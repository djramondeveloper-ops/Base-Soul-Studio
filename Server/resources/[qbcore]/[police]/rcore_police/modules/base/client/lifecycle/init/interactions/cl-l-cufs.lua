-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-cufs.lua
--  Engineered by Eazy Fxap
--  Original: 265 lines → Cleaned: 84 lines
-- =====================================================

CreateThread(function()
    local waitTime = 150
    while true do
        Wait(waitTime)
        if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE then
            local session = Interactions.Cuff.Session
            if not session then return end
            
            local ped = session.mePed
            
            -- Stop handsup and knee anims if playing
            if IsEntityPlayingAnim(ped, HANDS_UP.DICT, HANDS_UP.NAME, 3) then
                StopEntityAnim(ped, HANDS_UP.DICT, HANDS_UP.NAME, 1.0)
            end
            if IsEntityPlayingAnim(ped, KNEE.DICT, KNEE.NAME, 3) then
                StopEntityAnim(ped, KNEE.DICT, KNEE.NAME, 1.0)
            end
            
            -- Keep player in current seat if in vehicle
            if currentSeat then
                local vehicle = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(vehicle, currentSeat) ~= ped then
                    SetPedIntoVehicle(ped, vehicle, currentSeat)
                end
                SetPedConfigFlag(ped, 184, true)
            end
            
            -- Force cuff animation if not playing
            if not IsEntityPlayingAnim(ped, session.animDict, session.animName, 3) then
                Wait(25)
                TaskPlayAnim(ped, session.animDict, session.animName, 8.0, -8.0, -1, MOVEMENT_FLAG.MOVE_ALL, 0, 0, 0, 0)
            end
            waitTime = 150
        else
            waitTime = 250
        end
    end
end)

CreateThread(function()
    local waitTime = 250
    local playerId = PlayerId()
    while true do
        Wait(waitTime)
        if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE then
            waitTime = 0
            
            -- Walk restrictions
            if Config.Cuffing.DisableWalkForCuffedPlayers then
                DisableControlAction(0, 30, true) -- Move left/right
                DisableControlAction(0, 31, true) -- Move up/down
                DisableControlAction(0, 34, true) -- Move left (alt)
                DisableControlAction(0, 35, true) -- Move right (alt)
                DisableControlAction(0, 21, true) -- Sprint
            end
            
            -- Sprint restriction
            if Config.Cuffing.DisableSprintForCuffedPlayers then
                local ped = PlayerPedId()
                if IsPedRunning(ped) or IsPedSprinting(ped) then
                    SetTimeout(100, function()
                        if DoesEntityExist(ped) then
                            ForcePedMotionState(ped, -668482597, 0, 0, 0)
                        end
                    end)
                end
            end
            
            -- Action restrictions
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 45, true)  -- Reload
            DisableControlAction(0, 140, true) -- Melee Attack Light
            DisableControlAction(0, 104, true) -- Extra vehicle action
            DisableControlAction(0, 75, true)  -- Vehicle exit
            DisableControlAction(27, 75, true) -- Vehicle exit (alt)
            DisableControlAction(0, 22, true)  -- Jump
            
            SetPlayerMayNotEnterAnyVehicle(playerId)
        else
            waitTime = 250
        end
    end
end)
