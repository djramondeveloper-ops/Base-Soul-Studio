-- Seoul Base integration: rcore fines use the native Seoul invoice table through the server bridge.
if Config.Invoices == Invoices.NONE then
    HandleInvoice = function(target)
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
        if not retval then return end
        local amount = math.floor(tonumber(retval[tostring(1)]) or 0)
        if amount <= 0 then return end
        CreateInvoice(target, amount)
    end

    CreateInvoice = function(target, amount)
        TriggerServerEvent('rcore_police:server:requestInvoice', target, amount)
    end
end
