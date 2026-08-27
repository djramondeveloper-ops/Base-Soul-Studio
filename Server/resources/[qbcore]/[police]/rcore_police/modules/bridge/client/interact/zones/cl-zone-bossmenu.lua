-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function OpenBossMenu(zone)
    local job = zone.getDepartmentOwner()
    local zoneDutyState = zone.getZoneDutyState()
    local zoneType = zone.getZoneType()
    local jobState = zone.getJobState()
    if not job then
        return
    end
    local hasAccess, statusCode = Utils.HasZoneAccess(job, zoneDutyState, zoneType, jobState)
    if not hasAccess then
        return dbg.debug('You dont have access to this zone - reason: %s!', statusCode)
    end
    if type(job) == "table" then
        job = Framework.job.name
    end
    dbg.debug('Trying to open boss menu for job named: %s', job)
    local jobCreator = FindTargetResource('job_creator') or FindTargetResource('jobs_creator') or nil
    if Config.BossMenu and Config.BossMenu.UseIncludedMenu or jobCreator then
        TriggerServerEvent('rcore_police:server:requestBossMenu')
        return
    else
        dbg.debug('Not using built in boss menu.')
    end
    OpenSociety(job)
end
function OpenSociety(job)
    if not job then
        dbg.critical('Boss menu: Failed to open since not getting any job data which you are part off! (%s)', job)
        return false
    end
    if Config.Society == Society.CODESTUDIO then
        TriggerEvent('cs:bossmenu:Open', job)
        return true
    end
    if Config.Society == Society.QB_MANAGEMENT then
        TriggerEvent(Config.Events['qb-openBossMenu'])
        return true
    end
    if isResourcePresentProvideless('vms_bossmenu') and doesExportExistInResource('vms_bossmenu', 'openBossMenu') then
        exports['vms_bossmenu']:openBossMenu(job, 'job')
        return true
    end
    if Config.Society == Society.QBX_MANAGEMENT then
        exports['qbx_management']:OpenBossMenu(job)
        return true
    end
    if Config.Society == Society.OKOK and isResourcePresentProvideless('okokBossMenu') then
        TriggerEvent('okokBossMenu:toggleJobDuty')
        Wait(0)
        TriggerEvent('okokBossMenu:openBossMenu')
        return true
    end
    if Config.Framework == Framework.ESX then
        TriggerEvent('esx_society:openBossMenu', job, function(data, menu) end, Config.SocietyOptionsESX)
        return true
    end
    if Config.Framework == Framework.QBCore then
        TriggerEvent(Config.Events['qb-openBossMenu'])
        return true
    end
    if Config.Framework == Framework.QBOX then
        exports['qbx_management']:OpenBossMenu(job)
        return true
    end
    dbg.critical('Boss menu: Failed to find any supported society to open it! Detected society: %s', Config.Society)
    return false
end
