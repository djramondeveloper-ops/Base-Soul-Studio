-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    local RanksAsBossList = Config.RanksAsBossList or {
        ['boss'] = true,
        ['chief'] = true,
    }
    if Config.Framework == Framework.QBCore then
        NetworkService.RegisterNetEvent('SetDuty', function(validRequest, state)
            if validRequest then
                if Framework.job then
                    Framework.job.duty = state
                end
                dbg.debug('Setting player duty state: %s', state)
            end
        end)
        local ServerJobsCached = {}
        local CachedJobGrades = {}
        local QBCore = nil
        local success = pcall(function()
            QBCore = exports[Framework.QBCore]:GetCoreObject()
        end)
        if not success then
            success = pcall(function()
                QBCore = exports[Framework.QBCore]:GetSharedObject()
            end)
        end
        if not success then
            local breakPoint = 0
            while not QBCore do
                Wait(100)
                TriggerEvent('QBCore:GetObject', function(obj)
                    QBCore = obj
                end)
                breakPoint = breakPoint + 1
                if breakPoint == 25 then
                    dbg.debug('Could not load the sharedobject, are you sure it is called \'QBCore:GetObject\'?')
                    break
                end
            end
        end
        Framework.object = QBCore
        local function GetJobDutyState(job)
            if not job then
                return false
            end

            if job.onduty ~= nil then
                return job.onduty == true
            end

            if job.onDuty ~= nil then
                return job.onDuty == true
            end

            if Config.AutoDuty and Config.JobGroups and Config.JobGroups[job.name] then
                return true
            end

            return not Config.DutySystemState
        end

        local function CacheJobFromPlayerData(playerData)
            if type(playerData) ~= 'table' or type(playerData.job) ~= 'table' then
                return false
            end

            local job = playerData.job
            local grade = type(job.grade) == 'table' and job.grade or {}
            local gradeName = grade.name or job.gradeName or tostring(job.grade or 0)
            local gradeLevel = tonumber(grade.level or grade.grade or job.gradeLevel or job.grade) or 0

            Framework.identifier = playerData.citizenid or playerData.identifier or Framework.identifier
            Framework.setJob({
                name = job.name,
                gradeName = gradeName,
                grade = gradeLevel,
                duty = GetJobDutyState(job),
                isBoss = RanksAsBossList[gradeName] or job.isboss == true or job.isBoss == true,
            })

            return true
        end

        function AwaitPlayerLoad()
            local identity = FindTargetResource and FindTargetResource('identity') or nil
            local multichar = FindTargetResource and FindTargetResource('multicharacter') or nil
            if not identity then
                identity = 'IDENTITY_NOT_FOUND'
            end
            if not multichar then
                multichar = 'MULTICHAR_NOT_FOUND'
            end
            dbg.debug('AwaitPlayerLoad: Checking server enviroment: \nIdentity: %s \nMultichar: %s', identity, multichar)
            if type(LocalPlayer.state['isLoggedIn']) == "boolean" then
                repeat
                    Wait(500)
                    dbg.debug(
                        'AwaitPlayerLoad: Awaiting to player load as active character via method: LocalPlayer.state.isLoggedIn')
                until LocalPlayer.state['isLoggedIn']
            elseif QBCore then
                local size = 0
                local playerData = QBCore.Functions.GetPlayerData()
                if type(playerData) == "table" then
                    repeat
                        Wait(500)
                        playerData = QBCore.Functions.GetPlayerData()
                        size = table.size(playerData)
                        dbg.debug('AwaitPlayerLoad: Awaiting to player load as active character via method: PlayerData')
                    until size and size > 0
                end
            else
                dbg.debug(
                'AwaitPlayerLoad: Any of framework related helper functions, not found: loading fallback solution.')
            end
            dbg.debug('AwaitPlayerLoad: Requesting player load, since player is found as active!')
            TriggerServerEvent('rcore_police:server:characterLoaded')
            TriggerEvent("rcore_police:client:characterLoaded")
            PlayerLoaded()
        end
        function PlayerLoaded()
            CachePlayerData()
        end
        function Framework.getDeathState()
            local playerData = QBCore.Functions.GetPlayerData()
            if not playerData or not playerData.metadata then
                return false
            end
            local isDead = playerData.metadata.isDead
            local lastStand = playerData.metadata.inlaststand
            local deathState = isDead or lastStand
            if deathState then
                return deathState
            end
            return false
        end
        function CachePlayerData()
            if not QBCore then
                return
            end
            local playerData = QBCore.Functions.GetPlayerData()
            CacheJobFromPlayerData(playerData)
        end
        local isActive = false
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            if source == '' then return end
            if not isActive then return end
            isActive = false
        end)
        CreateThread(function()
            while true do
                if NetworkIsPlayerActive(PlayerId()) and not isActive then
                    isActive = true
                    AwaitPlayerLoad()
                end
                Wait(500)
            end
        end)
        function Framework.sendNotification(message, type)
            TriggerEvent('QBCore:Notify', message, type, 5000)
        end
        function Framework.GetJobGrades(jobName)
            if CachedJobGrades[jobName] then
                return CachedJobGrades[jobName]
            end
            if not QBCore then
                return
            end
            local job = QBCore.Shared.Jobs[jobName]
            if not job or not job.grades then
                return {}
            end
            local grades = {}
            local jobGrades = job.grades
            local size = table.size(jobGrades)
            for i = 0, size, 1 do
                local grade = jobGrades[tostring(i)]
                if grade then
                    table.insert(grades, GradeModel(grade))
                end
            end
            CachedJobGrades[jobName] = grades
            return grades
        end
        function Framework.isInJob()
            if Framework.job and Config.JobGroups[Framework.job.name] then
                return true
            end
            return false
        end
        RegisterNetEvent(Config.Events['QBCore:Client:SetDuty'], function(state)
            if Framework.job then
                Framework.job.duty = state
            end
        end)
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function(jobData)
            if type(jobData) == 'table' and jobData.name then
                dbg.debug('Framework - job: Updating player job data, player loaded.')
                CacheJobFromPlayerData({
                    job = jobData,
                    identifier = Framework.identifier,
                })
            else
                CachePlayerData()
            end
        end)
        -- Seoul vRP pushes refreshed QBCore-compatible PlayerData through this real event.
        -- Listen to it so promotions, job changes and duty refresh the rcore cache immediately.
        RegisterNetEvent('QBCore:Player:SetPlayerData')
        AddEventHandler('QBCore:Player:SetPlayerData', function(playerData)
            CacheJobFromPlayerData(playerData)
        end)

        RegisterNetEvent(Config.Events['QBCore:Client:OnJobUpdate'])
        AddEventHandler(Config.Events['QBCore:Client:OnJobUpdate'], function(updatedJobData)
            if type(updatedJobData) ~= 'table' then return end
            dbg.debug('Framework - job: Updating player job data!')
            CacheJobFromPlayerData({
                job = updatedJobData,
                identifier = Framework.identifier,
            })
        end)
        function Framework.setJob(job)
            Framework.job = job
            if Framework.job.isBoss then
                Framework.job.gradeName = "boss"
            end
        end
        function Framework.CachePoliceGroups()
            if ServerJobsCached and next(ServerJobsCached) then
                return true, ServerJobsCached
            end
            if not Framework.object then
                return false, ServerJobsCached
            end
            if not Framework.object.Shared then
                return false, ServerJobsCached
            end
            if not Framework.object.Shared.Jobs then
                return false, ServerJobsCached
            end
            local serverJobs = Framework.object.Shared.Jobs
            if not serverJobs then
                return false, ServerJobsCached
            end
            if serverJobs and next(serverJobs) then
                for jobName, job in pairs(serverJobs) do
                    local configured = GetDepartmentConfig(jobName)
                    if configured or job.type == 'leo' then
                        ServerJobsCached[jobName] = {
                            grades = job.grades
                        }
                    end
                end
                return true, ServerJobsCached
            else
                return false, ServerJobsCached
            end
        end
    end
end)
