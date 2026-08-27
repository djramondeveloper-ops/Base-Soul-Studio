-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL QBCORE CLIENT ADAPTER
-----------------------------------------------------------------------------------------------------------------------------------------
QBCore = QBCore or {}
QBCore.Config = QBConfig
QBCore.Shared = QBShared
QBCore.ClientCallbacks = QBCore.ClientCallbacks or {}
QBCore.ServerCallbacks = QBCore.ServerCallbacks or {}
QBCore.PlayerData = QBCore.PlayerData or {}
QBCore.Functions = QBCore.Functions or {}

exports('GetCoreObject', function() return QBCore end)
RegisterNetEvent('QBCore:GetObject', function(cb) cb(QBCore) end)
AddEventHandler('QBCore:GetObject', function(cb) cb(QBCore) end)

function QBCore.Functions.GetPlayerData(cb)
    if cb then cb(QBCore.PlayerData) end
    return QBCore.PlayerData
end

function QBCore.Functions.Notify(text, texttype, length)
    TriggerEvent('Notify', texttype or 'primary', text, length or 5000)
end

function QBCore.Functions.TriggerCallback(name, cb, ...)
    QBCore.ServerCallbacks[name] = cb
    TriggerServerEvent('QBCore:Server:TriggerCallback', name, ...)
end

function QBCore.Functions.CreateClientCallback(name, cb) QBCore.ClientCallbacks[name] = cb end
function QBCore.Functions.GetCoords(entity) local c=GetEntityCoords(entity); return vector4(c.x,c.y,c.z,GetEntityHeading(entity)) end
function QBCore.Functions.GetVehicles() return GetGamePool('CVehicle') end
function QBCore.Functions.GetPeds(ignoreList) return GetGamePool('CPed') end
function QBCore.Functions.GetPlayers() return GetActivePlayers() end
function QBCore.Functions.GetClosestPlayer(coords)
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

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    QBCore.PlayerData = data or {}
end)

RegisterNetEvent('QBCore:Client:TriggerCallback', function(name, ...)
    local cb = QBCore.ServerCallbacks[name]
    if cb then cb(...); QBCore.ServerCallbacks[name] = nil end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    QBCore.PlayerData = {}
end)

function QBCore.Functions.HasItem(item, amount)
    amount = amount or 1
    if GetResourceState('ox_inventory') == 'started' then
        return (exports.ox_inventory:Search('count', item) or 0) >= amount
    end
    return false
end

function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if lib and lib.progressBar then
        local ok = lib.progressBar({ duration = duration or 5000, label = label or name, canCancel = canCancel ~= false, disable = disableControls or {}, anim = animation, prop = prop })
        if ok then if onFinish then onFinish() end else if onCancel then onCancel() end end
    else
        Wait(duration or 5000)
        if onFinish then onFinish() end
    end
end
