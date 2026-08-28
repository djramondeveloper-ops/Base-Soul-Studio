OccupiedChairs = {}

RegisterCommand("seats", function(playerSource)
    if playerSource == 0 then
        tprint(OccupiedChairs)
    end
end, false)

function IsSeatOccupiedByUser(seatIndex, serverId)
    local seatData = OccupiedChairs[seatIndex]
    return seatData ~= nil and seatData.user == serverId
end

function GetSeatIdxByServerId(serverId)
    for seatIndex, seatData in pairs(OccupiedChairs) do
        if seatData.user == serverId then
            return seatIndex
        end
    end

    return nil
end

local function getChairDefinition(modelName)
    if not modelName or not SH or not SH.data or not SH.data.Chairs then
        return nil
    end

    return SH.data.Chairs[joaat(modelName)]
end

EventLimiterService.RegisterNetEvent("rcore_prison:server:unregisterSeat", 0, 1, function(playerSource, isAllowed, seatPosIndex, chairModel)
    if not isAllowed or not chairModel then
        return
    end

    local chairDefinition = getChairDefinition(chairModel)
    if not chairDefinition then
        return
    end

    local seatDefinition = chairDefinition.positions and chairDefinition.positions[seatPosIndex]
    if not seatDefinition or not seatDefinition.offset then
        return
    end

    IsUserAtSeatPos(playerSource, seatDefinition.offset, function(isAtSeat, seatWorldPosition)
        if not isAtSeat then
            return
        end

        local seatIndex = GetIdxByPos(seatWorldPosition)

        if not OccupiedChairs[seatIndex] then
            seatIndex = GetSeatIdxByServerId(playerSource)
        end

        local occupiedSeat = seatIndex and OccupiedChairs[seatIndex]
        if not occupiedSeat then
            return
        end

        if not IsSeatOccupiedByUser(seatIndex, playerSource) then
            return
        end

        StartClient(playerSource, "startExit", occupiedSeat)

        SetTimeout(500, function()
            OccupiedChairs[seatIndex] = nil
            if Inventory and type(Inventory.HandleOpenState) == 'function' then
                Inventory.HandleOpenState(playerSource, false)
            end
        end)
    end)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:registerSeat", 0, 1, function(playerSource, isAllowed, seatData, seatType, seatPosIndex, chairModel)
    if not isAllowed or not chairModel then
        return
    end

    local chairDefinition = getChairDefinition(chairModel)
    if not chairDefinition then
        return
    end

    local seatDefinition = chairDefinition.positions and chairDefinition.positions[seatPosIndex]
    if not seatDefinition or not seatDefinition.offset then
        return
    end

    IsUserAtSeatPos(playerSource, seatDefinition.offset, function(isAtSeat, seatWorldPosition)
        if not isAtSeat then
            return
        end

        local seatIndex = GetIdxByPos(seatWorldPosition)
        local occupiedSeat = OccupiedChairs[seatIndex]

        if occupiedSeat and occupiedSeat.seatPosIdx == seatPosIndex then
            Framework.sendNotification(playerSource, _U("CHAIRS.SOMEBODY_IS_SITTING"), "error")
            return
        end

        RegisterSeatPos(
            playerSource,
            seatPosIndex,
            chairModel,
            seatType,
            seatData,
            chairDefinition,
            seatWorldPosition
        )
    end)
end)

function GetIdxByPos(position)
    local roundedX = math.ceil(position.x / 2) * 2 - 1
    local roundedY = math.ceil(position.y / 2) * 2 - 1
    local key = tostring(roundedX) .. tostring(roundedY)
    key = key:gsub("%-", "")

    return tonumber(key)
end

function RegisterSeatPos(playerSource, seatPosIndex, chairModel, seatType, seatData, chairDefinition, seatWorldPosition)
    local seatIndex = GetIdxByPos(seatWorldPosition)

    if not OccupiedChairs[seatIndex] then
        OccupiedChairs[seatIndex] = {
            user = playerSource,
            name = GetPlayerName(playerSource),
            model = chairModel,
            seatType = seatType,
            seatPosIdx = seatPosIndex
        }
    end

    if Inventory and type(Inventory.HandleOpenState) == 'function' then
        Inventory.HandleOpenState(playerSource, true)
    end

    local message
    if seatType == "lay" then
        message = _U("CHAIRS.YOU_ARE_NOW_LAYING")
    else
        message = _U("CHAIRS.YOU_ARE_NOW_SITTING")
    end

    Framework.sendNotification(playerSource, message, "success")
    StartClient(playerSource, "startSit", seatType, seatData, chairDefinition, seatPosIndex)
end

function IsUserAtSeatPos(playerSource, offset, callback)
    local ped = GetPlayerPed(playerSource)
    local playerCoords = GetEntityCoords(ped)
    local targetCoords = playerCoords + offset
    local distance = #(playerCoords - targetCoords)

    if distance <= 2.0 then
        callback(true, targetCoords)
    else
        callback(false)
    end
end

CreateThread(function()
    if not Config.Chairs.HealLayingPlayers then
        return
    end

    dbg.debug("Starting healing player")

    while true do
        Wait(0)

        if next(OccupiedChairs) then
            for _, seatData in pairs(OccupiedChairs) do
                if seatData.seatType == "lay" then
                    local playerSource = seatData.user
                    local ped = GetPlayerPed(playerSource)

                    if ped > 0 then
                        local health = GetEntityHealth(ped)
                        local healModifier = Config.Chairs.HealModifier or 1

                        StartClient(playerSource, "healPlayer", health + healModifier)
                    end
                end
            end
        end

        Wait(Config.Chairs.HealLayingPlayersTimeCycle * 60 * 1000)
    end
end)