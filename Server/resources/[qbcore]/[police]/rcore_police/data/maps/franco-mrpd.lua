-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['FRANCO_MRPD'] = {
        Jobs = 'LSPD',
        Resource = MAPS.FRANCO_MRPD,
        MapLocation = MAP_TYPES.MRPD,
        Blip = {
            name = 'MRPD',
            enable = true,
            sprite  = 60,
			display = 4,
			scale   = 1.0,
			color   = 29
        },
        Pos = vec3(438.17715454102, -990.36309814453, 30.707313537598),
        Zones = {
            {
                label = _U('ZONES_LABELS.DUTY'),
                coords = vec3(447.27398681641, -991.47729492188, 30.707878112793),
                type = ZONE_TYPE.DUTY,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.REPORTS'),
                coords = vec3(447.26544189453, -988.98779296875, 30.707874298096),
                type = ZONE_TYPE.REPORTS,
                icon = 'fa-solid fa-clock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WRITE_REPORT'),
                coords = vec3(443.76306152344, -987.76971435547, 30.707302093506),
                type = ZONE_TYPE.WRITE_REPORT,
                icon = 'fa-solid fa-clock',
                require_duty = false,
                no_job_zone = true,
            },
            {
                label = _U('ZONES_LABELS.BOSS_MENU'),
                coords = vec3(447.13565063477, -989.70355224609, 34.241790771484),
                type = ZONE_TYPE.BOSS_MENU,
                icon = 'fa-solid fa-business-time',
                require_duty = true,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(440.30206298828, -1008.75390625, 24.452463150024),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 258.3512878418
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(453.212, -1001.763, 23.842),
                        heading = 180.0
                    },
                    {
                        coords = vec3(450.352, -1001.763, 23.842),
                        heading = 180.0
                    },
                    {
                        coords = vec3(447.278, -1001.763, 23.842),
                        heading = 180.0
                    },
                    {
                        coords = vec3(444.274, -1001.763, 23.842),
                        heading = 180.0
                    },
                    {
                        coords = vec3(441.247, -1001.763, 23.842),
                        heading = 180.0
                    },
                    {
                        coords = vec3(441.166, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(444.206, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(447.215, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(450.223, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(453.275, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(456.326, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(459.400, -1020.012, 23.842),
                        heading = 0.0
                    },
                    {
                        coords = vec3(462.544, -1020.012, 23.845),
                        heading = 0.0
                    },
                    {
                        coords = vec3(465.658, -1020.012, 23.845),
                        heading = 0.0
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(461.12097167969, -1006.8237915039, 41.319080352783),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 178.46305847168
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(450.62493896484, -1014.751953125, 42.84200668335),
                        heading = 89.102127075195
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
                coords = vec3(464.60147094727, -1008.8666381836, 30.707313537598),
                type = ZONE_TYPE.PERSONAL_LOCKER,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.EVIDENCE_STASH'),
                coords = vec3(449.75402832031, -1009.9407958984, 30.707311630249),
                type = ZONE_TYPE.EVIDENCE_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.JOB_STASH'),
                coords = vec3(452.49810791016, -1012.8920288086, 30.707311630249),
                type = ZONE_TYPE.JOB_STASH,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.OUTFIT_ROOM'),
                coords = vec3(467.26068115234, -1010.1314697266, 30.707294464111),
                type = ZONE_TYPE.CLOTHING_ROOM,
                icon = 'fa-solid fa-shirt',
                require_duty = false,
            },
            {
                label = _U('ZONES_LABELS.WEAPON_SHOP'),
                coords = vector3(449.37069702148, -1005.5228881836, 30.707311630249),
                type = ZONE_TYPE.WEAPON_SHOP,
                icon = 'fa-solid fa-lock',
                require_duty = false,
            },
        }
    }
end)
