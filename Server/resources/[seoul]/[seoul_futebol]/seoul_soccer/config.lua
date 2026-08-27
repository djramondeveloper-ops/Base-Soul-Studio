_G.Config = _G.Config or {}

Config = _G.Config
-- Toggle debug printing across scripts. Set to `true` to enable prints.
Config.Debug = false

-- If debug is disabled, silence the global `print` to avoid noisy output from scripts.
do
    local _orig_print = print
    if not Config.Debug then
        print = function() end
    else
        print = _orig_print
    end
end
-- Framework principal da Seoul Base. O bridge mantém fallbacks legados.
Config.Core = "VRP"

-- Language file: locales/<Locale>.json (en, tr, pt, es, de, pl)

Config.Locale = "pt"

-- Default match length in minutes
Config.MatchDuration = 20

-- Seoul Base / vRP bridge.
-- A taxa de entrada usa a economia oficial da vRP. "bank" usa PaymentBank,
-- usando o saldo bancário oficial da personagem na Seoul.
Config.Seoul = {
    MoneyAccount = "bank", -- bank | full
    Betting = {
        Enabled = true,
        Min = 0,
        Max = 100000,
    },
    Lobby = {
        MaxNameLength = 64,
        MinDurationMinutes = 1,
        MaxDurationMinutes = 180,
        MaxTargetGoals = 99,
    },
}

-- API externa: exports/eventos server-side continuam disponíveis, mas os net events
-- genéricos de consulta ficam desligados para reduzir superfície de spam de MySQL.
Config.API = {
    SaveMatchHistory = true,
    LeaderboardDefaultLimit = 10,
    LeaderboardMaxLimit = 100,
    MatchHistoryDefaultLimit = 20,
    MatchHistoryMaxLimit = 100,
    EnableServerEvents = true,
    EnableNetEvents = false,
}
Config.Commands = {
    -- Seoul: menu aberto pelo NPC/ox_target; sem comando global /soccer.
    OpenMenu = false,
    GoalDebugToggle = false,

}

-- Notify: ox_lib | qbcore | esx | auto
-- Target: auto | ox_target | qb-target | qtarget
Config.Bridge = {
    Notify = "ox_lib",
    Target = "ox_target",
}

-- Host-only keys during a match (FiveM control IDs)
Config.HostKeys = {
    StartMatch = 166,  -- F5
    TogglePause = 311, -- K
    EndMatch = 182,    -- L
    ToggleDoors = 29,  -- B
}

-- Lobby invite popup (labels only; keys can be changed in GTA Settings > Key Bindings)
Config.LobbyInvite = {
    AcceptKeyLabel = "K",
    DeclineKeyLabel = "J",
    InviteTimeoutMs = 60000,
}

-- Goal popup position on screen (CSS). Kept on the right so it does not cover the controls list.
Config.GoalNotification = {
    Right = "20px",
    Top = "50%",
}

-- Text shown on the pitch NPC target option
Config.TargetPed = {
    label = "Menu de Futebol",
    icon = "fas fa-futbol",
    distance = 2.0,
}

-- Map blips for each pitch. Set Label = false to use the pitch name.

Config.MapBlips = {
    Enabled = true,
    Sprite = 58,
    Color = 2,
    Scale = 1.0,
    Label = false,
    ShortRange = false,
}



-- Optional: enable goal markers, goalkeeper, slide tackle tweaks
-- Config.GoalMarkers = { Enabled = true }
-- Config.Goalkeeper = { Enabled = true }
-- Goalkeeper catch animation slots are classified as high/mid/low + left/center/right.
-- Example:
-- Config.Goalkeeper = {
--     CatchAnimations = {
--         Clips = {
--             high_left = { dict = "anim_dict_here", clip = "clip_here", flag = 49, durationMs = -1, attachDelayMs = 300 },
--             low_center = { dict = "anim_dict_here", clip = "clip_here", flag = 49, durationMs = -1, attachDelayMs = 300 },
--         }
--     }
-- }
Config.SlideTackle = {
    EnableKnockdown = true,

    -- How long the victim stays ragdolled (ms). Lower = gets up faster.
    MaxRagdollMs = 300,
    DurationMs = 700,
    StealDistance = 2.15,
    HardStealBallDistance = 2.15,
    ServerHardBallExtraTol = 0.28,
    ServerHardOwnerExtraTol = 0.55,
    HardStealUseHeadingDistance = true,
    HardStealHeadingAlongMax = 3.55,
    HardStealHeadingLateralMax = 1.52,
    HardStealHeadingBehindAllow = 0.42,
    HardStealHeadingAxis = "slide",
    OwnerReachExtra = 0.48,
    HardStealEngageMinDot = 0.12,
    PreCheckMaxDistance = 3.85,
    YawNudgeDegrees = 6.0,
    BallReach = {
        ZToleranceHard = 1.5,
        ZToleranceSoft = 0.9,
    },

    VictimRagdollMs = 1050,
    LooseBallPop = {
        MinSpeed = 8.2,
        MaxSpeed = 12.5,
        SpeedBonus = 3.4,
        Lift = 0.9,
        ForwardOffset = 2.1,
        HeightAbovePed = 0.42,
        OwnerlessMs = 1250,
        AttackerPickupLockMs = 1450,
        VictimPickupLockMs = 1500,
        VictimReclaimBlockMs = 2800,
    },
    HardStealRetryMs = 120,
}

Config.StealSystem = {
    -- 0 = hard slide (R) can be used immediately after a soft steal attempt
    ServerHardAfterSoftGateMs = 0,
}

-- Server-side validation distances for goal suggestions and loose ball claims.
Config.GoalDetection = {
    ClientSuggestMaxPedBall = 4.0,
    GoalSuggestMaxBallDeviation = 3.5,
    LooseClaimMaxDistance = 2.35,
}

Config.PlayerKeys = {
    -- E (tap, no sprint) = goalkeeper / save / pick up ball at feet
    -- SHIFT + E = soft steal
    -- R = slide tackle
    Steal = 38,
    HardSteal = 45,
}

-- Pitches: menu, blip, NPC, goals, and optional doors
Config.Pitches = {

    {
        id     = "broker_park",
        name   = "Broker Park",
        coords = vector3(771.2968, -234.1603, 65.2206),
        radius = 50.0,
        image  = "area1.png",
        npc = {
            enabled = true,
            model   = "a_m_y_dhill_01",
            coords  = vector4(800.0497, -232.2168, 66.2205, 165.8086)

        },

        -- Pitch gates (optional). Host locks/unlocks them from the match UI after warmup.
        -- Find model hash + coords with CodeWalker or a door finder tool.
        -- doors = {
        --     { label = "Gate 1", model = 579926722, coords = vector3(x, y, z) },
        -- },

        doors = {},
        goals = {
            {
                center      = vector3(745.2116, -220.9496, 66.2206),
                halfExtents = vector3(2.4, 3.1, 2.50),
                scoringTeam = 2,
                side        = "West goal",
            },

            {
                center      = vector3(796.9882, -247.2909, 66.2205),
                halfExtents = vector3(2.4, 3.1, 2.50),
                scoringTeam = 1,
                side        = "East goal",

            },

        },

    },

    {

        id     = "vespucci_beach",
        name   = "Vespucci Beach",
        coords = vector3(-1170.6082, -1711.4446, 3.5795),
        radius = 50.0,
        image  = "area1.png",
        npc = {
            enabled = true,
            model   = "a_m_y_dhill_01",
            coords  = vector4(-1181.9148, -1737.8893, 4.5795, 33.0401)
        },

        -- Prop doors: use closedCoords while closed, openCoords while open.
        -- Capture positions in-game with soccer_doorcapture closed / open.
        doors = {
            {
                label = "Door 1",
                kind = "prop",
                model = 579926722,
                coords = vector3(-1168.161621, -1728.699463, 4.5795),
                closedCoords = vector3(-1168.161621, -1728.699463, 4.5795),
                closedHeading = 35.5612,
                -- openCoords = vector3(...), openHeading = 35.5612,
            },

            {
                label = "Door 2",
                kind = "prop",
                model = 579926722,
                coords = vector3(-1191.158569, -1707.395386, 4.5795),
                closedCoords = vector3(-1191.158569, -1707.395386, 4.5795),
                closedHeading = 35.5612,
            },

        },

        goals = {
            {
                center      = vector3(-1193.9078, -1728.6550, 4.5795),
                halfExtents = vector3(1.30, 2.42, 2.80),
                scoringTeam = 2,
                side        = "West goal",
                goalLine = {
                    from   = vector3(-1196.5508, -1725.6871, 4.5795),
                    to     = vector3(-1192.3671, -1731.2461, 4.1),
                    inside = vector3(-1194.5513, -1729.1302, 4.1),
                },

            },

            {
                center      = vector3(-1147.3239, -1695.1033, 4.5795),
                halfExtents = vector3(1.30, 2.42, 2.80),
                scoringTeam = 1,
                side        = "East goal",
                goalLine = {
                    from   = vector3(-1145.3552, -1697.3862, 4.1),
                    to     = vector3(-1148.8016, -1692.4758, 4.1),
                    inside = vector3(-1146.6692, -1694.6438, 4.1),
                },

            },

        },

    }

}



-- Balls shown in the lobby creator (image = file in web/dist/assets)

Config.Balls = {

    {

        id = "classic",

        name = "Classic Soccer Ball",

        model = "p_ld_soc_ball_01",

        image = "default.png",

        syntheticRoll = false,

        rollRadius = 0.11,

    },

    {

        id = "red_ball",

        name = "Black soccer",

        model = "p_ld_soc_black_ball",

        image = "red_ball.png",

        syntheticRoll = true,

        rollRadius = 0.11,

    },

    {

        id = "white_ball",

        name = "White soccer",

        model = "p_ld_soc_ball_white",

        image = "white_ball.png",

        syntheticRoll = true,

        rollRadius = 0.11,

    }

}



-- Team kits applied directly to the ped (no qb-clothing required).

-- item = drawable index, or -1 = last drawable in that slot, -2 = second-to-last, etc.

-- usePlayerNumber = jersey number picks the texture

-- fallbackItem = used if the clothing pack is missing drawables

-- Slot names: mask, arms, pants, bag, shoes, chain, t-shirt, bproof, decals, torso2

-- Prop names: hat, glass, ear (item = -1 removes the prop)

Config.UniformCollection = {
    Enabled = true,
    Name = "as_football",
}

Config.UniformNumbers = {

    Min = 1,

    Max = 10,

    Default = 5,

}



Config.Uniforms = {

    ["team_a"] = {

        name = "Red Team",

        male = {

            outfitData = {

                ["t-shirt"]   = { item = 15, texture = 0 },

                ["torso2"]    = { item = -1, fallbackItem = 15, usePlayerNumber = true, numberTextureOffset = -1 },

                ["decals"]    = { item = 0, texture = 0 },

                ["arms"]      = { item = 15, texture = 0 },

                ["pants"]     = { item = -1, fallbackItem = 15, texture = 0 },

                ["shoes"]     = { item = -1, fallbackItem = 15, texture = 0 },

                ["mask"]      = { item = 0,  texture = 0 },

                ["hat"]       = { item = -1, texture = 0 },

                ["glass"]     = { item = 0,  texture = 0 },

                ["ear"]       = { item = -1, texture = 0 }

            }

        },

        

        female = {

            outfitData = {

                ["t-shirt"]   = { item = 15, texture = 0 },

                ["torso2"]    = { item = -1, fallbackItem = 15, usePlayerNumber = true, usePlayerNumberAsDrawable = true, texture = 0 },

                ["decals"]    = { item = 0, texture = 0 },

                ["arms"]      = { item = 15, texture = 0 },

                ["pants"]     = { item = -2, fallbackItem = 15, texture = 0 },

                ["shoes"]     = { item = -1, fallbackItem = 15, texture = 0 },

                ["mask"]      = { item = 0,  texture = 0 },

                ["hat"]       = { item = -1, texture = 0 },

                ["glass"]     = { item = 0,  texture = 0 },

                ["ear"]       = { item = -1, texture = 0 }

            }

        }

    },

    ["team_b"] = {

        name = "Blue Team",

        male = {

            outfitData = {

                ["t-shirt"]   = { item = 15, texture = 0 },

                ["torso2"]    = { item = -2, fallbackItem = 15, usePlayerNumber = true, numberTextureOffset = -1 },

                ["decals"]    = { item = 0, texture = 0 },

                ["arms"]      = { item = 15, texture = 0 },

                ["pants"]     = { item = -2, fallbackItem = 15, texture = 0 },

                ["shoes"]     = { item = -2, fallbackItem = 15, texture = 0 },

                ["mask"]      = { item = 0,  texture = 0 },

                ["hat"]       = { item = -1, texture = 0 },

                ["glass"]     = { item = 0,  texture = 0 },

                ["ear"]       = { item = -1, texture = 0 }

            }

        },



        female = {

            outfitData = {

                ["t-shirt"]   = { item = 15, texture = 0 },

                ["torso2"]    = { item = -1, fallbackItem = 15, usePlayerNumber = true, usePlayerNumberAsDrawable = true, texture = 0 },

                ["decals"]    = { item = 0, texture = 0 },

                ["arms"]      = { item = 15, texture = 0 },

                ["pants"]     = { item = -1, fallbackItem = 15, texture = 0 },

                ["shoes"]     = { item = -2, fallbackItem = 15, texture = 0 },

                ["mask"]      = { item = 0,  texture = 0 },

                ["hat"]       = { item = -1, texture = 0 },

                ["glass"]     = { item = 0,  texture = 0 },

                ["ear"]       = { item = -1, texture = 0 }

            }

        }

    }

}



-- Markers shown in warmup showing which goal you defend. Style: sign | ground_ring | minimal | aura | chevron

Config.GoalMarkers = {

    Style = "sign",

    Team1Color = { 240, 55, 55 },

    Team2Color = { 55, 145, 255 },

}



-- Stadium scoreboard on pitch props (DUI screen)

Config.FootballScoreboard = {

    Enabled = true,

    LazyDui = true,

    GoalOverlayMaxAgeMs = 2800,

    DuiPaintWaitMs = 900,

    DuiPage = "web/dist/stadium.html",

    ScoreboardDriver = "soccer",
    RequireAce = true,
    AcePermission = "football.scoreboard",

    DuiWidth = 1280,

    DuiHeight = 720,

    DrawDistance = 130.0,

    SpawnDistance = 180.0,

    DefaultMatchMinutes = 90,

    PolyExtraForward = 0.65,

    DrawBackFace = false,

    DrawSide = -1.0,

    FlipX = false,

    AutoFitModelScreen = true,

    ModelSurfacePush = 0.008,

    ModelScreenAxis = "y",

    ModelScreenXOffset = 0.0,

    ModelScreenYOffset = 0.0,

    ModelScreenDepthOffset = 0.0,

    ModelScreenZOffset = 0.0,

    ModelScreenWidthScale = 1.0,

    ModelScreenHeightScale = 0.95,

    Backplate = {

        Enabled = true,

        PaddingX = 0.22,

        PaddingY = 0.18,

        Color = { 0, 0, 0, 255 },

    },

    ScreenTextureReplace = {

        Enabled = false,

        Candidates = {},

    },

    -- Fallback labels if locale file is missing (normally use locales/*.json scoreboard.periods)

    PeriodLabels = {

        waiting = "LOBBY",

        warmup = "WARMUP",

        countdown = "KICKOFF",

        paused = "PAUSED",

        ended = "FULL TIME",

        first_half = "FIRST HALF",

        second_half = "SECOND HALF",

    },

    Boards = {

        {

            id = "broker_park_main",

            coords = vector3(782.7689, -222.1564, 66.2204),

            heading = 154.0673,

            model = "prop_huge_display_01",

            renderTarget = "big_disp",

            screenRotation = 0,

            modelOffset = vector3(0.0, 0.0, 8.0),

            supportModel = "prop_flagpole_3a",

            supportHeading = 154.0673,

            supportOffset = vector3(0.0, 0.0, -1.5),

            surfaceOffset = 0.0,

        },



        {

            id = "vespucci_beach_main",

            coords = vector3(-1157.0514, -1723.2834, 4.5796),

            heading = 215.3276,

            width = 3.2,

            height = 1.8,

            model = "prop_huge_display_01",

            renderTarget = "big_disp",

            modelOffset = vector3(0.0, 0.0, 8.0),

            supportModel = "prop_flagpole_3a",

            supportHeading = 35.3276,

            supportOffset = vector3(0.0, 0.0, 0.0),

            surfaceOffset = 0.0,

        },

    },

}



---@diagnostic disable-next-line: undefined-global

SoccerApplyConfigDefaults()


