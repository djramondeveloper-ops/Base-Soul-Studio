CreateThread(function()
    if Config.Framework == Framework.ESX then
        local ESX = nil

        local success, result = pcall(function()
            ESX = exports[Framework.ESX]:getSharedObject()
        end)

        if not success then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end

        Framework.object = ESX

        function Framework.getIdentifier(client)
            local player = Framework.getPlayer(client)
            if player == nil then return nil end

            local identifier = tostring(player.identifier)


            return identifier
        end

        function Framework.canPerformJobCommand(client, commandName)
            local job = Framework.getJob(client)

            if job == nil then return false end

            local jobName = job.name:lower()
            local grade = job.grade
            local gradeName = job.gradeName:lower()

            if jobName == nil then return false end

            if not Config.RestrictCommands.Enable and Config.Jobs[jobName] then
                return true
            end

            if Config.AllowAdminGroupsUseJailCommands and Framework.isAdmin(client) then
                return true, true
            end

            if Config.RestrictCommands and Config.RestrictCommands.Enable and commandName and Config.RestrictCommands.ListGrades[commandName] and next(Config.RestrictCommands.ListGrades[commandName]) then
                if Config.RestrictCommands.UseGradeNumbers and grade ~= nil then
                    if grade >= Config.RestrictCommands.GradeNumber then
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
            end

            return false
        end

        function Framework.getJob(client)
            local player = Framework.getPlayer(client)

            if player == nil then return nil end

            return {
                name = player.job.name,
                gradeName = player.job.grade_name,
                grade = player.job.grade,
                duty = player.job.onDuty or false
            }
        end

        function Framework.getCharacterName(client)
            local player = Framework.getPlayer(client)

            if player == nil then return nil end

            local firstname = player.get('firstName')
            local lastname = player.get('lastName')

            if firstname == nil or lastname == nil then
                firstname = player.firstname
                lastname = player.lastname
            end

            if type(player.getName) ~= "nil" then
                local fullName = player.getName()

                if fullName then
                    return fullName
                end
            end

            if firstname == nil and lastname == nil then
                return ("%s"):format(player.name or "Unknown")
            end

            return string.format('%s %s', firstname, lastname)
        end

        function Framework.getPlayer(client)
            local player = ESX.GetPlayerFromId(client)
            if player == nil then return end

            return player
        end

        function Framework.sendNotification(client, message, messageType)
            local player = Framework.getPlayer(client)
            if player == nil then return end

            if type(player.showNotification) == "nil" then
                TriggerClientEvent("esx:showNotification", client, message)
                return
            end

            player.showNotification(message, messageType)
        end

        function Framework.isAdmin(client)
            local retval = false
            local player = Framework.getPlayer(client)

            if player == nil then return false end

            local group = player.getGroup()

            for _, adminGroup in ipairs(Config.FrameworkAdminGroups[Config.Framework]) do
                if group == adminGroup then
                    return true
                end
            end

            if not retval and Ace.Can(client, Permissions.HAS_SERVER_GROUP) then
                retval = true
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
            if type(ESX.ExtendedPlayers) ~= "function" and type(LoadOfficersDefault) ~= "nil" then
                return LoadOfficersDefault()
            end

            local jobNames = {}

            for jobName in pairs(Config.Jobs) do
                jobNames[#jobNames + 1] = jobName
            end

            local officers = {}
            local ok, grouped = pcall(ESX.ExtendedPlayers, "job", jobNames)

            if ok and type(grouped) == "table" then
                for _, players in pairs(grouped) do
                    for _, xPlayer in ipairs(players) do
                        local playerId = xPlayer.source or xPlayer.getSource and xPlayer.getSource()

                        if playerId then
                            dbg.debug("GetOfficers (ExtendedPlayers): Adding player with ID: %s", playerId)
                            officers[#officers + 1] = playerId
                        end
                    end
                end

                return officers
            end

            return LoadOfficersDefault()
        end

        --- Validate job and grade via ESX.DoesJobExist (when available)
        ---@param tag string Player tag for debug logs
        ---@param jobName string
        ---@param gradeIndex number
        ---@return boolean valid
        ---@return number gradeIndex Resolved grade (falls back to 0 if original doesn't exist)
        local function ResolveJobGrade(tag, jobName, gradeIndex)
            if not ESX or type(ESX.DoesJobExist) == "nil" then
                return true, gradeIndex
            end

            if ESX.DoesJobExist(jobName, gradeIndex) then
                return true, gradeIndex
            end

            dbg.job("SetPlayerJob: %s '%s' (grade: %s) not found, trying grade 0", tag, jobName, gradeIndex)

            if ESX.DoesJobExist(jobName, 0) then
                return true, 0
            end

            dbg.job("SetPlayerJob: %s '%s' does not exist at all", tag, jobName)

            return false, gradeIndex
        end

        function Framework.setJob(client, jobName, gradeIndex)
            local player = Framework.getPlayer(client)
            local tag = PlayerTag(client)

            if not player then
                dbg.job("SetPlayerJob: %s not found, skipping", tag)
                return nil
            end

            jobName = jobName or Config.Prisoners.RemovePlayerSetDefaultJob or 'unemployed'
            gradeIndex = gradeIndex or Config.Prisoners.RemovePlayerSetDefaultGrade or 0

            local valid, resolvedGrade = ResolveJobGrade(tag, jobName, gradeIndex)

            if not valid then
                return nil
            end

            if type(player.setJob) ~= "nil" then
                player.setJob(jobName, resolvedGrade, false)
            elseif type(player.SetJob) ~= "nil" then
                player.SetJob(jobName, resolvedGrade, false)
            end

            dbg.job("SetPlayerJob: %s applied '%s' (grade: %s)", tag, jobName, resolvedGrade)
        end

        local disabledInventories = {
            [Inventories.QS] = true,
            [Inventories.OX] = true,
        }

        function Framework.cacheItems()
            if isResourcePresentProvideless(Inventories.QS) then
                return
            end

            if isResourcePresentProvideless(Inventories.OX) then
                return
            end

            if disabledInventories[Config.Inventories] then
                return
            end

            local serverItems = nil

            if Config.Inventories == Inventories.ESX or Config.Inventories == Inventories.CHEEZA then
                serverItems = db.GetServerItems()
            end

            if doesExportExistInResource(Inventories.CODEM, 'GetItemList') then
                ServerItems = exports['codem-inventory']:GetItemList()
            end

            if serverItems and next(serverItems) then
                for k, v in pairs(serverItems) do
                    if v then
                        local itemName = v.name and v.name:upper()

                        if itemName and not ServerItems[itemName:upper()] then
                            ServerItems[itemName:upper()] = v
                        end
                    end
                end

                dbg.debug('Server items: Find %s amount of items on your server.', table.size(serverItems))
            end
        end

        --- @return boolean
        function Framework.clearInventory(client)
            local player = Framework.getPlayer(client)
            local playerInventory = Inventory.getInventoryItems(client)

            if type(playerInventory) == "table" then
                for k, item in pairs(playerInventory) do
                    if item and type(item) == "table" then
                        if not Inventory.KeepSessionItemsWithName[item.name] then
                            Inventory.removeItem(client, item.name, item.count, item.type)
                        end
                    end
                end
            end

            if player then
                local playerLoadout = player.getLoadout()

                if playerLoadout and type(playerLoadout) == "table" then
                    for k, v in pairs(playerLoadout) do
                        if v.name then
                            player.removeWeapon(v.name)
                        end
                    end
                end
            end

            TriggerEvent("esx:playerInventoryCleared", client)
            TriggerEvent("esx:playerLoadoutCleared", client)

            return true
        end

        AddEventHandler("rcore_prison:server:characterSpawned", function(playerId)
            TriggerEvent('rcore_prison:server:playerLoaded', playerId)
        end)

        AddEventHandler("rcore_prison:server:playerLogout", function(playerId)
            TriggerEvent('rcore_prison:server:playerUnloaded', playerId)
        end)

        Framework.cacheItems()
    end
end, "sv-esx code name: Phoenix")
