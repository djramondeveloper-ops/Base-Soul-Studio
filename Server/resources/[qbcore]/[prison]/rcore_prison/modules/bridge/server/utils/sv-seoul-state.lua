-- Seoul Base compatibility: keep the legacy state bag "Prison" synchronized
-- without using characters.Prison as the sentence source.

local function setPrisonState(playerId, state)
    playerId = tonumber(playerId)
    if not playerId or playerId <= 0 or not GetPlayerName(playerId) then return end
    Player(playerId).state:set('Prison', state == true, true)
end

AddEventHandler('rcore_prison:server:heartbeat', function(actionType, data)
    if type(data) ~= 'table' or type(data.prisoner) ~= 'table' then return end
    local prisoner = data.prisoner
    local playerId = prisoner.source

    if (not playerId or tonumber(playerId) == nil) and prisoner.owner and Framework and Framework.object then
        local qbPlayer = Framework.object.Functions.GetPlayerByCitizenId(tostring(prisoner.owner))
        playerId = qbPlayer and qbPlayer.PlayerData and qbPlayer.PlayerData.source or nil
    end

    if actionType == 'PRISONER_NEW' or actionType == 'PRISONER_LOADED' then
        setPrisonState(playerId, true)
    elseif actionType == 'PRISONER_RELEASED' then
        setPrisonState(playerId, false)
    end
end)

CreateThread(function()
    Wait(5000)
    for _, id in ipairs(GetPlayers()) do
        local playerId = tonumber(id)
        local ok, jailed = pcall(function()
            return exports['rcore_prison']:IsPrisoner(playerId)
        end)
        if ok then setPrisonState(playerId, jailed == true) end
    end
end)
