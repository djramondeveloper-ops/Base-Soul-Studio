-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL QBCORE SERVER ADAPTER
-----------------------------------------------------------------------------------------------------------------------------------------
QBCore = QBCore or {}
QBCore.Config = QBConfig
QBCore.Shared = QBShared
QBCore.ServerCallbacks = QBCore.ServerCallbacks or {}
QBCore.ClientCallbacks = QBCore.ClientCallbacks or {}
QBCore.UsableItems = QBCore.UsableItems or {}
QBCore.Players = QBCore.Players or {}
QBCore.Commands = QBCore.Commands or { List = {}, IgnoreList = { user = true, owner = true } }

exports('GetCoreObject', function() return QBCore end)
AddEventHandler('QBCore:GetObject', function(cb) cb(QBCore) end)

local function passportFromSource(source) return vRP.Passport(source) end
local function normalizeMoneyType(t) if t == 'cash' or t == 'money' then return 'cash' elseif t == 'bank' then return 'bank' else return t end end

local function makePlayerData(source, Passport)
    local Identity = vRP.Identity(Passport) or {}
    local Groups = vRP.UserGroups(Passport) or {}
    local jobName, jobLevel = vRP.getUserGroupByType(Passport, 'job')
    jobName = jobName or 'unemployed'
    jobLevel = tonumber(jobLevel) or 0
    return {
        source = source,
        citizenid = tostring(Passport),
        cid = Passport,
        license = Identity.License or vRP.License(Passport) or '',
        name = (Identity.Name or Identity.name or 'Individuo') .. ' ' .. (Identity.Lastname or Identity.name2 or ''),
        charinfo = {
            firstname = Identity.Name or Identity.name or 'Individuo',
            lastname = Identity.Lastname or Identity.name2 or 'Indigente',
            birthdate = Identity.Birthdate or Identity.Birth or '00-00-0000',
            gender = Identity.Sex == 'F' and 1 or 0,
            phone = vRP.Phone(Passport),
            account = tostring(Passport)
        },
        money = { cash = vRP.getMoney(Passport), bank = vRP.GetBank(Passport), crypto = 0 },
        job = { name = jobName, label = jobName, type = 'job', onduty = vRP.HasService(Passport, jobName), isboss = jobLevel == 1, grade = { name = tostring(jobLevel), level = jobLevel, payment = 0 } },
        gang = { name = 'none', label = 'No Gang', isboss = false, grade = { name = 'none', level = 0 } },
        metadata = vRP.Datatable(Passport) or {},
        position = GetEntityCoords(GetPlayerPed(source)),
        items = vRP.Inventory(Passport),
        groups = Groups
    }
end

local function makePlayer(source, Passport)
    local Player = { PlayerData = makePlayerData(source, Passport), Functions = {} }
    function Player.Functions.UpdatePlayerData()
        Player.PlayerData = makePlayerData(source, Passport)
        TriggerClientEvent('QBCore:Player:SetPlayerData', source, Player.PlayerData)
        TriggerClientEvent('QBCore:Player:UpdatePlayerData', source, Player.PlayerData)
    end
    function Player.Functions.SetPlayerData(key, val) Player.PlayerData[key] = val; Player.Functions.UpdatePlayerData() end
    function Player.Functions.SetMetaData(key, val)
        Player.PlayerData.metadata[key] = val
        local data = vRP.Datatable(Passport) or {}
        data[key] = val
        Player.Functions.UpdatePlayerData()
    end
    function Player.Functions.GetItemByName(item)
        item = Seoul.NormalizeItem(item)
        local amount = vRP.ItemAmount(Passport, item)
        if amount > 0 then return { name = item, amount = amount, count = amount, label = item } end
    end
    function Player.Functions.GetItemsByName(item)
        local it = Player.Functions.GetItemByName(item)
        return it and { it } or {}
    end
    function Player.Functions.AddItem(item, amount, slot, info, reason) return vRP.GenerateItem(Passport, item, amount or 1, true, slot, info) end
    function Player.Functions.RemoveItem(item, amount, slot, reason) return vRP.TakeItem(Passport, item, amount or 1, true, slot) end
    function Player.Functions.ClearInventory() return vRP.ClearInventory(Passport) end
    function Player.Functions.SetInventory(items) return true end
    function Player.Functions.AddMoney(mtype, amount, reason)
        mtype = normalizeMoneyType(mtype)
        if mtype == 'bank' then return vRP.GiveBank(Passport, amount, true) end
        if mtype == 'cash' then return vRP.GenerateItem(Passport, SeoulCashItem or 'dollar', amount, true) end
        return false
    end
    function Player.Functions.RemoveMoney(mtype, amount, reason)
        mtype = normalizeMoneyType(mtype)
        if mtype == 'bank' then return vRP.PaymentBank(Passport, amount, true) end
        if mtype == 'cash' then return vRP.TakeItem(Passport, SeoulCashItem or 'dollar', amount, true) end
        return false
    end
    function Player.Functions.SetMoney(mtype, amount, reason)
        mtype = normalizeMoneyType(mtype)
        if mtype == 'bank' then vRP.setBank(Passport, amount); return true end
        if mtype == 'cash' then vRP.setMoney(Passport, amount); return true end
        return false
    end
    function Player.Functions.GetMoney(mtype)
        mtype = normalizeMoneyType(mtype)
        if mtype == 'bank' then return vRP.GetBank(Passport) end
        if mtype == 'cash' then return vRP.getMoney(Passport) end
        return 0
    end
    function Player.Functions.SetJob(job, grade) vRP.SetPermission(Passport, job, grade or 1); Player.Functions.UpdatePlayerData(); return true end
    function Player.Functions.SetGang(gang, grade) vRP.SetPermission(Passport, gang, grade or 1); Player.Functions.UpdatePlayerData(); return true end
    function Player.Functions.SetJobDuty(onDuty) Player.PlayerData.job.onduty = onDuty; Player.Functions.UpdatePlayerData() end
    function Player.Functions.Save() return true end
    function Player.Functions.Logout() QBCore.Player.Logout(source) end
    function Player.Functions.AddMethod(methodName, handler) Player.Functions[methodName] = handler end
    function Player.Functions.AddField(fieldName, data) Player[fieldName] = data end
    return Player
end

QBCore.Functions = QBCore.Functions or {}
function QBCore.Functions.GetCoords(entity) local c=GetEntityCoords(entity); return vector4(c.x,c.y,c.z,GetEntityHeading(entity)) end
function QBCore.Functions.GetIdentifier(source, idtype) return GetPlayerIdentifierByType(source, idtype or 'license') end
function QBCore.Functions.GetSource(identifier) for src in pairs(QBCore.Players) do for _,id in pairs(GetPlayerIdentifiers(src)) do if id == identifier then return src end end end return 0 end
function QBCore.Functions.GetPlayer(source) return QBCore.Players[tonumber(source)] end
function QBCore.Functions.GetPlayerByCitizenId(citizenid) for _,p in pairs(QBCore.Players) do if tostring(p.PlayerData.citizenid) == tostring(citizenid) then return p end end end
function QBCore.Functions.GetPlayerByPhone(number) for _,p in pairs(QBCore.Players) do if tostring(p.PlayerData.charinfo.phone) == tostring(number) then return p end end end
function QBCore.Functions.GetPlayers() local t={} for src in pairs(QBCore.Players) do t[#t+1]=src end return t end
function QBCore.Functions.GetQBPlayers() return QBCore.Players end
function QBCore.Functions.HasPermission(source, permission) local p=passportFromSource(source); return p and vRP.HasPermission(p, permission) or false end
function QBCore.Functions.HasItem(source, item, amount) local p=passportFromSource(source); return p and vRP.ItemAmount(p,item) >= (amount or 1) end
function QBCore.Functions.Notify(source, text, ntype, length) TriggerClientEvent('Notify', source, ntype or 'primary', text, length or 5000) end
function QBCore.Functions.CreateCallback(name, cb) QBCore.ServerCallbacks[name] = cb end
function QBCore.Functions.TriggerCallback(name, source, cb, ...) if QBCore.ServerCallbacks[name] then QBCore.ServerCallbacks[name](source, cb, ...) end end
function QBCore.Functions.RegisterServerCallback(name, cb) QBCore.Functions.CreateCallback(name, cb) end
function QBCore.Functions.CreateUseableItem(item, cb) QBCore.UsableItems[item] = cb end
function QBCore.Functions.CanUseItem(item) return QBCore.UsableItems[item] end
function QBCore.Functions.UseItem(source, item) local cb=QBCore.UsableItems[item.name or item]; if cb then cb(source, item) end end
function QBCore.Functions.SpawnVehicle(source, model, coords, warp) TriggerClientEvent('QBCore:Command:SpawnVehicle', source, model, coords, warp) end
function QBCore.Functions.DeleteVehicle(vehicle) DeleteEntity(vehicle) end
function QBCore.Functions.CreatePhoneNumber() return vRP.GeneratePhone() end
function QBCore.Functions.CreateAccountNumber() return tostring(math.random(10000000,99999999)) end

QBCore.Player = QBCore.Player or {}
function QBCore.Player.Login(source, citizenid, newData)
    local Passport = tonumber(citizenid) or passportFromSource(source)
    if not Passport then return false end
    QBCore.Players[source] = makePlayer(source, Passport)
    TriggerEvent('QBCore:Server:PlayerLoaded', QBCore.Players[source])
    TriggerClientEvent('QBCore:Client:OnPlayerLoaded', source)
    TriggerClientEvent('QBCore:Player:SetPlayerData', source, QBCore.Players[source].PlayerData)
    return QBCore.Players[source]
end
function QBCore.Player.Logout(source)
    TriggerClientEvent('QBCore:Client:OnPlayerUnload', source)
    TriggerEvent('QBCore:Server:OnPlayerUnload', source)
    QBCore.Players[source] = nil
end
function QBCore.Player.Save(source) return true end
function QBCore.Player.SaveOffline(PlayerData) return true end
function QBCore.Player.CreateCitizenId() return tostring(math.random(100000,999999)) end
function QBCore.Player.CreateFingerId() return tostring(math.random(100000,999999)) end
function QBCore.Player.CreateWalletId() return tostring(math.random(100000,999999)) end
function QBCore.Player.CreateSerialNumber() return tostring(math.random(100000,999999)) end

RegisterNetEvent('QBCore:Server:TriggerCallback', function(name, ...)
    local source = source
    local cb = QBCore.ServerCallbacks[name]
    if not cb then return end
    cb(source, function(...)
        TriggerClientEvent('QBCore:Client:TriggerCallback', source, name, ...)
    end, ...)
end)

RegisterNetEvent('QBCore:UpdatePlayer', function()
    local source = source
    if QBCore.Players[source] then QBCore.Players[source].Functions.UpdatePlayerData() end
end)

AddEventHandler('Connect', function(Passport, source, First)
    QBCore.Player.Login(source, Passport, {})
end)

AddEventHandler('playerDropped', function()
    QBCore.Players[source] = nil
end)

if tostring(GetConvar('seoul:debug', 'false')):lower() == 'true' then print('^2[Seoul]^7 QBCore adapter ativo.') end
