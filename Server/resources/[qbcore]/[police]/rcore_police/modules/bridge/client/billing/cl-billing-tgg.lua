-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.TGG then
        HandleInvoice = function(target)
            if isResourcePresentProvideless('vms_cityhall') then
                dbg.debug('Invoice: Detected vms_cityhall using it')
                exports['vms_cityhall']:openBillingsMenu()
                return false
            end
            local retval = UI.Input(_U('INVOICES.INPUT_INVOICE_MENU_TITLE'), {
                {
                    label = _U("PLAYER_NAME_INPUT"),
                    placeholder = getPlayerLabelByShowMode(target),
                    type = "input",
                    disabled = true
                },
                {
                    label = _U('INVOICES.INPUT_INVOICE_FINE_LABEL'),
                    placeholder = "",
                    type = "number",
                    required = true
                },
            })
            if not retval then
                return 
            end
            local amount = retval[tostring(1)]
            if not amount then
                return
            end
            CreateInvoice(target, amount)
        end
        CreateInvoice = function(target, amount)
            dbg.debug('Creating invoice for target %s with amount %s', target, amount)
            TriggerServerEvent('rcore_police:server:createInvoice', target, amount)
        end
    end
end)
