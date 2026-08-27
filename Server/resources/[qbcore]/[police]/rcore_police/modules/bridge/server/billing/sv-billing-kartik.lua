-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.KARTIK then
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            local targetBankAccount = exports['kartik-banking']:GetAccountDataBySource(invoice.target.playerId, "fleeca")
            if not targetBankAccount or not targetBankAccount.accountNumber then
                return
            end
            local jobAccount = exports['kartik-banking']:GetAccountDataByOwner("police")
            if jobAccount then
                exports['kartik-banking']:GenerateBill({
                    owner = tostring(targetBankAccount.accountNumber),
                    sender_name = "LSPD",
                    title = invoice.reason,
                    issuer_account_number = tostring(jobAccount.accountNumber),
                    frequency = "custom",
                    custom_frequency_days = 0,
                    amount = invoice.amount,
                    metadata = {
                        type = "one-time",
                    }
                })
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
            local invoice = Framework.BuildInvoicePayload(playerId, targetPlayerId, data.reason, amount)
            if not invoice then
                return
            end
            local targetBankAccount = exports['kartik-banking']:GetAccountDataBySource(invoice.target.playerId, "fleeca")
            if not targetBankAccount or not targetBankAccount.accountNumber then
                return
            end
            local jobAccount = exports['kartik-banking']:GetAccountDataByOwner("police")
            if jobAccount then
                exports['kartik-banking']:GenerateBill({
                    owner = tostring(targetBankAccount.accountNumber),
                    sender_name = "LSPD",
                    title = invoice.reason,
                    issuer_account_number = tostring(jobAccount.accountNumber),
                    frequency = "custom",
                    custom_frequency_days = 0,
                    amount = invoice.amount,
                    metadata = {
                        type = "one-time",
                    }
                })
            end
        end
    end
end)
