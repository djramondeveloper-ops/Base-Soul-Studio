local function getPrisonBreakStorageSafe()
    if not Object or not Object.getStorage then
        return nil
    end

    return Object.getStorage(STORAGE_PRISON_BREAK)
end

local function ensurePrisonBreakSession()
    local storage = getPrisonBreakStorageSafe()
    if not storage then
        return nil
    end

    storage._prisonBreakSessions = storage._prisonBreakSessions or {}
    storage._prisonBreakSessions.walls = storage._prisonBreakSessions.walls or {}

    return storage._prisonBreakSessions
end

local function getPrisonBreakWalls()
    local prisonBreakData = SH and SH.data and SH.data.PrisonBreak
    local wallGroups = prisonBreakData and prisonBreakData.WALLS

    if type(wallGroups) ~= "table" then
        return nil
    end

    return wallGroups
end

local function getVec3(sourceCoords)
    if not sourceCoords then
        return nil
    end

    return vec3(sourceCoords.x, sourceCoords.y, sourceCoords.z)
end

local function getZoneId(layerName, wallIndex)
    return ("%s_%s"):format(layerName, wallIndex)
end

local function getWallByZoneId(zoneId)
    local wallGroups = getPrisonBreakWalls()
    if not wallGroups then
        return nil
    end

    for layerName, wallList in pairs(wallGroups) do
        if layerName ~= "ALL_WALLS" and type(wallList) == "table" then
            for wallIndex, wallData in ipairs(wallList) do
                if getZoneId(layerName, wallIndex) == zoneId then
                    return wallData, layerName, wallIndex
                end
            end
        end
    end

    return nil
end

local function getWallState(zoneId)
    local session = ensurePrisonBreakSession()
    if not session then
        return WALL_STATES.FULL_HEALTH
    end

    return session.walls[zoneId] or WALL_STATES.FULL_HEALTH
end

local function setWallState(zoneId, state)
    local session = ensurePrisonBreakSession()
    if not session then
        return false
    end

    session.walls[zoneId] = state
    return true
end

local function buildEscapeRouteData()
    local wallGroups = getPrisonBreakWalls()
    if not wallGroups then
        return nil
    end

    local session = ensurePrisonBreakSession()
    if not session then
        return nil
    end

    local routeData = {}

    for layerName, wallList in pairs(wallGroups) do
        if layerName ~= "ALL_WALLS" and type(wallList) == "table" then
            for wallIndex, wallData in ipairs(wallList) do
                local zoneId = getZoneId(layerName, wallIndex)
                local wallCoords = getVec3(wallData.coords)
                local interactCoords = getVec3(wallData.interactCoords) or wallCoords

                routeData[zoneId] = {
                    coords = {
                        x = interactCoords.x,
                        y = interactCoords.y,
                        z = interactCoords.z,
                    },
                    wallCoords = {
                        x = wallCoords.x,
                        y = wallCoords.y,
                        z = wallCoords.z,
                    },
                    interactCoords = {
                        x = interactCoords.x,
                        y = interactCoords.y,
                        z = interactCoords.z,
                    },
                    state = session.walls[zoneId] or WALL_STATES.FULL_HEALTH,
                    layerName = layerName,
                    zoneType = "WALLS",
                    breakType = wallData.zoneType,
                    players = {},
                }
            end
        end
    end

    return routeData
end

local function registerEscapeRoutesForPlayer(playerId)
    local routeData = buildEscapeRouteData()
    if not routeData then
        return false
    end

    TriggerClientEvent("rcore_prison:client:registerEscapeRoutes", playerId, routeData)
    return true
end

local function registerEscapeRoutesForAll()
    local routeData = buildEscapeRouteData()
    if not routeData then
        return false
    end

    TriggerClientEvent("rcore_prison:client:registerEscapeRoutes", -1, routeData)
    return true
end

local function sendError(playerId, message)
    if Framework and Framework.sendNotification then
        Framework.sendNotification(playerId, message, "error")
    end
end

local function getPrisonerBySourceSafe(playerId)
    local prisonerStorage = Object and Object.getStorage and Object.getStorage(STORAGE_PRISONER)
    if not prisonerStorage or not prisonerStorage.GetPrisonerBySource then
        return nil
    end

    return prisonerStorage.GetPrisonerBySource(playerId)
end

local function isActivePrisonBreakForPlayer(playerId)
    local prisoner = getPrisonerBySourceSafe(playerId)
    if not prisoner then
        return false, nil
    end

    local jailbreak = prisoner.jailbreak
    if not jailbreak or jailbreak.state ~= true then
        return false, prisoner
    end

    return true, prisoner
end

local function getPlayerCoords(playerId)
    local ped = GetPlayerPed(playerId)
    if not ped or ped <= 0 then
        return nil
    end

    return GetEntityCoords(ped)
end

local function isPlayerNearWall(playerId, wallData, maxDistance)
    maxDistance = maxDistance or 2.5

    local playerCoords = getPlayerCoords(playerId)
    if not playerCoords or not wallData then
        return false
    end

    local wallCoords = getVec3(wallData.coords)
    local interactCoords = getVec3(wallData.interactCoords)

    if wallCoords and #(playerCoords - wallCoords) <= maxDistance then
        return true
    end

    if interactCoords and #(playerCoords - interactCoords) <= maxDistance then
        return true
    end

    return false
end

local function hasRequiredEscapeItem(playerId)
    if not Config.Escape.NeedItem then
        return true
    end

    if not Inventory or not Inventory.hasItem then
        return false
    end

    local ok, hasItem = pcall(function()
        return Inventory.hasItem(playerId, Config.Escape.ItemName, 1)
    end)

    return ok and hasItem == true
end

local function broadcastWallUpdate(zoneId, state)
    StartClient(-1, "updateWall", zoneId, "setWallState", state, {})
end

local originalStartPrisonBreak = StartPrisonBreak
if type(originalStartPrisonBreak) == "function" then
    function StartPrisonBreak(playerId)
        local ok = originalStartPrisonBreak(playerId)
        if ok then
            local session = ensurePrisonBreakSession()
            if session then
                session.walls = {}
            end

            TriggerClientEvent("rcore_prison:client:ResetPrisonBreak", -1, false)

            SetTimeout(750, function()
                registerEscapeRoutesForAll()
            end)
        end

        return ok
    end
end

local originalSyncPrisonBreak = SyncPrisonBreak
if type(originalSyncPrisonBreak) == "function" then
    function SyncPrisonBreak(playerId, resetAlarm)
        local ok = originalSyncPrisonBreak(playerId, resetAlarm)
        if ok then
            ensurePrisonBreakSession()
            TriggerClientEvent("rcore_prison:client:ResetPrisonBreak", playerId, false)

            SetTimeout(750, function()
                registerEscapeRoutesForPlayer(playerId)
            end)
        end

        return ok
    end
end

local originalPrisonBreakReset = PrisonBreakReset
if type(originalPrisonBreakReset) == "function" then
    function PrisonBreakReset(playerId, resetAlarm)
        local session = ensurePrisonBreakSession()
        if session then
            session.walls = {}
        end

        return originalPrisonBreakReset(playerId, resetAlarm)
    end
end

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestEscapeInteract", 0, 1, function(playerSource, isAllowed, requestData)
    if not isAllowed or not Config.Escape.Enable then
        return
    end

    if type(requestData) ~= "table" then
        return
    end

    local isActive = isActivePrisonBreakForPlayer(playerSource)
    if not isActive then
        return sendError(playerSource, _U("PRISON_BREAK.IS_NOT_ACTIVE"))
    end

    local zoneId = requestData.zoneId
    local wallData, layerName = getWallByZoneId(zoneId)
    if not wallData or not layerName then
        return
    end

    if getWallState(zoneId) == WALL_STATES.DESTROYED then
        return sendError(playerSource, _U("PRISON_BREAK.INTERACT_NOT_DONE"))
    end

    if not isPlayerNearWall(playerSource, wallData, 3.0) then
        return
    end

    if not hasRequiredEscapeItem(playerSource) then
        return sendError(playerSource, _U("PRISON_BREAK.NO_ITEM"))
    end

    StartClient(playerSource, "startInteractTask", zoneId, "WALLS")
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:EscapeInteractFinishTask", 0, 1, function(playerSource, isAllowed, zoneType, zoneId)
    if not isAllowed or zoneType ~= "WALLS" then
        return
    end

    local isActive, prisoner = isActivePrisonBreakForPlayer(playerSource)
    if not isActive then
        return
    end

    local wallData, layerName = getWallByZoneId(zoneId)
    if not wallData or not layerName then
        return
    end

    if getWallState(zoneId) == WALL_STATES.DESTROYED then
        return
    end

    if not isPlayerNearWall(playerSource, wallData, 4.0) then
        return
    end

    setWallState(zoneId, WALL_STATES.DESTROYED)
    broadcastWallUpdate(zoneId, WALL_STATES.DESTROYED)

    if PrisonService and PrisonService.SendHeartbeat and prisoner then
        PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PLAYER_DESTROYED_WALL, {
            prisoner = prisoner,
            zoneId = zoneId,
            layerName = layerName,
        })
    end
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestRepairWall", 0, 1, function(playerSource, isAllowed, requestData)
    if not isAllowed or type(requestData) ~= "table" then
        return
    end

    local zoneId = requestData.zoneId
    local wallData = getWallByZoneId(zoneId)
    if not wallData then
        return
    end

    if getWallState(zoneId) ~= WALL_STATES.DESTROYED then
        return sendError(playerSource, _U("PRISON_BREAK.INTERACT_NOT_DONE"))
    end

    if not isPlayerNearWall(playerSource, wallData, 3.0) then
        return
    end

    StartClient(playerSource, "startInteractTask", zoneId, "REPAIR_WALL")

    SetTimeout((Config.Escape.RepairWallTime or 10) * 1000, function()
        if getWallState(zoneId) ~= WALL_STATES.DESTROYED then
            return
        end

        setWallState(zoneId, WALL_STATES.FULL_HEALTH)
        StartClient(-1, "syncRepairWall", getVec3(wallData.coords))
        broadcastWallUpdate(zoneId, WALL_STATES.FULL_HEALTH)
    end)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:registerEscapeExitZone", 0, 1, function(playerSource, isAllowed, requestData)
    if not isAllowed or type(requestData) ~= "table" then
        return
    end

    local zoneId = requestData.zoneId
    local wallData, layerName = getWallByZoneId(zoneId)
    if not wallData or layerName ~= "SECOND_LAYER" then
        return
    end

    if getWallState(zoneId) ~= WALL_STATES.DESTROYED then
        return
    end

    if not isPlayerNearWall(playerSource, wallData, 5.0) then
        return
    end

    local prisonerStorage = Object and Object.getStorage and Object.getStorage(STORAGE_PRISONER)
    local prisoner = prisonerStorage and prisonerStorage.GetPrisonerBySource and prisonerStorage.GetPrisonerBySource(playerSource)
    if not prisoner then
        return
    end

    if PrisonService and PrisonService.SetPrisonerEscapeState then
        PrisonService.SetPrisonerEscapeState(playerSource, true, {
            path = wallData.zoneType or "native",
            script = GetCurrentResourceName(),
        })
    end

    if PrisonService and PrisonService.SendHeartbeat then
        PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PLAYER_ESCAPE_FROM_PRISON, {
            prisoner = prisoner,
            zoneId = zoneId,
            layerName = layerName,
        })
    end

    if prisonerStorage and prisonerStorage.ReleasePrisoner then
        prisonerStorage.ReleasePrisoner(playerSource, false, true)
    end
end)
