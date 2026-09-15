--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

local VehicleFuelTypeByHash = nil
local function GetVehicleFuelTypeByHash()
    if not VehicleFuelTypeByHash then
        VehicleFuelTypeByHash = {}
        -- FIX 1 (corrected): client/init.lua's ConvertClientConfigTables converts
        -- Config.VehicleFuelType from this raw {model=name, fuelType=X} array into
        -- a hash-keyed table before real usage, so by the time this actually runs
        -- it's normally already keyed by model hash -- ipairs() would find nothing
        -- and this cache would stay permanently empty. Handle both shapes so this
        -- is correct regardless of whether that conversion has run yet.
        if Config.VehicleFuelType[1] ~= nil then
            for _, entry in ipairs(Config.VehicleFuelType) do
                VehicleFuelTypeByHash[GetHashKey(entry.model)] = entry.fuelType
            end
        else
            for modelHash, fuelType in pairs(Config.VehicleFuelType) do
                VehicleFuelTypeByHash[modelHash] = fuelType
            end
        end
    end
    return VehicleFuelTypeByHash
end

function GetGunFlowRatePerMinute(fuelType)
    local configured = Config.FlowRatePerFuelType and Config.FlowRatePerFuelType[fuelType]
    local flowRate = tonumber(configured) or tonumber(Config.DispenserGunFlowRatePerMinuteInLiters) or 60
    if flowRate <= 0 then flowRate = 60 end
    return flowRate
end

exports("GetGunFlowRatePerMinute", GetGunFlowRatePerMinute)

function GetGunFlowRateInMilliseconds(fuelType)
    return (60 * 1000) / GetGunFlowRatePerMinute(fuelType)
end

exports("GetGunFlowRateInMilliseconds", GetGunFlowRateInMilliseconds)

function GetFuelLabelByType(type)
    return _U(type)
end

exports("GetFuelLabelByType", GetFuelLabelByType)

function GetVehicleFuelType(model)
    model = tonumber(model) or 0
    local vehicleClass = GetVehicleClassFromName(model)
    -- FIX 1: Config.VehicleFuelType is an array of {model=name, fuelType=X}, not a
    -- table keyed by model hash -- indexing it directly with the hash every caller
    -- passes here always returned nil, so this per-vehicle override list (including
    -- marking EV supercars like the Voltic/T20/Raiden as needing a charge, not gas)
    -- was never actually applied
    local data = GetVehicleFuelTypeByHash()[model]
    if data then
        return data
    end

    local vehicleClassFuel = Config.SpecificFuelTypePerVehicleClass
    if vehicleClassFuel[vehicleClass] then
        local fuelTypes = vehicleClassFuel[vehicleClass]
        if type(fuelTypes) == "table" and #fuelTypes > 0 then
            return fuelTypes[(model % #fuelTypes) + 1]
        end
    end

    local vehicleTypeFuel = Config.RandomFuelTypesPerVehicleType[GetVehicleType(model)]
    if type(vehicleTypeFuel) == "table" and #vehicleTypeFuel > 0 then
        return vehicleTypeFuel[(model % #vehicleTypeFuel) + 1]
    end

    local defaults = Config.DefaultRandomFuelTypes or {}
    if #defaults > 0 then
        return defaults[(model % #defaults) + 1]
    end

    -- Broken/empty fuel config should still return a value from this resource's
    -- actual enum. (The enum uses NATURAL, not PETROL/GASOLINE.)
    return FuelType.NATURAL or FuelType.DIESEL or 1
end

exports("GetVehicleFuelType", GetVehicleFuelType)

function GetVehicleFuelTypeLabel(model)
    return _U(GetVehicleFuelType(model))
end

exports("GetVehicleFuelTypeLabel", GetVehicleFuelTypeLabel)
