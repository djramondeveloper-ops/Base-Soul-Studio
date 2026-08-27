if Config.Framework ~= "vrp" then return end

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local function passport(value)
    return tonumber(value) or 0
end

function GetIdentifier(source)
    local id = vRP.Passport(source)
    return id and tostring(id) or nil
end

function GetSourceFromIdentifier(identifier)
    return vRP.Source(passport(identifier))
end

function GetCharacterName(source)
    local id = vRP.Passport(source)
    local identity = id and vRP.Identity(id)
    return identity and identity.Name or GetPlayerName(source) or "Indivíduo", identity and identity.Lastname or ""
end

function GetCharacterNameFromIdentifier(identifier)
    local identity = vRP.Identity(passport(identifier))
    return identity and (identity.Name .. " " .. identity.Lastname) or nil
end

function GetPhoneNumberFromIdentifier(identifier)
    local id = passport(identifier)
    if id <= 0 then return "" end

    local currentIdentifier = "vrp:" .. id
    local legacyIdentifier = "pandora:" .. id
    local bareIdentifier = tostring(id)

    return MySQL.scalar.await([[
        SELECT phone_number
        FROM phone_phones
        WHERE owner_id IN (?, ?, ?) OR id IN (?, ?, ?)
        ORDER BY
            CASE WHEN owner_id = ? OR id = ? THEN 0 ELSE 1 END,
            last_seen DESC
        LIMIT 1
    ]], {
        currentIdentifier, legacyIdentifier, bareIdentifier,
        currentIdentifier, legacyIdentifier, bareIdentifier,
        currentIdentifier, currentIdentifier
    }) or ""
end

function IsAdmin(source)
    local id = vRP.Passport(source)
    return id and vRP.HasPermission(id, Config.VRP.AdminPermission, nil, true) ~= false or false
end

function GetVehicles(identifier)
    return MySQL.query.await([[SELECT Plate AS plate, Vehicle AS model, '' AS color FROM vehicles WHERE Passport = ?]], { passport(identifier) }) or {}
end

RegisterCallback("vrp:getPlayerContext", function(source)
    local job = GetJob(source)
    return {
        identifier = GetIdentifier(source),
        job = job,
        duty = IsOnDuty(source),
        hasItem = HasItem(source, Config.Item.Name),
        company = GetCompanyDataServer and GetCompanyDataServer(source) or nil
    }
end)

AddEventHandler("Connect", function(Passport, source)
    Wait(1000)
    TriggerClientEvent("lb-tablet:vrpLoaded", source)
    TriggerEvent("lb-tablet:jobUpdated", source, GetJob(source).name, IsOnDuty(source))
end)

AddEventHandler("Disconnect", function(Passport, source)
    PlayerLoggedOut(source)
end)

-- Client mirrors Seoul's service:Client event here. Re-read authoritative vRP state
-- before notifying tablet server subsystems (units, duty blips, Police/EMS state).
RegisterNetEvent("lb-tablet:vrpServiceChanged", function()
    local source = source
    local id = vRP.Passport(source)
    if not id then return end

    local job = GetJob(source)
    if not job or not (Config.VRP.Jobs or {})[job.name] then return end

    TriggerEvent("lb-tablet:jobUpdated", source, job.name, IsOnDuty(source))
end)
