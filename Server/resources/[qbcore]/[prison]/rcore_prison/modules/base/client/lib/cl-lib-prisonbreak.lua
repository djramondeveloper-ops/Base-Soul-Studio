local currentEscapeInteraction = {}

local WALL_MODEL_INTACT = joaat("prop_fnclink_10d")
local WALL_MODEL_BROKEN = joaat("rcore_prop_fnclink_10d")

local prisonBreakBriefingStarted = false
local playerWasSpottedAtWall = false
local escapeRoutesRegistered = false
local wallTaskInProgress = false

local localGuardPeds = {}
local localGuardMap = {}

local BOLT_CUTTER_MODEL = joaat("h4_prop_h4_bolt_cutter_01a")
local BOLT_CUTTER_BAG_MODEL = joaat("ch_p_m_bag_var02_arm_s")

local PATROL_ROUTES = {
    TYPE_A = {
        Points = {
            [0] = vector3(1770.1, 2538.464, 45.564),
            [1] = vector3(1761.746, 2530.179, 45.564),
            [2] = vector3(1760.106, 2522.247, 48.354),
            [3] = vector3(1761.633, 2521.815, 55.383),
            [4] = vector3(1768.569, 2529.862, 55.153),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 4000,
        EnableLookAtCoords = true,
        LookAt = {
            [0] = vector3(1785.262, 2528.204, 45.561),
            [1] = vector3(1760.175, 2541.616, 45.564),
            [2] = vector3(1741.848, 2521.748, 45.558),
            [3] = vector3(1741.848, 2521.748, 45.558),
            [4] = vector3(1758.153, 2561.73, 51.507),
        },
    },

    TYPE_B = {
        Points = {
            [0] = vector3(1767.925, 2565.082, 55.467),
            [1] = vector3(1761.719, 2565.263, 55.439),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 4000,
        EnableLookAtCoords = true,
        LookAt = {
            [0] = vector3(1767.758, 2538.003, 45.558),
            [1] = vector3(1750.946, 2553.367, 45.548),
        },
    },

    TYPE_C = {
        Points = {
            [0] = vector3(1753.888, 2502.016, 45.611),
            [1] = vector3(1742.231, 2524.099, 45.564),
            [2] = vector3(1715.031, 2511.472, 45.564),
            [3] = vector3(1713.981, 2493.884, 45.564),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 4000,
        EnableLookAtCoords = true,
        LookAt = {
            [0] = vector3(1756.747, 2529.015, 45.564),
            [1] = vector3(1722.827, 2535.64, 45.564),
            [2] = vector3(1690.738, 2515.833, 45.564),
            [3] = vector3(1721.436, 2490.613, 45.564),
        },
    },

    TYPE_D = {
        Points = {
            [0] = vector3(1693.096, 2493.947, 45.564),
            [1] = vector3(1713.981, 2493.884, 45.564),
            [2] = vector3(1715.031, 2511.472, 45.564),
            [3] = vector3(1742.231, 2524.099, 45.564),
            [4] = vector3(1753.888, 2502.016, 45.611),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 4000,
        EnableLookAtCoords = true,
        LookAt = {
            [0] = vector3(1693.51, 2505.146, 45.564),
            [1] = vector3(1721.436, 2490.613, 45.564),
            [2] = vector3(1690.738, 2515.833, 45.564),
            [3] = vector3(1722.827, 2535.64, 45.564),
            [4] = vector3(1756.747, 2529.015, 45.564),
        },
    },

    TYPE_E = {
        Points = {
            [0] = vector3(1656.658, 2488.947, 45.564),
            [1] = vector3(1666.233, 2502.819, 45.564),
            [2] = vector3(1678.372, 2496.806, 45.564),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 4000,
        EnableLookAtCoords = true,
        LookAt = {
            [0] = vector3(1665.48, 2501.397, 45.564),
            [1] = vector3(1663.402, 2488.481, 45.564),
            [2] = vector3(1687.761, 2505.944, 45.564),
        },
    },

    TYPE_06 = {
        Points = {
            [0] = vector3(1587.6637, 2671.749, 45.47485),
            [1] = vector3(1586.79163, 2671.09839, 44.4800873),
            [2] = vector3(1585.65991, 2669.74976, 44.4839935),
            [3] = vector3(1584.48682, 2668.37451, 44.49173),
            [4] = vector3(1583.50366, 2666.84863, 44.4918938),
            [5] = vector3(1582.62085, 2665.29932, 44.49013),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 0,
        EnableLookAtCoords = false,
        LookAt = {},
    },

    TYPE_07 = {
        Points = {
            [0] = vector3(1757.54907, 2431.591, 45.5023),
            [1] = vector3(1756.748, 2430.94238, 44.50678),
            [2] = vector3(1755.21082, 2430.133, 44.50924),
        },
        Scenario = "WORLD_HUMAN_GUARD_STAND",
        Timeout = 0,
        EnableLookAtCoords = false,
        LookAt = {},
    },
}

local prisonMapLoaded = false
local noiseLevel = 0
local visibleLevel = 0
local eventLocks = {}

local function hasEntries(tbl)
    return tbl ~= nil and next(tbl) ~= nil
end

local function clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
        return maxValue
    end

    return value
end

local function getRouteMaxIndex(routePoints)
    local maxIndex = -1

    for index in pairs(routePoints) do
        if index > maxIndex then
            maxIndex = index
        end
    end

    return maxIndex
end

local function getCutterHelpKeys()
    return {
        {
            label = _U("PRISON_BREAK.INTERACT_CUTTERS"),
            keyName = Config.Escape.InteractCuttersKey or "E",
        },
    }
end

local function getRepairHelpKeys()
    return {
        {
            label = _U("PRISON_BREAK.INTERACT_REPAIR_WALL"),
            keyName = Config.Escape.RepairWallKey or "H",
        },
    }
end

local function configureGuardPed(ped)
    if not ped or not DoesEntityExist(ped) then
        return
    end

    SetPedRelationshipGroupHash(ped, GetHashKey("COP"))
    SetPedAsCop(ped, true)
    SetCanAttackFriendly(ped, false, false)
    SetPedKeepTask(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)

    SetPedCombatAttributes(ped, 0, true)
    SetPedCombatAttributes(ped, 16, true)
    SetPedCombatAttributes(ped, 14, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 90, true)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatMovement(ped, 3)
end

AddEventHandler("rcore_prison:shared:internal:MapLoaded", function()
    prisonMapLoaded = true
end)

CreateThread(function()
    local tries = 0

    repeat
        Wait(250)
        tries = tries + 1

        if tries >= 50 then
            dbg.critical("Failed to load prison map in cl-lib-prisonbreak.lua")
            break
        end
    until prisonMapLoaded

    DefaultState()
end, "cl-lib-prisonbreak code name: Phoenix")

local function ClearWallSwaps(coords)
    if not coords then
        return
    end

    RemoveModelSwap(coords, 0.1, WALL_MODEL_INTACT, WALL_MODEL_BROKEN, false)
    RemoveModelSwap(coords, 0.1, WALL_MODEL_BROKEN, WALL_MODEL_INTACT, false)
end

local function ResetAllPrisonBreakWalls()
    local prisonBreakData = SH.data.PrisonBreak
    if not prisonBreakData or not prisonBreakData.WALLS then
        return
    end

    for _, wallGroup in pairs(prisonBreakData.WALLS) do
        if type(wallGroup) == "table" then
            for _, wallData in pairs(wallGroup) do
                if wallData and wallData.coords then
                    ClearWallSwaps(wallData.coords)
                    CreateModelSwap(wallData.coords, 0.1, WALL_MODEL_BROKEN, WALL_MODEL_INTACT, true)
                end
            end
        end
    end
end

local function ClearEscapeRouteZones()
    if NearWorldCOMS then
        for _, zone in pairs(NearWorldCOMS) do
            local layerName = zone.getLayerName and zone.getLayerName() or nil
            local zoneType = zone.getZoneType and zone.getZoneType() or nil

            if layerName or zoneType == "WALLS" then
                zone.destroy()
            end
        end
    end

    if WorldCOMS then
        for _, zone in pairs(WorldCOMS) do
            local zoneType = zone.getZoneType and zone.getZoneType() or nil

            if zoneType == "WALLS" then
                zone.destroy()
            end
        end
    end
end

function DefaultState()
    local prisonBreakData = SH.data.PrisonBreak
    if not prisonBreakData then
        return dbg.debug("Prison break: Not supported on this map preset: %s", SH.preset)
    end

    dbg.debug("Prison break: Setting initial state for walls")
    ResetAllPrisonBreakWalls()
end

RegisterNetEvent("rcore_prison:client:ResetPrisonBreak", function(resetAlarm)
    if resetAlarm then
        Sound.SetPrisonAlarm(false)
        Sound.HandleAlarmAnnoucement(true)
    end

    Subtitles.Hide()
    Blips.RemoveByType("ESCAPE_POINTS")

    prisonBreakBriefingStarted = false
    escapeRoutesRegistered = false
    playerWasSpottedAtWall = false
    currentEscapeInteraction = {}
    wallTaskInProgress = false
    HelpKeys.Hide()

    ClearEscapeRouteZones()
    ResetAllPrisonBreakWalls()
end)

RegisterNetEvent("rcore_prison:client:registerEscapeRoutes", function(routeData)
    Blips.RemoveByType("ESCAPE_POINTS")
    ClearEscapeRouteZones()

    escapeRoutesRegistered = true
    RegisterEscapeRouteLayer(routeData)
end)

RegisterNetEvent("rcore_prison:client:setAlarm", function(state)
    Sound.StartAlarm(state)
end)

NetworkService.RegisterNetEvent("startPrisonBreakProlog", function(shouldStart)
    if not shouldStart then
        return
    end

    prisonBreakBriefingStarted = true

    Subtitles.Show(_U("PRISON_BREAK_PROLOG_SUBTITLE.START_FIRST"))
    Wait(6000)

    Subtitles.Show(_U("PRISON_BREAK_PROLOG_SUBTITLE.START_SEC"))
    Wait(4500)

    Subtitles.Show(_U("PRISON_BREAK_PROLOG_SUBTITLE.START_THIRD"))
    Wait(4500)

    Subtitles.Show(_U("PRISON_BREAK_PROLOG_SUBTITLE.START_FOURTH"))
end)

RegisterNetEvent("rcore_prison:client:restoreSwapSessions", function(swaps)
    if swaps then
        RestoreWall(swaps)
    end
end)

RegisterNetEvent("rcore_prison:client:startInteractTask", function(zoneId, zoneType)
    HelpKeys.Hide()
    currentEscapeInteraction = {}

    if zoneType == "WALLS" then
        StartWallTask(zoneType, zoneId)
    elseif zoneType == "REPAIR_WALL" then
        TaskRepairWall()
    end
end)

RegisterNetEvent("rcore_prison:client:syncRepairWall", function(coords)
    if coords then
        CustomModelSwap(coords, WALL_STATES.FULL_HEALTH)
    end
end)

function TaskRepairWall()
    FreezePlayer(PlayerId(), true)
    FreezeEntityPosition(PlayerPedId(), true)

    local hammer = CreateObject(GetHashKey("prop_tool_hammer"), 0, 0, 0, true, true, true)

    AttachEntityToEntity(
        hammer,
        PlayerPedId(),
        GetPedBoneIndex(PlayerPedId(), 57005),
        0.18, -0.02, -0.02,
        350.0, 100.0, 140.0,
        true, true, false, true, 1, true
    )

    playAnim("amb@world_human_hammering@male@base", "base", -1, 49)

    Wait(Config.Escape.RepairWallTime * 1000)

    ClearPedTasks(PlayerPedId())
    DetachEntity(hammer, 1, true)
    DeleteEntity(hammer)
    DeleteObject(hammer)

    FreezeEntityPosition(PlayerPedId(), false)
    FreezePlayer(PlayerId(), false)
end

function playAnim(dict, name, duration, flag)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), dict, name, -8.0, -8.0, duration, flag, 0, 0, 0, 0)
end

function LoadAnimationDict(dict)
    RequestAnimDict(dict)

    local tries = 0
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        tries = tries + 1

        if tries >= 50 then
            dbg.critical("Failed to load animation: %s!", dict)
            break
        end
    end

    return HasAnimDictLoaded(dict)
end

function LoadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)

        local tries = 0
        while not HasModelLoaded(model) do
            Wait(10)
            tries = tries + 1

            if tries >= 50 then
                dbg.critical("Failed to load model: %s!", model)
                break
            end
        end
    end

    return HasModelLoaded(model)
end

function SpawnObject(model, coords, isNetworked, dynamic)
    isNetworked = isNetworked or false
    dynamic = dynamic or false

    local object = CreateObject(model, coords.x, coords.y, coords.z, isNetworked, dynamic, false)
    local tries = 0

    while not DoesEntityExist(object) do
        Wait(0)
        tries = tries + 1

        if tries >= 50 then
            dbg.critical("Failed to spawn object named: %s", model)
            break
        end
    end

    return object
end

function StartCuttingSequenece(zoneType, zoneId)
    local animationDict = "anim@scripted@heist@ig4_bolt_cutters@male@"
    local sequenceDuration = 10000

    if Config.Escape.Experimental and Config.Escape.Experimental.CuttingSequence then
        sequenceDuration = (Config.Escape.Experimental.CuttingSequenceTime or 10) * 1000
    end

    local ped = PlayerPedId()
    local startTime = GetGameTimer()
    local lastCutterObject = nil
    local lastScene = nil

    repeat
        Wait(1000)

        local pedCoords = GetEntityCoords(ped)
        local pedRotation = GetEntityRotation(ped)
        local sceneCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.2)

        LoadAnimationDict(animationDict)
        LoadModel(BOLT_CUTTER_MODEL)
        LoadModel(BOLT_CUTTER_BAG_MODEL)

        lastCutterObject = SpawnObject(BOLT_CUTTER_MODEL, pedCoords, true, true)

        lastScene = NetworkCreateSynchronisedScene(
            sceneCoords.x, sceneCoords.y, sceneCoords.z,
            pedRotation.x, pedRotation.y, pedRotation.z,
            2, true, true, 1065353216, 5.0, 1.3
        )

        NetworkAddPedToSynchronisedScene(
            ped,
            lastScene,
            animationDict,
            "action_male",
            4.0, -4.0,
            1033, 0, 1000.0, 0
        )

        NetworkAddEntityToSynchronisedScene(
            lastCutterObject,
            lastScene,
            animationDict,
            "action_cutter",
            1.0, -1.0, 1148846080
        )

        NetworkStartSynchronisedScene(lastScene)
        Wait(3800)

        local foundGround, groundZ = GetGroundZAndNormalFor_3dCoord(pedCoords.x, pedCoords.y, pedCoords.z)
        if foundGround then
            SetEntityCoords(ped, pedCoords.x, pedCoords.y, groundZ, false, false, false, false)
            SetEntityRotation(ped, pedRotation.x, pedRotation.y, pedRotation.z, 2, true)
        end

        if DoesEntityExist(lastCutterObject) then
            DeleteEntity(lastCutterObject)
        end

        RemoveAnimDict(animationDict)
        SetModelAsNoLongerNeeded(BOLT_CUTTER_MODEL)
    until (GetGameTimer() - startTime) >= sequenceDuration

    FinishWallTask(zoneType, zoneId, lastCutterObject, lastScene, animationDict)
end

function StartNormalCutting(zoneType, zoneId)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    local animationDict = "anim@scripted@heist@ig4_bolt_cutters@male@"
    local sceneCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.2)

    LoadAnimationDict(animationDict)
    LoadModel(BOLT_CUTTER_MODEL)
    LoadModel(BOLT_CUTTER_BAG_MODEL)

    local cutterObject = SpawnObject(BOLT_CUTTER_MODEL, pedCoords, true, true)

    local scene = NetworkCreateSynchronisedScene(
        sceneCoords.x, sceneCoords.y, sceneCoords.z,
        pedRotation.x, pedRotation.y, pedRotation.z,
        2, true, false, 1065353216, 5.0, 1.3
    )

    NetworkAddPedToSynchronisedScene(
        ped,
        scene,
        animationDict,
        "action_male",
        4.0, -4.0,
        1033, 0, 1000.0, 0
    )

    NetworkAddEntityToSynchronisedScene(
        cutterObject,
        scene,
        animationDict,
        "action_cutter",
        1.0, -1.0, 1148846080
    )

    NetworkStartSynchronisedScene(scene)

    SetTimeout(3800, function()
        FinishWallTask(zoneType, zoneId, cutterObject, scene, animationDict)
    end)
end

function FinishWallTask(zoneType, zoneId, cutterObject, scene, animationDict)
    local ped = PlayerPedId()

    TriggerServerEvent("rcore_prison:server:EscapeInteractFinishTask", zoneType, zoneId)

    if scene then
        NetworkStopSynchronisedScene(scene)
    end

    if cutterObject and DoesEntityExist(cutterObject) then
        DeleteEntity(cutterObject)
    end

    ClearPedTasksImmediately(ped)
    RemoveAnimDict(animationDict)

    if IsModelInCdimage(BOLT_CUTTER_MODEL) then
        SetModelAsNoLongerNeeded(BOLT_CUTTER_MODEL)
    end

    if wallTaskInProgress then
        wallTaskInProgress = false
    end
end

function StartWallTask(zoneType, zoneId)
    dbg.debug("Starting wall task with type: %s", zoneType)

    wallTaskInProgress = true

    if IsModelInCdimage(BOLT_CUTTER_MODEL) then
        dbg.debug("Loading variant A for wall task.")

        if Config.Escape.Experimental and Config.Escape.Experimental.CuttingSequence then
            dbg.debug("Loading sequence cutting through wall")
            StartCuttingSequenece(zoneType, zoneId)
        else
            dbg.debug("Loading normal cutting through wall without sequence")
            StartNormalCutting(zoneType, zoneId)
        end

        return
    end

    dbg.debug("Since the model is not in cdimage, we will use the default animation variant B.")

    local fallbackDict = "mp_common_heist"
    local ped = PlayerPedId()

    LoadAnimationDict(fallbackDict)

    TaskPlayAnim(
        ped,
        fallbackDict,
        "pick_door",
        3.0, 1.0,
        -1,
        49,
        0,
        true, true, true
    )

    Wait(GetAnimDuration(fallbackDict, "pick_door") * 1000)

    StopEntityAnim(ped, "pick_door", fallbackDict, 0)
    FinishWallTask(zoneType, zoneId, nil, nil, fallbackDict)
end

function EnterZone(zoneId, zone)
    local breakType = zone.getBreakType()
    local wallState = zone.getWallState()
    local zoneType = zone.getZoneType()
    local helpKeys = zone.getInteractHelpKeys()

    currentEscapeInteraction = {
        zoneId = zoneId,
        zoneType = zoneType,
        breakType = breakType,
        wallState = wallState,
    }

    HelpKeys.Show(helpKeys, "top-left")
end

function LeaveZone(zoneId, zone)
    local layerName = zone.getLayerName()
    local breakType = zone.getBreakType()

    dbg.debug("Player left zone with Id: %s", zoneId)
    dbg.debug("Current layer: %s", layerName)
    dbg.debug("Break type: %s", breakType)

    currentEscapeInteraction = {}
    HelpKeys.Hide()

    if layerName == "SECOND_LAYER" then
        if not PrisonService.IsPrisoner() then
            dbg.debug("Player is not a prisoner, cannot release him!")
            return
        end

        TriggerServerEvent("rcore_prison:server:registerEscapeExitZone", {
            breakType = breakType,
            zoneId = zoneId,
            layerName = layerName,
        })
    end
end

RegisterNetEvent("rcore_prison:client:updateWall", function(zoneId, setterName, state, zonePlayers)
    for _, zone in pairs(WorldCOMS) do
        if zone.id == zoneId then
            local currentJob = zone.getPlayerCurrentJob()
            local layerName = zone.getLayerName()
            local previousState = zone.getWallState()
            local isPrisoner = PrisonService.IsPrisoner()

            if zonePlayers then
                zone.setZonePlayers(zonePlayers)
            end

            local setter = zone[setterName]
            if setter then
                setter(state)
            end

            if state == WALL_STATES.FULL_HEALTH then
                if isPrisoner then
                    zone.setInteractHelpKeys(getCutterHelpKeys())

                    if layerName == "SECOND_LAYER" then
                        zone.setRenderMarker(true)
                    end

                    zone.render()
                    dbg.debug("RENDERING WALL TASK HELP FOR PRISONER")
                elseif currentJob and Config.Jobs[currentJob.name] then
                    zone.setRenderMarker(true)
                    zone.stopRender()
                end
            elseif state == WALL_STATES.DESTROYED then
                if currentJob and Config.Jobs[currentJob.name] and not isPrisoner then
                    if layerName == "SECOND_LAYER" then
                        zone.setInteractHelpKeys(getRepairHelpKeys())
                    end

                    zone.render()
                elseif isPrisoner then
                    if layerName == "SECOND_LAYER" then
                        zone.setInteractHelpKeys({})
                        zone.setRenderMarker(false)
                        HelpKeys.Hide()
                        return
                    end

                    zone.stopRender()
                end
            end

            if previousState == WALL_STATES.DESTROYED and state == WALL_STATES.FULL_HEALTH then
                if isPrisoner then
                    zone.setInteractHelpKeys(getCutterHelpKeys())

                    if layerName == "SECOND_LAYER" then
                        zone.setRenderMarker(true)
                    end

                    zone.render()
                    dbg.debug("RENDERING WALL TASK HELP FOR PRISONER")
                elseif currentJob and Config.Jobs[currentJob.name] then
                    zone.stopRender()
                end
            end

            break
        end
    end
end)

function GetCoordsById(zoneId)
    for _, zone in pairs(NearWorldCOMS) do
        if zone.id == zoneId then
            if zone.getWallCoords then
                return zone.getWallCoords()
            end

            return zone.getPosition()
        end
    end

    for _, zone in pairs(WorldCOMS) do
        if zone.id == zoneId then
            if zone.getWallCoords then
                return zone.getWallCoords()
            end

            return zone.getPosition()
        end
    end
end

function RegisterZone(zoneId, zoneData)
    local zone = CreateCOMSZone()
    local coords = vec3(zoneData.coords.x, zoneData.coords.y, zoneData.coords.z)
    local wallCoordsData = zoneData.wallCoords or zoneData.coords
    local wallCoords = vec3(wallCoordsData.x, wallCoordsData.y, wallCoordsData.z)

    zone.getWallCoords = function()
        return wallCoords
    end

    zone.setId(zoneId)
    zone.setRenderDistance(Config.Escape.WallLodSyncDistance)
    zone.setType(1)
    zone.setWallState(zoneData.state)
    zone.setLayerName(zoneData.layerName)
    zone.setZoneType(zoneData.zoneType)
    zone.setPosition(coords)
    zone.setRenderMarker(true)
    zone.setInRadius(1.5)
    zone.setBreakType(zoneData.breakType)
    zone.setRenderDistance(5)
    zone.setColor(Config.Escape.MarkerColor)
    zone.setZonePlayers(zoneData.players)
    zone.setPlayerCurrentJob(Framework.job)

    zone.on("leave", function()
        LeaveZone(zoneId, zone)
    end)

    zone.on("enter", function()
        EnterZone(zoneId, zone)
    end)

    return zone
end

function RegisterEscapeRouteLayer(routeData)
    if not routeData then
        return
    end

    for zoneId, zoneData in pairs(routeData) do
        local zone = RegisterZone(zoneId, zoneData)
        local shouldRender = true
        local wallState = zone.getWallState()
        local wallCoords = zone.getWallCoords and zone.getWallCoords() or zone.getPosition()

        CustomModelSwap(wallCoords, wallState, true)

        if wallState == WALL_STATES.DESTROYED then
            local currentJob = zone.getPlayerCurrentJob()

            if currentJob and Config.Jobs[currentJob.name] then
                if not PrisonService.IsPrisoner() then
                    zone.setInteractHelpKeys(getRepairHelpKeys())
                else
                    shouldRender = false
                end
            else
                shouldRender = false
            end
        elseif wallState == WALL_STATES.FULL_HEALTH then
            if PrisonService.IsPrisoner() then
                zone.setInteractHelpKeys(getCutterHelpKeys())
            else
                shouldRender = false
            end
        end

        if not shouldRender then
            zone.stopRender()
        else
            if PrisonService.IsPrisoner() and prisonBreakBriefingStarted then
                Blips.Create({
                    name = _U("PRISON_BREAK.WALL_BLIP_TEXT", zoneId),
                    sprite = 761,
                    color = 1,
                    scale = 1.0,
                    zoneId = zoneId,
                    coords = zone.getPosition(),
                    type = "ESCAPE_POINTS",
                })
            end
        end
    end
end

function CustomModelSwap(coords, wallState, noFx)
    WallSwapHandler(coords, wallState, noFx)
end

function WallSwapHandler(coords, wallState, noFx)
    local playFx = not noFx

    if wallState == WALL_STATES.DESTROYED then
        SetWallBroken(coords, playFx, wallState)
    elseif wallState == WALL_STATES.FULL_HEALTH then
        SetRepairedWall(coords, playFx, wallState)
    end
end

function SetRepairedWall(coords, playFx, wallState)
    dbg.debug("[WALLS] SetRepairedWall: Setting wall to state: %s", wallState)

    ClearWallSwaps(coords)
    CreateModelSwap(coords, 0.1, WALL_MODEL_BROKEN, WALL_MODEL_INTACT, true)
end

function SetWallBroken(coords, playFx, wallState)
    dbg.debug("[WALLS] SetWallBroken: Setting wall to state: %s", wallState)

    ClearWallSwaps(coords)
    CreateModelSwap(coords, 0.1, WALL_MODEL_INTACT, WALL_MODEL_BROKEN, true)
end

function LODSync(coords)
    ClearWallSwaps(coords)
    CreateModelSwap(coords, 0.1, WALL_MODEL_INTACT, WALL_MODEL_BROKEN, true)
end

function RestoreWall(swaps)
    if not swaps then
        return
    end

    for _, swapData in pairs(swaps) do
        CustomModelSwap(swapData.pos, swapData.state)
    end
end

function PlayerEscaped()
    Subtitles.Hide()
    TriggerEvent("rcore_prison:client:playerEscapedFromPrison")
    Blips.RemoveByType("ESCAPE_POINTS")
    Blips.RemoveByType("NPC")
end

function DestroyWall(zoneId)
    dbg.debug("[WALLS] Destroying wall at location! %s", zoneId)

    local coords = GetCoordsById(zoneId)
    if coords then
        CustomModelSwap(coords, WALL_STATES.DESTROYED)
    end
end

function SyncStaticObject(entity)
    N_0x0379daf89ba09aa5(entity, true)
end

function InteractZone()
    if hasEntries(currentEscapeInteraction) then
        TriggerServerEvent("rcore_prison:server:requestEscapeInteract", currentEscapeInteraction)
    end
end

function RequestRepairWall()
    if hasEntries(currentEscapeInteraction) then
        TriggerServerEvent("rcore_prison:server:requestRepairWall", currentEscapeInteraction)
    end
end

RegisterKey(InteractZone, "ZONE_PRISON", "Interact zone", Config.Zone.InteractKey)
RegisterKey(RequestRepairWall, "WALL_PRISON", "Repair wall", Config.Escape.RepairWallKey)

function deleteAllLocalPeds()
    if not hasEntries(localGuardPeds) then
        return
    end

    for _, ped in pairs(localGuardPeds) do
        if ped and DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end

    localGuardPeds = {}
    localGuardMap = {}
end

function hasClearLos(guardPed, guardCoords, targetPed, targetCoords)
    local distance = #(guardCoords - targetCoords)

    if distance < 20.0 and targetPed then
        if HasEntityClearLosToEntity(guardPed, targetPed, 17) then
            return IsPedFacingPed(guardPed, targetPed, 40.0)
        end

        return false
    end

    return false
end

function vectorSubtract(a, b)
    return vector3(a.x - b.x, a.y - b.y, a.z - b.z)
end

function angleToVector(angle)
    local radians = math.rad(angle)
    return vector3(math.cos(radians), math.sin(radians), 0.0)
end

function calculateAngle(a, b)
    local dotProduct = (a.x * b.x) + (a.y * b.y)
    local magnitudeA = math.sqrt((a.x * a.x) + (a.y * a.y))
    local magnitudeB = math.sqrt((b.x * b.x) + (b.y * b.y))

    return math.deg(math.acos(dotProduct / (magnitudeA * magnitudeB)))
end

function isWithinGuardView(playerCoords, guardHeading, wallCoords)
    local toWall = vectorSubtract(wallCoords, playerCoords)
    local forward = angleToVector(guardHeading)
    local angle = calculateAngle(forward, toWall)

    dbg.debug("Guard view: %s %s", angle, Config.Escape.ViewCone)

    return angle <= Config.Escape.ViewCone
end

function canGuardSeeBrokenWall()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local playerHeading = GetEntityHeading(PlayerPedId())

    for zoneId, zone in pairs(NearWorldCOMS) do
        local layerName = zone.getLayerName()
        local wallState = zone.getWallState()
        local wallCoords = zone.getPosition()
        local wasReported = zone.getReportState()
        local distance = #(playerCoords - wallCoords)

        if layerName and wallState == WALL_STATES.DESTROYED then
            local maxDistance = Config.Escape.ViewNPCDistance or 30

            if distance <= maxDistance and not wasReported then
                if isWithinGuardView(playerCoords, playerHeading, wallCoords) then
                    zone.setReportState(true)
                    return true, zoneId
                end
            end
        end
    end
end

function IsPlayerAtAnyWall()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local prisonBreakData = SH.data.PrisonBreak
    local allWalls = prisonBreakData and prisonBreakData.WALLS and prisonBreakData.WALLS.ALL_WALLS

    if not allWalls then
        return false
    end

    for _, wallData in pairs(allWalls) do
        local interactCoords = vec3(
            wallData.interactCoords.x,
            wallData.interactCoords.y,
            wallData.interactCoords.z
        )

        if #(playerCoords - interactCoords) <= 4.0 then
            return true
        end
    end

    return false
end

function isPlayerNearGuard()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not hasEntries(localGuardPeds) then
        return false
    end

    for _, guardPed in pairs(localGuardPeds) do
        local guardCoords = GetEntityCoords(guardPed)

        if not IsPedDeadOrDying(guardPed) and hasClearLos(guardPed, guardCoords, playerPed, playerCoords) then
            return true, guardPed
        end
    end

    return false
end

function getLocalGuards()
    return localGuardPeds
end

function LoadRecording(recordingName)
    if GetIsWaypointRecordingLoaded(recordingName) then
        return
    end

    RequestWaypointRecording(recordingName)

    while not GetIsWaypointRecordingLoaded(recordingName) do
        Wait(0)
    end
end

RegisterNetEvent("rcore_prison:client:guards")
AddEventHandler("rcore_prison:client:guards", function(guardsData)
    Wait(500)
    deleteAllLocalPeds()

    local spawnedPeds = {}
    local spawnedMap = {}

    if not hasEntries(guardsData) then
        localGuardPeds = spawnedPeds
        localGuardMap = spawnedMap
        return
    end

    for netId, guardData in pairs(guardsData) do
        if netId and NetworkDoesEntityExistWithNetworkId(netId) then
            local ped = NetToPed(netId)

            if DoesEntityExist(ped) then
                configureGuardPed(ped)
                TaskPatrol(ped, "miss_" .. guardData[STRUCT_ROUTE], 0, 0)

                table.insert(spawnedPeds, ped)
                spawnedMap[ped] = true
            end
        end
    end

    localGuardPeds = spawnedPeds
    localGuardMap = spawnedMap
end)

RegisterNetEvent("rcore_prison:client:respawnGuard")
AddEventHandler("rcore_prison:client:respawnGuard", function(guardData)
    Wait(500)

    if not guardData or not NetworkDoesEntityExistWithNetworkId(guardData.netId) then
        return
    end

    local ped = NetToPed(guardData.netId)
    if not ped or not DoesEntityExist(ped) then
        return
    end

    configureGuardPed(ped)
    TaskPatrol(ped, "miss_" .. guardData[STRUCT_ROUTE], 0, 0)

    local alreadyRegistered = false
    for _, existingPed in pairs(localGuardPeds) do
        if existingPed == ped then
            alreadyRegistered = true
            break
        end
    end

    if not alreadyRegistered then
        table.insert(localGuardPeds, ped)
    end

    localGuardMap[ped] = true
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    deleteAllLocalPeds()
end)

function isDay()
    local hour = GetClockHours()
    return not (hour < 7 or hour > 21)
end

function getNoiseLevel()
    return noiseLevel
end

function setNoiseLevel(value)
    noiseLevel = value
end

function addNoise(value)
    noiseLevel = noiseLevel + value
end

function getVisibleLevel()
    return visibleLevel
end

function setVisibleLevel(value)
    visibleLevel = value
end

function addVisibleLevel(value)
    visibleLevel = visibleLevel + value
end

function updateNoiseLevel(_)
    -- Intentionally left empty in the original logic.
end

function updateVisibleLevel(_)
    -- Intentionally left empty in the original logic.
end

CreateThread(function()
    local tries = 0

    repeat
        Wait(250)
        tries = tries + 1

        if tries >= 50 then
            dbg.critical("Failed to load prison map in cl-lib-prisonbreak.lua")
            break
        end
    until prisonMapLoaded

    repeat
        Wait(1000)
    until SH.data.PrisonBreak

    while true do
        Wait(250)

        local ped = PlayerPedId()
        if IsPedDeadOrDying(ped) then
            goto continue
        end

        local playerId = PlayerId()
        local stealthNoise = GetPlayerCurrentStealthNoise(playerId)
        local isNearGuard, guardPed = isPlayerNearGuard()

        if guardPed and localGuardMap and localGuardMap[guardPed] then
            local guardCoords = GetEntityCoords(guardPed)
            local playerCoords = GetEntityCoords(ped)
            local guardDistance = #(playerCoords - guardCoords)

            local collisionDistance = 1.5
            if Config.Guards.Experimental and Config.Guards.Experimental.DistanceToGuard then
                collisionDistance = Config.Guards.Experimental.DistanceToGuard
            end

            local forwardSpeed = 1.2
            if Config.Guards.Experimental and Config.Guards.Experimental.PlayerMovementSpeed then
                forwardSpeed = Config.Guards.Experimental.PlayerMovementSpeed
            end

            if guardDistance < collisionDistance then
                local heading = GetEntityHeading(ped)
                local forward = vec3(
                    math.sin(math.rad(heading)),
                    math.cos(math.rad(heading)),
                    0.0
                )

                local projectedCoords = playerCoords + (forward * 0.6)
                local movedCloser = guardDistance > #(projectedCoords - guardCoords)
                local attackedGuard = HasEntityBeenDamagedByEntity(guardPed, ped, true) and not IsEntityDead(guardPed)

                if movedCloser or attackedGuard then
                    dbg.debug("Attacked or running into guard")
                    handleGuardArrest(guardPed, ped)
                end

                ClearEntityLastDamageEntity(guardPed)
            end
        end

        local updatedNoise = clamp(getNoiseLevel() + (stealthNoise * 0.7), 0, 100)
        local updatedVisible = clamp(getVisibleLevel() + 20.0, 0, 100)

        setNoiseLevel(updatedNoise)

        local brokenWallSeen, wallZoneId = canGuardSeeBrokenWall()
        if brokenWallSeen and escapeRoutesRegistered and guardPed then
            dbg.debug("Guard can see broken wall")
            TriggerServerEvent(
                "rcore_prison:server:prisonBreakGuardSpottedBrokenWall",
                PedToNet(guardPed),
                wallZoneId
            )
        end

        if isNearGuard then
            setVisibleLevel(updatedVisible)

            if IsPlayerAtAnyWall() and not playerWasSpottedAtWall and wallTaskInProgress and escapeRoutesRegistered and guardPed then
                playerWasSpottedAtWall = true
                dbg.debug("Player is near escape wall and visible level is 100, calling guards")

                TriggerServerEvent(
                    "rcore_prison:server:prisonBreakUserSpotted",
                    PedToNet(guardPed)
                )
            end
        end

        updateNoiseLevel(getNoiseLevel())
        updateVisibleLevel(getVisibleLevel())

        if getNoiseLevel() > 0 then
            local newNoise = getNoiseLevel() - 2.5
            if (getNoiseLevel() - 10.0) < 0 then
                setNoiseLevel(0)
            else
                setNoiseLevel(newNoise)
            end
        end

        if isDay() then
            if getVisibleLevel() > 50 then
                if (getVisibleLevel() - 10.0) < 50 then
                    setVisibleLevel(50)
                else
                    setVisibleLevel(getVisibleLevel() - 2.5)
                end
            else
                setVisibleLevel(50)
            end
        else
            if (getVisibleLevel() - 10.0) < 0 then
                setVisibleLevel(0)
            else
                setVisibleLevel(getVisibleLevel() - 1.25)
            end
        end

        ::continue::
    end
end, "cl-lib-prisonbreak code name: Phoenix")

CreateThread(function()
    for routeName, routeData in pairs(PATROL_ROUTES) do
        OpenPatrolRoute("miss_" .. routeName)

        local maxIndex = getRouteMaxIndex(routeData.Points)
        for index = 0, maxIndex do
            local point = routeData.Points[index]
            local lookAt = routeData.LookAt[index] or point

            if routeData.EnableLookAtCoords then
                AddPatrolRouteNode(index, routeData.Scenario, point, lookAt, routeData.Timeout)
            else
                AddPatrolRouteNode(index, routeData.Scenario, point, point, routeData.Timeout)
            end

            if index < maxIndex then
                AddPatrolRouteLink(index, index + 1)
            else
                AddPatrolRouteLink(index, 0)
            end
        end

        ClosePatrolRoute()
        CreatePatrolRoute()
    end
end, "cl-lib-prisonbreak code name: Alfa")

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for routeName in pairs(PATROL_ROUTES) do
        DeletePatrolRoute("miss_" .. routeName)
    end
end)

function EventAwait(key, callback, ...)
    if eventLocks[key] then
        return
    end

    eventLocks[key] = true
    callback(...)
    Wait(5000)
    eventLocks[key] = false
end

function StopOfficerTask()
    if not hasEntries(localGuardMap) then
        return
    end

    for ped in pairs(localGuardMap) do
        if DoesEntityExist(ped) then
            ClearPedTasks(ped)
        end
    end
end

AddEventHandler("gameEventTriggered", function(eventName, eventData)
    if eventName ~= "CEventNetworkEntityDamage" then
        return
    end

    local victim = eventData[1]
    local attacker = eventData[2]
    local fatalDamage = eventData[6]

    if fatalDamage ~= 0 or not victim or not attacker then
        return
    end

    if not IsEntityAPed(victim) or not IsEntityAPed(attacker) then
        return
    end

    if not NetworkGetEntityIsNetworked(victim) or not NetworkGetEntityIsNetworked(attacker) then
        return
    end

    if GetPedType(victim) == 28 or IsPedAPlayer(victim) then
        return
    end

    if not (localGuardMap and localGuardMap[victim]) then
        return
    end

    handleGuardArrest(victim, attacker)
end)

function handleGuardArrest(guardPed, playerPed)
    local guardNetId = NetworkGetNetworkIdFromEntity(guardPed)
    local playerServerId = MyServerId or GetPlayerServerId(PlayerId())

    EventAwait(guardNetId, function()
        dbg.debug("Guard reacting to player...")

        repeat
            Wait(1000)
        until not IsPedRagdoll(guardPed)

        if IsEntityDead(guardPed) then
            return
        end

        RequestAnimDict("mp_arrest_paired")
        while not HasAnimDictLoaded("mp_arrest_paired") do
            Wait(10)
        end

        SetPoliceIgnorePlayer(playerPed, true)
        SetCurrentPedWeapon(guardPed, -1569615261, true)
        SetCurrentPedWeapon(playerPed, -1569615261, true)

        FreezeEntityPosition(playerPed, true)

        local arrestCoords = GetOffsetFromEntityInWorldCoords(guardPed, 0.0, 0.6, 0.0)
        SetEntityCoords(playerPed, vec3(arrestCoords.x, arrestCoords.y, arrestCoords.z - 1))
        Wait(100)
        SetEntityHeading(playerPed, GetEntityHeading(guardPed))

        TaskPlayAnim(
            guardPed,
            "mp_arrest_paired",
            "cop_p2_back_right",
            8.0, -8.0,
            3750,
            2,
            0.0,
            false, false, false
        )

        TaskPlayAnim(
            playerPed,
            "mp_arrest_paired",
            "crook_p2_back_right",
            3.0, 3.0,
            -1,
            32,
            0.0,
            false, false, false
        )

        Wait(4750)

        dbg.debug("Sending to solitary")
        TriggerServerEvent("rcore_prison:server:guardWasAttackedByPrisoner", guardNetId, playerServerId)

        FreezeEntityPosition(playerPed, false)
        RemoveAnimDict("mp_arrest_paired")
    end)
end

RegisterCommand("debugPeds", function()
    if not hasEntries(localGuardPeds) then
        return
    end

    local debugData = {}

    for ped in pairs(localGuardMap) do
        if ped and DoesEntityExist(ped) then
            debugData[#debugData + 1] = {
                FLAG_DISABLE_EVENTS = GetPedConfigFlag(ped, 32, true),
                modelName = GetEntityArchetypeName(ped),
                entity = ped,
                pos = GetEntityCoords(ped),
            }
        end
    end

    tprint(debugData)
end, false)