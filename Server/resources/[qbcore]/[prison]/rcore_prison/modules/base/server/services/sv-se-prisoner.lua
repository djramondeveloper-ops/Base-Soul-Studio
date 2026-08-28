PrisonService = PrisonService or {}

function PrisonService.getPlayer(source)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        return nil
    end

    return prisoner
end

function PrisonService.getPlayerById(prisonerId)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerById(prisonerId)

    if not prisoner then
        return nil
    end

    return prisoner
end

function PrisonService.GetPrisonersLoadedState()
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage then
        return false
    end

    return prisonerStorage.GetPrisonersLoadedState()
end

function PrisonService.loadAllPrisoners()
    local cacheState = "LOADED_DATA_INTO_CACHE"
    local prisonersFromDb = db.FetchPrisoners()
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local loadPromise = promise.new()

    if next(prisonersFromDb) then
        for index = 1, #prisonersFromDb do
            local prisonerRow = prisonersFromDb[index]
            local decodedData = nil

            if prisonerRow.data then
                decodedData = json.decode(prisonerRow.data)
            end

            if decodedData then
                local prisoner = PrisonerModel()
                prisoner.id = prisonerRow.prisoner_id
                prisoner.owner = prisonerRow.owner
                prisoner.jail_time = decodedData.jail_time
                prisoner.jail_reason = decodedData.jail_reason
                prisoner.officerName = decodedData.officerName
                prisoner.prisonerName = decodedData.prisonerName
                prisoner.state = decodedData.state
                prisoner.perollDone = decodedData.perollDone
                prisoner.solitary_time = decodedData.solitary_time
                prisoner.solitary_cell = decodedData.solitary_cell

                prisonerStorage.AddPlayer(prisoner)
            end

            if index >= #prisonersFromDb then
                loadPromise:resolve(true)
            end
        end
    else
        cacheState = "NOT_ANY_PRISONERS_IN_DB"
        loadPromise:resolve(true)
    end

    Citizen.Await(loadPromise)

    if cacheState then
        dbg.debug("Prisoner data into cache state: %s", cacheState)
    end

    Wait(0)
    PrisonService.isDBReady = true
    prisonerStorage.CheckOnlinePlayers()
end

function PrisonService.CheckForAnySentence(source)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        dbg.debug(
            "PrisonService - Check for any sentence: Player named %s with playerId: %s has inactive sentence",
            GetPlayerName(source),
            source
        )
        return false
    end

    if prisoner.jail_time > 0 then
        dbg.debug(
            "PrisonService - Check for any sentence: Player named %s with playerId: %s has active sentence: %s",
            GetPlayerName(source),
            source,
            prisoner.jail_time
        )
        return true
    end

    return false
end

function PrisonService.SaveUser(source)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        return nil
    end

    prisonerStorage.SavePrisoner(source)
end

function PrisonService.GetAllPrisoners(filter)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage then
        return nil
    end

    return prisonerStorage.GetAllPrisoners(filter)
end

function PrisonService.SendHeartbeat(source, ...)
    local payload = ...
    TriggerEvent("rcore_prison:server:heartbeat", source, payload)
end

function PrisonService.HandlePrisonerLocation(source, locationType)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage then
        return nil
    end

    return prisonerStorage.HandlePrisonerTeleport(source, locationType)
end

function PrisonService.Jail(targetSource, jailTime, jailReason, officerSource)
    if not targetSource then
        return false
    end

    local targetPed = GetPlayerPed(targetSource)
    if targetPed < 0 then
        return false
    end

    jailTime = jailTime or 60
    jailReason = jailReason or "No reason provided"

    local jailingOfficer = nil
    if officerSource then
        jailingOfficer = officerSource
    end

    PrisonService.JailCitizen(jailingOfficer, targetSource, jailTime, jailReason)
end

function PrisonService.Unjail(targetSource, releaseFromTimeCheck, isOfflineRelease)
    if not targetSource then
        return false
    end

    local targetPed = GetPlayerPed(targetSource)
    if targetPed < 0 then
        return false
    end

    if releaseFromTimeCheck == nil then
        releaseFromTimeCheck = true
    end

    isOfflineRelease = isOfflineRelease or false
    PrisonService.UnjailCitizen(targetSource, releaseFromTimeCheck, isOfflineRelease)
end

function PrisonService.JailCitizen(officerSource, targetSource, jailTimeInSeconds, jailReason)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local existingPrisoner = prisonerStorage.GetPrisonerBySource(targetSource)

    if existingPrisoner then
        Framework.sendNotification(
            officerSource,
            _U("GENERAL.CITIZEN_ALREADY_JAILED"),
            "error"
        )

        dbg.debug("Player named: %s is already jailed", GetPlayerName(targetSource))
        return false
    end

    if Inventory and type(Inventory.HandleOpenState) == 'function' then
        Inventory.HandleOpenState(targetSource, true)
    end

    local convertedJailTime = Time.ConvertTimeFromSeconds(jailTimeInSeconds, Config.Time)
    local prisoner = PrisonerModel()
    local identifier = Framework.getIdentifier(targetSource)

    prisoner.jail_time = convertedJailTime
    prisoner.jail_reason = jailReason
    prisoner.state = "jailed"

    if officerSource then
        prisoner.officerName = Framework.getCharacterName(officerSource)
    else
        prisoner.officerName = "-"
    end

    prisoner.prisonerName = Framework.getCharacterName(targetSource)

    local prisonerId = db.DefinePrisonerData(identifier, {
        prisonerData = prisoner
    })

    if not prisonerId then
        dbg.critical(
            "Cannot create prisoner %s %s - db insert PrisonService.JailCitizen",
            prisoner.charId,
            prisoner.prisonerName
        )
        return
    end

    prisoner.id = prisonerId
    prisoner.source = targetSource
    prisoner.owner = identifier

    db.DefinePrisonerJailTime(prisoner.id, prisoner.jail_time)

    local wasAdded = prisonerStorage.AddPlayer(prisoner)
    if wasAdded then
        LogService.RegisterTransaction(
            "CITIZEN_JAILED",
            _U("LOGS_ACTIONS.LOG_CITIZEN_JAILED_BY_OFFICER", prisoner.prisonerName, prisoner.officerName),
            identifier,
            prisoner.officerName,
            prisoner.prisonerName
        )

        prisonerStorage.LoadPrisoner(targetSource, HEARTBEAT_EVENTS.PRISONER_NEW)
    end
end

function PrisonService.EditSentenceBySource(source, amount)
    if not source then
        return false
    end

    local charId = Framework.getIdentifier(source)

    if amount <= 0 then
        Framework.sendNotification(
            charId,
            _U("GENERAl.AMOUNT_CANNOT_BE_LESS_THAN_0"),
            "error"
        )

        return dbg.debug(
            "Edit sentence service: Amount cannot be less than 0 initiated for charId (%s) by %s (%s)",
            charId,
            GetPlayerName(source),
            source
        )
    end

    local convertedTime = Time.ConvertTimeFromSeconds(amount, Config.Time)
    if convertedTime then
        local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
        local prisoner = prisonerStorage.GetPrisonerById(charId)

        if not prisoner then
            return
        end

        prisonerStorage.UpdatePlayerSentence(charId, convertedTime)
    end
end

function PrisonService.EditSentenceWithConvertedTime(prisonerId, convertedTime, initiatorSource)
    if convertedTime <= 0 then
        Framework.sendNotification(
            prisonerId,
            _U("GENERAl.AMOUNT_CANNOT_BE_LESS_THAN_0"),
            "error"
        )

        return dbg.debug(
            "Edit sentence service: Amount cannot be less than 0 initiated for charId (%s) by %s (%s)",
            prisonerId,
            GetPlayerName(initiatorSource),
            initiatorSource
        )
    end

    local finalTime = convertedTime
    if finalTime then
        local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
        local prisoner = prisonerStorage.GetPrisonerById(prisonerId)

        if not prisoner then
            return
        end

        prisonerStorage.UpdatePlayerSentence(prisonerId, finalTime, initiatorSource)
    end
end

function PrisonService.EditSentence(prisonerId, amount, initiatorSource)
    if amount <= 0 then
        Framework.sendNotification(
            prisonerId,
            _U("GENERAl.AMOUNT_CANNOT_BE_LESS_THAN_0"),
            "error"
        )

        return dbg.debug(
            "Edit sentence service: Amount cannot be less than 0 initiated for charId (%s) by %s (%s)",
            prisonerId,
            GetPlayerName(initiatorSource),
            initiatorSource
        )
    end

    local convertedTime = Time.ConvertTimeFromSeconds(amount, Config.Time)
    if convertedTime then
        local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
        local prisoner = prisonerStorage.GetPrisonerById(prisonerId)

        if not prisoner then
            return
        end

        prisonerStorage.UpdatePlayerSentence(prisonerId, convertedTime, initiatorSource)
    end
end

function PrisonService.SetPrisonerEscapeState(source, escapeState, reason)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        return false
    end

    prisonerStorage.SetPrisonerEscapeState(prisoner.owner, escapeState, reason)
end

function PrisonService.UnjailCitizen(source, releaseFromTimeCheck, isOfflineRelease)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        dbg.debug("Player named: %s is not jailed!", GetPlayerName(source))
        return false
    end

    prisonerStorage.ReleasePrisoner(source, releaseFromTimeCheck, isOfflineRelease)
end

function PrisonService.UnjailOfflineCitizen(prisonerId)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage then
        return false
    end

    return prisonerStorage.ReleasePrisonerOffline(prisonerId)
end

function PrisonService.LoadPrisoner(source)
    local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage.GetPrisonerBySource(source)

    if not prisoner then
        return nil
    end

    prisonerStorage.LoadPrisoner(source)
end

local pendingReleaseChecks = {}

RegisterCommand("debug_release", function(source)
    if source ~= 0 then
        return
    end

    if pendingReleaseChecks and next(pendingReleaseChecks) then
        tprint(pendingReleaseChecks)
    end
end, false)

EventLimiterService.RegisterNetEvent(
    "rcore_prison:server:requestRelease",
    0,
    1,
    function(source, isAllowed)
        if not isAllowed then
            return
        end

        local prisonerStorage = Object.getStorage(STORAGE_PRISONER)
        local prisoner = prisonerStorage.GetPrisonerBySource(source)

        if not prisoner then
            return false, "PRISONER_NOT_FOUND"
        end

        local jailTime = tonumber(prisoner.jail_time)

        dbg.debug(
            "Release player: Checking player %s with jailTime: %s to be released out.",
            GetPlayerName(source),
            jailTime
        )

        if not pendingReleaseChecks[source] then
            pendingReleaseChecks[source] = {
                identifier = Framework.getIdentifier(source),
                time = jailTime,
                name = GetPlayerName(source)
            }
        end

        if jailTime > 10 then
            dbg.debug("Failed to release player %s with jailTime: %s", GetPlayerName(source), jailTime)

            return Framework.sendNotification(
                source,
                _U("CANNOT_BE_RELEASED", Time.DynamicSecondsToClock(prisoner.jail_time)),
                "error"
            )
        end

        if not Config.CanPrisonerBeReleasedWhenOnSolitary and prisoner.solitary_cell then
            local canBeReleasedFromSolitary = SolitaryService.CanBeAutoReleased(source)
            if not canBeReleasedFromSolitary then
                dbg.debug(
                    "Failed to release player %s with jailTime: %s since being in solitary cell!",
                    GetPlayerName(source),
                    jailTime
                )

                return Framework.sendNotification(
                    source,
                    _U("CANNOT_BE_RELEASED_SINCE_HAVING_SOLITARY"),
                    "error"
                )
            end
        end

        if pendingReleaseChecks[source] then
            pendingReleaseChecks[source] = nil
        end

        dbg.debug("Player named: %s was automatically released his time is up", GetPlayerName(source))
        prisonerStorage.ReleasePrisoner(source, true)
    end
)

Object.registerService(SERVICE_PRISONER, PrisonService)
