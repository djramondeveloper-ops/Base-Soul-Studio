-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local EMULATED_EVENTS = Config.Private.EMULATED_EVENTS['qb-policejob']
local PROPS_LIST = {
    ['spawnBarrier'] = {
        model = 'prop_barrier_work05',
        type = PROP_TYPES.BARRICADE
    },
    ['SpawnSpikeStrip'] = {
        model = 'p_ld_stinger_s',
        type = PROP_TYPES.SPIKES
    },
}
local SKIP_GROUP_CHECKS_FOR_ACTIONS = {
    ['EscortPlayer'] = true,
    ['KidnapPlayer'] = true,
    ['PutPlayerInVehicle'] = true,
    ['SetPlayerOutVehicle'] = true,
}
CreateThread(function()
    if Config.Framework == Framework.QBCore then
        RegisterNetEvent('rcore_police:server:requestEmulatedAction', function(action, targetPlayerId)
            local playerId = source
            if not EMULATED_EVENTS[action] then
                return
            end
            local eventType = EMULATED_EVENTS[action].type
            local eventAction = EMULATED_EVENTS[action].action
            local isProp = EMULATED_EVENTS[action].isProp
            local extraData = {}
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not SKIP_GROUP_CHECKS_FOR_ACTIONS[eventAction] then
                if not state then
                    return
                end
            end
            local startClientSource = targetPlayerId
            local initiator = playerId
            if isProp then
                if PROPS_LIST[eventAction] and next(PROPS_LIST[eventAction]) then
                    local data = PROPS_LIST[eventAction]
                    local value = data['model']
                    local type = data['type']
                    StartClient(playerId, 'spawnProp', value, type)
                else
                    Framework.sendNotification(playerId, _U('PROPS.FAILED_TO_SPAWN_PROP', eventAction))
                end
                return
            end
            if eventType == EMULATED.NEARBY then
                local state = Utils.IsPlayerNearAnotherPlayer(playerId, targetPlayerId)
                if not state then
                    return Framework.sendNotification(playerId, _U('NO_CITIZEN_NEARBY'), 'error')
                end
                if eventAction == 'CuffPlayerSoft' then
                    eventAction = 'Handcuff'
                    return ActionService.Handcuff(playerId, targetPlayerId)
                end
                if eventAction == 'EscortPlayer' then
                    if playerId == targetPlayerId then
                        return
                    end
                    return ActionService.Escort(playerId, targetPlayerId)
                end
                if eventAction == 'PutPlayerInVehicle' then
                    ActionService.PutPlayerInVehicle(playerId, targetPlayerId, true)
                    return
                end
                if eventAction == 'SetPlayerOutVehicle' then
                    ActionService.TakePlayerFromVehicle(playerId, targetPlayerId)
                    return
                end
                if eventAction == 'SearchPlayer' then
                    startClientSource = initiator
                    initiator = targetPlayerId
                end
                if eventAction == 'JailPlayer' then
                    startClientSource = initiator
                    initiator = targetPlayerId
                end
                if eventAction == 'SeizeDriverLicense' then
                    return RemovePlayerLicense(initiator, targetPlayerId, 'driver')
                end
                StartClient(startClientSource, eventAction, initiator, extraData)
            elseif eventType == EMULATED.NO_NEARBY then
                if action == 'SendPoliceEmergencyAlert' and playerData then
                    EmergencyCall(playerData)
                    return
                end
                StartClient(startClientSource, eventAction)
            end
        end)
    end
end)
