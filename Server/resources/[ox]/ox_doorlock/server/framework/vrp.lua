local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end

    local ok, result = pcall(fn, ...)
    if ok then
        return result
    end

    return nil
end

local function getPassport(source)
    return safeCall(vRP.Passport, source) or safeCall(vRP.getUserId, source)
end

function GetPlayer(playerId)
    local passport = getPassport(playerId)

    if not passport then
        return nil
    end

    return {
        source = playerId,
        Passport = passport
    }
end

function GetCharacterId(player)
    return tostring(player and player.Passport or "")
end

local function hasPermission(passport, permission, level)
    if not passport or not permission then
        return false
    end

    if level and tonumber(level) and tonumber(level) > 0 then
        return safeCall(vRP.HasPermission, passport, permission, tonumber(level)) or false
    end

    return safeCall(vRP.HasPermission, passport, permission) or safeCall(vRP.hasPermission, passport, permission) or false
end

function IsPlayerInGroup(player, filter)
    if not player or not player.Passport or not filter then
        return false
    end

    local passport = player.Passport
    local filterType = type(filter)

    if filterType == "string" then
        return hasPermission(passport, filter) and filter or false
    end

    if filterType ~= "table" then
        return false
    end

    local listType = table.type and table.type(filter) or nil

    if listType == "array" then
        for i = 1, #filter do
            local permission = filter[i]
            if hasPermission(passport, permission) then
                return permission, 0
            end
        end

        return false
    end

    for permission, level in pairs(filter) do
        if hasPermission(passport, permission, level) then
            return permission, tonumber(level) or 0
        end
    end

    return false
end
