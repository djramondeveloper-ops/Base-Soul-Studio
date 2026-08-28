--[[ FX Information ]]--
fx_version   'cerulean'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'rcore_prison'
author       'NewEdit | rcore.cz'
version      '2.2.8'
description  'Standalone unique Prison system - prison break, prison jobs and more!'

shared_scripts {
    'shared/sh-utils.lua',
    'shared/sh-const.lua',
    'shared/sh-locale.lua',
    'data/locales/*.lua',
    'config.lua',
    'shared/sh-init.lua',
    'modules/base/shared/api/*.lua',
    'modules/bridge/shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'sconfig.lua',
    'permissions.lua',
    
    'modules/base/server/sv-ace.lua',
    'modules/base/server/models/*.lua',

    'modules/bridge/server/sv-deployer.lua',
    'modules/bridge/server/sv-bridge.lua',


    'modules/bridge/server/database/sv-ghmatti.lua',
    'modules/bridge/server/database/sv-db.lua',

    'modules/bridge/server/framework/*.lua',
    'modules/bridge/server/inventory/*.lua',

    'modules/bridge/server/sv-useable_items.lua',


    'modules/bridge/server/booths/*.lua',
    'modules/bridge/server/other/*.lua',
    'modules/bridge/server/dispatch/*.lua',

    'modules/bridge/server/sv-integration-test.lua',

    'modules/bridge/server/rcore/*.lua',

    'modules/bridge/server/notify/*.lua',
    'modules/bridge/server/doorlocks/*.lua',
    'modules/bridge/server/consumables/*.lua',
    'modules/bridge/server/maps/*.lua',

    'modules/base/server/sv-callback.lua',

    'modules/base/server/init/sv-object.lua',
    'modules/base/server/models/*.lua',
    'modules/base/server/services/*.lua',
    'modules/base/server/lib/*.lua',
    'modules/base/server/storage/*.lua',
    'modules/base/server/lifecycle/init/*.lua',
    'modules/base/server/api/*.lua',
    'modules/base/server/sv-commands.lua',
    'modules/base/server/init/sv-init.lua',
    'modules/base/server/*.lua',

    'modules/bridge/server/sv-migration.lua',
    'modules/bridge/server/utils/*.lua',
}


client_scripts {
    'outfits.lua',

    'modules/bridge/client/cl-bridge.lua',

    'modules/bridge/client/framework/*.lua',

    'modules/bridge/client/target/cl-main.lua',
    'modules/bridge/client/menu/cl-main.lua',

    'modules/base/client/cl-callback.lua',

    'modules/base/client/init/cl-object.lua',
    'modules/base/client/models/*.lua',
    'modules/base/client/services/*.lua',
    'modules/base/client/lib/menu/*.lua',
    'modules/base/client/lib/menu/menus/*.lua',
    'modules/base/client/lib/*.lua',
    'modules/base/client/storage/*.lua',
    'modules/base/client/lifecycle/**/*.lua',
    'modules/base/client/api/*.lua',
    'modules/base/client/init/cl-init.lua',

    'modules/bridge/client/clothing/utils/*.lua',
    'modules/bridge/client/clothing/*.lua',
    
    'modules/bridge/client/notify/cl-main.lua',
    'modules/bridge/client/textUI/cl-main.lua',
    'modules/bridge/client/dispatch/*.lua',
}


escrow_ignore {
    'modules/base/server/services/sv-se-chat.lua',
    'modules/bridge/client/clothing/*.lua',
    'modules/bridge/client/clothing/utils/*.lua',
    'modules/bridge/client/dispatch/*.lua',
    'modules/bridge/client/framework/*.lua',
    'modules/bridge/client/notify/*.lua',
    'modules/bridge/client/textUI/*.lua',

    "inventory_items.lua",

    'assets/includedLibrary',
    'assets/includedMaps',
    'assets/inventoryImages',

    'modules/bridge/server/database/*.lua',
    'modules/bridge/server/dispatch/*.lua',
    'modules/bridge/server/utils/*.lua',
    'modules/bridge/server/framework/*.lua',
    'modules/bridge/server/inventory/*.lua',
    'modules/bridge/server/notify/*.lua',
    'modules/bridge/server/booths/*.lua',

    'modules/base/shared/api/sh-time.lua',
    'modules/base/server/api/*.lua',
    'modules/base/server/sv-commands.lua',

    'modules/bridge/server/sv-useable_items.lua',

    'modules/base/client/api/*.lua',
    'permissions.lua',
    'config.lua',
    'sconfig.lua',
    'outfits.lua',
    'zones.json',
    'shared/sh-const.lua',
    'hideModels.json',
    'data/locales/*.lua',
    'data/presets/*.lua',
}


ui_page 'modules/nui/web/build/index.html'

files {
	'zones.json',
    'hideModels.json',
    'modules/nui/web/build/index.html',
    'modules/nui/web/build/config.js',
    'modules/nui/web/build/images/*.png',
    'modules/nui/web/build/images/*.jpg',
    'modules/nui/web/build/images/*.jpeg',
	'modules/nui/web/build/**/*',
    'assets/inventoryImages/*.png',
	'data/*.lua',
	'data/**/*.lua',
}

dependencies {
	'/server:5104',
	'/onesync',
}

dependency '/assetpacks'