COMSService = COMSService or {}

local function getCOMSStorage()
    return Object.getStorage(STORAGE_COMS)
end

function COMSService.getPlayer(source)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    return comsStorage.GetPlayerBySource(source)
end

function COMSService.CheckForAnySentence(source)
    return COMSService.getPlayer(source)
end

function COMSService.GetPlayerById(id)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    return comsStorage.GetPlayerById(id)
end

function COMSService.ReleaseUser(source, officerSource)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return false
    end

    if officerSource then
        local officerIdentifier = Framework.getIdentifier(officerSource)
        local citizenName = Framework.getCharacterName(source)
        local officerName = Framework.getCharacterName(officerSource)
        local logMessage = _U(
            "LOGS_ACTIONS.LOG_CITIZEN_CITIZEN_RELEASED_BY_OFFICER_FROM_PAROLLE",
            officerName,
            citizenName
        )

        LogService.RegisterTransaction(
            "RELEASE_PLAYER",
            logMessage,
            officerIdentifier,
            citizenName,
            officerName
        )
    end

    local playerData = COMSService.getPlayer(source)
    if playerData then
        local zoneId = playerData.zoneIdx
        if zoneId then
            dbg.debug(
                "Found active COMS for player (%s) - clearing area with zoneId: %s!",
                GetPlayerName(source),
                zoneId
            )

            StartClient(source, "UnregisterCOMSArea", source, zoneId)
        end

        StartClient(source, "RemoveBlipByType", "COMS")
    end

    comsStorage.ReleaseUser(source)
end

function COMSService.SaveUser(source)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    local playerData = comsStorage.GetPlayerBySource(source)
    if not playerData then
        return nil
    end

    comsStorage.SaveUser(source)
end

function COMSService.LoadPeroll(source)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    local playerData = comsStorage.GetPlayerBySource(source)
    if not playerData then
        return nil
    end

    comsStorage.loadPeroll(source)
end

function COMSService.UpdatePlayerKeyByValue(source, key, value)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    local playerData = comsStorage.GetPlayerBySource(source)
    if not playerData then
        return nil
    end

    return comsStorage.UpdatePlayerKeyByValue(source, key, value)
end

function COMSService.GetAllCOMS(source)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return nil
    end

    return comsStorage.GetAllCOMS(source)
end

function COMSService.StartPerollForCitizen(officerSource, targetSource, perollTarget, reason)
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return false
    end

    local activePeroll = comsStorage.GetPlayerBySource(targetSource)
    if activePeroll then
        dbg.debug("Player already has a peroll", GetPlayerName(targetSource))

        if officerSource then
            Framework.sendNotification(
                officerSource,
                _U("GENERAL.ACTIVE_PAROLLE"),
                "error"
            )
        end

        return false
    end

    local targetPed = GetPlayerPed(targetSource)
    if targetPed <= 0 then
        dbg.debug("Player is not online", GetPlayerName(targetSource))

        if officerSource then
            Framework.sendNotification(
                officerSource,
                _U("GENERAL.TARGET_PLAYER_NOT_FOUND"),
                "error"
            )
        end

        return false
    end

    local perollData = COMSPlayerModel()
    perollData.charId = Framework.getIdentifier(targetSource)
    perollData.perollAmount = 0
    perollData.perollTarget = perollTarget
    perollData.reason = reason
    perollData.name = Framework.getCharacterName(targetSource)

    local perollId = db.CreateCitizenPeroll(
        perollData.charId,
        perollData.state,
        perollData.perollTarget,
        perollData.name
    )

    if not perollId then
        dbg.critical(
            "Cannot create peroll %s %s - db insert COMSService.StartPerollForCitizen",
            perollData.charId,
            perollData.name
        )
        return
    end

    local officerName = "-"
    if officerSource then
        officerName = Framework.getCharacterName(officerSource)
    end

    local targetIdentifier = Framework.getIdentifier(targetSource)
    local targetName = Framework.getCharacterName(targetSource)
    local logMessage = _U(
        "LOGS_ACTIONS.LOG_CITIZEN_PAROLLED_BY_OFFICER",
        targetName,
        officerName,
        perollTarget
    )

    LogService.RegisterTransaction(
        "CITIZEN_PAROLLED",
        logMessage,
        targetIdentifier,
        officerName,
        targetName
    )

    perollData.id = perollId

    if perollData.id then
        local wasAdded = comsStorage.addPlayer(perollData)
        local startLocations = Config.COMS.StartLocations

        if startLocations and startLocations.coords then
            StartClient(targetSource, "SetWaypoint", startLocations.coords)
        end

        if wasAdded then
            comsStorage.loadPeroll(targetSource)

            if officerSource then
                Framework.sendNotification(
                    targetSource,
                    _U("GENERAL.YOU_HAVE_BEEN_SENT_TO_COMS_BY", officerName)
                )
            end
        end

        TriggerEvent(
            "rcore_prison:server:comsRegisteredForPlayer",
            targetSource,
            perollData.perollTarget
        )
    end

    return perollData
end

function COMSService.loadAllUsers()
    local cacheState = "LOADED_DATA_INTO_CACHE"
    local fetchedUsers = db.FetchCOMSUsers() or {}
    local comsStorage = getCOMSStorage()
    if not comsStorage then
        return
    end

    local loadingPromise = promise.new()

    if next(fetchedUsers) then
        for index = 1, #fetchedUsers do
            local row = fetchedUsers[index]

            if row then
                local perollData = COMSPlayerModel()
                perollData.id = row.id
                perollData.charId = row.owner
                perollData.perollAmount = row.perollAmount
                perollData.perollTarget = row.perollTarget
                perollData.reason = row.reason
                perollData.state = row.state
                perollData.zoneId = row.zoneId or "NONE"
                perollData.name = row.name

                comsStorage.addPlayer(perollData)
            end

            if index >= #fetchedUsers then
                loadingPromise:resolve(true)
            end

            Wait(0)
        end
    else
        cacheState = "NOT_ANY_COMS_USERS_IN_DB"
        loadingPromise:resolve(true)
    end

    Citizen.Await(loadingPromise)

    if cacheState then
        dbg.debug("COMS data into cache state: %s", cacheState)
    end
end
