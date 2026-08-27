local CALLBACK_TIMEOUT <const> = 15
local waitingCallbacks = {}

RegisterNetEvent("lb-phone:cb:response", function(requestId, ...)
    local callback = waitingCallbacks[requestId]
    if not callback then return end

    local ok, errorMessage = pcall(callback.cb, ...)
    if not ok then
        local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())
        print(("^1SCRIPT ERROR: Client callback response '%s' failed: %s^7\n%s"):format(callback.event, errorMessage or "", stackTrace or ""))
    end
    waitingCallbacks[requestId] = nil
end)

local function GenerateRequestId()
    local requestId = math.random(999999999)
    while waitingCallbacks[requestId] do requestId = math.random(999999999) end
    return requestId
end

function TriggerClientCallback(event, source, cb, ...)
    local requestId = GenerateRequestId()
    waitingCallbacks[requestId] = { cb = cb or function() end, event = event }

    SetTimeout(CALLBACK_TIMEOUT * 1000, function()
        local callback = waitingCallbacks[requestId]
        if not callback then return end
        infoprint("error", ("Client callback ^1%s^7 timed out after %is. Triggered on %i"):format(event, CALLBACK_TIMEOUT, source))
        callback.cb()
        waitingCallbacks[requestId] = nil
    end)

    TriggerClientEvent("lb-phone:cb:" .. event, source, requestId, ...)
end

function AwaitClientCallback(event, source, ...)
    local response = promise.new()
    TriggerClientCallback(event, source, function(...)
        response:resolve({ ... })
    end, ...)
    return table.unpack(Citizen.Await(response))
end

exports("TriggerClientCallback", TriggerClientCallback)
exports("AwaitClientCallback", AwaitClientCallback)
