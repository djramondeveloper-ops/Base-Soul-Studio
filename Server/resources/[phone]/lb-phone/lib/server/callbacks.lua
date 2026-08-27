---@class CallbackOptions
---@field preventSpam? boolean
---@field rateLimit? number
---@field defaultReturn? any

local registeredCallbacks = {}
local exportCallbacks = {}
local callbackRateLimits = {}
local triggeredCallbacks = {}

local function SendCallbackResponse(source, requestId, ...)
    TriggerClientEvent("lb-phone:cb:response", source, requestId, ...)
end

local function CanPlayerTriggerCallback(source, callbackName, options)
    if not options then return true end

    if options.preventSpam then
        triggeredCallbacks[source] = triggeredCallbacks[source] or {}
        if triggeredCallbacks[source][callbackName] then
            debugprint(("callback '%s' is already being processed for player %s"):format(callbackName, source))
            return false
        end
    end

    if options.rateLimit then
        callbackRateLimits[source] = callbackRateLimits[source] or {}
        local calls = math.max(callbackRateLimits[source][callbackName] or 0, 0)

        if calls >= options.rateLimit then
            debugprint(("callback '%s' reached the rate limit for player %s"):format(callbackName, source))
            return false
        end

        callbackRateLimits[source][callbackName] = calls + 1
        SetTimeout(60000, function()
            local playerLimits = callbackRateLimits[source]
            if not playerLimits or not playerLimits[callbackName] then return end
            playerLimits[callbackName] = math.max(playerLimits[callbackName] - 1, 0)
        end)
    end

    if options.preventSpam then
        triggeredCallbacks[source][callbackName] = true
    end

    return true
end

local function FinishCallback(source, event)
    if triggeredCallbacks[source] then
        triggeredCallbacks[source][event] = nil
    end
end

local function ReportCallbackError(event, errorMessage)
    local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())
    print(("^1SCRIPT ERROR: Server callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
end

---@param event string
---@param handler fun(source: number, ...): ...any
---@param options? CallbackOptions
function RegisterCallback(event, handler, options)
    assert(type(event) == "string", "event must be a string")
    assert(type(handler) == "function", "handler must be a function")
    assert(not registeredCallbacks[event], ("event '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent("lb-phone:cb:" .. event, function(requestId, ...)
        local src = source
        if not requestId then return end

        if not CanPlayerTriggerCallback(src, event, options) then
            SendCallbackResponse(src, requestId, options and options.defaultReturn or nil)
            return
        end

        local params = { ... }
        local startedAt = GetGameTimer()
        local ok, result = pcall(function()
            return { handler(src, table.unpack(params)) }
        end)

        if ok then
            debugprint(("Server callback ^5%s^7 took %ims"):format(event, GetGameTimer() - startedAt))
            SendCallbackResponse(src, requestId, table.unpack(result))
        else
            ReportCallbackError(event, result)
            SendCallbackResponse(src, requestId, options and options.defaultReturn or nil)
        end

        FinishCallback(src, event)
    end)
end

---@param event string
---@param handler fun(source: number, cb: fun(...), ...)
---@param options? CallbackOptions
function RegisterLegacyCallback(event, handler, options)
    assert(type(event) == "string", "event must be a string")
    assert(type(handler) == "function", "handler must be a function")
    assert(not registeredCallbacks[event], ("event '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent("lb-phone:cb:" .. event, function(requestId, ...)
        local src = source
        if not requestId then return end

        if not CanPlayerTriggerCallback(src, event, options) then
            SendCallbackResponse(src, requestId, options and options.defaultReturn or nil)
            return
        end

        local params = { ... }
        local startedAt = GetGameTimer()
        local responded = false

        local ok, errorMessage = pcall(function()
            handler(src, function(...)
                if responded then
                    debugprint(("Legacy callback '%s' tried to respond more than once"):format(event))
                    return
                end

                responded = true
                SendCallbackResponse(src, requestId, ...)
                debugprint(("Legacy callback ^5%s^7 took %ims"):format(event, GetGameTimer() - startedAt))
                FinishCallback(src, event)
            end, table.unpack(params))
        end)

        if ok and not responded then
            SetTimeout(15000, function()
                if responded then return end
                responded = true
                debugprint(("Legacy callback '%s' timed out after 15s"):format(event))
                SendCallbackResponse(src, requestId, options and options.defaultReturn or nil)
                FinishCallback(src, event)
            end)
        end

        if not ok then
            ReportCallbackError(event, errorMessage)
            if not responded then
                SendCallbackResponse(src, requestId, options and options.defaultReturn or nil)
            end
            FinishCallback(src, event)
        end
    end)
end

---@param event string
---@param handler fun(source: number, phoneNumber: string, ...): ...any
---@param defaultReturn? any
---@param options? CallbackOptions
function BaseCallback(event, handler, defaultReturn, options)
    if type(defaultReturn) == "table" and options == nil and
        (defaultReturn.preventSpam ~= nil or defaultReturn.rateLimit ~= nil or defaultReturn.defaultReturn ~= nil) then
        options = defaultReturn
        defaultReturn = options.defaultReturn
    end

    if options and options.defaultReturn ~= nil and defaultReturn == nil then
        defaultReturn = options.defaultReturn
    end

    RegisterCallback(event, function(source, ...)
        local phoneNumber = GetEquippedPhoneNumber and GetEquippedPhoneNumber(source)
        if not phoneNumber then
            debugprint(("BaseCallback '%s' blocked: player has no equipped phone."):format(event))
            return defaultReturn
        end
        return handler(source, phoneNumber, ...)
    end, options)
end

local function CanResourceRegisterCallback(resource, event)
    if registeredCallbacks[event] then
        infoprint("error", ("Callback '%s' is already registered"):format(event))
        return false
    end

    exportCallbacks[resource] = exportCallbacks[resource] or {}
    if table.contains(exportCallbacks[resource], event) then return false end
    table.insert(exportCallbacks[resource], event)
    return true
end

exports("RegisterCallback", function(event, handler, options)
    local resource = GetInvokingResource()
    if CanResourceRegisterCallback(resource, event) then
        RegisterCallback(event, handler, options)
    end
end)

exports("BaseCallback", function(event, handler, options)
    local resource = GetInvokingResource()
    if CanResourceRegisterCallback(resource, event) then
        BaseCallback(event, handler, nil, options)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    local callbacks = exportCallbacks[resource]
    if not callbacks then return end

    for i = 1, #callbacks do
        local event = callbacks[i]
        if registeredCallbacks[event] then
            RemoveEventHandler(registeredCallbacks[event])
            registeredCallbacks[event] = nil
        end
    end
    exportCallbacks[resource] = nil
end)

AddEventHandler("playerDropped", function()
    triggeredCallbacks[source] = nil
    callbackRateLimits[source] = nil
end)
