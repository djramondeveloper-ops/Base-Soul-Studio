-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.QS then
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason or data.name, amount)
            if not invoice then
                return
            end
            if doesExportExistInResource(Invoices.QS, "ServerCreateInvoice") then
                exports[Invoices.QS]:ServerCreateInvoice(invoice.target.playerId, '', data.name or '', invoice.amount, true, false, false, false, invoice.society)
            else
                dbg.debug("Using older version of qs_billing which doesnt support this export")
                StartClient(playerId, "RequestInvoice", targetPlayerId, amount)
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason or data.name, amount)
            if not invoice then
                return
            end
            if doesExportExistInResource(Invoices.QS, "ServerCreateInvoice") then
                exports[Invoices.QS]:ServerCreateInvoice(invoice.target.playerId, '', invoice.reason, invoice.amount, true, false, false, false, invoice.society)
            else
                dbg.debug("Using older version of qs_billing which doesnt support this export")
                StartClient(playerId, "RequestInvoice", targetPlayerId, amount)
            end
            Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
        end
    end
end)
