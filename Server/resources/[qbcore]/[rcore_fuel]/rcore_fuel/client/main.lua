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

if Config.EnableUnbreakableFuelPumps then
    CreateThread(function()
        while true do
            Wait(500)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for shopId, shopData in pairs(Config.ShopList) do
                if #(shopData.blipPosition - playerCoords) <= 100 then
                    for dispenserIndex, pumpData in pairs(shopData.pumpPosition) do
                        if pumpData.entity ~= nil and DoesEntityExist(pumpData.entity) then
                            SetEntityInvincible(pumpData.entity, true)
                            SetEntityProofs(pumpData.entity, true, true, true, true, true, true, true, true)
                            FreezeEntityPosition(pumpData.entity, true)
                            SetEntityCanBeDamaged(pumpData.entity, false)
                            SetEntityOnlyDamagedByPlayer(pumpData.entity, false)

                            if IsPedInAnyVehicle(playerPed, false) then
                                if not pumpData.blockEntity then
                                    SetEntityCollision(pumpData.entity, false, true)
                                    pumpData.blockEntity = CreateLocalObject(-994492850, pumpData.pos)
                                    SetPlayerInvisibleLocally(pumpData.blockEntity, true)
                                    FreezeEntityPosition(pumpData.blockEntity, true)
                                end
                            elseif pumpData.blockEntity then
                                SetEntityCollision(pumpData.entity, true, true)
                                DeleteEntity(pumpData.blockEntity)
                                pumpData.blockEntity = nil
                            end
                        end
                    end
                end
            end
        end
    end, "Setting gas station fro non explosive")
end

function BuildPumpFuelDataList(shopData, pumpData)
    local fuelDataList = {}
    local activeType = ResolvePumpFuelSelection(pumpData)

    for fuelTypeIndex, fuelTypeName in ipairs(pumpData.fuelTypeList or {}) do
        -- FIX 5: gasPrices may be nil for a new shop that has never had prices set
        local gasPrices = shopData.gasPrices or {}
        table.insert(fuelDataList, {
            name = _U(fuelTypeName),
            price = gasPrices[fuelTypeName] or 0,
            active = fuelTypeIndex == activeType,
            labelUnitFuel = _U(fuelTypeName .. "_unit"),
            fuelType = fuelTypeName,
            inStock = true,
        })

    end

    return fuelDataList
end

function TryCreatePumpScaleform(shopId, dispenserIndex, pumpData, shopData, pumpEntity)
    local fuelDataList = BuildPumpFuelDataList(shopData, pumpData)
    local uiFlipOffset, uiSquareOffset = GetOffsetsForUIFlipForDispenserPump(pumpEntity)
    local scaleformKey = "pump_" .. shopId .. "_" .. dispenserIndex

    CreateVirtualScaleform(scaleformKey, {
        ModelHash = GetEntityModel(pumpEntity),
        entity = pumpEntity,
        entityHit = pumpEntity,
        URL = "nui://rcore_fuel/html/FuelPump/index.html",
        align = pumpData.align,
    }, {
        fuelData = fuelDataList,
        dispenserIdentifier = dispenserIndex,
        identifier = shopId,
        FuelPump = true,
        FuelPumpSquares = {
            { GetOffsetFromEntityInWorldCoords(pumpEntity, uiSquareOffset) },
            { GetOffsetFromEntityInWorldCoords(pumpEntity, uiFlipOffset) },
        },
    }, GetEntityCoords(pumpEntity))
end

function DestroyPumpScaleformIfLoaded(shopId, dispenserIndex)
    local scaleformKey = "pump_" .. shopId .. "_" .. dispenserIndex
    local scaleformData = ScaleformCache[scaleformKey]

    if scaleformData and scaleformData.duiObj and scaleformData.duiLoaded then
        DestroyTV(scaleformData)
        ScaleformCache[scaleformKey] = nil
    end
end

function RefreshNearbyPumpScaleforms(playerCoords)
    for shopId, shopData in pairs(Config.ShopList) do
        if #(shopData.blipPosition - playerCoords) <= 100 then
            if shopData.tankerScaleform then
                local tankerDistance = #(shopData.tankerScaleform.pos - playerCoords)

                if tankerDistance < 15 then
                    if not shopData.tankerScaleform.entity then
                        local tankerEntity = CreateLocalObject(shopData.tankerScaleform.model, shopData.tankerScaleform.pos)
                        shopData.tankerScaleform.entity = tankerEntity
                        SetEntityHeading(tankerEntity, shopData.tankerScaleform.heading)
                        SetEntityAlpha(tankerEntity, 0, false)

                        CreateVirtualScaleform("pump_tanker_" .. tankerEntity, {
                            ModelHash = shopData.tankerScaleform.model,
                            entity = tankerEntity,
                            entityHit = tankerEntity,
                            URL = "nui://rcore_fuel/html/FuelTank/index.html",
                        }, {
                            identifier = shopId,
                            tanker = true,
                        }, shopData.tankerScaleform.pos)
                    end
                elseif shopData.tankerScaleform.entity then
                    local tankerEntity = shopData.tankerScaleform.entity
                    local scaleformKey = "pump_tanker_" .. tankerEntity
                    local scaleformData = ScaleformCache[scaleformKey]

                    if scaleformData and scaleformData.duiObj and scaleformData.duiLoaded then
                        DestroyTV(scaleformData)
                        ScaleformCache[scaleformKey] = nil
                    end

                    if tankerEntity and DoesEntityExist(tankerEntity) then
                        DeleteEntity(tankerEntity)
                    end
                    shopData.tankerScaleform.entity = nil
                end
            end

            for dispenserIndex, pumpData in pairs(shopData.pumpPosition) do
                if #(pumpData.pos - playerCoords) < math.max(15, Config.PumpDisplayDistance or 15) then
                    -- Model swaps/MLO streaming can invalidate a cached pump handle.
                    -- Clear it immediately so the supported-model resolver can bind
                    -- the replacement prop on this same refresh pass.
                    if pumpData.entity and not DoesEntityExist(pumpData.entity) then
                        DestroyPumpScaleformIfLoaded(shopId, dispenserIndex)
                        pumpData.entity = nil
                    end

                    if not pumpData.entity then
                        local pumpEntity = FindSupportedDispenserEntity(pumpData.pos, pumpData.hash, 3.0)

                        if pumpEntity ~= 0 and DoesEntityExist(pumpEntity) and GetEntityHealth(pumpEntity) ~= 0 then
                            pumpData.entity = pumpEntity
                            TryCreatePumpScaleform(shopId, dispenserIndex, pumpData, shopData, pumpEntity)
                        end
                    elseif DoesEntityExist(pumpData.entity) then
                        local pumpHealth = GetEntityHealth(pumpData.entity)

                        -- Pickup/target discovery may resolve the prop before this
                        -- thread. An entity handle does not mean its DUI exists yet.
                        local scaleformKey = "pump_" .. shopId .. "_" .. dispenserIndex
                        if pumpHealth > 0 and not ScaleformCache[scaleformKey] then
                            TryCreatePumpScaleform(shopId, dispenserIndex, pumpData, shopData, pumpData.entity)
                        end

                        if pumpHealth == 0 then
                            local scaleformKey = "pump_" .. shopId .. "_" .. dispenserIndex
                            local scaleformData = ScaleformCache[scaleformKey]

                            if scaleformData and scaleformData.distance and scaleformData.distance == 1000 then
                                pumpData.entity = FindSupportedDispenserEntity(pumpData.pos, pumpData.hash, 3.0)
                            else
                                DestroyPumpScaleformIfLoaded(shopId, dispenserIndex)
                                pumpData.entity = nil
                            end
                        end
                    end
                elseif pumpData.entity then
                    local scaleformKey = "pump_" .. shopId .. "_" .. dispenserIndex
                    local scaleformData = ScaleformCache[scaleformKey]

                    if not (scaleformData and scaleformData.distance and scaleformData.distance == 1000) then
                        DestroyPumpScaleformIfLoaded(shopId, dispenserIndex)
                        pumpData.entity = nil
                    end
                end
            end
        end
    end
end

CreateThread(function()
    Wait(250)

    while true do
        Wait(250)
        RefreshNearbyPumpScaleforms(GetEntityCoords(PlayerPedId()))
    end
end, "creating 3D render scaleform")

function RefreshFuelDispenserUtilise()
    local playerCoords = GetEntityCoords(PlayerPedId())

    for shopId, shopData in pairs(Config.ShopList) do
        if #(shopData.blipPosition - playerCoords) < 100 then
            for dispenserIndex, pumpData in pairs(shopData.pumpPosition) do
                if #(pumpData.pos - playerCoords) < 40 then
                    if pumpData.entityForAttachment and not DoesEntityExist(pumpData.entityForAttachment) then
                        pumpData.entityForAttachment = nil
                        if pumpData.pumpObjects then
                            for _, sideObjects in pairs(pumpData.pumpObjects) do
                                if sideObjects.rope and DoesEntityExist(sideObjects.rope) then DeleteEntity(sideObjects.rope) end
                                if sideObjects.holder and DoesEntityExist(sideObjects.holder) then DeleteEntity(sideObjects.holder) end
                            end
                            pumpData.pumpObjects = nil
                        end
                    end

                    if not pumpData.entityForAttachment then
                        local pumpEntity = FindSupportedDispenserEntity(pumpData.pos, pumpData.hash, 3.0)
                        if DoesEntityExist(pumpEntity) then
                            pumpData.entityForAttachment = pumpEntity
                        end
                    end

                    local attachmentEntity = pumpData.entityForAttachment

                    if DoesEntityExist(attachmentEntity) then
                        if GetEntityHealth(attachmentEntity) >= 1 and GetEntityModel(attachmentEntity) ~= 0 then
                            if not pumpData.pumpObjects then
                                pumpData.pumpObjects = {
                                    {},
                                    {},
                                }
                            end

                            if not pumpData.occupied then
                                pumpData.occupied = {}
                            end

                            for sideId = 1, 2 do
                                if not pumpData.occupied[sideId] then
                                    if not pumpData.pumpObjects[sideId].rope then
                                        local ropeEntity = CreateFuelRopeForPump(attachmentEntity, sideId)
                                        if DoesEntityExist(ropeEntity) and GetEntityModel(attachmentEntity) ~= 0 then
                                            pumpData.pumpObjects[sideId].rope = ropeEntity
                                        end
                                    end

                                    if not pumpData.pumpObjects[sideId].holder then
                                        local holderEntity = CreateFuelHolderForPump(attachmentEntity, sideId)
                                        if DoesEntityExist(holderEntity) and GetEntityModel(attachmentEntity) ~= 0 then
                                            pumpData.pumpObjects[sideId].holder = holderEntity
                                        end
                                    end
                                else
                                    local ropeEntity = pumpData.pumpObjects[sideId].rope
                                    if ropeEntity then
                                        DeleteEntity(ropeEntity)
                                    end
                                    pumpData.pumpObjects[sideId].rope = nil
                                end
                            end
                        else
                            pumpData.entityForAttachment = nil
                            if pumpData.pumpObjects then
                                for _, sideObjects in pairs(pumpData.pumpObjects) do
                                    if sideObjects.rope and DoesEntityExist(sideObjects.rope) then DeleteEntity(sideObjects.rope) end
                                    if sideObjects.holder and DoesEntityExist(sideObjects.holder) then DeleteEntity(sideObjects.holder) end
                                end
                                pumpData.pumpObjects = nil
                            end
                        end
                    else
                        pumpData.entityForAttachment = nil
                        if pumpData.pumpObjects then
                            for _, sideObjects in pairs(pumpData.pumpObjects) do
                                DeleteEntity(sideObjects.rope)
                                DeleteEntity(sideObjects.holder)
                            end
                            pumpData.pumpObjects = nil
                        end
                    end
                else
                    pumpData.entityForAttachment = nil
                    if pumpData.pumpObjects then
                        for _, sideObjects in pairs(pumpData.pumpObjects) do
                            DeleteEntity(sideObjects.rope)
                            DeleteEntity(sideObjects.holder)
                        end
                        pumpData.pumpObjects = nil
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(250)
        RefreshFuelDispenserUtilise()
    end
end, "Creating dispenser guns etc for fuelPumps")

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, shopData in pairs(Config.ShopList) do
        if shopData.tankerScaleform and shopData.tankerScaleform.entity then
            DeleteEntity(shopData.tankerScaleform.entity)
        end
    end

    for _, shopData in pairs(Config.ShopList) do
        for _, pumpData in pairs(shopData.pumpPosition) do
            if pumpData.blockEntity then
                DeleteEntity(pumpData.blockEntity)
            end

            if pumpData.pumpObjects then
                for _, sideObjects in pairs(pumpData.pumpObjects) do
                    DeleteEntity(sideObjects.rope)
                    DeleteEntity(sideObjects.holder)
                end
                pumpData.pumpObjects = nil
            end
        end
    end
end)

CreateThread(function()
    local lastVehicleTryingToEnter = 0

    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        local vehicleTryingToEnter = GetVehiclePedIsTryingToEnter(playerPed)

        if vehicleTryingToEnter ~= lastVehicleTryingToEnter and vehicleTryingToEnter ~= 0 then
            lastVehicleTryingToEnter = vehicleTryingToEnter
            TriggerEvent("rcore_fuel:playerIsTryingToEnterVehicle", vehicleTryingToEnter)
        end

        if vehicleTryingToEnter == 0 then
            lastVehicleTryingToEnter = 0
        end
    end
end, "trying to enter vehicle thread event")

CreateThread(function()
    local wasInVehicle = false
    local lastExitedVehicle = nil

    while true do
        Wait(300)
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            if wasInVehicle then
                lastExitedVehicle = GetVehiclePedIsIn(playerPed, false)
                wasInVehicle = false
            end
        else
            if lastExitedVehicle then
                TriggerEvent("rcore_fuel:playerIsExitingVehicle", lastExitedVehicle)
                lastExitedVehicle = nil
            end
            wasInVehicle = true
        end
    end
end, "player exit vehicle event")

-- FIX 1: this whole block duplicated client/payment.lua exactly (same event,
-- same NUI callback, same logic) -- removed here since payment.lua is the
-- dedicated home for it. The duplication meant rcore_fuel:payForFuel fired
-- twice per payment (harmless only because the server already guards against
-- double-processing by nil-ing the session on the first call) and every
-- payment-modal NUI message was sent twice.

RegisterKey(function()
    TriggerEvent("rcore_fuel:sendKeyCode", "E")
end, "key_event_for_mission_fuel_e", "", "E")

for shopId, shopData in pairs(Config.ShopList) do
    for dispenserIndex, pumpData in pairs(shopData.pumpPosition) do
        pumpData.source = {}
        pumpData.occupied = {}
    end
end
