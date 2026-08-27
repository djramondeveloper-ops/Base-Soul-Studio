-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL MULTIFRAMEWORK V2 - QBCORE CLIENT
-- Helpers/client callbacks complementares sem editar compat/client/qbcore.lua.
-----------------------------------------------------------------------------------------------------------------------------------------
if not SeoulMultiframework or not SeoulMultiframework.QBCore or SeoulMultiframework.QBCore.Enabled == false then
    return
end

QBCore = QBCore or {}
QBCore.Functions = QBCore.Functions or {}
QBCore.ClientCallbacks = QBCore.ClientCallbacks or {}
QBCore.ServerCallbacks = QBCore.ServerCallbacks or {}
QBCore.Shared = QBCore.Shared or QBShared or {}

local PendingServerCallbacks = {}
local NotifyTypes = {
    success = "verde",
    error = "vermelho",
    warning = "amarelo",
    primary = "default",
    info = "default",
    police = "policia"
}

local function asVec3(coords)
    if not coords then return nil end
    if type(coords) == "table" then return vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0) end
    return coords
end

local function loadModel(model)
    model = type(model) == "number" and model or joaat(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    return model
end

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    return true
end

function QBCore.Functions.GetName()
    local charinfo = QBCore.PlayerData and QBCore.PlayerData.charinfo
    if not charinfo then return "" end
    return ((charinfo.firstname or "") .. " " .. (charinfo.lastname or "")):gsub("^%s+", ""):gsub("%s+$", "")
end

function QBCore.Functions.Notify(text, notifyType, length)
    local title = "Aviso"
    local message = text
    if type(text) == "table" then
        title = tostring(text.caption or text.title or title)
        message = text.text or text.message or ""
    end
    local seoulType = NotifyTypes[tostring(notifyType or "primary"):lower()] or tostring(notifyType or "default")
    TriggerEvent("Notify", title, tostring(message or ""), seoulType, tonumber(length) or 5000)
end

RegisterNetEvent("QBCore:Notify", function(text, notifyType, length)
    QBCore.Functions.Notify(text, notifyType, length)
end)

-- Adiciona suporte promise/await sem trocar o formato usado pelo handler legado do compat.
function QBCore.Functions.TriggerCallback(name, ...)
    local args = { ... }
    local callback
    if type(args[1]) == "function" then callback = table.remove(args, 1) end
    local pending = promise.new()
    PendingServerCallbacks[name] = pending

    QBCore.ServerCallbacks[name] = function(...)
        pending:resolve(...)
        PendingServerCallbacks[name] = nil
        if callback then callback(...) end
    end

    TriggerServerEvent("QBCore:Server:TriggerCallback", name, table.unpack(args))
    if callback then return end
    Citizen.Await(pending)
    PendingServerCallbacks[name] = nil
    return pending.value
end

function QBCore.Functions.GetClosestPlayer(coords)
    coords = asVec3(coords) or GetEntityCoords(PlayerPedId())
    local closestPlayer, closestDistance = -1, -1
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            local distance = #(GetEntityCoords(ped) - coords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer, closestDistance = player, distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function QBCore.Functions.GetObjects()
    return GetGamePool("CObject")
end

function QBCore.Functions.GetPeds(ignoreList)
    local ignored = {}
    for _, ped in ipairs(ignoreList or {}) do ignored[ped] = true end
    local result = {}
    for _, ped in ipairs(GetGamePool("CPed")) do
        if not ignored[ped] then result[#result + 1] = ped end
    end
    return result
end

function QBCore.Functions.GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    coords = asVec3(coords) or GetEntityCoords(ped)
    distance = tonumber(distance) or 5.0
    local result = {}

    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= 0 and #(GetEntityCoords(targetPed) - coords) <= distance then
            result[#result + 1] = player
        end
    end

    return result
end

function QBCore.Functions.GetClosestPed(coords, ignoreList)
    coords = asVec3(coords) or GetEntityCoords(PlayerPedId())
    local ignored = {}
    for _, ped in ipairs(ignoreList or {}) do ignored[ped] = true end

    local closest, closestDistance = -1, -1
    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped ~= PlayerPedId() and not ignored[ped] then
            local distance = #(GetEntityCoords(ped) - coords)
            if closestDistance == -1 or distance < closestDistance then
                closest, closestDistance = ped, distance
            end
        end
    end
    return closest, closestDistance
end

function QBCore.Functions.GetClosestVehicle(coords)
    coords = asVec3(coords) or GetEntityCoords(PlayerPedId())
    local closest, closestDistance = -1, -1
    for _, vehicle in ipairs(GetGamePool("CVehicle")) do
        local distance = #(GetEntityCoords(vehicle) - coords)
        if closestDistance == -1 or distance < closestDistance then
            closest, closestDistance = vehicle, distance
        end
    end
    return closest, closestDistance
end

function QBCore.Functions.GetClosestObject(coords)
    coords = asVec3(coords) or GetEntityCoords(PlayerPedId())
    local closest, closestDistance = -1, -1
    for _, object in ipairs(GetGamePool("CObject")) do
        local distance = #(GetEntityCoords(object) - coords)
        if closestDistance == -1 or distance < closestDistance then
            closest, closestDistance = object, distance
        end
    end
    return closest, closestDistance
end

function QBCore.Functions.LoadModel(model)
    return loadModel(model)
end

function QBCore.Functions.LoadAnimDict(dict)
    return loadAnimDict(dict)
end

function QBCore.Functions.PlayAnim(animDictionary, animationName, upperbodyOnly, duration)
    local ped = PlayerPedId()
    loadAnimDict(animDictionary)
    local flag = upperbodyOnly and 16 or 0
    TaskPlayAnim(ped, animDictionary, animationName, 8.0, 8.0, duration or -1, flag, 0.0, false, false, false)
end

function QBCore.Functions.SpawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local hash = loadModel(model)
    if not hash then return false end

    coords = coords or QBCore.Functions.GetCoords(PlayerPedId())
    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w or 0.0, isnetworked ~= false, false)
    if not DoesEntityExist(vehicle) then return false end

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(hash)

    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1) end
    if cb then cb(vehicle) end
    return vehicle
end

function QBCore.Functions.DeleteVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
    return not DoesEntityExist(vehicle)
end

function QBCore.Functions.GetPlate(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return QBCore.Shared.Trim and QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
end

function QBCore.Functions.GetVehicleProperties(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return nil end
    local primary, secondary = GetVehicleColours(vehicle)
    local pearl, wheel = GetVehicleExtraColours(vehicle)
    local r1, g1, b1 = GetVehicleCustomPrimaryColour(vehicle)
    local r2, g2, b2 = GetVehicleCustomSecondaryColour(vehicle)

    return {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        fuelLevel = GetVehicleFuelLevel(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle),
        color1 = primary,
        color2 = secondary,
        pearlescentColor = pearl,
        wheelColor = wheel,
        customPrimaryColor = { r1, g1, b1 },
        customSecondaryColor = { r2, g2, b2 },
        wheelType = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        xenonColor = GetVehicleXenonLightsColor(vehicle),
        modEngine = GetVehicleMod(vehicle, 11),
        modBrakes = GetVehicleMod(vehicle, 12),
        modTransmission = GetVehicleMod(vehicle, 13),
        modSuspension = GetVehicleMod(vehicle, 15),
        modArmor = GetVehicleMod(vehicle, 16),
        modTurbo = IsToggleModOn(vehicle, 18),
        modXenon = IsToggleModOn(vehicle, 22)
    }
end

function QBCore.Functions.SetVehicleProperties(vehicle, props)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or type(props) ~= "table" then return false end
    SetVehicleModKit(vehicle, 0)

    if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
    if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
    if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
    if props.color1 or props.color2 then
        local c1, c2 = GetVehicleColours(vehicle)
        SetVehicleColours(vehicle, props.color1 or c1, props.color2 or c2)
    end
    if props.pearlescentColor or props.wheelColor then
        local pearl, wheel = GetVehicleExtraColours(vehicle)
        SetVehicleExtraColours(vehicle, props.pearlescentColor or pearl, props.wheelColor or wheel)
    end
    if props.customPrimaryColor then SetVehicleCustomPrimaryColour(vehicle, table.unpack(props.customPrimaryColor)) end
    if props.customSecondaryColor then SetVehicleCustomSecondaryColour(vehicle, table.unpack(props.customSecondaryColor)) end
    if props.wheelType then SetVehicleWheelType(vehicle, props.wheelType) end
    if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
    if props.xenonColor then SetVehicleXenonLightsColor(vehicle, props.xenonColor) end
    if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
    if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
    if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
    if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
    if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
    if props.modTurbo ~= nil then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
    if props.modXenon ~= nil then ToggleVehicleMod(vehicle, 22, props.modXenon) end
    return true
end

function QBCore.Functions.CreateClientCallback(name, cb)
    if type(name) ~= "string" or type(cb) ~= "function" then return false end
    QBCore.ClientCallbacks[name] = cb
    return true
end

RegisterNetEvent("QBCore:Client:TriggerClientCallback", function(name, ...)
    local callback = QBCore.ClientCallbacks[name]
    if not callback then return end
    callback(function(...)
        TriggerServerEvent("QBCore:Server:TriggerClientCallback", name, ...)
    end, ...)
end)

RegisterNetEvent("QBCore:Client:OnSharedUpdate", function(collection, name, data)
    if type(collection) ~= "string" or not QBCore.Shared[collection] then return end
    QBCore.Shared[collection][name] = data
end)

RegisterNetEvent("QBCore:Client:OnSharedUpdateMultiple", function(collection, values)
    if type(collection) ~= "string" or type(values) ~= "table" or not QBCore.Shared[collection] then return end
    for name, data in pairs(values) do QBCore.Shared[collection][name] = data end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    TriggerServerEvent("QBCore:UpdatePlayer")
end)

if tostring(GetConvar("seoul:debug", "false")):lower() == "true" then
    print("^2[Seoul]^7 Multiframework QBCore V2 client ativo sem substituir compat/.")
end
