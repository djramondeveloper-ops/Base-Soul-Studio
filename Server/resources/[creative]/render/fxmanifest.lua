fx_version 'cerulean'
game 'gta5'

name 'HaridCore-render'
description '[E] pra render jogadores'
author 'Harid'
version '1.0.0'

ui_page 'html/HaridCoreui.html'

client_scripts {
  "src/HaridCorecl.lua",
  'config.lua'
}

server_scripts {
  "src/HaridCoresv.lua"   
}

files {
  'html/HaridCoreui.html',
  'html/HaridCorecss.css',
  'html/HaridCoresj.js'
}
