-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.NDCORE then
        RegisterNetEvent('rcore_police:setVehicleToImpound', function(vehicleId)
            local playerId = source
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not state then
                return
            end
            local vehicle = NDCore.getVehicle(vehicleId)
            if not vehicle then 
                return
            end
            vehicle.setMetadata("impoundReclaimPrice", 500)
            vehicle.setStatus("impounded", true)
        end)
        GarageService.IsVehiclePlayerOwned = function(plate, vehicleId)
            local retval = false
            if not plate then
                return retval
            end
            local vehicle = NDCore.getVehicle(vehicleId)
            if vehicle then
                retval = true
            end
            return retval
        end
        GarageService.GetVehicleInfo = function(plate, vehicleId)
            local retval = {}
            if not plate then
                return retval
            end
            retval.vehicle_owner = RandomNames[math.random(1, #RandomNames)]
            retval.owner_identifier = generateFakeIdentifier()
            retval.owner_phone_number = generateFakePhoneNumber()
            return retval
        end
    end
end)
