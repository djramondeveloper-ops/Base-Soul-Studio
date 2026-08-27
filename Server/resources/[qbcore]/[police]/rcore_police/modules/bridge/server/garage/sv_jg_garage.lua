-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local CachedJobGarages = {}
CreateThread(function()
    if Config.Garages == Garages.JG then
        AddEventHandler('rcore_police:server:requestGarages', function(source)
            if not source then
                return
            end
            local playerId = source
            if CachedJobGarages and next(CachedJobGarages) then
                StartClient(playerId, "setJobGarages", CachedJobGarages)
            end
        end)
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
        GarageService.RegisterCache = function()
            if doesExportExistInResource(Garages.JG, "getAllGarages") then
                local success, garages = xpcall(function()
                    return exports[Garages.JG]:getAllGarages()
                end, function(err)
                    dbg.debug("RegisterCache: Error while calling getAllGarages: " .. tostring(err))
                    return nil
                end)
                if success and garages and type(garages) == "table" and next(garages) then
                    for index, garage in pairs(garages) do
                        local garageId = garage.name
                        if GetDepartmentConfig(garageId) then
                            CachedJobGarages[garageId] = garage
                        end
                    end
                end
            else
                dbg.debug('RegisterCache: Resource %s is missing export getAllGarages, switching to built-in garages!', Config.Garages)
            end
        end
        GarageService.RegisterCache()
    end
end)
