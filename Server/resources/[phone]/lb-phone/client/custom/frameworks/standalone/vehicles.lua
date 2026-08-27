if Config.Framework ~= "standalone" then
    return
end

---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end

    if vehicleData.plate then
        SetVehicleNumberPlateText(vehicle, vehicleData.plate)
    end

    local statistics = vehicleData.statistics or {}

    if statistics.engine then
        SetVehicleEngineHealth(vehicle, tonumber(statistics.engine) or 1000.0)
    end

    if statistics.body then
        SetVehicleBodyHealth(vehicle, tonumber(statistics.body) or 1000.0)
    end

    if statistics.fuel then
        SetVehicleFuelLevel(vehicle, (tonumber(statistics.fuel) or 100.0) + 0.0)
    end

    if Config.Valet.FixTakeOut then
        SetVehicleFixed(vehicle)
    end
end

---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
    local hash = tonumber(vehicleData.model)

    if not hash and vehicleData.vehicle then
        hash = joaat(vehicleData.vehicle)
    end

    if not hash or not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        return nil
    end

    local model = LoadModel(hash)
    if not model then return nil end

    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, 0.0, true, false)
    if vehicle == 0 then
        SetModelAsNoLongerNeeded(hash)
        return nil
    end

    SetVehicleOnGroundProperly(vehicle)
    ApplyVehicleMods(vehicle, vehicleData)
    SetModelAsNoLongerNeeded(hash)

    return vehicle
end
