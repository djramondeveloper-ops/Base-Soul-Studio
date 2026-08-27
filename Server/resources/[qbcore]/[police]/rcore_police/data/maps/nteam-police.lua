-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['NTEAM_ROCKFORD_HILLS'] = {
        Jobs = 'LSPD',
        Resource = MAPS.ROCKFORD_HILLS_NTEAM,
        MapLocation = MAP_TYPES.ROCKFORD_HILLS,
        Blip = {
            name = 'Police',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 29
        },
        Pos = vec3(-578.6779, -423.1903, 35.1719),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(-590.2037, -423.2840, 35.1719),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(-585.9910, -420.5436, 35.1719),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(-584.0392, -421.1972, 35.1724),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(-568.9434, -418.7224, 39.6326),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(-589.5326, -415.7101, 31.1601),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 273.5256
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-599.9782, -415.4047, 30.1601),
                        heading = 270.7570
                    },
                    {
                        coords = vec3(-600.3498, -411.8388, 30.1601),
                        heading = 266.3332
                    },
                    {
                        coords = vec3(-599.9762, -408.2675, 30.1601),
                        heading = 262.8116
                    },
                    {
                        coords = vec3(-599.9255, -404.7593, 30.1601),
                        heading = 271.1283
                    },
                    {
                        coords = vec3(-600.1702, -401.0921, 30.1601),
                        heading = 271.1548
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-598.4066, -425.1616, 50.3841 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 205.3767
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-596.0435, -431.5703, 51.3841),
                        heading = 181.9074
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(-603.3762, -416.6220, 35.1720),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(-589.3936, -414.5031, 35.1719),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(-605.8413, -418.4496, 35.1720),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(-602.7180, -420.9364, 35.1720),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vector3(-599.4716, -413.0707, 35.1719),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
