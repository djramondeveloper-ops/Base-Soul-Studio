local createCigarProductionStorage, storageName, storageFactory

function createCigarProductionStorage()
  local storage = {}
  storage._cigarProductionStorage = {}

  function storage.GetIdForSession()
    return #storage._cigarProductionStorage + 1
  end

  function storage.GetSessionBySource(playerId)
    local sessionId = nil

    for index = 1, #storage._cigarProductionStorage do
      local session = storage._cigarProductionStorage[index]

      if session and session.playerId == playerId then
        sessionId = index
      end
    end

    return sessionId
  end

  function storage.UnregisterSession(playerId)
    local sessionId = storage.GetSessionBySource(playerId)

    if sessionId then
      storage._cigarProductionStorage[sessionId] = nil
      return true
    end

    return false
  end

  function storage.RegisterSession(sessionData)
    if not sessionData then
      return
    end

    storage._cigarProductionStorage[sessionData.id] = sessionData
    return sessionData.id
  end

  RegisterCommand("prison_cigar_production", function(source)
    if source ~= 0 then
      return
    end

    if next(storage._cigarProductionStorage) then
      tprint(storage._cigarProductionStorage)
    else
      dbg.debug("There is no active cigar production sessions!")
    end
  end, false)

  return storage
end

CigarProductionStorage = createCigarProductionStorage
storageName = STORAGE_CIGAR_PRODUCTION
storageFactory = CigarProductionStorage()
Object.registerStorage(storageName, storageFactory)
