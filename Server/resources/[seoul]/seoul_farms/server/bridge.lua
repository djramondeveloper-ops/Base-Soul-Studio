-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS SERVER BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = Tunnel or module("vrp","lib/Tunnel")
Proxy = Proxy or module("vrp","lib/Proxy")
vRP = vRP or Proxy.getInterface("vRP")

SeoulFarms = SeoulFarms or {}

local function debugLog(msg)
    if Farms and Farms.Debug then
        print("[Seoul Farms] "..tostring(msg))
    end
end

local function parseAmount(value)
    if parseInt then return parseInt(value) end
    return math.floor(tonumber(value) or 0)
end

local function safeCall(fn,...)
    if not fn then return nil end
    local ok,res = pcall(fn,...)
    if ok then return res end
    if Farms and Farms.Debug then print("[Seoul Farms] safeCall: "..tostring(res)) end
    return nil
end

local PermissionAliases = {
    ["mechanic"] = function() return Farms.Permissions.Mechanic end,
    ["Mechanic"] = function() return Farms.Permissions.Mechanic end,
    ["gang"] = function() return Farms.Permissions.Gangs end,
    ["gangs"] = function() return Farms.Permissions.Gangs end,
    ["Gangs"] = function() return Farms.Permissions.Gangs end,
    ["police"] = function() return Farms.Permissions.Police end,
    ["Police"] = function() return Farms.Permissions.Police end,
    ["policia.permissao"] = function() return Farms.Permissions.Police end
}

function SeoulFarms.Debug(Message)
    debugLog(Message)
end

function SeoulFarms.Passport(source)
    return (vRP.Passport and vRP.Passport(source)) or (vRP.getUserId and vRP.getUserId(source)) or false
end

function SeoulFarms.Source(Passport)
    return (vRP.Source and vRP.Source(Passport)) or (vRP.getUserSource and vRP.getUserSource(Passport)) or false
end

function SeoulFarms.Identity(Passport)
    local Identity = (vRP.Identity and vRP.Identity(Passport)) or (vRP.getUserIdentity and vRP.getUserIdentity(Passport)) or {}
    Identity.name = Identity.name or Identity.Name or "Passaporte"
    Identity.name2 = Identity.name2 or Identity.Lastname or tostring(Passport)
    return Identity
end

local function permissionList(Permission)
    if type(Permission) == "table" then return Permission end
    local Alias = PermissionAliases[tostring(Permission or "")]
    if Alias then return Alias() end
    return { Permission }
end

function SeoulFarms.HasPermissionByPassport(Passport,Permission)
    if not Passport then return false end
    for _,Perm in ipairs(permissionList(Permission)) do
        if Perm and Perm ~= "" then
            if vRP.HasPermission and vRP.HasPermission(Passport,Perm) then return true end
            if vRP.hasPermission and vRP.hasPermission(Passport,Perm) then return true end
        end
    end
    return false
end

function SeoulFarms.HasPermission(source,Permission)
    return SeoulFarms.HasPermissionByPassport(SeoulFarms.Passport(source),Permission)
end

function SeoulFarms.Notify(source,Type,Message,Time)
    TriggerClientEvent("Notify",source,Type or "info",Message or "",Time or 5000)
end

function SeoulFarms.ItemAmount(source,Passport,Item)
    Passport = Passport or SeoulFarms.Passport(source)
    if vRP.ItemAmount then return parseAmount(vRP.ItemAmount(Passport,Item)) end
    if vRP.getInventoryItemAmount then return parseAmount(vRP.getInventoryItemAmount(Passport,Item)) end
    if vRP.InventoryItemAmount then
        local Data = vRP.InventoryItemAmount(Passport,Item)
        return parseAmount(Data and Data[1] or 0)
    end
    if GetResourceState("ox_inventory") == "started" then
        local Amount = safeCall(function() return exports.ox_inventory:GetItem(source,Item,nil,true) end)
        return parseAmount(Amount)
    end
    return 0
end

function SeoulFarms.ItemName(Item)
    if ItemName then return ItemName(Item) end
    if vRP.itemNameList then return vRP.itemNameList(Item) end
    return Item
end

function SeoulFarms.CanCarry(source,Passport,Item,Amount)
    Amount = parseAmount(Amount)
    Passport = Passport or SeoulFarms.Passport(source)
    if vRP.CheckWeight then return vRP.CheckWeight(Passport,Item,Amount) end
    if GetResourceState("ox_inventory") == "started" then
        local Result = safeCall(function() return exports.ox_inventory:CanCarryItem(source,Item,Amount) end)
        if Result ~= nil then return Result end
    end
    local Weight = (vRP.itemWeightList and vRP.itemWeightList(Item)) or (ItemWeight and ItemWeight(Item)) or 0
    if vRP.computeInvWeight and vRP.getBackpack then
        return (vRP.computeInvWeight(Passport) + (Weight * Amount)) <= vRP.getBackpack(Passport)
    end
    return true
end

function SeoulFarms.GiveItem(source,Passport,Item,Amount,Notify)
    Amount = parseAmount(Amount)
    Passport = Passport or SeoulFarms.Passport(source)
    if Amount <= 0 then return false end
    if vRP.GenerateItem then return vRP.GenerateItem(Passport,Item,Amount,Notify ~= false) ~= false end
    if vRP.GiveItem then return vRP.GiveItem(Passport,Item,Amount,Notify ~= false) ~= false end
    if vRP.giveInventoryItem then return vRP.giveInventoryItem(Passport,Item,Amount,Notify ~= false) ~= false end
    if GetResourceState("ox_inventory") == "started" then
        return safeCall(function() return exports.ox_inventory:AddItem(source,Item,Amount) end) and true or false
    end
    return false
end

function SeoulFarms.TakeItem(source,Passport,Item,Amount,Notify)
    Amount = parseAmount(Amount)
    Passport = Passport or SeoulFarms.Passport(source)
    if Amount <= 0 then return false end
    if vRP.TakeItem then return vRP.TakeItem(Passport,Item,Amount,Notify ~= false) end
    if vRP.tryGetInventoryItem then return vRP.tryGetInventoryItem(Passport,Item,Amount,Notify ~= false) end
    if GetResourceState("ox_inventory") == "started" then
        return safeCall(function() return exports.ox_inventory:RemoveItem(source,Item,Amount) end) and true or false
    end
    return false
end

function SeoulFarms.AddStress(Passport,Amount)
    if vRP.UpgradeStress then vRP.UpgradeStress(Passport,Amount) return end
    if vRP.upgradeStress then vRP.upgradeStress(Passport,Amount) return end
end

function SeoulFarms.Format(Value)
    if vRP.format then return vRP.format(parseAmount(Value)) end
    if Dotted then return Dotted(parseAmount(Value)) end
    return tostring(parseAmount(Value))
end

function SeoulFarms.VehicleOwnerByPlate(Plate)
    if vRP.PassportPlate then return vRP.PassportPlate(Plate) end
    if vRP.getVehiclePlate then return vRP.getVehiclePlate(Plate) end
    return false
end

function SeoulFarms.VehiclePrice(Name)
    if vRP.vehiclePrice then return parseAmount(vRP.vehiclePrice(Name)) end
    if VehiclePrice then return parseAmount(VehiclePrice(Name)) end
    return 100000
end

function SeoulFarms.VehicleName(Name)
    if VehicleName then return VehicleName(Name) end
    return Name
end

function SeoulFarms.AddFine(Passport,Amount,Description,Source)
    Amount = parseAmount(Amount)
    if not Passport or Amount <= 0 then return false end
    if GetResourceState("bank") == "started" then
        local ok = safeCall(function()
            exports.bank:AddTaxes(Passport,Source or false,"Seguro",Amount,Description or "Seguro de veículo")
            return true
        end)
        if ok then return true end
    end
    if vRP.setFines then return vRP.setFines(Passport,Amount) end
    if vRP.GiveFine then return vRP.GiveFine(Passport,Amount) end
    return false
end

function SeoulFarms.Webhook(Url,Message)
    if not Url or Url == "" then return end
    if vRP.createWeebHook then
        safeCall(function() vRP.createWeebHook(Url,Message) end)
    end
end

function SeoulFarms.PlayersByPermission(Permission)
    local Result = {}
    for _,Perm in ipairs(permissionList(Permission)) do
        local Players = nil
        if vRP.NumPermission then Players = vRP.NumPermission(Perm) end
        if (not Players or next(Players) == nil) and vRP.numPermission then Players = vRP.numPermission(Perm) end
        if Players then
            for Passport,Source in pairs(Players) do
                if type(Source) == "number" then Result[Passport] = Source end
            end
        end
    end
    return Result
end

function SeoulFarms.RequiredItems()
    local Items = {}
    local function add(item)
        if item and item ~= "" then Items[item] = true end
    end
    for _,Data in pairs({ Farms.cocaina or {}, Farms.maconha or {}, Farms.meta or {} }) do
        for _,Farm in pairs(Data) do
            for _,Step in pairs(Farm.itens or {}) do
                add(Step.re); add(Step.item)
            end
        end
    end
    for _,Item in ipairs(Farms.itemList or {}) do add(Item.item) end
    for _,Lavagem in pairs(Farms.lavagem or {}) do
        for Item in pairs(Lavagem.requirements or {}) do add(Item) end
    end
    for _,Desmanche in pairs(Farms.desmanche or {}) do
        add(Desmanche.ItemNecessario)
        for Item in pairs(Desmanche.Payment or {}) do add(Item) end
    end
    add(Farms.DirtyMoneyItem or "dirtydollar")
    add(Farms.CleanMoneyItem or "dollar")
    return Items
end

RegisterCommand("seoulfarmsstatus",function(source)
    local Total = 0
    for _ in pairs(SeoulFarms.RequiredItems()) do Total = Total + 1 end
    local Message = "Seoul Farms OK | drogas/lavagem: gangs | desmanche: mechanic | itens usados: "..Total
    if source and source > 0 then
        SeoulFarms.Notify(source,"info",Message,7000)
    else
        print("[Seoul Farms] "..Message)
    end
end,false)
