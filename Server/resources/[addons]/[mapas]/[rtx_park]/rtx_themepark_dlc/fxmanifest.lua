fx_version 'cerulean'
game 'gta5'
description 'RTX THEME PARK DLC'
version '80.0'
shared_scripts {
	'@vrp/lib/Utils.lua'
}

dependencies {
	'vrp',
	'oxmysql',
	'ox_target',
	'ox_inventory',
	'rtx_themepark_dlc_objects',
	'rtx_scenarios'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'language/main.lua',
	'server/other.lua',
	'server/main.lua',
	'server/attr1.lua',
	'server/attr2.lua',
	'server/attr3.lua',
	'server/attr4.lua',
	'server/attr5.lua',
	'server/attr6.lua',
	'server/attr7.lua',
	'server/attr8.lua',
	'server/attr9.lua',
	'server/dlc/attr10.lua',
	'server/dlc/attr11.lua',
	'server/dlc/attr12.lua',
	'server/dlc/attr13.lua',
	'server/dlc/attr14.lua',
	'server/dlc/attr15.lua',
	'server/dlc/attr16.lua',
	'server/dlc/attr17.lua',
	'server/dlc/attr18.lua'
}
client_scripts {
	'config.lua',
	'language/main.lua',
	'client/seoul.lua',
	'client/main.lua',
	'client/sound.lua',
	'client/paths1.lua',
	'client/paths2.lua',
	'client/paths3.lua',
	'client/attr1.lua',
	'client/attr2.lua',
	'client/attr3.lua',
	'client/attr4.lua',
	'client/attr5.lua',
	'client/attr6.lua',
	'client/attr7.lua',
	'client/attr8.lua',
	'client/attr9.lua',
	'client/dlc/attr10.lua',
	'client/dlc/attr11.lua',
	'client/dlc/attr12.lua',
	'client/dlc/attr13.lua',
	'client/dlc/attr14.lua',
	'client/dlc/attr15.lua',
	'client/dlc/attr16.lua',
	'client/dlc/attr17.lua',
	'client/dlc/attr18.lua',
}
files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/sound.js',
	'html/debounce.min.js',
	'html/jquery.connections.js',
	'html/BebasNeueBold.ttf',
	'html/NakaraRegular.ttf',
	'html/img/*.png',
	'html/sounds/*.mp3'
}
exports {
	'IsPlayerOnRide', -- exports["rtx_themepark_dlc"]:IsPlayerOnRide() -- it will return if player is on some theme park ride
}
ui_page 'html/ui.html'
lua54 'yes'
escrow_ignore {
  'config.lua',
  'language/main.lua',
  'server/other.lua'
}
