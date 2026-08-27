-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Notify == Notify.QBOX then
        Framework.sendNotification = function(client, message, notifyType)
            exports.qbx_core:Notify(client, message, notifyType, 5000)
        end
    end
end)
