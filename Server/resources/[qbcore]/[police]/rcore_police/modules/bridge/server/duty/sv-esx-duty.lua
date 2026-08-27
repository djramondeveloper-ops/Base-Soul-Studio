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
    if Config.Duty == Duty.ESX then
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
            local job = Framework.getJob(playerId)
            local jobName = job and job.name
            local runningService = false
            if jobName and Config.Duty == Duty.ESX_SERVICE then
                runningService = true
                StartClient(playerId, 'HandleESXService', jobName)
            end
            SetTimeout(Config.Service.Cooldown * 1000, function()
                if serviceCooldown[playerId] then
                    serviceCooldown[playerId] = nil
                end
            end)
            if playerServiceStates[playerId] then
                if not runningService then
                    Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_IN_SERVICE'), 'success')
                end
                state = 'IN_SERVICE'
                DutyService.UpdatePlayerDuty(playerId, true)
            else
                if not runningService then
                    Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_OFF_SERVICE'), 'success')
                end
                state = 'OFF_SERVICE'
                DutyService.UpdatePlayerDuty(playerId, false)
            end
            local name = Framework.getCharacterShortName(playerId)
            local charId = Framework.getIdentifier(playerId)
            Utils.Log("Duty", ('Player named %s (%s) (%s) setting duty state to: %s'):format(name, charId, source, state))
            dbg.debug('Player named %s (%s) requested duty state: %s', GetPlayerName(playerId), source, state)
        end
        DutyService.EnforceDuty = function(playerId, state)
            playerServiceStates[playerId] = state
            DutyService.UpdatePlayerDuty(playerId, state)
        end
        DutyService.ActiveService = function(departmentName)
            if Config.Duty == Duty.ESX_SERVICE then
                dbg.debug('Registering service for department: %s because running esx_service', departmentName)
                TriggerEvent('esx_service:activateService', departmentName, 32)
            end
        end
        DutyService.UpdatePlayerDuty = function(playerId, state)
            local player = Framework.getPlayer(playerId)
            local job = player and player.getJob()
            if player and job and type(job.onDuty) ~= nil then
                dbg.debug("Found latest esx using job.onDuty setting state %s for user with playerId %s", state, playerId)
                player.setJob(job.name, job.grade, state)
            end
            StartClient(playerId, 'SetDuty', state)
            TriggerEvent('rcore_police:server:SetDuty', playerId, state)
        end
        DutyService.IsPlayerInService = function(playerId)
            local player = Framework.getPlayer(playerId)
            local state = false
            if not player then
                return
            end
            local job = player.getJob()
            local onDuty = job and job.onDuty or playerServiceStates[playerId]
            if onDuty then
                state = true
            end
            return state
        end
    end
end)
