CreateThread(function()
    if Config.Framework == Framework.NONE then
        function Framework.getIdentifier(client)
            local license = GetPlayerIdentifierByType(client, 'license')
    
            return license
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
            return nil
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
            end
            
            if Config.Jobs[jobName] then
                return true, true
            end
            
            return false, false
        end
    
        function Framework.getCharacterName(client)
            return GetPlayerName(client)
        end

        function Framework.isAdmin(client)
            local retval = false

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

        function Framework.setJob(client, jobName)
            dbg.debug('This feature is not defined for Standalone, will not work!')
        end
    
        AddEventHandler("rcore_prison:server:characterSpawned", function(playerId)
            TriggerEvent('rcore_prison:server:playerLoaded', playerId)
        end)

        AddEventHandler("rcore_prison:server:playerLogout", function(playerId)
            TriggerEvent('rcore_prison:server:playerUnloaded', playerId)
        end)
    end    
end, "sv-standalone code name: Phoenix")
