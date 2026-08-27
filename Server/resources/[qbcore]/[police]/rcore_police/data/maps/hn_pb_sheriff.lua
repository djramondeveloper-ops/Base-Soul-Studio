-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    Maps["hn_pb_sheriff"] = {
        Pos = vec3(-438.619843, 5991.720215, 30.967855),
        MapLocation = "PALETOBLVD_NONE",
        Blip = {
            scale = 1.0,
            sprite = 60,
            display = 4,
            name = "Paleto Sheriff",
            enable = true,
            color = 29,
        },
        Jobs = {'PRPD'},
        Zones = {
            {
                require_duty = false,
                coords = vec3(-427.936615, 6000.041016, 35.133865),
                no_job_zone = false,
                label = _U("ZONES_LABELS.PERSONAL_LOCKER"),
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.PERSONAL_LOCKER,
            },
            {
                require_duty = false,
                coords = vec3(-440.060791, 6012.327148, 30.967855),
                no_job_zone = false,
                label = _U("ZONES_LABELS.REPORTS"),
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.REPORTS,
            },
            {
                require_duty = false,
                coords = vec3(-424.66, 5997.68, 30.97),
                no_job_zone = false,
                label = _U("ZONES_LABELS.OUTFIT_ROOM"),
                npc = {
                    model = 's_m_y_sheriff_01',
                    heading = 42.63
                },
                icon = "fa-solid fa-shirt",
                type = ZONE_TYPE.CLOTHING_ROOM,
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vector3(-448.31, 6041.51, 31.24),
                npc = {
                    model = 's_m_y_sheriff_01',
                    heading = 256.52
                },
                icon = 'fas fa-car',
                type = ZONE_TYPE.GARAGE_VEHICLE,
                require_duty = false,
                points = {
                    {
                        coords = vector3(-441.77, 6027.06, 31.34),
                        heading = 313.25
                    },
                    {
                        coords = vector3(-439.4, 6029.92, 31.34),
                        heading = 308.86
                    },
                    {
                        coords = vector3(-435.48, 6031.72, 31.34),
                        heading = 312.46
                    }
                }
            },
            {
                label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
                coords = vec3(-497.63, 6015.44, 30.99),
                icon = 'fa-solid fa-helicopter',
                npc = {
                    model = 's_m_m_ciasec_01',
                    heading = 92.43
                },
                type = ZONE_TYPE.GARAGE_AIR,
                require_duty = true,
                points = {
                    {
                        coords = vec3(-495.20, 6001.96, 32.75),
                        heading = 146.66
                    },
                }
            },
            {
                require_duty = false,
                coords = vec3(-462.27, 6017.88, 36.31),
                no_job_zone = false,
                label = _U("ZONES_LABELS.BOSS_MENU"),
                icon = "fa-solid fa-business-time",
                type = ZONE_TYPE.BOSS_MENU,
            },
            {
                require_duty = false,
                coords = vec3(-449.596405, 6028.826660, 30.967852),
                no_job_zone = false,
                label = _U("ZONES_LABELS.DUTY"),
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.DUTY,
            },
            {
                require_duty = false,
                coords = vec3(-437.05, 5996.41, 30.97),
                no_job_zone = false,
                npc = {
                    model = 's_f_y_sheriff_01',
                    heading = 48.80
                },
                label = _U("ZONES_LABELS.WEAPON_SHOP"),
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.WEAPON_SHOP,
            },
            {
                require_duty = false,
                coords = vec3(-439.567291, 5990.781250, 30.967855),
                no_job_zone = false,
                label = _U("ZONES_LABELS.JOB_STASH"),
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.JOB_STASH,
            },
            {
                require_duty = false,
                coords = vec3(-438.99, 6016.64, 30.97),
                no_job_zone = false,
                label = _U("ZONES_LABELS.WRITE_REPORT"),
                npc = {
                    model = 's_f_y_sheriff_01',
                    heading = 48.97
                },
                icon = "fa-solid fa-clock",
                type = ZONE_TYPE.WRITE_REPORT,
            },
            {
                require_duty = false,
                coords = vec3(-431.389496, 5991.035645, 30.967859),
                no_job_zone = false,
                label = _U("ZONES_LABELS.WEAPON_STORAGE"),
                icon = "",
                type = ZONE_TYPE.WEAPON_STORAGE,
            },
            {
                require_duty = false,
                coords = vec3(-440.949158, 5991.426270, 35.131813),
                no_job_zone = false,
                label = _U("ZONES_LABELS.EVIDENCE_STASH"),
                icon = "fa-solid fa-lock",
                type = ZONE_TYPE.EVIDENCE_STASH,
            },
        },
        Resource = "hn_pb_sheriff",
    }
end)
