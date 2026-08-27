-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.RCORE then
            -- Event handler for opening the Dispatch 
            -- This event is triggered when 'rcore_police:client:showDispatch' is fired.
            -- You need to define ExecuteCommand('commandUsedForOpeningDispatch')
        AddEventHandler('rcore_police:client:showDispatch', function()
            ExecuteCommand('panel')
        end)
    end
end)


