local function CreateLogsStorage()
  local storage = {
    logs = {}
  }

  function storage.addLog(logEntry)
    storage.logs[#storage.logs + 1] = logEntry
    return true
  end

  function storage.getLogs()
    return storage.logs
  end

  return storage
end

LogsStorage = CreateLogsStorage
Object.registerStorage(STORAGE_LOGS, LogsStorage())
