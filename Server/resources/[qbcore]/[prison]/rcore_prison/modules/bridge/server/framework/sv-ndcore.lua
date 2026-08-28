CreateThread(function()
    if Config.Framework == Framework.NDCore then
        function Framework.getIdentifier(client)
            local player = Framework.getPlayer(client)
    
            if not player then
                return nil
            end
    
            local identifiers = player.identifiers
    
            if not identifiers then
                return nil
            end
    
            return identifiers['discord'] or identifiers['license'] or identifiers['license2'] 
        end
    
        function Framework.cacheItems()
            return nil
        end


        function Framework.getJob(client)
            local retval =  {
                name = 'unemployed',
                label = 'Unemployed',
                gradeName = 'None',
                grade = 1
            }

            if Ace.Can(client, Permissions.CAN_USE_JOB_COMMANDS) then
                retval =  {
                    name = 'police',
                    label = 'Police',
                    gradeName = 'Officer',
                    grade = 1
                }
            end
    
            return retval
        end
    
            
        function Framework.getPlayer(client)
            return NDCore.getPlayer(client) or {}
        end
    
        function Framework.canPerformJobCommand(client, commandName)
            local job = Framework.getJob(client)
            
            if job == nil then return false, false end
    
            local jobName = job.name
            local jobGrade = job.grade
            local gradeName = job.gradeName:lower()
            
            if jobName == nil then return false end
            
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
            end

            if Config.AllowAdminGroupsUseJailCommands and Framework.isAdmin(client) then
                return true, true
            end
    
            if Config.Jobs[jobName] then
                return true, true
            end
            
            return false, false
        end
 
        function Framework.getCharacterName(client)
            local player = Framework.getPlayer(client)
    
            if not player then
                return 'Unknown'
            end
    
            if player.firstname == nil or player.lastname == nil then
                return 'Unknown'
            end
    
            local name = ('%s %s'):format(player.firstname or 'Unknown', player.lastname or 'Unknown')
    
            return name or GetPlayerName(client)
        end
    
        function Framework.sendNotification(client, message, type)
            TriggerClientEvent('chat:addMessage', client, {
                multiline = true,
                args = { message }
            })
        end
    
        function Framework.isAdmin(client)
            local retval = false

            if Ace.Can(client, Permissions.HAS_SERVER_GROUP) then
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
    
        function Framework.getMoney(client)
            local player = Framework.getPlayer(client)
    
            if not player then
                return 0
            end
    
            return player.cash or 0
        end
    
    
        function Framework.addMoney(client, amount)
            local player = Framework.getPlayer(client)
    
            if not player then
                return 0
            end
    
            return player.addMoney("cash", amount, 'prison - addMoney')
        end
    
        function Framework.removeMoney(client, amount)
            local player = Framework.getPlayer(client)
    
            if not player then
                return 0
            end
    
            return player.deductMoney("cash", amount, 'prison - deductMoney')
        end
        

        function Framework.setJob(client, jobName)
            dbg.debug('This feature is not defined for NDCore, will not work!')
        end

        AddEventHandler("rcore_prison:server:characterSpawned", function(playerId)
            TriggerEvent('rcore_prison:server:playerLoaded', playerId)
        end)

        AddEventHandler("rcore_prison:server:playerLogout", function(playerId)
            TriggerEvent('rcore_prison:server:playerUnloaded', playerId)
        end)
    end
end, "sv-ndcore code name: Phoenix")
