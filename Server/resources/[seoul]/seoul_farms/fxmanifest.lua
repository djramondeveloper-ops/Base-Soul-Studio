fx_version "bodacious"
game "gta5"
lua54 "yes"

name "seoul_farms"
author "Seoul Dev"
description "Farms, lavagem, venda e desmanche adaptados para Seoul Base MultiFramework"
version "1.0.0-seoul"

dependency "vrp"

shared_scripts {
    "@vrp/lib/Utils.lua",
    "Config.lua"
}

client_scripts {
    "@vrp/config/Native.lua",
    "client/bridge.lua",
    "Desmanche/client.lua",
    "Drogas/client/cocaina.lua",
    "Drogas/client/maconha.lua",
    "Drogas/client/meta.lua",
    "Gerais/client.lua",
    "Lavagem/client.lua"
}

server_scripts {
    "@vrp/config/Vehicle.lua",
    "server/bridge.lua",
    "Desmanche/server.lua",
    "Drogas/server.lua",
    "Gerais/server.lua",
    "Lavagem/server.lua"
}
