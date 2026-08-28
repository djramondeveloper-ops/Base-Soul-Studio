local createCOMSSessionStorage, storageName, storageFactory

function createCOMSSessionStorage()
  local storage = {}
  storage._sessions = {}

  RegisterCommand("sessions", function(source)
    if source == 0 then
      tprint(storage._sessions)
    end
  end, false)

  function storage.getAllSessions()
    return storage._sessions
  end

  function storage.getSession(zoneId)
    return storage._sessions[zoneId]
  end

  function storage.updateSessionByKeyValue(zoneId, key, value)
    local session = storage._sessions[zoneId]
    if not session then
      return false
    end

    session[key] = value
    return true
  end

  function storage.registerSession(sessionData)
    storage._sessions[sessionData.zoneId] = sessionData
    return true
  end

  function storage.unregisterSession(sessionData)
    storage._sessions[sessionData.zoneId] = nil
  end

  return storage
end

COMSSessionStorage = createCOMSSessionStorage
storageName = STORAGE_COMS_SESSIONS
storageFactory = COMSSessionStorage()
Object.registerStorage(storageName, storageFactory)
