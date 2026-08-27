-- 0r-mapeditor - Seoul Base
-- Opening, database bootstrap and safe export publishing.

local RESOURCE = GetCurrentResourceName()
local EXPORT_ROOT = tostring(Config.exportPath or 'exports'):gsub('^/+', ''):gsub('/+$', '')
if EXPORT_ROOT == '' or EXPORT_ROOT:find('..', 1, true) then EXPORT_ROOT = 'exports' end

local function hasPermission(src)
    return Bridge.HasPermission(src)
end

local function openForPlayer(src)
    src = tonumber(src)
    if not src or src <= 0 then return false end

    if not hasPermission(src) then
        Bridge.Notify(src, locale('notify.not_allowed'), 'error')
        return false
    end

    TriggerClientEvent('0r-mapeditor:openGranted', src)
    return true
end

exports('OpenForPlayer', openForPlayer)

-- Compatibility endpoint. There is no /mapeditor command or F7 keybind in Seoul.
RegisterNetEvent('0r-mapeditor:requestOpen', function()
    openForPlayer(source)
end)

-- ---------------------------------------------------------------------------
-- Safe export bundle
-- ---------------------------------------------------------------------------
-- The leaked/decrypted package had a broken replacement for the original C#
-- publisher: it received CSV/Lua/manifest/JSON strings but treated them as an
-- object table, then wrote XML text with a .ymap extension. FiveM does not turn
-- that XML into a compiled YMAP automatically. Seoul therefore publishes a
-- runnable Lua map resource bundle plus a CodeWalker-friendly .ymap.xml source.
-- ---------------------------------------------------------------------------

local function finiteNumber(value, default)
    local number = tonumber(value)
    if not number or number ~= number or number == math.huge or number == -math.huge then
        return default or 0.0
    end
    return number
end

local function asBool(value, default)
    if value == nil then return default == true end
    if value == false or value == 0 or value == '0' or value == 'false' then return false end
    return true
end

local function clamp(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function sanitizeName(value)
    local name = tostring(value or '')
        :gsub('[%c]', '')
        :gsub('[^%w_%- ]', '')
        :gsub('%s+', '_')
        :lower()
    name = name:sub(1, 64)
    if name == '' then name = 'seoul_map' end
    return name
end

local function xmlEscape(value)
    return tostring(value or '')
        :gsub('&', '&amp;')
        :gsub('<', '&lt;')
        :gsub('>', '&gt;')
        :gsub('"', '&quot;')
        :gsub("'", '&apos;')
end

local function normalizeExport(raw)
    if type(raw) ~= 'table' then return nil, 'invalid payload' end

    local objects = type(raw.objects) == 'table' and raw.objects or {}
    local hidden = type(raw.hidden) == 'table' and raw.hidden or {}
    local lights = type(raw.lights) == 'table' and raw.lights or {}

    local maxObjects = tonumber(Config.maxObjects) or 5000
    if #objects > maxObjects then return nil, 'too many objects' end
    if #hidden > (Config.maxHiddenProps or 2500) then return nil, 'too many hidden props' end
    if #lights > (Config.maxLights or 1000) then return nil, 'too many lights' end

    local out = {
        name = tostring(raw.name or 'Untitled'):sub(1, 128),
        objects = {},
        hidden = {},
        lights = {},
    }

    for _, object in ipairs(objects) do
        if type(object) == 'table' then
            local model = tostring(object.model or ''):sub(1, 128)
            if model ~= '' then
                out.objects[#out.objects + 1] = {
                    model = model,
                    x = finiteNumber(object.x), y = finiteNumber(object.y), z = finiteNumber(object.z),
                    rx = finiteNumber(object.rx), ry = finiteNumber(object.ry), rz = finiteNumber(object.rz),
                    lod = math.floor(clamp(finiteNumber(object.lod, 500), 50, 3000)),
                    alpha = math.floor(clamp(finiteNumber(object.alpha, 255), 0, 255)),
                    collision = asBool(object.collision, true),
                    frozen = asBool(object.frozen, true),
                    visible = asBool(object.visible, true),
                    interior = asBool(object.interior, false),
                }
            end
        end
    end

    for _, entry in ipairs(hidden) do
        if type(entry) == 'table' then
            local model = tostring(entry.model or ''):sub(1, 128)
            if model ~= '' then
                out.hidden[#out.hidden + 1] = {
                    model = model,
                    x = finiteNumber(entry.x), y = finiteNumber(entry.y), z = finiteNumber(entry.z),
                    radius = clamp(finiteNumber(entry.radius, 0.25), 0.05, 50.0),
                }
            end
        end
    end

    for _, light in ipairs(lights) do
        if type(light) == 'table' then
            out.lights[#out.lights + 1] = {
                x = finiteNumber(light.x), y = finiteNumber(light.y), z = finiteNumber(light.z),
                r = math.floor(clamp(finiteNumber(light.r, 255), 0, 255)),
                g = math.floor(clamp(finiteNumber(light.g, 255), 0, 255)),
                b = math.floor(clamp(finiteNumber(light.b, 255), 0, 255)),
                range = clamp(finiteNumber(light.range, 12.0), 0.1, 500.0),
                intensity = clamp(finiteNumber(light.intensity, 5.0), 0.0, 100.0),
            }
        end
    end

    return out
end

local function makeFxmanifest(slug)
    return ([=[fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name '%s'
description 'Mapa publicado pelo Seoul Prop Editor'
author 'Seoul Base / 0r-mapeditor'
version '1.0.0'

client_script 'client.lua'
]=]):format(slug)
end

local function luaBool(value)
    return value and 'true' or 'false'
end

local function makeClientLua(data, slug)
    local lines = {
        '-- Generated by Seoul Prop Editor',
        ('-- Map: %s'):format(slug),
        '',
        'local objects = {',
    }

    for _, object in ipairs(data.objects) do
        lines[#lines + 1] = string.format(
            '    { model = %q, x = %.6f, y = %.6f, z = %.6f, rx = %.6f, ry = %.6f, rz = %.6f, lod = %d, alpha = %d, collision = %s, frozen = %s, visible = %s },',
            object.model, object.x, object.y, object.z, object.rx, object.ry, object.rz,
            object.lod, object.alpha, luaBool(object.collision), luaBool(object.frozen), luaBool(object.visible)
        )
    end

    lines[#lines + 1] = '}'
    lines[#lines + 1] = 'local hidden = {'
    for _, entry in ipairs(data.hidden) do
        lines[#lines + 1] = string.format(
            '    { model = %q, x = %.6f, y = %.6f, z = %.6f, radius = %.6f },',
            entry.model, entry.x, entry.y, entry.z, entry.radius
        )
    end
    lines[#lines + 1] = '}'

    lines[#lines + 1] = 'local lights = {'
    for _, light in ipairs(data.lights) do
        lines[#lines + 1] = string.format(
            '    { x = %.6f, y = %.6f, z = %.6f, r = %d, g = %d, b = %d, range = %.4f, intensity = %.4f },',
            light.x, light.y, light.z, light.r, light.g, light.b, light.range, light.intensity
        )
    end
    lines[#lines + 1] = '}'

    local runtime = [=[
local spawned = {}

local function modelHash(model)
    return tonumber(model) or joaat(model)
end

local function roomKey(interior, x, y, z)
    local count = GetInteriorRoomCount(interior) or 0
    for roomIndex = 1, math.max(0, count - 1) do
        local ax, ay, az, bx, by, bz = GetInteriorRoomExtents(interior, roomIndex)
        if ax and x >= ax and x <= bx and y >= ay and y <= by and z >= az and z <= bz then
            local roomName = GetInteriorRoomName(interior, roomIndex)
            if roomName and roomName ~= '' then return joaat(roomName) end
        end
    end
    return 0
end

local function assignRoom(entity, x, y, z)
    local interior = GetInteriorAtCoords(x, y, z)
    if not interior or interior == 0 then return end
    local key = roomKey(interior, x, y, z)
    if key ~= 0 then ForceRoomForEntity(entity, interior, key) end
end

CreateThread(function()
    for _, entry in ipairs(hidden) do
        CreateModelHideExcludingScriptObjects(entry.x, entry.y, entry.z, entry.radius, modelHash(entry.model), true)
    end

    for _, object in ipairs(objects) do
        local hash = modelHash(object.model)
        if hash and hash ~= 0 and IsModelValid(hash) then
            RequestModel(hash)
            local deadline = GetGameTimer() + 5000
            while not HasModelLoaded(hash) and GetGameTimer() < deadline do Wait(0) end

            if HasModelLoaded(hash) then
                local entity = CreateObjectNoOffset(hash, object.x, object.y, object.z, false, false, false)
                if entity and entity ~= 0 and DoesEntityExist(entity) then
                    SetEntityRotation(entity, object.rx, object.ry, object.rz, 2, true)
                    SetEntityLodDist(entity, object.lod)
                    SetEntityCollision(entity, object.collision, object.collision)
                    SetEntityVisible(entity, object.visible, false)
                    if object.alpha < 255 then SetEntityAlpha(entity, object.alpha, false) end
                    FreezeEntityPosition(entity, object.frozen)
                    assignRoom(entity, object.x, object.y, object.z)
                    spawned[#spawned + 1] = entity
                end
                SetModelAsNoLongerNeeded(hash)
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        if #lights == 0 then
            Wait(1000)
        else
            for _, light in ipairs(lights) do
                DrawLightWithRange(light.x, light.y, light.z, light.r, light.g, light.b, light.range, light.intensity)
            end
            Wait(0)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, entity in ipairs(spawned) do
        if DoesEntityExist(entity) then DeleteEntity(entity) end
    end
    for _, entry in ipairs(hidden) do
        RemoveModelHide(entry.x, entry.y, entry.z, entry.radius, modelHash(entry.model), false)
    end
end)
]=]

    lines[#lines + 1] = runtime
    return table.concat(lines, '\n')
end

local function makeCsv(data)
    local lines = { 'model,x,y,z,rx,ry,rz,lod,collision,frozen,visible,alpha' }
    for _, object in ipairs(data.objects) do
        local model = object.model:gsub('[,\r\n]', '')
        lines[#lines + 1] = string.format(
            '%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%d,%s,%s,%s,%d',
            model, object.x, object.y, object.z, object.rx, object.ry, object.rz,
            object.lod, tostring(object.collision), tostring(object.frozen), tostring(object.visible), object.alpha
        )
    end
    return table.concat(lines, '\n')
end

local function eulerQuaternion(rx, ry, rz)
    local x = math.rad(rx) * 0.5
    local y = math.rad(ry) * 0.5
    local z = math.rad(rz) * 0.5
    local sx, cx = math.sin(x), math.cos(x)
    local sy, cy = math.sin(y), math.cos(y)
    local sz, cz = math.sin(z), math.cos(z)

    return {
        x = sx * cy * cz - cx * sy * sz,
        y = cx * sy * cz + sx * cy * sz,
        z = cx * cy * sz - sx * sy * cz,
        w = cx * cy * cz + sx * sy * sz,
    }
end

local function makeYmapXml(data, slug)
    local compatible = {}
    for _, object in ipairs(data.objects) do
        -- Collision-disabled/interior props need script behavior and are intentionally
        -- excluded from the static CodeWalker source.
        if object.collision and not object.interior then compatible[#compatible + 1] = object end
    end

    local minX, minY, minZ = 0.0, 0.0, 0.0
    local maxX, maxY, maxZ = 0.0, 0.0, 0.0
    if #compatible > 0 then
        minX, minY, minZ = compatible[1].x, compatible[1].y, compatible[1].z
        maxX, maxY, maxZ = minX, minY, minZ
        for _, object in ipairs(compatible) do
            minX, minY, minZ = math.min(minX, object.x), math.min(minY, object.y), math.min(minZ, object.z)
            maxX, maxY, maxZ = math.max(maxX, object.x), math.max(maxY, object.y), math.max(maxZ, object.z)
        end
    end

    local lines = {
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<CMapData>',
        ('  <name>%s</name>'):format(xmlEscape(slug)),
        '  <parent />',
        '  <flags value="0" />',
        '  <contentFlags value="65" />',
        string.format('  <streamingExtentsMin x="%.4f" y="%.4f" z="%.4f" />', minX - 50.0, minY - 50.0, minZ - 50.0),
        string.format('  <streamingExtentsMax x="%.4f" y="%.4f" z="%.4f" />', maxX + 50.0, maxY + 50.0, maxZ + 50.0),
        string.format('  <entitiesExtentsMin x="%.4f" y="%.4f" z="%.4f" />', minX - 25.0, minY - 25.0, minZ - 25.0),
        string.format('  <entitiesExtentsMax x="%.4f" y="%.4f" z="%.4f" />', maxX + 25.0, maxY + 25.0, maxZ + 25.0),
        '  <entities>',
    }

    for _, object in ipairs(compatible) do
        local q = eulerQuaternion(object.rx, object.ry, object.rz)
        lines[#lines + 1] = '    <Item type="CEntityDef">'
        lines[#lines + 1] = ('      <archetypeName>%s</archetypeName>'):format(xmlEscape(object.model))
        lines[#lines + 1] = '      <flags value="0" />'
        lines[#lines + 1] = '      <guid value="0" />'
        lines[#lines + 1] = string.format('      <position x="%.4f" y="%.4f" z="%.4f" />', object.x, object.y, object.z)
        lines[#lines + 1] = string.format('      <rotation x="%.6f" y="%.6f" z="%.6f" w="%.6f" />', -q.x, -q.y, -q.z, q.w)
        lines[#lines + 1] = '      <scaleXY value="1" />'
        lines[#lines + 1] = '      <scaleZ value="1" />'
        lines[#lines + 1] = '      <parentIndex value="-1" />'
        lines[#lines + 1] = ('      <lodDist value="%d" />'):format(object.lod)
        lines[#lines + 1] = '      <childLodDist value="0" />'
        lines[#lines + 1] = '      <lodLevel>LODTYPES_DEPTH_ORPHANHD</lodLevel>'
        lines[#lines + 1] = '      <numChildren value="0" />'
        lines[#lines + 1] = '      <priorityLevel>PRI_REQUIRED</priorityLevel>'
        lines[#lines + 1] = '      <extensions />'
        lines[#lines + 1] = '      <ambientOcclusionMultiplier value="255" />'
        lines[#lines + 1] = '      <artificialAmbientOcclusion value="255" />'
        lines[#lines + 1] = '      <tintValue value="0" />'
        lines[#lines + 1] = '    </Item>'
    end

    lines[#lines + 1] = '  </entities>'
    lines[#lines + 1] = '  <containerLods />'
    lines[#lines + 1] = '  <boxOccluders />'
    lines[#lines + 1] = '  <occludeModels />'
    lines[#lines + 1] = '  <physicsDictionaries />'
    lines[#lines + 1] = '  <instancedData><ImapLink /><PropInstanceList /><GrassInstanceList /></instancedData>'
    lines[#lines + 1] = '  <timeCycleModifiers />'
    lines[#lines + 1] = '  <carGenerators />'
    lines[#lines + 1] = '  <LODLightsSOA />'
    lines[#lines + 1] = '  <DistantLODLightsSOA />'
    lines[#lines + 1] = '  <block>'
    lines[#lines + 1] = '    <version value="0" />'
    lines[#lines + 1] = '    <flags value="0" />'
    lines[#lines + 1] = ('    <name>%s</name>'):format(xmlEscape(slug))
    lines[#lines + 1] = '    <exportedBy>Seoul Prop Editor</exportedBy>'
    lines[#lines + 1] = '    <owner />'
    lines[#lines + 1] = '    <time />'
    lines[#lines + 1] = '  </block>'
    lines[#lines + 1] = '</CMapData>'
    return table.concat(lines, '\n'), #compatible
end

local function makeReadme(slug, data, ymapCount)
    return ([=[SEOUL PROP EDITOR - EXPORT: %s

ARQUIVOS GERADOS
- %s.fxmanifest.lua  -> renomeie para fxmanifest.lua
- %s.client.lua      -> renomeie para client.lua
- %s.json            -> backup/importacao no Prop Editor
- %s.csv             -> planilha/listagem dos props
- %s.ymap.xml        -> fonte XML para abrir/importar no CodeWalker

RESOURCE PRONTO
1. Crie Server/resources/[maps]/%s/
2. Copie %s.fxmanifest.lua para essa pasta como fxmanifest.lua
3. Copie %s.client.lua para essa pasta como client.lua
4. Adicione: ensure %s

O client.lua e o caminho recomendado: preserva %d props, %d ocultacoes de props do mundo e %d luzes.
O .ymap.xml contem %d props compativeis com YMAP estatico. Ele NAO e um .ymap binario compilado;
abra/importe no CodeWalker e gere o .ymap compilado se quiser usar streaming nativo.

Mapas marcados como PERMANENTE dentro do Prop Editor nao precisam deste export para funcionar:
o proprio 0r-mapeditor carrega esses mapas automaticamente para todos os jogadores.
]=]):format(
        slug, slug, slug, slug, slug, slug,
        slug, slug, slug, slug,
        #data.objects, #data.hidden, #data.lights, ymapCount
    )
end

local function writeVerified(path, content)
    if type(content) ~= 'string' then return false end
    SaveResourceFile(RESOURCE, path, content, #content)
    local check = LoadResourceFile(RESOURCE, path)
    return check == content
end

RegisterNetEvent('0r-mapeditor:publishYmap', function(exportName, _legacyCsv, _legacyLua, _legacyManifest, jsonData, mapId, mapName)
    local src = source
    if not src or src == 0 then return end

    if not hasPermission(src) then
        Bridge.Notify(src, locale('notify.not_allowed'), 'error')
        return
    end

    if type(jsonData) ~= 'string' or #jsonData == 0 or #jsonData > (16 * 1024 * 1024) then
        TriggerClientEvent('0r-mapeditor:ymapResult', src, nil, 'invalid_json', false)
        return
    end

    local ok, decoded = pcall(json.decode, jsonData)
    if not ok then
        TriggerClientEvent('0r-mapeditor:ymapResult', src, nil, 'invalid_json', false)
        return
    end

    local data, normalizeError = normalizeExport(decoded)
    if not data then
        print(('[0r-mapeditor] Publish rejected for %s: %s'):format(src, tostring(normalizeError)))
        TriggerClientEvent('0r-mapeditor:ymapResult', src, nil, normalizeError, false)
        return
    end

    local requestedName = exportName or mapName or data.name or ('map_' .. tostring(mapId or ''))
    local slug = sanitizeName(requestedName)

    local ymapXml, ymapCount = makeYmapXml(data, slug)
    local files = {
        [slug .. '.fxmanifest.lua'] = makeFxmanifest(slug),
        [slug .. '.client.lua'] = makeClientLua(data, slug),
        [slug .. '.json'] = json.encode(data),
        [slug .. '.csv'] = makeCsv(data),
        [slug .. '.ymap.xml'] = ymapXml,
        [slug .. '.README.txt'] = makeReadme(slug, data, ymapCount),
    }

    for fileName, content in pairs(files) do
        if not writeVerified(EXPORT_ROOT .. '/' .. fileName, content) then
            print(('[0r-mapeditor] Failed writing %s/%s'):format(EXPORT_ROOT, fileName))
            TriggerClientEvent('0r-mapeditor:ymapResult', src, nil, fileName, false)
            return
        end
    end

    if SaveLogAction then
        SaveLogAction(src, 'publish_map', ('%s (%d objects)'):format(slug, #data.objects))
    end

    print(('[0r-mapeditor] Published export bundle "%s" (%d objects, %d hidden, %d lights).'):format(
        slug, #data.objects, #data.hidden, #data.lights
    ))

    -- Client handler expects success as the third argument.
    TriggerClientEvent('0r-mapeditor:ymapResult', src, slug, EXPORT_ROOT .. '/' .. slug .. '.README.txt', true)
end)

-- ---------------------------------------------------------------------------
-- Database bootstrap
-- ---------------------------------------------------------------------------
CreateThread(function()
    local queries = {
        [[CREATE TABLE IF NOT EXISTS `mapeditor_maps` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(128) NOT NULL,
            `category` VARCHAR(64) DEFAULT 'general',
            `permanent` TINYINT(1) DEFAULT 0,
            `owner` VARCHAR(64) DEFAULT '',
            `objects` LONGTEXT,
            `hidden` LONGTEXT,
            `lights` LONGTEXT,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )]],
        [[CREATE TABLE IF NOT EXISTS `mapeditor_objects` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `map_id` INT DEFAULT NULL,
            `identifier` VARCHAR(64) DEFAULT '',
            `model` VARCHAR(128) DEFAULT '',
            `x` FLOAT DEFAULT 0,
            `y` FLOAT DEFAULT 0,
            `z` FLOAT DEFAULT 0,
            `rx` FLOAT DEFAULT 0,
            `ry` FLOAT DEFAULT 0,
            `rz` FLOAT DEFAULT 0,
            `lod` INT DEFAULT 500,
            `alpha` INT DEFAULT 255,
            `collision` TINYINT(1) DEFAULT 1,
            `frozen` TINYINT(1) DEFAULT 1,
            `visible` TINYINT(1) DEFAULT 1,
            `blip_on` TINYINT(1) DEFAULT 0,
            `blip_name` VARCHAR(64) DEFAULT '',
            `blip_color` INT DEFAULT 0,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (`map_id`),
            INDEX (`identifier`)
        )]],
        [[CREATE TABLE IF NOT EXISTS `mapeditor_prefabs` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(128) NOT NULL,
            `category` VARCHAR(64) DEFAULT 'general',
            `owner` VARCHAR(64) DEFAULT '',
            `data` LONGTEXT,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )]],
        [[CREATE TABLE IF NOT EXISTS `mapeditor_logs` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(64) DEFAULT '',
            `name` VARCHAR(64) DEFAULT '',
            `action` VARCHAR(64) DEFAULT '',
            `detail` LONGTEXT,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )]],
    }

    for _, query in ipairs(queries) do
        MySQL.query.await(query)
    end
    print('[0r-mapeditor] Database tables ready.')
end)
