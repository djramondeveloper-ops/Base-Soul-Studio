local createJobStorage

function createJobStorage()
  local storage = {}
  storage._sessions = {}

  RegisterCommand("prisonSessions", function(source)
    if source == 0 then
      tprint(storage._sessions)
    end
  end, false)

  function storage.registerJob(jobData)
    local jobName = jobData.name

    if not storage._sessions[jobName] then
      storage._sessions[jobName] = {
        pastJobs = {},
        players = {}
      }
    end

    return true
  end

  function storage.unregisterPlayer(playerId)
    local identifier = Framework.getIdentifier(playerId)
    if not identifier then
      return
    end

    if not next(storage._sessions) then
      return
    end

    for _, session in pairs(storage._sessions) do
      if session.players[identifier] then
        session.players[identifier] = nil
        dbg.debug("Unregistering player from job since left game!")
      end
    end
  end

  function storage.GetRandomPlaceIdx(jobName, jobData)
    local attempts = 10

    while attempts > 0 do
      local randomIndex = math.random(1, #jobData.points)
      local usedLocations = storage._sessions[jobName].pastJobs
      local locationKey = tostring(randomIndex)

      if not usedLocations[locationKey] then
        usedLocations[locationKey] = true
        return randomIndex
      end

      attempts = attempts - 1
    end

    return math.random(1, #jobData.points)
  end

  function storage.isPlayerInJob(identifier)
    local isInJob = false
    local hasCooldown = false

    for _, session in pairs(storage._sessions) do
      local playerSession = session.players[identifier]
      if playerSession then
        isInJob = true
        hasCooldown = playerSession.cooldown
      end
    end

    return isInJob, hasCooldown
  end

  function storage.getPlayerSession(jobName, identifier)
    local session = storage._sessions[jobName]
    if not session then
      return nil
    end

    return session.players[identifier]
  end

  function storage.getJobPool(jobName)
    local session = storage._sessions[jobName]
    if not session then
      return nil
    end

    return session.pastJobs
  end

  function storage.getRequiredDelivery(jobKey)
    local requiredDeliveries = Config.PrisonJobs.RequiredDelivery or 1

    if Config.PrisonJobs.SetCustomRequiredDeliveries then
      local customDeliveries = Config.PrisonJobs.RequiredDeliveries[jobKey]
      if customDeliveries then
        requiredDeliveries = customDeliveries
      end
    end

    return requiredDeliveries
  end

  function storage.LeaveJobTask(playerId, jobId, locationIdx, reason)
    if not jobId then
      return
    end

    local jobData = SH.data.jobs[jobId]
    if not jobData then
      return
    end

    local jobName = jobData.name
    local jobSession = storage._sessions[jobName]
    if not jobSession then
      return
    end

    local identifier = Framework.getIdentifier(playerId)
    local playerSession = storage.getPlayerSession(jobName, identifier)

    if not playerSession then
      return
    end

    if playerSession.locationIdx ~= locationIdx then
      return dbg.debug("Invalid location index")
    end

    local locationKey = tostring(locationIdx)
    if jobSession.pastJobs[locationKey] then
      jobSession.pastJobs[locationKey] = nil
    end

    playerSession.cooldown = true

    SetTimeout(Config.PrisonJobs.PlayerJobCoolDown * 60 * 1000, function()
      dbg.debug("Resetting job session for this player >> %s %s", identifier, GetPlayerName(playerId))

      local currentSession = storage._sessions[jobName]
      if not currentSession then
        return
      end

      if currentSession.players[identifier] then
        currentSession.players[identifier] = nil
      end
    end)

    if reason then
      local reasonLabel = _U(("MINIGAME_STATES.%s"):format(reason:upper()))

      dbg.debug("Player %s left the job session with reason: %s", GetPlayerName(playerId), reasonLabel)

      return Framework.sendNotification(
        playerId,
        _U("JOB.IN_ACTIVE_SESSION_LEFT_REASON", reasonLabel),
        "error"
      )
    end

    Framework.sendNotification(playerId, _U("JOB.IN_ACTIVE_SESSION_LEFT"), "error")
  end

  function storage.registerPlayerIntoJob(playerId, jobId)
    if not jobId then
      return
    end

    local jobData = SH.data.jobs[jobId]
    if not jobData then
      return
    end

    local jobName = jobData.name
    local jobType = jobData.type
    local jobSession = storage._sessions[jobName]
    if not jobSession then
      return
    end

    local identifier = Framework.getIdentifier(playerId)
    local locationIdx = storage.GetRandomPlaceIdx(jobName, jobData)

    jobSession.players[identifier] = {
      playerId = playerId,
      jobId = jobId,
      locationIdx = locationIdx,
      delivered = 0
    }

    if Config.PrisonJobs.Electrician.EachJobLevelIncreaseDifficulty and jobType == JOBS.ELECTRICIAN then
      jobSession.players[identifier].extra = {
        difficulty = Config.Circuit.Difficulty
      }
    end

    local pointData = jobData.points[locationIdx]
    if pointData and pointData.pos then
      StartClient(playerId, "SetWaypoint", pointData.pos)
    end

    StartClient(playerId, "startJob", jobId, locationIdx)
  end

  function storage.finishJobTask(playerId, jobId, locationIdx)
    if not jobId then
      return
    end

    local jobData = SH.data.jobs[jobId]
    if not jobData then
      return
    end

    local jobName = jobData.name
    local identifier = Framework.getIdentifier(playerId)
    local playerSession = storage.getPlayerSession(jobName, identifier)
    local jobType = jobData.type

    if not playerSession then
      return
    end

    if playerSession.locationIdx ~= locationIdx then
      return dbg.debug("Invalid location index")
    end

    playerSession.delivered = playerSession.delivered + 1

    if Config.PrisonJobs.Electrician.EachJobLevelIncreaseDifficulty and jobType == JOBS.ELECTRICIAN then
      if not playerSession.extra then
        return
      end

      if playerSession.extra.difficulty <= 6 then
        playerSession.extra.difficulty = playerSession.extra.difficulty + 1
      else
        playerSession.extra.difficulty = 1
      end
    end

    local requiredDeliveries = storage.getRequiredDelivery(jobType)

    if playerSession.delivered >= requiredDeliveries then
      SetTimeout(Config.PrisonJobs.ResetJobPoolCooldown * 60 * 1000, function()
        dbg.debug("Resetting job pool for this job >> %s with IDX: %s", jobName, locationIdx)

        local currentSession = storage._sessions[jobName]
        if not currentSession then
          return
        end

        currentSession.pastJobs[tostring(locationIdx)] = nil
      end)

      SetTimeout(Config.PrisonJobs.PlayerJobCoolDown * 60 * 1000, function()
        dbg.debug("Resetting job session for this player >> %s %s", identifier, GetPlayerName(playerId))

        local currentSession = storage._sessions[jobName]
        if not currentSession then
          return
        end

        if currentSession.players[identifier] then
          currentSession.players[identifier] = nil
        end
      end)

      playerSession.cooldown = true
      JobService.GetReward(playerId, jobId)
      return
    end

    SetTimeout(Config.PrisonJobs.ResetJobPoolCooldown * 60 * 1000, function()
      dbg.debug("Resetting job pool for this job >> %s with IDX: %s", jobName, locationIdx)

      local currentSession = storage._sessions[jobName]
      if not currentSession then
        return
      end

      currentSession.pastJobs[tostring(locationIdx)] = nil
    end)

    local nextLocationIdx = storage.GetRandomPlaceIdx(jobName, jobData)
    playerSession.locationIdx = nextLocationIdx

    Framework.sendNotification(
      playerId,
      _U("JOB.IN_ACTIVE_SESSION_DELIVERED", playerSession.delivered, storage.getRequiredDelivery(jobName)),
      "success"
    )

    local nextPointData = jobData.points[nextLocationIdx]
    if nextPointData and nextPointData.pos then
      StartClient(playerId, "SetWaypoint", nextPointData.pos)
    end

    StartClient(playerId, "startJob", jobId, nextLocationIdx, playerSession.extra)
  end

  return storage
end

JobStorage = createJobStorage
Object.registerStorage(STORAGE_JOBS, JobStorage())