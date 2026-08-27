-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-escort.lua
--  Engineered by Eazy Fxap
--  Original: 796 lines → Cleaned: 180 lines
-- =====================================================

escortEscape = false
local escortHelpKeys = false
local blockAction = false

NetworkService.RegisterNetEvent("EscortState", function(success, state)
    if success then
        Interactions.Escort.TARGET_PLAYER_ESCORT_INITIATOR_STATE = state
    end
end)

CreateThread(function()
    UtilsService.LoadAnimationDict("rcmnigel1d")
    local waitTime = 250
    
    while true do
        local ped = PlayerPedId()
        Wait(waitTime or 500)
        
        if not InteractionService.isEscorted() then
            if escortHelpKeys then
                escortHelpKeys = false
                UI.ResetHelpKeys()
            end
        end
        
        if Config.DebugStates then
            dbg.critical("isEscorted: %s\nnot IsPedCuffed: %s\nnot blockAction: %s", InteractionService.isEscorted(), not IsPedCuffed(ped), not blockAction)
        end
        
        if InteractionService.isEscorted() then
            if not UtilsService.IsPedDeath(ped) then
                if not IsPedCuffed(ped) then
                    if Interactions.Escort.TARGET_PLAYER_ESCORT_INITIATOR_STATE then
                        if not escortEscape then
                            if not blockAction then
                                waitTime = 0
                                if not escortHelpKeys then
                                    escortHelpKeys = true
                                    local keys = {
                                        { key = Config.Escort.EnableStopEscortKey, label = _U("STOP_ESCORT_LABEL") }
                                    }
                                    if Config.Escort.EnableCuffCitizenWhenNotCuffedDuringEscort then
                                        table.insert(keys, { key = Config.Escort.CuffCitizenKey or "H", label = _U("CUFF_LABEL") })
                                    end
                                    UI.HelpKeys({ keys = keys }, true)
                                end
                                
                                if IsPedRunning(ped) or IsPedSprinting(ped) then
                                    SetTimeout(100, function()
                                        if DoesEntityExist(ped) then
                                            ForcePedMotionState(ped, -668482597, 0, 0, 0)
                                        end
                                    end)
                                end
                                
                                -- Disable actions while escorted and not cuffed
                                local controls = {24, 257, 25, 45, 22, 44, 37, 23, 73, 59, 71, 72, 75}
                                for _, control in ipairs(controls) do
                                    DisableControlAction(0, control, true)
                                end
                                DisableControlAction(2, 199, true)
                                DisableControlAction(2, 36, true)
                                DisableControlAction(27, 75, true)
                            end
                        end
                    end
                end
            end
        else
            waitTime = 250
        end
    end
end)

CreateThread(function()
    local waitTime = 250
    while true do
        Wait(waitTime or 500)
        if Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE then
            local session = Interactions.Escort.Session
            if session and session.targetPed and session.initiatorPed then
                local isAttached = IsEntityAttachedToEntity(session.targetPed, session.initiatorPed)
                local isInitiatorMoving = not IsPedStill(session.initiatorPed)
                local isTargetPlayingAnim = IsEntityPlayingAnim(session.targetPed, session.animDict, session.animName, 3)
                
                if IsPedSittingInAnyVehicle(session.targetPed) then
                    Interactions.StopCitizenEscort(session.targetPed)
                end
                
                if not isAttached then
                    UtilsService.AttachFromPedToTarget(session.initiatorPed, session.targetPed)
                end
                
                if IsEntityPlayingAnim(session.targetPed, HANDS_UP.DICT, HANDS_UP.NAME, 3) or GetHandsUPState() then
                    StopEntityAnim(session.targetPed, HANDS_UP.DICT, HANDS_UP.NAME, 1.0)
                end
                
                if IsEntityPlayingAnim(session.targetPed, KNEE.DICT, KNEE.NAME, 3) or GetKneeState() then
                    StopEntityAnim(session.targetPed, KNEE.DICT, KNEE.NAME, 1.0)
                end
                
                if not IsPedCuffed(session.targetPed) then
                    if Config.Escort.BreakWhenNotCuffsOn then
                        escortEscape = true
                    end
                end
                
                if session.targetDead or DeadUtils.IsTargetPlayerDead(session.targetServerId) then
                    if not IsEntityPlayingAnim(session.targetPed, "nm", "firemans_carry", 3) then
                        AttachEntityToEntity(session.targetPed, session.initiatorPed, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                        TaskPlayAnim(session.targetPed, "nm", "firemans_carry", 8.0, -8.0, -1, 33, 0, false, false, false)
                    end
                else
                    if not IsPedCuffed(session.targetPed) then
                        if not IsEntityPlayingAnim(session.targetPed, "mp_arresting", "idle", 3) then
                            TaskPlayAnim(session.targetPed, "mp_arresting", "idle", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        end
                    end
                    
                    if isInitiatorMoving and not isTargetPlayingAnim then
                        TaskPlayAnim(session.targetPed, session.animDict, session.animName, 3.0, 3.0, -1, 1, 0, 0, 0, 0)
                    elseif not isInitiatorMoving and isTargetPlayingAnim then
                        if IsPedCuffed(session.targetPed) and session.animType == "back" then
                            TaskPlayAnim(session.targetPed, "mp_arresting", "idle", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
                        else
                            TaskPlayAnim(session.targetPed, session.animDict, "idle", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
                        end
                    end
                end
                
                waitTime = 0
            else
                waitTime = 250
            end
        else
            waitTime = 250
        end
    end
end)

function GetMinigameSettings(difficulty)
    local settings = {
        low = { speed = 2, maxFails = 3, maxRevs = 3, neededPicks = 1 },
        easy = { speed = 3, maxFails = 2, maxRevs = 2, neededPicks = 1 },
        medium = { speed = 4, maxFails = 1, maxRevs = 1, neededPicks = 1 },
        high = { speed = 5, maxFails = 0, maxRevs = 1, neededPicks = 1 }
    }
    return settings[difficulty]
end

if Config.Escort.BreakWhenNotCuffsOn then
    function TryEscapeWhenInEscort()
        local ped = PlayerPedId()
        if escortEscape and not IsPedCuffed(ped) and InteractionService.isEscorted() then
            escortEscape = false
            UI.ResetHelpKeys()
            Wait(300)
            
            local difficulties = {"low", "easy", "medium", "high"}
            local success = false
            
            for _, diff in ipairs(difficulties) do
                local settings = GetMinigameSettings(diff)
                success = UI.StartMinigame({
                    speed = settings.speed,
                    maxFails = settings.maxFails,
                    maxRevs = settings.maxRevs,
                    neededPicks = settings.neededPicks
                })
                Wait(100)
                if not success then break end
            end
            
            if success then
                local initiatorId = Interactions.Escort.Session.initiatorPlayerId
                local isFront = UtilsService.IsPlayerInFrontOrBehind(initiatorId)
                Interactions.RemoveCuffs(true)
                Interactions.StopCitizenEscort(ped)
                blockAction = true
                
                SetTimeout(0, function()
                    if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE then
                        Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = false
                    end
                    TriggerServerEvent("rcore_police:server:requestCuffEscape", initiatorId, isFront, true)
                    StartPunchAnim(isFront)
                    Wait(1000)
                    if blockAction then blockAction = false end
                end)
            end
        end
    end
    
    RegisterKey(TryEscapeWhenInEscort, "RCORE_POLICE_ESCORT_ESCAPE", _U("KEY_MAPPING.ESCORT_ESCAPE"), Config.Escort.BreakWhenNotCuffsOnKey, nil, { state = true, cooldown = 250 })
end

if Config.Escort.EnableCuffCitizenWhenNotCuffedDuringEscort then
    function TryToCuffCitizenDuringEscort()
        if not Utils.CanPlayerInteract() then return end
        local closestPlayer, _ = Utils.getClosestPlayers(Config.CheckDistance, false)
        if escortHelpKeys then
            TriggerServerEvent("rcore_police:server:requestCuffDuringEscort", closestPlayer)
        end
    end
    
    RegisterKey(TryToCuffCitizenDuringEscort, "RCORE_POLICE_ESCORT_CUFF", _U("ESCORT.KEYMAP_DESCRIPTION") or "Cuff: Useable when being escorted", Config.Escort.CuffCitizenKey or "H", nil, { state = true, cooldown = 1000 })
end

if Config.Escort.EnableStopEscort then
    function TryStopPoliceEscort()
        if not Utils.CanPlayerInteract() then return end
        if escortHelpKeys then
            TriggerServerEvent("rcore_police:server:requestStopEscort")
        end
    end
    
    RegisterKey(TryStopPoliceEscort, "RCORE_POLICE_ESCORT_STOP", _U("KEY_MAPPING.STOP_ESCORT"), Config.Escort.EnableStopEscortKey or "G", nil, { state = true, cooldown = 250 })
end
