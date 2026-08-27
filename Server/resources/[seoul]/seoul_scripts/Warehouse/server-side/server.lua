if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Warehouse') then return end

local Inside = {}
local TableName = SeoulScripts.Warehouse.Table or 'seoul_warehouses'

local function notify(src,t,m) SeoulScriptsServer.Notify(src,t,m,5000) end
local function warehouseCoords(index)
    local data = WarehouseConfig.Warehouses[tonumber(index)]
    return data and data.coords, data and tonumber(data.price or 0)
end
local function nearWarehouse(src,index,maxDist)
    local coords = warehouseCoords(index)
    if not coords then return false end
    local ped = GetPlayerPed(src)
    if not ped or not DoesEntityExist(ped) then return false end
    return #(GetEntityCoords(ped) - coords) <= (maxDist or 4.0)
end
local function cleanName(name) return tostring(name or ''):gsub('[^%w%s%-%_]',''):sub(1,32) end
local function validCode(code) return tostring(code or ''):match('^%d%d%d%d$') ~= nil end
local function registerStash(id,name,slots,weight)
    if GetResourceState('ox_inventory') == 'started' then
        pcall(function() exports.ox_inventory:RegisterStash('seoul_warehouse_'..id, name, tonumber(slots) or WarehouseConfig.stashes.defaultSlots, tonumber(weight) or WarehouseConfig.stashes.defaultWeight, false) end)
    end
end

local function ensureTable()
    MySQL.query.await(([[CREATE TABLE IF NOT EXISTS `%s` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `passport` int(11) DEFAULT NULL,
        `identifier` varchar(64) DEFAULT NULL,
        `owner` varchar(80) DEFAULT NULL,
        `name` varchar(40) NOT NULL,
        `code` varchar(8) NOT NULL,
        `location_index` int(11) NOT NULL,
        `max_slots` int(11) NOT NULL DEFAULT 50,
        `max_weight` int(11) NOT NULL DEFAULT 50000,
        `original_price` int(11) NOT NULL DEFAULT 0,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
        PRIMARY KEY (`id`),
        UNIQUE KEY `name` (`name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]]):format(TableName))
end

local function loadStashes()
    ensureTable()
    local rows = MySQL.query.await(('SELECT id,name,max_slots,max_weight FROM `%s`'):format(TableName)) or {}
    for _,row in ipairs(rows) do registerStash(row.id,row.name,row.max_slots,row.max_weight) end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        CreateThread(function() Wait(1500) loadStashes() end)
    end
end)

RegisterNetEvent('seoul_warehouse:buy')
AddEventHandler('seoul_warehouse:buy', function(index,name,code)
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    if not passport then return end
    index = tonumber(index)
    local coords,price = warehouseCoords(index)
    if not coords then return notify(src,'negado','Armazém inválido.') end
    if not nearWarehouse(src,index,5.0) then return notify(src,'negado','Você está longe do armazém.') end
    name = cleanName(name)
    if #name < 3 then return notify(src,'negado','Nome inválido.') end
    if not validCode(code) then return notify(src,'negado','Código precisa ter 4 números.') end
    local count = MySQL.scalar.await(('SELECT COUNT(*) FROM `%s` WHERE passport = ?'):format(TableName), { passport }) or 0
    if tonumber(count) >= (WarehouseConfig.maxPurchases or 6) then return notify(src,'negado','Você atingiu o limite de armazéns.') end
    local exists = MySQL.scalar.await(('SELECT id FROM `%s` WHERE name = ?'):format(TableName), { name })
    if exists then return notify(src,'negado','Já existe armazém com esse nome.') end
    if SeoulScriptsServer.Money(src) < price then return notify(src,'negado','Dinheiro insuficiente.') end
    if not SeoulScriptsServer.TakeMoney(src,price) then return notify(src,'negado','Falha ao cobrar.') end
    local identifier = SeoulScriptsServer.Identifier(src)
    local owner = GetPlayerName(src) or ('Passaporte '..passport)
    local id = MySQL.insert.await(('INSERT INTO `%s` (passport,identifier,owner,name,code,location_index,max_slots,max_weight,original_price) VALUES (?,?,?,?,?,?,?,?,?)'):format(TableName), {
        passport, identifier, owner, name, tostring(code), index, WarehouseConfig.stashes.defaultSlots, WarehouseConfig.stashes.defaultWeight, price
    })
    if not id then return notify(src,'negado','Falha ao registrar armazém.') end
    registerStash(id,name,WarehouseConfig.stashes.defaultSlots,WarehouseConfig.stashes.defaultWeight)
    TriggerClientEvent('seoul_warehouse:setupStashTarget', src, coords, id)
    notify(src,'sucesso','Você comprou o armazém: '..name)
end)

RegisterNetEvent('seoul_warehouse:enter')
AddEventHandler('seoul_warehouse:enter', function(name,code,index)
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    if not passport then return end
    index = tonumber(index)
    name = cleanName(name)
    if not validCode(code) then code = tostring(code or '') end
    if not nearWarehouse(src,index,5.0) then return notify(src,'negado','Você está longe do armazém.') end
    local rows = MySQL.query.await(('SELECT * FROM `%s` WHERE name = ? AND location_index = ? LIMIT 1'):format(TableName), { name, index }) or {}
    local row = rows[1]
    if not row then return notify(src,'negado','Nome ou local inválido.') end
    if tostring(row.code) ~= tostring(code) and tonumber(row.passport) ~= tonumber(passport) then return notify(src,'negado','Código inválido.') end
    registerStash(row.id,row.name,row.max_slots,row.max_weight)
    Inside[src] = { id = row.id, index = index, outside = GetEntityCoords(GetPlayerPed(src)), owner = tonumber(row.passport) == tonumber(passport) }
    SetPlayerRoutingBucket(src, (SeoulScripts.Warehouse.BucketBase or 93000) + tonumber(row.id))
    TriggerClientEvent('seoul_warehouse:teleportInside', src, row.id, Inside[src].owner)
end)

RegisterNetEvent('seoul_warehouse:leave')
AddEventHandler('seoul_warehouse:leave', function()
    local src = source
    local data = Inside[src]
    if not data then return end
    SetPlayerRoutingBucket(src, 0)
    TriggerClientEvent('seoul_warehouse:teleportOutside', src, data.outside)
    Inside[src] = nil
end)

RegisterNetEvent('seoul_warehouse:requestUpgradeInfo')
AddEventHandler('seoul_warehouse:requestUpgradeInfo', function(id,upgradeType)
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    local row = MySQL.single.await(('SELECT id,passport,name,max_slots,max_weight FROM `%s` WHERE id = ?'):format(TableName), { tonumber(id) })
    if not row or tonumber(row.passport) ~= tonumber(passport) then return notify(src,'negado','Você não é o dono deste armazém.') end
    TriggerClientEvent('seoul_warehouse:receiveUpgradeInfo', src, row.max_slots, row.max_weight)
end)

RegisterNetEvent('seoul_warehouse:processUpgrade')
AddEventHandler('seoul_warehouse:processUpgrade', function(id,upgradeType,upgradeAmount)
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    id,upgradeAmount = tonumber(id), tonumber(upgradeAmount)
    if not id or not upgradeAmount or upgradeAmount <= 0 or upgradeAmount > 100 then return notify(src,'negado','Melhoria inválida.') end
    local row = MySQL.single.await(('SELECT * FROM `%s` WHERE id = ?'):format(TableName), { id })
    if not row or tonumber(row.passport) ~= tonumber(passport) then return notify(src,'negado','Você não é o dono deste armazém.') end
    local cost,newSlots,newWeight
    if upgradeType == 'slots' then
        newSlots = tonumber(row.max_slots) + upgradeAmount
        if newSlots > WarehouseConfig.stashes.maxSlots then return notify(src,'negado','Limite máximo de slots excedido.') end
        newWeight = tonumber(row.max_weight)
        cost = upgradeAmount * WarehouseConfig.stashes.slotCost
    elseif upgradeType == 'weight' then
        newSlots = tonumber(row.max_slots)
        newWeight = tonumber(row.max_weight) + (upgradeAmount * 1000)
        if newWeight > WarehouseConfig.stashes.maxWeight then return notify(src,'negado','Limite máximo de peso excedido.') end
        cost = upgradeAmount * WarehouseConfig.stashes.weightCost
    else
        return notify(src,'negado','Tipo de melhoria inválido.')
    end
    if SeoulScriptsServer.Money(src) < cost then return notify(src,'negado','Dinheiro insuficiente.') end
    if not SeoulScriptsServer.TakeMoney(src,cost) then return notify(src,'negado','Falha ao cobrar.') end
    MySQL.update.await(('UPDATE `%s` SET max_slots = ?, max_weight = ? WHERE id = ?'):format(TableName), { newSlots, newWeight, id })
    registerStash(id,row.name,newSlots,newWeight)
    notify(src,'sucesso','Armazém melhorado com sucesso.')
end)

RegisterNetEvent('seoul_warehouse:changePin')
AddEventHandler('seoul_warehouse:changePin', function(id,newCode)
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    if not validCode(newCode) then return notify(src,'negado','Código precisa ter 4 números.') end
    local changed = MySQL.update.await(('UPDATE `%s` SET code = ? WHERE id = ? AND passport = ?'):format(TableName), { tostring(newCode), tonumber(id), passport })
    notify(src, changed and changed > 0 and 'sucesso' or 'negado', changed and changed > 0 and 'Código alterado.' or 'Você não é o dono deste armazém.')
end)

RegisterNetEvent('seoul_warehouse:sell')
AddEventHandler('seoul_warehouse:sell', function()
    local src = source
    local passport = SeoulScriptsServer.Passport(src)
    local data = Inside[src]
    if not data then return notify(src,'negado','Você não está dentro do armazém.') end
    local row = MySQL.single.await(('SELECT * FROM `%s` WHERE id = ?'):format(TableName), { data.id })
    if not row or tonumber(row.passport) ~= tonumber(passport) then return notify(src,'negado','Você não é o dono deste armazém.') end
    local payout = math.floor((tonumber(row.original_price) or 0) * (1.0 - (WarehouseConfig.sellpros or 0.25)))
    if GetResourceState('ox_inventory') == 'started' then pcall(function() exports.ox_inventory:ClearInventory('seoul_warehouse_'..row.id) end) end
    MySQL.query.await(('DELETE FROM `%s` WHERE id = ?'):format(TableName), { row.id })
    SeoulScriptsServer.GiveMoney(src,payout)
    SetPlayerRoutingBucket(src,0)
    TriggerClientEvent('seoul_warehouse:teleportOutside', src, data.outside)
    Inside[src] = nil
    notify(src,'sucesso','Você vendeu o armazém por $'..payout..'.')
end)

RegisterCommand('seoulwarehouses', function(src)
    if src > 0 and not SeoulScriptsServer.HasSourcePermission(src,'WarehouseAdmin') then return end
    local count = MySQL.scalar.await(('SELECT COUNT(*) FROM `%s`'):format(TableName)) or 0
    if src > 0 then notify(src,'aviso','Armazéns cadastrados: '..count) else print('[Seoul Scripts] Armazéns cadastrados: '..count) end
end)

AddEventHandler('playerDropped', function() Inside[source] = nil end)
