fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

dependencies {
    "/server:6116",
    "/onesync",
    "ox_lib"
}

shared_scripts {
    "@ox_lib/init.lua",
    "@seoul_uipack/init.lua",
    "@vrp/lib/Utils.lua",
    "Config.lua"
}

client_scripts {
    "@vrp/config/Native.lua",
    "@PolyZone/client.lua",
    "client.lua",
    "seoul_insert.lua",
    "**/client.lua"
}

server_scripts {
    "server.lua",
    "**/server.lua",
    "items/seoul_seed_importer/server.lua"
}

files {
    "web/**"
}
