if Config.JailScript ~= "JAIL_SCRIPT" then
    return
end

function JailPlayer(identifier, time, reason, officerSource)
    local minutes = math.floor(time / 60)
    local source = GetSourceFromIdentifier(identifier)

    return false
end

function UnjailPlayer(identifier)
    local source = GetSourceFromIdentifier(identifier)

    return false
end

function GetRemainingPrisonSentence(identifier)
    local source = GetSourceFromIdentifier(identifier)

    return 0
end
