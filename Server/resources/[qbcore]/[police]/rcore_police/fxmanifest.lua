-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



fx_version   'cerulean'
lua54        'yes'
game         'gta5'
node_version "22"
name         'rcore_police'
author       'NewEdit | rcore.cz'
version      '1.2.3'
description  'Unique Police System for FiveM (all-in-one)'
shared_scripts {
    'types.lua',
    'shared/sh-utils.lua',
    'shared/sh-const.lua',
    'configs/framework.lua',
    'bridge.lua',
    'shared/sh-locale.lua',
    'data/locales/*.lua',
    'data/maps/*.lua',
    'configs/outfits.lua',
    'configs/fines.lua',
    'configs/permissions.lua',
    'config.lua',
    'config_private.lua',
    'shared/sh-init.lua',
    'shared/sh-api.lua',
    'modules/bridge/shared/*.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/bridge/sv-deployer.lua',
    'configs/sconfig.lua',
    'configs/fake_vehicle_info.lua',
    'modules/base/server/init/*.lua',
    'modules/bridge/sv-bridge.lua',
    'modules/bridge/server/db/*.lua',
    'modules/bridge/server/framework/*.lua',
    'modules/bridge/server/inventory/*.lua',
    'modules/bridge/server/images/*.lua',
    'modules/bridge/server/useable_items/*.lua',
    'modules/bridge/server/boss_menu/*.lua',
    'modules/bridge/server/billing/*.lua',
    'modules/bridge/server/dispatch/*.lua',
    'modules/bridge/server/garage/*.lua',
    'modules/bridge/server/duty/*.lua',
    'modules/bridge/server/utils/*.lua',
    'modules/bridge/server/society/*.lua',
    'modules/bridge/server/license/*.lua',
    'modules/bridge/server/death/*.lua',
    'modules/bridge/server/department_store/*.lua',
    'modules/bridge/server/prison/*.lua',
    'modules/bridge/server/sv-listeners.lua',
    'modules/base/server/models/*.lua',
    'modules/base/server/services/*.lua',
    'modules/base/server/storage/*.lua',
    'modules/base/server/lifecycle/init/*.lua',
    'modules/base/server/lib/*.lua',
    'modules/bridge/server/sv-commands.lua',
    'modules/bridge/server/impl/*.lua',
    'modules/bridge/conflict/dist/index.js',
}
client_scripts {
    'modules/base/client/init/*.lua',
    'modules/bridge/cl-bridge.lua',
    'modules/bridge/client/textUI/*.lua',
    'modules/bridge/client/progressbar/*.lua',
    'modules/bridge/client/framework/*.lua',
    'modules/bridge/client/inventory/*.lua',
    'modules/bridge/client/prison/*.lua',
    'modules/bridge/client/dispatch/*.lua',
    'modules/bridge/client/menu/*.lua',
    'modules/bridge/client/menu/library/*.lua',
    'modules/bridge/client/utils/*.lua',
    'modules/bridge/client/garage/resources/*.lua',
    'modules/bridge/client/garage/*.lua',
    'modules/bridge/client/clothing/*.lua',
    'modules/bridge/client/license/*.lua',
    'modules/bridge/client/billing/*.lua',
    'modules/bridge/client/mdt/*.lua',
    'modules/base/client/models/*.lua',
    'modules/base/client/services/*.lua',
    'modules/base/client/storage/*.lua',
    'modules/base/client/lifecycle/init/*.lua',
    'modules/base/client/lib/nui/*.lua',
    'modules/base/client/lib/*.lua',
    'modules/base/client/lib/props/*.lua',
    'modules/base/client/lib/interactions/*.lua',
    'modules/base/client/lifecycle/init/interactions/*.lua',
    'modules/bridge/client/impl/*.lua',
    'modules/bridge/client/interact/*.lua',
    'modules/bridge/client/interact/zones/*.lua',
    'modules/bridge/client/duty/*.lua',
    'modules/bridge/client/phones/*.lua',
}
ui_page 'modules/nui/web/build/index.html'
files {
    'modules/nui/web/build/index.html',
    'modules/nui/web/build/images/*.png',
    'modules/nui/web/build/images/*.jpg',
    'modules/nui/web/build/images/*.jpeg',
	'modules/nui/web/build/**/*',
}
escrow_ignore {
    'config.lua',
    'modules/bridge/client/**/*.lua',
    'modules/bridge/server/**/*.lua',
    'data/locales/*.lua',
    'data/maps/*.lua',
    'configs/*.lua',
    'inventory_items.lua',
    'shared/sh-const.lua',
    'bridge.lua',
    'modules/bridge/server/sv-commands.lua',
}
dependencies {
	'/server:5104',
	'/onesync',
    'rcore_police_assets'
}
provides { "esx_policejob", "qb-policejob", "wasabi_police", "okok_police", "p_policejob" }
dependency '/assetpacks'
