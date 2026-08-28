AddEventHandler("rcore_prison:shared:internal:MapLoaded", function()
    JobService.RegisterInit()
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestJob", 0, 1, function(playerSource, isAllowed, jobId)
    if not isAllowed then
        return
    end

    JobService.RequestJob(playerSource, jobId)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestOpenJobMenu", 0, 1, function(playerSource, isAllowed)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        dbg.debug(
            "Request job menu - player named %s is not prisoner.",
            GetPlayerName(playerSource),
            playerSource
        )

        return Framework.sendNotification(
            playerSource,
            _U("GENERAL.YOUT_ARE_NOT_PRISONER"),
            "error"
        )
    end

    local prisonAccount = PrisonAccountService.getPlayer(playerSource)
    if prisonAccount then
        dbg.debug(
            "Request job menu - player named %s is opening job menu.",
            GetPlayerName(playerSource),
            playerSource
        )

        StartClient(playerSource, "openJobMenu")
        return
    end

    dbg.debug(
        "Request job menu - player named %s is not having prison account.",
        GetPlayerName(playerSource),
        playerSource
    )

    Framework.sendNotification(
        playerSource,
        _U("GENERAL.YOU_DONT_HAVE_PRISONER_ACCOUNT"),
        "error"
    )
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:finishJobTask", 0, 1, function(playerSource, isAllowed, jobId, taskId)
    if not isAllowed then
        return
    end

    JobService.FinishJobTask(playerSource, jobId, taskId)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:leaveJobTask", 0, 1, function(playerSource, isAllowed, jobId, taskId, reason)
    if not isAllowed then
        return
    end

    JobService.LeaveJobTask(playerSource, jobId, taskId, reason)
end)