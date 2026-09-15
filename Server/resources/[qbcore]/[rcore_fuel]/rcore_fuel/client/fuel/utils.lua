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

VehicleModelTypeChecks = {
    AmphibiousQuadbike = { IsThisModelAnAmphibiousQuadbike, VehicleTypes.AMPHIBIOUS_QUAD_BIKE },
    AmphibiousCar = { IsThisModelAnAmphibiousCar, VehicleTypes.AMPHIBIOUS_CAR },
    Train = { IsThisModelATrain, VehicleTypes.TRAIN },
    QuadBike = { IsThisModelAQuadbike, VehicleTypes.QUAD_BIKE },
    Plane = { IsThisModelAPlane, VehicleTypes.PLANE },
    Jetski = { IsThisModelAJetski, VehicleTypes.JETSKI },
    Heli = { IsThisModelAHeli, VehicleTypes.HELI },
    Car = { IsThisModelACar, VehicleTypes.CAR },
    Boat = { IsThisModelABoat, VehicleTypes.BOAT },
    Bike = { IsThisModelABike, VehicleTypes.BIKE },
    Bicycle = { IsThisModelABicycle, VehicleTypes.BICYCLE },
}

function GetVehicleType(modelHash)
    for _, typeCheck in pairs(VehicleModelTypeChecks) do
        if typeCheck[1](modelHash) then
            return typeCheck[2]
        end
    end

    return nil
end

function IsVehicleModelEnabledForFueling(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return false
    end

    local modelHash = GetEntityModel(vehicle)

    if Config.WhitelistFuelFeatureForModel[modelHash] then
        return true
    end

    if Config.DisableFuelFeatureForModel[modelHash] then
        return false
    end

    for typeName, typeCheck in pairs(VehicleModelTypeChecks) do
        if not Config.IsVehicleTypeAllowed[typeName] and typeCheck[1](modelHash) then
            return false
        end
    end

    return true
end

function GetVehicleFuelModifier(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 1.0, 0
    end

    local vehicleClass = GetVehicleClass(vehicle)
    local fuelType = GetVehicleFuelType(GetEntityModel(vehicle))
    local modifier = Config.VehicleClassWLTPModifier[vehicleClass] or 1.0

    if Config.VehicleClassWLTPModifierPerFuelType and Config.VehicleClassWLTPModifierPerFuelType[fuelType] then
        local perFuelModifier = tonumber(Config.VehicleClassWLTPModifierPerFuelType[fuelType][vehicleClass])
        if perFuelModifier then
            modifier = perFuelModifier
        end
    end

    local vehicleModel = GetEntityModel(vehicle)
    if Config.VehicleModelWLTPModifier[vehicleModel] then
        modifier = Config.VehicleModelWLTPModifier[vehicleModel]
    end

    return modifier, vehicleClass
end

function DetermineFuelConsumption(vehicleClass, vehicleModel, minConsumption, maxConsumption)
    local useReverse = Config.ForceSpecificClassToUseReverseConsumption[vehicleClass]
        or Config.ForceSpecificVehicleModelToUseReverseConsumption[vehicleModel]
    local ignoreReverse = Config.IgnoreSpecificVehicleModelToUseReverseConsumption[vehicleModel]

    if useReverse and not ignoreReverse then
        return minConsumption, minConsumption - maxConsumption
    end

    return maxConsumption, maxConsumption - minConsumption
end

function CalculateFuelConsumptionRate(vehicle, consumptionOptions)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 1.0
    end

    local fuelModifier, vehicleClass = GetVehicleFuelModifier(vehicle)
    local minConsumption = Config.FuelConsumption.min
    local maxConsumption = Config.FuelConsumption.max
    local speedKmh = GetEntitySpeed(vehicle) * 3.6
    local vehicleCoords = GetEntityCoords(vehicle)
    local speedMultiplier = 0
    local vehicleModel = GetEntityModel(vehicle)
    local fuelType = GetVehicleFuelType(vehicleModel)
    local consumptionProfile = Config.FuelConsumption.CustomPerModel[vehicleModel]
        or Config.FuelConsumption.CustomPerFuelType[fuelType]

    if consumptionProfile then
        minConsumption = consumptionProfile.min
        maxConsumption = consumptionProfile.max
    end

    local hit, _, _, _, _, surfaceMaterial = CastRayCast(
        vehicleCoords,
        vehicleCoords - vector3(0, 0, 10),
        4294967295,
        vehicle
    )

    if hit == 1 then
        local terrainConsumption = Config.FuelConsumption.CustomPerTerrarian[GetMaterialType(surfaceMaterial)]

        if consumptionProfile and consumptionProfile.CustomPerTerrarian then
            terrainConsumption = consumptionProfile.CustomPerTerrarian[GetMaterialType(surfaceMaterial)]
        end

        if terrainConsumption then
            minConsumption = terrainConsumption.min
            maxConsumption = terrainConsumption.max
        end
    end

    if speedKmh >= Config.MinimumSpeedForIncreasingFuelConsumption then
        speedMultiplier = (speedKmh / Config.MinimumSpeedForIncreasingFuelConsumption) - 1.0
    end

    if speedKmh >= Config.SpeedLimitCapForMinFuelTake then
        speedKmh = Config.SpeedLimitCapForMinFuelTake
    end

    if consumptionOptions then
        if consumptionOptions.forceMinimum then
            speedKmh = Config.SpeedLimitCapForMinFuelTake
        end

        if consumptionOptions.forceMaximum then
            speedKmh = 0
        end

        if consumptionOptions.ignoreSpeed then
            speedMultiplier = 0.0
        end
    end

    minConsumption = minConsumption * fuelModifier
    maxConsumption = maxConsumption * fuelModifier

    local baseConsumption, consumptionRange = DetermineFuelConsumption(
        vehicleClass,
        vehicleModel,
        minConsumption,
        maxConsumption
    )
    local speedBasedConsumption = maxConsumption * speedMultiplier
    local weatherConsumption = Config.FuelConsumptionPerWeatherType[GetPrevWeatherTypeHashName()] or 0
    local speedRatio = speedKmh / Config.SpeedLimitCapForMinFuelTake

    return baseConsumption - (consumptionRange * speedRatio) + weatherConsumption + speedBasedConsumption
end

function GetVehicleFuelConsumptionEfficiency(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 50.0
    end

    local currentRate = CalculateFuelConsumptionRate(vehicle, nil)
    local maxRate = CalculateFuelConsumptionRate(vehicle, {
        forceMaximum = true,
        ignoreSpeed = true,
    })
    local minRate = CalculateFuelConsumptionRate(vehicle, {
        forceMinimum = true,
        ignoreSpeed = true,
    })

    local range = minRate - maxRate
    if math.abs(range) < 0.0001 then
        return 50.0
    end

    local efficiency = ((currentRate - maxRate) / range) * 100

    if efficiency > 100 then
        efficiency = 100 - (efficiency - 100)
    end

    if efficiency < 20 then
        efficiency = 20
    end

    return efficiency
end

exports("GetVehicleFuelConsumptionEfficiency", GetVehicleFuelConsumptionEfficiency)

function GetVehicleMaxCurrentDrivingRange(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 0.0
    end

    local consumptionRate = CalculateFuelConsumptionRate(vehicle)
    if not consumptionRate or consumptionRate <= 0.0001 then
        return 0.0
    end

    local fuelLiters = GetVehicleFuelLiters(vehicle)

    return (fuelLiters / consumptionRate) * (Config.ConsumptionWLTP or 10)
end

exports("GetVehicleMaxCurrentDrivingRange", GetVehicleMaxCurrentDrivingRange)

function GetMaximumFuelCapacityForVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return Config.MaxFuel or 65.0
    end

    local modelHash = GetEntityModel(vehicle)
    local customCapacity = Config.CustomFuelCapacity[modelHash]

    if customCapacity then
        return customCapacity.maxFuel
    end

    local vehicleClass = GetVehicleClass(vehicle)

    if Config.AverageFuelTankSizePerFuelType then
        local capacityByClass = Config.AverageFuelTankSizePerFuelType[GetVehicleFuelType(modelHash)]
        local perFuelCapacity = capacityByClass and tonumber(capacityByClass[vehicleClass])
        if perFuelCapacity then
            return perFuelCapacity
        end
    end

    local classCapacity = Config.VehicleClassAverageFuelTankSize and tonumber(Config.VehicleClassAverageFuelTankSize[vehicleClass])
    if classCapacity then
        return classCapacity
    end

    return tonumber(Config.MaxFuel) or 65.0
end

exports("GetMaximumFuelCapacityForVehicle", GetMaximumFuelCapacityForVehicle)

function GetVehicleFuelPercentage(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        if IsPlayerInVehicle and IsPlayerInVehicle() then
            vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        end
    end

    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 0.0
    end

    if not DecorExistOn(vehicle, DecorEnum.FUEL) then
        SetVehicleFuel(vehicle, 30.0 + math.random(70))
    end

    local fuelPercentage = DecorGetFloat(vehicle, DecorEnum.FUEL)
    if not fuelPercentage or fuelPercentage <= 0 then
        fuelPercentage = GetVehicleFuelLevel(vehicle)
    end

    return fuelPercentage or 0.0
end

exports("GetVehicleFuelPercentage", GetVehicleFuelPercentage)

function GetVehicleFuelLiters(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        if IsPlayerInVehicle and IsPlayerInVehicle() then
            vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        end
    end

    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return 0.0
    end

    -- If called by a HUD (like tuff-hud), HUD gauges expect percentage (0-100), not raw liter capacity
    local invoking = GetInvokingResource()
    if invoking and (invoking == "tuff-hud" or string.find(invoking, "hud")) then
        return GetVehicleFuelPercentage(vehicle)
    end

    if not DecorExistOn(vehicle, DecorEnum.FUEL) then
        SetVehicleFuel(vehicle, 30.0 + math.random(70))
    end

    local maxCapacity = GetMaximumFuelCapacityForVehicle(vehicle)
    local fuelPercentage = DecorGetFloat(vehicle, DecorEnum.FUEL)

    if not fuelPercentage or fuelPercentage <= 0 then
        fuelPercentage = GetVehicleFuelLevel(vehicle)
    end

    return (maxCapacity or Config.MaxFuel or 65.0) * ((fuelPercentage or 0.0) / 100)
end

exports("GetVehicleFuelLiters", GetVehicleFuelLiters)

function AddVehicleFuelLiter(vehicle, liters)
    local maxCapacity = GetMaximumFuelCapacityForVehicle(vehicle)
    if not maxCapacity or maxCapacity <= 0 then maxCapacity = 65.0 end
    local currentLiters = GetVehicleFuelLiters(vehicle)
    SetVehicleFuel(vehicle, ((currentLiters + liters) / maxCapacity) * 100)
end

exports("AddVehicleFuelLiter", AddVehicleFuelLiter)

function RemoveVehicleFuelLiter(vehicle, liters)
    local maxCapacity = GetMaximumFuelCapacityForVehicle(vehicle)
    if not maxCapacity or maxCapacity <= 0 then maxCapacity = 65.0 end
    local currentLiters = GetVehicleFuelLiters(vehicle)
    SetVehicleFuel(vehicle, ((currentLiters - liters) / maxCapacity) * 100)
end

exports("RemoveVehicleFuelLiter", RemoveVehicleFuelLiter)

function AddVehicleFuelPercentage(vehicle, percentage)
    SetVehicleFuel(vehicle, GetVehicleFuelPercentage(vehicle) + percentage)
end

exports("AddVehicleFuelPercentage", AddVehicleFuelPercentage)

function RemoveVehicleFuelPercentage(vehicle, percentage)
    SetVehicleFuel(vehicle, GetVehicleFuelPercentage(vehicle) - percentage)
end

exports("RemoveVehicleFuelPercentage", RemoveVehicleFuelPercentage)

function IsVehicleFull(vehicle)
    return GetVehicleFuelPercentage(vehicle) >= 100.0
end

function SetVehicleFuel(vehicle, fuelPercentage)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return
    end

    fuelPercentage = (fuelPercentage or 0.0) + 0.0

    -- Guard against NaN (in IEEE-754 floating point, NaN ~= NaN evaluates to true)
    if fuelPercentage ~= fuelPercentage then
        fuelPercentage = 0.0
    end

    if fuelPercentage <= 0 then
        fuelPercentage = 0.0
    end

    if fuelPercentage >= 100.0 then
        fuelPercentage = 100.0
    end

    SetVehicleFuelLevel(vehicle, fuelPercentage)

    if NetworkGetEntityIsNetworked(vehicle) then
        Entity(vehicle).state:set("fuel", fuelPercentage, true)
    end

    if Config.EnableStateBagsForOxFuel and SetInformationAboutFuelLevel then
        SetInformationAboutFuelLevel(vehicle, fuelPercentage)
    end

    DecorSetFloat(vehicle, DecorEnum.FUEL, fuelPercentage)
end

exports("SetVehicleFuel", SetVehicleFuel)
