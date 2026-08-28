local function onHandleInvBusy(success, isBusy)
    if not success then
        return
    end

    HandleInventoryBusyState(isBusy)
end

NetworkService.RegisterNetEvent("HandleInvBusy", onHandleInvBusy)