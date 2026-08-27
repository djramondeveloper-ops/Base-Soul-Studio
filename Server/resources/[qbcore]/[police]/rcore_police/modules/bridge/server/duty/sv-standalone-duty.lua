-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local serviceCooldown = {}
local playerServiceStates = {}
CreateThread(function()
    if Config.Duty == Duty.NONE then
        AddEventHandler('rcore_police:server:setPlayerDuty', function(playerId, state)
            if not playerId then
                return
            end
            if playerServiceStates[playerId] == nil then
                playerServiceStates[playerId] = false
            end
            playerServiceStates[playerId] = not playerServiceStates[playerId]
            DutyService.EnforceDuty(playerId, state)
        end)
        AddEventHandler('rcore_police:server:playerUnloaded', function(playerId)
            if serviceCooldown[playerId] then
                serviceCooldown[playerId] = nil
            end
            if playerServiceStates[playerId] then
                playerServiceStates[playerId] = nil
            end
        end)
        DutyService.EnforceDuty = function(playerId, state)
            playerServiceStates[playerId] = state
            DutyService.UpdatePlayerDuty(playerId, state)
        end
        DutyService.HandlePlayerDuty = function(playerId)
            local state = nil
            if playerServiceStates[playerId] == nil then
                playerServiceStates[playerId] = false -- Set default as not in service
            end
            playerServiceStates[playerId] = not playerServiceStates[playerId]
            if serviceCooldown[playerId] then
                return Framework.sendNotification(playerId, _U('DUTY.COOLDOWN'), 'error')
            end
            if not serviceCooldown[playerId] then
                serviceCooldown[playerId] = true
            end
            SetTimeout(Config.Service.Cooldown * 1000, function()
                if serviceCooldown[playerId] then
                    serviceCooldown[playerId] = nil
                end
            end)
            if playerServiceStates[playerId] then
                state = 'IN_SERVICE'
                DutyService.UpdatePlayerDuty(playerId, true)
                Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_IN_SERVICE'), 'success')
            else
                state = 'OFF_SERVICE'
                DutyService.UpdatePlayerDuty(playerId, false)
                Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_OFF_SERVICE'), 'success')
            end
            dbg.debug('Player named %s (%s) requested duty state: %s', GetPlayerName(playerId), source, state)
        end
        DutyService.ActiveService = function(departmentName)
        end
        DutyService.UpdatePlayerDuty = function(playerId, state)
            StartClient(playerId, 'SetDuty', state)
            TriggerEvent('rcore_police:server:SetDuty', playerId, state)
        end
        DutyService.IsPlayerInService = function(playerId)
            local state = false
            if playerServiceStates[playerId] then
                state = true
            end
            return state
        end
    end
end)
