-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



NONE_RESOURCE = 'standalone'
STANDALONE = 'standalone'
AUTO_DETECT = 'auto_detect'
INVENTORY = 'Inventory'
SOCIETY = "Society"
CLOTHING = "Clothing"
PRE_CUFF_STYLES = {
    CLASSIC = "CLASSIC",
    ALTERNATIVE = "ALTERNATIVE"
}
SHOW_MODE = {
    ID = 'ID',
    OOC_ID = 'OOC_ID',
}
TRACK_TYPE = {
    PED = 1,
    VEHICLE = 2,
}
TRACK_TYPE_READABLE = {
    [TRACK_TYPE.PED] = "PED",
    [TRACK_TYPE.VEHICLE] = "VEHICLE"
}
InteractionsTarget = {
    OX = "ox_target",
    QB = "qb-target",
    NONE = NONE_RESOURCE
}
THIRD_PARTY_RESOURCE = {
    QB_SMALL_RESOURCES = 'qb-smallresources',
    QBX_SMALL_RESOURCES = 'qbx_smallresources',
    QF_MDT = 'qf-mdt',
    PMA_VOICE = 'pma-voice',
    QB_PHONE = 'qb-phone'
}
PoliceResources = {
    P = 'p_policejob',
    WASABI = 'wasabi_police',
    ESX = 'esx_policejob',
    QB = 'qb-policejob',
    QBOX = 'qbx_police',
    ND = 'ND_Police'
}
dbg = rdebug()
Levels = {
    INFO = '^2[asset-deployer:info]^7',
    WARN = '^3[asset-deployer:warn]^7',
    ERROR = '^1[asset-deployer:error]^7',
    LOAD = '^3[asset-deployer:load]^7',
    DEBUG = '^3[debug]^7',
}
ZONE_ACTIONS = {
    DESTROY_VEHICLE_TYRES = "DESTROY_VEHICLE_TYRES",
    BLOCK_VEHICLES_IN_FRONT = "BLOCK_VEHICLES_IN_FRONT",
    BLOCK_VEHICLE_MOVEMENT = "BLOCK_VEHICLE_MOVEMENT",
    CHECK_VEHICLE_SPEED = "CHECK_VEHICLE_SPEED"
}
ZONE_TYPE = {
    WRITE_REPORT = "WRITE_REPORT",
    MUGSHOT = "MUGSHOT",
    REPORTS = "REPORTS",
    WEAPON_SHOP = 'WEAPON_SHOP',
    WEAPON_STORAGE = 'WEAPON_STORAGE',
    CLOTHING_ROOM = 'CLOTHING_ROOM',
    EVIDENCE_STASH = 'EVIDENCE_STASH',
    JOB_STASH = 'JOB_STASH',
    PERSONAL_LOCKER = 'PERSONAL_LOCKER',
    GARAGE_VEHICLE = 'GARAGE_VEHICLE',
    GARAGE_AIR = 'GARAGE_AIR',
    VEHICLE_SPAWNPOINT = 'VEHICLE_SPAWNPOINT',
    BOSS_MENU = 'BOSS_MENU',
    DUTY = 'DUTY'
}
MENU_ID_LIST = {
    SELECT_PLAYERS = 'SELECT_PLAYERS',
    LICENSES = 'LICENSES',
    PLAYER_INVENTORY = 'PLAYER_INVENTORY',
    SHOW_VEHICLE_INFO = 'SHOW_VEHICLE_INFO',
    WEAPON_SHOP = 'WEAPON_SHOP',
    JOB_OUTFITS = 'JOB_OUTFITS',
    JOB_GARAGE = 'JOB_GARAGE',
    MAIN_MENU = 'MAIN_MENU',
}
INVENTORY_STATUS_CODES = {
    EMPTY_INVENTORY = 'EMPTY_INVENTORY',
    HAS_ITEMS = 'HAS_ITEMS'
}
ERROR_STATES = {
    PLAYER_ALREADY_IN_GROUP = 'PLAYER_ALREADY_IN_GROUP',
    NO_STORAGE_FOUND = 'NO_STORAGE_FOUND',
    NO_PLAYER_ID = 'NO_PLAYER_ID',
    PLAYER_WITH_THIS_ID_IS_OFFLINE = 'PLAYER_WITH_THIS_ID_IS_OFFLINE',
    PLAYER_ADDED_TO_GROUP = 'PLAYER_ADDED_TO_GROUP',
    PLAYER_ID_IS_NOT_A_NUMBER = 'PLAYER_ID_IS_NOT_A_NUMBER',
    PLAYER_IDENTIFIER_NOT_FOUND = 'PLAYER_IDENTIFIER_NOT_FOUND',
    PLAYER_JOB_GROUP_NOT_FOUND = 'PLAYER_JOB_GROUP_NOT_FOUND',	
}
EMULATED = {
    NO_NEARBY = 'NO_NEARBY',
    NEARBY = 'NEARBY',
}
STORAGE_GARAGE = 'STORAGE_GARAGE'
STORAGE_GROUPS = 'STORAGE_GROUPS'
STORAGE_INTERACTIONS = 'STORAGE_INTERACTIONS'
Shake = {
    DEATH_FAIL = "DEATH_FAIL_IN_EFFECT_SHAKE",
    DRUNK = "DRUNK_SHAKE",
    DRUG_TRIP = "FAMILY5_DRUG_TRIP_SHAKE",
    HAND_SHAKE = "HAND_SHAKE",
    JOLT = "JOLT_SHAKE",
    LARGE_EXPLOSION = "LARGE_EXPLOSION_SHAKE",
    MEDIUM_EXPLOSION = "MEDIUM_EXPLOSION_SHAKE",
    SMALL_EXPLOSION = "SMALL_EXPLOSION_SHAKE",
    ROAD_VIBRATION = "ROAD_VIBRATION_SHAKE",
    SKY_DIVING = "SKY_DIVING_SHAKE",
    VIBRATE = "VIBRATE_SHAKE",
}
EntityAttach = {
    CUFFS = {
        FRONT = {
            offset = vector3(-0.000000, -0.000000, 0.078000),
            rot = vector3(17.460012, -102.060150, 4.320000),
        },
        BACK = {
            offset = vector3(-0.055, 0.06, 0.04),
            rot = vector3(265.0, 155.0, 80.0),
        }
    },
}
CameraAnimFX = {
    BEAST_INTRO_SCENE = 'BeastIntroScene',
    BEAST_LAUNCH = 'BeastLaunch',
    BEAST_TRANSITION = 'BeastTransition',
    BIKER_FILTER = 'BikerFilter',
    BIKER_FILTER_OUT = 'BikerFilterOut',
    BIKER_FORMATION = 'BikerFormation',
    BIKER_FORMATION_OUT = 'BikerFormationOut',
    CAM_PUSH_IN_FRANKLIN = 'CamPushInFranklin',
    CAM_PUSH_IN_MICHAEL = 'CamPushInMichael',
    CAM_PUSH_IN_NEUTRAL = 'CamPushInNeutral',
    CAM_PUSH_IN_TREVOR = 'CamPushInTrevor',
    CHOP_VISION = 'ChopVision',
    CROSS_LINE = 'CrossLine',
    CROSS_LINE_OUT = 'CrossLineOut',
    DEADLINE_NEON = 'DeadlineNeon',
    DEATH_FAIL_FRANKLIN_IN = 'DeathFailFranklinIn',
    DEATH_FAIL_MICHAEL_IN = 'DeathFailMichaelIn',
    DEATH_FAIL_DARK = 'DeathFailMPDark',
    DEATH_FAIL_IN = 'DeathFailMPIn',
    DEATH_FAIL_NEUTRAL_IN = 'DeathFailNeutralIn',
    DEATH_FAIL_OUT = 'DeathFailOut',
    DEATH_FAIL_TREVOR_IN = 'DeathFailTrevorIn',
    DEFAULT_FLASH = 'DefaultFlash',
    DMT_FLIGHT = 'DMT_flight',
    FLIGHT_INTRO = 'DMT_flight_intro',
    DONT_TAZEME_BRO = 'Dont_tazeme_bro',
    DRUGS_DRIVING_IN = 'DrugsDrivingIn',
    DRUGS_DRIVING_OUT = 'DrugsDrivingOut',
    DRUGS_MICHAEL_ALIENS_FIGHT = 'DrugsMichaelAliensFight',
    DRUGS_MICHAEL_ALIENS_FIGHT_IN = 'DrugsMichaelAliensFightIn',
    DRUGS_MICHAEL_ALIENS_FIGHT_OUT = 'DrugsMichaelAliensFightOut',
    DRUGS_TREVOR_CLOWNS_FIGHT = 'DrugsTrevorClownsFight',
    DRUGS_TREVOR_CLOWNS_FIGHT_IN = 'DrugsTrevorClownsFightIn',
    DRUGS_TREVOR_CLOWNS_FIGHT_OUT = 'DrugsTrevorClownsFightOut',
    EXPLOSION_JOSH = 'ExplosionJosh3',
    FOCUS_IN = 'FocusIn',
    FOCUS_OUT = 'FocusOut',
    HEIST_CELEB_END = 'HeistCelebEnd',
    HEIST_CELEB_PASS = 'HeistCelebPass',
    HEIST_CELEB_TOAST = 'HeistCelebToast',
    HEIST_LOCATE = 'HeistLocate',
    HEIST_TRIP_SKIP_FADE = 'HeistTripSkipFade',
    INCH_ORANGE = 'InchOrange',
    INCH_ORANGE_OUT = 'InchOrangeOut',
    INCH_PICKUP = 'InchPickup',
    INCH_PICKUP_OUT = 'InchPickupOut',
    INCH_PURPLE = 'InchPurple',
    INCH_PURPLE_OUT = 'InchPurpleOut',
    LOST_TIME_DAY = 'LostTimeDay',
    LOST_TIME_NIGHT = 'LostTimeNight',
    MENU_HEIST_IN = 'MenuMGHeistIn',
    MENU_HEIST_INTRO = 'MenuMGHeistIntro',
    MENU_HEIST_OUT = 'MenuMGHeistOut',
    MENU_HEIST_TINT = 'MenuMGHeistTint',
    MENU_IN = 'MenuMGIn',
    MENU_SELECTION_IN = 'MenuMGSelectionIn',
    MENU_SELECTION_TINT = 'MenuMGSelectionTint',
    MENU_TOURNAMENT_IN = 'MenuMGTournamentIn',
    MENU_TOURNAMENT_TINT = 'MenuMGTournamentTint',
    MINIGAME_END_FRANKLIN = 'MinigameEndFranklin',
    MINIGAME_END_MICHAEL = 'MinigameEndMichael',
    MINIGAME_END_NEUTRAL = 'MinigameEndNeutral',
    MINIGAME_END_TREVOR = 'MinigameEndTrevor',
    MINIGAME_TRANSITION_IN = 'MinigameTransitionIn',
    MINIGAME_TRANSITION_OUT = 'MinigameTransitionOut',
    BULL_TOST = 'MP_Bull_tost',
    BULL_TOST_OUT = 'MP_Bull_tost_Out',
    CELEB_LOSE = 'MP_Celeb_Lose',
    CELEB_LOSE_OUT = 'MP_Celeb_Lose_Out',
    CELEB_PRELOAD = 'MP_Celeb_Preload',
    CELEB_PRELOAD_FADE = 'MP_Celeb_Preload_Fade',
    CELEB_WIN = 'MP_Celeb_Win',
    CELEB_WIN_OUT = 'MP_Celeb_Win_Out',
    CORONA_SWITCH = 'MP_corona_switch',
    INTRO_LOGO = 'MP_intro_logo',
    JOB_LOAD = 'MP_job_load',
    KILLSTREAK = 'MP_Killstreak',
    KILLSTREAK_OUT = 'MP_Killstreak_Out',
    LOSER_STREAK_OUT = 'MP_Loser_Streak_Out',
    ORBITAL_CANNON = 'MP_OrbitalCannon',
    POWERPLAY = 'MP_Powerplay',
    POWERPLAY_OUT = 'MP_Powerplay_Out',
    RACE_CRASH = 'MP_race_crash',
    SMUGGLER_CHECKPOINT = 'MP_SmugglerCheckpoint',
    TRANSFORM_RACE_FLASH = 'MP_TransformRaceFlash',
    WARP_CHECKPOINT = 'MP_WarpCheckpoint',
    PAUSE_MENU_OUT = 'PauseMenuOut',
    PENNED_IN = 'pennedIn',
    PENNED_IN_OUT = 'PennedInOut',
    PEYOTE_END_IN = 'PeyoteEndIn',
    PEYOTE_END_OUT = 'PeyoteEndOut',
    PEYOTE_IN = 'PeyoteIn',
    PEYOTE_OUT = 'PeyoteOut',
    FILTER = 'PPFilter',
    FILTER_OUT = 'PPFilterOut',
    GREEN = 'PPGreen',
    GREEN_OUT = 'PPGreenOut',
    ORANGE = 'PPOrange',
    ORANGE_OUT = 'PPOrangeOut',
    PINK = 'PPPink',
    PINK_OUT = 'PPPinkOut',
    PURPLE = 'PPPurple',
    PURPLE_OUT = 'PPPurpleOut',
    RACE_TURBO = 'RaceTurbo',
    RAMPAGE = 'Rampage',
    RAMPAGE_OUT = 'RampageOut',
    SNIPER_OVERLAY = 'SniperOverlay',
    SUCCESS_FRANKLIN = 'SuccessFranklin',
    SUCCESS_MICHAEL = 'SuccessMichael',
    SUCCESS_NEUTRAL = 'SuccessNeutral',
    SUCCESS_TREVOR = 'SuccessTrevor',
    SWITCH_CAM = 'switch_cam_1',
    SWITCH_CAM = 'switch_cam_2',
    SWITCH_FRANKLIN_IN = 'SwitchHUDFranklinIn',
    SWITCH_FRANKLIN_OUT = 'SwitchHUDFranklinOut',
    SWITCH_IN = 'SwitchHUDIn',
    SWITCH_MICHAEL_IN = 'SwitchHUDMichaelIn',
    SWITCH_MICHAEL_OUT = 'SwitchHUDMichaelOut',
    SWITCH_OUT = 'SwitchHUDOut',
    SWITCH_TREVOR_IN = 'SwitchHUDTrevorIn',
    SWITCH_TREVOR_OUT = 'SwitchHUDTrevorOut',
    SWITCH_OPEN_FRANKLIN = 'SwitchOpenFranklin',
    SWITCH_OPEN_FRANKLIN_IN = 'SwitchOpenFranklinIn',
    SWITCH_OPEN_FRANKLIN_OUT = 'SwitchOpenFranklinOut',
    SWITCH_OPEN_MICHAEL_IN = 'SwitchOpenMichaelIn',
    SWITCH_OPEN_MICHAEL_MID = 'SwitchOpenMichaelMid',
    SWITCH_OPEN_MICHAEL_OUT = 'SwitchOpenMichaelOut',
    SWITCH_OPEN_NEUTRAL = 'SwitchOpenNeutralFIB5',
    SWITCH_OPEN_NEUTRAL_OUT_HEIST = 'SwitchOpenNeutralOutHeist',
    SWITCH_OPEN_TREVOR_IN = 'SwitchOpenTrevorIn',
    SWITCH_OPEN_TREVOR_OUT = 'SwitchOpenTrevorOut',
    SWITCH_SCENE_FRANKLIN = 'SwitchSceneFranklin',
    SWITCH_SCENE_MICHAEL = 'SwitchSceneMichael',
    SWITCH_SCENE_NEUTRAL = 'SwitchSceneNeutral',
    SWITCH_SCENE_TREVOR = 'SwitchSceneTrevor',
    SWITCH_SHORT_FRANKLIN_IN = 'SwitchShortFranklinIn',
    SWITCH_SHORT_FRANKLIN_MID = 'SwitchShortFranklinMid',
    SWITCH_SHORT_MICHAEL_IN = 'SwitchShortMichaelIn',
    SWITCH_SHORT_MICHAEL_MID = 'SwitchShortMichaelMid',
    SWITCH_SHORT_NEUTRAL_IN = 'SwitchShortNeutralIn',
    SWITCH_SHORT_NEUTRAL_MID = 'SwitchShortNeutralMid',
    SWITCH_SHORT_TREVOR_IN = 'SwitchShortTrevorIn',
    SWITCH_SHORT_TREVOR_MID = 'SwitchShortTrevorMid',
    TINY_RACER_GREEN = 'TinyRacerGreen',
    TINY_RACER_GREEN_OUT = 'TinyRacerGreenOut',
    TINY_RACER_INTRO_CAM = 'TinyRacerIntroCam',
    TINY_RACER_PINK = 'TinyRacerPink',
    TINY_RACER_PINK_OUT = 'TinyRacerPinkOut',
    WEAPON_UPGRADE = 'WeaponUpgrade',
}
PERMISSIONS_JOBS = {
    ACCESS_BOSS_MENU = 'ACCESS_BOSS_MENU',
    ACCESS_GARAGE_VEHICLE = 'ACCESS_GARAGE_VEHICLE',
    ACCESS_GARAGE_HELI = 'ACCESS_GARAGE_HELI',
}
MAPS = {
    PROMPT_SANDY_SHERIFF = 'prompt_sandy_sheriff',
    MOLO_BCPD = 'molo_bcpd',
    MOLO_DAVIS = 'molo_davispd',
    ROCKFORD_HILLS_NTEAM = 'cfx-nteam-police',
    IBONOJA_FULL = 'ibonoja_mrpd',
    IBONOJA_EDITABLE = 'ibonoja_mrpd_full_editable',
    STANDALONE = 'STANDALONE',
    MOLO_LSPD_HQ = 'molo_lspdhq',
    MOLO_MRPDV2 = 'molo_mrpdv2',
    MOLO_MRPD = 'molo_mrpd',
    GABZ_MRPD = 'cfx-gabz-mrpd',
    BROFX_VSPD = 'brofx_vspd',
    FRANCO_MRPD = 'cfx-fm-mrpd',
}
MAP_TYPES = {
    ROCKFORD_HILLS = 'ROCKFORD_HILLS',
    VANILLA_UNICORN = 'VANILLA_UNICORN',
    MRPD = 'MRPD',
    SANDY = 'SANDY',
    PALETO_BAY = 'PALETO_BAY',
    VSPD = 'VSPD',
}
PAYMENT_METHODS = {
    COMPANY = 'COMPANY',
    BANK = 'BANK',
}
BANK_TRANSACTION_TYPES = {
    ADD = 'ADD',
    REMOVE = 'REMOVE'
}
ZONES_ACCESS = {
    NO_PART_ZONE_JOB = 'NO_PART_ZONE_JOB',
    NO_DUTY = 'NO_DUTY',
    PLAYER_NEED_TO_BE_ON_DUTY = 'PLAYER_NEED_TO_BE_ON_DUTY',
}
OUTFITS = {
    SET_OUTFIT = 'SET_OUTFIT',
    RESTORE_OUTFIT = 'RESTORE_OUTFIT'
}
CLOTHING_COMPONENTS = {
    HEAD = 0,
    MASKS = 1,
    HAIR_STYLES = 2,
    BODY = 3,  -- BODY // TORSO
    PANTS = 4,
    BAGS_AND_PARACHUTE = 5,
    SHOES = 6,
    ACCESSORIES = 7,
    SHIRT = 8,
    BODY_ARMOR = 9,
    DECALS = 10,
    ARMS = 11
}
PROP_COMPONENTS = {
    HATS = 0,
    GLASSES = 1,
    EARS = 2,
    WATCHES = 6,
    BRACELETS = 7,
    ACCESSORY = 7,
}
DRAWABLE = {
    NONE = -1,
}
PROP_TYPES = {
    WHEEL_CLAMP = "WHEEL_CLAMP",
    PAPER_BAG = 'PAPER_BAG',
    SPEED_RADAR = "SPEED_RADAR",
    SPIKES = 'SPIKES',
    BARRICADE = 'BARRICADE',
    MEGA_PHONE = 'MEGA_PHONE'
}
MENU_ACTIONS = {
    HIRE_PLAYER = 'HIRE_PLAYER',
    TAKE_INVENTORY_ITEM = 'TAKE_INVENTORY_ITEM',
    SHOW_VEHICLE_INFORMATION = 'SHOW_VEHICLE_INFORMATION',
    IN_VEHICLE = "IN_VEHICLE",
    FROM_VEHICLE = "FROM_VEHICLE",
    EMERGENCY = "EMERGENCY",
    SHOW_MDT = "SHOW_MDT",
    SHOW_PLAYER_LICENSES = 'SHOW_PLAYER_LICENSES',
    SEARCH_PLAYER = 'SEARCH_PLAYER',
    SENT_TO_JAIL = 'SENT_TO_JAIL',
    CUFF_SOFT = 'CUFF_SOFT',
    ESCORT_CITIZEN = 'ESCORT_CITIZEN',
    INVOCE_CITIZEN = 'INVOICE_CITIZEN',
    REQUEST_SPAWN_MODEL = 'REQUEST_SPAWN_MODEL',
    UNLOCK_VEHICLE = 'UNLOCK_VEHICLE',
    IMPOUND_VEHICLE = 'IMPOUND_VEHICLE',
    SENT_TO_COMS = 'SENT_TO_COMS',
    SENT_FINE = 'SENT_FINE',
}
ACTION_TYPES = {
    VEHICLE = "VEHICLE",
    CITIZEN = 'CITIZEN',
}
RADIAL_MENU = {
    SENT_TYPE_EVENT = "EVENT",
    SENT_TYPE_COMMAND = "COMMAND",
    SENT_TYPE_EXPORT = "EXPORT",
    SENT_SIDE_CLIENT = "CLIENT",
    SENT_SIDE_SERVER = "SERVER",
}
MOVEMENT_FLAG = {
    MOVE_ALL_BODY = 49,
    MOVE_ALL = 49,
}
BOSS_MENU_ACTIONS = {
    FIRE_CITIZEN = 'FIRE_CITIZEN',
    SET_BONUS = 'SET_BONUS',
    UPDATE_GRADE = 'UPDATE_GRADE',
    DEPOSIT_SOCIETY_MONEY = 'DEPOSIT_SOCIETY_MONEY',
    WIDTHRAW_SOCIETY_MONEY = 'WIDTHRAW_SOCIETY_MONEY',
}
NUI_EVENTS = {
    IMAGE_PATH = 'IMAGE_PATH',
    VIEW_PHOTO = "VIEW_PHOTO",
    SENT_UI_TRANSLATIONS = 'SENT_UI_TRANSLATIONS',
    BOSS_MENU_ORDER_VEHICLE = 'BOSS_MENU_ORDER_VEHICLE',
    BOSS_MENU_UPDATE_DATA = 'BOSS_MENU_UPDATE_DATA',
    BOSS_MENU_REQUEST_ACTION = 'BOSS_MENU_REQUEST_ACTION',
    OPEN_JOB_BOSS_MENU = 'OPEN_JOB_BOSS_MENU',
    OPEN_JOB_GARAGE = "OPEN_JOB_GARAGE",
    OPEN_DEPARTMENT_STORE = "OPEN_DEPARTMENT_STORE",
    GET_VEHICLE_FROM_DEPARTMENT_GARAGE = "GET_VEHICLE_FROM_DEPARTMENT_GARAGE",
    GET_ITEM_FROM_DEPARTMENT_STORE = "GET_ITEM_FROM_DEPARTMENT_STORE",
    HANDLE_MOVE_RADAR = "HANDLE_MOVE_RADAR",
    HANDLE_FOCUS = "HANDLE_FOCUS",
    SET_FAST_LIMIT_RADAR = "SET_FAST_LIMIT_RADAR",
    RESET_RADAR = "RESET_RADAR",
    SHOW_RADAR = "SHOW_RADAR",
    UPDATE_RADAR = 'UPDATE_RADAR',
    POLICE_RADAR = 'POLICE_RADAR',
    SAVE_REPORT = 'SAVE_REPORT',
    SEND_NOTIFICATION = 'SEND_NOTIFICATION',
    REPORTS_REFRESH = "REPORTS_REFRESH",
    DELETE_REPORT = "DELETE_REPORT",
    REPORTS = "REPORTS",
    SENT_RADIAL_MENU = 'SENT_RADIAL_MENU',
    HOVER_CONTEXT = 'HOVER_CONTEXT',
    STOP_HOVER_CONTEXT = 'STOP_HOVER_CONTEXT',
    SUBMIT_CONTEXT = 'SUBMIT_CONTEXT',
    CONTEXT_MENU = 'CONTEXT_MENU',
    BODYCAMS = 'BODYCAMS',
    PAY_DIALOG = 'PAY_DIALOG',
    SENT_PAYDIALOG = 'SENT_PAYDIALOG',
    SET_VISIBLE = 'setVisible',
    LOADED = 'LOADED',
    FORM_DIALOG = 'FORM_DIALOG',
    HELPKEYS = 'HELPKEYS',
    CLOSE_APP = 'CLOSE_APP',
    GET_INPUT_DATA = 'GET_INPUT_DATA',
    ADD_NOTE = "ADD_NOTE",
    UPDATE_STATUS = "UPDATE_STATUS",
    START_MINIGAME = "lockpick:start",
    STOP_MINIGAME = "lockpick:end",
    MINIGAME_RESULT = "lockpick/result",
    MINIGAME_SOUND = "lockpick/sound",
}
REPORT_STATES = {
    NEW_REPORT = 'NEW_REPORT',
    IN_REVIEW = 'IN_REVIEW',
}
SHOP_STATE = {
    ACCESS_BY_ANY_MEMBERS = 'ACCESS_BY_ANY_MEMBERS',
    ORDER_BY_BOSS = 'ORDER_BY_BOSS',
}
STORAGE_MODE = {
    FREE = 'FREE',
}
HANDS_UP = {
    DICT = "missminuteman_1ig_2",
    NAME = "handsup_base",
}
KNEE = {
    DICT = "missheist_jewel",
    NAME = "manageress_kneel_loop",
}
SEAT_INDEXES = {
    DRIVER_SEAT = -1
}
AUTO_DUTY_STATES = {
    ['PLAYER_ALREADY_IN_GROUP'] = true,
    ['PLAYER_ADDED_TO_GROUP'] = true
}
JOB = 'job'
