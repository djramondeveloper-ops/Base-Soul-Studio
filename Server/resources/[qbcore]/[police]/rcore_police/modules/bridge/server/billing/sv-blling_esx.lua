-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.ESX_BILLING then
        CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed)
            dbg.debug('Speed camera taken fine for this vehicle: %s - but you need to integrate this to your billing resource (sv-billing_esx.lua)', vehiclePlate)
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
            if not doesExportExistInResource(Invoices.ESX_BILLING, "BillPlayer") then
                dbg.debug("Using older version of esx_billing which doesnt support this export")
                StartClient(playerId, "RequestInvoice", targetPlayerId, amount)
            else
                exports[Invoices.ESX_BILLING]:BillPlayer(invoice.target.playerId, invoice.initiator.identifier, invoice.society, invoice.reason, invoice.amount)
            end
            Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
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
            if not doesExportExistInResource(Invoices.ESX_BILLING, "BillPlayer") then
                dbg.debug("Using older version of esx_billing which doesnt support this export")
                StartClient(playerId, "RequestInvoice", targetPlayerId, amount)
            else
                exports[Invoices.ESX_BILLING]:BillPlayer(invoice.target.playerId, invoice.initiator.identifier, invoice.society, invoice.reason, invoice.amount)
            end
            Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
        end
    end
end)
