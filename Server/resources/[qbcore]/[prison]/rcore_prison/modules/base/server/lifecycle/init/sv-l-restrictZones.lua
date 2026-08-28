RegisterNetEvent("rcore_prison:server:currentRestrictZone", function(zoneData)
    local playerSource = source

    if not SH or not SH.data or not zoneData then
        return
    end

    local zoneId = zoneData.id
    local restrictZones = SH.data.RestrictCommandZones
    local zoneDefinition = restrictZones and restrictZones[zoneId]

    if not zoneDefinition or not next(zoneDefinition) then
        return
    end

    local playerPed = GetPlayerPed(playerSource)
    local playerCoords = GetEntityCoords(playerPed)

    if not IsPointInPolygon(playerCoords, zoneDefinition.vertices) then
        return
    end

    RestrictZone = zoneData
end)

RegisterNetEvent("rcore_prison:server:clearCurrentRestrictZone", function()
    if RestrictZone and next(RestrictZone) then
        RestrictZone = {}
    end
end)
