fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Seoul Dev"
description "Seoul Phone - versão mais recente criada por Seoul Dev"
version "seoul-dev-latest"

shared_scripts {
    "config/*.lua",
    "shared/**/*.lua"
}

client_scripts {
    "lib/client/**/*.lua",
    "client/**/*.lua",
    "seoul/client/charging.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",

    "lib/server/callbacks.lua",
    "lib/server/clientCallbacks.lua",
    "lib/server/autoSql.lua",

    "server/apiKeys.lua",

    "server/custom/frameworks/qb/qb.lua",
    "server/custom/frameworks/qb/money.lua",
    "server/custom/frameworks/qb/services.lua",
    "server/custom/frameworks/qb/vehicles.lua",
    "server/custom/frameworks/qb/mail.lua",
    "server/custom/frameworks/qb/commands.lua",

    "server/custom/frameworks/qbox/qbox.lua",
    "server/custom/frameworks/qbox/money.lua",
    "server/custom/frameworks/qbox/services.lua",
    "server/custom/frameworks/qbox/vehicles.lua",
    "server/custom/frameworks/qbox/mail.lua",
    "server/custom/frameworks/qbox/commands.lua",

    "server/custom/frameworks/esx/esx.lua",
    "server/custom/frameworks/esx/money.lua",
    "server/custom/frameworks/esx/services.lua",
    "server/custom/frameworks/esx/vehicles.lua",
    "server/custom/frameworks/esx/commands.lua",

    "server/custom/frameworks/standalone/standalone.lua",
    "server/custom/frameworks/standalone/money.lua",
    "server/custom/frameworks/standalone/services.lua",
    "server/custom/frameworks/standalone/vehicles.lua",
    "server/custom/frameworks/standalone/commands.lua",

    "server/custom/frameworks/ox.lua",
    "server/custom/frameworks/vrp2.lua",

    "server/custom/uniquePhones/*.lua",
    "server/custom/functions/*.lua",

    "server/misc/debug.lua",
    "server/misc/databaseChecker/defaultTables.lua",
    "server/misc/databaseChecker/databaseChecker.lua",

    "server/server.lua",

    "server/misc/accountSwitcher.lua",
    "server/misc/airshare.lua",
    "server/misc/autoDeleteNotifications.lua",
    "server/misc/backup.lua",
    "server/misc/battery.lua",
    "server/misc/errors.lua",
    "server/misc/exports.lua",
    "server/misc/notifications.lua",
    "server/misc/security.lua",
    "server/misc/statistics.lua",

    "server/apps/custom.lua",
    "server/apps/default/*.lua",
    "server/apps/framework/home/*.lua",
    "server/apps/framework/*.lua",
    "server/apps/other/*.lua",
    "server/apps/social/*.lua",

    "server/versionCheck.lua"
}

files {
    "ui/dist/**/*",
    "ui/components.js",
    "config/**/*",
    "phone.sql",
    "sound/data/lbphone.dat54.rel",
    "sound/dlc_lbscripts/sounds.awc"
}

data_file "AUDIO_WAVEPACK" "sound/dlc_lbscripts"
data_file "AUDIO_SOUNDDATA" "sound/data/lbphone.dat"

ui_page "ui/dist/index.html"

dependencies {
    "oxmysql",
    "vrp"
}

escrow_ignore {
    "config/**/*",

    "client/apps/framework/**/*.lua",
    "server/apps/framework/**/*.lua",
    "shared/*.lua",

    "client/custom/**/*.lua",
    "server/custom/**/*.lua",

    "client/misc/debug.lua",
    "server/misc/debug.lua",

    "server/misc/functions.lua",
    "server/misc/databaseChecker/*.lua",

    "server/apiKeys.lua",

    "types.lua",

    "client/apps/default/weather.lua",

    "lib/**/*",
    "phone.sql",
    "README.md"
}
