Blips = type(_G.Blips) == 'table' and _G.Blips or {
    Cache = {}
}
Blips.Cache = Blips.Cache or {}

function Blips.SetWaypoint(coords)
    if not coords then
        return dbg.debug("Invalid position for waypoint!")
    end

    SetNewWaypoint(coords.x, coords.y)
end

function Blips.RemoveByType(blipType)
    if not next(Blips.Cache) then
        return
    end

    for blipHandle, blipData in pairs(Blips.Cache) do
        if blipData.type == blipType then
            RemoveBlip(blipHandle)
            Blips.Cache[blipHandle] = nil
        end
    end
end

function Blips.RemoveById(zoneId)
    if not next(Blips.Cache) then
        return
    end

    for blipHandle, blipData in pairs(Blips.Cache) do
        if blipData.zoneId == zoneId then
            RemoveBlip(blipData.id)
            Blips.Cache[blipHandle] = nil
            dbg.debug("Blip removed: %s %s", zoneId, blipData.id)
        end
    end
end

function Blips.Create(blipData)
    if not blipData.sprite then
        return
    end

    local blipHandle = AddBlipForCoord(
        blipData.coords.x,
        blipData.coords.y,
        blipData.coords.z or 0.0
    )

    if not Blips.Cache[blipHandle] then
        Blips.Cache[blipHandle] = {
            id = blipHandle,
            zoneId = blipData.zoneId,
            type = blipData.type
        }
    end

    SetBlipDisplay(blipHandle, 4)
    SetBlipSprite(blipHandle, blipData.sprite)
    SetBlipScale(blipHandle, blipData.scale)
    SetBlipColour(blipHandle, blipData.color)
    SetTextFont(1)
    SetBlipAsShortRange(blipHandle, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blipData.name)
    EndTextCommandSetBlipName(blipHandle)
end

function Blips.CreateSquaredArea(coords, blipType)
    if not coords then
        return dbg.debug("Invalid position for squared area blip!")
    end

    local blipHandle = AddBlipForRadius(coords.x, coords.y, coords.z, 30.0)

    ShowHeadingIndicatorOnBlip(blipHandle, true)
    SetBlipSquaredRotation(blipHandle, 90.0)
    SetBlipRotation(blipHandle, math.ceil(GetEntityHeading(PlayerPedId())))
    SetBlipColour(blipHandle, 0)
    SetBlipAlpha(blipHandle, 80)

    if not Blips.Cache[blipHandle] then
        Blips.Cache[blipHandle] = {
            id = blipHandle,
            type = blipType or "COMS"
        }
    end
end