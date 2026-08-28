local registerCallback = callback.register
local callbackName = "rcore_prison:server:getPrisonerAccountLogs"

local function getPrisonerAccountLogs(playerSource, _)
    local characterId = Framework.getIdentifier(playerSource)
    if not characterId then
        return {}
    end

    local accountLogs = AccountLogService.GetLogsByCharId(characterId)
    if not accountLogs then
        return {}
    end

    local logs = {}
    local logCount = table.size(accountLogs)

    for _, logEntry in pairs(accountLogs) do
        logs[#logs + 1] = logEntry
    end

    return {
        hasMore = logCount == 4,
        logs = logs
    }
end

registerCallback(callbackName, getPrisonerAccountLogs)