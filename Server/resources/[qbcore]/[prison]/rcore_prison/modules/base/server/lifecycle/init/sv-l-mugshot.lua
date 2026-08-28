EventLimiterService.RegisterNetEvent("rcore_prison:server:syncMugshot", 0, 1, function(playerSource, isAllowed, mugshotData)
    if not isAllowed then
        return
    end

    if not Config.Mugshot then
        return dbg.debug(
            "Mugshot is disabled when syncing mugshot for user: %s -> returning!",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        return dbg.debug(
            "syncMugshot Prisoner not found when syncing mugshot for user: %s",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage then
        return dbg.debug(
            "syncMugshot Prisoner storage not found when syncing mugshot for user: %s",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    if prisonerStorage.MugshotDefinedForPrisoner(playerSource) then
        return dbg.debug(
            "syncMugshot Prisoner mugshot is defined when syncing mugshot for user: %s",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    if not mugshotData then
        return dbg.debug(
            "syncMugshot Prisoner mugshot data are missing for user named: %s",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    if mugshotData.id ~= playerSource then
        return dbg.debug(
            "syncMugshot Prisoner playerId is not matching the mugshot source which was sent for user: %s",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    if prisoner.mugshot then
        prisonerStorage.UpdatePlayerDataByKey("mugshotState", true, playerSource)
    end
end)
