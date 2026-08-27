-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.NONE then
        GarageService.IsVehiclePlayerOwned = function(plate)
            if not plate then
                return false
            end
            return db.IsVehicleOwnedByPlateGarage(plate)
        end
        GarageService.GetVehicleInfo = function(plate)
            local retval = {
                plate = plate
            }
            local isOwnedVehicle, vehicleInfo = db.GetVehicleOwnerInfoByPlate(plate)
            if isOwnedVehicle and vehicleInfo then
                retval.vehicle_owner = vehicleInfo.vehicle_owner
                retval.owner_phone_number = vehicleInfo.phone_number
                if IS_QB[Config.Framework] then
                    retval.owner_identifier = vehicleInfo.identifier
                end
            end
            if Config.VehicleInfo.NotOwnedVehicleFakeInfo and not isOwnedVehicle then
                retval.vehicle_owner = RandomNames[math.random(1, #RandomNames)]
                retval.owner_identifier = generateFakeIdentifier()
                retval.owner_phone_number = generateFakePhoneNumber()
            end
            return retval
        end
    end
end)
