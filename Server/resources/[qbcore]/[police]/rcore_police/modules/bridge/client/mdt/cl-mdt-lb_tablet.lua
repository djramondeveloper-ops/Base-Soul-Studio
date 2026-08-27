CreateThread(function()
    if Config.MDT ~= MDT.LB_TABLET then return end

    AddEventHandler('rcore_police:client:showMDT', function()
        if GetResourceState('lb-tablet') ~= 'started' then
            return Framework.sendNotification('LB Tablet nao esta iniciado.', 'error')
        end

        local ok = pcall(function()
            exports['lb-tablet']:ToggleOpen(true)
        end)
        if not ok then
            Framework.sendNotification('Nao foi possivel abrir o LB Tablet.', 'error')
        end
    end)
end)
