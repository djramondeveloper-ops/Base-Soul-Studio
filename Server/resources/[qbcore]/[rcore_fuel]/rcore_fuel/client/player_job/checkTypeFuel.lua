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

function CheckFuelTypeForVehicle()
    ShowHelpNotification(_U("manual_guide"), false, true, 10000)
    local veh = LetUserSelectVehicle()
    if not veh or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        ShowNotification(_U("vehicle_not_found") or "No valid vehicle selected.")
        return
    end

    -- V4: prevent stale entity handles after selection/network migration.
    -- A vehicle can disappear between selection and the inspection animation.
    if not NetworkGetEntityIsNetworked(veh) then
        NetworkRegisterEntityAsNetworked(veh)
    end
    if not DoesEntityExist(veh) or GetEntityType(veh) ~= 2 then
        ShowNotification(_U("vehicle_not_found") or "No valid vehicle selected.")
        return
    end

    local ped = PlayerPedId()
    local driver = GetPedInVehicleSeat(veh, -1)
    if driver and driver ~= 0 and driver ~= ped then
        ShowNotification("You cannot inspect a vehicle while someone is driving it.")
        return
    end

    -- Position the player directly in front of the vehicle, centered on its nose.
    -- Using the vehicle's front model bound keeps the distance consistent instead
    -- of scaling the old 2.8m offset by the entire vehicle diagonal.
    local _modelMin, _modelMax = GetModelDimensions(GetEntityModel(veh))
    local frontGap = 0.55
    local walkPos = GetOffsetFromEntityInWorldCoords(
        veh,
        0.0,
        _modelMax.y + frontGap,
        0.0
    )

    -- FIX 8: wrap entire sequence in pcall so veh freeze and door are ALWAYS cleaned up
    FreezeEntityPosition(veh, true)

    local ok, err = pcall(function()
        if not GoToCoordsWithHeadingInTime(ped, walkPos, GetEntityHeading(veh) - 180, 1500) then
            return
        end
        Wait(1000)
        FreezeEntityPosition(ped, true)
        SetEntityHeading(ped, GetEntityHeading(veh) - 180)
        Wait(1000)
        Animation.Play("mechanic")
        Wait(1000)
        Animation.ResetAll()
        SetVehicleDoorOpen(veh, 4, false, false)
        Wait(1000)
        Animation.Play("notepad")
        ShowSubtitle(_U("manual_reading"), 10000)
        Wait(10000)
        Animation.Play("mechanic")
        Wait(1000)
        local fuelType = GetVehicleFuelType(GetEntityModel(veh)) or "petrol"
        ShowSubtitle(_U(fuelType .. "_check") or ("Fuel type: " .. tostring(fuelType)), 10000)
    end)

    -- Always restore state regardless of error
    Animation.ResetAll()
    FreezeEntityPosition(ped, false)
    if DoesEntityExist(veh) then
        SetVehicleDoorShut(veh, 4, false)
        FreezeEntityPosition(veh, false)
    end

    if not ok then
        print("[rcore_fuel] CheckFuelTypeForVehicle error: " .. tostring(err))
    end
end

RegisterNetEvent("rcore_fuel:checkFuelType", CheckFuelTypeForVehicle)
