-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Utils = {}
function ConvertPlayerJobToStructure(data)
    data = type(data) == 'table' and data or {}
    local gradeData = type(data.grade) == 'table' and data.grade or {}

    if Config.Framework == Framework.ESX then
        return {
            group = data.name or 'none',
            grade = tonumber(data.grade) or tonumber(data.grade_level) or 0,
            grade_name = data.grade_name or data.gradeName or 'none',
        }
    elseif IS_QB[Config.Framework] then
        return {
            group = data.name or 'none',
            grade = tonumber(data.grade_level) or tonumber(gradeData.level) or tonumber(data.grade) or 0,
            grade_name = data.grade_name or gradeData.name or data.gradeName or 'none',
        }
    elseif Config.Framework == Framework.NDCore then
        return {
            group = data.name or 'none',
            grade = tonumber(data.rank) or tonumber(data.grade) or 0,
            grade_name = data.gradeName or data.grade_name or 'none',
        }
    end

    return {
        group = data.name or 'none',
        grade = tonumber(data.grade) or tonumber(data.grade_level) or 0,
        grade_name = data.grade_name or data.gradeName or 'none',
    }
end

Utils.Log = function(title, description, color)
    local embedData = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }
    local jsonData = json.encode({
        username = GetCurrentResourceName(),
        embeds = embedData
    })
    PerformHttpRequest(SWebhook, function(err, text, headers)
        if err ~= 200 then
        else
            print("Webhook message sent successfully!")
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end
Utils.IsPlayerNearAnotherPlayer = function(playerId, targetPlayerId, checkDist)
    local mePed = GetPlayerPed(playerId)
    local meCoords = GetEntityCoords(mePed)
    local targetPed = GetPlayerPed(targetPlayerId)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(meCoords - targetCoords)
    if not checkDist then
        checkDist = Config.CheckDistance
    end
    return distance <= checkDist
end
Utils.getClosestPlayers = function(playerIdInitiator, maxDist)
    local ped = GetPlayerPed(playerIdInitiator)
    local coords = GetEntityCoords(ped)
    local players = GetPlayers()
    local closestDistance = maxDist or 5.0
    local closestPlayerName = ''
    local closestPlayer = -1
    local retval = {}
    for i = 1, #players, 1 do
        local playerId = players[i]
        if (playerId ~= playerIdInitiator) and playerId ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(playerId))
            local distance = #(pos - coords)
            if distance <= closestDistance and playerId ~= playerIdInitiator then
                if distance <= 0.0 then
                else
                    closestPlayer = playerId
                    closestPlayerName = GetPlayerName(playerId)
                    closestDistance = distance
                    retval[#retval + 1] = {
                        playerId = closestPlayer,
                        name = GetPlayerName(playerId),
                        prefix = ('%s (%s)'):format(closestPlayerName, closestPlayer)
                    }
                end
            end
        end
    end
    return closestPlayer, closestDistance, retval
end
