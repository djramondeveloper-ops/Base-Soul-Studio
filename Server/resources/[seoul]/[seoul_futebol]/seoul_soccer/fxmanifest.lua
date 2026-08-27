fx_version 'cerulean'
shared_script 'sh_config.js'
escrow_ignore {
    '*.lua',
    'modules/**/*.lua',
    'config_defaults.lua',
    'config.lua'
}
game 'gta5'

author '0Resmon / Seoul Base adaptation'
description 'Seoul Soccer System - adapted for Seoul Base'
version '1.0.12-npc-onesync'

ui_page 'web/dist/index.html'

dependencies {
    'oxmysql',
    'ox_lib',
    'ox_target',
    'vrp'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@vrp/lib/utils.lua',
    'modules/shared/config_merge.lua',
    'config_defaults.lua',
    'config.lua',
    'modules/shared/locale.lua',
    'modules/shared/goals.lua',
    'modules/shared/bridge.lua',
}

client_scripts {
    'modules/client/main.lua',
    'modules/client/pitch_doors.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/server/npcs.lua',
    'modules/server/main.lua',
    'modules/server/api.lua',
    'server.lua'
}

server_exports {
    'GetTabletBridgeSnapshot',
    'GetLeaderboard',
    'GetLeaderboardTable',
    'GetPlayerStats',
    'GetPlayerMatchHistory',
    'GetPlayerMatchHistoryRaw',
    'GetPlayerMatchHistoryTable',
    'GetPitchOverview',
    'GetPitchOverviewTable',
    'GetActiveLobbies',
    'GetActiveLobbiesTable',
    'GetServerSummary',
    'GetRecentTopScorers',
    'GetMatchById',
    'IsPlayerInMatch',
    'GetPlayerLobbyId',
    'StartFootballMatch',
    'UpdateFootballScore',
    'UpdateFootballTime',
    'GoalScored',
    'GetFootballMatchState',
}

files {
    'locales/*.json',
    'web/dist/index.html',
    'web/dist/stadium.html',
    'web/dist/assets/*.js',
    'web/dist/assets/*.css',
    'web/dist/assets/*.png',
    'web/dist/assets/*.svg',
    'web/dist/*.svg',
    'web/dist/*.png'
}
