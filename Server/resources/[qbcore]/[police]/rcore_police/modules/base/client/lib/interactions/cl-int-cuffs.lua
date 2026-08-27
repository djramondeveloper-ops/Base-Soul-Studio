-- =====================================================
--  rcore_police · modules/base/client/lib/interactions/cl-int-cuffs.lua
--  Engineered by Eazy Fxap
--  Original: 820 lines → Cleaned: 245 lines
-- =====================================================

local cuffOffset = { -0.022, 0.058, -0.004, 0.0, 0.0, -90.0 }
local PreCuffHooks = { officer = {}, citizen = {} }
local IsCuffMinigameActive = false

function Interactions.RemoveCuffs(instant, typeStr)
    if not instant then Wait(2000) end
    dbg.debug("Removing cuffs from players valid")
    
    local ped = PlayerPedId()
    
    if DoesEntityExist(Interactions.Entity) then
        DetachEntity(Interactions.Entity, true, true)
        DeleteEntity(Interactions.Entity)
    end
    if DoesEntityExist(Interactions.FrontEntity) then
        DetachEntity(Interactions.FrontEntity, true, true)
        DeleteEntity(Interactions.FrontEntity)
    end
    
    ClearPedTasksImmediately(ped)
    SetEnableHandcuffs(ped, false)
    SetPedCanPlayGestureAnims(ped, true)
    SetPedPathCanUseLadders(ped, true)
    SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
    
    Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = false
    Interactions.Cuff.Session = nil
    Interactions.Entity = nil
    Interactions.FrontEntity = nil
    
    dbg.debug("Removing cuffs finished!")
    UI.StopMinigame()
    
    if typeStr ~= "ziptie" then
        Sounds.PlayUncuff()
    end
end

function StartPunchAnim(dir)
    local ped = PlayerPedId()
    if IsEntityAttached(ped) then DetachEntity(ped) end
    ClearPedTasksImmediately(ped)
    
    local dict = "melee@unarmed@streamed_core"
    local name = "victim_failed_takedown_rear_r_facehit"
    local time = 3000
    
    if dir == "front" then
        name = "counter_attack_r"
        time = 2000
    end
    
    UtilsService.LoadAnimationDict(dict)
    TaskPlayAnim(ped, dict, name, 8.0, 8.0, time, 1, 0.0, false, false, false)
    Wait(time)
    ClearPedTasksImmediately(ped)
end

function PunchSync(punchData, extraData)
    dbg.debug("Sync punch anim from citizen!")
    local dict = "melee@unarmed@streamed_variations"
    local name = "victim_takedown_front_cross_r"
    local time = 2000
    local ped = PlayerPedId()
    
    if IsActiveAnimGlobally and next(IsActiveAnimGlobally) then
        if IsEntityPlayingAnim(ped, IsActiveAnimGlobally.dict, IsActiveAnimGlobally.name, 3) then
            StopEntityAnim(ped, IsActiveAnimGlobally.dict, IsActiveAnimGlobally.name, 1.0)
        end
        IsActiveAnimGlobally = nil
        dbg.debug("Stopped active hold anim on player, clearing it.")
    end
    
    UtilsService.LoadAnimationDict(dict)
    ClearPedTasksImmediately(ped)
    if IsEntityAttached(ped) then DetachEntity(ped, false, false) end
    
    local hp = GetEntityHealth(ped)
    if extraData == "front" then
        SetPedToRagdoll(ped, 2000, 2000, 0, false, false, false)
        Wait(2000)
        SetEntityHealth(ped, hp)
        return
    end
    
    TaskPlayAnim(ped, dict, name, -8.0, 8.0, time, 1, 0.0, false, false, false)
    Wait(time)
    ClearPedTasksImmediately(ped)
    SetPedToRagdoll(ped, 2000, 2000, 3, false, false, false)
    Wait(2000)
    SetEntityHealth(ped, hp)
    SetEnableHandcuffs(ped, false)
    MakePedIgnoreHitFromOtherPlayer(ped, false)
end

function Interactions.SetCuffingMotion(ped, attackerServerId, dir)
    dbg.debug("SetCitizenCuffs: Cuff motion is in progress.")
    
    if Config.Cuffing.BreakCuffsMinigame then
        local roll = math.random(1, 100)
        if roll < Config.Cuffing.BreakCuffsChance or roll < Config.Cuffing.BreakTackleChance then
            SetTimeout(0, function()
                if UI.StartMinigame() then
                    IsCuffMinigameActive = true
                    FreezeEntityPosition(ped, false)
                    Interactions.RemoveCuffs(true)
                    Interactions.StopCitizenEscort(ped)
                    Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = false
                    
                    SetTimeout(100, function()
                        TriggerServerEvent("rcore_police:server:requestCuffEscape", attackerServerId, dir)
                        StartPunchAnim(dir)
                    end)
                end
            end)
        end
    end
    
    if dir == "front" then
        SetTimeout(Config.Cuffing.BreakCuffsTimeFront * 1000, function() UI.StopMinigame() end)
        return
    end
    
    local waitTime = Config.Cuffing.BreakCuffsTimeBack * 1000
    local startT = GetGameTimer()
    FreezeEntityPosition(ped, true)
    
    while GetGameTimer() - startT < waitTime and not IsCuffMinigameActive do
        Wait(500)
    end
    
    FreezeEntityPosition(ped, false)
    UI.StopMinigame()
    IsCuffMinigameActive = false
    dbg.debug("SetCitizenCuffs: Cuff motion is finished.")
end

function Interactions.SetCitizenCuffs(initiator, typeStr)
    dbg.debug("SetCitizenCuffs: Starting cuffing process.")
    Interactions.RunCuffPre("citizen")
    
    local ped = PlayerPedId()
    local dir = UtilsService.IsPlayerInFrontOrBehind(initiator)
    if typeStr == "ziptie" then dir = "back" end
    
    local dict = Interactions.Cuff.TARGET_PLAYER_ANIM_DICT
    local name = Interactions.Cuff.TARGET_PLAYER_ANIM_DICT_NAME
    local boneIdx = 18905
    
    if dir == "back" then
        dict = "mp_arresting"
        name = "idle"
        boneIdx = 60309
    end
    
    UtilsService.LoadAnimationDict(dict)
    dbg.debug("SetCitizenCuffs: Requesting sync cuffing motion. %s", dir)
    
    local attachData = EntityAttach.CUFFS[dir and string.upper(dir) or "FRONT"]
    local pos = attachData and attachData.offset or vec3(0,0,0)
    local rot = attachData and attachData.rot or vec3(0,0,0)
    
    if typeStr == "ziptie" then
        Interactions.Cuff.TARGET_PLAYER_MODEL = "hei_prop_zip_tie_positioned"
        boneIdx = 60309
        pos = vec3(cuffOffset[1], cuffOffset[2], cuffOffset[3])
        rot = vec3(cuffOffset[4], cuffOffset[5], cuffOffset[6])
    end
    
    local cuffProp = UtilsService.SpawnObject(Interactions.Cuff.TARGET_PLAYER_MODEL, GetPedBoneCoords(ped, boneIdx, 0.0, 0.0, 0.0), true, true)
    dbg.debug("SetCitizenCuffs: Creating cuff entity.")
    
    SetEntityCollision(cuffProp, false, false)
    AttachEntityToEntity(cuffProp, ped, GetPedBoneIndex(ped, boneIdx), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, false, false, true, 0, true)
    dbg.debug("SetCitizenCuffs: Attaching cuffs to player.")
    
    SetPedCanPlayGestureAnims(ped, false)
    SetPedPathCanUseLadders(ped, false)
    SetEnableHandcuffs(ped, true)
    SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
    
    dbg.debug("SetCitizenCuffs: Loading cuff cycle.")
    Interactions.Entity = cuffProp
    Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = true
    Interactions.Cuff.Session = {
        mePed = ped,
        initiator = initiator,
        animDict = dict,
        animName = name,
        animType = dir
    }
    
    Interactions.SetCuffingMotion(ped, initiator, dir)
    
    if typeStr ~= "ziptie" then
        Sounds.PlayHandcuff()
    end
end

function GetRemainingAnimTime(dict, name, curTime)
    local duration = GetAnimDuration(dict, name)
    if duration <= 0.0 then return 0 end
    return math.floor((duration * (1.0 - curTime)) * 1000)
end

function PlayPartialAnim(dict, name, startTime, cb)
    local ped = PlayerPedId()
    startTime = startTime or 0.0
    UtilsService.LoadAnimationDict(dict)
    TaskPlayAnim(ped, dict, name, 8.0, 8.0, -1, 1, 0.0, false, false, false)
    Wait(50)
    SetEntityAnimCurrentTime(ped, dict, name, startTime)
    
    local remain = GetRemainingAnimTime(dict, name, startTime)
    SetTimeout(remain, function()
        ClearPedTasksImmediately(ped)
        if cb then cb(true) end
    end)
end

function Interactions.OnCuffPre(role, cb)
    table.insert(PreCuffHooks[role] or {}, cb)
end

function Interactions.RunCuffPre(role)
    local hooks = PreCuffHooks[role]
    if not hooks or #hooks == 0 then return end
    
    local promises = {}
    for _, fn in pairs(hooks) do
        local p = promise.new()
        CreateThread(function()
            local ok, err = pcall(function()
                fn(function() p:resolve(true) end)
            end)
            if not ok then
                print("^1CuffPre Hook Error:^0", err)
                p:resolve(true)
            end
        end)
        table.insert(promises, p)
    end
    return Citizen.Await(PromiseAll(promises))
end

function PromiseAll(promises)
    local p = promise.new()
    local count = 0
    local total = #promises
    if total == 0 then return {} end
    
    local results = {}
    for i, prom in ipairs(promises) do
        CreateThread(function()
            results[i] = Citizen.Await(prom)
            count = count + 1
            if count == total then p:resolve(results) end
        end)
    end
    return p
end

AddEventHandler("rcore_police:registerCuffPre", function(role, cb)
    Interactions.OnCuffPre(role, cb)
end)
