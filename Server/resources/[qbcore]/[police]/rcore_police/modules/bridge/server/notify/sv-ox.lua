-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Notify == Notify.OX then
        Framework.sendNotification = function(client, message, type)
            if lib then
                TriggerClientEvent('ox_lib:notify', client, {
                    title = _U('NOTIFY.TITLE'),
                    description = message,
                    type = type,
                    duration = 5000
                })
            end
        end
    end
end)
