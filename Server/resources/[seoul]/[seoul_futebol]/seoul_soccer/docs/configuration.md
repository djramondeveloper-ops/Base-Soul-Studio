# Configuration

Edit `config.lua`. Values not overridden there come from `config_defaults.lua`.

## Core and locale

`Config.Core` selects `QBCore` or `ESX`. `Config.Locale` selects `en`, `tr`, `pt`, `es`, `de`, or `pl`. Locale files are stored in `locales/`; missing phrases fall back to the configured English text in code or config.

`Config.MatchDuration` is the default match length in minutes. `Config.Debug` enables development logging and should normally remain `false` on production servers.

## Bridge

`Config.Bridge.Notify` accepts `ox_lib`, `qbcore`, `esx`, or `auto`. `Config.Bridge.Target` accepts `auto`, `ox_target`, `qb-target`, or `qtarget`. In `auto` mode the resource chooses a supported resource that is already started.

## Commands and keys

`Config.Commands` controls command names such as the main menu and goal debug command. `Config.HostKeys` contains FiveM control IDs for starting, pausing, ending, and operating pitch doors. `Config.PlayerKeys`, `Config.LobbyInvite`, and the goalkeeper settings control player inputs; registered key mappings can also be changed in GTA's Key Bindings menu.

## Pitches

Each entry in `Config.Pitches` has a unique `id`, display name, center, radius, image, NPC, goals, and optional doors. Goal centers and goal lines must match the map geometry. Door entries may control map doors or movable props. Localized pitch and door names use `config.pitches.<id>` and `config.doors.<pitch_id>_<index>` in each locale file.

## Balls

`Config.Balls` defines the lobby choices. Each ball needs a unique `id`, model, image, and roll settings. Localized names use `config.balls.<id>`. Goal suggestions and loose-ball claims are checked against the server's authentic ball entity; `Config.GoalDetection.ClientSuggestMaxPedBall`, `GoalSuggestMaxBallDeviation`, and `LooseClaimMaxDistance` tune the validation distances.

## Uniforms

`Config.UniformNumbers` sets the allowed jersey number range. `Config.Uniforms.team_a` and `team_b` contain male and female clothing components. Negative drawable values select items relative to the end of the available clothing list; `fallbackItem` is used when an add-on clothing pack is unavailable. Localized kit names use `config.uniforms.team_a` and `config.uniforms.team_b`.

## Assists and match statistics

The assist settings in `Config.Assists` control the touch window and eligible previous touch. Match results, goals, assists, participants, and pitch information are saved automatically. Leaderboard and history limits are configured under `Config.API`.

## API

`Config.API` controls query limits and whether optional server and network query events are enabled. Prefer direct server exports for integrations inside another resource. See [Exports](exports.md).

## Stadium scoreboard

`Config.FootballScoreboard.Enabled` enables DUI boards. `Boards` contains the world position, model, size, offsets, and screen rotation for every display.

`ScoreboardDriver = "soccer"` is the default and uses authoritative seoul_soccer lobby state. Client `football:*` control events are rejected in this mode. Set the driver to `standalone` only when another trusted controller must drive the board. Standalone client control always requires ACE `football.scoreboard`; keep `RequireAce = true` and grant the ACE only to trusted groups.

## Goalkeeper and slide tackle

`Config.Goalkeeper` controls role points, interaction range, catches, saves, ball pickup, release, and animations. `Config.SlideTackle`, `Config.StandTackle`, and `Config.StealSystem` control tackle distances, cooldowns, direction checks, loose-ball behavior, and HUD feedback. Keep server distance checks enabled when tuning client feel.
