-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    local CachedJobGrades = {}
    local ServerJobsCached = {}
    local RanksAsBossList = Config.RanksAsBossList or {
        ['boss'] = true,
        ['chief'] = true,
    }
    if Config.Framework == Framework.ESX then
        local ESX = nil
        local EnforcePlayerLoaded = false
        local success, result = pcall(function()
            ESX = exports[Framework.ESX]:getSharedObject()
        end)
        if not success then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Framework.object = ESX
        NetworkService.RegisterNetEvent('ServerJobs', function(validRequest, data)
            if validRequest then
                Framework.jobs = data
            end
        end)
        function Framework.sendNotification(message, type)
            ESX.ShowNotification(message, type)
        end
        function AwaitPlayerLoad()
            if not ESX then
                return
            end
            local identity = FindTargetResource and FindTargetResource('identity') or nil
            local multichar = FindTargetResource and FindTargetResource('multicharacter') or nil
            if not identity then
                identity = 'IDENTITY_NOT_FOUND'
            end
            if not multichar then
                multichar = 'MULTICHAR_NOT_FOUND'
            end
            dbg.debug('AwaitPlayerLoad: Checking server enviroment: \nIdentity: %s \nMultichar: %s', identity,
                multichar)
            if type(ESX.IsPlayerLoaded) == "table" then
                repeat
                    Wait(500)
                    dbg.debug(
                        'AwaitPlayerLoad: Awaiting to player load as active character via method: ESX.IsPlayerLoaded')
                until ESX.IsPlayerLoaded() or EnforcePlayerLoaded
            elseif type(ESX.GetPlayerData) == "table" then
                local playerData = ESX.GetPlayerData()
                repeat
                    Wait(500)
                    playerData = ESX.GetPlayerData()
                    dbg.debug(
                    'AwaitPlayerLoad: Awaiting to player load as active character via method: ESX.GetPlayerData')
                until playerData and next(playerData) or EnforcePlayerLoaded
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
            return false
        end
        function CachePlayerData()
            local playerData = ESX.GetPlayerData()
            local retval = {}
            if playerData and playerData.job then
                retval = {
                    job = playerData.job,
                    identifier = playerData.identifier
                }
            end
            if retval and next(retval) then
                if retval.identifier then
                    Framework.identifier = retval.identifier
                end
                local duty = false
                local hasFrameworkDuty = false
                local gradeName = retval.job.grade_name:lower()
                if retval.job and retval.job.duty ~= nil then
                    duty = retval.job.duty
                end
                if not Config.DutySystemState and not duty then
                    duty = true
                end
                if retval.job and retval.job.onDuty then
                    duty = true
                    hasFrameworkDuty = true
                end
                if Config.AutoDutyDisableESX and hasFrameworkDuty then
                    if Config.JobGroups[retval.job.name] then
                        duty = false
                    end
                end
                Framework.setJob({
                    name = retval.job.name,
                    gradeName = retval.job.grade_name,
                    grade = retval.job.grade,
                    duty = duty,
                    isBoss = RanksAsBossList[gradeName] or false
                })
            end
        end
        local isActive = false
        RegisterNetEvent('esx:onPlayerLogout', function()
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
        RegisterNetEvent(Config.Events['esx:playerLoaded'])
        AddEventHandler(Config.Events['esx:playerLoaded'], function(data)
            local duty = false
            local hasFrameworkDuty = false
            if data.job and data.job.duty ~= nil then
                duty = data.job.duty
            end
            if not Config.DutySystemState and not duty then
                duty = true
            end
            if data.job and data.job.onDuty then
                duty = true
                hasFrameworkDuty = true
            end
            if Config.AutoDutyDisableESX and hasFrameworkDuty then
                if Config.JobGroups[data.job.name] then
                    duty = false
                end
            end
            local gradeName = data.job.grade_name:lower()
            Framework.setJob({
                name = data.job.name,
                gradeName = data.job.grade_name,
                grade = data.job.grade,
                duty = duty,
                isBoss = RanksAsBossList[gradeName] or false
            })
        end)
        RegisterNetEvent(Config.Events['esx:setJob'])
        AddEventHandler(Config.Events['esx:setJob'], function(data)
            local duty = false
            local hasFrameworkDuty = false
            if data and data.duty ~= nil then
                duty = data.duty
            end
            if not Config.DutySystemState and not duty then
                duty = true
            end
            if data.job and data.job.onDuty then
                duty = true
                hasFrameworkDuty = true
            end
            if Config.AutoDutyDisableESX and hasFrameworkDuty then
                if Config.JobGroups[data.job.name] then
                    duty = false
                end
            end
            local gradeName = data.grade_name:lower()
            Framework.setJob({
                name = data.name,
                gradeName = data.grade_name,
                grade = data.grade,
                duty = duty,
                isBoss = RanksAsBossList[gradeName] or false
            })
        end)
        NetworkService.RegisterNetEvent('SetDuty', function(validRequest, state)
            if validRequest then
                if Framework.job then
                    Framework.job.duty = state
                end
                dbg.debug('Setting player duty state: %s', state)
            end
        end)
        function Framework.GetJobGrades(jobName)
            if CachedJobGrades[jobName] then
                return CachedJobGrades[jobName]
            end
            if not Framework.jobs then
                return
            end
            local job = Framework.jobs[jobName]
            if not job or not job.grades then
                return {}
            end
            local grades = {}
            local jobGrades = job.grades
            local size = table.size(jobGrades)
            if size then
                for i = 0, size, 1 do
                    local grade = jobGrades[tostring(i)]
                    if grade then
                        table.insert(grades, GradeModel(grade))
                    end
                end
            end
            CachedJobGrades[jobName] = grades
            return grades
        end
        function Framework.setJob(job)
            Framework.job = job
        end
        function Framework.CachePoliceGroups()
            if ServerJobsCached and next(ServerJobsCached) then
                return true, ServerJobsCached
            end
            if not Framework.jobs then
                return false, ServerJobsCached
            end
            local serverJobs = Framework.jobs
            if not serverJobs then
                return false, ServerJobsCached
            end
            if serverJobs and next(serverJobs) then
                for jobName, job in pairs(serverJobs) do
                    if Config.JobGroups[jobName] and Config.JobGroups[jobName]?.Store then
                        ServerJobsCached[jobName] = {
                            grades = job.grades
                        }
                        return
                    end
                    ServerJobsCached[jobName] = {
                        grades = job.grades
                    }
                end
                return true, ServerJobsCached
            else
                return false, ServerJobsCached
            end
        end
    end
end)
