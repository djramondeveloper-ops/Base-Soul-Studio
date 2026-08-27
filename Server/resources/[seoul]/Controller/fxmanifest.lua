fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "Web/index.html"

shared_scripts {
    "@ox_lib/init.lua",
    "Config.lua"
}

client_scripts {
    "@vrp/config/Native.lua",
    "@vrp/lib/Utils.lua",
    "@PolyZone/client.lua",
    "Compat/client.lua",
    "Admin/client.lua",
    "Player/client.lua",
    "Wall/client.lua",
    "Weather/client.lua",
    "Tencode/client.lua",
    "Hospital/client.lua",
    "Survival/client.lua"
}

server_scripts {
    "@vrp/lib/Utils.lua",
    "Compat/server.lua",
    "Admin/server.lua",
    "Player/server.lua",
    "Wall/server.lua",
    "Weather/server.lua",
    "Tencode/server.lua",
    "Hospital/server.lua",
    "Survival/server.lua"
}

files {
    "Web/*",
    "Web/**/*"
}

dependency "vrp"
dependency "ox_lib"
dependency "ox_inventory"
dependency "PolyZone"
