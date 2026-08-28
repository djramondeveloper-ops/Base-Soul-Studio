local createCOMStorage, storageName, storageFactory

function createCOMStorage()
  local storage = {}
  storage._COMS = {}

  RegisterCommand("coms", function(source)
    if source == 0 then
      tprint(storage._COMS)
    end
  end, false)

  function storage.UpdatePlayerKeyByValue(source, key, value)
    if not source then
      return nil
    end

    local identifier = Framework.getIdentifier(source)
    if not identifier then
      return nil
    end

    local playerData = storage._COMS[identifier]
    if not playerData then
      return nil
    end

    playerData[key] = value
    return true
  end

  function storage.GetAllCOMS()
    return storage._COMS
  end

  function storage.GetPlayerById(charId)
    return storage._COMS[tostring(charId)]
  end

  function storage.GetPlayerBySource(source)
    if not source then
      return nil
    end

    local identifier = Framework.getIdentifier(source)
    if not identifier then
      return nil
    end

    return storage._COMS[identifier]
  end

  function storage.ReleaseUser(source)
    if not source then
      return nil
    end

    local identifier = Framework.getIdentifier(source)
    if not identifier then
      return nil
    end

    local playerData = storage._COMS[identifier]
    if not playerData then
      return nil
    end

    storage._COMS[identifier] = nil
    db.DeletePlayerCOMS(identifier)

    dbg.debug("Citizen named (%s) was released from peroll", GetPlayerName(source))
    Framework.sendNotification(source, _U("RELEASE_COMS_MESSAGE"), "success")
    StartClient(source, "comsHeartbeat")
  end

  function storage.SaveUser(source)
    if not source then
      return nil
    end

    local identifier = Framework.getIdentifier(source)
    if not identifier then
      return nil
    end

    local playerData = storage._COMS[identifier]
    if not playerData then
      return nil
    end

    local zoneId = playerData.zoneId
    local playerName = GetPlayerName(source)

    if zoneId then
      dbg.debug("Removing current zone with ID (%s) since player disconnect (%s)", zoneId, playerName)
      db.DeleteCOMSZone(identifier, zoneId)
      db.DeleteCOMSSessionZone(zoneId)
    end

    StartClient(source, "comsHeartbeat")
  end

  function storage.loadPeroll(source)
    if not source then
      return nil
    end

    local identifier = Framework.getIdentifier(source)
    if not identifier then
      return nil
    end

    dbg.debug("Loading community service for charId -> [%s]", GetPlayerName(source))

    local startLocations = Config.COMS.StartLocations
    if startLocations and startLocations.coords then
      StartClient(source, "SetWaypoint", startLocations.coords)
    end

    local playerData = storage._COMS[identifier]
    if not playerData then
      return nil
    end

    if playerData.state == COMS_STATES.SWEEPING then
      playerData.state = COMS_STATES.IDLE
    end

    SetTimeout(1000, function()
      StartClient(source, "StartComsIntro", {
        name = playerData.name,
        perollTarget = playerData.perollTarget,
        perollAmount = playerData.perollAmount
      })
    end)

    StartClient(source, "comsHeartbeat", playerData)
  end

  function storage.addPlayer(playerData)
    if not playerData then
      return nil
    end

    if not playerData.charId then
      return nil
    end

    storage._COMS[playerData.charId] = playerData
    return playerData.charId
  end

  function storage.removePlayer(playerData)
    if not playerData or not playerData.charId then
      return
    end

    storage._COMS[playerData.charId] = nil
  end

  return storage
end

COMStorage = createCOMStorage
storageName = STORAGE_COMS
storageFactory = COMStorage()
Object.registerStorage(storageName, storageFactory)
