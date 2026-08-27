-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Licence == Licence.NONE then
        ShowPlayerLicense = function(data)
            dbg.debug('ShowPlayerLicense: Loaded standalone, you need to integrate your resource for licence info.')
        end
    end
end)
