-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local ServerJobsCached = {}
local DeathPlayers = {}
CreateThread(function()
    if Config.Framework == Framework.QBOX then
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
                    fprint('Could not load the sharedobject, are you sure it is called \'QBCore:GetObject\'?',
                        Levels.ERROR)
                    break
                end
            end
        end
        Framework.object = QBCore
        function Framework.setHandcuffMetadata(playerId, state)
            local player = Framework.getPlayer(playerId)
            if not player then return end
            player.Functions.SetMetaData('ishandcuffed', state)
        end
        function Framework.isAdmin(client)
            local retval = false
            for _, adminGroup in ipairs(Config.FrameworkAdminGroups[Config.Framework]) do
                if QBCore and QBCore.Functions.HasPermission(client, adminGroup) then
                    retval = true
                end
            end
            if not retval and IsPlayerAceAllowed(client, 'command') then
                retval = true
            end
            return retval
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
        function Framework.getBankMoney(client)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            return player.Functions.GetMoney("bank")
        end
        function Framework.addBankMoney(client, amount, reason)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            return player.Functions.AddMoney("bank", amount, reason)
        end
        function Framework.removeBankMoney(client, amount, reason)
            local player = Framework.getPlayer(client)
            if not player then
                return 0
            end
            return player.Functions.RemoveMoney("bank", amount, reason)
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
            return player.Functions.SetJob(jobName, gradeIndex)
        end
        function Framework.GetBankAccount(playerId)
            local player = Framework.getPlayer(playerId)
            if not player then
                return nil
            end
            local account = {
                AddMoney = function(amount)
                    player.Functions.AddMoney("bank", amount)
                end,
                RemoveMoney = function(amount)
                    player.Functions.RemoveMoney("bank", amount)
                end,
                GetMoney = function()
                    return player.Functions.GetMoney("bank")
                end
            }
            return account
        end
        function Framework.getPlayer(client)
            if not client then
                return nil
            end
            return QBCore.Functions.GetPlayer(client)
        end
        function Framework.getIdentifier(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end
            return tostring(player.PlayerData.citizenid)
        end
        function Framework.getJob(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end
            return {
                name = player.PlayerData.job.name,
                grade_name = player.PlayerData.job.grade.name,
                grade_level = player.PlayerData.job.grade.level,
                duty = player.PlayerData.job.onduty or false,
                isBoss = player.PlayerData.job.isboss
            }
        end
        function Framework.sendNotification(client, message, type)
            TriggerClientEvent('QBCore:Notify', client, message, type, 5000)
        end
        function Framework.getCharacterShortName(client)
            local player = QBCore.Functions.GetPlayer(client)
            if player == nil then return nil end
            local firstname = player.PlayerData.charinfo.firstname
            local lastname = player.PlayerData.charinfo.lastname
            return string.format('%s %s', firstname, lastname)
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
            local player = Framework.getPlayer(playerId)
            if Config.AutoDutyDisableQB and player then
                local playerJob = player.PlayerData.job.name
                if Config.JobGroups[playerJob] then
                    player.Functions.SetJobDuty(false)
                end
                dbg.debug('Player named %s setting duty to false - login!', GetPlayerName(playerId))
            end
            if playerId then
                TriggerEvent('rcore_police:server:playerLoaded', playerId)
            end
        end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerId)
            local playerId = playerId
            local player = Framework.getPlayer(playerId)
            if playerId then
                if IS_QB[Config.Framework] then
                    Framework.setHandcuffMetadata(playerId, false)
                end
                if Config.AutoDutyDisableQB and player then
                    local playerJob = player.PlayerData.job.name
                    if Config.JobGroups[playerJob] then
                        player.Functions.SetJobDuty(false)
                    end
                    dbg.debug('Player named %s setting duty to false - login!', GetPlayerName(playerId))
                end
                TriggerEvent('rcore_police:server:playerUnloaded', playerId)
            end
        end)
        AddEventHandler('QBCore:Server:OnJobUpdate', function(playerId, jobData)
            TriggerEvent('rcore_police:server:jobUpdate', playerId, jobData)
        end)
        AddEventHandler('playerDropped', function()
            local playerId = source
            local player = Framework.getPlayer(playerId)
            if playerId then
                if IS_QB[Config.Framework] then
                    Framework.setHandcuffMetadata(playerId, false)
                end
                if Config.AutoDutyDisableQB and player then
                    local playerJob = player.PlayerData.job.name
                    if Config.JobGroups[playerJob] then
                        player.Functions.SetJobDuty(false)
                    end
                    dbg.debug('Player named %s setting duty to false - login!', GetPlayerName(playerId))
                end
                TriggerEvent('rcore_police:server:playerUnloaded', playerId)
            end
        end)
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
                    if Config.JobGroups[jobName] and Config.JobGroups[jobName]?.Store then
                        return
                    end
                    if job.type == 'leo' then
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
        function Framework.CacheServerItems()
            if not QBCore then
                return
            end
            if not QBCore.Shared or not QBCore.Shared.Items then
                return
            end
            local retval = QBCore.Shared.Items
            if isResourcePresentProvideless(Inventory.QS) then
                return
            end
            if isResourcePresentProvideless(Inventory.OX) then
                return
            end
            if doesExportExistInResource(Inventory.CODEM, 'GetItemList') then
                ServerItems = exports.codem_inventory:GetItemList()
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
        Framework.CacheServerItems()
    end
end)
