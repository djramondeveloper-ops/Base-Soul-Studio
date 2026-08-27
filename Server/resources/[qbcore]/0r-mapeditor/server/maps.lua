-- Map & object CRUD for 0r-mapeditor

local function getIdentifier(src)
    local id = GetPlayerIdentifierByType(src, 'license')
    if not id or id == '' then
        id = GetPlayerIdentifier(src, 0)
    end
    return id or ('player_' .. tostring(src))
end

local function toBool(v)
    if v == nil or v == false or v == 0 or v == '0' or v == 'false' then
        return false
    end
    return true
end

local function finiteNumber(v, default)
    local n = tonumber(v)
    if not n or n ~= n or n == math.huge or n == -math.huge then
        return default or 0.0
    end
    return n
end

local function toInt(v, default)
    return math.floor(finiteNumber(v, default or 0))
end

local function toFloat(v, default)
    return finiteNumber(v, default or 0.0)
end

-- ---------------------------------------------------------------------------
-- Object save
-- ---------------------------------------------------------------------------
RegisterNetEvent('0r-mapeditor:saveObject', function(data)
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    if type(data) ~= 'table' or type(data.object) ~= 'table' then return end

    local obj = data.object
    local mapId = tonumber(data.mapId)
    local identifier = getIdentifier(src)

    local model = tostring(obj.model or ''):sub(1, 128)
    if model == '' then return end

    local x = toFloat(obj.x)
    local y = toFloat(obj.y)
    local z = toFloat(obj.z)
    local rx = toFloat(obj.rx)
    local ry = toFloat(obj.ry)
    local rz = toFloat(obj.rz)
    local lod = toInt(obj.lod, 500)
    local alpha = toInt(obj.alpha, 255)
    local collision = toBool(obj.collision)
    local frozen = toBool(obj.frozen)
    local visible = toBool(obj.visible)
    local blipOn = toBool(obj.blipOn)
    local blipName = tostring(obj.blipName or ''):sub(1, 64)
    local blipColor = toInt(obj.blipColor)

    if mapId then
        local mapRow = MySQL.single.await(
            'SELECT `owner` FROM `mapeditor_maps` WHERE `id` = ?',
            { mapId }
        )
        if not mapRow or (mapRow.owner ~= '' and mapRow.owner ~= identifier) then
            Bridge.Notify(src, locale('notify.overwrite_own'), 'error')
            return
        end
    end

    local dbId = tonumber(data.dbId)
    local objectId
    if dbId and dbId ~= 0 then
        -- Nunca deixa um admin alterar silenciosamente um objeto pertencente a outro mapa/owner.
        local current = MySQL.single.await(
            'SELECT `identifier` FROM `mapeditor_objects` WHERE `id` = ?',
            { dbId }
        )
        if not current or (current.identifier ~= '' and current.identifier ~= identifier) then
            Bridge.Notify(src, locale('notify.overwrite_own'), 'error')
            return
        end

        MySQL.update.await([[
            UPDATE `mapeditor_objects` SET
                `map_id` = ?, `model` = ?, `x` = ?, `y` = ?, `z` = ?,
                `rx` = ?, `ry` = ?, `rz` = ?, `lod` = ?, `alpha` = ?,
                `collision` = ?, `frozen` = ?, `visible` = ?,
                `blip_on` = ?, `blip_name` = ?, `blip_color` = ?
            WHERE `id` = ?
        ]], {
            mapId, model, x, y, z, rx, ry, rz, lod, alpha,
            collision and 1 or 0, frozen and 1 or 0, visible and 1 or 0,
            blipOn and 1 or 0, blipName, blipColor,
            dbId
        })
        objectId = dbId
    else
        -- Insert new object
        objectId = MySQL.insert.await([[
            INSERT INTO `mapeditor_objects`
                (`map_id`, `identifier`, `model`, `x`, `y`, `z`, `rx`, `ry`, `rz`,
                 `lod`, `alpha`, `collision`, `frozen`, `visible`,
                 `blip_on`, `blip_name`, `blip_color`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            mapId, identifier, model, x, y, z, rx, ry, rz,
            lod, alpha, collision and 1 or 0, frozen and 1 or 0, visible and 1 or 0,
            blipOn and 1 or 0, blipName, blipColor
        })
    end

    -- Respond with the mapping so the client can set the dbId.
    TriggerClientEvent('0r-mapeditor:objectSaved', src, {
        mapId = mapId,
        localId = data.localId,
        dbId = objectId,
    })
end)

-- ---------------------------------------------------------------------------
-- Object delete
-- ---------------------------------------------------------------------------
RegisterNetEvent('0r-mapeditor:deleteObject', function(dbId)
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    dbId = tonumber(dbId)
    if not dbId then return end
    local identifier = getIdentifier(src)
    MySQL.update.await(
        "DELETE FROM `mapeditor_objects` WHERE `id` = ? AND (`identifier` = ? OR `identifier` = '')",
        { dbId, identifier }
    )
end)

RegisterNetEvent('0r-mapeditor:deleteObjects', function(data)
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    if type(data) ~= 'table' or type(data.dbIds) ~= 'table' then return end
    local ids = {}
    for _, v in ipairs(data.dbIds) do
        local n = tonumber(v)
        if n then ids[#ids + 1] = n end
        if #ids >= (Config.maxObjects or 5000) then break end
    end
    if #ids > 0 then
        local placeholders = table.concat((function()
            local arr = {}
            for _ = 1, #ids do arr[#arr + 1] = '?' end
            return arr
        end)(), ',')
        local identifier = getIdentifier(src)
        ids[#ids + 1] = identifier
        MySQL.update.await(
            "DELETE FROM `mapeditor_objects` WHERE `id` IN (" .. placeholders .. ") AND (`identifier` = ? OR `identifier` = '')",
            ids
        )
    end
end)

-- ---------------------------------------------------------------------------
-- Map save
-- ---------------------------------------------------------------------------
RegisterNetEvent('0r-mapeditor:saveMap', function(data)
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    if type(data) ~= 'table' then return end

    local identifier = getIdentifier(src)
    local mapId = tonumber(data.id)
    local name = tostring(data.name or 'Untitled'):sub(1, 128)
    local category = tostring(data.category or 'general'):sub(1, 64)
    local permanent = toBool(data.permanent)

    local objects = type(data.objects) == 'table' and data.objects or {}
    local hidden = type(data.hidden) == 'table' and data.hidden or {}
    local lights = type(data.lights) == 'table' and data.lights or {}

    if #objects > (Config.maxObjects or 5000)
        or #hidden > (Config.maxHiddenProps or 2500)
        or #lights > (Config.maxLights or 1000) then
        Bridge.Notify(src, locale('notify.map_too_large'), 'error')
        return
    end

    local objectsJson = json.encode(objects)
    local hiddenJson = json.encode(hidden)
    local lightsJson = json.encode(lights)
    if #objectsJson > (16 * 1024 * 1024)
        or #hiddenJson > (4 * 1024 * 1024)
        or #lightsJson > (4 * 1024 * 1024) then
        Bridge.Notify(src, locale('notify.map_too_large'), 'error')
        return
    end

    local newId
    if mapId and mapId ~= 0 then
        -- Ensure the map belongs to this player (or is unowned).
        local row = MySQL.single.await('SELECT `owner` FROM `mapeditor_maps` WHERE `id` = ?', { mapId })
        if not row or (row.owner ~= '' and row.owner ~= identifier) then
            Bridge.Notify(src, locale('notify.overwrite_own'), 'error')
            return
        end
        MySQL.update.await([[
            UPDATE `mapeditor_maps` SET
                `name` = ?, `category` = ?, `permanent` = ?,
                `objects` = ?, `hidden` = ?, `lights` = ?
            WHERE `id` = ?
        ]], { name, category, permanent and 1 or 0, objectsJson, hiddenJson, lightsJson, mapId })
        newId = mapId
    else
        newId = MySQL.insert.await([[
            INSERT INTO `mapeditor_maps`
                (`name`, `category`, `permanent`, `owner`, `objects`, `hidden`, `lights`)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ]], { name, category, permanent and 1 or 0, identifier, objectsJson, hiddenJson, lightsJson })
    end
    if not newId then
        Bridge.Notify(src, locale('notify.map_save_fail'), 'error')
        return
    end

    -- Save the objects into the objects table (replace) so they can be edited individually.
    MySQL.update.await('DELETE FROM `mapeditor_objects` WHERE `map_id` = ?', { newId })
    local rowIds = {}
    for _, o in ipairs(objects) do
        local model = tostring(o.model or ''):sub(1, 128)
        if model ~= '' then
            local pid = MySQL.insert.await([[
                INSERT INTO `mapeditor_objects`
                    (`map_id`, `identifier`, `model`, `x`, `y`, `z`, `rx`, `ry`, `rz`,
                     `lod`, `alpha`, `collision`, `frozen`, `visible`,
                     `blip_on`, `blip_name`, `blip_color`)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ]], {
                newId, identifier, model,
                toFloat(o.x), toFloat(o.y), toFloat(o.z),
                toFloat(o.rx), toFloat(o.ry), toFloat(o.rz),
                toInt(o.lod, 500), toInt(o.alpha, 255),
                toBool(o.collision) and 1 or 0,
                toBool(o.frozen) and 1 or 0,
                toBool(o.visible) and 1 or 0,
                toBool(o.blip_on) and 1 or 0,
                tostring(o.blip_name or ''):sub(1, 64),
                toInt(o.blip_color)
            })
            if pid then
                rowIds[#rowIds + 1] = { localId = o.eid, dbId = pid }
            end
        end
    end

    SaveLogAction(src, 'save_map', name)
    TriggerClientEvent('0r-mapeditor:mapSaved', src, newId, name, category, rowIds)
    TriggerEvent('0r-mapeditor:mapChangedInternal', newId)
end)

-- ---------------------------------------------------------------------------
-- Map list & load
-- ---------------------------------------------------------------------------
RegisterNetEvent('0r-mapeditor:getMaps', function()
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    local rows = MySQL.query.await(
        'SELECT `id`, `name`, `category`, `permanent`, `objects` FROM `mapeditor_maps` ORDER BY `id` DESC'
    )
    local list = {}
    for _, r in ipairs(rows or {}) do
        local count = 0
        local ok, decoded = pcall(json.decode, r.objects or '[]')
        if ok and type(decoded) == 'table' then
            count = #decoded
        end
        list[#list + 1] = {
            id = r.id,
            name = r.name,
            category = r.category,
            permanent = toBool(r.permanent),
            count = count,
        }
    end
    TriggerClientEvent('0r-mapeditor:mapList', src, list)
end)

RegisterNetEvent('0r-mapeditor:requestLoad', function(id)
    local src = source
    if not src or src == 0 then return end
    if not Bridge.HasPermission(src) then return end
    id = tonumber(id)
    if not id then return end
    local row = MySQL.single.await(
        'SELECT `id`, `name`, `category`, `permanent`, `objects`, `hidden`, `lights` FROM `mapeditor_maps` WHERE `id` = ?',
        { id }
    )
    if not row then return end

    local objects = {}
    local ok, decoded = pcall(json.decode, row.objects or '[]')
    if ok and type(decoded) == 'table' then objects = decoded end

    local hidden = {}
    ok, decoded = pcall(json.decode, row.hidden or '[]')
    if ok and type(decoded) == 'table' then hidden = decoded end

    local lights = {}
    ok, decoded = pcall(json.decode, row.lights or '[]')
    if ok and type(decoded) == 'table' then lights = decoded end

    TriggerClientEvent('0r-mapeditor:loadMap', src, {
        id = row.id,
        name = row.name,
        category = row.category,
        permanent = toBool(row.permanent),
        objects = objects,
        hidden = hidden,
        lights = lights,
    })
end)
