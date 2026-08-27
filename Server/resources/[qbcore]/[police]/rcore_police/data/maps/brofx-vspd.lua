-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps['BROFX_VSPD'] = {
        Jobs = 'LSPD',
        Resource = MAPS.BROFX_VSPD,
        MapLocation = MAP_TYPES.VSPD,
        Zones = {
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-1093.413940, -844.067627, 38.9),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 51.533946990967
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vector3(-1100.85, -836.71, 38.87),
                        heading = 37.18830871582
                    },
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(-1087.89, -839.69, 3.68),
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 304.57
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-1088.078125, -831.539124, 2.682415),
                        heading = 219.65873718262
                    },
                    {
                        coords = vec3(-1085.135864, -829.733643, 2.682415),
                        heading = 220.71632385254
                    },
                    {
                        coords = vec3(-1082.265259, -827.442444, 2.682415),
                        heading = 220.96112060547
                    },
                    {
                        coords = vec3(-1079.387451, -825.337646, 2.682415),
                        heading = 217.86663818359
                    },
                    {
                        coords = vec3(-1090.967896, -833.882324, 2.682415),
                        heading = 220.6011505127
                    }
                }
            },
        }
    }
end)
