-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Notify == Notify.BRUTAL then
        Framework.sendNotification = function(client, message, type)
            TriggerClientEvent('brutal_notify:SendAlert', client, _U('NOTIFY.TITLE'), message, 5500, type)
        end
    end
end, "sv-brutal_notify code name: Phoenix")
