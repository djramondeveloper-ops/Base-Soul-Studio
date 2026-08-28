--- Third-party job integration providers
--- Each provider can hook into job changes (e.g. remove old job, sync new job)
---@type { resource: string, onBeforeJobChange?: fun(client: number, identifier: string, currentJob: table, newJobName: string), onAfterJobChange?: fun(client: number, identifier: string, newJobName: string) }[]
local JobProviders = {
    {
        resource = "cs_multijob",
        onBeforeJobChange = function(client, identifier, currentJob, newJobName)
            if not identifier or not currentJob then return end

            TriggerEvent("cs:multijob:removeJob", identifier, currentJob.name)
        end,
    },
}

--- Event names fired for each phase, so customers can hook into job changes
local JobPhaseEvents = {
    onBeforeJobChange = "rcore_prison:server:onBeforeJobChange",
    onAfterJobChange  = "rcore_prison:server:onAfterJobChange",
}

--- Run provider hooks and fire the corresponding rcore event for a phase
---@param phase "onBeforeJobChange"|"onAfterJobChange"
local function RunJobProviders(phase, ...)
    for _, provider in ipairs(JobProviders) do
        if isResourcePresentProvideless(provider.resource) and type(provider[phase]) == "function" then
            local ok, err = pcall(provider[phase], ...)

            if not ok then
                dbg.job("SetPlayerJob: provider '%s' error in %s: %s", provider.resource, phase, err)
            end
        end
    end

    if JobPhaseEvents[phase] then
        TriggerEvent(JobPhaseEvents[phase], ...)
    end
end

--- Set a player's job and fire the onJobChanged hook
---@param client number Player server ID
---@param jobName string Target job name
---@param gradeIndex? number Grade index (ESX only, defaults to 0)
local function SetPlayerJob(client, jobName, gradeIndex)
    local tag = PlayerTag(client)
    local currentJob = Framework.getJob(client)
    local identifier = Framework.getIdentifier(client)

    dbg.job("SetPlayerJob: %s setting job '%s' (grade: %s)", tag, jobName, gradeIndex or 0)

    RunJobProviders("onBeforeJobChange", client, identifier, currentJob, jobName)

    Framework.setJob(client, jobName, gradeIndex)

    RunJobProviders("onAfterJobChange", client, identifier, jobName)

    local newJob = Framework.getJob(client)
    local changed = newJob and newJob.name and newJob.name:lower() == jobName:lower()

    dbg.job("SetPlayerJob: %s result: %s", tag, changed and "success" or "failed")

    TriggerEvent("rcore_prison:server:onJobChanged", client, jobName, changed)
end

--- Remove a player's job and reset to default (unemployed)
---@param client number Player server ID
local function RemovePlayerJob(client)
    local defaultJob = Config.Prisoners.RemovePlayerSetDefaultJob or "unemployed"
    local defaultGradeIndex = Config.Prisoners.RemovePlayerSetDefaultGrade or 1

    SetPlayerJob(client, defaultJob, defaultGradeIndex)
end


--- Check if a player's current job should be removed when jailed
---@param playerId number Player server ID
---@return boolean
local function ShouldRemoveJob(playerId)
    local player = Framework.getPlayer(playerId)
    local playerJob = Framework.getJob(playerId)
    local jobName = playerJob and playerJob.name:lower()

    return player and jobName and Config.Prisoners.RemoveJobList[jobName] or false
end

NetworkService.EventListener("heartbeat", function(eventType, data)
    if eventType == HEARTBEAT_EVENTS.PRISONER_RELEASED then return end
    if not Config.Prisoners.RemovePlayerJobWhenJailed then return end

    local playerId = data.prisoner and data.prisoner.source

    if not playerId then return end

    if ShouldRemoveJob(playerId) then
        dbg.job("SetPlayerJob: %s removing job (prisoner jailed)", PlayerTag(playerId))
        RemovePlayerJob(playerId)
    else
        dbg.job("SetPlayerJob: %s job not in RemoveJobList, skipping", PlayerTag(playerId))
    end
end)
