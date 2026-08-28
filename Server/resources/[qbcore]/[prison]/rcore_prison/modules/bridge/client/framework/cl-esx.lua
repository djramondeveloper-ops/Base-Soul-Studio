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

        if not ESX then
            return
        end

        function Framework.showHelpNotification(text)
            ESX.ShowHelpNotification(text, true, false)
        end

        function Framework.sendNotification(message, type)
            ESX.ShowNotification(message, type)
        end

        function HandleInventoryOpenState(state)
            local ply = LocalPlayer

            if not ply then
                return
            end
        end

        function GetCharacterIdentifier()
            local playerData = ESX.GetPlayerData()

            if playerData and playerData.identifier then
                return playerData.identifier
            end

            return nil
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

            local duty = false

            if retval and next(retval) then
                if retval.identifier then
                    Framework.identifier = retval.identifier
                end

                Framework.setJob({
                    name = retval.job.name,
                    gradeName = retval.job.grade_name,
                    grade = retval.job.grade,
                    duty = duty,
                    isBoss = retval.job.grade_name == "boss"
                })
            end
        end

        function Framework.setJob(job)
            Framework.job = job
        end

        RegisterNetEvent(Config.FrameworkEvents['esx:setJob'])
        AddEventHandler(Config.FrameworkEvents['esx:setJob'], function(job)
            dbg.debug('Framework - job: Updating player job data!')
            Framework.setJob({
                name = job.name,
                gradeName = job.grade_name,
                grade = job.grade,
                isOnDuty = false,
                isBoss = job.grade_name == "boss"
            })
        end)

        AddEventHandler("rcore_prison:client:characterSpawned", function()
            CachePlayerData()
        end)
    end
end, "cl-esx code name: Phoenix")
