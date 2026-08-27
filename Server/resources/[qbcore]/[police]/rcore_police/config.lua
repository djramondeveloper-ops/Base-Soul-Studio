-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Items = {
    Spikes = "spikestrips", -- item oficial Seoul
    SpeedCamera = "speed_camera",
    Megaphone = "megaphone",
    Barrier = "barrier",
    Handcuffs = "handcuff", -- item oficial Seoul
    HandcuffsKeys = "handcuffs_key",
    PaperBag = 'paper_bag_rcore',
    Zipties = 'zipties',
    ZipTiesCutter = 'zipties_cutter',
    PanicButton = 'panic_button',
    Camera = "police_camera", -- evita conflito com a camera geral da Creative
    Photo = "photo",
    GPS = "gps",
    BodyCam = 'bodycam',
    WheelClamp = "wheel_clamp",
    WheelClampWrench = "wheel_clamp_wrench",
    BodyCamTablet = 'bodycam_tablet'
}
Config = {
    Debug = false,          -- This is enabling debug of rcore_police
    DebugInventory = false, -- This enable debug related to the inventory module
    DebugClothing = false,  -- This enable debug related to the clothing module
    DebugAPI = false,       -- This enable debug related to the API system
    DebugServer = false,    -- This enable debug related to server enviroment to find out special issues with script itself.
    DebugStates = false,    -- This enable debug related to states that handles (isCuffed, isEscorted, isBagged)
    DebugError = false,     -- Allows to show nice debug errors when escrow throws ?-1
    DebugInteract = false,  -- Used for debugging target interact.
    EnableInteractCommandsForAll = false, -- This will enable commands as (/escort, /search, /put_in_veh, /get_from_veh)
    DebugLevel = {
        'NETWORK',
        'INFO',
        'CRITICAL',
        'SUCCESS',
        'ERROR',
        'API',
        'DEBUG',
        'MENU',
    },
    Locale = 'pt-br', -- Seoul: idioma portugues brasileiro
    Database = Database.OX, -- Seoul: oxmysql
        --[[        Supported database connectors:
            * AUTO_DETECT: auto-detect db connector
            * Database.OX: oxmysql,
            * Database.MYSQL_ASYNC: mysql-async,
            * Database.GHMATTI: ghmattimysql,
            * STANDALONE: no db connector found
    ]]
    Clothing = Clothing.NONE, -- usa o sistema de fardas incluido sem depender de resource externo
        --[[        Supported clothing:
            * AUTO_DETECT: auto-detect clothing [Only detecting supported clothing below]
            * Clothing.RCORE: rcore_clothing
            * Clothing.ESX: skinchanger
            * Clothing.QB: qb-clothing
            * Clothing.IAPPEARANCE, illenium-appearance
            * Clothing.CODEM, codem-appearance (Experimental)
            * Clothing.CRM, crm-appearance (Experimental)
            * Clothing.TGIANN, tgiann-clothing (Experimental)
            * Clothing.WASABI, fivem-appearance - wasabi fork (Experimental)
    ]]
    Inventory = Inventory.OX, -- Seoul: ox_inventory
        --[[        Supported inventories:
            * AUTO_DETECT: auto-detect inventory [Only detecting supported inventories below]
            * Inventory.ESX: es_extended
            * Inventory.QB: qb-inventory
            * Inventory.PS: ps-inventory
            * Inventory.QS: qs-inventory
            * Inventory.CODEM: codem-inventory
            - Support is currently experimental; full functionality is not guaranteed.
                - Stashes and Search features are not included in the official API documentation.
                - If these features do not work as expected, we may not be able to provide a solution until the author releases official support.
            * Inventory.OX: ox_inventory
            - For customers using ox_inventory with QBCore:
                - The official QBCore bridge was discontinued by Ox.
                - The last official version that supported QBCore had bugs/issues with invBusy statebags, which are fixed in the latest releases.
                - There is a community fork that keeps ox_inventory up to date while maintaining QBCore bridge support: https://github.com/TheOrderFivem/ox_inventory
            * Inventory.LJ: lj-inventory
            * Inventory.MF: mf-inventory
            * Inventory.CHEEZA: inventory
            * Inventory.TGIANN: tgiann-inventory
            * Inventory.ORIGEN: origen-inventory
            * STANDALONE: no inventory found, you will need to integrate it
        Note:
            - If your inventory is not opening (search/stashes), you may be using an unsupported inventory, or the author has changed their exports/events.
            - Please check for updates or contact the inventory author for support.
            - Support is not provided if you are running modified inventory/not inventory from list, always use supported & latest versions.
    ]]
    Framework = Framework.QBCore, -- resolvido para o resource vrp por configs/framework.lua
        --[[        Supported frameworks:
            * AUTO_DETECT: auto-detect framework
            * Framework.ESX: es_extended
            * Framework.QBCore: qb-core
            * Framework.QBOX: qbx_core
            * STANDALONE: no framework found, you will need to integrate it
    ]]
    Prison = Prison.NONE, -- Seoul: bridge NONE encaminha para o export real lb-tablet:JailPlayer
        --[[        Supported prisons:
            * AUTO_DETECT: auto-detect prison
            * Prison.RCORE: rcore_prison
            * Prison.QB_PRISON: qb_prison
            * STANDALONE: no prison found, you will need to integrate it
    ]]
    Invoices = Invoices.NONE, -- bridge standalone adaptado para a tabela invoices da Seoul
        --[[        Supported billings:
            * AUTO_DETECT: auto-detect billing system
            * Invoices.QB_PHONE: qb-phone
            * Invoices.ESX_BILLING: esx_billing
            * Invoices.OKOK: okokBilling,
            * Invoices.QS: qs-billing,
            * Invoices.FD, fd_banking
            * Invoices.TGG, tgg-billing
            * Invoices.VMS, vms_cityhall
            * STANDALONE: no billing resource found, you will need to integrate it
    ]]
    Dispatch = Dispatch.LB_TABLET, -- LB Tablet atual confirmado
        --[[        Supported dispatches:
            * AUTO_DETECT: auto-detect dispatch resources
            * Dispatch.RCORE, rcore_dispatch
            * Dispatch.QS, qs-dispatch
            * Dispatch.PS, ps-dispatch
            * Dispatch.CD, cd_disaptch
            * Dispatch.CORE, core_dispatch
            * Dispatch.CODEM, codem_dispatch
            * Dispatch.LOVE_SCRIPTS, emergency_dispatch
            * Dispatch.ORIGEN, origen_police
            * Dispatch.TK, tk_dispatch
            * Dispatch.DUSA, dusa_Dispatch
            * Dispatch.LB_TABLET, lb-tablet
            * STANDALONE: no dispatch resource found, you will need to integrate it
    ]]
    Garages = Garages.NONE, -- usa garagem interna do rcore
        --[[        Supported Garage resources:
            * AUTO_DETECT: auto-detect garage resource
            * Garages.QB_GARAGE: qb-garages,
            * Garages.ESX_GARAGE: esx_garage,
            * Garages.QBOX: qbx_garages,
            * Garages.JG: qbx_garages,
            * Garages.CD_GARAGE: cd_garages,
            * Garages.ZYKE, zyk_garages
            * Garages.QS, qs-advancedgarages
            * Garages.OKOK okokGarage (Experimental)
            - There is not official API provided by authors, we catch events which are used inside okokGarage, not guranteed it will work.
            * STANDALONE: no garage resource found, you will need to integrate it
        Note:
            - By default, the system checks vehicles based on framework:
                ESX: user_vehicles
                IS_QB (QBCore, QBOX): player_vehicles
            - The table name can be customized in configs\sconfig.lua:
                ServerConfig.Database.QBCORE = "your_custom_table_name"
            Example:
                Garages = Garages.QB_GARAGE,
                ServerConfig.Database.QBCORE = "custom_vehicles_table"
            Standalone:
                - You must implement your own vehicle state management for fetching, impound, and return
                - By default it tries to load based off framework and determine proper db-table for checking player owned_vehicles as fallback.
            Troubleshooting:
                - Enable debug logs for more details if detection fails.
                - Set Garages manually if your system is not detected.
    ]]
    Fuel = AUTO_DETECT,
        --[[        Supported Fuel resources:
            * AUTO_DETECT: auto-detect fuel resource
            * Fuel.RCORE: rcore_fuel,
            * Fuel.LEGACY: LegacyFuel,
            * Fuel.PS: ps-fuel,
            * Fuel.CDN: cdn-fuel,
            * Fuel.TI: ti_fuel,
            * Fuel.MY: myFuel,
            * Fuel.OKOK: okokGasStation,
            * Fuel.OX: ox_fuel,
            * Fuel.LJ: lj-fuel,
            * Fuel.ND: nd_fuel,
            * Fuel.RENEWED: Renewed-Fuel,
            * Fuel.HYON_GAS: HYON_GAS,
            * STANDALONE: no fuel resource found, you will need to integrate it
    ]]
    Licence = Licence.NONE, -- a vRP atual nao possui metadata de licenses no formato QB
        --[[        Supported Licence resources:
            * AUTO_DETECT: auto-detect licence resource
            * Licence.ESX: esx_license,
            * Licence.QBCORE: qb-core,
            * Licence.CODESTUDIO: cs_licence,
            * STANDALONE: no licence resource found, you will need to integrate it
    ]]
    Menu = Menu.RCORE,
        --[[        Supported Menu:
            * AUTO_DETECT: auto-detect menu
            * Menu.RCORE: rcore_police,
            * Menu.ESX_CONTEXT: esx_context,
            * Menu.OX: ox_lib - context,
            * Menu.QB: qb-menu,
            * STANDALONE: rcore_police
    ]]
    Notify = Notify.QBCORE, -- QBCore:Notify implementado pela vRP Seoul
        --[[        Supported Notify system:
            * AUTO_DETECT: auto-detect Notify resource
            * Notify.BRUTAL: brutal_notify,
            * Notify.PNOTIFY: pNotify,
            * Notify.OX: ox_lib,
            * Notify.ESX_NOTIFY: esx_notify,
            * Notify.QBCORE: qb-core,
            * Notify.ESX: es_extended,
            * Notify.MYTHIC: mythic_notify,
            * Notify.OKOK: okokNotify,
            * Notify.ST_NOTIFY: vstNotify
            * STANDALONE: Will use native notifications included in resource
    ]]
    MDT = MDT.LB_TABLET, -- LB Tablet atual confirmado
        --[[        Supported MDT system:
            * AUTO_DETECT: auto-detect MDT resource
            * MDT.PS: ps-mdt
            * MDT.QS: qs-dispatch
            * MDT.DRX: drx_mdt
            * MDT.LB_TABLET 'lb-tablet'
            * MDT.TK: 'tk_mdt'
            * MDT.REDUTZU: redutzu-mdt
            * STANDALONE: no MDT resource found.
    ]]
    Society = Society.NONE, -- bridge persistente Seoul em rcore_police_society
        --[[        Supported Society system:
            * AUTO_DETECT: auto-detect Society resource
            * Society.QB_BANKING: qb-banking
            * Society.QB_MANAGEMENT: qb-management
            * Society.QBX_MANAGEMENT: qbx_management
            * Society.SNIPE: snipe_banking
            * Society.RENEWED: renewed_banking
            * Society.FD: fd_banking
            * Society.CRM_BANKING, crm-banking
            * Society.OKOK: okok_banking
            * Society.CODESTUDIO: cs-bossmenu
            * Society.TGG_BANKING: tgg-banking,
            * STANDALONE: no society resource found.
    ]]
    TextUI = TextUI.OX, -- ox_lib atual
        --[[        Supported TextUI system:
            * AUTO_DETECT: auto-detect TextUI resource
            * TextUI.RCORE: rcore_police,
            * TextUI.OX: ox_lib,
            * TextUI.QBCORE: qb-core,
            * TextUI.ESX: esx_textui,
            * STANDALONE: no TextUI resource found.
    ]]
    Duty = Duty.QBCORE, -- SetJobDuty implementado pela vRP Seoul
        --[[        Supported duty system:
            * AUTO_DETECT: auto-detect duty resource
            * STANDALONE: no duty resource found.
    ]]
    Keys = Keys.NONE, -- sem sistema de chaves atual confirmado neste pacote
        --[[        Supported key systems:
            * AUTO_DETECT: auto-detect keys resource
            * Keys.RCORE: rcore_garage,
            * Keys.FIVECODE, fivecode_carkeys,
            * Keys.CD, cd_garage,
            * Keys.QS, qs-vehiclekeys,
            * Keys.XD, xd_locksystem,
            * Keys.MK, mk_vehiclekeys
            * Keys.OKOK, okokGarage,
            * Keys.JAKSAM, vehicle_keys,
            * Keys.MR_NEWB, MrNewbVehicleKeys,
            * Keys.WASABI, wasabi_carlock,
            * STANDALONE: no key resource found.
    ]]
    PG = PG.OX, -- ox_lib progress
        --[[        Supported progressbar:
            * AUTO_DETECT: auto-detect progressbar resource
            * PG.OX: ox_lib,
            * PG.ESX: es_extended,
            * PG.QBCORE: qb-core,
            * STANDALONE: no progressbar found, it will use our solution.
    ]]
    Business = {
        SocietyPrefix = 'society'
    },
    Tackle = {
        Enable = true,                         -- This is used for enabling/disabling tackle feature.
        ExperimentalForceFrontBack = true,     -- This is used for checking tackle when being only fron front/behind not from sides (experimental)
        OnlyForDepartmentGroups = true,        -- This is used for enabling/disabling tackle feature only for police groups defined in this config.
        Key = 'H',                             -- Key used for tackling nearby player.
        CooldownKey = 1000,                    -- This allows to define cooldown before able to do another tackle.
        KeyReleaseTackledPlayer = 'E',         -- This is key for releasing tackled player from tackle.
        KeyReleaseTackledPlayerCooldown = 1.5, -- By default in seconds
        DisableCuffAndEscortKey = false,       -- This is used for disabling CuffAndEscortKey feature.
        Distance = 3.0,                        -- This is default distance radius to be able tackle somebody (closest to player)
    },
    Megaphone = {
        Enable = true,          -- This allows to enable/disable megaphone feature
        HearRangeRadius = 50.0, -- This allows to change distance (hear radius) when megaphone is active
        ExitKey = 'E',          -- This is used for exiting from megaphone
        TurnKey = 'H',          -- This is used for activating/disable megaphone
    },
    SocietyOptionsESX = {
        checkBal = true,  -- Allow to check society money from boss menu.
        withdraw = true,  -- Allow to withdraw from society (boss menu)
        deposit = true,   -- Allow to deposit to society (boss menu)
        employees = true, -- Allow to hire employees in business (boss menu)
        salary = true,    -- Allow to adjust employeees salary (boss menu)
        grades = true,    -- Allow to adjust grades in boss menu.
        wash = false,     -- Allow to wash business money.
    },
    Prefixes = {
        ['qb-policejob'] = 'police:client', -- Event name for qb-policejob
    },
    Events = {
        ['qb-openBossMenu'] = 'qb-bossmenu:client:OpenMenu',
        ['esx-openBossMenu'] = 'esx_society:openBossMenu',
        ['esx:playerLoaded'] = 'esx:playerLoaded',
        ['esx:setJob'] = 'esx:setJob',
        ['esx:playerLogout'] = 'esx:onPlayerLogout',
        ['QBCore:Client:OnPlayerLoaded'] = 'QBCore:Client:OnPlayerLoaded',
        ['QBCore:Client:OnJobUpdate'] = 'QBCore:Client:OnJobUpdate',
        ['esx_addonaccount:getSharedAccount'] = 'esx_addonaccount:getSharedAccount',
        ['esx_society:registerSociety'] = 'esx_society:registerSociety',
        ['skinchanger:getSkin'] = 'skinchanger:getSkin',
        ['skinchanger:loadClothes'] = 'skinchanger:loadClothes',
        ['qb-clothing:client:loadOutfit'] = 'qb-clothing:client:loadOutfit',
        ['QBCore:Server:SetDuty'] = 'QBCore:Server:SetDuty',
        ['QBCore:Client:SetDuty'] = 'QBCore:Client:SetDuty',
        ['esx_skin:getPlayerSkin'] = 'esx_skin:getPlayerSkin',
        ['skinchanger:loadSkin'] = 'skinchanger:loadSkin',
    },
    Service = {
        Cooldown = 2 -- Cooldown when want to set on/off duty (2 seconds by default)
    },
    BossMenu = {
        Enable = true,
        UseIncludedMenu = true,
        MoneySymbol = '$',
    },
    Outfits = {
        Enable = true,
        EnableRestoreOutfit = false, -- evita resetar skin civil sem bridge de appearance atual confirmado       -- When enabled, this will add option into menu restore player civil outfit
        UseIncludedOutfitSystem = true,   -- When enabled, it will use included outfit system based off player job grade. (see rcore_police/outfits.lua)
        ShownOwnGradeOutfitsOnly = false, -- When enabled, it will show only specific grade outfits
        DefaultDepartmentTemplate = {
            storage = DepartmentOutfits,
            access = {
                [0] = {
                    'short_sleeve',
                    'long_sleeve',
                },
                [4] = {
                    'swat'
                }
            }
        }
    },
    Fines = {
        Enable = true, -- Should this option be loaded in F6 (Job Menu)
        List = Fines   -- Can be found in rcore_police/configs/fines.lua
    },
    VehicleInfo = {
        UseProgressBar = true,               -- This allow to use progressbar for vehicle info / disable.
        ProgressBarTime = 5,                 -- This allows to define how much time will take to get vehicle info (By default: in seconds)
        TemporaryPersistentFakeInfo = false, -- This setting will for the same vehicle show same generated fake info, until TemporaryPersistentFakeInfoTime
        TemporaryPersistentFakeInfoTime = 5, -- Default: in minutes
        NotOwnedVehicleFakeInfo = true,      -- This will allow to generate fake informations for non-owned vehicles (NPC) when using F6 - Vehicle - Vehicle information
    },
    UnlockVehicle = {
        UseProgressBar = true, -- This allow to use progressbar for unlocking vehicle / disable.
        ProgressBarTime = 5,   -- This allows to define how much time will take to open the nearby locked vehicle (By default: in seconds)
    },
    SelectPlayers = {
            --[[            ShowMode:
                * ID: This will only show playerId of nearby players Player: (#1)
                * OOC_ID: This will show OOC name with playerId: NewEdit (#1)
        ]]
        ShowMode = SHOW_MODE.ID,
        Marker = {
            type = 21, -- The type of marker
            r = 255,   -- Red
            g = 255,   -- Green
            b = 255,   -- Blue
            a = 100,   -- Alpha
        }
    },
    Reports = {
        Enable = true,                                       -- This is used to enable/disable report system
        NotifyAllDepartmentOfficersWhenNewReport = true,     -- This is used for notify all departments officers when new report occured at Lobby
        NotifyAllDepartmentOfficersWhenUpdatedReport = true, -- This is used for notify all departments officers when report was updated by officer
        LimitReportsPerPlayer = true,                        -- This is used for limit reports per player, to not able spam the reports
        CooldownResetPerPlayer = 5,                          -- In minutes by default
        InputWriteLimit = 200,
    },
    PoliceRadar = {
        Enable = true,                -- This is used for enable/disable police radar included in this resource.
        OpenKey = "N",                -- This is key used for opening.
        SpeedType = 'KMH',            -- Options: MPH, KMH
        CheckDistance = 10.0,         -- This is check distance for front & rear radar camera
        CheckRadius = 8.0,            -- This is for checking vehicles in the specified front & rear radar camera angles (circle)
        LockRadarKey = 'U',           -- This allows to lock radar.
        FastLock = false,             -- This allows fast lock to be set.
        FastLockSpeed = 15,           -- This is by default fast lock speed.
        RestrictOnlyForDriver = true, -- This allows to restrict radar be able to opened by driver only!
        WhitelistedVehicles = {       -- Here you can define vehicles where radar can be opened if needed
            ['sultanrs'] = true,
        },
        Beep = {
            Play = true,                        -- This allows to enable/disable beep sound when any update for plate/speed being targeted.
            AudioName = "5_SEC_WARNING",        -- Name of sound from dictionary below
            AudioRef = "HUD_MINI_GAME_SOUNDSET" -- Name of dictionary for specified sound above
        },
        RecentSessions = true,                    -- This allows to track temporary history
        RecentSessionsTrackVehicleWithSpeed = 10, -- The speed which the vehile will be added into recent session history of tracked vehicles.
    },
    Area = {
        Enable = false -- This is used for disable vehicle generators (Vehicle, NPC) on the area of police map preset.
    },
    HelpKeys = {
        Position = "top-left" -- Positions: top-left, top-right, center-left, center-right, bottom-left, bottom-right
    },
        --[[        Blips behavior matrix:
        RequireItem | RequireDuty | AutoBlip | Result
        Yes         | Yes         | Yes      | Must have GPS + be on duty → blip appears automatically
        Yes         | Yes         | No       | Must have GPS + be on duty → blip must be activated manually
        Yes         | No          | Yes/No   | Needs GPS only → blip depends on GPS use/toggle
        No          | Yes         | Yes      | Needs duty only → blip appears automatically
        No          | Yes         | No       | Needs duty only → blip must be activated manually
        No          | No          | Yes/No   | Blips always visible (⚠️ not recommended)
    ]]
    Blips = {
        Enable         = true, -- Seoul: GPS/blips policiais ativos; item gps cadastrado nos dois catálogos.
        AutoSubscribe  = true, -- Auto-subscribe players in departments
        AutoBlip       = false, -- Automatically show a player's blip when requirements are met
        RequireDuty    = true, -- Only show blips if the member is on duty
        LabelFormat    = "[{grade}] {name}",
        Font           = {
            Enable = false,       -- Enable custom font for blip labels
            Name   = "Pricedown", -- Font face name (e.g., "Pricedown", "Chalet-London", etc.)
        },
        Blip           = {
            Display    = 2,
            Category   = 7,
            Scale      = 1.4,
            ShortRange = false,
        },
        SpritesByState = {
            Walk = {
                sprite = 60,
                color  = 0,
            },
        },
        GPS            = {
            ItemName          = Items.GPS,
            ItemUsageCooldown = 1500, -- 1.5 seconds cooldown
            RequireItem       = true, -- If true, player must have + activate GPS
        }
    },
    Props = {
        DespawnOnlyForDepartmentGroups = false, -- This allows to restrict interaction with props only for department groups
        SpeedZoneRange = 10.0,                  -- This speed zone range is 30 units (m) - blocking NPC paths around barriers.
        SpeedZoneSpeed = 0.0,                   -- Target speed for vehicles (NPC) around barriers
        SpikesRange = 1.5,
        SpeedCamera = {
            SpeedType = 'KMH',                    -- Options: MPH, KMH
            CooldownForProcessingSameVehicle = 5, -- By default in minutes
            DefaultMaxSpeed = 50.0,               -- This allows to define default max speed if not defined in input form.
            CheckDistance = 30.0,                 -- This is default distance for checking vehicle.
            BlipOption = true,                    -- This is allowing option to define if camera should be visible on map
            IgnoreFineForDepartments = true,      -- This is allowing to disable fine, for speeding officers.
            IgnoreJobList = {
                ["lspd"] = true,
                ["prpd"] = true,
                ["paramedic"] = true,
            },
                --[[                InvoiceMode:
                    * 1: The invoice from camera will go to driver of the vehicle.
                    * 2: The invoice from camera will to the owner of vehicle.
                        - This needs to be defined by yourself in: modules\bridge\server\billing\your_billing.lua - CreateOfflineInvoiceForVehicle
            ]]
            InvoiceMode = 1,
            Blip = {
                Label = 'Radar movel',
                Sprite = 184,
                Color = 2,
                Scale = 1.0,
            }
        },
        HelpKeys = {
            {
                key = 'E',
                label = 'Pressionar'
            },
            {
                key = 'MOUSE_UP',
                label = 'Girar'
            },
            {
                key = 'H',
                label = 'Sair'
            },
        },
        AllowDrawLineDirectionHelper = true, -- This is used to draw line which help to navigate for camera direction (only for speed_camera)
        DistanceBetweenWheelClamp = 1.0,
        DistanceBetweenProps = 3.0,      -- How much distance is required between props.
        LodDistance = 290,               -- What distance props are going to be loaded for users
        TakeItemWhenPlacingProp = true,  -- This will allow when prop is placed up to take item from player inventory
        ReturnItemWhenRemoveProp = true, -- This will allow when prop is picked up to get item in player inventory
        CheckHasItem = false,            -- This will check if player needs to have specific item in his inventory to place item.
        PG = {
            EnableWhenDeploying = true, --To enable/disable progressbar for when deploying object
            EnableWhenPicking = true,   --To enable/disable progressbar for picking up object
            Time = 5,                   -- In seconds
        },
        PlaceEditorCheckDistance = 10.0, -- This is distance how far the raycast will work from your ped.
        PlaceEditorOutlineColor = {      -- This is color seen when using editor in preview of object is shown
            r = 255,                     -- RED
            g = 255,                     -- GREEN
            b = 255,                     -- BLUE
            a = 50,                      -- ALPHA
        },
        PlaceEditorOutlineNotPlacableColor = {
            r = 255,
            g = 0,
            b = 0,
            a = 255,
        },
        PlaceEditorDistance = 2.0, -- This allows to change distance for placing prop from you (player)
        ModelDataByPropType = {
            [PROP_TYPES.WHEEL_CLAMP] = {
                prop = 'prop_spot_clamp',
                itemName = Items.WheelClamp,
                label = 'Trava de roda',
                action = ZONE_ACTIONS.BLOCK_VEHICLE_MOVEMENT,
                needItem = Items.WheelClampWrench,
                needItemLabel = "Chave da trava de roda"
            },
            [PROP_TYPES.SPIKES] = {
                prop = 'p_ld_stinger_s',
                itemName = Items.Spikes,
                label = 'Fura-pneu',
                action = ZONE_ACTIONS.DESTROY_VEHICLE_TYRES,
            },
            [PROP_TYPES.BARRICADE] = {
                prop = 'rds_prop_barrier_police',
                itemName = Items.Barrier,
                label = 'Barreira',
                action = ZONE_ACTIONS.BLOCK_VEHICLES_IN_FRONT,
            },
            [PROP_TYPES.SPEED_RADAR] = {
                prop = 'rds_speed_camera',
                itemName = Items.SpeedCamera,
                label = 'Radar',
                action = ZONE_ACTIONS.CHECK_VEHICLE_SPEED,
            }
        }
    },
    WheelClamp = {
        Enable = true,
        DistanceToBoneToRemove = 1.2,
        Bones = {
            "wheel_lf", "wheel_rf",
            "wheel_lr", "wheel_rr",
            "wheel_lm1", "wheel_rm1",
            "wheel_lm2", "wheel_rm2",
            "wheel_lm3", "wheel_rm3"
        }
    },
    JobMenu = {
        Enable = true,        -- This allow to enable/disable included job menu.
        EnableInvoice = true, -- This allows to enable invoices
        EnableProps = true,   -- This allows props
        PropList = {
            {
                label = 'Fura-pneus',
                model = 'p_ld_stinger_s',
                icon = '',
                type = PROP_TYPES.SPIKES,
            },
            {
                label = 'Barreira',
                model = 'rds_prop_barrier_police',
                icon = 'fa-solid fa-road-barrier',
                type = PROP_TYPES.BARRICADE
            },
            {
                label = 'Megafone',
                model = 'prop_megaphone_01',
                icon = '',
                type = PROP_TYPES.MEGA_PHONE
            },
            {
                label = 'Radar movel',
                model = 'rds_speed_camera',
                icon = '',
                type = PROP_TYPES.SPEED_RADAR
            },
        },
    },
    InventoryImageUseState = false,
    InventoryImagePaths = {
        [Inventory.OX] = 'nui://ox_inventory/web/images',
        [Inventory.QB] = 'nui://qb-inventory/html/images',
        [Inventory.LJ] = 'nui://lj-inventory/html/images',
        [Inventory.QS] = 'nui://qs-inventory/html/images',
        [Inventory.PS] = 'nui://ps-inventory/html/images',
        [Inventory.TGIANN] = 'nui://inventory_images/images',
    },
    ItemShop = {
        Enable = true, -- This will set to use our Weapon Shop system included!
        DefaultDepartmentTemplate = {
            mode = SHOP_STATE.ACCESS_BY_ANY_MEMBERS,
            storageMode = STORAGE_MODE.FREE,
            storage = {
                [Items.Spikes] = { label = "Fura-pneus", price = 0 },
                [Items.Handcuffs] = { label = "Algemas", price = 255 },
                [Items.Barrier] = { label = "Barreira", price = 255 },
                [Items.HandcuffsKeys] = { label = "Chave de algemas", price = 0 },
                [Items.PaperBag] = { label = "Saco de papel", price = 0 },
                [Items.Zipties] = { label = "Enforca-gato", price = 0 },
                [Items.BodyCam] = { label = "Bodycam", price = 0 },
                [Items.WheelClamp] = { label = "Trava de roda", price = 0 },
                [Items.WheelClampWrench] = { label = "Chave da trava de roda", price = 0 },
                [Items.Camera] = { label = "Camera de evidencia", price = 0 },
                [Items.BodyCamTablet] = { label = "Tablet da bodycam", price = 250 },
                [Items.SpeedCamera] = { label = "Radar movel", price = 250 },
                [Items.Megaphone] = { label = "Megafone", price = 0 },
                [Items.PanicButton] = { label = "Botao de panico", price = 0 },
                [Items.ZipTiesCutter] = { label = "Cortador de enforca-gato", price = 0 },
                [Items.GPS] = { label = "GPS", price = 0 },
                ['radio'] = { label = "Radio", price = 250 },
                ['WEAPON_RIFLE_AMMO'] = { label = "Municao de rifle", price = 70 },
                ['WEAPON_PISTOL_AMMO'] = { label = "Municao de pistola", price = 50 },
                ['WEAPON_NIGHTSTICK'] = { label = "Cassetete", price = 500 },
                ['WEAPON_CARBINERIFLE'] = { label = "Carabina", price = 500 },
                ['WEAPON_STUNGUN'] = { label = "Taser", price = 150 },
                ['WEAPON_APPISTOL'] = { label = "Pistola AP", price = 500 },
                ['WEAPON_FLASHLIGHT'] = { label = "Lanterna", price = 300 },
            },
            access = {
                [0] = {
                    "WEAPON_APPISTOL", "WEAPON_NIGHTSTICK", "WEAPON_STUNGUN",
                    "WEAPON_FLASHLIGHT", "radio", "WEAPON_RIFLE_AMMO", "WEAPON_PISTOL_AMMO",
                    Items.Spikes, Items.Barrier, Items.Handcuffs, Items.HandcuffsKeys,
                    Items.SpeedCamera, Items.Zipties,
                    Items.BodyCam, Items.PaperBag,
                    Items.WheelClamp, Items.WheelClampWrench, Items.Camera,
                    Items.Megaphone, Items.PanicButton, Items.ZipTiesCutter, Items.GPS
                },
                [1] = {
                    Items.BodyCamTablet,
                },
                [3] = {
                    'WEAPON_CARBINERIFLE',
                },
                [5] = { "*" },
            }
        },
        Weapon = {
            WhenBuyedWeaponGaveAmmo = true,     -- This allows to enable giving off ammo when buying weapon
            WhenBuyedWeaponGaveAmmoAmount = 30, -- Number of ammo (item) that will be gaven to the weapon
            AmmoToWeapon = {
                ['WEAPON_APPISTOL'] = 'WEAPON_PISTOL_AMMO',
                ['WEAPON_ASSAULTSMG'] = 'WEAPON_SMG_AMMO',
                ['WEAPON_CARBINERIFLE'] = 'WEAPON_RIFLE_AMMO',
            },
            AmmoToWeaponQBCore = {
                ['WEAPON_APPISTOL'] = 'pistol_ammo',
                ['WEAPON_ASSAULTSMG'] = 'smg_ammo',
            }
        },
        PaymentDialog = true,
        AmmoAlias = {
            ['ammo-shotgun'] = 'shotgun_ammo',
            ['ammo-9'] = 'pistol_ammo',
            ['ammo-rifle'] = 'rifle_ammo',
        },
    },
    BodyCams = {
        EnableCommand = true,     -- This allows to enable/disable command for opening body cams feed.
        CommandName = 'bodycams', -- Name of the command for the bodycams dashboard feed.
        HideModel = false,
        ExitCamKey = 'E',             -- Key used for exiting bodycams!
        ThreadTime = 250,             -- Default spectator cycle time (in ms)
        RestrictByGrades = false,     -- This allows to restrict bodycams feed based off grade level below.
        RestrictSpectateByGrades = 2, -- Player grade needs to be >= 2
        Prop = {
            BoneId = 24818,
            Pos = vec3(0.12683200771922, 0.14320925137666, 0.11986595654326),
            Rot = vec3(-14.502323044318, 100, 100)
        },
        Spectate = {
            EnableScreenEffects = true,             -- This allows to enable/disable effect when spectating somebody bodycam.
            EffectName = 'Island_CCTV_ChannelFuzz', -- This allows to change effect for the spectate mode
            EffectModifier = 0.1,
        }
    },
    RanksAsBossList = {
        ['chief'] = true,
        ['boss'] = true,
        ['Comandante'] = true, -- LSPD nivel superior Seoul
        ['Chefe'] = true,      -- PRPD nivel superior Seoul
    },
    Garage = {
        Enable = true,              -- This is allows to enable/disable garage system.
        UseOurBuiltinGarage = true, -- This allow to enforce our garages
        DefaultDepartmentTemplate = {
            storage = {
                ['police4'] = { label = "Viatura descaracterizada", model = 'police4', price = 0 },
                ['police3'] = { label = "Viatura policial (A)", model = 'police3', price = 0 },
                ['police2'] = { label = "Viatura policial (B)", model = 'police2', price = 0 },
                ['police'] = { label = "Viatura policial (C)", model = 'police', price = 0 },
                ['policeb'] = { label = "Moto policial", model = 'policeb', price = 0 },
                ['policet'] = { label = "Van policial", model = 'policet', price = 0 },
                ['riot'] = { label = "Blindado policial", model = 'riot', price = 0 },
                ['fbi2'] = { label = "FBI", model = 'fbi2', price = 0 },
                ['polmav'] = { label = "Helicoptero policial", model = 'polmav', price = 0, isAir = true },
            },
            access = {
                [0] = {
                    "police3",
                },
                [1] = {
                    "policet",
                    "policeb",
                },
                [2] = {
                    "riot",
                    "fbi2",
                    "police",
                    "police2",
                },
                [3] = {
                    "police4",
                },
                [5] = { "*" },
            }
        },
        VehicleInformations = {
            IconsByKey = {
                ['vehicle_plate'] = 'fas fa-map-pin',
                ['plate'] = 'fas fa-map-pin',
                ['vehicle_owner'] = 'moroccan fa-car',
                ['vehicle_name'] = 'far fa-comments',
                ['owner_phone_number'] = 'fas fa-phone',
                ['owner_identifier'] = 'fas fa-question',
            }
        },
        MarkerRenderDistance = 10,           -- This is default marker render distance for garage points
        NeedsToBuyVehiclesInGarages = false, -- This allow to enable/disable that vehicles in garage needs to be buy, then picked up for free.
        PricePerVehicleOrder = 50,
        UseOwnImpound = false,                -- This allow to enable/disable included Impound - you can hook own.
        ImpoundUseProgresBar = true,          -- This allow to enable/disable progress bar for impound
        ImpoundRemoveTime = 10,               -- By default in seconds
        EnableExtrasMenu = true,              -- Can be found under F6 job menu - Vehicles menu.
        EnableSpawnVehicleWithExtras = true,  -- Enable setting Vehicle extras when vehicle spawn.
        DepartmentsEnableBuyVehicles = false, -- When enabled, this set requirement to buy vehicles from garage
        DepartmentsBuyVehicleCostPrice = 100, -- Buy price for each vehicle when enabled buy vehicles.
        DefaultFuelLevel = 100,               -- Default vehicle fuel level when spawned
        VehicleExtras = {
            ['police'] = {
                {
                    label = 'Sirene - tipo (B)',
                    state = true,
                    id = 2,
                }
            }
        },
    },
    UseTargetForZones = false, -- This is used when you want to use target instead of markers for your zones.
    Stashes = {
        [ZONE_TYPE.PERSONAL_LOCKER] = {
            Slots = 10,
            MaxWeight = 50000,
        },
        [ZONE_TYPE.EVIDENCE_STASH] = {
            Slots = 50,
            MaxWeight = 50000,
        },
        [ZONE_TYPE.WEAPON_STORAGE] = {
            Slots = 50,
            MaxWeight = 50000,
        },
        [ZONE_TYPE.JOB_STASH] = {
            Slots = 50,
            MaxWeight = 50000,
        }
    },
    DutySystemState = true,    -- This allows to enable/disable duty system for job menus, interact with zones etc.
    AutoDutyDisableQB = true,  -- Recommend to keep on true, since QBCORE/QBOX are having duty set automatically as true.
    AutoDutyDisableESX = true, -- Recommend to keep on true, since ESX is having duty set automatically as true by default. (Only for latest es_extended)
    AutoDutyTimeout = 1000,    -- This is time when it applies when being detect as loaded in department (dont change this!)
    AutoDuty = true,           -- This allows to set player duty automatically when loading in as citizen part of derpatment group below.
    Flags = {
        CuffsItemOnlyForDepartmentGroups = false,
        CuffsRequiredForTransport = false,
        SkipDeathCheck = false,
    },
    JobGroups = {
        ['LSPD'] = {
            Outfits = {
                storage = DepartmentOutfits,
                access = {
                    [0] = {
                        'short_sleeve',
                        'long_sleeve',
                    },
                    [4] = {
                        'swat'
                    }
                }
            },
            VehiclesToGrade = {
                storage = {
                    ['police4'] = { label = "Viatura descaracterizada", model = 'police4', image = 'https://docs.fivem.net/vehicles/police4.webp', price = 300 },
                    ['police3'] = { label = "Viatura policial (A)", model = 'police3', price = 300 },
                    ['police2'] = { label = "Viatura policial (B)", model = 'police2', price = 300 },
                    ['police'] = { label = "Viatura policial (C)", model = 'police', price = 300 },
                    ['policeb'] = { label = "Moto policial", model = 'policeb', price = 300 },
                    ['policet'] = { label = "Van policial", model = 'policet', price = 300 },
                    ['riot'] = { label = "Blindado policial", model = 'riot', price = 300 },
                    ['fbi2'] = { label = "FBI", model = 'fbi2', price = 300 },
                    ['polmav'] = { label = "Helicoptero policial", model = 'polmav', price = 300, isAir = true },
                },
                access = {
                    [0] = {
                        "police3",
                        "polmav",
                    },
                    [1] = {
                        "policet",
                        "policeb",
                    },
                    [2] = {
                        "riot",
                        "fbi2",
                        "police",
                        "police2",
                    },
                    [3] = {
                        "police4",
                    },
                    [5] = { "*" },
                }
            },
            Store = {
                mode = SHOP_STATE.ACCESS_BY_ANY_MEMBERS,
                storageMode = STORAGE_MODE.FREE,
                storage = {
                    [Items.Spikes] = { label = "Fura-pneus", price = 0 },
                    [Items.Handcuffs] = { label = "Algemas", price = 255 },
                    [Items.Barrier] = { label = "Barreira", price = 255 },
                    [Items.HandcuffsKeys] = { label = "Chave de algemas", price = 0 },
                    [Items.PaperBag] = { label = "Saco de papel", price = 0 },
                    [Items.Zipties] = { label = "Enforca-gato", price = 0 },
                    [Items.BodyCam] = { label = "Bodycam", price = 0 },
                    [Items.WheelClamp] = { label = "Trava de roda", price = 0 },
                    [Items.WheelClampWrench] = { label = "Chave da trava de roda", price = 0 },
                    [Items.Camera] = { label = "Camera de evidencia", price = 0 },
                    [Items.BodyCamTablet] = { label = "Tablet da bodycam", price = 250 },
                    [Items.SpeedCamera] = { label = "Radar movel", price = 250 },
                    [Items.Megaphone] = { label = "Megafone", price = 0 },
                    [Items.PanicButton] = { label = "Botao de panico", price = 0 },
                    [Items.ZipTiesCutter] = { label = "Cortador de enforca-gato", price = 0 },
                    [Items.GPS] = { label = "GPS", price = 0 },
                    ['radio'] = { label = "Radio", price = 250 },
                    ['WEAPON_RIFLE_AMMO'] = { label = "Municao de rifle", price = 70 },
                    ['WEAPON_PISTOL_AMMO'] = { label = "Municao de pistola", price = 50 },
                    ['WEAPON_NIGHTSTICK'] = { label = "Cassetete", price = 500 },
                    ['WEAPON_CARBINERIFLE'] = { label = "Carabina", price = 500 },
                    ['WEAPON_STUNGUN'] = { label = "Taser", price = 150 },
                    ['WEAPON_APPISTOL'] = { label = "Pistola AP", price = 500 },
                    ['WEAPON_FLASHLIGHT'] = { label = "Lanterna", price = 300 },
                },
                access = {
                    [0] = {
                        "WEAPON_APPISTOL", "WEAPON_NIGHTSTICK", "WEAPON_STUNGUN",
                        "WEAPON_FLASHLIGHT", "radio", "WEAPON_RIFLE_AMMO", "WEAPON_PISTOL_AMMO",
                        Items.Spikes, Items.Barrier, Items.Handcuffs, Items.HandcuffsKeys,
                        Items.SpeedCamera, Items.Zipties,
                        Items.BodyCam, Items.PaperBag,
                        Items.WheelClamp, Items.WheelClampWrench, Items.Camera,
                        Items.Megaphone, Items.PanicButton, Items.ZipTiesCutter, Items.GPS,
                    },
                    [1] = {
                        Items.BodyCamTablet,
                    },
                    [3] = {
                        'WEAPON_CARBINERIFLE',
                    },
                    [5] = { "*" },
                }
            }
        },
        ['PRPD'] = {
            Outfits = {
                storage = DepartmentOutfits,
                access = {
                    [0] = {
                        'trooper',
                    },
                }
            },
            VehiclesToGrade = {
                storage = {
                    ['police4'] = { label = "Viatura descaracterizada", model = 'police4', price = 0 },
                    ['police3'] = { label = "Viatura policial (A)", model = 'police3', price = 0 },
                    ['police2'] = { label = "Viatura policial (B)", model = 'police2', price = 0 },
                    ['police'] = { label = "Viatura policial (C)", model = 'police', price = 0 },
                    ['policeb'] = { label = "Moto policial", model = 'policeb', price = 0 },
                    ['policet'] = { label = "Van policial", model = 'policet', price = 0 },
                    ['riot'] = { label = "Blindado policial", model = 'riot', price = 0 },
                    ['fbi2'] = { label = "FBI", model = 'fbi2', price = 0 },
                    ['polmav'] = { label = "Helicoptero policial", model = 'polmav', price = 0, isAir = true },
                },
                access = {
                    [0] = {
                        "police3",
                    },
                    [1] = {
                        "policet",
                        "policeb",
                    },
                    [2] = {
                        "riot",
                        "fbi2",
                        "police",
                        "police2",
                    },
                    [3] = {
                        "police4",
                    },
                    [5] = { "*" },
                }
            },
            Store = {
                mode = SHOP_STATE.ACCESS_BY_ANY_MEMBERS,
                storageMode = STORAGE_MODE.FREE,
                storage = {
                    [Items.Spikes] = { label = "Fura-pneus", price = 0 },
                    [Items.Handcuffs] = { label = "Algemas", price = 255 },
                    [Items.Barrier] = { label = "Barreira", price = 255 },
                    [Items.HandcuffsKeys] = { label = "Chave de algemas", price = 0 },
                    [Items.PaperBag] = { label = "Saco de papel", price = 0 },
                    [Items.Zipties] = { label = "Enforca-gato", price = 0 },
                    [Items.BodyCam] = { label = "Bodycam", price = 0 },
                    [Items.WheelClamp] = { label = "Trava de roda", price = 0 },
                    [Items.WheelClampWrench] = { label = "Chave da trava de roda", price = 0 },
                    [Items.Camera] = { label = "Camera de evidencia", price = 0 },
                    [Items.BodyCamTablet] = { label = "Tablet da bodycam", price = 250 },
                    [Items.SpeedCamera] = { label = "Radar movel", price = 250 },
                    [Items.Megaphone] = { label = "Megafone", price = 0 },
                    [Items.PanicButton] = { label = "Botao de panico", price = 0 },
                    [Items.ZipTiesCutter] = { label = "Cortador de enforca-gato", price = 0 },
                    [Items.GPS] = { label = "GPS", price = 0 },
                    ['radio'] = { label = "Radio", price = 250 },
                    ['WEAPON_RIFLE_AMMO'] = { label = "Municao de rifle", price = 70 },
                    ['WEAPON_PISTOL_AMMO'] = { label = "Municao de pistola", price = 50 },
                    ['WEAPON_NIGHTSTICK'] = { label = "Cassetete", price = 500 },
                    ['WEAPON_CARBINERIFLE'] = { label = "Carabina", price = 500 },
                    ['WEAPON_STUNGUN'] = { label = "Taser", price = 150 },
                    ['WEAPON_APPISTOL'] = { label = "Pistola AP", price = 500 },
                    ['WEAPON_FLASHLIGHT'] = { label = "Lanterna", price = 300 },
                },
                access = {
                    [0] = {
                        "WEAPON_APPISTOL", "WEAPON_NIGHTSTICK", "WEAPON_STUNGUN",
                        "WEAPON_FLASHLIGHT", "radio", "WEAPON_RIFLE_AMMO", "WEAPON_PISTOL_AMMO",
                        Items.Spikes, Items.Barrier, Items.Handcuffs, Items.HandcuffsKeys,
                        Items.SpeedCamera, Items.Zipties,
                        Items.WheelClamp, Items.WheelClampWrench, Items.Camera,
                        Items.Megaphone, Items.PanicButton, Items.ZipTiesCutter, Items.GPS,
                    },
                    [1] = {
                        Items.BodyCamTablet,
                    },
                    [3] = {
                        'WEAPON_CARBINERIFLE',
                    },
                    [5] = { "*" },
                }
            }
        },
    },
    FrameworkAdminGroups = {
        [Framework.ESX] = {
            ['superadmin'] = true,
            ['admin'] = true,
        },
        [Framework.QBCore] = { 'god', 'admin' },
        [Framework.QBOX] = { 'god', 'admin' },
    },
    PresetCreator = {
        Enable = true,                -- This enable/disable preset creator tool.
        PointCheckDist = 5.0,         -- This is default distance to check between points.
        DisableDistanceCheck = false, -- This is used for diasbling point check distance, might be useful for some maps.
        SkipPointConfirmation = true, -- This is used for checking if you want to auto confirmation for points or not.
    },
    JobMenuKey = 'F6',          -- This is default key for opening job menu
    InteractZone = "E",         -- This is default key for interacting with zones
    CheckDistance = 2.0,        -- This is default checking distance to zone
    CheckVehicleDistance = 3.0, -- This is default checking distance when near vehicle
    RadialMenu = {
        Enable = true, -- This allows to enable/disable included radial menu
        Key = 'F1'     -- Seoul: tecla para abrir o radial policial
    },
    Zones = {
        RenderDistanceNPC = 150.0, -- This is default zone render distance for NPC
        ZoneRenderDistance = 5.0,  -- This is default zone render distance
        ScaleFactor = 1.0,         -- This allows to change scale factor of markers
        Style = 'Marker'           -- 3D, Marker, Target
    },
    Marker = {
        Rotation = true,                -- This enable rotation of markers
        Alpha = 100,                    -- The alpha of markers rendered
        Type = 20,                      -- The style of markers
        Scale = vector3(0.5, 0.5, 0.5), -- The scale of markers
        Colour = {                      -- The RGBA color for marker
            r = 150,
            g = 150,
            b = 150,
            a = 255
        }
    },
    EmergencyCall = {
        CooldownState = true, -- This will block any spam for emergency call from same layer
        Cooldown = 5,         -- In minutes, 5 by default
        PlaySound = true,     -- This allows to play sound when emergency call sent
        Blip = {
            Sprite = 161,     -- Blip icon
            Colour = 1,       -- Color of blip
            Display = 8,      -- Blip display type
            Scale = 2.0       -- Blip default scale
        }
    },
    Zipties = {
        Enable = true,
        ReturnZipTies = false,
        UseableRemoveItems = {
            Items.ZipTiesCutter,
            'weapon_switchblade',
            'weapon_knife',
            'weapon_machete',
        },
    },
    SearchInventory = 2 * 1000, -- This allows to set default search time for player inventory interaction.
    PanicButton = {
        EnableCommand = true,             -- This allows to enable command for panic button (only for department groups)
        NeedItem = true,                  -- Does player neede panic_button item be able use it
        NeedItemName = Items.PanicButton, -- Item defined for apnic button
        DispatchDisableGroupNotify = true -- It will be disable builtin notification for other department members.
    },
    Handsup = {
        Enable = true,         -- Allows to enable/disable our included handsup system.
        EnableCooldown = true, -- Allows to enable/disable cooldown for specific key, to prevent abuse.
        Animations = {
            { dict = "missminuteman_1ig_2", name = "handsup_base" } -- Here you can define different handsup animations that can be registered as "Hands up"
        },
        CooldownTime = 1.5, -- By default in seconds
        Key = "X",
    },
    Knee = {
        Enable = true,         -- This allows to enable/disable knee feature.
        EnableCooldown = true, -- Do you want to set cooldown for knee command?
        CooldownTime = 1.5,    -- By default in seconds
    },
    PlayerSearch = {
        Flags = {
            RequireHandsup = true,
            RequireCuffed = true,
        }
    },
    Image = {
        AllowCameraItem = true,
        AllowTakenPhotoReplaceWithRealImage = false, -- This option will work only for ox_inventory.
    },
    Escort = {
        Enable = true,
        Flags = {
            RequireHandsup = true,
            RequireCuffed = true, -- Enables a check that the player is cuffed before allowing escort.
        },
        BreakWhenNotCuffsOn = true,                        -- This allows to enable/disable breaking cuffs when not having them on
        BreakWhenNotCuffsOnKey = "E",                      -- Default key for breaking the cuffs
        EnableStopEscort = true,                           -- This allows to enable/disable quick hotkey for stopping escort
        EnableStopEscortKey = "G",                         -- Default key for stopping escort
        CuffCitizenKey = 'H',                              -- Default key for cuffing & re-escorting citizen
        EnableCuffCitizenWhenNotCuffedDuringEscort = true, -- This allows to enable/disable cuffing during escort
    },
    CuffAndEscortKey = 'J', -- This is default key for tackle cuffing & escorting at the same time.
    Cuffing = {
        BreakCuffsMinigame            = true,  -- This allows to enable break cuff minigame for target player (depends on BreakCuffsChance)
        BreakTackleMinigame           = true,  -- This allows to enable tackle minigame for target player (depends on BreakTackleChance)
        CheckDistance                 = 1.5,   -- This is default distance for being close to another player when cuffing
        TakeAndReturnItems            = true,  -- This allows to enable/disable taking & returning items when interacting
        CheckHasItems                 = true,  -- This allows to enable/disable check of items when interacting
        DisableCuffKeysUseableItem    = false, -- This allows to set useable items for Items.HandcuffKeys if useable or not
        DisableSprintForCuffedPlayers = false, -- This allows to enable/disable sprinting for cuffed players.
        DisableWalkForCuffedPlayers   = false, -- This allows to enable/disable of player movement when being cuffed.
        DisableInventoryWhileCuffed   = false, -- This allows to enable/disable player inventory usage while being cuffed.
        BreakCuffsTimeFront = 4, -- By default 2 seconds. (Front)
        BreakCuffsTimeBack  = 4, -- By default 4 second (Back)
        Minigame            = {
            speed = 3,      -- 1-10
            maxFails = 2,   -- Max fails
            maxRevs = 3,    -- Max checkpoints
            neededPicks = 1 -- How many to break out off cuff/tackle
        },
        PreCuff             = {
            Enable = false, -- Enable cool precuff scenario before cuffing player.
        },
        BreakCuffsChance    = 30, -- 30% change that mínigame will occur
        BreakTackleChance   = 30, -- 30% change that mínigame will occur
    },
    InteractionEnableTarget = true,           -- This allows to enable/disable interactions via target (OX | QB)
    InteractionsTarget = InteractionsTarget.OX, -- ox_target atual confirmado         -- This will perform automatic check what target system is used on the server
    RequireDutyForTargetInteractions = false, -- This set target interaction for department only useable when on duty.
}
Config.ItemsLabels = {
    [Items.ZipTiesCutter] = _U('ZIP_TIES_CUTTER'),
    [Items.HandcuffsKeys] = _U("HANDCUFFS_KEY"),
    [Items.Handcuffs] = _U("HANDCUFFS"),
    [Items.Barrier] = _U("BARRIER"),
    [Items.Megaphone] = _U("MEGAPHONE"),
    [Items.SpeedCamera] = _U("SPEEDCAMERA"),
    [Items.Spikes] = _U("SPIKES"),
    [Items.Zipties] = _U('ZIP_TIES'),
    [Items.PaperBag] = _U('PAPERBAG'),
}
Config.Commands = {
    SHOW_BLIPS = "show_blips",            -- Command used for subscribing to job blips
    PRESET_CREATOR = 'preset_creator',    -- Command used for preset creator.
    SET_PLAYER_JOB = 'setjob',            -- Only for standalone servers without framework
    REMOVE_PLAYER_JOB = 'removejob',      -- Only for standalone servers without framework
    GRANT_LICENCE = 'add_licence',        -- Command used for granting licence to player if supported licence script found.
    REVOKE_LICENCE = 'revoke_licence',    -- Command used for removing licence from player if supported licence script found.
    FREE_PLAYER = "freePlayer",           -- Admin command used for removing cuff/zipties from a player.
    PANIC_BUTTON = "panic_button",        -- Command used for emergecy call (departments membersr only)
    SEARCH_PLAYER = 'search',             -- Command used for searching player
    SEARCH_PLAYER_QB = 'rob',             -- Command used for searching player
    ESCORT_PLAYER = 'escort',             -- Command used for escort player
    PUT_PLAYER_IN_VEH = 'put_in_veh',     -- Command used for putting player in vehicle
    GET_PLAYER_FROM_VEH = 'get_from_veh', -- Command used for getting player from vehicle
}
Config.ChatCommands = {
    [Config.Commands.FREE_PLAYER] = true, -- Allows if this command can be used by admins or not.
}
Config.ChatSuggestions = {
    [Config.Commands.PRESET_CREATOR] = {
        { name = '', help = _U('SUGGESTIONS.PRESET_CREATOR') },
    },
    [Config.Commands.SEARCH_PLAYER] = {
        { name = '', help = '' },
    },
    [Config.Commands.ESCORT_PLAYER] = {
        { name = '', help = '' },
    },
    [Config.Commands.PUT_PLAYER_IN_VEH] = {
        { name = '', help = '' },
    },
    [Config.Commands.GET_PLAYER_FROM_VEH] = {
        { name = '', help = '' },
    },
    [Config.Commands.PANIC_BUTTON] = {
        { name = '', help = '' },
    },
    [Config.Commands.SET_PLAYER_JOB] = {
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_PLAYERID') },
        { name = _U('SUGGESTIONS.KEY_STRING'), help = _U('SUGGESTIONS.HELP_JOB') },
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_JOB_GRADE') },
    },
    [Config.Commands.REMOVE_PLAYER_JOB] = {
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_PLAYERID') },
    },
    [Config.Commands.GRANT_LICENCE] = {
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_PLAYERID') },
        { name = _U('SUGGESTIONS.KEY_STRING'), help = _U('SUGGESTIONS.HELP_LICENCE') },
    },
    [Config.Commands.REVOKE_LICENCE] = {
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_PLAYERID') },
        { name = _U('SUGGESTIONS.KEY_NUMBER'), help = _U('SUGGESTIONS.HELP_LICENCE') },
    }
}
