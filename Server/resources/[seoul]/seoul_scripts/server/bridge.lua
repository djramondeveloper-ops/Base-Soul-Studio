-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SCRIPTS SERVER BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module('vrp','lib/Tunnel') or {}
Proxy = module('vrp','lib/Proxy') or {}
vRP = vRP or Proxy.getInterface('vRP')
vRPC = vRPC or Tunnel.getInterface('vRP')

SeoulScriptsServer = SeoulScriptsServer or {}
local Cooldowns = {}

local function debugPrint(...)
    if SeoulScripts and SeoulScripts.Debug then
        print('[Seoul Scripts][SERVER]', ...)
    end
end
SeoulScriptsServer.Debug = debugPrint

function SeoulScriptsServer.Enabled(name)
    return not SeoulScripts or not SeoulScripts.Modules or SeoulScripts.Modules[name] ~= false
end

function SeoulScriptsServer.Passport(source)
    if not source or source <= 0 then return nil end
    if vRP then
        if vRP.Passport then
            local ok, result = pcall(vRP.Passport, source)
            if ok and result then return result end
        end
        if vRP.getUserId then
            local ok, result = pcall(vRP.getUserId, source)
            if ok and result then return result end
        end
    end
    return nil
end

function SeoulScriptsServer.Notify(source,kind,msg,time)
    TriggerClientEvent('Notify', source, kind or 'aviso', msg or '', time or 5000)
end

function SeoulScriptsServer.HasPermission(passport, permissions)
    if not passport or not vRP or not vRP.HasPermission then return false end
    if type(permissions) == 'string' then permissions = { permissions } end
    for _,permission in ipairs(permissions or {}) do
        local ok, result = pcall(vRP.HasPermission, passport, permission)
        if ok and result then return true end

        if vRP.HasGroup then
            ok, result = pcall(vRP.HasGroup, passport, permission)
            if ok and result then return true end
        end
    end
    return false
end

function SeoulScriptsServer.HasSourcePermission(source, key)
    local passport = SeoulScriptsServer.Passport(source)
    if not passport then return false end
    return SeoulScriptsServer.HasPermission(passport, SeoulScripts.Permissions[key] or key)
end

function SeoulScriptsServer.CheckCooldown(source, name, ms)
    local now = GetGameTimer()
    local key = tostring(source)..':'..tostring(name)
    local limit = ms or (SeoulScripts.Security and SeoulScripts.Security.ServerEventCooldown) or 700
    if Cooldowns[key] and now - Cooldowns[key] < limit then return false end
    Cooldowns[key] = now
    return true
end

function SeoulScriptsServer.DistanceBetweenSources(a,b)
    local pa,pb = GetPlayerPed(a),GetPlayerPed(b)
    if not pa or not pb or not DoesEntityExist(pa) or not DoesEntityExist(pb) then return 99999.0 end
    return #(GetEntityCoords(pa) - GetEntityCoords(pb))
end

function SeoulScriptsServer.GetWeight(passport)
    if vRP then
        if vRP.GetWeight then
            local ok, result = pcall(vRP.GetWeight, passport)
            if ok and tonumber(result) then return tonumber(result) end
        end
        if vRP.getBackpack then
            local ok, result = pcall(vRP.getBackpack, passport)
            if ok and tonumber(result) then return tonumber(result) end
        end
    end
    return 0
end

function SeoulScriptsServer.AddWeight(passport, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 or not passport or not vRP then return false end
    if vRP.UpgradeWeight then
        local ok = pcall(vRP.UpgradeWeight, passport, amount)
        return ok
    end
    if vRP.setBackpack and vRP.getBackpack then
        local now = SeoulScriptsServer.GetWeight(passport)
        local ok = pcall(vRP.setBackpack, passport, now + amount)
        return ok
    end
    return false
end

function SeoulScriptsServer.ItemAmount(source,item)
    if GetResourceState('ox_inventory') == 'started' then
        local count = exports.ox_inventory:Search(source,'count',item)
        return tonumber(count) or 0
    end
    local passport = SeoulScriptsServer.Passport(source)
    if passport and vRP then
        if vRP.ItemAmount then return tonumber(vRP.ItemAmount(passport,item)) or 0 end
        if vRP.InventoryItemAmount then
            local result = vRP.InventoryItemAmount(passport,item)
            if type(result) == 'table' then return tonumber(result[1]) or 0 end
            return tonumber(result) or 0
        end
    end
    return 0
end

function SeoulScriptsServer.TakeItem(source,item,amount)
    amount = tonumber(amount) or 1
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:RemoveItem(source,item,amount) == true
    end
    local passport = SeoulScriptsServer.Passport(source)
    if passport and vRP and vRP.TakeItem then return vRP.TakeItem(passport,item,amount,true) end
    return false
end

function SeoulScriptsServer.GiveItem(source,item,amount)
    amount = tonumber(amount) or 1
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(source,item,amount) == true
    end
    local passport = SeoulScriptsServer.Passport(source)
    if passport and vRP then
        if vRP.GiveItem then return vRP.GiveItem(passport,item,amount,true) end
        if vRP.GenerateItem then return vRP.GenerateItem(passport,item,amount,true) end
    end
    return false
end

function SeoulScriptsServer.Money(source)
    return SeoulScriptsServer.ItemAmount(source, SeoulScripts.Items.Money or 'dollar')
end

function SeoulScriptsServer.TakeMoney(source,amount)
    return SeoulScriptsServer.TakeItem(source, SeoulScripts.Items.Money or 'dollar', amount)
end

function SeoulScriptsServer.GiveMoney(source,amount)
    return SeoulScriptsServer.GiveItem(source, SeoulScripts.Items.Money or 'dollar', amount)
end

function SeoulScriptsServer.Identifier(source)
    local passport = SeoulScriptsServer.Passport(source)
    if passport then return 'vrp:'..tostring(passport), passport end
    for _,identifier in ipairs(GetPlayerIdentifiers(source)) do
        if identifier:find('license:') then return identifier, passport end
    end
    return tostring(source), passport
end

function SeoulScriptsServer.RandomString(size)
    local chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    local str = ''
    for i=1,(size or 8) do
        local r = math.random(#chars)
        str = str..chars:sub(r,r)
    end
    return str
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() and GetConvar('seoul:startupLog','true') == 'true' then
        print('^2[Seoul Scripts]^0 seoul_scripts carregado com sucesso.')
    end
end)
