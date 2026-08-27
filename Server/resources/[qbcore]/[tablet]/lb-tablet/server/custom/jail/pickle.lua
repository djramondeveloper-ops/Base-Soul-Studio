if Config.JailScript ~= "pickle" then
    return
end

function JailPlayer(identifier, time, reason, officerSource)
    local minutes = math.floor(time / 60)
    local source = GetSourceFromIdentifier(identifier)

    if not source then
        return false
    end

    exports.pickle_prisons:JailPlayer(source, minutes)

    return true
end

function UnjailPlayer(identifier)
    local source = GetSourceFromIdentifier(identifier)

    return false
end

function GetRemainingPrisonSentence(identifier)
    local source = GetSourceFromIdentifier(identifier)
    local sentence = MySQL.scalar.await("SELECT time, sentence_date FROM pickle_prisons WHERE identifier = ?", { identifier })

    if not sentence then
        return 0
    end

    local timeLeft = sentence.time - (os.time() - sentence.sentence_date)

    return math.max(0, timeLeft)
end
