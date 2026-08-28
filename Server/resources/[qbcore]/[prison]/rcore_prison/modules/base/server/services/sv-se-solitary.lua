SolitaryService = SolitaryService or {}

function SolitaryService.IsPlayerCloseToGuard(source, guardNetId)
    local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
    local playerPed = GetPlayerPed(source)
    local guardCoords = GetEntityCoords(guardEntity)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(guardCoords - playerCoords)

    return distance <= Config.Solitary.GuardDistanceCheck
end

function SolitaryService.HasSentence(source)
    local prisoner = PrisonService.getPlayer(source)
    if not prisoner then
        return false
    end

    local solitaryTime = prisoner.solitary_time
    return solitaryTime and solitaryTime > 0 or solitaryTime
end

function SolitaryService.ReleasePrisoner(source)
    local prisoner = PrisonService.getPlayer(source)
    if not prisoner then
        return dbg.debug("Failed to release player from solitary, since he is not a prisoner")
    end

    if not prisoner.solitary_cell then
        return
    end

    prisoner.solitary_time = nil
    prisoner.solitary_cell = nil
    prisoner.solitary_startedAt = nil

    db.UpdateJailData(prisoner, prisoner.owner, function(success)
        if success then
            dbg.debug("Releasing player named %s (%s) from solitary", GetPlayerName(source), source)

            local prisonYard = SH.data.prisonYard
            if prisonYard then
                local yardCoords = vec3(prisonYard.x, prisonYard.y, prisonYard.z)
                if yardCoords then
                    StartClient(source, "teleportUser", yardCoords)
                end
            end

            SetTimeout(1000, function()
                prisoner.hasTimeChange = true
                StartClient(source, "prisonerHeartbeat", prisoner)
                prisoner.hasTimeChange = false
            end)

            LogService.RegisterTransaction(
                _U("SOLITARY.MDW_LOG_TITLE_RELEASED"),
                _U("SOLITARY.MDW_LOG_DESC_RELEASED"),
                prisoner.owner,
                nil,
                prisoner.prisonerName
            )

            Discord.SendMessage(
                _U("SOLITARY.DISCORD_LOG_SENT_TITLE_RELEASED"),
                _U("SOLITARY.DISCORD_LOG_SENT_DESC_RELEASED"),
                {
                    {
                        name = _U("SOLITARY.DISCORD_LOG_OOC_NAME_LABEL"),
                        value = GetPlayerName(source)
                    },
                    {
                        name = _U("SOLITARY.DISCORD_LOG_IC_NAME_LABEL"),
                        value = prisoner.prisonerName
                    }
                }
            )

            Framework.sendNotification(source, _U("SOLITARY.RELEASED"), "success")
        else
            dbg.critical("Failed to update solitary release data for player %s", GetPlayerName(source))
        end
    end)
end

function SolitaryService.GetRandomCell()
    local solitaryCells = SH.data.SolitaryCells
    if not solitaryCells then
        return
    end

    local randomCellId = math.random(1, #solitaryCells)
    local cellData = solitaryCells[randomCellId]

    if Config.Debug then
        tprint(cellData)
        dbg.debug(
            "Solitary: selecting random cell with ID: %s on map preset: %s",
            randomCellId,
            Config.Map
        )
    end

    return randomCellId, cellData
end

function SolitaryService.SetPrisonerSentence(source, timeInSeconds, reason, officerSource)
    if not source then
        return
    end

    local prisoner = PrisonService.getPlayer(source)
    if not prisoner then
        return dbg.debug("Failed to set player for solitary, since he is not a prisoner")
    end

    if prisoner.solitary_cell then
        Framework.sendNotification(source, _U("SOLITARY.ALREADY_IN_SOLITARY"), "error")
        return dbg.debug("Failed to set player for solitary, since he is already in solitary")
    end

    local convertedTime = Time.ConvertTimeFromSeconds(timeInSeconds, Config.Time)
    if convertedTime then
        local cellId, cellData = SolitaryService.GetRandomCell()
        prisoner.solitary_cell = cellId
        prisoner.solitary_time = convertedTime

        db.UpdateJailData(prisoner, prisoner.owner, function(success)
            if success then
                db.DefinePrisonerSolitaryTime(prisoner.id, convertedTime)
            else
                dbg.critical("Failed to update solitary data for player %s", GetPlayerName(source))
            end
        end)

        local officerName = nil
        if officerSource then
            officerName = Framework.getCharacterName(officerSource)
        end

        prisoner.solitary_startedAt = GetGameTimer()

        if cellData then
            StartClient(source, "teleportUser", cellData.coords)
        end

        SetTimeout(1000, function()
            StartClient(source, "prisonerHeartbeat", prisoner)
        end)

        Framework.sendNotification(
            source,
            _U("SOLITARY.PLACED_IN_SOLITARY", Time.DynamicSecondsToClock(convertedTime)),
            "success"
        )

        local logReason = reason or "-"
        LogService.RegisterTransaction(
            _U("SOLITARY.MDW_LOG_TITLE"),
            _U("SOLITARY.MDW_LOG_DESC", Time.DynamicSecondsToClock(convertedTime), logReason),
            prisoner.owner,
            officerName,
            prisoner.prisonerName
        )

        Discord.SendMessage(
            _U("SOLITARY.DISCORD_LOG_SENT_TITLE"),
            _U("SOLITARY.DISCORD_LOG_SENT_DESC"),
            {
                {
                    name = _U("SOLITARY.DISCORD_LOG_OOC_NAME_LABEL"),
                    value = GetPlayerName(source)
                },
                {
                    name = _U("SOLITARY.DISCORD_LOG_IC_NAME_LABEL"),
                    value = prisoner.prisonerName
                },
                {
                    name = _U("SOLITARY.DISCORD_LOG_REASON_LABEL"),
                    value = logReason
                },
                {
                    name = _U("SOLITARY.DISCORD_LOG_TIME_LABEL"),
                    value = Time.DynamicSecondsToClock(convertedTime)
                }
            }
        )

        dbg.debug("Setting player named %s (%s) for solitary", GetPlayerName(source), source)
    end
end

function SolitaryService.CanBeAutoReleased(source)
    local canBeReleased = false
    local prisoner = PrisonService.getPlayer(source)

    if not prisoner then
        return canBeReleased
    end

    if not prisoner.solitary_time then
        return canBeReleased
    end

    local startedAt = prisoner.solitary_startedAt
    local durationMs = prisoner.solitary_time * 1000

    if not startedAt then
        return canBeReleased
    end

    local releaseAt = startedAt + durationMs
    local currentTime = GetGameTimer()

    if releaseAt <= currentTime then
        canBeReleased = true
    end

    dbg.debug("Solitary player named %s release state: %s", GetPlayerName(source), canBeReleased)
    return canBeReleased
end

EventLimiterService.RegisterNetEvent(
    "rcore_prison:server:requestSolitaryRelease",
    0,
    1,
    function(source, isAllowed)
        if not isAllowed then
            return
        end

        local canBeReleased = SolitaryService.CanBeAutoReleased(source)
        if canBeReleased then
            SolitaryService.ReleasePrisoner(source)
        end
    end
)

RegisterNetEvent("rcore_prison:server:guardWasAttackedByPrisoner", function(guardNetId, playerSource)
    local sourcePlayer = source

    if not guardNetId then
        return
    end

    if sourcePlayer ~= playerSource then
        return
    end

    local guards = GetPatrollingGuards()
    local guardData = guards[guardNetId]
    if not guardData then
        return
    end

    local isCloseToGuard = SolitaryService.IsPlayerCloseToGuard(sourcePlayer, guardNetId)
    if not isCloseToGuard then
        return
    end

    local prisoner = PrisonService.getPlayer(sourcePlayer)
    if not prisoner then
        CitizenAttackedGuard(playerSource)
        return
    end

    local solitaryTime = Config.Solitary.Time

    Framework.sendNotification(
        sourcePlayer,
        _U("SOLITARY.PRISONER_ATTACKED_GUARD", Time.DynamicSecondsToClock(solitaryTime)),
        "success"
    )

    SolitaryService.SetPrisonerSentence(
        sourcePlayer,
        solitaryTime,
        _U("SOLITARY.DISCORD_LOG_REASON_PRISONER_ATTACKED_GUARD")
    )
end)
