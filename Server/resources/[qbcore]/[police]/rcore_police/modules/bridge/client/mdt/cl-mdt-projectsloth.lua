-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.MDT == MDT.PS then
            -- Event handler for opening the MDT (Mobile Data Terminal).
            -- This event is triggered when 'rcore_police:client:showMDT' is fired.
            -- ExecuteCommand is a native function that simulates a user typing a command in chat.
            -- In this case, it executes the command './mdt', which internally triggers the logic
            -- registered under that command name.
        AddEventHandler('rcore_police:client:showMDT', function()
            ExecuteCommand('mdt') -- Executes the command './mdt'
        end)
    end
end)


