-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-utils.lua
--  Engineered by Eazy Fxap
--  Original: 815 lines → Cleaned: 232 lines
-- =====================================================

UtilsService = {}
local isFading = false

function UtilsService.StopCurrentFade()
    isFading = false
end

function UtilsService.HandleEntityFade(entity, fadeType, duration)
    if not entity or not fadeType or not duration then return end
    
    isFading = true
    CreateThread(function()
        local startTime = GetGameTimer()
        local startAlpha = fadeType == "fadeIn" and 0 or 255
        local endAlpha = fadeType == "fadeIn" and 255 or 0
        local step = fadeType == "fadeIn" and 1 or -1
        
        while isFading do
            local elapsed = GetGameTimer() - startTime
            local progress = elapsed / duration
            local currentAlpha = math.floor(startAlpha + (progress * 255 * step))
            
            if currentAlpha > 255 then currentAlpha = 255 end
            if currentAlpha < 0 then currentAlpha = 0 end
            
            SetEntityAlpha(entity, currentAlpha, false)
            
            if fadeType == "fadeIn" and currentAlpha >= 255 then
                break
            elseif fadeType == "fadeOut" and currentAlpha <= 0 then
                SetTimeout(400, function()
                    DeleteEntity(entity)
                end)
                break
            end
            Wait(50)
        end
    end)
end

function UtilsService.LoadAnimationDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local tries = 0
    while not HasAnimDictLoaded(dict) and tries < 50 do
        Wait(10)
        tries = tries + 1
    end
    return HasAnimDictLoaded(dict)
end

function UtilsService.LoadModel(model)
    local hash = Object.getHash(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local tries = 0
        while not HasModelLoaded(hash) and tries < 50 do
            Wait(10)
            tries = tries + 1
        end
        if tries >= 50 then
            dbg.critical("Failed to load model: %s!", hash)
        end
    end
    return HasModelLoaded(hash)
end

function UtilsService.SpawnObject(model, coords, isLocal, isNetworked, noOffset)
    isNetworked = isNetworked or false
    isLocal = isLocal or false
    local obj
    if noOffset then
        obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, isLocal, isNetworked, false)
    else
        obj = CreateObject(model, coords.x, coords.y, coords.z, isLocal, isNetworked, false)
    end
    
    local tries = 0
    while not DoesEntityExist(obj) and tries < 50 do
        Wait(0)
        tries = tries + 1
    end
    
    if tries >= 50 then
        dbg.critical("Failed to spawn object named: %s", model)
    end
    
    return obj
end

function UtilsService.GetPlayerPedFromServerId(serverId)
    if not serverId then return nil, false end
    local playerIdx = GetPlayerFromServerId(serverId)
    if not playerIdx or playerIdx == -1 then
        dbg.debug("Failed to get player from serverId: %s got: %s not in same scope!", serverId, playerIdx)
        return nil, false
    end
    local ped = GetPlayerPed(playerIdx)
    dbg.debug("GetPlayerPedFromServerId: Returning with playerPed (%s) for serverId %s", ped, serverId)
    return ped, true
end

function UtilsService.GetServerIdFromPed(ped)
    dbg.debug("GetServerIdFromPed: Requesting playerIndex 1/3")
    if not ped then return nil end
    local playerIdx = NetworkGetPlayerIndexFromPed(ped)
    if not playerIdx then return nil end
    
    dbg.debug("GetServerIdFromPed: Got player index (%s) rquesting playerId 2/3", playerIdx)
    local serverId = GetPlayerServerId(playerIdx)
    dbg.debug("GetServerIdFromPed: Returning playerId (%s) 3/3", serverId)
    
    return serverId
end

function UtilsService.GetPlayerIndexFromPed(ped)
    if not ped then return nil end
    return NetworkGetPlayerIndexFromPed(ped)
end

function UtilsService.GetPedFromVehicleSeatIndex(veh, seat)
    return GetLastPedInVehicleSeat(veh, seat)
end

function UtilsService.AttachFromPedToTarget(initiatorPed, targetPed, options)
    if not initiatorPed then return dbg.debug("AttachFromPedToTarget: Failed to attached ped since initiator ped is not defined") end
    if not targetPed then return dbg.debug("AttachFromPedToTarget: Failed to attached ped since targetPed ped is not defined") end
    
    local pIdx = UtilsService.GetPlayerIndexFromPed(initiatorPed)
    local sId = UtilsService.GetServerIdFromPed(initiatorPed)
    
    local boneIndex = options and options.boneIndex or 11816
    local offset = options and options.offset or vector2(0.25, 0.25)
    local rot = options and options.rot or vector4(0.0, 0.0, 0.0, 0.0)
    local syncRot = options and options.syncRot
    if syncRot == nil then syncRot = true end
    
    if pIdx then
        dbg.debug("AttachFromPedToTarget: Loading attach for you with this serverId (%s) by player named %s", sId, GetPlayerName(pIdx))
    end
    
    Wait(0)
    AttachEntityToEntity(targetPed, initiatorPed, boneIndex, offset.x, offset.y, rot.x, rot.y, rot.z, rot.w, false, false, false, false, 2, syncRot)
    return IsEntityAttachedToEntity(targetPed, initiatorPed)
end

function getClosestPlayerToMe()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestPlayer = nil
    local minDistance = math.huge
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= ped then
            local dist = #(coords - GetEntityCoords(targetPed))
            if dist < minDistance then
                minDistance = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

function normalizeAndScaleVector(vec, scale)
    local len = math.sqrt(vec.x^2 + vec.y^2 + vec.z^2)
    if len == 0 then return {x=0, y=0, z=0} end
    return {
        x = (vec.x / len) * scale,
        y = (vec.y / len) * scale,
        z = (vec.z / len) * scale
    }
end

function fadeInFlashlight(sourceCoords, targetCoords, duration)
    local frames = duration * 1000 / 30
    for i = 0, frames, 1 do
        local r = math.random(180, 255)
        local g = math.random(180, 255)
        local b = math.random(180, 255)
        
        local dir = {
            x = targetCoords.x - sourceCoords.x,
            y = targetCoords.y - sourceCoords.y,
            z = targetCoords.z - sourceCoords.z
        }
        dir = normalizeAndScaleVector(dir, 0.1)
        
        DrawSpotLight(sourceCoords.x, sourceCoords.y, sourceCoords.z, dir.x, dir.y, dir.z, r, g, b, 50.0, (i/frames)*100, 0.0, 25.0, 30.0)
        Wait(30)
    end
end

function UtilsService.IsTargetInFrontOfPed(ped, coords)
    local pedCoords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local dir = vector3(coords.x - pedCoords.x, coords.y - pedCoords.y, 0.0)
    local len = #dir
    dir = dir / len
    
    local dot = (forward.x * dir.x) + (forward.y * dir.y) + (forward.z * dir.z)
    return dot > 0
end

function UtilsService.IsPlayerInFrontOrBehind(targetPlayerId, useSmallAngle)
    if not targetPlayerId then return end
    
    local ped = PlayerPedId()
    local targetPed = UtilsService.GetPlayerPedFromServerId(targetPlayerId)
    
    if IsInDev then return "back" end
    if ped == targetPed then
        local closest = getClosestPlayerToMe()
        if closest then
            targetPed = GetPlayerPed(closest)
        else
            return "no_target"
        end
    end
    
    local facing = IsPedFacingPed(ped, targetPed, 90.0)
    if useSmallAngle then
        facing = IsPedFacingPed(targetPed, ped, 40.0)
    end
    
    return facing and "front" or "back"
end

function UtilsService.GetTargetOffset(ped, offset)
    offset = offset or 0
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    return coords + (forward * offset)
end

function UtilsService.CreateProps(propsData)
    if type(propsData) ~= "table" then return end
    local ped = PlayerPedId()
    local spawnedProps = {}
    
    if propsData and next(propsData) then
        for _, prop in pairs(propsData) do
            local bone = GetPedBoneIndex(ped, prop.bone or 60309)
            local obj = UtilsService.SpawnObject(prop.name, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0), false, false)
            
            AttachEntityToEntity(obj, ped, bone, prop.coords.x, prop.coords.y, prop.coords.z, prop.rotation.x, prop.rotation.y, prop.rotation.z, true, true, false, true, 0, true)
            spawnedProps[obj] = obj
        end
    end
    return spawnedProps
end

function UtilsService.DeleteCreatedProps(props)
    if props and next(props) then
        for obj, _ in pairs(props) do
            if DoesEntityExist(obj) then
                DetachEntity(obj, false, false)
                DeleteEntity(obj)
            end
        end
    end
end
