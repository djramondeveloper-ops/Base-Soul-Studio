local allowedAccountActions = {
    DEPOSIT = true,
    WITHDRAW = true
}

EventLimiterService.RegisterNetEvent("rcore_prison:server:registerPrisonerAccount", 0, 1, function(playerSource, isAllowed, _)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        return Framework.sendNotification(playerSource, "You are not a prisoner", "error")
    end

    local prisonAccount = PrisonAccountService.getPlayer(playerSource)
    if not prisonAccount then
        PrisonAccountService.createAccount(playerSource)
    else
        PrisonAccountService.LoadAccount(playerSource)
    end
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:executePrisonerAccountTask", 0, 1, function(playerSource, isAllowed, isTaskAllowed, taskData)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        return Framework.sendNotification(playerSource, "You are not a prisoner", "error")
    end

    if not isTaskAllowed or type(taskData) ~= "table" then
        return
    end

    local prisonAccount = PrisonAccountService.getPlayer(playerSource)
    if not prisonAccount then
        return
    end

    local action = taskData.action
    local amount = taskData.amount and tonumber(taskData.amount) or nil

    if not allowedAccountActions[action] or not amount then
        return
    end

    local transactionCreated = PrisonAccountService.CreateTransaction(playerSource, action, amount)
    if transactionCreated then
        StartClient(playerSource, "UpdatePrisonerAccount", prisonAccount)
    end
end)
