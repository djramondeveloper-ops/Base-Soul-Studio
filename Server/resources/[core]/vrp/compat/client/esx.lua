-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ESX CLIENT ADAPTER
-----------------------------------------------------------------------------------------------------------------------------------------
ESX = ESX or {}
ESX.PlayerData = ESX.PlayerData or {}
ESX.ServerCallbacks = ESX.ServerCallbacks or {}
ESX.ClientCallbacks = ESX.ClientCallbacks or {}

exports('getSharedObject', function() return ESX end)
AddEventHandler('esx:getSharedObject', function(cb) cb(ESX) end)

function ESX.GetPlayerData() return ESX.PlayerData end
function ESX.IsPlayerLoaded() return next(ESX.PlayerData) ~= nil end
function ESX.ShowNotification(msg, ntype, length) TriggerEvent('Notify', ntype or 'primary', msg, length or 5000) end
function ESX.TriggerServerCallback(name, cb, ...)
    local requestId = math.random(100000,999999)
    ESX.ServerCallbacks[requestId] = cb
    TriggerServerEvent('esx:triggerServerCallback', name, requestId, ...)
end
function ESX.RegisterClientCallback(name, cb) ESX.ClientCallbacks[name] = cb end
function ESX.SetPlayerData(key, val) ESX.PlayerData[key] = val end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer or {}
end)
RegisterNetEvent('esx:setPlayerData', function(key, val)
    ESX.PlayerData[key] = val
end)
RegisterNetEvent('esx:serverCallback', function(requestId, ...)
    local cb = ESX.ServerCallbacks[requestId]
    if cb then cb(...); ESX.ServerCallbacks[requestId] = nil end
end)
RegisterNetEvent('esx:showNotification', function(msg, ntype, length) ESX.ShowNotification(msg, ntype, length) end)

ESX.Math = ESX.Math or {}
function ESX.Math.Round(value, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(value * mult + 0.5) / mult
end

ESX.Game = ESX.Game or {}
function ESX.Game.GetPlayers() return GetActivePlayers() end
function ESX.Game.GetClosestPlayer(coords)
    local players = GetActivePlayers()
    local closest, distance = -1, -1
    coords = coords or GetEntityCoords(PlayerPedId())
    for _,player in ipairs(players) do
        local ped = GetPlayerPed(player)
        if ped ~= PlayerPedId() then
            local dist = #(coords - GetEntityCoords(ped))
            if distance == -1 or dist < distance then closest, distance = player, dist end
        end
    end
    return closest, distance
end
function ESX.Game.GetVehicles() return GetGamePool('CVehicle') end
function ESX.Game.GetClosestVehicle(coords)
    local vehicles = GetGamePool('CVehicle')
    local closest, distance = nil, -1
    coords = coords or GetEntityCoords(PlayerPedId())
    for _,veh in ipairs(vehicles) do
        local dist = #(coords - GetEntityCoords(veh))
        if distance == -1 or dist < distance then closest, distance = veh, dist end
    end
    return closest, distance
end
function ESX.Game.DeleteVehicle(vehicle) DeleteEntity(vehicle) end
function ESX.Game.SpawnVehicle(model, coords, heading, cb)
    local hash = type(model) == 'number' and model or joaat(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading or coords.w or 0.0, true, false)
    if cb then cb(veh) end
    return veh
end
