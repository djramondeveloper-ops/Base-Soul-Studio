-- Server-side handler for hold props during interactions (e.g. hold E animations)
RegisterNetEvent('Interact:SetHoldProps', function(prop)
    local src = source
    if not src or src == 0 then return end

    Player(src).state:set('interact:holdProps', prop, true)
end)

-- Callback for vRP framework: check if player has group(s)
lib.callback.register('interact:hasGroup', function(source, filter)
    if not filter then return true end

    if GetResourceState('vrp') ~= 'started' then
        return true -- No vRP = no restriction
    end

    local Proxy = module('vrp', 'lib/Proxy')
    local vRP = Proxy.getInterface('vRP')
    if not vRP or not vRP.getUserId or not vRP.HasGroup then
        return true
    end

    local user_id = vRP.getUserId(source)
    if not user_id then return false end

    user_id = tonumber(user_id) or user_id

    local filterType = type(filter)
    if filterType == 'string' then
        return vRP.HasGroup(user_id, filter)
    elseif filterType == 'table' then
        for i = 1, #filter do
            if vRP.HasGroup(user_id, filter[i]) then
                return true
            end
        end
        return false
    end

    return true
end)
