-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================


if Config.Dispatch == Dispatch.LB_TABLET then
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
        local data = {
            code = '10-64',
            priority = 'high',
            title = _U('DISPATCH.OFFICER_SENT_EMERGENCY_CALL_TITLE'),
            time = 30, -- LB Tablet usa segundos
            job = jobName, -- LSPD ou PRPD real da Seoul
            description = dispatchMessage,
            location = {
                label = 'Officer',
                coords = vec2(pedCoords.x, pedCoords.y)
            }
        }
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
        local dispatchId = exports[Dispatch.LB_TABLET]:AddDispatch(data)
        if dispatchId then
            dbg.debug('EmergencyCall: Using %s since player named %s invoked emergency call!', Config.Dispatch, citizenName)
        end
    end
end
