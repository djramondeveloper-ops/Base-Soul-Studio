if Config.JailScript ~= "esx" then
    return
end

function JailPlayer(identifier, time, reason, officerSource)
    local minutes = math.floor(time / 60)
    local source = GetSourceFromIdentifier(identifier)

    if not source then
        return false
    end

    TriggerEvent("esx_jail:sendToJail", source, minutes)

    return true
end

function UnjailPlayer(identifier)
    local source = GetSourceFromIdentifier(identifier)

    return false
end

function GetRemainingPrisonSentence(identifier)
    local source = GetSourceFromIdentifier(identifier)

    return MySQL.scalar.await("SELECT jail_time FROM users WHERE identifier = ?", { identifier }) or 0
end
