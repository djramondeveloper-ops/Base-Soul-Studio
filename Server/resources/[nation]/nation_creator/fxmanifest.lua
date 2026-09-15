fx_version "cerulean"
game "gta5" 
lua54 'yes'

ui_page_preload 'yes'
ui_page "nui/index.html"
files {
	"nui/**"}
client_scripts {
	
	"seoul_theme.lua","@vrp/lib/Utils.lua",
	"client_config.lua",
	"client.lua"
} 
server_script {
	"@vrp/lib/Utils.lua",
	"server_config.lua",
	"server.lua"
}

dependencies {
	"vrp",
	"oxmysql",
	"alc-spawn",
	"nation_barbershop",
	"nation_skinshop",
	"nation_tattoos"
}
                                                                      



client_script {
'@vrp/lib/utils.lua','AlcProtect.lua'
}
