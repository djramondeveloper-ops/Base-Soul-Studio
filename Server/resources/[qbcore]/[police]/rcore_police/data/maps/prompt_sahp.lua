-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["prompt_sahp"] = {
        Zones = {
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.EVIDENCE_STASH,
                coords = vec3(843.88940429688, -1274.4193115234, 21.246704101562),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.REPORTS"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.REPORTS,
                coords = vector3(836.51226806641, -1296.1643066406, 26.896450042725),
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
                coords = vec3(852.89501953125, -1293.6202392578, 26.721168518066),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.WEAPON_SHOP,
                coords = vector3(837.42510986328, -1276.2736816406, 21.246696472168),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.BOSS_MENU"),
                require_duty = false,
                icon = "fa-solid fa-business-time",
                type = ZONE_TYPE.BOSS_MENU,
                coords = vec3(843.16876220703, -1301.6925048828, 31.765483856201),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
                require_duty = false,
                icon = "fa-solid fa-shirt",
                type = ZONE_TYPE.CLOTHING_ROOM,
                coords = vec3(852.13549804688, -1289.0703125, 26.721197128296),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.WRITE_REPORT"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.WRITE_REPORT,
                coords = vec3(835.59362792969, -1293.1955566406, 26.721313476562),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.DUTY"),
                require_duty = false,
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.DUTY,
                coords = vec3(838.76177978516, -1283.0242919922, 21.246715545654),
            },
            {
                no_job_zone = false,
                label = _U("ZONES_LABELS.JOB_STASH"),
                require_duty = false,
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.JOB_STASH,
                coords = vec3(831.23956298828, -1296.9204101562, 26.721166610718),
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(839.9619140625, -1290.8651123047, 20.985725402832),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 28.346456
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(851.37762451172, -1303.166015625, 20.989652633667),
                        heading = 85.3
                    },
                    {
                        coords = vec3(851.03076171875, -1299.5028076172, 20.98991394043),
                        heading = 85.3
                    },
                    {
                        coords = vec3(850.69293212891, -1295.6041259766, 20.98975944519),
                        heading = 85.3
                    },
                    {
                        coords = vec3(850.99896240234, -1291.4987792969, 20.989435195923),
                        heading = 85.3
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
                        coords = vector3(838.59167480469, -1290.8845214844, 41.900569915771),
                        heading = 92.8
                    },
                }
            },
        },
        Pos = vec3(838.59167480469, -1290.8845214844, 41.900569915771),
        Jobs = "LSPD",
        MapLocation = "MOUNTAINVIEWDRIVE_ALHAMBRADRIVE",
        Blip = {
            sprite = 60,
            scale = 1.0,
            name = "SAHP",
            display = 4,
            color = 29,
            enable = true,
        },
        Resource = "prompt_sandy_sheriff",
    }
end)
