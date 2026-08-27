-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.MDT == MDT.DRX then
            -- Event handler for opening the MDT (Mobile Data Terminal).
            -- This event is triggered when 'rcore_police:client:showMDT' is fired.
        AddEventHandler('rcore_police:client:showMDT', function()
            exports.drx_mdt:OpenMDT()
        end)
    end
end)

