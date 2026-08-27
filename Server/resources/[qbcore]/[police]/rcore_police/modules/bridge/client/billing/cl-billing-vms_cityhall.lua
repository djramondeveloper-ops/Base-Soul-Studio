-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.VMS then
        HandleInvoice = function(target)
            exports['vms_cityhall']:openBillingsMenu()
        end
        CreateInvoice = function(target, amount)
        end
    end
end)
