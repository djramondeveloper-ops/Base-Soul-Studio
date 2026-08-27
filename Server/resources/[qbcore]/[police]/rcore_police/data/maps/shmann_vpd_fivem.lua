-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["shmann_vpd_fivem"] = {
        Jobs = "LSPD",
        Pos = vec3(-1106.228516, -843.415406, 19.321656),
        MapLocation = "SANANDREASAVENUE_NONE",
        Blip = {
            scale = 1.0,
            display = 4,
            enable = true,
            name = "POLICE",
            sprite = 60,
            color = 29,
        },
        Zones = {
            {
                icon = "fa-solid fa-shirt",
                require_duty = false,
                type = ZONE_TYPE.CLOTHING_ROOM,
                coords = vec3(-1144.061524, -812.123046, 4.864502),
                no_job_zone = false,
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
            },
            {
                icon = "fa-solid fa-lock",
                require_duty = false,
                type = ZONE_TYPE.PERSONAL_LOCKER,
                coords = vec3(-1123.714234, -824.729676, 4.864502),
                no_job_zone = false,
                label = _U("ZONES_LABELS.PERSONAL_LOCKER"),
            },
            {
                icon = "fa-solid fa-clock",
                require_duty = false,
                type = ZONE_TYPE.WRITE_REPORT,
                coords = vec3(-1092.843994, -832.206604, 19.321656),
                no_job_zone = false,
                label = _U("ZONES_LABELS.WRITE_REPORT"),
            },
            {
                icon = "fa-solid fa-lock",
                require_duty = false,
                type = ZONE_TYPE.WEAPON_SHOP,
                coords = vec3(-1132.219726, -816.712098, 4.864502),
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
            },
            {
                icon = "fa-solid fa-lock",
                require_duty = false,
                type = ZONE_TYPE.EVIDENCE_STASH,
                coords = vec3(-1150.351684, -826.378052, 4.864502),
                no_job_zone = false,
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
            },
            {
                icon = "",
                require_duty = false,
                type = ZONE_TYPE.WEAPON_STORAGE,
                coords = vec3(-1136.782470, -819.613160, 4.864502),
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_STORAGE"),
            },
            {
                icon = "fa-solid fa-business-time",
                require_duty = false,
                type = ZONE_TYPE.BOSS_MENU,
                coords = vec3(-1108.694458, -836.505494, 34.267456),
                no_job_zone = false,
                label = _U("ZONES_LABELS.BOSS_MENU"),
            },
            {
                icon = "fa-solid fa-lock",
                require_duty = false,
                type = ZONE_TYPE.JOB_STASH,
                coords = vec3(-1104.936280, -837.560424, 34.267456),
                no_job_zone = false,
                label = _U("ZONES_LABELS.JOB_STASH"),
            },
            {
                icon = "fa-solid fa-clock",
                require_duty = false,
                type = ZONE_TYPE.DUTY,
                coords = vec3(-1092.329712, -828.606568, 19.321656),
                no_job_zone = false,
                label = _U("ZONES_LABELS.DUTY"),
            },
            {
                icon = "fa-solid fa-clock",
                require_duty = false,
                type = ZONE_TYPE.REPORTS,
                coords = vec3(-1088.940674, -834.369202, 19.321656),
                no_job_zone = false,
                label = _U("ZONES_LABELS.REPORTS"),
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(-1107.824218, -829.411010, 5.016114),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 221.102372
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-1109.670288, -825.336242, 4.460084),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1112.109864, -822.224182, 4.460084),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1114.628540, -818.980224, 4.476928),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1117.054932, -815.841736, 4.476928),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1119.389038, -812.835144, 4.460084),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1121.709838, -809.881348, 4.460084),
                        heading = 308.976380
                    },
                    {
                        coords = vec3(-1124.043946, -806.887940, 4.460084),
                        heading = 308.976380
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-1105.252686, -843.204406, 36.671020 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 308.976380
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-1095.098876, -834.843934, 37.569946),
                        heading = 127.559052
                    },
                }
            },
        },
        Resource = "shmann_vpd_fivem",
    }
end)
