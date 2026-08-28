local cigarProductionCooldowns = {}

local function validateCigarProductionRequest(playerSource, interactionId)
    local interactions = SH and SH.data and SH.data.interaction
    local interaction = interactions and interactions[interactionId]

    if not interaction then
        return false
    end

    local accessType = interaction.zone and interaction.zone.access or INTERACT_ACCESS_TYPES.PRISONER_ONLY
    if accessType == INTERACT_ACCESS_TYPES.PRISONER_ONLY and not PrisonService.CheckForAnySentence(playerSource) then
        Framework.sendNotification(playerSource, _U("GENERAL.YOUT_ARE_NOT_PRISONER"), "error")
        return false
    end

    local storage = Object.getStorage(STORAGE_CIGAR_PRODUCTION)
    if not storage then
        return false
    end

    local rewardItem = Config.CigarProduction.RewardItem
    if not Inventory.DoesItemExist(rewardItem, playerSource) then
        Framework.sendNotification(
            playerSource,
            _U("CIGAR_PRODUCTION.REQUIRED_ITEM_NOT_FOUND", rewardItem),
            "error"
        )

        dbg.critical(
            "Cigar production: Cannot start since required item is not defined on your server for user %s (%s)",
            rewardItem,
            GetPlayerName(playerSource),
            playerSource
        )

        return false
    end

    return true
end

local function handleCigarProductionCooldown(playerSource)
    local cooldownMinutes = Config.CigarProduction.RewardCooldown

    if cooldownMinutes <= 0 then
        dbg.debug(
            "No cooldown: Cigar production: Cooldown ended for player named: %s (%s)",
            GetPlayerName(playerSource),
            playerSource
        )

        cigarProductionCooldowns[playerSource] = nil
        return
    end

    dbg.debug(
        "Cooldown: Cigar production: Cooldown started for player named: %s (%s)",
        GetPlayerName(playerSource),
        playerSource
    )

    SetTimeout(cooldownMinutes * 60 * 1000, function()
        dbg.debug(
            "Cooldown: Cigar production: Cooldown ended for player named: %s (%s)",
            GetPlayerName(playerSource),
            playerSource
        )

        cigarProductionCooldowns[playerSource] = nil
    end)
end

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestCigarProduction", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    if not validateCigarProductionRequest(playerSource, interactionId) then
        return
    end

    if cigarProductionCooldowns[playerSource] then
        Framework.sendNotification(playerSource, _U("CIGAR_PRODUCTION.COOLDOWN"), "error")
        return
    end

    cigarProductionCooldowns[playerSource] = true
    StartClient(playerSource, "startCigarProduction", interactionId)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestCigarProductionFailed", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    if not validateCigarProductionRequest(playerSource, interactionId) then
        return
    end

    if not cigarProductionCooldowns[playerSource] then
        return
    end

    handleCigarProductionCooldown(playerSource)
end)

EventLimiterService.RegisterNetEvent("rcore_prison:server:requestCigarProductionReward", 0, 1, function(playerSource, isAllowed, interactionId)
    if not isAllowed then
        return
    end

    if not validateCigarProductionRequest(playerSource, interactionId) then
        return
    end

    dbg.debug(
        "Cigar production: Requesting reward for player named: %s (%s)",
        GetPlayerName(playerSource),
        playerSource
    )

    if not cigarProductionCooldowns[playerSource] then
        return
    end

    Framework.sendNotification(playerSource, _U("CIGAR_PRODUCTION.YOU_RECEIVED_REWARD"), "success")

    local rewardAmount = 1
    local rewardMin = Config.CigarProduction.RewardMin
    local rewardMax = Config.CigarProduction.RewardMax

    if rewardMin and rewardMax then
        rewardAmount = math.random(rewardMin, rewardMax)
    end

    Inventory.addItem(playerSource, Config.CigarProduction.RewardItem, rewardAmount)
    handleCigarProductionCooldown(playerSource)
end)