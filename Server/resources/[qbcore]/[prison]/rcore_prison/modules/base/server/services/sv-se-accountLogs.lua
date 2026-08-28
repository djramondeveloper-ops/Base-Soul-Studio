AccountLogService = {
    isDBReady = false
}

function AccountLogService.RegisterTransaction(action, description, charId, amount)
    local storage = Object.getStorage(STORAGE_ACCOUNT_LOGS)
    if not storage then
        return nil
    end

    local logEntry = {
        action = action,
        desc = description,
        charId = charId,
        amount = amount,
        created_at = os.date("%Y-%m-%d %H:%M:%S")
    }

    storage.addLog(logEntry)

    local registered = db.RegisterAccountTransaction(action, description, charId, amount)
    if registered then
        dbg.debug("Account log registered successfully")
    end

    return registered
end

function AccountLogService.GetLogsByCharId(charId)
    local storage = Object.getStorage(STORAGE_ACCOUNT_LOGS)
    if not storage then
        return nil
    end

    local logs = storage.getLogs()
    local filteredLogs = {}

    for _, logEntry in ipairs(logs) do
        if logEntry.charId == charId then
            table.insert(filteredLogs, logEntry)
        end
    end

    return filteredLogs
end

function AccountLogService.LoadAllLogs()
    local databaseLogs = db.FetchAccountLogs()
    local storage = Object.getStorage(STORAGE_ACCOUNT_LOGS)

    if not storage then
        return nil
    end

    if databaseLogs and next(databaseLogs) then
        for _, logEntry in ipairs(databaseLogs) do
            if logEntry then
                storage.addLog(logEntry)
            end
            Wait(0)
        end
    end

    AccountLogService.isDBReady = true
    return true
end

function AccountLogService.GetLogs()
    local storage = Object.getStorage(STORAGE_ACCOUNT_LOGS)
    if not storage then
        return nil
    end

    return storage.getLogs()
end
