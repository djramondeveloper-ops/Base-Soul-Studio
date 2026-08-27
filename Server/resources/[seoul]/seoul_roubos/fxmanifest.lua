fx_version 'bodacious'
game 'gta5'
lua54 'yes'

name 'seoul_roubos'
author 'Seoul Dev - DjRamonDev'
description 'Roubos adaptados para Seoul Base: ATM, caixa, gerais, joalheria e carro forte'
version '1.0.0-seoul'

shared_scripts {
    '@ox_lib/init.lua',
    '@vrp/lib/Utils.lua',
    'Config.lua'
}

client_scripts {
    '@vrp/config/Native.lua',
    '@vrp/lib/Utils.lua',
    'client/core.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@vrp/lib/Utils.lua',
    'server/core.lua'
}

files {
    'README.md',
    'README_SEOUL.md',
    'instalacao/**/*'
}

dependencies {
    'vrp',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}
