-- Seoul Base - permanent map runtime
-- Loads maps marked as permanent for every player without networking thousands of props.

if Config.permanentRuntime == false then
    return
end

local PermanentMaps = {}
local SpawnedMaps = {}
local EditorActive = false
local NeedsRespawn = false

local function asBool(value, default)
    if value == nil then return default == true end
    if value == false or value == 0 or value == '0' or value == 'false' then return false end
    return true
end

local function modelHash(model)
    if type(model) == 'number' then return model end
    local numeric = tonumber(model)
    if numeric then return numeric end
    return joaat(tostring(model or ''))
end

local function removeHide(entry)
    local hash = modelHash(entry.model)
    RemoveModelHide(
        tonumber(entry.x) or 0.0,
        tonumber(entry.y) or 0.0,
        tonumber(entry.z) or 0.0,
        tonumber(entry.radius) or 0.25,
        hash,
        false
    )
end

local function clearSpawnedMap(mapId)
    local state = SpawnedMaps[tostring(mapId)]
    if not state then return end
    state.cancelled = true

    for _, entity in ipairs(state.entities or {}) do
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    for _, hidden in ipairs(state.hidden or {}) do
        removeHide(hidden)
    end

    SpawnedMaps[tostring(mapId)] = nil
end

local function clearAllSpawned()
    local ids = {}
    for mapId in pairs(SpawnedMaps) do ids[#ids + 1] = mapId end
    for _, mapId in ipairs(ids) do clearSpawnedMap(mapId) end
end

local function roomKey(interior, x, y, z)
    if not interior or interior == 0 then return 0 end
    local count = GetInteriorRoomCount(interior) or 0
    for roomIndex = 1, math.max(0, count - 1) do
        local ax, ay, az, bx, by, bz = GetInteriorRoomExtents(interior, roomIndex)
        if ax and x >= ax and x <= bx and y >= ay and y <= by and z >= az and z <= bz then
            local roomName = GetInteriorRoomName(interior, roomIndex)
            if roomName and roomName ~= '' then
                return joaat(roomName)
            end
        end
    end
    return 0
end

local function assignInteriorRoom(entity, x, y, z)
    local interior = GetInteriorAtCoords(x, y, z)
    if not interior or interior == 0 then return end

    local key = roomKey(interior, x, y, z)
    if key ~= 0 then
        ForceRoomForEntity(entity, interior, key)
    end
end

local function spawnObject(object)
    local hash = modelHash(object.model)
    if not hash or hash == 0 or not IsModelValid(hash) then
        return nil
    end

    RequestModel(hash)
    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do
        Wait(0)
    end

    if not HasModelLoaded(hash) then
        return nil
    end

    local x = tonumber(object.x) or 0.0
    local y = tonumber(object.y) or 0.0
    local z = tonumber(object.z) or 0.0
    local entity = CreateObjectNoOffset(hash, x, y, z, false, false, false)

    if entity and entity ~= 0 and DoesEntityExist(entity) then
        SetEntityRotation(
            entity,
            tonumber(object.rx) or 0.0,
            tonumber(object.ry) or 0.0,
            tonumber(object.rz) or 0.0,
            2,
            true
        )

        local lod = math.floor(tonumber(object.lod) or 500)
        SetEntityLodDist(entity, math.max(50, math.min(lod, 3000)))

        local collision = asBool(object.collision, true)
        SetEntityCollision(entity, collision, collision)
        SetEntityVisible(entity, asBool(object.visible, true), false)

        local alpha = math.floor(tonumber(object.alpha) or 255)
        alpha = math.max(0, math.min(alpha, 255))
        if alpha < 255 then SetEntityAlpha(entity, alpha, false) end

        FreezeEntityPosition(entity, asBool(object.frozen, true))
        assignInteriorRoom(entity, x, y, z)
    else
        entity = nil
    end

    SetModelAsNoLongerNeeded(hash)
    return entity
end

local function canSpawnRuntime()
    if EditorActive then return false end
    if Objects and Objects.Count and Objects.Count() > 0 then
        return false
    end
    return true
end

local function spawnPermanentMap(map)
    if type(map) ~= 'table' or not map.id then return end
    local mapId = tostring(map.id)

    PermanentMaps[mapId] = map
    clearSpawnedMap(mapId)

    if not canSpawnRuntime() then
        NeedsRespawn = true
        return
    end

    local state = { entities = {}, hidden = {}, cancelled = false }

    for _, hidden in ipairs(map.hidden or {}) do
        local entry = {
            model = hidden.model,
            x = tonumber(hidden.x) or 0.0,
            y = tonumber(hidden.y) or 0.0,
            z = tonumber(hidden.z) or 0.0,
            radius = math.max(0.05, math.min(tonumber(hidden.radius) or 0.25, 50.0)),
        }
        CreateModelHideExcludingScriptObjects(entry.x, entry.y, entry.z, entry.radius, modelHash(entry.model), true)
        state.hidden[#state.hidden + 1] = entry
    end

    CreateThread(function()
        for _, object in ipairs(map.objects or {}) do
            if state.cancelled then break end
            if not EditorActive then
                local entity = spawnObject(object)
                if entity then state.entities[#state.entities + 1] = entity end
            else
                NeedsRespawn = true
                break
            end
            Wait(0)
        end
    end)

    SpawnedMaps[mapId] = state
end

local function respawnAll()
    if not canSpawnRuntime() then
        NeedsRespawn = true
        return
    end

    clearAllSpawned()
    NeedsRespawn = false
    for _, map in pairs(PermanentMaps) do
        spawnPermanentMap(map)
    end
end

RegisterNetEvent('0r-mapeditor:permanentMaps', function(maps)
    PermanentMaps = {}
    for _, map in ipairs(type(maps) == 'table' and maps or {}) do
        if map and map.id then PermanentMaps[tostring(map.id)] = map end
    end
    respawnAll()
end)

RegisterNetEvent('0r-mapeditor:permanentUpsert', function(map)
    if type(map) ~= 'table' or not map.id then return end
    PermanentMaps[tostring(map.id)] = map
    spawnPermanentMap(map)
end)

RegisterNetEvent('0r-mapeditor:permanentRemove', function(mapId)
    mapId = tostring(mapId or '')
    PermanentMaps[mapId] = nil
    clearSpawnedMap(mapId)
end)

-- Multiple handlers on openGranted are intentional: main.lua opens the UI, this one
-- removes runtime copies so the admin does not edit on top of duplicated props.
AddEventHandler('0r-mapeditor:openGranted', function()
    EditorActive = true
    NeedsRespawn = true
    clearAllSpawned()
end)

AddEventHandler('0r-mapeditor:editorClosed', function()
    EditorActive = false
    -- Do not duplicate the editor's local working objects. Runtime maps return as
    -- soon as the editor workspace is empty (or on the next reconnect/resource start).
    if canSpawnRuntime() then
        respawnAll()
    else
        NeedsRespawn = true
    end
end)

CreateThread(function()
    Wait(2000)
    TriggerServerEvent('0r-mapeditor:requestPermanentMaps')

    while true do
        Wait(2500)
        if NeedsRespawn and canSpawnRuntime() then
            respawnAll()
        end
    end
end)

CreateThread(function()
    while true do
        local hasLights = false
        if not EditorActive then
            for mapId, map in pairs(PermanentMaps) do
                if SpawnedMaps[mapId] and type(map.lights) == 'table' then
                    for _, light in ipairs(map.lights) do
                        hasLights = true
                        DrawLightWithRange(
                            tonumber(light.x) or 0.0,
                            tonumber(light.y) or 0.0,
                            tonumber(light.z) or 0.0,
                            math.floor(tonumber(light.r) or 255),
                            math.floor(tonumber(light.g) or 255),
                            math.floor(tonumber(light.b) or 255),
                            tonumber(light.range) or 12.0,
                            tonumber(light.intensity) or 5.0
                        )
                    end
                end
            end
        end
        Wait(hasLights and 0 or 500)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearAllSpawned()
end)
