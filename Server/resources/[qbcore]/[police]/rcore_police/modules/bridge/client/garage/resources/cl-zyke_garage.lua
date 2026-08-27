-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.ZYKE then
        GarageService.GetVehicleProps = function(vehicleId)
            return {}
        end
        GarageService.SetVehicleToImpound = function(vehicleId, vehicleProps)
            if DoesEntityExist(vehicleId) then
                VehicleService.ImpoundVehicle(vehicleId)
                exports["zyke_garages"]:OpenImpounderMenu()
            end
            dbg.debug('SetVehicleToImpound: Using resource %s to impound closest vehicle with entityId: %s', Config.Garages, vehicleId)
        end
    end
end)
