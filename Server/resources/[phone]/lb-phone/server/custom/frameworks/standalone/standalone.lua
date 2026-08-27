if Config.Framework ~= "standalone" then
    return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP BRIDGE: vRP Creative/vRP Integration
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = {}
local vRPReady = false

CreateThread(function()
    local utils = LoadResourceFile("vrp", "lib/Utils.lua")
    if not utils then return end

    load(utils)()

    local Proxy = module("vrp", "lib/Proxy")
    if not Proxy then return end

    vRP = Proxy.getInterface("vRP")
    vRPReady = true
end)

local function WaitForVRP()
    while not vRPReady do
        Wait(100)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES (registrados ao iniciar)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    WaitForVRP()

    vRP.Prepare("lbphone/UserVehicles", "SELECT * FROM vehicles WHERE Passport = @Passport")
    vRP.Prepare("lbphone/GetVehicle", "SELECT * FROM vehicles WHERE Passport = @Passport AND Plate = @Plate LIMIT 1")
    vRP.Prepare("lbphone/GetVehicleByPlate", "SELECT * FROM vehicles WHERE Plate = @Plate LIMIT 1")
    vRP.Prepare("lbphone/OfflineBank", "SELECT Bank FROM characters WHERE id = @Passport")
    vRP.Prepare("lbphone/AddBankOffline", "UPDATE characters SET Bank = Bank + @Amount WHERE id = @Passport")
    vRP.Prepare("lbphone/IdentifierToPassport", "SELECT id FROM characters WHERE id = @Passport LIMIT 1")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS DE VALIDAÃ‡ÃƒO DE ITENS E UNIQUE PHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetInventoryItemName(item)
    if type(item) ~= "table" then
        return nil
    end
    return item.item or item.name or item.Item or item[1]
end

local function HasAnyPhoneItem(Passport)
    local baseItem = Config.Item.Name or "cellphone"
    if (vRP.ItemAmount(Passport, baseItem) or 0) > 0 then
        return true
    end

    local Inventory = vRP.Inventory(Passport)
    if type(Inventory) ~= "table" then
        return false
    end

    for _, item in pairs(Inventory) do
        local itemName = GetInventoryItemName(item)

        if itemName == "cellphone" then
            return true
        end

        if type(itemName) == "string" and itemName:match("^cellphone%-") then
            return true
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: Passport from identifier string "vrp:123"
-----------------------------------------------------------------------------------------------------------------------------------------
local function IdentifierToPassport(identifier)
    local value = tostring(identifier or "")
    local passport = value:match("^vrp:(%d+)$")
        or value:match("^pandora:(%d+)$")
        or value:match("^(%d+)$")

    return passport and tonumber(passport) or nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IS ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
function IsAdmin(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1
    end

    for _, group in ipairs(Config.VRPAdminGroups or { "Admin" }) do
        if vRP.HasPermission(Passport, group) then
            return true
        end
    end

    return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET IDENTIFIER -> vrp:<Passport>
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@return string | nil
function GetIdentifier(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return nil
    end

    return "vrp:" .. Passport
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SOURCE FROM IDENTIFIER
-----------------------------------------------------------------------------------------------------------------------------------------
---@param identifier string
---@return number?
function GetSourceFromIdentifier(identifier)
    WaitForVRP()

    local Passport = IdentifierToPassport(identifier)
    if not Passport then
        return nil
    end

    local src = vRP.Source(Passport)
    return src or nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HAS ITEM (VerificaÃ§Ã£o correta com Notify)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param itemName string
function HasItem(source, itemName)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return false
    end

    if itemName == "cellphone" or itemName == Config.Item.Name then
        local hasPhone = HasAnyPhoneItem(Passport)
        return hasPhone
    end

    local amount = vRP.ItemAmount(Passport, itemName)
    return amount and amount > 0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CHARACTER NAME
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@return string firstname
---@return string lastname
function GetCharacterName(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return GetPlayerName(source), ""
    end

    local Identity = vRP.Identity(Passport)
    if Identity then
        return Identity.Name or GetPlayerName(source), Identity.Lastname or ""
    end

    return GetPlayerName(source), ""
end



RegisterCallback("vrp:hasItem", function(source, itemName)
    return HasItem(source, itemName)
end)
