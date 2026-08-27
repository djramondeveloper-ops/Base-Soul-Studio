-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Notify == Notify.ST_NOTIFY then
        Framework.sendNotification = function(client, message, type)
            exports['stNotify']:Notify(client, type, message, "", nil, false, 5000)
        end
    end
end)
