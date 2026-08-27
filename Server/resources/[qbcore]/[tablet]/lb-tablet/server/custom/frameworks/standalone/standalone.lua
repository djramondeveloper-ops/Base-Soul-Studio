if Config.Framework ~= "standalone" then
    return
end

function GetIdentifier(source)
    return GetPlayerIdentifierByType(source, "license")
end

function GetSourceFromIdentifier(identifier)
    local players = GetPlayers()

    for i = 1, #players do
        if GetIdentifier(players[i]) == identifier then
            return players[i]
        end
    end
end

function GetCharacterName(source)
    local firstname = GetPlayerName(source)
    local lastname = tostring(source)

    return firstname, lastname
end

function GetCharacterNameFromIdentifier(identifier)
    return MySQL.scalar.await("SELECT CONCAT(firstname, ' ', lastname) FROM lbtablet_registration_characters WHERE character_id = ?", { identifier })
end

function IsAdmin(source)
    return IsPlayerAceAllowed(source, "command.lbtablet_admin") == 1
end

function GetVehicles(identifier)
    return MySQL.query.await("SELECT plate, model, color FROM lbtablet_registration_vehicles WHERE character_id = ?", { identifier })
end
