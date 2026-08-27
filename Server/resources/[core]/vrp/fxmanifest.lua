fx_version "bodacious"
game "gta5"
lua54 "yes"

creative_network "extended"
version "1.1.0-seoul-multiframework"

provide 'qb-core'
provide 'es_extended'
provide 'spawnmanager'
provide 'sessionmanager'
provide 'taskbar'

dependencies {
    '/onesync',
    'oxmysql',
    'ox_lib'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/Item.lua',
    'config/Vehicle.lua',
    'config/Global.lua',
    'config/Drops.lua',
    'compat/shared/framework.lua',
    'multiframework/shared/config.lua',
    'multiframework/shared/qbcore.lua'
}

client_scripts {
    'lib/Utils.lua',
    'config/Native.lua',

    'client/base.lua',
    'client/gui.lua',
    'client/objects.lua',
    'client/playanim.lua',
    'client/player.lua',
    'client/vehicles.lua',

    'compat/client/qbcore.lua',
    'compat/client/esx.lua',
    'compat/client/seoul_admincontrol.lua',
    'multiframework/client/qbcore.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lib/Utils.lua',

    'modules/vrp.lua',
    'modules/base.lua',
    'modules/banned.lua',
    'modules/daily.lua',
    'modules/drugs.lua',
    'modules/groups.lua',
    'modules/identity.lua',
    'modules/inventory.lua',
    'modules/permissions.lua',
    'modules/money.lua',
    'modules/player.lua',
    'modules/prepare.lua',
    'modules/battlepass.lua',
    'modules/vehicles.lua',
    'modules/playing.lua',
    'modules/version.lua',

    'compat/server/legacy.lua',
    'compat/server/seoul_admincontrol.lua',
    'compat/server/lbphone.lua',
    'compat/server/ox_inventory.lua',
    'compat/server/qbcore.lua',
    'compat/server/esx.lua',
    'multiframework/server/qbcore.lua'
}

files {
    'lib/*',
    'config/*',
    'config/**/*',
    'config/**/**/*'
}
