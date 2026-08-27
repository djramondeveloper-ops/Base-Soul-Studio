-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL LEGACY/REBORN/CREATIVE COMPAT SERVER
-- Mantém a Origens/vRP como core real e cria nomes/contratos que scripts Reborn, Creative antiga, QB e ESX esperam.
-----------------------------------------------------------------------------------------------------------------------------------------
Seoul = Seoul or {}
Reborn = Reborn or Seoul -- alias legado; não é auth e não chama servidor externo.

Proxy.addInterface("Seoul", Seoul)
Tunnel.bindInterface("Seoul", Seoul)
Proxy.addInterface("Reborn", Seoul)
Tunnel.bindInterface("Reborn", Seoul)

GlobalState["Inventory"] = GlobalState["Inventory"] or (UsingOxInventory and "ox_inventory" or "creative")
GlobalState["Basics"] = GlobalState["Basics"] or {
    ServerName = ServerName or "Seoul",
    Discord = ServerLink or "",
    MaxHealth = 400
}
GlobalState["RebornConfig"] = GlobalState["RebornConfig"] or { images = "nui://ox_inventory/web/images/" }
GlobalState["SeoulConfig"] = GlobalState["SeoulConfig"] or { images = "nui://ox_inventory/web/images/" }

local function normalizeItem(item)
    if not item then return item end
    item = tostring(item)
    local aliases = SeoulLegacyCashAliases or {}
    return aliases[item] or item
end
Seoul.NormalizeItem = normalizeItem
Reborn.NormalizeItem = normalizeItem

local function exportHandler(resource, exportName, func)
    AddEventHandler(("__cfx_export_%s_%s"):format(resource, exportName), function(setCB)
        setCB(func)
    end)
end
_G.exportHandler = _G.exportHandler or exportHandler

function Seoul.license()
    return { license = "Seoul-Core", ip = "http://localhost/", porta = tostring(GetConvarInt("sv_port", 30120)) }
end
function Seoul.images() return GlobalState["SeoulConfig"].images end
function Seoul.multi_personagem() return { Enabled = true, Max_personagens = 1 } end
function Seoul.needs() return { Tempo = 90, Fome = 2, Sede = 1 } end
function Seoul.segurity_code() return { start_bank = 0, start_money = 0 } end
function Seoul.frameworkTables()
    return { users = false, owned_vehicles = false, players = false, player_vehicles = false, ox_inventory = true, characters = true, vehicles = true }
end
function Seoul.dbSimilarTables() return {} end
function Seoul.groups()
    local groups = {}
    if type(Groups) == "table" then
        for name, data in pairs(Groups) do
            groups[name] = data
        end
    end
    return groups
end

AddEventHandler("Seoul:reloadInfos", function() end)
AddEventHandler("Reborn:reloadInfos", function() TriggerEvent("Seoul:reloadInfos") end)

-- SQL aliases estilo vRP antigo/Reborn
function vRP.prepare(name, query) return vRP.Prepare(name, query) end
function vRP.query(name, params) return vRP.Query(name, params or {}) end
function vRP.execute(name, params) return vRP.Update(name, params or {}) end

-- Player aliases
function vRP.getUserId(source) return vRP.Passport(source) end
function vRP.getUserd(source) return vRP.Passport(source) end
function vRP.getUserSource(user_id) return vRP.Source(parseInt(user_id)) end
function vRP.getUsers() return vRP.Players() end
function vRP.getUserDataTable(user_id) return vRP.Datatable(parseInt(user_id)) end
function vRP.getUData(user_id, key) return json.encode(vRP.UserData(parseInt(user_id), key) or {}) end
function vRP.setUData(user_id, key, value)
    return vRP.Query("playerdata/SetData", { Passport = parseInt(user_id), Name = key, Information = value or "{}" })
end
function vRP.getSData(key) return json.encode(vRP.GetSrvData(key, true) or {}) end
function vRP.setSData(key, value) return vRP.SetSrvData(key, json.decode(value or "{}") or {}, true) end

-- Identity aliases
function vRP.getUserIdentity(user_id)
    local id = vRP.Identity(parseInt(user_id))
    if not id then return nil end
    id.name2 = id.name2 or id.Lastname
    id.name = id.name or id.Name
    id.firstname = id.firstname or id.Name
    id.lastname = id.lastname or id.Lastname
    id.user_id = id.id
    id.registration = id.registration or id.Registration or id.Phone or tostring(id.id)
    id.phone = id.phone or id.Phone or vRP.Phone(id.id)
    return id
end
function vRP.getInformation(user_id)
    local id = vRP.Identity(parseInt(user_id))
    if not id then return {} end
    local row = {}
    for k,v in pairs(id) do row[k] = v end
    row.name = row.name or row.Name
    row.name2 = row.name2 or row.Lastname
    row.bank = row.bank or row.Bank or 0
    row.phone = row.phone or row.Phone or vRP.Phone(user_id)
    row.inventory = json.encode(vRP.Inventory(user_id) or {})
    return { row }
end
function vRP.getInfos(user_id) return vRP.getInformation(user_id) end
function vRP.getUserIdRegistration(registration) return false end
function vRP.getUserByRegistration(registration) return vRP.getUserIdRegistration(registration) end
function vRP.generateRegistrationNumber() return vRP.GenerateToken() end
function vRP.generatePlateNumber() return vRP.GeneratePlate() end
function vRP.genPlate() return vRP.GeneratePlate() end
function vRP.getVehiclePlate(plate) return vRP.PassportPlate(plate) end

-- Money aliases
function vRP.addBank(user_id, amount) return vRP.GiveBank(parseInt(user_id), parseInt(amount)) end
function vRP.giveBankMoney(user_id, amount) return vRP.GiveBank(parseInt(user_id), parseInt(amount)) end
function vRP.setBank(user_id, amount)
    local current = vRP.GetBank(user_id)
    amount = parseInt(amount)
    if amount > current then return vRP.GiveBank(user_id, amount - current) end
    if amount < current then return vRP.RemoveBank(user_id, current - amount) end
end
function vRP.getBank(user_id) return vRP.GetBank(parseInt(user_id)) end
function vRP.getBankMoney(user_id) return vRP.GetBank(parseInt(user_id)) end
function vRP.paymentBank(user_id, amount) return vRP.PaymentBank(parseInt(user_id), parseInt(amount)) end
function vRP.tryPayment(user_id, amount) return vRP.PaymentFull(parseInt(user_id), parseInt(amount)) end
function vRP.tryFullPayment(user_id, amount) return vRP.PaymentFull(parseInt(user_id), parseInt(amount)) end
function vRP.getMoney(user_id) return vRP.ItemAmount(parseInt(user_id), SeoulCashItem or "dollar") end
function vRP.giveMoney(user_id, amount) return vRP.GenerateItem(parseInt(user_id), SeoulCashItem or "dollar", parseInt(amount), true) end
function vRP.setMoney(user_id, amount)
    local cash = vRP.getMoney(user_id)
    if cash > 0 then vRP.TakeItem(user_id, SeoulCashItem or "dollar", cash, false) end
    if parseInt(amount) > 0 then vRP.giveMoney(user_id, amount) end
end
function vRP.withdrawCash(user_id, amount) return vRP.WithdrawCash(user_id, amount) end
function vRP.PaymentMoney(user_id, amount) return vRP.TakeItem(user_id, SeoulCashItem or "dollar", parseInt(amount), true) end
function vRP.PaymentDirty(user_id, amount) return vRP.TakeItem(user_id, "dirtydollar", parseInt(amount), true) end
function vRP.GetFine(user_id) return 0 end
function vRP.GiveFine(user_id, amount) return true end
function vRP.RemoveFine(user_id, amount) return true end
function vRP.getFines(user_id) return 0 end
function vRP.setFines(user_id, amount) return true end

-- Inventory aliases. OX overrides ficam em ox_inventory.lua quando iniciado.
function vRP.itemWeightList(item) return ItemWeight and ItemWeight(normalizeItem(item)) or 0 end
function vRP.getItemWeight(item) return vRP.itemWeightList(item) end
function vRP.getInventory(user_id) return vRP.Inventory(parseInt(user_id)) end
function vRP.getInventoryItemAmount(user_id, item) return vRP.ItemAmount(parseInt(user_id), normalizeItem(item)) end
function vRP.giveInventoryItem(user_id, item, amount, notify, slot, metadata) return vRP.GenerateItem(parseInt(user_id), normalizeItem(item), parseInt(amount), notify, slot) end
function vRP.tryGetInventoryItem(user_id, item, amount, slot, notify) return vRP.TakeItem(parseInt(user_id), normalizeItem(item), parseInt(amount), notify, slot) end
function vRP.removeInventoryItem(user_id, item, amount, slot, notify) return vRP.TakeItem(parseInt(user_id), normalizeItem(item), parseInt(amount), notify, slot) end
function vRP.clearInventory(user_id) return vRP.ClearInventory(parseInt(user_id)) end
function vRP.computeInvWeight(user_id) return vRP.InventoryWeight(parseInt(user_id)) end
function vRP.computeChestWeight(data) return vRP.ChestWeight(data or {}) end
function vRP.getBackpack(user_id) return vRP.GetWeight(parseInt(user_id)) end
function vRP.setBackpack(user_id, amount) return vRP.UpgradeWeight(parseInt(user_id), parseInt(amount), "=") end
function vRP.storeChestItem(user_id, chest, item, amount, slot, target) return vRP.StoreChest(user_id, chest, amount, 0, slot, target, true) end
function vRP.tryChestItem(user_id, chest, item, amount, slot, target) return vRP.TakeChest(user_id, chest, amount, slot, target, true) end
function vRP.updateChest(user_id, chest, slot, target, amount) return vRP.UpdateChest(user_id, chest, slot, target, amount, true) end

-- Groups aliases
function vRP.hasPermission(user_id, permission, level) return vRP.HasPermission(parseInt(user_id), permission, level) end
function vRP.addUserGroup(user_id, group, level) return vRP.SetPermission(parseInt(user_id), group, level or 1) end
function vRP.removeUserGroup(user_id, group) return vRP.RemovePermission(parseInt(user_id), group) end
function vRP.getUserGroups(user_id) return vRP.UserGroups(parseInt(user_id)) end
function vRP.numPermission(permission) return vRP.NumPermission(permission) end
function vRP.getUserGroupByType(user_id, groupType)
    local userGroups = vRP.UserGroups(parseInt(user_id)) or {}
    for group, level in pairs(userGroups) do
        if not groupType or vRP.GroupType(group) == groupType or groupType == "job" or groupType == "work" then
            return group, level
        end
    end
    return "unemployed", 0
end
function vRP.getSalaryByGroup(group, level) return 0 end
function vRP.GetUserHierarchy(user_id, group) return (vRP.UserGroups(user_id) or {})[group] or 0 end

-- Needs aliases
function vRP.upgradeHunger(user_id, amount) return vRP.UpgradeHunger(user_id, amount) end
function vRP.upgradeThirst(user_id, amount) return vRP.UpgradeThirst(user_id, amount) end
function vRP.upgradeStress(user_id, amount) return vRP.UpgradeStress(user_id, amount) end
function vRP.downgradeHunger(user_id, amount) return vRP.DowngradeHunger(user_id, amount) end
function vRP.downgradeThirst(user_id, amount) return vRP.DowngradeThirst(user_id, amount) end
function vRP.downgradeStress(user_id, amount) return vRP.DowngradeStress(user_id, amount) end

-- Phone/LB aliases
function vRP.GenerateString(format)
    local text = tostring(format or "DDD-DDDD")
    return (text:gsub("D", function() return tostring(math.random(0,9)) end):gsub("L", function() return string.char(math.random(65,90)) end))
end
function vRP.GeneratePhone() return vRP.GenerateString("DDD-DDDD") end
function vRP.generateStringNumber(format) return vRP.GenerateString(format) end
function vRP.generatePhoneNumber() return vRP.GeneratePhone() end
function vRP.GetPhone(user_id) return vRP.Phone(user_id) end
function vRP.UserPhone(user_id) return vRP.Phone(user_id) end
function vRP.getPhone(user_id) return vRP.Phone(user_id) end
function vRP.getUserByPhone(phone) return false end
function vRP.UpgradePhone(user_id, phone) return true end
function vRP.upgradePhone(user_id, phone) return true end

-- Misc aliases
function vRP.isBanned(id) return vRP.Banned and vRP.Banned(id) or false end
function vRP.initPrison(user_id, amount) return vRP.InsertPrison(user_id, amount) end
function vRP.updatePrison(user_id, amount) return vRP.UpdatePrison(user_id, amount) end
function vRP.InitPrison(user_id, amount) return vRP.InsertPrison(user_id, amount) end
function vRP.UpgradeChars(source) return vRP.UpgradeCharacters(source) end
function vRP.remGmsId(user_id, amount) return vRP.PaymentGems(user_id, amount) end
function vRP.userGemstone(license) return 0 end
function vRP.PaymentGemstone(user_id, amount) return vRP.PaymentGems(user_id, amount) end

local function SeoulStartupLog()
    local debug = tostring(GetConvar("seoul:debug", "false")):lower()
    local startup = tostring(GetConvar("seoul:startupLog", "true")):lower()
    if startup ~= "false" then
        print("^2[Seoul]^7 Seoul Base MultiFramework carregada com sucesso.")
    elseif debug == "true" or debug == "1" or debug == "yes" or debug == "sim" then
        print("^2[Seoul]^7 Seoul Base MultiFramework carregada com sucesso.")
    end
end

SeoulStartupLog()
