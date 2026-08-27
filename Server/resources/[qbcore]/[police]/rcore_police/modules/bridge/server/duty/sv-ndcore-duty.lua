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
    if Config.Duty == Duty.NDCORE then
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
        DutyService.HandlePlayerDuty = function(playerId)
            local player = Framework.getPlayer(playerId)
            local state = nil
            if playerServiceStates[playerId] == nil then
                playerServiceStates[playerId] = false -- Set default as not in service
            end
            playerServiceStates[playerId] = not playerServiceStates[playerId]
            if not player then
                return
            end
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
            else
                state = 'OFF_SERVICE'
                DutyService.UpdatePlayerDuty(playerId, false)
            end
            dbg.debug('Player named %s (%s) requested duty state: %s', GetPlayerName(playerId), source, state)
        end
        DutyService.ActiveService = function(departmentName)
        end
        DutyService.EnforceDuty = function(playerId, state)
            playerServiceStates[playerId] = state
            DutyService.UpdatePlayerDuty(playerId, state)
        end
        DutyService.UpdatePlayerDuty = function(playerId, state)
            StartClient(playerId, 'SetDuty', state)
            TriggerEvent('rcore_police:server:SetDuty', playerId, state)
        end
        DutyService.IsPlayerInService = function(playerId)
            local player = Framework.getPlayer(playerId)
            local state = false
            if not player then
                return
            end
            if playerServiceStates[playerId] then
                state = true
            end
            return state
        end
    end
end)
