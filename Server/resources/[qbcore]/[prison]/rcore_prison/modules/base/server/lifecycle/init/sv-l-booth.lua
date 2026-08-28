local isMapLoaded = false

local addEventHandler = AddEventHandler
local registerLimitedEvent = EventLimiterService.RegisterNetEvent
local createThread = CreateThread

local function sendError(playerSource, message)
    return Framework.sendNotification(playerSource, message, "error")
end

local function getInteractionContext(playerSource, interactionId)
    local interactions = SH and SH.data and SH.data.interaction
    local interaction = interactions and interactions[interactionId]

    if not interaction then
        sendError(playerSource, "Zone is not defined.")
        return nil
    end

    local accessType = interaction.zone and interaction.zone.access or INTERACT_ACCESS_TYPES.PRISONER_ONLY
    local boothConfig = interaction.booth

    if not boothConfig then
        sendError(playerSource, "Booth is not defined.")
        return nil
    end

    return interaction, accessType, boothConfig
end

local function validatePrisonerAccess(playerSource, accessType)
    if accessType ~= INTERACT_ACCESS_TYPES.PRISONER_ONLY then
        return true
    end

    if PrisonService.CheckForAnySentence(playerSource) then
        return true
    end

    sendError(playerSource, "You do not have any active sentence.")
    return false
end

addEventHandler("rcore_prison:shared:internal:MapLoaded", function()
    isMapLoaded = true
end)

registerLimitedEvent("rcore_prison:server:requestBooth", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    local _, accessType, boothConfig = getInteractionContext(playerSource, interactionId)
    if not boothConfig then
        return
    end

    local booth = BoothService.GetBooth(boothConfig.number)
    if not booth then
        return sendError(playerSource, "Booth is disabled!")
    end

    if not validatePrisonerAccess(playerSource, accessType) then
        return
    end

    if BoothService.IsOcuppied(booth.number, playerSource) then
        return sendError(playerSource, "Booth is already in use.")
    end

    if Config.Phones == Phones.NONE then
        return
    end

    dbg.debug(
        "Booth with number %s is now active for player %s (%s)",
        booth.number,
        GetPlayerName(playerSource),
        playerSource
    )

    booth.playerId = playerSource
    StartClient(playerSource, "openBooth", interactionId)
end)

registerLimitedEvent("rcore_prison:server:requestBoothLeave", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    local _, accessType, boothConfig = getInteractionContext(playerSource, interactionId)
    if not boothConfig then
        return
    end

    local booth = BoothService.GetBooth(boothConfig.number)
    if not booth then
        return sendError(playerSource, "Booth is not defined.")
    end

    if not validatePrisonerAccess(playerSource, accessType) then
        return
    end

    if BoothService.IsOcuppied(booth.number, playerSource) then
        return sendError(playerSource, "Booth is already in use.")
    end

    if Config.Phones == Phones.NONE then
        return
    end

    dbg.debug(
        "Booth with number %s is now inactive for player %s (%s)",
        booth.number,
        GetPlayerName(playerSource),
        playerSource
    )

    BoothService.SendHeartbeat("BOOTH_LEAVE", function(success)
        if success then
            Framework.sendNotification(playerSource, _U("BOOTHS.CALL_ENDED"), "success")
        end
    end, booth.callData)

    booth.state = CALL_ENUMS.IDLE
    booth.playerId = nil
    booth.callData = nil
end)

registerLimitedEvent("rcore_prison:server:requestBoothCall", 0, 1, function(playerSource, isAllowed, interactionId, targetNumber)
    if not isAllowed then
        return
    end

    local _, accessType, boothConfig = getInteractionContext(playerSource, interactionId)
    if not boothConfig then
        return
    end

    local booth = BoothService.GetBooth(boothConfig.number)
    if not booth then
        return sendError(playerSource, "Booth is not defined.")
    end

    if not validatePrisonerAccess(playerSource, accessType) then
        return
    end

    BoothService.SendHeartbeat("BOOTH_START_CALL", function(success)
        if success then
            StartClient(playerSource, "startCall", targetNumber)
            Framework.sendNotification(playerSource, _U("BOOTHS.CALL_STARTED_FROM_BOOTH"), "success")
            return
        end

        booth.state = CALL_ENUMS.IDLE
        booth.playerId = nil
        booth.callData = nil

        StartClient(playerSource, "ResetCallState", targetNumber)
        Framework.sendNotification(playerSource, _U("BOOTHS.CALL_ENDED_FROM_BOOTH"), "error")
    end, {
        targetNumber = targetNumber,
        boothNumber = boothConfig.number,
        initiatorPlayerId = playerSource
    })
end)

registerLimitedEvent("rcore_prison:server:requestBoothEndCall", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    local _, accessType, boothConfig = getInteractionContext(playerSource, interactionId)
    if not boothConfig then
        return
    end

    local booth = BoothService.GetBooth(boothConfig.number)
    if not booth then
        return sendError(playerSource, "Booth is not defined.")
    end

    if not booth.playerId or not booth.callData then
        return sendError(playerSource, "Booth is not in use.")
    end

    if not validatePrisonerAccess(playerSource, accessType) then
        return
    end

    local targetPlayerId = booth.callData.targetPlayerId

    dbg.debug(
        "Booth with number %s is now inactive for player %s (%s) since user request end call!",
        booth.number,
        GetPlayerName(playerSource),
        playerSource
    )

    BoothService.SendHeartbeat("BOOTH_LEAVE", function(success)
        if not success then
            return
        end

        booth.state = CALL_ENUMS.IDLE
        booth.playerId = nil
        booth.callData = nil

        Framework.sendNotification(playerSource, _U("BOOTHS.LEAVE_CALL_ENDED"), "success")
    end, {
        boothNumber = boothConfig.number,
        targetPlayerId = targetPlayerId,
        initiatorPlayerId = playerSource,
        callId = booth.callData.callId
    })
end)

createThread(function()
    local attempts = 0

    while not isMapLoaded and attempts < 50 do
        Wait(250)
        attempts = attempts + 1
    end

    if not isMapLoaded then
        dbg.critical("Failed to load prison map in sv-l-booth.lua")
    end

    if not SH or not SH.data or not SH.data.interaction then
        return
    end

    local interactions = SH.data.interaction
    local usedBoothNumbers = {}
    local registeredBooths = {}
    local bridgeStatus = "OK"
    local bridgeMessage = "Booth module: %s"

    for interactionId = 1, #interactions do
        local interaction = interactions[interactionId]

        if interaction and interaction.type == INTERACT_TYPES.BOOTH and interaction.booth then
            local boothNumber = interaction.booth.number

            registeredBooths[interactionId] = {
                id = interactionId,
                coords = interaction.coords,
                number = boothNumber
            }

            if usedBoothNumbers[boothNumber] then
                bridgeStatus = "FOUND_DUPLICATE_DISABLING_BOOTHS_MODULE"
                dbg.critical("Booth number is already in use: %s at index: %s", boothNumber, interactionId)
            else
                usedBoothNumbers[boothNumber] = true
            end
        end
    end

    local presetPath = ("data/presets/%s.lua"):format(SH.preset)

    if bridgeStatus == "FOUND_DUPLICATE_DISABLING_BOOTHS_MODULE" then
        bridgeStatus = "ERROR"
        bridgeMessage = ([[%s - Path: %s 
 Please go to this path and adjust the booth number.]]):format(bridgeMessage, presetPath)
    end

    if Config.Phones == Phones.NONE then
        bridgeStatus = "ERROR"
        bridgeMessage = ("%s - Phone resource is not supported by rcore_prison."):format(bridgeMessage)
        return dbg.bridge(bridgeMessage, bridgeStatus, bridgeMessage)
    end

    dbg.bridge(bridgeMessage, bridgeStatus, bridgeMessage)

    if bridgeStatus == "ERROR" then
        if next(registeredBooths) then
            tprint(registeredBooths)
        end
        return
    end

    BoothService.Register(registeredBooths)
end)