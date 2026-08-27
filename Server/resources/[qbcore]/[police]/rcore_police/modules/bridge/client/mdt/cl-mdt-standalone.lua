-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.MDT == MDT.NONE then
            -- Event handler for opening the MDT (Mobile Data Terminal).
            -- This event is triggered when 'rcore_police:client:showMDT' is fired.
            -- You need to define ExecuteCommand('commandUsedForOpeningMDT')
        AddEventHandler('rcore_police:client:showMDT', function()
            Framework.sendNotification(_U("NOT_MDT_LOADED_STANDALONE"), "error")
            dbg.debug("Not supported MDT detected since running standalone bridge.")
        end)
    end
end)


