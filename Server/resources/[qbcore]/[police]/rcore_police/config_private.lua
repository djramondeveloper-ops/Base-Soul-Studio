-- =====================================================
--  rcore_police · config_private.lua
--  Engineered by Eazy Fxap
--  Original: 319 lines → Cleaned: 130 lines
-- =====================================================

-- ============================================================
--  DEV FLAGS
-- ============================================================

CreateThread(function()
    IsInDev = false
    IsInDevTwoClients = false
end)

-- ============================================================
--  EMULATED EVENTS (for compatibility with other police scripts)
-- ============================================================

Config.Private = {}

Config.Private.EMULATED_EVENTS = {
    ["qb-policejob"] = {
        CuffPlayerSoft        = { action = "CuffPlayerSoft",          type = "NEARBY"    },
        CuffPlayer            = { action = "CuffPlayer",              type = "NEARBY"    },
        PutPlayerInVehicle    = { action = "PutPlayerInVehicle",      type = "NEARBY"    },
        SetPlayerOutVehicle   = { action = "SetPlayerOutVehicle",     type = "NEARBY"    },
        SendPoliceEmergencyAlert = { action = "SendPoliceEmergencyAlert", type = "NO_NEARBY" },
        SeizeDriverLicense    = { action = "SeizeDriverLicense",      type = "NEARBY"    },
        KidnapPlayer          = { action = "KidnapPlayer",            type = "NEARBY"    },
        CheckStatus           = { action = "CheckStatus",             type = "NEARBY"    },
        EscortPlayer          = { action = "EscortPlayer",            type = "NEARBY"    },
        SearchPlayer          = { action = "SearchPlayer",            type = "NEARBY"    },
        JailPlayer            = { action = "JailPlayer",              type = "NEARBY"    },
        spawnCone             = { action = "spawnCone",   isProp = true, type = "NO_NEARBY" },
        spawnBarrier          = { action = "spawnBarrier", isProp = true, type = "NO_NEARBY" },
        spawnRoadSign         = { action = "spawnRoadSign", isProp = true, type = "NO_NEARBY" },
        spawnTent             = { action = "spawnTent",   isProp = true, type = "NO_NEARBY" },
        spawnLight            = { action = "spawnLight",  isProp = true, type = "NO_NEARBY" },
        SpawnSpikeStrip       = { action = "SpawnSpikeStrip", isProp = true, type = "NO_NEARBY" },
        deleteObject          = { action = "deleteObject",             type = "NO_NEARBY" },
    },
}

-- ============================================================
--  FALLBACK WEAPONS (per rank)
-- ============================================================

Config.Private.FallbackWeapons = {
    recruit = {
        List = {
            { label = "Pistola AP",  weapon = "WEAPON_APPISTOL",   cost = 100 },
            { label = "Cassetete",   weapon = "WEAPON_NIGHTSTICK",  cost = 0   },
            { label = "Taser",       weapon = "WEAPON_STUNGUN",     cost = 100 },
            { label = "Lanterna",    weapon = "WEAPON_FLASHLIGHT",  cost = 80  },
        },
    },
    officer = {
        List = {
            { label = "Pistola AP",  weapon = "WEAPON_APPISTOL",   cost = 100 },
            { label = "Cassetete",   weapon = "WEAPON_NIGHTSTICK",  cost = 0   },
            { label = "Taser",       weapon = "WEAPON_STUNGUN",     cost = 100 },
            { label = "Lanterna",    weapon = "WEAPON_FLASHLIGHT",  cost = 80  },
        },
    },
    sergeant = {
        List = {
            { label = "Pistola AP",  weapon = "WEAPON_APPISTOL",   cost = 100 },
            { label = "Cassetete",   weapon = "WEAPON_NIGHTSTICK",  cost = 0   },
            { label = "Taser",       weapon = "WEAPON_STUNGUN",     cost = 100 },
            { label = "Lanterna",    weapon = "WEAPON_FLASHLIGHT",  cost = 80  },
        },
    },
    lieutenant = {
        List = {
            { label = "Pistola AP",  weapon = "WEAPON_APPISTOL",   cost = 100 },
            { label = "Cassetete",   weapon = "WEAPON_NIGHTSTICK",  cost = 0   },
            { label = "Taser",       weapon = "WEAPON_STUNGUN",     cost = 100 },
            { label = "Lanterna",    weapon = "WEAPON_FLASHLIGHT",  cost = 80  },
        },
    },
    boss = {
        List = {
            { label = "Pistola AP",   weapon = "WEAPON_APPISTOL",    cost = 100 },
            { label = "Cassetete",    weapon = "WEAPON_NIGHTSTICK",   cost = 0   },
            { label = "Taser",        weapon = "WEAPON_STUNGUN",      cost = 100 },
            { label = "Lanterna",     weapon = "WEAPON_FLASHLIGHT",   cost = 80  },
            { label = "Carabina",     weapon = "WEAPON_CARBINERIFLE", cost = 80  },
        },
    },
}

-- ============================================================
--  FALLBACK OUTFITS (per rank)
-- ============================================================

Config.Private.FallbackOutfits = {
    recruit = {
        short_sleeve = { label = "Manga curta", outfit = Outfits.short_sleeve },
        long_sleeve  = { label = "Manga longa", outfit = Outfits.long_sleeve  },
    },
    officer = {
        short_sleeve = { label = "Manga curta", outfit = Outfits.short_sleeve },
        long_sleeve  = { label = "Manga longa", outfit = Outfits.long_sleeve  },
    },
    sergeant = {
        short_sleeve = { label = "Manga curta", outfit = Outfits.short_sleeve },
        long_sleeve  = { label = "Manga longa", outfit = Outfits.long_sleeve  },
    },
    lieutenant = {
        short_sleeve = { label = "Manga curta", outfit = Outfits.short_sleeve },
        long_sleeve  = { label = "Manga longa", outfit = Outfits.long_sleeve  },
        swat         = { label = "SWAT",         outfit = Outfits.swat         },
    },
    boss = {
        short_sleeve = { label = "Manga curta", outfit = Outfits.short_sleeve },
        long_sleeve  = { label = "Manga longa", outfit = Outfits.long_sleeve  },
        swat         = { label = "SWAT",         outfit = Outfits.swat         },
    },
}
