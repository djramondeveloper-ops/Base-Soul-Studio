-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-tackle.lua
--  Engineered by Eazy Fxap
--  Original: 823 lines → Cleaned: 240 lines
-- =====================================================

TACKLE_ANIM_DICT = "missmic2ig_11"
TACKLE_ANIM_NAME = "mic_2_ig_11_intro_goon"
TACKLE_ANIM_DICT_GROUND_DICT = "random@homelandsecurity"
TACKLE_ANIM_DICT_GROUND_NAME = "idle_girl"

local isTackling = false
local isTackled = false
TACKLED_PLAYER_ID = nil

function TackleReset(serverId, keepTackling)
    local ped = UtilsService.GetPlayerPedFromServerId(serverId)
    local plyPed = PlayerPedId()
    local animDict = "random@homelandsecurity"
    local animName = "exit_cop_ground"
    local waitLoop = true
    
    UI.StopMinigame()
    if keepTackling then waitLoop = false end
    
    if waitLoop then
        repeat
            Wait(250)
            if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                waitLoop = false
                Wait(250)
            end
        until not waitLoop
        
        StopEntityAnim(plyPed, "random@homelandsecurity", "idle_girl", 3)
        UtilsService.LoadAnimationDict("get_up@cuffed")
        TaskPlayAnim(ped, "get_up@cuffed", "back_to_default", 8.0, 8.0, 3000, 1, 0.0, false, false, false)
    else
        isTackled = false
    end
end

function TackleCuffPlayer(serverId)
    local ped = UtilsService.GetPlayerPedFromServerId(serverId)
    UtilsService.LoadAnimationDict("get_up@cuffed")
    TaskPlayAnim(ped, "get_up@cuffed", "back_to_default", 8.0, 8.0, -1, 1, 0.0, false, false, false)
    UI.StopMinigame()
end

function TacklePlayer(serverId)
    if not serverId then return end
    
    isTackled = false
    UtilsService.LoadAnimationDict(TACKLE_ANIM_DICT)
    local targetPed = UtilsService.GetPlayerPedFromServerId(serverId)
    local plyPed = PlayerPedId()
    
    AttachEntityToEntity(plyPed, targetPed, 11816, 0.2, 0.4, 0.0, 0.0, GetEntityHeading(targetPed) + 180, 0.0, false, false, false, false, 2, false)
    
    local animDict = "melee@unarmed@streamed_variations"
    local animName = "victim_takedown_front_cross_r"
    local time = 1500
    local heading = GetEntityHeading(targetPed) - 180
    
    UtilsService.LoadAnimationDict(animDict)
    TaskPlayAnimAdvanced(plyPed, animDict, animName, GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.0, 0.0), 0.0, 0.0, heading, 8.0, 3.0, time + 500, 1, 0.0, 0, 0)
    
    Wait(time + 500)
    DetachEntity(plyPed, false, false)
    FreezeEntityPosition(plyPed, true)
    ClearPedTasksImmediately(plyPed)
    
    UtilsService.LoadAnimationDict("random@homelandsecurity")
    TaskPlayAnimAdvanced(plyPed, "random@homelandsecurity", "idle_girl", GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.0, 0.0), 0.0, 0.0, GetEntityHeading(targetPed), 8.0, 8.0, -1, 1, 0, 0, 0)
    
    local startMinigame = false
    if Config.Cuffing.BreakTackleMinigame then
        if math.random(1, 100) >= Config.Cuffing.BreakTackleChance then
            SetTimeout(0, function()
                SetTimeout(5000, function() UI.StopMinigame() end)
                if UI.StartMinigame() then
                    startMinigame = true
                    TackleReset(serverId, startMinigame)
                end
            end)
        end
    end
    
    isTackled = true
    repeat
        Wait(250)
        if not IsEntityPlayingAnim(plyPed, "random@homelandsecurity", "idle_girl", 3) then
            TaskPlayAnim(plyPed, "random@homelandsecurity", "idle_girl", 8.0, 8.0, -1, 1, 0.0, false, false, false)
        end
        if IsEntityPlayingAnim(targetPed, "random@homelandsecurity", "exit_cop_ground", 3) then
            if isTackled then
                TaskPlayAnim(plyPed, "random@homelandsecurity", "exit_girl", 8.0, 8.0, -1, 1, 0.0, false, false, false)
                isTackled = false
            end
        end
    until not isTackled
    
    if not startMinigame then Wait(6000) end
    FreezeEntityPosition(plyPed, false)
    DetachEntity(plyPed, false, false)
    ClearPedTasks(plyPed)
    
    if startMinigame then StartPunchAnim("back") end
end

function TryTackleNearbyPlayer()
    if not Config.Tackle.Enable then return dbg.debug("Tackle is disabled!") end
    if not Framework.job then return end
    
    if Config.Tackle.OnlyForDepartmentGroups and Framework.job then
        if not GetDepartmentConfig(Framework.job.name) then
            return dbg.debug("Tackle: Restricted only for department groups, your job: %s", string.lower(Framework.job.name))
        end
    end
    
    dbg.debug("Tackle: Checking closest player in distance.")
    local closestPlayer, _ = Utils.getClosestPlayers(Config.Tackle.Distance, false)
    
    if closestPlayer and closestPlayer ~= -1 then
        if isTackling then return dbg.debug("Tackle: State initiator is busy (active)") end
        if IsPropSessionActive then return dbg.debug("Tackle: Prop session active!") end
        if isTackled then return dbg.debug("Tackle: Is busy!") end
        
        local plyPed = PlayerPedId()
        local targetPed = UtilsService.GetPlayerPedFromServerId(closestPlayer)
        
        Utils.TackleRestrictions({playerPed = plyPed, targetPed = targetPed, closestPlayer = closestPlayer}, function(allowed, reason)
            if not allowed then return dbg.debug(reason or "Tackle not allowed") end
            
            if Config.Tackle.ExperimentalForceFrontBack then
                local isFrontOrBack = UtilsService.IsPlayerInFrontOrBehind(closestPlayer, true)
                if not ({front = true, back = true})[isFrontOrBack] then
                    return dbg.debug("Tackle: You cant do tackle from sides only front/back! Incoming calculation: %s", isFrontOrBack)
                end
            end
            
            isTackled = true
            isTackling = true
            TACKLED_PLAYER_ID = closestPlayer
            
            TriggerServerEvent("rcore_police:server:requestTacklePlayer", closestPlayer)
            UtilsService.LoadAnimationDict(TACKLE_ANIM_DICT)
            TaskPlayAnim(plyPed, TACKLE_ANIM_DICT, "mic_2_ig_11_intro_goon", 8.0, -8.0, 3000, 0, 0.005, false, false, false)
            Wait(3000)
            
            MakePedIgnoreHitFromOtherPlayer(plyPed, true)
            MakePedIgnoreHitFromOtherPlayer(targetPed, true)
            
            local offsetCoords = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, -0.2, 0.0)
            UtilsService.LoadAnimationDict("random@homelandsecurity")
            SetEntityHeading(plyPed, GetEntityHeading(plyPed) - 35.0)
            SetEntityCoords(plyPed, offsetCoords.x, offsetCoords.y, offsetCoords.z - 1, false, false, false, false)
            
            UI.HelpKeys({
                keys = {
                    { key = Config.Tackle.KeyReleaseTackledPlayer, label = _U("RELEASE_PLAYER_TACKLE") },
                    { key = Config.CuffAndEscortKey, label = _U("CUFF_PLAYER_TACKLE") }
                }
            }, true)
            
            local brokeFree = false
            local timer = GetGameTimer()
            TaskPlayAnim(plyPed, "random@homelandsecurity", "idle_cop_ground", 8.0, 8.0, -1, 1, 0.0, false, false, false)
            
            repeat
                local diff = GetGameTimer() - timer
                if not IsEntityPlayingAnim(targetPed, "random@homelandsecurity", "idle_girl", 3) and not brokeFree then
                    isTackling = false
                    brokeFree = true
                    ClearPedTasks(plyPed)
                    DetachEntity(plyPed, false, false)
                    isTackled = false
                    MakePedIgnoreHitFromOtherPlayer(plyPed, false)
                    MakePedIgnoreHitFromOtherPlayer(targetPed, false)
                    break
                end
                
                if diff >= 3000 then
                    timer = GetGameTimer()
                    local animTime = GetEntityAnimCurrentTime(plyPed, "random@homelandsecurity", "idle_cop_ground")
                    if not IsEntityPlayingAnim(plyPed, "random@homelandsecurity", "idle_cop_ground", 3) then
                        TaskPlayAnim(plyPed, "random@homelandsecurity", "idle_cop_ground", 8.0, 8.0, -1, 1, 0.0, false, false, false)
                    end
                    if animTime >= 0.4 then
                        SetEntityAnimCurrentTime(plyPed, "random@homelandsecurity", "idle_cop_ground", 0.0)
                    end
                end
                Wait(100)
            until not isTackling
            
            UI.ResetHelpKeys()
            
            if brokeFree then
                Framework.sendNotification(_U("PLAYER_ESCA  PED_TACKLE"), "success")
                SetEntityHeading(plyPed, GetEntityHeading(targetPed))
                PunchSync(nil, "back")
                brokeFree = false
                isTackled = false
                MakePedIgnoreHitFromOtherPlayer(plyPed, false)
                MakePedIgnoreHitFromOtherPlayer(targetPed, false)
                return
            end
            
            TaskPlayAnim(plyPed, "random@homelandsecurity", "exit_cop_ground", 8.0, 8.0, 6000, 1, 0.0, false, false, false)
            Wait(6000)
            StopEntityAnim(plyPed, "random@homelandsecurity", "exit_cop_ground", 3)
            ClearPedTasks(plyPed)
            DetachEntity(plyPed, false, false)
            MakePedIgnoreHitFromOtherPlayer(plyPed, false)
            MakePedIgnoreHitFromOtherPlayer(targetPed, false)
            isTackled = false
        end)
    end
end

function StopTacklingPlayer()
    if isTackling and TACKLED_PLAYER_ID then
        TriggerServerEvent("rcore_police:server:requestTackleEnableMovement", TACKLED_PLAYER_ID)
        TACKLED_PLAYER_ID = nil
        isTackling = false
    end
end

function StartTackleCuff()
    if Config.DisableCuffAndEscortKey then return end
    if isTackling and TACKLED_PLAYER_ID then
        TriggerServerEvent("rcore_police:server:requestTackleCuff", TACKLED_PLAYER_ID)
        isTackling = false
        TACKLED_PLAYER_ID = nil
    end
end

RegisterKey(TryTackleNearbyPlayer, "RCORE_POLICE_TACKLE", _U("KEY_MAPPING.TACKLE_PLAYER"), Config.Tackle.Key or "H", nil, { state = true, cooldown = Config.Tackle.CooldownKey })
RegisterKey(StopTacklingPlayer, "RCORE_POLICE_RELEASE_TACKLED_PLAYER", _U("KEY_MAPPING.TACKLE_STOP"), Config.Tackle.KeyReleaseTackledPlayer, nil, { state = true, cooldown = Config.Tackle.KeyReleaseTackledPlayerCooldown })
RegisterKey(StartTackleCuff, "RCORE_POLICE_TACKLE_CUFF_PLAYER", _U("KEY_MAPPING.TACKLE_CUFF_AND_ESCORT_PLAYER"), Config.CuffAndEscortKey, nil, { state = true, cooldown = 1500.0 })
