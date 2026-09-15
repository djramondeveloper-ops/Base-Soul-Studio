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

-- everything here is client sided!

--- @param vehicleEntity number
--- @param vehicleHash number
--- @param vehicleModelName string
--- @param vehiclePlate string ( non trimmed )
Config.GiveVehicleKeys = function(vehicleEntity, vehicleHash, vehicleModelName, vehiclePlate)
    if not vehicleEntity or vehicleEntity == 0 or not DoesEntityExist(vehicleEntity) then
        return
    end
    local trimmedPlate = Trim(vehiclePlate)

    if IsResourceOnServer("qbx_vehiclekeys") then
        if lib and lib.callback and NetworkGetEntityIsNetworked(vehicleEntity) then
            pcall(function()
                lib.callback.await('qbx_vehiclekeys:server:giveKeys', false, VehToNet(vehicleEntity))
            end)
        end
        TriggerEvent("qb-vehiclekeys:client:AddKeys", trimmedPlate)
        return
    end

    if IsResourceOnServer("wasabi_carlock") then
        exports.wasabi_carlock:GiveKey(trimmedPlate)
        return
    end

    if IsResourceOnServer("Renewed-Vehiclekeys") then
        exports['Renewed-Vehiclekeys']:addKey(trimmedPlate)
        return
    end

    if IsResourceOnServer("MrNewbVehicleKeys") then
        exports.MrNewbVehicleKeys:GiveKeysByPlate(trimmedPlate)
        return
    end

    if IsResourceOnServer("mk_vehiclekeys") then
        exports["mk_vehiclekeys"]:AddKey(vehicleEntity)
        return
    end

    if IsResourceOnServer("vehicles_keys") or IsResourceOnServer("jaksam-vehicles-keys") then
        TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', trimmedPlate)
        return
    end

    if IsResourceOnServer("t1ger_keys") then
        exports['t1ger_keys']:GiveTemporaryKeys(trimmedPlate, vehicleModelName or "", '')
        return
    end

    if IsResourceOnServer("tgiann-hotwire") then
        exports["tgiann-hotwire"]:GiveKeyPlate(trimmedPlate, true)
        return
    end

    if IsResourceOnServer("qb-vehiclekeys") then
        TriggerEvent("qb-vehiclekeys:client:AddKeys", trimmedPlate)
        return
    end

    if IsResourceOnServer("rcore_garage") then
        TriggerServerEvent("rcore_garage:GivePlayerKey", trimmedPlate)
        return
    end

    if IsResourceOnServer("fivecode_carkeys") then
        exports.fivecode_carkeys:GiveKey(vehicleEntity, false, true)
        return
    end

    if IsResourceOnServer("cd_garage") then
        TriggerEvent('cd_garage:AddKeys', exports["cd_garage"]:GetPlate(vehicleEntity))
        return
    end

    if IsResourceOnServer("qs-vehiclekeys") then
        exports['qs-vehiclekeys']:GiveKeys(trimmedPlate, vehicleModelName)
        return
    end

    if IsResourceOnServer("xd_locksystem") then
        exports['xd_locksystem']:SetVehicleKey(trimmedPlate)
        return
    end
end

--- @param vehicleEntity number
--- @param vehicleHash number
--- @param vehicleModelName string
--- @param vehiclePlate string ( non trimmed )
Config.RemoveVehicleKeys = function(vehicleEntity, vehicleHash, vehicleModelName, vehiclePlate)
    if not vehicleEntity or vehicleEntity == 0 or not DoesEntityExist(vehicleEntity) then
        return
    end
    vehiclePlate = vehiclePlate or GetVehicleNumberPlateText(vehicleEntity)
    local trimmedPlate = Trim(vehiclePlate)

    if IsResourceOnServer("qbx_vehiclekeys") then
        TriggerEvent("qb-vehiclekeys:client:RemoveKeys", trimmedPlate)
        return
    end

    if IsResourceOnServer("wasabi_carlock") then
        exports.wasabi_carlock:RemoveKey(trimmedPlate)
        return
    end

    if IsResourceOnServer("Renewed-Vehiclekeys") then
        exports['Renewed-Vehiclekeys']:removeKey(trimmedPlate)
        return
    end

    if IsResourceOnServer("MrNewbVehicleKeys") then
        exports.MrNewbVehicleKeys:RemoveKeysByPlate(trimmedPlate)
        return
    end

    if IsResourceOnServer("mk_vehiclekeys") then
        exports["mk_vehiclekeys"]:RemoveKey(vehicleEntity)
        return
    end

    if IsResourceOnServer("tgiann-hotwire") then
        -- tgiann-hotwire does not provide a removal export
        return
    end

    if IsResourceOnServer("qb-vehiclekeys") then
        TriggerEvent("qb-vehiclekeys:client:RemoveKeys", trimmedPlate)
        return
    end

    if IsResourceOnServer("rcore_garage") then
        TriggerServerEvent("rcore_garage:RemovePlayerKey", trimmedPlate)
        return
    end

    if IsResourceOnServer("fivecode_carkeys") then
        exports.fivecode_carkeys:GiveKey(vehicleEntity, false, false)
        return
    end

    if IsResourceOnServer("cd_garage") then
        return
    end

    if IsResourceOnServer("qs-vehiclekeys") then
        exports['qs-vehiclekeys']:RemoveKeys(trimmedPlate, vehicleModelName)
        return
    end

    if IsResourceOnServer("xd_locksystem") then
        exports['xd_locksystem']:SetVehicleKey(trimmedPlate, true)
        return
    end
end

--- @param value string
function Trim(value)
    if not value then return "" end
    return (string.gsub(tostring(value), "^%s*(.-)%s*$", "%1"))
end
