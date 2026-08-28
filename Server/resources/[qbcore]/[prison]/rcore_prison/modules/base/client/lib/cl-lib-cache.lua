Cache = type(_G.Cache) == 'table' and _G.Cache or {}

local function buildPlayerCacheKey(section)
    local playerId = PlayerId()
    local playerName = GetPlayerName(playerId) or "unknown"

    return string.format("PRISON_%s_%s", section, playerName)
end

function Cache.DeleteOutfitKVP()
    local kvpKey = buildPlayerCacheKey("OUTFIT")
    local savedValue = GetResourceKvpString(kvpKey)

    if savedValue then
        DeleteResourceKvp(kvpKey)
    end
end

function Cache.SaveOutfitKVP(outfitValue)
    local kvpKey = buildPlayerCacheKey("OUTFIT")
    return SetResourceKvp(kvpKey, outfitValue)
end

function Cache.GetOutfitKVP()
    local kvpKey = buildPlayerCacheKey("OUTFIT")
    local savedValue = GetResourceKvpString(kvpKey)

    if savedValue then
        return tonumber(savedValue)
    end

    return nil
end

function Cache.DeletePrologKVP()
    local kvpKey = buildPlayerCacheKey("PROLOG")
    local savedValue = GetResourceKvpInt(kvpKey)

    if savedValue == 1 then
        DeleteResourceKvp(kvpKey)
    end
end

function Cache.GetPrologKVP()
    local kvpKey = buildPlayerCacheKey("PROLOG")
    return GetResourceKvpInt(kvpKey)
end

function Cache.SetPrologKVP(value)
    local kvpKey = buildPlayerCacheKey("PROLOG")
    return SetResourceKvpInt(kvpKey, value)
end