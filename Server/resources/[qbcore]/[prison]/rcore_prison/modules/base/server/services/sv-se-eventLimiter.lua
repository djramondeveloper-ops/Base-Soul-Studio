EventLimiterService = {}

local eventCounters = {}
local eventResetTimes = {}

local function getNetworkFlowBucket(source)
    local sourceKey = tostring(source)

    RegisterNetworkFlow[sourceKey] = RegisterNetworkFlow[sourceKey] or {
        session = {}
    }

    return RegisterNetworkFlow[sourceKey]
end

local function recordNetworkFlow(source, eventName)
    local bucket = getNetworkFlowBucket(source)

    table.insert(bucket.session, {
        player_name = GetPlayerName(source),
        player_id = source,
        eventName = eventName,
        time = os.time()
    })

    bucket[eventName] = true
end

local function initVariables(data, forceReset)
    local source = data.source
    local eventName = data.eventName

    if not eventCounters[source] or forceReset then
        eventCounters[source] = {}
        eventResetTimes[source] = {}
    end

    if eventCounters[source][eventName] == nil or forceReset then
        eventCounters[source][eventName] = 0
        eventResetTimes[source][eventName] = GetGameTimer() + data.inTimeSpan
    end
end

function EventLimiterService.RegisterNetEvent(eventName, inTimeSpan, limit, callback)
    RegisterNetEvent(eventName, function(...)
        if source == nil or source == 0 then
            return
        end

        local limiterData = {
            eventName = eventName,
            limit = limit or 1,
            inTimeSpan = inTimeSpan or 1000,
            source = source
        }

        initVariables(limiterData)

        local now = GetGameTimer()
        if eventResetTimes[source][eventName] <= now then
            initVariables(limiterData, true)
        end

        eventCounters[source][eventName] = eventCounters[source][eventName] + 1
        local isAllowed = eventCounters[source][eventName] <= limiterData.limit

        recordNetworkFlow(source, eventName)
        initVariables(limiterData, false)

        if isAllowed then
            dbg.debugNetwork(
                "Event %s has been triggered by user with playerId %s named: %s",
                eventName,
                source,
                GetPlayerName(source)
            )
        end

        callback(source, isAllowed, ...)
    end)
end

InitVariables = initVariables
