local Lobbies = {}
--- Bekleyen davetler: [hedefOyuncuSrc] = { lobbyId, teamIndex, expiresAt }
local LobbyInvites = {}
local NextLobbyId = 1
local LobbyTimerActive = {}

local function GetNowMs()
    if GetGameTimer then
        return GetGameTimer()
    end
    return os.time() * 1000
end

-- ─────────────────────────────────────────────
-- Veritabanı Başlatma
-- ─────────────────────────────────────────────
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `seoul_soccer_player_stats` (
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(50) NOT NULL DEFAULT '',
            `goals` INT NOT NULL DEFAULT 0,
            `assists` INT NOT NULL DEFAULT 0,
            `matches` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local function GetPlayerIdentifier(src)
    if Bridge and type(Bridge.GetPlayerIdentifier) == "function" then
        local identifier = Bridge.GetPlayerIdentifier(src)
        if identifier and identifier ~= "" then return identifier end
    end
    local ids = GetPlayerIdentifiers(src) or {}
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 8) == 'license:' then
            return id
        end
    end
    return 'player:' .. tostring(src)
end

local function Trim(str)
    if str == nil then return '' end
    str = tostring(str)
    return (str:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function ResolvePlayerStatsName(src)
    if not src or src == 0 then return nil end

    if Bridge and type(Bridge.GetCharacterName) == "function" then
        local characterName = Trim(Bridge.GetCharacterName(src) or '')
        if characterName ~= '' and string.lower(characterName) ~= 'unknown' then
            return characterName
        end
    end

    local steam = Trim(GetPlayerName(src) or '')
    if steam ~= '' and string.lower(steam) ~= 'unknown' then
        return steam
    end

    if GetResourceState('qbx_core') == 'started' then
        local ok, player = pcall(function()
            return exports.qbx_core:GetPlayer(src)
        end)
        if ok and player and player.PlayerData and player.PlayerData.charinfo then
            local ci = player.PlayerData.charinfo
            local full = Trim((Trim(ci.firstname or '') .. ' ' .. Trim(ci.lastname or '')):gsub('%s+', ' '))
            if full ~= '' then return full end
        end
    end

    if GetResourceState('qb-core') == 'started' then
        local ok, QBCore = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player and Player.PlayerData and Player.PlayerData.charinfo then
                local ci = Player.PlayerData.charinfo
                local full = Trim((Trim(ci.firstname or '') .. ' ' .. Trim(ci.lastname or '')):gsub('%s+', ' '))
                if full ~= '' then return full end
            end
        end
    end

    if GetResourceState('es_extended') == 'started' then
        local ok, ESX = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and ESX and ESX.GetPlayerFromId then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer and xPlayer.getName then
                local n = Trim(xPlayer.getName() or '')
                if n ~= '' and string.lower(n) ~= 'unknown' then return n end
            end
        end
    end

    return nil
end

local function GetCachedLobbyPlayerName(lobby, src)
    if not lobby or not src then return nil end
    for _, team in ipairs({ lobby.team1.players, lobby.team2.players }) do
        for _, p in ipairs(team) do
            if p.src == src and p.name then
                local n = Trim(tostring(p.name))
                if n ~= '' and string.lower(n) ~= 'unknown' then return n end
            end
        end
    end
    return nil
end

local function GetPlayerTeamIndex(lobby, src)
    if not lobby then return 0 end
    for _, p in ipairs(lobby.team1.players) do
        if p.src == src then return 1 end
    end
    for _, p in ipairs(lobby.team2.players) do
        if p.src == src then return 2 end
    end
    return 0
end

local function SaveGoalToDB(src, lobby)
    if not src or src == 0 then return end
    local identifier = GetPlayerIdentifier(src)
    local name = ResolvePlayerStatsName(src) or (lobby and GetCachedLobbyPlayerName(lobby, src))
    name = name and Trim(name) or ''
    if name == '' or string.lower(name) == 'unknown' then return end
    MySQL.query([[
        INSERT INTO seoul_soccer_player_stats (identifier, name, goals)
        VALUES (?, ?, 1)
        ON DUPLICATE KEY UPDATE name = VALUES(name), goals = goals + 1
    ]], { identifier, name })
end

local function SaveAssistToDB(src, lobby)
    if not src or src == 0 then return end
    local identifier = GetPlayerIdentifier(src)
    local name = ResolvePlayerStatsName(src) or (lobby and GetCachedLobbyPlayerName(lobby, src))
    name = name and Trim(name) or ''
    if name == '' or string.lower(name) == 'unknown' then return end
    MySQL.query([[
        INSERT INTO seoul_soccer_player_stats (identifier, name, assists)
        VALUES (?, ?, 1)
        ON DUPLICATE KEY UPDATE name = VALUES(name), assists = assists + 1
    ]], { identifier, name })
end

local function RecordAssistCandidate(lobby, passerSrc)
    if not lobby or not passerSrc or passerSrc == 0 then return end
    local team = GetPlayerTeamIndex(lobby, passerSrc)
    if team ~= 1 and team ~= 2 then return end
    lobby.assistCandidate = {
        src = passerSrc,
        team = team,
        atMs = GetNowMs(),
    }
end

local function ResolveAssistForGoal(lobby, scorerSrc, isOwnGoal)
    if isOwnGoal then return nil end
    local acfg = Config.Assists or {}
    if acfg.Enabled == false then return nil end
    local cand = lobby and lobby.assistCandidate
    if type(cand) ~= 'table' then return nil end
    local assistSrc = tonumber(cand.src) or 0
    if assistSrc == 0 then return nil end
    local windowMs = tonumber(acfg.WindowMs) or 5000
    local atMs = tonumber(cand.atMs) or 0
    if GetNowMs() - atMs > windowMs then return nil end
    if not scorerSrc or scorerSrc == 0 then return nil end
    if assistSrc == tonumber(scorerSrc) then return nil end
    local scorerTeam = GetPlayerTeamIndex(lobby, scorerSrc)
    local candTeam = tonumber(cand.team) or 0
    if scorerTeam == 0 or candTeam == 0 or scorerTeam ~= candTeam then return nil end
    return assistSrc
end

local function SaveMatchToDB(lobby)
    if not lobby then return end
    local function saveOne(src, cachedLobbyName)
        if not src or src == 0 then return end
        local identifier = GetPlayerIdentifier(src)
        local name = ResolvePlayerStatsName(src)
        if (not name or Trim(name) == '') and cachedLobbyName then
            local cn = Trim(tostring(cachedLobbyName))
            if cn ~= '' and string.lower(cn) ~= 'unknown' then name = cn end
        end
        name = name and Trim(name) or ''
        if name == '' or string.lower(name) == 'unknown' then return end
        MySQL.query([[
            INSERT INTO seoul_soccer_player_stats (identifier, name, matches)
            VALUES (?, ?, 1)
            ON DUPLICATE KEY UPDATE name = VALUES(name), matches = matches + 1
        ]], { identifier, name })
    end
    for _, p in ipairs(lobby.team1.players) do saveOne(p.src, p.name) end
    for _, p in ipairs(lobby.team2.players) do saveOne(p.src, p.name) end
end

-- ─────────────────────────────────────────────
-- Yardımcı: lobi oyuncularının tüm server id listesi
-- ─────────────────────────────────────────────
local function GetAllPlayers(lobby)
    local players = {}
    for _, p in ipairs(lobby.team1.players) do players[#players + 1] = p.src end
    for _, p in ipairs(lobby.team2.players) do players[#players + 1] = p.src end
    return players
end

local function CountLobbyPlayers(lobby)
    if not lobby then return 0 end
    return #(lobby.team1.players or {}) + #(lobby.team2.players or {})
end

local function BroadcastToLobby(lobby, event, ...)
    for _, src in ipairs(GetAllPlayers(lobby)) do
        TriggerClientEvent(event, src, ...)
    end
end

local function IsPlayerInLobby(lobby, src)
    if not lobby then return false end
    for _, p in ipairs(lobby.team1.players) do
        if p.src == src then return true end
    end
    for _, p in ipairs(lobby.team2.players) do
        if p.src == src then return true end
    end
    return false
end

local function GetLobbyIdPlayerBelongsTo(src)
    if not src then return nil end
    for lid, lobby in pairs(Lobbies) do
        if lobby and IsPlayerInLobby(lobby, src) then
            return lid
        end
    end
    return nil
end

local function ClearLobbyInviteClient(targetSrc)
    if not targetSrc then return end
    TriggerClientEvent('seoul_soccer:client:ClearLobbyInvite', targetSrc)
end

local function ClearInvitesForLobby(lobbyId)
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local toClear = {}
    for tid, inv in pairs(LobbyInvites) do
        if inv and tonumber(inv.lobbyId) == lobbyId then
            toClear[#toClear + 1] = tid
        end
    end
    for _, tid in ipairs(toClear) do
        LobbyInvites[tid] = nil
        ClearLobbyInviteClient(tid)
    end
end

local GetPitchById

local function GetDefendingTeamForGoal(scoringTeam)
    scoringTeam = tonumber(scoringTeam)
    if scoringTeam == 1 then return 2 end
    if scoringTeam == 2 then return 1 end
    return 0
end

--- Gol sonrasi kickoff kilidi: tum istemcilere (fizik + UI tutarliligi).
local function BroadcastKickoffLockState(lobby)
    if not lobby then return end
    BroadcastToLobby(lobby, 'seoul_soccer:client:KickoffLockState',
        lobby.kickoffLockActive == true,
        tonumber(lobby.kickoffAllowedTeam) or 0,
        tonumber(lobby.kickoffBlockedTeam) or 0
    )
end

function GetPitchById(pitchId)
    if pitchId == nil then return nil end
    local want = tostring(pitchId)
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch and pitch.id ~= nil and tostring(pitch.id) == want then
            return pitch
        end
    end
    return nil
end

--- Kapı: native (`model` + `coords`). Eksik/boş satırlar yok sayılır.
local function GetPitchDoorEntries(pitch)
    local out = {}
    if not pitch or type(pitch.doors) ~= "table" then return out end
    for _, def in ipairs(pitch.doors) do
        if type(def) == "table" then
            local c = def.coords
            local hasCoords = c and type(c.x) == "number"
            if def.model and hasCoords then
                out[#out + 1] = def
            end
        end
    end
    return out
end

local function GetPitchDoorCount(pitchId)
    return #GetPitchDoorEntries(GetPitchById(pitchId))
end

local function InitLobbyPitchDoorLocks(lobby)
    if not lobby then return end
    local n = GetPitchDoorCount(lobby.pitchId)
    lobby.pitchDoorLocks = {}
    for i = 1, n do
        lobby.pitchDoorLocks[i] = false
    end
end

local function BuildPitchDoorsForUi(pitchId)
    local entries = GetPitchDoorEntries(GetPitchById(pitchId))
    local out = {}
    for i, d in ipairs(entries) do
        out[i] = { label = (d.label ~= nil and tostring(d.label)) or ("Door " .. tostring(i)) }
    end
    return out
end

local function CopyPitchDoorLocks(lobby)
    local t = {}
    if not lobby or type(lobby.pitchDoorLocks) ~= "table" then return t end
    for i, v in ipairs(lobby.pitchDoorLocks) do
        t[i] = v == true
    end
    return t
end

local function UnlockPitchDoorsForEveryone(pitchId)
    local n = GetPitchDoorCount(pitchId)
    if n == 0 then return end
    local unlocks = {}
    for i = 1, n do
        unlocks[i] = false
    end
    TriggerClientEvent("seoul_soccer:client:ApplyPitchDoorLocks", -1, pitchId, unlocks)
end

local function BroadcastPitchDoorState(lobby, lobbyId)
    if not lobby or not lobby.pitchId then return end
    if type(lobby.pitchDoorLocks) ~= "table" then return end
    TriggerClientEvent("seoul_soccer:client:ApplyPitchDoorLocks", -1, lobby.pitchId, lobby.pitchDoorLocks)
    BroadcastToLobby(lobby, "seoul_soccer:client:PitchDoorLocksNui", lobbyId, CopyPitchDoorLocks(lobby))
end

--- Oyuncuya tum sahalarin guncel kilit durumunu gonderir (geç-join / resource restart resync).
local function SendPitchDoorStateToPlayer(src)
    if not src then return end
    local activeByPitch = {}
    for _, lobby in pairs(Lobbies) do
        if lobby and lobby.pitchId and type(lobby.pitchDoorLocks) == "table" then
            activeByPitch[tostring(lobby.pitchId)] = lobby.pitchDoorLocks
        end
    end
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch and pitch.id ~= nil then
            local pid = pitch.id
            local locks = activeByPitch[tostring(pid)]
            if not locks then
                local n = GetPitchDoorCount(pid)
                if n > 0 then
                    locks = {}
                    for i = 1, n do locks[i] = false end
                end
            end
            if locks then
                TriggerClientEvent("seoul_soccer:client:ApplyPitchDoorLocks", src, pid, locks)
            end
        end
    end
end

local function ResolvePitchId(requestedPitchId)
    if requestedPitchId == "random" then
        local pitchCount = #(Config.Pitches or {})
        if pitchCount > 0 then
            return Config.Pitches[math.random(1, pitchCount)].id
        end
        return nil
    end

    if requestedPitchId and GetPitchById(requestedPitchId) then
        return requestedPitchId
    end

    -- Eski UI value'su ile geri uyumluluk.
    if requestedPitchId == "stadium-1" and Config.Pitches and Config.Pitches[1] then
        return Config.Pitches[1].id
    end

    if Config.Pitches and Config.Pitches[1] then
        return Config.Pitches[1].id
    end

    return nil
end

--- 'random' veya bos: kurucu ped konumuna en yakin pitch (UI her zaman random yolluyordu; yanlis sahada aninda atma onlenir)
local function ResolvePitchIdForHost(requestedPitchId, src)
    if requestedPitchId and tostring(requestedPitchId) ~= "" and tostring(requestedPitchId) ~= "random" then
        return ResolvePitchId(requestedPitchId)
    end
    if not src or not GetPlayerPed or not GetEntityCoords then
        return ResolvePitchId("random")
    end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then
        return ResolvePitchId("random")
    end
    local ok, pos = pcall(GetEntityCoords, ped)
    if not ok or not pos then
        return ResolvePitchId("random")
    end
    local bestId, bestD2 = nil, nil
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch and pitch.id and pitch.coords then
            local dx = pos.x - pitch.coords.x
            local dy = pos.y - pitch.coords.y
            local d2 = (dx * dx) + (dy * dy)
            if not bestD2 or d2 < bestD2 then
                bestD2 = d2
                bestId = pitch.id
            end
        end
    end
    return bestId or ResolvePitchId("random")
end

local function IsPlayerNearPitch(src, pitchId, extraDistance)
    src = tonumber(src)
    local pitch = GetPitchById(pitchId)
    if not src or not pitch or not pitch.coords or not GetPlayerPed or not GetEntityCoords then return false end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local ok, pos = pcall(GetEntityCoords, ped)
    if not ok or not pos then return false end
    local dx = pos.x - pitch.coords.x
    local dy = pos.y - pitch.coords.y
    local dz = pos.z - pitch.coords.z
    local distance = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
    local allowed = math.max(10.0, tonumber(pitch.radius) or 50.0) + math.max(0.0, tonumber(extraDistance) or 10.0)
    return distance <= allowed
end

local function BuildGoalkeeperPoint(pitch, goalBox)
    if not pitch or not pitch.coords or not goalBox or not goalBox.min or not goalBox.max then return nil end
    local center = vector3(
        (goalBox.min.x + goalBox.max.x) * 0.5,
        (goalBox.min.y + goalBox.max.y) * 0.5,
        (goalBox.min.z + goalBox.max.z) * 0.5
    )
    local gk = Config.Goalkeeper or {}
    local offset = math.max(0.0, tonumber(gk.OffsetTowardField) or 2.8)
    local dx = pitch.coords.x - center.x
    local dy = pitch.coords.y - center.y
    local len = math.sqrt((dx * dx) + (dy * dy))
    if len > 0.2 then
        center = vector3(center.x + ((dx / len) * offset), center.y + ((dy / len) * offset), center.z)
    end
    return center
end

local function GetGoalkeeperPointForTeam(pitchId, teamIndex)
    local pitch = GetPitchById(pitchId)
    if not pitch or type(pitch.goals) ~= "table" then return nil end
    teamIndex = tonumber(teamIndex)
    for _, raw in ipairs(pitch.goals) do
        local goalBox = GoalShared.NormalizeGoalEntry(raw)
        local defendingTeam = goalBox and GetDefendingTeamForGoal(goalBox.scoringTeam) or 0
        if defendingTeam == teamIndex then
            return BuildGoalkeeperPoint(pitch, goalBox)
        end
    end
    return nil
end

local function VectorToHeading(dx, dy)
    local angle = math.deg(math.atan2(-dx, dy))
    return (angle + 360.0) % 360.0
end

local function CalculateKickoffPositions(lobby)
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.goals or #pitch.goals < 2 then return {} end

    local center = pitch.coords
    local g1 = nil
    local g2 = nil

    for _, raw in ipairs(pitch.goals) do
        local goalBox = GoalShared.NormalizeGoalEntry(raw)
        if goalBox then
            if goalBox.scoringTeam == 2 then -- Defended by Team 1
                g1 = goalBox.center
            elseif goalBox.scoringTeam == 1 then -- Defended by Team 2
                g2 = goalBox.center
            end
        end
    end

    if not g1 or not g2 then
        g1 = pitch.goals[1].center
        g2 = pitch.goals[2].center
    end

    local v1 = g1 - center
    local v2 = g2 - center
    
    local len1 = math.sqrt((v1.x * v1.x) + (v1.y * v1.y) + (v1.z * v1.z))
    local len2 = math.sqrt((v2.x * v2.x) + (v2.y * v2.y) + (v2.z * v2.z))
    
    local u1 = len1 > 0.001 and vector3(v1.x / len1, v1.y / len1, v1.z / len1) or vector3(1.0, 0.0, 0.0)
    local u2 = len2 > 0.001 and vector3(v2.x / len2, v2.y / len2, v2.z / len2) or vector3(-1.0, 0.0, 0.0)

    local p1 = vector3(-u1.y, u1.x, 0.0)
    local p2 = vector3(-u2.y, u2.x, 0.0)

    local spawns = {}

    local t1Players = lobby.team1.players or {}
    local gk1 = tonumber((lobby.goalkeepers or {})[1]) or 0
    
    local outfield1 = {}
    for _, p in ipairs(t1Players) do
        local pSrc = tonumber(p.src)
        if pSrc and pSrc ~= 0 and pSrc ~= gk1 then
            table.insert(outfield1, pSrc)
        end
    end

    local spacing = 2.5
    local offsetDistance = 6.0

    if gk1 ~= 0 then
        local gkPoint = GetGoalkeeperPointForTeam(lobby.pitchId, 1)
        if gkPoint then
            spawns[tostring(gk1)] = {
                coords = gkPoint,
                heading = VectorToHeading(-u1.x, -u1.y)
            }
        end
    end

    local n1 = #outfield1
    for i, pSrc in ipairs(outfield1) do
        local s = (i - (n1 + 1) / 2) * spacing
        local spawnPos = center + (u1 * offsetDistance) + (p1 * s)
        spawns[tostring(pSrc)] = {
            coords = spawnPos,
            heading = VectorToHeading(-u1.x, -u1.y)
        }
    end

    local t2Players = lobby.team2.players or {}
    local gk2 = tonumber((lobby.goalkeepers or {})[2]) or 0

    local outfield2 = {}
    for _, p in ipairs(t2Players) do
        local pSrc = tonumber(p.src)
        if pSrc and pSrc ~= 0 and pSrc ~= gk2 then
            table.insert(outfield2, pSrc)
        end
    end

    if gk2 ~= 0 then
        local gkPoint = GetGoalkeeperPointForTeam(lobby.pitchId, 2)
        if gkPoint then
            spawns[tostring(gk2)] = {
                coords = gkPoint,
                heading = VectorToHeading(-u2.x, -u2.y)
            }
        end
    end

    local n2 = #outfield2
    for i, pSrc in ipairs(outfield2) do
        local s = (i - (n2 + 1) / 2) * spacing
        local spawnPos = center + (u2 * offsetDistance) + (p2 * s)
        spawns[tostring(pSrc)] = {
            coords = spawnPos,
            heading = VectorToHeading(-u2.x, -u2.y)
        }
    end

    return spawns
end

local function GetGoalkeeperPayload(lobby)
    local keepers = {}
    lobby.goalkeepers = lobby.goalkeepers or {}
    for teamIndex = 1, 2 do
        local keeperSrc = tonumber(lobby.goalkeepers[teamIndex]) or 0
        keepers[teamIndex] = {
            src = keeperSrc,
            name = keeperSrc ~= 0 and (GetPlayerName(keeperSrc) or "Kaleci") or nil,
        }
    end
    return keepers
end

local function GetGoalkeeperHoldPayload(lobby)
    local hold = lobby and lobby.goalkeeperHold or nil
    if not hold or not hold.src then
        return { src = 0, team = 0, untilTime = 0 }
    end
    return {
        src = tonumber(hold.src) or 0,
        team = tonumber(hold.team) or 0,
        untilTime = tonumber(hold.untilTime) or 0,
        catchMeta = hold.catchMeta,
    }
end

local function BroadcastGoalkeeperState(lobby)
    if not lobby then return end
    BroadcastToLobby(lobby, 'seoul_soccer:client:GoalkeepersChanged', GetGoalkeeperPayload(lobby))
end

local function BroadcastGoalkeeperHoldState(lobby)
    if not lobby then return end
    BroadcastToLobby(lobby, 'seoul_soccer:client:GoalkeeperHoldChanged', GetGoalkeeperHoldPayload(lobby))
end

local function ClearGoalkeeperHold(lobby, broadcast)
    if not lobby or not lobby.goalkeeperHold then return false end
    lobby.goalkeeperHold = nil
    if broadcast then
        BroadcastGoalkeeperHoldState(lobby)
    end
    return true
end

local function ClearGoalkeeperForPlayer(lobby, src)
    if not lobby or not src then return false end
    lobby.goalkeepers = lobby.goalkeepers or {}
    local changed = false
    for teamIndex = 1, 2 do
        if tonumber(lobby.goalkeepers[teamIndex]) == tonumber(src) then
            lobby.goalkeepers[teamIndex] = nil
            changed = true
        end
    end
    if lobby.goalkeeperHold and tonumber(lobby.goalkeeperHold.src) == tonumber(src) then
        ClearGoalkeeperHold(lobby, true)
    end
    return changed
end

local function ResolveBallSelection(ballSelection)
    local defaultBall = (Config.Balls and Config.Balls[1]) or { id = "classic", model = "p_ld_soc_ball_01" }

    if type(ballSelection) == "number" and Config.Balls and Config.Balls[ballSelection] then
        local selectedBall = Config.Balls[ballSelection]
        return selectedBall.id, selectedBall.model
    end

    if type(ballSelection) == "string" and Config.Balls then
        for _, ball in ipairs(Config.Balls) do
            if tostring(ball.id) == ballSelection then
                return ball.id, ball.model
            end
        end
    end

    return defaultBall.id, defaultBall.model
end

local function SanitizeTeamName(raw, defaultName)
    defaultName = defaultName or "Takim"
    if type(raw) ~= "string" then
        return defaultName
    end
    local s = raw:match("^%s*(.-)%s*$") or ""
    if s == "" then
        return defaultName
    end
    if #s > 48 then
        s = string.sub(s, 1, 48)
    end
    return s
end

--- Lobi \u015fifresi: trim + 32 karakter limit. Bo\u015fsa (veya sadece whitespace) \u015fifresiz.
local function SanitizeLobbyPassword(raw)
    if raw == nil then return "" end
    if type(raw) ~= "string" then
        raw = tostring(raw)
    end
    local s = raw:match("^%s*(.-)%s*$") or ""
    if s == "" then return "" end
    if #s > 32 then
        s = string.sub(s, 1, 32)
    end
    return s
end

local function GetUniformNumberConfig()
    local cfg = Config.UniformNumbers or {}
    local min = math.floor(tonumber(cfg.Min) or 1)
    local max = math.floor(tonumber(cfg.Max) or 10)
    if max < min then max = min end
    local def = math.floor(tonumber(cfg.Default) or max)
    if def < min then def = min end
    if def > max then def = max end
    return min, max, def
end

local function ResolveJerseyNumber(raw)
    local min, max, def = GetUniformNumberConfig()
    local n = tonumber(raw)
    if not n then return def end
    n = math.floor(n)
    if n < min then n = min end
    if n > max then n = max end
    return n
end

local function BuildLobbyPlayerEntry(src, jerseyNumber)
    return {
        src = src,
        name = ResolvePlayerStatsName(src) or GetPlayerName(src) or ("Player " .. tostring(src)),
        jerseyNumber = ResolveJerseyNumber(jerseyNumber),
    }
end

local function RemoveLobbyPlayerBySrc(players, sid)
    if type(players) ~= "table" then return nil end
    for i, p in ipairs(players) do
        if tonumber((p or {}).src) == sid then
            return table.remove(players, i)
        end
    end
    return nil
end

local function RefreshLobbyProximityGrace(lobby)
    if not lobby then return end
    local graceMs = tonumber((Config.PitchBounds or {}).ProximityGraceMs) or 15000
    lobby.pitchProximityGraceUntil = GetNowMs() + graceMs
end

--- Istemciye gonderilecek guvenli lobi kopyasi: password alani cikartilir,
--- bunun yerine `hasPassword` boolean'i eklenir.
local function BuildLobbiesSnapshotForClient()
    local snap = {}
    local privateKeys = {
        password = true,
        paidBySrc = true,
        paidPassportBySrc = true,
        forfeitedBySrc = true,
    }
    for lid, lobby in pairs(Lobbies) do
        if type(lobby) == "table" then
            local copy = {}
            for k, v in pairs(lobby) do
                if not privateKeys[k] then
                    copy[k] = v
                end
            end
            copy.hasPassword = (type(lobby.password) == "string" and lobby.password ~= "")
            snap[lid] = copy
        end
    end
    return snap
end

local LobbyActionCooldowns = {}

local function CheckLobbyActionRate(src, action, cooldownMs)
    src = tonumber(src)
    if not src then return false end
    local now = GetNowMs()
    local key = tostring(src) .. ":" .. tostring(action or "default")
    local untilMs = tonumber(LobbyActionCooldowns[key]) or 0
    if now < untilMs then return false end
    LobbyActionCooldowns[key] = now + math.max(100, tonumber(cooldownMs) or 500)
    return true
end

local function GetSeoulLobbyLimits()
    local cfg = (Config.Seoul and Config.Seoul.Lobby) or {}
    return {
        maxNameLength = math.max(8, math.min(96, math.floor(tonumber(cfg.MaxNameLength) or 64))),
        minDuration = math.max(1, math.floor(tonumber(cfg.MinDurationMinutes) or 1)),
        maxDuration = math.max(1, math.floor(tonumber(cfg.MaxDurationMinutes) or 180)),
        maxTargetGoals = math.max(1, math.floor(tonumber(cfg.MaxTargetGoals) or 99)),
    }
end

local function GetBetLimits()
    local cfg = (Config.Seoul and Config.Seoul.Betting) or {}
    local enabled = cfg.Enabled ~= false
    local min = math.max(0, math.floor(tonumber(cfg.Min) or 0))
    local max = math.max(min, math.floor(tonumber(cfg.Max) or 100000))
    return enabled, min, max
end

local function SanitizeLobbyName(raw)
    local limits = GetSeoulLobbyLimits()
    local name = Trim(tostring(raw or "")):gsub("[%z-]", "")
    if name == "" then return nil end
    if #name > limits.maxNameLength then
        name = string.sub(name, 1, limits.maxNameLength)
    end
    return name
end

local function ResolveValidatedBet(raw)
    local enabled, min, max = GetBetLimits()
    if not enabled then return 0 end
    local amount = math.floor(tonumber(raw) or 0)
    if amount < 0 or amount > max then return nil end
    if amount > 0 and amount < min then return nil end
    return amount
end

local function PayLobbyStoredIdentity(lobby, srcValue, amount)
    amount = math.floor(tonumber(amount) or 0)
    if not lobby or amount <= 0 then return false end
    local key = tostring(srcValue)
    local passport = tonumber((lobby.paidPassportBySrc or {})[key])
    if passport and Bridge.AddMoneyToPassport and Bridge.AddMoneyToPassport(passport, amount) then
        return true
    end
    return Bridge.AddMoney(tonumber(srcValue), amount) == true
end

local function RefundLobbyEntry(lobby, srcValue)
    if not lobby then return false end
    local key = tostring(srcValue)
    local paid = tonumber((lobby.paidBySrc or {})[key]) or 0
    if paid <= 0 then return true end
    if not PayLobbyStoredIdentity(lobby, srcValue, paid) then return false end
    lobby.paidBySrc[key] = nil
    if lobby.paidPassportBySrc then lobby.paidPassportBySrc[key] = nil end
    return true
end

local function RefundAllLobbyEntries(lobby)
    if not lobby then return end
    local keys = {}
    for srcKey in pairs(lobby.paidBySrc or {}) do keys[#keys + 1] = srcKey end
    for _, srcKey in ipairs(keys) do RefundLobbyEntry(lobby, srcKey) end
end

local function MarkLobbyEntryForfeit(lobby, srcValue)
    if not lobby or srcValue == nil then return end
    local key = tostring(srcValue)
    if tonumber((lobby.paidBySrc or {})[key]) and tonumber((lobby.paidBySrc or {})[key]) > 0 then
        lobby.forfeitedBySrc = lobby.forfeitedBySrc or {}
        lobby.forfeitedBySrc[key] = true
    end
end

--- NUI: lobi olusturma basarisiz/basarili (modal optimistik kapanmasin)
local function SendCreateLobbyResultToClient(src, ok, message, lobbyId)
    if not src or src == 0 then return end
    TriggerClientEvent(
        'seoul_soccer:client:CreateLobbyResult',
        src,
        ok == true,
        tostring(message or ""),
        tonumber(lobbyId)
    )
end

--- `format` "6 vs 6" gibi ise takim basina limit; parse edilemezse limit yok
local function ParseLobbyFormat(raw)
    local fmt = type(raw) == "string" and raw or ""
    local n, m = string.match(fmt, "(%d+)%s*%-?%s*[vV][sS]%s*%-?%s*(%d+)")
    n, m = tonumber(n), tonumber(m)
    if n and m and n >= 1 and n <= 11 and m >= 1 and m <= 11 then
        return math.floor(n), math.floor(m)
    end
    return nil, nil
end

local function GetLobbyTeamCapacityCaps(lobby)
    if not lobby then return nil, nil end
    return ParseLobbyFormat(lobby.format)
end

local function WouldExceedTeamCapacity(lobby, teamIndex, countAfterAdd)
    local cap1, cap2 = GetLobbyTeamCapacityCaps(lobby)
    local cap = (teamIndex == 1) and cap1 or cap2
    if not cap then return false end
    return (tonumber(countAfterAdd) or 0) > cap
end

local function PickPrimaryLobbyForStadiumScoreboard()
    local order = { "playing", "paused", "warmup", "countdown", "waiting" }
    for _, want in ipairs(order) do
        local bestId, bestLobby = nil, nil
        for id, lobby in pairs(Lobbies) do
            if lobby.state == want then
                local lid = tonumber(id) or 0
                if not bestId or lid < bestId then
                    bestId = lid
                    bestLobby = lobby
                end
            end
        end
        if bestLobby then
            return bestLobby
        end
    end
    return nil
end

local function StadiumScoreboardPeriodLabel(key, fallback)
    local locKey = ("scoreboard.periods.%s"):format(key)
    local fb = Config.FootballScoreboard or {}
    local labels = fb.PeriodLabels or {}
    return LOr(locKey, labels[key] or fallback)
end

local function BuildStadiumScoreboardPayloadFromLobby(lobby)
    local st = tostring(lobby.state or "")
    local totalSec = math.max(60, math.floor(tonumber(lobby.duration) or 20) * 60)
    local timeLeft = math.max(0, math.floor(tonumber(lobby.timeLeft) or 0))
    local elapsed = math.max(0, totalSec - timeLeft)
    local timeStr
    local period
    local status

    if st == "waiting" then
        elapsed = 0
        timeStr = "--:--"
        period = StadiumScoreboardPeriodLabel("waiting", "LOBBY")
        status = LOr("scoreboard.status.lobby", "Lobby")
    elseif st == "warmup" then
        timeStr = ("%02d:%02d"):format(math.floor(timeLeft / 60), timeLeft % 60)
        period = StadiumScoreboardPeriodLabel("warmup", "WARMUP")
        status = LOr("scoreboard.status.warmup", "Warmup")
    elseif st == "countdown" then
        timeStr = ("%02d:%02d"):format(math.floor(timeLeft / 60), timeLeft % 60)
        period = StadiumScoreboardPeriodLabel("countdown", "KICK OFF")
        status = LOr("scoreboard.status.countdown", "Countdown")
    elseif st == "paused" then
        timeStr = ("%02d:%02d"):format(math.floor(timeLeft / 60), timeLeft % 60)
        period = StadiumScoreboardPeriodLabel("paused", "PAUSED")
        status = LOr("scoreboard.status.paused", "Paused")
    elseif st == "playing" then
        timeStr = ("%02d:%02d"):format(math.floor(timeLeft / 60), timeLeft % 60)
        if elapsed < totalSec * 0.5 then
            period = StadiumScoreboardPeriodLabel("first_half", "FIRST HALF")
        else
            period = StadiumScoreboardPeriodLabel("second_half", "SECOND HALF")
        end
        status = LOr("scoreboard.status.live", "Live")
    else
        timeStr = "--:--"
        period = StadiumScoreboardPeriodLabel("ended", "ENDED")
        status = LOr("scoreboard.status.ended", "Ended")
    end

    return {
        homeName = lobby.team1 and lobby.team1.name or LOr("defaults.team1_name", "Red Team"),
        awayName = lobby.team2 and lobby.team2.name or LOr("defaults.team2_name", "Blue Team"),
        homeScore = tonumber(lobby.team1 and lobby.team1.score) or 0,
        awayScore = tonumber(lobby.team2 and lobby.team2.score) or 0,
        time = timeStr,
        period = period,
        status = status,
        state = st,
        elapsedSeconds = elapsed,
        totalSeconds = totalSec,
        timeLeft = timeLeft,
        active = true,
    }
end

local function SyncStadiumScoreboard(targetSrc)
    local fb = Config.FootballScoreboard or {}
    if fb.Enabled == false then return end
    if fb.ScoreboardDriver == "standalone" then return end

    local lobby = PickPrimaryLobbyForStadiumScoreboard()
    if not lobby then
        if targetSrc then
            TriggerClientEvent("football:scoreboardStandby", targetSrc)
        else
            TriggerClientEvent("football:scoreboardStandby", -1)
        end
        TriggerEvent("football:server:ingest", {
            screenOff = true,
            active = false,
            state = "idle",
            status = LOr("scoreboard.status.standby", "Standby"),
        })
        return
    end

    local payload = BuildStadiumScoreboardPayloadFromLobby(lobby)
    if targetSrc then
        TriggerClientEvent("football:syncState", targetSrc, payload)
    else
        TriggerClientEvent("football:syncState", -1, payload)
    end
    TriggerEvent("football:server:ingest", payload)
end

local function BroadcastLobbiesSync(targetSrc)
    local snap = BuildLobbiesSnapshotForClient()
    if targetSrc then
        TriggerClientEvent('seoul_soccer:client:SyncLobbies', targetSrc, snap)
    else
        TriggerClientEvent('seoul_soccer:client:SyncLobbies', -1, snap)
    end
    TriggerEvent('seoul_soccer:internal:TabletSync')
    SyncStadiumScoreboard(targetSrc)
end

--- Menu acikken canli skor / kalan sure (oyuncu lobide olmasa da).
local function BroadcastLobbyMenuLiveTick(lobbyId)
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local l = Lobbies[lobbyId]
    if not l then return end
    local st = tostring(l.state or "")
    if st ~= "warmup" and st ~= "countdown" and st ~= "playing" and st ~= "paused" then
        return
    end
    TriggerClientEvent('seoul_soccer:client:LobbyMenuLiveTick', -1, {
        id       = lobbyId,
        state    = st,
        timeLeft = tonumber(l.timeLeft) or 0,
        score1   = tonumber(l.team1 and l.team1.score) or 0,
        score2   = tonumber(l.team2 and l.team2.score) or 0,
    })
    TriggerEvent('seoul_soccer:internal:TabletTick', lobbyId)
end

local function GetModelHash(modelName)
    if type(modelName) == "number" then
        return modelName
    end

    if joaat then
        return joaat(modelName)
    end

    if GetHashKey then
        return GetHashKey(modelName)
    end

    return nil
end

local function IsModelUsable(modelHash)
    if not modelHash or modelHash == 0 then
        return false
    end

    -- Bazı native'ler server runtime'da bulunmayabilir.
    if IsModelInCdimage and not IsModelInCdimage(modelHash) then
        return false
    end

    if IsModelValid and not IsModelValid(modelHash) then
        return false
    end

    return true
end

local function IsEntityHandleValid(entity)
    if not entity or entity == 0 then
        return false
    end
    if DoesEntityExist then
        return DoesEntityExist(entity)
    end
    return true
end

local function TryCallEntityNative(entity, nativeFn, ...)
    if not nativeFn then return false end
    if not IsEntityHandleValid(entity) then return false end
    local ok = pcall(nativeFn, entity, ...)
    return ok
end

local function GetPlayerPedSafe(src)
    if not GetPlayerPed then return 0 end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return 0 end
    if DoesEntityExist and not DoesEntityExist(ped) then return 0 end
    return ped
end

local function CanValidateStealOnServer()
    return GetPlayerPed and GetEntityCoords
end

--- FAIL-CLOSED yardimci: server native'leri yoksa "dogrulanamadi" kabul edilir (reject).
--- Native'ler normalde mevcut; yoksa guvenligi oyunculuk kolayligina tercih et.
local function IsWithinStealDistance(ownerSrc, attackerSrc, maxDistance)
    if not CanValidateStealOnServer() then
        return false
    end

    local ownerPed = GetPlayerPedSafe(ownerSrc)
    local attackerPed = GetPlayerPedSafe(attackerSrc)
    if ownerPed == 0 or attackerPed == 0 then
        return false
    end

    local ownerPos = GetEntityCoords(ownerPed)
    local attackerPos = GetEntityCoords(attackerPed)
    if not ownerPos or not attackerPos then
        return false
    end

    local dx = attackerPos.x - ownerPos.x
    local dy = attackerPos.y - ownerPos.y
    local dist2D = math.sqrt((dx * dx) + (dy * dy))
    return dist2D <= maxDistance
end

local function GetPlayerSpeedSafe(src)
    if not GetEntitySpeed then return nil end
    local ped = GetPlayerPedSafe(src)
    if ped == 0 then return nil end
    local ok, speed = pcall(GetEntitySpeed, ped)
    if not ok then return nil end
    return tonumber(speed)
end

--- Calmada: hirsizin ped'i ile top entity arasinda 3D mesafe.
--- Top entity yoksa (streaming / desync) "unknown" (nil) doner; cagiran taraf fallback uygular
--- (genellikle sahip-hirsiz ped mesafesine duser). Fail-closed politikasi: native eksikse false.
local function IsAttackerCloseToBallForSteal(lobby, attackerSrc, maxDist, zTol)
    maxDist = tonumber(maxDist) or 1.35
    zTol = tonumber(zTol) or 1.2
    if not lobby or not CanValidateStealOnServer() then
        return false
    end
    local ent = lobby.ballEntity
    if not ent or not IsEntityHandleValid(ent) then
        -- Top entity yok: bilinmiyor. Caller ped-ped fallback'e donsun.
        return nil
    end
    local ped = GetPlayerPedSafe(attackerSrc)
    if ped == 0 then
        return false
    end
    local okB, ballPos = pcall(GetEntityCoords, ent)
    local okP, pPos = pcall(GetEntityCoords, ped)
    if not okB or not okP or not ballPos or not pPos then
        return false
    end
    local dx = pPos.x - ballPos.x
    local dy = pPos.y - ballPos.y
    local dz = pPos.z - ballPos.z
    local dxy = math.sqrt((dx * dx) + (dy * dy))
    return (dxy <= maxDist) and (math.abs(dz) <= zTol)
end

--- Hard slide: kayma dogrultusu (XY, istemci slideDir) top veya sahip ped'e ne kadar hizali (max dot).
--- minDot <= 0 kontrol yok. Yan bosluga kayma (hedefe dik) dusuk dot verir.
local function HardStealSlideEngagesTarget(slideCfg, attackerSrc, ownerSrc, lobby, slideDirX, slideDirY)
    local minDot = tonumber(slideCfg and slideCfg.HardStealEngageMinDot) or 0
    if minDot <= 0 then return true end
    local fx = tonumber(slideDirX)
    local fy = tonumber(slideDirY)
    if fx == nil or fy == nil then return true end
    local fl = math.sqrt(fx * fx + fy * fy)
    if fl < 0.08 then return true end
    fx, fy = fx / fl, fy / fl

    if not lobby or not CanValidateStealOnServer() then return false end
    local atkPed = GetPlayerPedSafe(attackerSrc)
    if atkPed == 0 then return false end
    local okA, aPos = pcall(GetEntityCoords, atkPed)
    if not okA or not aPos then return false end

    local function dotToward(tx, ty)
        local dx, dy = tx - aPos.x, ty - aPos.y
        local dl = math.sqrt(dx * dx + dy * dy)
        if dl < 0.05 then return -1.0 end
        return (fx * dx + fy * dy) / dl
    end

    local best = -1.0
    local ent = lobby.ballEntity
    if ent and IsEntityHandleValid(ent) then
        local okB, bPos = pcall(GetEntityCoords, ent)
        if okB and bPos then
            best = math.max(best, dotToward(bPos.x, bPos.y))
        end
    end
    if ownerSrc and ownerSrc ~= 0 then
        local oPed = GetPlayerPedSafe(ownerSrc)
        if oPed ~= 0 then
            local okO, oPos = pcall(GetEntityCoords, oPed)
            if okO and oPos then
                best = math.max(best, dotToward(oPos.x, oPos.y))
            end
        end
    end
    return best >= minDot
end

local function NormalizeFlatXY(x, y)
    x = tonumber(x) or 0.0
    y = tonumber(y) or 0.0
    local l = math.sqrt(x * x + y * y)
    if l < 0.05 then return nil end
    return x / l, y / l
end

--- Hard steal heading ekseni: "slide" = istemci slideDir, "ped" = saldirgan ped forward (XY).
local function HardStealGetAxisFlatXY(attackerSrc, slideCfg, slideDirX, slideDirY)
    local axis = tostring(slideCfg and slideCfg.HardStealHeadingAxis or "slide"):lower()
    if axis == "ped" then
        if not GetEntityForwardVector then return nil end
        local ped = GetPlayerPedSafe(attackerSrc)
        if ped == 0 then return nil end
        local ok, f = pcall(GetEntityForwardVector, ped)
        if not ok or not f then return nil end
        return NormalizeFlatXY(f.x, f.y)
    end
    return NormalizeFlatXY(slideDirX, slideDirY)
end

--- Hedef (tx,ty) saldirgan etrafinda heading ekseninde ileri + yanal slab icinde mi?
local function HardStealInHeadingSlab(attackerSrc, tx, ty, slideCfg, slideDirX, slideDirY)
    if not CanValidateStealOnServer() then return false end
    local ped = GetPlayerPedSafe(attackerSrc)
    if ped == 0 then return false end
    local okP, aPos = pcall(GetEntityCoords, ped)
    if not okP or not aPos then return false end
    local fx, fy = HardStealGetAxisFlatXY(attackerSrc, slideCfg, slideDirX, slideDirY)
    if not fx or not fy then return false end
    local vx, vy = tx - aPos.x, ty - aPos.y
    local along = vx * fx + vy * fy
    local lateral = math.abs(vx * (-fy) + vy * fx)
    local alongMax = tonumber(slideCfg.HardStealHeadingAlongMax) or 3.55
    local latMax = tonumber(slideCfg.HardStealHeadingLateralMax) or 1.52
    local behind = tonumber(slideCfg.HardStealHeadingBehindAllow) or 0.42
    if along < -behind - 0.02 then return false end
    if along > alongMax + 0.02 then return false end
    if lateral > latMax + 0.02 then return false end
    return true
end

--- Hard steal: top mesafe + Z (heading veya daire).
local function IsHardStealBallCloseServer(lobby, attackerSrc, slideCfg, slideDirX, slideDirY, zTolHard)
    if slideCfg.HardStealUseHeadingDistance == false then
        local hardStealDist = tonumber(slideCfg.StealDistance) or 2.15
        local hardBallDist = tonumber(slideCfg.HardStealBallDistance) or hardStealDist
        local extraBall = tonumber(slideCfg.ServerHardBallExtraTol) or 0.28
        return IsAttackerCloseToBallForSteal(lobby, attackerSrc, hardBallDist + extraBall, zTolHard)
    end
    local ent = lobby.ballEntity
    if not ent or not IsEntityHandleValid(ent) then
        return nil
    end
    local ped = GetPlayerPedSafe(attackerSrc)
    if ped == 0 then return false end
    local okB, bPos = pcall(GetEntityCoords, ent)
    local okP, pPos = pcall(GetEntityCoords, ped)
    if not okB or not okP or not bPos or not pPos then return false end
    if not HardStealInHeadingSlab(attackerSrc, bPos.x, bPos.y, slideCfg, slideDirX, slideDirY) then
        return false
    end
    local dz = math.abs((pPos.z or 0.0) - (bPos.z or 0.0))
    return dz <= zTolHard
end

--- Hard steal: sahip ped XY (heading veya daire).
local function IsHardStealOwnerCloseServer(ownerSrc, attackerSrc, slideCfg, slideDirX, slideDirY, hardOwnerTol)
    if slideCfg.HardStealUseHeadingDistance == false then
        return IsWithinStealDistance(ownerSrc, attackerSrc, hardOwnerTol)
    end
    local oPed = GetPlayerPedSafe(ownerSrc)
    if oPed == 0 then return false end
    local okO, oPos = pcall(GetEntityCoords, oPed)
    if not okO or not oPos then return false end
    return HardStealInHeadingSlab(attackerSrc, oPos.x, oPos.y, slideCfg, slideDirX, slideDirY)
end

--- Arkadan slide mudahale tespiti: saldirgan sahip forward'inin TERSINDEN geliyorsa true.
--- Dot(owner.forward, normalize(attacker - owner)) < threshold (-0.3 tipik).
local function IsSlideFromBehind(ownerSrc, attackerSrc, dotThreshold)
    if not GetEntityForwardVector or not CanValidateStealOnServer() then return false end
    local ownerPed = GetPlayerPedSafe(ownerSrc)
    local attackerPed = GetPlayerPedSafe(attackerSrc)
    if ownerPed == 0 or attackerPed == 0 then return false end
    local ownerPos = GetEntityCoords(ownerPed)
    local attackerPos = GetEntityCoords(attackerPed)
    if not ownerPos or not attackerPos then return false end
    local dx = attackerPos.x - ownerPos.x
    local dy = attackerPos.y - ownerPos.y
    local dist = math.sqrt((dx * dx) + (dy * dy))
    if dist < 0.001 then return false end
    local fwd = GetEntityForwardVector(ownerPed)
    if not fwd then return false end
    local fwdLen = math.sqrt((fwd.x * fwd.x) + (fwd.y * fwd.y))
    if fwdLen < 0.001 then return false end
    local dot = ((dx / dist) * (fwd.x / fwdLen)) + ((dy / dist) * (fwd.y / fwdLen))
    return dot < (tonumber(dotThreshold) or -0.3)
end

--- Hard slide sonrasi top firlatma: XY duzlemde yon. Client kayma dogrultusunu (slideDirX/Y)
--- gonderir; sunucuda yeterli XY hiz varken client yonu hiz vektoru ile uyusmuyorsa hiz tercih edilir.
local function ResolveHardSlideLooseDir(clientSlideX, clientSlideY, atkPed)
    local vx, vy = nil, nil
    if atkPed and atkPed ~= 0 and GetEntityVelocity then
        local ok, vel = pcall(GetEntityVelocity, atkPed)
        if ok and vel then
            vx = tonumber(vel.x) or 0.0
            vy = tonumber(vel.y) or 0.0
        end
    end
    local vLenSq = ((vx or 0.0) * (vx or 0.0)) + ((vy or 0.0) * (vy or 0.0))
    local vLen = math.sqrt(math.max(0.0, vLenSq))

    local cx = tonumber(clientSlideX)
    local cy = tonumber(clientSlideY)
    if cx ~= nil and cy ~= nil then
        local cLenSq = cx * cx + cy * cy
        if cLenSq > 0.0001 then
            local cInv = 1.0 / math.sqrt(cLenSq)
            local cnx, cny = cx * cInv, cy * cInv
            if vLen >= 0.85 then
                local vnx, vny = vx / vLen, vy / vLen
                local dot = cnx * vnx + cny * vny
                if dot < 0.35 then
                    return vnx, vny
                end
            end
            return cnx, cny
        end
    end

    if vLen >= 0.35 then
        return vx / vLen, vy / vLen
    end

    if atkPed and atkPed ~= 0 and GetEntityForwardVector then
        local f = GetEntityForwardVector(atkPed)
        if f then
            local fx, fy = tonumber(f.x) or 0.0, tonumber(f.y) or 0.0
            local fLenSq = fx * fx + fy * fy
            if fLenSq > 0.0001 then
                local finv = 1.0 / math.sqrt(fLenSq)
                return fx * finv, fy * finv
            end
        end
    end
    return 1.0, 0.0
end

local function IsBlockedByFrontShield(ownerSrc, attackerSrc, stealCfg)
    local shield = (stealCfg and stealCfg.FrontShield) or {}
    if not shield.Enabled then return false end
    if not GetEntityForwardVector then return false end
    if not CanValidateStealOnServer() then return false end

    local ownerPed = GetPlayerPedSafe(ownerSrc)
    local attackerPed = GetPlayerPedSafe(attackerSrc)
    if ownerPed == 0 or attackerPed == 0 then return false end

    local ownerPos = GetEntityCoords(ownerPed)
    local attackerPos = GetEntityCoords(attackerPed)
    if not ownerPos or not attackerPos then return false end

    local dx = attackerPos.x - ownerPos.x
    local dy = attackerPos.y - ownerPos.y
    local distance = math.sqrt((dx * dx) + (dy * dy))
    local maxDistance = tonumber(shield.MaxDistance) or 1.65
    if distance > maxDistance then return false end
    if distance < 0.001 then return true end

    local forward = GetEntityForwardVector(ownerPed)
    if not forward then return false end
    local fwdLen = math.sqrt((forward.x * forward.x) + (forward.y * forward.y))
    if fwdLen < 0.001 then return false end

    local dirX = dx / distance
    local dirY = dy / distance
    local fwdX = forward.x / fwdLen
    local fwdY = forward.y / fwdLen
    local dot = (dirX * fwdX) + (dirY * fwdY)
    local dotThreshold = tonumber(shield.DotThreshold) or 0.12

    return dot >= dotThreshold
end

--- Top spawn / gol sonrasi merkez: zemin yuksekligi (sunucuda native varsa)
local function ServerProbeGroundZ(x, y, probeZ)
    if not GetGroundZFor_3dCoord then return nil end
    local ok, a, b = pcall(GetGroundZFor_3dCoord, x + 0.0, y + 0.0, probeZ + 0.0, false)
    if not ok then return nil end
    if a == true and type(b) == "number" then return b end
    if type(a) == "number" then return a end
    return nil
end

local function ResolveBallSpawnZForPitchXY(pitch, x, y)
    if not pitch or not pitch.coords then return 0.0 end
    local c = pitch.coords
    local fallback = c.z + 0.02
    local gd = Config.GoalDetection or {}
    if gd.BallSpawnUseGroundProbe == false then return fallback end
    if RequestCollisionAtCoord then
        pcall(RequestCollisionAtCoord, x + 0.0, y + 0.0, c.z + 0.0)
    end
    local offset = tonumber(gd.BallGroundProbeZOffset) or 120.0
    local bump = tonumber(gd.BallSpawnAboveGround) or 0.14
    local band = tonumber(gd.BallSpawnGroundZSaneBand) or 35.0

    local gz = ServerProbeGroundZ(x, y, c.z + offset)
    if not gz or gz < -200.0 or gz > 1500.0 then
        gz = ServerProbeGroundZ(x, y, 2000.0)
    end
    if not gz or gz < -200.0 or gz > 1500.0 then
        return fallback
    end

    local dz = gz - c.z
    -- pitch.coords.z saha isaretinden yukarida kalabiliyor; gercek zemin asagida band disinda kalir.
    local useGround = (math.abs(dz) <= band) or (gz < c.z - 1.0) or (gz <= c.z + 0.85)
    -- Isaret havada, GetGroundZ belirgin sekilde asagida: eski mantik reddedip fallback'e dusmesin.
    if gz < c.z - 0.35 then
        useGround = true
    end
    if not useGround then
        return fallback
    end

    return gz + bump
end

--- Sunucu: carpisma yuklendikten sonra X,Y'de gercek zemin + bump (warmup/countdown spawn).
local function ServerFinalizeBallGroundZ(entity, x, y, pitch)
    if not entity or entity == 0 or not IsEntityHandleValid(entity) or not pitch or not pitch.coords then return end
    local gd = Config.GoalDetection or {}
    local bump = tonumber(gd.BallSpawnAboveGround) or 0.14
    local baseZ = pitch.coords.z or 0.0

    if RequestCollisionAtCoord then
        pcall(RequestCollisionAtCoord, x + 0.0, y + 0.0, baseZ + 80.0)
    end

    local function medianGroundZ()
        local candidates = {}
        for _, probe in ipairs({ baseZ + 420.0, baseZ + 140.0, 1800.0, 950.0, baseZ + 35.0 }) do
            local gz = ServerProbeGroundZ(x, y, probe)
            if gz and gz > -200.0 and gz < 1600.0 then
                candidates[#candidates + 1] = gz
            end
        end
        if #candidates == 0 then return nil end
        table.sort(candidates)
        return candidates[math.ceil(#candidates * 0.5)]
    end

    local zPut = baseZ + 0.02
    for attempt = 1, 8 do
        Wait(attempt == 1 and 55 or 40)
        local gz = medianGroundZ()
        if gz then
            zPut = gz + bump
            break
        end
    end

    if SetEntityCoordsNoOffset then
        TryCallEntityNative(entity, SetEntityCoordsNoOffset, x + 0.0, y + 0.0, zPut, false, false, false)
    elseif SetEntityCoords then
        TryCallEntityNative(entity, SetEntityCoords, x + 0.0, y + 0.0, zPut, false, false, false, false)
    end
    TryCallEntityNative(entity, SetEntityVelocity, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then
        TryCallEntityNative(entity, SetEntityAngularVelocity, 0.0, 0.0, 0.0)
    end

    if PlaceObjectOnGroundProperly and DoesEntityExist and DoesEntityExist(entity) then
        pcall(PlaceObjectOnGroundProperly, entity)
        Wait(0)
        local okp, pos = pcall(GetEntityCoords, entity)
        if okp and pos then
            local zAfter = pos.z + bump * 0.35
            if zAfter < zPut + 0.55 then
                if SetEntityCoordsNoOffset then
                    TryCallEntityNative(entity, SetEntityCoordsNoOffset, x + 0.0, y + 0.0, zAfter, false, false, false)
                elseif SetEntityCoords then
                    TryCallEntityNative(entity, SetEntityCoords, x + 0.0, y + 0.0, zAfter, false, false, false, false)
                end
            end
        end
    end

    -- Son kontrol: merkez XY'de top hala zeminden kopuksa (match / countdown basi) bir prob daha.
    local okp, pNow = pcall(GetEntityCoords, entity)
    if okp and pNow then
        local gzSnap = ServerProbeGroundZ(x, y, pNow.z + 160.0)
        if not gzSnap or gzSnap < -200.0 then
            gzSnap = ServerProbeGroundZ(x, y, 950.0)
        end
        if gzSnap and gzSnap > -200.0 and gzSnap < 1600.0 then
            local wantZ = gzSnap + bump
            if pNow.z > wantZ + 0.16 then
                if SetEntityCoordsNoOffset then
                    TryCallEntityNative(entity, SetEntityCoordsNoOffset, x + 0.0, y + 0.0, wantZ, false, false, false)
                elseif SetEntityCoords then
                    TryCallEntityNative(entity, SetEntityCoords, x + 0.0, y + 0.0, wantZ, false, false, false, false)
                end
            end
        end
    end

    TryCallEntityNative(entity, SetEntityVelocity, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then
        TryCallEntityNative(entity, SetEntityAngularVelocity, 0.0, 0.0, 0.0)
    end
end

local function CleanupLobbyBall(lobby)
    if not lobby then return end
    lobby.ballOwner = nil
    lobby.ownerProtectionUntil = 0
    lobby.stealAttemptCooldowns = {}
    lobby.hardStealAttemptCooldowns = {}
    lobby.standTackleAttemptCooldowns = {}
    lobby.hardStealVictimNoClaimUntil = {}
    lobby.hardStealBlockedVictim = 0
    lobby.hardStealBlockedVictimUntil = 0
    local ent = lobby.ballEntity
    if ent and ent ~= 0 then
        if DeleteEntity then
            pcall(DeleteEntity, ent)
        elseif DeleteObject then
            pcall(DeleteObject, ent)
        end
    end
    lobby.ballEntity = nil
end

local function RemoveDuplicateSoccerBallsNearPitch(lobby)
    if not lobby or not IsEntityHandleValid(lobby.ballEntity) then return end
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return end
    local c = pitch.coords
    local modelHash = GetModelHash(lobby.ballModel or "p_ld_soc_ball_01")
    if not IsModelUsable(modelHash) then
        modelHash = GetModelHash("p_ld_soc_ball_01")
    end
    if not IsModelUsable(modelHash) then return end
    local keep = lobby.ballEntity
    local radius = math.max((tonumber(pitch.radius) or 50.0) * 2.75, 24.0)

    if GetGamePool and GetEntityModel and GetEntityCoords and DeleteEntity then
        local okPool, pool = pcall(function()
            return GetGamePool("CObject")
        end)
        if okPool and type(pool) == "table" then
            for _, e in ipairs(pool) do
                if e and e ~= 0 and e ~= keep then
                    local okM, m = pcall(GetEntityModel, e)
                    if okM and m == modelHash then
                        local okP, pos = pcall(GetEntityCoords, e)
                        if okP and pos then
                            local dx = pos.x - c.x
                            local dy = pos.y - c.y
                            local dz = pos.z - c.z
                            local d = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                            if d <= radius then
                                pcall(DeleteEntity, e)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function SpawnLobbyBall(lobby)
    if not lobby then return end

    CleanupLobbyBall(lobby)

    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return end

    local modelHash = GetModelHash(lobby.ballModel or "p_ld_soc_ball_01")
    if not IsModelUsable(modelHash) then
        modelHash = GetModelHash("p_ld_soc_ball_01")
    end

    if not IsModelUsable(modelHash) then
        return
    end

    local c = pitch.coords
    local spawnZ = ResolveBallSpawnZForPitchXY(pitch, c.x, c.y)

    local ballEntity = nil
    if CreateObject then
        ballEntity = CreateObject(modelHash, c.x, c.y, spawnZ, true, true, false)
    elseif CreateObjectNoOffset then
        ballEntity = CreateObjectNoOffset(modelHash, c.x, c.y, spawnZ, true, true, false)
    else
        return
    end

    if not ballEntity or ballEntity == 0 then
        return
    end

    if DoesEntityExist then
        local timeoutAt = GetGameTimer() + 500
        while not DoesEntityExist(ballEntity) and GetGameTimer() < timeoutAt do
            Wait(0)
        end
    end

    if not IsEntityHandleValid(ballEntity) then
        if ballEntity and ballEntity ~= 0 and DeleteEntity then
            pcall(DeleteEntity, ballEntity)
        end
        return
    end

    TryCallEntityNative(ballEntity, SetEntityAsMissionEntity, true, true)
    TryCallEntityNative(ballEntity, SetEntityDynamic, true)
    TryCallEntityNative(ballEntity, SetEntityCollision, true, true)

    if SetEntityCoords then
        TryCallEntityNative(ballEntity, SetEntityCoords, c.x, c.y, spawnZ, false, false, false, false)
    elseif SetEntityCoordsNoOffset then
        TryCallEntityNative(ballEntity, SetEntityCoordsNoOffset, c.x, c.y, spawnZ, false, false, false)
    end

    ServerFinalizeBallGroundZ(ballEntity, c.x, c.y, pitch)

    TryCallEntityNative(ballEntity, SetEntityHeading, 0.0)

    local bs = Config.BallStreaming or {}
    local lodDist = math.floor(tonumber(bs.LodDist) or 65535)
    local cullRadius = tonumber(bs.CullingRadius) or 15000.0
    TryCallEntityNative(ballEntity, SetEntityLodDist, lodDist)
    TryCallEntityNative(ballEntity, SetEntityDistanceCullingRadius, cullRadius)

    if NetworkGetNetworkIdFromEntity and IsEntityHandleValid(ballEntity) then
        local ok, ballNetIdValue = pcall(NetworkGetNetworkIdFromEntity, ballEntity)
        local ballNetId = ok and (ballNetIdValue or 0) or 0
        if ballNetId ~= 0 then
            -- true: top rastgele istemciye "migrate" olup konum senkronu bozulabiliyordu.
            if SetNetworkIdCanMigrate then
                SetNetworkIdCanMigrate(ballNetId, false)
            end
            if SetNetworkIdExistsOnAllMachines then
                SetNetworkIdExistsOnAllMachines(ballNetId, true)
            end
            if NetworkSetNetworkIdDynamic then
                NetworkSetNetworkIdDynamic(ballNetId, false)
            end
            lobby.ballNetId = ballNetId
        end
    end

    lobby.ballEntity = ballEntity
    RemoveDuplicateSoccerBallsNearPitch(lobby)
end

local function PlaceLobbyBallAtCenter(lobby)
    if not lobby then return end
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return end

    if not IsEntityHandleValid(lobby.ballEntity) then
        SpawnLobbyBall(lobby)
    end
    if not IsEntityHandleValid(lobby.ballEntity) then return end

    local c = pitch.coords
    local roughZ = ResolveBallSpawnZForPitchXY(pitch, c.x, c.y)

    if RequestCollisionAtCoord then
        pcall(RequestCollisionAtCoord, c.x + 0.0, c.y + 0.0, (c.z or 0.0) + 80.0)
    end

    if SetEntityCoordsNoOffset then
        TryCallEntityNative(lobby.ballEntity, SetEntityCoordsNoOffset, c.x, c.y, roughZ, false, false, false)
    elseif SetEntityCoords then
        TryCallEntityNative(lobby.ballEntity, SetEntityCoords, c.x, c.y, roughZ, false, false, false, false)
    end

    TryCallEntityNative(lobby.ballEntity, SetEntityDynamic, true)
    TryCallEntityNative(lobby.ballEntity, SetEntityCollision, true, true)
    TryCallEntityNative(lobby.ballEntity, SetEntityHeading, 0.0)
    TryCallEntityNative(lobby.ballEntity, SetEntityVelocity, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then
        TryCallEntityNative(lobby.ballEntity, SetEntityAngularVelocity, 0.0, 0.0, 0.0)
    end

    ServerFinalizeBallGroundZ(lobby.ballEntity, c.x, c.y, pitch)

    RemoveDuplicateSoccerBallsNearPitch(lobby)
end

--- Top pitch merkezinden cok uzaklastiginda: mevcut entity silinir, merkezde yeni top spawn (ag netId guncellenir).
local function RespawnLobbyBallAtCenterFromOob(lobby)
    if not lobby then return end
    SpawnLobbyBall(lobby)
    Wait(0)
    if IsEntityHandleValid(lobby.ballEntity) then
        PlaceLobbyBallAtCenter(lobby)
    end
end

local function UnfreezeLobbyBallBeforeCenterSpawn(lobby)
    if not lobby or not IsEntityHandleValid(lobby.ballEntity) then return end
    if FreezeEntityPosition then
        TryCallEntityNative(lobby.ballEntity, FreezeEntityPosition, false)
    end
end

--- Gol aninda top havada yakalanmissa XY korunarak zemine oturtulur.
local function SnapLobbyBallToGroundAtCurrentXY(lobby, entity)
    entity = entity or (lobby and lobby.ballEntity)
    if not lobby or not IsEntityHandleValid(entity) then return false end
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return false end

    UnfreezeLobbyBallBeforeCenterSpawn(lobby)

    local ok, pos = pcall(GetEntityCoords, entity)
    if not ok or not pos then return false end

    local x, y = pos.x + 0.0, pos.y + 0.0
    local gd = Config.GoalDetection or {}
    local bump = tonumber(gd.BallSpawnAboveGround) or 0.14
    local baseZ = pitch.coords.z or 0.0

    if RequestCollisionAtCoord then
        pcall(RequestCollisionAtCoord, x, y, baseZ + 80.0)
    end

    local gz = ServerProbeGroundZ(x, y, pos.z + 160.0)
    if not gz or gz < -200.0 then
        gz = ServerProbeGroundZ(x, y, 950.0)
    end
    if not gz or gz < -200.0 then
        gz = ServerProbeGroundZ(x, y, baseZ + 120.0)
    end
    if not gz or gz < -200.0 then
        gz = baseZ
    end

    local zPut = gz + bump
    if SetEntityCoordsNoOffset then
        TryCallEntityNative(entity, SetEntityCoordsNoOffset, x, y, zPut, false, false, false)
    elseif SetEntityCoords then
        TryCallEntityNative(entity, SetEntityCoords, x, y, zPut, false, false, false, false)
    end

    if PlaceObjectOnGroundProperly and DoesEntityExist and DoesEntityExist(entity) then
        pcall(PlaceObjectOnGroundProperly, entity)
    end

    TryCallEntityNative(entity, SetEntityVelocity, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then
        TryCallEntityNative(entity, SetEntityAngularVelocity, 0.0, 0.0, 0.0)
    end
    return true
end

local function IsLobbyBallNearGround(lobby, entity, maxAbove)
    entity = entity or (lobby and lobby.ballEntity)
    if not lobby or not IsEntityHandleValid(entity) then return false end
    local ok, pos = pcall(GetEntityCoords, entity)
    if not ok or not pos then return false end
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch then return false end
    local gz = ServerProbeGroundZ(pos.x, pos.y, pos.z + 80.0)
    if not gz or gz < -200.0 then
        gz = ServerProbeGroundZ(pos.x, pos.y, (pitch.coords and pitch.coords.z or 0.0) + 120.0)
    end
    if not gz or gz < -200.0 then return false end
    return (pos.z - gz) <= (tonumber(maxAbove) or 0.45)
end

--- Gol sonrasi: top havada dondurulmaz; once duser, zeminde sabitlenir (BallResetDelayMs sonra merkeze).
local function ParkLobbyBallAfterGoal(lobby)
    if not lobby or not IsEntityHandleValid(lobby.ballEntity) then return end

    UnfreezeLobbyBallBeforeCenterSpawn(lobby)
    if SetEntityAngularVelocity then
        TryCallEntityNative(lobby.ballEntity, SetEntityAngularVelocity, 0.0, 0.0, 0.0)
    end

    if IsLobbyBallNearGround(lobby, lobby.ballEntity, 0.42) then
        SnapLobbyBallToGroundAtCurrentXY(lobby, lobby.ballEntity)
        if FreezeEntityPosition then
            TryCallEntityNative(lobby.ballEntity, FreezeEntityPosition, true)
        end
        return
    end

    -- Havada yakalandi: yatay hiz sifir, asagi it; fizik dusurur, zeminde dondur.
    TryCallEntityNative(lobby.ballEntity, SetEntityVelocity, 0.0, 0.0, -5.5)

    local lobbyRef = lobby
    CreateThread(function()
        local deadline = GetNowMs() + 1500
        while GetNowMs() < deadline do
            if not lobbyRef or not IsEntityHandleValid(lobbyRef.ballEntity) then return end
            local ent = lobbyRef.ballEntity
            if IsLobbyBallNearGround(lobbyRef, ent, 0.42) then
                SnapLobbyBallToGroundAtCurrentXY(lobbyRef, ent)
                if FreezeEntityPosition then
                    TryCallEntityNative(ent, FreezeEntityPosition, true)
                end
                return
            end
            Wait(35)
        end
        if lobbyRef and IsEntityHandleValid(lobbyRef.ballEntity) then
            SnapLobbyBallToGroundAtCurrentXY(lobbyRef, lobbyRef.ballEntity)
            if FreezeEntityPosition then
                TryCallEntityNative(lobbyRef.ballEntity, FreezeEntityPosition, true)
            end
        end
    end)
end

local function GetLobbyBallNetId(lobby)
    if not lobby then return 0 end
    if lobby.ballNetId and lobby.ballNetId ~= 0 then
        return lobby.ballNetId
    end
    if not lobby.ballEntity then return 0 end
    if not NetworkGetNetworkIdFromEntity then return 0 end
    if not IsEntityHandleValid(lobby.ballEntity) then return 0 end
    local ok, netId = pcall(NetworkGetNetworkIdFromEntity, lobby.ballEntity)
    if not ok then return 0 end
    return netId or 0
end

local function SetLobbyBallOwner(lobby, ownerSrc)
    if not lobby then return end
    local previousOwner = tonumber(lobby.ballOwner) or 0
    local nextOwner = tonumber(ownerSrc) or 0
    if nextOwner ~= 0 and previousOwner ~= nextOwner then
        lobby.ballOwnerSinceMs = GetNowMs()
    elseif nextOwner == 0 then
        lobby.ballOwnerSinceMs = 0
    end
    if lobby.goalkeeperHold then
        local holdSrc = tonumber(lobby.goalkeeperHold.src) or 0
        local nextOwner = tonumber(ownerSrc) or 0
        if nextOwner == 0 or holdSrc ~= nextOwner then
            ClearGoalkeeperHold(lobby, true)
        end
    end
    -- Son topu taşıyan oyuncuyu takip et (gol attığında kimin attığını bilmek için)
    if ownerSrc and ownerSrc ~= 0 then
        lobby.lastBallOwner = ownerSrc
        -- Top bir oyuncu tarafından tekrar sahiplenildi; "slide sonrası sahipsiz pencere" biter.
        lobby.looseBallUntil = 0
        lobby.ballLooseSinceMs = nil
        local newTeam = GetPlayerTeamIndex(lobby, ownerSrc)
        local cand = lobby.assistCandidate
        if cand and newTeam ~= 0 and newTeam ~= tonumber(cand.team) then
            lobby.assistCandidate = nil
        end
    end
    lobby.ballOwner = ownerSrc
    -- Sahipsiz top: onceki hard-slide looseBallUntil pas/şut vb. ile supurulmeli; aksi halde kimse claim edemiyor.
    if not ownerSrc or ownerSrc == 0 then
        lobby.looseBallUntil = 0
        lobby.ballLooseSinceMs = GetNowMs()
    end

    if ownerSrc and ownerSrc ~= 0 and lobby.kickoffLockActive == true then
        local ownerTeam = GetPlayerTeamIndex(lobby, ownerSrc)
        if ownerTeam ~= 0 and ownerTeam == tonumber(lobby.kickoffAllowedTeam) then
            lobby.kickoffLockActive = false
            lobby.kickoffAllowedTeam = 0
            lobby.kickoffBlockedTeam = 0
        end
    end

    if ownerSrc and ownerSrc ~= 0 then
        local stealCfg = Config.StealSystem or {}
        local graceMs = tonumber(stealCfg.OwnerGraceMs) or 700
        lobby.ownerProtectionUntil = GetNowMs() + math.max(0, graceMs)
    else
        lobby.ownerProtectionUntil = 0
    end
    local blockedVictim = tonumber(lobby.hardStealBlockedVictim) or 0
    if ownerSrc and ownerSrc ~= 0 and blockedVictim ~= 0 and tonumber(ownerSrc) ~= blockedVictim then
        lobby.hardStealBlockedVictim = 0
        lobby.hardStealBlockedVictimUntil = 0
    end
    BroadcastToLobby(lobby, 'seoul_soccer:client:BallOwnerChanged', ownerSrc or 0, GetLobbyBallNetId(lobby))
    BroadcastKickoffLockState(lobby)
end

local function ResolveGoalScorerSrc(lobby, nowMs)
    if not lobby then return nil end
    nowMs = tonumber(nowMs) or GetNowMs()

    local currentOwner = tonumber(lobby.ballOwner) or 0
    local action = lobby.lastBallAction
    if type(action) == "table" then
        local actionSrc = tonumber(action.src) or 0
        local actionAt = tonumber(action.atMs) or 0
        local actionAge = nowMs - actionAt
        -- Prefere o ultimo chute/passe intencional por alguns segundos.
        -- Um auto-claim instantaneo perto da linha nao deve transformar um chute normal em gol contra.
        if actionSrc ~= 0 and actionAge >= 0 and actionAge <= 7000 then
            if currentOwner == 0 or currentOwner == actionSrc then
                return actionSrc
            end

            local ownerSince = tonumber(lobby.ballOwnerSinceMs) or 0
            local ownerHeldMs = ownerSince > 0 and (nowMs - ownerSince) or 0
            if ownerHeldMs < 700 then
                return actionSrc
            end
        end
    end

    if currentOwner ~= 0 then
        return currentOwner
    end
    local lastOwner = tonumber(lobby.lastBallOwner) or 0
    if lastOwner ~= 0 then return lastOwner end
    return nil
end

local function ResolveScorerDisplayName(lobby, src)
    if not src or src == 0 then
        return nil
    end
    local resolved = ResolvePlayerStatsName(src)
    if resolved and Trim(resolved) ~= "" then
        return Trim(resolved)
    end
    local cached = GetCachedLobbyPlayerName(lobby, src)
    if cached and Trim(cached) ~= "" then
        return Trim(cached)
    end
    local fallback = Trim(GetPlayerName(src) or "")
    if fallback ~= "" and string.lower(fallback) ~= "unknown" then
        return fallback
    end
    return nil
end

local function ResetLobbyMatchStats(lobby)
    if not lobby then return end
    lobby.playerGoals = {}
    lobby.goalTimeline = {}
    lobby.goalEventSeq = 0
    lobby.assistCandidate = nil
    lobby.lastBallAction = nil
    lobby.ballOwnerSinceMs = 0
end

local function BuildLobbyPlayerGoals(lobby)
    local out = {}
    local srcMap = lobby and lobby.playerGoals or {}
    for _, row in pairs(srcMap or {}) do
        if type(row) == "table" then
            out[#out + 1] = {
                src = tonumber(row.src) or 0,
                name = tostring(row.name or LOr("defaults.unknown_player", "Unknown Player")),
                team = tonumber(row.team) or 0,
                goals = tonumber(row.goals) or 0,
                assists = tonumber(row.assists) or 0,
            }
        end
    end
    table.sort(out, function(a, b)
        if (a.goals or 0) ~= (b.goals or 0) then
            return (a.goals or 0) > (b.goals or 0)
        end
        if (a.assists or 0) ~= (b.assists or 0) then
            return (a.assists or 0) > (b.assists or 0)
        end
        return string.lower(tostring(a.name or "")) < string.lower(tostring(b.name or ""))
    end)
    return out
end

local function BuildLobbyGoalTimeline(lobby)
    local out = {}
    local timeline = lobby and lobby.goalTimeline or {}
    for i = #timeline, 1, -1 do
        local row = timeline[i]
        if type(row) == "table" then
            out[#out + 1] = {
                seq = tonumber(row.seq) or i,
                src = tonumber(row.src) or 0,
                name = tostring(row.name or LOr("defaults.unknown_player", "Unknown Player")),
                team = tonumber(row.team) or 0,
                score1 = tonumber(row.score1) or 0,
                score2 = tonumber(row.score2) or 0,
                timeLeft = tonumber(row.timeLeft) or 0,
                elapsedSec = tonumber(row.elapsedSec) or 0,
                assistSrc = tonumber(row.assistSrc) or 0,
                assistName = row.assistName and tostring(row.assistName) or nil,
            }
        end
    end
    return out
end

local function BuildLobbyMatchStatsPayload(lobby)
    return {
        playerGoals = BuildLobbyPlayerGoals(lobby),
        goalTimeline = BuildLobbyGoalTimeline(lobby),
    }
end

--- Ortak: warmup/match snapshot (StartMatch + host migration icin)
local function BuildMatchSnapshotForPlayer(lobby, lobbyId, playerSrc, hostSrc)
    local gn = Config.GoalNotification or {}
    -- Gol toast: sag kenar (Right). Geri uyumluluk: Left verilmisse ayni string right olarak kullanilir.
    local goalEdge = gn.Right or gn.Left or "20px"
    return {
        lobbyId   = lobbyId,
        pitchId   = lobby.pitchId,
        mySrc     = playerSrc,
        ballModel = lobby.ballModel,
        ballNetId = GetLobbyBallNetId(lobby),
        ballOwner = lobby.ballOwner or 0,
        team1     = lobby.team1,
        team2     = lobby.team2,
        myTeam    = GetPlayerTeamIndex(lobby, playerSrc),
        goalkeepers = GetGoalkeeperPayload(lobby),
        goalkeeperHold = GetGoalkeeperHoldPayload(lobby),
        timeLeft  = lobby.timeLeft,
        isHost    = playerSrc == hostSrc,
        keybinds  = GetLocalizedKeybinds(),
        hostKeys  = Config.HostKeys,
        uiKeys    = Config.UIKeys or {},
        notifPos  = {
            right = tostring(goalEdge),
            top   = tostring(gn.Top or "50%"),
        },
        ballOutline = lobby.ballOutline == true,
        allowInventory = lobby.allowInventory ~= false,
        allowBothTeamsTouchAfterGoal = lobby.allowBothTeamsTouchAfterGoal == true,
        spawnAtOwnHalfAfterGoal = lobby.spawnAtOwnHalfAfterGoal == true,
        state = lobby.state,
        name = lobby.name,
        duration = tonumber(lobby.duration) or Config.MatchDuration,
        targetGoals = tonumber(lobby.targetGoals) or 0,
        format = lobby.format,
        ballId = lobby.ballId,
        pitchDoors = BuildPitchDoorsForUi(lobby.pitchId),
        pitchDoorLocks = CopyPitchDoorLocks(lobby),
        matchStats = BuildLobbyMatchStatsPayload(lobby),
        kickoffLockActive = lobby.kickoffLockActive == true,
        kickoffAllowedTeam = tonumber(lobby.kickoffAllowedTeam) or 0,
        kickoffBlockedTeam = tonumber(lobby.kickoffBlockedTeam) or 0,
        shotTrailPresetIndex = tonumber(lobby.shotTrailPresetIndex) or 0,
        shotTrailPresetLabel = GetShotTrailPresetLabel(lobby.shotTrailPresetIndex),
    }
end

local function BroadcastShotTrailPreset(lobby)
    if not lobby then return end
    local idx = tonumber(lobby.shotTrailPresetIndex) or 0
    local label = GetShotTrailPresetLabel(idx)
    for _, psrc in ipairs(GetAllPlayers(lobby)) do
        TriggerClientEvent('seoul_soccer:client:ShotTrailPresetChanged', psrc, idx, label)
    end
end

RegisterNetEvent('seoul_soccer:server:CycleShotTrailPreset', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if tonumber(lobby.host) ~= tonumber(src) then return end

    local st = tostring(lobby.state or "")
    if st ~= "warmup" and st ~= "countdown" and st ~= "playing" and st ~= "paused" then
        return
    end

    local presetCount = GetShotTrailPresetCount()
    if presetCount <= 0 then return end

    local cur = math.floor(tonumber(lobby.shotTrailPresetIndex) or 0)
    local nextIdx
    if cur == 0 then
        nextIdx = -1
    elseif cur == -1 then
        nextIdx = 1
    elseif cur >= presetCount then
        nextIdx = 0
    else
        nextIdx = cur + 1
    end
    lobby.shotTrailPresetIndex = nextIdx

    local label = GetShotTrailPresetLabel(nextIdx)
    Bridge.NotifyPlayer(src, L("client.shot_fx_changed", label), "inform", 2800)
    BroadcastShotTrailPreset(lobby)
end)

local function DestroyLobbyAfterMatch(lobbyId, endReason)
    local l = Lobbies[lobbyId]
    if not l then return end
    if SoccerAPI and SoccerAPI.SaveMatchHistory then
        SoccerAPI.SaveMatchHistory(l, lobbyId, endReason or 'unknown')
    end
    UnlockPitchDoorsForEveryone(l.pitchId)
    ClearInvitesForLobby(lobbyId)
    -- Tüm oyuncuların maç sayısını güncelle
    SaveMatchToDB(l)

    -- Katilim ucreti: odul dagilimi
    local paid = l.paidBySrc or {}
    local paidPassports = l.paidPassportBySrc or {}
    local prizePool = 0
    for _, amt in pairs(paid) do prizePool = prizePool + (tonumber(amt) or 0) end
    if prizePool > 0 then
        local function PayPlayer(srcValue, amount)
            local key = tostring(srcValue)
            local passport = tonumber(paidPassports[key])
            if passport and Bridge.AddMoneyToPassport and Bridge.AddMoneyToPassport(passport, amount) then
                return true
            end
            return Bridge.AddMoney(tonumber(srcValue), amount) == true
        end

        local s1 = tonumber(l.team1 and l.team1.score) or 0
        local s2 = tonumber(l.team2 and l.team2.score) or 0
        local winnerList = nil
        if s1 > s2 then
            winnerList = l.team1.players
        elseif s2 > s1 then
            winnerList = l.team2.players
        end
        if winnerList and #winnerList > 0 then
            local forfeited = l.forfeitedBySrc or {}
            local eligibleWinners = {}
            for _, p in ipairs(winnerList) do
                if forfeited[tostring(p.src)] ~= true then
                    eligibleWinners[#eligibleWinners + 1] = p
                end
            end
            if #eligibleWinners > 0 then
                local share = math.floor(prizePool / #eligibleWinners)
                if share > 0 then
                    for _, p in ipairs(eligibleWinners) do
                        PayPlayer(p.src, share)
                    end
                end
            end
        else
            -- Empate: devolve a taxa apenas a quem permaneceu na partida.
            -- Quem saiu/desconectou depois do início é desistência e não recebe reembolso.
            local forfeited = l.forfeitedBySrc or {}
            for srcStr, amt in pairs(paid) do
                if forfeited[tostring(srcStr)] ~= true then
                    PayPlayer(srcStr, tonumber(amt) or 0)
                end
            end
        end
    end

    BroadcastToLobby(l, 'seoul_soccer:client:MatchEnded', l.team1.score, l.team2.score)
    local footballEndPayload = {
        homeScore = tonumber(l.team1 and l.team1.score) or 0,
        awayScore = tonumber(l.team2 and l.team2.score) or 0,
        homeName = l.team1 and l.team1.name or nil,
        awayName = l.team2 and l.team2.name or nil,
        state = "ended",
        status = "ENDED",
        reason = endReason or "unknown",
    }
    TriggerClientEvent('football:endMatch', -1, footballEndPayload)
    TriggerEvent('football:server:ingest', footballEndPayload)
    CleanupLobbyBall(l)
    Lobbies[lobbyId] = nil
    LobbyTimerActive[lobbyId] = nil
    BroadcastLobbiesSync()
end

--- Oyuncu saha disina ciktiginda lobiden cikar (kurucu ise mac iptal).
local function RemovePlayerFromLobbyForDistance(lobbyId, lobby, src)
    if not lobby or not src then return end
    if lobby.host == src then
        local st = tostring(lobby.state or "")
        if st == "playing" or st == "paused" then
            -- Evita exploit de aposta: sair do campo durante jogo encerra pelo placar atual.
            -- O host que abandonou é marcado como desistente antes do payout.
            MarkLobbyEntryForfeit(lobby, src)
            DestroyLobbyAfterMatch(lobbyId, "host_left_pitch")
            return
        end

        local players = GetAllPlayers(lobby)
        RefundAllLobbyEntries(lobby)
        UnlockPitchDoorsForEveryone(lobby.pitchId)
        CleanupLobbyBall(lobby)
        ClearInvitesForLobby(lobbyId)
        Lobbies[lobbyId] = nil
        for _, psrc in ipairs(players) do
            TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', psrc, L('server.host_left_pitch_cancel'))
        end
        BroadcastLobbiesSync()
        return
    end

    if lobby.state == "waiting" then
        RefundLobbyEntry(lobby, src)
    elseif lobby.state == "warmup" or lobby.state == "countdown" or lobby.state == "playing" or lobby.state == "paused" then
        MarkLobbyEntryForfeit(lobby, src)
    end
    local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)
    for i, p in ipairs(lobby.team1.players) do
        if p.src == src then
            table.remove(lobby.team1.players, i)
            break
        end
    end
    for i, p in ipairs(lobby.team2.players) do
        if p.src == src then
            table.remove(lobby.team2.players, i)
            break
        end
    end
    if lobby.ballOwner == src then
        SetLobbyBallOwner(lobby, nil)
    end
    if goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end
    -- Istemci RemovedFromMatch icinde zaten bildirim gosterir.
    TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', src, L('server.kicked_distance'))
    BroadcastLobbiesSync()
end

local function GetBallCoordsForGoalCheck(lobby)
    if not lobby or not GetEntityCoords then return nil end
    if IsEntityHandleValid(lobby.ballEntity) then
        local ok, c = pcall(GetEntityCoords, lobby.ballEntity)
        if ok and c then return c end
    end
    local netId = GetLobbyBallNetId(lobby)
    if netId and netId ~= 0 and NetworkDoesNetworkIdExist and NetworkGetEntityFromNetworkId then
        local okNet, netOk = pcall(NetworkDoesNetworkIdExist, netId)
        if okNet and netOk then
            local ent = NetworkGetEntityFromNetworkId(netId)
            if ent and ent ~= 0 and IsEntityHandleValid(ent) then
                local ok2, c2 = pcall(GetEntityCoords, ent)
                if ok2 and c2 then return c2 end
            end
        end
    end
    return nil
end

local function GetPitchBoundsDistances(pitch, pb)
    pb = pb or (Config.PitchBounds or {})
    local radius = tonumber(pitch and pitch.radius) or 50.0
    local ballMult = tonumber(pb.BallOutOfBoundsRadiusMultiplier) or 2.75
    local playerMult = tonumber(pb.PlayerKickRadiusMultiplier) or 2.2
    return radius * ballMult, radius * playerMult
end

--- Top saha disindaysa merkeze spawn/tasi. true = reset yapildi.
local function TryResetLobbyBallOutOfBounds(lobby, ballPos)
    if not lobby or not ballPos then return false end
    if lobby.goalCenterSpawnPending == true then
        return false
    end
    local now = GetNowMs()
    if now < (tonumber(lobby.ballOobResetCooldownUntil) or 0) then
        return false
    end

    local pb = Config.PitchBounds or {}
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return false end

    local maxBallDist = select(1, GetPitchBoundsDistances(pitch, pb))
    local cx, cy = pitch.coords.x, pitch.coords.y
    local dxb = ballPos.x - cx
    local dyb = ballPos.y - cy
    if math.sqrt((dxb * dxb) + (dyb * dyb)) <= maxBallDist then
        return false
    end

    if pb.BallOobRespawnNewEntity ~= false then
        RespawnLobbyBallAtCenterFromOob(lobby)
    else
        PlaceLobbyBallAtCenter(lobby)
    end
    SetLobbyBallOwner(lobby, nil)
    lobby.ballOobResetCooldownUntil = now + 650
    return true
end

local function ProcessPitchBoundsForLobby(lobbyId, lobby)
    if not lobby then return end
    local pb = Config.PitchBounds or {}
    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return end
    local _, maxPlayerDist = GetPitchBoundsDistances(pitch, pb)
    local cx, cy = pitch.coords.x, pitch.coords.y

    local state = lobby.state
    if state == "playing" or state == "paused" then
        local now = GetNowMs()
        local radius = tonumber(pitch.radius) or 50.0
        local ballMult = tonumber(pb.BallOutOfBoundsRadiusMultiplier) or 1.02
        local limitDist = radius * ballMult

        -- Check if player in possession has left the pitch
        local ownerSrc = tonumber(lobby.ballOwner) or 0
        if ownerSrc ~= 0 then
            local ownerPed = GetPlayerPedSafe(ownerSrc)
            if ownerPed ~= 0 then
                local ok, pos = pcall(GetEntityCoords, ownerPed)
                if ok and pos then
                    local dx = pos.x - cx
                    local dy = pos.y - cy
                    local dist = math.sqrt((dx * dx) + (dy * dy))
                    if dist > limitDist then
                        -- Reset ball and strip possession
                        if now >= (tonumber(lobby.ballOobResetCooldownUntil) or 0) then
                            if pb.BallOobRespawnNewEntity ~= false then
                                RespawnLobbyBallAtCenterFromOob(lobby)
                            else
                                PlaceLobbyBallAtCenter(lobby)
                            end
                            SetLobbyBallOwner(lobby, nil)
                            lobby.ballOobResetCooldownUntil = now + 650
                        end
                    end
                end
            end
        end

        local ballPos = GetBallCoordsForGoalCheck(lobby)
        if ballPos then
            TryResetLobbyBallOutOfBounds(lobby, ballPos)
        end
    end

    -- waiting: lobideyken de saha disi (menudeyken bile) uzaklasinca at
    -- Grace: sadece waiting/warmup/countdown — playing/paused'ta da uygulaniyordu; hizli F5 sonrasi dakikalarca kontrol devre disi kalabiliyordu
    if state == "waiting" or state == "warmup" or state == "countdown" or state == "playing" or state == "paused" then
        local now = GetNowMs()
        if state ~= "playing" and state ~= "paused" then
            if now < (tonumber(lobby.pitchProximityGraceUntil) or 0) then
                return
            end
        end
        for _, src in ipairs(GetAllPlayers(lobby)) do
            local ped = GetPlayerPedSafe(src)
            if ped ~= 0 then
                local ok, pos = pcall(GetEntityCoords, ped)
                if ok and pos then
                    local dx = pos.x - cx
                    local dy = pos.y - cy
                    local pd = math.sqrt((dx * dx) + (dy * dy))
                    if pd > maxPlayerDist then
                        RemovePlayerFromLobbyForDistance(lobbyId, lobby, src)
                        return
                    end
                end
            end
        end
    end
end

local function GetBallSpeed(lobby)
    if not lobby or not GetEntityVelocity then return nil end
    local ent = lobby.ballEntity
    if not IsEntityHandleValid(ent) then return nil end
    local ok, v = pcall(GetEntityVelocity, ent)
    if not ok or not v then return nil end
    return math.sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z))
end

local function IsPlayerInGoalkeeperArea(lobby, src, teamIndex, extraDistance)
    if not lobby then return false end
    local point = GetGoalkeeperPointForTeam(lobby.pitchId, teamIndex)
    if not point then return false end
    if not GetPlayerPed or not GetEntityCoords then return true end

    local ped = GetPlayerPedSafe(src)
    if ped == 0 then return false end
    local pos = GetEntityCoords(ped)
    if not pos then return false end

    local dx = pos.x - point.x
    local dy = pos.y - point.y
    local dz = pos.z - point.z
    local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
    local gkCfg = Config.Goalkeeper or {}
    local radius = (tonumber(gkCfg.AreaRadius) or 8.0) + (tonumber(extraDistance) or 0.0)
    return dist <= radius
end

local function IsBallNearPlayer(src, ballPos, maxDistance)
    if not ballPos then return false end
    if not GetPlayerPed or not GetEntityCoords then return true end
    local ped = GetPlayerPedSafe(src)
    if ped == 0 then return false end
    local pos = GetEntityCoords(ped)
    if not pos then return false end
    local dx = pos.x - ballPos.x
    local dy = pos.y - ballPos.y
    local dz = pos.z - ballPos.z
    return math.sqrt((dx * dx) + (dy * dy) + (dz * dz)) <= maxDistance
end

local function GetKeeperPedPos(src)
    if not GetPlayerPed or not GetEntityCoords then return nil end
    local ped = GetPlayerPedSafe(src)
    if ped == 0 then return nil end
    local pos = GetEntityCoords(ped)
    return pos
end

local function GetBallVelocityVec(lobby)
    if not lobby or not GetEntityVelocity then return nil end
    local ent = lobby.ballEntity
    if not IsEntityHandleValid(ent) then return nil end
    local ok, v = pcall(GetEntityVelocity, ent)
    if not ok or not v then return nil end
    return v
end

local function RoundGoalkeeperMetaValue(value)
    value = tonumber(value)
    if not value then return nil end
    return math.floor((value * 100.0) + 0.5) / 100.0
end

local function GetKeeperRightVector(src)
    local ped = GetPlayerPedSafe(src)
    if ped == 0 then return nil end

    if GetEntityForwardVector then
        local ok, fwd = pcall(GetEntityForwardVector, ped)
        if ok and fwd then
            local len = math.sqrt((fwd.x * fwd.x) + (fwd.y * fwd.y))
            if len > 0.001 then
                return { x = fwd.y / len, y = -fwd.x / len }
            end
        end
    end

    if GetEntityHeading then
        local ok, heading = pcall(GetEntityHeading, ped)
        if ok and heading then
            local rad = math.rad(tonumber(heading) or 0.0)
            return { x = math.cos(rad), y = math.sin(rad) }
        end
    end

    return nil
end

local function BuildGoalkeeperCatchMeta(lobby, src, teamIndex, ballPos, pedPos, ballVel, source)
    if not ballPos or not pedPos then
        return { source = source or "catch", height = "mid", direction = "center", animKey = "mid_center" }
    end

    local gkCfg = Config.Goalkeeper or {}
    local animCfg = gkCfg.CatchAnimations or {}
    local highMin = tonumber(animCfg.HighMinZAbovePed) or 1.15
    local lowMax = tonumber(animCfg.LowMaxZAbovePed) or 0.55
    local centerMax = tonumber(animCfg.CenterLateralMax) or 0.45
    local incomingCenterMax = tonumber(animCfg.CenterIncomingSpeedMax) or 0.35

    local heightDelta = (tonumber(ballPos.z) or 0.0) - (tonumber(pedPos.z) or 0.0)
    local height = "mid"
    if heightDelta >= highMin then
        height = "high"
    elseif heightDelta <= lowMax then
        height = "low"
    end

    local lateral = 0.0
    local right = GetKeeperRightVector(src)
    if right then
        local bx = (tonumber(ballPos.x) or 0.0) - (tonumber(pedPos.x) or 0.0)
        local by = (tonumber(ballPos.y) or 0.0) - (tonumber(pedPos.y) or 0.0)
        lateral = (bx * right.x) + (by * right.y)
    end

    local direction = "center"
    if lateral > centerMax then
        direction = "right"
    elseif lateral < -centerMax then
        direction = "left"
    end
    local directionSource = "position"

    if ballVel and right then
        local lateralVel = (ballVel.x * right.x) + (ballVel.y * right.y)
        if lateralVel > incomingCenterMax then
            direction = "left"
            directionSource = "velocity"
        elseif lateralVel < -incomingCenterMax then
            direction = "right"
            directionSource = "velocity"
        end
    end

    local dx = (tonumber(ballPos.x) or 0.0) - (tonumber(pedPos.x) or 0.0)
    local dy = (tonumber(ballPos.y) or 0.0) - (tonumber(pedPos.y) or 0.0)
    local dz = (tonumber(ballPos.z) or 0.0) - (tonumber(pedPos.z) or 0.0)
    local speed = nil
    if ballVel then
        speed = math.sqrt((ballVel.x * ballVel.x) + (ballVel.y * ballVel.y) + (ballVel.z * ballVel.z))
    else
        speed = GetBallSpeed(lobby)
    end

    return {
        source = source or "catch",
        team = tonumber(teamIndex) or 0,
        height = height,
        direction = direction,
        directionSource = directionSource,
        animKey = ("%s_%s"):format(height, direction),
        heightDelta = RoundGoalkeeperMetaValue(heightDelta),
        lateral = RoundGoalkeeperMetaValue(lateral),
        distance = RoundGoalkeeperMetaValue(math.sqrt((dx * dx) + (dy * dy) + (dz * dz))),
        speed = RoundGoalkeeperMetaValue(speed),
    }
end

local function GetBallDistanceToGoalkeeperPoint(lobby, teamIndex, ballPos)
    if not lobby or not ballPos then return nil end
    local point = GetGoalkeeperPointForTeam(lobby.pitchId, teamIndex)
    if not point then return nil end
    local dx = ballPos.x - point.x
    local dy = ballPos.y - point.y
    return math.sqrt((dx * dx) + (dy * dy))
end

-- Ped veya kale noktasi referansli "topun save menziline girdi mi?" kontrolu.
-- maxZAbovePed/maxZAbovePoint verilirse, top referansin Z'sinden bu kadar (m) yukseklikteyken
-- range kontrolu reddedilir (kafa uzerinden gecen lob cok kolay yakalanmasin).
local function IsBallInGoalkeeperSaveRange(lobby, src, teamIndex, ballPos, playerDistance, goalPointDistance, maxZAbovePed, maxZAbovePoint)
    if not ballPos then return false end
    local gkCfg = Config.Goalkeeper or {}
    local tolerance = tonumber(gkCfg.ServerDistanceTolerance) or 1.0
    local playerRange = (tonumber(playerDistance) or 0.0) + tolerance

    local pedPos = GetKeeperPedPos(src)
    if pedPos then
        local dx = pedPos.x - ballPos.x
        local dy = pedPos.y - ballPos.y
        local dz = pedPos.z - ballPos.z
        local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
        if dist <= playerRange then
            if not maxZAbovePed or (ballPos.z - pedPos.z) <= maxZAbovePed then
                return true
            end
        end
    elseif not GetPlayerPed or not GetEntityCoords then
        -- Sunucu native'lari yoksa (runtime farki) guvenli defansif dönüs
        return true
    end

    local point = GetGoalkeeperPointForTeam(lobby.pitchId, teamIndex)
    if point then
        local ddx = ballPos.x - point.x
        local ddy = ballPos.y - point.y
        local goalDist = math.sqrt((ddx * ddx) + (ddy * ddy))
        local goalRange = (tonumber(goalPointDistance) or tonumber(playerDistance) or 0.0) + tolerance
        if goalDist <= goalRange then
            if not maxZAbovePoint or (ballPos.z - point.z) <= maxZAbovePoint then
                return true
            end
        end
    end

    return false
end

local function ParryBallAwayFromGoal(lobby, src, teamIndex, ballPos)
    if not lobby or not ballPos or not IsEntityHandleValid(lobby.ballEntity) then return end
    local point = GetGoalkeeperPointForTeam(lobby.pitchId, teamIndex)
    local pitch = GetPitchById(lobby.pitchId)
    local dirX, dirY = 0.0, 0.0

    if pitch and pitch.coords and point then
        dirX = pitch.coords.x - point.x
        dirY = pitch.coords.y - point.y
    elseif GetPlayerPed and GetEntityCoords then
        local ped = GetPlayerPedSafe(src)
        if ped ~= 0 then
            local pos = GetEntityCoords(ped)
            if pos then
                dirX = ballPos.x - pos.x
                dirY = ballPos.y - pos.y
            end
        end
    end

    local len = math.sqrt((dirX * dirX) + (dirY * dirY))
    if len < 0.001 then
        dirX, dirY, len = 0.0, 1.0, 1.0
    end

    local gkCfg = Config.Goalkeeper or {}
    local speed = tonumber(gkCfg.ParrySpeed) or 13.0
    local lift = tonumber(gkCfg.ParryLift) or 1.6
    TryCallEntityNative(lobby.ballEntity, SetEntityVelocity, (dirX / len) * speed, (dirY / len) * speed, lift)
end

--- Sunucu konsolu: sadece Config.GoalDetection.Debug == true iken (poll dongusunde spam olmasin)
local function GoalServerDebugPrint(msg)
    if not (Config.GoalDetection or {}).Debug then return end
    print(msg)
end

-- forcedScoringTeam: sweep/trajectory tespitinde pos kutu icinde olmayabilir; takim disaridan verilir
local function ProcessGoalFromBallPosition(lobbyId, lobby, pos, forcedScoringTeam)
    if not lobby or lobby.state ~= "playing" or not pos then return false end
    local now = GetNowMs()
    if now < (tonumber(lobby.goalCooldownUntil) or 0) then
        GoalServerDebugPrint(("[seoul_soccer DEBUG] Gol cooldown aktif, %dms kaldi"):format((lobby.goalCooldownUntil or 0) - now))
        return false
    end

    local pitch = GetPitchById(lobby.pitchId)
    if not pitch then return false end

    local scoredTeam = forcedScoringTeam or GoalShared.FindScoringTeamAtPosition(pitch, pos)
    if not scoredTeam then
        GoalServerDebugPrint(("[seoul_soccer DEBUG] Pos kale kutusunda degil: %.2f  %.2f  %.2f"):format(pos.x, pos.y, pos.z))
        return false
    end
    GoalServerDebugPrint(("[seoul_soccer DEBUG] GOL! Takim %d skoru artti"):format(scoredTeam))

    -- Golü atan oyuncuyu tespit et (top sahibi veya son top sahibi)
    local scorerSrc = ResolveGoalScorerSrc(lobby, now)

    if scoredTeam == 1 then
        lobby.team1.score = (lobby.team1.score or 0) + 1
    else
        lobby.team2.score = (lobby.team2.score or 0) + 1
    end

    -- Gol istatistiğini veritabanına kaydet
    SaveGoalToDB(scorerSrc, lobby)

    local scorerName = ResolveScorerDisplayName(lobby, scorerSrc) or LOr("defaults.unknown_player", "Unknown Player")
    local scorerTeam = GetPlayerTeamIndex(lobby, scorerSrc)
    local isOwnGoal = (scorerTeam == 1 or scorerTeam == 2) and scorerTeam ~= scoredTeam

    local assistSrc = ResolveAssistForGoal(lobby, scorerSrc, isOwnGoal)
    local assistName = nil
    if assistSrc and assistSrc ~= 0 then
        assistName = ResolveScorerDisplayName(lobby, assistSrc)
        SaveAssistToDB(assistSrc, lobby)
    end
    lobby.assistCandidate = nil
    local durationSec = math.max(0, tonumber(lobby.duration) or 0) * 60
    local timeLeftNow = math.max(0, tonumber(lobby.timeLeft) or 0)
    local elapsedSec = math.max(0, durationSec - timeLeftNow)

    lobby.playerGoals = lobby.playerGoals or {}
    if scorerSrc and scorerSrc ~= 0 then
        local scorerKey = tostring(scorerSrc)
        local playerRow = lobby.playerGoals[scorerKey]
        if not playerRow then
            playerRow = {
                src = scorerSrc,
                name = scorerName,
                team = scorerTeam,
                goals = 0,
            }
            lobby.playerGoals[scorerKey] = playerRow
        else
            playerRow.src = scorerSrc
            playerRow.name = scorerName
            if scorerTeam == 1 or scorerTeam == 2 then
                playerRow.team = scorerTeam
            end
        end
        playerRow.goals = (tonumber(playerRow.goals) or 0) + 1
    end

    if assistSrc and assistSrc ~= 0 then
        lobby.playerGoals = lobby.playerGoals or {}
        local assistKey = tostring(assistSrc)
        local assistTeam = GetPlayerTeamIndex(lobby, assistSrc)
        local assistRow = lobby.playerGoals[assistKey]
        if not assistRow then
            assistRow = {
                src = assistSrc,
                name = assistName or ResolveScorerDisplayName(lobby, assistSrc) or LOr("defaults.unknown_player", "Unknown Player"),
                team = assistTeam,
                goals = 0,
                assists = 0,
            }
            lobby.playerGoals[assistKey] = assistRow
        else
            assistRow.src = assistSrc
            if assistName and Trim(assistName) ~= "" then
                assistRow.name = assistName
            end
            if assistTeam == 1 or assistTeam == 2 then
                assistRow.team = assistTeam
            end
        end
        assistRow.assists = (tonumber(assistRow.assists) or 0) + 1
    end

    lobby.goalTimeline = lobby.goalTimeline or {}
    lobby.goalEventSeq = (tonumber(lobby.goalEventSeq) or 0) + 1
    local timelineEntry = {
        seq = lobby.goalEventSeq,
        src = scorerSrc or 0,
        name = scorerName,
        team = scoredTeam,
        scorerTeam = scorerTeam,
        isOwnGoal = isOwnGoal,
        assistSrc = assistSrc or 0,
        assistName = assistName,
        score1 = lobby.team1.score or 0,
        score2 = lobby.team2.score or 0,
        timeLeft = timeLeftNow,
        elapsedSec = elapsedSec,
    }
    table.insert(lobby.goalTimeline, timelineEntry)
    if #lobby.goalTimeline > 40 then
        table.remove(lobby.goalTimeline, 1)
    end

    local gd = Config.GoalDetection or {}
    local resetDelay = math.max(0, tonumber(gd.BallResetDelayMs) or 3500)
    local baseCd = math.max(0, tonumber(gd.CooldownMs) or 4000)
    lobby.goalCooldownUntil = now + math.max(baseCd, resetDelay + 1000)

    SetLobbyBallOwner(lobby, nil)
    lobby.goalCenterSpawnPending = true
    ParkLobbyBallAfterGoal(lobby)

    local kickoffTeam = GetDefendingTeamForGoal(scoredTeam)
    if lobby.allowBothTeamsTouchAfterGoal == true then
        lobby.kickoffLockActive = false
        lobby.kickoffAllowedTeam = 0
        lobby.kickoffBlockedTeam = 0
    elseif kickoffTeam == 1 or kickoffTeam == 2 then
        lobby.kickoffLockActive = true
        lobby.kickoffAllowedTeam = kickoffTeam
        lobby.kickoffBlockedTeam = scoredTeam
    else
        lobby.kickoffLockActive = false
        lobby.kickoffAllowedTeam = 0
        lobby.kickoffBlockedTeam = 0
    end
    BroadcastKickoffLockState(lobby)

    if lobby.spawnAtOwnHalfAfterGoal then
        local goalLobbyId = lobbyId
        CreateThread(function()
            Wait(1500)
            local l = Lobbies[goalLobbyId]
            if not l or l.state ~= "playing" then return end
            local spawns = CalculateKickoffPositions(l)
            for _, team in ipairs({ l.team1.players, l.team2.players }) do
                for _, p in ipairs(team) do
                    local pSrc = tonumber(p.src)
                    local sp = pSrc and spawns[tostring(pSrc)]
                    if sp then
                        TriggerClientEvent('seoul_soccer:client:TeleportToKickoff', pSrc, sp.coords, sp.heading)
                    end
                end
            end
        end)
    end

    local goalLobbyId = lobbyId
    CreateThread(function()
        Wait(resetDelay)
        local l = Lobbies[goalLobbyId]
        if not l then return end
        if l.state ~= "playing" and l.state ~= "paused" and l.state ~= "countdown" then
            l.goalCenterSpawnPending = false
            UnfreezeLobbyBallBeforeCenterSpawn(l)
            return
        end
        UnfreezeLobbyBallBeforeCenterSpawn(l)
        PlaceLobbyBallAtCenter(l)
        SetLobbyBallOwner(l, nil)
        l.goalCenterSpawnPending = false
        l.lastBallAction = nil
        BroadcastToLobby(l, 'seoul_soccer:client:BallCenterReady')
    end)

    BroadcastToLobby(lobby, 'seoul_soccer:client:TimerTick', lobby.timeLeft, lobby.team1.score, lobby.team2.score)
    BroadcastLobbyMenuLiveTick(lobbyId)
    BroadcastLobbiesSync()
    local footballGoalPayload = {
        scoringTeam = scoredTeam,
        homeScore = lobby.team1.score,
        awayScore = lobby.team2.score,
        score1 = lobby.team1.score,
        score2 = lobby.team2.score,
        homeName = lobby.team1.name,
        awayName = lobby.team2.name,
        team1Name = lobby.team1.name,
        team2Name = lobby.team2.name,
        scorerSrc = scorerSrc or 0,
        scorerName = scorerName,
        scorerTeam = scorerTeam,
        isOwnGoal = isOwnGoal,
        assistSrc = assistSrc or 0,
        assistName = assistName,
        timelineEntry = timelineEntry,
        matchStats = BuildLobbyMatchStatsPayload(lobby),
        kickoffLockActive = lobby.kickoffLockActive == true,
        kickoffAllowedTeam = tonumber(lobby.kickoffAllowedTeam) or 0,
        kickoffBlockedTeam = tonumber(lobby.kickoffBlockedTeam) or 0,
        timeLeft = timeLeftNow,
        totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
    }
    BroadcastToLobby(lobby, 'seoul_soccer:client:GoalScored', footballGoalPayload)
    TriggerClientEvent('football:goalScored', -1, footballGoalPayload)
    TriggerEvent('football:server:ingest', footballGoalPayload)

    do
        local pitch = GetPitchById(lobby.pitchId)
        TriggerEvent('seoul_soccer:internal:TabletGoal', {
            pitchName = pitch and GetLocalizedPitchName(pitch) or tostring(lobby.pitchId or ''),
            scoreHome = tonumber(lobby.team1.score) or 0,
            scoreAway = tonumber(lobby.team2.score) or 0,
            scorer = scorerName,
            teamHome = lobby.team1 and lobby.team1.name or nil,
            teamAway = lobby.team2 and lobby.team2.name or nil,
        })
    end

    local tg = tonumber(lobby.targetGoals)
    if tg and tg >= 1 then
        if (lobby.team1.score or 0) >= tg or (lobby.team2.score or 0) >= tg then
            DestroyLobbyAfterMatch(lobbyId, 'target_goals')
        end
    end
    return true
end

local function TryProcessLobbyGoal(lobbyId, lobby)
    local pos = GetBallCoordsForGoalCheck(lobby)
    local prevPos = lobby.prevBallPos

    if pos then
        lobby.prevBallPos = pos
    else
        -- Top entity okunamadiysa onceki konumu temizle; yanlis sweep onlensin
        lobby.prevBallPos = nil
    end

    if pos then
        local scored = ProcessGoalFromBallPosition(lobbyId, lobby, pos)
        -- Anlık pozisyon golle sonuclananmadiysa trajectory sweep dene (tunneling)
        if not scored and prevPos and lobby.state == "playing" then
            local now = GetNowMs()
            if now >= (tonumber(lobby.goalCooldownUntil) or 0) then
                local pitch = GetPitchById(lobby.pitchId)
                if pitch then
                    local sweepTeam = GoalShared.FindScoringTeamForSegment(pitch, prevPos, pos)
                    if sweepTeam then
                        GoalServerDebugPrint(("[seoul_soccer DEBUG] SWEEP GOL! Takim %d (trajectory)"):format(sweepTeam))
                        ProcessGoalFromBallPosition(lobbyId, lobby, pos, sweepTeam)
                    end
                end
            end
        end
    end
end

RegisterNetEvent('seoul_soccer:server:SuggestBallGoalAt', function(lobbyId, x, y, z)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]
    if not lobby or lobby.state ~= "playing" then
        GoalServerDebugPrint(("[seoul_soccer DEBUG] SuggestBallGoalAt REDDEDILDI: lobbyId=%s state=%s"):format(tostring(lobbyId), lobby and lobby.state or "nil"))
        return
    end
    if not IsPlayerInLobby(lobby, src) then
        GoalServerDebugPrint(("[seoul_soccer DEBUG] SuggestBallGoalAt REDDEDILDI: oyuncu lobide degil src=%s"):format(src))
        return
    end
    local hintPos = vector3(tonumber(x) or 0.0, tonumber(y) or 0.0, tonumber(z) or 0.0)
    local authPos = GetBallCoordsForGoalCheck(lobby)
    if not authPos then
        GoalServerDebugPrint("[seoul_soccer DEBUG] SuggestBallGoalAt REDDEDILDI: authentic top entity/net id okunamadi")
        return
    end

    local pitch = GetPitchById(lobby.pitchId)
    if not pitch or not pitch.coords then return end

    local maxR = (tonumber(pitch.radius) or 50.0) * 2.8
    local dx = authPos.x - pitch.coords.x
    local dy = authPos.y - pitch.coords.y
    if math.sqrt((dx * dx) + (dy * dy)) > maxR then return end

    local gd = Config.GoalDetection or {}
    local maxPedBall = math.max(0.1, tonumber(gd.ClientSuggestMaxPedBall) or 4.0)
    local ped = GetPlayerPedSafe(src)
    if not ped or ped == 0 or not IsEntityHandleValid(ped) then return end
    local okP, ppos = pcall(GetEntityCoords, ped)
    if not okP or not ppos then return end
    local dxb = authPos.x - ppos.x
    local dyb = authPos.y - ppos.y
    local dzb = authPos.z - ppos.z
    if math.sqrt((dxb * dxb) + (dyb * dyb) + (dzb * dzb)) > maxPedBall then return end

    lobby.goalClientThrottle = lobby.goalClientThrottle or {}
    local th = lobby.goalClientThrottle
    local now = GetNowMs()
    local nextAllowed = tonumber(th[src]) or 0
    if now < nextAllowed then return end
    th[src] = now + 180

    -- Client koordinati skor kararinda kullanilmaz. Yalnizca authentic topa yakin bir hint ise saklanir.
    local hdx = authPos.x - hintPos.x
    local hdy = authPos.y - hintPos.y
    local hdz = authPos.z - hintPos.z
    local hintDistance = math.sqrt((hdx * hdx) + (hdy * hdy) + (hdz * hdz))
    local maxDeviation = math.max(0.0, tonumber(gd.GoalSuggestMaxBallDeviation) or 3.5)
    if hintDistance <= maxDeviation then
        lobby.lastClientBallPos = hintPos
        lobby.lastClientBallPosAt = now
    end

    ProcessGoalFromBallPosition(lobbyId, lobby, authPos)
end)

-- ─────────────────────────────────────────────
-- Lobi Talepleri
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:RequestLobbies', function()
    local src = source
    if not CheckLobbyActionRate(src, "request_lobbies", 400) then return end
    BroadcastLobbiesSync(src)
end)

--- Lobi sifre dogrulamasi (lobiye girmeden once). UI, modal uzerinde gosterilmek uzere sonucu bekler.
RegisterNetEvent('seoul_soccer:server:ValidateLobbyPassword', function(lobbyId, password)
    local src = source
    if not CheckLobbyActionRate(src, "password", 500) then return end
    lobbyId = tonumber(lobbyId)
    if not lobbyId then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId or 0, false)
        return
    end
    local lobby = Lobbies[lobbyId]
    if not lobby or lobby.state ~= "waiting" then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, false)
        return
    end
    if not IsPlayerNearPitch(src, lobby.pitchId, 12.0) then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, false)
        return
    end

    -- Zaten lobideysem veya kurucuysam sifre istenmez.
    if tonumber(lobby.host) == tonumber(src) or IsPlayerInLobby(lobby, src) then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, true)
        return
    end

    local lobbyPwd = type(lobby.password) == "string" and lobby.password or ""
    if lobbyPwd == "" then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, true)
        return
    end

    local given = SanitizeLobbyPassword(password)
    if given == lobbyPwd then
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, true)
    else
        TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, false)
    end
end)

RegisterNetEvent('seoul_soccer:server:CreateLobby', function(data)
    local src = source
    if not CheckLobbyActionRate(src, "create", 2000) then return end
    if type(data) ~= "table" then
        SendCreateLobbyResultToClient(src, false, L('server.settings_invalid'))
        return
    end

    local existingLobbyId = GetLobbyIdPlayerBelongsTo(src)
    if existingLobbyId then
        Bridge.NotifyPlayer(src, L('server.invite_you_busy'), 'error', 4000)
        SendCreateLobbyResultToClient(src, false, L('server.invite_you_busy'))
        return
    end

    local pitchId = ResolvePitchIdForHost(data.pitchId, src)
    if not pitchId then
        Bridge.NotifyPlayer(src, L('server.pitch_not_found'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.pitch_not_found'))
        return
    end
    if not IsPlayerNearPitch(src, pitchId, 12.0) then
        Bridge.NotifyPlayer(src, L('server.lobby_too_far'), 'error', 4000)
        SendCreateLobbyResultToClient(src, false, L('server.lobby_too_far'))
        return
    end

    for _, lobby in pairs(Lobbies) do
        if lobby.pitchId == pitchId and (lobby.state == "waiting" or lobby.state == "warmup" or lobby.state == "countdown" or lobby.state == "playing" or lobby.state == "paused") then
            Bridge.NotifyPlayer(src, L('server.pitch_busy'), 'error')
            SendCreateLobbyResultToClient(src, false, L('server.pitch_busy'))
            return
        end
    end

    local lobbyName = SanitizeLobbyName(data.name or L("defaults.lobby_name_fallback"))
    if not lobbyName then
        Bridge.NotifyPlayer(src, L('server.settings_name_required'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.settings_name_required'))
        return
    end

    local format1, format2 = ParseLobbyFormat(data.format or "6 vs 6")
    if not format1 or not format2 then
        Bridge.NotifyPlayer(src, L('server.settings_format_invalid'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.settings_format_invalid'))
        return
    end
    local lobbyFormat = ("%d vs %d"):format(format1, format2)

    local limits = GetSeoulLobbyLimits()
    local duration = math.floor(tonumber(data.duration) or tonumber(Config.MatchDuration) or 20)
    if duration < limits.minDuration or duration > limits.maxDuration then
        Bridge.NotifyPlayer(src, L('server.settings_duration_invalid'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.settings_duration_invalid'))
        return
    end

    local betAmount = ResolveValidatedBet(data.betAmount)
    if betAmount == nil then
        Bridge.NotifyPlayer(src, L('server.lobby_bet_invalid'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.lobby_bet_invalid'))
        return
    end

    local selectedBallId, selectedBallModel = ResolveBallSelection(data.ballId)
    local useTargetGoals = data.useTargetGoals == true or (tonumber(data.targetGoals) or 0) >= 1
    local targetGoals = 0
    if useTargetGoals then
        targetGoals = math.floor(tonumber(data.targetGoals) or 0)
        if targetGoals < 1 or targetGoals > limits.maxTargetGoals then
            Bridge.NotifyPlayer(src, L('server.settings_target_invalid'), 'error')
            SendCreateLobbyResultToClient(src, false, L('server.settings_target_invalid'))
            return
        end
    end

    -- Cobranca antes de criar o lobby: sem saldo = sem lobby e sem degradar silenciosamente a aposta para zero.
    local hostPassport = Bridge.GetPassport and Bridge.GetPassport(src) or nil
    if betAmount > 0 and not Bridge.RemoveMoney(src, betAmount) then
        Bridge.NotifyPlayer(src, L('server.lobby_bet_no_funds'), 'error')
        SendCreateLobbyResultToClient(src, false, L('server.lobby_bet_no_funds'))
        return
    end

    local lid = NextLobbyId
    NextLobbyId = NextLobbyId + 1
    local lobbyPassword = SanitizeLobbyPassword(data.password)

    Lobbies[lid] = {
        id = lid,
        host = src,
        name = lobbyName,
        pitchId = pitchId,
        format = lobbyFormat,
        bet = betAmount,
        password = lobbyPassword,
        ballId = selectedBallId,
        ballModel = selectedBallModel,
        ballEntity = nil,
        ballOwner = nil,
        looseBallUntil = 0,
        ballLooseSinceMs = nil,
        ownerProtectionUntil = 0,
        stealAttemptCooldowns = {},
        hardStealAttemptCooldowns = {},
        standTackleAttemptCooldowns = {},
        hardStealVictimNoClaimUntil = {},
        hardStealBlockedVictim = 0,
        hardStealBlockedVictimUntil = 0,
        kickoffLockActive = false,
        kickoffAllowedTeam = 0,
        kickoffBlockedTeam = 0,
        goalkeeperSaveCooldowns = {},
        goalkeeperSwitchCooldowns = {},
        goalkeeperHold = nil,
        goalCooldownUntil = 0,
        goalCenterSpawnPending = false,
        playerGoals = {},
        goalTimeline = {},
        goalEventSeq = 0,
        assistCandidate = nil,
        goalkeepers = {},
        targetGoals = targetGoals,
        duration = duration,
        ballOutline = data.ballOutline == true,
        allowInventory = data.allowInventory ~= false,
        allowBothTeamsTouchAfterGoal = data.allowBothTeamsTouchAfterGoal == true,
        spawnAtOwnHalfAfterGoal = data.spawnAtOwnHalfAfterGoal == true,
        shotTrailPresetIndex = GetDefaultShotTrailPresetIndex(),
        state = "waiting",
        pitchProximityGraceUntil = GetNowMs() + (tonumber((Config.PitchBounds or {}).ProximityGraceMs) or 15000),
        timeLeft = duration * 60,
        team1 = { name = SanitizeTeamName(data.team1Name, L("defaults.team1_name")), score = 0, players = {} },
        team2 = { name = SanitizeTeamName(data.team2Name, L("defaults.team2_name")), score = 0, players = {} },
        paidBySrc = {},
        paidPassportBySrc = {},
        forfeitedBySrc = {},
    }

    table.insert(Lobbies[lid].team1.players, BuildLobbyPlayerEntry(src))
    if betAmount > 0 then
        Lobbies[lid].paidBySrc[tostring(src)] = betAmount
        if hostPassport then
            Lobbies[lid].paidPassportBySrc[tostring(src)] = hostPassport
        end
    end

    Bridge.NotifyPlayer(src, L('server.lobby_created'), 'success')
    BroadcastLobbiesSync()
    SendCreateLobbyResultToClient(src, true, '', lid)
end)

RegisterNetEvent('seoul_soccer:server:JoinLobby', function(lobbyId, teamIndex, password)
    local src = source
    lobbyId = tonumber(lobbyId)
    teamIndex = tonumber(teamIndex)
    local lobby = lobbyId and Lobbies[lobbyId] or nil

    if not CheckLobbyActionRate(src, "join", 700) then return end

    if not lobby then
        Bridge.NotifyPlayer(src, L('server.lobby_not_found'), 'error', 4000)
        return
    end
    if not IsPlayerNearPitch(src, lobby.pitchId, 12.0) then
        Bridge.NotifyPlayer(src, L('server.lobby_too_far'), 'error', 4000)
        return
    end
    if lobby.state ~= "waiting" then
        Bridge.NotifyPlayer(src, L('server.lobby_not_joinable_state'), 'error', 4000)
        return
    end
    if teamIndex ~= 1 and teamIndex ~= 2 then return end

    local currentLobbyId = GetLobbyIdPlayerBelongsTo(src)
    if currentLobbyId and tonumber(currentLobbyId) ~= tonumber(lobbyId) then
        Bridge.NotifyPlayer(src, L('server.invite_you_busy'), 'error', 4000)
        return
    end

    local alreadyInTeam1, alreadyInTeam2 = false, false
    local sid = tonumber(src)

    for _, p in pairs(lobby.team1.players) do if tonumber(p.src) == sid then alreadyInTeam1 = true end end
    for _, p in pairs(lobby.team2.players) do if tonumber(p.src) == sid then alreadyInTeam2 = true end end

    if (teamIndex == 1 and alreadyInTeam1) or (teamIndex == 2 and alreadyInTeam2) then return end

    -- Sifre kontrolu: sadece yeni katilanlar icin (takim degistirme/zaten lobideki oyuncular icin atlanir).
    if not alreadyInTeam1 and not alreadyInTeam2 and tonumber(lobby.host) ~= sid then
        local lobbyPwd = type(lobby.password) == "string" and lobby.password or ""
        if lobbyPwd ~= "" then
            local given = SanitizeLobbyPassword(password)
            if given ~= lobbyPwd then
                TriggerClientEvent('seoul_soccer:client:LobbyPasswordResult', src, lobbyId, false)
                Bridge.NotifyPlayer(src, L('server.lobby_password_wrong'), 'error', 3500)
                return
            end
        end
    end

    if alreadyInTeam1 and teamIndex == 2 then
        if WouldExceedTeamCapacity(lobby, 2, #lobby.team2.players + 1) then
            Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
            return
        end
    elseif alreadyInTeam2 and teamIndex == 1 then
        if WouldExceedTeamCapacity(lobby, 1, #lobby.team1.players + 1) then
            Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
            return
        end
    elseif not alreadyInTeam1 and not alreadyInTeam2 then
        if teamIndex == 1 and WouldExceedTeamCapacity(lobby, 1, #lobby.team1.players + 1) then
            Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
            return
        end
        if teamIndex == 2 and WouldExceedTeamCapacity(lobby, 2, #lobby.team2.players + 1) then
            Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
            return
        end
    end

    local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)

    if alreadyInTeam1 and teamIndex == 2 then
        local old = RemoveLobbyPlayerBySrc(lobby.team1.players, sid)
        table.insert(lobby.team2.players, BuildLobbyPlayerEntry(src, old and old.jerseyNumber))
    elseif alreadyInTeam2 and teamIndex == 1 then
        local old = RemoveLobbyPlayerBySrc(lobby.team2.players, sid)
        table.insert(lobby.team1.players, BuildLobbyPlayerEntry(src, old and old.jerseyNumber))
    elseif not alreadyInTeam1 and not alreadyInTeam2 then
        -- Katilim ucreti kontrolu: yeni giren oyuncudan kes
        local betAmount = tonumber(lobby.bet) or 0
        if betAmount > 0 then
            local paid = (lobby.paidBySrc or {})[tostring(src)]
            if not paid then
                if not Bridge.RemoveMoney(src, betAmount) then
                    Bridge.NotifyPlayer(src, L('server.lobby_bet_no_funds'), 'error')
                    return
                end
                lobby.paidBySrc = lobby.paidBySrc or {}
                lobby.paidPassportBySrc = lobby.paidPassportBySrc or {}
                lobby.paidBySrc[tostring(src)] = betAmount
                local passport = Bridge.GetPassport and Bridge.GetPassport(src) or nil
                if passport then lobby.paidPassportBySrc[tostring(src)] = passport end
            end
        end

        if teamIndex == 1 then
            table.insert(lobby.team1.players, BuildLobbyPlayerEntry(src))
        elseif teamIndex == 2 then
            table.insert(lobby.team2.players, BuildLobbyPlayerEntry(src))
        end
        -- Gerçek yeni katılım: lobi içindeki herkese (katılan hariç) bildirim gönder
        local joinerName = ResolvePlayerStatsName(src) or GetPlayerName(src) or ("Player " .. tostring(src))
        local joinMsg = L('server.player_joined_lobby', joinerName)
        local allInLobby = GetAllPlayers(lobby)
        for _, psrc in ipairs(allInLobby) do
            if tonumber(psrc) ~= tonumber(src) then
                Bridge.NotifyPlayer(psrc, joinMsg, 'inform', 3500)
            end
        end
    end

    -- Mevcut bir lobiye yeni giren oyuncu icin mesafe grace'i tazele.
    -- Aksi halde eski lobilerde ilk join denemesi aninda "kicked_distance" ile dusme yasaniyordu.
    RefreshLobbyProximityGrace(lobby)

    if goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end
    BroadcastLobbiesSync()
end)

RegisterNetEvent('seoul_soccer:server:DisbandLobby', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]
    if not lobby then return end

    if tonumber(lobby.host) ~= tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.lobby_disband_host_only'), 'error', 3000)
        return
    end
    if lobby.state ~= "waiting" then
        Bridge.NotifyPlayer(src, L('server.lobby_disband_waiting_only'), 'error', 3000)
        return
    end

    local evac = GetAllPlayers(lobby)
    RefundAllLobbyEntries(lobby)
    UnlockPitchDoorsForEveryone(lobby.pitchId)
    CleanupLobbyBall(lobby)
    ClearInvitesForLobby(lobbyId)
    Lobbies[lobbyId] = nil
    local msg = L('server.lobby_disbanded')
    for _, psrc in ipairs(evac) do
        TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', psrc, msg)
    end
    BroadcastLobbiesSync()
end)

local LOBBY_SETTINGS_EDITABLE = {
    waiting = true,
    warmup = true,
    countdown = true,
    playing = true,
    paused = true,
}

local function IsLobbySettingsEditableState(stateName)
    return LOBBY_SETTINGS_EDITABLE[tostring(stateName or "")] == true
end

local function SendUpdateLobbySettingsResult(src, ok, message)
    if not src or src == 0 then return end
    TriggerClientEvent('seoul_soccer:client:UpdateLobbySettingsResult', src, ok == true, tostring(message or ""))
end

local function BroadcastLobbySettingsUpdated(lobby, lobbyId)
    if not lobby or not lobbyId then return end
    BroadcastLobbiesSync()
    local st = tostring(lobby.state or "")
    if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
        for _, psrc in ipairs(GetAllPlayers(lobby)) do
            TriggerClientEvent('seoul_soccer:client:LobbySettingsUpdated', psrc,
                BuildMatchSnapshotForPlayer(lobby, lobbyId, psrc, lobby.host))
        end
        local footballPayload = {
            homeName = lobby.team1 and lobby.team1.name or nil,
            awayName = lobby.team2 and lobby.team2.name or nil,
            homeScore = tonumber(lobby.team1 and lobby.team1.score) or 0,
            awayScore = tonumber(lobby.team2 and lobby.team2.score) or 0,
            timeLeft = tonumber(lobby.timeLeft) or 0,
            totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
            state = st,
            status = (st == "paused" and "PAUSED") or (st == "playing" and "LIVE") or "WARMUP",
        }
        TriggerClientEvent('football:updateTime', -1, footballPayload)
        TriggerEvent('football:server:ingest', footballPayload)
    end
    BroadcastLobbyMenuLiveTick(lobbyId)
end

RegisterNetEvent('seoul_soccer:server:UpdateLobbySettings', function(lobbyId, patch)
    local src = source
    if type(lobbyId) == "table" and patch == nil then
        patch = lobbyId
        lobbyId = patch.lobbyId
    end
    lobbyId = tonumber(lobbyId)
    patch = patch or {}
    if type(patch) ~= "table" then
        SendUpdateLobbySettingsResult(src, false, L('server.settings_invalid'))
        return
    end

    local lobby = lobbyId and Lobbies[lobbyId] or nil
    if not lobby then
        Bridge.NotifyPlayer(src, L('server.lobby_not_found'), 'error')
        SendUpdateLobbySettingsResult(src, false, L('server.lobby_not_found'))
        return
    end
    if tonumber(lobby.host) ~= tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.settings_host_only'), 'error')
        SendUpdateLobbySettingsResult(src, false, L('server.settings_host_only'))
        return
    end
    if not IsLobbySettingsEditableState(lobby.state) then
        Bridge.NotifyPlayer(src, L('server.settings_not_editable'), 'error')
        SendUpdateLobbySettingsResult(src, false, L('server.settings_not_editable'))
        return
    end

    local st = tostring(lobby.state or "")

    if patch.name ~= nil then
        local nm = Trim(tostring(patch.name or ""))
        if nm == "" then
            Bridge.NotifyPlayer(src, L('server.settings_name_required'), 'error')
            SendUpdateLobbySettingsResult(src, false, L('server.settings_name_required'))
            return
        end
        lobby.name = string.sub(nm, 1, 64)
    end

    if patch.duration ~= nil then
        local dur = math.floor(tonumber(patch.duration) or 0)
        local limits = GetSeoulLobbyLimits()
        if dur < limits.minDuration or dur > limits.maxDuration then
            Bridge.NotifyPlayer(src, L('server.settings_duration_invalid'), 'error')
            SendUpdateLobbySettingsResult(src, false, L('server.settings_duration_invalid'))
            return
        end
        lobby.duration = dur
        if st == "waiting" or st == "warmup" or st == "countdown" then
            lobby.timeLeft = dur * 60
        end
    end

    if patch.timeLeftMinutes ~= nil then
        local mins = math.floor(tonumber(patch.timeLeftMinutes) or 0)
        local limits = GetSeoulLobbyLimits()
        if mins < limits.minDuration or mins > limits.maxDuration then
            Bridge.NotifyPlayer(src, L('server.settings_timeleft_invalid'), 'error')
            SendUpdateLobbySettingsResult(src, false, L('server.settings_timeleft_invalid'))
            return
        end
        local maxSec = math.max(60, (tonumber(lobby.duration) or Config.MatchDuration or 20) * 60)
        lobby.timeLeft = math.min(maxSec, math.max(60, mins * 60))
    end

    if patch.useTargetGoals ~= nil or patch.targetGoals ~= nil then
        local useTarget = patch.useTargetGoals == true
        if patch.useTargetGoals == nil then
            useTarget = (tonumber(patch.targetGoals) or 0) >= 1
        end
        if not useTarget then
            lobby.targetGoals = 0
        else
            local tg = math.floor(tonumber(patch.targetGoals) or 0)
            local limits = GetSeoulLobbyLimits()
            if tg < 1 or tg > limits.maxTargetGoals then
                Bridge.NotifyPlayer(src, L('server.settings_target_invalid'), 'error')
                SendUpdateLobbySettingsResult(src, false, L('server.settings_target_invalid'))
                return
            end
            local maxScore = math.max(tonumber(lobby.team1 and lobby.team1.score) or 0,
                tonumber(lobby.team2 and lobby.team2.score) or 0)
            if tg <= maxScore then
                Bridge.NotifyPlayer(src, L('server.settings_target_below_score'), 'error')
                SendUpdateLobbySettingsResult(src, false, L('server.settings_target_below_score'))
                return
            end
            lobby.targetGoals = tg
        end
    end

    local t1Size = tonumber(patch.team1Size)
    local t2Size = tonumber(patch.team2Size)
    if t1Size or t2Size then
        t1Size = math.floor(t1Size or 0)
        t2Size = math.floor(t2Size or 0)
        if t1Size < 1 or t1Size > 11 or t2Size < 1 or t2Size > 11 then
            Bridge.NotifyPlayer(src, L('server.settings_format_invalid'), 'error')
            SendUpdateLobbySettingsResult(src, false, L('server.settings_format_invalid'))
            return
        end
        local n1 = #(lobby.team1.players or {})
        local n2 = #(lobby.team2.players or {})
        if n1 > t1Size or n2 > t2Size then
            Bridge.NotifyPlayer(src, L('server.settings_format_roster'), 'error')
            SendUpdateLobbySettingsResult(src, false, L('server.settings_format_roster'))
            return
        end
        lobby.format = ("%d vs %d"):format(t1Size, t2Size)
    end

    if patch.team1Name ~= nil then
        lobby.team1.name = SanitizeTeamName(patch.team1Name, L("defaults.team1_name"))
    end
    if patch.team2Name ~= nil then
        lobby.team2.name = SanitizeTeamName(patch.team2Name, L("defaults.team2_name"))
    end

    if patch.ballOutline ~= nil then
        lobby.ballOutline = patch.ballOutline == true
    end
    if patch.allowInventory ~= nil then
        lobby.allowInventory = patch.allowInventory ~= false
    end
    if patch.allowBothTeamsTouchAfterGoal ~= nil then
        lobby.allowBothTeamsTouchAfterGoal = patch.allowBothTeamsTouchAfterGoal == true
    end
    if patch.spawnAtOwnHalfAfterGoal ~= nil then
        lobby.spawnAtOwnHalfAfterGoal = patch.spawnAtOwnHalfAfterGoal == true
    end
    if patch.password ~= nil then
        lobby.password = SanitizeLobbyPassword(patch.password)
    end

    Bridge.NotifyPlayer(src, L('server.settings_updated'), 'success', 3500)
    SendUpdateLobbySettingsResult(src, true, "")
    BroadcastLobbySettingsUpdated(lobby, lobbyId)
end)

RegisterNetEvent('seoul_soccer:server:SetLobbyTeamName', function(lobbyId, teamIndex, rawName)
    local src = source
    lobbyId = tonumber(lobbyId)
    teamIndex = tonumber(teamIndex)
    if not lobbyId or (teamIndex ~= 1 and teamIndex ~= 2) then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end

    if lobby.host ~= src then
        Bridge.NotifyPlayer(src, L('server.team_rename_host_only'), 'error')
        return
    end
    if not IsLobbySettingsEditableState(lobby.state) then
        Bridge.NotifyPlayer(src, L('server.settings_not_editable'), 'error')
        return
    end

    local defaultName = teamIndex == 1 and L("defaults.team1_name") or L("defaults.team2_name")
    local newName = SanitizeTeamName(rawName, defaultName)
    if teamIndex == 1 then
        lobby.team1.name = newName
    else
        lobby.team2.name = newName
    end
    BroadcastLobbySettingsUpdated(lobby, lobbyId)
end)

RegisterNetEvent('seoul_soccer:server:SetJerseyNumber', function(lobbyId, jerseyNumber)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end

    local lobby = Lobbies[lobbyId]
    if not lobby or lobby.state ~= "waiting" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local sid = tonumber(src)
    local nextNumber = ResolveJerseyNumber(jerseyNumber)

    for _, p in ipairs(lobby.team1.players or {}) do
        if tonumber(p.src) == sid then
            p.jerseyNumber = nextNumber
            BroadcastLobbiesSync()
            return
        end
    end
    for _, p in ipairs(lobby.team2.players or {}) do
        if tonumber(p.src) == sid then
            p.jerseyNumber = nextNumber
            BroadcastLobbiesSync()
            return
        end
    end
end)

RegisterNetEvent('seoul_soccer:server:InvitePlayerToLobby', function(lobbyId, targetSrc, teamIndex)
    local src = source
    if not CheckLobbyActionRate(src, "invite", 500) then return end
    lobbyId = tonumber(lobbyId)
    targetSrc = tonumber(targetSrc)
    teamIndex = tonumber(teamIndex)
    if not lobbyId or not targetSrc or (teamIndex ~= 1 and teamIndex ~= 2) then return end

    if targetSrc == src then
        Bridge.NotifyPlayer(src, L('server.invite_self'), 'error')
        return
    end

    local lobby = Lobbies[lobbyId]
    if not lobby or lobby.state ~= "waiting" or lobby.host ~= src then return end

    if not GetPlayerName(targetSrc) then
        Bridge.NotifyPlayer(src, L('server.invite_player_offline'), 'error')
        return
    end

    if IsPlayerInLobby(lobby, targetSrc) then
        Bridge.NotifyPlayer(src, L('server.invite_already_in_lobby'), 'error')
        return
    end

    if GetLobbyIdPlayerBelongsTo(targetSrc) then
        Bridge.NotifyPlayer(src, L('server.invite_target_busy'), 'error')
        return
    end

    local invCfg = Config.LobbyInvite or {}
    local timeoutMs = math.max(10000, tonumber(invCfg.InviteTimeoutMs) or 60000)
    local now = GetNowMs()
    LobbyInvites[targetSrc] = {
        lobbyId = lobbyId,
        teamIndex = teamIndex,
        expiresAt = now + timeoutMs,
    }

    local ak = tostring(invCfg.AcceptKeyLabel or 'K')
    local dk = tostring(invCfg.DeclineKeyLabel or 'J')
    local teamName = teamIndex == 1 and lobby.team1.name or lobby.team2.name

    TriggerClientEvent('seoul_soccer:client:ShowLobbyInvite', targetSrc, {
        lobbyId = lobbyId,
        lobbyName = lobby.name,
        hostName = ResolvePlayerStatsName(src) or GetPlayerName(src) or 'Host',
        teamIndex = teamIndex,
        teamName = teamName,
        acceptKey = ak,
        declineKey = dk,
    })
    Bridge.NotifyPlayer(src, L('server.invite_sent'), 'success', 3500)
end)

local function GetPedCoordsSafeForNearby(src)
    if not src or src == 0 then return nil end
    if not GetPlayerPed or not GetEntityCoords then return nil end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

RegisterNetEvent('seoul_soccer:server:ResolveNearbyInviteTargets', function(requestId, nearbyIds)
    local src = source
    if not CheckLobbyActionRate(src, "nearby", 500) then return end
    requestId = tonumber(requestId)
    if not requestId or type(nearbyIds) ~= "table" then return end

    local cfg = Config.NearbyInvite or {}
    local maxR = math.max(5.0, tonumber(cfg.MaxRadius) or 20.0)
    local hostCoords = GetPedCoordsSafeForNearby(src)
    local out = {}

    -- Istemciden gelen liste spam'e karsi en fazla 20 ID islenir.
    local maxIds = math.min(#nearbyIds, 20)
    for i = 1, maxIds do
        local rawId = nearbyIds[i]
        local tid = tonumber(rawId)
        if tid and tid > 0 and tid ~= src and GetPlayerName(tid) then
            local inRange = true
            if hostCoords then
                local c = GetPedCoordsSafeForNearby(tid)
                if not c or #(hostCoords - c) > maxR then
                    inRange = false
                end
            end
            if inRange then
                local displayName = ResolvePlayerStatsName(tid)
                if not displayName or Trim(displayName) == "" then
                    displayName = Trim(GetPlayerName(tid) or "")
                end
                if displayName == "" then
                    displayName = ("ID %d"):format(tid)
                end
                out[#out + 1] = { serverId = tid, name = displayName }
            end
        end
    end

    TriggerClientEvent('seoul_soccer:client:NearbyPlayerNamesResult', src, requestId, out)
end)

RegisterNetEvent('seoul_soccer:server:AcceptLobbyInvite', function(lobbyId)
    local src = source
    if not CheckLobbyActionRate(src, "accept_invite", 700) then return end
    lobbyId = tonumber(lobbyId)
    local inv = LobbyInvites[src]
    if not inv or tonumber(inv.lobbyId) ~= lobbyId then
        LobbyInvites[src] = nil
        ClearLobbyInviteClient(src)
        Bridge.NotifyPlayer(src, L('server.invite_invalid'), 'error')
        return
    end

    local now = GetNowMs()
    if now > (tonumber(inv.expiresAt) or 0) then
        LobbyInvites[src] = nil
        ClearLobbyInviteClient(src)
        Bridge.NotifyPlayer(src, L('server.invite_expired'), 'error')
        return
    end

    local lobby = Lobbies[lobbyId]
    if not lobby or lobby.state ~= "waiting" then
        LobbyInvites[src] = nil
        ClearLobbyInviteClient(src)
        Bridge.NotifyPlayer(src, L('server.invite_lobby_gone'), 'error')
        return
    end

    if GetLobbyIdPlayerBelongsTo(src) then
        LobbyInvites[src] = nil
        ClearLobbyInviteClient(src)
        Bridge.NotifyPlayer(src, L('server.invite_you_busy'), 'error')
        return
    end

    local teamIndex = tonumber(inv.teamIndex) or 2
    if teamIndex ~= 1 and teamIndex ~= 2 then teamIndex = 2 end

    if not IsPlayerNearPitch(src, lobby.pitchId, 12.0) then
        Bridge.NotifyPlayer(src, L('server.lobby_too_far'), 'error', 4000)
        return
    end

    local alreadyInTeam1, alreadyInTeam2 = false, false
    for _, p in pairs(lobby.team1.players) do if p.src == src then alreadyInTeam1 = true end end
    for _, p in pairs(lobby.team2.players) do if p.src == src then alreadyInTeam2 = true end end
    if alreadyInTeam1 or alreadyInTeam2 then
        LobbyInvites[src] = nil
        ClearLobbyInviteClient(src)
        BroadcastLobbiesSync()
        Bridge.NotifyPlayer(src, L('server.invite_already_in_lobby'), 'inform', 3500)
        return
    end

    if teamIndex == 1 and WouldExceedTeamCapacity(lobby, 1, #lobby.team1.players + 1) then
        Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
        return
    end
    if teamIndex == 2 and WouldExceedTeamCapacity(lobby, 2, #lobby.team2.players + 1) then
        Bridge.NotifyPlayer(src, L('server.lobby_team_full'), 'error', 4000)
        return
    end

    local betAmount = tonumber(lobby.bet) or 0
    if betAmount > 0 and not (lobby.paidBySrc or {})[tostring(src)] then
        if not Bridge.RemoveMoney(src, betAmount) then
            Bridge.NotifyPlayer(src, L('server.lobby_bet_no_funds'), 'error', 4000)
            return
        end
        lobby.paidBySrc = lobby.paidBySrc or {}
        lobby.paidPassportBySrc = lobby.paidPassportBySrc or {}
        lobby.paidBySrc[tostring(src)] = betAmount
        local passport = Bridge.GetPassport and Bridge.GetPassport(src) or nil
        if passport then lobby.paidPassportBySrc[tostring(src)] = passport end
    end

    LobbyInvites[src] = nil
    ClearLobbyInviteClient(src)

    local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)
    if teamIndex == 1 then
        table.insert(lobby.team1.players, BuildLobbyPlayerEntry(src))
    else
        table.insert(lobby.team2.players, BuildLobbyPlayerEntry(src))
    end
    RefreshLobbyProximityGrace(lobby)
    if goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end
    BroadcastLobbiesSync()
    Bridge.NotifyPlayer(src, L('server.invite_joined'), 'success', 4000)
    Bridge.NotifyPlayer(lobby.host, L('server.invite_accepted_host', ResolvePlayerStatsName(src) or GetPlayerName(src) or '?'), 'inform', 4000)
end)

RegisterNetEvent('seoul_soccer:server:DeclineLobbyInvite', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    local inv = LobbyInvites[src]
    if not inv or tonumber(inv.lobbyId) ~= lobbyId then return end

    LobbyInvites[src] = nil
    ClearLobbyInviteClient(src)

    local lobby = Lobbies[lobbyId]
    if lobby and lobby.host and lobby.host ~= src then
        Bridge.NotifyPlayer(lobby.host, L('server.invite_declined_host', ResolvePlayerStatsName(src) or GetPlayerName(src) or '?'), 'inform', 4000)
    end
end)

RegisterNetEvent('seoul_soccer:server:LeaveTeam', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    local lobby = lobbyId and Lobbies[lobbyId] or nil
    if not lobby then return end
    if lobby.state ~= "waiting" then return end
    if tonumber(lobby.host) == tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.host_cannot_leave_team'), 'warning', 3000)
        return
    end

    local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)
    RefundLobbyEntry(lobby, src)
    local sid = tonumber(src)
    for i, p in ipairs(lobby.team1.players) do if tonumber(p.src) == sid then table.remove(lobby.team1.players, i) break end end
    for i, p in ipairs(lobby.team2.players) do if tonumber(p.src) == sid then table.remove(lobby.team2.players, i) break end end

    if goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end
    BroadcastLobbiesSync()
end)

--- Host ayrildiginda random olarak kalanlardan birine devret.
--- Aktif bir mac varsa tum lobi oyunculari icin snapshot yayinla (NUI isHost gorunumu anlik guncellensin).
--- Kalan kimse yoksa false doner.
local function MigrateHostInLobby(lobby, lobbyId, oldHostSrc)
    if not lobby or not lobbyId then return false end
    local oldHostName = ResolvePlayerStatsName(oldHostSrc) or GetPlayerName(oldHostSrc) or ("#" .. tostring(oldHostSrc))
    if lobby.state == "waiting" then
        RefundLobbyEntry(lobby, oldHostSrc)
    elseif lobby.state == "warmup" or lobby.state == "countdown" or lobby.state == "playing" or lobby.state == "paused" then
        MarkLobbyEntryForfeit(lobby, oldHostSrc)
    end
    -- Ayrilan host'u takimlardan temizle
    for i, p in ipairs(lobby.team1.players) do
        if p.src == oldHostSrc then table.remove(lobby.team1.players, i) break end
    end
    for i, p in ipairs(lobby.team2.players) do
        if p.src == oldHostSrc then table.remove(lobby.team2.players, i) break end
    end
    ClearGoalkeeperForPlayer(lobby, oldHostSrc)
    if lobby.ballOwner == oldHostSrc then
        SetLobbyBallOwner(lobby, nil)
    end

    local candidates = {}
    for _, p in ipairs(lobby.team1.players) do candidates[#candidates + 1] = p.src end
    for _, p in ipairs(lobby.team2.players) do candidates[#candidates + 1] = p.src end
    if #candidates == 0 then
        return false
    end

    local newHostSrc = candidates[math.random(1, #candidates)]
    lobby.host = newHostSrc

    local st = lobby.state
    local isActive = (st == "warmup" or st == "countdown" or st == "playing" or st == "paused")
    if isActive then
        for _, p in ipairs(lobby.team1.players) do
            TriggerClientEvent('seoul_soccer:client:HostTransferred', p.src,
                BuildMatchSnapshotForPlayer(lobby, lobbyId, p.src, newHostSrc))
        end
        for _, p in ipairs(lobby.team2.players) do
            TriggerClientEvent('seoul_soccer:client:HostTransferred', p.src,
                BuildMatchSnapshotForPlayer(lobby, lobbyId, p.src, newHostSrc))
        end
    end

    local newHostName = ResolvePlayerStatsName(newHostSrc) or GetPlayerName(newHostSrc) or ("#" .. tostring(newHostSrc))
    Bridge.NotifyPlayer(newHostSrc, L('server.host_transferred_to_you'), 'success', 4500)
    for _, psrc in ipairs(candidates) do
        if psrc ~= newHostSrc then
            if isActive then
                Bridge.NotifyPlayer(psrc, L('server.host_left_transfer', oldHostName, newHostName), 'warning', 4000)
            else
                Bridge.NotifyPlayer(psrc, L('server.host_transferred_in_lobby', newHostName), 'inform', 3500)
            end
        end
    end
    return true
end

RegisterNetEvent('seoul_soccer:server:LeaveLobby', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]
    if not lobby then return end

    local isHost = tonumber(lobby.host) == tonumber(src)
    local totalPlayers = CountLobbyPlayers(lobby)

    -- Kurucu ayriliyor ve lobide baska oyuncu var: host devri (disconnect ile ayni).
    if isHost and totalPlayers > 1 then
        local migrated = MigrateHostInLobby(lobby, lobbyId, src)
        if lobby.stealAttemptCooldowns then lobby.stealAttemptCooldowns[src] = nil end
        if lobby.hardStealAttemptCooldowns then lobby.hardStealAttemptCooldowns[src] = nil end
        if lobby.standTackleAttemptCooldowns then lobby.standTackleAttemptCooldowns[src] = nil end
        if lobby.hardStealVictimNoClaimUntil then lobby.hardStealVictimNoClaimUntil[src] = nil end
        if migrated then
            BroadcastLobbiesSync()
            return
        end
        -- Migrate basarisiz (beklenmez): kalanlari mac disi birak + lobiyi kaldir.
        local evac = GetAllPlayers(lobby)
        UnlockPitchDoorsForEveryone(lobby.pitchId)
        CleanupLobbyBall(lobby)
        ClearInvitesForLobby(lobbyId)
        if lobby.state == "waiting" then RefundAllLobbyEntries(lobby) end
        Lobbies[lobbyId] = nil
        -- RemovedFromMatch istemcide Bridge.Notify ile gosterilir; NotifyAll ile ikinci kez gosterme.
        local msg = L('server.host_left_cancel')
        for _, psrc in ipairs(evac) do
            TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', psrc, msg)
        end
        BroadcastLobbiesSync()
        return
    end

    -- Kurucu tek basina (veya normal oyuncu ayrilisi)
    local evacSolo = nil
    if isHost and totalPlayers <= 1 then
        evacSolo = GetAllPlayers(lobby)
    end

    if lobby.state == "waiting" then
        RefundLobbyEntry(lobby, src)
    elseif lobby.state == "warmup" or lobby.state == "countdown" or lobby.state == "playing" or lobby.state == "paused" then
        MarkLobbyEntryForfeit(lobby, src)
    end

    local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)
    for i, p in ipairs(lobby.team1.players) do if p.src == src then table.remove(lobby.team1.players, i) break end end
    for i, p in ipairs(lobby.team2.players) do if p.src == src then table.remove(lobby.team2.players, i) break end end

    if lobby.stealAttemptCooldowns then lobby.stealAttemptCooldowns[src] = nil end
    if lobby.hardStealAttemptCooldowns then lobby.hardStealAttemptCooldowns[src] = nil end
    if lobby.standTackleAttemptCooldowns then lobby.standTackleAttemptCooldowns[src] = nil end
    if lobby.hardStealVictimNoClaimUntil then lobby.hardStealVictimNoClaimUntil[src] = nil end

    if not isHost then
        local st = lobby.state
        if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
            local leaverName = ResolvePlayerStatsName(src) or GetPlayerName(src) or ("#" .. tostring(src))
            local msg = L('server.player_left_match', leaverName)
            for _, psrc in ipairs(GetAllPlayers(lobby)) do
                Bridge.NotifyPlayer(psrc, msg, 'inform', 3500)
            end
        end
    end

    if isHost then
        UnlockPitchDoorsForEveryone(lobby.pitchId)
        CleanupLobbyBall(lobby)
        ClearInvitesForLobby(lobbyId)
        Lobbies[lobbyId] = nil
        local msg = L('server.host_left_cancel')
        if evacSolo then
            for _, psrc in ipairs(evacSolo) do
                TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', psrc, msg)
            end
        end
    elseif goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end

    BroadcastLobbiesSync()
end)

--- Kurucu tarafindan bir oyuncunun lobi takimindan atilmasi.
--- Sadece waiting fazinda ve kurucu disindaki oyuncular hedeflenebilir.
RegisterNetEvent('seoul_soccer:server:KickPlayerFromLobby', function(lobbyId, targetSrc)
    local src = source
    lobbyId = tonumber(lobbyId)
    targetSrc = tonumber(targetSrc)
    if not lobbyId or not targetSrc then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end

    if lobby.host ~= src then
        Bridge.NotifyPlayer(src, L('server.kick_host_only'), 'error', 2500)
        return
    end
    if lobby.state ~= "waiting" then
        Bridge.NotifyPlayer(src, L('server.kick_waiting_only'), 'error', 2500)
        return
    end
    if targetSrc == src then
        Bridge.NotifyPlayer(src, L('server.kick_self'), 'error', 2500)
        return
    end
    if not IsPlayerInLobby(lobby, targetSrc) then
        Bridge.NotifyPlayer(src, L('server.kick_not_in_lobby'), 'error', 2500)
        return
    end

    RefundLobbyEntry(lobby, targetSrc)
    local goalieChanged = ClearGoalkeeperForPlayer(lobby, targetSrc)
    local removed = false
    for i, p in ipairs(lobby.team1.players) do
        if p.src == targetSrc then
            table.remove(lobby.team1.players, i)
            removed = true
            break
        end
    end
    if not removed then
        for i, p in ipairs(lobby.team2.players) do
            if p.src == targetSrc then
                table.remove(lobby.team2.players, i)
                removed = true
                break
            end
        end
    end

    if lobby.ballOwner == targetSrc then
        SetLobbyBallOwner(lobby, nil)
    end
    if lobby.stealAttemptCooldowns then lobby.stealAttemptCooldowns[targetSrc] = nil end
    if lobby.hardStealAttemptCooldowns then lobby.hardStealAttemptCooldowns[targetSrc] = nil end
    if lobby.standTackleAttemptCooldowns then lobby.standTackleAttemptCooldowns[targetSrc] = nil end
    if lobby.hardStealVictimNoClaimUntil then lobby.hardStealVictimNoClaimUntil[targetSrc] = nil end

    -- Davet durumunda bekleyen daveti temizle
    if LobbyInvites[targetSrc] and tonumber(LobbyInvites[targetSrc].lobbyId) == lobbyId then
        LobbyInvites[targetSrc] = nil
        ClearLobbyInviteClient(targetSrc)
    end

    if goalieChanged then
        BroadcastGoalkeeperState(lobby)
    end

    local targetName = ResolvePlayerStatsName(targetSrc) or GetPlayerName(targetSrc) or ("#" .. tostring(targetSrc))
    Bridge.NotifyPlayer(src, L('server.kick_success', targetName), 'success', 3500)
    -- Atilan oyuncu: RemovedFromMatch -> istemci tek bildirim.
    TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', targetSrc, L('server.kicked_by_host'))

    BroadcastLobbiesSync()
end)

RegisterNetEvent("seoul_soccer:server:RequestPitchDoorState", function()
    local src = source
    if not src then return end
    SendPitchDoorStateToPlayer(src)
end)

RegisterNetEvent("seoul_soccer:server:TogglePitchDoor", function(lobbyId, _doorIndex)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.host ~= src then
        Bridge.NotifyPlayer(src, L("server.door_host_only"), "error", 2200)
        return
    end
    local st = lobby.state
    if st ~= "warmup" and st ~= "countdown" and st ~= "playing" and st ~= "paused" then
        return
    end
    local n = GetPitchDoorCount(lobby.pitchId)
    if n == 0 then return end
    lobby.pitchDoorLocks = lobby.pitchDoorLocks or {}
    -- Tum kapilar es zamanli: en az biri kilitliyse tumunu ac, degilse tumunu kilitle.
    local anyLocked = false
    for i = 1, n do
        if lobby.pitchDoorLocks[i] == true then
            anyLocked = true
            break
        end
    end
    local nextState = not anyLocked
    for i = 1, n do
        lobby.pitchDoorLocks[i] = nextState
    end
    BroadcastPitchDoorState(lobby, lobbyId)
end)

local function CanClaimLooseBall(lobby, src)
    if not lobby or not src then return false end

    local ballEntity = lobby.ballEntity
    if not IsEntityHandleValid(ballEntity) then
        local netId = GetLobbyBallNetId(lobby)
        if not netId or netId == 0 or not NetworkDoesNetworkIdExist or not NetworkGetEntityFromNetworkId then
            return false
        end
        local okNet, exists = pcall(NetworkDoesNetworkIdExist, netId)
        if not okNet or not exists then return false end
        ballEntity = NetworkGetEntityFromNetworkId(netId)
        if not IsEntityHandleValid(ballEntity) then return false end
    end

    local ped = GetPlayerPedSafe(src)
    if not ped or ped == 0 or not IsEntityHandleValid(ped) then return false end

    local okBall, ballPos = pcall(GetEntityCoords, ballEntity)
    local okPed, pedPos = pcall(GetEntityCoords, ped)
    if not okBall or not ballPos or not okPed or not pedPos then return false end

    local dx = (ballPos.x or 0.0) - (pedPos.x or 0.0)
    local dy = (ballPos.y or 0.0) - (pedPos.y or 0.0)
    local dz = (ballPos.z or 0.0) - (pedPos.z or 0.0)
    local maxDistance = math.max(0.1, tonumber((Config.GoalDetection or {}).LooseClaimMaxDistance) or 2.35)
    return math.sqrt((dx * dx) + (dy * dy) + (dz * dz)) <= maxDistance
end

RegisterNetEvent('seoul_soccer:server:RequestBallPossession', function(lobbyId, forceTake, tackleMode, slideDirX, slideDirY)
    local src = source
    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if not IsPlayerInLobby(lobby, src) then return end
    if lobby.state == "waiting" or lobby.state == "ended" then return end
    -- Gol sonrasi top merkeze yerlestirilene kadar kimse sahiplik alamaz.
    if lobby.goalCenterSpawnPending == true then return end
    -- Sadece aktif mac fazinda top sahipligi (lobi disi / warmup / countdown engeli)
    if lobby.state ~= "playing" and lobby.state ~= "paused" then return end

    if lobby.kickoffLockActive == true then
        local t = GetPlayerTeamIndex(lobby, src)
        if t ~= 1 and t ~= 2 then
            return
        end
        if t ~= tonumber(lobby.kickoffAllowedTeam) then
            return
        end
    end

    local currentOwner = lobby.ballOwner
    local nowMs = GetNowMs()
    -- Hard slide sonrası top kısa bir pencere boyunca bilerek sahipsiz kalır.
    -- Bu sürede hiçbir claim/steal isteği sahiplik almamalı.
    local looseUntil = tonumber(lobby.looseBallUntil) or 0
    if (currentOwner == nil or currentOwner == 0) and nowMs < looseUntil then
        return
    end
    if tonumber(currentOwner) == tonumber(src) and tonumber(currentOwner) ~= 0 then
        SetLobbyBallOwner(lobby, src)
        return
    end

    if lobby.goalkeeperHold then
        return
    end

    -- Client sut/pas sonrasi owner=0; Release gecikti / esitlik tipi kaydiysa sunucu hala eski sahibi tutar.
    -- forceTake=false claim bu dalda hicbir sey yapmaz; rakip topu alamaz, sadece kayitli sahip "yenilenir".
    -- Top, kayitli sahibinin pedinden yeterince uzaktaysa sahipligi dusur ve bos-top claim'e dus.
    if not forceTake
        and currentOwner and currentOwner ~= 0 and currentOwner ~= src
    then
        local stealCfg = Config.StealSystem or {}
        local abandon = tonumber(stealCfg.ServerAbandonBallOwnerDistance) or 5.25
        if abandon > 0.5 and lobby.ballEntity and lobby.ballEntity ~= 0 and IsEntityHandleValid(lobby.ballEntity) then
            local ownerPed = GetPlayerPedSafe(currentOwner)
            if ownerPed and ownerPed ~= 0 and IsEntityHandleValid(ownerPed) then
                local okb, bpos = pcall(GetEntityCoords, lobby.ballEntity)
                local oko, opos = pcall(GetEntityCoords, ownerPed)
                if okb and bpos and oko and opos then
                    local dx = (bpos.x or 0.0) - (opos.x or 0.0)
                    local dy = (bpos.y or 0.0) - (opos.y or 0.0)
                    local dz = (bpos.z or 0.0) - (opos.z or 0.0)
                    local distOwnerBall = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                    if distOwnerBall >= abandon then
                        SetLobbyBallOwner(lobby, nil)
                        currentOwner = tonumber(lobby.ballOwner) or 0
                    end
                end
            end
        end
    end

    if currentOwner == nil or currentOwner == 0 then
        if not CanClaimLooseBall(lobby, src) then return end
        local blockedVictim = tonumber(lobby.hardStealBlockedVictim) or 0
        local blockedVictimUntil = tonumber(lobby.hardStealBlockedVictimUntil) or 0
        if src == blockedVictim then
            if blockedVictimUntil == 0 or nowMs < blockedVictimUntil then
                return
            end
            lobby.hardStealBlockedVictim = 0
            lobby.hardStealBlockedVictimUntil = 0
        end
        lobby.hardStealVictimNoClaimUntil = lobby.hardStealVictimNoClaimUntil or {}
        local reclaimBlockedUntil = tonumber(lobby.hardStealVictimNoClaimUntil[src]) or 0
        if nowMs < reclaimBlockedUntil then
            return
        end
        if reclaimBlockedUntil > 0 then
            lobby.hardStealVictimNoClaimUntil[src] = nil
        end
        SetLobbyBallOwner(lobby, src)
        return
    end

    if not IsPlayerInLobby(lobby, currentOwner) then
        if not CanClaimLooseBall(lobby, src) then return end
        SetLobbyBallOwner(lobby, src)
        return
    end

    if forceTake then
        local now = nowMs
        local stealCfg = Config.StealSystem or {}
        local slideCfg = Config.SlideTackle or {}
        local standCfg = Config.StandTackle or {}
        local isHardSteal = tackleMode == "hard"
        local isStandTackle = tackleMode == "stand"
        local isSoftSteal = not isHardSteal and not isStandTackle

        -- Takım arkadaşından top çalmak engelli (soft + hard + stand)
        local ownerTeam = GetPlayerTeamIndex(lobby, currentOwner)
        local attackerTeam = GetPlayerTeamIndex(lobby, src)
        if ownerTeam ~= 0 and attackerTeam ~= 0 and ownerTeam == attackerTeam then
            Bridge.NotifyPlayer(src, L('server.teammate_no_steal'), 'warning', 1400)
            return
        end

        -- Normal top calma (SHIFT + E): basit ve deterministik.
        -- Mesafe uygunsa hic animasyon / stumble / ragdoll / front-shield kullanmadan sahiplik degisir.
        if isSoftSteal then
            local softOwnerDist = tonumber(stealCfg.StealOwnerDistance) or tonumber(stealCfg.StealDistance) or 1.55
            local ownerSpeed = GetPlayerSpeedSafe(currentOwner)
            local stationarySpeed = tonumber(stealCfg.StationaryOwnerSpeed) or 0.25
            if ownerSpeed ~= nil and ownerSpeed <= stationarySpeed then
                softOwnerDist = tonumber(stealCfg.StationaryOwnerDistance) or softOwnerDist
            end
            if not IsWithinStealDistance(currentOwner, src, softOwnerDist) then
                return
            end

            lobby.stealAttemptCooldowns = lobby.stealAttemptCooldowns or {}
            local softCdMs = tonumber(stealCfg.ServerStealCooldownMs) or 350
            local nextAllowedAt = tonumber(lobby.stealAttemptCooldowns[src]) or 0
            if now < nextAllowedAt then
                return
            end
            lobby.stealAttemptCooldowns[src] = now + math.max(0, softCdMs)

            local softCfg = stealCfg.SoftSteal or {}
            local guardMs = tonumber(softCfg.ContactGuardMs) or 450
            TriggerClientEvent('seoul_soccer:client:SoftStealContactGuard', src, currentOwner, guardMs)
            TriggerClientEvent('seoul_soccer:client:SoftStealContactGuard', currentOwner, src, guardMs)
            TriggerClientEvent('seoul_soccer:client:BallStealSuccess', src, "soft", false)
            SetLobbyBallOwner(lobby, src)
            return
        end

        local hardStealDist = tonumber(slideCfg.StealDistance) or 2.15
        local softPedFallback = tonumber(stealCfg.StealDistance) or 1.55
        local softBallDist = tonumber(stealCfg.StealBallDistance) or softPedFallback
        local hardBallDist = tonumber(slideCfg.HardStealBallDistance) or math.max(hardStealDist, softBallDist)
        local standBallDist = tonumber(standCfg.StealBallDistance) or 1.6

        local ballReach = slideCfg.BallReach or {}
        local zTolHard = tonumber(ballReach.ZToleranceHard) or 1.2
        local zTolSoft = tonumber(ballReach.ZToleranceSoft) or 0.8

        local function ensureBool(val, fallback)
            if val == nil then return fallback end
            return val == true
        end

        if isHardSteal then
            -- Hard tackle: varsayilan olarak topa VE sahip ped'e birlikte (heading slab veya daire).
            -- HardStealRequireBallAndOwner = false iken eski OR: topa VEYA sahibe.
            local extraBall = tonumber(slideCfg.ServerHardBallExtraTol) or 0.28
            local extraOwner = tonumber(slideCfg.ServerHardOwnerExtraTol) or 0.55
            local hardBallTol = hardBallDist + extraBall
            local hardOwnerTol = hardStealDist + extraOwner
            local closeToBall = IsHardStealBallCloseServer(lobby, src, slideCfg, slideDirX, slideDirY, zTolHard)
            local closeToOwner = IsHardStealOwnerCloseServer(currentOwner, src, slideCfg, slideDirX, slideDirY, hardOwnerTol)
            local requireBoth = slideCfg.HardStealRequireBallAndOwner ~= false
            if requireBoth then
                if not (closeToBall == true and closeToOwner) then
                    return
                end
            else
                if not ((closeToBall == true) or closeToOwner) then
                    return
                end
            end
            if not HardStealSlideEngagesTarget(slideCfg, src, currentOwner, lobby, slideDirX, slideDirY) then
                return
            end
        elseif isStandTackle then
            if standCfg.Enabled == false then
                return
            end
            local standExtra = tonumber(standCfg.ServerStandBallExtraTol) or 0.45
            local standOwnerTol = standBallDist + (tonumber(standCfg.ServerStandOwnerExtraTol) or 0.55)
            local closeToBall = IsAttackerCloseToBallForSteal(lobby, src, standBallDist + standExtra, zTolSoft)
            local closeToOwner = IsWithinStealDistance(currentOwner, src, standOwnerTol)
            if not ((closeToBall == true) or closeToOwner) then
                return
            end
        end

        if now < (tonumber(lobby.ownerProtectionUntil) or 0) then
            Bridge.NotifyPlayer(src, L('server.owner_protecting'), 'warning')
            return
        end

        -- Front shield: sadece soft + stand; hard slide (arkadan dahil) shield'i geriye geciyor.
        if (not isHardSteal) and IsBlockedByFrontShield(currentOwner, src, stealCfg) then
            Bridge.NotifyPlayer(src, L('server.steal_front_blocked'), 'warning')
            return
        end

        local serverStealCooldownMs
        local cooldowns
        if isHardSteal then
            -- Hard slide cooldownunu client zaten yonetiyor; server tarafinda burada uzun gate yazmak
            -- ayni slide penceresindeki retry'leri kesip "kaydim ama calmadi" hissini artiriyordu.
            -- Bu map sadece soft->hard gecis gate'i gibi dis kaynakli lock'lar icin okunur.
            cooldowns = lobby.hardStealAttemptCooldowns or {}
            lobby.hardStealAttemptCooldowns = cooldowns
        elseif isStandTackle then
            serverStealCooldownMs = tonumber(standCfg.CooldownMs) or 1500
            cooldowns = lobby.standTackleAttemptCooldowns or {}
            lobby.standTackleAttemptCooldowns = cooldowns
        else
            serverStealCooldownMs = tonumber(stealCfg.ServerStealCooldownMs) or 900
            cooldowns = lobby.stealAttemptCooldowns or {}
            lobby.stealAttemptCooldowns = cooldowns
        end

        local nextAllowedAt = tonumber(cooldowns[src]) or 0
        if now < nextAllowedAt then
            if isHardSteal then
                local waitSeconds = math.ceil((nextAllowedAt - now) / 1000)
                Bridge.NotifyPlayer(src, L('server.steal_wait_hard', waitSeconds), 'warning', 1600)
            end
            return
        end
        if not isHardSteal then
            cooldowns[src] = now + math.max(0, serverStealCooldownMs)
        end

        -- Cross-cooldown zincirleme engelleri: bir mudahaleden hemen sonra farkli tip spam edilmesin.
        if isHardSteal then
            -- Hard -> soft spam engeli (korundu).
            lobby.stealAttemptCooldowns = lobby.stealAttemptCooldowns or {}
            local softCdMs = tonumber(stealCfg.ServerStealCooldownMs) or 900
            local existingSoft = tonumber(lobby.stealAttemptCooldowns[src]) or 0
            local newSoft = now + math.max(0, softCdMs)
            if existingSoft < newSoft then
                lobby.stealAttemptCooldowns[src] = newSoft
            end
        elseif isStandTackle then
            -- Stand -> soft k\u0131sa gate (ayn\u0131 tick'te E spam).
            lobby.stealAttemptCooldowns = lobby.stealAttemptCooldowns or {}
            local softCdMs = tonumber(stealCfg.ServerStealCooldownMs) or 900
            local existingSoft = tonumber(lobby.stealAttemptCooldowns[src]) or 0
            local newSoft = now + math.max(0, softCdMs)
            if existingSoft < newSoft then
                lobby.stealAttemptCooldowns[src] = newSoft
            end
        else
            -- Soft -> hard gate: basarili soft sonrasi ayni oyuncunun hemen R ile slide'a gitmesini 1500ms engelle.
            local hardGateMs = math.max(0, tonumber(stealCfg.ServerHardAfterSoftGateMs) or 1500)
            if hardGateMs > 0 then
                lobby.hardStealAttemptCooldowns = lobby.hardStealAttemptCooldowns or {}
                local existingHard = tonumber(lobby.hardStealAttemptCooldowns[src]) or 0
                local newHard = now + hardGateMs
                if existingHard < newHard then
                    lobby.hardStealAttemptCooldowns[src] = newHard
                end
            end
        end

        -- Hard slide ile arkadan mudahale tespiti (foul flag; sadece event + notify, kart/penalty yok).
        local backTackleFoul = false
        if isHardSteal then
            local btCfg = slideCfg.BackTackleFoul or {}
            if ensureBool(btCfg.Enabled, true) then
                local thr = tonumber(btCfg.DotThreshold) or -0.3
                backTackleFoul = IsSlideFromBehind(currentOwner, src, thr)
            end
        end

        -- Soft steal yukarida erken return ile biter. Burasi sadece hard/stand reaksiyon akisi.
        local stealMode = (isHardSteal and "hard") or (isStandTackle and "stand") or "soft"
        if currentOwner and currentOwner ~= 0 and (isHardSteal or isStandTackle) then
            TriggerClientEvent('seoul_soccer:client:BallStolen', currentOwner, src, stealMode, backTackleFoul)
        end
        TriggerClientEvent('seoul_soccer:client:BallStealSuccess', src, stealMode, backTackleFoul)

        -- Foul bildirimleri (sadece hard slide + arkadan). Kart / penalty buraya ileride eklenebilir.
        if backTackleFoul then
            local btCfg = slideCfg.BackTackleFoul or {}
            if ensureBool(btCfg.NotifyAttacker, true) then
                Bridge.NotifyPlayer(src, L('server.slide_back_foul_attacker'), 'warning', 1800)
            end
            if ensureBool(btCfg.NotifyVictim, true) and currentOwner and currentOwner ~= 0 then
                Bridge.NotifyPlayer(currentOwner, L('server.slide_back_foul_victim'), 'warning', 1800)
            end
        end

        if isHardSteal then
            -- Slide tackle: gercekci his icin top SAHIPLENILMEZ; bosa dusurulur.
            -- Saldirgan slide'ini tamamlar, top one firlar, sahadakiler kovalayabilir.
            -- Saldirgan kendi clientinde topa forward impulse uygular ("LooseBallAfterSlide").
            local popCfg = (slideCfg and slideCfg.LooseBallPop) or {}
            -- OwnerlessMs yanlis 0 gelirse aninda claim + ayaga yapistirma olur; minimum pencere zorunlu.
            local ownerlessMs = math.max(400, tonumber(popCfg.OwnerlessMs) or 700)
            local victimReclaimBlockMs = math.max(
                0,
                tonumber(popCfg.VictimReclaimBlockMs)
                    or tonumber(popCfg.VictimPickupLockMs)
                    or 1200
            )
            local effectiveVictimBlockMs = math.max(victimReclaimBlockMs, ownerlessMs + 3500)
            if currentOwner and currentOwner ~= 0 and victimReclaimBlockMs > 0 then
                lobby.hardStealVictimNoClaimUntil = lobby.hardStealVictimNoClaimUntil or {}
                local prev = tonumber(lobby.hardStealVictimNoClaimUntil[currentOwner]) or 0
                local nextUntil = now + effectiveVictimBlockMs
                if prev < nextUntil then
                    lobby.hardStealVictimNoClaimUntil[currentOwner] = nextUntil
                end
                lobby.hardStealBlockedVictim = currentOwner
                lobby.hardStealBlockedVictimUntil = nextUntil
            end
            SetLobbyBallOwner(lobby, nil)
            -- Pas/sut sonrasi SetLobbyBallOwner(nil) looseBallUntil sifirlar; hard slide penceresi burada yenilenir.
            lobby.looseBallUntil = now + ownerlessMs

            -- Server tarafindan da fizik uygula: tum client'larda ayni top konumu/hizi gorunsun.
            if lobby.ballEntity and lobby.ballEntity ~= 0 and IsEntityHandleValid(lobby.ballEntity)
                and GetEntityCoords and SetEntityVelocity
            then
                local atkPed = GetPlayerPedSafe(src)
                if atkPed and atkPed ~= 0 and IsEntityHandleValid(atkPed) then
                    local ap = GetEntityCoords(atkPed)
                    if ap then
                        local dx, dy = ResolveHardSlideLooseDir(slideDirX, slideDirY, atkPed)
                        local popMin = tonumber(popCfg.MinSpeed) or 5.5
                        local popMax = tonumber(popCfg.MaxSpeed) or 9.0
                        local popBonus = tonumber(popCfg.SpeedBonus) or 2.0
                        local popLift = tonumber(popCfg.Lift) or 1.2
                        local popForward = tonumber(popCfg.ForwardOffset) or 1.0
                        local popHeight = tonumber(popCfg.HeightAbovePed) or 0.55
                        local atkSpeed = GetPlayerSpeedSafe(src) or 0.0
                        local popSpeed = math.max(popMin, math.min(atkSpeed + popBonus, popMax))

                        TryCallEntityNative(lobby.ballEntity, SetEntityDynamic, true)
                        TryCallEntityNative(lobby.ballEntity, SetEntityCollision, true, true)
                        if ActivatePhysics then
                            TryCallEntityNative(lobby.ballEntity, ActivatePhysics)
                        end
                        if SetEntityCoordsNoOffset then
                            TryCallEntityNative(
                                lobby.ballEntity,
                                SetEntityCoordsNoOffset,
                                ap.x + (dx * popForward),
                                ap.y + (dy * popForward),
                                ap.z + popHeight,
                                false, false, false
                            )
                        elseif SetEntityCoords then
                            TryCallEntityNative(
                                lobby.ballEntity,
                                SetEntityCoords,
                                ap.x + (dx * popForward),
                                ap.y + (dy * popForward),
                                ap.z + popHeight,
                                false, false, false, false
                            )
                        end
                        TryCallEntityNative(lobby.ballEntity, SetEntityVelocity, dx * popSpeed, dy * popSpeed, popLift)
                    end
                end
            end

            RemoveDuplicateSoccerBallsNearPitch(lobby)

            -- Deterministik pop: ball netId + kayma dogrultusu (client slide vektoru + sunucu dogrulama).
            -- Top entity kontrolu kimdeyse o client push'u uygular; digerleri RequestBallControl basarisiz olur ve cikis yapar.
            local ballNetId = 0
            if lobby.ballEntity and lobby.ballEntity ~= 0 and NetworkGetNetworkIdFromEntity then
                ballNetId = NetworkGetNetworkIdFromEntity(lobby.ballEntity) or 0
            end
            local fwd = nil
            local atkPed2 = GetPlayerPedSafe(src)
            if atkPed2 and atkPed2 ~= 0 then
                local fx, fy = ResolveHardSlideLooseDir(slideDirX, slideDirY, atkPed2)
                fwd = { x = fx, y = fy, z = 0.0 }
            end
            TriggerClientEvent('seoul_soccer:client:LooseBallAfterSlide', -1, lobbyId, src, ballNetId, fwd, now)
        else
            SetLobbyBallOwner(lobby, src)
        end
    end
end)

RegisterNetEvent('seoul_soccer:server:BeginSoftStealContactGuard', function(lobbyId, targetSrc, requestedMs)
    local src = source
    lobbyId = tonumber(lobbyId)
    targetSrc = tonumber(targetSrc) or 0
    if not lobbyId or targetSrc == 0 or targetSrc == src then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if not IsPlayerInLobby(lobby, src) or not IsPlayerInLobby(lobby, targetSrc) then return end
    if lobby.state ~= "playing" and lobby.state ~= "paused" then return end
    if tonumber(lobby.ballOwner) ~= targetSrc then return end

    local ownerTeam = GetPlayerTeamIndex(lobby, targetSrc)
    local attackerTeam = GetPlayerTeamIndex(lobby, src)
    if ownerTeam ~= 0 and attackerTeam ~= 0 and ownerTeam == attackerTeam then return end

    local stealCfg = Config.StealSystem or {}
    local softCfg = stealCfg.SoftSteal or {}
    local now = GetNowMs()
    local spamLockMs = math.max(250, tonumber(softCfg.SpamLockMs) or tonumber(softCfg.InputLockMs) or 650)
    lobby.softStealGuardCooldowns = lobby.softStealGuardCooldowns or {}
    local guardKey = ("%s:%s"):format(src, targetSrc)
    if now < (tonumber(lobby.softStealGuardCooldowns[guardKey]) or 0) then return end
    lobby.softStealGuardCooldowns[guardKey] = now + spamLockMs

    local ownerDist = tonumber(stealCfg.StealOwnerDistance) or tonumber(stealCfg.StealDistance) or 1.55
    local ownerSpeed = GetPlayerSpeedSafe(targetSrc)
    local stationarySpeed = tonumber(stealCfg.StationaryOwnerSpeed) or 0.25
    if ownerSpeed ~= nil and ownerSpeed <= stationarySpeed then
        ownerDist = tonumber(stealCfg.StationaryOwnerDistance) or ownerDist
    end
    if not IsWithinStealDistance(targetSrc, src, ownerDist + 0.25) then return end

    local maxMs = (tonumber(softCfg.HoldMs) or 1200) + (tonumber(softCfg.ContactGuardMs) or 1500) + 250
    local durationMs = math.max(150, math.min(tonumber(requestedMs) or maxMs, maxMs))
    TriggerClientEvent('seoul_soccer:client:SoftStealContactGuard', src, targetSrc, durationMs)
    TriggerClientEvent('seoul_soccer:client:SoftStealContactGuard', targetSrc, src, durationMs)
end)

RegisterNetEvent('seoul_soccer:server:ReleaseBallPossession', function(lobbyId, actionKind, shotPower, charge, applyTrail)
    local src = source
    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if not IsPlayerInLobby(lobby, src) then return end
    if lobby.state ~= "playing" and lobby.state ~= "paused" then return end
    local boRelease = tonumber(lobby.ballOwner)
    if boRelease and boRelease ~= 0 and boRelease == tonumber(src) then
        local kind = type(actionKind) == 'string' and actionKind or ''
        if kind == 'shot' or kind == 'pass' or kind == 'cross' or kind == 'keeper_throw' or kind == 'keeper_punt' then
            lobby.lastBallAction = {
                src = src,
                team = GetPlayerTeamIndex(lobby, src),
                kind = kind,
                atMs = GetNowMs(),
            }
        end
        if kind == 'pass' or kind == 'cross' or kind == 'keeper_throw' then
            RecordAssistCandidate(lobby, src)
        end
        ClearGoalkeeperHold(lobby, true)
        SetLobbyBallOwner(lobby, nil)

        -- Entity control, pas/sut sonrasi eski sahibinde kalir (SetNetworkIdCanMigrate=false
        -- otomatik migrasyonu engeller). Alici client'in NetworkRequestControlOfEntity isteği
        -- bu pencerede yanit alabilsin diye kisa sure migration acik birakilir.
        local releaseNetId = GetLobbyBallNetId(lobby)
        if releaseNetId and releaseNetId ~= 0 and SetNetworkIdCanMigrate then
            SetNetworkIdCanMigrate(releaseNetId, true)
            SetTimeout(1200, function()
                if releaseNetId ~= 0 and SetNetworkIdCanMigrate then
                    SetNetworkIdCanMigrate(releaseNetId, false)
                end
            end)
        end

        local st = Config.ShotTrail or {}
        if kind == 'shot' and st.SyncRemoteShotTrailToLobby ~= false and applyTrail == true then
            local sp = tonumber(shotPower)
            local ch = tonumber(charge)
            if sp and ch ~= nil then
                ch = math.max(0.0, math.min(1.0, ch))
                sp = math.max(0.0, math.min(55.0, sp))
                local netId = GetLobbyBallNetId(lobby)
                if netId and netId ~= 0 then
                    for _, psrc in ipairs(GetAllPlayers(lobby)) do
                        if psrc ~= src then
                            TriggerClientEvent('seoul_soccer:client:LobbyShotTrailFx', psrc, netId, sp, ch)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('seoul_soccer:server:RequestGoalkeeperSave', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)

    local gkCfg = Config.Goalkeeper or {}
    if gkCfg.Enabled == false or not lobbyId then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.state ~= "playing" and lobby.state ~= "paused" and lobby.state ~= "warmup" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local teamIndex = GetPlayerTeamIndex(lobby, src)
    if teamIndex ~= 1 and teamIndex ~= 2 then return end
    if tonumber((lobby.goalkeepers or {})[teamIndex]) ~= tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.not_goalkeeper'), 'warning', 1600)
        return
    end

    local now = GetNowMs()
    lobby.goalkeeperSaveCooldowns = lobby.goalkeeperSaveCooldowns or {}
    local nextSaveAt = tonumber(lobby.goalkeeperSaveCooldowns[src]) or 0
    if now < nextSaveAt then return end
    local baseCooldown = math.max(0, tonumber(gkCfg.SaveCooldownMs) or 2200)
    lobby.goalkeeperSaveCooldowns[src] = now + baseCooldown

    if not IsPlayerInGoalkeeperArea(lobby, src, teamIndex, tonumber(gkCfg.ServerDistanceTolerance) or 1.0) then
        Bridge.NotifyPlayer(src, L('server.not_in_gk_area'), 'warning', 1600)
        return
    end

    local ballPos = GetBallCoordsForGoalCheck(lobby)
    if not ballPos then return end

    local catchDistance = tonumber(gkCfg.CatchDistance) or 2.6
    local parryDistance = tonumber(gkCfg.ParryDistance) or 4.2
    local catchGoalDistance = tonumber(gkCfg.GoalPointCatchDistance) or catchDistance
    local parryGoalDistance = tonumber(gkCfg.GoalPointParryDistance) or parryDistance
    local catchMaxZ = tonumber(gkCfg.CatchMaxZAboveKeeper)
    local parryMaxZ = tonumber(gkCfg.ParryMaxZAboveKeeper)

    -- Parry menzili + Z tavani: cok yuksek lob save tetiklemesin.
    if not IsBallInGoalkeeperSaveRange(lobby, src, teamIndex, ballPos, parryDistance, parryGoalDistance, parryMaxZ, parryMaxZ) then
        return
    end

    -- Yon kontrolu: top kaleciye yaklasir yonde mi?
    local pedPos = GetKeeperPedPos(src)
    local ballVel = GetBallVelocityVec(lobby)
    local towardDot = 1.0
    local distPedToBall3d = nil
    if pedPos and ballPos then
        local dx0 = pedPos.x - ballPos.x
        local dy0 = pedPos.y - ballPos.y
        local dz0 = pedPos.z - ballPos.z
        distPedToBall3d = math.sqrt((dx0 * dx0) + (dy0 * dy0) + (dz0 * dz0))
    end
    if pedPos and ballVel then
        local dx = pedPos.x - ballPos.x
        local dy = pedPos.y - ballPos.y
        local dz = pedPos.z - ballPos.z
        local toLen = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
        local vLen = math.sqrt((ballVel.x * ballVel.x) + (ballVel.y * ballVel.y) + (ballVel.z * ballVel.z))
        if toLen > 0.001 and vLen > 0.001 then
            towardDot = ((ballVel.x * dx) + (ballVel.y * dy) + (ballVel.z * dz)) / (toLen * vLen)
        end
    end

    local closeCatchD = tonumber(gkCfg.CloseCatchDistance) or 0.0
    local inCloseCatchBand = (closeCatchD > 0.001 and distPedToBall3d ~= nil and distPedToBall3d <= closeCatchD)
    local catchAnimCfg = gkCfg.CatchAnimations or {}
    local lowCatchMaxZ = tonumber(catchAnimCfg.LowMaxZAbovePed) or 0.55
    local highCatchMinZ = tonumber(catchAnimCfg.HighMinZAbovePed) or 1.15
    local lowCatchRange = catchDistance + (tonumber(gkCfg.ServerDistanceTolerance) or 1.0)
    local forceLowCatch = catchAnimCfg.ForceLowCatch ~= false
        and pedPos ~= nil
        and ballPos ~= nil
        and distPedToBall3d ~= nil
        and distPedToBall3d <= lowCatchRange
        and ((ballPos.z - pedPos.z) <= lowCatchMaxZ)
    local forceHighCatch = catchAnimCfg.ForceHighCatch ~= false
        and pedPos ~= nil
        and ballPos ~= nil
        and distPedToBall3d ~= nil
        and distPedToBall3d <= lowCatchRange
        and ((ballPos.z - pedPos.z) >= highCatchMinZ)

    local requireToward = gkCfg.RequireBallToward ~= false
    local towardMin = tonumber(gkCfg.BallTowardDotMin) or 0.05
    if requireToward and ballVel and towardDot < towardMin and not inCloseCatchBand and not forceLowCatch and not forceHighCatch then
        -- Top kaleciden uzaklasiyor / yan geciyor: save tetiklenmesin ve tam cooldown yakilmasin
        lobby.goalkeeperSaveCooldowns[src] = now + math.floor(baseCooldown * 0.25)
        return
    end

    -- Hiz bazli catch sansi
    local ballSpeed = GetBallSpeed(lobby)
    local catchMaxSpeed = tonumber(gkCfg.CatchMaxBallSpeed) or 13.0
    local catchFullSpeed = tonumber(gkCfg.CatchFullSpeed) or 7.0
    local requiresKnownSpeed = gkCfg.CatchRequiresKnownSpeed ~= false
    local probabilistic = gkCfg.ProbabilisticCatch ~= false

    local chance
    if ballSpeed == nil then
        chance = requiresKnownSpeed and 0.0 or 0.85
    elseif ballSpeed <= catchFullSpeed then
        chance = 1.0
    elseif ballSpeed >= catchMaxSpeed then
        chance = 0.0
    elseif probabilistic and catchMaxSpeed > catchFullSpeed then
        chance = 1.0 - ((ballSpeed - catchFullSpeed) / (catchMaxSpeed - catchFullSpeed))
    else
        chance = 1.0
    end

    -- Aci bonusu: top tam cepheden geliyorsa hafif bonus
    local angleBonusMin = tonumber(gkCfg.AngleCatchBonusMin) or 0.35
    if chance > 0 and ballVel and towardDot >= angleBonusMin then
        chance = math.min(1.0, chance + 0.1)
    end

    -- Kafa uzerinden gecen lob: catch iptal, parry'e dus
    if pedPos and catchMaxZ and (ballPos.z - pedPos.z) > catchMaxZ then
        chance = 0.0
    end

    -- Catch icin daha dar menzil gerekir
    local inCatchRange = IsBallInGoalkeeperSaveRange(
        lobby, src, teamIndex, ballPos, catchDistance, catchGoalDistance, catchMaxZ, catchMaxZ
    )
    if not inCatchRange then
        chance = 0.0
    end

    -- Yere yakin veya havadan gelen top E-save menzilindeyse parry/fumble degil, direkt elde tutma.
    if inCatchRange and (forceLowCatch or forceHighCatch) then
        chance = 1.0
    end

    -- Top kaleciye iyice yaklasti: olasilik / bilinmeyen hiz reddi yerine tut (yavas/orta hiz bandi).
    -- CatchMaxZ ile lob zaten chance=0; burada tekrar lob uzerinden zorlamayiz.
    local closeMaxSp = tonumber(gkCfg.CloseCatchMaxBallSpeed) or 6.5
    if inCatchRange and inCloseCatchBand and (ballSpeed == nil or ballSpeed <= closeMaxSp) then
        local lobOver = pedPos and catchMaxZ and (ballPos.z - pedPos.z) > catchMaxZ
        if not lobOver then
            chance = 1.0
        end
    end

    local roll = math.random()
    if chance > 0 and roll <= chance then
        lobby.goalkeeperHold = {
            src = src,
            team = teamIndex,
            untilTime = now + math.max(1000, tonumber(gkCfg.HoldMaxMs) or 6500),
            catchMeta = BuildGoalkeeperCatchMeta(lobby, src, teamIndex, ballPos, pedPos, ballVel, "catch"),
        }
        SetLobbyBallOwner(lobby, src)
        BroadcastGoalkeeperHoldState(lobby)
        Bridge.NotifyPlayer(src, L('server.gk_ball_held'), 'success', 1800)

        local holdUntil = lobby.goalkeeperHold.untilTime
        CreateThread(function()
            Wait(math.max(1000, tonumber(gkCfg.HoldMaxMs) or 6500))
            local l = Lobbies[lobbyId]
            if not l or not l.goalkeeperHold then return end
            if tonumber(l.goalkeeperHold.src) ~= tonumber(src) then return end
            if tonumber(l.goalkeeperHold.untilTime) ~= tonumber(holdUntil) then return end
            ClearGoalkeeperHold(l, true)
            if l.ballOwner == src then
                SetLobbyBallOwner(l, nil)
            end
            Bridge.NotifyPlayer(src, L('server.gk_held_too_long'), 'warning', 1800)
        end)
    else
        ParryBallAwayFromGoal(lobby, src, teamIndex, ballPos)
        SetLobbyBallOwner(lobby, nil)
        BroadcastToLobby(lobby, 'seoul_soccer:client:GoalkeeperParry', src)

        -- Catch denenebilir bir top fumble edildiyse ek cooldown + bildirim
        local failedExtra = math.max(0, tonumber(gkCfg.FailedSaveExtraCooldownMs) or 0)
        if failedExtra > 0 and chance > 0 then
            lobby.goalkeeperSaveCooldowns[src] = now + baseCooldown + failedExtra
            Bridge.NotifyPlayer(src, L('server.gk_fumble'), 'warning', tonumber(gkCfg.FumbleNotifyMs) or 1400)
        end
    end
end)

-- YENI: Kaleciye ozel "top ayagin dibindeyken ELLE AL" eventi.
-- E (save) gelen top icindi (RequireBallToward + ParryDistance + catch chance). Yerde duran /
-- yavas yuvarlanan topa GK uzanir ve elle alir. Catch-rolu YOK, deterministic bir al.
-- Kosullar: GK + kendi alaninda + top yakin + alcak + yavas + (varsayilan) top sahipsiz.
RegisterNetEvent('seoul_soccer:server:RequestGoalkeeperPickup', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)

    local gkCfg = Config.Goalkeeper or {}
    local pickupCfg = gkCfg.PickupAtFeet or {}
    if gkCfg.Enabled == false or pickupCfg.Enabled == false or not lobbyId then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.state ~= "playing" and lobby.state ~= "paused" and lobby.state ~= "warmup" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local teamIndex = GetPlayerTeamIndex(lobby, src)
    if teamIndex ~= 1 and teamIndex ~= 2 then return end
    if tonumber((lobby.goalkeepers or {})[teamIndex]) ~= tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.not_goalkeeper'), 'warning', 1600)
        return
    end

    -- Cooldown: save ile ortak sayac (goalkeeperSaveCooldowns); E/G spamini engellemek icin.
    local now = GetNowMs()
    lobby.goalkeeperSaveCooldowns = lobby.goalkeeperSaveCooldowns or {}
    local nextAllowedAt = tonumber(lobby.goalkeeperSaveCooldowns[src]) or 0
    if now < nextAllowedAt then return end
    local baseCooldown = math.max(0, tonumber(pickupCfg.CooldownMs) or 800)

    -- GK alani kontrolu (ceza sahasi esdegeri). Tolerance pickup icin default save ile ayni.
    local areaTolerance = tonumber(pickupCfg.ServerDistanceTolerance) or tonumber(gkCfg.ServerDistanceTolerance) or 1.0
    if not IsPlayerInGoalkeeperArea(lobby, src, teamIndex, areaTolerance) then
        Bridge.NotifyPlayer(src, L('server.not_in_gk_area'), 'warning', 1600)
        return
    end

    if lobby.goalkeeperHold then
        return
    end

    -- Top sahibi kontrolu: varsayilan olarak sadece SAHIPSIZ top kaldirilir (OnlyLooseBall=true).
    local onlyLoose = (pickupCfg.OnlyLooseBall ~= false)
    local currentOwner = tonumber(lobby.ballOwner) or 0
    if onlyLoose and currentOwner ~= 0 and currentOwner ~= tonumber(src) then
        Bridge.NotifyPlayer(src, L('server.gk_pickup_ball_not_loose'), 'warning', 1400)
        return
    end

    local ballPos = GetBallCoordsForGoalCheck(lobby)
    if not ballPos then return end

    -- Mesafe kontrolu: GK ped <-> top 3D.
    local pedPos = GetKeeperPedPos(src)
    if not pedPos then return end
    local dx = pedPos.x - ballPos.x
    local dy = pedPos.y - ballPos.y
    local dz = pedPos.z - ballPos.z
    local dist3d = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
    local maxDist = (tonumber(pickupCfg.BallMaxDistance) or 2.0) + areaTolerance
    if dist3d > maxDist then
        Bridge.NotifyPlayer(src, L('server.gk_pickup_too_far'), 'warning', 1400)
        return
    end

    -- Alcak olmali: top GK kafasinin ustunde degil.
    local maxZ = tonumber(pickupCfg.BallMaxZAbovePed) or 1.3
    if (ballPos.z - pedPos.z) > (maxZ + 0.25) then
        Bridge.NotifyPlayer(src, L('server.gk_pickup_too_high'), 'warning', 1400)
        return
    end

    -- Yavas olmali: sert sut halindeki topa pickup yok (E-save o ise icin).
    local maxSpeed = tonumber(pickupCfg.BallMaxSpeed) or 4.5
    local ballSpeed = GetBallSpeed(lobby)
    if ballSpeed and ballSpeed > (maxSpeed + 1.5) then
        Bridge.NotifyPlayer(src, L('server.gk_pickup_too_fast'), 'warning', 1400)
        return
    end

    -- Tum kontroller gecti: catch akisi ile ayni state'i uygula (hold + ball owner + broadcast).
    lobby.goalkeeperSaveCooldowns[src] = now + baseCooldown
    lobby.goalkeeperHold = {
        src = src,
        team = teamIndex,
        untilTime = now + math.max(1000, tonumber(gkCfg.HoldMaxMs) or 6500),
        catchMeta = BuildGoalkeeperCatchMeta(lobby, src, teamIndex, ballPos, pedPos, nil, "pickup"),
    }
    SetLobbyBallOwner(lobby, src)
    BroadcastGoalkeeperHoldState(lobby)
    Bridge.NotifyPlayer(src, L('server.gk_pickup_success'), 'success', 1400)

    -- HoldMaxMs asilirsa otomatik birakma (catch akisiyla ayni guard).
    local holdUntil = lobby.goalkeeperHold.untilTime
    CreateThread(function()
        Wait(math.max(1000, tonumber(gkCfg.HoldMaxMs) or 6500))
        local l = Lobbies[lobbyId]
        if not l or not l.goalkeeperHold then return end
        if tonumber(l.goalkeeperHold.src) ~= tonumber(src) then return end
        if tonumber(l.goalkeeperHold.untilTime) ~= tonumber(holdUntil) then return end
        ClearGoalkeeperHold(l, true)
        if l.ballOwner == src then
            SetLobbyBallOwner(l, nil)
        end
        Bridge.NotifyPlayer(src, L('server.gk_held_too_long'), 'warning', 1800)
    end)
end)

RegisterNetEvent('seoul_soccer:server:ToggleGoalkeeper', function(lobbyId, goalTeam)
    local src = source
    lobbyId = tonumber(lobbyId)
    goalTeam = tonumber(goalTeam)

    local gkCfg = Config.Goalkeeper or {}
    if gkCfg.Enabled == false then return end
    if not lobbyId or (goalTeam ~= 1 and goalTeam ~= 2) then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.state == "waiting" or lobby.state == "ended" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local playerTeam = GetPlayerTeamIndex(lobby, src)
    if playerTeam ~= goalTeam then
        Bridge.NotifyPlayer(src, L('server.gk_wrong_goal'), 'error', 2500)
        return
    end

    local goalPoint = GetGoalkeeperPointForTeam(lobby.pitchId, goalTeam)
    if not goalPoint then
        Bridge.NotifyPlayer(src, L('server.gk_point_missing'), 'error', 2500)
        return
    end

    if GetPlayerPed and GetEntityCoords then
        local ped = GetPlayerPedSafe(src)
        if ped == 0 then return end
        local pos = GetEntityCoords(ped)
        if not pos then return end
        local dx = pos.x - goalPoint.x
        local dy = pos.y - goalPoint.y
        local dz = pos.z - goalPoint.z
        local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
        local allowedDist = (tonumber(gkCfg.InteractDistance) or 2.8) + (tonumber(gkCfg.ServerDistanceTolerance) or 1.25)
        if dist > allowedDist then
            Bridge.NotifyPlayer(src, L('server.gk_too_far_from_goal'), 'warning', 2500)
            return
        end
    end

    lobby.goalkeepers = lobby.goalkeepers or {}
    local currentKeeper = tonumber(lobby.goalkeepers[goalTeam]) or 0
    local now = GetNowMs()
    if currentKeeper == src then
        lobby.goalkeepers[goalTeam] = nil
        ClearGoalkeeperHold(lobby, true)
        if lobby.ballOwner == src then
            SetLobbyBallOwner(lobby, nil)
        end
        BroadcastGoalkeeperState(lobby)
        Bridge.NotifyPlayer(src, L('server.gk_left'), 'inform', 2500)
        return
    end

    if currentKeeper ~= 0 and IsPlayerInLobby(lobby, currentKeeper) then
        Bridge.NotifyPlayer(src, L('server.gk_slot_taken'), 'warning', 2500)
        return
    end

    lobby.goalkeeperSwitchCooldowns = lobby.goalkeeperSwitchCooldowns or {}
    local switchCooldownMs = math.max(0, tonumber(gkCfg.SwitchCooldownMs) or 30000)
    local nextSwitchAt = tonumber(lobby.goalkeeperSwitchCooldowns[src]) or 0
    if switchCooldownMs > 0 and now < nextSwitchAt then
        local waitSeconds = math.ceil((nextSwitchAt - now) / 1000)
        Bridge.NotifyPlayer(src, L('server.gk_switch_wait', waitSeconds), 'warning', 2200)
        return
    end

    ClearGoalkeeperForPlayer(lobby, src)
    lobby.goalkeepers[goalTeam] = src
    lobby.goalkeeperSwitchCooldowns[src] = now + switchCooldownMs
    BroadcastGoalkeeperState(lobby)
    Bridge.NotifyPlayer(src, L('server.gk_became'), 'success', 2500)
end)

RegisterNetEvent('seoul_soccer:server:LeaveGoalkeeper', function(lobbyId)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.state == "waiting" or lobby.state == "ended" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local changed = ClearGoalkeeperForPlayer(lobby, src)
    if lobby.ballOwner == src then
        SetLobbyBallOwner(lobby, nil)
    end
    if changed then
        BroadcastGoalkeeperState(lobby)
        Bridge.NotifyPlayer(src, L('server.gk_left'), 'inform', 1800)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for key in pairs(LobbyActionCooldowns) do
        if string.sub(key, 1, #tostring(src) + 1) == tostring(src) .. ':' then
            LobbyActionCooldowns[key] = nil
        end
    end
    LobbyInvites[src] = nil
    ClearLobbyInviteClient(src)

    local hostLobbiesToProcess = {}
    local syncNeeded = false
    local droppedName = ResolvePlayerStatsName(src) or GetPlayerName(src) or ("#" .. tostring(src))

    for lobbyId, lobby in pairs(Lobbies) do
        if lobby.host == src then
            hostLobbiesToProcess[#hostLobbiesToProcess + 1] = lobbyId
        else
            if lobby.state == "waiting" then
                RefundLobbyEntry(lobby, src)
            elseif lobby.state == "warmup" or lobby.state == "countdown" or lobby.state == "playing" or lobby.state == "paused" then
                MarkLobbyEntryForfeit(lobby, src)
            end
            local goalieChanged = ClearGoalkeeperForPlayer(lobby, src)
            local removed = false
            for i, p in ipairs(lobby.team1.players) do
                if p.src == src then table.remove(lobby.team1.players, i) removed = true break end
            end
            if not removed then
                for i, p in ipairs(lobby.team2.players) do
                    if p.src == src then table.remove(lobby.team2.players, i) removed = true break end
                end
            end
            if lobby.ballOwner == src then
                SetLobbyBallOwner(lobby, nil)
            end
            if lobby.stealAttemptCooldowns then lobby.stealAttemptCooldowns[src] = nil end
            if lobby.hardStealAttemptCooldowns then lobby.hardStealAttemptCooldowns[src] = nil end
            if lobby.standTackleAttemptCooldowns then lobby.standTackleAttemptCooldowns[src] = nil end
            if lobby.hardStealVictimNoClaimUntil then lobby.hardStealVictimNoClaimUntil[src] = nil end
            if goalieChanged then
                BroadcastGoalkeeperState(lobby)
            end
            if removed then
                local st = lobby.state
                if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
                    local msg = L('server.player_disconnected_match', droppedName)
                    for _, psrc in ipairs(GetAllPlayers(lobby)) do
                        Bridge.NotifyPlayer(psrc, msg, 'warning', 3500)
                    end
                end
            end
            if removed or goalieChanged then
                syncNeeded = true
            end
        end
    end

    for _, lobbyId in ipairs(hostLobbiesToProcess) do
        local lobby = Lobbies[lobbyId]
        if lobby then
            local migrated = MigrateHostInLobby(lobby, lobbyId, src)
            if migrated then
                syncNeeded = true
            else
                local evac = GetAllPlayers(lobby)
                UnlockPitchDoorsForEveryone(lobby.pitchId)
                CleanupLobbyBall(lobby)
                ClearInvitesForLobby(lobbyId)
                if lobby.state == "waiting" then RefundAllLobbyEntries(lobby) end
                Lobbies[lobbyId] = nil
                local msg = L('server.host_left_cancel')
                for _, psrc in ipairs(evac) do
                    TriggerClientEvent('seoul_soccer:client:RemovedFromMatch', psrc, msg)
                end
                syncNeeded = true
            end
        end
    end

    if syncNeeded then
        BroadcastLobbiesSync()
    end
end)

-- ─────────────────────────────────────────────
-- ADIM 1: "Maçı Başlat" butonuna basıldı → WARMUP
-- UI kapanır, scoreboard + tuş rehberi açılır (maç henüz başlamaz)
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:StartMatch', function(lobbyId)
    local src = source
    if type(lobbyId) == "table" then
        lobbyId = lobbyId.lobbyId or lobbyId.id
    end
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]

    if not lobby then return end
    if lobby.host ~= src then return end
    if lobby.state ~= "waiting" then return end
    if #(lobby.team1.players or {}) < 1 or #(lobby.team2.players or {}) < 1 then
        Bridge.NotifyPlayer(src, L('server.start_need_both_teams'), 'error', 3500)
        return
    end

    -- Isinma: top yok; F5 (BeginMatch) ile countdown baslayinca spawn edilir.
    lobby.team1.score = 0
    lobby.team2.score = 0
    ResetLobbyMatchStats(lobby)
    lobby.state = "warmup"
    lobby.pitchProximityGraceUntil = GetNowMs() + (tonumber((Config.PitchBounds or {}).ProximityGraceMs) or 15000)
    ClearInvitesForLobby(lobbyId)
    InitLobbyPitchDoorLocks(lobby)
    BroadcastPitchDoorState(lobby, lobbyId)

    -- Tüm oyunculara warmup bildirimi gönder (NUI kapanır, scoreboard açılır)
    for _, p in ipairs(lobby.team1.players) do
        TriggerClientEvent('seoul_soccer:client:EnterWarmup', p.src, BuildMatchSnapshotForPlayer(lobby, lobbyId, p.src, src))
    end
    for _, p in ipairs(lobby.team2.players) do
        TriggerClientEvent('seoul_soccer:client:EnterWarmup', p.src, BuildMatchSnapshotForPlayer(lobby, lobbyId, p.src, src))
    end

    local footballWarmupPayload = {
        homeName = lobby.team1.name,
        awayName = lobby.team2.name,
        homeScore = tonumber(lobby.team1.score) or 0,
        awayScore = tonumber(lobby.team2.score) or 0,
        timeLeft = tonumber(lobby.timeLeft) or 0,
        totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
        state = "warmup",
        status = "WARMUP",
        period = "WARMUP",
    }
    TriggerClientEvent('football:startMatch', -1, footballWarmupPayload)
    TriggerEvent('football:server:ingest', footballWarmupPayload)
    BroadcastLobbiesSync()
    BroadcastLobbyMenuLiveTick(lobbyId)
end)

local function StartLobbyTimer(lobbyId)
    if LobbyTimerActive[lobbyId] then return end
    LobbyTimerActive[lobbyId] = true
    CreateThread(function()
        while Lobbies[lobbyId] and Lobbies[lobbyId].state == "playing" do
            Wait(1000)
            local l = Lobbies[lobbyId]
            if not l then break end
            if l.state ~= "playing" then break end

            l.timeLeft = l.timeLeft - 1
            BroadcastToLobby(l, 'seoul_soccer:client:TimerTick', l.timeLeft, l.team1.score, l.team2.score)
            local footballTickPayload = {
                homeName = l.team1 and l.team1.name or nil,
                awayName = l.team2 and l.team2.name or nil,
                homeScore = tonumber(l.team1 and l.team1.score) or 0,
                awayScore = tonumber(l.team2 and l.team2.score) or 0,
                timeLeft = tonumber(l.timeLeft) or 0,
                totalSeconds = math.max(0, tonumber(l.duration) or 0) * 60,
                state = "playing",
                status = "LIVE",
            }
            TriggerClientEvent('football:updateTime', -1, footballTickPayload)
            TriggerEvent('football:server:ingest', footballTickPayload)
            BroadcastLobbyMenuLiveTick(lobbyId)

            if l.timeLeft <= 0 then
                DestroyLobbyAfterMatch(lobbyId, 'time_up')
                break
            end
        end
        LobbyTimerActive[lobbyId] = nil
    end)
end

-- ─────────────────────────────────────────────
-- ADIM 2: Host F5'e bastı → Maç BAŞLAR (timer tick)
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:BeginMatch', function(lobbyId)
    local src = source
    if type(lobbyId) == "table" then
        lobbyId = lobbyId.lobbyId or lobbyId.id
    end
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end
    local lobby = Lobbies[lobbyId]

    if not lobby then return end
    if lobby.host ~= src then return end
    if lobby.state == "warmup" then
        PlaceLobbyBallAtCenter(lobby)
        SetLobbyBallOwner(lobby, nil)
        lobby.state = "countdown"
        BroadcastToLobby(lobby, 'seoul_soccer:client:StartCountdown')
        BroadcastLobbiesSync()
        BroadcastLobbyMenuLiveTick(lobbyId)

        CreateThread(function()
            Wait(3000)
            local l = Lobbies[lobbyId]
            if not l then return end
            if l.state ~= "countdown" then return end

            -- Countdown bitiminde topu tekrar merkez + zemin snap (baslangicta havada kalma).
            PlaceLobbyBallAtCenter(l)
            SetLobbyBallOwner(l, nil)

            l.state = "playing"
            BroadcastToLobby(l, 'seoul_soccer:client:MatchStateChanged', "playing", l.timeLeft)
            local footballStartPayload = {
                homeName = l.team1 and l.team1.name or nil,
                awayName = l.team2 and l.team2.name or nil,
                homeScore = tonumber(l.team1 and l.team1.score) or 0,
                awayScore = tonumber(l.team2 and l.team2.score) or 0,
                timeLeft = tonumber(l.timeLeft) or 0,
                totalSeconds = math.max(0, tonumber(l.duration) or 0) * 60,
                state = "playing",
                status = "LIVE",
            }
            TriggerClientEvent('football:startMatch', -1, footballStartPayload)
            TriggerEvent('football:server:ingest', footballStartPayload)
            BroadcastLobbiesSync()
            BroadcastLobbyMenuLiveTick(lobbyId)
            StartLobbyTimer(lobbyId)
        end)
        return
    end

    if lobby.state ~= "paused" then return end

    lobby.state = "playing"
    BroadcastToLobby(lobby, 'seoul_soccer:client:MatchStateChanged', "playing", lobby.timeLeft)
    local footballResumePayload = {
        homeName = lobby.team1 and lobby.team1.name or nil,
        awayName = lobby.team2 and lobby.team2.name or nil,
        homeScore = tonumber(lobby.team1 and lobby.team1.score) or 0,
        awayScore = tonumber(lobby.team2 and lobby.team2.score) or 0,
        timeLeft = tonumber(lobby.timeLeft) or 0,
        totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
        state = "playing",
        status = "LIVE",
    }
    TriggerClientEvent('football:updateTime', -1, footballResumePayload)
    TriggerEvent('football:server:ingest', footballResumePayload)
    BroadcastLobbiesSync()
    BroadcastLobbyMenuLiveTick(lobbyId)
    StartLobbyTimer(lobbyId)
end)

-- ─────────────────────────────────────────────
-- Host F6 → Timer Durdur / Devam
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:TogglePause', function(lobbyId)
    local src = source
    local lobby = Lobbies[lobbyId]

    if not lobby then return end
    if lobby.host ~= src then return end

    if lobby.state == "playing" then
        lobby.state = "paused"
        BroadcastToLobby(lobby, 'seoul_soccer:client:MatchStateChanged', "paused", lobby.timeLeft)
        local footballPausePayload = {
            timeLeft = tonumber(lobby.timeLeft) or 0,
            totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
            state = "paused",
            status = "PAUSED",
        }
        TriggerClientEvent('football:updateTime', -1, footballPausePayload)
        TriggerEvent('football:server:ingest', footballPausePayload)
    elseif lobby.state == "paused" then
        lobby.state = "playing"
        BroadcastToLobby(lobby, 'seoul_soccer:client:MatchStateChanged', "playing", lobby.timeLeft)
        local footballUnpausePayload = {
            timeLeft = tonumber(lobby.timeLeft) or 0,
            totalSeconds = math.max(0, tonumber(lobby.duration) or 0) * 60,
            state = "playing",
            status = "LIVE",
        }
        TriggerClientEvent('football:updateTime', -1, footballUnpausePayload)
        TriggerEvent('football:server:ingest', footballUnpausePayload)
        StartLobbyTimer(lobbyId)
    end
    BroadcastLobbiesSync()
    BroadcastLobbyMenuLiveTick(lobbyId)
end)

-- ─────────────────────────────────────────────
-- Host F7 → Maçı Bitir
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:EndMatch', function(lobbyId)
    local src = source
    local lobby = Lobbies[lobbyId]

    if not lobby then return end
    if lobby.host ~= src then return end

    DestroyLobbyAfterMatch(lobbyId, 'host_ended')
end)

CreateThread(function()
    while true do
        Wait(2000)
        local now = GetNowMs()
        local toExpire = {}
        for tid, inv in pairs(LobbyInvites) do
            if inv and now > (tonumber(inv.expiresAt) or 0) then
                toExpire[#toExpire + 1] = tid
            end
        end
        for _, tid in ipairs(toExpire) do
            LobbyInvites[tid] = nil
            ClearLobbyInviteClient(tid)
            Bridge.NotifyPlayer(tid, L('server.invite_expired'), 'error', 4000)
        end
    end
end)

--- Sahipsiz top: sunucu otoritesi ile konum/hiz tum istemcilere hizalanir (slide / kapma sonrasi).
CreateThread(function()
    while true do
        local bs = Config.BallStreaming or {}
        local interval = tonumber(bs.ServerLooseBallSyncMs)
        if not interval or interval <= 0 then
            Wait(2000)
        else
            Wait(math.max(75, math.floor(interval)))
            local ids = {}
            for id in pairs(Lobbies) do
                ids[#ids + 1] = id
            end
            for _, lobbyId in ipairs(ids) do
                local lobby = Lobbies[lobbyId]
                if lobby and (lobby.state == "playing" or lobby.state == "paused" or lobby.state == "countdown") then
                    local owner = tonumber(lobby.ballOwner) or 0
                    if owner == 0 and lobby.ballEntity and IsEntityHandleValid(lobby.ballEntity) then
                        local bs = Config.BallStreaming or {}
                        local forceMs = tonumber(bs.LooseBallForceStopAfterMs) or 0
                        if forceMs > 0 and lobby.ballLooseSinceMs then
                            local nowMs = GetNowMs()
                            if (nowMs - lobby.ballLooseSinceMs) >= forceMs then
                                local okp, pos = pcall(GetEntityCoords, lobby.ballEntity)
                                if okp and pos and GetGroundZFor_3dCoord then
                                    local okg, r1, r2 = pcall(GetGroundZFor_3dCoord, pos.x, pos.y, pos.z + 0.55, false)
                                    local gz = nil
                                    if okg and r1 == true and type(r2) == "number" then
                                        gz = r2
                                    elseif okg and type(r1) == "number" then
                                        gz = r1
                                    end
                                    local maxH = tonumber(bs.LooseBallForceStopMaxHeightAboveGround) or 0.78
                                    if gz and gz > -400.0 and (pos.z - gz) <= maxH then
                                        if SetEntityVelocity then
                                            pcall(SetEntityVelocity, lobby.ballEntity, 0.0, 0.0, 0.0)
                                        end
                                        if SetEntityAngularVelocity then
                                            pcall(SetEntityAngularVelocity, lobby.ballEntity, 0.0, 0.0, 0.0)
                                        end
                                    end
                                end
                            end
                        end
                        local ok, pos = pcall(GetEntityCoords, lobby.ballEntity)
                        if ok and pos then
                            local vx, vy, vz = 0.0, 0.0, 0.0
                            if GetEntityVelocity then
                                local okv, vel = pcall(GetEntityVelocity, lobby.ballEntity)
                                if okv and vel then
                                    vx = tonumber(vel.x) or 0.0
                                    vy = tonumber(vel.y) or 0.0
                                    vz = tonumber(vel.z) or 0.0
                                end
                            end
                            BroadcastToLobby(lobby, 'seoul_soccer:client:BallLoosePhysicsSync', lobbyId, pos.x, pos.y, pos.z, vx, vy, vz)
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    local gd = Config.GoalDetection or {}
    local interval = math.max(50, tonumber(gd.PollIntervalMs) or 150)
    while true do
        local hasLobbies = next(Lobbies) ~= nil
        Wait(hasLobbies and interval or 2000)
        if not hasLobbies then goto goal_poll_cont end
        local ids = {}
        for id in pairs(Lobbies) do
            ids[#ids + 1] = id
        end
        for _, lid in ipairs(ids) do
            local lobby = Lobbies[lid]
            if lobby and lobby.state == "playing" then
                TryProcessLobbyGoal(lid, lobby)
            end
        end
        ::goal_poll_cont::
    end
end)

RegisterNetEvent('seoul_soccer:server:ReportBallOutOfBounds', function(lobbyId, x, y, z)
    local src = source
    lobbyId = tonumber(lobbyId)
    if not lobbyId then return end

    local pb = Config.PitchBounds or {}
    if pb.InstantBallOobCenterRespawn ~= true then return end

    local lobby = Lobbies[lobbyId]
    if not lobby then return end
    if lobby.state ~= "playing" and lobby.state ~= "paused" then return end
    if not IsPlayerInLobby(lobby, src) then return end

    local ballPos = GetBallCoordsForGoalCheck(lobby)
    if not ballPos then
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        if not x or not y or not z then return end
        ballPos = { x = x, y = y, z = z }
    end

    TryResetLobbyBallOutOfBounds(lobby, ballPos)
end)

CreateThread(function()
    while true do
        local pb = Config.PitchBounds or {}
        local hasLobbies = next(Lobbies) ~= nil
        local interval
        if not hasLobbies then
            interval = 2000
        elseif pb.InstantBallOobCenterRespawn == true then
            interval = math.max(50, tonumber(pb.InstantBallOobPollIntervalMs) or 120)
        else
            interval = math.max(200, tonumber(pb.PollIntervalMs) or 500)
        end
        Wait(interval)
        if not hasLobbies then goto pitch_bounds_cont end
        local ids = {}
        for id in pairs(Lobbies) do
            ids[#ids + 1] = id
        end
        for _, lid in ipairs(ids) do
            local lobby = Lobbies[lid]
            if lobby then
                ProcessPitchBoundsForLobby(lid, lobby)
            end
        end
        ::pitch_bounds_cont::
    end
end)

-- ─────────────────────────────────────────────
-- Leaderboard
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:server:RequestLeaderboard', function()
    local src = source
    if not CheckLobbyActionRate(src, "leaderboard", 1500) then return end
    local acfg = Config.Assists or {}
    local orderBy = tostring(acfg.LeaderboardOrderBy or 'goals')
    local result
    if SoccerAPI and SoccerAPI.FetchLeaderboard then
        result = SoccerAPI.FetchLeaderboard(10, orderBy)
    else
        local orderSql = 'ORDER BY goals DESC, assists DESC'
        if orderBy == 'assists' then
            orderSql = 'ORDER BY assists DESC, goals DESC'
        end
        result = MySQL.query.await(
            ('SELECT identifier, name, goals, assists, matches FROM seoul_soccer_player_stats '
                .. "WHERE TRIM(COALESCE(name, '')) <> '' AND LOWER(TRIM(name)) <> 'unknown' "
                .. '%s LIMIT 10'):format(orderSql),
            {}
        )
    end
    TriggerClientEvent('seoul_soccer:client:LeaderboardData', src, result or {})
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    local fb = Config.FootballScoreboard or {}
    if fb.Enabled ~= false then
        TriggerClientEvent('football:scoreboardStandby', -1)
    end
    CreateThread(function()
        Wait(1200)
        TriggerClientEvent('seoul_soccer:client:ReleaseAllPitchDoors', -1)
        SyncStadiumScoreboard()
    end)
end)

AddEventHandler("seoul_soccer:server:SyncStadiumScoreboard", function(targetSrc)
    SyncStadiumScoreboard(targetSrc)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    local fb = Config.FootballScoreboard or {}
    if fb.Enabled ~= false then
        TriggerClientEvent('football:scoreboardStandby', -1)
    end
    for _, lobby in pairs(Lobbies) do
        -- Reinicio manual do resource não pode consumir taxas de entrada já pagas.
        RefundAllLobbyEntries(lobby)
        CleanupLobbyBall(lobby)
    end
    TriggerClientEvent('seoul_soccer:client:ReleaseAllPitchDoors', -1)
end)

-- Harici API (modules/server/api.lua) icin cekirdek referanslar
SoccerAPI = SoccerAPI or {}
SoccerAPI.Lobbies = Lobbies
SoccerAPI.GetLobbiesTable = function()
    return Lobbies
end
SoccerAPI.GetPlayerIdentifier = GetPlayerIdentifier
SoccerAPI.GetPitchById = GetPitchById
SoccerAPI.CountLobbyPlayers = CountLobbyPlayers
SoccerAPI.IsPlayerInLobby = IsPlayerInLobby
SoccerAPI.GetLobbyTeamCapacityCaps = GetLobbyTeamCapacityCaps
SoccerAPI.BuildGoalTimeline = BuildLobbyGoalTimeline
