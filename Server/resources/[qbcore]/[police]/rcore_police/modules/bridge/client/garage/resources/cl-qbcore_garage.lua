-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.QB_GARAGE then
        GarageService.GetVehicleProps = function(vehicleId)
            local retval = {}
            if Config.Framework == Framework.QBCore then
                retval = Framework.object.Functions.GetVehicleProperties(vehicleId)
            end
            return retval
        end
        GarageService.SetVehicleToImpound = function(vehicleId, vehicleProps)
            if not vehicleId then
                return
            end
            local plate = GetVehicleNumberPlateText(vehicleId)
            if vehicleProps and vehicleProps.plate ~= plate then
                vehicleProps.plate = plate
            end
            VehicleService.ImpoundVehicle(vehicleId)
            TriggerServerEvent('rcore_police:setVehicleToImpound', vehicleId, vehicleProps)
        end
    end
end)
