-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.DUSA then
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
                id = 0,
                event = 'NEW ALERT',
                title = _U("DISPATCH.OFFICER_SENT_EMERGENCY_CALL_TITLE"),
                description = dispatchMessage,
                code = '10-33',
                codeName = 'explosion',
                coords = pedCoords,
                priority = 0,
                alert = {
                    radius = 0, -- Radius around the blip
                    sprite = Config.EmergencyCall.Blip.Sprite, -- Sprite of the blip
                    color = Config.EmergencyCall.Blip.Colour, -- Color of the blip
                    scale = Config.EmergencyCall.Blip.Scale, -- Scale of the blip
                    length = 2, -- How long it stays on the map
                    sound = "Lose_1st", -- Alert sound
                    sound2 = "GTAO_FM_Events_Soundset", -- Alert sound
                    offset = "false", -- Blip / radius offset
                    flash = "true" -- Blip flash
                },
                recipientJobs = PoliceJobs,
            }
            TriggerClientEvent('rcore_police:client:setDispatch', playerId, dispatchData)
        end
    end
end)
