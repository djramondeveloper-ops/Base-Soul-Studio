local spawnedTablets = {}
local tabletModel = Config.TabletModel or -933868115

function WaitForEntity(entity)
    local timeout = GetGameTimer() + 5000

    while GetGameTimer() < timeout do
        if DoesEntityExist(entity) then
            return true
        end

        Wait(0)
    end

    return DoesEntityExist(entity)
end

BaseCallback("spawnTablet", function(source, tabletId)
    if not Config.ServerSideSpawn then
        return infoprint(
            "error",
            "Possible cheater.",
            source .. " | " .. GetPlayerName(source),
            "tried to spawn a tablet, but Config.ServerSideSpawn is disabled."
        )
    end

    if spawnedTablets[tabletId] then
        return spawnedTablets[tabletId]
    end

    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed) - vector3(0.0, 0.0, 5.0)

    local entity = CreateObject(
        tabletModel,
        coords.x,
        coords.y,
        coords.z,
        true,
        true,
        false
    )

    if not WaitForEntity(entity) then
        return infoprint("warning", "Failed to create the tablet object (timed out).")
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)
    spawnedTablets[tabletId] = netId

    SetEntityIgnoreRequestControlFilter(entity, true)

    return netId
end)

RegisterNetEvent("tablet:failedControl", function()
    local src = source
    local tabletId = GetEquippedTablet(src)
    local netId = tabletId and spawnedTablets[tabletId] or nil

    if not Config.ServerSideSpawn or not tabletId or not netId then
        return
    end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and entity ~= 0 then
        DeleteEntity(entity)
    end

    spawnedTablets[tabletId] = nil
end)

RegisterNetEvent("tablet:setTabletObject", function(netId)
    local src = source
    local tabletId = GetEquippedTablet(src)

    if Config.ServerSideSpawn or not tabletId then
        return
    end

    spawnedTablets[tabletId] = netId
end)

RegisterNetEvent("tablet:deleteTabletObject", function()
    local src = source
    local tabletId = GetEquippedTablet(src)
    local netId = tabletId and spawnedTablets[tabletId] or nil

    if not tabletId or not netId then
        return
    end

    if Config.ServerSideSpawn then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity and entity ~= 0 then
            DeleteEntity(entity)
        end
    end

    spawnedTablets[tabletId] = nil
end)

OnTabletDisconnect(function(tabletId, src)
    local netId = spawnedTablets[tabletId]
    if not netId then
        return
    end

    debugprint(("Deleting %s (%i)'s tablet entity"):format(GetPlayerName(src), src))

    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and entity ~= 0 then
        DeleteEntity(entity)
    end

    spawnedTablets[tabletId] = nil
end)