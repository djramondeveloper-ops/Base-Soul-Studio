local function CreateCanteenStorage()
  local storage = {
    storageSessions = {}
  }

  function storage.isSessionRegistered(playerId)
    return storage.storageSessions[playerId] ~= nil
  end

  function storage.registerSession(playerId)
    storage.storageSessions[playerId] = true

    local cooldown = Config.Canteen.FreeFoodPackageCooldown * 60 * 1000
    SetTimeout(cooldown, function()
      storage.storageSessions[playerId] = nil
    end)
  end

  return storage
end

CanteenStorage = CreateCanteenStorage
Object.registerStorage(STORAGE_CANTEEN, CanteenStorage())
