
fx_version 'cerulean'
lua54 'yes'
game 'gta5'
author 'LMBAWE9'
version '1.0.5'
description 'ESX/QB Compatible Resource'

shared_scripts {
	'@ox_lib/init.lua',
	'@vrp/lib/Utils.lua',
	'config.lua',
	'shared/init.lua',
}

client_script 'client.lua'
server_script 'server.lua'

ui_page 'ui/build/index.html'

files {
	'data/*.lua',
	'locales/*.json',
	'modules/**/client.lua',
	'modules/**/server.lua',
	'modules/bridge/**/client.lua',
	'modules/bridge/**/server.lua',
	'ui/build/index.html',
	'ui/build/**/*',
}

dependencies { 'vrp', 'ox_lib', 'xsound' }
