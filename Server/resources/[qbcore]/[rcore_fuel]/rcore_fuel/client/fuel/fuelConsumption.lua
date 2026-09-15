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

if Config.EnableStateBagsForOxFuel then
    local pendingFuelStateBagUpdates = {}

    CreateThread(function()
        while true do
            Wait(4000)

            for vehicle, fuelLevel in pairs(pendingFuelStateBagUpdates) do
                if DoesEntityExist(vehicle) then
                    Entity(vehicle).state:set("fuel", fuelLevel, true)
                end
            end

            pendingFuelStateBagUpdates = {}
        end
    end, "sync statebag fuel")

    function SetInformationAboutFuelLevel(vehicle, fuelLevel)
        pendingFuelStateBagUpdates[vehicle] = fuelLevel
    end
end

CreateThread(function()
    local lastPlayerCoords = nil
    local lastVehicle = nil
    local lastSampleTime = nil

    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isValidDriver = vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)
            and IsVehicleModelEnabledForFueling(vehicle) and IsPlayerDriver()

        if not isValidDriver then
            lastPlayerCoords = nil
            lastVehicle = nil
            lastSampleTime = nil
            Wait(100)
        else
            local playerCoords = GetEntityCoords(playerPed)
            local sampleTime = GetGameTimer()

            -- Never carry distance from a previous vehicle into a newly-entered one.
            if lastVehicle ~= vehicle then
                lastVehicle = vehicle
                lastPlayerCoords = playerCoords
                lastSampleTime = sampleTime
            else
                local fuelPercentage = GetVehicleFuelPercentage(vehicle)
                local maxFuelCapacity = tonumber(GetMaximumFuelCapacityForVehicle(vehicle)) or tonumber(Config.MaxFuel) or 65.0
                if maxFuelCapacity <= 0 then maxFuelCapacity = 65.0 end

                if lastPlayerCoords then
                    local speedMps = GetEntitySpeed(vehicle)
                    local speedKmh = speedMps * 3.6
                    local elapsedSeconds = math.max(0.1, (sampleTime - (lastSampleTime or sampleTime)) / 1000.0)
                    local distanceMeters = #(playerCoords - lastPlayerCoords)
                    -- Ignore implausible position jumps caused by teleports, streaming
                    -- corrections, or a long client hitch. They should not empty a tank.
                    local maxPlausibleDistance = math.max(50.0, (speedMps * elapsedSeconds * 3.0) + 25.0)

                    if speedKmh >= 5.0 then
                        if distanceMeters <= maxPlausibleDistance then
                            local currentFuelLiters = (fuelPercentage / 100) * maxFuelCapacity
                            -- Fuel-consumption math is defined in metric units. Display-unit
                            -- conversion (miles/gallons) must never change the actual drain rate.
                            local distanceKm = distanceMeters / 1000
                            local consumptionRate = tonumber(CalculateFuelConsumptionRate(vehicle)) or 0
                            local wltp = tonumber(Config.ConsumptionWLTP) or 10
                            if wltp <= 0 then wltp = 10 end
                            local newFuelPercentage = (
                                (currentFuelLiters - (consumptionRate * (distanceKm / wltp)))
                                / maxFuelCapacity
                            ) * 100

                            SetVehicleFuel(vehicle, newFuelPercentage)
                        end
                    elseif GetIsVehicleEngineRunning(vehicle) then
                        local idleDrainPercentage = (2.5E-4 / maxFuelCapacity) * 100
                        SetVehicleFuel(vehicle, fuelPercentage - idleDrainPercentage)
                    end
                end

                lastPlayerCoords = playerCoords
                lastSampleTime = sampleTime
            end
        end
    end
end, "Counting fuel")

CreateThread(function()
    local lastPlayerCoords = nil
    local lastVehicle = nil
    local lastSampleTime = nil

    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isValidDriver = vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) and IsPlayerDriver()

        if not isValidDriver then
            lastPlayerCoords = nil
            lastVehicle = nil
            lastSampleTime = nil
        else
            local playerCoords = GetEntityCoords(playerPed)
            local sampleTime = GetGameTimer()

            if lastVehicle ~= vehicle then
                lastVehicle = vehicle
                lastPlayerCoords = playerCoords
                lastSampleTime = sampleTime
            else
                if VehicleHasWrongFuel(vehicle) and lastPlayerCoords then
                    if not DecorExistOn(vehicle, DecorEnum.MILEAGE) then
                        DecorSetFloat(vehicle, DecorEnum.MILEAGE, 0.0)
                    end

                    local elapsedSeconds = math.max(0.1, (sampleTime - (lastSampleTime or sampleTime)) / 1000.0)
                    local distanceMeters = #(playerCoords - lastPlayerCoords)
                    local maxPlausibleDistance = math.max(25.0, (GetEntitySpeed(vehicle) * elapsedSeconds * 3.0) + 15.0)
                    local mileage = DecorGetFloat(vehicle, DecorEnum.MILEAGE)

                    if distanceMeters <= maxPlausibleDistance then
                        mileage = mileage + distanceMeters
                        DecorSetFloat(vehicle, DecorEnum.MILEAGE, mileage)
                    end

                    if mileage >= Config.VehicleFailureMileage then
                        ShowHelpNotification(_U("wrong_fuel_failure"), false, true, 20000)
                        SetVehicleFuel(vehicle, 0.0)
                        DecorSetFloat(vehicle, DecorEnum.MILEAGE, 0.0)
                    end
                end

                lastPlayerCoords = playerCoords
                lastSampleTime = sampleTime
            end
        end
    end
end, "Counting mileage")

CreateThread(function()
    local playerPed          = nil
    local vehicle            = nil
    local lastLockedVehicle  = nil  -- FIX 9: track which vehicle we made undriveable

    while true do
        Wait(100)

        playerPed = PlayerPedId()
        vehicle   = GetVehiclePedIsIn(playerPed, false)

        if IsPlayerDriver() then
            local vehicleModel = GetEntityModel(vehicle)

            if vehicleModel and type(vehicleModel) == "number" and vehicleModel ~= 0 then
                local disableEngineBelow = Config.DisableEngineAfterCertainFuelLevel and Config.DisableEngineAfterCertainFuelLevel[GetVehicleFuelType(vehicleModel)]
                local fuelPercentage = GetVehicleFuelPercentage(vehicle)
                local shouldDisable = (fuelPercentage <= 0.0) or (disableEngineBelow and disableEngineBelow > 0 and fuelPercentage < disableEngineBelow)

                if shouldDisable then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    SetVehicleUndriveable(vehicle, true)
                    lastLockedVehicle = vehicle
                else
                    -- If the player changed vehicles, unlock the vehicle we actually
                    -- locked rather than blindly toggling the current one.
                    if lastLockedVehicle and lastLockedVehicle ~= vehicle and DoesEntityExist(lastLockedVehicle) then
                        SetVehicleUndriveable(lastLockedVehicle, false)
                    end
                    if lastLockedVehicle == vehicle then
                        SetVehicleUndriveable(vehicle, false)
                    end
                    lastLockedVehicle = nil
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        else
            -- player exited - reset any vehicle we previously locked so it
            -- doesn't stay permanently undriveable for the next driver
            if lastLockedVehicle and DoesEntityExist(lastLockedVehicle) then
                SetVehicleUndriveable(lastLockedVehicle, false)
                lastLockedVehicle = nil
            end
            Wait(1000)
        end
    end
end, "Disabling engine after certain fuel level")
