-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['MOLO_BCPD'] = {
        Jobs = 'LSPD',
        Resource = MAPS.MOLO_BCPD,
        MapLocation = MAP_TYPES.PALETO_BAY,
        Blip = {
            name = 'BCPD',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 29
        },
        Pos = vec3(-442.78, 6015.47, 32.48),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(-438.33, 6012.83, 32.48),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(-434.64, 6005.21, 32.48),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(-443.9, 6015.18, 32.48),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(-438.35, 6000.64, 32.48),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-458.36, 6011.57, 31.49),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 10.68
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-483.48, 6025.41, 31.34),
                        heading = 222.84
                    },
                    {
                        coords = vec3(-480.28, 6028.36, 31.34),
                        heading = 222.84
                    },
                    {
                        coords = vec3(-476.44, 6031.84, 31.34),
                        heading = 222.84
                    },
                    {
                        coords = vec3(-472.65, 6035.31, 31.34),
                        heading = 222.84
                    },
                    {
                        coords = vec3(-468.96, 6038.78, 31.34),
                        heading = 222.84
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-458.22, 5998.42, 31.34 + 1),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 139.54
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-474.13, 5989.61, 31.34),
                        heading = 42.36
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(-443.54, 6004.25, 32.48),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(-447.39, 5998.65, 32.48),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(-448.33, 6010.51, 36.64),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(-443.25, 6000.23, 32.48),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(-446.48, 5995.34, 32.48),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vec3(-444.83, 6001.29, 32.48),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
