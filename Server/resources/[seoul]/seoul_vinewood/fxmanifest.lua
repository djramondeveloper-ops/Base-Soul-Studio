fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'R1CKY | adaptado para Seoul Base'
description 'Seoul Vinewood - editor administrativo do letreiro de Vinewood'
version '1.0.0-seoul'

shared_script 'config.lua'

client_script 'client.lua'

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.ttf',
    'web/img/*.png',
    'textSettings.json',
    'stream/**/*.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'
