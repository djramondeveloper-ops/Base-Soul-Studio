-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.RCORE then
        EmergencyCall = function(playerData)
            if not playerData then
                return
            end
            local playerId = playerData.playerId
            local jobName = playerData.group
            local citizenName = Framework.getCharacterShortName(playerId)
            local group = GroupsService.GetGroupByName(jobName)
            local dispatchMessage = _U('DISPATCH.OFFICER_SENT_EMERGENCY_CALL', citizenName)
            local mePed = GetPlayerPed(playerId)
            local pedCoords = GetEntityCoords(mePed)
            if group then
                if Config.EmergencyCall.CooldownState and not EmergencyCalls[playerId] then
                    EmergencyCalls[playerId] = true
                    SetTimeout(Config.EmergencyCall.Cooldown * 60 * 1000, function()
                        EmergencyCalls[playerId] = nil
                    end)
                    if not Config.PanicButton.DispatchDisableGroupNotify then
                        group:Notify(dispatchMessage)
                    end
                    group:StartEvent("RenderEmergencyBlip", pedCoords, dispatchMessage)
                elseif not Config.EmergencyCall.CooldownState then
                    group:Notify(dispatchMessage)
                    group:StartEvent("RenderEmergencyBlip", pedCoords, dispatchMessage) 
                end
            end
            local data = {
                code = '10-33',
                default_priority = 'high',
                coords = vec3(pedCoords.x, pedCoords.y, pedCoords.z),
                job = jobName,
                text = dispatchMessage,
                type = 'alerts',
                blip_time = 5,
                blip = {
                    text = _U('DISPATCH.OFFICER_SENT_EMERGENCY_CALL_TITLE', citizenName),
                    sprite = 104,
                    colour = 0,
                    scale = 1.0,
                    flashes = false,
                    radius = 0,
                }
            }
            TriggerEvent('rcore_dispatch:server:sendAlert', data)
        end
    end
end)
