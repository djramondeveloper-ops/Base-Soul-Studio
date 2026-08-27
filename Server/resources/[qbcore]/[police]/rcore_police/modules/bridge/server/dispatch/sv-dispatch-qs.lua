-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.QS then
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
                job = jobName,
                callLocation = pedCoords,
                callCode = { code = '<10-33>', snippet = '<10-33>' },
                message = dispatchMessage,
                flashes = true, -- You can set to true if you need call flashing sirens...
                blip = {
                    sprite = Config.EmergencyCall.Blip.Sprite, --blip sprite
                    scale = Config.EmergencyCall.Blip.Scale, -- blip scale
                    colour = Config.EmergencyCall.Blip.Colour, -- blip colour
                    flashes = true, -- blip flashes
                    text = dispatchMessage,
                    time = (20 * 1000),
                },
            }
            TriggerEvent('qs-dispatch:server:CreateDispatchCall', dispatchData)
        end
    end
end)
