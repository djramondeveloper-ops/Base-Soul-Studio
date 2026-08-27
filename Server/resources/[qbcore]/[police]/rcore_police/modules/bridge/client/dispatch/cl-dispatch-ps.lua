-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Dispatch == Dispatch.PS then
            -- Event handler for opening the Dispatch.
            -- This event is triggered when 'rcore_police:client:showDispatch' is fired.
            -- ExecuteCommand is a native function that simulates a user typing a command in chat.
            -- In this case, it executes the command './commandUsedForOpeningDispatch', which internally triggers the logic
            -- registered under that command name.
        AddEventHandler('rcore_police:client:showDispatch', function()
            Framework.sendNotification(_U("NOT_MDT_LOADED_STANDALONE"), "error")
            dbg.debug("Not dispatch panel detected.")
        end)
        RegisterNetEvent('rcore_police:client:setDispatch', function(payload)
            if not payload then
                return
            end
            TriggerServerEvent('ps-dispatch:server:notify', payload)
        end)
    end
end)

