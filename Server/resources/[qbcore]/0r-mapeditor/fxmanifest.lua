-- decrypted and fixed by OxcyShop https://discord.gg/XdhhX29yhM

fx_version 'cerulean'
game 'gta5'

name '0r-mapeditor'
description 'Seoul Prop Editor - AdminControl integration'
author '0Resmon Studios'
version '1.0.1'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

ui_page 'html/index.html'

shared_scripts {
    'config/shared.lua',
    'locales/locale.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/camera.lua',
    'client/raycast.lua',
    'client/objects.lua',
    'client/history.lua',
    'client/clipboard.lua',
    'client/array.lua',
    'client/align.lua',
    'client/prefab.lua',
    'client/gizmo.lua',
    'client/gizmo_axis.lua',
    'client/placement.lua',
    'client/worldprops.lua',
    'client/bulk.lua',
    'client/preview.lua',
    'client/brush.lua',
    'client/fill.lua',
    'client/lights.lua',
    'client/areadelete.lua',
    'client/maps.lua',
    'client/main.lua',
    'client/permanent.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server.lua',
    'bridge/server.lua',
    'server/logs.lua',
    'server/maps.lua',
    'server/prefab.lua',
    'server/main.lua',
    'server/permanent.lua',
}

files {
    'data/props.json',
    'locales/*.json',
    'html/index.html',
    'html/*.js',
    'html/*.css',
    'html/fonts/*',
    'html/images/*',
}

escrow_ignore {
    'config/*.lua',
    'bridge/*.lua',
    'locales/locale.lua',
    'locales/*.json',
    'data/*.json',
    'html/**',
}

dependencies {
    'oxmysql',
}

-- Seoul Base: dependencia /assetpacks removida; o pacote nao inclui esse resource.

-- decrypted and fixed by OxcyShop https://discord.gg/XdhhX29yhM