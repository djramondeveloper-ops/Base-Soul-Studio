fx_version 'bodacious'
game 'gta5'
lua54 'yes'

name 'seoul_scripts'
author 'Seoul Dev - DjRamonDev'
description 'Pacote Accessories/Reborn adaptado cirurgicamente para Seoul Base MultiFramework'
version '1.0.0-seoul'

ui_page 'Web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@vrp/lib/Utils.lua',
    'shared/config.lua',
    'Academy/config.lua',
    'ArmBraker/config.lua',
    'Assault/config.lua',
    'Flashbang/config.lua',
    'Warehouse/config.lua'
}

client_scripts {
    '@vrp/config/Native.lua',
    '@vrp/lib/Utils.lua',
    'client/bridge.lua',

    'Anims/client-side/client.lua',
    'Safelocker/client-side/client.lua',
    'Sirens/client-side/client.lua',
    'Skate/client-side/client.lua',
    'Manobras/client-side/client.lua',
    'Academy/client-side/client.lua',
    'ArmBraker/client-side/client.lua',
    'Assault/client-side/client.lua',
    'Perimeter/client-side/core.lua',
    'Pets/client-side/client.lua',
    'Rope/client-side/client.lua',
    'Tackle/client-side/tackle.lua',
    'Blipsystem/client-side/client.lua',
    'Flashbang/client-side/cl_functions.lua',
    'Flashbang/client-side/client.lua',
    'Warehouse/client-side/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@vrp/lib/Utils.lua',
    'server/bridge.lua',
    'server/entities.lua',

    'Academy/server-side/server.lua',
    'ArmBraker/server-side/server.lua',
    'Perimeter/server-side/core.lua',
    'Pets/server-side/server.lua',
    'Rope/server-side/server.lua',
    'Tackle/server-side/server.lua',
    'Blipsystem/server-side/server.lua',
    'Flashbang/server-side/sv_functions.lua',
    'Flashbang/server-side/server.lua',
    'Warehouse/server-side/server.lua',
    'server/items_seed.lua'
}

files {
    'stream/*',
    'Web/*',
    'Web/**/*',
    'data/*.json'
}

dependencies {
    'vrp',
    'ox_lib',
    'oxmysql'
}
