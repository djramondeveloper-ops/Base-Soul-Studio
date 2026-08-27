-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.TGG then
        RegisterNetEvent('rcore_police:server:requestInvoice', function(target, amount)
            local playerId = source
            CreateInvoice(playerId, target, amount)
        end)
        CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed)
            dbg.debug(
            'Speed camera taken fine for this vehicle: %s - but you need to integrate this to your billing resource (sv-billing-standalone.lua)',
                vehiclePlate)
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
            local invoiceData = {
                items = {
                    {
                        key = invoice.reason:lower(),
                        label = invoice.reason,
                        price = invoice.amount,
                        quantity = 1,
                        priceChange = false,
                        quantityChange = false
                    }
                },
                total = invoice.amount,
                notes = '-',
                sender = data and data.job or invoice.initiator.job or 'police',
                senderId = invoice.initiator.identifier,
                senderName = data and data.job or invoice.initiator.job or 'police',
                recipientId = invoice.target.identifier,
                recipientName = invoice.target.name,
                taxPercentage = 0,
                senderCompanyName = data and data.job or invoice.initiator.job or 'police'
            }
            if not doesExportExistInResource(Invoices.TGG, "CreateInvoice") then
                return
            end
            local invoice = exports[Invoices.TGG]:CreateInvoice(invoiceData)
            if invoice then
                dbg.debug('Invoice was created using resource: %s', Config.Invoices)
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
            if not data.reason then
                data.reason = "Fine"
            end
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            local invoiceData = {
                items = {
                    {
                        key = invoice.reason:lower(),
                        label = invoice.reason,
                        price = invoice.amount,
                        quantity = 1,
                        priceChange = false,
                        quantityChange = false
                    }
                },
                total = invoice.amount,
                notes = '-',
                sender = data and data.job or invoice.initiator.job or 'police',
                senderId = invoice.initiator.identifier,
                senderName = data and data.job or invoice.initiator.job or 'police',
                recipientId = invoice.target.identifier,
                recipientName = invoice.target.name,
                taxPercentage = 0,
                senderCompanyName = data and data.job or invoice.initiator.job or 'police'
            }
            if not doesExportExistInResource(Invoices.TGG, "CreateInvoice") then
                return
            end
            local invoice = exports[Invoices.TGG]:CreateInvoice(invoiceData)
            if invoice then
                dbg.debug('Invoice was created using resource: %s', Config.Invoices)
            end
        end
    end
end)
