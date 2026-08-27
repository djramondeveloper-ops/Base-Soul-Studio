-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.JAKSAM then
        HandleInvoice = function(targetPlayerId)
            TriggerEvent("billing_ui:openBillingMenu", targetPlayerId)
        end
        CreateInvoice = function(targetPlayerId, amount)
            TriggerServerEvent('rcore_police:server:requestInvoice', targetPlayerId, amount)
        end
    end
end)
