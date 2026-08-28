local actionRequested = false
local stopRequested = false
TASK_PROCESSING_STEPPER = false

local finishCallback = nil
local progress = 0
local isExiting = false
local isCompleted = false

local particleHandlesByPlayerId = {}

local localNetworkedPropModels = {
    prop_hedge_trimmer_01 = true,
    prop_tool_broom = true,
    prop_leaf_blower_01 = true,
    prop_fish_slice_01 = true,
}

local stepperController = {}
Stepper = stepperController

local function showStepperHelp(label)
    HelpKeys.Show({
        {
            label = _U("JOB.STEPPER_TASK_LABEL", label),
            keyName = "",
        },
        {
            label = _U("JOB.STEPPER_PROGRESS_LABEL", progress),
            keyName = "",
        },
        {
            label = _U("JOB.STEPPER_DO_TASK_LABEL"),
            keyName = Config.PrisonJobs.Stepper.DoTask,
        },
        {
            label = _U("JOB.STEPPER_EXIT_TASK_LABEL"),
            keyName = Config.PrisonJobs.Stepper.StopTask,
        },
    }, "top-left")
end

local function showJobExitHelp()
    HelpKeys.Show({
        {
            label = _U("JOB.STOP_CURRENT_JOB_LABEL"),
            keyName = Config.PrisonJobs.LeaveJobKey,
        },
    }, "top-left")
end

function stepperController.LoadAndStart(stepperConfig, callback)
    finishCallback = callback

    CreateThread(function()
        StartStepper(stepperConfig)
    end, "cl-lib-stepper code name: Phoenix")
end

local function resolvePropNetworkState(model)
    if type(NetworkedEntities) == "table" and NetworkedEntities[model] ~= nil then
        return NetworkedEntities[model]
    end

    if localNetworkedPropModels[model] ~= nil then
        return localNetworkedPropModels[model]
    end

    return true
end

local function cleanupAnimDicts(animMap)
    for _, animData in pairs(animMap) do
        if animData and animData.dict then
            RemoveAnimDict(animData.dict)
        end
    end
end

function requestPTFXAsset(assetName)
    RequestNamedPtfxAsset(assetName)

    while not HasNamedPtfxAssetLoaded(assetName) do
        Wait(0)
    end

    return true
end

function handlePTFX(enabled, particleData)
    if not particleData then
        return
    end

    local playerPed = PlayerPedId()
    local playerServerId = MyServerId
    local boneIndex = GetPedBoneIndex(playerPed, 28422)

    if enabled then
        local color = {
            R = 255.0,
            G = 255.0,
            B = 255.0,
            A = 1.0,
        }

        requestPTFXAsset(particleData.dict)
        UseParticleFxAsset(particleData.dict)

        particleHandlesByPlayerId[playerServerId] = StartParticleFxLoopedOnEntityBone(
            particleData.name,
            playerPed,
            particleData.offset.pos.x,
            particleData.offset.pos.y,
            particleData.offset.pos.z,
            particleData.offset.rot.x,
            particleData.offset.rot.y,
            particleData.offset.rot.z,
            boneIndex,
            1.0,
            false,
            false,
            false
        )

        if color then
            local handle = particleHandlesByPlayerId[playerServerId]

            SetParticleFxLoopedAlpha(handle, color.A)
            SetParticleFxLoopedColour(
                handle,
                color.R / 255,
                color.G / 255,
                color.B / 255,
                false
            )
        end

        return
    end

    local handle = particleHandlesByPlayerId[playerServerId]
    if handle then
        StopParticleFxLooped(handle, false)
        particleHandlesByPlayerId[playerServerId] = nil
    end

    RemoveNamedPtfxAsset(particleData.dict)
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function handleStepperExit(exitDict, exitName, exitTime, label, animMap, propEntity)
    if not propEntity then
        return
    end

    if isExiting or isCompleted then
        return
    end

    ClearCycle("STEPPER")
    isExiting = true

    local playerPed = PlayerPedId()

    TriggerEvent("rcore_prison:client:despawnEntity", propEntity)

    if DoesEntityExist(propEntity) then
        DeleteEntity(propEntity)
    end

    Jobs.Entity = nil

    HelpKeys.Hide()

    TaskPlayAnim(
        playerPed,
        exitDict,
        exitName,
        8.0,
        -8.0,
        exitTime,
        0,
        0.0,
        0,
        0,
        0
    )

    if exitTime and exitTime > 0 then
        Wait(exitTime)
    end

    actionRequested = false
    FreezeEntityPosition(playerPed, false)
    ClearPedTasksImmediately(playerPed)

    cleanupAnimDicts(animMap)

    TASK_PROCESSING_STEPPER = false
    isExiting = false
    ActionState = false

    if not isCompleted and finishCallback then
        finishCallback(false, propEntity)
    end

    DebugRecordStep(Jobs.MinigameType, "Exit task")
    showJobExitHelp()
end

function HandleStepperFinish(percentIncrease, repetitions, totalDuration, label, propEntity, useMinigame)
    local passedMinigame = false

    if useMinigame then
        passedMinigame = HandleStepperMinigame()
    end

    if passedMinigame or not useMinigame then
        for _ = 1, repetitions do
            Wait(totalDuration / repetitions)
            progress = progress + percentIncrease
        end

        if next(Jobs.entities) then
            for _, entity in pairs(Jobs.entities) do
                if DoesEntityExist(entity) then
                    local visibleAlpha = math.floor(255 * (progress / 100))
                    local fadedAlpha = 255 - visibleAlpha
                    SetEntityAlpha(entity, fadedAlpha)
                end
            end
        end
    end

    if progress < 99 then
        return
    end

    ClearCycle("STEPPER")

    if finishCallback then
        finishCallback(true, propEntity)
    end

    isCompleted = true
    progress = 0
    TASK_PROCESSING_STEPPER = false

    TriggerEvent("rcore_prison:client:despawnEntity", propEntity)

    if DoesEntityExist(propEntity) then
        DetachEntity(propEntity, true, true)
        DeleteEntity(propEntity)
    end

    Jobs.Entity = nil

    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())
    HelpKeys.Hide()

    DebugRecordStep(Jobs.MinigameType, "Finished task")

    SetTimeout(2000, function()
        isCompleted = false
    end)
end

function StartStepper(stepperConfig)
    if TASK_PROCESSING_STEPPER then
        error("Task is already processing")
    end

    TASK_PROCESSING_STEPPER = true

    local animMap = stepperConfig.animMap
    local skillMap = stepperConfig.skillMap
    local label = stepperConfig.label

    if not animMap then
        TASK_PROCESSING_STEPPER = false
        error("Animation list is empty")
    end

    if not skillMap then
        TASK_PROCESSING_STEPPER = false
        error("Skill map is empty")
    end

    if not label then
        TASK_PROCESSING_STEPPER = false
        error("Stepper label is empty")
    end

    for _, animData in pairs(animMap) do
        LoadAnimDict(animData.dict)
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    FreezeEntityPosition(playerPed, true)
    SetEntityHeading(playerPed, playerHeading)

    local propEntity = nil

    if stepperConfig.prop and stepperConfig.prop.model then
        local model = stepperConfig.prop.model
        local spawnCoords = playerCoords + vec3(0, 0, -1.0)
        local networked = resolvePropNetworkState(model)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        propEntity = CreateObject(
            model,
            spawnCoords.x,
            spawnCoords.y,
            spawnCoords.z,
            networked,
            true,
            true
        )

        SetEntityHeading(propEntity, playerHeading)

        local boneIndex = GetPedBoneIndex(playerPed, stepperConfig.prop.hand or 57005)

        TriggerEvent("rcore_prison:client:spawnedEntity", {
            entity = propEntity,
            targetPed = playerPed,
            model = model,
            coords = spawnCoords,
            heading = playerHeading,
            boneIndex = boneIndex,
            offsets = {
                pos = stepperConfig.prop.offset.pos,
                rot = stepperConfig.prop.offset.rot,
            },
        })

        AttachEntityToEntity(
            propEntity,
            playerPed,
            boneIndex,
            stepperConfig.prop.offset.pos.x,
            stepperConfig.prop.offset.pos.y,
            stepperConfig.prop.offset.pos.z,
            stepperConfig.prop.offset.rot.x,
            stepperConfig.prop.offset.rot.y,
            stepperConfig.prop.offset.rot.z,
            true,
            true,
            true,
            false,
            1,
            true
        )

        SetModelAsNoLongerNeeded(model)
    end

    Jobs.Entity = propEntity

    TaskPlayAnim(
        playerPed,
        animMap.ENTER.dict,
        animMap.ENTER.name,
        8.0,
        -8.0,
        animMap.ENTER.time,
        0,
        0,
        0,
        0,
        0
    )

    showStepperHelp(label)

    local useMinigame = stepperConfig.minigame and stepperConfig.minigame.enabled or false

    dbg.debug("Stepper started -> awaiting user input.")

    SetCycle("STEPPER", 0, function()
        progress = math.min(progress, 100)

        if isCompleted then
            return
        end

        if progress > 99 then
            handleStepperExit(
                animMap.EXIT.dict,
                animMap.EXIT.name,
                animMap.EXIT.time,
                label,
                animMap,
                propEntity
            )
            return
        end

        if isExiting then
            return
        end

        TaskPlayAnim(
            playerPed,
            animMap.IDLE.dict,
            animMap.IDLE.name,
            8.0,
            -8.0,
            -1,
            0,
            0,
            0,
            0,
            0
        )

        if actionRequested then
            handlePTFX(true, stepperConfig.particles)

            TaskPlayAnim(
                playerPed,
                animMap.ACTION.dict,
                animMap.ACTION.name,
                8.0,
                -8.0,
                animMap.ACTION.time,
                animMap.ACTION.flag or 0,
                0,
                0,
                0,
                0
            )

            Wait(animMap.ACTION.time)

            handlePTFX(false, stepperConfig.particles)

            HandleStepperFinish(
                skillMap.action.percentIncrease,
                skillMap.action.time,
                skillMap.action.time - 70,
                label,
                propEntity,
                useMinigame
            )

            if not isCompleted then
                showStepperHelp(label)
            end

            actionRequested = false
            return
        end

        if stopRequested then
            ClearCycle("STEPPER")
            actionRequested = false
            stopRequested = false

            handleStepperExit(
                animMap.EXIT.dict,
                animMap.EXIT.name,
                animMap.EXIT.time,
                label,
                animMap,
                propEntity
            )
            return
        end

        Wait(100)
    end)
end

function StopStepper()
    if actionRequested then
        return
    end

    if progress > 99 then
        return
    end

    actionRequested = false
    stopRequested = true
    ClearCycle("STEPPER")
end

function DoStepper()
    if not TASK_PROCESSING_STEPPER then
        return
    end

    if not actionRequested and progress <= 99 then
        actionRequested = true
    end
end

RegisterKey(
    DoStepper,
    "START_STEPPER",
    "Start stepper",
    Config.PrisonJobs.Stepper.DoTask
)

RegisterKey(
    StopStepper,
    "STOP_STEPPER",
    "Stop stepper",
    Config.PrisonJobs.Stepper.StopTask
)