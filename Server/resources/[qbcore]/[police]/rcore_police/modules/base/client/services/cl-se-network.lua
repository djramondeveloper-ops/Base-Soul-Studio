-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-network.lua
--  Engineered by Eazy Fxap
--  Original: 68 lines → Cleaned: 26 lines
-- =====================================================

NetworkService = {}

function NetworkService.RegisterNetEvent(eventName, callback, ...)
    local eventId = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", eventName)
    dbg.debugNetwork("Registering protected event named: %s", eventName)
    
    RegisterNetEvent(eventId, function(...)
        if source == "" then return end
        callback(true, ...)
    end)
end

function NetworkService.EventListener(eventName, callback)
    local eventId = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", eventName)
    
    AddEventHandler(eventId, function(...)
        callback(...)
    end)
end
