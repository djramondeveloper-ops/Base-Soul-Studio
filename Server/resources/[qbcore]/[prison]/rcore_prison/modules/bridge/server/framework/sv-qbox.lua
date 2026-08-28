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
                    dbg.critical('Could not load the sharedobject, are you sure it is called \'QBCore:GetObject\'?')
                    break
                end
            end
        end

        Framework.object = QBCore


        function Framework.getPlayer(client)
            if not client then
                return nil
            end

            return QBCore.Functions.GetPlayer(client)
        end

        function Framework.getPlayerCuffState(client)
            local player = Framework.getPlayer(client)

            if not player then
                return false
            end

            local retval = false

            if player.PlayerData.metadata['ishandcuffed'] then
                retval = player.PlayerData.metadata['ishandcuffed']
            end

            return retval
        end

        function Framework.getMoney(client)
            local player = Framework.getPlayer(client)

            if not player then
                return 0
            end

            return player.Functions.GetMoney("cash")
        end

        function Framework.addMoney(client, amount)
            local player = Framework.getPlayer(client)

            if not player then
                return 0
            end

            return player.Functions.AddMoney("cash", amount)
        end

        function Framework.removeMoney(client, amount)
            local player = Framework.getPlayer(client)

            if not player then
                return 0
            end

            player.Functions.RemoveMoney("cash", amount)
        end

        function Framework.canPerformJobCommand(client, commandName)
            local job = Framework.getJob(client)

            if job == nil then return false, false end

            local jobName = job.name
            local jobGrade = job.grade
            local gradeName = job.gradeName:lower()

            if jobName == nil then return false end

            if Config.AllowAdminGroupsUseJailCommands and Framework.isAdmin(client) then
                return true, true
            end

            if Config.RestrictCommands and Config.RestrictCommands.Enable and commandName and next(Config.RestrictCommands.ListGrades[commandName]) then
                if Config.RestrictCommands.UseGradeNumbers and jobGrade ~= nil then
                    if jobGrade >= Config.RestrictCommands.GradeNumber then
                        return true, true
                    else
                        return false, _U('PERMISSION.NOT_ENOUGH_RANK')
                    end
                else
                    local hasPermission = Config.RestrictCommands.ListGrades[commandName][gradeName]

                    if not hasPermission then
                        return false, _U('PERMISSION.NOT_ENOUGH_RANK')
                    else
                        return true, true
                    end
                end
            else
                dbg.debug('Not using restrict commands, since its disabled!')
            end

            if Config.Jobs and Config.Jobs[jobName] then
                return true, true
            end

            return false, false
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
                gradeName = player.PlayerData.job.grade.name,
                grade = player.PlayerData.job.grade.level,
                onDuty = player.PlayerData.job.onduty,
                isBoss = player.PlayerData.job.isboss
            }
        end

        function Framework.getCharacterName(client)
            local player = QBCore.Functions.GetPlayer(client)
            if player == nil then return nil end

            local firstname = player.PlayerData.charinfo.firstname
            local lastname = player.PlayerData.charinfo.lastname

            return string.format('%s %s', firstname, lastname)
        end

        function Framework.sendNotification(client, message, type)
            if type == 'info' then
                type = 'primary'
            end

            TriggerClientEvent('QBCore:Notify', tonumber(client), message, type, 5000)
        end

        function Framework.isAdmin(client)
            if not client then
                return false
            end

            if type(client) ~= "number" then
                return false
            end

            local retval = false

            for _, adminGroup in ipairs(Config.FrameworkAdminGroups[Config.Framework]) do
                if QBCore.Functions.HasPermission(client, adminGroup) then
                    retval = true
                end
            end

            if not retval and IsPlayerAceAllowed(client, 'command') then
                retval = true
            end

            if not retval then
                for groupName, v in pairs(PermissionMap) do
                    if IsPlayerAceAllowed(client, groupName) then
                        return true
                    end
                end
            end
            
            return retval
        end

        function LoadOfficers()
            if type(QBCore.Functions.GetQBPlayers) ~= "function" and type(LoadOfficersDefault) ~= "nil" then
                return LoadOfficersDefault()
            end

            local officers = {}
            local qbPlayers = QBCore.Functions.GetQBPlayers()

            for _, player in pairs(qbPlayers) do
                if player and player.PlayerData then
                    local job = player.PlayerData.job
                    local playerId = player.PlayerData.source

                    if job and job.name and Config.Jobs[job.name:lower()] and job.onduty then
                        dbg.debug("GetOfficers (GetQBPlayers): Adding player with ID: %s", playerId)
                        officers[#officers + 1] = playerId
                    end
                end
            end

            return officers
        end

        function Framework.setJob(client, jobName)
            local player = Framework.getPlayer(client)
            local tag = PlayerTag(client)

            if not player then
                dbg.job("SetPlayerJob: %s not found, skipping", tag)
                return nil
            end

            jobName = jobName or Config.Prisoners.RemovePlayerSetDefaultJob or 'unemployed'

            player.Functions.SetJob(jobName)

            dbg.job("SetPlayerJob: %s applied '%s'", tag, jobName)
        end

        --- @return boolean
        function Framework.clearInventory(client)
            local player = Framework.getPlayer(client)

            if player == nil then
                return nil
            end

            local p = promise.new()
            local clearMain, clearMainErr = pcall(function()
                return player.Functions.ClearInventory(Inventory.KeepSessionItems)
            end)

            local state = false

            if clearMain then
                state = true
                p:resolve(state)
            else
                local backClear, backClearErr = pcall(player.Functions.SetPlayerData, "items", {})

                if backClear then
                    state = true
                    p:resolve(state)
                else
                    p:resolve(state)
                end
            end

            dbg.debugInventory("Framework.clearInventory: For citizen %s (%s) with state: %s", GetPlayerName(client),
                client, state)

            Citizen.Await(p)

            return state
        end

        local disabledInventories = {
            [Inventories.QS] = true,
            [Inventories.OX] = true,
        }

        function Framework.cacheItems()
            if not QBCore then
                return
            end

            if not QBCore.Shared or not QBCore.Shared.Items then
                return
            end

            local retval = QBCore.Shared.Items

            if isResourcePresentProvideless(Inventories.QS) then
                return
            end

            if isResourcePresentProvideless(Inventories.OX) then
                return
            end

            if disabledInventories[Config.Inventories] then
                return
            end

            if doesExportExistInResource(Inventories.CODEM, 'GetItemList') then
                retval = exports['codem-inventory']:GetItemList()
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

        AddEventHandler("rcore_prison:server:characterSpawned", function(playerId)
            TriggerEvent('rcore_prison:server:playerLoaded', playerId)
        end)

        AddEventHandler("rcore_prison:server:playerLogout", function(playerId)
            TriggerEvent('rcore_prison:server:playerUnloaded', playerId)
        end)

        Framework.cacheItems()
    end
end, "sv-qbcore code name: Phoenix")
