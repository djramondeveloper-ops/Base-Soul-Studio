local createLogsStorage, storageName, storageFactory

function createLogsStorage()
  local storage = {}
  storage.logs = {}

  function storage.addLog(logData)
    local nextLogId = #storage.logs + 1

    if not logData.id then
      logData.id = nextLogId
    end

    storage.logs[#storage.logs + 1] = logData
    return true
  end

  function storage.getLogs()
    return storage.logs
  end

  return storage
end

LogsStorage = createLogsStorage
storageName = STORAGE_ACCOUNT_LOGS
storageFactory = LogsStorage()
Object.registerStorage(storageName, storageFactory)
