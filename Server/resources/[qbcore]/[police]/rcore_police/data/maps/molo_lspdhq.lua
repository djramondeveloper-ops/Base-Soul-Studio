-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['MOLO_LSPDHQ'] = {
        Jobs = 'LSPD',
        Resource = MAPS.MOLO_LSPD_HQ,
        MapLocation = 'other',
        Blip = {
            name = 'LSPD_HQ',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 21
        },
        Pos = vec3(99.77, -397.76, 48.50),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(94.52, -423.44, 48.50),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(84.18, -418.58, 48.50),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(87.77, -414.55, 48.50),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(84.77, -356.99, 53.10),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(78.39, -385.20, 39.00),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 161.00
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(66.47, -391.50, 37.75),
                        heading = 252.28
                    },
                    {
                        coords = vec3(64.76, -396.19, 37.75),
                        heading = 252.28
                    },
                    {
                        coords = vec3(62.22, -400.39, 37.75),
                        heading = 252.28
                    },
                    {
                        coords = vec3(84.42, -395.32, 37.75),
                        heading = 68.03
                    },
                    {
                        coords = vec3(82.58, -399.73, 37.75),
                        heading = 68.03
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(77.47, -428.10, 84.32 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 345.82
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(82.18, -415.62, 85.22),
                        heading = 155.90
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(82.95, -363.82, 41.32),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(56.98, -377.78, 40.82),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(89.74, -422.55, 48.50),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(81.91, -366.67, 41.32),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vec3(79.33, -363.00, 41.32),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_STORAGE'),
                coords = vec3(76.93, -366.34, 41.32),
                type = ZONE_TYPE.WEAPON_STORAGE,
                icon= 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
