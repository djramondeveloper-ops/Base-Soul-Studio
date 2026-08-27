-- Seoul Base: QBCore duty bridge backed by the real vRP service state.
-- vRP is the source of truth. LB Tablet reads vRP.HasService and receives service:Client.

local serviceCooldown = {}
local playerServiceStates = {}

if Config.Duty == Duty.QBCORE then
    local function getFrameworkDuty(playerId)
        local player = Framework.getPlayer(playerId)
        if not player or not player.PlayerData or not player.PlayerData.job then
            return nil, player
        end

        local job = player.PlayerData.job
        local duty = job.onduty
        if duty == nil then
            duty = job.onDuty
        end

        if duty == nil then
            return nil, player
        end

        return duty == true, player
    end

    local function syncCachedDuty(playerId)
        local duty = getFrameworkDuty(playerId)
        if duty ~= nil then
            playerServiceStates[playerId] = duty
            return duty
        end

        return playerServiceStates[playerId] == true
    end

    AddEventHandler('rcore_police:server:setPlayerDuty', function(playerId, state)
        if not playerId or type(state) ~= 'boolean' then
            return
        end

        DutyService.EnforceDuty(playerId, state)
    end)

    AddEventHandler('rcore_police:server:playerUnloaded', function(playerId)
        serviceCooldown[playerId] = nil
        playerServiceStates[playerId] = nil
    end)

    DutyService.HandlePlayerDuty = function(playerId)
        local currentDuty, player = getFrameworkDuty(playerId)
        if not player then
            return
        end

        if currentDuty == nil then
            currentDuty = playerServiceStates[playerId] == true
        end

        if serviceCooldown[playerId] then
            return Framework.sendNotification(playerId, _U('DUTY.COOLDOWN'), 'error')
        end

        serviceCooldown[playerId] = true
        SetTimeout(Config.Service.Cooldown * 1000, function()
            serviceCooldown[playerId] = nil
        end)

        local requestedDuty = not currentDuty
        local changed = player.Functions.SetJobDuty(requestedDuty)

        if changed == false then
            dbg.critical('Duty: framework rejected SetJobDuty(%s) for player %s', tostring(requestedDuty), tostring(playerId))
            return
        end

        -- The Seoul QBCore adapter immediately refreshes PlayerData from vRP.HasService.
        local authoritativeDuty = getFrameworkDuty(playerId)
        if authoritativeDuty == nil then
            authoritativeDuty = requestedDuty
        end

        playerServiceStates[playerId] = authoritativeDuty
        DutyService.UpdatePlayerDuty(playerId, authoritativeDuty)

        if authoritativeDuty then
            Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_IN_SERVICE'), 'success')
        else
            Framework.sendNotification(playerId, _U('DUTY.YOU_ARE_OFF_SERVICE'), 'success')
        end

        dbg.debug(
            'Duty Seoul sync | player=%s requested=%s authoritative=%s',
            tostring(playerId),
            tostring(requestedDuty),
            tostring(authoritativeDuty)
        )
    end

    DutyService.EnforceDuty = function(playerId, state)
        if not playerId or type(state) ~= 'boolean' then
            return false
        end

        local currentDuty, player = getFrameworkDuty(playerId)
        if not player then
            return false
        end

        if currentDuty == nil then
            currentDuty = playerServiceStates[playerId] == true
        end

        if currentDuty ~= state then
            local changed = player.Functions.SetJobDuty(state)
            if changed == false then
                dbg.critical('Duty: framework rejected enforced SetJobDuty(%s) for player %s', tostring(state), tostring(playerId))
                return false
            end
        end

        local authoritativeDuty = getFrameworkDuty(playerId)
        if authoritativeDuty == nil then
            authoritativeDuty = state
        end

        playerServiceStates[playerId] = authoritativeDuty
        DutyService.UpdatePlayerDuty(playerId, authoritativeDuty)
        return authoritativeDuty
    end

    DutyService.UpdatePlayerDuty = function(playerId, state)
        TriggerEvent('rcore_police:server:SetDuty', playerId, state)
        TriggerEvent(Config.Events['QBCore:Server:SetDuty'], playerId, state)
        TriggerClientEvent(Config.Events['QBCore:Client:SetDuty'], playerId, state)
    end

    DutyService.IsPlayerInService = function(playerId)
        return syncCachedDuty(playerId)
    end
end
