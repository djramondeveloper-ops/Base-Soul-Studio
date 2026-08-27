-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.TK then
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
            exports.tk_dispatch:addCall({
                title = _U("DISPATCH.OFFICER_SENT_EMERGENCY_CALL_TITLE"),
                code = '10-33',
                coords = pedCoords,
                message = dispatchMessage,
                flash = true,
                jobs = PoliceJobs,
                blip = {
                    sprite = Config.EmergencyCall.Blip.Sprite, 
                    colour = Config.EmergencyCall.Blip.Colour, 
                    scale = Config.EmergencyCall.Blip.Scale,
                    display = true, 
                    shortRange = false,
                    radius = 0,
                }
            })
        end
    end
end)
