-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local Jobs = {
    ['police'] = {
        grades = {
            ['4'] = {
                name = "boss",
                isboss = true,
            },
            ['3'] = {
                name = "deputy",
            },
            ['2'] = {
                name = "novice",
            },
            ['1'] = {
                name = "member",
            }
        }
    },
}
local ADMIN_GROUPS = {
    SUPER_ADMIN = 'superadmin',
    ADMIN = 'admin'
}
CreateThread(function()
    if Config.Framework == Framework.NONE then
        Framework.object = nil
        RegisterCommand(Config.Commands and Config.Commands.REMOVE_PLAYER_JOB or 'removejob', function(source, args, rawCommand)
            if source == 0 then
                return
            end
            local playerGroup = Framework.getPlayerGroup(source)
            if playerGroup and playerGroup == 'user' then
                Framework.sendNotification(source, _U('JOB.NOT_ENOUGH_PERMS_TO_ACCESS', playerGroup), 'error')
                return
            end
            local target = tonumber(args[1])
            if not target  then
                Framework.sendNotification(source, _U('JOB.INVALID_TARGET'), 'error')
                return
            end
            local ped = GetPlayerPed(target)
            if DoesEntityExist(ped) then
                RemovePlayerJob(source, target) 
            end
        end, false)
        RegisterCommand(Config.Commands and Config.Commands.SET_PLAYER_JOB or 'setjob', function(source, args, rawCommand)
            if source == 0 then
                return
            end
            local playerGroup = Framework.getPlayerGroup(source)
            if playerGroup and playerGroup == 'user' then
                Framework.sendNotification(source, _U('JOB.NOT_ENOUGH_PERMS_TO_ACCESS', playerGroup), 'error')
                return
            end
            local target = tonumber(args[1])
            local jobName = args[2]
            local jobGrade = tonumber(args[3])
            if not target or not jobName or not jobGrade then
                Framework.sendNotification(source, _U('JOB.SET_BUSINESS_JOB_USE_CASE'), 'error')
                return
            end
            if not Jobs[jobName] then
                Framework.sendNotification(source, _U('JOB.SET_BUSINESS_INVALID_JOB'), 'error')
                return
            end
            if not Jobs[jobName].grades[tostring(jobGrade)] then
                Framework.sendNotification(source, _U('JOB.SET_BUSINESS_INVALID_GRADE'), 'error')
                return
            end
            local playerIdentifier = Framework.getIdentifier(source)
            if playerIdentifier then
                SetPlayerJob(source, target, playerIdentifier, jobName, jobGrade)
            end
        end, false)
        function Framework.isAdmin(client)
            local retval = false
            local playerGroup = Framework.getPlayerGroup(client)
            if playerGroup ~= 'user' then
                retval = true
            end
            if IsPlayerAceAllowed(client, 'command') then
                retval = true
            end
            return retval
        end
        function Framework.getPlayerGroup(client)
            local group = 'user'
            if Ace.Can(client, Permissions.HAS_SERVER_GROUP) then
                group = 'admin'
            end
            return group
        end
        function Framework.HandleGarageBankTransaction(params, callback)
            local state = true
            local playerId = params.playerId
            local transactionType = params.transactionType
            local costAmount = params.spawnPrice
            local fallbackCost = Config.Garage.DepartmentsBuyVehicleCostPrice
            if not costAmount then
                costAmount = fallbackCost
            end
            if callback then
                callback(state, costAmount)
            end
        end
        function Framework.getBankMoney(client)
            return 100000
        end
        function Framework.getIdentifier(client)
            local success, result = pcall(function()
                return GetPlayerIdentifierByType(client, 'license')
            end)
            if not success then
                return dbg.critical('GetPlayerIdentifier: Failed to get identifier for user named %s', GetPlayerName(client))
            end
            return result
        end
        function Framework.getJob(playerId)
            local identifier = Framework.getIdentifier(playerId)
            if not identifier then return nil end
            local jsonData = GetResourceKvpString(identifier .. "_job")
            if not jsonData then
                return nil
            end
            local jobData = json.decode(jsonData)
            return jobData
        end
        function Framework.SetPlayerJob(target, jobName, gradeIndex)
            local player = Framework.getPlayer(target)
            if not player then
                return false
            end
            if not jobName then
                jobName = 'unemployed'
            end
            if not gradeIndex then
                gradeIndex = 1
            end
            local identifier = player.identifier
            SetPlayerJob(target, target, identifier, jobName, gradeIndex)
        end
        function Framework.addBankMoney(client, amount, reason)
            return nil
        end
        function Framework.removeBankMoney(client, amount, reason)
            return nil
        end
        function Framework.getPlayer(client)
            if not client then
                return nil
            end
            return {
                identifier = Framework.getIdentifier(client)
            }
        end
        function Framework.GetBankAccount(playerId)
            local player = Framework.getPlayer(playerId)
            if not player then
                return nil
            end
            local account = {
                AddMoney = function(amount) 
                end,
                RemoveMoney = function(amount) 
                end,
                GetMoney = function() 
                    return 0
                end
            }
            return account
        end
        function Framework.sendNotification(client, message, type)
            TriggerClientEvent('rcore_police:client:showNotification', client, message, type, 5000)
        end
        function Framework.getCharacterShortName(client)
            return GetPlayerName(client)
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
        function Framework.getPlayerJob(playerId)
            local identifier = Framework.getIdentifier(playerId)
            if not identifier then return nil end
            local playerJobKey = ('%s_%s'):format(identifier, 'job')
            local jsonData = GetResourceKvpString(playerJobKey)
            if not jsonData then
                return nil
            end
            local jobData = json.decode(jsonData)
            return jobData
        end
        function SetPlayerJob(initiator, playerId, identifier, jobName, jobGrade)
            if not identifier then return nil end
            local job = Jobs[jobName]
            local gradeName = job.grades[tostring(jobGrade)].name
            local isBoss = job.grades[tostring(jobGrade)].boss
            local jobData = {
                name = jobName,
                grade = jobGrade,
                gradeName = gradeName,
                isBoss = isBoss or gradeName:lower() == 'boss'
            }
            local playerJobKey = ('%s_%s'):format(identifier, 'job')
            local jsonData = json.encode(jobData)
            if not jsonData then
                return nil
            end
            TriggerEvent('rcore_police:server:setJob', playerId, jobData)
            TriggerClientEvent('rcore_police:client:setJob', playerId, jobData)
            SetResourceKvp(playerJobKey, jsonData)
            Framework.sendNotification(initiator, _U('JOB.ADD_TO_PLAYER', GetPlayerName(playerId), gradeName), 'success')
        end
        function RemovePlayerJob(initiator, playerId)
            local identifier = Framework.getIdentifier(playerId)
            if not identifier then return nil end
            local playerJobKey = ('%s_%s'):format(identifier, 'job')
            local jsonData = GetResourceKvpString(playerJobKey)
            if not jsonData then
                return nil
            end
            TriggerEvent('rcore_police:server:setJob', playerId, nil)
            TriggerClientEvent('rcore_police:client:setJob', playerId, nil)
            DeleteResourceKvp(playerJobKey)
            Framework.sendNotification(initiator, _U('JOB.REMOVED_FROM_PLAYER', GetPlayerName(playerId)), 'error')
        end
        function Framework.setHandcuffMetadata(playerId, state)
        end
        function SetJobUpdate(playerId)
            if not playerId then
                return
            end
            local job = Framework.getPlayerJob(playerId)
            if job and next(job) then
                tprint(job)
                TriggerEvent('rcore_police:server:setJob', playerId, job)
                TriggerClientEvent('rcore_police:client:setJob', playerId, job) 
            end
        end
        AddEventHandler('rcore_police:server:setJob', function(playerId, jobData)
            TriggerEvent('rcore_police:server:jobUpdate', playerId, jobData)
        end)
        RegisterNetEvent('rcore_police:server:characterLoaded', function()
            local playerId = source
            if playerId then
                TriggerEvent('rcore_police:server:playerLoaded', playerId)
            end
            SetJobUpdate(playerId)
        end)
        AddEventHandler('playerDropped', function()
            local playerId = source
            if playerId then
                TriggerEvent('rcore_police:server:playerUnloaded', playerId)
            end
        end)
        function Framework.CachePoliceGroups()
            return false, {}
        end
    end    
end)
