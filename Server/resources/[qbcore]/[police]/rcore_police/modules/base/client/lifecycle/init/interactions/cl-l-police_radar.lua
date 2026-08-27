-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-police_radar.lua
--  Engineered by Eazy Fxap
--  Original: 999 lines → Cleaned: 240 lines
-- =====================================================

local checkDistance = Config.PoliceRadar.CheckDistance or 10.0
local checkRadius = Config.PoliceRadar.CheckRadius or 5.0
IsUsingRadar = false
local fastLockSpeed = Config.PoliceRadar.FastLockSpeed or 10
local memorySessions = {}
local radarMemory = {}
local isRadarLocked = false
IsLoadedRadarSettings = false

Radar = {
    HasChanged = false,
    PatrolSpeed = 0,
    Front = { Plate = nil, Speed = 0, Lock = { Plate = false, Speed = false } },
    Rear = { Plate = nil, Speed = 0, Lock = { Plate = false, Speed = false } }
}

RegisterNuiCallback(NUI_EVENTS.HANDLE_FOCUS, function(data, cb)
    if not IsUsingRadar then return end
    dbg.debug("Radar: Handling draggable focus to state: %s", data)
    ToggleFocus(data)
    cb("OK")
end)

RegisterNuiCallback(NUI_EVENTS.SHOW_RADAR, function(data, cb)
    IsUsingRadar = data
    dbg.debug("Police radar: Use state set to %s", data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.SET_FAST_LIMIT_RADAR, function(data, cb)
    fastLockSpeed = data
    dbg.debug("Police radar: Updating fast lock limit for vehicle to: %s", data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.RESET_RADAR, function(data, cb)
    Radar = {
        HasChanged = false,
        PatrolSpeed = 0,
        Front = { Plate = nil, Speed = 0, Lock = { Plate = false, Speed = false } },
        Rear  = { Plate = nil, Speed = 0, Lock = { Plate = false, Speed = false } }
    }
    UpdateRadar(nil, nil, true)
    cb("ok")
end)

CreateThread(function()
    while true do
        Wait(100)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 then
            if IsUsingRadar then
                local coords = GetEntityCoords(vehicle)
                local forwardVector = GetEntityForwardVector(vehicle)
                
                -- Check Front
                local frontCoords = coords + (forwardVector * checkDistance)
                local frontVeh = GetVehicleAtEndCoords(frontCoords, checkRadius)
                Radar.HasChanged = false
                
                if frontVeh ~= 0 then
                    local plate = GetVehicleNumberPlateText(frontVeh)
                    if plate and plate ~= Radar.Front.Plate and not Radar.Front.Locked then
                        Radar.Front.Plate = plate
                        Radar.HasChanged = true
                    end
                end
                
                -- Check Rear
                local rearCoords = coords - (forwardVector * checkDistance)
                local rearVeh = GetVehicleAtEndCoords(rearCoords, checkRadius)
                
                if rearVeh ~= 0 then
                    local plate = GetVehicleNumberPlateText(rearVeh)
                    if plate and plate ~= Radar.Rear.Plate and not Radar.Rear.Locked then
                        Radar.Rear.Plate = plate
                        Radar.HasChanged = true
                    end
                end
                
                -- Update Patrol Speed
                local currentSpeed = GetEntitySpeed(vehicle)
                if currentSpeed ~= Radar.PatrolSpeed then
                    Radar.PatrolSpeed = math.floor(currentSpeed)
                    UpdateRadar(frontVeh, rearVeh, true)
                end
                
                if isRadarLocked then
                    DrawDebugLine(coords, frontCoords, checkRadius)
                    DrawDebugLine(coords, rearCoords, checkRadius)
                end
                
                if Radar.HasChanged then
                    if not isRadarLocked then
                        UpdateRadar(frontVeh, rearVeh, true)
                        if Config.PoliceRadar.Beep.Play and IsUsingRadar then
                            local soundId = GetSoundId()
                            if soundId then
                                PlaySoundFrontend(soundId, Config.PoliceRadar.Beep.AudioName or "5_SEC_WARNING", Config.PoliceRadar.Beep.AudioRef or "HUD_MINI_GAME_SOUNDSET", true)
                            end
                        end
                    end
                end
            end
        else
            if IsUsingRadar then
                IsUsingRadar = false
                UI.PoliceRadar(IsLoadedRadarSettings)
            end
        end
    end
end)

function GetVehicleLabelFromEntity(entity)
    return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity)))
end

function GetRadarSpeed(speed)
    local type = string.upper(Config.PoliceRadar.SpeedType)
    if type == "MPH" then
        dbg.debug("Using radar speed conversion via MPH")
        return math.floor(speed * 2.236936)
    elseif type == "KMH" then
        dbg.debug("Using radar speed conversion via KM/H")
        return math.floor(speed * 3.6)
    else
        return math.floor(speed)
    end
end

function RegisterSessionForPlate(entity, speed)
    local plate = GetVehicleNumberPlateText(entity)
    if memorySessions[plate] then return end
    
    dbg.debug("Police radar: Registering vehicle with plate: %s into memory sessions!", plate)
    table.insert(radarMemory, {
        plate = plate,
        label = GetVehicleLabelFromEntity(entity),
        speed = speed
    })
    memorySessions[plate] = true
end

function UpdateRadar(frontVeh, rearVeh, forceUpdate)
    if isRadarLocked then return end
    
    if frontVeh then
        local speed = math.floor(GetEntitySpeed(frontVeh))
        if speed ~= 0 and speed ~= Radar.Front.Speed then
            Radar.Front.Speed = GetRadarSpeed(speed)
        end
        
        if Config.PoliceRadar.RecentSessions and Config.PoliceRadar.RecentSessionsTrackVehicleWithSpeed and speed >= Config.PoliceRadar.RecentSessionsTrackVehicleWithSpeed then
            RegisterSessionForPlate(frontVeh, speed)
        end
        
        if speed >= fastLockSpeed and not Radar.Front.Lock.Speed and Config.PoliceRadar.FastLock then
            Radar.Front.Lock.Speed = true
            Radar.Front.Lock.Plate = true
            Radar.Front.LockSpeed = GetRadarSpeed(speed)
            dbg.debug("Fast Lock: Front vehicle locked at %s", speed)
            SetTimeout(4000, function() Radar.Front.Lock.Speed = false end)
        end
    end
    
    if rearVeh then
        local speed = math.floor(GetEntitySpeed(rearVeh))
        if speed ~= 0 and speed ~= Radar.Rear.Speed then
            Radar.Rear.Speed = GetRadarSpeed(speed)
        end
        
        if Config.PoliceRadar.RecentSessions and Config.PoliceRadar.RecentSessionsTrackVehicleWithSpeed and speed >= Config.PoliceRadar.RecentSessionsTrackVehicleWithSpeed then
            RegisterSessionForPlate(rearVeh, speed)
        end
        
        if speed >= fastLockSpeed and not Radar.Rear.Lock.Speed and Config.PoliceRadar.FastLock then
            Radar.Rear.Lock.Speed = true
            Radar.Rear.Lock.Plate = true
            Radar.Rear.LockSpeed = GetRadarSpeed(speed)
            dbg.debug("Fast Lock: Rear vehicle locked at %s", speed)
            SetTimeout(4000, function() Radar.Rear.Lock.Speed = false end)
        end
    end
    
    if not forceUpdate and Radar.Rear.Speed <= 0 and Radar.Front.Speed <= 0 then return end
    
    UI.SendReactMessage(NUI_EVENTS.UPDATE_RADAR, {
        Front = { Plate = Radar.Front.Plate, Speed = Radar.Front.Speed, LockSpeed = Radar.Front.LockSpeed or 0, Lock = Radar.Front.Lock },
        Rear = { Plate = Radar.Rear.Plate, Speed = Radar.Rear.Speed, LockSpeed = Radar.Rear.LockSpeed or 0, Lock = Radar.Rear.Lock },
        PatrolSpeed = GetRadarSpeed(Radar.PatrolSpeed),
        Recent = radarMemory
    })
end

function DrawDebugLine(startCoords, endCoords, radius)
    DrawLine(startCoords.x, startCoords.y, startCoords.z, endCoords.x, endCoords.y, endCoords.z, 255, 0, 0, 255)
    DrawMarker(1, endCoords.x, endCoords.y, endCoords.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 255, 0, 255, false, true, 2, nil, nil, false)
    DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0, 0, 0, 0, 0, 0, radius, radius, radius, 0, 0, 255, 100, false, true, 2, nil, nil, false)
end

function UI.PoliceRadar(showState)
    if showState then SetNuiFocus(true, true) end
    
    if not Radar.Front.Plate then Radar.Front.Plate = "XXX-XXX" end
    if not Radar.Rear.Plate then Radar.Rear.Plate = "XXX-XXX" end
    
    local data = {
        moveState = isRadarLocked,
        FastLockSpeed = fastLockSpeed,
        recent = radarMemory,
        showState = showState,
        radarState = IsUsingRadar,
        radar = { Front = Radar.Front, Rear = Radar.Rear, PatrolSpeed = Radar.PatrolSpeed }
    }
    
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    UI.SendReactMessage(NUI_EVENTS.POLICE_RADAR, data)
end

function ToggleFocus(state)
    isRadarLocked = state
    SetNuiFocus(state, state)
end

function OpenRadar()
    if not IsUsingRadar then return end
    isRadarLocked = not isRadarLocked
    Framework.sendNotification(isRadarLocked and _U("RADAR.LOCK_TOGGLE_ON") or _U("RADAR.LOCK_TOGGLE_OFF"), "success")
end

function LockRadarToggle(coords, radius)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, radius or 2.0, 0, 2175)
    if veh ~= 0 then return veh, true, "found_vehicle" end
    return nil, false, "unk"
end

function GetVehicleAtEndCoords(coords, radius)
    return GetClosestVehicle(coords.x, coords.y, coords.z, radius or 2.0, 0, 2175)
end

AddEventHandler("rcore_police:client:openPoliceRadar", function() OpenRadar() end)

RegisterKey(function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then
        return dbg.debug("Police radar: Failed to open radar, since player is not in vehicle.")
    end
    if not Config.PoliceRadar.Enable then
        return dbg.debug("Police radar: Is not enabled for use, see config.lua")
    end
    
    if Framework.job then
        local jobGroup = GetDepartmentConfig(Framework.job.name)
        if jobGroup then
            local driverSeat = SEAT_INDEXES and SEAT_INDEXES.DRIVER_SEAT or -1
            if GetVehicleClass(vehicle) ~= 18 and not (Config.PoliceRadar.WhitelistedVehicles and Config.PoliceRadar.WhitelistedVehicles[GetEntityArchetypeName(vehicle)]) then
                return dbg.debug("Police radar: Vehicle is not emergency, not going to open it.")
            end
            if Config.PoliceRadar.RestrictOnlyForDriver and GetPedInVehicleSeat(vehicle, driverSeat) ~= ped then
                return dbg.debug("Police radar: Radar can be used only from driver seat")
            end
            
            dbg.debug("Police radar: Has valid job group, granting access to radar.")
            IsLoadedRadarSettings = not IsLoadedRadarSettings
            if not IsLoadedRadarSettings and not isRadarLocked then
                IsLoadedRadarSettings = true
            end
            UI.PoliceRadar(IsLoadedRadarSettings)
        else
            dbg.debug("Police radar: Your job named %s is not allowed to access radar!", Framework.job.name)
        end
    end
end, "RCORE_POLICE_RADAR", "RCORE_POLICE_RADAR", Config.PoliceRadar.OpenKey or "N", nil, { state = true, cooldown = 250 })

RegisterKey(OpenRadar, "RCORE_POLICE_RADAR_LOCK", "RCORE_POLICE_RADAR", Config.PoliceRadar.LockRadarKey or "B", nil, { state = true, cooldown = 250 })
