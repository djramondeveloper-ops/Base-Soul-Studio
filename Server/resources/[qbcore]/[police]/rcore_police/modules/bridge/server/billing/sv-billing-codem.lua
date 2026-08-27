-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.CODEM then
        RegisterNetEvent('rcore_police:server:requestInvoice', function(target, amount)
            local playerId = source
            CreateInvoice(playerId, target, amount)
        end)
        CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed)
            dbg.debug('Speed camera taken fine for this vehicle: %s - but you need to integrate this to your billing resource (sv-billing-standalone.lua)', vehiclePlate)
        end
        CreateInvoiceToPlayerInVehicle = function(playerId, targetPlayerId, amount, data)
            if not playerId then
                return
            end
            if not targetPlayerId then
                return
            end
            if not data then
                data = {}
            end
            if doesExportExistInResource(Invoices.CODEM, "createBilling") then
                exports[Invoices.CODEM]:createBilling(playerId, targetPlayerId, amount, data.reason or '', true)
            else
                dbg.critical('Invoices: Failed to create invoice since cannot found export named createBilling - reach out to authors / update your resources %s', Config.Society)
            end
        end
        CreateInvoice = function(playerId, targetPlayerId, amount, data)
            if not playerId then
                return
            end
            if not targetPlayerId then
                return
            end
            if not Utils.IsPlayerNearAnotherPlayer(playerId, targetPlayerId) then
                return
            end
            if not data then
                data = {}
            end
            if doesExportExistInResource(Invoices.CODEM, "createBilling") then
                exports[Invoices.CODEM]:createBilling(playerId, targetPlayerId, amount, data.reason or '', true)
            else
                dbg.critical('Invoices: Failed to create invoice since cannot found export named createBilling - reach out to authors / update your resources %s', Config.Society)
            end
        end
    end
end)
