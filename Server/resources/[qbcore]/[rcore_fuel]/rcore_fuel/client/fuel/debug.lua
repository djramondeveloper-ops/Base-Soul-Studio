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

local fuelDebugEnabled = false
local consumptionSamples = { 0 }
local tripDistanceKm = 0
local fuelAtTripStart = 0
local estimatedRangeKm = 0
local efficiencyScore = 0
local lastMetricsUpdate = 0
local trackedVehicle = 0
local debugHudBaseX = 0.1
local debugHudBaseY = 0.1
local debugHudLineHeight = 0.035
local currentConsumption = 0

function CalculateDebugAverageConsumption()
    local total = 0

    for _, sample in pairs(consumptionSamples) do
        total = total + sample
    end

    return total / #consumptionSamples
end

function FormatDebugNumber(value)
    return string.format("%.2f", value)
end

function DrawDebugHudText(text, xOffset, yOffset)
    SetTextFont(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(xOffset, yOffset)
end

CreateThread(function()
    while true do
        Wait(0)

        if not fuelDebugEnabled then
            Wait(1000)
        else
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local playerPed = PlayerPedId()

            if IsPedInAnyVehicle(playerPed, false) then
                if trackedVehicle ~= vehicle then
                    trackedVehicle = vehicle
                    tripDistanceKm = 0
                    consumptionSamples = { CalculateFuelConsumptionRate(vehicle) }
                    fuelAtTripStart = GetVehicleFuelLiters(vehicle)
                end

                if vehicle ~= 0 and IsVehicleModelEnabledForFueling(vehicle) then
                    if GetGameTimer() > lastMetricsUpdate then
                        currentConsumption = CalculateFuelConsumptionRate(vehicle)
                        estimatedRangeKm = GetVehicleMaxCurrentDrivingRange(vehicle)
                        efficiencyScore = GetVehicleFuelConsumptionEfficiency(vehicle)
                        lastMetricsUpdate = GetGameTimer() + 1000

                        if GetEntitySpeed(vehicle) * 3.6 >= 5.0 then
                            table.insert(consumptionSamples, currentConsumption)

                            if #consumptionSamples > 30 then
                                table.remove(consumptionSamples, 1)
                            end
                        end
                    end

                    local debugLines = {
                        {
                            text = "~f~Consumption: ~g~"
                                .. FormatDebugNumber(GetMeasurementUnits(currentConsumption, MeasurementTypes.LITERS))
                                .. " "
                                .. GetMeasurementTypeLabel(MeasurementTypes.LITERS)
                                .. " / "
                                .. Config.ConsumptionWLTP
                                .. " "
                                .. GetMeasurementTypeLabel(MeasurementTypes.KILOMETERS),
                            offset = 0,
                        },
                        {
                            text = "~f~Average consumption: ~g~"
                                .. FormatDebugNumber(CalculateDebugAverageConsumption())
                                .. " "
                                .. GetMeasurementTypeLabel(MeasurementTypes.LITERS),
                            offset = -0.062,
                        },
                        { test = "", offset = 0.0 },
                        {
                            text = "~f~Current fuel: ~g~"
                                .. FormatDebugNumber(GetVehicleFuelLiters(vehicle))
                                .. " - "
                                .. GetMeasurementTypeLabel(MeasurementTypes.LITERS),
                            offset = 0.01,
                        },
                        {
                            text = "~f~Maximum fuel capacity: ~g~"
                                .. FormatDebugNumber(GetMaximumFuelCapacityForVehicle(vehicle))
                                .. " - "
                                .. GetMeasurementTypeLabel(MeasurementTypes.LITERS),
                            offset = -0.072,
                        },
                        {
                            text = "~f~Fuel in percentage: ~g~"
                                .. FormatDebugNumber(GetVehicleFuelPercentage(vehicle))
                                .. "%",
                            offset = -0.043,
                        },
                        {
                            text = "~f~Fuel type: ~g~"
                                .. GetVehicleFuelTypeLabel(GetEntityModel(vehicle)),
                            offset = 0.024,
                        },
                        { test = "", offset = 0.0 },
                        {
                            text = "~f~Mileage: ~g~"
                                .. FormatDebugNumber(GetMeasurementUnits(tripDistanceKm, MeasurementTypes.KILOMETERS)),
                            offset = 0.033,
                        },
                        {
                            text = "~f~Fuel taken so far: ~g~"
                                .. FormatDebugNumber(
                                    GetMeasurementUnits(
                                        fuelAtTripStart - GetVehicleFuelLiters(vehicle),
                                        MeasurementTypes.LITERS
                                    )
                                )
                                .. " "
                                .. GetMeasurementTypeLabel(MeasurementTypes.LITERS),
                            offset = -0.03,
                        },
                        {
                            text = "~f~Estimated Range: ~g~"
                                .. FormatDebugNumber(GetMeasurementUnits(estimatedRangeKm, MeasurementTypes.KILOMETERS))
                                .. " "
                                .. GetMeasurementTypeLabel(MeasurementTypes.KILOMETERS),
                            offset = -0.033,
                        },
                        { test = "", offset = 0.0 },
                        {
                            text = "~f~Vehicle class: ~g~" .. GetVehicleClass(vehicle),
                            offset = -0.002,
                        },
                        {
                            text = "~f~Vehicle modifier: ~g~" .. GetVehicleFuelModifier(vehicle),
                            offset = -0.024,
                        },
                        { test = "", offset = 0.0 },
                        {
                            text = "~f~Efficiency score: ~g~" .. FormatDebugNumber(efficiencyScore),
                            offset = -0.025,
                        },
                    }

                    for lineIndex, line in ipairs(debugLines) do
                        DrawDebugHudText(
                            line.text,
                            debugHudBaseX + line.offset,
                            debugHudBaseY + ((lineIndex - 1) * debugHudLineHeight)
                        )
                    end
                end
            else
                Wait(1000)
            end
        end
    end
end, "rendering WLTP")

CreateThread(function()
    local lastCoords = nil

    while true do
        if not fuelDebugEnabled then
            Wait(1000)
        else
            lastCoords = GetEntityCoords(PlayerPedId())
            Wait(33)

            tripDistanceKm = tripDistanceKm + (#(lastCoords - GetEntityCoords(PlayerPedId())) / 1000)
        end
    end
end, "rendering WLTP")

if Config.FuelDebug then
    RegisterCommand("setfuel", function(_, args)
        -- FIX 1: this let any player set fuel to any value directly, bypassing
        -- the entire fuel-purchase economy -- add the same permission check used
        -- elsewhere in this resource's debug/editor commands
        if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            return
        end
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        print("max fuel: ", GetMaximumFuelCapacityForVehicle(vehicle))
        SetVehicleFuel(vehicle, tonumber(args[1]))
    end)
end

if Config.AllowDebugCommand then
    RegisterCommand("fueldebug", function()
        -- FIX 2: matches the IsPlayerInGroup check used elsewhere under
        -- Config.AllowDebugCommand (e.g. client/debug.lua's fuelcompanydebug)
        if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            return
        end
        fuelDebugEnabled = not fuelDebugEnabled
        print("Enabling fuel debug", fuelDebugEnabled)
    end)

    RegisterCommand("fueldebugtypes", function()
        -- FIX 2: see fueldebug above
        if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            return
        end
        local fuelTypeCounts = {}

        for _, modelName in pairs(GetAllVehicleModels()) do
            local modelHash = GetHashKey(modelName)
            local fuelType = GetVehicleFuelType(modelHash)

            if not fuelTypeCounts[fuelType] then
                fuelTypeCounts[fuelType] = 0
            end

            fuelTypeCounts[fuelType] = fuelTypeCounts[fuelType] + 1
        end

        Dump(fuelTypeCounts, nil, "gasPrices")
    end)
end
