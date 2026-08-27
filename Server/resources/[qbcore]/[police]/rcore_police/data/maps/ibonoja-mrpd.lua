-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['ibonoja_mrpd_full_editable'] = {
        Jobs = 'LSPD',
        Resource = MAPS.IBONOJA_EDITABLE,
        MapLocation = MAP_TYPES.MRPD,
        Blip = {
            name    = 'MRPD',
            enable  = true,
            sprite  = 60,
            display = 4,
            scale   = 1.0,
            color   = 29
        },
        Pos = vec3(431.9733, -990.6953, 43.6908),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(447.0533, -978.9218, 30.6893),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(442.2609, -983.3594, 30.6893),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(439.8971, -982.0018, 30.6893),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(452.1762, -999.1946, 35.0892),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(401.5237, -975.3519, 23.3257),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 277.9602
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(404.4033, -980.8141, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.4004, -983.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.2353, -986.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.2353, -989.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.2353, -992.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.2353, -995.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(404.2353, -998.7090, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(420.9434, -981.5212, 22.1000),
                        heading = 89.8987
                    },
                    {
                        coords = vec3(420.9434, -984.5212, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(420.9434, -987.3212, 22.1000),
                        heading = 268.8654
                    },
                    {
                        coords = vec3(420.9434, -990.3212, 22.1000),
                        heading = 268.8654
                    },
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
                coords = vec3(462.1186, -1004.8707, 30.6893),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(473.8155, -1001.3298, 30.6893),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(475.4857, -998.5790, 26.2074),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(450.0127, -982.3279, 30.6893),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(467.8412, -1003.5329, 30.6893),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vector3(480.8682, -1006.4828, 30.6893),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
