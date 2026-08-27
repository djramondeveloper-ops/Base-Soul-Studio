-- =====================================================
-- SERVIDOR - 100% standalone / independente de framework
-- (Compativel com ESX, QBCore, QBox, vRP ou qualquer "creative" custom,
-- pois so repassa os eventos de attach/deattach entre os clientes)
-- =====================================================

RegisterServerEvent('icemallow-drag-server:attach')
AddEventHandler('icemallow-drag-server:attach', function(targetPlayer)
    local source = source
    TriggerClientEvent('icemallow-drag:attach', targetPlayer, source)
end)

RegisterServerEvent('icemallow-drag-server:deattach')
AddEventHandler('icemallow-drag-server:deattach', function(targetPlayer)
    local source = source
    TriggerClientEvent('icemallow-drag:deattach', targetPlayer, source)
end)
