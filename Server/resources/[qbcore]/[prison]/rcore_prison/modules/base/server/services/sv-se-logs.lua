LogService = {}

local function getLogStorage()
    return Object.getStorage(STORAGE_LOGS)
end

function LogService.RegisterTransaction(action, description, charId, officerName, citizenName)
    local storage = getLogStorage()
    if not storage then
        return nil
    end

    local logEntry = {
        action = action,
        desc = description,
        charId = charId,
        officer_name = officerName or "-",
        citizen_name = citizenName or "-",
        created_at = os.date("%Y-%m-%d %H:%M:%S")
    }

    storage.addLog(logEntry)

    local success = db.RegisterTransaction(action, description, charId, logEntry.officer_name, logEntry.citizen_name)
    if success then
        dbg.debug("Log registered successfully")
    end
end

function LogService.LoadAllLogs()
    local state = "LOADED_DATA_INTO_CACHE"
    local logs = db.FetchPrisonLogs() or {}
    local storage = getLogStorage()

    if not storage then
        return
    end

    if next(logs) then
        for _, logEntry in ipairs(logs) do
            if logEntry then
                storage.addLog(logEntry)
            end
            Wait(0)
        end
    else
        state = "NOT_ANY_LOGS_IN_DB"
    end

    dbg.debug("Logs data into cache state: %s", state)
end

function LogService.GetLogs()
    local storage = getLogStorage()
    if not storage then
        return nil
    end

    return storage.getLogs()
end
