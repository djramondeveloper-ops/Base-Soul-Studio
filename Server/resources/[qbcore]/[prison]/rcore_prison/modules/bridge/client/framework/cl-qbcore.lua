CreateThread(function()
    if Config.Framework == Framework.QBCore then
        local QBCore = nil

        local success = pcall(function()
            if GetResourceState('vrp') == 'started' or GetResourceState('vrp') == 'starting' then
                QBCore = exports['vrp']:GetCoreObject()
            else
                QBCore = exports[Framework.QBCore]:GetCoreObject()
            end
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

        function HandleInventoryOpenState(state)
            local ply = LocalPlayer

            if not ply then
                return
            end

            ply.state:set('inv_busy', state)
        end

        function Framework.showHelpNotification(text)
            DisplayHelpTextThisFrame(text, false)
            BeginTextCommandDisplayHelp(text)
            EndTextCommandDisplayHelp(0, false, false, -1)
        end

        function Framework.sendNotification(message, type)
            TriggerEvent('QBCore:Notify', message, type, 5000)
        end

        function Framework.isInJob()
            if Framework.job and Config.Jobs[Framework.job.name] then
                return true
            end

            return false
        end

        function CachePlayerData()
            if not QBCore then
                return
            end

            local playerData = QBCore.Functions.GetPlayerData()
            local retval = {}

            if playerData and playerData.job then
                retval = {
                    job = playerData.job,
                    identifier = playerData.citizenid,
                }
            end

            if retval and next(retval) then
                if retval.identifier then
                    Framework.identifier = retval.identifier
                end

                Framework.setJob({
                    name = retval.job.name,
                    gradeName = retval.job.grade.name,
                    grade = retval.job.grade.level,
                    duty = retval.job.onduty,
                    isBoss = retval.job.isboss
                })
            end
        end

        function GetCharacterIdentifier()
            local playerData = QBCore.Functions.GetPlayerData()

            if playerData and playerData.citizenid then
                return playerData.citizenid
            end

            return nil
        end

        function Framework.setJob(job)
            Framework.job = job
        end

        RegisterNetEvent(Config.FrameworkEvents['QBCore:Client:OnJobUpdate'])
        AddEventHandler(Config.FrameworkEvents['QBCore:Client:OnJobUpdate'], function(updatedJobData)
            dbg.debug('Framework - job: Updating player job data!')
            Framework.setJob({
                name = updatedJobData.name,
                gradeName = updatedJobData.grade.name,
                grade = updatedJobData.grade.level,
                isOnDuty = updatedJobData.onduty,
                isBoss = updatedJobData.isboss
            })
        end)

        AddEventHandler("rcore_prison:client:characterSpawned", function()
            CachePlayerData()
        end)
    end
end, "cl-qbcore code name: Phoenix")
