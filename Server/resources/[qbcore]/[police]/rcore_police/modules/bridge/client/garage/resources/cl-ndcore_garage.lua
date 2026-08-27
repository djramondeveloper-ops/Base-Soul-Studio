-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.NDCORE then
        GarageService.GetVehicleProps = function(vehicleId)
            return {}
        end
        GarageService.SetVehicleToImpound = function(vehicleId, vehicleProps)
            if not vehicleId then
                return
            end
            TriggerServerEvent('rcore_police:setVehicleToImpound', vehicleId)
        end
    end
end)
