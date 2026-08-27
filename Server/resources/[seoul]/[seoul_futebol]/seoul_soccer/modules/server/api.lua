--[[
  seoul_soccer — harici kaynaklar icin sunucu API (exports + eventler).

  Ornek (baska bir server script):
    local lb = exports['seoul_soccer']:GetLeaderboard(10, 'goals')
    local tableData = exports['seoul_soccer']:GetPitchOverviewTable()
    local history = exports['seoul_soccer']:GetPlayerMatchHistory('license:abc...', 15)

  Async event (sunucu -> sunucu, requestId ile):
    TriggerEvent('seoul_soccer:server:ApiQuery', 'leaderboard', { limit = 10 }, requestId)
    AddEventHandler('seoul_soccer:server:ApiQueryResult', function(rid, ok, payload)
      if rid ~= requestId then return end
      ...
    end)
]]

SoccerAPI = SoccerAPI or {}

local function ApiCfg()
    return Config.API or {}
end

local function ClampLimit(n, defaultLimit, maxKey)
    local cfg = ApiCfg()
    local def = tonumber(defaultLimit) or 10
    local max = tonumber(cfg[maxKey]) or 100
    n = tonumber(n)
    if not n or n < 1 then return def end
    if n > max then return max end
    return math.floor(n)
end

local function Trim(str)
    if str == nil then return '' end
    str = tostring(str)
    return (str:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function ResolveIdentifier(arg)
    if arg == nil then return nil end
    if type(arg) == 'number' then
        local fn = SoccerAPI.GetPlayerIdentifier
        if fn and arg > 0 then
            return fn(arg)
        end
        return nil
    end
    local s = Trim(arg)
    if s == '' then return nil end
    return s
end

local function LeaderboardOrderSql(orderBy)
    orderBy = tostring(orderBy or (Config.Assists or {}).LeaderboardOrderBy or 'goals')
    if orderBy == 'assists' then
        return 'ORDER BY assists DESC, goals DESC, matches DESC'
    end
    if orderBy == 'matches' then
        return 'ORDER BY matches DESC, goals DESC, assists DESC'
    end
    return 'ORDER BY goals DESC, assists DESC, matches DESC'
end

local function NameFilterSql()
    return "WHERE TRIM(COALESCE(name, '')) <> '' AND LOWER(TRIM(name)) <> 'unknown'"
end

local function BuildTable(columns, rows)
    return {
        columns = columns,
        rows = rows or {},
        rowCount = #(rows or {}),
    }
end

local function EncodeJson(tbl)
    if json and json.encode then
        local ok, out = pcall(json.encode, tbl or {})
        if ok then return out end
    end
    return '[]'
end

local function DecodeJson(str)
    if not str or str == '' then return nil end
    if json and json.decode then
        local ok, out = pcall(json.decode, str)
        if ok then return out end
    end
    return nil
end

-- ─────────────────────────────────────────────
-- Veritabani
-- ─────────────────────────────────────────────
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `seoul_soccer_match_history` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `finished_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `pitch_id` VARCHAR(64) NOT NULL DEFAULT '',
            `pitch_name` VARCHAR(128) NOT NULL DEFAULT '',
            `lobby_id` INT UNSIGNED NOT NULL DEFAULT 0,
            `team1_name` VARCHAR(64) NOT NULL DEFAULT '',
            `team2_name` VARCHAR(64) NOT NULL DEFAULT '',
            `score1` INT NOT NULL DEFAULT 0,
            `score2` INT NOT NULL DEFAULT 0,
            `winner_team` TINYINT NOT NULL DEFAULT 0,
            `format` VARCHAR(32) NOT NULL DEFAULT '',
            `duration_min` INT NOT NULL DEFAULT 0,
            `elapsed_sec` INT NOT NULL DEFAULT 0,
            `target_goals` INT NOT NULL DEFAULT 0,
            `end_reason` VARCHAR(32) NOT NULL DEFAULT 'unknown',
            `goal_timeline` JSON NULL,
            PRIMARY KEY (`id`),
            KEY `idx_finished` (`finished_at`),
            KEY `idx_pitch` (`pitch_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `seoul_soccer_match_participants` (
            `match_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(60) NOT NULL,
            `player_name` VARCHAR(50) NOT NULL DEFAULT '',
            `team` TINYINT NOT NULL DEFAULT 0,
            `goals_in_match` INT NOT NULL DEFAULT 0,
            `assists_in_match` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`match_id`, `identifier`),
            KEY `idx_identifier` (`identifier`),
            CONSTRAINT `fk_seoul_soccer_match_participants_history`
                FOREIGN KEY (`match_id`) REFERENCES `seoul_soccer_match_history` (`id`)
                ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local function CollectMatchParticipants(lobby)
    local out = {}
    local statsBySrc = {}
    if lobby and type(lobby.playerGoals) == 'table' then
        for _, row in pairs(lobby.playerGoals) do
            if type(row) == 'table' then
                local src = tonumber(row.src) or 0
                if src > 0 then
                    statsBySrc[src] = row
                end
            end
        end
    end

    local getId = SoccerAPI.GetPlayerIdentifier
    local teams = { lobby.team1, lobby.team2 }
    for teamIdx, team in ipairs(teams) do
        for _, p in ipairs((team or {}).players or {}) do
            local src = tonumber(p.src) or 0
            if src > 0 and getId then
                local st = statsBySrc[src] or {}
                out[#out + 1] = {
                    identifier = getId(src),
                    player_name = Trim(p.name or st.name or 'Unknown'),
                    team = teamIdx,
                    goals_in_match = tonumber(st.goals) or 0,
                    assists_in_match = tonumber(st.assists) or 0,
                }
            end
        end
    end
    return out
end

function SoccerAPI.SaveMatchHistory(lobby, lobbyId, endReason)
    if not lobby then return end
    local cfg = ApiCfg()
    if cfg.SaveMatchHistory == false then return end

    local score1 = tonumber(lobby.team1 and lobby.team1.score) or 0
    local score2 = tonumber(lobby.team2 and lobby.team2.score) or 0
    local winner = 0
    if score1 > score2 then winner = 1
    elseif score2 > score1 then winner = 2 end

    local durationMin = tonumber(lobby.duration) or tonumber(Config.MatchDuration) or 20
    local totalSec = math.max(0, durationMin * 60)
    local timeLeft = math.max(0, tonumber(lobby.timeLeft) or 0)
    local elapsedSec = math.max(0, totalSec - timeLeft)

    local pitchId = tostring(lobby.pitchId or '')
    local pitchName = pitchId
    local getPitch = SoccerAPI.GetPitchById
    if getPitch then
        local pitch = getPitch(lobby.pitchId)
        if pitch and pitch.name then
            pitchName = GetLocalizedPitchName(pitch)
        end
    end

    local timeline = {}
    if SoccerAPI.BuildGoalTimeline then
        timeline = SoccerAPI.BuildGoalTimeline(lobby) or {}
    end

    local matchId = MySQL.insert.await([[
        INSERT INTO seoul_soccer_match_history
            (pitch_id, pitch_name, lobby_id, team1_name, team2_name, score1, score2,
             winner_team, format, duration_min, elapsed_sec, target_goals, end_reason, goal_timeline)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        pitchId,
        pitchName,
        tonumber(lobbyId) or 0,
        tostring((lobby.team1 and lobby.team1.name) or ''),
        tostring((lobby.team2 and lobby.team2.name) or ''),
        score1,
        score2,
        winner,
        tostring(lobby.format or ''),
        durationMin,
        elapsedSec,
        tonumber(lobby.targetGoals) or 0,
        tostring(endReason or 'unknown'),
        EncodeJson(timeline),
    })

    if not matchId or matchId == 0 then return end

    local participants = CollectMatchParticipants(lobby)
    for _, row in ipairs(participants) do
        if row.identifier and row.identifier ~= '' then
            MySQL.insert.await([[
                INSERT IGNORE INTO seoul_soccer_match_participants
                    (match_id, identifier, player_name, team, goals_in_match, assists_in_match)
                VALUES (?, ?, ?, ?, ?, ?)
            ]], {
                matchId,
                row.identifier,
                row.player_name,
                row.team,
                row.goals_in_match,
                row.assists_in_match,
            })
        end
    end

    TriggerEvent('seoul_soccer:matchSaved', matchId, lobbyId, endReason, {
        pitchId = pitchId,
        pitchName = pitchName,
        score1 = score1,
        score2 = score2,
        winnerTeam = winner,
        team1Name = tostring((lobby.team1 and lobby.team1.name) or ''),
        team2Name = tostring((lobby.team2 and lobby.team2.name) or ''),
    })
end

-- ─────────────────────────────────────────────
-- Leaderboard
-- ─────────────────────────────────────────────
function SoccerAPI.FetchLeaderboard(limit, orderBy)
    limit = ClampLimit(limit, (ApiCfg()).LeaderboardDefaultLimit or 10, 'LeaderboardMaxLimit')
    local sql = ('SELECT identifier, name, goals, assists, matches FROM seoul_soccer_player_stats %s %s LIMIT %d'):format(
        NameFilterSql(),
        LeaderboardOrderSql(orderBy),
        limit
    )
    return MySQL.query.await(sql, {}) or {}
end

local function ExportGetLeaderboard(limit, orderBy)
    return SoccerAPI.FetchLeaderboard(limit, orderBy)
end

local function ExportGetLeaderboardTable(limit, orderBy)
    local rows = ExportGetLeaderboard(limit, orderBy)
    local out = {}
    for i, r in ipairs(rows) do
        out[#out + 1] = {
            rank = i,
            identifier = r.identifier,
            name = r.name,
            goals = tonumber(r.goals) or 0,
            assists = tonumber(r.assists) or 0,
            matches = tonumber(r.matches) or 0,
        }
    end
    return BuildTable(
        { 'rank', 'name', 'goals', 'assists', 'matches', 'identifier' },
        out
    )
end

-- ─────────────────────────────────────────────
-- Oyuncu istatistikleri / mac gecmisi
-- ─────────────────────────────────────────────
function SoccerAPI.FetchPlayerStats(identifierOrSource)
    local id = ResolveIdentifier(identifierOrSource)
    if not id then return nil end
    local rows = MySQL.query.await(
        'SELECT identifier, name, goals, assists, matches FROM seoul_soccer_player_stats WHERE identifier = ? LIMIT 1',
        { id }
    )
    return rows and rows[1] or nil
end

function SoccerAPI.FetchPlayerMatchHistory(identifierOrSource, limit, offset)
    local id = ResolveIdentifier(identifierOrSource)
    if not id then return {} end
    limit = ClampLimit(limit, (ApiCfg()).MatchHistoryDefaultLimit or 20, 'MatchHistoryMaxLimit')
    offset = math.max(0, math.floor(tonumber(offset) or 0))

    return MySQL.query.await([[
        SELECT
            h.id AS match_id,
            h.finished_at,
            h.pitch_id,
            h.pitch_name,
            h.team1_name,
            h.team2_name,
            h.score1,
            h.score2,
            h.winner_team,
            h.format,
            h.elapsed_sec,
            h.end_reason,
            p.team AS my_team,
            p.goals_in_match,
            p.assists_in_match,
            p.player_name
        FROM seoul_soccer_match_participants p
        INNER JOIN seoul_soccer_match_history h ON h.id = p.match_id
        WHERE p.identifier = ?
        ORDER BY h.finished_at DESC
        LIMIT ? OFFSET ?
    ]], { id, limit, offset }) or {}
end

local function FormatMatchHistoryRows(rows)
    local out = {}
    for _, r in ipairs(rows or {}) do
        local myTeam = tonumber(r.my_team) or 0
        local s1, s2 = tonumber(r.score1) or 0, tonumber(r.score2) or 0
        local result = 'draw'
        if s1 ~= s2 then
            local winTeam = s1 > s2 and 1 or 2
            result = (myTeam == winTeam) and 'win' or 'loss'
        end
        out[#out + 1] = {
            matchId = tonumber(r.match_id),
            finishedAt = r.finished_at,
            pitchId = r.pitch_id,
            pitchName = r.pitch_name,
            team1Name = r.team1_name,
            team2Name = r.team2_name,
            score = ('%d - %d'):format(s1, s2),
            score1 = s1,
            score2 = s2,
            myTeam = myTeam,
            myGoals = tonumber(r.goals_in_match) or 0,
            myAssists = tonumber(r.assists_in_match) or 0,
            result = result,
            format = r.format,
            elapsedSec = tonumber(r.elapsed_sec) or 0,
            endReason = r.end_reason,
        }
    end
    return out
end

local function ExportGetPlayerMatchHistoryTable(identifierOrSource, limit, offset)
    local rows = SoccerAPI.FetchPlayerMatchHistory(identifierOrSource, limit, offset)
    local formatted = FormatMatchHistoryRows(rows)
    return BuildTable(
        { 'finishedAt', 'pitchName', 'score', 'result', 'myGoals', 'myAssists', 'format', 'endReason', 'matchId' },
        formatted
    )
end

-- ─────────────────────────────────────────────
-- Sahalar / aktif lobiler / ozet
-- ─────────────────────────────────────────────
local ACTIVE_LOBBY_STATES = {
    waiting = true,
    warmup = true,
    countdown = true,
    playing = true,
    paused = true,
}

--- main.lua icindeki canli `Lobbies` tablosu (export cagrisinda guncel referans).
local function getLobbiesTable()
    if type(SoccerAPI.GetLobbiesTable) == 'function' then
        return SoccerAPI.GetLobbiesTable() or {}
    end
    return SoccerAPI.Lobbies or {}
end

local function isActiveLobbyState(state)
    return ACTIVE_LOBBY_STATES[tostring(state or ''):lower()] == true
end

local function SanitizeLobbyForExport(lobbyId, lobby)
    local countFn = SoccerAPI.CountLobbyPlayers
    local playerCount = countFn and countFn(lobby) or 0
    local cap1, cap2 = nil, nil
    if SoccerAPI.GetLobbyTeamCapacityCaps then
        cap1, cap2 = SoccerAPI.GetLobbyTeamCapacityCaps(lobby)
    end
    return {
        id = lobbyId,
        name = lobby.name,
        pitchId = lobby.pitchId,
        state = lobby.state,
        format = lobby.format,
        host = lobby.host,
        playerCount = playerCount,
        team1Count = #(lobby.team1 and lobby.team1.players or {}),
        team2Count = #(lobby.team2 and lobby.team2.players or {}),
        team1Cap = cap1,
        team2Cap = cap2,
        score1 = tonumber(lobby.team1 and lobby.team1.score) or 0,
        score2 = tonumber(lobby.team2 and lobby.team2.score) or 0,
        team1Name = lobby.team1 and lobby.team1.name,
        team2Name = lobby.team2 and lobby.team2.name,
        timeLeft = tonumber(lobby.timeLeft),
        hasPassword = type(lobby.password) == 'string' and lobby.password ~= '',
        targetGoals = tonumber(lobby.targetGoals) or 0,
    }
end

function SoccerAPI.FetchActiveLobbies()
    local lobbies = getLobbiesTable()
    local out = {}
    for lid, lobby in pairs(lobbies) do
        if type(lobby) == 'table' and isActiveLobbyState(lobby.state) then
            out[#out + 1] = SanitizeLobbyForExport(lid, lobby)
        end
    end
    table.sort(out, function(a, b)
        return (tonumber(a.id) or 0) < (tonumber(b.id) or 0)
    end)
    return out
end

function SoccerAPI.FetchPitchOverview()
    local lobbies = getLobbiesTable()
    local busyByPitch = {}
    local playersOnPitch = {}

    for lid, lobby in pairs(lobbies) do
        if type(lobby) == 'table' and isActiveLobbyState(lobby.state) then
            local pid = tostring(lobby.pitchId or '')
            if pid ~= '' then
                busyByPitch[pid] = SanitizeLobbyForExport(lid, lobby)
                local cnt = SoccerAPI.CountLobbyPlayers and SoccerAPI.CountLobbyPlayers(lobby) or 0
                playersOnPitch[pid] = (playersOnPitch[pid] or 0) + cnt
            end
        end
    end

    local out = {}
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch and pitch.id ~= nil then
            local pid = tostring(pitch.id)
            local busy = busyByPitch[pid]
            local pc = pitch.coords
            out[#out + 1] = {
                pitchId = pitch.id,
                pitchName = GetLocalizedPitchName(pitch),
                radius = tonumber(pitch.radius),
                isBusy = busy ~= nil,
                lobby = busy,
                playerCount = playersOnPitch[pid] or 0,
                state = busy and busy.state or 'idle',
                coords = pc and { x = pc.x, y = pc.y, z = pc.z } or nil,
            }
        end
    end
    return out
end

local function ExportGetPitchOverviewTable()
    local pitches = SoccerAPI.FetchPitchOverview()
    local rows = {}
    for _, p in ipairs(pitches) do
        local lobby = p.lobby
        rows[#rows + 1] = {
            pitchId = p.pitchId,
            pitchName = p.pitchName,
            state = p.state,
            isBusy = p.isBusy,
            playerCount = p.playerCount,
            lobbyId = lobby and lobby.id or nil,
            score = lobby and ('%d - %d'):format(lobby.score1 or 0, lobby.score2 or 0) or '-',
            format = lobby and lobby.format or '-',
        }
    end
    return BuildTable(
        { 'pitchName', 'state', 'playerCount', 'isBusy', 'lobbyId', 'score', 'format', 'pitchId' },
        rows
    )
end

local function ExportGetActiveLobbiesTable()
    local lobbies = SoccerAPI.FetchActiveLobbies()
    local rows = {}
    for _, l in ipairs(lobbies) do
        rows[#rows + 1] = {
            id = l.id,
            name = l.name,
            pitchId = l.pitchId,
            state = l.state,
            players = ('%d (%d+%d)'):format(l.playerCount, l.team1Count, l.team2Count),
            score = ('%d - %d'):format(l.score1, l.score2),
            format = l.format,
        }
    end
    return BuildTable(
        { 'id', 'name', 'pitchId', 'state', 'players', 'score', 'format' },
        rows
    )
end

function SoccerAPI.FetchServerSummary()
    local lobbies = SoccerAPI.FetchActiveLobbies()
    local pitches = SoccerAPI.FetchPitchOverview()
    local activeMatches = 0
    local waitingLobbies = 0
    local totalPlayers = 0
    for _, l in ipairs(lobbies) do
        totalPlayers = totalPlayers + (l.playerCount or 0)
        if l.state == 'playing' or l.state == 'paused' or l.state == 'countdown' then
            activeMatches = activeMatches + 1
        elseif l.state == 'waiting' or l.state == 'warmup' then
            waitingLobbies = waitingLobbies + 1
        end
    end
    local busyPitches = 0
    for _, p in ipairs(pitches) do
        if p.isBusy then busyPitches = busyPitches + 1 end
    end
    return {
        activeLobbyCount = #lobbies,
        activeMatchCount = activeMatches,
        waitingLobbyCount = waitingLobbies,
        playersInSoccer = totalPlayers,
        pitchCount = #pitches,
        busyPitchCount = busyPitches,
        generatedAt = os.time(),
    }
end

function SoccerAPI.FetchRecentTopScorers(days, limit)
    days = math.max(1, math.min(365, math.floor(tonumber(days) or 7)))
    limit = ClampLimit(limit, 10, 'LeaderboardMaxLimit')
    return MySQL.query.await([[
        SELECT p.identifier,
               MAX(p.player_name) AS name,
               SUM(p.goals_in_match) AS goals,
               SUM(p.assists_in_match) AS assists,
               COUNT(*) AS matches
        FROM seoul_soccer_match_participants p
        INNER JOIN seoul_soccer_match_history h ON h.id = p.match_id
        WHERE h.finished_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
        GROUP BY p.identifier
        HAVING goals > 0
        ORDER BY goals DESC, assists DESC
        LIMIT ?
    ]], { days, limit }) or {}
end

function SoccerAPI.FetchMatchById(matchId)
    matchId = tonumber(matchId)
    if not matchId then return nil end
    local rows = MySQL.query.await('SELECT * FROM seoul_soccer_match_history WHERE id = ? LIMIT 1', { matchId })
    if not rows or not rows[1] then return nil end
    local match = rows[1]
    match.goal_timeline = DecodeJson(match.goal_timeline)
    match.participants = MySQL.query.await(
        'SELECT identifier, player_name, team, goals_in_match, assists_in_match FROM seoul_soccer_match_participants WHERE match_id = ?',
        { matchId }
    ) or {}
    return match
end

function SoccerAPI.FindPlayerLobby(source)
    source = tonumber(source)
    if not source or source == 0 then return nil end
    local lobbies = getLobbiesTable()
    for lid, lobby in pairs(lobbies) do
        if type(lobby) == 'table' and SoccerAPI.IsPlayerInLobby and SoccerAPI.IsPlayerInLobby(lobby, source) then
            return lid, lobby
        end
    end
    return nil, nil
end

--- 0r-smarttab ve diger harici kaynaklar icin tek cagri (lobi + saha ozeti).
function SoccerAPI.FetchTabletBridgeSnapshot()
    return {
        pitchOverview = SoccerAPI.FetchPitchOverview(),
        activeLobbies = SoccerAPI.FetchActiveLobbies(),
        serverSummary = SoccerAPI.FetchServerSummary(),
    }
end

-- ─────────────────────────────────────────────
-- Exports
-- ─────────────────────────────────────────────
exports('GetTabletBridgeSnapshot', SoccerAPI.FetchTabletBridgeSnapshot)
exports('GetLeaderboard', ExportGetLeaderboard)
exports('GetLeaderboardTable', ExportGetLeaderboardTable)
exports('GetPlayerStats', SoccerAPI.FetchPlayerStats)
exports('GetPlayerMatchHistory', function(id, limit, offset)
    return FormatMatchHistoryRows(SoccerAPI.FetchPlayerMatchHistory(id, limit, offset))
end)
exports('GetPlayerMatchHistoryRaw', SoccerAPI.FetchPlayerMatchHistory)
exports('GetPlayerMatchHistoryTable', ExportGetPlayerMatchHistoryTable)
exports('GetPitchOverview', SoccerAPI.FetchPitchOverview)
exports('GetPitchOverviewTable', ExportGetPitchOverviewTable)
exports('GetActiveLobbies', SoccerAPI.FetchActiveLobbies)
exports('GetActiveLobbiesTable', ExportGetActiveLobbiesTable)
exports('GetServerSummary', SoccerAPI.FetchServerSummary)
exports('GetRecentTopScorers', SoccerAPI.FetchRecentTopScorers)
exports('GetMatchById', SoccerAPI.FetchMatchById)
exports('IsPlayerInMatch', function(src)
    local lid = SoccerAPI.FindPlayerLobby(src)
    if not lid then return false end
    local lobby = getLobbiesTable()[lid]
    if not lobby then return false end
    local st = tostring(lobby.state or '')
    return st == 'playing' or st == 'paused' or st == 'countdown' or st == 'warmup'
end)
exports('GetPlayerLobbyId', function(src)
    local lid = SoccerAPI.FindPlayerLobby(src)
    return lid
end)

-- ─────────────────────────────────────────────
-- Event tabanli sorgular (baska server scriptler)
-- ─────────────────────────────────────────────
local API_HANDLERS = {
    leaderboard = function(p)
        return true, ExportGetLeaderboard(p.limit, p.orderBy)
    end,
    leaderboardTable = function(p)
        return true, ExportGetLeaderboardTable(p.limit, p.orderBy)
    end,
    playerStats = function(p)
        local row = SoccerAPI.FetchPlayerStats(p.identifier or p.source or p.src)
        return row ~= nil, row
    end,
    playerMatchHistory = function(p)
        return true, FormatMatchHistoryRows(SoccerAPI.FetchPlayerMatchHistory(
            p.identifier or p.source or p.src, p.limit, p.offset))
    end,
    playerMatchHistoryTable = function(p)
        return true, ExportGetPlayerMatchHistoryTable(p.identifier or p.source or p.src, p.limit, p.offset)
    end,
    pitchOverview = function()
        return true, SoccerAPI.FetchPitchOverview()
    end,
    pitchOverviewTable = function()
        return true, ExportGetPitchOverviewTable()
    end,
    activeLobbies = function()
        return true, SoccerAPI.FetchActiveLobbies()
    end,
    activeLobbiesTable = function()
        return true, ExportGetActiveLobbiesTable()
    end,
    serverSummary = function()
        return true, SoccerAPI.FetchServerSummary()
    end,
    tabletBridge = function()
        return true, SoccerAPI.FetchTabletBridgeSnapshot()
    end,
    recentTopScorers = function(p)
        return true, SoccerAPI.FetchRecentTopScorers(p.days, p.limit)
    end,
    matchById = function(p)
        local row = SoccerAPI.FetchMatchById(p.matchId or p.id)
        return row ~= nil, row
    end,
}

AddEventHandler('seoul_soccer:server:ApiQuery', function(queryType, params, requestId)
    if (ApiCfg()).EnableServerEvents == false then return end
    params = type(params) == 'table' and params or {}
    local handler = API_HANDLERS[tostring(queryType or '')]
    if not handler then
        TriggerEvent('seoul_soccer:server:ApiQueryResult', requestId, false, { error = 'unknown_query', queryType = queryType })
        return
    end
    local ok, payload = handler(params)
    TriggerEvent('seoul_soccer:server:ApiQueryResult', requestId, ok == true, payload)
end)

-- Oyuncu baglandiginda / script basinda: baska kaynak dinleyebilir
RegisterNetEvent('seoul_soccer:server:RequestPlayerMatchHistory', function(identifier, limit, requestId)
    local src = source
    if (ApiCfg()).EnableNetEvents == false then return end
    limit = ClampLimit(limit, (ApiCfg()).MatchHistoryDefaultLimit or 20, 'MatchHistoryMaxLimit')
    local id = identifier
    if not id or id == '' then
        id = SoccerAPI.GetPlayerIdentifier and SoccerAPI.GetPlayerIdentifier(src) or nil
    end
    local rows = FormatMatchHistoryRows(SoccerAPI.FetchPlayerMatchHistory(id, limit, 0))
    TriggerClientEvent('seoul_soccer:client:PlayerMatchHistory', src, requestId or 0, rows)
end)

RegisterNetEvent('seoul_soccer:server:RequestLeaderboardExport', function(limit, orderBy, requestId)
    local src = source
    if (ApiCfg()).EnableNetEvents == false then return end
    local rows = ExportGetLeaderboard(limit, orderBy)
    TriggerClientEvent('seoul_soccer:client:LeaderboardExport', src, requestId or 0, rows)
end)

RegisterNetEvent('seoul_soccer:server:RequestPitchOverviewExport', function(requestId)
    local src = source
    if (ApiCfg()).EnableNetEvents == false then return end
    TriggerClientEvent('seoul_soccer:client:PitchOverviewExport', src, requestId or 0, SoccerAPI.FetchPitchOverview())
end)

print('[seoul_soccer] Server API exports loaded (GetLeaderboard, GetPitchOverview, GetPlayerMatchHistory, ...)')
