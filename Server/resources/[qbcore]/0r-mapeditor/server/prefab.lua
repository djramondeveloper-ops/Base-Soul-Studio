-- Prefab CRUD for 0r-mapeditor

local function getIdentifier(src)
    local id = GetPlayerIdentifierByType(src, 'license')
    if not id or id == '' then
        id = GetPlayerIdentifier(src, 0)
    end
    return id or ('player_' .. tostring(src))
end

-- Client requests the list of available prefabs.
RegisterNetEvent('0r-mapeditor:getPrefabs', function()
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    local rows = MySQL.query.await(
        'SELECT `id`, `name`, `category` FROM `mapeditor_prefabs` ORDER BY `id` DESC'
    )
    TriggerClientEvent('0r-mapeditor:prefabList', src, rows or {})
end)

-- Client saves a new prefab.
RegisterNetEvent('0r-mapeditor:savePrefab', function(data)
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    if type(data) ~= 'table' then
        Bridge.Notify(src, locale('notify.prefab_save_fail'), 'error')
        return
    end
    local name = tostring(data.name or 'Prefab'):sub(1, 128)
    local category = tostring(data.category or 'general'):sub(1, 64)
    local payload = tostring(data.data or '')
    if payload == '' or #payload > 2 * 1024 * 1024 then
        Bridge.Notify(src, locale('notify.prefab_save_fail'), 'error')
        return
    end
    local identifier = getIdentifier(src)
    MySQL.insert.await(
        'INSERT INTO `mapeditor_prefabs` (`name`, `category`, `owner`, `data`) VALUES (?, ?, ?, ?)',
        { name, category, identifier, payload }
    )
    Bridge.Notify(src, locale('notify.prefab_saved', name), 'success')
    SaveLogAction(src, 'save_prefab', name)
end)

-- Client requests a prefab's data to place it.
RegisterNetEvent('0r-mapeditor:getPrefab', function(id)
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    id = tonumber(id)
    if not id then
        return
    end
    local row = MySQL.single.await(
        'SELECT `id`, `name`, `category`, `data` FROM `mapeditor_prefabs` WHERE `id` = ?',
        { id }
    )
    if row then
        TriggerClientEvent('0r-mapeditor:prefabData', src, row)
    end
end)

-- Client deletes a prefab.
RegisterNetEvent('0r-mapeditor:deletePrefab', function(id)
    local src = source
    if not src or src == 0 then
        return
    end
    if not Bridge.HasPermission(src) then
        return
    end
    id = tonumber(id)
    if not id then
        return
    end
    local identifier = getIdentifier(src)
    -- Only allow deleting prefabs the player owns (or if no owner recorded).
    local row = MySQL.single.await(
        'SELECT `owner` FROM `mapeditor_prefabs` WHERE `id` = ?',
        { id }
    )
    if row and (row.owner == '' or row.owner == identifier) then
        MySQL.update.await('DELETE FROM `mapeditor_prefabs` WHERE `id` = ?', { id })
        SaveLogAction(src, 'delete_prefab', id)
    else
        Bridge.Notify(src, locale('notify.delete_own'), 'error')
    end
end)
