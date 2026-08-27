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
local CachedJobGrades = {}
CreateThread(function()
    if Config.Framework == Framework.NONE then
        NetworkService.RegisterNetEvent('SetDuty', function(validRequest, state)
            if validRequest then
                if Framework.job then
                    Framework.job.duty = state
                end
                dbg.debug('Setting player duty state: %s', state)
            end
        end)
        CreateThread(function()
            while true do
                if NetworkIsPlayerActive(PlayerId()) then
                    Wait(1000)
                    TriggerServerEvent('rcore_police:server:characterLoaded')
                    PlayerLoaded()
                    break
                end
                Wait(0)
            end
        end)
        function PlayerLoaded()
            TriggerEvent("rcore_police:client:characterLoaded")
        end
        function Framework.getDeathState()
            return false
        end
        RegisterNetEvent('rcore_police:client:showNotification', function(message)
            if source == '' then return end
            Framework.sendNotification(message)
        end)
        function Framework.sendNotification(message, type)
            local icon = "CHAR_DEFAULT"
            local type = 1
            local text = message
            local title = _U('TITLE_NOTIFY')
            local subTitle = ""
            SetNotificationTextEntry("STRING")
            AddTextComponentString(text)
            SetTextFont(1)
            SetNotificationMessage(icon, icon, true, type, title, subTitle)
            DrawNotification(false, true)
        end
        function Framework.setJob(job)
            if not job.grade then
                job.grade = 1
            end
            Framework.job = job
        end
        function Framework.isInJob()
            if Framework.job and Config.Jobs[Framework.job.name] then
                return true
            end
            return false
        end
        function Framework.GetJobGrades(jobName)
            if CachedJobGrades[jobName] then
                return CachedJobGrades[jobName]
            end
            local job = Jobs[jobName]
            if not job or not job.grades then
                return {}
            end
            local grades = {}
            local jobGrades = job.grades
            local size = table.size(jobGrades)
            for i = 0, size, 1 do
                local grade = jobGrades[tostring(i)]
                if grade then
                    table.insert(grades, GradeModel(grade))
                end
            end
            CachedJobGrades[jobName] = grades
            return grades
        end
        RegisterNetEvent('rcore_police:client:playerLoaded')
        AddEventHandler('rcore_police:client:playerLoaded', function(data)
            if source == '' then return end
            local duty = Config.DutySystemState and false or true
            Framework.setJob({
                name = data.name,
                gradeName = data.gradeName,
                grade = data.grade,
                duty = duty,
                isBoss = data.grade_name == 'boss'
            })
        end)
        RegisterNetEvent('rcore_police:client:setJob')
        AddEventHandler('rcore_police:client:setJob', function(data)
            if source == '' then return end
            local duty = Config.DutySystemState and false or true
            if not data then
                Framework.setJob(nil)
            else
                Framework.setJob({
                    name = data.name,
                    gradeName = data.gradeName,
                    grade = data.grade,
                    duty = duty,
                    isBoss = data.gradeName == 'boss'
                })
            end
        end)
        function Framework.CachePoliceGroups()
            return false, {}
        end
    end    
end)
