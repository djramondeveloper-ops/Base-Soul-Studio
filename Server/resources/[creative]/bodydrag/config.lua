Config = {}

-- =====================================================
-- FRAMEWORK
-- =====================================================
-- 'auto'       -> detecta automaticamente ESX, QBCore, QBox ou vRP rodando no servidor
-- 'esx'        -> forca ESX
-- 'qbcore'     -> forca QBCore
-- 'qbox'       -> forca QBox (qbx_core)
-- 'vrp'        -> forca vRP
-- 'standalone' -> nao usa nenhum framework (ideal para servidores "creative"/customizados)
Config.Framework = 'auto'

-- Nomes dos resources usados na autodeteccao (ajuste se o seu core tiver outro nome)
Config.FrameworkResources = {
    esx    = 'es_extended',
    qbcore = 'qb-core',
    qbox   = 'qbx_core',
    vrp    = 'vrp',
}

-- =====================================================
-- INTEGRACAO COM SISTEMA DE MORTE / AMBULANCIA
-- =====================================================
-- Evento de servidor disparado quando o jogador e "curado"/reanimado (false)
-- ou marcado como morto (true) ao ser largado. Deixe "" (vazio) para desativar
-- essa integracao naquele framework (o script continua funcionando normalmente).
Config.DeathStatusEvent = {
    esx        = 'esx_ambulancejob:setDeathStatus',
    qbcore     = 'hospital:server:SetDeathStatus',
    qbox       = 'hospital:server:SetDeathStatus',
    vrp        = '',
    standalone = '',
}

-- =====================================================
-- GERAL
-- =====================================================
Config.ShowDistance = 10.0
Config.InteractDistance = 3.0

Config.AnimDict = 'combat@drag_ped@'

-- Controles (docs.fivem.net/docs/game-references/controls/)
Config.DragControl = 206     -- tecla de interacao contextual (padrao E)
Config.ReleaseControl = 47   -- G
Config.TurnLeftControl = 30  -- A
Config.TurnRightControl = 34 -- D
