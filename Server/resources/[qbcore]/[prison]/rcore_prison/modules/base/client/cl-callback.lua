local pendingCallbacks = {}
local callbackCooldowns = {}

local CALLBACK_EVENT_TEMPLATE = "__rcore_prison_cb_%s"
local CALLBACK_RESOURCE = "rcore_prison"

RegisterNetEvent(CALLBACK_EVENT_TEMPLATE:format(CALLBACK_RESOURCE), function(requestId, ...)
    local resolver = pendingCallbacks[requestId]

    if resolver then
        return resolver(...)
    end
end)

local function canTriggerCallback(callbackName, cooldownMs)
    if cooldownMs and type(cooldownMs) == "number" and cooldownMs > 0 then
        local now = GetGameTimer()
        local nextAllowedAt = callbackCooldowns[callbackName] or 0

        if now < nextAllowedAt then
            return false
        end

        callbackCooldowns[callbackName] = now + cooldownMs
    end

    return true
end

local function invokeCallback(_, callbackName, cooldownMs, responseHandler, ...)
    if not canTriggerCallback(callbackName, cooldownMs) then
        return
    end

    local requestId

    repeat
        requestId = ("%s:%s"):format(callbackName, math.random(0, 100000))
    until not pendingCallbacks[requestId]

    TriggerServerEvent(
        CALLBACK_EVENT_TEMPLATE:format(callbackName),
        CALLBACK_RESOURCE,
        requestId,
        ...
    )

    local responsePromise = responseHandler and nil or promise.new()

    pendingCallbacks[requestId] = function(response)
        pendingCallbacks[requestId] = nil

        if responsePromise then
            return responsePromise:resolve(response)
        end

        responseHandler(table.unpack(response))
    end

    if responsePromise then
        return table.unpack(Citizen.Await(responsePromise))
    end
end

callback = setmetatable({}, {
    __call = invokeCallback
})

function callback.await(callbackName, cooldownMs, ...)
    return invokeCallback(nil, callbackName, cooldownMs, false, ...)
end

function callback.register(callbackName, handler)
    RegisterNetEvent(CALLBACK_EVENT_TEMPLATE:format(callbackName), function(requestId, responseEventName, ...)
        local results = table.pack(handler(...))

        TriggerServerEvent(
            CALLBACK_EVENT_TEMPLATE:format(requestId),
            responseEventName,
            results
        )
    end)
end