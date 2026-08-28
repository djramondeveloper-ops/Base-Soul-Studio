local prisonerAccountData = {}
local isAwaitingRegistration = false
local registrationPromise = nil

NetworkService.RegisterNetEvent("UpdatePrisonerAccount", function(success, accountData)
    FrontendService.AwaitFrontend()

    if not success then
        return
    end

    dbg.debug("Prisoner account data received: %s", json.encode(accountData))

    prisonerAccountData = accountData or {}

    if isAwaitingRegistration and registrationPromise then
        registrationPromise:resolve(true)
    end

    FrontendService.SendReactMessage("syncPrisonerAccount", accountData)
end)

NetworkService.EventListener("heartbeat", function(eventName)
    if eventName ~= HEARTBEAT_EVENTS.PRISONER_RELEASED then
        return
    end

    if Config.Accounts.DeleteAccountWhenReleased then
        PrisonerAccountService.Reset()
    end
end)

RegisterNuiCallback(NUI_CALLBACKS.REGISTER_PRISONER_ACCOUNT, function(data, cb)
    isAwaitingRegistration = true
    registrationPromise = promise.new()

    if data then
        TriggerServerEvent("rcore_prison:server:registerPrisonerAccount", SH.zoneId)
    end

    Citizen.Await(registrationPromise)

    SetTimeout(250, function()
        if not isAwaitingRegistration then
            return
        end

        isAwaitingRegistration = false
        prisonerAccountData = {}

        FrontendService.HandleFocus(true)
        FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
            screen = "ACCOUNT",
            visible = true,
        })
    end)

    cb(prisonerAccountData)
end)

RegisterNuiCallback(NUI_CALLBACKS.EXECUTE_PRISONER_ACCOUNT, function(data, cb)
    if data then
        TriggerServerEvent(
            "rcore_prison:server:executePrisonerAccountTask",
            SH.zoneId,
            data
        )
    end

    cb("OK")
end)

RegisterNuiCallback(NUI_CALLBACKS.GET_PRISON_LOGS, function(_, cb)
    local logs = callback.await("rcore_prison:server:getAllTransactions", false)
    cb(logs)
end)

RegisterNuiCallback(NUI_CALLBACKS.GET_PRISONER_ACCOUNT_LOGS, function(_, cb)
    local logs = callback.await("rcore_prison:server:getPrisonerAccountLogs", false)
    cb(logs)
end)
