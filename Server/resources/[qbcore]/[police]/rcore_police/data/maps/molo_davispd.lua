-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['MOLO_DAVISPD'] = {
        Jobs = {'LSPD', "PRPD"},
        Resource = MAPS.MOLO_DAVIS,
        MapLocation = MAP_TYPES.VANILLA_UNICORN,
        Blip = {
            name = 'DAVISPD',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 29
        },
        Pos = vec3(244.9, -1372.16, 33.42),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(240.64, -1348.77, 33.4),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(260.38, -1379.45, 34.25),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(248.78, -1370.06, 33.42),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(269.43, -1386.53, 34.25),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(211.07, -1384.28, 30.58),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 272.14
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(210.83, -1400.19, 30.58),
                        heading = 331.49
                    },
                    {
                        coords = vec3(207.98, -1398.11, 30.58),
                        heading = 331.4
                    },
                    {
                        coords = vec3(204.39, -1395.95, 30.58),
                        heading = 331.4
                    },
                    {
                        coords = vec3(201.53, -1394.01, 30.58),
                        heading = 331.4
                    },
                    {
                        coords = vec3(198.45, -1392.55, 30.58),
                        heading = 331.4
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(241.16, -1406.11, 30.59 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 40.02
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(249.44, -1402.19, 30.57),
                        heading = 304.38
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(265.17, -1381.93, 34.25),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(243.32, -1347.99, 33.41),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(269.25, -1361.53, 34.21),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(243.2, -1339.72, 33.4),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(230.89, -1349.75, 33.4),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vec3(263.52, -1390.48, 34.25),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
