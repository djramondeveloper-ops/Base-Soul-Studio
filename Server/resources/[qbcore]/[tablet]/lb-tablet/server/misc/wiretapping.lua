if not (Config.LBPhone and Config.Police and Config.Police.Wiretapping) then
    return
end

local minimumCallDurationMs = math.floor((Config.Police.Wiretapping.MinimumCallDuration or 0) * 1000)

local wiretappedNumbers = {}
local activeWiretapCallsByNumber = {}
local listenersByCallId = {}
local listeningCallBySource = {}

MySQL.ready(function()
    while not DatabaseCheckerFinished do
        Wait(500)
    end

    local rows = MySQL.query.await("SELECT phone_number FROM lbtablet_police_wiretaps")

    for i = 1, #rows do
        wiretappedNumbers[rows[i].phone_number] = true
    end
end)

local function arrayContains(list, value)
    for i = 1, #list do
        if list[i] == value then
            return true
        end
    end

    return false
end

local function getCallSource(number)
    return exports["lb-phone"]:GetSourceFromNumber(number)
end

local function getCallForNumber(number)
    local source = getCallSource(number)
    if not source then
        debugprint("Source not found for phone number:", number)
        return nil, nil, nil
    end

    local inCall, callId = exports["lb-phone"]:IsInCall(source)
    if not inCall or not callId then
        debugprint("Phone number is not in a call:", number)
        return source, nil, nil
    end

    local call = exports["lb-phone"]:GetCall(callId)
    if not call then
        debugprint("Call not found for phone number:", number, "source:", source)
        return source, callId, nil
    end

    return source, callId, call
end

local function getWiretapOtherParty(call, number)
    if call.caller and call.caller.number == number then
        return (call.callee and call.callee.number) or call.company
    end

    if call.callee and call.callee.number == number then
        return call.caller and call.caller.number or nil
    end

    return nil
end

local function setWiretapInCallState(call, number, inCall)
    local payload = {
        number = number,
        inCall = inCall
    }

    if inCall then
        payload.inCallWith = getWiretapOtherParty(call, number)
        payload.duration = os.time() - call.started
    end

    TriggerClientEvent("tablet:police:setInCall", -1, payload)
end

local function markWiretapCall(number, callId, call)
    if not number or not wiretappedNumbers[number] then
        return
    end

    activeWiretapCallsByNumber[number] = callId
    listenersByCallId[callId] = listenersByCallId[callId] or {}

    setWiretapInCallState(call, number, true)
end

local function isAnyOtherWiretapUsingCall(callId, excludedNumber)
    for phoneNumber, activeCallId in pairs(activeWiretapCallsByNumber) do
        if phoneNumber ~= excludedNumber and activeCallId == callId and wiretappedNumbers[phoneNumber] then
            return true
        end
    end

    return false
end

local function waitForMinimumDuration(call)
    local elapsedMs = math.floor((os.time() - call.started) * 1000)
    local remainingMs = math.max(minimumCallDurationMs - elapsedMs, 0)

    if remainingMs > 0 then
        Wait(remainingMs)
    end
end

local function monitorExistingCall(number)
    local _, callId, call = getCallForNumber(number)
    if not callId or not call then
        return
    end

    waitForMinimumDuration(call)

    call = exports["lb-phone"]:GetCall(callId)
    if not call then
        debugprint("Call not found after waiting for duration:", callId)
        return
    end

    if not wiretappedNumbers[number] then
        return
    end

    local isCaller = call.caller and call.caller.number == number
    local isCallee = call.callee and call.callee.number == number

    if not isCaller and not isCallee then
        return
    end

    markWiretapCall(number, callId, call)
end

function AddWiretap(number)
    if wiretappedNumbers[number] then
        debugprint("Phone number is already wiretapped:", number)
        return
    end

    wiretappedNumbers[number] = true

    MySQL.scalar("SELECT `name` FROM phone_phones WHERE phone_number = ?", { number }, function(phoneName)
        TriggerClientEvent("tablet:police:createWiretap", -1, {
            phoneNumber = number,
            phoneName = phoneName
        })

        Citizen.CreateThreadNow(function()
            monitorExistingCall(number)
        end)
    end)
end

function RemoveWiretap(number)
    if not wiretappedNumbers[number] then
        return
    end

    wiretappedNumbers[number] = nil

    TriggerClientEvent("tablet:police:removeWiretap", -1, number)

    local callId = activeWiretapCallsByNumber[number]
    activeWiretapCallsByNumber[number] = nil

    if not callId then
        return
    end

    if isAnyOtherWiretapUsingCall(callId, number) then
        return
    end

    local listeners = listenersByCallId[callId]
    if not listeners then
        return
    end

    for i = #listeners, 1, -1 do
        StopListeningToWiretappedCall(listeners[i])
    end

    listenersByCallId[callId] = nil
end

function IsPhoneNumberWiretapped(number)
    return wiretappedNumbers[number] or false
end

function GetWiretappedPhoneNumberCall(number)
    return activeWiretapCallsByNumber[number]
end

function ListenToWiretappedCall(source, number)
    local callId = activeWiretapCallsByNumber[number]
    if not callId then
        debugprint("No ongoing call found for phone number:", number)
        return false
    end

    local listeners = listenersByCallId[callId]
    if not listeners then
        listeners = {}
        listenersByCallId[callId] = listeners
    end

    if listeningCallBySource[source] == callId or arrayContains(listeners, source) then
        debugprint("Source is already listening to the call:", source)
        return false
    end

    StopListeningToWiretappedCall(source)

    local call = exports["lb-phone"]:GetCall(callId)
    if not call then
        debugprint("Call not found for call ID:", callId)
        return false
    end

    listeners[#listeners + 1] = source
    listeningCallBySource[source] = callId

    if call.caller and call.caller.source then
        TriggerClientEvent("phone:phone:addVoiceTarget", source, call.caller.source, true, true)
        TriggerClientEvent("phone:phone:addVoiceTarget", call.caller.source, source, false, true)
    end

    if call.callee and call.callee.source then
        TriggerClientEvent("phone:phone:addVoiceTarget", source, call.callee.source, true, true)
        TriggerClientEvent("phone:phone:addVoiceTarget", call.callee.source, source, false, true)
    end

    return true
end

function StopListeningToWiretappedCall(source, call)
    local callId = listeningCallBySource[source]
    if not callId then
        return
    end

    listeningCallBySource[source] = nil

    local listeners = listenersByCallId[callId]
    if listeners then
        for i = #listeners, 1, -1 do
            if listeners[i] == source then
                table.remove(listeners, i)
                break
            end
        end
    end

    if not call then
        call = exports["lb-phone"]:GetCall(callId)
        if not call then
            debugprint("Call not found:", callId)

            if listeners and #listeners == 0 and not isAnyOtherWiretapUsingCall(callId) then
                listenersByCallId[callId] = nil
            end

            return
        end
    end

    if call.caller and call.caller.source then
        TriggerClientEvent("phone:phone:removeVoiceTarget", source, call.caller.source, true, true)
        TriggerClientEvent("phone:phone:removeVoiceTarget", call.caller.source, source, false, true)
    end

    if call.callee and call.callee.source then
        TriggerClientEvent("phone:phone:removeVoiceTarget", source, call.callee.source, true, true)
        TriggerClientEvent("phone:phone:removeVoiceTarget", call.callee.source, source, false, true)
    end

    if listeners and #listeners == 0 and not isAnyOtherWiretapUsingCall(callId) then
        listenersByCallId[callId] = nil
    end
end

local function notifyWiretapSubscribers(number)
    local tabletIds = {}
    local rows = MySQL.query.await(
        "SELECT tablet_id FROM lbtablet_police_wiretaps_subscribers WHERE phone_number = ?",
        { number }
    )

    for i = 1, #rows do
        tabletIds[i] = rows[i].tablet_id
    end

    if #tabletIds == 0 then
        return
    end

    NotifyTablets(tabletIds, {
        app = "Police",
        title = L("BACKEND.POLICE.WIRETAP_NOTIFICATION.TITLE"),
        content = L("BACKEND.POLICE.WIRETAP_NOTIFICATION.CONTENT", {
            number = exports["lb-phone"]:FormatNumber(number)
        })
    })
end

AddEventHandler("lb-phone:callAnswered", function(call)
    local callerNumber = call.caller and call.caller.number
    local calleeNumber = call.callee and call.callee.number

    local callerWiretapped = callerNumber and wiretappedNumbers[callerNumber]
    local calleeWiretapped = calleeNumber and wiretappedNumbers[calleeNumber]

    if not callerWiretapped and not calleeWiretapped then
        debugprint("Call is not wiretapped:", callerNumber, calleeNumber)
        return
    end

    Wait(minimumCallDurationMs)

    local callId = call.callId
    call = exports["lb-phone"]:GetCall(callId)
    if not call then
        debugprint("Call not found after waiting for duration:", callId)
        return
    end

    listenersByCallId[callId] = listenersByCallId[callId] or {}

    if callerNumber and wiretappedNumbers[callerNumber] then
        notifyWiretapSubscribers(callerNumber)
        markWiretapCall(callerNumber, callId, call)
    end

    if calleeNumber and wiretappedNumbers[calleeNumber] then
        notifyWiretapSubscribers(calleeNumber)
        markWiretapCall(calleeNumber, callId, call)
    end
end)

AddEventHandler("lb-phone:callEnded", function(call)
    local callId = call.callId

    local callerNumber = call.caller and call.caller.number
    if callerNumber and activeWiretapCallsByNumber[callerNumber] == callId then
        activeWiretapCallsByNumber[callerNumber] = nil
        setWiretapInCallState(call, callerNumber, false)
    end

    local calleeNumber = call.callee and call.callee.number
    if calleeNumber and activeWiretapCallsByNumber[calleeNumber] == callId then
        activeWiretapCallsByNumber[calleeNumber] = nil
        setWiretapInCallState(call, calleeNumber, false)
    end

    local listeners = listenersByCallId[callId]
    if not listeners then
        return
    end

    for i = #listeners, 1, -1 do
        StopListeningToWiretappedCall(listeners[i], call)
    end

    listenersByCallId[callId] = nil
end)

OnPlayerDisconnect(function(source)
    StopListeningToWiretappedCall(source)
end)

if not Config.DisableWiretapWarning then
    SetTimeout(3000, function()
        local voiceSystem = GetPhoneConfig().Voice.System

        if voiceSystem == "pma" or voiceSystem == "mumble" then
            return
        end

        while true do
            infoprint("warning", "Your phone's voice system is set to '" .. (voiceSystem or "nil") .. "', which does not support wiretapping by default.")
            infoprint("warning", "You can implement wiretapping support for your voice system by implementing the 'phone:phone:addVoiceTarget' and 'phone:phone:removeVoiceTarget' events in lb-phone/client/custom/functions/voice.lua.")
            infoprint("warning", "To disable this warning, set Config.DisableWiretapWarning to true, or disable Config.Police.Wiretapping.")
            Wait(5000)
        end
    end)
end