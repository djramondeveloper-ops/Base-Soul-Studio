-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["prompt_sandy_sheriff"] = {
        Zones = {
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.EVIDENCE_STASH,
                coords = vec3(1824.843994, 3676.180176, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.REPORTS"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.REPORTS,
                coords = vec3(1825.252686, 3671.010986, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_STORAGE"),
                require_duty = false,
                icon = "",
                type = ZONE_TYPE.WEAPON_STORAGE,
                coords = vec3(1825.833008, 3684.145020, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.PERSONAL_LOCKER"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.PERSONAL_LOCKER,
                coords = vec3(1816.681274, 3666.514404, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.WEAPON_SHOP,
                coords = vec3(1822.509888, 3679.028564, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.BOSS_MENU"),
                require_duty = false,
                icon = "fa-solid fa-business-time",
                type = ZONE_TYPE.BOSS_MENU,
                coords = vec3(1820.188964, 3662.531982, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
                require_duty = false,
                icon = "fa-solid fa-shirt",
                type = ZONE_TYPE.CLOTHING_ROOM,
                coords = vec3(1826.492310, 3679.595704, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.WRITE_REPORT"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.WRITE_REPORT,
                coords = vec3(1827.072510, 3670.285644, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.DUTY"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.DUTY,
                coords = vec3(1816.549438, 3669.876954, 34.402222),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.JOB_STASH"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.JOB_STASH,
                coords = vec3(1818.118652, 3661.938476, 34.402222),
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(1839.626342, 3685.859375, 33.997802),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 28.346456
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(1841.868164, 3691.410888, 33.408082),
                        heading = 76.535438
                    },
                    {
                        coords = vec3(1845.705444, 3693.454834, 33.256470),
                        heading = 76.535438
                    },
                    {
                        coords = vec3(1849.318726, 3695.499024, 33.155274),
                        heading = 76.535438
                    },
                    {
                        coords = vec3(1852.747314, 3697.529786, 33.155274),
                        heading = 76.535438
                    },
                    {
                        coords = vec3(1856.175782, 3699.731934, 33.138428),
                        heading = 76.535438
                    },
                    {
                        coords = vec3(1859.459350, 3701.907714, 33.138428),
                        heading = 76.535438
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(1833.098876, 3672.435058, 41.658570 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 31.181102
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(1818.461548, 3673.094482, 42.557496),
                        heading = 300.472442
                    },
                }
            },
        },
        Pos = vec3(1829.353882, 3666.224122, 34.402222),
        Jobs = "PRPD",
        MapLocation = "MOUNTAINVIEWDRIVE_ALHAMBRADRIVE",
        Blip = {
            sprite = 60,
            scale = 1.0,
            name = "SHERIFF",
            display = 4,
            color = 29,
            enable = true,
        },
        Resource = "prompt_sandy_sheriff",
    }
end)
