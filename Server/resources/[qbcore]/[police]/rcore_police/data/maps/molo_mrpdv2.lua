-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['MOLO_MRPDV2'] = {
        Jobs = 'LSPD',
        Resource = MAPS.MOLO_MRPDV2,
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
                coords = vec3(446.62, -983.88, 31.78),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(462.3, -980.42, 30.17),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(442.81, -982.26, 31.78),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(467.66, -975.59, 35.89),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(461.66, -968.73, 23.95),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 81.05
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(458.03, -985.79, 22.95),
                        heading = 1.34
                    },
                    {
                        coords = vec3(450.55, -985.61, 22.95),
                        heading = 2.67
                    },
                    {
                        coords = vec3(458.42, -953.2, 22.95),
                        heading = 176.41
                    },
                    {
                        coords = vec3(449.83, -953.09, 22.95),
                        heading = 177.66
                    },
                    {
                        coords = vec3(439.93, -952.75, 22.95),
                        heading = 179.11
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
                        coords = vec3(442.16, -986.32, 43.69),
                        heading = 99.64
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(451.89, -997.53, 31.7),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(455.72, -986.56, 30.17),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(463.75, -993.76, 27.63),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(460.22, -998.87, 31.74),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(454.57, -996.99, 31.72),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vec3(463.34, -996.03, 31.74),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
