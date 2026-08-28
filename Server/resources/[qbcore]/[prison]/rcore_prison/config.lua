Config = {
    Debug = false,           -- This is enabling debug of rcore_prison
    DebugInventory = false,  -- This enable debug related to the inventory module
    DebugClothing = false,   -- This enable debug related to the clothing module
    DebugAPI = false,        -- This enable debug related to the API system

    DebugEnviroment = false, -- This enable debug related to the enviroment
    ErrorDebug = false,      -- will make errors easier to track

    DebugPlayerLoad = false, -- This enable debug related to playerLoad and disable other debug flags.

    DebugLevel = {
        'PLAYER_LOAD',
        'JOB',
        'CUFFS',
        'NETWORK',
        'INFO',
        'CRITICAL',
        'SUCCESS',
        'ERROR',
        'API',
        'DEBUG',
        'MENU',
    },

    Locale = 'en', -- Choose your language ['en']

    -- ⚠️ Deployer system ⚠️
    -- ⚠️ Third party resources can be installed by using our Deployer system without any additional configuration. ⚠️

    -- Supported resources by deployer: https://documentation.rcore.cz/paid-resources/rcore_prison#supported-resources
    -- Documentation: https://documentation.rcore.cz/paid-resources/rcore_prison/guides/deployer

    -- ⚠️⚠️ READ THIS CAREFULLY ⚠️⚠️
    -- ⚠️⚠️ If you are using ESX or QBCore or QBOX you can leave the Framework settings and Other script settings as they are, they will be detected automatically ⚠️⚠️

    --[[
        Supported frameworks:
            * AUTO_DETECT: auto-detect framework
            * Framework.ESX: es_extended
            * Framework.QBCore: qb-core
            * Framework.QBOX: qbx_core
            * Framework.NDCore: ND_Core
            * STANDALONE: no framework found, you will need to integrate it
    ]]
    Framework = Framework.QBCore, -- Seoul: QBCore compat fornecido pela vRP

    --[[
        Supported inventories:
            * AUTO_DETECT: auto-detect inventory [Only detecting supported inventories below]
            * Inventories.ESX: es_extended
            * Inventories.QB: qb-inventory
            * Inventories.PS, ps-inventory
            * Inventories.QS, qs-inventory
            * Inventories.OX, ox_inventory
            * Inventories.LJ, lj-inventory
            * Inventories.MF, mf-inventory
            * Inventories.CODEM, codem-inventory
            * Inventories.TGIANN, tgiann-inventory
            * Inventories.ORIGEN, origen-inventory
            * Inventories.CORE, core_inventory
            * STANDALONE: no inventory found, you will need to integrate it

    Note:
        - We only support official and up-to-date versions of supported inventories.
        - Custom or modified inventories may not work as expected, and we can't guarantee support.
        - codem_inventory: Using money as an item (not supported by qb-core by default) may cause issues we can't resolve, as it's handled internally. When money is used as an item, it isn't included in getInventoryItems.
        - qs-inventory: Using money as an item (not supported by qb-core by default) may cause issues we can't resolve, as it's handled internally. When money is used as an item, it isn't included in getInventoryItems.
        - qb-inventory: Money as an item isn't supported by default. If you need item-based money, we recommend using ox_inventory, which handles it correctly.
        - tgiann-inventory:
            Money as an item is not supported by default.
            When clearing inventory, we now use the ClearInventory export to directly remove the item.
            If money is not being removed properly, we can’t fix it, as it’s handled internally.
  ]]
  
    Inventories = Inventories.OX, -- Seoul: ox_inventory

    --[[
        Supported prisons:
            * AUTO_DETECT: auto-detect prison map [Only detecting supported maps below]
            * Map.RCORE
            * Map.PROMPT (V1 version)
            * Map.PROMPT_FULL (V2 full package)
            * Map.UNCLE
            * Map.ALCATRAZ
            * Map.YBN
            * Map.DESERTOS
            * Map.GABZ
            * STANDALONE: no prison map found, loading standalone preset (data/presets/standalone.lua)
    ]]

    Map = Map.RCORE, -- usar o mapa rcore_prison_map incluído no pacote

    --[[
        Supported interactions:
            * AUTO_DETECT: auto-detect interactions [Only detecting supported interactions below]
            * Interactions.OX: ox_target, -- If you are using crm-target, dont enforce it -> we strict check if resource is not emulated.
            * Interactions.QB: qb-target,
            * Interactions.MV, mv-target,
            * Interactions.NONE, distance interaction - press [E]
            * STANDALONE: no target interaction found, distance interaction - press [E] will be used
    ]]
    Interactions = Interactions.OX, -- Seoul: ox_target

    --[[
        Supported database connectors:
            * AUTO_DETECT: auto-detect db connector
            * Database.OX: oxmysql,
            * Database.MYSQL_ASYNC: mysql-async,
            * Database.GHMATTI: ghmattimysql,
            * STANDALONE: no db connector found
    ]]
    Database = Database.OX, -- Seoul: oxmysql

    --[[
        Supported clothing:
            * AUTO_DETECT: auto-detect clothing [Only detecting supported clothing below]
            * Cloth.RCORE: rcore_clothing
            * Cloth.ESX: skinchanger
            * Cloth.QB: qb-clothing
            * Cloth.IAPPEARANCE
            * Cloth.CODEM, codem-appearance (Experimental)
            * Cloth.CRM, crm-appearance (Experimental)
            * Cloth.TGIANN, tgiann-clothing
            * Cloth.WASABI, fivem-appearance - wasabi fork (Experimental)
    ]]
    Cloth = Cloth.NONE, -- aplicação do uniforme interno; restauração adaptada para nation_skinshop


    --[[
        Supported phone resources:
            * AUTO_DETECT: auto-detect phone resource
            * Phones.LB: lb_phone,
            * STANDALONE: Phone booths will be not useable.
    ]]
    Phones = Phones.LB, -- Seoul: lb-phone

    --[[
        Supported Notify resources:
            * AUTO_DETECT: auto-detect Notify resource
            * Notifies.BRUTAL: brutal_notify
            * Notifies.PNOTIFY: qb-pNotify
            * Notifies.OX: ox_lib
            * Notifies.ESX_NOTIFY: esx_notify
            * Notifies.QBCORE: qb-core
            * Notifies.ESX: es_extended
            * Notifies.MYTHIC: mythic_notify
            * Notifies.OKOK: okokNotify
            * Notifies.SPICY_NOTIFY: stNotify
            * STANDALONE: Will use native notifications included in resource
    ]]
    Notifies = Notifies.OX, -- Seoul: ox_lib

    --[[
        Supported TextUI resources:
            * AUTO_DETECT: auto-detect TextUI resource
            * TextUI.RCORE: rcore_prison,
            * TextUI.OX: ox_lib,
            * TextUI.QBCORE: qb-core,
            * TextUI.ESX: esx_textui,
            * STANDALONE: no TextUI resource found.
    ]]

    TextUI = TextUI.OX, -- Seoul: ox_lib

    --[[
        Supported Menu:
            * AUTO_DETECT: auto-detect menu
            * Menus.RCORE: rcore_prison,
            * Menus.ESX_CONTEXT: esx_context,
            * Menus.OX: ox_lib - context,
            * Menus.QB: qb-menu,
            * STANDALONE: rcore_prison
    ]]
    Menus = Menus.RCORE, -- manter a interface própria do rcore_prison

    --[[
        Supported dispatches:
            * AUTO_DETECT: auto-detect dispatch resources
            * Dispatches.RCORE, rcore_dispatch
            * Dispatches.QS, qs-dispatch
            * Dispatches.PS, ps-dispatch
            * Dispatches.CD, cd_dispatch
            * Dispatches.LB, lb-tablet
            * Dispatches.CORE, core_dispatch
            * Dispatches.CODEM, codem_dispatch
            * Dispatches.LOVE_SCRIPTS, emergency_dispatch
            * Dispatches.ORIGEN, origen_police
            * Dispatches.TK, tk_dispatch
            * Dispatches.DUSA, dusa_dispatch
            * Dispatches.KARTIK, kartik_dispatch
            * STANDALONE: no dispatch resource found, you will need to integrate it
    ]]

    --[[
        =========================================================

        How to test if the dispatch is working:

        1. Make sure you are in-game.
        2. Open your txAdmin panel and go to "Live Console".
        3. Type: rcore_prison_test_dispatch
        4. Press Enter.
        5. You should receive a test dispatch in-game.

        If you don't see the dispatch, check that:
        * The dispatch resource is started.
        * You are in job named police
        * Make sure that supported dispatch is run before rcore_prison.
        * No errors are showing in the server console.

        =========================================================
    --]]

    Dispatches = Dispatches.LB, -- Seoul: lb-tablet

    ---------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------------

    -- Framework admin groups

    FrameworkAdminGroups = {
        [Framework.ESX] = { 'superadmin', 'admin' },
        [Framework.QBCore] = { 'god', 'admin' },
        [Framework.QBOX] = { 'god', 'admin' },
    },

    AllowAdminGroupsUseJailCommands = false, -- This is used for allowing admin groups to use prison commands which are restricted to police/sheriff jobs

    RestrictCommandsForDistance = true,      -- This is used for restricting commands for distance to inmates.

    RestrictDistance = 10.0,                 -- This is the distance for restricting commands

    RegisterChatSuggestions = true,          -- Allow to register chat suggestions (enable/disable)

    Prisoners = {
        Companion = true,                -- This is used for enabling companion system, player with the specific job are not going to be attacked by Prison Guards
        CompanionRefreshCycleTime = 1.5, -- This is the time for refreshing prisoners (default in sec)
        CompanionJobList = {
            ['LSPD'] = true,
            ['PRPD'] = true,
            ['Paramedic'] = true,
        },

        RemovePlayerJobWhenJailed = false, -- Seoul: prisão não demite cargo permanente do cidadão        -- This is used for removing player job when citizen is jailed (supports: ESX, QBCore)
        RemovePlayerSetDefaultJob = 'unemployed', -- This is the default job set when RemovePlayerJobWhenJailed is enabled
        RemovePlayerSetDefaultGrade = 1,               -- This is the grade index set when RemovePlayerJobWhenJailed is enabled
        RemoveJobList = {
            ['LSPD'] = true,
            ['PRPD'] = true,
            ['Paramedic'] = true,
        }
    },

    

    -- If you are using renamed events for player load/unload, change only the right-side!

    PlayerLoad = {
        Client = {
            ['esx:playerLoaded'] = 'esx:playerLoaded',
            ['QBCore:Client:OnPlayerLoaded'] = 'QBCore:Client:OnPlayerLoaded',
            ['esx:onPlayerLogout'] = 'esx:onPlayerLogout',
            ['QBCore:Client:OnPlayerUnload'] = 'QBCore:Client:OnPlayerUnload',
        },

        Server = {
            ['esx:playerLoaded'] = 'esx:playerLoaded',
            ['QBCore:Server:OnPlayerUnload'] = 'QBCore:Server:OnPlayerUnload',
            ['ND:characterUnloaded'] = 'ND:characterUnloaded',
            ['esx:playerLogout'] = 'esx:playerLogout',
            ['esx:playerDropped'] = 'esx:playerDropped',
        },
    },

    -- If you are using renamed events, change only the right-side!

    FrameworkEvents = {
        ['QBCore:Client:OnJobUpdate'] = 'QBCore:Client:OnJobUpdate',
        ['esx:setJob'] = 'esx:setJob',
        ['esx_skin:getPlayerSkin'] = 'esx_skin:getPlayerSkin',
        ['skinchanger:loadSkin'] = 'skinchanger:loadSkin',
        ['skinchanger:getSkin'] = 'skinchanger:getSkin',
        ['skinchanger:loadClothes'] = 'skinchanger:loadClothes',
        ['qb-clothing:client:loadOutfit'] = 'qb-clothing:client:loadOutfit',
        ['qb-clothing:client:loadPlayerClothing'] = 'qb-clothing:client:loadPlayerClothing'
    },

    DisableClothing = false,                    -- Option to disable clothing

    CanPrisonerBeReleasedWhenOnSolitary = true, -- This is used for enabling prisoner to be released when they are on solitary
    ReduceSentenceType = SentenceTypes.ONLINE,  -- [OFFLINE - Prisoners are not required to be on server for sentence reduce, ONLINE - Prisoners are required to be on server for sentence reducing!]
    RenderJailTime = true,                      -- This is used for rendering jail time on the screen

    RenderNPCBlips = true,                      -- This is used for rendering blips on map
    RenderBlipsForEverybody = true,             -- This allows to render blips for all players, not only for prisoners.

    DisplayPrisonMapForEverybody = false,       -- This allows to render prison map for every player [When disabled it render only for prisoners]
    DisplayPrisonMap = true,                    -- This is used for displaying prison map on the game map! (The map consumes 0.02ms to render!) [When disabled it render only for prisoners]

    JailByNPCSettings = {
        JailDistance = 10.0, -- This is the distance for jailing player by NPC
        JailTime = 60,       -- This is the jail time for NPC jail (default in min)
        ResetPedPool = 5,    -- This is the time for resetting ped pool - so same ped can jail other users. (default in min)
    },

    -- Prison break settings

    DispatchSettings = {
        InvokeWhenDestroyedWall = true,      -- This is used for invoking dispatch when wall is destroyed (without NPC seen player destroying wall)
        InvokeWhenPlayerEscapePrison = true, -- This is used for invoking dispatch when player escaped from Prison (without NPC seen player escaping)
    },

    Escape = {
        ThirdParty = {
            ["prompt_prison_escape_dlc"] = {
                Alarm = {
                    Enable = true,                      -- Enable/disable alarm system
                    UseChance = false,                   -- Enable chance-based alarm triggering
                    TriggerChance = 75,                 -- Chance (0-100%) that alarm will trigger when conditions are met
                    AwaitedStartDelay = true,           -- Should alarm wait before starting?
                    AwaitedStartDelayConfig = {
                        UseRandomRange = false,         -- If true: random delay between min/max. If false: use strict delay
                        StrictDelay = 8,                -- Strict delay in seconds (used when UseRandomRange = false)
                        RandomMin = 10,                 -- Minimum random delay in seconds (used when UseRandomRange = true)
                        RandomMax = 30,                 -- Maximum random delay in seconds (used when UseRandomRange = true)
                    }
                },
                Dispatch = {
                    EnableOnEscape = true,              -- Enable dispatch when player escapes via third party script
                    EnableOnFullyReleased = false,      -- Enable dispatch when escaped prisoner leaves prison area (gives prisoner momentum)
                    UseChance = false,                  -- Enable chance-based dispatch triggering
                    TriggerChance = 100,                -- Chance (0-100%) that dispatch will trigger when conditions are met
                    AwaitedStartDelay = false,          -- Should dispatch wait before starting?
                    AwaitedStartDelayConfig = {
                        UseRandomRange = false,         -- If true: random delay between min/max. If false: use strict delay
                        StrictDelay = 5,                -- Strict delay in seconds (used when UseRandomRange = false)
                        RandomMin = 5,                  -- Minimum random delay in seconds (used when UseRandomRange = true)
                        RandomMax = 15,                 -- Maximum random delay in seconds (used when UseRandomRange = true)
                    }
                },
                ScriptName = "prompt_prison_escape",
                MapName = "prompt_prison_escape_dlc",
                PathWay = "toilets",
                Dealer = {
                    Enable = true, -- Do you want to included it to dealer items? (True/False)
                    ItemName = "screwdriver", -- Name of item required for prison escape
                    ItemLabel = "Screw Driver", -- Name of item in Dealer shop (label)
                    Cost = 45 -- It will cost the Config.EconomyItem
                }
            },
        },
      
        RequiredPolice = 3,                               -- How many police officers are need to be online?
        PoliceCheck = false,                              -- This is used for enabling checking if there is enough Police officers to start Prison break
        Enable = true,                                    -- This is used for enabling prison break system
        MarkerColor = { r = 255, g = 0, b = 0, a = 100 }, -- This is the color of the marker
        ViewCone = 160,
        WallLodSyncDistance = 150,                        -- This is the distance for syncing walls
        AutoCatch = true,                                 -- This is used for auto catching the prisone are escaping
        SolitaryTime = 5,                                 -- This is the time for solitary (default in min) - when prisoner is escaping and get caughh when AutoCatch enabled.
        DisableBugEscape = true,                          -- This is used for disabling bug escape system || Player are only allowed to escape through included Prison break system!
        WhenEscapeRemoveInmateStash = false,              -- This is used for removing inmates stash when they are escaping
        BugEscapeCycleTime = 1,                           -- This is the time for checking if prisoner is in area (default in minutes)
        ViewNPCDistance = 30,                             -- This is the distance for viewing NPC
        RepairWallTime = 10,                              -- This is the time for repairing the wall (default in seconds)
        RepairWallKey = 'H',
        InteractCuttersKey = 'E',
        ResetTime = 30,                   -- This is the time for resetting the escape (default in min)
        EnableAutomaticReset = true,      -- This is used for enabling automatic reset of the escape
        NeedItem = true,                  -- This is used for needing item to escape from the prison
        ItemName = 'wire_cutter',         -- This is the item name for escaping from the prison
        NotifyJobs = { 'LSPD', 'PRPD' }, -- This is the list of the jobs which are going to be notified when prisoner is escaping using supported dispatch system

        -- This is used for enabling spawning prison guards patrolling around prison yard.
        -- Value: false: Enable spawning
        -- Value: true: Disabled spawning

        DisablePatrollingGuards = true,  

        Experimental = {
            RemoveCuttersAfterWallDestroyed = true, -- This will enable removing wire_cutter (ItemName) from player inventory when destroying wall
            RemoveCuttersAfterSecondWall = true,     -- If true: remove after 2nd wall (1 cutter = 2 cuts). If false: remove after 1st wall (need 2 cutters)
            CuttingSequence = false,                 -- This will enable/disable cutting sequence
            CuttingSequenceTime = 15,                -- How much the cutting should take before wall breaks (in seconds)
            ClearPlayerInventoryWhenEscape = false,  -- This will enable/disable clearing of player inventory if he escaped
        }
    },
    
    Guards = {
        EnableJailAllCitizensWhenAttackedGuard = false, -- This is used for jailing all citizens when guard is attacked
        JailTime = 20,                                 -- This is the jail time for attacking guard (default in min)
    
        Experimental = {
            DistanceToGuard = 5.0, -- What distance is player checked
            PlayerMovementSpeed = 0.5 -- What current player movement speed needs to be able player sent to be solitary when run over into guard
        },
    },

    Statebag = {
        ServerPlayersUse = false
    },


    Solitary = {
        DistanceCheck = 10.0,      -- This is the distance for checking if player is in his solitary cell.
        GuardDistanceCheck = 10.0, -- This is the distance for checking if player is in the guard area.
        Time = 3,                  -- This is the time for solitary (default in min) - when guard is attacked by prisoner
    },

    Release = {
        AtCheckpoint = false, -- This is used for releasing prisoner at the checkpoint, if disabled prisoner will be released at the prison.
    },

    Circuit = {
        Lifes = 3,      -- How much lifes person has for Electrician
        Difficulty = 1, -- 1, 2, 3, 4, 5, 6 --> This is ignored when EachJobLevelIncreaseDifficulty is enabled

        HelpKeys = {
            EXIT = 'BACKSPACE',
            ARROW_UP = 'ArrowUp',
            ARROW_DOWN = 'ArrowDown',
            ARROW_LEFT = 'ArrowLeft',
            ARROW_RIGHT = 'ArrowRight',
        },

        Keybinds = {
            ['ARROW_UP'] = 172,
            ['ARROW_DOWN'] = 173,
            ['LEFT_ARROW'] = 174,
            ['RIGHT_ARROW'] = 175,
            ['BACKSPACE'] = 177,
        }
    },

    Commands = {
        Jail = 'jail',                    -- This is the command for jailing player
        Unjail = 'unjail',                -- This is the command for unjailing player
        Startcs = 'startcs',              -- This is the command for starting the community service
        Removecs = 'removecs',            -- This is the command for removing the community service
        JailCP = 'jailcp',                -- This is command for opening jail dashboard
        StopAlarm = 'stopalarm',          -- This is the command for stopping the alarm
        Solitary = 'solitary',            -- This is the command for sending player to solitary cell(s)
        RemoveSolitary = 'rsolitary',     -- This is the command for removing player from solitary cell(s)
        ResetPrisonBreak = 'resetescape', -- This is the command for resetting the prison break
    },

    Menu = {
        Position = 'top-right', -- This is the position of the menu ['top-left', 'top-right', 'bottom-left', 'bottom-right']
    },

    Helpkeys = {
        Position = 'top-left', -- This is the position of the help keys ['top-left', 'top-right', 'bottom-left', 'bottom-right']
    },

    Text = {
        Position = 'bottom-right', -- This is the position of the text ['top-left', 'top-right', 'bottom-left', 'bottom-right']
    },

    Subtitles = {
        Position = 'bottom-center', -- This is the position of the subtitles ['top-left', 'top-right', 'bottom-left', 'bottom-center', 'bottom-right']
    },


    Zone = {
        CheckDist = 3.0,               -- This is the distance for checking if player is in the zone
        InteractKey = 'E',             -- This is the key for interacting with the zone
        HelpkeysInteractKeyName = 'E', -- This is the key name for the help keys
        Size = vec3(1.0, 1.0, 1.0),    -- This is the size of the zones
    },

    -- Jobs which are allowed to jail/unjail players!

    Jobs = {
        ['LSPD'] = true,
        ['PRPD'] = true,
    },


    PrisonJobs = {
        PlayerJobCoolDown = 2,                                     -- This is the cooldown for player to get new job (default: 2 min)
        ResetJobPoolCooldown = 1,                                  -- This is the cooldown for resetting job pool (default: 1 min)
        RequiredDelivery = 5,                                      -- This is the required delivery for prisoner to be released

        TargetHighlight = false,                                   -- This is used for highlighting the target (Only for targets)
        TargetHiglightColor = { r = 50, g = 149, b = 1, a = 255 }, -- This is the color of the target highlight

        SetCustomRequiredDeliveries = true,                        -- This is used for setting custom required deliveries for each job

        -- By default using ox_lib skillCheck, can be changed to own via minigame in rcore_prison/modules/base/client/api/cl-jobs.lua

        Minigame = {
            Cooking = true,
            Janitor = true,
            CleanGround = true,
            BushTrimming = true,
        },

        Electrician = {
            EachJobLevelIncreaseDifficulty = true -- This is used for increasing difficulty for each job level
        },

        LeaveJobKey = 'G', -- This is the key for leaving the job
        DoJobKey = 'E',    -- This is the key for doing the job

        Stepper = {
            DoTask = 'SPACE', -- This is the key for doing exercises
            StopTask = 'H',   -- This is the key for stopping exercise
        },

        -- This is the list of the rewards which are going to be given to player when they finish the job(s)

        Rewards = {
            {
                type = 'ITEM',
                list = {
                    {
                        name = 'water',
                        count = 10
                    }
                }
            },
            {
                type = 'CREDITS',
                min = 100,
                max = 500,
            },
            {
                type = 'REDUCE_SENTENCE',
                value = 5 -- This is the value for reducing sentence time as reward (5 min)
            }
        },

        RenderInteractZoneDistance = 100.0, -- This is the distance for rendering interact zone
        InRadius = 1.5,                     -- This is the distance for checking if player is in radius

        RequiredDeliveries = {              -- This is the required deliveries for each job
            [JOBS.ELECTRICIAN] = 2,
            [JOBS.GARDENER] = 2,
            [JOBS.CLEAN_GROUND] = 1,
            [JOBS.BUSH_TRIMMING] = 3,
            [JOBS.COOK] = 1,
            [JOBS.LAUNDRY] = 3,
        }
    },


    PrisonYardAnnoucement = false, -- This is used for announcing prisoners about the yard time!
    BroadcastNewPrisoner = false,   -- This is used for broadcasting new prisoner to all players on server.
    AutoUncuffNewPrisoner = true,  -- This is used for auto uncuffing new prisoner when they are jailed.

    Time = TIMES.MIN,              -- This is the time unit for jail time ['SEC', 'MIN', 'HOURS', 'DAYS', 'WEEK', 'MONTHS']

    PhoneBooth = {
        Enabled = true,
        Lenght = 10,        -- This is the lenght of the phone number [10 - lb-phone]
        Format = '{3}-{3}-{4}', -- This is the format of the phone number [{3}-{4}: lb-phone]
    },  

    Chairs = {
        Enable = false,                 -- This is used for enabling chairs system
        RaycastDistCheck = 5.0,         -- This is the distance for checking if player is near the chair
        SeatDistCheck = 1.5,            -- This is the distance for checking if player is near the chair
        DebugSeatPos = false,           -- This is used for debugging the chair positions

        HealLayingPlayers = true,       -- This is used for healing players when they are laying on the bed
        HealModifier = 0.5,             -- This is the heal modifier for laying players
        HealLayingPlayersTimeCycle = 1, -- Default (1 minute) - This is the time in minutes for healing laying players
    },

    GYM = {
        -- Supported stats resources: [RTX_GYM]
        -- Can be added in rcore_prison/modules/base/client/client/api/cl-gym.lua

        DoExerciseKey = 'SPACE', -- This is the key for doing exercises
        StopExerciseKey = 'H',   -- This is the key for stopping exercise

        SkillMap = {
            [EXERCISE_MAP.CRANKS] = {
                action = {
                    percentIncrease = 2,
                    time = 4,
                },
                skills = {
                    strength = 0.3,
                    stamina = 0.1,
                }
            },

            [EXERCISE_MAP.SITUPS] = {
                action = {
                    percentIncrease = 8,
                    time = 1,
                },
                skills = {
                    strength = 0.3,
                    stamina = 0.1,
                }
            },

            [EXERCISE_MAP.MUSLECHIN] = {
                action = {
                    percentIncrease = 2,
                    time = 4,
                },
                skills = {
                    strength = 0.3,
                    stamina = 0.1,
                }
            },
        },
    },

    UI = {
        DisableAddSentencePlayerId = false, -- This will allow to define if AddSentence via playerId is enabled/disabled
        AddSentenceReasonRequired = false,  -- This will define Add Sentence - sentence reason is required
    },

    Mugshot = {
        Enable = false, -- Internal API for third party resources, this will not take mugshot from the player as you expect!
    },

    Outfits = {
        RestorePlayerOutfitOnRelease = true, -- This is used for setting outfit on release
    },

    ClothingStandaloneTesting = false, 
    EconomyItem = 'cigarrete', -- This is the economy item for prison

    Accounts = {
        Enable = true,                     -- This is used for enabling prisoner accounts system
        DeleteAccountWhenReleased = false, -- This is used for deleting account when prisoner is released
    },

    --[[
        Prolog System

        Server Events:
            rcore_prison:server:prologStarted  -> Triggered when prolog begins
            rcore_prison:server:prologFinished -> Triggered when prolog ends

        Note:
            If you are using an anticheat, players might be flagged for freecam
            during the prolog sequence. You can listen to these events to apply
            a temporary anticheat bypass to avoid false bans.
    ]]

    Prolog = {
        Enable = false,    -- This is used for enabling prolog system
        ResetCache = false -- This is used for resetting cache when prolog is started
    },

    COMS = {
        Enable = true,           -- This is used for enabling coms system
        RenderPerollTime = true, -- This is used for rendering peroll time on the screen

        Area = {
            EnableDynamicUnload = false -- This is used for allow to unload the current zone and load it back dynamically.
        },

        Blip = {
            enable = true, -- Do you want to show blip on map?
            sprite = 643,
            color = 1,
            scale = 1.0,
        },

        StartLocations = {
            name = 'Alta - Coms',
            coords = vector3(236.44, -409.33, 47.92),
            type = INTERACT_TYPES.COMS,
            zone = {
                size = vec3(1, 1, 1),
                icon = "fa-solid fa-paper-plane",
                label = 'Community service'
            },
            npc = {
                coords = vec3(236.44, -409.33, 47.92),
                heading = 342.26,
                model = 's_m_m_prisguard_01'
            },
            access = INTERACT_ACCESS_TYPES.ALL
        },

        RenderAreaOnlyForCOMSCitizens = false, -- This is used for rendering area only for coms citizens.
        DisableGameControls = true,            -- This is used for disabling game controls when player is cleaning.

        InteractKey = 'E',
        CleaningAnimTime = 10 * 1000,

        RenderDistance = 150.0, -- This is the distance for rendering coms
        InRadius = 100.0,       -- This is the distance for checking if player is in radius

        Models = {
            'prop_rub_cardpile_05',
            'prop_rub_binbag_03',
            'prop_skid_box_06',
            'prop_rub_flotsam_01',
            'prop_rub_litter_03c',
            'prop_rub_binbag_06',
            'prop_rub_cardpile_06',
        },

        Outline = {
            color = {
                x = 250, -- Red
                y = 149, -- Green
                z = 68   -- Blue
            },
            opacity = 80 -- Opacity of the outline
        }
    },


    -- This is the list of the inventory images paths to the items, that are used in our script frontend

    ImagePath = {
        [Inventories.OX] = 'nui://ox_inventory/web/images',
        [Inventories.QB] = 'nui://qb-inventory/html/images',
        [Inventories.LJ] = 'nui://lj-inventory/html/images',
        [Inventories.QS] = 'nui://qs-inventory/html/images',
        [Inventories.PS] = 'nui://ps-inventory/html/images',
        [Inventories.TGIANN] = 'nui://inventory_images/images',
        [Inventories.ESX] = '', -- When running es_extended the images are being loaded from rcore_prison/modules/nui/web/build/images/items
    },


    Alcatraz = {
        BackToLosSantosPos = vector4(13.7, -2784.97, 2.53, 359.96),
        BackToAlcatrazPos = vector4(3868.583984375, -28.968952178955, 6.7066369056702, 183.09248352051),

        Visit = {
            Enable = true,                                    -- Should allow to teleport to Visitation center & spawn NPC
            YardPos = vector4(3944.02, 45.33, 22.34, 281.05), -- Coords used for teleporting user back from visit
            VisitPos = vector4(3864.56, -13.29, 6.71, 92.68), -- Coords used for teleporting user to visitation room
        }
    },

    Canteen = {
        CreditItems = {
            { name = 'water',     price = 30, label = 'Water' },
            { name = 'fries',     price = 7,  label = 'Fries' },
            { name = 'sprunk',    price = 7,  label = 'Sprunk' },
            { name = 'cigarrete', price = 80, label = 'Cigars' },
        },

        FreeFoodPackage = true,      -- This is used for enabling free food package system
        FreeFoodPackageCooldown = 5, -- This is the cooldown for free food package system (5 min)
        FreeFoodPackageItems = {
            { name = 'water',  count = 1, label = 'Water' },
            { name = 'sprunk', count = 1, label = 'Sprunk' },
        }
    },

    -- Player stashed items are stored at Lobby guard when released!

    -- Money note:
        -- qb-inventory, qs-inventory, and codem-inventory do NOT store money as a real item.
        -- Money is handled as an account balance, so it cannot be stashed like normal items.
        -- These options may behave unpredictably, especially when UseCashAsItem is enabled
        -- (e.g., double money, incorrect refunds, or desync issues).
        -- Recommended: manage money through economy logic, not item stashing.
        -- If you want to attempt support anyway, the code is open and inventory handling can be extended.

    Stash = {
        EnableStashing = true,       -- This is used for enabling stashing system
        ReturnItemsOnRelease = true, -- This is used for returning items when citizen is released from prison
        AntiExploit = true,          -- This will block many attempt for getting items from stash
        KeepItemsState = true,       -- This is used for keeping items when citizen is jailed into prison.
        KeepItems = {
            ['bread'] = false,
            ['water'] = false,
            ['sludgie'] = false,
            ['money'] = false, -- Doesnt work with qs-inventory, qb-inventory, codem-inventory (money as item)
            ['cash'] = false,  -- Doesnt work with qs-inventory, qb-inventory codem-inventory (money as item)
        }
    },

    -- Experimental feature are provided as it is, use at your own risk!

    Experimental = {
        RestoreOutfitWhenDiedInAsPrisoner = true, -- This is used for restoring outfit when prisoner died in prison
    },

    Jail = {
        FetchClosestPlayer = 10.0, -- This is the distance for fetching closest player around player ./jailcp - Add Sentence
    },

    CigarProduction = {
        RewardCooldown = 5,       -- This is the reward cooldown for minigame (min)
        RewardMin = 1,            -- This is the reward amount for minigame
        RewardMax = 10,           -- This is the reward amount for minigame
        RewardItem = 'cigarrete', -- This is the reward item for minigame
    },

    Minigame = {
        AnimDict = 'anim@amb@business@coc@coc_unpack_cut_left@', -- Animation dictionary for minigame
        AnimName = 'coke_cut_v5_coccutter',                      -- Animation name for minigame

        Steps = 5,                                               -- How many blocks script is going to generate?
        MoveStep = 0.09,                                         -- Speed of arrowKeys generation block (> 0.02!!)
        Tolerance = 0.025,                                       -- What tolenrace should script ignore?
        TimeAcc = 0.3,                                           -- Calc behind keyPress minigame

        Keys = { 'W', 'S', 'A', 'D' },                           -- Option to define own keys for minigame, no need for change! :)

        -- Change only right side KEY

        Keybinds = {
            ['W'] = 'W',
            ['S'] = 'S',
            ['A'] = 'A',
            ['D'] = 'D',
        }
    },

    -- We dont recommend to change this settings, if you decide to change it and want to spawn NPC inside the prison by game-engine you have been warned!

    EnableSpawnNPCInsidePrison = false, -- This is used for enabling spawn NPC inside the prison

    Teleport = {
        WhenReleasedTeleportPrisonerInFrontOfPrison = true, -- This is used for teleporting prisoner in front of the prison when released
    }
}

--- Restrict zones are areas/zones when the police units (officers) are able to perform those specific commands defined in Access.
--- By default zone is defined on place where players are released and can be found in rcore_prison/data/presets/yourMap.lua - RestrictCommandZones

Config.RestrictZones = {
    Enable = false,   -- To enable/disable this feature
    CheckDist = 10.0, -- How far to check if player is close to any zone
    Access = {
        [Config.Commands.Unjail] = true,
        [Config.Commands.Jail] = true,
        [Config.Commands.JailCP] = true,
    }
}

Config.Hud = {
    -- Path: modules\base\client\api\cl-hud.lua

    -- Master switch: if false, HUD handling will not run at all.
    -- Set to true if you wants to use this system.
    Enable = false,

    States = {
        -- When a prisoner reconnects and their sentence is restored.
        -- false = HUD/radar disabled while in prison
        [HEARTBEAT_EVENTS.PRISONER_LOADED]   = false,

        -- When a prisoner is jailed for the first time (new sentence).
        -- false = HUD/radar disabled while in prison
        [HEARTBEAT_EVENTS.PRISONER_NEW]      = false,

        -- When a prisoner finishes their sentence OR escapes.
        -- true = HUD/radar enabled again when free
        [HEARTBEAT_EVENTS.PRISONER_RELEASED] = true,
    },

    ----------------------------------------------------------------------
    -- HandleRenderState
    --
    -- @param bool (boolean)
    --   - true  = Radar (HUD) will be enabled/visible
    --   - false = Radar (HUD) will be disabled/hidden
    --
    -- Description:
    -- This function is called whenever a prisoner state changes,
    -- passing in a boolean value that controls the HUD visibility.
    --
    -- By default, it uses DisplayRadar(bool) to toggle the radar.
    -- You may also extend this with your own events for custom HUD
    -- elements, e.g. TriggerEvent("your_hud:show") or
    -- TriggerEvent("your_hud:hide").
    ----------------------------------------------------------------------
    HandleRenderState = function(bool)
        DisplayRadar(bool)
        -- Example for extending:
        -- if bool then
        --     TriggerEvent("your_hud:show")
        -- else
        --     TriggerEvent("your_hud:hide")
        -- end
    end
}


-- Here you define what command should be enabled/disable:

Config.StateCommands = {
    [Config.Commands.Jail] = true,
    [Config.Commands.JailCP] = true,
    [Config.Commands.Unjail] = true,
    [Config.Commands.Startcs] = true,
    [Config.Commands.Removecs] = true,
    [Config.Commands.RemoveSolitary] = true,
    [Config.Commands.Solitary] = true,
    [Config.Commands.StopAlarm] = true,
    [Config.Commands.ResetPrisonBreak] = true,
}

Config.RestrictCommands = {
    Enable = false,          -- Do you want to restrict command based off job grades?
    UseGradeNumbers = false, -- This will use check via jobGrade number (this will disable check via ListGrades)
    GradeNumber = 2,         -- Which grades are able to access specific commands (>=)
    ListGrades = {           -- List of grades with access state (true = yes | false = no access) to use specific commands.
        [Config.Commands.Jail] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        },
        [Config.Commands.JailCP] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        },
        [Config.Commands.Unjail] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        },
        [Config.Commands.Startcs] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        },
        [Config.Commands.Removecs] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        },
        [Config.Commands.RemoveSolitary] = {
            ['recruit'] = false,
            ['officer'] = true,
            ['sergeant'] = true,
            ['lieutenant'] = true,
            ['chief'] = true,
            ['boss'] = true,
        }
    }
}

Config.UseableItems = {
    Tablet = 'prison_tablet'
}

Config.ChatSuggestions = {
    [Config.Commands.Jail] = {
        { name = _U('CHAT_SUGGESTIONS.JAIL_PLAYER_PARAM'),             help = _U('CHAT_SUGGESTIONS.JAIL_PLAYER_HELP_PARAM') },
        { name = _U(('CHAT_SUGGESTIONS.TIME_%s'):format(Config.Time)), help = _U(('CHAT_SUGGESTIONS.TIME_%s'):format(Config.Time)) },
    },
    [Config.Commands.Startcs] = {
        { name = _U('CHAT_SUGGESTIONS.JAIL_PLAYER_PARAM'), help = _U('CHAT_SUGGESTIONS.JAIL_PLAYER_HELP_PARAM') },
    },
    [Config.Commands.Unjail] = {
        { name = _U('CHAT_SUGGESTIONS.UNJAIL_PLAYER_PARAM'), help = _U('CHAT_SUGGESTIONS.UNJAIL_PLAYER_HELP_PARAM') },
    },
    [Config.Commands.Solitary] = {
        { name = _U('CHAT_SUGGESTIONS.SOLITARY_PLAYER_PARAM'),         help = _U('CHAT_SUGGESTIONS.SOLITARY_PLAYER_HELP_PARAM') },
        { name = _U(('CHAT_SUGGESTIONS.TIME_%s'):format(Config.Time)), help = _U(('CHAT_SUGGESTIONS.TIME_%s'):format(Config.Time)) },
    },
    [Config.Commands.RemoveSolitary] = {
        { name = _U('CHAT_SUGGESTIONS.REMOVE_SOLITARY_PLAYER_PARAM'), help = _U('CHAT_SUGGESTIONS.REMOVE_SOLITARY_PLAYER_HELP_PARAM') },
    }
}

-- Path: modules\base\client\api\cl-prison_alarm.lua

Sounds = {
    UseCustomAlarmSound = false, -- This allow you to enable/disable prison break alarm with own
}

Assets = {
    EnableGatesOnTopofStairs = true, -- This allow you to enable/disable gates on top of the stairs
    UnloadSolitaryCells = false,     -- This allow you to enable/disable solitary cells shown on Prison yard
    UnloadWallsWhenOnFullPrompt = true,
}


NetworkedEntities = {
    ["prop_hedge_trimmer_01"] = true,
    ["prop_tool_broom"] = true,
    ["prop_leaf_blower_01"] = true,
    ["prop_fish_slice_01"] = true,
}