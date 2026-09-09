-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL MULTIFRAMEWORK V2 - CONFIG
-- Camada complementar. Nao substitui nem altera os arquivos compat/ existentes.
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulMultiframework = SeoulMultiframework or {}
SeoulMultiframework.QBCore = SeoulMultiframework.QBCore or {}

local QB = SeoulMultiframework.QBCore

QB.Enabled = true

-- Classificacao explicita baseada nos grupos nativos atuais de config/Global.lua.
-- A camada nao tenta adivinhar se um grupo e job ou gang pelo nome/Type.
QB.Jobs = QB.Jobs or {
    "LSPD",
    "PRPD",
    "PMRJ",
    "PCRJ",
    "PFRJ",
    "EXERCITORJ",
    "BOMBEIRORJ",
    "PMESP",
    "PCSP",
    "PFSP",
    "EXERCITOSP",
    "BOMBEIROSP",
    "Paramedic",
    "Mechanic",
    "BurgerShot"
}

QB.Gangs = QB.Gangs or {
    "Families",
    "Ballas",
    "Vagos",
    "MarabuntaGrande",
    "VarriosLosAztecas",
    "LostMC",
    "ArmenianMob",
    "Kkangpae",
    "WeiChengTriad",
    "MadrazoCartel",
    "ONeilBrothers",
    "Favela1",
    "Favela2",
    "Favela3",
    "Favela4",
    "Favela5",
    "Favela6",
    "Favela7",
    "Bahamas",
    "Cassino",
    "Vanilla"
}

QB.JobLookup = QB.JobLookup or {}
QB.GangLookup = QB.GangLookup or {}

for _, name in ipairs(QB.Jobs) do
    QB.JobLookup[name] = true
end

for _, name in ipairs(QB.Gangs) do
    QB.GangLookup[name] = true
end

-- QBCore usa grade 0 como cargo inicial e o maior grade como chefe.
-- A Seoul usa hierarchy[1] como cargo mais alto. Esta opcao faz a conversao nos dois sentidos.
QB.UseQBCoreGradeOrder = true

-- Mantem campos Seoul adicionais no PlayerData para diagnostico/compatibilidade sem remover campos QBCore.
QB.ExposeSeoulFields = true

-- Mapeamento explicito das permissoes administrativas QBCore para a hierarquia Admin real da Seoul.
-- vRP considera niveis menores como hierarquias mais altas.
QB.Permissions = QB.Permissions or {
    user = false,
    god = { group = "Admin", level = 1 },
    owner = { group = "Admin", level = 1 },
    admin = { group = "Admin", level = 3 },
    moderator = { group = "Admin", level = 3 },
    mod = { group = "Admin", level = 3 }
}
