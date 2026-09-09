-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local function markSeoulVehicleKey(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate or plate == "" then
        return false
    end

    Entity(vehicle).state:set("Lockpick", plate, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    return true
end

function AddVehicleKey(vehicle)
    if not vehicle then
        return false
    end
    if not DoesEntityExist(vehicle) then
        return false
    end
    markSeoulVehicleKey(vehicle)
    local coords = GetEntityCoords(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    TriggerServerEvent("hrs_vehicles:persists:pdm", VehToNet(vehicle))
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
    if Config.Keys == Keys.RCORE then
        TriggerServerEvent("rcore_garage:GivePlayerKey", plate)
        return true
    end
    if Config.Keys == Keys.FIVECODE then
        exports.fivecode_carkeys:GiveKey(vehicle, false, true)
        return true
    end
    if Config.Keys == Keys.MR_NEWB then
        exports.MrNewbVehicleKeys:GiveKeys(vehicle)
        return true
    end
    if Config.Keys == Keys.OKOK then
        TriggerServerEvent("okokGarage:GiveKeys", plate)
        return true
    end
    if Config.Keys == Keys.JAKSAM then
        TriggerServerEvent("vehicles_keys:selfGiveCurrentVehicleKeys")
        return true
    end
    if Config.Keys == Keys.QB then
        TriggerEvent('qb-vehiclekeys:client:AddKeys', plate)
        return true
    end
    if Config.Keys == Keys.WASABI then
        exports.wasabi_carlock:GiveKey(plate)
        return true
    end
    TriggerServerEvent("realisticVehicleSystem:server:addVehicle", model, vector4(coords.x, coords.y, coords.z, GetEntityHeading(vehicle)))
    if Config.Keys == Keys.CD then
        TriggerEvent('cd_garage:AddKeys', exports["cd_garage"]:GetPlate(vehicle))
        return true
    end
    if Config.Keys == Keys.QS then
        local vehicleModelName = GetDisplayNameFromVehicleModel(model)
        exports['qs-vehiclekeys']:GiveKeys(plate, vehicleModelName, true)
        return true
    end
    if Config.Keys == Keys.XD then
        exports['xd_locksystem']:givePlayerKeys(plate)
        return true
    end
    if Config.Keys == Keys.RENEWED then
        exports['Renewed-Vehiclekeys']:addKey(plate)
        return true
    end
    if Config.Keys == Keys.MK then
        exports["mk_vehiclekeys"]:AddKey(vehicle)
        return true
    end
    TriggerServerEvent('t1ger_keys:updateOwnedKeys', plate, true)
    dbg.debug('Setting vehicle keys for vehicle named %s!', GetEntityArchetypeName(vehicle))
    return true
end
function RemoveVehicleKey(vehicle)
    if not vehicle then
        return
    end
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local plate = GetVehicleNumberPlateText(vehicle)
    if Config.Keys == Keys.ZYKE then
        exports["zyke_garages"]:RemoveKey(plate, model)
    end
    if Config.Keys == Keys.RENEWED then
        exports['Renewed-Vehiclekeys']:removeKey(plate)
    end
    if Config.Keys == Keys.MK then
        exports["mk_vehiclekeys"]:RemoveKey(vehicle)
    end
    dbg.debug('Removing vehicles keys for vehicle using via resource API: %s', Config.Keys)
end
RegisterNetEvent('rcore_police:client:despawnVehicle', function(netId)
    if source == '' then return end
    if not netId then return end
    local entity = NetToVeh(netId)
    if DoesEntityExist(entity) then
        RemoveVehicleKey(entity) 
    end
end)
