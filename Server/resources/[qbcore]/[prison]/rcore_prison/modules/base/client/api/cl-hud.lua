local radarEvents = Config.Hud.States or {
    [HEARTBEAT_EVENTS.PRISONER_LOADED]   = false,
    [HEARTBEAT_EVENTS.PRISONER_NEW]      = false,
    [HEARTBEAT_EVENTS.PRISONER_RELEASED] = true,
}

local function setRadarVisibility(state)
    if Config.Hud.HandleRenderState(state) then
        Config.Hud.HandleRenderState(state) 
    else
        DisplayRadar(state)
    end
end

NetworkService.EventListener('heartbeat', function(eventType, data)
    if not Config.Hud.Enable then return end
    
    local newState = radarEvents[eventType]

    if newState ~= nil then
        setRadarVisibility(newState)
    end
end)

exports["rcore_prison"]:registerListener("onHud", function(state, statusCode, reason)
    -- setRadarVisibility(state)
end)
