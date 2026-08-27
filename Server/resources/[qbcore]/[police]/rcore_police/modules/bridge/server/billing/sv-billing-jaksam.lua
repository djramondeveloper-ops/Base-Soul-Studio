-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.JAKSAM then
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            if not doesExportExistInResource('billing_ui', 'createBill') then
                return
            end
            exports["billing_ui"]:createBill(invoice.initiator.identifier, invoice.target.identifier, invoice.reason, amount, invoice.society, 'society')
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            if not doesExportExistInResource('billing_ui', 'createBill') then
                return
            end
            exports["billing_ui"]:createBill(invoice.initiator.identifier, invoice.target.identifier, invoice.reason, amount, invoice.society, 'society')
        end
    end
end)
