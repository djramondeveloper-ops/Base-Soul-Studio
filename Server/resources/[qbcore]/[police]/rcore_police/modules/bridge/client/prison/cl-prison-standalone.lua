CreateThread(function()
    if Config.Prison ~= Prison.NONE then return end

    SentPlayerToCOMS = function(target)
        if not target or not isResourcePresentProvideless(Prison.ESX_COMS) then return end

        local retval = UI.Input(_U('INPUT_JAIL_PLAYER.HEADER'), {
            {
                label = _U("PLAYER_NAME_INPUT"),
                placeholder = getPlayerLabelByShowMode(target),
                type = "input",
                disabled = true
            },
            {
                label = _U('INPUT_JAIL_PLAYER.JAIL_TIME_LABEL'),
                placeholder = "",
                type = "number",
                required = true
            },
        })
        if not retval then return end

        local time = tonumber(retval[tostring(1)])
        if not time or time <= 0 then return end
        TriggerServerEvent('esx_communityservice:sendToCommunityService', target, time)
    end

    SentPlayerToPrison = function(target)
        if not target then return end

        local retval = UI.Input(_U('INPUT_JAIL_PLAYER.HEADER'), {
            {
                label = _U("PLAYER_NAME_INPUT"),
                placeholder = getPlayerLabelByShowMode(target),
                type = "input",
                disabled = true
            },
            {
                label = _U('INPUT_JAIL_PLAYER.JAIL_TIME_LABEL'),
                placeholder = "",
                type = "number",
                required = true
            },
            {
                label = _U('INPUT_JAIL_PLAYER.REASON_LABEL'),
                placeholder = "",
                type = "textarea",
            },
        })
        if not retval then return end

        local time = tonumber(retval[tostring(1)])
        local jailReason = tostring(retval[tostring(2)] or 'Prisao policial')
        if not time or time <= 0 then return end

        if GetResourceState('lb-tablet') == 'started' then
            TriggerServerEvent('rcore_police:server:requestSeoulPrison', target, time, jailReason)
            return
        end

        if isResourceLoaded(Prison.QALLE) then
            TriggerServerEvent('esx-qalle-jail:jailPlayer', target, time, jailReason)
            return
        end

        dbg.critical('SentPlayerToPrison: lb-tablet nao esta iniciado e nenhum fallback de prisao confirmado esta disponivel.')
    end
end)
