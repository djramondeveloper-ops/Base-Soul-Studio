-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["kiiya_mrpd"] = {
        Pos = vec3(462.636260, -971.756530, 26.386358),
        Zones = {
            {
                coords = vec3(455.05,-996.60,30.71),
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
                type = ZONE_TYPE.WEAPON_SHOP,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-lock",
            },
            {
                coords = vec3(451.97,-987.76,30.71),
                label = _U("ZONES_LABELS.REPORTS"),
                type = ZONE_TYPE.REPORTS,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-clock",
            },
            {
                coords = vec3(452.09,-995.91,30.71),
                label = _U("ZONES_LABELS.WEAPON_STORAGE"),
                type = ZONE_TYPE.WEAPON_STORAGE,
                require_duty = false,
                no_job_zone = false,
                icon = "",
            },
            {
                coords = vec3(432.616730, -999.115112, 35.683670),
                label = _U("ZONES_LABELS.BOSS_MENU"),
                type = ZONE_TYPE.BOSS_MENU,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-business-time",
            },
            {
                coords = vec3(444.839356, -981.484008, 30.710692),
                label = _U("ZONES_LABELS.WRITE_REPORT"),
                type = ZONE_TYPE.WRITE_REPORT,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-clock",
            },
            {
                coords = vec3(465.37,-998.59,30.72),
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
                type = ZONE_TYPE.CLOTHING_ROOM,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-shirt",
            },
            {
                coords = vec3(445.949066, -992.432434, 30.710712),
                label = _U("ZONES_LABELS.DUTY"),
                type = ZONE_TYPE.DUTY,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-clock",
            },
            {
                coords = vec3(468.12,-1000.33,30.71),
                label = _U("ZONES_LABELS.PERSONAL_LOCKER"),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-lock",
            },
            {
                coords = vec3(468.445282, -977.060424, 35.683666),
                label = _U("ZONES_LABELS.JOB_STASH"),
                type = ZONE_TYPE.JOB_STASH,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-lock",
            },
            {
                coords = vec3(463.635314, -971.686280, 26.386358),
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
                type = ZONE_TYPE.EVIDENCE_STASH,
                require_duty = false,
                no_job_zone = false,
                icon = "fa-solid fa-lock",
            },
        },
        Blip = {
            enable = true,
            sprite = 60,
            display = 4,
            name = "POLICE",
            color = 29,
            scale = 1.0,
        },
        Resource = "kiiya_mrpd",
        MapLocation = MAP_TYPES.MRPD,
        Jobs = "LSPD",
    }
end)
