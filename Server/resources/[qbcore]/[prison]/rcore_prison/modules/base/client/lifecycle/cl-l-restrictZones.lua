local mapLoaded = false

AddEventHandler("rcore_prison:shared:internal:MapLoaded", function()
    mapLoaded = true
end)

local function waitForMapLoad()
    local attempts = 0

    repeat
        Wait(250)
        attempts = attempts + 1

        if attempts >= 50 then
            dbg.critical("Failed to load prison map in cl-l-restrictZones.lua")
            break
        end
    until mapLoaded
end

local function getClosestZoneData(playerCoords2D, zone)
    local closestDistance = math.huge
    local closestVertex = nil
    local zoneName = nil
    local zoneAccess = nil

    for _, vertex in ipairs(zone.vertices) do
        local distance = #(vec2(vertex.x, vertex.y) - playerCoords2D)

        if distance <= closestDistance then
            closestDistance = distance
            closestVertex = vertex
            zoneName = zone.name
            zoneAccess = zone.access
        end
    end

    return {
        closestVertex = closestVertex,
        distance = closestDistance,
        name = zoneName,
        access = zoneAccess,
    }
end

CreateThread(function()
    if not Config.RestrictZones then
        return
    end

    if not Config.RestrictZones.Enable then
        dbg.debug("Restrict zones are not enabled, not loading them")
        return
    end

    waitForMapLoad()

    if not SH.data then
        return
    end

    local restrictCommandZones = SH.data.RestrictCommandZones
    if not restrictCommandZones then
        dbg.critical("Failed to find any RestrictCommandZones for map: %s", Config.Map)
        return
    end

    while true do
        Wait(250)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerCoords2D = vec2(playerCoords.x, playerCoords.y)
        local checkDistance = (Config.RestrictZones and Config.RestrictZones.CheckDist) or 10

        for zoneId, zone in pairs(restrictCommandZones) do
            if zone.vertices then
                local zoneData = getClosestZoneData(playerCoords2D, zone)

                if zoneData and zoneData.distance < checkDistance then
                    local isInsideZone = IsPointInPolygon(playerCoords2D, zone.vertices)

                    if isInsideZone then
                        if not next(RestrictZone) then
                            RestrictZone = {
                                id = zoneId,
                                name = zoneData.name,
                                access = zoneData.access,
                            }

                            TriggerServerEvent("rcore_prison:server:currentRestrictZone", RestrictZone)
                        end
                    elseif next(RestrictZone) then
                        RestrictZone = {}
                        TriggerServerEvent("rcore_prison:server:clearCurrentRestrictZone")
                    end
                end
            end
        end
    end
end)
