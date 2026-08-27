-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Invoices == Invoices.OKOK then
        NetworkService.RegisterNetEvent('GenerateInvoiceFromServer', function(validRequest, invoice)
            if validRequest then
                TriggerServerEvent("okokBilling:CreateCustomInvoice", invoice.initiator.playerId, invoice.amount, 'Fine', invoice.target.playerId, invoice.initiator.job, invoice.society)
            end
        end)
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
            if not retval then
                return 
            end
            local amount = retval[tostring(1)]
            if not amount then
                return
            end
            CreateInvoice(target, amount)
        end
        CreateInvoice = function(targetPlayerId, amount)
            local job = Framework.job
            local society = ('%s_%s'):format(Config.Business.SocietyPrefix, job.name)
            if society then
                Framework.sendNotification(_U("SENT_FINE"), "success")
                dbg.debug('CreateInvoice: Using resource %s sending event named: %s', Config.Invoices, 'okokBilling:CreateCustomInvoice')
                if Config.Debug then
                    local retval = {
                        target = targetPlayerId, 
                        amount = amount, 
                        initiator = MyServerId, 
                        job = job, 
                        society = society
                    }
                    if retval and next(retval) then
                        tprint(retval)
                    end
                end
                TriggerServerEvent("okokBilling:CreateCustomInvoice", targetPlayerId, amount, 'Fine', MyServerId, job.name, society)
            end
        end
    end
end)
