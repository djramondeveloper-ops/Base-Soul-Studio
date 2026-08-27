--[[
  Internal defaults for seoul_soccer. Values here are merged with config.lua.
  Server owners should edit config.lua, not this file.
]]
SoccerConfigDefaults = {}

SoccerConfigDefaults.Core = "VRP"

SoccerConfigDefaults.Locale = "pt"

SoccerConfigDefaults.Commands = {
    OpenMenu = false,
    GoalDebugToggle = false,
}

SoccerConfigDefaults.MatchDuration = 20

-- Assists and leaderboard
SoccerConfigDefaults.Assists = {
    Enabled = true,
    WindowMs = 5000,
    LeaderboardOrderBy = "goals",
}

-- External API / match history
SoccerConfigDefaults.API = {
    SaveMatchHistory = true,
    LeaderboardDefaultLimit = 10,
    LeaderboardMaxLimit = 100,
    MatchHistoryDefaultLimit = 20,
    MatchHistoryMaxLimit = 100,
    EnableServerEvents = true,
    EnableNetEvents = true,
}

-- Jersey numbers in the lobby
SoccerConfigDefaults.UniformNumbers = {
    Min = 1,
    Max = 10,
    Default = 5,
}

-- Lobby invite popup
SoccerConfigDefaults.LobbyInvite = {
    AcceptKeyLabel = "K",
    DeclineKeyLabel = "J",
    InviteTimeoutMs = 60000,
}

-- Invite nearby players
SoccerConfigDefaults.NearbyInvite = {
    ClientScanRadius = 18.0,
    MaxRadius = 20.0,
}

-- Ball visibility and loose-ball physics
SoccerConfigDefaults.BallStreaming = {
    LodDist = 65535,
    CullingRadius = 15000.0,
    ReapplyVisibilityMs = 2500,
    ModelLoadTimeoutMs = 15000,
    ServerLooseBallSyncMs = 180,
    LooseSyncApplyThreshold = 0.42,
    LooseBallGroundFriction = {
        Enabled = true,
        ClientIntervalMs = 55,
        HorizontalRetainPerStep = 0.90,
        MaxHorizontalSpeedToApply = 8.0,
        HorizontalRetainHighSpeed = 0.965,
        MaxHeightAboveGroundForFriction = 0.85,
        HorizontalRetainAirborne = 0.968,
        StopHorizontalBelow = 0.085,
    },
    LooseBallForceStopAfterMs = 9000,
    LooseBallForceStopMaxHeightAboveGround = 0.78,
}

-- Goal detection and kickoff reset
SoccerConfigDefaults.GoalDetection = {
    PollIntervalMs = 50,
    CooldownMs     = 4000,
    BallResetDelayMs = 3500,
    BallSpawnUseGroundProbe = true,
    BallGroundProbeZOffset = 120.0,
    BallSpawnAboveGround = 0.14,
    BallSpawnGroundZSaneBand = 35.0,
    UsePitchBasedGoalLine = true,
    AutoGoalLineBackFromCenter = 1.35,
    AutoGoalLineHalfWidth = 2.55,
    GoalLineMinAdvance = 0.26,
    GoalLineAirZBandFraction = 0.5,
    GoalLineMinAdvanceAir = 0.09,
    AutoGoalLineInsideDepth = 0.5,
    GoalLineUseBoxMouthEdge = true,
    GoalLineMouthExtendEachSideM = 0.45,
    GoalLineExplicitExtendEachSideM = 0.55,
    DrawGoalLineDebug = false,
    GoalLineDebugThicknessM = 0,
    RequirePastFieldPlane = false,
    GoalMouthOffsetFromCenter = 1.38,
    GoalPastPlaneMinDot = 0.14,
    StrictGoalBounds = true,
    GoalAirZHeadroomM = 2.5,
    GoalSuggestMaxBallDeviation = 3.5,
    ZSlabMinThickness = 0.45,
    ZSlabHalfHeight   = 2.75,
    XYMinSpan    = 1.35,
    XYEdgePadding = 0.9,
    ClientSuggestMaxPedBall = 4.0,
    LooseClaimMaxDistance = 2.35,
    Debug = false,
    DebugNotifyIntervalMs = 0,
}

-- Pitch boundary and out-of-bounds
SoccerConfigDefaults.PitchBounds = {
    BallOutOfBoundsRadiusMultiplier = 1.02,
    InstantBallOobCenterRespawn = true,
    InstantBallOobClientCheckMs = 100,
    InstantBallOobPollIntervalMs = 120,
    BallOobRespawnNewEntity = true,
    PlayerKickRadiusMultiplier = 2.2,
    PollIntervalMs = 500,
    ProximityGraceMs = 15000,
}

-- Client performance tuning
SoccerConfigDefaults.Performance = {
    Client = {
        BallLoopIdleMs = 35,
        BallLoopIdleDistance = 14.0,
        BallLoopLobbyPhaseMs = 120,
        BallLoopNoBallMs = 80,
        BallResolveMissCacheMs = 140,
        SlideCooldownHudMs = 33,
        SoftStealHudMs = 16,
        DrawOverlayMs = 16,
        HostUiPollMs = 5,
        GoalkeeperHudMs = 16,
        WeaponBlockPollMs = 5,
        SoftContactGuardPollMs = 16,
        SoftContactGuardFullScanMs = 50,
        SoftProximityGuardScanMs = 16,
        SoftProximityGuardFarScanMs = 45,
        SoftProximityGuardNearExtraDistance = 2.0,
        DribbleSetupRefreshMs = 250,
    },
}

-- Goal popup screen position
SoccerConfigDefaults.GoalNotification = {
    Right = "20px",
    Top   = "50%",
}

-- Goal celebration picker
SoccerConfigDefaults.GoalCelebration = {
    Enabled = true,
    PromptTimeoutMs = 10000,
    PickerTimeoutMs = 13000,
    AnimDurationMs = 9000,
    FlipAnimDurationMs = 0,
    AcceptKeyLabel = "Y",
    DeclineKeyLabel = "N",
    AcceptKeybind = "y",
    DeclineKeybind = "n",
}

-- Warmup goal markers
SoccerConfigDefaults.GoalMarkers = {
    Enabled = true,
    ShowDuring = { "warmup", "countdown" },
    Style = "sign",
    ShowLabels = true,
    LabelZOffset = 1.45,
    LabelDrawDistance = 52.0,
    ShowGroundPatch = true,
    OffsetTowardField = 4.0,
    ZBump = 0.02,
    Alpha = 175,
    Pulse = false,
    PulseSpeed = 2.0,
    PulseAmplitude = 0.28,
    GroundRing = { Type = 25, Scale = { x = 1.75, y = 1.75, z = 0.14 } },
    Aura = {
        OuterScale = { x = 3.35, y = 3.35, z = 0.14 },
        InnerScale = { x = 2.05, y = 2.05, z = 0.18 },
        PostScale = { x = 0.45, y = 0.45, z = 1.35 },
    },
    MarkerType = 2,
    Scale = { x = 1.35, y = 1.35, z = 1.85 },
    BobUpAndDown = false,
    FaceCamera = false,
    DrawLight = false,
    Light = { Range = 4.5, Intensity = 0.55, ZOffset = 0.45 },
    Team1Color = { 240, 55, 55 },
    Team2Color = { 55, 145, 255 },
}

-- Stadium scoreboard (DUI)
SoccerConfigDefaults.FootballScoreboard = {
    Enabled = true,
    LazyDui = false,
    GoalOverlayMaxAgeMs = 2800,
    DuiPaintWaitMs = 900,
    DuiPage = "web/dist/stadium.html",
    ScoreboardDriver = "soccer",
    DuiWidth = 1280,
    DuiHeight = 720,
    DrawDistance = 130.0,
    SpawnDistance = 180.0,
    VisibilityTickMs = 650,
    TxdName = "football_scoreboard_txd",
    TxnName = "football_scoreboard_tex",
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
    ModelScreenWidthScale = 0.98,
    ModelScreenHeightScale = 0.88,
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
    RequireAce = true,
    AcePermission = "football.scoreboard",
    DefaultMatchMinutes = 90,
    PeriodLabels = {
        waiting = "LOBBY",
        warmup = "WARMUP",
        countdown = "KICKOFF",
        paused = "PAUSED",
        ended = "FULL TIME",
        first_half = "FIRST HALF",
        second_half = "SECOND HALF",
    },
    DefaultState = {
        homeName = "Red Team",
        awayName = "Blue Team",
        homeScore = 0,
        awayScore = 0,
        time = "00:00",
        period = "Waiting",
        status = "Standby",
    },
    Boards = {
        {
            id = "broker_park_main",
            coords = vector3(771.1984, -233.1716, 70.65),
            heading = 148.0,
            width = 3.6,
            height = 2.05,
            model = "prop_huge_display_01",
            modelOffset = vector3(0.0, 0.0, -0.08),
            surfacePush = 0.008,
            screenAxis = "y",
            screenXOffset = 0.0,
            screenYOffset = 0.0,
            screenDepthOffset = 0.0,
            screenZOffset = 0.0,
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
            modelOffset = vector3(0.0, 0.0, 5.0),
            supportModel = "prop_flagpole_3a",
            supportHeading = 35.3276,
            supportOffset = vector3(0.0, 0.0, 0.0),
            surfaceOffset = 0.0,
        },
    },
}

-- Goalkeeper role and saves
SoccerConfigDefaults.Goalkeeper = {
    Enabled = true,
    Key = 38, -- E
    KeyLabel = "E",
    ExitKey = 73, -- X
    ExitKeyLabel = "X",
    InteractDistance = 2.8,
    TextDistance = 13.0,
    OffsetTowardField = 2.8,
    TextZOffset = 1.15,
    ServerDistanceTolerance = 1.0,

    AreaRadius = 8.0,
    SavePromptDistance = 7.0,
    GoalPointPromptDistance = 8.0,

    CatchDistance = 2.6,
    GoalPointCatchDistance = 2.8,
    ParryDistance = 4.2,
    GoalPointParryDistance = 4.5,

    CatchFullSpeed = 7.0,
    CatchMaxBallSpeed = 13.0,
    CatchRequiresKnownSpeed = true,
    ProbabilisticCatch = true,
    AngleCatchBonusMin = 0.35,

    CatchMaxZAboveKeeper = 2.2,
    ParryMaxZAboveKeeper = 3.6,
    RequireBallToward = true,
    BallTowardDotMin = 0.05,
    CloseCatchDistance = 1.28,
    CloseCatchMaxBallSpeed = 6.5,

    ParrySpeed = 13.0,
    ParryLift = 1.6,

    SaveCooldownMs = 2200,
    FailedSaveExtraCooldownMs = 900,
    SwitchCooldownMs = 30000,
    HoldMaxMs = 6500,
    CarryOffset = 0.72,
    CarryHeight = 0.28,
    ReleasePickupLockMs = 900,
    HoldAnimDict = "anim@heists@box_carry@",
    HoldAnimClip = "idle",
    HoldAnimTaskFlag = 49,
    HoldAttachDelayMs = 300,
    HoldBoneTag = 57005,
    HoldBoneOffsetX = -0.015,
    HoldBoneOffsetY = 0.038,
    HoldBoneOffsetZ = 0.042,
    HoldBoneRotX = 0.0,
    HoldBoneRotY = 0.0,
    HoldBoneRotZ = 0.0,
    CatchAnimations = {
        Enabled = true,
        LowMaxZAbovePed = 0.55,
        HighMinZAbovePed = 1.15,
        CenterLateralMax = 0.45,
        CenterIncomingSpeedMax = 0.35,
        ForceLowCatch = true,
        ForceHighCatch = true,
        Clips = {
            -- Fill these later with { dict = "...", clip = "...", flag = 49, durationMs = -1, attachDelayMs = 300 }.
            -- Specific source keys are checked first: catch_high_left, pickup_low_center, etc.
            high_left = { dict = "random@mugging3", clip = "handsup_standing_enter", flag = 49, durationMs = 1250, attachDelayMs = 360, refresh = false },
            high_center = { dict = "random@mugging3", clip = "handsup_standing_enter", flag = 49, durationMs = 1250, attachDelayMs = 360, refresh = false },
            high_right = { dict = "random@mugging3", clip = "handsup_standing_enter", flag = 49, durationMs = 1250, attachDelayMs = 360, refresh = false },
            mid_left = {},
            mid_center = {},
            mid_right = {},
            low_left = { dict = "mini@tennis@female", clip = "dive_bh_long_hi", flag = 0, durationMs = 1250, attachDelayMs = 520, refresh = false },
            low_center = { dict = "mini@tennis@female", clip = "dive_bh_long_hi", flag = 0, durationMs = 1250, attachDelayMs = 520, refresh = false },
            low_right = { dict = "mini@tennis@female", clip = "dive_fh_long_hi", flag = 0, durationMs = 1250, attachDelayMs = 520, refresh = false },
        },
    },
    Punt = {
        MinSpeed = 15.0,
        MaxSpeed = 32.0,
        MinLift = 2.0,
        MaxLift = 5.2,
    },
    Throw = {
        MinSpeed = 8.0,
        MaxSpeed = 17.0,
        MinLift = 0.6,
        MaxLift = 1.8,
    },
    PickupAtFeet = {
        Enabled          = true,
        Key              = 47,
        KeyLabel         = "G",
        BallMaxDistance  = 2.0,
        BallMaxZAbovePed = 1.3,
        BallMaxSpeed     = 4.5,
        CooldownMs       = 800,
        PromptDistance   = 4.0,
        OnlyLooseBall    = true,
        ServerDistanceTolerance = 0.6,
    },
}

-- Notify and target integration
SoccerConfigDefaults.Bridge = {
    Notify = "ox_lib", -- "ox_lib" | "qbcore" | "esx" | "auto"
    Target = "ox_target" -- Seoul Base
}

-- Control hints shown in the match UI
SoccerConfigDefaults.Keybinds = {
    player = {
        { key = "F",              desc = "Pass / Shoot" },
        { key = "G",              desc = "Cross" },
        { key = "E",              desc = "Become GK / Save / Pick up ball" },
        { key = "E",              desc = "Steal ball (hold SHIFT + E)" },
        { key = "R",              desc = "Slide tackle" },
        { key = "O",              desc = "Scoreboard (hold)" },
    },

    goalkeeper = {
        { key = "E",              desc = "Save / Catch" },
        { key = "G",              desc = "Pick up ball (at feet)" },
        { key = "F",              desc = "Throw pass" },
        { key = "G",              desc = "Punt" },
        { key = "X",              desc = "Leave goalkeeper" },
    },

    host = {
        { key = "F5", desc = "Start match" },
        { key = "K",  desc = "Pause / Resume" },
        { key = "L",  desc = "End match" },
        { key = "B",  desc = "Pitch doors (lock / unlock all)" },
        { key = "I",  desc = "Shot effect: off -> random -> presets (I)" },
        { key = "U",  desc = "Lobby settings" },
    }
}

-- Host-only match keys
SoccerConfigDefaults.HostKeys = {
    StartMatch = 166,  -- F5
    TogglePause = 311, -- K
    EndMatch = 182,    -- L
    ToggleDoors = 29,  -- B
}

-- Player control IDs
SoccerConfigDefaults.PlayerKeys = {
    Kick = 23,         -- F (tap = pass, hold = shot)
    Cross = 47,        -- G (cross)
    Steal = 38,        -- E (soft steal, GK, save, pickup — see SoftSteal settings)
    HardSteal = 45,    -- R (slide tackle)
    FastDribble = 44,  -- Q (sprint dribble)
    SlideTackle = 36,  -- legacy; not used (slide is on R)
}

-- Slide tackle (R)
SoccerConfigDefaults.SlideTackle = {
    MinSpeed         = 3.5,
    ServerMinSpeedFactor = 0.80,
    StealDistance    = 2.15,
    HardStealBallDistance = 2.15,
    ServerHardBallExtraTol = 0.28,
    ServerHardOwnerExtraTol = 0.55,
    HardStealUseHeadingDistance = true,
    HardStealHeadingAlongMax = 3.55,
    HardStealHeadingLateralMax = 1.52,
    HardStealHeadingBehindAllow = 0.42,
    HardStealHeadingAxis = "slide",
    HardStealRequireBallAndOwner = true,
    OwnerReachExtra = 0.48,
    HardStealEngageMinDot = 0.12,
    ServerAckGraceMs = 420,
    BallReach = {
        ZToleranceHard = 1.2,
        ZToleranceSoft = 0.8,
    },
    CarryZOffset     = 0.05,
    PreCheckMaxDistance = 3.85,
    DurationMs       = 900,
    HardStealRetryMs = 150,
    CooldownMs       = 6500,
    MissCooldownMs   = 4500,
    MissStumbleMs    = 600,
    YawNudgeDegrees  = 6.0,
    ImpulsePower     = 3.0,
    SustainProfile = {
        MaxSpeed     = 7.5,
        MinSpeed     = 3.0,
        DecayFactor  = 0.55,
        ForceGain    = 60.0,
    },
    PostStealPickupLockMs = 450,
    PostSlideAutoClaimSuppressMs = 1100,
    LooseBallPop = {
        MinSpeed              = 5.5,
        MaxSpeed              = 9.0,
        SpeedBonus            = 2.0,
        Lift                  = 1.2,
        ForwardOffset         = 1.0,
        HeightAbovePed        = 0.55,
        OwnerlessMs           = 700,
        AttackerPickupLockMs  = 1000,
        VictimPickupLockMs    = 1200,
        VictimReclaimBlockMs  = 2200,
    },
    EnableKnockdown  = false,
    KnockdownMs      = 950,
    RecoveryMs       = 450,
    KnockdownPush    = 0.65,
    MaxRagdollMs     = 300,
    VictimRagdollMs  = 1200,
    BackTackleFoul = {
        Enabled      = true,
        DotThreshold = -0.3,
        NotifyVictim = true,
        NotifyAttacker = true,
    },
}

-- Standing tackle (optional)
SoccerConfigDefaults.StandTackle = {
    Enabled       = false,
    StealBallDistance = 1.60,
    ServerStandBallExtraTol = 0.45,
    ServerStandOwnerExtraTol = 0.55,
    CooldownMs    = 1500,
    AnimMs        = 450,
    AnimDict      = "melee@unarmed@streamed_core",
    AnimClip      = "short_0_punch",
    BonusReachWhileJockey = 0.20,
}

-- Defensive jockey stance
SoccerConfigDefaults.Jockey = {
    Enabled       = true,
    MaxDistance   = 2.0,
    FacingDotMin  = 0.35,
    MoveRateMul   = 0.70,
    BonusAfterJockeyMs = 500,
}

-- Ball highlight in the lobby
SoccerConfigDefaults.BallOutline = {
    Mode = "entity_outline",

    OutlineColor   = { 255, 235, 55, 255 },
    OutlineShader  = 1,

    StrokeOnBall = true,

    StrokeRadius   = 0.12,
    StrokeRings    = 4,
    StrokeSegments = 24,
    StrokeColor    = { 255, 255, 255, 230 },

    Radius     = 0.40,
    ZOffset    = 0.04,
    Segments   = 40,
    OuterMul   = 1.22,
    OuterZBump = 0.03,
    InnerColor = { 255, 235, 40, 245 },
    OuterColor = { 255, 42, 42, 235 },
}

-- Pass, shot, cross, and dribble
SoccerConfigDefaults.BallActions = {
    DribbleRollRadius = 0.11,
    DribbleRollGain   = 1.0,
    DribbleNetSync = {
        Enabled = true,
        SpeedGain = 1.15,
        MinSpeed = 2.6,
        MinSpeedApplyAbovePedSpeed = 1.32,
        MaxSpeed = 8.2,
    },
    ChargeMs = 1100,
    TapThresholdMs = 220,
    ControlTimeoutMs = 900,
    ControlRetries = 5,
    ControlRetryStepMs = 220,
    AllowKickWithoutControl = true,
    NoControlRequestMs = 40,
    VelocityHoldMs = 180,
    VelocityHoldIntervalMs = 20,
    KickSpawnOffset = 1.05,
    KickSpawnZBelowPed = 0.42,
    KickSpawnGroundClearance = 0.14,
    MaxSyntheticRollOmega = 28.0,

    Pass = {
        MinSpeed = 4.0,
        MaxSpeed = 9.0,
        MinLift = 0.25,
        MaxLift = 0.70,
        PickupLockMs = 420,
    },

    Shot = {
        PowerCurve = 1.35,
        MinSpeed = 8.0,
        MaxSpeed = 34.0,
        MinLift = 0.8,
        MaxLift = 4.2,
        PickupLockMs = 760,
        ShotTrailFx = {
            Enabled = true,
            Networked = false,
            BurstCount = 2,
            SpawnOnBall = true,
            Scale = 0.95,
            ScaleFromShot = { Min = 0.72, Max = 1.35 },
            SpawnChance = 0.42,
            MinCharge = 0.58,
            MinShotSpeed = 13.5,
            StopSpeed = 0.52,
            StopHorizontalSpeed = 0.4,
            StopSettledMs = 90,
            StopDisplacementMin = 0.07,
            StopDisplacementMs = 160,
            MinBallSpeed = 1.15,
        },
    },

    Cross = {
        MinSpeed = 12.5,
        MaxSpeed = 18.5,
        MinLift = 4.2,
        MaxLift = 6.4,
        PickupLockMs = 700,
        CooldownMs = 450,
    },
}

-- Ball steal and ownership
SoccerConfigDefaults.StealSystem = {
    ClaimDistance = 1.55,
    StealBallDistance = 1.28,
    StealDistance = 1.55,
    StealOwnerDistance = 1.55,
    StationaryOwnerSpeed = 0.25,
    StationaryOwnerDistance = 2.05,
    ClientStealCooldownMs = 0,
    ServerStealCooldownMs = 0,
    ServerHardStealCooldownMs = 8500,
    ServerHardAfterSoftGateMs = 1500,
    OwnerGraceMs = 700,
    ServerAbandonBallOwnerDistance = 5.25,
    FrontShield = {
        Enabled = true,
        MaxDistance = 1.65,
        DotThreshold = 0.12 -- +1 = front, 0 = side, -1 = behind
    },
    SoftSteal = {
        RequireSprint = true,
        HoldMs = 0,
        MaxDistance = 1.35,
        ContactGuardMs = 1500,
        PostStealGuardMs = 2500,
        InputLockMs = 650,
        SpamLockMs = 650,
        SeparationDistance = 1.15,
        CollisionGuardDistance = 5.0,
        BreakDistanceBuffer = 0.55,
        CancelOnSprintRelease = false,
        ShowHud = false,
    },
}

-- HUD toggle keys
SoccerConfigDefaults.UIKeys = {
    ToggleInfo = 74,   -- H
    ToggleInfoLabel = "H",
    ToggleScoreboardLabel = "O",
    CycleShotTrailLabel = "I",
}

-- Shot trail effects
SoccerConfigDefaults.ShotTrail = {
    DefaultPresetIndex = -1,
    SpawnChance = 0.42,
    MinCharge = 0.58,
    MinShotSpeed = 13.5,
    SyncRemoteShotTrailToLobby = true,
}

-- Shot trail presets (host cycles with I)
SoccerConfigDefaults.ShotTrailPresets = {
    {
        id = "fire",
        labelKey = "fire",
        Enabled = true,
        Networked = false,
        Asset = "scr_indep_fireworks",
        Effect = "scr_indep_firework_trail_spawn",
        DurationMs = 1320,
        IntervalMs = 22,
        OffsetBehind = 0.42,
        Scale = 0.98,
        BurstCount = 2,
        Spread = 0.16,
        ZBump = 0.14,
        SpawnOnBall = true,
        BallZBump = 0.2,
        MinBallSpeed = 1.15,
        MinShotSpeed = 7.0,
        StartDelayMs = 250,
        MinDistanceFromPed = 1.15,
        ScaleFromShot = { Min = 0.72, Max = 1.38 },
        DurationFromShot = { MinMs = 760, MaxMs = 1480 },
        StopSpeed = 0.42,
        StopHorizontalSpeed = 0.34,
        StopSettledMs = 75,
        StopSettledMsHard = 32,
        BallFire = { Enabled = false },
        Layers = {
            { Asset = "scr_indep_fireworks", Effect = "scr_indep_firework_trail_spawn", ScaleMul = 1.0, BurstCount = 2 },
            { Asset = "scr_indep_fireworks", Effect = "scr_indep_firework_starburst", ScaleMul = 0.88, EveryNth = 1 },
            { Asset = "scr_indep_fireworks", Effect = "scr_indep_firework_grd_burst", ScaleMul = 0.62, EveryNth = 2 },
        },
    },
    {
        id = "fireworks",
        labelKey = "fireworks",
        Enabled = true,
        Networked = false,
        Asset = "scr_indep_fireworks",
        Effect = "scr_indep_firework_trail_spawn",
        DurationMs = 1300,
        IntervalMs = 22,
        OffsetBehind = 0.42,
        Scale = 0.95,
        BurstCount = 2,
        Spread = 0.16,
        ZBump = 0.14,
        SpawnOnBall = true,
        BallZBump = 0.2,
        MinBallSpeed = 1.15,
        MinShotSpeed = 7.0,
        StartDelayMs = 240,
        MinDistanceFromPed = 1.15,
        ScaleFromShot = { Min = 0.72, Max = 1.35 },
        DurationFromShot = { MinMs = 750, MaxMs = 1500 },
        BallFire = { Enabled = false },
        Layers = {
            { Asset = "scr_indep_fireworks", Effect = "scr_indep_firework_trail_spawn", ScaleMul = 1.0, BurstCount = 2 },
            { Asset = "scr_indep_fireworks", Effect = "scr_indep_firework_starburst", ScaleMul = 0.85, EveryNth = 1 },
            { Asset = "core", Effect = "exp_grd_flare", ScaleMul = 0.55, EveryNth = 2 },
        },
    },
    {
        id = "smoke",
        labelKey = "smoke",
        Enabled = true,
        Networked = false,
        Asset = "core",
        Effect = "env_gunsmoke",
        DurationMs = 760,
        IntervalMs = 70,
        OffsetBehind = 0.34,
        Scale = 0.42,
        BurstCount = 1,
        Spread = 0.05,
        SpawnOnBall = false,
        MinBallSpeed = 2.2,
        MinShotSpeed = 12.0,
        StartDelayMs = 180,
        MinDistanceFromPed = 1.55,
        ScaleFromShot = { Min = 0.28, Max = 0.62 },
        DurationFromShot = { MinMs = 420, MaxMs = 900 },
        StopSpeed = 1.2,
        StopHorizontalSpeed = 1.0,
        StopSettledMs = 30,
        StopSettledMsHard = 12,
        BallFire = { Enabled = false },
        Layers = {
            { Asset = "core", Effect = "env_gunsmoke", ScaleMul = 1.0, BurstCount = 1, ZBump = 0.08 },
            { Asset = "core", Effect = "proj_grenade_smoke", ScaleMul = 0.34, BurstCount = 1, EveryNth = 3, ZBump = 0.05 },
        },
    },
    {
        id = "sparks",
        labelKey = "sparks",
        Enabled = true,
        Networked = false,
        Asset = "core",
        Effect = "ent_brk_sparking_wires",
        DurationMs = 1200,
        IntervalMs = 20,
        OffsetBehind = 0.4,
        Scale = 1.0,
        BurstCount = 2,
        Spread = 0.12,
        SpawnOnBall = true,
        MinBallSpeed = 1.15,
        MinShotSpeed = 7.0,
        StartDelayMs = 220,
        MinDistanceFromPed = 1.1,
        ScaleFromShot = { Min = 0.78, Max = 1.38 },
        DurationFromShot = { MinMs = 700, MaxMs = 1450 },
        BallFire = { Enabled = false },
        Layers = {
            { Asset = "core", Effect = "ent_brk_sparking_wires", ScaleMul = 1.05, BurstCount = 2 },
            { Asset = "core", Effect = "ent_dst_elec_crackle", ScaleMul = 0.75, EveryNth = 1 },
            { Asset = "core", Effect = "exp_grd_flare", ScaleMul = 0.4, EveryNth = 3 },
        },
    },
    {
        id = "steam",
        labelKey = "steam",
        Enabled = true,
        Networked = false,
        Asset = "core",
        Effect = "ent_sht_steam",
        DurationMs = 1250,
        IntervalMs = 23,
        OffsetBehind = 0.44,
        Scale = 1.05,
        BurstCount = 2,
        Spread = 0.15,
        SpawnOnBall = true,
        MinBallSpeed = 1.15,
        MinShotSpeed = 7.0,
        StartDelayMs = 220,
        MinDistanceFromPed = 1.1,
        ScaleFromShot = { Min = 0.8, Max = 1.4 },
        DurationFromShot = { MinMs = 720, MaxMs = 1400 },
        BallFire = { Enabled = false },
        Layers = {
            { Asset = "core", Effect = "ent_sht_steam", ScaleMul = 1.0, BurstCount = 2 },
            { Asset = "core", Effect = "exp_sht_steam", ScaleMul = 0.95, EveryNth = 1 },
            { Asset = "core", Effect = "ent_brk_steam_burst", ScaleMul = 0.8, EveryNth = 2 },
        },
    },
}

-- Kick animation trim
SoccerConfigDefaults.ShotAnimation = {
    StartAt = 0.45,
    EndAt = 0.90,
}

-- Target option on pitch NPC
SoccerConfigDefaults.TargetPed = {
    label    = "Menu de Futebol",
    icon     = "fas fa-futbol",
    distance = 2.0,
}

-- Map blips for pitches
SoccerConfigDefaults.MapBlips = {
    Enabled  = true,
    Sprite   = 58,
    Color    = 2,
    Scale    = 1.0,
    Label    = false,
    ShortRange = false,
}
