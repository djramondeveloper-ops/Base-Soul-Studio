-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMIN TABLET BRIDGE
-- Compat seguro para MRI QAdmin rodar na Seoul Base (vRP/Creative + adapter QBCore).
-- Não inventa core novo: primeiro tenta qb-core real, depois o adapter GetCoreObject do vrp.
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulQAdmin = SeoulQAdmin or {}

local cachedCore

local function tryCore(resource)
    if not resource or resource == '' then return nil end
    local state = GetResourceState(resource)
    if state ~= 'started' and state ~= 'starting' then return nil end

    local ok, core = pcall(function()
        return exports[resource]:GetCoreObject()
    end)

    if ok and type(core) == 'table' then return core end
    return nil
end

local function notifyFallback(source, message, notifyType, length)
    source = tonumber(source or 0) or 0
    message = tostring(message or '')
    notifyType = notifyType or 'aviso'
    length = tonumber(length or 5000) or 5000

    if source > 0 then
        TriggerClientEvent('Notify', source, notifyType, message, length)
    else
        TriggerEvent('Notify', notifyType, message, length)
    end
end

local function roundFallback(value, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor((tonumber(value) or 0) * mult + 0.5) / mult
end

local function trimFallback(value)
    if not value then return nil end
    return (string.gsub(tostring(value), '^%s*(.-)%s*$', '%1'))
end

local function normalizeCore(core)
    if type(core) ~= 'table' then return core end

    core.Functions = core.Functions or {}
    core.Shared = core.Shared or {}
    core.Commands = core.Commands or { List = {}, IgnoreList = { user = true } }
    core.Commands.List = core.Commands.List or {}
    core.Commands.IgnoreList = core.Commands.IgnoreList or { user = true }

    core.Shared.Round = core.Shared.Round or roundFallback
    core.Shared.Trim = core.Shared.Trim or trimFallback
    core.Shared.Vehicles = core.Shared.Vehicles or {}
    core.Shared.Items = core.Shared.Items or {}
    core.Shared.Jobs = core.Shared.Jobs or {}
    core.Shared.Gangs = core.Shared.Gangs or {}

    core.Functions.Notify = core.Functions.Notify or notifyFallback
    core.Functions.GetPlayers = core.Functions.GetPlayers or function()
        local list = {}
        for _, src in ipairs(GetPlayers()) do list[#list + 1] = tonumber(src) or src end
        return list
    end
    core.Functions.GetQBPlayers = core.Functions.GetQBPlayers or function()
        local players = {}
        for _, src in ipairs(core.Functions.GetPlayers()) do
            local player = core.Functions.GetPlayer and core.Functions.GetPlayer(src)
            if player then players[src] = player end
        end
        return players
    end
    core.Functions.GetPlayerData = core.Functions.GetPlayerData or function() return {} end
    core.Functions.GetCoords = core.Functions.GetCoords or function(entity)
        local c = GetEntityCoords(entity)
        return vector4(c.x, c.y, c.z, GetEntityHeading(entity))
    end
    core.Functions.CreateCallback = core.Functions.CreateCallback or function(name, cb)
        core.ServerCallbacks = core.ServerCallbacks or {}
        core.ServerCallbacks[name] = cb
    end
    core.Functions.TriggerCallback = core.Functions.TriggerCallback or function(name, source, cb, ...)
        core.ServerCallbacks = core.ServerCallbacks or {}
        local handler = core.ServerCallbacks[name]
        if handler then return handler(source, cb, ...) end
        if cb then cb(nil) end
    end


    core.Functions.AddPermission = core.Functions.AddPermission or function(source, permission)
        local player = core.Functions.GetPlayer and core.Functions.GetPlayer(source)
        local passport = player and player.PlayerData and player.PlayerData.citizenid
        if passport and SeoulQAdminRuntime and SeoulQAdminRuntime.SetPermission then
            return SeoulQAdminRuntime.SetPermission(passport, permission, 1)
        end
        return false
    end
    core.Functions.RemovePermission = core.Functions.RemovePermission or function(source, permission)
        local player = core.Functions.GetPlayer and core.Functions.GetPlayer(source)
        local passport = player and player.PlayerData and player.PlayerData.citizenid
        if passport and SeoulQAdminRuntime and SeoulQAdminRuntime.RemovePermission then
            return SeoulQAdminRuntime.RemovePermission(passport, permission)
        end
        return false
    end

    if type(core.Commands.Add) ~= 'function' then
        core.Commands.Add = function(name, help, arguments, argsrequired, callback, permission, ...)
            if type(name) ~= 'string' or name == '' or type(callback) ~= 'function' then return false end
            core.Commands.List[name] = {
                name = name,
                help = help,
                arguments = arguments or {},
                argsrequired = argsrequired == true,
                permission = permission
            }
            RegisterCommand(name, function(source, args, rawCommand)
                callback(source, args or {}, rawCommand)
            end, false)
            return true
        end
    end

    core.Commands.Refresh = core.Commands.Refresh or function() return true end

    return core
end

function SeoulQAdminResolveCore()
    if cachedCore and type(cachedCore) == 'table' then return normalizeCore(cachedCore) end

    cachedCore = tryCore('qb-core') or tryCore('vrp')
    if cachedCore then return normalizeCore(cachedCore) end

    local ok = pcall(function()
        TriggerEvent('QBCore:GetObject', function(obj)
            if type(obj) == 'table' then cachedCore = obj end
        end)
    end)

    if ok and cachedCore then return normalizeCore(cachedCore) end
    return nil
end

local FunctionProxy = {}
setmetatable(FunctionProxy, {
    __index = function(_, key)
        local core = SeoulQAdminResolveCore()
        local fn = core and core.Functions and core.Functions[key]
        if fn then return fn end

        return function(...)
            if key == 'GetQBPlayers' then return {} end
            if key == 'GetPlayers' then return {} end
            if key == 'GetPlayer' then return nil end
            if key == 'GetPlayerData' then return {} end
            if key == 'GetIdentifier' then return nil end
            if key == 'HasPermission' then return false end
            if key == 'Notify' then return notifyFallback(...) end
            if key == 'CreateCallback' then return nil end
            if key == 'TriggerCallback' then local args = { ... }; local cb = args[3] or args[2]; if type(cb) == 'function' then cb(nil) end; return nil end
            return nil
        end
    end
})

local SharedProxy = {}
setmetatable(SharedProxy, {
    __index = function(_, key)
        local core = SeoulQAdminResolveCore()
        local shared = core and core.Shared and core.Shared[key]
        if shared ~= nil then return shared end
        if key == 'Jobs' or key == 'Gangs' or key == 'Vehicles' or key == 'Items' then return {} end
        if key == 'Round' then return roundFallback end
        if key == 'Trim' then return trimFallback end
        return nil
    end
})

local CommandsProxy = { List = {}, IgnoreList = { user = true } }
function CommandsProxy.Add(name, help, arguments, argsrequired, callback, permission, ...)
    local core = SeoulQAdminResolveCore()
    if core and core.Commands and type(core.Commands.Add) == 'function' and core.Commands ~= CommandsProxy then
        return core.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    end
    if type(name) ~= 'string' or name == '' or type(callback) ~= 'function' then return false end
    CommandsProxy.List[name] = { name = name, help = help, arguments = arguments or {}, argsrequired = argsrequired == true, permission = permission }
    RegisterCommand(name, function(source, args, rawCommand)
        callback(source, args or {}, rawCommand)
    end, false)
    return true
end
function CommandsProxy.Refresh() return true end

local CoreProxy = { Functions = FunctionProxy, Shared = SharedProxy, Commands = CommandsProxy, ServerCallbacks = {}, ClientCallbacks = {}, Players = {} }
setmetatable(CoreProxy, {
    __index = function(_, key)
        local core = SeoulQAdminResolveCore()
        if core and core[key] ~= nil then return core[key] end
        return nil
    end,
    __newindex = function(_, key, value)
        local core = SeoulQAdminResolveCore()
        if core then core[key] = value end
        rawset(CoreProxy, key, value)
    end
})

function SeoulQAdminGetCoreObject()
    return SeoulQAdminResolveCore() or CoreProxy
end
