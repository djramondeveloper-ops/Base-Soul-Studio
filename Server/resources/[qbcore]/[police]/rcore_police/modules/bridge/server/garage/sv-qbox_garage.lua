-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Garages == Garages.QBOX_GARAGE then
        RegisterNetEvent('rcore_police:setVehicleToImpound', function(vehicleId)
            local playerId = source
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not state then
                return
            end
            if doesExportExistInResource(Garages.QBOX_GARAGE, 'SetVehicleGarage') then
                return exports[Garages.QBOX_GARAGE]:SetVehicleGarage(vehicleId, 'impoundlot')
            end
        end)
        GarageService.IsVehiclePlayerOwned = function(plate)
            if not plate then
                return false
            end
            local retval = false
            if doesExportExistInResource('qbx_vehicles', 'GetVehicleIdByPlate') then
                local vehicle = exports.qbx_vehicles:GetVehicleIdByPlate(plate)
                if vehicle then
                    retval = true
                end
            end
            return retval
        end
    end
end)
