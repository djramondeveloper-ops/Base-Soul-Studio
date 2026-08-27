-- =====================================================
--  rcore_police · modules/base/client/init/cl-init.lua
--  Engineered by Eazy Fxap
--  Original: 435 lines → Cleaned: 140 lines
-- =====================================================

-- ============================================================
--  GLOBAL CLIENT NAMESPACES
-- ============================================================

UI               = {}
Props            = {}
GarageService    = {}
TextService      = {}
GroupsService    = {}
Reports          = {}
BodyCams         = {}
Sounds           = {}
DeathPlayers     = {}
Utils            = {}
keyCache         = {}

-- Misc state flags
IsPropSessionActive   = false
CurrentZone           = nil
MyServerId            = GetPlayerServerId(PlayerId())
GlobalZoneId          = nil
currentSeat           = nil
escortHelpKeys        = false
blockAction           = false
isOpenMenu            = false
BodyCamState          = false
IsLoadedRadarSettings = false
IsUsingRadar          = false
IsBusy                = false

-- ============================================================
--  KEY TIMER CACHE (per-zone key cooldown tracking)
-- ============================================================

local keyTimers = {}

-- ============================================================
--  STARTUP CLEANUP (detach, un-cuff, clear tasks)
-- ============================================================

CreateThread(function()
    local ped = PlayerPedId()
    DetachEntity(ped, true, false)
    SetEnableHandcuffs(ped, false)
    RemoveAttachedEntities(ped)
    FreezeEntityPosition(ped, false)
    ClearTimecycleModifier()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then
        ClearPedTasksImmediately(ped, false)
    end
end)

-- ============================================================
--  REMOVE ATTACHED ENTITIES (detach + delete all CObjects)
-- ============================================================

function RemoveAttachedEntities(targetEntity)
    for _, obj in ipairs(GetGamePool("CObject")) do
        if DoesEntityExist(obj) and IsEntityAttachedToEntity(obj, targetEntity) then
            DetachEntity(obj, true, true)
            DeleteEntity(obj)
        end
    end
end

-- ============================================================
--  TRIGGER KEY ACTION (zone-keybind handler with cooldown)
-- ============================================================

function TriggerKeyAction()
    local zoneKey = keyCache[GlobalZoneId]
    if not zoneKey then return end

    local now = GetGameTimer()
    keyTimers[GlobalZoneId] = keyTimers[GlobalZoneId] or 0
    if now >= keyTimers[GlobalZoneId] then
        zoneKey()
        keyTimers[GlobalZoneId] = now + 1000
    end
end

-- Register the zone interact key
RegisterKey(
    TriggerKeyAction,
    "RCORE_POLICE_INTERACT",
    _U("KEY_MAPPING.INTERACT_ZONE"),
    Config.InteractZone or "E"
)

-- ============================================================
--  BOSS RANK SETUP HELP COMMAND
-- ============================================================

RegisterCommand("rcore_police_help_boss_setup", function()
    local job = Framework.job
    if not job or type(job) ~= "table" then return end
    local gradeName = job.gradeName or job.grade_name
    if not gradeName then
        dbg.info("⚠ No gradeName found in Framework.job")
        return
    end

    print("\n========================================================")
    print(" RCORE POLICE - BOSS RANK SETUP HELP")
    print("========================================================")
    print("- Path: config.lua")
    print("- Your current gradeName: " .. gradeName)
    print("\n- Want to make this grade a boss?")
    print("- See Config.RanksAsBossList and add your grade [" .. gradeName .. "] as shown bellow.")
    print("--------------------------------------------------------\n")
    print("Config.RanksAsBossList = {")
    for k in pairs(Config.RanksAsBossList) do
        print(("    ['%s'] = true,"):format(k))
    end
    print(("    ['%s'] = true,  <-- Add your new boss grade here"):format(gradeName))
    print("}\n")
end, false)

-- ============================================================
--  ZONE ACCESS DEBUG COMMAND
-- ============================================================

RegisterCommand("rcore_police_debug_access", function()
    local job = Framework.job
    if not job then
        print("[DEBUG] No job data available.")
        return
    end
    if type(job) ~= "table" then return end

    if not CurrentZone then
        print("[DEBUG] No CurrentZone available.")
        return
    end

    local jobName     = job.name
    local zoneType    = CurrentZone.getZoneType()
    local deptOwner   = CurrentZone.getDepartmentOwner()
    local dutyState   = CurrentZone.getZoneDutyState()
    local zoneLabel   = CurrentZone.getZoneLabel()
    local jobState    = CurrentZone.getJobState()

    -- Check if player's job matches the zone department owner
    local isJobAllowed = false
    if type(deptOwner) == "table" then
        for _, j in ipairs(deptOwner) do
            if j == jobName then isJobAllowed = true; break end
        end
    elseif type(deptOwner) == "string" then
        isJobAllowed = jobName == deptOwner
    end

    local hasAccess, accessStatus = Utils.HasZoneAccess(job, dutyState, zoneType, jobState)

    -- Format zone owner display
    local ownerDisplay
    if type(deptOwner) == "table" then
        ownerDisplay = table.concat(deptOwner, ", ")
    else
        ownerDisplay = deptOwner
    end

    print("====== Zone debug ======")
    print(("Player Job:       %s"):format(jobName or "N/A"))
    print(("Zone Label:       %s"):format(zoneLabel or "N/A"))
    print(("Zone Type:        %s"):format(zoneType or "N/A"))
    print(("Zone Duty State:  %s"):format(dutyState ~= nil and tostring(dutyState) or "N/A"))
    print(("Zone Job Owner:   %s"):format(ownerDisplay or "N/A"))
    print(("Job State:        %s"):format(jobState ~= nil and tostring(jobState) or "N/A"))
    print(("Is Job Allowed:   %s"):format(tostring(isJobAllowed)))
    print(("Has Zone Access:  %s (Status: %s)"):format(tostring(hasAccess), tostring(accessStatus)))
    print("================================")
end, false)
