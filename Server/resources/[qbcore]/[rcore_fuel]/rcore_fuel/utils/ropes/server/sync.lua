--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

RopeCache = {}

local MAX_ROPES_PER_PLAYER = 32
local MAX_ROPE_ENDPOINT_DISTANCE = 75.0
local RopeAddRateLimit = {}
local RopeFetchRateLimit = {}

local function IsFiniteNumber(value)
    local n = tonumber(value)
    return n and n == n and n ~= math.huge and n ~= -math.huge and n or nil
end

local function IsVectorLike(value)
    if value == nil then return false end
    local ok, x, y, z = pcall(function()
        return IsFiniteNumber(value.x), IsFiniteNumber(value.y), IsFiniteNumber(value.z)
    end)
    return ok and x ~= nil and y ~= nil and z ~= nil
end

local function CopyVector(value)
    if not IsVectorLike(value) then return nil end
    return vector3(IsFiniteNumber(value.x), IsFiniteNumber(value.y), IsFiniteNumber(value.z))
end

local function ClampNumber(value, minimum, maximum, fallback)
    value = IsFiniteNumber(value)
    if not value then return fallback end
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

local function ResolveAndValidateEntityData(src, data)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local playerCoords = GetEntityCoords(ped)

    if data[1] == 1 then
        local entity = NetworkGetEntityFromNetworkId(data[2])
        if not entity or entity == 0 or not DoesEntityExist(entity) then
            return false, "endpoint_not_ready"
        end
        return #(GetEntityCoords(entity) - playerCoords) <= MAX_ROPE_ENDPOINT_DISTANCE
    elseif data[1] == 2 then
        return #(data[2] - playerCoords) <= MAX_ROPE_ENDPOINT_DISTANCE
    end

    return false
end

local function SanitizeEntityData(data)
    if type(data) ~= "table" then return nil end
    local entityType = IsFiniteNumber(data[1])
    if entityType == 1 then
        local netId = IsFiniteNumber(data[2])
        if not netId or netId <= 0 then return nil end
        return { 1, math.floor(netId) }
    elseif entityType == 2 then
        local coords = CopyVector(data[2])
        local model = IsFiniteNumber(data[3])
        if not coords or not model then return nil end
        return { 2, coords, math.floor(model) }
    end
    return nil
end

local function SanitizeRopeData(data)
    data = type(data) == "table" and data or {}
    return {
        maxLength = ClampNumber(data.maxLength, 0.1, 100.0, 4.0),
        ropeType = math.floor(ClampNumber(data.ropeType, 0, 7, 6)),
        initLength = ClampNumber(data.initLength, 0.1, 100.0, 10.0),
        minLength = ClampNumber(data.minLength, 0.0, 100.0, 1.0),
        lengthChangeRate = ClampNumber(data.lengthChangeRate, -20.0, 20.0, 0.0),
        onlyPPU = ClampNumber(data.onlyPPU, 0, 1, 0) >= 1 and 1 or 0,
        collisionOn = ClampNumber(data.collisionOn, 0, 1, 1) >= 1 and 1 or 0,
        lockFromFront = math.floor(ClampNumber(data.lockFromFront, 0, 2, 2)),
        timeMultiplier = ClampNumber(data.timeMultiplier, 0.01, 10.0, 0.2),
        breakable = ClampNumber(data.breakable, 0, 1, 0) >= 1 and 1 or 0,
    }
end

local function CountPlayerRopes(src)
    local count = 0
    for _, ropeEntry in pairs(RopeCache) do
        if tonumber(ropeEntry.source) == tonumber(src) then
            count = count + 1
        end
    end
    return count
end

local function SanitizeRopeEntry(src, ropeEntry)
    if type(ropeEntry) ~= "table" then return nil end

    local handler = ropeEntry.ropeHandler
    if type(handler) ~= "string" or #handler < 6 or #handler > 64 or not handler:match("^[%w]+$") then
        return nil
    end

    local existing = RopeCache[handler]
    if existing and tonumber(existing.source) ~= tonumber(src) then
        return nil
    end

    local ropeType = IsFiniteNumber(ropeEntry.ropeType)
    if ropeType ~= 1 and ropeType ~= 2 then return nil end

    local ropeStartPos = CopyVector(ropeEntry.ropeStartPos)
    local rotation = CopyVector(ropeEntry.rotation)
    if not ropeStartPos or not rotation then return nil end

    local safe = {
        source = src,
        ropeType = ropeType,
        ropeHandler = handler,
        ropeStartPos = ropeStartPos,
        rotation = rotation,
        data = SanitizeRopeData(ropeEntry.data),
    }

    if ropeType == 1 then
        safe.entityData = SanitizeEntityData(ropeEntry.entityData)
        safe.entityAttachData = SanitizeEntityData(ropeEntry.entityAttachData)
        safe.ropeEndPos = CopyVector(ropeEntry.ropeEndPos)
        if not safe.entityData or not safe.entityAttachData or not safe.ropeEndPos then
            return nil
        end
        -- Attached-rope start/end vectors are entity-local offsets, not world
        -- positions. Validate the actual endpoint entities/coordinates instead.
        local firstValid, firstReason = ResolveAndValidateEntityData(src, safe.entityData)
        local secondValid, secondReason = ResolveAndValidateEntityData(src, safe.entityAttachData)
        if not firstValid then return nil, firstReason or "endpoint_out_of_range" end
        if not secondValid then return nil, secondReason or "endpoint_out_of_range" end
    else
        -- Static rope positions are world coordinates, so reject remote arbitrary
        -- creation far away from the sending player.
        local ped = GetPlayerPed(src)
        if not ped or ped == 0 or #(GetEntityCoords(ped) - ropeStartPos) > 75.0 then
            return nil
        end
    end

    return safe
end

RegisterNetEvent("rcore_rope:sync:fetch", function()
    local src = source
    local now = GetGameTimer()
    if RopeFetchRateLimit[src] and now - RopeFetchRateLimit[src] < 2000 then return end
    RopeFetchRateLimit[src] = now
    TriggerClientEvent("rcore_rope:sync:fetch", src, RopeCache)
end)

RegisterNetEvent("rcore_rope:sync:AddToCache", function(ropeEntry)
    local src = source
    local handler = type(ropeEntry) == "table" and ropeEntry.ropeHandler
    if type(handler) ~= "string" or #handler < 6 or #handler > 64 or not handler:match("^[%w]+$") then return end
    local function reject(reason)
        TriggerClientEvent("rcore_rope:sync:AddResult", src, handler, reason)
    end
    local now = GetGameTimer()
    if RopeAddRateLimit[src] and now - RopeAddRateLimit[src] < 100 then
        reject("rate_limited")
        return
    end
    RopeAddRateLimit[src] = now
    local existing = RopeCache[handler]
    if existing then
        if tonumber(existing.source) ~= tonumber(src) then
            reject("handler_owned_by_another_player")
        else
            -- A retry acknowledges the original rope without replacing it or
            -- respawning every other client's rendered rope.
            TriggerClientEvent("rcore_rope:sync:AddToCache", src, existing)
        end
        return
    end
    if CountPlayerRopes(src) >= MAX_ROPES_PER_PLAYER then reject("rope_limit") return end

    local safeEntry, reason = SanitizeRopeEntry(src, ropeEntry)
    if not safeEntry then reject(reason or "invalid_request") return end

    RopeCache[safeEntry.ropeHandler] = safeEntry
    TriggerClientEvent("rcore_rope:sync:AddToCache", -1, safeEntry)
end)

RegisterNetEvent("rcore_rope:sync:RemoveFromCache", function(ropeHandler)
    local src = source
    -- Cleanup of owned ropes must not be dropped when a hose swap removes
    -- several ropes in one frame. Ownership and the creation cap bound this.
    if type(ropeHandler) ~= "string" then return end
    local ropeEntry = RopeCache[ropeHandler]
    if not ropeEntry or tonumber(ropeEntry.source) ~= tonumber(src) then return end

    RopeCache[ropeHandler] = nil
    TriggerClientEvent("rcore_rope:sync:RemoveFromCache", -1, ropeHandler)
end)

AddEventHandler("playerDropped", function()
    local src = source
    RopeAddRateLimit[src] = nil
    RopeFetchRateLimit[src] = nil
    for ropeHandler, ropeEntry in pairs(RopeCache) do
        if tonumber(ropeEntry.source) == tonumber(src) then
            RopeCache[ropeHandler] = nil
            TriggerClientEvent("rcore_rope:sync:RemoveFromCache", -1, ropeHandler)
        end
    end
end)
