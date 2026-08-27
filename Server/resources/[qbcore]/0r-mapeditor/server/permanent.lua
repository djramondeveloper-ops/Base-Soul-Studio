-- Seoul Base - permanent map runtime server cache

if Config.permanentRuntime == false then
    return
end

local PermanentCache = {}
local CacheReady = false
local RequestCooldown = {}

local function toBool(value)
    return value == true or value == 1 or value == '1' or value == 'true'
end

local function decodeList(raw)
    if type(raw) == 'table' then return raw end
    local ok, data = pcall(json.decode, raw or '[]')
    return ok and type(data) == 'table' and data or {}
end

local function rowToMap(row)
    if not row then return nil end
    return {
        id = tonumber(row.id),
        name = tostring(row.name or 'Untitled'),
        category = tostring(row.category or 'general'),
        permanent = toBool(row.permanent),
        objects = decodeList(row.objects),
        hidden = decodeList(row.hidden),
        lights = decodeList(row.lights),
    }
end

local function cacheAsArray()
    local list = {}
    for _, map in pairs(PermanentCache) do list[#list + 1] = map end
    table.sort(list, function(a, b) return (a.id or 0) < (b.id or 0) end)
    return list
end

local function reloadCache()
    local rows = MySQL.query.await([[
        SELECT `id`, `name`, `category`, `permanent`, `objects`, `hidden`, `lights`
        FROM `mapeditor_maps`
        WHERE `permanent` = 1
        ORDER BY `id` ASC
    ]]) or {}

    PermanentCache = {}
    for _, row in ipairs(rows) do
        local map = rowToMap(row)
        if map and map.id then PermanentCache[map.id] = map end
    end
    CacheReady = true
end

local function refreshOne(mapId)
    mapId = tonumber(mapId)
    if not mapId then return end

    local row = MySQL.single.await([[
        SELECT `id`, `name`, `category`, `permanent`, `objects`, `hidden`, `lights`
        FROM `mapeditor_maps`
        WHERE `id` = ?
    ]], { mapId })

    if row and toBool(row.permanent) then
        local map = rowToMap(row)
        PermanentCache[mapId] = map
        TriggerClientEvent('0r-mapeditor:permanentUpsert', -1, map)
    else
        PermanentCache[mapId] = nil
        TriggerClientEvent('0r-mapeditor:permanentRemove', -1, mapId)
    end
end

AddEventHandler('0r-mapeditor:mapChangedInternal', function(mapId)
    refreshOne(mapId)
end)

RegisterNetEvent('0r-mapeditor:requestPermanentMaps', function()
    local src = source
    if not src or src == 0 then return end

    local now = os.time()
    if RequestCooldown[src] and now - RequestCooldown[src] < 5 then return end
    RequestCooldown[src] = now

    if not CacheReady then
        local ok, err = pcall(reloadCache)
        if not ok then
            print(('[0r-mapeditor] Failed to load permanent maps: %s'):format(tostring(err)))
            return
        end
    end

    TriggerClientEvent('0r-mapeditor:permanentMaps', src, cacheAsArray())
end)

AddEventHandler('playerDropped', function()
    RequestCooldown[source] = nil
end)

CreateThread(function()
    -- server/main.lua creates the tables on first install. Retry until that is ready.
    for attempt = 1, 10 do
        Wait(attempt == 1 and 1200 or 750)
        local ok, err = pcall(reloadCache)
        if ok then
            print(('[0r-mapeditor] Permanent runtime ready (%d map(s)).'):format(#cacheAsArray()))
            return
        end
        if attempt == 10 then
            print(('[0r-mapeditor] Permanent runtime failed to initialize: %s'):format(tostring(err)))
        end
    end
end)
