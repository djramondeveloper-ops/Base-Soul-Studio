-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Prison == Prison.QB_PRISON then
        SentPlayerToCOMS = function(target)
            if not target then
                return
            end
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
            local time = retval[tostring(1)]
            TriggerServerEvent('qb-communityservice:server:StartCommunityService', target, time)
        end
        SentPlayerToPrison = function(target)
            if not target then
                return
            end
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
                    required = false,
                },
            })
            if not retval then return end
            local time = retval[tostring(1)]
            local jailReason = retval[tostring(2)]
            dbg.debug('SentPlayerToPrison: Sending player with playerId %s for jailTime %s', target, time)
            TriggerServerEvent('rcore_police:server:requestPrison', tonumber(target), time)
            return true
        end
    end
end)
