NetworkService.RegisterNetEvent("Notify", function(success, notificationData)
    if not success then
        return
    end

    Framework.sendNotification(notificationData)
end)