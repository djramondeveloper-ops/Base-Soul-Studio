EventLimiterService.RegisterNetEvent("rcore_prison:server:handleQuestTask", 0, 1, function(playerSource, isAllowed, taskData)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        return Framework.sendNotification(
            playerSource,
            _U("GENERAL.YOU_ARE_NOT_PRISONER"),
            "error"
        )
    end

    if type(taskData) ~= "table" then
        return
    end

    local zoneId = taskData.zoneId
    if not IsAtZone(zoneId, playerSource) then
        dbg.debug(
            "Handle quest task: Player named %s is not in zone with ID: %s",
            GetPlayerName(playerSource),
            zoneId
        )

        return Framework.sendNotification(
            playerSource,
            _U("GENERAL.YOU_ARE_FAR_AWAY"),
            "error"
        )
    end

    local action = taskData.action
    dbg.debug("Handle quest task: Executing action: %s", action)

    if action == Actions.SHOW_JAIL_TIME then
        dbg.debug("Handle quest task: Started action - show jail time!")

        local jailTime = tonumber(prisoner.jail_time)
        if not jailTime then
            return
        end

        local remainingTime = Time.DynamicSecondsToClock(jailTime)
        return Framework.sendNotification(
            playerSource,
            _U("GENERAL.REMAINING_JAIL_TIME", remainingTime),
            "info"
        )
    end

    if action == Actions.GET_FREE_FOOD_PACKAGE then
        return CanteenService.GetFreeFoodPackage(playerSource)
    end

    if action == Actions.SHOW_CANTEEN then
        return CanteenService.ShowOffer(playerSource)
    end

    if action == Actions.PRISON_BREAK then
        return StartPrisonBreak(playerSource)
    end

    if action == Actions.RELEASE_PLAYER then
        local jailTime = tonumber(prisoner.jail_time)
        if jailTime and jailTime > 2 then
            local remainingTime = Time.DynamicSecondsToClock(jailTime)
            return Framework.sendNotification(
                playerSource,
                _U("CANNOT_BE_RELEASED", remainingTime),
                "error"
            )
        end

        PrisonService.UnjailCitizen(playerSource, true)
    end
end)
