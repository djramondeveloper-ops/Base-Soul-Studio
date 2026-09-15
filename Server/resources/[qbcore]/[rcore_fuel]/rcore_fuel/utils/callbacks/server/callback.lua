--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

ServerCallbacks = {}
local callbackRateLimit = {}
local callbackGlobalRateLimit = {}

function RegisterServerCallback(name, callbackFn)
    ServerCallbacks[name] = callbackFn
end

RegisterNetEvent("rcore_fuel:callCallback", function(callbackName, callbackId, ...)
    local src = source

    -- Prevent malformed callback requests and callback spam from clients.
    if type(callbackName) ~= "string" or #callbackName == 0 or #callbackName > 128
        or type(callbackId) ~= "number" or callbackId ~= math.floor(callbackId)
        or callbackId < 0 or callbackId > 65535 then
        return
    end

    -- Reject unknown callbacks before allocating per-name limiter state. Otherwise a
    -- malicious client can generate unbounded random callback names and grow memory/logs.
    local callback = ServerCallbacks[callbackName]
    if not callback then
        TriggerClientEvent("rcore_fuel:callback", src, callbackId, false)
        return
    end

    local now = GetGameTimer()

    -- Global per-player token window in addition to the per-callback cooldown. This
    -- prevents rotating through many valid callback names to bypass the individual limit.
    local global = callbackGlobalRateLimit[src]
    if not global or now - global.windowStart >= 1000 then
        global = { windowStart = now, count = 0 }
        callbackGlobalRateLimit[src] = global
    end
    global.count = global.count + 1
    if global.count > 20 then
        TriggerClientEvent("rcore_fuel:callback", src, callbackId, false)
        return
    end

    callbackRateLimit[src] = callbackRateLimit[src] or {}
    local lastCall = callbackRateLimit[src][callbackName]
    if lastCall and now - lastCall < 250 then
        TriggerClientEvent("rcore_fuel:callback", src, callbackId, false)
        return
    end
    callbackRateLimit[src][callbackName] = now

    if callback then
        local responded = false
        local function respond(...)
            if responded then return end
            responded = true
            TriggerClientEvent("rcore_fuel:callback", src, callbackId, ...)
        end

        local ok, err = pcall(callback, src, respond, ...)
        if not ok then
            print(string.format("[rcore_fuel] Server callback '%s' failed: %s", callbackName, tostring(err)))
            respond(false)
        end
    end
end)

AddEventHandler("playerDropped", function()
    callbackRateLimit[source] = nil
    callbackGlobalRateLimit[source] = nil
end)
