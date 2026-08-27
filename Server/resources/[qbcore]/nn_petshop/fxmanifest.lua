fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'nn_petshop'
description 'Pet shop - buy pets (UI added separately)'
version '1.0.3'

escrow_ignore {
  'shared/**/*',
  'server/**/*',
  'install/**/*',
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/assets/**/*',
}

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/target_adapter.lua',
    'client/main.lua',
}

server_scripts {
    '@vrp/lib/Utils.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/main.lua',
}

dependencies {
    'oxmysql',
    'interact',
    'ox_target',
}
