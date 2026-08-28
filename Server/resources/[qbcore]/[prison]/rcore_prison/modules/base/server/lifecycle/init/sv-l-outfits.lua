NetworkService.EventListener("heartbeat", function(eventName, eventData)
    if not next(eventData) then
        return
    end

    if Config.Cloth ~= Cloth.FAPPEARANCE then
        return
    end

    local prisoner = eventData.prisoner
    if not prisoner then
        return
    end

    local function restoreCachedOutfit(targetSource, ownerIdentifier)
        if not targetSource then
            return
        end

        local cachedOutfit = GetCachedOutfit(ownerIdentifier)
        if cachedOutfit and next(cachedOutfit) then
            StartClient(targetSource, "StoredOutfit", cachedOutfit)
        end
    end

    if eventName == HEARTBEAT_EVENTS.PRISONER_LOADED then
        restoreCachedOutfit(prisoner.source, prisoner.owner)
    elseif eventName == HEARTBEAT_EVENTS.PRISONER_RELEASED then
        restoreCachedOutfit(prisoner.source, prisoner.owner)
    end
end)

RegisterNetEvent("rcore_prison:request:saveOutfitIntoCache", function(outfitData)
    local playerSource = source

    if not PrisonService.CheckForAnySentence(playerSource) then
        return
    end

    if Config.Cloth ~= Cloth.FAPPEARANCE then
        return
    end

    local identifier = Framework.getIdentifier(playerSource)
    if not identifier then
        return
    end

    if type(outfitData) ~= "table" then
        return
    end

    CacheCurrentOutfit(identifier, outfitData)
end)

function DeleteCachedOutfit(identifier)
    local kvpKey = ("%s_%s"):format(GetCurrentResourceName(), identifier)

    if kvpKey then
        DeleteResourceKvp(kvpKey)
    end
end

function CacheCurrentOutfit(identifier, outfitData)
    local kvpKey = ("%s_%s"):format(GetCurrentResourceName(), identifier)

    if kvpKey then
        SetResourceKvp(kvpKey, json.encode(outfitData))
    end
end

function GetCachedOutfit(identifier)
    local kvpKey = ("%s_%s"):format(GetCurrentResourceName(), identifier)
    local storedValue = GetResourceKvpString(kvpKey)

    if storedValue then
        return json.decode(storedValue)
    end
end
