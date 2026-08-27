-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



AddEventHandler('rcore_police:client:zoneInteract', function(data)
    if type(data) ~= 'table' then
        return
    end
    if not data then
        return
    end
    local zone = data.zone
    if not zone then
        return 
    end
    OnZoneKeypress(zone)
end)
AddEventHandler("rcore_police:client:characterLoaded", function()
    if GetInvokingResource() ~= GetCurrentResourceName() then return end
    if Config.UseTargetForZones and isResourcePresentProvideless("crm-target") then
        InitRegisterZones()
    end
end)
function HandleRegistrationZoneBlock()
    local retval = false 
    if Config.UseTargetForZones and isResourcePresentProvideless('crm-target') then
        retval = true
    end 
    return retval
end
function OnZoneEnter(zone)
    local zoneType = zone.getZoneType()
    local job = zone.getDepartmentOwner()
    local zoneDutyState = zone.getZoneDutyState()
    local label = zone.getZoneLabel()
    local coords = zone.getPosition()
    local jobState = zone.getJobState()
    local playerId = PlayerPedId()
    GlobalZoneId = zone.getId()
    CurrentZone = zone
    local hasAccess, statusCode = Utils.HasZoneAccess(job, zoneDutyState, zoneType, jobState)
    if not hasAccess and not jobState then
        return dbg.debug('You dont have access to this zone - reason: %s!', statusCode)
    end
    dbg.debug('Player entered zone type: %s', zoneType)
    if Config.Zones.Style == 'DrawText' or Config.Zones.Style == 'Marker' or Config.Zones.Style == "Target" then
        if zoneType == ZONE_TYPE.VEHICLE_SPAWNPOINT and GetVehiclePedIsIn(playerId, false) <= 0 then
            return
        end
        local restrictHelp = true
        if label == '' and zoneType == ZONE_TYPE.VEHICLE_SPAWNPOINT then
            label = _U("POINTS.STORE_VEHICLE")
        end
        if Config.Zones.Style == "Target" and zoneType == ZONE_TYPE.VEHICLE_SPAWNPOINT then
            restrictHelp = false
        elseif Config.Zones.Style == "Marker" then
            restrictHelp = false
        end
        if restrictHelp then
            return
        end
        TextService.Render(label, coords)
    end 
    if zoneType == ZONE_TYPE.VEHICLE_SPAWNPOINT then
        HandleVehicleEnterOnSpawnPoint(zone)
    end
end
function OnZoneLeave(zone)
    local zoneType = zone.getZoneType()
    if Config.Zones.Style == 'DrawText' or Config.Zones.Style == 'Marker' or Config.Zones.Style == "Target" then
        TextService.Hide()
    end 
    if GlobalZoneId then
        GlobalZoneId = nil    
    end
    if CurrentZone then
        CurrentZone = nil
    end
    dbg.debug('Player left zone type: %s', zoneType)
end
function OnZoneKeypress(zone)
    if not zone then
        return dbg.critical('Zone keypress: Failed to interact with zone, doesnt exist?!')
    end
    if type(zone) == 'number' then
        return dbg.critical('Zone keypress: Returned number - using resource for target: %s', Config.InteractionsTarget)
    end
    local job = zone.getDepartmentOwner()
    local zoneDutyState = zone.getZoneDutyState()
    local zoneType = zone.getZoneType()
    local jobState = zone.getJobState()
    CurrentZone = zone
    local hasAccess, statusCode = Utils.HasZoneAccess(job, zoneDutyState, zoneType, jobState)
    if not hasAccess and not jobState then
        if statusCode == ZONES_ACCESS.PLAYER_NEED_TO_BE_ON_DUTY then
            Framework.sendNotification(_U('DUTY.NEED_TO_BE_ON_DUTY_TO_INTERACT_WITH_ZONE'))
        end
        return dbg.debug('You dont have access to this zone - reason: %s!', statusCode)
    end
    if zoneType == ZONE_TYPE.GARAGE_VEHICLE or zoneType == ZONE_TYPE.GARAGE_AIR then
        safeCallFunction(OpenJobGarageMenu, zoneType == ZONE_TYPE.GARAGE_VEHICLE or zoneType == ZONE_TYPE.GARAGE_AIR, zone)
    elseif zoneType == ZONE_TYPE.VEHICLE_SPAWNPOINT then
        safeCallFunction(HandleVehicleOnSpawnPointInteract, ZONE_TYPE.VEHICLE_SPAWNPOINT, zone)
    elseif zoneType == ZONE_TYPE.BOSS_MENU then
        safeCallFunction(OpenBossMenu, ZONE_TYPE.BOSS_MENU, zone)
    elseif zoneType == ZONE_TYPE.DUTY then
        safeCallFunction(HandleJobDuty, ZONE_TYPE.DUTY, zone)
    elseif zoneType == ZONE_TYPE.PERSONAL_LOCKER then
        safeCallFunction(OpenPersonalLocker,  ZONE_TYPE.PERSONAL_LOCKER, zone)
    elseif zoneType == ZONE_TYPE.EVIDENCE_STASH then
        safeCallFunction(OpenEvidenceStash, ZONE_TYPE.EVIDENCE_STASH, zone)
    elseif zoneType == ZONE_TYPE.JOB_STASH then
        safeCallFunction(OpenJobStash, ZONE_TYPE.JOB_STASH, zone)
    elseif zoneType == ZONE_TYPE.CLOTHING_ROOM then
        safeCallFunction(OpenOutfitMenu, ZONE_TYPE.CLOTHING_ROOM , zone)
    elseif zoneType == ZONE_TYPE.WEAPON_SHOP then
        safeCallFunction(OpenWeaponShop, ZONE_TYPE.WEAPON_SHOP, zone)
    elseif zoneType == ZONE_TYPE.WEAPON_STORAGE then
        safeCallFunction(OpenWeaponStorage, ZONE_TYPE.WEAPON_SHOP, zone)
    elseif zoneType == ZONE_TYPE.REPORTS then
        UI.ReportMenu()
    elseif zoneType == ZONE_TYPE.WRITE_REPORT and Config.Reports.Enable then
        WriteReport(zone)
    else
        dbg.critical('OnZoneKeypress: Undefined interaction for zoneType: %s', zoneType)
    end
end
