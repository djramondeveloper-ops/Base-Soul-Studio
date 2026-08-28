local globalStateUpdateTimeout = nil
local globalStateUpdateDelay = 500

local function buildPrisonYardCoords()
    if not SH or not SH.data or not SH.data.prisonYard then
        return nil
    end

    local prisonYard = SH.data.prisonYard
    return vec3(prisonYard.x, prisonYard.y, prisonYard.z)
end

function UpdateGlobalStateDebounced()
    if globalStateUpdateTimeout then
        return
    end

    globalStateUpdateTimeout = SetTimeout(globalStateUpdateDelay, function()
        GlobalState.rcore_prison_servers_players = PlayerLoadedPool
        globalStateUpdateTimeout = nil
    end)
end

AddEventHandler("rcore_prison:server:playerLoaded", function(playerSource)
    ChatService.RegisterAllSuggestions(playerSource)

    if Config.GlobalState and Config.GlobalState.ServerPlayersUse then
        GlobalState.rcore_prison_servers_players = PlayerLoadedPool
    end

    local identifier = Framework.getIdentifier and Framework.getIdentifier(playerSource) or nil

    if PrisonService.CheckForAnySentence(playerSource) then
        dbg.debug(
            "Player load: Has sentence player %s with serverId %s with identifier: %s",
            GetPlayerName(playerSource),
            playerSource,
            identifier
        )

        PrisonService.LoadPrisoner(playerSource)
    else
        dbg.debug(
            "Player load: Failed to find any sentence for player %s with serverId %s with identifier: %s",
            GetPlayerName(playerSource),
            playerSource,
            identifier
        )

        if Config.Debug then
            local prisoners = PrisonService.GetAllPrisoners(false)
            if prisoners and next(prisoners) then
                tprint(prisoners)
            end
        end
    end

    if COMSService.CheckForAnySentence(playerSource) then
        SetTimeout(1000, function()
            COMSService.LoadPeroll(playerSource)
        end)
    end

    PrisonAccountService.LoadAccount(playerSource)
    SyncPrisonBreak(playerSource, false)
end)

NetworkService.EventListener("heartbeat", function(eventName, eventData)
    if eventName ~= HEARTBEAT_EVENTS.PRISONER_NEW then
        return
    end

    if not eventData or not next(eventData) or not eventData.prisoner then
        return
    end

    local prisoner = eventData.prisoner

    if Config.Accounts.Enable then
        PrisonAccountService.LoadAccount(prisoner.source)
    end

    local playerPed = GetPlayerPed(prisoner.source)
    local playerCoords = GetEntityCoords(playerPed)
    local prisonYardCoords = buildPrisonYardCoords()

    if not prisonYardCoords then
        return
    end

    local distanceFromYard = #(prisonYardCoords - playerCoords)
    if distanceFromYard >= 100 then
        StartClient(prisoner.source, "teleportUser", prisonYardCoords)

        dbg.debug(
            "Prisoner: Teleporting citizen %s (%s) to prison yard, spawned outside of Prison!",
            GetPlayerName(prisoner.source),
            prisoner.source
        )
    end
end)

AddEventHandler("rcore_prison:server:playerUnloaded", function(playerSource)
    local success, err = pcall(function()
        dbg.debug(
            "UNLOAD-PLAYER: Player with ID (%s) named %s saving his time, unloading.",
            playerSource,
            GetPlayerName(playerSource)
        )

        JobService.isPlayerInJob(playerSource)
        PrisonService.SaveUser(playerSource)
        COMSService.SaveUser(playerSource)
        StopAlarmServer(playerSource)
        RemoveNearPlayers(playerSource)

        if PlayerLoadedPool[playerSource] then
            PlayerLoadedPool[playerSource] = nil
        end

        local flowKey = tostring(playerSource)
        if RegisterNetworkFlow[flowKey] then
            RegisterNetworkFlow[flowKey] = nil
        end

        if Config.GlobalState and Config.GlobalState.ServerPlayersUse then
            UpdateGlobalStateDebounced()
        end
    end)

    if not success then
        dbg.critical("Error in playerUnloaded handler for player %s: %s", playerSource, err)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, playerSource in pairs(GetPlayers()) do
        if playerSource then
            PrisonService.SaveUser(playerSource)
        end
    end
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(restartData)
    if restartData.secondsRemaining ~= 60 then
        return
    end

    CreateThread(function()
        Wait(45000)

        for _, playerSource in pairs(GetPlayers()) do
            if playerSource then
                PrisonService.SaveUser(playerSource)
            end
        end

        PrisonAccountService.saveAllAccounts()
    end)
end)

callback.register("rcore_prison:server:getAllPrisoners", function(playerSource, _)
    if not Framework.canPerformJobCommand(playerSource) then
        return {}
    end

    local allPrisoners = PrisonService.GetAllPrisoners(false)
    local prisonerCount = table.size(allPrisoners)
    local prisoners = {}

    for _, prisonerData in pairs(allPrisoners) do
        table.insert(prisoners, prisonerData)
    end

    return {
        hasMore = prisonerCount == 4,
        prisoners = prisoners
    }
end)

CreateThread(function()
    if not Config.Escape.DisableBugEscape then
        return
    end

    while true do
        Wait(0)

        local prisoners = PrisonService.GetAllPrisoners(true)
        if next(prisoners) then
            for _, prisonerData in pairs(prisoners) do
                if prisonerData.source then
                    PrisonService.HandlePrisonerLocation(prisonerData.source)
                end
            end
        end

        Wait(Config.Escape.BugEscapeCycleTime * 60 * 1000)
    end
end)
