fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Seoul Studio - DjRamonDev'
description 'Seoul Brothels - bordéis, gestão por Passport e NPCs OneSync'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@vrp/lib/Utils.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/street.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    '/onesync',
    'ox_lib',
    'oxmysql',
    'ox_target',
    'vrp'
}
