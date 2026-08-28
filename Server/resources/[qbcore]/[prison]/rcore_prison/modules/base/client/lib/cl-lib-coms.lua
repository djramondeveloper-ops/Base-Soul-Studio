local hasNearbyWorldCOMS = false

WorldCOMS = {}
NearWorldCOMS = {}
CWZones = {}

local currentCOMSSession = {
    zoneId = nil,
    verticeId = nil,
    owner = nil,
}

local isSweeping = false
local polygonContainsNative = glm.polygon.contains

local trashSizeOverrides = {
    prop_rub_binbag_06 = 2.5,
    prop_rub_cardpile_06 = 2.5,
    prop_rub_litter_03c = 4.0,
}

local zoneFactory = {}

local function polygonContains(zone, coords)
    local thickness = zone.thickness or 0.0
    return polygonContainsNative(zone.polygon, coords, thickness / 4)
end

local function buildPolygonZone(data)
    if not CWZones[data.zoneIdx] then
        CWZones[data.zoneIdx] = {}
    end

    local zoneVertices = CWZones[data.zoneIdx]
    data.idx = #zoneVertices + 1
    data.size = data.size or 2
    data.prefechPoints = data.prefechPoints or {}

    for index, point in pairs(data.points) do
        if not data.prefechPoints[index] then
            data.prefechPoints[index] = vec3(point.X, point.Y, point.Z)
        end
    end

    data.points = data.prefechPoints
    data.polygon = glm.polygon.new(data.points)
    data.coords = data.polygon:centroid()
    data.center = vec3(data.pos.X, data.pos.Y, data.pos.Z)
    data.contains = polygonContains

    zoneVertices[data.idx] = data

    if data.spawnTrashEntities then
        local storedZone = CWZones[data.zoneIdx][data.idx]

        if not storedZone.entities then
            local modelName = data.modelsPreset and data.modelsPreset[data.idx]
            if not modelName then
                return
            end

            local modelHash = joaat(modelName)
            if IsModelValid(modelHash) then
                LoadModel(modelHash)

                local entity = CreateObject(
                    modelHash,
                    data.center.x,
                    data.center.y,
                    data.center.z,
                    false,
                    false,
                    false
                )

                local entityCoords = GetEntityCoords(entity)
                local archetypeName = GetEntityArchetypeName(entity)

                SetEntityCoords(entity, entityCoords.x, entityCoords.y, entityCoords.z)

                if trashSizeOverrides[archetypeName] then
                    data.size = trashSizeOverrides[archetypeName]
                end

                Wait(0)
                PlaceObjectOnGroundProperly(entity)
                FreezeEntityPosition(entity, true)
                SetEntityCollision(entity, false, true)

                if DoesEntityExist(entity) then
                    storedZone.entities = {
                        entity = entity,
                        model = modelHash,
                    }

                    if MyServerId == data.owner then
                        SetEntityDrawOutline(entity, true)
                        SetEntityDrawOutlineShader(1)

                        local outline = Config.COMS.Outline
                        SetEntityDrawOutlineColor(
                            outline.color.x,
                            outline.color.y,
                            outline.color.z,
                            outline.opacity
                        )
                    end
                end
            end
        end
    end

    if data.decals then
        local storedZone = CWZones[data.zoneIdx][data.idx]

        if not storedZone.decal then
            storedZone.decal = AddDecal(
                4421,
                data.center.x,
                data.center.y,
                data.center.z,
                0.0,
                0.0,
                -1.0,
                GetNormalizedVector(0.0, 1.0, 0.0),
                8.0,
                8.0,
                0.1,
                0.0,
                0.0,
                0.5,
                -1.0,
                0,
                0,
                0
            )
        end
    end

    Wait(0)
    return data
end

zoneFactory.poly = buildPolygonZone
zones = zoneFactory
contains = polygonContains

CreateThread(function()
    local getPlayerPed = PlayerPedId
    local getCoords = GetEntityCoords

    while true do
        Wait(1000)

        hasNearbyWorldCOMS = false

        local playerPed = getPlayerPed()
        local playerCoords = getCoords(playerPed)

        for index, com in pairs(WorldCOMS) do
            local distance = #(playerCoords - com.position)
            local renderDistance = (NearWorldCOMS[com.id] and NearWorldCOMS[com.id].renderDistance)
                or Config.COMS.RenderDistance

            if distance < renderDistance then
                NearWorldCOMS[com.id] = com
                hasNearbyWorldCOMS = true
            else
                com.rendering = false
                WorldCOMS[index] = com
                NearWorldCOMS[com.id] = nil
            end
        end
    end
end, "cl-lib-coms code name: Phoenix")

CreateThread(function()
    local getPlayerPed = PlayerPedId
    local getCoords = GetEntityCoords
    local sleep = 0

    while true do
        Wait(sleep)

        if not hasNearbyWorldCOMS then
            sleep = 250
            Wait(300)
        else
            sleep = 0
        end

        local playerPed = getPlayerPed()
        local playerCoords = getCoords(playerPed)

        for _, com in pairs(NearWorldCOMS) do
            local distance = #(playerCoords - com.position)
            local wallState = com.getWallState()

            if wallState then
                local syncDistance = Config.Escape.WallLodSyncDistance

                if distance < syncDistance then
                    if not com.syncWallState then
                        local zonePlayers = com.getZonePlayers and com.getZonePlayers()

                        if zonePlayers and next(zonePlayers) then
                            local currentPlayerState = zonePlayers[tostring(MyServerId)]

                            dbg.debug(
                                "[LOD - Walls] 1. Loading state cache for current user with state [%s]!",
                                currentPlayerState
                            )

                            if currentPlayerState ~= true then
                                dbg.debug("[LOD - Walls] 2. Loading destroyed wall since player come into area!")
                                CustomModelSwap(com.position, WALL_STATES.DESTROYED)
                            end

                            com.syncWallState = true
                        end
                    end
                elseif distance > syncDistance then
                    if com.syncWallState then
                        local zonePlayers = com.getZonePlayers and com.getZonePlayers()

                        if zonePlayers and next(zonePlayers) then
                            local currentPlayerState = zonePlayers[tostring(MyServerId)]

                            if currentPlayerState ~= nil then
                                dbg.debug("[LOD - Walls] Unloading destroyed wall since player left area!")
                                com.setZonePlayerState(MyServerId, false)
                                CustomModelSwap(com.position, WALL_STATES.FULL_HEALTH)
                                com.syncWallState = false
                            end
                        else
                            CustomModelSwap(com.position, WALL_STATES.FULL_HEALTH)
                            com.syncWallState = false
                        end
                    end
                end
            end
        end
    end
end, "cl-lib-coms code name: Alfa")

CreateThread(function()
    local getPlayerPed = PlayerPedId
    local getCoords = GetEntityCoords
    local sleep = 0

    while true do
        Wait(sleep)

        if not hasNearbyWorldCOMS then
            sleep = 700
            Wait(300)
        else
            sleep = 0
        end

        local playerPed = getPlayerPed()
        local playerCoords = getCoords(playerPed)

        for comId, com in pairs(NearWorldCOMS) do
            local distance = #(playerCoords - com.position)

            if distance and com and distance <= com.renderDistance and not com.destroyed and not com.stopRendering then
                com.rendering = true

                if distance <= com.inRadius then
                    if com.isIn == false then
                        if com.onEnter ~= nil then
                            pcall(com.onEnter)
                        end
                    end

                    com.isIn = true
                else
                    if com.isIn then
                        if com.onLeave ~= nil then
                            pcall(com.onLeave)
                        end

                        com.isIn = false
                    end
                end

                if com.isIn and com.id and CWZones[com.id] then
                    for verticeId, polygonZone in pairs(CWZones[com.id]) do
                        local insidePolygon = polygonContainsNative(
                            polygonZone.polygon,
                            playerCoords,
                            (polygonZone.size or 0.0) / 2
                        )

                        if insidePolygon then
                            if not polygonZone.isInsidePolygon and com.onEnterPolygon ~= nil then
                                polygonZone.isInsidePolygon = true
                                com.verticeId = verticeId
                                pcall(com.onEnterPolygon)
                            end
                        else
                            if polygonZone.isInsidePolygon and com.onLeavePolygon ~= nil then
                                polygonZone.isInsidePolygon = false
                                pcall(com.onLeavePolygon)
                            end
                        end
                    end
                end
            else
                com.rendering = false
                sleep = 300
            end

            NearWorldCOMS[comId] = com
        end
    end
end, "cl-lib-coms code name: Beta")

CreateThread(function()
    local drawMarker = DrawMarker
    local sleep = 0

    while true do
        Wait(sleep)

        if not hasNearbyWorldCOMS then
            Wait(1000)
        end

        for _, com in pairs(NearWorldCOMS) do
            if com.stopRendering == false or not com.stopRendering then
                if com.rendering and not com.destroyed and com.renderMarker then
                    drawMarker(
                        com.type,
                        com.position.x,
                        com.position.y,
                        com.position.z,
                        com.dir.x,
                        com.dir.y,
                        com.dir.z,
                        com.rot.x,
                        com.rot.y,
                        com.rot.z,
                        com.scale.x,
                        com.scale.y,
                        com.scale.z,
                        com.getRed(),
                        com.getGreen(),
                        com.getBlue(),
                        com.getAlpha(),
                        false,
                        com.faceCamera,
                        2,
                        com.rotation,
                        nil,
                        nil,
                        false
                    )
                end
            end
        end
    end
end, "cl-lib-coms code name: Bravo")

function CreateCOMSZone()
    local zone = {}

    zone.id = table.size(WorldCOMS) + 1
    zone.type = 28
    zone.firstUpdate = false
    zone.resource = GetCurrentResourceName()
    zone.renderDistance = Config.COMS.RenderDistance
    zone.position = vector3(0, 0, 0)
    zone.dir = vector3(0, 0, 0)
    zone.rot = vector3(0, 0, 0)
    zone.scale = vec3(1, 1, 1)
    zone.rotation = false
    zone.faceCamera = false
    zone.rendering = false
    zone.stopRendering = false
    zone.owner = nil
    zone.isBusy = false
    zone.onEnter = nil
    zone.onLeave = nil
    zone.onEnterPolygon = nil
    zone.onLeavePolygon = nil
    zone.onSync = nil
    zone.isIn = false
    zone.onlyVehicle = nil
    zone.areaDebug = false
    zone.models = nil
    zone.actionState = false
    zone.renderMarker = false
    zone.reportState = false
    zone.inRadius = Config.COMS.InRadius
    zone.syncData = {}
    zone.interactHelpKeys = {}
    zone.playerJob = nil
    zone.breakType = nil
    zone.layerName = nil
    zone.wallState = WALL_STATES.FULL_HEALTH
    zone.color = {
        r = 240,
        g = 200,
        b = 80,
        a = 160,
    }
    zone.zonePlayers = {}
    zone.zoneType = nil
    zone.properties = nil
    zone.syncWallState = false
    zone.destroyed = false
    zone.vertices = nil
    zone.verticeId = nil

    function zone.setOnlyVehicle(value)
        zone.onlyVehicle = value
    end

    function zone.setId(value)
        zone.id = value
        zone.update()
    end

    function zone.setBreakType(value)
        zone.breakType = value
    end

    function zone.getBreakType()
        return zone.breakType
    end

    function zone.getId()
        return zone.id
    end

    function zone.setActionState(value)
        zone.actionState = value
    end

    function zone.getActionState()
        return zone.actionState
    end

    function zone.setType(value)
        zone.type = value
        zone.update()
    end

    function zone.getType()
        return zone.type
    end

    function zone.setVertices(value)
        zone.vertices = value
    end

    function zone.setInteractOwner(value)
        zone.owner = value
    end

    function zone.unloadVertice(verticeId)
        if zone.vertices and zone.vertices[verticeId] then
            zone.vertices[verticeId] = nil
        end
    end

    function zone.unloadArea(zoneId)
        local storedZone = CWZones[zoneId]

        if storedZone and next(storedZone) then
            for verticeId, polygonZone in pairs(storedZone) do
                local decal = polygonZone.decal
                local entityData = polygonZone.entities

                if entityData and entityData.entity then
                    SetTimeout(0, function()
                        DeleteStashOnGround(zoneId, verticeId, entityData.entity, true)
                    end)
                else
                    dbg.critical("COMS: Failed to found entities for zone with ID: %s", zoneId)
                end

                if decal and IsDecalAlive(decal) then
                    RemoveDecal(decal)
                end

                zone.unloadVertice(verticeId)
            end
        end

        Wait(1000)
        CWZones[zoneId] = nil
    end

    function zone.setModels(value)
        zone.models = value
    end

    function zone.setRenderMarker(value)
        zone.renderMarker = value
    end

    function zone.setWallState(value)
        zone.wallState = value
    end

    function zone.setLayerName(value)
        zone.layerName = value
    end

    function zone.getLayerName()
        return zone.layerName
    end

    function zone.getZonePlayers()
        return zone.zonePlayers
    end

    function zone.setZonePlayerState(playerId, state)
        if not playerId then
            return
        end

        zone.zonePlayers[tostring(playerId)] = state
    end

    function zone.setZonePlayers(value)
        zone.zonePlayers = value or {}
    end

    function zone.getWallState()
        return zone.wallState
    end

    function zone.getReportState()
        return zone.reportState
    end

    function zone.setReportState(value)
        zone.reportState = value
    end

    function zone.setPlayerCurrentJob(value)
        zone.playerJob = value
    end

    function zone.getPlayerCurrentJob()
        return zone.playerJob
    end

    function zone.setZoneType(value)
        zone.zoneType = value
    end

    function zone.getZoneType()
        return zone.zoneType
    end

    function zone.setInteractHelpKeys(value)
        zone.interactHelpKeys = value
    end

    function zone.getInteractHelpKeys()
        return zone.interactHelpKeys
    end

    function zone.setPosition(value)
        zone.position = value
        zone.update()
        return zone
    end

    function zone.getPosition()
        return zone.position
    end

    function zone.setDir(value)
        zone.dir = value
        zone.update()
    end

    function zone.getDir()
        return zone.dir
    end

    function zone.setScale(value)
        zone.scale = value
        zone.update()
    end

    function zone.getScale()
        return zone.scale
    end

    function zone.setColor(value)
        zone.color = value
        zone.update()
    end

    function zone.getColor()
        return zone.color
    end

    function zone.setAlpha(value)
        zone.color.a = value
        zone.update()
    end

    function zone.getAlpha()
        if zone.isBusy then
            return 125
        end

        return zone.color.a
    end

    function zone.setRed(value)
        zone.color.r = value
        zone.update()
    end

    function zone.getRed()
        if zone.isBusy then
            return 255
        end

        return zone.color.r
    end

    function zone.setGreen(value)
        zone.color.g = value
        zone.update()
    end

    function zone.getGreen()
        if zone.isBusy then
            return 0
        end

        return zone.color.g
    end

    function zone.setBlue(value)
        zone.color.b = value
        zone.update()
    end

    function zone.getBlue()
        if zone.isBusy then
            return 0
        end

        return zone.color.b
    end

    function zone.setRenderDistance(value)
        zone.renderDistance = value
        zone.update()
        return zone
    end

    function zone.getRenderDistance()
        return zone.renderDistance
    end

    function zone.setFaceCamera(value)
        zone.faceCamera = value
        zone.update()
    end

    function zone.getFaceCamera()
        return zone.faceCamera
    end

    function zone.setRotation(value)
        zone.rotation = value
        zone.update()
    end

    function zone.getRotation()
        return zone.rotation
    end

    function zone.setInRadius(value)
        zone.inRadius = value
        zone.update()
    end

    function zone.getInRadius()
        return zone.inRadius
    end

    function zone.render()
        zone.stopRendering = false
        zone.rendering = true
        zone.firstUpdate = false
        zone.update()
        return zone
    end

    function zone.stopRender()
        zone.stopRendering = true
        zone.rendering = false
        zone.update()
    end

    function zone.destroy()
        zone.stopRendering = true
        zone.rendering = false
        zone.destroyed = true
        zone.update(true)
    end

    function zone.SetBusyStatus(value)
        zone.isBusy = value
        zone.update()
    end

    function zone.IsMarkerBusy()
        return zone.isBusy
    end

    function zone.isRendering()
        return zone.rendering
    end

    function zone.setSyncData(value)
        zone.syncData = value
        zone.update()
    end

    function zone.setBannerPreview(value)
        zone.properties = value
        zone.update()
    end

    function zone.setAreaDebug(enabled, largeDebug, customScale)
        zone.areaDebug = enabled

        if largeDebug then
            zone.setType(28)
        else
            zone.setType(1)
        end

        if largeDebug then
            zone.scale = vector3(10, 10, 10)
        elseif customScale then
            zone.scale = vector3(customScale, customScale, customScale)
        else
            local tolerance = Config.LOD.RENDER_DISTANCE_TOLERANCE
            zone.scale = vector3(tolerance, tolerance, tolerance)
        end

        zone.update()
    end

    function zone.on(eventName, callback)
        local lowered = string.lower(eventName)

        if lowered == "enter" then
            zone.onEnter = callback
        elseif lowered == "leave" then
            zone.onLeave = callback
        elseif lowered == "sync" then
            zone.onSync = callback
        elseif eventName == "enterPolygon" then
            zone.onEnterPolygon = callback
        elseif eventName == "leavePolygon" then
            zone.onLeavePolygon = callback
        end

        zone.update()
    end

    function zone.update(removeCompletely)
        if zone.firstUpdate then
            return
        end

        if removeCompletely then
            for nearId, nearCom in pairs(NearWorldCOMS) do
                if nearCom.getId() == zone.getId() then
                    NearWorldCOMS[nearId] = nil
                end
            end

            for worldId, worldCom in pairs(WorldCOMS) do
                if worldCom.getId() == zone.getId() then
                    WorldCOMS[worldId] = nil
                end
            end

            return
        end

        local updated = false

        for worldId, worldCom in pairs(WorldCOMS) do
            if worldCom.getId() == zone.getId() then
                WorldCOMS[worldId] = zone
                updated = true
            end
        end

        if not updated then
            table.insert(WorldCOMS, zone)
        end
    end

    table.insert(WorldCOMS, zone)
    return zone
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, com in pairs(WorldCOMS) do
        if com.resource == resourceName then
            com.unloadArea(com.id)
            com.destroy()
        end
    end

    if Entity.cache and next(Entity.cache) then
        for _, entityData in pairs(Entity.cache) do
            local entity = entityData.entity

            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
    end
end)

function CleanZone(coords, radius)
    local cleanRadius = radius or 1

    ClearAreaOfObjects(coords.x, coords.y, coords.z, cleanRadius, 0)
    RemoveDecalsInRange(coords.x, coords.y, coords.z, cleanRadius)
end

function RegisterZoneCOMS(zoneData, modelPreset, zoneIdx, ownerId)
    if not zoneData or table.size(zoneData) <= 0 then
        return dbg.critical("Cannot register COMS zone, no data provided!!!")
    end

    for _, zoneEntry in pairs(zoneData) do
        zones.poly({
            pos = zoneEntry.pos,
            points = zoneEntry.vertices,
            modelsPreset = modelPreset,
            spawnTrashEntities = true,
            decals = true,
            size = 4.0,
            zoneIdx = zoneIdx,
            owner = ownerId,
        })

        Wait(100)
    end
end

function GetNormalizedVector(x, y, z)
    local length = math.sqrt(x * x + y * y + z * z)

    if length == 0.0 then
        return vector3(0.0, 0.0, 0.0)
    end

    local inverseLength = 1.0 / length
    return vector3(x * inverseLength, y * inverseLength, z * inverseLength)
end

function GetClosestPolygon()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not currentCOMSSession.zoneId then
        return nil
    end

    local zoneVertices = CWZones[currentCOMSSession.zoneId]
    local closestVerticeId = nil

    for verticeId, polygonZone in pairs(zoneVertices) do
        local distance = #(polygonZone.coords - playerCoords)

        if not polygonZone.state and distance <= 1.5 then
            closestVerticeId = verticeId
            break
        end
    end

    return closestVerticeId
end

function StartInteract()
    if not next(currentCOMSSession) then
        return
    end

    if currentCOMSSession.owner and currentCOMSSession.owner ~= MyServerId then
        return dbg.debug("Cannot start interaction, not owner")
    end

    if IsInVehicle() then
        return dbg.debug("Cannot start interaction while in vehicle")
    end

    if isSweeping then
        return dbg.debug("Cannot start interaction, already sweeping")
    end

    HelpKeys.Hide()

    local closestPolygon = GetClosestPolygon()
    if closestPolygon ~= currentCOMSSession.verticeId then
        currentCOMSSession.verticeId = closestPolygon
    end

    if not currentCOMSSession.verticeId then
        return
    end

    if not closestPolygon then
        isSweeping = false
        return Framework.sendNotification("You are not near any trash", "error")
    end

    isSweeping = true

    local broomModel = "prop_tool_broom"
    local playerPed = PlayerPedId()
    local offset = vec3(0.0, 0.0, -5.0)

    if Config.COMS.DisableGameControls then
        FreezePlayer(PlayerId(), true)
    end

    FreezeEntityPosition(playerPed, true)

    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, offset.x, offset.y, offset.z)
    local broomObject = CreateObject(
        joaat(broomModel),
        spawnCoords.x,
        spawnCoords.y,
        spawnCoords.z,
        true,
        false,
        false
    )

    LoadAnim("amb@world_human_janitor@male@idle_a")

    TaskPlayAnim(
        playerPed,
        "amb@world_human_janitor@male@idle_a",
        "idle_a",
        8.0,
        -8.0,
        -1,
        0,
        0,
        false,
        false,
        false
    )

    AttachEntityToEntity(
        broomObject,
        playerPed,
        GetPedBoneIndex(playerPed, 28422),
        -0.005,
        0.0,
        0.0,
        360.0,
        360.0,
        0.0,
        true,
        true,
        false,
        true,
        false,
        true
    )

    SetTimeout(Config.COMS.CleaningAnimTime, function()
        if Config.COMS.DisableGameControls then
            FreezePlayer(PlayerId(), false)
        end

        FreezeEntityPosition(playerPed, false)
        DetachEntity(broomObject, true, true)
        DeleteEntity(broomObject)
        ClearPedTasks(playerPed)

        isSweeping = false

        TriggerServerEvent("rcore_prison:server:requestRemoveVertice", currentCOMSSession)
    end)
end

function IsInVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)
    return vehicle > 0
end

function FreezePlayer(playerId, state)
    SetPlayerControl(playerId, not state, false)
end

function DeleteStashOnGround(zoneId, verticeId, entity, instantDelete)
    if CWZones[zoneId] and CWZones[zoneId][verticeId] then
        CWZones[zoneId][verticeId] = nil
    end

    if instantDelete then
        SetEntityDrawOutline(entity, false)
        DeleteEntity(entity)
        return
    end

    local alpha = 255

    while alpha >= 0 do
        Wait(10)
        SetEntityAlpha(entity, alpha, false)
        alpha = alpha - 12
    end

    Wait(5000)
    SetEntityDrawOutline(entity, false)
    DeleteEntity(entity)
end

function LoadModel(modelHash)
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
end

RegisterCommand("rcore_prison_coms_debug", function()
    if next(currentCOMSSession) then
        local playerPed = PlayerPedId()
        currentCOMSSession.Coords = GetEntityCoords(playerPed)
        tprint(currentCOMSSession)
    else
        dbg.debug("COMS: Failed to find any active player current session!")
    end
end)

function RegisterCOMSArea(data)
    local zoneId = data.idx
    local comZone = CreateCOMSZone()

    comZone.setPosition(data.zonePos)
    comZone.setModels(data.models)
    comZone.setVertices(data.vertices)
    comZone.setId(zoneId)
    comZone.setInteractOwner(data.owner)

    if data.owner == MyServerId then
        currentCOMSSession.owner = data.owner
    end

    comZone.render()

    comZone.on("enterPolygon", function()
        if comZone.owner == MyServerId then
            HelpKeys.Show({
                {
                    keyName = "E",
                    label = _U("START_CLEANING_LABEL"),
                },
            })

            currentCOMSSession.verticeId = comZone.verticeId
        end
    end)

    comZone.on("leavePolygon", function()
        if comZone.owner == MyServerId then
            HelpKeys.Hide()
            currentCOMSSession.verticeId = nil
        end
    end)

    comZone.on("leave", function()
        if comZone.owner == MyServerId then
            currentCOMSSession.zoneId = nil
        end

        dbg.debug("You left COMS active area, unloading.", zoneId)

        if Config.COMS.Area and Config.COMS.Area.EnableDynamicUnload then
            comZone.unloadArea(zoneId)
        end
    end)

    comZone.on("enter", function()
        if comZone.owner == MyServerId then
            currentCOMSSession.zoneId = zoneId
        end

        dbg.debug(
            "Entered active COMS area with zoneId: %s %s %s",
            zoneId,
            comZone.owner,
            MyServerId
        )

        RegisterZoneCOMS(comZone.vertices, comZone.models, zoneId, comZone.owner)
    end)
end

RegisterKey(
    StartInteract,
    "START_INTERACT_COMS",
    "Interact COMS",
    Config.COMS.InteractKey
)