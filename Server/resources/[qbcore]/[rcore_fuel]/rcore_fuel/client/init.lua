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

SharedObject = GetSharedObject()
ExistingFuelingOffsetVehicles = {}
local _clientNonce = "5076c59ea539de616e0e398f08bab4ac"

if Config.WorkAroundForQBCoreLoadedEvent then
    OnObjectLoaded(function()
        while true do
            Wait(1000)
            if SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData then
                local playerData = SharedObject.Functions.GetPlayerData()
                if playerData and playerData.citizenid then
                    TriggerServerEvent("rcore_fuel:playerLoadedCitizenId", playerData.citizenid)
                    return
                end
            end
        end
    end)
end

RegisterNetEvent("rcore_fuel:updateConfig", function(configChanges)
    if not configChanges or type(configChanges) ~= "table" then return end
    for shopId, shopFields in pairs(configChanges) do
        if not Config.ShopList[shopId] then
            Config.ShopList[shopId] = {}
        end
        if type(shopFields) == "table" then
            for fieldName, fieldValue in pairs(shopFields) do
                Config.ShopList[shopId][fieldName] = fieldValue
            end
        end
        RemoveScaleformPumpDataByIdentifier(shopId)
    end
    RefreshAllScaleformData()
    TriggerEvent("rcore_fuel:dataUpdated")
end)

RegisterNetEvent("rcore_fuel:forceRefreshScaleform", function()
    if GetCurrentPumpIdentifier() then
        return
    end

    for scaleformKey, scaleformData in pairs(ScaleformCache) do
        if scaleformData.scaleformLoaded then
            RemoveScaleformPumpDataByIdentifier(scaleformKey)
        else
            local shopData = Config.ShopList and Config.ShopList[scaleformData.identifier]
            if shopData and shopData.pumpPosition then
                for dispenserIndex, pumpData in pairs(shopData.pumpPosition) do
                    if #(scaleformData.entityPos - pumpData.pos) < 1 then
                        local fuelDataList = BuildPumpFuelDataList(shopData, pumpData)

                        scaleformData.fuelData = fuelDataList
                    end
                end
            end
        end
    end
end)

RegisterNUICallback("exit", function(data, callback)
    SetNuiFocus(false, false)
    if callback then
        callback("ok")
    end
end)

RegisterNUICallback("init_main", function(data, callback)
    SendNUIMessage({
        type = "locales_main",
        locales = {
            cash = _U("cash"),
            bank = _U("bank"),
            select_payment_method = _U("select_payment_method"),
            close_button = _U("close_button"),
            truck_hose_title = _U("truck_hose_title"),
            truck_hose_part_1 = _U("truck_hose_part_1"),
            truck_hose_part_2 = _U("truck_hose_part_2"),
            truck_hose_part_3 = _U("truck_hose_part_3"),
        },
    })

    if callback then
        callback("ok")
    end
end)

CreateThread(function()
    TriggerServerEvent("rcore_fuel:requestConfigChanges")
end, "fetch cache")

-- Legacy compat: falls back to the old "...ReserveConsumption" key name if someone's
-- config still uses it (harmless no-op on a stock config -- that key was never shipped)
if Config.ForceSpecificClassToUseReverseConsumption == nil then
    Config.ForceSpecificClassToUseReverseConsumption = Config.ForceSpecificClassToUseReserveConsumption
end

if Config.ForceSpecificVehicleModelToUseReverseConsumption == nil then
    Config.ForceSpecificVehicleModelToUseReverseConsumption = Config.ForceSpecificVehicleModelToUseReserveConsumption
end

if Config.IgnoreSpecificVehicleModelToUseReverseConsumption == nil then
    Config.IgnoreSpecificVehicleModelToUseReverseConsumption = Config.IgnoreSpecificVehicleModelToUseReserveConsumption
end

function ConvertClientConfigTables()
    if Config.HideHud == nil then
        Config.HideHud = true
    end

    for shopId, shopData in pairs(Config.ShopList) do
        if shopData.objectSpawner then
            for _, spawnObject in pairs(shopData.objectSpawner) do
                table.insert(Config.SpawnObject, spawnObject)
            end
        end
        if shopData.tipTruckSpawnPosition then
            Config.SpawnTipTruckSpawnPositions[shopId] = shopData.tipTruckSpawnPosition
        end
        if shopData.tankerTapPosition then
            shopData.tankerTapPosition.model = "prop_roofpipe_01"
            Config.FinalFuelPipe[shopId] = shopData.tankerTapPosition
        end
        Config.TankerShopPosition[shopId] = shopData.tankerScaleform.missionBlipPosition
    end
    local customFuelCapacitySource = DeepCopy(Config.CustomFuelCapacity)
    Config.CustomFuelCapacity = {}
    for _, capacityEntry in pairs(customFuelCapacitySource) do
        local modelHash = capacityEntry.model
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.CustomFuelCapacity[modelHash] = { maxFuel = capacityEntry.maxFuel }
    end

    local denyFuelingSource = DeepCopy(Config.DenyFuelingFromTypeFuelForTypeFuel)
    Config.DenyFuelingFromTypeFuelForTypeFuel = {}
    for sourceFuelType, deniedTargets in pairs(denyFuelingSource) do
        Config.DenyFuelingFromTypeFuelForTypeFuel[sourceFuelType] = {}
        for _, deniedFuelType in pairs(deniedTargets) do
            Config.DenyFuelingFromTypeFuelForTypeFuel[sourceFuelType][deniedFuelType] = true
        end
    end

    local nonLiquidFuelTypesSource = DeepCopy(Config.NonLiquidFueLTypes)
    Config.NonLiquidFueLTypes = {}
    for _, fuelType in pairs(nonLiquidFuelTypesSource) do
        Config.NonLiquidFueLTypes[fuelType] = true
    end

    local wltpModifierSource = DeepCopy(Config.VehicleModelWLTPModifier)
    Config.VehicleModelWLTPModifier = {}
    for _, modifierEntry in pairs(wltpModifierSource) do
        local modelHash = modifierEntry.model
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.VehicleModelWLTPModifier[modelHash] = modifierEntry.modifier
    end

    local vehicleFuelTypeSource = DeepCopy(Config.VehicleFuelType)
    Config.VehicleFuelType = {}
    for _, fuelTypeEntry in pairs(vehicleFuelTypeSource) do
        local modelHash = fuelTypeEntry.model
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.VehicleFuelType[modelHash] = fuelTypeEntry.fuelType
    end

    local skipMissionSource = DeepCopy(Config.SkipMissionForFuelType)
    Config.SkipMissionForFuelType = {}
    for _, fuelType in pairs(skipMissionSource) do
        Config.SkipMissionForFuelType[fuelType] = true
    end

    local disableFuelFeatureSource = DeepCopy(Config.DisableFuelFeatureForModel)
    Config.DisableFuelFeatureForModel = {}
    for _, modelName in pairs(disableFuelFeatureSource) do
        Config.DisableFuelFeatureForModel[GetHashKey(modelName)] = true
    end

    local whitelistFuelFeatureSource = DeepCopy(Config.WhitelistFuelFeatureForModel)
    Config.WhitelistFuelFeatureForModel = {}
    for _, modelName in pairs(whitelistFuelFeatureSource) do
        Config.WhitelistFuelFeatureForModel[GetHashKey(modelName)] = true
    end

    local weatherConsumptionSource = DeepCopy(Config.FuelConsumptionPerWeatherType)
    Config.FuelConsumptionPerWeatherType = {}
    for weatherKey, consumptionValue in pairs(weatherConsumptionSource) do
        local key = weatherKey
        if type(key) == "string" then
            key = GetHashKey(key)
        end
        Config.FuelConsumptionPerWeatherType[key] = consumptionValue
    end

    local fuelConsumptionSource = DeepCopy(Config.FuelConsumption)
    Config.FuelConsumption = {}
    Config.FuelConsumption.max = fuelConsumptionSource.max
    Config.FuelConsumption.min = fuelConsumptionSource.min
    Config.FuelConsumption.CustomPerTerrarian = fuelConsumptionSource.CustomPerTerrarian
    Config.FuelConsumption.CustomPerModel = {}
    Config.FuelConsumption.CustomPerFuelType = {}
    for _, modelConsumption in pairs(fuelConsumptionSource.CustomPerModel) do
        local modelHash = modelConsumption.model
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.FuelConsumption.CustomPerModel[modelHash] = modelConsumption
    end
    for _, fuelTypeConsumption in pairs(fuelConsumptionSource.CustomPerFuelType) do
        Config.FuelConsumption.CustomPerFuelType[fuelTypeConsumption.fuelType] = fuelTypeConsumption
    end

    for pipeId, pipeData in pairs(Config.FinalFuelPipe) do
        Config.SpawnObject[pipeId] = pipeData
    end

    local forceReverseConsumptionSource = DeepCopy(Config.ForceSpecificVehicleModelToUseReverseConsumption)
    Config.ForceSpecificVehicleModelToUseReverseConsumption = {}
    for _, modelName in pairs(forceReverseConsumptionSource) do
        local modelHash = modelName
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.ForceSpecificVehicleModelToUseReverseConsumption[modelHash] = true
    end

    local ignoreReverseConsumptionSource = DeepCopy(Config.IgnoreSpecificVehicleModelToUseReverseConsumption)
    Config.IgnoreSpecificVehicleModelToUseReverseConsumption = {}
    for _, modelName in pairs(ignoreReverseConsumptionSource) do
        local modelHash = modelName
        if type(modelHash) == "string" then
            modelHash = GetHashKey(modelHash)
        end
        Config.IgnoreSpecificVehicleModelToUseReverseConsumption[modelHash] = true
    end

    local forceReverseClassSource = DeepCopy(Config.ForceSpecificClassToUseReverseConsumption)
    Config.ForceSpecificClassToUseReverseConsumption = {}
    for _, vehicleClass in pairs(forceReverseClassSource) do
        Config.ForceSpecificClassToUseReverseConsumption[vehicleClass] = true
    end

    local jerrycanAllowedSource = DeepCopy(Config.JerrycanRefuelingAllowedForSpecificTypes)
    Config.JerrycanRefuelingAllowedForSpecificTypes = {}
    for _, fuelType in pairs(jerrycanAllowedSource) do
        Config.JerrycanRefuelingAllowedForSpecificTypes[fuelType] = true
    end

    local supportedPumpSource = DeepCopy(Config.SupportedGasPumpModel)
    Config.SupportedGasPumpModel = {}
    for _, pumpModel in pairs(supportedPumpSource) do
        Config.SupportedGasPumpModel[pumpModel.modelHash] = pumpModel
    end
end

CreateThread(function()
  ConvertClientConfigTables()
end, "converting config tables")

function LoadFuelingOffsetData()
    local offsetJson = LoadResourceFile(GetCurrentResourceName(), "fueling_offset.json") or "{}"
    local offsetData = json.decode(offsetJson)

    for modelKey, offsetEntry in pairs(offsetData) do
        ExistingFuelingOffsetVehicles[tonumber(modelKey)] = offsetEntry
    end

    for _, offsetConfig in pairs(Config.CustomOffsetForFuelingVehicle) do
        ExistingFuelingOffsetVehicles[GetHashKey(offsetConfig.model)] = {
            offset = offsetConfig.offset,
            heading = offsetConfig.heading,
        }
    end
end

CreateThread(function()
  LoadFuelingOffsetData()
end, "loading all offsets")

CreateThread(function()
    while true do
        Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, replaceObject in pairs(Config.ReplaceObjects) do
            local distanceToObject = #(replaceObject.pos - playerCoords)

            if distanceToObject < 15 then
                if not replaceObject.swapped then
                    local closestEntity = GetClosestObjectOfType(
                        replaceObject.pos, 3.0, replaceObject.originalModelHash, false, false, false
                    )

                    if closestEntity == 0 then
                        closestEntity = GetClosestObjectOfType(
                            replaceObject.pos, 3.0, replaceObject.newModelHash, false, false, false
                        )
                    end

                    if GetEntityModel(closestEntity) == replaceObject.newModelHash then
                        replaceObject.swapped = true
                    elseif closestEntity ~= 0 and DoesEntityExist(closestEntity) then
                        CreateModelSwap(
                            replaceObject.pos.x,
                            replaceObject.pos.y,
                            replaceObject.pos.z,
                            replaceObject.radius,
                            replaceObject.originalModelHash,
                            replaceObject.newModelHash,
                            true
                        )
                    end
                end
            else
                replaceObject.swapped = nil
            end
        end
    end
end, "CreateModelSwap")

function BuildGasPumpCameraOffset()
    return {
        x = 0.0,
        y = -3.0,
        z = 0.35,
        rotationOffset = vec3(0.0, 0.0, 0.0),
    }
end

function BuildGasPumpResolution(screenSize, screenOffsets)
    return {
        distance = 5,
        ScreenSize = screenSize,
        CameraOffSet = BuildGasPumpCameraOffset(),
        ScreenOffSet = screenOffsets,
    }
end

function InitDefaultPumpResolutions()
    local defaultResolutions = {}

    local standardGasScreen = vec3(0.018495, 0.00608, 0.0)
    local standardGasOffsets = {
        [AlignTypes.LEFT] = vec3(-1.85244, -0.037835, 2.0523),
        [AlignTypes.RIGHT] = vec3(0.7, -0.037835, 2.0523),
        [AlignTypes.MIDDLE] = vec3(-0.55, 0.0, 3.2),
    }
    for _, modelName in ipairs({
        'prop_gas_pump_1b', 'prop_gas_pump_1c', 'prop_gas_pump_1a', 'prop_gas_pump_1d',
    }) do
        defaultResolutions[GetHashKey(modelName)] = BuildGasPumpResolution(standardGasScreen, standardGasOffsets)
    end

    defaultResolutions[GetHashKey('prop_vintage_pump')] = BuildGasPumpResolution(
        vec3(0.00352, 0.00096, 0.0),
        {
            [AlignTypes.MIDDLE] = vec3(-0.393465, 0.0, 2.40655),
            [AlignTypes.LEFT] = vec3(-1.2, 0.0, 1.7),
            [AlignTypes.RIGHT] = vec3(0.4, 0.0, 1.7),
        }
    )

    defaultResolutions[GetHashKey('prop_gas_pump_old2_rc')] = BuildGasPumpResolution(
        vec3(0.010495, 0.00308, 0.0),
        {
            [AlignTypes.MIDDLE] = vec3(-0.47, 0.0, 2.3),
            [AlignTypes.LEFT] = vec3(-1.5, 0.0, 1.7),
            [AlignTypes.RIGHT] = vec3(0.6, 0.0, 1.7),
        }
    )

    defaultResolutions[GetHashKey('rcore_electric_charger_a')] = BuildGasPumpResolution(
        vec3(0.0395, 0.0205, 0.0),
        {
            [AlignTypes.MIDDLE] = vec3(-0.55, 0.0, 1.8),
            [AlignTypes.LEFT] = vec3(-1.522, 0.0, 0.847),
            [AlignTypes.RIGHT] = vec3(0.522, 0.0, 0.847),
        }
    )

    defaultResolutions[486135101] = BuildGasPumpResolution(standardGasScreen, standardGasOffsets)

    defaultResolutions[GetHashKey('prop_tv_flat_02')] = {
        distance = 5,
        ScreenSize = vec3(-0.002965, -0.009885, 0.0),
        CameraOffSet = {
            x = 0.0,
            y = -3.0,
            z = 0.35,
            rotationOffset = vec3(0.0, 0.0, 0.0),
        },
        ScreenOffSet = vec3(-0.6, -0.01, 0.5),
    }

    if not Config.resolution then
        Config.resolution = {}
    end

    for modelHash, resolutionData in pairs(defaultResolutions) do
        if not Config.resolution[modelHash] then
            Config.resolution[modelHash] = resolutionData
        end
    end
end

CreateThread(function()
  Wait(2000)
  InitDefaultPumpResolutions()
end, "Using default values for resolution if it doesnt exists after x seconds")

DecorRegister(DecorEnum.FUEL, 1)
DecorRegister(DecorEnum.MILEAGE, 1)
DecorRegister(DecorEnum.WRONG_FUEL, 2)

if DecorIsRegisteredAsType(DecorEnum.FUEL, 1) == false or Config.EnableStateBagsOnly then
decorStateCache = {}

function DecorGetBool(entity, decorKey)
    local entityState = Entity(entity).state
    if entityState[decorKey] ~= nil then
        if not decorStateCache[entity] then
            decorStateCache[entity] = {}
            decorStateCache[entity][decorKey] = entityState[decorKey]
        end
    end

    if decorStateCache[entity] and decorStateCache[entity][decorKey] == true then
        return true
    end

    return false
end

function DecorGetInt(entity, decorKey)
    local entityState = Entity(entity).state
    if entityState[decorKey] ~= nil then
        if not decorStateCache[entity] then
            decorStateCache[entity] = {}
            decorStateCache[entity][decorKey] = entityState[decorKey] or 0
        end
    end

    if decorStateCache[entity] and decorStateCache[entity][decorKey] then
        return decorStateCache[entity][decorKey]
    end

    return 0
end

function DecorGetTime(entity, decorKey)
    local entityState = Entity(entity).state
    if entityState[decorKey] ~= nil then
        if not decorStateCache[entity] then
            decorStateCache[entity] = {}
            decorStateCache[entity][decorKey] = entityState[decorKey] or 0
        end
    end

    if decorStateCache[entity] and decorStateCache[entity][decorKey] then
        return decorStateCache[entity][decorKey]
    end

    return os.time()
end

function DecorGetFloat(entity, decorKey)
    local entityState = Entity(entity).state
    if entityState[decorKey] ~= nil then
        if not decorStateCache[entity] then
            decorStateCache[entity] = {}
            decorStateCache[entity][decorKey] = entityState[decorKey] or 0.0
        end
    end

    if decorStateCache[entity] and decorStateCache[entity][decorKey] then
        return decorStateCache[entity][decorKey]
    end

    return 0.0
end

function DecorSetBool(entity, decorKey, value)
    if entity == nil then
        return
    end

    if not decorStateCache[entity] then
        decorStateCache[entity] = {}
    end

    decorStateCache[entity][decorKey] = value
end

function DecorSetInt(entity, decorKey, value)
    if not decorStateCache[entity] then
        decorStateCache[entity] = {}
    end

    decorStateCache[entity][decorKey] = tonumber(value) or 0
end

function DecorSetTime(entity, decorKey, value)
    if not decorStateCache[entity] then
        decorStateCache[entity] = {}
    end

    decorStateCache[entity][decorKey] = tonumber(value) or os.time()
end

function DecorSetFloat(entity, decorKey, value)
    if not decorStateCache[entity] then
        decorStateCache[entity] = {}
    end

    decorStateCache[entity][decorKey] = (tonumber(value) or 0) + 0.0
end

function DecorRemove(entity, decorKey)
    Entity(entity).state:set(decorKey, nil, true)

    if decorStateCache[entity] then
        decorStateCache[entity][decorKey] = nil
    end
end

function DecorExistOn(entity, decorKey)
    if not entity then
        return
    end

    local entityState = Entity(entity).state
    if entityState[decorKey] ~= nil then
        return entityState[decorKey] and true or false
    end

    if decorStateCache[entity] and decorStateCache[entity][decorKey] then
        return true
    end

    return false
end

CreateThread(function()
    local lastSyncedDecorValues = {}

    while true do
        Wait(4000)

        for entity, decorValues in pairs(decorStateCache) do
            if DoesEntityExist(entity) then
                for decorKey, decorValue in pairs(decorValues) do
                    if not lastSyncedDecorValues[entity] then
                        lastSyncedDecorValues[entity] = {}
                    end

                    if lastSyncedDecorValues[entity][decorKey] ~= decorValue then
                        Entity(entity).state:set(decorKey, decorValue, true)
                        lastSyncedDecorValues[entity][decorKey] = decorValue
                    end
                end
            else
                decorStateCache[entity] = nil
            end
        end
    end
end, "sync statebag fuel from non existing decors")

function handleStateBagChange(stateKey, valueType)
    AddStateBagChangeHandler(stateKey, nil, function(bagName, key, value)
        local entity = GetEntityFromStateBagName(bagName)
        if entity == 0 then
            return
        end

        if not decorStateCache[entity] then
            decorStateCache[entity] = {}
        end

        if valueType == "bool" then
            decorStateCache[entity][stateKey] = value == true
        elseif valueType == "float" then
            decorStateCache[entity][stateKey] = (tonumber(value) or 0) + 0.0
        elseif valueType == "number" then
            decorStateCache[entity][stateKey] = tonumber(value) or 0
        else
            decorStateCache[entity][stateKey] = value
        end
    end)
end

handleStateBagChange(DecorEnum.WRONG_FUEL, "bool")
handleStateBagChange(DecorEnum.MILEAGE, "float")
handleStateBagChange(DecorEnum.FUEL, "number")
end

-- Wrong-fuel state can come from either the original GTA decorator system or
-- the authoritative replicated server state bag. Check both so pump-out and
-- engine-failure behavior remains consistent regardless of entity ownership.
function VehicleHasWrongFuel(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return false
    end

    local entityState = Entity(vehicle).state
    if entityState and entityState[DecorEnum.WRONG_FUEL] == true then
        return true
    end

    if DecorExistOn(vehicle, DecorEnum.WRONG_FUEL) then
        return DecorGetBool(vehicle, DecorEnum.WRONG_FUEL) == true
    end

    return false
end
