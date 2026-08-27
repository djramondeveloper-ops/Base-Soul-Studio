-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['DEFAULT_MRPD'] = {
        Jobs = {'LSPD'},
        Resource = MAPS.STANDALONE,
        MapLocation = MAP_TYPES.MRPD,
        Blip = {
            name = 'MRPD',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 29
        },
        Pos = vec3(441.371, -981.135, 30.689),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(440.168, -977.170, 30.689),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(442.122, -975.133, 30.689),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(440.932, -981.134, 30.689),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vector3(450.09, -973.25, 30.69),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(459.006, -1017.08, 28.15),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 87.87
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(442.751617, -1026.881470, 27.712978),
                        heading = 4.1657543182373
                    },
                    {
                        coords = vec3(438.867065, -1027.309937, 27.784710),
                        heading = 10.444779396057
                    },
                    {
                        coords = vec3(435.290436, -1027.881470, 27.849098),
                        heading = 9.7324199676514
                    },
                    {
                        coords = vec3(431.244995, -1027.757935, 27.920460),
                        heading = 5.1252827644348
                    },
                    {
                        coords = vec3(427.489471, -1028.421143, 27.987534),
                        heading = 10.377487182617
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(463.220093, -982.255188, 42.691944 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 92.43
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(449.246460, -981.269531, 42.691658),
                        heading = 90.037353515625
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(454.839478, -985.134216, 31.003664),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(452.145, -973.22, 30.68),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(459.802, -989.471, 24.914),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(458.085, -985.047, 30.689),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(458.07, -992.97, 30.67),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vector3(452.4, -983.88, 30.69),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
                npc = {
                    model = 's_m_y_cop_01',
                    heading = 42.5
                },
            },
        }
    }
end)
