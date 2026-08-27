
fx_version "adamant"
game "gta5"

ui_page_preload 'yes'

ui_page "nui/index.html"

files {
	"nui/**"}

client_scripts {
	
	"seoul_theme.lua","@vrp/lib/utils.lua",
	"client_config.lua",
	"client.lua",
	"compat_client.lua"
} 

server_script {
	"@vrp/lib/utils.lua",
	"server_config.lua",
	"server.lua",
	"compat_server.lua"
}

dependencies { "vrp", "oxmysql" }




client_script {
'@vrp/lib/utils.lua','AlcProtect.lua'
}
