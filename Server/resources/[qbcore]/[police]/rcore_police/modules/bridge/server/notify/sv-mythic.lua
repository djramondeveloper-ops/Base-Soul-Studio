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
            if type == 'info' then
                type = 'inform'
            end
            TriggerClientEvent('mythic_notify:client:SendAlert', client, {
                type = type,
                text = message,
                length = 5500
            })
        end
    end
end)
