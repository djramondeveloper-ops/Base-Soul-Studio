-- ================================================================
-- LB Phone - Custom Apps Server Handler
-- Manages custom application functionality for user-defined phone apps
-- ================================================================

-- Handle custom application usage on the server side
-- This event is triggered when a player uses a custom app that has server-side functionality
-- Custom apps are defined in the Config.CustomApps table and can have optional server callbacks
RegisterNetEvent("lb-phone:customApp", function(customAppId)
    local playerSource = source  -- Get the player who triggered this event
    
    -- Retrieve the custom app configuration from the config
    -- Each custom app can define its own server-side behavior
    local customAppConfig = Config.CustomApps[customAppId]
    
    -- Check if the custom app exists and has a server-side callback function
    -- The onServerUse function is optional and only executed if defined
    local serverCallback = customAppConfig and customAppConfig.onServerUse
    
    if serverCallback then
        -- Execute the custom app's server-side callback function
        -- Pass the player source to allow the callback to interact with the specific player
        serverCallback(playerSource)
    end
    
    -- Note: If no server callback is defined, the custom app operates entirely client-side
    -- This allows for flexible app development where some apps need server interaction
    -- and others can function purely on the client
end)


-- -- Em config.lua (hipotético):
-- Config.CustomApps = {
--     ["meuapp"] = {
--         name = "Meu App",
--         icon = "icon.png",
--         onServerUse = function(source)
--             -- Código server-side quando o app é usado
--             print("Player " .. source .. " usou meu app customizado!")
--         end
--     }
-- }