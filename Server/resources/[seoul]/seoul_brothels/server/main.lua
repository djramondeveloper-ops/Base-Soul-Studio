local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local Brothels = {}
local Rooms = {}
local Workers = {}
local Members = {}
local WorkerEntities = {}
local Sessions = {}
local Cooldowns = {}

local function debugPrint(message)
    if Config and Config.Debug then
        print(('[seoul_brothels] %s'):format(tostring(message)))
    end
end

local function countTable(tbl)
    local amount = 0
    for _ in pairs(tbl or {}) do amount = amount + 1 end
    return amount
end

local function jdecode(value, fallback)
    if type(value) == 'table' then return value end
    if type(value) ~= 'string' or value == '' then return fallback or {} end
    local ok, data = pcall(json.decode, value)
    if ok and type(data) == 'table' then return data end
    return fallback or {}
end

local function jencode(value)
    return json.encode(value or {})
end

local function getPassport(src)
    src = tonumber(src)
    if not src or src <= 0 then return nil end
    if type(vRP.Passport) == 'function' then
        local ok, value = pcall(vRP.Passport, src)
        value = ok and tonumber(value) or nil
        if value and value > 0 then return value end
    end
end

local function takePayment(passport, amount)
    passport = tonumber(passport)
    amount = math.floor(tonumber(amount) or 0)
    if not passport or amount <= 0 then return false end
    local fn
    if tostring(Config.MoneyAccount or 'bank'):lower() == 'full' then
        fn = vRP.PaymentFull
    else
        fn = vRP.PaymentBank
    end
    if type(fn) ~= 'function' then return false end
    local ok, paid = pcall(fn, passport, amount)
    return ok and paid == true
end

local function giveBank(passport, amount)
    passport = tonumber(passport)
    amount = math.floor(tonumber(amount) or 0)
    if not passport or amount <= 0 or type(vRP.GiveBank) ~= 'function' then return false end
    return pcall(vRP.GiveBank, passport, amount)
end

local function hasAdmin(src)
    if GetResourceState('AdminControl') == 'started' then
        local ok, allowed = pcall(function()
            return exports.AdminControl:HasBrothelsPermission(src)
        end)
        if ok then return allowed == true end
    end

    local passport = getPassport(src)
    if not passport then return false end
    if vRP.HasPermission and vRP.HasPermission(passport, Config.AdminPermission) then return true end
    if vRP.HasGroup and vRP.HasGroup(passport, Config.AdminPermission) then return true end
    return false
end

local function notify(src, kind, message)
    src = tonumber(src)
    if not src or src <= 0 then return end
    TriggerClientEvent('Notify', src, kind or 'aviso', message or '', 5000)
end

local function validCoords(c)
    return type(c) == 'table' and tonumber(c.x) and tonumber(c.y) and tonumber(c.z)
end

local function currentPlayerCoords(src)
    src = tonumber(src)
    if not src or src <= 0 then return nil end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    local okCoords, coords = pcall(GetEntityCoords, ped)
    if not okCoords or not coords then return nil end
    local heading = 0.0
    local okHeading, value = pcall(GetEntityHeading, ped)
    if okHeading and value then heading = tonumber(value) or 0.0 end
    return { x = coords.x + 0.0, y = coords.y + 0.0, z = coords.z + 0.0, h = heading }
end

local function defaultPrices()
    local p = {}
    for key, data in pairs(Config.Services) do p[key] = data.defaultPrice end
    return p
end

local function ensureTables()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `seoul_brothels` (`id` int NOT NULL AUTO_INCREMENT,`name` varchar(80) NOT NULL,`owner_passport` int DEFAULT NULL,`balance` bigint NOT NULL DEFAULT 0,`is_open` tinyint(1) NOT NULL DEFAULT 1,`entrance` longtext NULL,`management` longtext NULL,`cashier` longtext NULL,`prices` longtext NULL,`created_by` int DEFAULT NULL,`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `seoul_brothel_rooms` (`id` int NOT NULL AUTO_INCREMENT,`brothel_id` int NOT NULL,`name` varchar(80) NOT NULL,`coords` longtext NOT NULL,`active` tinyint(1) NOT NULL DEFAULT 1,PRIMARY KEY (`id`),KEY `idx_brothel_rooms_brothel` (`brothel_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `seoul_brothel_workers` (`id` int NOT NULL AUTO_INCREMENT,`brothel_id` int NOT NULL,`name` varchar(80) NOT NULL,`model` varchar(80) NOT NULL,`coords` longtext NOT NULL,`heading` float NOT NULL DEFAULT 0,`active` tinyint(1) NOT NULL DEFAULT 1,PRIMARY KEY (`id`),KEY `idx_brothel_workers_brothel` (`brothel_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `seoul_brothel_members` (`brothel_id` int NOT NULL,`passport` int NOT NULL,`role` varchar(20) NOT NULL DEFAULT 'manager',`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (`brothel_id`,`passport`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `seoul_brothel_transactions` (`id` bigint NOT NULL AUTO_INCREMENT,`brothel_id` int NOT NULL,`passport` int DEFAULT NULL,`type` varchar(30) NOT NULL,`amount` bigint NOT NULL DEFAULT 0,`description` varchar(255) DEFAULT NULL,`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (`id`),KEY `idx_brothel_transactions_brothel` (`brothel_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
end

local function loadData()
    Brothels, Rooms, Workers, Members = {}, {}, {}, {}
    for _, row in ipairs(MySQL.query.await('SELECT * FROM seoul_brothels') or {}) do
        row.id = tonumber(row.id)
        row.owner_passport = row.owner_passport and tonumber(row.owner_passport) or nil
        row.balance = tonumber(row.balance) or 0
        row.is_open = tonumber(row.is_open) == 1
        row.entrance = jdecode(row.entrance, nil)
        row.management = jdecode(row.management, nil)
        row.cashier = jdecode(row.cashier, nil)
        row.prices = jdecode(row.prices, defaultPrices())
        Brothels[row.id] = row
        Rooms[row.id] = {}
        Workers[row.id] = {}
        Members[row.id] = {}
    end
    for _, row in ipairs(MySQL.query.await('SELECT * FROM seoul_brothel_rooms') or {}) do
        row.id, row.brothel_id = tonumber(row.id), tonumber(row.brothel_id)
        row.coords = jdecode(row.coords, {})
        row.active = tonumber(row.active) == 1
        if Rooms[row.brothel_id] then Rooms[row.brothel_id][row.id] = row end
    end
    for _, row in ipairs(MySQL.query.await('SELECT * FROM seoul_brothel_workers') or {}) do
        row.id, row.brothel_id = tonumber(row.id), tonumber(row.brothel_id)
        row.coords = jdecode(row.coords, {})
        row.heading = tonumber(row.heading) or 0.0
        row.active = tonumber(row.active) == 1
        if Workers[row.brothel_id] then Workers[row.brothel_id][row.id] = row end
    end
    for _, row in ipairs(MySQL.query.await('SELECT * FROM seoul_brothel_members') or {}) do
        local bid, passport = tonumber(row.brothel_id), tonumber(row.passport)
        if Members[bid] then Members[bid][passport] = row.role end
    end
end

local function removeWorkerEntity(workerId)
    local ped = WorkerEntities[workerId]
    if ped and DoesEntityExist(ped) then DeleteEntity(ped) end
    WorkerEntities[workerId] = nil
end

local function validWorkerModel(model)
    if type(model) ~= 'string' or model == '' or #model > 80 then return false end
    for i = 1, #Config.WorkerModels do
        if Config.WorkerModels[i] == model then return true end
    end
    return false
end

local function passportExists(passport)
    passport = tonumber(passport)
    if not passport or passport <= 0 then return false end
    local value = MySQL.scalar.await('SELECT 1 FROM characters WHERE id=? AND Deleted=0 LIMIT 1', { passport })
    return value ~= nil
end

local function spawnWorker(worker)
    removeWorkerEntity(worker.id)
    if not worker.active then
        debugPrint(('funcionaria #%s ignorada: inativa'):format(tostring(worker.id)))
        return false, 'inactive'
    end
    if not validCoords(worker.coords) then
        debugPrint(('funcionaria #%s ignorada: coordenadas invalidas'):format(tostring(worker.id)))
        return false, 'invalid_coords'
    end
    if not validWorkerModel(worker.model) then
        debugPrint(('funcionaria #%s ignorada: modelo invalido %s'):format(tostring(worker.id), tostring(worker.model)))
        return false, 'invalid_model'
    end
    local c = worker.coords
    local ok, ped = pcall(CreatePed, 4, joaat(worker.model), c.x + 0.0, c.y + 0.0, c.z + 0.0, worker.heading + 0.0, true, true)
    if ok and ped and ped ~= 0 then
        pcall(SetEntityOrphanMode, ped, 2)
        pcall(FreezeEntityPosition, ped, true)
        pcall(SetEntityInvincible, ped, true)
        pcall(SetBlockingOfNonTemporaryEvents, ped, true)
        WorkerEntities[worker.id] = ped
        return true
    end
    debugPrint(('funcionaria #%s falhou ao criar ped: %s'):format(tostring(worker.id), tostring(ped)))
    return false, 'create_failed'
end

local function spawnAllWorkers()
    local spawned = 0
    for _, list in pairs(Workers) do
        for _, worker in pairs(list) do
            local ok = spawnWorker(worker)
            if ok then spawned = spawned + 1 end
        end
    end
    return spawned
end

local function statusLines()
    local brothelCount = countTable(Brothels)
    local roomCount = 0
    local workerCount = 0
    local activeWorkerCount = 0
    local spawnedCount = 0
    local invalidCount = 0

    for _, rooms in pairs(Rooms) do roomCount = roomCount + countTable(rooms) end

    for _, list in pairs(Workers) do
        for _, worker in pairs(list) do
            workerCount = workerCount + 1
            if worker.active then activeWorkerCount = activeWorkerCount + 1 end
            local ped = WorkerEntities[worker.id]
            if ped and DoesEntityExist(ped) then
                spawnedCount = spawnedCount + 1
            elseif not worker.active or not validCoords(worker.coords) or not validWorkerModel(worker.model) then
                invalidCount = invalidCount + 1
            end
        end
    end

    return {
        ('bordels=%s quartos=%s funcionarias=%s ativas=%s spawnadas=%s invalidas=%s'):format(brothelCount, roomCount, workerCount, activeWorkerCount, spawnedCount, invalidCount),
        ('ox_target=%s interact=%s onesync=%s'):format(GetResourceState('ox_target'), GetResourceState('interact'), GetConvar('onesync', 'off'))
    }
end

local function printStatus(src)
    for _, line in ipairs(statusLines()) do
        print('[seoul_brothels] '..line)
        notify(src, 'aviso', line)
    end
end

local function publicSnapshot()
    local data = { brothels = {}, workers = {} }
    for id, b in pairs(Brothels) do
        data.brothels[id] = {
            id = id, name = b.name, is_open = b.is_open, prices = b.prices
        }
    end
    for bid, list in pairs(Workers) do
        for workerId, w in pairs(list) do
            local ped = WorkerEntities[workerId]
            local netId
            if ped and DoesEntityExist(ped) then
                local ok, value = pcall(NetworkGetNetworkIdFromEntity, ped)
                if ok and value and value ~= 0 then netId = value end
            end
            data.workers[workerId] = {
                id = workerId, brothel_id = bid, name = w.name, active = w.active, netId = netId
            }
        end
    end
    return data
end

local function syncAll(target)
    TriggerClientEvent('seoul_brothels:sync', target or -1, publicSnapshot())
end

local function isManager(passport, brothelId)
    local b = Brothels[brothelId]
    if not b or not passport then return false end
    if b.owner_passport == passport then return true end
    return Members[brothelId] and Members[brothelId][passport] == 'manager' or false
end

local function businessData(brothelId)
    local b = Brothels[brothelId]
    if not b then return nil end
    local managers, workers, rooms = {}, {}, {}
    for passport, role in pairs(Members[brothelId] or {}) do managers[#managers + 1] = { passport = passport, role = role } end
    for _, w in pairs(Workers[brothelId] or {}) do workers[#workers + 1] = w end
    for _, r in pairs(Rooms[brothelId] or {}) do rooms[#rooms + 1] = r end
    table.sort(managers, function(a,b) return a.passport < b.passport end)
    table.sort(workers, function(a,b) return a.id < b.id end)
    table.sort(rooms, function(a,b) return a.id < b.id end)
    return {
        id=b.id,name=b.name,owner_passport=b.owner_passport,balance=b.balance,is_open=b.is_open,
        entrance=b.entrance,management=b.management,cashier=b.cashier,prices=b.prices,
        managers=managers,workers=workers,rooms=rooms
    }
end

local function logTransaction(bid, passport, kind, amount, description)
    MySQL.insert.await('INSERT INTO seoul_brothel_transactions (brothel_id,passport,type,amount,description) VALUES (?,?,?,?,?)', {
        bid, passport, kind, amount or 0, description or ''
    })
end

lib.callback.register('seoul_brothels:getAdminData', function(src)
    if not hasAdmin(src) then return nil end
    local list = {}
    for id in pairs(Brothels) do list[#list + 1] = businessData(id) end
    table.sort(list, function(a,b) return a.id < b.id end)
    return list
end)

lib.callback.register('seoul_brothels:getBusinessPanel', function(src, brothelId)
    brothelId = tonumber(brothelId)
    local passport = getPassport(src)
    if not isManager(passport, brothelId) and not hasAdmin(src) then return nil end
    local data = businessData(brothelId)
    if data then
        data.transactions = MySQL.query.await('SELECT passport,type,amount,description,created_at FROM seoul_brothel_transactions WHERE brothel_id=? ORDER BY id DESC LIMIT 15', { brothelId }) or {}
    end
    return data
end)

lib.callback.register('seoul_brothels:getMyManagementPoints', function(src)
    local passport = getPassport(src)
    local admin = hasAdmin(src)
    local result = {}
    for id,b in pairs(Brothels) do
        if admin or isManager(passport,id) then
            result[#result+1] = { id=id, name=b.name, management=b.management, cashier=b.cashier }
        end
    end
    return result
end)

RegisterNetEvent('seoul_brothels:requestSync', function() syncAll(source) end)

RegisterNetEvent('seoul_brothels:adminCreate', function(data)
    local src = source
    if not hasAdmin(src) then return end
    if type(data) ~= 'table' then return end
    local count = 0 for _ in pairs(Brothels) do count = count + 1 end
    if count >= Config.MaxBrothels then return notify(src,'negado','Limite de bordéis atingido.') end
    local name = tostring(data.name or ''):sub(1,80)
    local coords = currentPlayerCoords(src)
    local owner = tonumber(data.owner_passport)
    if owner and not passportExists(owner) then return notify(src,'negado','Passport do dono não existe.') end
    if #name < 2 or not coords then return notify(src,'negado','Dados inválidos para criar o bordel.') end
    local creator = getPassport(src)
    local id = MySQL.insert.await('INSERT INTO seoul_brothels (name,owner_passport,entrance,prices,created_by) VALUES (?,?,?,?,?)', {
        name, owner, jencode(coords), jencode(defaultPrices()), creator
    })
    if not id then return notify(src,'negado','Falha ao criar bordel no banco.') end
    loadData(); syncAll()
    notify(src,'sucesso',('Bordel #%s criado: %s'):format(id,name))
end)

RegisterNetEvent('seoul_brothels:adminSetPoint', function(bid, point)
    local src = source
    if not hasAdmin(src) then return end
    bid = tonumber(bid); local coords = currentPlayerCoords(src)
    if not Brothels[bid] or not coords then return end
    if point ~= 'entrance' and point ~= 'management' and point ~= 'cashier' then return end
    MySQL.update.await(('UPDATE seoul_brothels SET `%s`=? WHERE id=?'):format(point), { jencode(coords), bid })
    loadData(); syncAll(); notify(src,'sucesso','Ponto atualizado.')
end)

RegisterNetEvent('seoul_brothels:adminSetOwner', function(bid, passport)
    local src = source
    if not hasAdmin(src) then return end
    bid, passport = tonumber(bid), tonumber(passport)
    if not Brothels[bid] or not passport or passport <= 0 then return end
    if not passportExists(passport) then return notify(src,'negado','Passport informado não existe.') end
    MySQL.update.await('UPDATE seoul_brothels SET owner_passport=? WHERE id=?',{passport,bid})
    loadData(); syncAll(); notify(src,'sucesso',('Dono definido: Passport %s.'):format(passport))
end)

RegisterNetEvent('seoul_brothels:adminAddRoom', function(bid, name)
    local src = source
    if not hasAdmin(src) then return end
    bid = tonumber(bid); local coords = currentPlayerCoords(src)
    name = tostring(name or ''):sub(1,80)
    if not Brothels[bid] or not coords or #name < 1 then return end
    local count=0 for _ in pairs(Rooms[bid] or {}) do count=count+1 end
    if count >= Config.MaxRoomsPerBrothel then return notify(src,'negado','Limite de quartos atingido.') end
    MySQL.insert.await('INSERT INTO seoul_brothel_rooms (brothel_id,name,coords) VALUES (?,?,?)',{bid,name,jencode(coords)})
    loadData(); syncAll(); notify(src,'sucesso','Quarto adicionado.')
end)

RegisterNetEvent('seoul_brothels:adminDeleteRoom', function(bid, roomId)
    local src=source
    if not hasAdmin(src) then return end
    bid,roomId=tonumber(bid),tonumber(roomId)
    if not Rooms[bid] or not Rooms[bid][roomId] then return end
    MySQL.update.await('DELETE FROM seoul_brothel_rooms WHERE id=? AND brothel_id=?',{roomId,bid})
    loadData(); syncAll(); notify(src,'sucesso','Quarto removido.')
end)

RegisterNetEvent('seoul_brothels:adminAddWorker', function(bid, name, model)
    local src=source
    if not hasAdmin(src) then return end
    bid=tonumber(bid); local coords=currentPlayerCoords(src)
    name=tostring(name or ''):sub(1,80); model=tostring(model or ''):sub(1,80)
    if not Brothels[bid] or not coords or #name<1 or not validWorkerModel(model) then return notify(src,'negado','Funcionária/modelo inválido.') end
    local count=0 for _ in pairs(Workers[bid] or {}) do count=count+1 end
    if count >= Config.MaxWorkersPerBrothel then return notify(src,'negado','Limite de funcionárias atingido.') end
    local workerId = MySQL.insert.await('INSERT INTO seoul_brothel_workers (brothel_id,name,model,coords,heading) VALUES (?,?,?,?,?)',{bid,name,model,jencode(coords),coords.h or 0})
    loadData()
    if workerId and Workers[bid] and Workers[bid][tonumber(workerId)] then spawnWorker(Workers[bid][tonumber(workerId)]) end
    Wait(250)
    syncAll()
    notify(src,'sucesso','Funcionária adicionada.')
end)

RegisterNetEvent('seoul_brothels:adminDeleteWorker', function(bid, workerId)
    local src=source
    if not hasAdmin(src) then return end
    bid,workerId=tonumber(bid),tonumber(workerId)
    if not Workers[bid] or not Workers[bid][workerId] then return end
    removeWorkerEntity(workerId)
    MySQL.update.await('DELETE FROM seoul_brothel_workers WHERE id=? AND brothel_id=?',{workerId,bid})
    loadData(); syncAll(); notify(src,'sucesso','Funcionária removida.')
end)

RegisterNetEvent('seoul_brothels:adminToggle', function(bid)
    local src=source
    if not hasAdmin(src) then return end
    bid=tonumber(bid); local b=Brothels[bid]; if not b then return end
    MySQL.update.await('UPDATE seoul_brothels SET is_open=? WHERE id=?',{b.is_open and 0 or 1,bid})
    loadData(); syncAll(); notify(src,'sucesso',b.is_open and 'Bordel fechado.' or 'Bordel aberto.')
end)

RegisterNetEvent('seoul_brothels:adminSetPrices', function(bid, prices)
    local src=source
    if not hasAdmin(src) then return end
    bid=tonumber(bid); if not Brothels[bid] or type(prices)~='table' then return end
    local clean={}
    for key, cfg in pairs(Config.Services) do
        local value=math.floor(tonumber(prices[key]) or cfg.defaultPrice)
        clean[key]=math.max(cfg.minPrice, math.min(cfg.maxPrice,value))
    end
    MySQL.update.await('UPDATE seoul_brothels SET prices=? WHERE id=?',{jencode(clean),bid})
    loadData(); syncAll(); notify(src,'sucesso','Preços atualizados.')
end)

RegisterNetEvent('seoul_brothels:adminDelete', function(bid)
    local src=source
    if not hasAdmin(src) then return end
    bid=tonumber(bid); if not Brothels[bid] then return end
    for workerId in pairs(Workers[bid] or {}) do removeWorkerEntity(workerId) end
    MySQL.update.await('DELETE FROM seoul_brothel_transactions WHERE brothel_id=?',{bid})
    MySQL.update.await('DELETE FROM seoul_brothel_members WHERE brothel_id=?',{bid})
    MySQL.update.await('DELETE FROM seoul_brothel_workers WHERE brothel_id=?',{bid})
    MySQL.update.await('DELETE FROM seoul_brothel_rooms WHERE brothel_id=?',{bid})
    MySQL.update.await('DELETE FROM seoul_brothels WHERE id=?',{bid})
    loadData(); syncAll(); notify(src,'sucesso','Bordel removido.')
end)

RegisterNetEvent('seoul_brothels:businessToggle', function(bid)
    local src=source; bid=tonumber(bid); local passport=getPassport(src)
    if not isManager(passport,bid) then return end
    local b=Brothels[bid]; if not b then return end
    MySQL.update.await('UPDATE seoul_brothels SET is_open=? WHERE id=?',{b.is_open and 0 or 1,bid})
    loadData(); syncAll(); notify(src,'sucesso',b.is_open and 'Estabelecimento fechado.' or 'Estabelecimento aberto.')
end)

RegisterNetEvent('seoul_brothels:businessSetPrices', function(bid, prices)
    local src=source; bid=tonumber(bid); local passport=getPassport(src)
    if not isManager(passport,bid) or type(prices)~='table' then return end
    local clean={}
    for key,cfg in pairs(Config.Services) do
        local value=math.floor(tonumber(prices[key]) or cfg.defaultPrice)
        clean[key]=math.max(cfg.minPrice,math.min(cfg.maxPrice,value))
    end
    MySQL.update.await('UPDATE seoul_brothels SET prices=? WHERE id=?',{jencode(clean),bid})
    loadData(); syncAll(); notify(src,'sucesso','Preços atualizados.')
end)

RegisterNetEvent('seoul_brothels:addManager', function(bid, managerPassport)
    local src=source; bid=tonumber(bid); managerPassport=tonumber(managerPassport); local passport=getPassport(src)
    local b=Brothels[bid]
    if not b or b.owner_passport ~= passport or not managerPassport or managerPassport<=0 or managerPassport==passport then return end
    if not passportExists(managerPassport) then return notify(src,'negado','Passport informado não existe.') end
    local count=0 for _ in pairs(Members[bid] or {}) do count=count+1 end
    if count>=Config.MaxManagersPerBrothel then return notify(src,'negado','Limite de gerentes atingido.') end
    MySQL.query.await('INSERT INTO seoul_brothel_members (brothel_id,passport,role) VALUES (?,?,\'manager\') ON DUPLICATE KEY UPDATE role=\'manager\'', {bid,managerPassport})
    loadData(); syncAll(); notify(src,'sucesso','Gerente adicionado.')
end)

RegisterNetEvent('seoul_brothels:removeManager', function(bid, managerPassport)
    local src=source; bid=tonumber(bid); managerPassport=tonumber(managerPassport); local passport=getPassport(src)
    local b=Brothels[bid]
    if not b or b.owner_passport~=passport then return end
    MySQL.update.await('DELETE FROM seoul_brothel_members WHERE brothel_id=? AND passport=?',{bid,managerPassport})
    loadData(); syncAll(); notify(src,'sucesso','Gerente removido.')
end)

RegisterNetEvent('seoul_brothels:deposit', function(bid, amount)
    local src=source; bid=tonumber(bid); amount=math.floor(tonumber(amount) or 0); local passport=getPassport(src)
    if not isManager(passport,bid) or amount<=0 or amount>Config.MaxTransactionAmount then return end
    if not takePayment(passport,amount) then return notify(src,'negado','Saldo insuficiente.') end
    local changed=MySQL.update.await('UPDATE seoul_brothels SET balance=balance+? WHERE id=?',{amount,bid})
    if not changed or changed<1 then
        giveBank(passport,amount)
        return notify(src,'negado','Falha ao atualizar o caixa; o valor foi devolvido ao banco.')
    end
    logTransaction(bid,passport,'deposit',amount,'Depósito no caixa')
    loadData(); notify(src,'sucesso',('Depositado $%s no caixa.'):format(amount))
end)

RegisterNetEvent('seoul_brothels:withdraw', function(bid, amount)
    local src=source; bid=tonumber(bid); amount=math.floor(tonumber(amount) or 0); local passport=getPassport(src)
    local b=Brothels[bid]
    if not b or b.owner_passport~=passport or amount<=0 or amount>Config.MaxTransactionAmount or b.balance<amount then return end
    if type(vRP.GiveBank) ~= 'function' then return notify(src,'negado','Integração bancária indisponível.') end
    local changed=MySQL.update.await('UPDATE seoul_brothels SET balance=balance-? WHERE id=? AND balance>=?', {amount,bid,amount})
    if not changed or changed<1 then return notify(src,'negado','Caixa insuficiente.') end
    if not giveBank(passport,amount) then
        MySQL.update.await('UPDATE seoul_brothels SET balance=balance+? WHERE id=?',{amount,bid})
        return notify(src,'negado','Falha ao creditar o banco; o valor voltou ao caixa.')
    end
    logTransaction(bid,passport,'withdraw',amount,'Saque do proprietário')
    loadData(); notify(src,'sucesso',('Sacado $%s para o banco.'):format(amount))
end)

local function findAvailableRoom(bid)
    local used={}
    for _,s in pairs(Sessions) do if s.brothel_id==bid and s.room_id and s.expires>os.time() then used[s.room_id]=true end end
    for roomId, room in pairs(Rooms[bid] or {}) do if room.active and not used[roomId] then return room end end
end

lib.callback.register('seoul_brothels:purchaseStreetService', function(src, serviceKey)
    serviceKey=tostring(serviceKey or '')
    local cfg=Config.Services[serviceKey]
    local price=cfg and tonumber(Config.Street and Config.Street.Prices and Config.Street.Prices[serviceKey]) or nil
    local passport=getPassport(src)
    if not Config.Street or not Config.Street.Enabled or not cfg or not price or not passport then return {ok=false,message='Serviço inválido.'} end
    price=math.floor(price)
    if price<cfg.minPrice or price>cfg.maxPrice then return {ok=false,message='Preço inválido.'} end
    if Cooldowns[src] and Cooldowns[src]>os.time() then return {ok=false,message='Aguarde alguns segundos.'} end
    local playerPed=GetPlayerPed(src)
    if not playerPed or playerPed==0 then return {ok=false,message='Personagem inválido.'} end
    local okVehicle,vehicle=pcall(GetVehiclePedIsIn,playerPed,false)
    if not okVehicle or not vehicle or vehicle==0 then return {ok=false,message='Você precisa estar em um veículo.'} end
    local okDriver,driver=pcall(GetPedInVehicleSeat,vehicle,-1)
    if okDriver and driver and driver~=0 and driver~=playerPed then return {ok=false,message='Você precisa estar dirigindo.'} end
    if not takePayment(passport,price) then return {ok=false,message='Saldo insuficiente.'} end
    Cooldowns[src]=os.time()+3
    return {ok=true,price=price}
end)

lib.callback.register('seoul_brothels:purchaseService', function(src, workerId, serviceKey)
    workerId=tonumber(workerId); serviceKey=tostring(serviceKey or '')
    local passport=getPassport(src); if not passport then return {ok=false,message='Personagem inválido.'} end
    local worker,bid
    for brothelId,list in pairs(Workers) do if list[workerId] then worker=list[workerId]; bid=brothelId; break end end
    local b=bid and Brothels[bid] or nil
    local cfg=Config.Services[serviceKey]
    if not worker or not worker.active or not b or not b.is_open or not cfg then return {ok=false,message='Serviço indisponível.'} end
    local ped=WorkerEntities[workerId]
    local playerPed=GetPlayerPed(src)
    if not ped or not DoesEntityExist(ped) or not playerPed or playerPed==0 then return {ok=false,message='Funcionária indisponível.'} end
    local pc,wc=GetEntityCoords(playerPed),GetEntityCoords(ped)
    if #(pc-wc)>Config.WorkerInteractDistance+1.0 then return {ok=false,message='Você está longe demais.'} end
    if Cooldowns[src] and Cooldowns[src]>os.time() then return {ok=false,message='Aguarde alguns segundos.'} end
    if Sessions[src] and Sessions[src].expires>os.time() then return {ok=false,message='Você já possui um atendimento em andamento.'} end
    local room=findAvailableRoom(bid)
    if not room then return {ok=false,message='Nenhum quarto disponível no momento.'} end
    local price=math.floor(tonumber((b.prices or {})[serviceKey]) or cfg.defaultPrice)
    price=math.max(cfg.minPrice,math.min(cfg.maxPrice,price))
    if not takePayment(passport,price) then return {ok=false,message='Saldo insuficiente.'} end
    local share=tonumber(Config.BusinessShare) or 0.75
    share=math.max(0.0,math.min(1.0,share))
    local business=math.floor(price*share)
    local changed=MySQL.update.await('UPDATE seoul_brothels SET balance=balance+? WHERE id=?',{business,bid})
    if not changed or changed<1 then
        giveBank(passport,price)
        return {ok=false,message='Falha ao registrar o pagamento; o valor foi devolvido ao banco.'}
    end
    logTransaction(bid,passport,'service',business,('Serviço %s / total %s'):format(serviceKey,price))
    Sessions[src]={brothel_id=bid,worker_id=workerId,room_id=room.id,service=serviceKey,expires=os.time()+Config.SessionExpireSeconds}
    Cooldowns[src]=os.time()+3
    loadData()
    return {ok=true,message='Pagamento aprovado.',room=room.coords,roomName=room.name,duration=Config.ServiceDurationMs,price=price}
end)

lib.callback.register('seoul_brothels:finishSession', function(src)
    local session = Sessions[src]
    if not session or session.expires <= os.time() then
        Sessions[src] = nil
        return { ok = false, message = 'Seu atendimento expirou.' }
    end
    local room = Rooms[session.brothel_id] and Rooms[session.brothel_id][session.room_id]
    local playerPed = GetPlayerPed(src)
    if not room or not playerPed or playerPed == 0 then return { ok = false, message = 'Quarto indisponível.' } end
    local pc = GetEntityCoords(playerPed)
    local rc = room.coords
    if not validCoords(rc) or #(pc - vector3(rc.x, rc.y, rc.z)) > 4.0 then
        return { ok = false, message = 'Você saiu do quarto.' }
    end
    Sessions[src] = nil
    Cooldowns[src] = os.time() + 5
    return { ok = true }
end)

AddEventHandler('playerDropped', function()
    Sessions[source]=nil; Cooldowns[source]=nil
end)

AddEventHandler('onResourceStop', function(resource)
    if resource~=GetCurrentResourceName() then return end
    for workerId in pairs(WorkerEntities) do removeWorkerEntity(workerId) end
end)

CreateThread(function()
    ensureTables()
    loadData()
    Wait(1000)
    local spawned = spawnAllWorkers()
    Wait(250)
    syncAll()
    print(('[seoul_brothels] carregado: %s bordel(is), %s funcionaria(s) spawnada(s)'):format(countTable(Brothels), spawned))
    while true do
        Wait(10000)
        local now=os.time()
        for src,s in pairs(Sessions) do if s.expires<=now then Sessions[src]=nil end end
        local respawned = false
        for bid,list in pairs(Workers) do
            for workerId,w in pairs(list) do
                local ped=WorkerEntities[workerId]
                if w.active and (not ped or not DoesEntityExist(ped)) then
                    spawnWorker(w)
                    respawned = true
                end
            end
        end
        if respawned then Wait(250); syncAll() end
    end
end)

exports('OpenAdminForPlayer', function(src)
    src=tonumber(src)
    if not src or not hasAdmin(src) then return false end
    TriggerClientEvent('seoul_brothels:adminOpen',src)
    return true
end)

exports('RespawnWorkers', function()
    loadData()
    local spawned = spawnAllWorkers()
    Wait(250)
    syncAll()
    return spawned
end)

RegisterCommand('seoulbrothels', function(src)
    src = tonumber(src) or 0
    if src > 0 and not hasAdmin(src) then return notify(src, 'negado', 'Sem permissao.') end
    if src > 0 then
        TriggerClientEvent('seoul_brothels:adminOpen', src)
    else
        print('[seoul_brothels] use seoulbrothelsstatus ou seoulbrothelsrespawn pelo console.')
    end
end, false)

RegisterCommand('seoulbrothelsstatus', function(src)
    src = tonumber(src) or 0
    if src > 0 and not hasAdmin(src) then return notify(src, 'negado', 'Sem permissao.') end
    printStatus(src)
end, false)

RegisterCommand('seoulbrothelsrespawn', function(src)
    src = tonumber(src) or 0
    if src > 0 and not hasAdmin(src) then return notify(src, 'negado', 'Sem permissao.') end
    loadData()
    local spawned = spawnAllWorkers()
    Wait(250)
    syncAll()
    local message = ('Respawn concluido: %s funcionaria(s) criada(s).'):format(spawned)
    print('[seoul_brothels] '..message)
    notify(src, 'sucesso', message)
end, false)
