-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.QS then
        GarageService.GetVehicleProps = function(vehicleId)
            return {}
        end
        GarageService.SetVehicleToImpound = function(vehicleId, vehicleProps)
            local retval = false
            if doesExportExistInResource(Garages.QS, "ImpoundVehicle") then
                exports[Garages.QS]:ImpoundVehicle()
                retval = true
            end
            if not retval then
                VehicleService.ImpoundVehicle(vehicleId)
            end
            dbg.debug('SetVehicleToImpound: Using resource %s to impound closest vehicle with entityId: %s via method: %s', Config.Garages, vehicleId, retval and Config.Garages or "FALLBACK")
        end
    end
end)
