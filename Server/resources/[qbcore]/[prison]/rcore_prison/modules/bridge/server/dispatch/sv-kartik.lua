local jobs = {}

CreateThread(function()
    if Config.Dispatches == Dispatches.KARTIK then
        for _, jobName in pairs(Config.Escape.NotifyJobs) do
            jobs[tostring(jobName)] = true
        end
        
        Dispatch.Breakout = function(playerId)
            local coords = vec3(SH.data.prisonYard.x, SH.data.prisonYard.y, SH.data.prisonYard.z)
            local payload = {
                code = '10-64',
                title = 'Prison break',
                type = "Call",
                sound = "gunshots",
                description = _U('DISPATCH.BREAKOUT_ACTIVE_MESSAGE'),
                coords = coords,
                blip = {
                    radius = 100.0,
                    sprite = 488,
                    color = 1,
                    scale = 1.5,
                    length = 30
                },
                jobs = jobs
            }
            
            TriggerClientEvent('rcore_prison:client:setDispatch', playerId, payload)
        end
    end
end, "sv-standalone code name: Phoenix")
