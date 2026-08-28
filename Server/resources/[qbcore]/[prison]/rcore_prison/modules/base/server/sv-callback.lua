local pendingCallbacks = {}
local callbackEventPattern = "__rcore_prison_cb_%s"
local resourceCallbackChannel = callbackEventPattern:format("rcore_prison")

RegisterNetEvent(resourceCallbackChannel, function(callbackId, ...)
    local handler = pendingCallbacks[callbackId]
    if not handler then
        return
    end

    return handler(...)
end)

local function invokeClientCallback(_, eventName, targetPlayerId, callbackFn, ...)
    local callbackId

    repeat
        callbackId = string.format("%s:%s:%s", eventName, math.random(0, 100000), targetPlayerId)
    until not pendingCallbacks[callbackId]

    TriggerClientEvent(
        callbackEventPattern:format(eventName),
        targetPlayerId,
        "rcore_prison",
        callbackId,
        ...
    )

    local callbackPromise = not callbackFn and promise.new() or nil

    pendingCallbacks[callbackId] = function(result)
        pendingCallbacks[callbackId] = nil

        if callbackPromise then
            return callbackPromise:resolve(result)
        end

        return callbackFn(table.unpack(result))
    end

    if callbackPromise then
        return table.unpack(Citizen.Await(callbackPromise))
    end
end

callback = setmetatable({}, {
    __call = invokeClientCallback,
})

function callback.await(eventName, targetPlayerId, ...)
    return invokeClientCallback(_, eventName, targetPlayerId, false, ...)
end

function callback.register(eventName, handler)
    RegisterNetEvent(callbackEventPattern:format(eventName), function(resourceName, callbackId, ...)
        TriggerClientEvent(
            callbackEventPattern:format(resourceName),
            source,
            callbackId,
            { handler(source, ...) }
        )
    end)
end
