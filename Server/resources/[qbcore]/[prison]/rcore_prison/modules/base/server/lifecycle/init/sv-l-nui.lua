local function canUseMdw(playerSource)
    if Framework.canPerformJobCommand(playerSource) then
        return true
    end

    dbg.debug(
        "Player named %s tried to execute a MDW quick action without permission",
        GetPlayerName(playerSource),
        playerSource
    )

    return false
end

local function getOnlineTargetSource(playerId)
    local targetSource = tonumber(playerId)
    if not targetSource then
        return nil
    end

    if GetPlayerPed(targetSource) <= 0 then
        dbg.debug("Player is not online", GetPlayerName(targetSource), targetSource)
        return nil
    end

    return targetSource
end

EventLimiterService.RegisterNetEvent("rcore_prison:server:executeMDWQuickAction", 0, 1, function(playerSource, isAllowed, requestData)
    if not isAllowed or not canUseMdw(playerSource) then
        return
    end

    local action = requestData.action
    local data = requestData.data or {}
    local charId = data.charId
    local characterId = data.characterId
    local amount = tonumber(data.amount)
    local actionExecuted = false

    dbg.debug(
        "Player named %s is executing a MDW quick action: %s",
        GetPlayerName(playerSource),
        action
    )

    if action == "RELEASE_PLAYER" and charId then
        local prisoner = PrisonService.getPlayerById(charId)
        if not prisoner then
            dbg.debug("Player with charId: %s is not found!", charId)
            return
        end

        if not prisoner.source then
            dbg.debug("Player named %s is not online, doing offline unjail!", prisoner.prisonerName)
            actionExecuted = PrisonService.UnjailOfflineCitizen(charId)
        else
            local shouldTeleport = data.TELEPORT_PLAYER

            dbg.debug(
                "Player named %s is releasing player named %s with state: %s",
                GetPlayerName(playerSource),
                prisoner.name,
                shouldTeleport
            )

            PrisonService.UnjailCitizen(prisoner.source, shouldTeleport)
            actionExecuted = true

            Framework.sendNotification(
                playerSource,
                _U("GENERAL.TARGET_PLAYER_HAS_BEEN_RELEASED"),
                "success"
            )
        end

        StartClient(-1, "updatePrisoner", prisoner)
    elseif action == "RELEASE_PLAYER" and characterId then
        local targetSource = GetPlayerByCharacterId(characterId)
        if not targetSource then
            dbg.debug("Player with charId: %s is not found!", characterId)
            return
        end

        COMSService.ReleaseUser(targetSource)
        actionExecuted = true

        Framework.sendNotification(
            playerSource,
            _U("GENERAL.TARGET_PLAYER_HAS_BEEN_RELEASED"),
            "success"
        )
    elseif action == "EDIT_SENTENCE" then
        local prisoner = PrisonService.getPlayerById(charId)
        local targetReference = prisoner and prisoner.source or charId
        local officerName = Framework.getCharacterName(playerSource)
        local targetName = ""

        if targetReference then
            targetName = Framework.getCharacterName(targetReference) or ""
        end

        local convertedTime = amount
        if amount then
            convertedTime = Time.ConvertTimeFromSeconds(amount, Config.Time)
        end

        local formattedTime = convertedTime
        if convertedTime then
            formattedTime = Time.DynamicSecondsToClock(convertedTime)
        end

        local _ = _U(
            "LOGS_ACTIONS.LOG_CITIZEN_CHANGED_SENTENCE_BY_OFFICER",
            targetName,
            officerName,
            formattedTime
        )

        PrisonService.EditSentence(charId, amount, playerSource)
        actionExecuted = true

        StartClient(-1, "updatePrisoner", prisoner)
    end

    dbg.debug(
        "Player named %s is executing a MDW quick action: %s was done with state: %s",
        GetPlayerName(playerSource),
        action,
        actionExecuted
    )
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestAddSentence", 0, 1, function(playerSource, isAllowed, requestData)
    if not isAllowed or not canUseMdw(playerSource) then
        return
    end

    local targetSource = getOnlineTargetSource(requestData.playerId)
    if not targetSource then
        Framework.sendNotification(
            playerSource,
            _U("GENERAL.TARGET_PLAYER_NOT_FOUND"),
            "error"
        )
        return false
    end

    if targetSource == playerSource then
        Framework.sendNotification(
            playerSource,
            _U("GENERAL.CANNOT_EXECUTE_ACTION_ON_YOURSELF"),
            "error"
        )

        return dbg.debug(
            "Player named %s tried to execute a MDW quick action on himself",
            GetPlayerName(playerSource),
            playerSource
        )
    end

    if requestData.type == "COMS" then
        COMSService.StartPerollForCitizen(
            playerSource,
            targetSource,
            requestData.sentenceAmount,
            requestData.sentenceReason
        )
    elseif requestData.type == "JAIL" then
        PrisonService.JailCitizen(
            playerSource,
            targetSource,
            requestData.sentenceAmount,
            requestData.sentenceReason
        )
    end
end)
