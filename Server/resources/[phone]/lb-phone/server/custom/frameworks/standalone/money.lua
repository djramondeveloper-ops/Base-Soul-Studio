if Config.Framework ~= "standalone" then
    return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP BRIDGE: Money / Bank Integration
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
-- GET BALANCE (saldo bancário real)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@return integer
function GetBalance(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return 0
    end

    return vRP.GetBank(Passport) or 0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD MONEY (adicionar dinheiro ao banco)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param amount integer
---@return boolean success
function AddMoney(source, amount)
    WaitForVRP()

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return false
    end

    local Passport = vRP.Passport(source)
    if not Passport then
        return false
    end

    vRP.GiveBank(Passport, amount, true)
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD MONEY OFFLINE (para transferência a jogadores offline)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param identifier string
---@param amount number
---@return boolean success
function AddMoneyOffline(identifier, amount)
    WaitForVRP()

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return false
    end

    -- Extrair Passport do identifier "vrp:123"
    local Passport = tostring(identifier or ""):match("^vrp:(%d+)$")
    Passport = Passport and tonumber(Passport) or nil

    if not Passport then
        return false
    end

    -- Verificar se o jogador está online
    local onlineSource = vRP.Source(Passport)
    if onlineSource then
        -- Está online, usar a função normal
        vRP.GiveBank(Passport, amount, true)
        return true
    end

    -- Offline: usar query direta
    local result = vRP.Query("lbphone/IdentifierToPassport", { Passport = Passport })
    if not result or not result[1] then
        return false
    end

    vRP.Update("lbphone/AddBankOffline", { Passport = Passport, Amount = amount })
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE MONEY (remover dinheiro do banco)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param amount integer
---@return boolean success
function RemoveMoney(source, amount)
    WaitForVRP()

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return false
    end

    local Passport = vRP.Passport(source)
    if not Passport then
        return false
    end

    return vRP.PaymentBank(Passport, amount, true)
end
