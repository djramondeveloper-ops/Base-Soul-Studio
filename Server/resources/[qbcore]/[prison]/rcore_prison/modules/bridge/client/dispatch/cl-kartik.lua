CreateThread(function()
    if Config.Dispatches == Dispatches.KARTIK then
        RegisterNetEvent('rcore_prison:client:setDispatch', function(payload)
            if source == '' then return end

            if not payload then
                return
            end

            if doesExportExistInResource(Dispatches.KARTIK, "CustomAlert") then
                exports['kartik-mdt']:CustomAlert(payload)
            else
                TriggerServerEvent('kartik-mdt:server:sendDispatchNotification', payload)
            end
        end)
    end
end)
