--- @param maxDist number
---@param includePlayer boolean
function getClosestPlayers(maxDist, includePlayer)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local maxDistance = maxDist or 5.0

    local players = GetActivePlayers()
    local closestDistance = maxDistance
    local closestPlayer = -1

    local retval = {}
    local onlinePlayers = GlobalState['rcore_prison_servers_players'] or {}

    for i = 1, #players, 1 do
        local playerId = players[i]

        if (playerId ~= PlayerId() or includePlayer) and playerId ~= -1 and NetworkIsPlayerActive(playerId) then
            local targetPed = GetPlayerPed(playerId)

            if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
                local pos = GetEntityCoords(targetPed)
                local distance = #(pos - coords)

                if distance <= maxDistance then
                    local serverId = GetPlayerServerId(playerId)
                    local playerName = GetPlayerName(playerId) or tostring(serverId)
                    local prefix = ('# (%s) %s'):format(serverId, playerName)

                    if onlinePlayers[serverId] and onlinePlayers[serverId].name then
                        playerName = onlinePlayers[serverId].name
                        prefix = ('# (%s) %s'):format(serverId, playerName)
                    end

                    retval[#retval + 1] = {
                        playerId = serverId,
                        name = playerName,
                        prefix = prefix,
                        distance = distance
                    }

                    if distance < closestDistance then
                        closestPlayer = serverId
                        closestDistance = distance
                    end
                end
            end
        end
    end

    table.sort(retval, function(a, b)
        return a.distance < b.distance
    end)

    for i = 1, #retval do
        retval[i].distance = nil
    end

    return closestPlayer, closestDistance, retval
end

function KeyboardInput(Title, Text, MaxStringLenght)
    local result = nil

    AddTextEntry('RCORE_INPUT_ENTRY', Title)

    DisplayOnscreenKeyboard(1, "RCORE_INPUT_ENTRY", Title, Text, "", "", "", MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        result = GetOnscreenKeyboardResult()
    else
        Wait(0)
    end

    return result
end

RegisterNuiCallback('getClosestPlayers', function(data, cb)
    local maxDistance = Config and Config.Jail and Config.Jail.FetchClosestPlayer or 10.0
    local closestPlayer, closestDistance, closestPlayers = getClosestPlayers(maxDistance, false)
    cb(closestPlayers or {})
end)
