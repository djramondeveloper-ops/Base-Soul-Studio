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

providedExports = {}
providedExports.SetFuel = true
providedExports.GetFuel = true

function SetFuel(vehicleEntity, fuelLevel)
    if not vehicleEntity then
        if IsPlayerInVehicle() then
            vehicleEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        end
    end

    if fuelLevel then
        if type(fuelLevel) ~= "number" then
            print("From resource: ", GetInvokingResource())
            print("Your usage of exports['rcore_fuel']SetFuel(vehicle, fuel) is wrong, the fuel level you're trying to set is either null value or it isnt number!")
            return
        end
    else
        print("From resource: ", GetInvokingResource())
        print("Your usage of exports['rcore_fuel']SetFuel(vehicle, fuel) is wrong, the fuel level you're trying to set is either null value or it isnt number!")
        return
    end

    if not vehicleEntity then
        print("From resource: ", GetInvokingResource())
        print("Your usage of exports['rcore_fuel']SetFuel(vehicle, fuel) is wrong, the 'vehicleEntity' is null value! Cannot return any fuel because of that!")
        return
    end

    if not DoesEntityExist(vehicleEntity) then
        print("From resource: ", GetInvokingResource())
        print("Your usage of exports['rcore_fuel']SetFuel(vehicle, fuel) is wrong, the 'vehicleEntity' doesnt exists but it has some value but it isnt entity! The vehicle value: " .. tostring(vehicleEntity))
        return
    end

    fuelLevel = math.max(0.0, math.min(100.0, fuelLevel + 0.0))
    SetVehicleFuel(vehicleEntity, fuelLevel)
end

function GetFuel(vehicleEntity)
    if not vehicleEntity or vehicleEntity == 0 then
        if IsPlayerInVehicle() then
            vehicleEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        end
    end

    if not vehicleEntity or vehicleEntity == 0 or not DoesEntityExist(vehicleEntity) then
        return 50.0
    end

    if GetVehicleFuelPercentage then
        return GetVehicleFuelPercentage(vehicleEntity)
    end

    return GetVehicleFuelLevel(vehicleEntity)
end

exports("SetFuel", SetFuel)
exports("GetFuel", GetFuel)
exports("setFuel", SetFuel)
exports("getFuel", GetFuel)

function provideExport(resourceName, exportName, exportFunction)
    if not providedExports[exportName] then
        exports(exportName, exportFunction)
        providedExports[exportName] = true
    end

    AddEventHandler(string.format("__cfx_export_%s_%s", resourceName, exportName), function(setCB)
        setCB(exportFunction)
    end)
end

AddStateBagChangeHandler("fuel", nil, function(bagName, key, value)
    if value == nil or type(value) ~= "number" then
        return
    end

    local entity = GetEntityFromStateBagName(bagName)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return
    end

    value = value + 0.0
    DecorSetFloat(entity, DecorEnum.FUEL, value)
    SetVehicleFuelLevel(entity, value)
end)

AddEventHandler("fuel:setFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

AddEventHandler("LegacyFuel:setFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

provideExport("LegacyFuel", "GetFuel", function(vehicleEntity)
    return GetFuel(vehicleEntity)
end)

provideExport("LegacyFuel", "SetFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

provideExport("ps-fuel", "GetFuel", function(vehicleEntity)
    return GetFuel(vehicleEntity)
end)

provideExport("ps-fuel", "SetFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

provideExport("cdn-fuel", "GetFuel", function(vehicleEntity)
    return GetFuel(vehicleEntity)
end)

provideExport("cdn-fuel", "SetFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

-- ox_fuel export bridge
provideExport("ox_fuel", "GetFuel", function(vehicleEntity)
    return GetFuel(vehicleEntity)
end)

provideExport("ox_fuel", "SetFuel", function(vehicleEntity, fuelLevel)
    SetFuel(vehicleEntity, fuelLevel)
end)

exports("vehicle_manual", function()
    TriggerEvent("rcore_fuel:checkFuelType")
end)

exports("window_cleaner", function()
    TriggerEvent("rcore_fuel:selectVehicleForCleaning")
end)

exports("fuel_pump", function()
    TriggerEvent("rcore_fuel:selectCarToPumpOut")
end)

