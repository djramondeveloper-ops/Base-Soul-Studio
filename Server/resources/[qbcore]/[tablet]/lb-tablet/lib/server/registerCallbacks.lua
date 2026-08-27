local registeredCallbacks = {}

local triggeredCallbacks = {}

local exportCallbacks = {}

function RegisterCallback(event, handler, antiSpam, defaultReturn)
    assert(type(event) == "string", "callback must be a string")
    assert(registeredCallbacks[event] == nil, ("callback '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent("lb-tablet:cb:" .. event, function(requestId, ...)
        local src = source

        if antiSpam then
            if not triggeredCallbacks[src] then
                triggeredCallbacks[src] = {}
            end

            if triggeredCallbacks[src][event] then
                debugprint(src, "has already triggered callback", event)
                TriggerClientEvent("lb-tablet:cb:response", src, requestId, defaultReturn)

                return
            end

            triggeredCallbacks[src][event] = true
        end

        local params = { ... }
        local startTime = os.nanotime()

        local success, errorMessage = pcall(function()
            TriggerClientEvent("lb-tablet:cb:response", src, requestId, handler(src, table.unpack(params)))

            local finishTime = os.nanotime()
            local ms = (finishTime - startTime) / 1e6

            debugprint(("Callback ^5%s^7 took %.4fms"):format(event, ms))
        end)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
            TriggerClientEvent("lb-tablet:cb:response", src, requestId, defaultReturn)
        end

        if antiSpam and triggeredCallbacks[src] then
            triggeredCallbacks[src][event] = nil
        end
    end) --[[@as EventHandler]]
end

function BaseCallback(event, handler, defaultReturn, antiSpam)
    RegisterCallback(event, function(source, ...)
        local tabletId = GetEquippedTablet(source)

        if not tabletId then
            debugprint(("^1%s^7: no tablet found for %s | %s"):format(event, GetPlayerName(source), source))
            return defaultReturn
        end

        return handler(source, tabletId, ...)
    end, antiSpam, defaultReturn)
end

local function CanResourceRegisterCallback(resource, event)
    if registeredCallbacks[event] then
        infoprint("error", ("Callback '%s' is already registered"):format(event))

        return false
    end

    if not exportCallbacks[resource] then
        exportCallbacks[resource] = {}
    end

    if table.contains(exportCallbacks[resource], event) then
        infoprint("error", ("Callback '%s' is already registered by resource '%s'"):format(event, resource))

        return false
    end

    table.insert(exportCallbacks[resource], event)

    return true
end

exports("RegisterCallback", function(event, handler, antiSpam, defaultReturn)
    local resource = GetInvokingResource()

    if CanResourceRegisterCallback(resource, event) then
        RegisterCallback(event, handler, antiSpam, defaultReturn)
    end
end)

exports("BaseCallback", function(event, handler, defaultReturn, antiSpam)
    local resource = GetInvokingResource()

    if CanResourceRegisterCallback(resource, event) then
        BaseCallback(event, handler, defaultReturn, antiSpam)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    local callbacks = exportCallbacks[resource]

    if not callbacks then
        return
    end

    for i = 1, #callbacks do
        local event = callbacks[i]
        local eventHandler = registeredCallbacks[event]

        if eventHandler then
            RemoveEventHandler(eventHandler)
        end

        registeredCallbacks[event] = nil
    end

    exportCallbacks[resource] = nil
end)
