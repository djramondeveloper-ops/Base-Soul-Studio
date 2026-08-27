-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ESX SERVER ADAPTER
-----------------------------------------------------------------------------------------------------------------------------------------
ESX = ESX or {}
ESX.Players = ESX.Players or {}
ESX.ServerCallbacks = ESX.ServerCallbacks or {}
ESX.UsableItems = ESX.UsableItems or {}
ESX.Jobs = ESX.Jobs or Config.Jobs or {}
ESX.Items = ESX.Items or Config.Items or {}

exports('getSharedObject', function() return ESX end)
AddEventHandler('esx:getSharedObject', function(cb) cb(ESX) end)

local function makeXPlayer(source, Passport)
    local Identity = vRP.Identity(Passport) or {}
    local group, level = vRP.getUserGroupByType(Passport, 'job')
    local self = {}
    self.source = source
    self.identifier = tostring(Passport)
    self.user_id = Passport
    self.name = (Identity.Name or 'Individuo') .. ' ' .. (Identity.Lastname or '')
    self.job = { name = group or 'unemployed', label = group or 'Unemployed', grade = level or 0, grade_name = tostring(level or 0), grade_label = tostring(level or 0), grade_salary = 0 }
    self.accounts = { bank = vRP.GetBank(Passport), money = vRP.getMoney(Passport), black_money = vRP.ItemAmount(Passport, 'dirtydollar') }
    self.inventory = vRP.Inventory(Passport)
    self.variables = {}
    function self.getIdentifier() return self.identifier end
    function self.getSource() return self.source end
    function self.getName() return self.name end
    function self.getJob() return self.job end
    function self.setJob(job, grade) vRP.SetPermission(Passport, job, grade or 1); self.job.name=job; self.job.grade=grade or 0 end
    function self.getGroup() return 'user' end
    function self.setGroup(group) self.group = group end
    function self.getAccounts() return self.accounts end
    function self.getAccount(name) return { name = name, money = self.getAccountMoney(name), label = name } end
    function self.getAccountMoney(name) if name=='bank' then return vRP.GetBank(Passport) elseif name=='black_money' then return vRP.ItemAmount(Passport,'dirtydollar') else return vRP.getMoney(Passport) end end
    function self.addAccountMoney(name, money, reason) if name=='bank' then return vRP.GiveBank(Passport,money,true) elseif name=='black_money' then return vRP.GenerateItem(Passport,'dirtydollar',money,true) else return vRP.giveMoney(Passport,money) end end
    function self.removeAccountMoney(name, money, reason) if name=='bank' then return vRP.PaymentBank(Passport,money,true) elseif name=='black_money' then return vRP.TakeItem(Passport,'dirtydollar',money,true) else return vRP.PaymentMoney(Passport,money) end end
    function self.getMoney() return vRP.getMoney(Passport) end
    function self.addMoney(money, reason) return vRP.giveMoney(Passport,money) end
    function self.removeMoney(money, reason) return vRP.PaymentMoney(Passport,money) end
    function self.getInventory() return vRP.Inventory(Passport) end
    function self.getInventoryItem(item) local count = vRP.ItemAmount(Passport,item); return { name=item, count=count, amount=count, label=item } end
    function self.addInventoryItem(item, count) return vRP.GenerateItem(Passport,item,count,true) end
    function self.removeInventoryItem(item, count) return vRP.TakeItem(Passport,item,count,true) end
    function self.canCarryItem(item, count) return vRP.CheckWeight(Passport,item,count) end
    function self.canSwapItem(firstItem, firstCount, testItem, testCount) return true end
    function self.getWeight() return vRP.InventoryWeight(Passport) end
    function self.getMaxWeight() return vRP.GetWeight(Passport) end
    function self.setMaxWeight(weight) return vRP.UpgradeWeight(Passport, weight, '=') end
    function self.showNotification(msg, ntype, length) TriggerClientEvent('esx:showNotification', source, msg, ntype, length) end
    function self.triggerEvent(eventName, ...) TriggerClientEvent(eventName, source, ...) end
    function self.set(k,v) self.variables[k]=v end
    function self.get(k) return self.variables[k] end
    function self.updatePlayerData(key, value) TriggerClientEvent('esx:setPlayerData', source, key, value) end
    function self.kick(reason) DropPlayer(source, reason or 'Kicked') end
    return self
end

function ESX.GetPlayerFromId(source) return ESX.Players[tonumber(source)] end
function ESX.GetPlayerFromIdentifier(identifier) for _,p in pairs(ESX.Players) do if p.identifier == tostring(identifier) then return p end end end
function ESX.GetPlayers() local t={} for src in pairs(ESX.Players) do t[#t+1]=src end return t end
function ESX.GetExtendedPlayers() local t={} for _,p in pairs(ESX.Players) do t[#t+1]=p end return t end
function ESX.GetIdentifier(source) return tostring(vRP.Passport(source) or GetPlayerIdentifierByType(source,'license') or source) end
function ESX.RegisterServerCallback(name, cb) ESX.ServerCallbacks[name] = cb end
function ESX.TriggerClientCallback(source, name, cb, ...) TriggerClientEvent('esx:triggerClientCallback', source, name, ...) end
function ESX.RegisterUsableItem(item, cb) ESX.UsableItems[item] = cb end
function ESX.GetUsableItems() return ESX.UsableItems end
function ESX.UseItem(source, item, ...) if ESX.UsableItems[item] then ESX.UsableItems[item](source, item, ...) end end
function ESX.GetItemLabel(item) return ItemName and ItemName(item) or item end
function ESX.GetItems() return ESX.Items end
function ESX.DoesJobExist(job, grade) return true end
function ESX.GetJobs() return ESX.Jobs end
function ESX.GetNumPlayers() return #ESX.GetPlayers() end
function ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
    if type(name) == 'table' then for _,n in ipairs(name) do ESX.RegisterCommand(n,group,cb,allowConsole,suggestion) end return end
    RegisterCommand(name, function(source,args,raw)
        local xPlayer = ESX.GetPlayerFromId(source)
        cb(xPlayer, args, function(msg) if source > 0 then TriggerClientEvent('chat:addMessage', source, { args = { msg } }) end end)
    end, false)
end

RegisterNetEvent('esx:triggerServerCallback', function(name, requestId, ...)
    local source = source
    local cb = ESX.ServerCallbacks[name]
    if not cb then return end
    cb(source, function(...)
        TriggerClientEvent('esx:serverCallback', source, requestId, ...)
    end, ...)
end)

AddEventHandler('Connect', function(Passport, source, First)
    ESX.Players[source] = makeXPlayer(source, Passport)
    TriggerEvent('esx:playerLoaded', source, ESX.Players[source], First)
    TriggerClientEvent('esx:playerLoaded', source, {
        identifier = ESX.Players[source].identifier,
        accounts = ESX.Players[source].getAccounts(),
        inventory = ESX.Players[source].getInventory(),
        job = ESX.Players[source].getJob(),
        money = ESX.Players[source].getMoney(),
        dead = false
    }, First)
end)

AddEventHandler('playerDropped', function()
    ESX.Players[source] = nil
end)

if tostring(GetConvar('seoul:debug', 'false')):lower() == 'true' then print('^2[Seoul]^7 ESX adapter ativo.') end
