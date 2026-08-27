-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.VIVUM then
        RegisterNetEvent('rcore_police:server:requestInvoice', function(target, amount, reason)
            local playerId = source
            CreateInvoice(playerId, target, amount, {
                reason = reason
            })
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
            local reason = ''
            if data and data.reason then
                reason = data.reason
            end
            if data.job then
                reason = 'Speed camera'
            end
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, reason, amount)
            if not invoice then
                return
            end
            if not doesExportExistInResource(Invoices.VIVUM, "SendInvoice") then
                return
            end
            local invoiceData = {
                sender = data and data.job or data and data.job or invoice.initiator.job or 'police',
                sender_label = 'Me',
                recipient = invoice.target.identifier,
                recipient_label = data and data.job or invoice.initiator.label,
                amount = invoice.amount,
                payments_num = 1,
                payments_period = 5,
                summary = invoice.reason
            }
            exports["vivum-billing"]:SendInvoice(targetPlayerId, invoiceData, function(res)
                Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            end, true)
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
            if not doesExportExistInResource(Invoices.VIVUM, "SendInvoice") then
                return
            end
            local invoiceData = {
                sender = data and data.job or data and data.job or invoice.initiator.job or 'police',
                sender_label = 'Me',
                recipient = invoice.target.identifier,
                recipient_label = data and data.job or invoice.initiator.label,
                amount = invoice.amount,
                payments_num = 1,
                payments_period = 5,
                summary = data and data.name or invoice.reason or 'Speed camera'
            }
            exports["vivum-billing"]:SendInvoice(targetPlayerId, invoiceData, function(res)
                Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            end, true)
        end
    end
end)
