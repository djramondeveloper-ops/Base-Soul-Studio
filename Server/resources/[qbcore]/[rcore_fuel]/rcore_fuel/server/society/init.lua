--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

-- server/society/init.lua
-- Society integration: routes society money operations through the detected framework.

Society = {}

local function NormalizeAmount(amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return nil end
    return amount
end

local function GetESXSocietyAccountName(jobName)
    local societyName = tostring(jobName or "")
    if societyName == "" then return nil end

    -- Current ESX society exposes the registered account name. Prefer it because
    -- custom societies are allowed to use an account name other than society_<job>.
    if GetResourceState("esx_society") == "started" then
        local ok, society = pcall(function()
            return exports.esx_society:GetSociety(societyName)
        end)
        if ok and type(society) == "table" and society.account then
            return tostring(society.account)
        end
    end

    -- Legacy/default ESX convention.
    if societyName:sub(1, 8) ~= "society_" then
        societyName = "society_" .. societyName
    end
    return societyName
end

-- esx_addonaccount uses a callback API. Wait for that callback before reporting success;
-- otherwise callers can grant stock/mission progress even when no account was found.
local function AwaitESXSharedAccount(jobName)
    if GetResourceState("esx_addonaccount") ~= "started" then return nil end

    local accountName = GetESXSocietyAccountName(jobName)
    if not accountName then return nil end

    local pending = promise:new()
    local settled = false

    local function settle(value)
        if settled then return end
        settled = true
        pending:resolve(value or false)
    end

    TriggerEvent("esx_addonaccount:getSharedAccount", accountName, function(account)
        settle(account)
    end)

    -- Fail closed if a broken addon-account resource never calls the callback.
    SetTimeout(2000, function()
        settle(false)
    end)

    local account = Citizen.Await(pending)
    if account == false then return nil end
    return account
end

--- Deposit money into the society/job account.
---@param jobName string  the job/society name
---@param amount  number
function Society.Deposit(jobName, amount)
    amount = NormalizeAmount(amount)
    if not jobName or not amount then return false end

    -- Qbox management
    if GetResourceState("qbx_management") == "started" then
        local ok, res = pcall(function()
            return exports.qbx_management:AddMoney(jobName, amount)
        end)
        if ok and res ~= false then return true end
    end

    -- Renewed Banking documents an explicit boolean success result. Fail closed on
    -- nil as well as false; otherwise a missing/broken account can be reported as a
    -- successful deposit merely because the export call itself did not throw.
    if GetResourceState("renewed-banking") == "started" then
        local ok, res = pcall(function()
            return exports['renewed-banking']:addAccountMoney(jobName, amount)
        end)
        if ok and res == true then return true end
    end

    -- qb-banking also documents a boolean result for AddMoney/RemoveMoney.
    if GetResourceState("qb-banking") == "started" then
        local ok, res = pcall(function()
            return exports['qb-banking']:AddMoney(jobName, amount, 'rcore_fuel')
        end)
        if ok and res == true then return true end
    end

    -- QBCore boss treasury (qb-management)
    if GetResourceState("qb-management") == "started" then
        local ok, res = pcall(function()
            return exports["qb-management"]:AddMoney(jobName, amount)
        end)
        if ok and res ~= false then return true end
    end

    -- ESX shared society account. Use the addon account directly and wait for the
    -- callback before returning so the caller gets a truthful success value.
    if GetResourceState("esx_addonaccount") == "started" then
        local account = AwaitESXSharedAccount(jobName)
        if not account or type(account.addMoney) ~= "function" then return false end

        local ok = pcall(function()
            account.addMoney(amount)
        end)
        return ok
    end

    print("[rcore_fuel] Society.Deposit: no compatible society resource found for job '" .. tostring(jobName) .. "'")
    return false
end

--- Withdraw money from the society/job account.
---@param jobName string
---@param amount  number
---@return boolean success
function Society.Withdraw(jobName, amount)
    amount = NormalizeAmount(amount)
    if not jobName or not amount then return false end

    -- Qbox management
    if GetResourceState("qbx_management") == "started" then
        local ok, res = pcall(function()
            return exports.qbx_management:RemoveMoney(jobName, amount)
        end)
        if ok and res ~= false then return true end
    end

    -- Renewed Banking documents an explicit boolean success result. Do not turn a
    -- nil/unknown response into authorization to grant stock or complete a mission.
    if GetResourceState("renewed-banking") == "started" then
        local ok, res = pcall(function()
            return exports['renewed-banking']:removeAccountMoney(jobName, amount)
        end)
        if ok and res == true then return true end
    end

    -- qb-banking documents RemoveMoney as boolean and accepts a transaction reason.
    if GetResourceState("qb-banking") == "started" then
        local ok, res = pcall(function()
            return exports['qb-banking']:RemoveMoney(jobName, amount, 'rcore_fuel')
        end)
        if ok and res == true then return true end
    end

    if GetResourceState("qb-management") == "started" then
        local ok, res = pcall(function()
            return exports["qb-management"]:RemoveMoney(jobName, amount)
        end)
        if ok and res ~= false then return true end
    end

    if GetResourceState("esx_addonaccount") == "started" then
        local account = AwaitESXSharedAccount(jobName)
        if not account or type(account.removeMoney) ~= "function" then return false end

        -- addonaccount's removeMoney does not itself provide a useful success value,
        -- so verify the balance before mutating it and only then report success.
        local balance = tonumber(account.money)
        if balance == nil or balance < amount then return false end

        local ok = pcall(function()
            account.removeMoney(amount)
        end)
        return ok
    end

    print("[rcore_fuel] Society.Withdraw: no compatible society resource found for job '" .. tostring(jobName) .. "'")
    return false
end
