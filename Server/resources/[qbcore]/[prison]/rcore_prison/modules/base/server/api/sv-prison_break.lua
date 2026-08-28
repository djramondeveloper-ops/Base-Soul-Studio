local Escape = Config.Escape.ThirdParty
local DebugEvents = {}


local function getPrisonBreakStorage()
    if not Object or not Object.getStorage then
        return nil
    end

    return Object.getStorage(STORAGE_PRISON_BREAK)
end

local function getPrisonBreakState(playerId)
    if not PrisonService then
        return nil, nil
    end

    local prisoner = PrisonService.getPlayer and PrisonService.getPlayer(playerId) or nil
    local jailbreak = prisoner and prisoner.jailbreak or nil
    return prisoner, jailbreak
end

function HandleAlarm(state)
    TriggerClientEvent('rcore_prison:client:setAlarm', -1, state == true)
    return true
end

function StartPrisonBreakAlarm(alarmState)
    if alarmState == nil then
        alarmState = true
    end

    return HandleAlarm(alarmState)
end

function SyncPrisonBreak(playerId, resetAlarm)
    playerId = tonumber(playerId)
    if not playerId then
        return false
    end

    local prisoner, jailbreak = getPrisonBreakState(playerId)
    local isActive = jailbreak and jailbreak.state == true

    if not prisoner or not isActive then
        TriggerClientEvent('rcore_prison:client:ResetPrisonBreak', playerId, resetAlarm == true)
        return false
    end

    local prisonBreakStorage = getPrisonBreakStorage()
    if prisonBreakStorage and prisonBreakStorage.RegisterSession then
        pcall(function()
            prisonBreakStorage.RegisterSession(jailbreak)
        end)
    end

    StartClient(playerId, 'startPrisonBreakProlog', true)
    if Config and Config.DispatchSettings and Config.DispatchSettings.InvokeWhenPlayerEscapePrison then
        HandleAlarm(true)
    end

    return true
end

function StartPrisonBreak(playerId)
    playerId = tonumber(playerId)
    if not playerId then
        return false
    end

    local prisoner = PrisonService and PrisonService.getPlayer and PrisonService.getPlayer(playerId) or nil
    if not prisoner then
        return false
    end

    local prisonBreakStorage = getPrisonBreakStorage()
    if prisonBreakStorage and prisonBreakStorage.RegisterSession then
        pcall(function()
            prisonBreakStorage.RegisterSession({
                state = true,
                source = playerId,
                owner = prisoner.owner,
                path = 'manual'
            })
        end)
    end

    if PrisonService and PrisonService.SetPrisonerEscapeState then
        pcall(function()
            PrisonService.SetPrisonerEscapeState(playerId, true, { path = 'manual', script = GetCurrentResourceName() })
        end)
    end

    HandleAlarm(true)
    StartClient(playerId, 'startPrisonBreakProlog', true)
    return true
end

function PrisonBreakReset(_, resetAlarm)
    local prisonBreakStorage = getPrisonBreakStorage()
    if prisonBreakStorage and prisonBreakStorage._prisonBreakSessions then
        prisonBreakStorage._prisonBreakSessions = {}
    end

    TriggerClientEvent('rcore_prison:client:ResetPrisonBreak', -1, resetAlarm == true)

    if resetAlarm then
        HandleAlarm(false)
    end

    return true
end


RegisterCommand('rcore_prison_prison_break_debug', function()
    if source ~= 0 then
        return
    end

    print("=== Prison Break Events Log ===")
    print("")

    if #DebugEvents == 0 then
        print("No events recorded yet.")
    else
        for i, event in ipairs(DebugEvents) do
            print(string.format("[%d] %s", i, event.timestamp))
            print(string.format("    Player: %s (ID: %s)", event.playerName or "Unknown", event.playerId))
            print(string.format("    Type: %s", event.label))
            print(string.format("    Action: %s", event.action))

            if event.chanceRoll then
                print(string.format("    Chance: %d / %d (%s)", event.chanceRoll, event.chanceRequired, event.chancePassed and "PASSED" or "FAILED"))
            end

            if event.delay then
                print(string.format("    Delay: %d seconds", event.delay))
                print(string.format("    DelayConfig: AwaitedStartDelay=%s, UseRandomRange=%s, StrictDelay=%s",
                    tostring(event.awaitedStartDelay),
                    tostring(event.useRandomRange),
                    tostring(event.strictDelay)
                ))
            end

            print("")
        end
    end

    print("=== End Events Log ===")
end, false)

RegisterCommand('rcore_prison_prison_break_debug_clear', function()
    if source ~= 0 then
        return
    end

    DebugEvents = {}
    print("[PrisonBreak:Debug] Events log cleared.")
end, false)

local function GetDelay(config)
    if not config or not config.AwaitedStartDelay then
        return 0
    end

    local delayConfig = config.AwaitedStartDelayConfig
    if not delayConfig then
        return 0
    end

    if delayConfig.UseRandomRange then
        return math.random(delayConfig.RandomMin or 10, delayConfig.RandomMax or 30)
    end

    return delayConfig.StrictDelay or 8
end

local function TriggerWithConfig(config, playerId, callback, label)
    local playerName = GetPlayerName(playerId)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    if not config then
        dbg.debug("[PrisonBreak:%s] Config is nil, skipping", label)
        table.insert(DebugEvents, {
            timestamp = timestamp,
            playerId = playerId,
            playerName = playerName,
            label = label,
            action = "SKIPPED - Config is nil"
        })
        return
    end

    if config.UseChance then
        local roll = math.random(1, 100)
        local chance = config.TriggerChance or 100
        local passed = roll <= chance
        dbg.debug("[PrisonBreak:%s] Chance roll: %d / %d", label, roll, chance)

        if not passed then
            dbg.debug("[PrisonBreak:%s] Chance failed, skipping", label)
            table.insert(DebugEvents, {
                timestamp = timestamp,
                playerId = playerId,
                playerName = playerName,
                label = label,
                action = "SKIPPED - Chance failed",
                chanceRoll = roll,
                chanceRequired = chance,
                chancePassed = false
            })
            return
        end
    end

    local delay = GetDelay(config)
    local awaitedStartDelay = config.AwaitedStartDelay or false
    local useRandomRange = config.AwaitedStartDelayConfig and config.AwaitedStartDelayConfig.UseRandomRange or false
    local strictDelay = config.AwaitedStartDelayConfig and config.AwaitedStartDelayConfig.StrictDelay or "N/A"

    dbg.debug("[PrisonBreak:%s] Delay calculated: %d seconds (AwaitedStartDelay: %s, UseRandomRange: %s, StrictDelay: %s)",
        label, delay, tostring(awaitedStartDelay), tostring(useRandomRange), tostring(strictDelay)
    )

    local eventData = {
        timestamp = timestamp,
        playerId = playerId,
        playerName = playerName,
        label = label,
        delay = delay,
        awaitedStartDelay = awaitedStartDelay,
        useRandomRange = useRandomRange,
        strictDelay = strictDelay
    }

    if config.UseChance then
        eventData.chanceRoll = math.random(1, 100)
        eventData.chanceRequired = config.TriggerChance or 100
        eventData.chancePassed = true
    end

    if delay > 0 then
        eventData.action = "TRIGGERED - With delay"
        table.insert(DebugEvents, eventData)

        dbg.debug("[PrisonBreak:%s] Triggering with %d second delay for player %s", label, delay, playerId)
        SetTimeout(delay * 1000, function()
            dbg.debug("[PrisonBreak:%s] Delay finished, invoking callback for player %s", label, playerId)
            table.insert(DebugEvents, {
                timestamp = os.date("%Y-%m-%d %H:%M:%S"),
                playerId = playerId,
                playerName = playerName,
                label = label,
                action = "INVOKED - After " .. delay .. "s delay"
            })
            callback(playerId)
        end)
    else
        eventData.action = "TRIGGERED - Immediate"
        table.insert(DebugEvents, eventData)

        dbg.debug("[PrisonBreak:%s] No delay, invoking callback immediately for player %s", label, playerId)
        callback(playerId)
    end
end

AddEventHandler('prompt_prison_escape:playerEscaped', function(source)
    if not Escape["prompt_prison_escape_dlc"] then
        return
    end

    local scriptName = Escape and Escape["prompt_prison_escape_dlc"].ScriptName or "prompt_prison_escape"
    local mapName = Escape and Escape["prompt_prison_escape_dlc"].MapName or "prompt_prison_escape_dlc"
    local pathWay = Escape and Escape["prompt_prison_escape_dlc"].PathWay or "TOILETS"

    if GetInvokingResource() ~= scriptName then
        dbg.critical("Prison break: Cannot set a state since %s is not running", scriptName)
        return 
    end

    if not isResourcePresentProvideless(mapName) then
        dbg.critical("Prison break: Cannot set a state since %s is not running!", mapName)
        return 
    end
    
    if not source then
        return
    end

    local prisoner = PrisonService.CheckForAnySentence(source)

    if not prisoner then
        return
    end

    local escapeConfig = Escape["prompt_prison_escape_dlc"]
    local alarmConfig = escapeConfig.Alarm
    local dispatchConfig = escapeConfig.Dispatch

    if alarmConfig and alarmConfig.Enable ~= false then
        TriggerWithConfig(alarmConfig, source, StartPrisonBreakAlarm, "Alarm")
    end

    if dispatchConfig and dispatchConfig.EnableOnEscape then
        TriggerWithConfig(dispatchConfig, source, Dispatch.Breakout, "Dispatch")
    end

    dbg.debug('Player (%s) has escaped from prison via %s, setting his escape state now. (%s)', GetPlayerName(source), pathWay, scriptName)

    table.insert(DebugEvents, {
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        playerId = source,
        playerName = GetPlayerName(source),
        label = "EscapeState",
        action = "SET - Escaped via " .. pathWay .. " (" .. scriptName .. ")"
    })

    PrisonService.SetPrisonerEscapeState(source, true, {
        path = pathWay,
        script = scriptName
    })
end)

NetworkService.EventListener('heartbeat', function(eventType, data)
    local prisonerModel = data.prisoner

    if not prisonerModel then
        return
    end

    local playerId = prisonerModel.source

    if not playerId then
        return
    end

    if not prisonerModel.escaped then        
        return
    end

    dbg.debug("Prisoner %s (%s) was released since he escaped, adding into logs he escaped!", prisonerModel.prisonerName, playerId)

    local dispatchConfig = Escape and Escape["prompt_prison_escape_dlc"] and Escape["prompt_prison_escape_dlc"].Dispatch

    -- Only trigger if EnableOnFullyReleased is true AND EnableOnEscape is false (to prevent double dispatch)
    if dispatchConfig and dispatchConfig.EnableOnFullyReleased and not dispatchConfig.EnableOnEscape then
        Dispatch.Breakout(playerId)
    end

    LogService.RegisterTransaction('RELEASE_PLAYER', _U('LOGS_ACTIONS.LOG_CITIZEN_CITIZEN_ESCAPED_THIRD_PARTY_PRISON_BREAK', prisonerModel.prisonerName), prisonerModel.owner)
end)

AddEventHandler('rcore_prison:server:playerUnloaded', function(playerId)
    local prisonerData = PrisonService.getPlayer(playerId)

    if not prisonerData then
        return
    end

    if prisonerData and prisonerData.jailbreak and prisonerData.jailbreak.state then
        dbg.debug("Player named %s was prisoner which escaped, removing jail state for him since he logout.", prisonerData.name)

        table.insert(DebugEvents, {
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            playerId = playerId,
            playerName = prisonerData.name,
            label = "PlayerUnloaded",
            action = "UNJAIL - Escaped prisoner logged out"
        })
        PrisonService.Unjail(playerId, false, true)
    end
end)