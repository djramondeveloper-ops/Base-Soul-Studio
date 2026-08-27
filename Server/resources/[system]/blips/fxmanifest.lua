fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

name         'mri_Qblips PTBR'
version      '1.0.0'
author       'mur4i'
discord		 '.mur4i'

client_scripts {
	'client/main.lua',
	'client/utils.lua',
	'client/framework/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
}

dependencies {
	'oxmysql',
}

credits   'https://github.com/dolaji-op/ds_blipcreator'