-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL MULTIFRAMEWORK SHARED
-- Camada QB/ESX/OX criada para adaptar vRP/Creative sem usar core Reborn ofuscado.
-----------------------------------------------------------------------------------------------------------------------------------------
QBConfig = QBConfig or {}
QBCore = QBCore or {}
QBShared = QBShared or {}
ESX = ESX or {}
Config = Config or {}

QBShared.Items = QBShared.Items or {}
QBShared.Vehicles = QBShared.Vehicles or {}
QBShared.Jobs = QBShared.Jobs or {
    unemployed = { label = "Civilian", defaultDuty = true, offDutyPay = false, grades = { ["0"] = { name = "Freelancer", payment = 10 } } }
}
QBShared.Gangs = QBShared.Gangs or { none = { label = "No Gang", grades = { ["0"] = { name = "none" } } } }
QBShared.StarterItems = QBShared.StarterItems or {}
QBShared.ForceJobDefaultDutyAtLogin = true
QBShared.Weapons = QBShared.Weapons or {}
QBShared.Locations = QBShared.Locations or {}

QBConfig.Player = QBConfig.Player or {}
QBConfig.Player.Bloodtypes = QBConfig.Player.Bloodtypes or { "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" }
QBConfig.Money = QBConfig.Money or {}
QBConfig.Money.MoneyTypes = QBConfig.Money.MoneyTypes or { cash = 0, bank = 0, crypto = 0 }
QBConfig.Money.DontAllowMinus = QBConfig.Money.DontAllowMinus or { "cash", "crypto" }
QBConfig.Server = QBConfig.Server or {}
QBConfig.Server.Whitelist = false
QBConfig.Server.Permissions = QBConfig.Server.Permissions or { "Admin", "Moderator", "Owner" }

Config.OxInventory = true
Config.PlayerFunctionOverride = "OxInventory"
Config.EnableDebug = false
Config.Locale = "pt-br"
Config.Multichar = true
Config.StartingAccountMoney = Config.StartingAccountMoney or { bank = 0, money = 0 }
Config.Accounts = Config.Accounts or { bank = { label = "Banco", round = true }, money = { label = "Dinheiro", round = true }, black_money = { label = "Sujo", round = true } }
Config.Jobs = Config.Jobs or { unemployed = { label = "Unemployed", grades = { ["0"] = { grade = 0, name = "unemployed", label = "Unemployed", salary = 10 } } } }
Config.Items = Config.Items or {}
Config.Weapons = Config.Weapons or {}

local function buildSharedFromVrpConfigs()
    if type(ItemList) == "function" then
        for name, data in pairs(ItemList()) do
            local label = data.Name or data.name or name
            local weight = tonumber(data.Weight or data.weight or 0) or 0
            QBShared.Items[name] = QBShared.Items[name] or {
                name = name,
                label = label,
                weight = math.floor(weight * 1000),
                type = "item",
                image = (data.Index or name) .. ".png",
                unique = false,
                useable = data.Type == "Consumível" or data.Execute ~= nil,
                shouldClose = true,
                combinable = nil,
                description = data.Description or ""
            }
            Config.Items[name] = Config.Items[name] or { label = label, weight = weight, rare = false, canRemove = true }
        end
        -- aliases comuns da Reborn/QB para o item de dinheiro da Origens
        if QBShared.Items["dollar"] and not QBShared.Items["dollars"] then
            QBShared.Items["dollars"] = QBShared.Items["dollar"]
            QBShared.Items["dollars"].name = "dollars"
        end
    end

    if type(VehicleList) == "function" then
        for model, data in pairs(VehicleList()) do
            QBShared.Vehicles[model] = QBShared.Vehicles[model] or {
                model = model,
                name = data.Name or model,
                brand = data.Class or "Seoul",
                price = data.Price or 0,
                category = data.Mode or data.Type or "vehicles",
                type = data.Type or "automobile",
                shop = data.Mode or "pdm"
            }
        end
    end
end

buildSharedFromVrpConfigs()

function QBShared.Round(value, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(value * mult + 0.5) / mult
end

function QBShared.Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function QBShared.SplitStr(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch('(.-)' .. delimiter) do
        result[#result + 1] = match
    end
    return result
end

function QBShared.RandomStr(length)
    local res = ""
    for i = 1, length do res = res .. string.char(math.random(97, 122)) end
    return res
end

function QBShared.RandomInt(length)
    local res = ""
    for i = 1, length do res = res .. tostring(math.random(0, 9)) end
    return res
end

function ESX.GetConfig()
    return Config
end

function ESX.Round(value, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(value * mult + 0.5) / mult
end
