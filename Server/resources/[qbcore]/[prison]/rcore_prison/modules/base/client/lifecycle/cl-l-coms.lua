local function onStartComsIntro(success, sessionData)
    if not success or not sessionData then
        return
    end

    local playerName = sessionData.name
    local payrollTarget = sessionData.perollTarget
    local payrollAmount = sessionData.perollAmount

    local introSteps = {
        {
            time = 4000,
            text = _U("CS.COMMUNITY_SERVICE_STARTED_PROLOG", playerName, payrollAmount, payrollTarget),
        },
        {
            time = 4000,
            text = _U("CS.COMMUNITY_SERVICE_FINISH_PROLOG"),
        },
    }

    for _, step in ipairs(introSteps) do
        Subtitles.Show(step.text)
        Wait(step.time + 300)
    end

    Subtitles.Hide()
end

NetworkService.RegisterNetEvent("StartComsIntro", onStartComsIntro)

local function onComsHeartbeat(success, sessionData)
    if not success then
        return
    end

    if sessionData then
        dbg.debug("Your coms session data were loaded!")
        COMSService.RegisterSession(sessionData)
        COMSService.RenderPerollTime()
    else
        dbg.debug("Your coms session data were deleted!")
        COMSService.ClearUserData()
    end
end

NetworkService.RegisterNetEvent("comsHeartbeat", onComsHeartbeat)

local function onUnregisterCOMSArea(serverId, zoneId)
    if not CWZones or not next(CWZones) then
        return
    end

    local zoneVertices = CWZones[zoneId]
    if not zoneVertices then
        return
    end

    for verticeId, vertexData in pairs(zoneVertices) do
        local decal = vertexData.decal
        local stashEntity = vertexData.entities and vertexData.entities.entity

        if stashEntity then
            DeleteStashOnGround(zoneId, verticeId, stashEntity, true)
        else
            dbg.critical(
                "Lifecycle - COMS: Failed to stash on ground, failed to find any entities! SERVER ID: %s ZONE-ID: %s",
                serverId,
                zoneId
            )
        end

        if decal and IsDecalAlive(decal) then
            RemoveDecal(decal)
        end

        if verticeId then
            SetTimeout(0, function()
                for _, worldZone in pairs(WorldCOMS) do
                    if worldZone.vertices and worldZone.id == zoneId then
                        worldZone.vertices[verticeId] = nil
                    end
                end
            end)
        end
    end
end

RegisterNetEvent("rcore_prison:client:UnregisterCOMSArea", onUnregisterCOMSArea)

local function onRemoveVertice(data)
    local zoneId = data.zoneId
    local verticeId = data.verticeId
    local zoneVertices = CWZones[zoneId]

    for _, worldZone in pairs(WorldCOMS) do
        if worldZone.vertices and worldZone.id == zoneId then
            worldZone.vertices[verticeId] = nil
        end
    end

    if not zoneVertices or not next(zoneVertices) then
        return
    end

    local vertexData = zoneVertices[verticeId]
    if not vertexData then
        return
    end

    local decal = vertexData.decal
    local stashEntity = vertexData.entities and vertexData.entities.entity

    if decal and IsDecalAlive(decal) then
        RemoveDecal(decal)
    end

    if stashEntity then
        DeleteStashOnGround(zoneId, verticeId, stashEntity)
    end
end

RegisterNetEvent("rcore_prison:client:removeVertice", onRemoveVertice)

local function onRegisterZone(zoneData)
    RegisterCOMSArea(zoneData)
end

RegisterNetEvent("rcore_prison:client:registerZone", onRegisterZone)

local function onGetCOMS(requestData, cb)
    local comsData = callback.await("rcore_prison:server:getAllComs", false, requestData)
    cb(comsData)
end

RegisterNuiCallback("getCOMS", onGetCOMS)