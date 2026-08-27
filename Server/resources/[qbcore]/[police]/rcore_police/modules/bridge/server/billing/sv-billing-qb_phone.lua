-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.QB_PHONE then
        CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed)
            dbg.debug('Speed camera taken fine for this vehicle: %s - but you need to integrate this to your billing resource (sv-billing-qb-phone.lua)', vehiclePlate)
        end
        CreateInvoiceToPlayerInVehicle = function(playerId, targetPlayerId, amount, data)
            if not playerId then
                return
            end
            if not targetPlayerId then
                return
            end
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            db.InsertQBPhoneInvoice(invoice.target.identifier, invoice.amount, data and data.job or invoice.initiator.job or 'police', invoice.initiator.name, invoice.initiator.identifier)
            TriggerClientEvent('qb-phone:RefreshPhone', targetPlayerId)
            Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            Framework.sendNotification(targetPlayerId, _U('INVOICES.TARGET_SUCCESS_RECEIVED_INVOICE_FROM_PLAYEr'), 'success')
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            db.InsertQBPhoneInvoice(invoice.target.identifier, invoice.amount, data and data.job or invoice.initiator.job or 'police', invoice.initiator.name, invoice.initiator.identifier)
            TriggerClientEvent('qb-phone:RefreshPhone', targetPlayerId)
            Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            Framework.sendNotification(targetPlayerId, _U('INVOICES.TARGET_SUCCESS_RECEIVED_INVOICE_FROM_PLAYEr'), 'success')
        end
    end
end)
