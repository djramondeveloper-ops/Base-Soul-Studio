-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.VMS then
        CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed)
            dbg.debug('Speed camera taken fine for this vehicle: %s - but you need to integrate this to your billing resource', vehiclePlate)
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
            local invoiceData = {
                society = invoice.society,
                job = data and data.job or invoice.initiator.job or 'police',
                jobLabel = invoice.initiator.label,
                issuerName = invoice.initiator.name,
                dateToPay = -1,
                percentageForSociety = 100,
                invoiceData = {
                    {qty = 1, unitPrice = invoice.amount, description = invoice.reason},
                },
            }
            if not doesExportExistInResource(Invoices.VMS, "giveBill") then
                return
            end
            exports['vms_cityhall']:giveBill(targetPlayerId, 'invoice', invoiceData, false, function(fineId)
                Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            end)
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
            local invoiceData = {
                society = invoice.society,
                job = data and data.job or invoice.initiator.job or 'police',
                jobLabel = invoice.initiator.label,
                issuerName = invoice.initiator.name,
                dateToPay = -1,
                percentageForSociety = 100,
                invoiceData = {
                    {qty = 1, unitPrice = invoice.amount, description = invoice.reason},
                },
            }
            if not doesExportExistInResource(Invoices.VMS, "giveBill") then
                return
            end
            exports['vms_cityhall']:giveBill(targetPlayerId, 'invoice', invoiceData, false, function(fineId)
                Framework.sendNotification(playerId, _U('INVOICES.INITIATOR_SUCCESS_SENT_INVOICE_TO_PLAYER'), 'success')
            end)
        end
    end
end)
