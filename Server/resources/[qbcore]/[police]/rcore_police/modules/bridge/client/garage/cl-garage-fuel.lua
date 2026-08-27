-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function SetVehicleFuel(vehicle)
    if not vehicle then
        return false
    end
    local fuelSystem = 'NATIVE'
    if not vehicle then
        dbg.debug('SetVehicleFuel: Failed to set since missing vehicle param: %s', type(vehicle))
        return false
    end
    if not DoesEntityExist(vehicle) then
        dbg.debug('SetVehicleFuel: Failed to set since target vehicle doesnt exist: %s', type(vehicle))
        return false
    end
    local fuelPrefix = ('%s.%s'):format(Config.Garage.DefaultFuelLevel or 100, 0)
    local defaultFuelLevel = tonumber(fuelPrefix)
    if not defaultFuelLevel then
        return false
    end
    if Config.Fuel == Fuel.LC then
        exports["lc_fuel"]:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.LEGACY then
        exports['LegacyFuel']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.RCORE then
        exports['rcore_fuel']:SetVehicleFuel(vehicle, defaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.PS then
        exports['ps-fuel']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.CDN then
        exports['cdn-fuel']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.TI then
        exports['ti_fuel']:setFuel(vehicle, defaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.OX then
        SetVehicleFuelLevel(vehicle, defaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.MY then
        exports['myFuel']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.OKOK then
        exports['okokGasStation']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.LJ then
        exports['lj-fuel']:SetFuel(vehicle, Config.Garage.DefaultFuelLevel)
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
    end
    if Config.Fuel == Fuel.ND then
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
        local FUEL_DECOR = "_ANDY_FUEL_DECORE_"
        SetVehicleFuelLevel(vehicle, defaultFuelLevel)
        DecorSetFloat(vehicle, FUEL_DECOR, GetVehicleFuelLevel(vehicle))
    end
    if Config.Fuel == Fuel.HYON_GAS then
        fuelSystem = 'THIRD_PARTY_FUEL_RESOURCE'
        local FUEL_DECOR = "_FUEL_LEVEL_"
        SetVehicleFuelLevel(vehicle, defaultFuelLevel)
        DecorSetFloat(vehicle, FUEL_DECOR, GetVehicleFuelLevel(vehicle))
    end
    if Config.Fuel == Fuel.RENEWED then
        SetVehicleFuelLevel(vehicle, defaultFuelLevel)
    end
    dbg.debug('Setting vehicle fuel via type (%s) for vehicle named %s!', fuelSystem, GetEntityArchetypeName(vehicle))
    if fuelSystem ~= "THIRD_PARTY_FUEL_RESOURCE" then
        SetVehicleFuelLevel(vehicle, defaultFuelLevel)
    end
    return true
end
