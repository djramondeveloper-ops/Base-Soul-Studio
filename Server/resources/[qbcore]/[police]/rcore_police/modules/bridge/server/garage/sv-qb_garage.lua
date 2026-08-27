-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.QB_GARAGE then
        RegisterNetEvent('rcore_police:setVehicleToImpound', function(vehicleId, vehicleProps)
            local playerId = source
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not state then
                return
            end
            if not vehicleId then
                return
            end
            if not vehicleProps then
                return
            end
            GarageService.SentToImpound(vehicleProps)
        end)
        GarageService.SentToImpound = function(vehicleProps)
            local plate = vehicleProps and vehicleProps.plate
            local body = vehicleProps and vehicleProps.body or 1000
            local engine = vehicleProps and vehicleProps.engine or 1000
            local fuel = vehicleProps and vehicleProps.fuel or 100
            if not GarageService.IsVehiclePlayerOwned(plate) then
                return false
            end
            MySQL.query(
                'UPDATE player_vehicles SET state = ?, body = ?, engine = ?, fuel = ?, depotprice = ? WHERE plate = ?',
                { 2, body, engine, fuel, 500, plate },
                function(affectedRows)
                end
            )
            return true
        end
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
