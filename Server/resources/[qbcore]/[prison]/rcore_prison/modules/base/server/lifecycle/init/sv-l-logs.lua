local registerCallback = callback.register
local callbackName = "rcore_prison:server:getAllLogs"

local function getAllLogs(playerSource, _)
    if not Framework.canPerformJobCommand(playerSource) then
        return {}
    end

    local rawLogs = LogService.GetLogs()
    local logCount = table.size(rawLogs)
    local logs = {}

    if rawLogs then
        for _, logEntry in pairs(rawLogs) do
            table.insert(logs, logEntry)
        end
    end

    return {
        hasMore = logCount == 4,
        logs = logs
    }
end

registerCallback(callbackName, getAllLogs)