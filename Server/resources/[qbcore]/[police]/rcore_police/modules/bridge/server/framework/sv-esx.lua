-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local CharSlotToServerId = {}   
local CachedJobs = {}
local DeathPlayers = {}
local ServerJobsCached = {}
local fetchedJobs = false
local RanksAsBossList = Config.RanksAsBossList or {
    ['boss'] = true,
    ['chief'] = true,
}
CreateThread(function()
    if Config.Framework == Framework.ESX then
        local ESX = nil
        local success, result = pcall(function()
            ESX = exports[Framework.ESX]:getSharedObject()
        end)
        if not success then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        RegisterServerEvent('esx:onPlayerDeath', function(data)
            local playerId = source
            local deathPed = GetPlayerPed(source)
            local deathHealth = GetEntityHealth(deathPed)
            if DeathPlayers[playerId] then
                return
            end
            if deathHealth and deathHealth <= 0 then   
                DeathPlayers[playerId] = true    
            end
        end)
        RegisterNetEvent('esx:onPlayerSpawn', function()
            local playerId = source
            if DeathPlayers[playerId] then
                DeathPlayers[playerId] = false
            end
        end)
        Framework.object = ESX
        function loadJobs()
            if not fetchedJobs then
                fetchedJobs = true
                local jobs = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})
                for k, v in ipairs(jobs) do
                    Framework.object.Jobs[v.name] = v
                    Framework.object.Jobs[v.name].grades = {}
                end
                local jobGrades = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})
                for k, v in ipairs(jobGrades) do
                    if Framework.object.Jobs[v.job_name] then
                        Framework.object.Jobs[v.job_name].grades[tostring(v.grade)] = v
                    end
                end
            end
        end
        function CacheJobsForPlayer()
            if CachedJobs and next(CachedJobs) then
                return CachedJobs
            end
            if not Framework.object then
                return
            end
            local loadBreaker = 0
            local jobs = nil
            repeat
                loadBreaker = loadBreaker + 1
                jobs = Framework.object.Jobs
                if jobs and next(jobs) then
                    break
                end
                Wait(500)
            until loadBreaker >= 50
            if not jobs or not next(jobs) then
                return nil
            end
            CachedJobs = jobs
            return CachedJobs
        end
        function Framework.setHandcuffMetadata(playerId, state)
        end
        function Framework.getIdentifier(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end
            local identifier = tostring(player.identifier)
            if isResourceLoaded(THIRD_PARTY_RESOURCE.CD) then
                local currentChar = CharSlotToServerId[tostring(client)]
                if not currentChar then
                    return identifier
                end
                if not identifier then
                    identifier = player.GetIdentifier()
                end
                local currentIdentifier = ('Char%s:%s'):format(currentChar, identifier)
                dbg.debug(
                "cd_multicharacter - getIdentifier: Returning real identifier for player named %s with playerId %s: (%s)",
                    GetPlayerName(client), client, currentIdentifier)
                return currentIdentifier
            else
                return identifier
            end
        end
        function Framework.HandleGarageBankTransaction(params, callback)
            local state = false
            local playerId = params.playerId
            local transactionType = params.transactionType
            local playerBankMoney = Framework.getBankMoney(playerId)
            local costAmount = params.spawnPrice
            local fallbackCost = Config.Garage.DepartmentsBuyVehicleCostPrice
            if not costAmount then
                costAmount = fallbackCost
            end
            if playerBankMoney >= costAmount then
                if transactionType == 'REMOVE' then
                    Framework.removeBankMoney(playerId, costAmount)
                    state = true
                elseif transactionType == 'ADD' then
                    Framework.addBankMoney(playerId, costAmount)
                    state = true
                end
            end
            if callback then
                callback(state, costAmount)
            end
        end
        function Framework.getJob(client)
            local player = Framework.getPlayer(client)
            if not player then return nil end
            local jobName = player.job.name
            local grade = player.job.grade
            local gradeName = player.job.grade_name:lower()
            local jobData = CachedJobs[jobName] or {}
            local isBoss = false
            if jobData and jobData.grades then
                if not jobData._gradeCount then
                    jobData._gradeCount = table.size(jobData.grades)
                end
                if RanksAsBossList[gradeName] or grade >= (jobData._gradeCount - 1) then
                    isBoss = true
                end
            end
            if not jobData.grades and RanksAsBossList[gradeName] then
                isBoss = true
            end
            return {
                name = jobName,
                grade_name = gradeName,
                grade = grade,
                isBoss = isBoss,
            }
        end
        function Framework.getCharacterShortName(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end
            local firstname = player.get('firstName')
            local lastname = player.get('lastName')
            local shortName = firstname or lastname
            if shortName == nil then
                shortName = player.firstname or player.lastname
            end
            return shortName
        end
        function Framework.getBankMoney(client)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            local retval = player.getAccount("bank")
            if retval and next(retval) then
                return tonumber(retval['money'])
            end
            return 0
        end
        function Framework.addBankMoney(client, amount, reason)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            return player.addAccountMoney('bank', amount)
        end
        function Framework.removeBankMoney(client, amount, reason)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            return player.removeAccountMoney("bank", amount)
        end
        function Framework.GetBankAccount(playerId)
            local player = Framework.getPlayer(playerId)
            if not player then
                return nil
            end
            local account = {
                AddMoney = function(amount)
                    player.addAccountMoney('bank', amount)
                end,
                RemoveMoney = function(amount)
                    player.removeAccountMoney("bank", amount)
                end,
                GetMoney = function()
                    local bankAccount = player.getAccount("bank")
                    local retval = 0
                    if bankAccount and next(bankAccount) then
                        retval = tonumber(bankAccount['money'])
                    end
                    return retval
                end
            }
            return account
        end
        function Framework.getCharacterShortName(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end
            local firstname = player.get('firstName')
            local lastname = player.get('lastName')
            if firstname == nil or lastname == nil then
                firstname = player.firstname
                lastname = player.lastname
            end
            return string.format('%s %s', firstname, lastname)
        end
        function Framework.getPlayer(client)
            local player = ESX.GetPlayerFromId(client)
            if player == nil then return end
            return player
        end
        function Framework.sendNotification(client, message, type)
            local player = Framework.getPlayer(client)
            if player == nil then return end
            player.showNotification(message, type)
        end
        function Framework.isAdmin(client)
            local player = Framework.getPlayer(client)
            if player == nil then return false end
            local group = player.getGroup()
            if group ~= "user" then
                return true
            end
            if group == "user" and IsPlayerAceAllowed(client, 'command') then
                return true
            end
            return false
        end
        function Framework.SetPlayerJob(target, jobName, gradeIndex)
            local player = Framework.getPlayer(target)
            if not player then
                return nil
            end
            if not jobName then
                jobName = 'unemployed'
            end
            if not gradeIndex then
                gradeIndex = 0
            end
            if jobName == 'unemployed' then
                gradeIndex = 0
            end
            player.setJob(jobName, gradeIndex)
            return true
        end
        function Framework.BuildInvoicePayload(playerId, targetId, reason, amount)
            if not playerId or not targetId then return nil end
            local initiatorJob = Framework.getJob(playerId)
            local initiatorName = Framework.getCharacterShortName(playerId)
            local initiatorIdentifier = Framework.getIdentifier(playerId)
            local targetName = Framework.getCharacterShortName(targetId)
            local targetIdentifier = Framework.getIdentifier(targetId)
            local invoice = {
                initiator = {
                    playerId = playerId,
                    identifier = initiatorIdentifier,
                    job = initiatorJob and initiatorJob.name or "unknown",
                    label = initiatorJob and initiatorJob.name:upper() or "UNKNOWN",
                    name = initiatorName,
                },
                target = {
                    playerId = targetId,
                    identifier = targetIdentifier,
                    name = targetName,
                },
                reason = reason or '',
                amount = amount,
                society = ('%s_%s'):format(Config.Business.SocietyPrefix, initiatorJob and initiatorJob.name or "unknown")
            }
            return invoice
        end
        RegisterNetEvent('rcore_police:server:characterLoaded', function()
            local playerId = source
            if playerId then
                TriggerEvent('rcore_police:server:playerLoaded', playerId)
            end
        end)
        AddEventHandler('esx:setJob', function(playerId, jobData)
            TriggerEvent('rcore_police:server:jobUpdate', playerId, jobData)
        end)
        AddEventHandler('playerDropped', function()
            local playerId = source
            if playerId then
                if isResourceLoaded(THIRD_PARTY_RESOURCE.CD) then
                    if CharSlotToServerId[tostring(playerId)] then
                        CharSlotToServerId[tostring(playerId)] = nil
                        dbg.debug(
                        'cd_multicharacter - playerDropped: Removed CharSlotToServerId for player named %s with playerId',
                            GetPlayerName(playerId), playerId)
                    end
                end
                TriggerEvent('rcore_police:server:playerUnloaded', playerId)
            end
        end)
        RegisterNetEvent('cd_multicharacter:CharacterChosen', function(characterSlot)
            local playerId = source
            if not CharSlotToServerId[tostring(playerId)] and playerId then
                CharSlotToServerId[tostring(playerId)] = characterSlot
                dbg.debug(
                'cd_multicharacter - CharacterChosen: Added CharSlotToServerId for player named %s with playerId',
                    GetPlayerName(playerId), playerId)
            end
        end)
        function Framework.CachePoliceGroups()
            if ServerJobsCached and next(ServerJobsCached) then
                return true, ServerJobsCached 
            end
            if not Framework.object then
                return false, ServerJobsCached
            end
            if not Framework.object.Jobs then
                return false, ServerJobsCached
            end
            if not Framework.object.Jobs then
                return false, ServerJobsCached
            end
            local serverJobs = Framework.object.Jobs
            if not serverJobs then
                return false, ServerJobsCached
            end
            if serverJobs and next(serverJobs) then
                for jobName, job in pairs(serverJobs) do
                    if Config.JobGroups[jobName] and Config.JobGroups[jobName]?.Store then
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
        function Framework.CacheServerItems()
            if isResourcePresentProvideless(Inventory.QS) then
                return
            end
            if isResourcePresentProvideless(Inventory.OX) then
                return
            end
            local retval = nil
            if isResourcePresentProvideless(Inventory.ESX) then
                retval = db.GetServerItems()
            end
            if retval and next(retval) then
                for k, v in pairs(retval) do
                    if v then
                        local itemName = v.name and v.name:upper()
                        if itemName and not ServerItems[itemName:upper()] then
                            ServerItems[itemName:upper()] = v
                        end
                    end
                end
                dbg.debug('Server items: Find %s amount of items on your server.', table.size(retval))
            end
        end
        local jobCreator = FindTargetResource('job_creator') or FindTargetResource('jobs_creator') or nil
        if isResourcePresentProvideless('job_creator') or isResourcePresentProvideless('jobs_creator') or jobCreator then
            loadJobs()
        end    
        Framework.CacheServerItems()
    end
end)
