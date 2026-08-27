-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local EMULATED_EVENTS = Config.Private.EMULATED_EVENTS['qb-policejob']
local impl = {
    { name = 'IsHandcuffed', func = InteractionService.isCuffed, resource = PoliceResources.QB },
}
CreateThread(function()
    if EMULATED_EVENTS and next(EMULATED_EVENTS) then
        for originEventName, data in pairs(EMULATED_EVENTS) do
            local eventName = Config.Prefixes['qb-policejob']
            local eventData = data
            local eventAction = eventData.action
            local eventType = eventData.type
            local registerEvent = ('%s:%s'):format(eventName, originEventName)
            RegisterNetEvent(registerEvent, function()
                if eventAction == MENU_ACTIONS.ESCORT_CITIZEN and not Config.Escort.Enable then
                    return
                end
                dbg.debug('IMPL: Emulated event was called named %s from resource %s', registerEvent,
                    GetInvokingResource())
                if eventType == EMULATED.NEARBY then
                    local closestPlayer, closestDistance, closestPlayers = Utils.getClosestPlayers(Config.CheckDistance,
                        false)
                    if closestPlayer and closestPlayer ~= -1 then
                        TriggerServerEvent("rcore_police:server:requestEmulatedAction", eventAction, closestPlayer)
                    else
                        Framework.sendNotification(_U('NO_CITIZEN_NEARBY'), 'error')
                    end
                elseif eventType == EMULATED.NO_NEARBY then
                    TriggerServerEvent('rcore_police:server:requestEmulatedAction', eventAction)
                end
            end)
        end
    end
end)
RegisterNetEvent('police:client:RobPlayer', function()
    if Config.Inventory == Inventory.QS then
        return
    end
    local targetPlayer, closestDistance, closestPlayers = Utils.getClosestPlayers(Config.CheckDistance, false)
    if targetPlayer and targetPlayer ~= -1 then
        local targetPed = UtilsService.GetPlayerPedFromServerId(targetPlayer)
        if not targetPed then
            return
        end
        if targetPlayer and InventoryUtils.CanSearch(targetPlayer) then
            OpenPlayerInventory(targetPlayer)
        else
            Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_DEAD_SEARCH_INV"), "error")
        end
    else
        Framework.sendNotification(_U('NO_CITIZEN_NEARBY'), 'error')
    end
end)
AddEventHandler('rcore_police:client:listener', function(data)
    if not data then return end
    if IS_QB[Config.Framework] then
        local state = data.state
        if data.action == "ESCORT" then
            TriggerEvent('hospital:client:isEscorted', state)
        end
    end
end)
CreateThread(function()
    if impl and next(impl) then
        for _, v in ipairs(impl) do
            if v.func and v.name then
                provideExport(v.name, v.resource, v.func)
            end
        end
    end
end)
