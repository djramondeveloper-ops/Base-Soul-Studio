
fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Seoul Dev"
description "Seoul Tablet integrado à Seoul Base vRP/Creative"
website "https://seoul.dev/"
version "seoul-dev-latest"

shared_scripts {
    "@vrp/lib/Utils.lua",
    "config/**.lua",
    "shared/**.lua"
}

client_script {
    "lib/client/**.lua",
    "client/**.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "lib/server/**.lua",
    "server/**.lua"
}

files {
    "config/**.json",
    "ui/dist/**/*",

    "ui/components.js",
}

ui_page "ui/dist/index.html"

dependencies {
    "oxmysql",
    "vrp",
    "lb-phone",
    -- "lb-tablet-prop" -- opcional: a Seoul usa prop GTA nativo por padrão
}

escrow_ignore {
    "lib/**",
    "config/**",
    "shared/**",
    "client/custom/**",
    "server/custom/**",
    "client/apps/custom/**",
    "server/apps/custom/**",
    "server/apiKeys.lua",
    "server/misc/databaseChecker/**",
}
