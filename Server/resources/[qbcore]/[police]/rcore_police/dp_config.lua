-- ============================================================
-- SEOUL BASE - CONFIGURACAO UNICA DA DELEGACIA
-- ============================================================
-- EDITE SOMENTE ESTE ARQUIVO para mover blip, pontos de interacao,
-- garagem e spawn de viaturas da sua DP.
--
-- O MLO kiiya_mrpd pode continuar iniciado normalmente.
-- Este arquivo NAO depende do nome do MLO para carregar.
-- ============================================================

Maps['SEOUL_DP'] = {
    -- Grupo/job que pode usar esta delegacia.
    Jobs = {
        'LSPD',
        'PRPD',
        'PMRJ',
        'PCRJ',
        'PFRJ',
        'EXERCITORJ',
        'BOMBEIRORJ',
        'PMESP',
        'PCSP',
        'PFSP',
        'EXERCITOSP',
        'BOMBEIROSP'
    },

    -- Sempre carrega esta configuracao. O MLO visual e independente.
    Resource = MAPS.STANDALONE,
    MapLocation = MAP_TYPES.MRPD,

    -- POSICAO DO BLIP DA DELEGACIA
    Pos = vec3(462.636260, -971.756530, 26.386358),

    Blip = {
        name = 'POLICIA',
        enable = true,
        sprite = 60,
        display = 4,
        scale = 1.0,
        color = 29,
        shortRange = false,
    },

    Zones = {
        -- BATER PONTO / DUTY
        {
            label = _U('ZONES_LABELS.DUTY'),
            coords = vec3(445.949066, -992.432434, 30.710712),
            type = ZONE_TYPE.DUTY,
            icon = 'fa-solid fa-clock',
            require_duty = false,
        },

        -- ARSENAL / LOJA DE ARMAS
        {
            label = _U('ZONES_LABELS.WEAPON_SHOP'),
            coords = vec3(455.05, -996.60, 30.71),
            type = ZONE_TYPE.WEAPON_SHOP,
            icon = 'fa-solid fa-lock',
            require_duty = false,
        },

        -- DEPOSITO DE ARMAS
        {
            label = _U('ZONES_LABELS.WEAPON_STORAGE'),
            coords = vec3(452.09, -995.91, 30.71),
            type = ZONE_TYPE.WEAPON_STORAGE,
            icon = 'fa-solid fa-lock',
            require_duty = false,
        },

        -- RELATORIOS
        {
            label = _U('ZONES_LABELS.REPORTS'),
            coords = vec3(451.97, -987.76, 30.71),
            type = ZONE_TYPE.REPORTS,
            icon = 'fa-solid fa-clock',
            require_duty = false,
        },

        -- ESCREVER RELATORIO
        {
            label = _U('ZONES_LABELS.WRITE_REPORT'),
            coords = vec3(444.839356, -981.484008, 30.710692),
            type = ZONE_TYPE.WRITE_REPORT,
            icon = 'fa-solid fa-clock',
            require_duty = false,
        },

        -- MENU DO CHEFE
        {
            label = _U('ZONES_LABELS.BOSS_MENU'),
            coords = vec3(432.616730, -999.115112, 35.683670),
            type = ZONE_TYPE.BOSS_MENU,
            icon = 'fa-solid fa-business-time',
            require_duty = false,
        },

        -- FARDAMENTO / ROUPAS
        {
            label = _U('ZONES_LABELS.OUTFIT_ROOM'),
            coords = vec3(465.37, -998.59, 30.72),
            type = ZONE_TYPE.CLOTHING_ROOM,
            icon = 'fa-solid fa-shirt',
            require_duty = false,
        },

        -- ARMARIO PESSOAL
        {
            label = _U('ZONES_LABELS.PERSONAL_LOCKER'),
            coords = vec3(468.12, -1000.33, 30.71),
            type = ZONE_TYPE.PERSONAL_LOCKER,
            icon = 'fa-solid fa-lock',
            require_duty = false,
        },

        -- BAU DA POLICIA
        {
            label = _U('ZONES_LABELS.JOB_STASH'),
            coords = vec3(468.445282, -977.060424, 35.683666),
            type = ZONE_TYPE.JOB_STASH,
            icon = 'fa-solid fa-lock',
            require_duty = false,
        },

        -- EVIDENCIAS
        {
            label = _U('ZONES_LABELS.EVIDENCE_STASH'),
            coords = vec3(463.635314, -971.686280, 26.386358),
            type = ZONE_TYPE.EVIDENCE_STASH,
            icon = 'fa-solid fa-lock',
            require_duty = false,
        },

        -- GARAGEM DE VIATURAS
        -- "coords" = onde aperta E para abrir a garagem.
        -- "points" = onde as viaturas aparecem.
        {
            label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
            coords = vec3(459.006, -1017.08, 28.15),
            type = ZONE_TYPE.GARAGE_VEHICLE,
            icon = 'fas fa-car',
            require_duty = true,
            npc = {
                model = 's_m_m_ciasec_01',
                heading = 87.87,
            },
            points = {
                { coords = vec3(442.751617, -1026.881470, 27.712978), heading = 4.1657543182373 },
                { coords = vec3(438.867065, -1027.309937, 27.784710), heading = 10.444779396057 },
                { coords = vec3(435.290436, -1027.881470, 27.849098), heading = 9.7324199676514 },
            },
        },

        -- GARAGEM AEREA / HELICOPTERO
        {
            label = _U('ZONES_LABELS.GARAGE_VEHICLE'),
            coords = vec3(463.220093, -982.255188, 43.691944),
            type = ZONE_TYPE.GARAGE_AIR,
            icon = 'fa-solid fa-helicopter',
            require_duty = true,
            npc = {
                model = 's_m_m_ciasec_01',
                heading = 92.43,
            },
            points = {
                { coords = vec3(449.246460, -981.269531, 42.691658), heading = 90.037353515625 },
            },
        },
    }
}
