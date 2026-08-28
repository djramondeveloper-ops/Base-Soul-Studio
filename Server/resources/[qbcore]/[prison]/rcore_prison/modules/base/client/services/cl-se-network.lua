NetworkService = {}

local function buildProtectedEventName(eventName)
    return ("%s:%s:%s"):format(GetCurrentResourceName(), "client", eventName)
end

function NetworkService.RegisterNetEvent(eventName, handler, ...)
    local protectedEventName = buildProtectedEventName(eventName)

    dbg.debugNetwork("Registering protected event named: %s", eventName)

    RegisterNetEvent(protectedEventName, function(...)
        if source == "" then
            return
        end

        handler(true, ...)
    end)
end

function NetworkService.EventListener(eventName, handler)
    local protectedEventName = buildProtectedEventName(eventName)

    AddEventHandler(protectedEventName, function(...)
        handler(...)
    end)
end
