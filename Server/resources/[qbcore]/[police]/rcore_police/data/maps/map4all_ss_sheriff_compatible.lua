-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["map4all_ss_sheriff_compatible"] = {
        Pos = vec3(1848.735840, 3676.059326, 38.929981),
        Zones = {
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(1852.62, 3694.67, 34.33),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 277.9602
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(1866.19, 3693.4, 33.74),
                        heading = 120.38
                    },
                    {
                        coords = vec3(1864.09, 3696.73, 33.74),
                        heading = 120.38
                    },
                    {
                        coords = vec3(1861.93, 3700.14, 33.74),
                        heading = 120.38
                    },
                    {
                        coords = vec3(1860.28, 3702.74, 33.75),
                        heading = 120.38
                    },
                }
            },
            {
                no_job_zone = false,
                coords = vec3(1840.995850, 3686.655518, 34.326145),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.EVIDENCE_STASH,
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
            },
            {
                no_job_zone = false,
                coords = vec3(1848.371704, 3681.473145, 34.326153),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.WEAPON_SHOP,
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
            },
            {
                no_job_zone = false,
                coords = vec3(1829.079956, 3681.435303, 34.326145),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.WRITE_REPORT,
                label = _U("ZONES_LABELS.WRITE_REPORT"),
            },
            {
                no_job_zone = false,
                coords = vec3(1853.998657, 3683.854004, 34.326157),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.REPORTS,
                label = _U("ZONES_LABELS.REPORTS"),
            },
            {
                no_job_zone = false,
                coords = vec3(1850.988159, 3677.415771, 38.929981),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.JOB_STASH,
                label = _U("ZONES_LABELS.JOB_STASH"),
            },
            {
                no_job_zone = false,
                coords = vec3(1846.010254, 3691.378662, 34.326149),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.DUTY,
                label = _U("ZONES_LABELS.DUTY"),
            },
            {
                no_job_zone = false,
                coords = vec3(1836.918579, 3677.250244, 34.347118),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.PERSONAL_LOCKER,
                label = _U("ZONES_LABELS.PERSONAL_LOCKER"),
            },
            {
                no_job_zone = false,
                coords = vec3(1833.392944, 3672.431885, 34.326145),
                require_duty = false,
                icon = "fa-solid fa-shirt",
                type = ZONE_TYPE.CLOTHING_ROOM,
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
            },
            {
                no_job_zone = false,
                coords = vec3(1845.439087, 3688.619141, 38.931282),
                require_duty = false,
                icon = "",
                type = ZONE_TYPE.WEAPON_STORAGE,
                label = _U("ZONES_LABELS.WEAPON_STORAGE"),
            },
            {
                no_job_zone = false,
                coords = vec3(1842.438477, 3678.861328, 34.326145),
                require_duty = false,
                icon = "fa-solid fa-business-time",
                type = ZONE_TYPE.BOSS_MENU,
                label = _U("ZONES_LABELS.BOSS_MENU"),
            },
        },
        Jobs = {"PRPD", 'LSPD'},
        Blip = {
            name = "SHERIFF",
            enable = true,
            display = 4,
            color = 29,
            sprite = 60,
            scale = 1.0,
        },
        MapLocation = "ALHAMBRADR_NONE",
        Resource = "map4all_ss_sheriff_compatible",
    }
end)
