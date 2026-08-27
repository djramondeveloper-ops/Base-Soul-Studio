-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.CD then
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
            local dispatchData = {
                job_table = PoliceJobs,
                coords = pedCoords,
                title = _U("DISPATCH.OFFICER_SENT_EMERGENCY_CALL_TITLE"),
                message = dispatchMessage,
                flash = 0,
                unique_id = tostring(math.random(0000000,9999999)),
                sound = 1,
                blip = {
                    sprite = Config.EmergencyCall.Blip.Sprite,
                    scale = Config.EmergencyCall.Blip.Scale,
                    colour = Config.EmergencyCall.Blip.Colour,
                    flashes = false,
                    text = dispatchMessage,
                    time = 5,
                    radius = 0,
                }
            }
            TriggerClientEvent('cd_dispatch:AddNotification', -1, dispatchData)
        end
    end
end)
