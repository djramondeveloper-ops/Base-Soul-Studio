local function resolvePlayerLoadEvent(eventName, environment)
    local playerLoadConfig = Config.PlayerLoad
    if not playerLoadConfig then
        return eventName
    end

    local environmentKey = environment == "server" and "Server" or "Client"
    local configuredEvents = playerLoadConfig[environmentKey]

    if configuredEvents and configuredEvents[eventName] then
        return configuredEvents[eventName]
    end

    return eventName
end

local playerLoadedEvents = {
    {
        event = resolvePlayerLoadEvent("esx:playerLoaded", "client"),
        framework = Framework.ESX,
        environment = "client"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Client:OnPlayerLoaded", "client"),
        framework = Framework.QBCore,
        environment = "client"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Client:OnPlayerLoaded", "client"),
        framework = Framework.QBOX,
        environment = "client"
    },
    {
        event = resolvePlayerLoadEvent("esx:playerLoaded", "server"),
        framework = Framework.ESX,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Server:OnPlayerUnload", "server"),
        framework = Framework.QBCore,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("ND:characterUnloaded", "server"),
        framework = Framework.NDCore,
        environment = "server"
    }
}

local playerUnloadedEvents = {
    {
        event = resolvePlayerLoadEvent("esx:playerLogout", "server"),
        framework = Framework.ESX,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("esx:playerDropped", "server"),
        framework = Framework.ESX,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Server:OnPlayerUnload", "server"),
        framework = Framework.QBCore,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Server:OnPlayerUnload", "server"),
        framework = Framework.QBOX,
        environment = "server"
    },
    {
        event = resolvePlayerLoadEvent("esx:onPlayerLogout", "client"),
        framework = Framework.ESX,
        environment = "client"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Client:OnPlayerUnload", "client"),
        framework = Framework.QBCore,
        environment = "client"
    },
    {
        event = resolvePlayerLoadEvent("QBCore:Client:OnPlayerUnload", "client"),
        framework = Framework.QBOX,
        environment = "client"
    }
}

local currentEnvironment = IsDuplicityVersion() and "server" or "client"

local function bindFrameworkEvents(eventList, callback)
    for _, eventData in pairs(eventList) do
        if eventData.environment == currentEnvironment and eventData.event then
            if isResourcePresentProvideless(eventData.framework) then
                dbg.playerLoad(
                    "BindFrameworkEvents: Registered event '%s' for framework '%s' on %s",
                    eventData.event,
                    eventData.framework,
                    currentEnvironment
                )

                callback(eventData)
            end
        end
    end
end

if IsDuplicityVersion() then
    local activePlayerSessions = {}

    RegisterCommand("rcore_prison_players", function(source)
        if source ~= 0 then
            return
        end

        local debugData = {
            third_party = {
                identity = FindTargetResource("identity") or "Unknown identity",
                multichar = FindTargetResource("multichar") or "Unknown multichar"
            },
            players = {}
        }

        local sessions = GetActivePlayerSessions()
        if sessions and next(sessions) then
            debugData.players = sessions
        end

        tprint(debugData)
    end, false)

    function RegisterPlayerSession(playerId, loadType)
        if not playerId then
            return false
        end

        local playerKey = tostring(playerId)
        if activePlayerSessions[playerKey] then
            return false
        end

        if type(Framework.getIdentifier) == nil then
            return false
        end

        local identifier = Framework.getIdentifier(playerId)
        if not identifier then
            return false
        end

        activePlayerSessions[playerKey] = {
            playerId = playerId,
            ooc_name = GetPlayerName(playerId) or "Unknown player name",
            ic_name = Framework.getCharacterName(playerId) or "Unknown character name",
            identifier = identifier,
            loadType = loadType
        }

        dbg.playerLoad(
            "Player %s marked as loaded (identifier: %s) with loadType: %s",
            playerId,
            identifier or "unknown",
            loadType or "unknown"
        )

        TriggerClientEvent("rcore_prison:client:setCharacterSpawned", playerId, playerId, identifier)
        TriggerEvent("rcore_prison:server:characterSpawned", playerId, identifier)

        return true
    end

    function UnregisterPlayerSession(playerId, reason)
        local session = activePlayerSessions[tostring(playerId)]
        if not session then
            return false
        end

        dbg.playerLoad(
            "Player %s marked as unloaded (identifier: %s) with reason: %s",
            playerId,
            session.identifier or "unknown",
            reason or "unknown"
        )

        activePlayerSessions[tostring(playerId)] = nil

        TriggerClientEvent("rcore_prison:client:playerLogout", playerId)
        TriggerEvent("rcore_prison:server:playerLogout", playerId)

        return true
    end

    function HasActiveSession(playerId)
        return activePlayerSessions[tostring(playerId)] ~= nil
    end

    function GetActivePlayerSessions()
        return activePlayerSessions
    end

    RegisterNetEvent("rcore_prison:server:RequestPlayerAsLoaded", function()
        RegisterPlayerSession(source, "thread - NetworkIsPlayerActive")
    end)

    AddEventHandler("playerDropped", function()
        if source then
            UnregisterPlayerSession(source, "playerDropped")
        end
    end)

    bindFrameworkEvents(playerLoadedEvents, function(eventData)
        AddEventHandler(eventData.event, function(playerId)
            local invokingResource = GetInvokingResource()
            if invokingResource ~= eventData.framework then
                return
            end

            RegisterPlayerSession(playerId, eventData.event or "frameworkEvent")
        end)
    end)

    bindFrameworkEvents(playerUnloadedEvents, function(eventData)
        AddEventHandler(eventData.event, function(playerId)
            local invokingResource = GetInvokingResource()
            if invokingResource ~= eventData.framework then
                return
            end

            UnregisterPlayerSession(playerId, eventData.event or "frameworkEvent")
        end)
    end)
else
    local isCharacterActive = false

    local function registerProtectedNetEvent(eventName, callback)
        RegisterNetEvent(eventName, function(...)
            if source == "" then
                return
            end

            callback(...)
        end)
    end

    function IsCharacterActive()
        return isCharacterActive
    end

    function WaitForLoadingScreenDismissed()
        if GetIsLoadingScreenActive() then
            repeat
                Wait(250)
            until not GetIsLoadingScreenActive()
        end

        DoScreenFadeIn(0)
    end

    function WaitForCharacterSelectDismissed()
        if not IsNuiFocused() then
            return
        end

        repeat
            Wait(250)
        until not IsNuiFocused()
    end

    function WaitForCharacterIdentifier()
        if type(GetCharacterIdentifier) ~= "function" then
            return
        end

        local identifier = GetCharacterIdentifier()
        if identifier then
            return
        end

        repeat
            Wait(250)
            identifier = GetCharacterIdentifier()
        until identifier
    end

    function SetCharacterActive()
        isCharacterActive = true
    end

    function OnCharacterSpawned(playerId, identifier)
        dbg.playerLoad("Character spawned into world.")
        TriggerEvent("rcore_prison:client:characterSpawned", playerId, identifier)
    end

    function SetCharacterInactive(reasonType, reasonName)
        if not isCharacterActive then
            return
        end

        repeat
            Wait(250)
        until false ~= IsNuiFocused()

        isCharacterActive = false

        dbg.playerLoad(
            "Character unloaded from world. Reason: %s - %s",
            reasonType or "unknown",
            reasonName
        )
    end

    function InitiatePlayerLoadRequest(reasonType, reasonName)
        if isCharacterActive then
            return
        end

        SetCharacterActive()

        if not NetworkIsPlayerActive(PlayerId()) then
            repeat
                Wait(250)
            until NetworkIsPlayerActive(PlayerId())
        end

        WaitForLoadingScreenDismissed()
        WaitForCharacterSelectDismissed()
        WaitForCharacterIdentifier()

        dbg.playerLoad(
            "Character detected. Reason: %s - %s",
            reasonType or "unknown",
            reasonName
        )

        TriggerServerEvent("rcore_prison:server:RequestPlayerAsLoaded")
    end

    registerProtectedNetEvent("rcore_prison:client:setCharacterSpawned", OnCharacterSpawned)

    registerProtectedNetEvent("rcore_prison:client:playerLogout", function()
        SetCharacterInactive("customEvent", "playerLogout")
    end)

    CreateThread(function()
        Wait(100)

        while true do
            if NetworkIsPlayerActive(PlayerId()) then
                InitiatePlayerLoadRequest("thread", "NetworkIsPlayerActive")
            end

            Wait(250)
        end
    end)

    bindFrameworkEvents(playerUnloadedEvents, function(eventData)
        registerProtectedNetEvent(eventData.event, function()
            SetCharacterInactive("frameworkEvent", eventData.event)
        end)
    end)

    bindFrameworkEvents(playerLoadedEvents, function(eventData)
        RegisterNetEvent(eventData.event, function()
            InitiatePlayerLoadRequest("frameworkEvent", eventData.event)
        end)
    end)
end