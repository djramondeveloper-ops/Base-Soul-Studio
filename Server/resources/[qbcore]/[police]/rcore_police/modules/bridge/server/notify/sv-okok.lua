-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Notify == Notify.OKOK then
        Framework.sendNotification = function(client, message, type)
            TriggerClientEvent('okokNotify:Alert', client,
                _U('NOTIFY.TITLE'),
                message,
                5000,
                type or 'info',
                false
            )
        end
    end
end)
