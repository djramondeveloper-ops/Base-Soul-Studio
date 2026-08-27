-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local cachedBlips = {}
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if cachedBlips and next(cachedBlips) then
        for k, v in pairs(cachedBlips) do
            if DoesBlipExist(k) then
                RemoveBlip(k)
            end
        end
    end
end)
function Utils.CreateBlipAtCoords(blipOptions)
    if not blipOptions then
        return
    end
    if not blipOptions.pos then
        return
    end
    local blip = AddBlipForCoord(blipOptions.pos)
    SetBlipSprite (blip, blipOptions.sprite)
    SetBlipDisplay(blip, blipOptions.display or 1)
    SetBlipScale  (blip, blipOptions.scale or 1.0)
    SetBlipColour (blip, blipOptions.color or 1)
    local shortRange = blipOptions.shortRange
    if shortRange == nil then shortRange = true end
    SetBlipAsShortRange(blip, shortRange)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipOptions.name or '')
    EndTextCommandSetBlipName(blip)
    if not cachedBlips[blip] then
        cachedBlips[blip] = blip
    end
    return blip
end
function Utils.HasAccessToJobMenu()
    local retval = false
    if (not Framework.job or not Framework.job.name) and type(CachePlayerData) == 'function' then
        CachePlayerData()
    end

    if Framework.job then
        local jobName = Framework.job.name
        local jobDuty = Framework.job.duty
        if Config.JobGroups[jobName] then
            if jobDuty then
                retval = true
            else
                if IsInDevTwoClients then
                    return true
                end
                Framework.sendNotification(_U('DUTY.NEED_TO_BE_ON_DUTY_TO_OPEN_MENU'), 'error')
                dbg.debug('You need to be on duty to access job menu!')
            end
        end
    end
    return retval
end
function Utils.GetOutfitByGender(data)
    if not data then
        return {}
    end
    local plyPed = PlayerPedId()
    local model = GetEntityArchetypeName(plyPed)
    local isMale = 'mp_m_freemode_01' == model
    local gender = isMale and 'male' or 'female'
    if not data[gender] then
        return {}
    end
    return data[gender]
end
function Utils.HasZoneAccess(zoneJobOwner, zoneDuty, zoneType, jobState)
    local retval, statusCode = false, ZONES_ACCESS.PLAYER_NEED_TO_BE_ON_DUTY
    if Framework.job then
        local playerJob = Framework.job.name
        local playerDutyState = Framework.job.duty
        local playerIsBoss = Framework.job.gradeName == "boss" or Framework.job.isBoss
        local isJobAllowed = false
        if type(zoneJobOwner) == "table" then
            for _, allowedJob in ipairs(zoneJobOwner) do
                if allowedJob == playerJob then
                    isJobAllowed = true
                    break
                end
            end
        elseif type(zoneJobOwner) == "string" then
            isJobAllowed = playerJob == zoneJobOwner
        end
        if isJobAllowed then
            if zoneDuty then
                if zoneDuty ~= playerDutyState then
                    if zoneType == 'BOSS_MENU' and not playerIsBoss then
                        return false, 'NO_BOSS'
                    end
                    return false, ZONES_ACCESS.PLAYER_NEED_TO_BE_ON_DUTY
                end
                retval, statusCode = true, ZONES_ACCESS.PLAYER_NEED_TO_BE_ON_DUTY
            else
                retval, statusCode = true, ZONES_ACCESS.NO_DUTY
            end
            if retval and zoneType == 'BOSS_MENU' and not playerIsBoss then
                return false, 'NO_BOSS'
            end
            if zoneType == ZONE_TYPE.WEAPON_SHOP and Config.ItemShop.Mode == SHOP_STATE.ORDER_BY_BOSS and not playerIsBoss then
                return false, 'REQUIRE_BOSS_SHOP_STATE_ORDER_BY_BOSS'
            end
        else
            if zoneType == ZONE_TYPE.WRITE_REPORT then
                return true, 'PUBLIC_ZONE'
            end
            return false, ZONES_ACCESS.NO_PART_ZONE_JOB
        end
    end
    return retval, statusCode
end
function Utils.CanPlayerInteract(flags)
    local plyPed = PlayerPedId()
    local SKIP_NUI_FLAG = false 
    local SKIP_DEATH_FLAG = false
    if flags and next(flags) then
        if flags["FLAG_SKIP_NUI_CHECK"] then
            SKIP_NUI_FLAG = true
        end
        if flags["FLAG_SKIP_DEATH"] then
            SKIP_DEATH_FLAG = true
        end
    end
    if Config.Handsup.Enable then
        if GetHandsUPState()  then
            dbg.debug("Player has hands up, cannot interact")
            return false 
        end
    end
    if Config.Flags and not Config.Flags.SkipDeathCheck then
        if UtilsService.IsPedDeath(plyPed) and not SKIP_DEATH_FLAG then
            dbg.debug("Player is dead, cannot interact")
            return false
        end
    end
    if not SKIP_NUI_FLAG then
        if IsNuiFocused() or IsPauseMenuActive() then 
            dbg.debug("Player is in pause menu or nui focus active cannot interact")
            return false
        end
    end
    if IsInventoryBusy() then
        dbg.debug("Player inventory is busy, cannot interact")
        return false
    end
    if IsPedCuffed(plyPed) then
        dbg.debug("Player is cuffed, cannot interact")
        return false
    end
    return true
end
function Utils.Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
function Utils.GetClosestVehicleToPlayer(plyPos, radius)
    local retval, statusCode = nil, 'not_found'
    radius = radius or 2.0
    local vehicle = GetClosestVehicle(plyPos.x, plyPos.y, plyPos.z, radius, 0, 23)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        retval = vehicle
        statusCode = 'found_vehicle'
    else
        local closestDist = radius
        local closestVeh = nil
        local vehicles = GetGamePool("CVehicle")
        for _, veh in pairs(vehicles) do
            if DoesEntityExist(veh) then
                local vehCoords = GetEntityCoords(veh)
                local dist = #(plyPos - vehCoords)
                if dist < closestDist then
                    closestDist = dist
                    closestVeh = veh
                end
            end
        end
        if closestVeh then
            retval = closestVeh
            statusCode = 'fallback_found'
        else
            statusCode = 'no_vehicle_found'
        end
    end
    dbg.debug('Closest vehicle: %s with status %s', retval, statusCode)
    return retval, statusCode
end
function Utils.getClosestPlayers(maxDist, includePlayer)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local players = GetActivePlayers()
    local closestDistance = maxDist or 5.0
    local closestPlayerName = ''
    local closestPlayer = -1
    local retval = {}
    for i = 1, #players, 1 do
        local playerId = players[i]
        if (playerId ~= PlayerId() or includePlayer) and playerId ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(playerId))
            local distance = #(pos - coords)
            if distance < closestDistance then
                closestPlayer = GetPlayerServerId(playerId)
                closestPlayerName = GetPlayerName(playerId)
                closestDistance = distance
                retval[#retval + 1] = {
                    playerId = closestPlayer,
                    name = GetPlayerName(playerId),
                    player = playerId,
                    prefix = ('%s (%s)'):format(closestPlayerName, closestPlayer)
                }
            end
        end
    end
    return closestPlayer, closestDistance, retval
end
