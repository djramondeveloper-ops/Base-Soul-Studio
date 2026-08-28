NetworkService = {}

function NetworkService.EventListener(eventName, callback)
    local resourceEventName = string.format("%s:%s:%s", GetCurrentResourceName(), "server", eventName)

    AddEventHandler(resourceEventName, function(...)
        callback(...)
    end)
end
