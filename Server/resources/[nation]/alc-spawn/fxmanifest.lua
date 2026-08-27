fx_version "cerulean"
game "gta5" 
lua54 'yes'
description "alcnetwork"

client_scripts {
   
	"seoul_theme.lua","@vrp/lib/Utils.lua",
   "@vrp/config/Native.lua",
   "main.lua"
}

server_scripts {
   "@vrp/lib/Utils.lua",
   "server.lua"
}

shared_scripts {
   'config.lua'
}

files {
   "web/**/*"}
ui_page "web/index.html"




client_script {
'@vrp/lib/utils.lua','AlcProtect.lua'
}