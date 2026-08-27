-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



DeathService = {}
DeathPlayers = {}
local States = {
    DEAD = true,
    ALIVE = false,
}
local GetLabelByState = {
    [true] = 'Death',
    [false] = 'Alive',
}
RegisterCommand("deadlist", function(source)
    if source == 0 then
        if DeathPlayers and next(DeathPlayers) then
            tprint(DeathPlayers)
        else
            dbg.info("There are not dead players on server!")
        end 
    end
end, false)
AddEventHandler('rcore_police:server:playerLoaded', function(playerId)
    if not playerId then
        return
    end
    if not IS_QB[Config.Framework] then return end
    local player = Framework.getPlayer(playerId)
    if not player then return end
    local metadata = player.PlayerData and player.PlayerData.metadata
    if not metadata then return end
    local isDead = metadata.isdead or metadata.inlaststand 
    if not isDead and Config.Framework == Framework.QBOX then
        isDead = metadata.health <= 0
    end
    if DeathService.GetPlayerState(playerId) then
        return
    end
    DeathService.SetPlayerState(playerId, isDead)
end)
AddEventHandler('rcore_police:server:playerUnloaded', function(playerId)
    local src = playerId
    if DeathPlayers[src] then
        DeathPlayers[src] = nil
    end
    local player = Player(src)
    player.state:set('rcorePoliceDead', false, true)
end)
RegisterNetEvent('rcore_police:server:sentPlayerDeath', function()
    local playerId = source
    if DeathService.GetPlayerState(playerId) then
        return
    end
    if DeathService.IsPlayerDead(playerId) then
        local state = DeathService.GetPlayerState(playerId)
        if state then
            return
        end
        DeathService.SetPlayerState(playerId, States.DEAD)
    end
end)
RegisterNetEvent('rcore_police:server:sentPlayerRespawned', function()
    local playerId = source
    if not DeathService.GetPlayerState(playerId) then
        return
    end
    DeathService.SetPlayerState(playerId, States.ALIVE)
end)
DeathService.IsPlayerDead = function(playerId)
    if not playerId then
        return false
    end
    local deathPed = GetPlayerPed(source)
    local deathHealth = GetEntityHealth(deathPed)
    local state = false
    if IS_QB[Config.Framework] and deathHealth >= 150.0 then
        state = true
    else
        state = deathHealth and deathHealth <= 0
    end
    return state
end
DeathService.GetPlayerState = function(playerId)
    local playerData = DeathPlayers[playerId]
    return playerData and playerData.state or false
end
DeathService.SetPlayerState = function(playerId, state)
    local label = GetLabelByState[state] or state
    if state == States.ALIVE then
        DeathPlayers[playerId] = {
            playerId = playerId,
            state = state,
        }
    else
        DeathPlayers[playerId] = {
            playerId = playerId,
            state = state,
            timestamp = os.time()
        }
    end
    local player = Player(playerId)
    player.state:set('rcorePoliceDead', state, true)
    dbg.debug('Player named %s (%s) death state setting to %s', GetPlayerName(playerId), playerId, label)
end
