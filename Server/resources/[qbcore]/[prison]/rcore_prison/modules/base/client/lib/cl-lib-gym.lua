local GYM = {}

local exerciseProgress = 0
TASK_ACTIVE_EXERCISE = false
TASK_INACTIVE_STATE = false
TASK_PROCESSING = false
isExit = false

local Exercises = {
    [EXERCISE_MAP.CRANKS] = {
        ENTER = {
            dict = "amb@world_human_push_ups@male@enter",
            name = "enter",
            time = 3050
        },
        IDLE = {
            dict = "amb@world_human_push_ups@male@idle_a",
            name = "idle_c"
        },
        ACTION = {
            dict = "amb@world_human_push_ups@male@base",
            name = "base",
            time = 1100
        },
        EXIT = {
            dict = "amb@world_human_push_ups@male@exit",
            name = "exit",
            time = 3400
        }
    },

    [EXERCISE_MAP.SITUPS] = {
        ENTER = {
            dict = "amb@world_human_sit_ups@male@enter",
            name = "enter",
            time = 4200
        },
        IDLE = {
            dict = "amb@world_human_sit_ups@male@idle_a",
            name = "idle_a"
        },
        ACTION = {
            dict = "amb@world_human_sit_ups@male@base",
            name = "base",
            time = 3400
        },
        EXIT = {
            dict = "amb@world_human_sit_ups@male@exit",
            name = "exit",
            time = 3700
        }
    },

    [EXERCISE_MAP.MUSLECHIN] = {
        ENTER = {
            dict = "amb@prop_human_muscle_chin_ups@male@enter",
            name = "enter",
            time = 1600
        },
        IDLE = {
            dict = "amb@prop_human_muscle_chin_ups@male@idle_a",
            name = "idle_a"
        },
        ACTION = {
            dict = "amb@prop_human_muscle_chin_ups@male@base",
            name = "base",
            time = 3000
        },
        EXIT = {
            dict = "amb@prop_human_muscle_chin_ups@male@exit",
            name = "exit",
            time = 3700
        }
    }
}

function StopExercise()
    if TASK_ACTIVE_EXERCISE then
        return
    end

    if exerciseProgress <= 99 then
        TASK_ACTIVE_EXERCISE = false
        TASK_INACTIVE_STATE = true
        ClearCycle("exercise")
    end
end

function DoExercise()
    if not TASK_PROCESSING then
        return
    end

    if not TASK_ACTIVE_EXERCISE and exerciseProgress <= 99 then
        TASK_ACTIVE_EXERCISE = true
    end
end

RegisterKey(
    DoExercise,
    "A",
    "A",
    Config.GYM.DoExerciseKey
)

RegisterKey(
    StopExercise,
    "B",
    "B",
    Config.GYM.StopExerciseKey
)

local handlingMultiplier = 1.0

function HandlingTask()
    if handlingMultiplier <= 1.6 then
        handlingMultiplier = handlingMultiplier + 0.1
    end
end

RegisterKey(HandlingTask, "A", "A", "E")

function startExercise()
    if TASK_PROCESSING then
        return
    end

    ClearPedTasksImmediately(PlayerPedId())
    TriggerEvent("rcore_prison:gymStartExercise", MyServerId, SH.zoneId)
end

RegisterNetEvent("rcore_prison:gymStartExercise", function(playerId, zoneId)
    if playerId ~= MyServerId then
        return
    end

    TASK_PROCESSING = true

    local ped = PlayerPedId()
    local interactionData = SH.data.interaction[zoneId]
    if not interactionData then
        return
    end

    local exerciseType = interactionData.exercise
    local exerciseData = Exercises[exerciseType]
    local coords = interactionData.coords
    local skillData = Config.GYM.SkillMap[exerciseType]

    for _, animData in pairs(exerciseData) do
        LoadAnimDict(animData.dict)
    end

    local placeModel = nil
    local placeEntity = nil

    if interactionData.place and interactionData.place.model then
        placeModel = interactionData.place.model
    end

    if placeModel then
        placeEntity = GetClosestObjectOfType(
            coords.x,
            coords.y,
            coords.z,
            1.0,
            placeModel,
            false,
            false,
            false
        )
    end

    local heading = 0.0
    if placeEntity then
        heading = GetEntityHeading(placeEntity)
        coords = GetEntityCoords(placeEntity)
    end

    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, coords)
    SetEntityHeading(ped, heading)

    TaskPlayAnim(
        ped,
        exerciseData.ENTER.dict,
        exerciseData.ENTER.name,
        8.0,
        -8.0,
        exerciseData.ENTER.time,
        0,
        0,
        0,
        0,
        0
    )

    HelpKeys.Show({
        {
            label = _U("GYM.HELPKEY_EXERCISE_LABEL", exerciseType),
            keyName = ""
        },
        {
            label = _U("GYM.HELPKEY_EXERCISE_PROGRESS_LABEL", exerciseProgress) .. "%",
            keyName = ""
        },
        {
            label = _U("GYM.HELPKEY_EXERCISE_DO_LABEL"),
            keyName = Config.GYM.DoExerciseKey
        },
        {
            label = _U("GYM.HELPKEY_EXERCISE_EXIT"),
            keyName = Config.GYM.StopExerciseKey
        }
    }, "top-left")

    SetCycle("exercise", 0, function()
        if exerciseProgress > 100 then
            exerciseProgress = 100
        end

        if exerciseProgress > 99 then
            StopTraining(
                exerciseData.EXIT.dict,
                exerciseData.EXIT.name,
                exerciseData.EXIT.time,
                exerciseType
            )
            return
        end

        if isExit then
            return
        end

        TaskPlayAnim(
            ped,
            exerciseData.IDLE.dict,
            exerciseData.IDLE.name,
            8.0,
            -8.0,
            -1,
            0,
            0,
            0,
            0,
            0
        )

        if TASK_ACTIVE_EXERCISE then
            TaskPlayAnim(
                ped,
                exerciseData.ACTION.dict,
                exerciseData.ACTION.name,
                8.0,
                -8.0,
                exerciseData.ACTION.time,
                0,
                0,
                0,
                0,
                0
            )

            IncreaseStats(
                skillData.action.percentIncrease,
                skillData.action.time,
                exerciseData.ACTION.time - 70,
                exerciseType
            )

            HelpKeys.Show({
                {
                    label = _U("GYM.HELPKEY_EXERCISE_LABEL", exerciseType),
                    keyName = ""
                },
                {
                    label = _U("GYM.HELPKEY_EXERCISE_PROGRESS_LABEL", exerciseProgress) .. "%",
                    keyName = ""
                },
                {
                    label = _U("GYM.HELPKEY_EXERCISE_DO_LABEL"),
                    keyName = Config.GYM.DoExerciseKey
                },
                {
                    label = _U("GYM.HELPKEY_EXERCISE_EXIT"),
                    keyName = Config.GYM.StopExerciseKey
                }
            }, "top-left")

            TASK_ACTIVE_EXERCISE = false
            return
        end

        if TASK_INACTIVE_STATE then
            ClearCycle("exercise")
            TASK_ACTIVE_EXERCISE = false
            TASK_INACTIVE_STATE = false

            StopTraining(
                exerciseData.EXIT.dict,
                exerciseData.EXIT.name,
                exerciseData.EXIT.time,
                exerciseType
            )
            return
        end

        Wait(100)
    end)
end)

function StopTraining(animDict, animName, animTime, exerciseType)
    if isExit then
        return
    end

    isExit = true

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local _, groundZ = GetGroundZFor_3dCoord(pedCoords.x, pedCoords.y, pedCoords.z, true)
    local groundCoords = vec3(pedCoords.x, pedCoords.y, groundZ)
    local forwardVector = GetEntityForwardVector(ped)
    local targetCoords = groundCoords - (forwardVector / 0.8)

    local shouldWaitForExitAnim = false

    if exerciseType == EXERCISE_MAP.SITUPS then
        SetEntityCoords(ped, targetCoords)
    else
        shouldWaitForExitAnim = true
    end

    HelpKeys.Hide()
    ClearCycle("exercise")

    TaskPlayAnim(
        ped,
        animDict,
        animName,
        8.0,
        -8.0,
        animTime,
        0,
        0.0,
        0,
        0,
        0
    )

    exerciseProgress = 0

    if not shouldWaitForExitAnim then
        Wait(animTime)
    end

    TASK_ACTIVE_EXERCISE = false
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)

    for _, animData in pairs(Exercises[exerciseType]) do
        RemoveAnimDict(animData.dict)
    end

    TASK_PROCESSING = false

    SetTimeout(1500, function()
        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(ped)

        isExit = false
        ActionState = false

        TriggerServerEvent("rcore_prison:unregisterGymPlace", SH.zoneId)
        SH.zoneId = nil
    end)
end

function IncreaseStats(percentIncrease, repeatCount, totalDuration, exerciseType)
    for _ = 1, repeatCount do
        Wait(totalDuration / repeatCount)
        exerciseProgress = exerciseProgress + percentIncrease
    end

    if exerciseProgress >= 99 then
        ReceiveExerciseStats(exerciseType)
    end
end

function LoadAnimDict(animDict)
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end