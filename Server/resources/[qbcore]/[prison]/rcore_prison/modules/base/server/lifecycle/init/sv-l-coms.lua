COMS = {}

local usedComsModels = {}
local activeComsZones = {}
local comsModels = Config.COMS.Models

function COMS.GetZoneData()
    local zonesFile = LoadResourceFile(GetCurrentResourceName(), RESOURCE_FILES.ZONES)
    local decodedZones = json.decode(zonesFile)

    if not decodedZones then
        return nil
    end

    local zoneGroups = {}

    for zoneIndex, vertices in pairs(decodedZones) do
        zoneGroups[zoneIndex] = vertices
    end

    return zoneGroups
end

local comsCache = {
    models = {},
    vertGroups = COMS.GetZoneData() or {}
}

function COMS.GenerateRandomArea()
    local maxAttempts = 5
    local selectedZone = nil

    for _ = 1, maxAttempts do
        local randomZoneIndex = math.random(1, #comsCache.vertGroups)

        if not activeComsZones[randomZoneIndex] then
            selectedZone = randomZoneIndex
        end
    end

    return selectedZone
end

function GetRandomModel(usedModels)
    local attempts = 10

    while attempts > 0 do
        local randomModel = comsModels[math.random(1, #comsModels)]

        if not usedModels[randomModel] then
            return randomModel
        end

        attempts = attempts - 1
    end

    return comsModels[math.random(1, #comsModels)]
end

function GenerateRandomModelPreset(zoneIndex)
    local vertices = comsCache.vertGroups[zoneIndex]
    if not vertices then
        return false
    end

    for vertexIndex = 1, #vertices do
        local randomModel = GetRandomModel(usedComsModels)

        if not comsCache.models[vertexIndex] then
            comsCache.models[vertexIndex] = randomModel
        end
    end

    return true
end

local function isValidComsPlayer(playerSource, comsPlayer)
    if comsPlayer and next(comsPlayer) then
        return true
    end

    Framework.sendNotification(playerSource, _U("CS.NOT_CS_USER"), "error")
    dbg.critical("Player [%s] tried to finish peroll, when not on CS.", GetPlayerName(playerSource), playerSource)

    return false
end

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestPerollRelease", 0, 1, function(playerSource, isAllowed)
    if not isAllowed then
        return
    end

    local comsPlayer = COMSService.getPlayer(playerSource)
    if not isValidComsPlayer(playerSource, comsPlayer) then
        return
    end

    COMSService.ReleaseUser(playerSource)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestFinishPeroll", 0, 1, function(playerSource, isAllowed)
    if not isAllowed then
        return
    end

    local comsPlayer = COMSService.getPlayer(playerSource)
    if not isValidComsPlayer(playerSource, comsPlayer) then
        return
    end

    local zoneIndex = comsPlayer.zoneIdx

    if comsPlayer.state ~= COMS_STATES.RETURN then
        Framework.sendNotification(playerSource, _U("CS.NOT_IN_RETURN_STATE"), "error")
        return
    end

    local zoneData = COMSessionsService.GetZoneData(zoneIndex)
    if not zoneData then
        return
    end

    if zoneData.verticesDone >= zoneData.verticesTarget then
        comsPlayer.perollAmount = comsPlayer.perollAmount + 1

        db.DeleteCOMSZone(comsPlayer.charId, zoneIndex)
        db.UpdatePlayerComsPerollAmount(comsPlayer.charId, comsPlayer.perollAmount)

        COMSService.UpdatePlayerKeyByValue(playerSource, "zoneIdx", nil)
        COMSService.UpdatePlayerKeyByValue(playerSource, "state", COMS_STATES.IDLE)
        COMSService.UpdatePlayerKeyByValue(playerSource, "perollAmount", comsPlayer.perollAmount)

        StartClient(playerSource, "comsHeartbeat", comsPlayer)
        TriggerEvent("rcore_prison:server:comsFinishedForPlayer", source, comsPlayer.perollAmount)

        Framework.sendNotification(playerSource, _U("CS.PEROLL_FINISHED"), "success")
    end
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestComs", 0, 1, function(playerSource, isAllowed)
    if not isAllowed then
        return
    end

    local comsPlayer = COMSService.getPlayer(playerSource)
    if not comsPlayer then
        Framework.sendNotification(playerSource, _U("CS.NOT_CS_USER"), "error")
        dbg.debug("Player [%s] tried to request peroll while not being on CS.", GetPlayerName(playerSource), playerSource)
        return
    end

    if comsPlayer.state ~= COMS_STATES.IDLE then
        Framework.sendNotification(playerSource, _U("CS.NOT_IN_RETURN_STATE"), "error")
        return
    end

    dbg.debug("Player [%s] requested peroll.", GetPlayerName(playerSource), playerSource)

    local zoneIndex = COMS.GenerateRandomArea()
    if not zoneIndex or activeComsZones[zoneIndex] then
        return
    end

    if db.DoesIdExistInPool(zoneIndex) then
        Framework.sendNotification(playerSource, _U("CS.CANNOT_GENERATE_ZONE_ALREADY_ACTIVE"), "error")
        return
    end

    activeComsZones[zoneIndex] = true

    if not GenerateRandomModelPreset(zoneIndex) then
        return
    end

    dbg.debug("Loading community service for [%s] | ZONE [%s]", GetPlayerName(playerSource), zoneIndex)

    local vertices = comsCache.vertGroups[zoneIndex]
    local firstVertex = vertices and vertices[1]
    local firstVertexPos = firstVertex and firstVertex.pos

    if not firstVertexPos then
        return
    end

    local zonePosition = vec3(firstVertexPos.X, firstVertexPos.Y, firstVertexPos.Z)
    local registered = COMSessionsService.RegisterZone(zoneIndex, #vertices, 0)

    if not registered then
        return
    end

    dbg.debug(
        "Registering zone [%s] | [%s] for player named (%s)",
        zoneIndex,
        #vertices,
        GetPlayerName(playerSource),
        playerSource
    )

    db.RegisterCOMSZone(zoneIndex, #vertices, 0)
    db.UpdatePlayerComsZoneId(zoneIndex, comsPlayer.charId)

    COMSService.UpdatePlayerKeyByValue(playerSource, "zoneIdx", zoneIndex)
    COMSService.UpdatePlayerKeyByValue(playerSource, "state", COMS_STATES.SWEEPING)

    StartClient(playerSource, "comsHeartbeat", comsPlayer)

    SetTimeout(1000, function()
        StartClient(-1, "registerZone", {
            models = comsCache.models,
            zonePos = zonePosition,
            vertices = comsCache.vertGroups[zoneIndex],
            idx = zoneIndex,
            owner = playerSource
        })
    end)

    StartClient(playerSource, "SetWaypoint", zonePosition)
    StartClient(playerSource, "createSquaredArea", zonePosition)

    TriggerEvent("rcore_prison:server:comsStartedForPlayer", source, comsPlayer.perollAmount)
    Framework.sendNotification(playerSource, _U("CS.STARTED_PEROLL"), "success")
end)

function IsPlayerAtVertice(zoneIndex, vertexIndex, playerSource)
    local playerPed = GetPlayerPed(playerSource)
    local playerCoords = GetEntityCoords(playerPed)

    local vertexData = comsCache.vertGroups[zoneIndex] and comsCache.vertGroups[zoneIndex][vertexIndex]
    if not vertexData then
        return false
    end

    local vertexCoords = vec3(vertexData.pos.X, vertexData.pos.Y, vertexData.pos.Z)
    local distance = #(playerCoords - vertexCoords)

    return distance <= 1.5
end

RegisterNetEvent("rcore_prison:server:requestRemoveVertice", function(requestData)
    local playerSource = source
    local comsPlayer = COMSService.getPlayer(playerSource)

    if not comsPlayer then
        Framework.sendNotification(playerSource, _U("CS.NOT_CS_USER"), "error")
        return
    end

    local zoneIndex = comsPlayer.zoneIdx
    local requestedZoneId = requestData.zoneId
    local ownerSource = requestData.owner
    local vertexIndex = requestData.verticeId

    if zoneIndex ~= requestedZoneId then
        Framework.sendNotification(playerSource, _U("CS.NOT_IN_OWN_ZONE"), "error")
        return
    end

    if ownerSource ~= playerSource then
        Framework.sendNotification(playerSource, _U("CS.NOT_OWNER_OF_ZONE"), "error")
        return
    end

    if not IsPlayerAtVertice(zoneIndex, vertexIndex, playerSource) then
        Framework.sendNotification(playerSource, _U("CS.NOT_IN_SWEEPING_RANGE"), "error")
        return
    end

    if comsPlayer.state ~= COMS_STATES.SWEEPING then
        Framework.sendNotification(playerSource, _U("CS.NOT_IN_SWEEPING_STATE"), "error")
        return
    end

    local zoneData = COMSessionsService.GetZoneData(zoneIndex)
    if not zoneData then
        return
    end

    zoneData.verticesDone = zoneData.verticesDone + 1
    COMSessionsService.UpdateDataByKey(zoneIndex, "verticesDone", zoneData.verticesDone)

    if zoneData.verticesDone >= zoneData.verticesTarget then
        COMSService.UpdatePlayerKeyByValue(playerSource, "state", COMS_STATES.RETURN)

        local startLocation = Config.COMS.StartLocations
        local returnCoords = startLocation and startLocation.coords

        if returnCoords then
            StartClient(playerSource, "SetWaypoint", returnCoords)
        end

        StartClient(playerSource, "comsHeartbeat", comsPlayer)
        StartClient(playerSource, "RemoveBlipByType", "COMS")

        Framework.sendNotification(playerSource, _U("CS.AREA_CLEANED_RETURN"), "success")
    end

    StartClient(-1, "removeVertice", requestData)
end)

callback.register("rcore_prison:server:getAllComs", function(playerSource, _)
    if not Framework.canPerformJobCommand(playerSource) then
        return {}
    end

    local allComs = COMSService.GetAllCOMS()
    local comsCount = table.size(allComs)
    local comsList = {}

    for _, comsData in pairs(allComs) do
        table.insert(comsList, comsData)
    end

    return {
        hasMore = comsCount == 4,
        coms = comsList
    }
end)