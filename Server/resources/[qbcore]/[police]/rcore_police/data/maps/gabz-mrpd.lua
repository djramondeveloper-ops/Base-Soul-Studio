-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['GABZ_MRPD'] = {
        Jobs = {'LSPD'},
        Resource = MAPS.GABZ_MRPD,
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
                coords = vector3(441.810730, -981.91, 30.83),
                type = ZONE_TYPE.DUTY,
                icon= 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vector3(461.37, -985.72, 31.9),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vector3(458.3, -999.7, 30.69),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon= 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(459.57, -986.57, 25.7),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 87.62
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(445.637665, -991.673889, 24.699978),
                        heading = 273.93334960938
                    },
                    {
                        coords = vec3(445.704193, -988.823364, 24.699978),
                        heading = 270.07043457031
                    },
                    {
                        coords = vec3(445.649933, -986.436035, 24.699978),
                        heading = 273.19186401367
                    },
                    {
                        heading = 269.81777954102,
                        coords = vec3(445.619476, -994.263794, 24.699978)
                    },
                    {
                        heading = 270.00573730469,
                        coords = vec3(445.569580, -996.954163, 24.699978)
                    },
                    {
                        heading = 93.676918029785,
                        coords = vec3(437.559540, -996.898499, 24.699978)
                    },
                    {
                        heading = 91.782669067383,
                        coords = vec3(437.302460, -994.138611, 24.699978)
                    },
                    {
                        heading = 90.66951751709,
                        coords = vec3(437.266998, -988.896179, 24.699978)
                    },
                    {
                        heading = 89.773406982422,
                        coords = vec3(437.427246, -986.247803, 24.699978)
                    },
                    {
                        heading = 273.29165649414,
                        coords = vec3(425.351654, -976.298035, 24.699978)
                    },
                    {
                        heading = 271.65374755859,
                        coords = vec3(425.642426, -978.959167, 24.699978)
                    },
                    {
                        heading = 270.09985351562,
                        coords = vec3(425.951721, -981.437378, 24.699978)
                    },
                    {
                        heading = 271.12057495117,
                        coords = vec3(425.416779, -984.347107, 24.699978)
                    },
                    {
                        heading = 270.63031005859,
                        coords = vec3(425.158051, -989.051392, 24.699978)
                    },
                    {
                        heading = 271.14364624023,
                        coords = vec3(425.494904, -991.761414, 24.699978)
                    },
                    {
                        heading = 270.48348999023,
                        coords = vec3(425.776581, -994.372131, 24.699978)
                    },
                    {
                        heading = 271.0071105957,
                        coords = vec3(425.558319, -997.205505, 24.699978)
                    },
                    {
                        coords = vec3(437.512543, -991.577393, 24.699978),
                        heading = 91.280967712402
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(463.67, -982.16, 43.69),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 88.45
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vector3(450.42, -981.1, 43.69),
                        heading = 88.59
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(461.901062, -995.572327, 31.046848),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon= 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(461.986450, -1000.010193, 31.042160),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon= 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(450.174408, -998.032532, 30.906961),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon= 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vector3(487.24, -996.94, 30.69),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon= 'fa-solid fa-lock',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_STORAGE'),
                coords = vec3(482.868622, -994.623047, 30.739695),
                type = ZONE_TYPE.WEAPON_STORAGE,
                icon= 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
