if Config.Framework ~= "esx" then
    return
end

debugprint("Loading ESX")

local export, obj = pcall(function()
    return exports.es_extended:getSharedObject()
end)

if export then
    ESX = obj
else
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
end

debugprint("ESX loaded")

function GetIdentifier(source)
    return ESX.GetPlayerFromId(source)?.identifier
end

function GetSourceFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer then
        return xPlayer.source
    end
end

function GetCharacterName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstName = xPlayer.get and xPlayer.get("firstName")
    local lastName = xPlayer.get and xPlayer.get("lastName")

    if not firstName or not lastName then
        local row = MySQL.single.await("SELECT firstname, lastname FROM users WHERE identifier=?", { GetIdentifier(source) })

        firstName = row?.firstname or GetPlayerName(source)
        lastName = row?.lastname or ""
    end

    return firstName, lastName
end

function GetCharacterNameFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier and ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer then
        return xPlayer.getName()
    end

    return MySQL.scalar.await("SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE identifier = ?", { identifier }) or ""
end

function IsAdmin(source)
    return ESX.GetPlayerFromId(source)?.getGroup() == "superadmin" or IsPlayerAceAllowed(source, "command.lbtablet_admin") == 1
end

function GetVehicles(identifier)
    return MySQL.query.await("SELECT plate, vehicle, `type` FROM owned_vehicles WHERE owner = ?", { identifier })
end

AddEventHandler("esx:playerLogout", function(source)
    PlayerLoggedOut(source)
end)

