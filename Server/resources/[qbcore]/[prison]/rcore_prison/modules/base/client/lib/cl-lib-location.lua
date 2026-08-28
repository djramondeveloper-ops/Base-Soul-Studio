local registerNetEvent = NetworkService.RegisterNetEvent

registerNetEvent("teleportUser", function(shouldTeleport, destination, teleportType)
    if not shouldTeleport then
        return
    end

    dbg.debug("Teleport session: Preparing teleport to area! 1/2 - reason: %s", teleportType)

    local ped = PlayerPedId()
    local startTime = GetGameTimer()

    FreezeEntityPosition(ped, true)

    if teleportType == TELEPORT_TYPES.TO_OUTSIDE_PRISON_RELEASED then
        SetEntityInvincible(ped, true)
    end

    while not HasCollisionLoadedAroundEntity(ped) do
        if GetGameTimer() - startTime >= 5000 then
            break
        end

        Wait(0)
    end

    SetEntityCoords(
        ped,
        destination.x,
        destination.y,
        destination.z,
        false,
        false,
        false,
        false
    )

    SetEntityHeading(ped, destination.w or 0.0)

    if teleportType == TELEPORT_TYPES.TO_YARD_NEW_PRISONER then
        dbg.debug(
            "Teleport session: Looks like teleport to yard new prisoner, loading some transition! %s",
            teleportType
        )
    end

    dbg.debug(
        "Teleport session: User was succesfully teleported to target area! 2/2 - reason: %s",
        teleportType
    )

    FreezeEntityPosition(ped, false)

    SetTimeout(1000, function()
        FreezeEntityPosition(ped, false)

        if teleportType == TELEPORT_TYPES.TO_OUTSIDE_PRISON_RELEASED then
            SetEntityInvincible(ped, false)
        end
    end)
end)