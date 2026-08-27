if Config.Dispatch == Dispatch.LB_TABLET then
    AddEventHandler('rcore_police:client:showDispatch', function()
        if GetResourceState(Dispatch.LB_TABLET) ~= 'started' then
            return Framework.sendNotification('LB Tablet nao esta iniciado.', 'error')
        end

        local ok, visible = pcall(function()
            return exports[Dispatch.LB_TABLET]:IsDispatchVisible()
        end)

        if not ok then
            return Framework.sendNotification('Nao foi possivel consultar a Central do LB Tablet.', 'error')
        end

        local toggled = pcall(function()
            exports[Dispatch.LB_TABLET]:ToggleDispatchVisible(not visible)
        end)

        if not toggled then
            Framework.sendNotification('Nao foi possivel abrir a Central do LB Tablet.', 'error')
        end
    end)
end
