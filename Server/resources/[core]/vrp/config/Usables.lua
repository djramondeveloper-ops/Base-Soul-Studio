-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL OX USABLES COMPAT
-- Arquivo criado porque o ox_inventory da Reborn carrega @vrp/config/Usables.lua.
-- A lógica de uso real pode continuar nos scripts da cidade ou ser adicionada aqui depois.
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ox_inventory:useItem")
AddEventHandler("ox_inventory:useItem", function(source, itemName, amount, data)
    local Passport = vRP and vRP.Passport and vRP.Passport(source)
    if Passport then
        TriggerEvent("Seoul:UseItem", source, Passport, itemName, amount, data)
    end
end)
