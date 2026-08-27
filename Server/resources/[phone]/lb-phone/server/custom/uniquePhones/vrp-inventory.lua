if Config.Item.Inventory ~= "vrp" or not Config.Item.Unique or not Config.Item.Require then
    return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP UNIQUE PHONES: Server-Side
-- Sistema de telefone Ãºnico baseado em nome de item: cellphone-<phone_number>
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
-- HELPERS DE VALIDAÃ‡ÃƒO DE ITENS
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

local function HasExactPhoneNumber(Passport, phoneNumber)
    phoneNumber = tostring(phoneNumber or ""):gsub("%D", "")
    if phoneNumber == "" then
        return false
    end

    local expectedItem = "cellphone-" .. phoneNumber
    local Inventory = vRP.Inventory(Passport)
    if type(Inventory) ~= "table" then
        return false
    end

    for _, item in pairs(Inventory) do
        local itemName = GetInventoryItemName(item)
        if type(itemName) == "string" then
            if itemName == expectedItem then
                return true
            end

            local inlineNumber = itemName:match("^cellphone%-(%d+)$")
            if inlineNumber == phoneNumber then
                return true
            end

            local prefixedNumber = itemName:match("^cellphone%-(%d+)%-.+$")
            if prefixedNumber == phoneNumber then
                return true
            end
        end
    end

    return false
end

local function HasEmptyPhoneItem(Passport)
    local Inventory = vRP.Inventory(Passport)
    if type(Inventory) ~= "table" then
        return false
    end

    for _, item in pairs(Inventory) do
        local itemName = GetInventoryItemName(item)
        if itemName == "cellphone" then
            return true
        end
    end
    return false
end

local function FindFirstPhoneNumber(Passport)
    local Inventory = vRP.Inventory(Passport)
    if type(Inventory) ~= "table" then
        return nil
    end

    for _, item in pairs(Inventory) do
        local itemName = GetInventoryItemName(item)
        if type(itemName) == "string" then
            local prefix, number = itemName:match("^(cellphone)%-(.+)$")
            if prefix == "cellphone" and number then
                return number
            end
        end
    end
    return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HAS PHONE NUMBER: Verificar se o player tem um celular com nÃºmero especÃ­fico
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param phoneNumber string
---@return boolean
function HasPhoneNumber(source, phoneNumber)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return false
    end

    if phoneNumber and tostring(phoneNumber) ~= "" then
        if HasExactPhoneNumber(Passport, phoneNumber) then
            return true
        end
    end

    -- Fallback obrigatÃ³rio para primeiro uso:
    -- Se ainda nÃ£o existe aparelho unique, mas o jogador tem cellphone normal,
    -- permitir abrir para o lb-phone conseguir criar/associar o aparelho.
    if HasAnyPhoneItem(Passport) then
        return true
    end

    -- A notificacao e feita no client (com debounce) para evitar spam.
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SET PHONE NUMBER: Atribuir nÃºmero ao celular (transformar cellphone -> cellphone-<numero>)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param phoneNumber string
---@return boolean success
function SetPhoneNumber(source, phoneNumber)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport or not phoneNumber then
        return false
    end

    -- Se jÃ¡ possui exatamente o telefone com este nÃºmero, tudo certo
    if HasExactPhoneNumber(Passport, phoneNumber) then
        return true
    end

    -- Verifica se tem o item "cellphone" exatamente vazio
    if not HasEmptyPhoneItem(Passport) then
        return false
    end

    local targetItem = "cellphone-" .. tostring(phoneNumber)

    -- Tentar remover exatamente 1 "cellphone" vazio
    if vRP.RemoveItem(Passport, "cellphone", 1, false) then
        -- Dar o item Ãºnico "cellphone-<numero>"
        vRP.GiveItem(Passport, targetItem, 1, false)
        return true
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SET ITEM NAME: Nomear o celular (nÃ£o aplicÃ¡vel sem metadata)
-----------------------------------------------------------------------------------------------------------------------------------------
function SetItemName(source, phoneNumber, name)
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS para o client
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCallback("vrp:getFirstPhoneNumber", function(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return nil
    end

    return FindFirstPhoneNumber(Passport)
end)

RegisterCallback("vrp:hasPhoneNumber", function(source, number)
    return HasPhoneNumber(source, number)
end)

