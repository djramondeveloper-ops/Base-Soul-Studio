fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'
version '1.2.9-seoul'
description 'Seoul UI Pack - convertido de reborn_uipack para seoul_uipack'

dependency 'ox_lib'

file 'init.lua'

client_scripts {
    'modules/*.lua',
    'main.lua',
    'seoul_theme.lua'
}

server_scripts {
    "server_modules/*.lua"
}

ui_page 'web/build/index.html'
files {
    'web/build/**',
    'locales/*.lua'
}
