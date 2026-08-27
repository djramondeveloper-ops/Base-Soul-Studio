-- Activity logging for 0r-mapeditor

local function getIdentifier(src)
    local id = GetPlayerIdentifierByType(src, 'license')
    if not id or id == '' then
        id = GetPlayerIdentifier(src, 0)
    end
    return id or ('player_' .. tostring(src))
end

local function getPlayerName(src)
    return GetPlayerName(src) or 'Unknown'
end

-- Write a log entry for a player action.
function SaveLogAction(src, action, detail)
    if not Config.logsEnabled then
        return
    end
    local identifier = getIdentifier(src)
    local name = getPlayerName(src)
    MySQL.insert.await(
        'INSERT INTO `mapeditor_logs` (`identifier`, `name`, `action`, `detail`) VALUES (?, ?, ?, ?)',
        { identifier, name, tostring(action), tostring(detail) }
    )
end

-- Client reports an activity (e.g. publish_ymap).
RegisterNetEvent('0r-mapeditor:log', function(action, detail)
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    action = tostring(action or ''):sub(1, 64)
    detail = tostring(detail or ''):sub(1, 2048)
    SaveLogAction(src, action, detail)
end)

-- Client requests the activity log.
RegisterNetEvent('0r-mapeditor:getLogs', function()
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    local rows = MySQL.query.await(
        'SELECT `action`, `name`, `detail`, `created_at` FROM `mapeditor_logs` ORDER BY `id` DESC LIMIT 100'
    )
    TriggerClientEvent('0r-mapeditor:logs', src, rows or {})
end)
