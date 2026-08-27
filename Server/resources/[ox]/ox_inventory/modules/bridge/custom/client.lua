RegisterNetEvent('vRP:Active', function(Passport)
    PlayerData.loaded = true
    PlayerData.groups = PlayerData.groups or {}
    PlayerData.source = cache.serverId
    PlayerData.identifier = Passport and ('vrp:%s'):format(Passport) or PlayerData.identifier
    client.setPlayerData('groups', PlayerData.groups)
end)

AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= cache.resource then return end
    PlayerData.groups = PlayerData.groups or {}
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    -- vRP/Creative controla fome, sede e stress pelo HUD da base.
end
