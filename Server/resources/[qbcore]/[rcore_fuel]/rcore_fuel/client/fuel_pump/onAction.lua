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

local activePumpDuiIdentifier = nil
local isPumpOpenBusy = false
local isFuelingMonitorActive = false
local monitorGeneration = 0
local pumpOpenGeneration = 0
local pumpReceiptGeneration = {}
local pendingFuelStart = nil

IsPlayerReadyToPump = false
DisableMouseForSelectVehicle = false

function GetCurrentFuelPercentage(vehicleEntity)
    if DoesEntityExist(vehicleEntity) then
        return GetVehicleFuelPercentage(vehicleEntity)
    end

    if IsPlayerHoldingJerryCan() then
        return GetCurrentJerryCanPercentage()
    end

    return nil
end

function SetShopPumpCollision(shopData, collisionEnabled)
    for _, pumpData in pairs(shopData.pumpPosition) do
        if DoesEntityExist(pumpData.entity) then
            if GetEntityHealth(pumpData.entity) >= 1 then
                if GetEntityModel(pumpData.entity) ~= 0 then
                    SetEntityCollision(pumpData.entity, collisionEnabled, true)
                end
            end
        end
    end
end

RegisterNetEvent("rcore_fuel:addFuel", function(vehicleNetId, fuelType, serverId, isJerryCanRefuel)
    -- This event mutates fuel and must only be accepted when it originated from FXServer.
    -- A modified client can otherwise call TriggerEvent locally and grant itself fuel.
    if source ~= 65535 then return end

    if isJerryCanRefuel then
        if GetPlayerServerID() == serverId and IsPlayerHoldingJerryCan() then
            AddLiterToJerryCan()
        end

        return
    end

    local vehicleEntity = NetToVeh(vehicleNetId)
    if not vehicleEntity or vehicleEntity == 0 or not DoesEntityExist(vehicleEntity) then
        return
    end
    local vehicleFuelType = GetVehicleFuelType(GetEntityModel(vehicleEntity))

    if fuelType ~= vehicleFuelType and not DecorExistOn(vehicleEntity, DecorEnum.WRONG_FUEL) then
        DecorSetBool(vehicleEntity, DecorEnum.WRONG_FUEL, true)
    end

    AddVehicleFuelLiter(vehicleEntity, 1)
end)

RegisterNetEvent("rcore_fuel:fuelingStartResult", function(requestId, accepted, session, message)
    if source ~= 65535 or requestId ~= pendingFuelStart or requestId ~= monitorGeneration then return end
    pendingFuelStart = nil
    if not IsPumping then return end
    if not accepted then
        isFuelingMonitorActive = false
        StopFueling(true)
        ShowNotification(message or "Fueling could not start. Check the pump and try again.")
        return
    end
    if session and session.duiIdentifier == activePumpDuiIdentifier then
        TriggerEvent("rcore_fuel:updateFuelCost", session.litersTanked, session.vehicleNetId,
            session.pricePerLiter, session.duiIdentifier)
    end
end)

RegisterNetEvent("rcore_fuel:startFueling", function(vehicleNetId)
    if not IsPumping or not activePumpDuiIdentifier then return end
    monitorGeneration = monitorGeneration + 1
    local generation = monitorGeneration
    local vehicleEntity = 0
    local playerPed = PlayerPedId()
    local fillingJerryCan = IsPlayerHoldingJerryCan()

    if NetworkDoesEntityExistWithNetworkId(vehicleNetId or 0) then
        vehicleEntity = NetToVeh(vehicleNetId)
    end

    local fuelPercentage = GetCurrentFuelPercentage(vehicleEntity)
    if fuelPercentage == nil then StopFueling() return end

    SendDUIDataByIdentifier(activePumpDuiIdentifier, { type = "showFueling" })
    local jerryWeaponId, jerryItemId = GetJerryCanServerItemIdentifiers()
    local dispenserValues = GetCurrentDispenserValues()
    local fuelType = dispenserValues and dispenserValues.fuelType or nil
    TriggerEvent("rcore_fuel:refuelSummary", { visible = true,
        unit = fuelType and _U(fuelType .. "_unit") or "L", status = "Refueling" })
    pendingFuelStart = generation

    TriggerServerEvent(
        "rcore_fuel:startFueling",
        vehicleNetId,
        GetCurrentPumpIdentifier(),
        fuelType,
        IsPlayerHoldingJerryCan(),
        activePumpDuiIdentifier,
        GetCurrentDispenserIdentifier(),
        jerryWeaponId,
        jerryItemId,
        generation
    )
    SetTimeout(5000, function()
        if pendingFuelStart == generation and generation == monitorGeneration and IsPumping then
            pendingFuelStart = nil
            StopFueling()
            ShowNotification("The pump did not respond. Please try again.")
        end
    end)

    ShowHelpNotification(_U("how_to_stop"), false, true, 10000)
    isFuelingMonitorActive = true

    local overflowFxTriggered = false

    CreateThread(function()
        local overflowTicks = 0

        while isFuelingMonitorActive and generation == monitorGeneration do
            Wait(100)
            if not isFuelingMonitorActive or generation ~= monitorGeneration then return end

            fuelPercentage = GetCurrentFuelPercentage(vehicleEntity)
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()

            local shouldStopFueling = false

            -- FIX 1: corrected stop-fueling logic from bak:
            -- stop if player dead, vehicle despawned, vehicle knocked away, or player ragdolled.
            local isDead = IsEntityDead(playerPed) or playerPed ~= PlayerPedId()
            if isDead then
                shouldStopFueling = true
            elseif not IsPlayerHoldingJerryCan() and not DoesEntityExist(vehicleEntity) then
                shouldStopFueling = true   -- vehicle gone, stop immediately
            elseif not IsPlayerHoldingJerryCan() and DoesEntityExist(vehicleEntity) and #(GetEntityCoords(playerPed) - GetEntityCoords(vehicleEntity)) > 7.0 then
                shouldStopFueling = true   -- vehicle knocked or driven far away
            elseif IsPedRagdoll(playerPed) then
                shouldStopFueling = true   -- player ragdolled
            elseif fuelPercentage == nil or fillingJerryCan ~= IsPlayerHoldingJerryCan()
                or IsPedInAnyVehicle(playerPed, false) then
                shouldStopFueling = true
            end

            if shouldStopFueling then
                SelectedVehicleAndStartFueling()
                return
            end

            if Config.OverflowFuel then
                -- Jerry cans do not have a vehicle entity. Avoid looking up the model/fuel
                -- type of entity 0 and simply stop the can when it reaches full capacity.
                if IsPlayerHoldingJerryCan() then
                    if fuelPercentage >= 100 then
                        SelectedVehicleAndStartFueling()
                        return
                    end
                else
                    local vehicleFuelType = GetVehicleFuelType(GetEntityModel(vehicleEntity))

                    if not Config.NonLiquidFueLTypes[vehicleFuelType] then
                        if fuelPercentage >= 100 and not overflowFxTriggered and IsPumping then
                            overflowTicks = overflowTicks + 1

                            if overflowTicks > 20 then
                                overflowFxTriggered = true

                                CreateThread(function()
                                    StartFuelFXOnEntity(GetEntityDispenserGun(), function()
                                        if generation == monitorGeneration and IsPouringFuelFXPlaying() then
                                            SelectedVehicleAndStartFueling()
                                        end
                                    end)
                                end, "the actuall fx effect")

                                return
                            end
                        end
                    elseif fuelPercentage >= 100 then
                        StopFueling()
                        return
                    end
                end
            elseif fuelPercentage >= 100 then
                SelectedVehicleAndStartFueling()
            end
        end
    end, "Thread for refueling vehicle and starting fx effect")
end)

RegisterNetEvent("rcore_fuel:resetSkipDestroy", function(identifier)
    if activePumpDuiIdentifier ~= nil then
        return
    end

    if not ClosestScaleformData or not ClosestScaleformData.identifier then
        return
    end

    local scaleformIdentifier = "pump_" .. ClosestScaleformData.identifier .. "_" .. ClosestScaleformData.dispenserIdentifier

    if scaleformIdentifier == identifier then
        SetAdditionalDataForScaleform(identifier, "skipDestroy", nil)
        RemoveScaleformPumpDataByIdentifier(ClosestScaleformData.identifier)
    end
end)

RegisterNetEvent("rcore_fuel:updateFuelCost", function(litersTanked, vehicleNetId, pricePerLiter, identifier)
    -- Route the session's counters to its own pump. The nearest loaded screen
    -- may belong to another dispenser, or may be absent while the DUI reloads.
    local nearest = ClosestScaleformData
    local nearestIdentifier = nearest and nearest.identifier and nearest.dispenserIdentifier
        and ("pump_" .. nearest.identifier .. "_" .. nearest.dispenserIdentifier) or nil
    local isActivePump = identifier ~= nil and identifier == activePumpDuiIdentifier
    if not identifier or (not isActivePump and identifier ~= nearestIdentifier) then return end
    litersTanked, pricePerLiter = tonumber(litersTanked), tonumber(pricePerLiter)
    if not litersTanked or not pricePerLiter then return end

    local fuelPercentage = nil
    local vehicleEntity = nil
    local fuelType = FuelType.NATURAL

    if not IsPlayerHoldingJerryCan() then
        if vehicleNetId and NetworkDoesEntityExistWithNetworkId(vehicleNetId) then
            vehicleEntity = NetToVeh(vehicleNetId)
        end
        if vehicleEntity and vehicleEntity ~= 0 and DoesEntityExist(vehicleEntity) then
            fuelPercentage = GetVehicleFuelPercentage(vehicleEntity)
            fuelType = GetVehicleFuelType(GetEntityModel(vehicleEntity))
        else
            fuelPercentage = 0.0
        end
    else
        fuelPercentage = GetCurrentJerryCanPercentage()
    end

    if identifier == nearestIdentifier and activePumpDuiIdentifier == nil then
        if GetAdditionalDataForScaleform(identifier).skipDestroy == nil then
            SetAdditionalDataForScaleform(identifier, "skipDestroy", true)

            SendDUIDataByIdentifier(identifier, {
                type = "lerpAmount",
                amount = GetLerpAmountForFuelType(fuelType),
            })

            SendDUIDataByIdentifier(identifier, { type = "showFueling" })
        end
    end

    if isActivePump or identifier == nearestIdentifier then
        if isActivePump then
            local dispenser = GetCurrentDispenserValues()
            TriggerEvent("rcore_fuel:refuelSummary", { visible = true,
                total = math.ceil(litersTanked * pricePerLiter),
                liters = GetMeasurementUnits(litersTanked, MeasurementTypes.LITERS),
                unit = _U((dispenser and dispenser.fuelType or fuelType) .. "_unit") })
        end
        SendDUIDataByIdentifier(identifier, {
            type = "update_cost",
            cost = math.ceil(litersTanked * pricePerLiter),
            fuel = fuelPercentage,
            litersTanked = litersTanked * GetMeasurementUnits(1, MeasurementTypes.LITERS),
        })

        local dispenser = isActivePump and GetCurrentDispenserValues() or nil
        local pumpPosition = dispenser and dispenser.pos or (nearest and nearest.entityPos)
        if vehicleEntity and pumpPosition then
            local distanceFromPump = #(pumpPosition - GetEntityCoords(PlayerPedId()))

            if distanceFromPump > 10 then
                showSubtitle(_U("fueling_noscaleform", fuelPercentage, math.ceil(litersTanked * pricePerLiter)))
            end
        end
    end
end)

RegisterNetEvent("rcore_fuel:stopFueling", function()
    isFuelingMonitorActive = false
    monitorGeneration = monitorGeneration + 1
    if source == 65535 then StopFueling(true) end
end)

RegisterNetEvent("rcore_fuel:PlayerOpen", function(shopId, dispenserIndex, dispenserData, pumpSide, skipWalkAnimation)
    if not shopId then
        return
    end

    local shopData = Config.ShopList and Config.ShopList[shopId]
    if not shopData or not shopData.pumpPosition or not shopData.pumpPosition[dispenserIndex] then
        return
    end

    local pumpPositionData = shopData.pumpPosition[dispenserIndex]
    local isReturningNozzle = false
    local isPickingUpNozzle = false

    if isPumpOpenBusy then
        return
    end

    isPumpOpenBusy = true
    pumpOpenGeneration = pumpOpenGeneration + 1
    local openGeneration = pumpOpenGeneration

    if not pumpPositionData.source then pumpPositionData.source = {} end
    if not pumpPositionData.occupied then pumpPositionData.occupied = {} end

    local playerPed = PlayerPedId()
    local pumpEntity = FindSupportedDispenserEntity(dispenserData.pos, dispenserData.hash, 3.0)
    local cleanupOnly = skipWalkAnimation and pumpSide and pumpPositionData.occupied[pumpSide]
    if (pumpEntity == 0 or not DoesEntityExist(pumpEntity)) and not cleanupOnly then
        isPumpOpenBusy = false
        TriggerServerEvent("rcore_fuel:releasePumpReservation", shopId, dispenserIndex, pumpSide)
        ShowNotification("Fuel pump prop could not be resolved. Try the interaction again.")
        return
    end

    pumpPositionData.entity = pumpEntity

    local playerServerId = GetPlayerServerID()
    local walkPosition, resolvedPumpSide = GetWalkOffsetForPump(pumpEntity, pumpSide)
    local walkHeadingOffset = GetHeadingOffetForPump(pumpEntity, pumpSide)
    if cleanupOnly then resolvedPumpSide = pumpSide end
    if not cleanupOnly and (not walkPosition or not resolvedPumpSide or walkHeadingOffset == nil) then
        isPumpOpenBusy = false
        TriggerServerEvent("rcore_fuel:releasePumpReservation", shopId, dispenserIndex, pumpSide)
        ShowNotification("This pump model is missing nozzle offset data.")
        return
    end

    if pumpPositionData.source[resolvedPumpSide] and pumpPositionData.source[resolvedPumpSide] ~= playerServerId then
        isPumpOpenBusy = false
        return
    end

    pumpPositionData.source[resolvedPumpSide] = playerServerId
    SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)

    DisableMouseForSelectVehicle = false

    if pumpPositionData.occupied[resolvedPumpSide] then
        isReturningNozzle = true
        -- Stop dispensing before starting the return gesture; StopFueling clears
        -- the active animation and must not run after the gesture starts.
        StopFueling()
        IsPlayerReadyToPump = false
        DisableMouseForSelectVehicle = true
    end

    if not skipWalkAnimation then
        local arrived, approachFailure = GoToCoordsWithHeadingInTime(playerPed, walkPosition,
            GetEntityHeading(pumpEntity) - walkHeadingOffset, 1500,
            function() return openGeneration == pumpOpenGeneration end,
            { positionTolerance = 0.8, heightTolerance = 1.25, headingTolerance = 10.0, finishHeading = true })
        if openGeneration ~= pumpOpenGeneration then return end
        if arrived and isReturningNozzle then
            -- The return gesture reaches with the right hand.
            AttachFuelNozzleToPed(GetEntityDispenserGun(), playerPed, 57005)
        end
        if not arrived then
            isPumpOpenBusy = false
            if isReturningNozzle then
                AttachFuelNozzleToPed(GetEntityDispenserGun(), playerPed)
                IsPlayerReadyToPump = true
                DisableMouseForSelectVehicle = false
            end
            if not pumpPositionData.occupied[resolvedPumpSide] then
                pumpPositionData.source[resolvedPumpSide] = false
                TriggerServerEvent("rcore_fuel:releasePumpReservation", shopId, dispenserIndex, resolvedPumpSide)
            end
            if not IsEntityDead(playerPed) and not IsPedRagdoll(playerPed) then
                ShowNotification("Could not reach the nozzle. Stand beside this side of the pump and try again.")
                print(string.format("[rcore_fuel] Pump approach failed: %s (model %s, side %s)",
                    tostring(approachFailure), tostring(GetEntityModel(pumpEntity)), tostring(resolvedPumpSide)))
            end
            return
        end
        -- An unavailable cosmetic clip must not silently prevent hose pickup.
        if not Animation.Play(isReturningNozzle and "nozzle_return" or "type2") then
            print("[rcore_fuel] Pump interaction animation unavailable; continuing nozzle interaction.")
        end
    end

    if pumpPositionData.occupied[resolvedPumpSide] then
        IsPlayerReadyToPump = false
        local selected = GetSelectedVehicleForFueling()
        if selected and selected ~= 0 and DoesEntityExist(selected) then
            SetEntityDrawOutline(selected, false)
        end
    end

    if not skipWalkAnimation then
        -- Keep the nozzle visible during the reach, then let the hand retract.
        if isReturningNozzle then
            Wait(1000)
            if openGeneration ~= pumpOpenGeneration then return end
            DisposeDispenserGun()
            Wait(800)
        else
            Wait(650)
        end
    end
    if openGeneration ~= pumpOpenGeneration then return end
    Animation.ResetAll()
    if not skipWalkAnimation and not isReturningNozzle and (IsEntityDead(playerPed) or IsPedRagdoll(playerPed)) then
        isPumpOpenBusy = false
        TriggerServerEvent("rcore_fuel:releasePumpReservation", shopId, dispenserIndex, resolvedPumpSide)
        return
    end

    if isReturningNozzle then
        pumpPositionData.occupied[resolvedPumpSide] = false
    elseif not pumpPositionData.occupied[resolvedPumpSide] then
        if IsPlayerHoldingDispenserGun() then
            -- We reserved this pump before discovering the player already has another
            -- nozzle. Release it immediately instead of leaving the side locked.
            pumpPositionData.occupied[resolvedPumpSide] = false
            pumpPositionData.source[resolvedPumpSide] = false
            TriggerServerEvent("rcore_fuel:SyncFuelPumpValues", shopId, dispenserIndex, {
                source = { [resolvedPumpSide] = false },
                occupied = { [resolvedPumpSide] = false },
            })
            isPumpOpenBusy = false
            return
        end

        pumpPositionData.occupied[resolvedPumpSide] = true
        isPickingUpNozzle = true
    else
        isPumpOpenBusy = false
        return
    end

    if isReturningNozzle then
        pumpPositionData.source[resolvedPumpSide] = false
    end

    TriggerServerEvent("rcore_fuel:SyncFuelPumpValues", shopId, dispenserIndex, {
        source = { [resolvedPumpSide] = pumpPositionData.source[resolvedPumpSide] },
        occupied = { [resolvedPumpSide] = pumpPositionData.occupied[resolvedPumpSide] },
    })

    if isPickingUpNozzle then
        if not EquipDispenserGun(pumpEntity, resolvedPumpSide) then
            -- Creation failure must release the server reservation we just marked
            -- occupied; otherwise this side of the pump stays locked until timeout.
            pumpPositionData.occupied[resolvedPumpSide] = false
            pumpPositionData.source[resolvedPumpSide] = false
            TriggerServerEvent("rcore_fuel:SyncFuelPumpValues", shopId, dispenserIndex, {
                source = { [resolvedPumpSide] = false },
                occupied = { [resolvedPumpSide] = false },
            })
            isPumpOpenBusy = false
            return
        end
        if openGeneration ~= pumpOpenGeneration then
            DisposeDispenserGun()
            return
        end
        SetPlayerStateHoldingDispenserGun(true)

        CreateThread(function()
            Wait(500)
            ShowHelpNotification(_U("select_car"), false, true, 10000)
        end, "Select car notify")

        IsPlayerReadyToPump = true

        activePumpDuiIdentifier = "pump_" .. GetCurrentPumpIdentifier() .. "_" .. GetCurrentDispenserIdentifier()
        pumpReceiptGeneration[activePumpDuiIdentifier] = (pumpReceiptGeneration[activePumpDuiIdentifier] or 0) + 1
        TriggerEvent("rcore_fuel:refuelSummary", { visible = false, total = 0, liters = 0 })
        SendDUIDataByIdentifier(activePumpDuiIdentifier, { type = "hideFueling" })
        SetAdditionalDataForScaleform(activePumpDuiIdentifier, "ignoreFade", true)
        SetAdditionalDataForScaleform(activePumpDuiIdentifier, "distance", 1000)

        SendDUIDataByIdentifier(activePumpDuiIdentifier, {
            type = "lerpAmount",
            amount = GetLerpAmountForFuelType(dispenserData.fuelType),
        })

        CreateThread(function()
            while IsPlayerReadyToPump do
                Wait(1000)

                local playerCoords = GetEntityCoords(PlayerPedId())
                local distanceFromPump = #(playerCoords - dispenserData.pos)
                local ropeBreakDistance = Config.RopeDistanceBeforeBreak or 10

                local shouldClosePump = false

                if IsEntityDead(PlayerPedId()) then
                    shouldClosePump = true
                elseif distanceFromPump >= ropeBreakDistance then
                    if not IsPumping and not IsPlayerWalkingToCoordinates() then
                        shouldClosePump = true
                    end
                end

                -- FIX 6: rewritten from a goto/label pair -- the original had 'return'
                -- followed by a label in the same block, which is an illegal Lua syntax
                -- (return must be the last statement in its block). Same logic: only
                -- treat the pump as still valid (and keep monitoring) if it exists, has
                -- health, and has a valid model; otherwise close out below.
                if not shouldClosePump then
                    local pumpStillValid = DoesEntityExist(pumpEntity)
                        and GetEntityHealth(pumpEntity) > 1
                        and GetEntityModel(pumpEntity) ~= 0
                    if not pumpStillValid then
                        shouldClosePump = true
                    end
                end

                if shouldClosePump then
                    TriggerEvent(
                        "rcore_fuel:PlayerOpen",
                        GetCurrentPumpIdentifier(),
                        GetCurrentDispenserIdentifier(),
                        GetCurrentDispenserValues(),
                        resolvedPumpSide,
                        true
                    )
                    return
                end
            end
        end, "Kill player fuel selection if far away")

        isPumpOpenBusy = false
        IsPumping = false
        SwitchFuelType(true)
        TriggerEvent("rcore_fuel:OnDispenserEnter")
    end

    if isReturningNozzle then
        DisposeDispenserGun()
        SetPlayerStateHoldingDispenserGun(false)

        local pumpId = GetCurrentPumpIdentifier()
        local dispenserId = GetCurrentDispenserIdentifier()

        if pumpId and dispenserId then
            activePumpDuiIdentifier = "pump_" .. pumpId .. "_" .. dispenserId
            local receiptId = activePumpDuiIdentifier
            pumpReceiptGeneration[receiptId] = (pumpReceiptGeneration[receiptId] or 0) + 1
            local generation = pumpReceiptGeneration[receiptId]
            SetAdditionalDataForScaleform(receiptId, "ignoreFade", true)
            SetAdditionalDataForScaleform(receiptId, "distance", Config.PumpDisplayDistance or 15)
            SetTimeout(Config.FuelReceiptDisplayDuration or 15000, function()
                if generation ~= pumpReceiptGeneration[receiptId] or activePumpDuiIdentifier == receiptId then return end
                SetAdditionalDataForScaleform(receiptId, "ignoreFade", nil)
                SetAdditionalDataForScaleform(receiptId, "distance", Config.PumpDisplayDistance or 15)
                SendDUIDataByIdentifier(receiptId, { type = "hideFueling" })
            end)
        end

        isPumpOpenBusy = false
        TriggerEvent("rcore_fuel:refuelSummaryEnded")
        TriggerServerEvent("rcore_fuel:requestPaymentModal", "fuelPump")
        activePumpDuiIdentifier = nil
        isFuelingMonitorActive = false
        ResetFuelingVariables()
        TriggerEvent("rcore_fuel:OnDispenserExit")
    end

    isPumpOpenBusy = false
    Animation.ResetAll()
end)

RegisterNetEvent("rcore_fuel:SyncFuelPumpValues", function(shopId, dispenserIndex, syncedValues)
    local shop = Config.ShopList and Config.ShopList[shopId]
    if not shop or not shop.pumpPosition or not shop.pumpPosition[dispenserIndex] then
        return
    end

    local pumpPositionData = shop.pumpPosition[dispenserIndex]
    if not pumpPositionData.source then pumpPositionData.source = {} end
    if not pumpPositionData.occupied then pumpPositionData.occupied = {} end

    for sideId, sourceId in pairs((syncedValues and syncedValues.source) or {}) do
        pumpPositionData.source[sideId] = (sourceId ~= false) and sourceId or nil
    end

    for sideId, isOccupied in pairs((syncedValues and syncedValues.occupied) or {}) do
        pumpPositionData.occupied[sideId] = (isOccupied ~= false) and isOccupied or nil
    end

    RefreshFuelDispenserUtilise()
end)


-- Keep file-local DUI/monitor state in sync with the shared pump reset.
AddEventHandler("rcore_fuel:resetFuelPumpVariables", function()
    activePumpDuiIdentifier = nil
    isFuelingMonitorActive = false
end)

-- Death safety: immediately clean up dispenser gun and reset fueling if player dies anywhere
local function HandlePlayerDeathCleanup()
    if IsPlayerHoldingDispenserGun() or IsPumping or isPumpOpenBusy then
        pumpOpenGeneration = pumpOpenGeneration + 1
        local pumpId = GetCurrentPumpIdentifier()
        local dispenserId = GetCurrentDispenserIdentifier()
        local side = GetCurrentPumpSideEntered()
        StopFueling()
        isPumpOpenBusy = false
        DisposeDispenserGun()
        SetPlayerStateHoldingDispenserGun(false)
        IsPlayerReadyToPump = false
        IsPumping = false
        isFuelingMonitorActive = false
        activePumpDuiIdentifier = nil
        ResetFuelingVariables()
        Animation.ResetAll()
        if pumpId and dispenserId and side then
            TriggerServerEvent("rcore_fuel:SyncFuelPumpValues", pumpId, dispenserId, {
                source = { [side] = false },
                occupied = { [side] = false },
            })
            TriggerServerEvent("rcore_fuel:stopFueling", pumpId, nil, nil)
        end
        TriggerEvent("rcore_fuel:OnDispenserExit")
    end
end

AddEventHandler("baseevents:onPlayerDied", HandlePlayerDeathCleanup)
AddEventHandler("baseevents:onPlayerKilled", HandlePlayerDeathCleanup)
AddEventHandler("qbx_medical:client:playerDied", HandlePlayerDeathCleanup)
AddEventHandler("qbx_core:client:playerDied", HandlePlayerDeathCleanup)
