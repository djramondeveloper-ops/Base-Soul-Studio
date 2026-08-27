# Installation

## Requirements

Install and start these resources before seoul_soccer:

* `oxmysql`
* One framework: `qb-core` (QBCore) or `es_extended` (ESX)
* A notification provider. `ox_lib` is recommended; QBCore and ESX notifications are also supported.
* One target provider: `ox_target`, `qb-target`, or `qtarget`

## Add the resource

1. Copy the `seoul_soccer` folder into your server's `resources` directory.
2. Open `config.lua` and set `Config.Core`, `Config.Locale`, and `Config.Bridge` for your server.
3. Add the resources to `server.cfg` in dependency order:

```cfg
ensure oxmysql
ensure ox_lib
ensure qb-core
ensure ox_target
ensure seoul_soccer
```

For ESX, replace `qb-core` with `es_extended`. Replace the target resource if you use `qb-target` or `qtarget`.

## Database

No SQL import is required. On startup, the resource automatically creates these tables when they do not exist:

* `seoul_soccer_player_stats`
* `seoul_soccer_match_history`
* `seoul_soccer_match_participants`

The database user must have permission to create tables and indexes.

## Test

1. Restart the server and check the console for Lua or database errors.
2. Join the server and use `/soccer`, or interact with a pitch NPC.
3. Create a lobby, join both teams, start a match, score a goal, and end the match.
4. Confirm that the scoreboard updates and a row is saved to `seoul_soccer_match_history`.

If you use standalone stadium scoreboard control, grant its ACE permission only to trusted staff:

```cfg
add_ace group.admin football.scoreboard allow
```
