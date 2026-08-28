local DebugSessions = DebugSessions or {}

local function filterBySource(prisoners)
  local filtered = {}

  for _, prisoner in pairs(prisoners) do
    if prisoner.source then
      filtered[prisoner.owner] = prisoner
    end
  end

  return filtered
end

filterBySource = filterBySource

local function CreatePrisonerStorage()
  local storage = {
    _prisoners = {},
    _prisonersLoaded = false
  }

  RegisterCommand("prisoners", function(source)
    if source ~= 0 then
      return
    end

    if next(storage._prisoners) then
      tprint(storage._prisoners)
    else
      dbg.debug("There are no prisoners in cache!")
    end
  end, false)

  function storage.MugshotDefinedForPrisoner(playerId)
    local prisoner = storage.GetPrisonerBySource(playerId)
    if not prisoner then
      return false
    end

    return prisoner.mugshotState
  end

  function storage.GetPrisonersLoadedState()
    return storage._prisonersLoaded
  end

  function storage.SaveGameTime(playerId)
    local prisoner = storage.GetPrisonerBySource(playerId)
    if not prisoner then
      return dbg.debug("Prisoner with playerId (%s) not found!", playerId)
    end

    local identifier = Framework.getIdentifier(playerId)
    if not IsServerIntervalRunning(identifier) then
      return dbg.debug("Thread with id: %s is not running!", identifier)
    end

    ClearServerInterval(identifier)

    local owner = prisoner.owner
    if prisoner.jail_time and owner then
      if prisoner.solitary_time and prisoner.solitary_time <= 0 then
        prisoner.solitary_startedAt = nil
      end

      db.UpdateJailData(prisoner, owner, function(saved)
        if saved then
          local playerName = GetPlayerName(playerId)
          local timeLeft = Time.DynamicSecondsToClock(prisoner.jail_time)
          dbg.debug(
            "Prisoner named (%s) with id: (%s) game-time %s was saved!",
            playerName,
            prisoner.id,
            timeLeft
          )
        else
          dbg.critical(
            "Failed to save prisoner data for (%s) with id: (%s)",
            GetPlayerName(playerId),
            prisoner.id
          )
        end
      end)

      if Config.ReduceSentenceType == SentenceTypes.OFFLINE then
        db.DefinePrisonerJailTime(prisoner.id, prisoner.jail_time)
      end
    end
  end

  RegisterCommand("times", function()
    if DebugSessions and next(DebugSessions) then
      tprint(DebugSessions)
    end
  end, false)

  function storage.LoadGameTime(playerId, jailTime, solitaryTime)
    local prisoner = storage.GetPrisonerBySource(playerId)
    local identifier = Framework.getIdentifier(playerId)

    if not prisoner then
      return
    end

    if prisoner.state ~= "jailed" then
      return
    end

    if IsServerIntervalRunning(identifier) then
      return dbg.debug("Thread with id: %s is already running!", identifier)
    end

    local currentJailTime = jailTime or prisoner.jail_time
    local jailEndTime = GetGameTimer() + (currentJailTime * 1000)

    local currentSolitaryTime
    local solitaryEndTime

    if prisoner.solitary_time then
      currentSolitaryTime = solitaryTime or prisoner.solitary_time
      solitaryEndTime = GetGameTimer() + (currentSolitaryTime * 1000)
    end

    DebugSessions[playerId] = {
      identifier = identifier,
      playerId = playerId,
      name = GetPlayerName(playerId),
      time = 0
    }

    dbg.debug("The game time loaded for user %s", GetPlayerName(playerId))

    SetServerInterval(identifier, 1000, function()
      local jailTimeLeft = Time.GetTimeLeftFromGameTime(jailEndTime)

      if prisoner.solitary_time and solitaryEndTime then
        local solitaryTimeLeft = Time.GetTimeLeftFromGameTime(solitaryEndTime)
        if solitaryTimeLeft > 0 then
          prisoner.solitary_time = solitaryTimeLeft
        end
      end

      if DebugSessions[playerId] then
        DebugSessions[playerId].time = jailTimeLeft
      end

      if jailTimeLeft > 0 then
        prisoner.jail_time = jailTimeLeft
      else
        DebugSessions[playerId] = nil
        ClearServerInterval(identifier)
        storage.SaveGameTime(playerId)
      end
    end)
  end

  function storage.GetPrisonerById(prisonerId)
    return storage._prisoners[tostring(prisonerId)]
  end

  function storage.CanPrisonerBeReleased(playerId)
    local prisoner = storage.GetPrisonerBySource(playerId)
    if not prisoner then
      return false
    end

    local canBeReleased = false

    if prisoner.state == "jailed" then
      local timeLeft = storage.GetPrisonerTimeLeft(prisoner.owner)
      if timeLeft and timeLeft <= 10 then
        canBeReleased = true
      end
    end

    return canBeReleased
  end

  function storage.GetPrisonerTimeLeft(owner)
    local reduceType = Config.ReduceSentenceType
    local result = db.FetchPrisonerTime(owner, reduceType)

    if type(result) == "string" then
      return tonumber(result)
    end

    if type(result) == "table" then
      return result.time
    end

    return tonumber(result)
  end

  function storage.LoadPrisoner(playerId, heartbeatEvent)
    local prisoner = storage.GetPrisonerBySource(playerId)
    if not prisoner then
      return
    end

    local yardPool = SH.data.YardPosPool
    local randomYardEntry = yardPool[math.random(1, #yardPool)]
    local yardTeleport = randomYardEntry or SH.data.prisonYard
    local teleportCoords = yardTeleport.pos or yardTeleport

    if heartbeatEvent == HEARTBEAT_EVENTS.PRISONER_NEW then
      local identifier = Framework.getIdentifier(playerId)

      pcall(function()
        Inventory.CreatePrisonerStash(playerId, identifier)
      end)

      pcall(function()
        if Inventory and type(Inventory.HandleOpenState) == 'function' then
            Inventory.HandleOpenState(playerId, true)
        end
      end)

      if Config.Prolog.Enable then
        dbg.debug("Starting prolog for prisoner named: %s", prisoner.prisonerName)

        storage.HandlePrisonerTeleport(
          playerId,
          TELEPORT_TYPES.TO_YARD_NEW_PRISONER,
          teleportCoords
        )

        TriggerEvent("rcore_prison:server:prologStarted", playerId)
        callback.await("prolog", playerId, 250, "a", "b")
        TriggerEvent("rcore_prison:server:prologFinished", playerId)
      else
        storage.HandlePrisonerTeleport(
          playerId,
          TELEPORT_TYPES.TO_YARD_NEW_PRISONER,
          teleportCoords
        )
      end

      storage.LoadGameTime(playerId, prisoner.jail_time, prisoner.solitary_time)
      PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_NEW, {
        prisoner = prisoner
      })
    else
      storage.LoadGameTime(playerId, prisoner.jail_time, prisoner.solitary_time)
      storage.HandlePrisonerTeleport(playerId)
      PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_LOADED, {
        prisoner = prisoner
      })
    end

    storage.UpdatePlayerDataByKey("source", playerId, playerId)

    if prisoner.solitary_cell then
      storage.UpdatePlayerDataByKey("solitary_startedAt", GetGameTimer(), playerId)
    end

    SetTimeout(1000, function()
      StartClient(playerId, "prisonerHeartbeat", prisoner)
    end)

    if not heartbeatEvent and not storage.CanPrisonerBeReleased(playerId) then
      Framework.sendNotification(
        playerId,
        _U("JAIL.WELCOME_BACK_TO_PRISON", Time.DynamicSecondsToClock(prisoner.jail_time)),
        "info"
      )
    end

    if not PlayerLoadedPool[playerId] then
      PlayerLoadedPool[playerId] = {
        playerId = playerId,
        state = true,
        name = GetPlayerName(playerId)
      }

      dbg.debug(
        "Registering player %s into player loaded pool! (player-id: %s)",
        GetPlayerName(playerId),
        playerId
      )
    end

    if Inventory and type(Inventory.HandleOpenState) == 'function' then
        Inventory.HandleOpenState(playerId, false)
    end

    dbg.debug(
      "Prisoner named (%s) with id: (%s) was loaded!",
      GetPlayerName(playerId),
      prisoner.id
    )

    StartClient(-1, "updatePrisoner", prisoner)

    if storage.CanPrisonerBeReleased(playerId) then
      if Config.Release.AtCheckpoint then
        SolitaryService.ReleasePrisoner(playerId)

        return dbg.debug(
          "Player named %s (%s) can be released from Prison, but needs to ask Warden to release him!",
          GetPlayerName(playerId),
          playerId
        )
      end

      storage.ReleasePrisoner(playerId, true)
      return
    end
  end

  function storage.HandlePrisonerTeleport(playerId, teleportType, teleportCoords)
    local isValidPosition, status = storage.HandlePrisonerLocation(playerId, teleportType, teleportCoords)

    if status then
      local result = isValidPosition and "NOT_REQUIRED" or "TELEPORTED_BACK"

      dbg.debug(
        "Prisoner named %s (%s) pos status: %s | Result: %s",
        GetPlayerName(playerId),
        playerId,
        status,
        result
      )
    end
  end

  function storage.CheckOnlinePlayers()
    local players = GetPlayers()
    if not next(players) then
      return
    end

    for index = 1, #players do
      local playerId = tonumber(players[index])
      local characterId = storage.ConvertPlayerIdToCharacterId(playerId)

      if storage._prisoners[characterId] then
        storage.LoadPrisoner(playerId, HEARTBEAT_EVENTS.PRISONER_LOADED)
      end

      Wait(0)
    end

    storage._prisonersLoaded = true
  end

  function storage.IsPrisonerOnEscape(playerId)
    local prisoner = storage.GetPrisonerBySource(playerId)
    if not prisoner then
      return false
    end

    return false
  end

  function storage.HandlePrisonerLocation(playerId, teleportType, teleportCoords)
    local isInsidePrison = true
    local status = "IN_PRISON_AREA"

    local ped = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(ped)
    local prisonYard = vec3(
      SH.data.prisonYard.x,
      SH.data.prisonYard.y,
      SH.data.prisonYard.z
    )

    local inPolygon = IsPointInPolygon(
      vec2(playerCoords.x, playerCoords.y),
      SH.data.prisonVertices
    )

    local prisoner = storage.GetPrisonerBySource(playerId)

    if prisoner and prisoner.jailbreak and prisoner.jailbreak.state then
      if not inPolygon then
        dbg.debug(
          "Player named %s (%s) has escaped from prison, releasing him now.",
          GetPlayerName(playerId),
          playerId
        )

        storage.ReleasePrisoner(playerId, false, true)
      end

      return true, "SKIPPING_TELEPORT_SINCE_PLAYER_ESCAPED"
    end

    if prisoner and prisoner.solitary_time and prisoner.solitary_time > 0 then
      local solitaryCells = SH.data.SolitaryCells
      if not solitaryCells then
        return
      end

      local cellData = solitaryCells[prisoner.solitary_cell]
      if cellData then
        local distance = #(playerCoords - vec3(
          cellData.coords.x,
          cellData.coords.y,
          cellData.coords.z
        ))

        if distance >= Config.Solitary.DistanceCheck then
          StartClient(
            playerId,
            "teleportUser",
            vec4(cellData.coords.x, cellData.coords.y, cellData.coords.z, 0),
            "SOLITARY_CELL_TELEPORT"
          )

          status = "TELEPORTED_TO_SOLITARY_CELL"
        end
      end
    end

    if teleportCoords then
      StartClient(playerId, "teleportUser", teleportCoords, teleportType)
    end

    if not inPolygon then
      StartClient(
        playerId,
        "teleportUser",
        vec4(prisonYard.x, prisonYard.y, prisonYard.z, 0),
        "NOT_IN_PRISON_AREA"
      )

      status = "NOT_IN_PRISON_AREA"
      isInsidePrison = false
    end

    return isInsidePrison, status
  end

  function storage.UpdatePlayerDataByKey(key, value, playerId)
    local characterId = storage.ConvertPlayerIdToCharacterId(playerId)
    if not characterId then
      return false
    end

    local prisoner = storage._prisoners[characterId]
    if not prisoner then
      return false
    end

    prisoner[key] = value
    return true
  end

  function storage.ReleasePrisonerOffline(prisonerId)
    local prisoner = storage.GetPrisonerById(prisonerId)
    if not prisoner then
      return false
    end

    pcall(function()
      db.DeletePrisonerData(prisonerId)
    end)

    PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_RELEASED, {
      prisoner = prisoner
    })

    storage._prisoners[prisonerId] = nil

    dbg.debug(
      "Prisoner named (%s) with id: (%s) was released offline!",
      prisoner.prisonerName,
      prisoner.id
    )

    return true
  end

  function storage.ReleasePrisoner(playerId, shouldTeleportOutside, escaped)
    dbg.debug(
      "Release prisoner: 1. Converting serverId to charId (%s)",
      GetPlayerName(playerId)
    )

    local characterId = storage.ConvertPlayerIdToCharacterId(playerId)
    if not characterId then
      return nil
    end

    dbg.debug(
      "Release prisoner: 2. Checking if player is prisoner (%s)",
      GetPlayerName(playerId)
    )

    if not storage._prisoners[characterId] then
      return nil
    end

    dbg.debug(
      "Release prisoner: 3. Loading prisoner model data (%s)",
      GetPlayerName(playerId)
    )

    local prisoner = storage.GetPrisonerBySource(playerId)

    if prisoner and not escaped then
      LogService.RegisterTransaction(
        "RELEASE_PLAYER",
        _U(
          "LOGS_ACTIONS.LOG_CITIZEN_CITIZEN_RELEASED_BY_OFFICER",
          prisoner.prisonerName,
          prisoner.officerName
        ),
        prisoner.owner,
        prisoner.officerName,
        prisoner.prisonerName
      )
    end

    if escaped then
      prisoner.escaped = true
    end

    PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_RELEASED, {
      prisoner = prisoner
    })

    dbg.debug(
      "Release prisoner: 4. Heatbeart of prisoner was sent now moving to deleting prisoner data (%s)",
      GetPlayerName(playerId)
    )

    if Config.Accounts.DeleteAccountWhenReleased then
      PrisonAccountService.DeleteAccount(playerId, characterId)
    end

    local success, errorMessage = pcall(db.DeletePrisonerData, characterId)
    if not success then
      dbg.critical(
        "Release prisoner: 5.5. Failed to remove prisoner data since error: %s",
        errorMessage
      )
    end

    dbg.debug(
      "Release prisoner: 6. Clearing player cache from storage (%s)",
      GetPlayerName(playerId)
    )

    ClearServerInterval(characterId)
    storage._prisoners[characterId] = nil

    dbg.debug(
      "Release prisoner: 7. Sending heartbeat to client, to remove data (%s)",
      GetPlayerName(playerId)
    )

    StartClient(playerId, "prisonerHeartbeat", nil, escaped)

    if Config.Teleport["WhenReleasedTeleportPrisonerInFrontOfPrison"] and shouldTeleportOutside then
      dbg.debug(
        "Release prisoner: 8. Target player named (%s) should be teleported outside of prison since release.",
        GetPlayerName(playerId)
      )

      StartClient(
        playerId,
        "teleportUser",
        SH.data.releasePos,
        TELEPORT_TYPES.TO_OUTSIDE_PRISON_RELEASED
      )
    end

    if not escaped then
      Framework.sendNotification(playerId, _U("PLAYER_RELEASED"), "info")
    end

    return true
  end

  function storage.AddPlayer(prisonerData)
    if not prisonerData or not prisonerData.owner then
      return
    end

    storage._prisoners[prisonerData.owner] = prisonerData
    return prisonerData.owner
  end

  function storage.ConvertPlayerIdToCharacterId(playerId)
    playerId = tonumber(playerId)
    if not playerId then
      return nil
    end

    return Framework.getIdentifier(playerId)
  end

  function storage.GetPrisonerBySource(playerId)
    local characterId = storage.ConvertPlayerIdToCharacterId(playerId)
    if not characterId then
      return nil
    end

    return storage._prisoners[characterId]
  end

  function storage.SetPrisonerEscapeState(characterId, state, metadata)
    local prisoner = storage._prisoners[characterId]
    if not prisoner then
      return false
    end

    prisoner.jailbreak = {
      state = state,
      metadata = metadata
    }

    dbg.debug(
      "Setting a prisoner escape state for (%s) for charId %s to state: %s",
      prisoner.name or prisoner.prisonerName,
      characterId,
      tostring(state)
    )

    return true
  end

  function storage.UpdatePlayerSentence(characterId, newJailTime, officerSource)
    local prisoner = storage._prisoners[characterId]
    if not prisoner then
      return
    end

    local oldJailTime = prisoner.jail_time

    storage.UpdatePlayerDataByKey("jail_time", newJailTime, prisoner.source)
    storage.UpdatePlayerDataByKey("hasTimeChange", true, prisoner.source)

    storage.SaveGameTime(prisoner.source)
    Wait(1000)
    storage.LoadGameTime(prisoner.source, newJailTime)

    prisoner.jail_time = newJailTime

    if prisoner.source then
      StartClient(prisoner.source, "prisonerHeartbeat", prisoner)
      storage.UpdatePlayerDataByKey("hasTimeChange", false, prisoner.source)

      local invokingResource = GetInvokingResource() or "INTERNAL FUNCTION"

      dbg.debug(
        "Prisoner named (%s) sentence was updated to %s! -> requested by %s",
        GetPlayerName(prisoner.source),
        Time.DynamicSecondsToClock(newJailTime),
        invokingResource
      )
    end

    local shouldLogChange = prisoner.officerName and prisoner.jail_time and prisoner.prisonerName

    if shouldLogChange or officerSource then
      if officerSource then
        prisoner.officerName = Framework.getCharacterName(officerSource)
      end

      LogService.RegisterTransaction(
        "EDIT_SENTENCE",
        _U(
          "LOGS_ACTIONS.LOG_CITIZEN_CHANGED_SENTENCE_BY_OFFICER",
          prisoner.officerName,
          Time.DynamicSecondsToClock(oldJailTime),
          Time.DynamicSecondsToClock(prisoner.jail_time)
        ),
        characterId,
        prisoner.officerName,
        prisoner.prisonerName
      )
    end
  end

  function storage.SavePrisoner(playerId)
    local characterId = storage.ConvertPlayerIdToCharacterId(playerId)
    if not characterId then
      return nil
    end

    local prisoner = storage._prisoners[characterId]
    if not prisoner then
      return nil
    end

    storage.SaveGameTime(playerId)
    prisoner.source = nil

    ClearServerInterval(characterId)
    StartClient(playerId, "prisonerHeartbeat")

    dbg.debug(
      "Prisoner named (%s) with id: (%s) was saved!",
      GetPlayerName(playerId),
      prisoner.id
    )
  end

  function storage.GetAllPrisoners(onlyOnline)
    if onlyOnline then
      return filterBySource(storage._prisoners)
    end

    return storage._prisoners
  end

  return storage
end

PrisonerStorage = CreatePrisonerStorage

Object.registerStorage(STORAGE_PRISONER, PrisonerStorage())