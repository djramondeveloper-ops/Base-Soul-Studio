-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-map_creator.lua
--  Engineered by Eazy Fxap
--  Original: 1178 lines → Cleaned: 350 lines
-- =====================================================

local MapCreatorValidResources = {
    rcore_prison_assets = true,
    rcore_police_assets = true,
    rcore_banners_assets = true,
    rcore_police_assets_bodycam = true,
    ["cfx-gabz-mapdata"] = true,
    ["qb-interior"] = true,
    luky3d_lifeinvader = true
}

local CurrentPointCoords = nil
local CreatorPoints = {}
local DefinePointsList = {
    POINTS = {},
    GARAGE_SPAWN_POINTS = {}
}
local IntervalTime = 250
local CurrentTaskIndex = 0
local TotalTaskCount = 0

MapOwner = nil
MapResource = nil

Interval = { Pool = {} }

function Interval.GetActiveThreads()
    local count = 0
    if Interval.Pool and next(Interval.Pool) then
        for k, v in pairs(Interval.Pool) do
            if v.state then count = count + 1 end
        end
    end
    return count
end

function Interval.setInterval(name, time, callback)
    dbg.debug("Interval: Registering interval named: %s", name)
    Interval.Pool[name] = {
        time = time,
        nextTime = time,
        state = false,
        callback = callback
    }
end

function Interval.updateIntervalState(name, state)
    if Interval.Pool[name] then
        Interval.Pool[name].state = state
        dbg.debug("Interval: Updating interval %s to state %s", name, state)
    end
end

function Interval.getInterval(name)
    return Interval.Pool[name]
end

function RotToDir(rot)
    local rx = math.rad(rot.x)
    local rz = math.rad(rot.z)
    
    local dx = -math.sin(rz) * math.cos(rx)
    local dy = math.cos(rz) * math.cos(rx)
    local dz = math.sin(rx)
    
    return vector3(dx, dy, dz)
end

function HandlePresetCreator()
    dbg.debug("Preset creator: Starting session.")
    TotalTaskCount = 0
    local loc, res = GetMapPresetAtLocation()
    StartInformationGather(loc, res)
end

function GetAllServerMaps()
    local maps = {}
    local numRes = GetNumResources()
    
    for i = 0, numRes - 1 do
        local resName = GetResourceByFindIndex(i)
        local meta = GetResourceMetadata(resName, "this_is_a_map", 0)
        
        if meta and isResourcePresentProvideless(resName) then
            if MapCreatorValidResources[resName:lower()] then
                table.insert(maps, { value = resName })
            end
        end
    end
    
    return maps
end

function TransformKeyToZone(data, key, coords)
    local icons = {
        [ZONE_TYPE.GARAGE_AIR] = "fa-solid fa-helicopter",
        [ZONE_TYPE.PERSONAL_LOCKER] = "fa-solid fa-lock",
        [ZONE_TYPE.EVIDENCE_STASH] = "fa-solid fa-lock",
        [ZONE_TYPE.JOB_STASH] = "fa-solid fa-lock",
        [ZONE_TYPE.CLOTHING_ROOM] = "fa-solid fa-shirt",
        [ZONE_TYPE.WEAPON_SHOP] = "fa-solid fa-lock",
        [ZONE_TYPE.GARAGE_VEHICLE] = "fas fa-car",
        [ZONE_TYPE.BOSS_MENU] = "fa-solid fa-business-time",
        [ZONE_TYPE.WRITE_REPORT] = "fa-solid fa-clock",
        [ZONE_TYPE.REPORTS] = "fa-solid fa-clock",
        [ZONE_TYPE.DUTY] = "fa-solid fa-clock"
    }
    
    local labels = {
        [ZONE_TYPE.CLOTHING_ROOM] = "OUTFIT_ROOM",
        [ZONE_TYPE.GARAGE_AIR] = "GARAGE_VEHICLE"
    }
    
    local labelKey = labels[key] or key
    
    local zone = {
        label = "ZONES_LABELS." .. labelKey,
        coords = coords or vec3(0, 0, 0),
        type = ZONE_TYPE[key],
        icon = data.icon or icons[key] or "",
        require_duty = data.require_duty or false,
        no_job_zone = data.no_job_zone or false
    }
    
    return zone
end

function FormatedJobGroupsSelect()
    local groups = {}
    for k, v in pairs(Config.JobGroups) do
        table.insert(groups, { value = k })
    end
    return groups
end

function StartInformationGather(loc, res)
    if loc then
        dbg.debug("You are at preset named %s with resource %s", loc, res)
    end
    
    local maps = GetAllServerMaps()
    local groups = FormatedJobGroupsSelect()
    
    local dialog = UI.Input(_U("PRESET_CREATOR.DIALOG_PRESET_TOOL_TITLE"), {
        {
            label = _U("PRESET_CREATOR.DIALOG_RESOURCE_TITLE"),
            type = "select",
            options = maps,
            required = true
        },
        {
            label = _U("PRESET_CREATOR.DIALOG_ZONE_OWNER"),
            type = "select",
            options = groups,
            required = true
        }
    })
    
    MapResource = dialog["0"]
    MapOwner = dialog["1"]
    
    local function HandlePoints(key, data)
        local zones = {}
        local validTypes = {
            VEHICLE_SPAWNPOINT = true,
            GARAGE_VEHICLE = true,
            GARAGE_AIR = true
        }
        
        for k, v in pairs(data) do
            local zone = TransformKeyToZone(v, k, v.coords)
            
            if Maps.BROFX_VSPD and Maps.BROFX_VSPD.Zones then
                for _, zData in pairs(Maps.BROFX_VSPD.Zones) do
                    local zType = type(zData.type) == "string" and zData.type:match("ZONE_TYPE%.(.+)") or zData.type
                    if zType == k then
                        for kz, vz in pairs(zData) do
                            if zone[kz] == nil then zone[kz] = vz end
                        end
                        break
                    end
                end
            end
            
            zone.require_duty = v.require_duty or false
            zone.no_job_zone = v.no_job_zone or false
            table.insert(zones, zone)
        end
        
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local locHash = GetStreetHashLocationFromCoords(pos)
        
        local preset = {
            Jobs = MapOwner,
            Resource = MapResource,
            MapLocation = locHash,
            Pos = pos,
            Zones = zones,
            Blip = {
                name = (MapOwner and MapOwner:upper()) or "UNKNOWN",
                enable = true,
                sprite = 60,
                display = 4,
                scale = 1.0,
                color = 29
            }
        }
        
        UI.HelpKeys(nil, false)
        CreatorPoints = {}
        TriggerServerEvent("rcore_police:server:requestPresetCreation", MapResource, preset)
    end
    
    DefinePoints(HandlePoints)
end

function GetMapPresetAtLocation()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    if ValidMapData and next(ValidMapData) then
        local minDist = 50.0
        local minData = nil
        local resName = nil
        
        for k, v in pairs(ValidMapData) do
            if type(v) == "table" and v.coords then
                local dist = #(v.coords - coords)
                if dist < minDist then
                    minDist = dist
                    minData = v
                    resName = k
                end
            end
        end
        
        return minData, resName
    end
    
    return nil, nil
end

function DefinePoints(cb)
    for k, v in pairs(ZONE_TYPE) do
        InsertPointByLocationType("POINTS", { name = k, key = k, offset = nil })
    end
    
    Interval.updateIntervalState("POINTS", true)
    TotalTaskCount = #DefinePointsList.POINTS
    StartNextTask(cb)
end

function InsertPointByLocationType(typeStr, pointData)
    local upperType = typeStr:upper()
    if DefinePointsList[upperType] then
        table.insert(DefinePointsList[upperType], pointData)
    end
end

function StartNextTask(cb)
    local countPoints = #DefinePointsList.POINTS
    local countGarage = #DefinePointsList.GARAGE_SPAWN_POINTS
    
    if countPoints == 0 and countGarage == 0 then
        if cb then
            ClearAllHelpMessages()
            UnregisterAllDynamicActions()
            Interval.updateIntervalState("POINTS", false)
            cb("points", CreatorPoints)
        end
        return
    end
    
    dbg.debug("Map creator - points: Outside count: %s | Inside count: %s", countPoints, countGarage)
    
    local function HandleNext(listName, cbName)
        local item = table.remove(DefinePointsList[listName], 1)
        dbg.debug("Map creator - points: Handling %s interactions.", cbName)
        StartTask(item.name, item.key, nil, nil, listName, function() StartNextTask(cb) end)
    end
    
    if countGarage <= 0 and countPoints > 0 then
        HandleNext("POINTS", "points")
    elseif countGarage > 0 then
        HandleNext("GARAGE_SPAWN_POINTS", "garage_spawn_points")
    end
end

function GetStreetHashLocationFromCoords(coords)
    if not coords then return nil end
    local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local n1 = GetStreetNameFromHashKey(s1)
    local n2 = GetStreetNameFromHashKey(s2)
    
    if (not n1 or n1 == "") and (not n2 or n2 == "") then return nil end
    
    local str = string.format("%s_%s", (n1 and n1 ~= "") and n1 or "none", (n2 and n2 ~= "") and n2 or "none")
    return str:gsub("%s+", ""):upper()
end

function StartTask(taskName, key, a3, listName, list, cbNext)
    CurrentTask = taskName:upper()
    ClearAllHelpMessages()
    
    if DefinePointsList[list] then
        for i, v in ipairs(DefinePointsList[list]) do
            if v.key == key then
                CurrentTaskIndex = i
                break
            end
        end
    end
    
    CurrentTaskIndex = CurrentTaskIndex + 1
    
    UI.HelpKeys({
        keys = {
            { key = "", label = _U("PRESET_CREATOR.HELP_KEY_TITLE") },
            { key = "", label = string.format("%s: (%s / %s)", _U("PRESET_CREATOR.HELP_KEY_REMAINING_COUNT"), CurrentTaskIndex, TotalTaskCount) },
            { key = "", label = string.format("%s: %s", _U("PRESET_CREATOR.HELP_KEY_TASK"), CurrentTask) },
            { key = "", label = string.format("%s: %s", _U("PRESET_CREATOR.HELP_KEY_ZONE_OWNER"), MapOwner) },
            { key = "", label = string.format("%s: %s", _U("PRESET_CREATOR.HELP_KEY_RESOURCE"), MapResource) },
            { key = "Enter", label = _U("PRESET_CREATOR.HELP_KEY_SAVE_POINT") },
            { key = "BACKSPACE", label = _U("PRESET_CREATOR.HELP_KEY_EXIT") }
        }
    }, true)
    
    CurrentPointCoords = nil
    
    RegisterDynamicAction("Backspace", function()
        UI.HelpKeys(nil, false)
        ClearAllHelpMessages()
        UnregisterAllDynamicActions()
        Interval.updateIntervalState("POINTS", false)
    end)
    
    RegisterDynamicAction("Select", function()
        if not CurrentPointCoords then return end
        
        if not Config.PresetCreator.DisableDistanceCheck then
            for k, v in pairs(CreatorPoints) do
                if #(v.coords - CurrentPointCoords) <= Config.PresetCreator.PointCheckDist then
                    return Framework.sendNotification(_U("PRESET_CREATOR.CLOSE_POINT"), "error")
                end
            end
        end
        
        if not Config.PresetCreator.SkipPointConfirmation then
            if not UI.Input(_U("PRESET_CREATOR.DIALOG_CONFIRM_TITLE"), {
                { label = _U("PRESET_CREATOR.DIALOG_CONFIRM_DESC"), type = "checkbox", required = true }
            }) then return end
        end
        
        local coords = GetEntityCoords(PlayerPedId())
        CreatorPoints[key] = { coords = vec3(CurrentPointCoords.x, CurrentPointCoords.y, coords.z) }
        cbNext()
    end)
end

Interval.setInterval("POINTS", 0, function()
    local pt, hit = GetRaycastPoint(1)
    local pedCoords = GetEntityCoords(PlayerPedId())
    
    if CreatorPoints and next(CreatorPoints) then
        for k, v in pairs(CreatorPoints) do
            DrawMarker(1, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 0, 0, 50, false, false, 2, nil, nil, false)
        end
    end
    
    if pt then
        CurrentPointCoords = pt
        DrawMarker(1, pt.x, pt.y, pedCoords.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 0, 0, 50, false, false, 2, nil, nil, false)
    end
end)

function RenderHelpText(s1, s2, s3, a4)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(s1)
    AddTextComponentSubstringPlayerName(s2 or "")
    AddTextComponentSubstringPlayerName(s3 or "")
    EndTextCommandDisplayHelp(0, true, false, a4 or -1)
end

function GetRaycastPoint(distMultiplier)
    local camCoords = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local dir = RotToDir(rot)
    local target = camCoords + (dir * 50.0)
    
    local ray = StartShapeTestRay(camCoords, target, distMultiplier or 1, PlayerPedId(), 0)
    local _, hit, endCoords, _, _ = GetShapeTestResult(ray)
    
    if hit == 1 then return endCoords, hit end
    return nil
end

local DynamicActions = {}

function RegisterDynamicAction(key, cb)
    if not DynamicActions[key] then
        DynamicActions[key] = { callback = cb }
    else
        DynamicActions[key].callback = cb
    end
    dbg.debug("Registering keys for %s", key)
end

function UnregisterAllDynamicActions()
    dbg.debug("Unregistering all dynamic actions!")
    DynamicActions = {}
end

function TriggerDynamicAction(key)
    if DynamicActions[key] and DynamicActions[key].callback then
        DynamicActions[key].callback()
    else
        dbg.debug("No action registered for %s", key)
    end
end

function PressKeySelect() TriggerDynamicAction("Select") end
function PressKeyExit() TriggerDynamicAction("Backspace") end

RegisterKey(PressKeySelect, "RETURN", _U("DYNAMIC_ACTION.SELECT_KEY"), "RETURN")
RegisterKey(PressKeyExit, "BACK", _U("DYNAMIC_ACTION.EXIT_KEY"), "BACK")

CreateThread(function()
    while true do
        Wait(IntervalTime)
        local time = GetGameTimer()
        
        for k, v in pairs(Interval.Pool) do
            if v.state then
                if time > v.nextTime then
                    IntervalTime = 0
                    v.nextTime = time + v.time
                    v.callback()
                end
            end
        end
        
        if Interval.GetActiveThreads() <= 0 then
            IntervalTime = 250
        end
    end
end)
