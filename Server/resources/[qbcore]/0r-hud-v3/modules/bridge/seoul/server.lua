local Tunnel = module('vrp', 'lib/Tunnel') or {}
local Proxy = module('vrp', 'lib/Proxy') or {}
local vRP = Proxy.getInterface('vRP')

local function getPassport(src)
    if not src or src <= 0 or not vRP then return nil end
    if vRP.Passport then
        local ok, result = pcall(vRP.Passport, src)
        if ok and result then return result end
    end
    if vRP.getUserId then
        local ok, result = pcall(vRP.getUserId, src)
        if ok and result then return result end
    end
    return nil
end

local function getIdentity(passport)
    if not passport or not vRP then return {} end
    if vRP.Identity then
        local ok, result = pcall(vRP.Identity, passport)
        if ok and type(result) == 'table' then return result end
    end
    if vRP.getUserIdentity then
        local ok, result = pcall(vRP.getUserIdentity, passport)
        if ok and type(result) == 'table' then return result end
    end
    return {}
end

local function getDatatable(passport)
    if not passport or not vRP then return {} end
    if vRP.Datatable then
        local ok, result = pcall(vRP.Datatable, passport)
        if ok and type(result) == 'table' then return result end
    end
    if vRP.getUserDataTable then
        local ok, result = pcall(vRP.getUserDataTable, passport)
        if ok and type(result) == 'table' then return result end
    end
    return {}
end

local function itemAmount(src, passport, item)
    if not item or item == '' then return 0 end
    if GetResourceState('ox_inventory') == 'started' then
        local ok, count = pcall(function()
            return exports.ox_inventory:Search(src, 'count', item)
        end)
        if ok and count then return tonumber(count) or 0 end
    end
    if passport and vRP then
        if vRP.ItemAmount then
            local ok, result = pcall(vRP.ItemAmount, passport, item)
            if ok then return tonumber(result) or 0 end
        end
        if vRP.InventoryItemAmount then
            local ok, result = pcall(vRP.InventoryItemAmount, passport, item)
            if ok then
                if type(result) == 'table' then return tonumber(result[1]) or 0 end
                return tonumber(result) or 0
            end
        end
    end
    return 0
end

local function bankAmount(passport)
    if not passport or not vRP then return 0 end
    for _, name in ipairs({ 'GetBank', 'getBankMoney' }) do
        if vRP[name] then
            local ok, result = pcall(vRP[name], passport)
            if ok then return tonumber(result) or 0 end
        end
    end
    return 0
end

local function jobInfo(passport)
    if not passport or not vRP then return { label = 'Civil', grade = 'Sem cargo' } end
    local groups = {}
    if vRP.getUserGroups then
        local ok, result = pcall(vRP.getUserGroups, passport)
        if ok and type(result) == 'table' then groups = result end
    elseif vRP.Groups then
        local ok, result = pcall(vRP.Groups, passport)
        if ok and type(result) == 'table' then groups = result end
    end

    for group, level in pairs(groups) do
        if vRP.HasService then
            local ok, active = pcall(vRP.HasService, passport, group)
            if ok and active then
                return { label = tostring(group), grade = tostring(level or '') }
            end
        else
            return { label = tostring(group), grade = tostring(level or '') }
        end
    end

    return { label = 'Civil', grade = 'Sem cargo' }
end

local function sendPlayerData(src)
    local passport = getPassport(src)
    if not passport then return end

    local data = getDatatable(passport)
    local cashItem = Config.MoneySettings.itemName or 'dollar'
    local extra = Config.MoneySettings.extra_currency or {}

    TriggerClientEvent(_e('client:setSeoulPlayerData'), src, {
        hunger = data.Hunger or data.hunger or 100,
        thirst = data.Thirst or data.thirst or 100,
        stress = data.Stress or data.stress or 0,
        cash = itemAmount(src, passport, cashItem),
        bank = bankAmount(passport),
        extra_currency = extra.type == 'item' and itemAmount(src, passport, extra.name) or 0,
        job = jobInfo(passport),
        identity = getIdentity(passport)
    })
end

RegisterNetEvent(_e('server:requestSeoulPlayerData'), function()
    sendPlayerData(source)
end)

AddEventHandler('Connect', function(_, src)
    if src then
        SetTimeout(1500, function()
            if GetPlayerName(src) then sendPlayerData(src) end
        end)
    end
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(state)
    TriggerClientEvent(_e('client:setPlayerDeathStatus'), source, state)
end)
