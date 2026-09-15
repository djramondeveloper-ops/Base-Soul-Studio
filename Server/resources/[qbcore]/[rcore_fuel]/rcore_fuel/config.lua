--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

Config = {}

Config.Locale = "en"

Config.Framework = {
    BuildKey = "5076c59ea539de616e0e398f08bab4ac",
    -- 1 = esx
    -- 2 = qbcore
    Active = 2,

    -- esx
    ESX_SHARED_OBJECT = "esx:getSharedObject",

    -- es_extended resource name
    ES_EXTENDED_NAME = "es_extended",

    -------
    -- qbcore
    QBCORE_SHARED_OBJECT = "QBCore:GetObject",

    -- qb-core resource name
    QB_CORE_NAME = "qb-core",

    -- will not detect any supported framework if on true.
    DisableDetection = false,
}

-- enable statebags for ox_fuel
Config.EnableStateBagsForOxFuel = true

-- this will make the fuel pumps almost unbreakable.
-- ( for some reason rhino tank can destroy them god knows why... everything else I threw at the pumps didnt seems to break them, but the rhino tank... )
Config.EnableUnbreakableFuelPumps = false

-- general debug
Config.Debug = false
Config.AllowDebugCommand = false

-- debug when error happens in F8
Config.ErrorDebug = false

-- is the game crashing when you pick the nozzle? Enable this, this will disable the ropes.
Config.DisableRopes = false

-- are you using notification that cannot work with ~keys~?
-- then please switch this to true and all keys will appear like this in notifications: [E] instead of ~INPUT_PICKUP~
Config.ForceNormalKeyLabels = false

-- what kind of skinchanger you would like to use?
-- if your server doesnt have any of the supported skinchanger the resource will simply disable this
-- feature and instead of equiping working clothes, the player will take "punch card" to work.

-- [[[[[[[       WARNING       ]]]]]]]
-- THIS configuration is automatic, you dont need to configure this at all. Configure this only if you need to force specific skinchanger.
-- [[[[[[[       WARNING       ]]]]]]]
--SkinChangerType.AUTOMATIC                 = Automatic detection
--SkinChangerType.SKIN_CHANGER              = skinchanger support
--SkinChangerType.CUI_CHARACTER             = cui_char support
--SkinChangerType.QB_CLOTHING               = qb_clothing support
--SkinChangerType.FIVEM_APPEARANCE          = Fivem appearance support
--SkinChangerType.ILLENIUM_APPEARANCE       = Illenium appearance support
--SkinChangerType.RCORE_CLOTHING            = rcore clothing support
--SkinChangerType.NONE                      = None will be used and punch card will be activated.
Config.SkinChangerType = SkinChangerType.AUTOMATIC

-- Target type
-- 0 = In build target system
-- 1 = Q_Target
-- 2 = BT Target
-- 3 = QB Target
-- 4 = OX Target
-- 5 = sleepless ( only v1. v2 is not supported )
-- 6 = is interaction
Config.TargetZoneType = 4

-- key for ALT? ( for target resources )
Config.KeyForTargetSystem = 19

-- [[[[[[[       WARNING       ]]]]]]]
-- THIS configuration is automatic, you dont need to configure this at all. Configure this only if you need to force specific inventory.
-- [[[[[[[       WARNING       ]]]]]]]
-- Inventory System
-- Inventory.AUTOMATIC = automatic detection
-- Inventory.OX        = ox_inventory
-- Inventory.ESX       = esx_inventory
-- Inventory.QB        = qb_inventory
-- Inventory.QS        = qs_inventory
-- Inventory.MF        = mf_inventory
-- Inventory.PS        = ps_inventory
-- Inventory.LJ        = lj_inventory
-- Inventory.CORE      = core_inventory
-- Inventory.CODEM     = codem-inventory
-- Inventory.TGIANN    = tgiann-inventory
-- Inventory.ORIGEN    = origen_inventory
-- Inventory.JAKSAM    = jaksam_inventory
Config.InventorySystem = Inventory.OX

-- When acquiring a new jerry can with no previous fuel metadata, should it start full (100%)?
-- Set to false if you want freshly bought/given cans to be empty (0%) and require filling at a pump.
Config.JerryCanStartsFull = true

-- which kind of society are you using?
-- [[[[[[[       WARNING       ]]]]]]]
-- THIS configuration is automatic, you dont need to configure this at all. Change unless you really have to.
-- [[[[[[[       WARNING       ]]]]]]]
-- Society systems
-- Society.AUTOMATIC            = automatic detection
-- Society.QB_BANKING           = qb-banking
-- Society.QB_BOSSMENU          = qb-bossmenu
-- Society.QB_MANAGEMENT        = qb-management
-- Society.ESX_ADDON_ACCOUNT    = esx_addonaccount
-- Society.NFS_BILLING          = nfs-billing
-- Society.OKOK_BANKING         = okokBanking
Config.SocietySystem = Society.AUTOMATIC

-- name of the cash item.
Config.CashItem = "dollar"

-- force usage of item use for cash
Config.IsCashBasedOnItem = true

-- Measurement system
-- metric    = MeasurementUnits.METRIC
-- IMPERIAL  = MeasurementUnits.IMPERIAL
Config.MeasurementUnits = MeasurementUnits.METRIC

-- if you do not wish to use some of the prepared map simply remove the (GetResourceState("cfx-gabz-esbltd") ~= "missing") and replace it with false
Config.ServerMaps = {
    ["cfx-gabz-esbltd"] = GetResourceState("cfx-gabz-esbltd") ~= "missing",
}

-- permission groups
Config.CommandGroups = {
    ["editor"] = { "admin", "superadmin", "god", 2, 3, 4, 5 }
}

Config.KeyMaps = {
    [KeyAction.GENERATOR] = {
        action = "E",
        label = "collect generator from ground",
    },

    [KeyAction.JERRYCAN] = {
        action = "E",
        label = "if near vehicle and holding jerry can player will start tanking vehicle",
    },

    [KeyAction.SWITCH_FUEL_TYPE] = {
        action = "Q",
        label = "Will switch fuel type",
    },

    [KeyAction.CALL_TAXI] = {
        action = "E",
        label = "Will call taxi if near marker",
    },

    [KeyAction.DROP_BARREL] = {
        action = "X",
        label = "This will drop barrel if you carry one",
    },

    [KeyAction.PICKUP_NOZZLE] = {
        action = "E",
        label = "Will pick up fuel noze",
    },

    [KeyAction.REFUEL_VEHICLE] = {
        action = "MOUSE_LEFT",
        label = "Will select vehicle to refuel",
    },

    -- this is for the "E" key when cleaning the vehicle
    [KeyAction.CLEAN_VEHICLE] = {
        -- Gameplay input group. Group 1 can fail to report the E key in normal gameplay.
        group = 0,
        control = 38,
    },

    -- Key for selecting the vehicle ( example from item called "vehicle manual" )
    [KeyAction.SELECT_VEHICLE] = {
        -- Vehicle manual guide says press attack (left mouse) after looking at the car
        group = 0,
        control = 24,
    },

    -- whenever player want to cancel selection of vehicle
    [KeyAction.CANCEL_SELECTION_VEHICLE] = {
        group = 0,
        control = 73, -- X
    },
}

-- color for the progress bar when pumping out wrong fuel from the vehicle
-- all possible colors
-- https://docs.fivem.net/docs/game-references/text-formatting/
Config.ColorOfProgressBar = "b"

-- color of the targeted vehicle
-- when you aim at vehicle and it starting glowing, you can edit the color here of the glow.
Config.ColorTarget = {
    r = 255,
    g = 255,
    b = 255,
    a = 255,
}

-- Sounds volume config
-- liquid sound effect
Config.LiquidVolume = 0.4 -- maximum value is 0.00 - 1.00

-- Electric humming effect
Config.ElectricHummingVolume = 0.4 -- maximum value is 0.00 - 1.00

-- save interval?
-- everything will get saved every 15 minutes.
Config.SaveCompaniesMinutesInterval = 15

-- permission map
Config.PermissionGroup = {
    ESX = {
        -- group system that used to work on numbers only
        [1] = {
            1, 2, 3, 4, 5
        },
        -- group system that works on name
        [2] = {
            "helper", "mod", "admin", "superadmin",
        },
    },

    QBCore = {
        -- group system that works on ACE
        [1] = {
            "god", "admin", "mod",
        },
    }
}

-- framework events
Config.Events = {
    QBCore = {
        playerLoaded = "QBCore:Client:OnPlayerLoaded",
        playerLoadedServer = "QBCore:Server:OnPlayerLoaded",
        jobUpdate = "QBCore:Client:OnJobUpdate",
    },
    ESX = {
        playerDropped = "esx:playerDropped",
        playerLoaded = "esx:playerLoaded",
        playerLogout = "esx:playerLogout",
        jobUpdate = "esx:setJob",
    },
}

Config.SpawnNPCList = {
    ["worker"] = {
        model = "s_m_y_airworker",

        pos = vector3(-328.03, -2700.7, 7.55),
        heading = 45.43,

        anim = "notepad2",

        renderDistance = 100.0,
    },
}

Config.ReplaceObjects = {
    ------
    {
        pos = vector3(-705.37, -1464.93, 5.42),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(-765.04, -1434.4, 5.42),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    ------
    {
        pos = vector3(48.52, 2779.06, 58.04),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(49.95, 2777.85, 58.04),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    ------
    {
        pos = vector3(2678.47, 3262.34, 55.24),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(2680.88, 3266.32, 55.24),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    ------
    {
        pos = vector3(2001.58, 3771.97, 32.18),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(2003.87, 3773.36, 32.18),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(2006.29, 3774.94, 32.18),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(2009.08, 3776.98, 32.18),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    ------
    {
        pos = vector3(-91.15, 6422.39, 31.48),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    {
        pos = vector3(-97.10, 6416.86, 31.48),
        radius = 2.0,
        originalModelHash = -469694731,
        newModelHash = GetHashKey("prop_gas_pump_old2_rc"),
    },
    ------
}

Config.SpawnObject = {
    -- EV machines
    {
        model = "rcore_electric_charger_a",
        pos = vec3(1204.195312, -1401.033691, 35.645233),
        heading = 45.0,
        renderDistance = 100.0,
        isMission = false,
    },
    {
        model = "rcore_electric_charger_a",
        pos = vec3(1207.068115, -1398.160889, 35.645233),
        heading = 45.0,
        renderDistance = 100.0,
        isMission = false,
    },
    {
        model = "rcore_electric_charger_a",
        pos = vec3(1212.937256, -1404.030029, 35.644920),
        heading = 45.0,
        renderDistance = 100.0,
        isMission = false,
    },
    {
        pos = vec3(1210.064697, -1406.903076, 35.644920),
        model = "rcore_electric_charger_a",
        heading = 45.0,
        renderDistance = 100.0,
        isMission = false,
    },
    {
        model = "rcore_electric_charger_a",
        pos = vector3(-1219.81, -2317.43, 14.2),
        heading = 150.0,
        renderDistance = 100.0,
        isMission = false,
    },
}

-- do not touch
Config.ScaleFormLists = {
    ["shop_scaleform_1"] = false,
    ["shop_scaleform_2"] = false,
}

-- will preload one scaleform and never release it just in case your server have use of too many scaleforms
Config.UsePreloaded = false

Config.ScaleformEditor = false

-- do not touch
-- you can view all AlignTypes in const.lua
Config.resolution = {
    -- objects that are non related to the fuel
    [GetHashKey("prop_tv_flat_02")] = {
        ['distance'] = 5,

        ['ScreenSize'] = vec3(-0.002965, -0.009885, 0.000000),
        ['CameraOffSet'] = {
            ['rotationOffset'] = vec3(0.000000, 0.000000, 0.000000),
            ['x'] = 0.0,
            ['y'] = -3.0,
            ['z'] = 0.35
        },

        ['ScreenOffSet'] = vec3(-0.6, -0.01, 0.5),
    },
}

-- the lower the better but the lower the more heavier it will become to NUI
Config.RefreshTime = 300

-- for some users the qbcore just refuse to call event for playerLoadedServer so this is work around... Turn only if support from rcore tell you so
Config.WorkAroundForQBCoreLoadedEvent = false

-- disable payment for this resource ( use only if you have your own solution )
-- rcore_fuel/client/payment.lua for UI
-- rcore_fuel/server/fuel_pump/pricing.lua ( event: rcore_fuel:payForFuel )
Config.DisablePaymentModal = false

-- will enable statebags only ( experimental )
Config.EnableStateBagsOnly = false

-- will enable keybinds for inventory active key ( experimental )
Config.EnableInventoryKeyBinds = false

-- FIX: EnableTax and TaxPercentage were referenced in server/main.lua but never defined
Config.EnableTax = false          -- set to true to deduct a tax from shop owner revenue
Config.TaxPercentage = 0.05       -- 5% tax on fuel sale revenue sent to owner

-- FIX: mission payouts were hardcoded in server/mission/mission.lua
Config.MissionPayout            = 1500  -- maximum cash reward for completing a fuel delivery mission
Config.MissionPayoutMaxCostRatio = 1.0   -- reward is also capped to this fraction of the delivered fuel purchase cost
Config.MissionRewardForWrongFuel = 250   -- maximum cash reward for pumping out wrong fuel from a vehicle
Config.MinWrongFuelLitersForReward = 10  -- prevents 1-liter two-player reward farming
Config.WrongFuelRewardPerLiter   = 10    -- reward scales with server-recorded wrong-fuel evidence up to the maximum above

-- Charge the completed refill once, using the cash/bank checkout menu.
-- Set true only if incremental automatic charging is wanted instead.
Config.SecureFuelLivePayment = false
Config.SecureFuelPaymentPriority = "cash" -- "cash" or "bank"; falls back to the other account when needed
Config.FuelReceiptDisplayDuration = 15000 -- keep the completed refill visible for 15 seconds
Config.PumpDisplayDistance = 15.0 -- world pump display range, measured from the pump

-- FIX: price bound config values (referenced in server/company/company.lua but never defined)
Config.MinFuelPrice    = 0.01     -- minimum price per liter an owner can set
Config.MaxFuelPrice    = 100.0    -- maximum price per liter an owner can set
Config.MinCompanyPrice = 10000    -- minimum company listing sale price
Config.MaxCompanyPrice = 10000000 -- maximum company listing sale price

-- FIX: MaximumOwnedCompanyPerPlayer referenced in buyCompany but never defined
Config.MaximumOwnedCompanyPerPlayer = 1  -- set to 0 for unlimited

-- FIX 2: Config.HideHud referenced in client/events.lua but never defined
Config.HideHud = false  -- set true to hide radar/HUD during fueling missions

-- FIX 1: Config keys referenced in code but never defined

-- Scaleform rendering: when true, calls SET_TEXTURE scaleform method on each render tick
-- (used for video-texture pump displays). Set false for standard scaleform.
Config.PopScaleform = false

-- Editor scaleform: default distance at which the scaleform editor opens
Config.DefaultOpenDistance = 8.0

-- Company marker: when true, society/job bosses can also access the company menu
-- even if they are not the registered owner_identifier
Config.EnableSociety = false

-- playerSkin: set true to use the legacy QB skinchanger system instead of the newer one
Config.OldSystemForQBClothing = false

-- playerSkin: the server event name used by fivem-appearance to save a player's skin
Config.Fivem_AppearanceSaveEvent = "fivem-appearance:saveAppearance"
