local NewDispatchName = "cd_dispatch3d"
local HasNewDispatch = false

local PayloadConfigurationByDispatch = {
    [Dispatches.CD] = {
        createCall = function(dispatchData)
            return {
                job_table = dispatchData.jobs or { 'police', 'sheriff' },
                coords = vec3(dispatchData.coords.x, dispatchData.coords.y, dispatchData.coords.z) or vector3(0, 0, 0),
                title = dispatchData.title or 'Prison break',
                message = dispatchData.message or 'Escape from prison',
                flash = 0,
                sound = 1,
                unique_id = tostring(math.random(0000000, 9999999)),
                blip = dispatchData.blip or {
                    sprite = 431,
                    scale = 1.2,
                    colour = 3,
                    flashes = false,
                    text = dispatchData.message or 'Escape from prison',
                    time = 5,
                    radius = 0,
                }
            }
        end,
    },
    [NewDispatchName] = {
        createCall = function(dispatchData)
            return {
                job_table = dispatchData.jobs or { 'police', 'sheriff' },
                coords = vec3(dispatchData.coords.x, dispatchData.coords.y, dispatchData.coords.z) or vector3(0, 0, 0),
                title = dispatchData.title or 'Prison break',
                message = dispatchData.message or 'Escape from prison',
                flash = 0,
                sound = 1,
                blip = dispatchData.blip or {
                    sprite = 431,
                    scale = 1.2,
                    colour = 3,
                    flashes = false,
                    text = dispatchData.message or 'Escape from prison',
                    time = 5,
                    radius = 0,
                }
            }
        end,
    }
}

CreateThread(function()
    if isResourcePresentProvideless(NewDispatchName) then
        Config.Dispatches = Dispatches.CD
        HasNewDispatch = true
    end

    if Config.Dispatches == Dispatches.CD then
        Dispatch.Breakout = function(playerId)
            local activeDispatch = HasNewDispatch and NewDispatchName or Config.Dispatches
            local config = PayloadConfigurationByDispatch[activeDispatch]

            if not config then
                return dbg.critical(
                "Dispatch: Failed to find payload configuration for dispatch %s, cancelling dispatch call for breakout",
                    activeDispatch)
            end

            local dispatchPayload = config.createCall({
                jobs = Config.Escape.NotifyJobs,
                coords = vec3(SH.data.prisonYard.x, SH.data.prisonYard.y, SH.data.prisonYard.z),
                title = _U('DISPATCH.BREAKOUT_BLIP_TEXT'),
                message = _U('DISPATCH.BREAKOUT_ACTIVE_MESSAGE'),
                blip = {
                    sprite = 431,
                    scale = 1.0,
                    colour = 3,
                    flashes = false,
                    text = _U('DISPATCH.BREAKOUT_BLIP_TEXT'),
                    time = 5,
                    radius = 0,
                }
            })

            if not dispatchPayload then
                return
            end

            if doesExportExistInResource(activeDispatch, "GetPlayersDispatchData") then
                TriggerEvent('cd_dispatch:AddNotification', dispatchPayload)
            else
                TriggerClientEvent('cd_dispatch:AddNotification', -1, dispatchPayload)
            end

            dbg.info('Dispatch.Breakout: Prison break started!')
        end
    end
end, "sv-codesign code name: Phoenix")
