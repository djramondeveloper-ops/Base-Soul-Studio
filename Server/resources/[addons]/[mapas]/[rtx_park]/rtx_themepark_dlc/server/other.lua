-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL / VRP INTEGRATION
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local ConsumeCooldown = {}

local function GetPassport(playersource)
    local passport = vRP.Passport(playersource)
    return passport and tonumber(passport) or nil
end

local function ParseAmount(value)
    local amount = math.floor(tonumber(value) or 0)
    return math.max(amount, 0)
end

local function HasIdentifierPermission(playersource, permissions)
    if type(permissions) ~= "table" then
        return false
    end

    local identifiers = {}
    for _, identifier in ipairs(GetPlayerIdentifiers(playersource)) do
        local prefix = identifier:match("^([^:]+):")
        if prefix then
            identifiers[prefix] = identifier
            if prefix == "xbl" then
                identifiers.xbox = identifier
            end
        end
    end

    for _, permission in ipairs(permissions) do
        if permission.permissiontype and permission.permisisondata then
            if identifiers[permission.permissiontype] == permission.permisisondata then
                return true
            end
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- OWNERSHIP DATABASE
-- Uses the exact table shipped with the resource, created automatically only when ownership is enabled.
-----------------------------------------------------------------------------------------------------------------------------------------
if Config.ThemeParkCanBeOwned then
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `owned_themepark` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(500) COLLATE utf8mb4_bin NOT NULL,
            `balance` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `identifier` (`identifier`(191))
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
    ]])
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function AddMoneyRTX(playersource, moneydata)
    local Passport = GetPassport(playersource)
    local Amount = ParseAmount(moneydata)
    if not Passport or Amount <= 0 then
        return false
    end

    return vRP.GenerateItem(Passport,"dollar",Amount,true) == true
end

function RemoveMoneyRTX(playersource, moneydata)
    local Passport = GetPassport(playersource)
    local Amount = ParseAmount(moneydata)
    if not Passport or Amount <= 0 then
        return false
    end

    return vRP.PaymentFull(Passport,Amount,false) == true
end

function GetMoneyRTX(playersource)
    local Passport = GetPassport(playersource)
    if not Passport then
        return 0
    end

    local Cash = tonumber(vRP.ItemAmount(Passport,"dollar")) or 0
    local Bank = tonumber(vRP.GetBank(Passport)) or 0

    -- PaymentFull succeeds when either cash OR bank can pay the full value.
    return math.max(Cash,Bank)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOOTING RANGE
-----------------------------------------------------------------------------------------------------------------------------------------
function GiveShootingRangeRewardToPlayer(playersource, prizeiddata)
    local PrizeId = tonumber(prizeiddata)
    local Prize = PrizeId and Config.ShootingRangePrizes[PrizeId]
    if not Prize then
        return false
    end

    if Prize.prizetype == "money" then
        local Amount = ParseAmount(Prize.prizedata)
        if Amount > 0 and AddMoneyRTX(playersource,Amount) then
            TriggerClientEvent("rtx_themepark:Notify",playersource,LanguageFile("prizerewardmoney",Amount))
            return true
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIFIER
-- Seoul ownership follows the character Passport, not an external framework citizen id.
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayerIdentifierRTX(playersource)
    local Passport = GetPassport(playersource)
    return Passport and tostring(Passport) or ""
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MANAGEMENT PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayerPermissionsManagment(playersource)
    if Config.ThemeParkOwnedSettings.acepermissionsforusemanagmentmenu.enable then
        if IsPlayerAceAllowed(playersource,Config.ThemeParkOwnedSettings.acepermissionsforusemanagmentmenu.permission) then
            return true
        end
    end

    if Config.ThemeParkOwnedSettings.jobpermissionsforusemanagmentmenu.enable then
        local Passport = GetPassport(playersource)
        local Group = Config.ThemeParkOwnedSettings.jobpermissionsforusemanagmentmenu.jobname
        if Passport and Group and vRP.HasGroup(Passport,Group) then
            return true
        end
    end

    if Config.ThemeParkOwnedSettings.identifierspermissionsforusemanagmentmenu == true then
        return HasIdentifierPermission(playersource,Config.ThemeParkOwnedSettings.permissionsviaidentifiers)
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTRACTION CONTROL PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayerPermissionsControlAttraction(playersource)
    if Config.ThemeParkControlMachineSettings.acepermissionsforusecontrolmenu.enable then
        if IsPlayerAceAllowed(playersource,Config.ThemeParkControlMachineSettings.acepermissionsforusecontrolmenu.permission) then
            return true
        end
    end

    if Config.ThemeParkControlMachineSettings.jobpermissionsforusecontrolmenu.enable then
        local Passport = GetPassport(playersource)
        local Group = Config.ThemeParkControlMachineSettings.jobpermissionsforusecontrolmenu.jobname
        if Passport and Group and vRP.HasGroup(Passport,Group) then
            return true
        end
    end

    if Config.ThemeParkControlMachineSettings.identifierspermissionsforcontrolmenu == true then
        return HasIdentifierPermission(playersource,Config.ThemeParkControlMachineSettings.permissionsviaidentifiers)
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FOOD / DRINK STATUS
-- Values mirror the existing Seoul inventory: hotdog/hamburger = 7 hunger; juices = 40 thirst.
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rtx_themepark:Seoul:Consume",function(itemtype)
    local source = source
    local Passport = GetPassport(source)
    if not Passport then
        return
    end

    local Now = os.time()
    if ConsumeCooldown[source] and ConsumeCooldown[source] > Now then
        return
    end
    ConsumeCooldown[source] = Now + 1

    if itemtype == "hotdog" or itemtype == "burger" then
        vRP.UpgradeHunger(Passport,7)
    elseif itemtype == "juice" then
        vRP.UpgradeThirst(Passport,40)
    end
end)

AddEventHandler("playerDropped",function()
    ConsumeCooldown[source] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME PARK PASS
-- The OX item can trigger the client event rtx_themepark:Seoul:UseThemeParkPass.
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rtx_themepark:Seoul:UseThemeParkPass",function()
    if not Config.ThemeParkPass then
        return
    end

    local source = source
    local Passport = GetPassport(source)
    if not Passport then
        return
    end

    if vRP.TakeItem(Passport,"themeparkpass",1,true) then
        TriggerClientEvent("rtx_themepark:Notify",source,LanguageFile("themeparkpassactivated",Config.ThemeParkPassTime))
        TriggerClientEvent("rtx_themepark:Global:ThemeParkPassActivate",source)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enablethemepark",function(source)
    if source == 0 then
        themeparkdisabled = not themeparkdisabled
        print(themeparkdisabled and Language[Config.Language]["themeparkblocked"] or Language[Config.Language]["themeparkallowed"])
        return
    end

    local Passport = GetPassport(source)
    if not Passport or not vRP.HasGroup(Passport,"Admin") then
        return
    end

    themeparkdisabled = not themeparkdisabled
    TriggerClientEvent("rtx_themepark:Notify",source,themeparkdisabled and Language[Config.Language]["themeparkblocked"] or Language[Config.Language]["themeparkallowed"])
end)
