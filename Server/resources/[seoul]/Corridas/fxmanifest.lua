fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Seoul Dev"
description "Sistema de corridas adaptado para Seoul Base vRP/Creative + OX Inventory"

shared_scripts {
    "@vrp/lib/utils.lua",
    "Config.lua"
}

client_scripts {
    "client-side/core.lua",
    "client-side/client_races.lua",
    "client-side/client_street.lua",
    "client-side/client_water.lua"
}

server_scripts {
    "server-side/core.lua",
    "server-side/server_races.lua",
    "server-side/server_street.lua",
    "server-side/server_water.lua"
}
