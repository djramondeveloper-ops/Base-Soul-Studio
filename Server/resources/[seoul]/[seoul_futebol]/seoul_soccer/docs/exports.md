# Server exports

Call exports from a server script with `exports['seoul_soccer']:ExportName(...)`.

## Data and match exports

| Export | Arguments | Result |
| --- | --- | --- |
| `GetTabletBridgeSnapshot` | none | Pitch overview, active lobbies, and server summary |
| `GetLeaderboard` | `limit?, orderBy?` | Formatted leaderboard rows |
| `GetLeaderboardTable` | `limit?, orderBy?` | Leaderboard table payload |
| `GetPlayerStats` | `identifierOrSource` | One player's aggregate stats or `nil` |
| `GetPlayerMatchHistory` | `identifierOrSource, limit?, offset?` | Formatted match history rows |
| `GetPlayerMatchHistoryRaw` | `identifierOrSource, limit?, offset?` | Raw database history rows |
| `GetPlayerMatchHistoryTable` | `identifierOrSource, limit?, offset?` | Match history table payload |
| `GetPitchOverview` | none | Pitch overview rows |
| `GetPitchOverviewTable` | none | Pitch overview table payload |
| `GetActiveLobbies` | none | Active lobby rows |
| `GetActiveLobbiesTable` | none | Active lobby table payload |
| `GetServerSummary` | none | Current server and match totals |
| `GetRecentTopScorers` | `days?, limit?` | Recent scorer rows |
| `GetMatchById` | `matchId` | Saved match or `nil` |
| `IsPlayerInMatch` | `source` | `true` during warmup, countdown, play, or pause |
| `GetPlayerLobbyId` | `source` | Lobby ID or `nil` |

```lua
local stats = exports['seoul_soccer']:GetPlayerStats(source)
local history = exports['seoul_soccer']:GetPlayerMatchHistory(source, 10, 0)
local inMatch = exports['seoul_soccer']:IsPlayerInMatch(source)
```

## Standalone scoreboard exports

| Export | Arguments | Result |
| --- | --- | --- |
| `StartFootballMatch` | `payload` | Starts or replaces standalone board state |
| `UpdateFootballScore` | `payload` | Updates team names or scores |
| `UpdateFootballTime` | `payload` | Updates elapsed/remaining time and state |
| `GoalScored` | `payload` | Applies a goal update and goal overlay |
| `GetFootballMatchState` | none | Current stadium scoreboard snapshot |

These exports are server-side and remain available for trusted integrations. `ScoreboardDriver = "soccer"` ignores external client control events.

```lua
exports['seoul_soccer']:StartFootballMatch({
    homeName = 'City',
    awayName = 'United',
    minutes = 20,
    homeScore = 0,
    awayScore = 0,
})

exports['seoul_soccer']:UpdateFootballScore({ homeScore = 1, awayScore = 0 })
```

## Optional server events

When `Config.API.EnableServerEvents` is enabled, another server resource can use `seoul_soccer:server:ApiQuery`. Listen for the matching request ID on `seoul_soccer:server:ApiQueryResult`.

```lua
local requestId = ('my-resource:%d'):format(os.time())

AddEventHandler('seoul_soccer:server:ApiQueryResult', function(id, ok, payload)
    if id ~= requestId then return end
    print(('Soccer query completed: %s'):format(ok))
end)

TriggerEvent('seoul_soccer:server:ApiQuery', 'leaderboard', { limit = 10 }, requestId)
```

The resource emits `seoul_soccer:matchSaved` after a match and its participants are stored.

```lua
AddEventHandler('seoul_soccer:matchSaved', function(matchId, lobbyId, endReason, match)
    print(('Saved soccer match %d on pitch %s'):format(matchId, match.pitchId))
end)
```
