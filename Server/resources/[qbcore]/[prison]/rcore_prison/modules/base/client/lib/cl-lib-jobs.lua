local leaveJobBypassDialog = false

local initialJobSubtitles = {
    [JOBS.ELECTRICIAN] = _U("JOB.ELECTRICIAN_SUBTITLES_INIT_STATE_LABEL"),
    [JOBS.COOK] = _U("JOB.COOKING_SUBTITLES_INIT_STATE_LABEL"),
    [JOBS.CLEAN_GROUND] = _U("JOB.CLEAN_GROUND_SUBTITLES_INIT_STATE_LABEL"),
    [JOBS.JANITOR] = _U("JOB.JANITOR_SUBTITLES_INIT_STATE_LABEL"),
    [JOBS.BUSH_TRIMMING] = _U("JOB.BUSHES_SUBTITLES_INIT_STATE_LABEL"),
    [JOBS.GARDENER] = _U("JOB.GARDENER_SUBTITLES_INIT_STATE_LABEL")
}

Jobs = {
    ActiveMinigame = false,
    ActiveJob = false,
    jobId = nil,
    locationId = nil,
    zoneName = nil,
    inZone = false,
    currentZone = nil,
    entities = {}
}

local function showStopJobHelp()
    HelpKeys.Show({
        {
            label = _U("JOB.STOP_CURRENT_JOB_LABEL"),
            keyName = Config.PrisonJobs.LeaveJobKey
        }
    }, "top-left")
end

local function showZoneJobHelp()
    HelpKeys.Show({
        {
            label = _U("JOB.STOP_CURRENT_JOB_LABEL"),
            keyName = Config.PrisonJobs.LeaveJobKey
        },
        {
            label = _U("JOB.START_TASK_LABEL"),
            keyName = Config.PrisonJobs.DoJobKey
        }
    }, "top-left")
end

local function clearSpawnedJobEntities()
    if Jobs.entities and next(Jobs.entities) then
        for _, entity in pairs(Jobs.entities) do
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
                SetEntityDrawOutline(entity, false)
            end
        end

        Jobs.entities = {}
    end
end

local function buildTaskCallback(ped, locationId, zoneName, jobId)
    return function(success)
        if success then
            Jobs.FinishedTask(ped, locationId, zoneName, jobId)
        else
            Jobs.FailedTask(ped, locationId, zoneName, jobId)
        end
    end
end

function Jobs.Init(jobId, locationId, extraData)
    dbg.debug("Job %s started! %s ", jobId, locationId)

    local jobData = SH.data.jobs[jobId]
    if not jobData then
        return
    end

    local pointData = jobData.points[locationId]
    if not pointData then
        return
    end

    local taskCoords = vec3(pointData.pos.x, pointData.pos.y, pointData.pos.z)
    local heading = pointData.pos.w or 0.0
    local zoneName = jobData.name
    local jobType = jobData.type

    Subtitles.Show(initialJobSubtitles[jobType])

    Jobs.ActiveJob = true
    Jobs.jobId = jobId
    Jobs.locationId = locationId
    Jobs.zoneName = zoneName
    Jobs.extra = extraData

    Blips.Create({
        name = _U("JOB.TASK_BLIP_AREA_NAME"),
        sprite = 164,
        color = 4,
        scale = 1.3,
        coords = taskCoords,
        type = "JOB"
    })

    showStopJobHelp()

    if jobType == JOBS.CLEAN_GROUND then
        local radius = 0.05
        local amount = math.random(2, 4)
        local positions = generateCirclePositions(taskCoords, radius, amount)
        local leafModels = {
            { name = "rcore_leafes_large" },
            { name = "rcore_leafes_medium" },
            { name = "rcore_leafes_small" }
        }

        for _, position in ipairs(positions) do
            local leafData = leafModels[math.random(1, #leafModels)]
            local entity = Entity.SpawnPropAtCoords({
                coords = position,
                heading = heading,
                model = leafData.name
            })

            table.insert(Jobs.entities, entity)
        end
    elseif jobType == JOBS.BUSH_TRIMMING then
        local radius = 1.0
        local amount = math.random(2, 3)
        local positions = generateCirclePositions(taskCoords, radius, amount)

        for _, position in ipairs(positions) do
            local entity = Entity.SpawnPropAtCoords({
                coords = position,
                heading = heading,
                model = "prop_veg_crop_04_leaf"
            })

            table.insert(Jobs.entities, entity)
        end
    end

    if Interact.Type == "ZONE" then
        local zone = CreateCOMSZone()
        local comsZoneId = ("%s_%s_%s"):format(zoneName, locationId, MyServerId)

        zone.setId(comsZoneId)
        zone.setType(1)
        zone.setPosition(vec3(taskCoords.x, taskCoords.y, taskCoords.z - 1.0))
        zone.setRenderMarker(true)
        zone.setInRadius(Config.PrisonJobs.InRadius)
        zone.setRenderDistance(Config.PrisonJobs.RenderInteractZoneDistance)

        zone.on("leave", function()
            if not Jobs.inZone then
                return
            end

            Jobs.inZone = false
            dbg.debug("You leave job place.", comsZoneId)
            showStopJobHelp()
        end)

        zone.on("enter", function()
            if Jobs.inZone then
                return
            end

            Jobs.inZone = true
            dbg.debug("You entered job place.", comsZoneId)
            showZoneJobHelp()
        end)

        zone.render()
        Jobs.currentZone = zone
    else
        CreateTargetZone(
            taskCoords,
            1,
            1,
            heading,
            {
                {
                    num = 1,
                    type = "client",
                    icon = "",
                    label = zoneName,
                    targeticon = "",
                    distance = 5.0,
                    onSelect = function()
                        Jobs.Minigame(jobType, locationId, zoneName, jobId, extraData)
                    end,
                    action = function()
                        Jobs.Minigame(jobType, locationId, zoneName, jobId, extraData)
                    end,
                    canInteract = function()
                        return Jobs.ActiveMinigame == false
                    end,
                    drawColor = { 255, 255, 255, 255 },
                    successDrawColor = { 30, 144, 255, 255 },
                    eventAction = "startTask",
                    color = 255
                }
            },
            zoneName,
            true
        )
    end
end

function Jobs.Minigame(jobType, locationId, zoneName, jobId, extraData)
    if Jobs.ActiveMinigame then
        return dbg.debug("Minigame is active?")
    end

    Subtitles.Hide()
    Jobs.ActiveMinigame = true

    if Jobs.currentZone then
        Jobs.currentZone.stopRender()
    end

    local ped = PlayerPedId()
    dbg.debug("Minigame type: %s", jobType)

    local minigameSettings = Config.PrisonJobs.Minigame or false
    Jobs.MinigameType = jobType
    StartDebugSession(Jobs.MinigameType)

    local taskCallback = buildTaskCallback(ped, locationId, zoneName, jobId)

    if jobType == JOBS.ELECTRICIAN then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

        Controller.LoadAndStart(
            (extraData and extraData.difficulty) or Config.Circuit.Difficulty,
            Config.Circuit.Lifes or 3,
            taskCallback
        )

        return
    end

    if jobType == JOBS.COOK then
        Subtitles.Show(_U("JOB.COOKING_SUBTITLES_ACTIVE_COOKING_LABEL"))

        Stepper.LoadAndStart({
            minigame = {
                enabled = minigameSettings and minigameSettings.Cooking or false
            },
            label = _U("JOB.COOKING_HELPKEYS_TASK_LABEL"),
            prop = {
                model = "prop_fish_slice_01",
                offset = {
                    pos = vec3(0.08, 0.0, -0.02),
                    rot = vec3(0.0, -25.0, 130.0)
                }
            },
            animMap = {
                ENTER = {
                    dict = "amb@prop_human_bbq@male@enter",
                    name = "enter",
                    time = 3050
                },
                IDLE = {
                    dict = "amb@prop_human_bbq@male@idle_a",
                    name = "idle_a"
                },
                ACTION = {
                    dict = "amb@prop_human_bbq@male@base",
                    name = "base",
                    time = 2500
                },
                EXIT = {
                    dict = "amb@prop_human_bbq@male@exit",
                    name = "exit",
                    time = 3400
                }
            },
            skillMap = {
                action = {
                    percentIncrease = math.random(10, 20),
                    time = 4
                }
            }
        }, taskCallback)

        return
    end

    if jobType == JOBS.BUSH_TRIMMING then
        Stepper.LoadAndStart({
            minigame = {
                enabled = minigameSettings and minigameSettings.BushTrimming or false
            },
            label = _U("JOB.BUSHES_DESCRIPTION"),
            prop = {
                hand = 28422,
                model = "prop_hedge_trimmer_01",
                offset = {
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0)
                }
            },
            particles = {
                dict = "scr_armenian3",
                name = "ent_anim_leaf_blower",
                boneId = 28422,
                offset = {
                    pos = vec3(1.0, 0.0, -0.1),
                    rot = vec3(0.0, 0.0, 0.0)
                }
            },
            animMap = {
                ENTER = {
                    dict = "amb@prop_human_bbq@male@enter",
                    name = "enter",
                    time = 3050
                },
                IDLE = {
                    dict = "amb@world_human_gardener_leaf_blower@idle_a",
                    name = "idle_a"
                },
                ACTION = {
                    dict = "amb@world_human_gardener_leaf_blower@base",
                    name = "base",
                    time = 3500
                },
                EXIT = {
                    dict = "amb@prop_human_bbq@male@exit",
                    name = "exit",
                    time = 3400
                }
            },
            skillMap = {
                action = {
                    percentIncrease = 20,
                    time = 4
                }
            }
        }, taskCallback)

        return
    end

    if jobType == JOBS.JANITOR then
        dbg.debug("started janitor task!")

        Stepper.LoadAndStart({
            minigame = {
                enabled = minigameSettings and minigameSettings.Janitor or false
            },
            label = _U("JOB.JANITOR_TITLE"),
            prop = {
                hand = 28422,
                model = "prop_tool_broom",
                offset = {
                    pos = vec3(0.0, 0.08, 0.0),
                    rot = vec3(0.0, 0.0, 0.0)
                }
            },
            animMap = {
                ENTER = {
                    dict = "amb@prop_human_bbq@male@enter",
                    name = "enter",
                    time = 3050
                },
                IDLE = {
                    dict = "anim@amb@drug_field_workers@rake@male_a@base",
                    name = "base"
                },
                ACTION = {
                    dict = "anim@amb@drug_field_workers@rake@male_a@idles",
                    name = "idle_b",
                    time = 3500
                },
                EXIT = {
                    dict = "amb@prop_human_bbq@male@exit",
                    name = "exit",
                    time = 3400
                }
            },
            skillMap = {
                action = {
                    percentIncrease = math.random(10, 20),
                    time = 4
                }
            }
        }, taskCallback)

        return
    end

    if jobType == JOBS.CLEAN_GROUND then
        Subtitles.Show(_U("JOB.CLEAN_GROUND_SUBTITLES_ACTIVE_STATE_LABEL"))

        Stepper.LoadAndStart({
            minigame = {
                enabled = minigameSettings and minigameSettings.CleanGround or false
            },
            label = _U("JOB.CLEAR_YARD_TITLE"),
            prop = {
                hand = 57005,
                model = "prop_leaf_blower_01",
                offset = {
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0)
                }
            },
            particles = {
                dict = "scr_armenian3",
                name = "ent_anim_leaf_blower",
                boneId = 28422,
                offset = {
                    pos = vec3(1.0, 0.0, -0.25),
                    rot = vec3(0.0, 0.0, 0.0)
                }
            },
            animMap = {
                ENTER = {
                    dict = "amb@prop_human_bbq@male@enter",
                    name = "enter",
                    time = 3050
                },
                IDLE = {
                    dict = "amb@world_human_gardener_leaf_blower@idle_a",
                    name = "idle_a"
                },
                ACTION = {
                    dict = "amb@world_human_gardener_leaf_blower@base",
                    name = "base",
                    time = 3500
                },
                EXIT = {
                    dict = "amb@prop_human_bbq@male@exit",
                    name = "exit",
                    time = 3400
                }
            },
            skillMap = {
                action = {
                    percentIncrease = math.random(10, 20),
                    time = 4
                }
            }
        }, taskCallback)

        return
    end

    Jobs.ActiveMinigame = false
    dbg.debug("Minigame type not found!")
end

function Jobs.FinishedTask(ped, locationId, zoneName, jobId)
    local minigameType = Jobs.MinigameType

    Jobs.ActiveJob = false
    Jobs.ActiveMinigame = false
    Jobs.inZone = false

    clearSpawnedJobEntities()

    DebugRecordStep(minigameType, "Finished job in total")
    Jobs.MinigameType = nil

    ClearPedTasks(ped)
    RemoveTargetZone(zoneName, jobId)
    RemoveTargetEntityHiglight()
    Subtitles.Hide()
    HelpKeys.Hide()
    Blips.RemoveByType("JOB")
    FreezePlayer(PlayerId(), false)
    FreezeEntityPosition(ped, false)

    dbg.debug("Job %s finished! %s", jobId, locationId)
    TriggerServerEvent("rcore_prison:server:finishJobTask", jobId, locationId)

    DestroyDebugSession(minigameType)
end

function Jobs.FailedTask(ped, locationId, zoneName, jobId)
    if not Jobs.ActiveJob then
        return
    end

    if Jobs.currentZone then
        SetTimeout(100, function()
            showZoneJobHelp()
        end)

        Jobs.currentZone.render()
        ClearPedTasksImmediately(ped)
    end

    ClearPedTasksImmediately(ped)
    RemoveTargetEntityHiglight()
    Subtitles.Hide()

    DebugRecordStep(Jobs.MinigameType, "Exit task")

    Jobs.ActiveMinigame = false

    FreezePlayer(PlayerId(), false)
    FreezeEntityPosition(ped, false)

    dbg.debug("Job %s failed! %s ", jobId, locationId)
end

NetworkService.EventListener("heartbeat", function(eventName)
    if eventName ~= HEARTBEAT_EVENTS.PRISONER_RELEASED then
        return
    end

    StopStepper()
    Jobs.ExitJob()

    clearSpawnedJobEntities()

    if Jobs.Entity and DoesEntityExist(Jobs.Entity) then
        DeleteEntity(Jobs.Entity)
        DetachEntity(Jobs.Entity, false, false)
        Jobs.Entity = nil
        ClearPedTasksImmediately(PlayerPedId())
    end

    dbg.debug("Found active job on citizen, stopping and clearing props.")
end)

function Jobs.ExitJob(forceExit)
    local minigameType = Jobs.MinigameType

    Dialog.Hide()

    if Jobs.currentZone then
        Jobs.currentZone.stopRender()
    end

    RemoveTargetZone(Jobs.zoneName, Jobs.locationId)
    RemoveTargetEntityHiglight()

    TriggerServerEvent(
        "rcore_prison:server:leaveJobTask",
        Jobs.jobId,
        Jobs.locationId,
        forceExit
    )

    Jobs.MinigameType = nil
    Jobs.ActiveJob = false
    Jobs.ActiveMinigame = false
    Jobs.jobId = nil
    Jobs.locationId = nil
    Jobs.inZone = false
    Jobs.extra = nil
    Jobs.currentZone = nil

    Blips.RemoveByType("JOB")
    Subtitles.Hide()
    HelpKeys.Hide()
    FreezePlayer(PlayerId(), false)

    SetTimeout(1000, function()
        HelpKeys.Hide()
    end)

    Wait(1000)
    DestroyDebugSession(minigameType)
end

function Jobs.HandleKeypress()
    dbg.debug("Job keypress state: %s %s", Jobs.inZone, Jobs.ActiveJob)

    if Jobs.inZone and Jobs.ActiveJob then
        local jobData = SH.data.jobs[Jobs.jobId]
        if not jobData then
            return dbg.debug("Not job found")
        end

        dbg.debug("Starting job minigame!")

        Jobs.Minigame(
            jobData.type,
            Jobs.locationId,
            Jobs.zoneName,
            Jobs.jobId,
            Jobs.extra
        )
    end

    Wait(1000)
end

function Jobs.LeaveCurrentJob()
    if not Jobs.ActiveJob then
        return
    end

    if TASK_PROCESSING_STEPPER then
        return
    end

    if Jobs.ActiveMinigame then
        return
    end

    if leaveJobBypassDialog then
        leaveJobBypassDialog = false
        Jobs.ExitJob()
        return
    end

    Dialog.Show(
        _U("JOB.LEAVE_JOB_DIALOG"),
        _U("JOB.LEAVE_JOB_DIALOG_DESC"),
        function(confirmed)
            if confirmed then
                Jobs.ExitJob()
            else
                Dialog.Hide()
            end
        end
    )
end

RegisterKey(
    Jobs.LeaveCurrentJob,
    "PRISON_JOBS_LEAVE",
    _U("KEYS.JOB_LEAVE_DSC"),
    Config.PrisonJobs.LeaveJobKey
)

RegisterKey(
    Jobs.HandleKeypress,
    "PRISON_START_TASK",
    _U("KEYS.JOB_LEAVE_DSC"),
    Config.PrisonJobs.DoJobKey
)