JobService = {}

local function getJobStorage()
    return Object.getStorage(STORAGE_JOBS)
end

function JobService.RegisterInit()
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    if not SH.data then
        return
    end

    local jobs = SH.data.jobs
    if not jobs then
        return dbg.critical("Failed to load jobs on this map: %s", Config.Map)
    end

    for jobId, jobData in pairs(jobs) do
        local registered = storage.registerJob(jobData)
        if registered then
            dbg.debug("Job with ID [%s] registered named: %s", jobId, jobData.name)
        end
    end
end

function JobService.isPlayerInJob(source)
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    local identifier = Framework.getIdentifier(source)
    return storage.isPlayerInJob(identifier)
end

function JobService.RequestJob(source, jobId)
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    if not jobId then
        dbg.error("Invalid job ID [%s]", jobId)
        return
    end

    local jobData = SH.data.jobs[jobId]
    if not jobData then
        return
    end

    local isInJob, isInCooldown = JobService.isPlayerInJob(source)
    if isInJob then
        if isInCooldown then
            return Framework.sendNotification(source, _U("JOB.IN_ACTIVE_SESSION_COOLDOWN"), "error")
        end

        return Framework.sendNotification(source, _U("JOB.IN_ACTIVE_SESSION_ACTIVE_JOB"), "error")
    end

    local jobPool = storage.getJobPool(jobData.name)
    local poolSize = table.size(jobPool)
    local jobType = jobData.type
    local pointCount = #jobData.points
    local requiredDelivery = storage.getRequiredDelivery(jobType) or 0
    local requiredPoints = (poolSize + 1) * requiredDelivery

    if jobType == JOBS.COOK and Config.Map == "gabz" then
        requiredPoints = 1
    end

    dbg.debug(
        "Pool size: %s, Job points: %s, Required delivery: %s | %s",
        poolSize,
        pointCount,
        requiredDelivery,
        requiredPoints
    )

    if pointCount < requiredPoints then
        return Framework.sendNotification(source, _U("JOB.CURRENT_JOB_NOT_FREE_SPACE"), "error")
    end

    storage.registerPlayerIntoJob(source, jobId)
end

function JobService.UnregisterPlayer(source)
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    storage.unregisterPlayer(source)
end

function JobService.FinishJobTask(source, taskIndex, payload)
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    if not taskIndex then
        return
    end

    storage.finishJobTask(source, taskIndex, payload)
end

function JobService.LeaveJobTask(source, taskIndex, payload, wasCanceled)
    local storage = getJobStorage()
    if not storage then
        return dbg.error("Job storage not found")
    end

    if not taskIndex then
        return
    end

    storage.LeaveJobTask(source, taskIndex, payload, wasCanceled)
end

function JobService.GetReward(source, baseReward)
    Framework.sendNotification(source, _U("JOB.IN_ACTIVE_SESSION_FINISHED"), "success")

    dbg.debug(
        "Prison Jobs: Player named %s (%s) finished job get him reward [%s]",
        GetPlayerName(source),
        source,
        baseReward
    )

    local identifier = Framework.getIdentifier(source)

    for _, reward in pairs(Config.PrisonJobs.Rewards) do
        if reward.type == "ITEM" then
            pcall(function()
                return Inventory.addMultipleItems(source, reward.list)
            end)
        end

        if reward.type == "CREDITS" then
            local creditReward = math.random(reward.min, reward.max)

            AccountLogService.RegisterTransaction(
                _U("JOB.REWARD_LOG_TITLE"),
                _U("JOB.REWARD_LOG_DESC", creditReward),
                identifier,
                creditReward
            )

            PrisonAccountService.AddCredits(source, creditReward, "PRISON_JOB_REWARD")
        end

        if reward.type == "REDUCE_SENTENCE" then
            reward.value = reward.value or 5
            JobService.ReduceSentenceTime(source, reward.value)
        end
    end
end

function JobService.ReduceSentenceTime(source, minutes)
    local prisoner = PrisonService.getPlayer(source)
    if not prisoner then
        return
    end

    minutes = minutes or 5

    local identifier = Framework.getIdentifier(source)
    local currentSentence = prisoner.jail_time
    local reducedTime = Time.ConvertTimeFromSeconds(minutes, Config.Time)
    local newSentence = currentSentence - reducedTime

    if newSentence < 0 then
        newSentence = 1
    end

    PrisonService.EditSentenceWithConvertedTime(identifier, newSentence, source)
end
