local scoreboardConfig = Config.FootballScoreboard or {}

local defaultState = scoreboardConfig.DefaultState or {}
local MatchState = {
    active = false,
    running = false,
    state = "idle",
    status = LOr("scoreboard.status.standby", defaultState.status or "Standby"),
    homeName = LOr("defaults.team1_name", defaultState.homeName or "Red Team"),
    awayName = LOr("defaults.team2_name", defaultState.awayName or "Blue Team"),
    homeScore = math.max(0, math.min(99, math.floor(tonumber(defaultState.homeScore) or 0))),
    awayScore = math.max(0, math.min(99, math.floor(tonumber(defaultState.awayScore) or 0))),
    elapsedSeconds = 0,
    totalSeconds = math.max(1, (tonumber(scoreboardConfig.DefaultMatchMinutes) or 90) * 60),
    period = LOr("scoreboard.periods.waiting", defaultState.period or "Waiting"),
}

local timerStarted = false

local function periodLabel(key, fallback)
    local localized = LOr(("scoreboard.periods.%s"):format(key), "")
    if localized ~= "" then return localized end
    local labels = scoreboardConfig.PeriodLabels
    if type(labels) == "table" and labels[key] then
        return tostring(labels[key])
    end
    return fallback
end

local function canControl(src)
    if src == 0 then return true end
    if scoreboardConfig.ScoreboardDriver ~= "standalone" then return false end
    return IsPlayerAceAllowed(src, scoreboardConfig.AcePermission or "football.scoreboard")
end

local function sanitizeName(value, fallback)
    value = tostring(value or fallback or ""):sub(1, 32)
    value = value:gsub("[%c<>]", "")
    if value == "" then return fallback end
    return value
end

local function normalizeScore(value)
    value = math.floor(tonumber(value) or 0)
    if value < 0 then return 0 end
    if value > 99 then return 99 end
    return value
end

local function resolvePeriod()
    local s = tostring(MatchState.state or ""):lower()
    if s == "warmup" then return periodLabel("warmup", "Warmup") end
    if s == "countdown" then return periodLabel("countdown", "Kickoff") end
    if s == "paused" then return periodLabel("paused", "Paused") end
    if s == "ended" then return periodLabel("ended", "Full Time") end
    if MatchState.elapsedSeconds < (MatchState.totalSeconds * 0.5) then
        return periodLabel("first_half", "FIRST HALF")
    end
    return periodLabel("second_half", "SECOND HALF")
end

local function snapshot(extra)
    MatchState.period = MatchState.period or resolvePeriod()

    local out = {
        active = MatchState.active,
        running = MatchState.running,
        state = MatchState.state,
        status = MatchState.status,
        homeName = MatchState.homeName,
        awayName = MatchState.awayName,
        homeScore = MatchState.homeScore,
        awayScore = MatchState.awayScore,
        elapsedSeconds = MatchState.elapsedSeconds,
        totalSeconds = MatchState.totalSeconds,
        period = MatchState.period,
    }

    if type(extra) == "table" then
        for key, value in pairs(extra) do
            out[key] = value
        end
    end

    return out
end

local function broadcast(eventName, extra)
    TriggerClientEvent(eventName, -1, snapshot(extra))
end

local function ingestExternalState(payload)
    payload = payload or {}
    if payload.screenOff == true then
        MatchState.active = false
        MatchState.running = false
        MatchState.state = "idle"
        MatchState.status = LOr("scoreboard.status.standby", "Standby")
        return
    end
    if payload.homeName then MatchState.homeName = sanitizeName(payload.homeName, MatchState.homeName) end
    if payload.awayName then MatchState.awayName = sanitizeName(payload.awayName, MatchState.awayName) end
    if payload.homeScore ~= nil then MatchState.homeScore = normalizeScore(payload.homeScore) end
    if payload.awayScore ~= nil then MatchState.awayScore = normalizeScore(payload.awayScore) end
    if payload.totalSeconds then MatchState.totalSeconds = math.max(60, math.floor(tonumber(payload.totalSeconds) or MatchState.totalSeconds)) end
    if payload.elapsedSeconds then MatchState.elapsedSeconds = math.max(0, math.min(MatchState.totalSeconds, math.floor(tonumber(payload.elapsedSeconds) or 0))) end
    if payload.timeLeft then
        local timeLeft = math.max(0, math.floor(tonumber(payload.timeLeft) or 0))
        MatchState.elapsedSeconds = math.max(0, MatchState.totalSeconds - timeLeft)
    end
    if payload.state then MatchState.state = tostring(payload.state) end
    if payload.status then MatchState.status = tostring(payload.status) end
    MatchState.active = payload.active ~= false
    MatchState.running = MatchState.state == "playing"
    MatchState.period = payload.period or resolvePeriod()
end

local function startTimerThread()
    if timerStarted then return end
    timerStarted = true

    CreateThread(function()
        while true do
            Wait(1000)
            if MatchState.active and MatchState.running then
                MatchState.elapsedSeconds = math.min(MatchState.totalSeconds, MatchState.elapsedSeconds + 1)
                MatchState.period = resolvePeriod()
                broadcast("football:updateTime")

                if MatchState.elapsedSeconds >= MatchState.totalSeconds then
                    MatchState.running = false
                    MatchState.state = "ended"
                    MatchState.status = LOr("scoreboard.status.ended", "Full Time")
                    MatchState.period = resolvePeriod()
                    broadcast("football:endMatch")
                end
            end
        end
    end)
end

local function startMatch(payload)
    payload = payload or {}
    local minutes = tonumber(payload.minutes or payload.duration or scoreboardConfig.DefaultMatchMinutes) or 90

    MatchState.active = true
    MatchState.running = payload.running ~= false
    MatchState.state = payload.state or "playing"
    MatchState.status = payload.status or LOr("scoreboard.status.live", "Live")
    MatchState.homeName = sanitizeName(payload.homeName, MatchState.homeName)
    MatchState.awayName = sanitizeName(payload.awayName, MatchState.awayName)
    if payload.homeScore ~= nil then MatchState.homeScore = normalizeScore(payload.homeScore) end
    if payload.awayScore ~= nil then MatchState.awayScore = normalizeScore(payload.awayScore) end
    MatchState.totalSeconds = math.max(60, math.floor(tonumber(payload.totalSeconds) or (minutes * 60)))
    MatchState.elapsedSeconds = math.max(0, math.min(MatchState.totalSeconds, math.floor(tonumber(payload.elapsedSeconds) or 0)))
    MatchState.period = payload.period or resolvePeriod()

    startTimerThread()
    broadcast("football:startMatch")
end

local function updateScore(payload)
    payload = payload or {}
    if payload.homeName then MatchState.homeName = sanitizeName(payload.homeName, MatchState.homeName) end
    if payload.awayName then MatchState.awayName = sanitizeName(payload.awayName, MatchState.awayName) end
    if payload.homeScore ~= nil then MatchState.homeScore = normalizeScore(payload.homeScore) end
    if payload.awayScore ~= nil then MatchState.awayScore = normalizeScore(payload.awayScore) end
    MatchState.active = true
    MatchState.period = payload.period or resolvePeriod()
    broadcast("football:updateScore")
end

local function updateTime(payload)
    payload = payload or {}
    if payload.totalSeconds then MatchState.totalSeconds = math.max(60, math.floor(tonumber(payload.totalSeconds) or MatchState.totalSeconds)) end
    if payload.elapsedSeconds then MatchState.elapsedSeconds = math.max(0, math.min(MatchState.totalSeconds, math.floor(tonumber(payload.elapsedSeconds) or 0))) end
    if payload.timeLeft then
        local timeLeft = math.max(0, math.floor(tonumber(payload.timeLeft) or 0))
        MatchState.elapsedSeconds = math.max(0, MatchState.totalSeconds - timeLeft)
    end
    if payload.state then MatchState.state = tostring(payload.state) end
    if payload.status then MatchState.status = tostring(payload.status) end
    MatchState.period = payload.period or resolvePeriod()
    MatchState.active = true
    broadcast("football:updateTime")
end

local function goalScored(payload)
    payload = payload or {}
    local scoringTeam = tonumber(payload.scoringTeam)

    if payload.homeScore ~= nil or payload.awayScore ~= nil then
        updateScore(payload)
    elseif scoringTeam == 1 then
        MatchState.homeScore = normalizeScore(MatchState.homeScore + 1)
    elseif scoringTeam == 2 then
        MatchState.awayScore = normalizeScore(MatchState.awayScore + 1)
    end

    MatchState.active = true
    MatchState.status = LOr("scoreboard.status.goal", "Goal")
    MatchState.period = resolvePeriod()
    broadcast("football:goalScored", {
        scoringTeam = scoringTeam,
        scorerName = payload.scorerName,
        isOwnGoal = payload.isOwnGoal == true,
    })
    MatchState.status = MatchState.running and LOr("scoreboard.status.live", "Live") or MatchState.status
end

RegisterNetEvent("football:requestSync", function()
    if scoreboardConfig.ScoreboardDriver ~= "standalone" then
        TriggerEvent("seoul_soccer:server:SyncStadiumScoreboard", source)
        return
    end
    TriggerClientEvent("football:syncState", source, snapshot())
end)

AddEventHandler("football:server:ingest", function(payload)
    ingestExternalState(payload)
end)

RegisterNetEvent("football:startMatch", function(payload)
    if not canControl(source) then return end
    startMatch(payload)
end)

RegisterNetEvent("football:updateScore", function(payload)
    if not canControl(source) then return end
    updateScore(payload)
end)

RegisterNetEvent("football:updateTime", function(payload)
    if not canControl(source) then return end
    updateTime(payload)
end)

RegisterNetEvent("football:goalScored", function(payload)
    if not canControl(source) then return end
    goalScored(payload)
end)

RegisterNetEvent("football:endMatch", function(payload)
    if not canControl(source) then return end
    payload = payload or {}
    MatchState.active = true
    MatchState.running = false
    MatchState.state = "ended"
    MatchState.status = payload.status or LOr("scoreboard.status.ended", "Full Time")
    MatchState.period = resolvePeriod()
    broadcast("football:endMatch")
end)

exports("StartFootballMatch", startMatch)
exports("UpdateFootballScore", updateScore)
exports("UpdateFootballTime", updateTime)
exports("GoalScored", goalScored)
exports("GetFootballMatchState", function()
    return snapshot()
end)
