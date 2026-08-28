local function onStartSit(success, interactionId, targetEntity, animationData, extraData)
    if not success then
        return
    end

    HandleInteraction(interactionId, targetEntity, animationData, extraData)
end

NetworkService.RegisterNetEvent("startSit", onStartSit)

local function onStartExit(success, exitData)
    if not success then
        return
    end

    ExitFunc(exitData)
end

NetworkService.RegisterNetEvent("startExit", onStartExit)

local function onResetSit(success, interactionId, targetEntity, animationData, extraData)
    if not success then
        return
    end

    HandleInteraction(interactionId, targetEntity, animationData, extraData)
end

NetworkService.RegisterNetEvent("resetSit", onResetSit)

local function onHealPlayer(success, healAmount)
    if not success then
        return
    end

    local playerPed = PlayerPedId()
    local currentHealth = GetEntityHealth(playerPed)
    local archetypeName = GetEntityArchetypeName(playerPed)

    local isMaleFreemode = archetypeName == "mp_m_freemode_01"
    local isFemaleFreemode = archetypeName == "mp_f_freemode_01"

    if isMaleFreemode then
        if currentHealth <= 200 then
            SetEntityHealth(playerPed, currentHealth + healAmount)
        end
    elseif isFemaleFreemode and currentHealth <= 100 then
        SetEntityHealth(playerPed, currentHealth + healAmount)
    end

    dbg.debug(
        "Healing player since laying on bed to amount: from / %s | to / %s",
        healAmount,
        currentHealth + healAmount
    )
end

NetworkService.RegisterNetEvent("healPlayer", onHealPlayer)

local function onHeartbeat(eventName)
    if eventName == "PRISONER_LOADED" then
        if not Config.Chairs.Enable then
            return
        end

        HandleRaycastInterval("init")
    elseif eventName == "PRISONER_RELEASED" then
        HandleRaycastInterval("exit")
    end
end

NetworkService.EventListener("heartbeat", onHeartbeat)