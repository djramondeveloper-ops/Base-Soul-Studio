-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL / VRP CREATIVE FRAMEWORK ADAPTER
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

PetshopFramework = PetshopFramework or {}

local function getPassport(src)
    src = tonumber(src)
    if not src or not vRP or not vRP.Passport then
        return nil
    end

    return vRP.Passport(src)
end

local function cashItem()
    return SeoulCashItem or "dollar"
end

local function getCashAmount(Passport)
    if vRP.getMoney then
        return tonumber(vRP.getMoney(Passport)) or 0
    end

    if vRP.ItemAmount then
        return tonumber(vRP.ItemAmount(Passport, cashItem())) or 0
    end

    return 0
end

CreateThread(function()
    print("^2[nn_petshop]^0 Framework: Seoul vRP/Creative")
end)

function PetshopFramework.GetIdentifier(src)
    local Passport = getPassport(src)
    if Passport then
        return tostring(Passport)
    end

    return nil
end

function PetshopFramework.GetCash(src)
    local Passport = getPassport(src)
    if not Passport then
        return 0
    end

    local cash = getCashAmount(Passport)
    local bank = vRP.GetBank and (tonumber(vRP.GetBank(Passport)) or 0) or 0
    return math.max(cash, bank)
end

function PetshopFramework.RemoveCash(src, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 0)
    if not Passport then
        return false
    end

    if amount <= 0 then
        return true
    end

    if vRP.PaymentFull then
        return vRP.PaymentFull(Passport, amount, true)
    end

    if vRP.TakeItem then
        return vRP.TakeItem(Passport, cashItem(), amount, true)
    end

    return false
end

function PetshopFramework.HasItem(src, itemName, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 1)

    if not Passport or not itemName or itemName == "" then
        return itemName == nil or itemName == ""
    end

    return (vRP.ItemAmount(Passport, itemName) or 0) >= amount
end

function PetshopFramework.RemoveItem(src, itemName, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 1)

    if not Passport or not itemName or itemName == "" or amount <= 0 then
        return false
    end

    return vRP.TakeItem(Passport, itemName, amount, true)
end

function PetshopFramework.AddItem(src, itemName, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 1)

    if not Passport or not itemName or itemName == "" or amount <= 0 then
        return false
    end

    return vRP.GenerateItem(Passport, itemName, amount, true)
end

function PetshopFramework.CanCarryItem(src, itemName, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 1)

    if not Passport or not itemName or itemName == "" or amount <= 0 then
        return false
    end

    if vRP.MaxItens and vRP.MaxItens(Passport, itemName, amount) then
        return false
    end

    if vRP.CheckWeight then
        return vRP.CheckWeight(Passport, itemName, amount)
    end

    return true
end

function PetshopFramework.RefundCash(src, amount)
    local Passport = getPassport(src)
    amount = math.floor(tonumber(amount) or 0)

    if not Passport or amount <= 0 or not vRP.GenerateItem then
        return
    end

    vRP.GenerateItem(Passport, cashItem(), amount, true)
end
