-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SCRIPTS CONFIG
-- Resource adaptado do pacote Accessories/Reborn para Seoul Base MultiFramework.
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulScripts = SeoulScripts or {}

SeoulScripts.Debug = GetConvar('seoul:debug','false') == 'true'

SeoulScripts.Modules = {
    Academy = true,
    Anims = true,
    ArmBraker = true,
    Assault = true,
    Blipsystem = true, -- blip de serviço legado, não substitui mri_Qblips
    Flashbang = true,
    Manobras = true,
    Perimeter = true,
    Pets = true,
    Rope = true,
    Safelocker = true,
    Sirens = true,
    Skate = true,
    Tackle = true,
    Warehouse = true
}

SeoulScripts.Permissions = {
    Admin = { 'Admin', 'admin.permissao' },
    Police = { 'Police', 'Policia', 'policia.permissao', 'Police2', 'Civil', 'Core' },
    Emergency = { 'Police', 'Policia', 'policia.permissao', 'Paramedic', 'Hospital', 'hospital.permissao' },
    WarehouseAdmin = { 'Admin', 'admin.permissao' }
}

SeoulScripts.Security = {
    RopeMaxDistance = 3.0,
    TackleMaxDistance = 4.0,
    FlashbangMaxThrowDistance = 80.0,
    ServerEventCooldown = 700,
}

SeoulScripts.Items = {
    Money = 'dollar',
    DirtyMoney = 'dirtydollar',
    Skate = 'skate',
    Rope = 'rope',
    Flashbang = 'WEAPON_FLASHBANG',
    Camera = 'camera',
    Binoculars = 'binoculars'
}

SeoulScripts.Pets = {
    -- whitelist segura. Se quiser mais modelos, adiciona aqui.
    AllowedModels = {
        ['a_c_shepherd'] = true,
        ['a_c_retriever'] = true,
        ['a_c_rottweiler'] = true,
        ['a_c_husky'] = true,
        ['a_c_poodle'] = true,
        ['a_c_pug'] = true,
        ['a_c_westy'] = true,
        ['a_c_cat_01'] = true,
        ['a_c_chop'] = true
    }
}

SeoulScripts.Blipsystem = {
    Colors = {
        Policia = 77,
        Police = 77,
        Hospital = 83,
        Paramedic = 83,
        Mechanic = 51,
        LSCustoms = 51,
        Bennys = 51,
        Corredor = 1
    }
}

SeoulScripts.Warehouse = {
    BucketBase = 93000,
    Table = 'seoul_warehouses'
}
