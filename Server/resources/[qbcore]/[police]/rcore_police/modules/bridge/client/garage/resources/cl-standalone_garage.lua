-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.NONE then
        GarageService.GetVehicleProps = function(vehicleId)
            local retval = {}
            if Config.Framework == Framework.ESX then
                retval = Framework.object.Game.GetVehicleProperties(vehicleId)
            end
            return retval
        end
        GarageService.SetVehicleToImpound = function(vehicleId, vehicleProps)
            if not vehicleId then
                return
            end
            if not vehicleProps then
                return
            end
            VehicleService.ImpoundVehicle(vehicleId)
        end
    end
end)
