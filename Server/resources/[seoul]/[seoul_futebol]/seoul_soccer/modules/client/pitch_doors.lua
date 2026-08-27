--[[
  Saha kapilari — iki mod:
    * prop (varsayilan): config pivot + FreezeEntityPosition. Kayar panel / MLO prop icin.
    * doorsystem: AddDoorToSystem + DoorSystemSetDoorState (menteseli kapilar).
      Kilitte prop snap YAPILMAZ — yalnizca door system + native kilit (cift mudahale onlenir).

  Resource start/stop: tum mudahaleler kaldirilir (coz, DoorSystem kaydini sil, tablolari sifirla).
]]

local DEBUG = false

local DOOR_FIND_RADIUS = 4.0
local DOOR_FIND_RADIUS_WIDE = 11.0
local REGISTER_USE_ENTITY_ANCHOR_IF_WITHIN_M = 8.0
local REPAIR_STRAY_FIND_RADIUS_M = 12.0
local REPAIR_STRAY_DISTANCE_M = 1.05
local DOOR_AUTOMATIC_RATE = 2.75
local DOOR_AUTOMATIC_DISTANCE_M = 5.0
local REAPPLY_LOCKED_MS = 2200
--- Kapı prop'u ile closedCoords arası makul üst sınır; üstünde snap yapılmaz (yanlış entity / pivot hatası ihtimali).
local MAX_DOOR_SNAP_DISTANCE_M = 9.0

local function dbg(fmt, ...)
    if not DEBUG then return end
    local ok, msg = pcall(string.format, fmt, ...)
    if ok then
        print(("[seoul_soccer:doors] %s"):format(msg))
    else
        print("[seoul_soccer:doors]", fmt, ...)
    end
end

local appliedByPitch = {}
local registered = {}
local frozenByKey = {}
local unlockedByKey = {}
local runtimeOffsets = {}

local function GetPitchById(pitchId)
    local want = tostring(pitchId or "")
    for _, p in ipairs(Config.Pitches or {}) do
        if p and p.id ~= nil and tostring(p.id) == want then
            return p
        end
    end
    return nil
end

local function GetPitchDoorEntries(pitch)
    local out = {}
    if not pitch or type(pitch.doors) ~= "table" then return out end
    for _, def in ipairs(pitch.doors) do
        if type(def) == "table" then
            local anchor = def.coords or def.closedCoords
            if def.model and anchor and type(anchor.x) == "number" then
                out[#out + 1] = def
            end
        end
    end
    return out
end

local function ResolveDoorModelHash(model)
    if model == nil then return 0 end
    if type(model) == "number" then return model end
    if type(model) == "string" then return joaat(model) end
    return 0
end

local function DoorUsesDoorSystem(def)
    if not def then return false end
    if def.useDoorSystem == true or def.kind == "doorsystem" then return true end
    if def.kind == "prop" or def.useDoorSystem == false then return false end
    return false
end

local function GetDoorHash(pitchId, idx)
    return joaat(("seoul_soccer:%s:%d"):format(tostring(pitchId or ""), tonumber(idx) or 0))
end

local function RequestDoorEntityControl(ent, timeoutMs)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return false end
    if NetworkHasControlOfEntity and NetworkHasControlOfEntity(ent) then return true end
    if not NetworkGetEntityIsNetworked or not NetworkGetEntityIsNetworked(ent) then return true end
    timeoutMs = tonumber(timeoutMs) or 320
    local untilAt = GetGameTimer() + math.max(50, timeoutMs)
    while GetGameTimer() < untilAt do
        if NetworkHasControlOfEntity(ent) then return true end
        if NetworkRequestControlOfEntity then NetworkRequestControlOfEntity(ent) end
        Wait(10)
    end
    return NetworkHasControlOfEntity and NetworkHasControlOfEntity(ent)
end

local function DoorSystemKnowsDoor(doorHash)
    if not doorHash or not DoorSystemGetDoorState then return false end
    local ok, st = pcall(DoorSystemGetDoorState, doorHash)
    if not ok or st == nil then return false end
    if type(st) == "number" and st < 0 then return false end
    return true
end

local function GetRuntimeOffset(pitchId, idx)
    local t = runtimeOffsets[tostring(pitchId or "")]
    if not t then return nil end
    return t[idx]
end

local function AddRuntimeOffset(pitchId, idx, dx, dy, dz)
    local pk = tostring(pitchId or "")
    runtimeOffsets[pk] = runtimeOffsets[pk] or {}
    local cur = runtimeOffsets[pk][idx] or { x = 0.0, y = 0.0, z = 0.0 }
    cur.x = (cur.x or 0.0) + (tonumber(dx) or 0.0)
    cur.y = (cur.y or 0.0) + (tonumber(dy) or 0.0)
    cur.z = (cur.z or 0.0) + (tonumber(dz) or 0.0)
    runtimeOffsets[pk][idx] = cur
    return cur
end

local function ClearRuntimeOffset(pitchId, idx)
    local pk = tostring(pitchId or "")
    if runtimeOffsets[pk] then
        runtimeOffsets[pk][idx] = nil
    end
end

--- Ayni modelde iki kapi varsa config pivotuna en yakin entity (yanlis kapi secimini onler).
local function FindDoorEntity(model, c, searchRadius)
    if model == 0 or not c or type(c.x) ~= "number" then return 0 end
    local r = tonumber(searchRadius) or DOOR_FIND_RADIUS
    if r < 0.5 then r = 0.5 end

    local rSq = r * r
    local bestEnt, bestDistSq = 0, rSq + 0.001
    local cx, cy, cz = c.x, c.y, c.z
    if GetGamePool then
        local pool = GetGamePool("CObject")
        if type(pool) == "table" then
            for _, ent in ipairs(pool) do
                if ent and ent ~= 0 and DoesEntityExist(ent) and GetEntityModel(ent) == model then
                    local ec = GetEntityCoords(ent)
                    if ec then
                        local dx, dy, dz = ec.x - cx, ec.y - cy, ec.z - cz
                        local dSq = (dx * dx) + (dy * dy) + (dz * dz)
                        if dSq <= rSq and dSq < bestDistSq then
                            bestDistSq = dSq
                            bestEnt = ent
                        end
                    end
                end
            end
        end
    end
    if bestEnt ~= 0 then return bestEnt end

    local ent = GetClosestObjectOfType(cx + 0.0, cy + 0.0, cz + 0.0, r, model, false, false, false)
    if ent and ent ~= 0 and DoesEntityExist(ent) then return ent end
    return 0
end

--- Prop arama noktasi (coords veya closedCoords).
local function GetDoorSearchCoords(def)
    return def.coords or def.closedCoords
end

local function ApplySnapOffset(pitchId, i, def, x, y, z)
    local ox, oy, oz = 0.0, 0.0, 0.0
    local so = def.snapOffset
    if type(so) == "table" or type(so) == "vector3" then
        ox = tonumber(so.x) or 0.0
        oy = tonumber(so.y) or 0.0
        oz = tonumber(so.z) or 0.0
    end
    local rto = GetRuntimeOffset(pitchId, i)
    if rto then
        ox = ox + (rto.x or 0.0)
        oy = oy + (rto.y or 0.0)
        oz = oz + (rto.z or 0.0)
    end
    return x + ox, y + oy, z + oz
end

--- Kilitli (kapali) konum — closedCoords oncelikli.
local function GetDoorClosedPivot(pitchId, i, def)
    local c = def.closedCoords or def.coords
    if not c or type(c.x) ~= "number" or type(c.y) ~= "number" or type(c.z) ~= "number" then return nil end
    local heading = tonumber(def.closedHeading)
    if heading == nil then heading = tonumber(def.heading) or 0.0 end
    local x, y, z = ApplySnapOffset(pitchId, i, def, c.x, c.y, c.z)
    return x, y, z, heading
end

--- Acik konum — openCoords veya kapali + openOffset.
local function GetDoorOpenPivot(pitchId, i, def)
    local oc = def.openCoords
    if oc and type(oc.x) == "number" and type(oc.y) == "number" and type(oc.z) == "number" then
        local h = tonumber(def.openHeading)
        if h == nil then h = tonumber(def.heading) or 0.0 end
        local x, y, z = ApplySnapOffset(pitchId, i, def, oc.x, oc.y, oc.z)
        return x, y, z, h
    end
    local tx, ty, tz, heading = GetDoorClosedPivot(pitchId, i, def)
    if tx == nil or ty == nil or tz == nil then return nil end
    local oo = def.openOffset
    if type(oo) == "table" or type(oo) == "vector3" then
        tx = tx + (tonumber(oo.x) or 0.0)
        ty = ty + (tonumber(oo.y) or 0.0)
        tz = tz + (tonumber(oo.z) or 0.0)
    else
        return nil
    end
    local openHeading = tonumber(def.openHeading)
    if openHeading == nil then openHeading = heading end
    return tx, ty, tz, openHeading
end

local function GetDoorPivotAndHeading(pitchId, i, def)
    return GetDoorClosedPivot(pitchId, i, def)
end

local function FindDoorEntityForDef(def, searchRadius)
    local model = ResolveDoorModelHash(def.model)
    local c = GetDoorSearchCoords(def)
    if model == 0 or not c then return 0 end
    local ent = FindDoorEntity(model, c, searchRadius or DOOR_FIND_RADIUS)
    if ent ~= 0 then return ent end
    if searchRadius and searchRadius <= DOOR_FIND_RADIUS + 0.01 then
        return FindDoorEntity(model, c, DOOR_FIND_RADIUS_WIDE)
    end
    return 0
end

local function ApplyEntityPivot(ent, tx, ty, tz, heading)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return end
    if NetworkGetEntityIsNetworked and NetworkGetEntityIsNetworked(ent) then
        RequestDoorEntityControl(ent, 420)
    end
    SetEntityVelocity(ent, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0) end
    SetEntityCoordsNoOffset(ent, tx, ty, tz, false, false, false)
    SetEntityHeading(ent, heading)
    -- SetEntityRotation(0,0,heading) KULLANMA: pitch/roll'u sifirlar; kayar panel / egik MLO prop'lari
    -- haritadan "ucup" kayboluyormus gibi yanlis konuma ziplatir.
end

local function NativeUnlockClosestDoor(model, c)
    if model == 0 or not c or not c.x then return end
    if SetStateOfClosestDoorOfType then
        SetStateOfClosestDoorOfType(model, c.x + 0.0, c.y + 0.0, c.z + 0.0, false, 0.0, false, false)
    end
end

local function NativeLockClosestDoor(model, c)
    if model == 0 or not c or not c.x then return end
    if SetStateOfClosestDoorOfType then
        SetStateOfClosestDoorOfType(model, c.x + 0.0, c.y + 0.0, c.z + 0.0, true, 0.0, false, false)
    end
end

local function UnfreezeDoorEntity(ent, enablePhysics)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return end
    if NetworkGetEntityIsNetworked and NetworkGetEntityIsNetworked(ent) then
        RequestDoorEntityControl(ent, 320)
    end
    FreezeEntityPosition(ent, false)
    if enablePhysics then
        if SetEntityDynamic then SetEntityDynamic(ent, true) end
        if ActivatePhysics then ActivatePhysics(ent) end
    end
    SetEntityVelocity(ent, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0) end
end

local function RemoveDoorFromDoorSystem(doorHash)
    if not doorHash then return end
    if DoorSystemSetDoorState then
        pcall(DoorSystemSetDoorState, doorHash, 0, false, false)
    end
    if RemoveDoorFromSystem then
        pcall(RemoveDoorFromSystem, doorHash)
    end
end

--- Tek kapinin tum script mudahalesini geri al.
local function ReleaseSingleDoor(pitchId, idx, def)
    local model = ResolveDoorModelHash(def.model)
    local c = GetDoorSearchCoords(def)
    local doorHash = GetDoorHash(pitchId, idx)
    local pk = tostring(pitchId or "")
    local key = pk .. ":" .. tostring(idx)

    local ent = frozenByKey[key]
    if (not ent or ent == 0 or not DoesEntityExist(ent)) and model ~= 0 and c then
        ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS_WIDE)
    end

    if ent and ent ~= 0 then
        UnfreezeDoorEntity(ent, false)
    end
    frozenByKey[key] = nil
    unlockedByKey[key] = nil

    if DoorSystemKnowsDoor(doorHash) or (registered[pk] and registered[pk][idx]) then
        RemoveDoorFromDoorSystem(doorHash)
    end
    NativeUnlockClosestDoor(model, c)

    if registered[pk] then
        registered[pk][idx] = nil
    end
end

local function UnregisterPitchDoors(pitchId)
    local pitch = GetPitchById(pitchId)
    local entries = GetPitchDoorEntries(pitch)
    for i, def in ipairs(entries) do
        ReleaseSingleDoor(pitchId, i, def)
    end
    registered[tostring(pitchId or "")] = nil
end

--- Tum sahalar: coz, DoorSystem sil, state sifirla (restart / stop).
local function ReleaseAllPitchDoors()
    dbg("ReleaseAllPitchDoors")
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch and pitch.id ~= nil then
            UnregisterPitchDoors(pitch.id)
        end
    end
    for key, ent in pairs(frozenByKey) do
        if ent and ent ~= 0 and DoesEntityExist(ent) then
            UnfreezeDoorEntity(ent)
        end
        frozenByKey[key] = nil
    end
    appliedByPitch = {}
    registered = {}
    runtimeOffsets = {}
    unlockedByKey = {}
end

local function EnsureDoorRegistered(pitchId, idx, def)
    local pk = tostring(pitchId or "")
    registered[pk] = registered[pk] or {}
    if registered[pk][idx] then return true end

    local model = ResolveDoorModelHash(def.model)
    local c = GetDoorSearchCoords(def)
    if model == 0 or not c or type(c.x) ~= "number" then return false end

    local doorHash = GetDoorHash(pitchId, idx)
    if DoorSystemKnowsDoor(doorHash) then
        registered[pk][idx] = true
        return true
    end

    local regX, regY, regZ = c.x + 0.0, c.y + 0.0, c.z + 0.0
    local probe = FindDoorEntity(model, c)
    if probe ~= 0 then
        local ec = GetEntityCoords(probe)
        if ec then
            local ddx, ddy, ddz = ec.x - regX, ec.y - regY, ec.z - regZ
            local d = math.sqrt((ddx * ddx) + (ddy * ddy) + (ddz * ddz))
            if d <= REGISTER_USE_ENTITY_ANCHOR_IF_WITHIN_M and d > 0.02 then
                regX, regY, regZ = ec.x + 0.0, ec.y + 0.0, ec.z + 0.0
            end
        end
    end

    AddDoorToSystem(doorHash, model, regX, regY, regZ, false, false, false)

    local regOk = false
    local deadline = GetGameTimer() + 450
    while GetGameTimer() < deadline do
        if IsDoorRegisteredWithSystem then
            local ok, known = pcall(IsDoorRegisteredWithSystem, doorHash)
            if ok and known then regOk = true break end
        end
        if DoorSystemKnowsDoor(doorHash) then regOk = true break end
        Wait(10)
    end
    if not regOk then return false end

    if DoorSystemSetAutomaticRate then
        pcall(DoorSystemSetAutomaticRate, doorHash, DOOR_AUTOMATIC_RATE, false, false)
    end
    if DoorSystemSetAutomaticDistance then
        pcall(DoorSystemSetAutomaticDistance, doorHash, DOOR_AUTOMATIC_DISTANCE_M, false, false)
    end

    registered[pk][idx] = true
    return true
end

local function RestoreDoorSystemMotion(doorHash)
    if not doorHash then return end
    if DoorSystemSetAutomaticRate then
        pcall(DoorSystemSetAutomaticRate, doorHash, DOOR_AUTOMATIC_RATE, false, false)
    end
    if DoorSystemSetAutomaticDistance then
        pcall(DoorSystemSetAutomaticDistance, doorHash, DOOR_AUTOMATIC_DISTANCE_M, false, false)
    end
end

local function SnapAndFreezeDoor(pitchId, i, def, isReapply)
    local key = tostring(pitchId) .. ":" .. tostring(i)

    if isReapply then
        local existingEnt = frozenByKey[key]
        if existingEnt and existingEnt ~= 0 and DoesEntityExist(existingEnt) and IsEntityPositionFrozen(existingEnt) then
            return true
        end
    end

    local model = ResolveDoorModelHash(def.model)
    local tx, ty, tz, heading = GetDoorClosedPivot(pitchId, i, def)
    if model == 0 or tx == nil or ty == nil or tz == nil then return false end

    local ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS)
    if ent == 0 then
        print(("[seoul_soccer:doors] Kapi #%d KILITLENEMEDI — prop bulunamadi. soccer_doorcapture closed ile closedCoords ayarla."):format(i))
        return false
    end

    if NetworkGetEntityIsNetworked and NetworkGetEntityIsNetworked(ent) then
        RequestDoorEntityControl(ent, 420)
    end
    SetEntityVelocity(ent, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0) end

    local ec = GetEntityCoords(ent)
    local snapOk = false
    if ec then
        local dx, dy, dz = ec.x - tx, ec.y - ty, ec.z - tz
        local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
        local maxSnap = tonumber(def.maxSnapDistance) or MAX_DOOR_SNAP_DISTANCE_M
        if maxSnap < 1.5 then maxSnap = 1.5 end
        if dist <= maxSnap then
            snapOk = true
        else
            print(("[seoul_soccer:doors] Kapi #%d KILIT — prop ile closedCoords arasi %.2fm (>%sm); koordinat snap ATLANDI, sadece dondur. soccer_doorshow / soccer_doorcapture ile pivotu dogrula."):format(
                i, dist, maxSnap
            ))
        end
    end

    if snapOk then
        ApplyEntityPivot(ent, tx, ty, tz, heading)
    end

    FreezeEntityPosition(ent, true)
    if SetEntityCollision then SetEntityCollision(ent, true, true) end

    frozenByKey[key] = ent
    unlockedByKey[key] = nil
    dbg("  door#%d LOCK+SNAP ent=%d at %.2f,%.2f,%.2f", i, ent, tx, ty, tz)
    return true
end

local function UnfreezeDoor(pitchId, i, def)
    local key = tostring(pitchId) .. ":" .. tostring(i)

    if unlockedByKey[key] then return end

    local ent = frozenByKey[key]
    if (not ent or ent == 0 or not DoesEntityExist(ent)) and def then
        ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS_WIDE)
    end
    if ent and ent ~= 0 then
        local ox, oy, oz, oHeading = GetDoorOpenPivot(pitchId, i, def)
        local hasOpenTarget = ox ~= nil
        UnfreezeDoorEntity(ent, hasOpenTarget)
        if hasOpenTarget then
            ApplyEntityPivot(ent, ox, oy, oz, oHeading)
            dbg("  door#%d UNLOCK+OPEN ent=%d", i, ent)
        else
            dbg("  door#%d UNLOCK (openCoords/openOffset yok, fizik devre disi) ent=%d", i, ent)
        end
    end
    frozenByKey[key] = nil
    unlockedByKey[key] = true
end

local function ApplyPropDoorLock(pitchId, i, def, locked, isReapply)
    if locked then
        SnapAndFreezeDoor(pitchId, i, def, isReapply)
    else
        UnfreezeDoor(pitchId, i, def)
    end
end

local function ApplyDoorSystemLock(pitchId, i, def, locked)
    local ok = EnsureDoorRegistered(pitchId, i, def)
    local doorHash = GetDoorHash(pitchId, i)
    local model = ResolveDoorModelHash(def.model)
    local c = GetDoorSearchCoords(def)

    if locked then
        if ok then DoorSystemSetDoorState(doorHash, 1, false, false) end
        NativeLockClosestDoor(model, c)
        -- Prop snap + DoorSystem ayni entity uzerinde carpisir; menteseli kapida "kaybolma" / ziplama yapar.
        -- Sadece DoorSystem + native kilit yeterli.
    else
        UnfreezeDoor(pitchId, i, def)
        if ok then
            DoorSystemSetDoorState(doorHash, 0, false, false)
            RestoreDoorSystemMotion(doorHash)
        end
        NativeUnlockClosestDoor(model, c)
    end
end

local function AnyPitchDoorLocked(locks)
    if type(locks) ~= "table" then return false end
    for _, v in pairs(locks) do
        if v == true then return true end
    end
    return false
end

local function ApplyPitchDoorLocks(pitchId, locks, isReapply)
    local pitch = GetPitchById(pitchId)
    local entries = GetPitchDoorEntries(pitch)
    dbg("ApplyPitchDoorLocks pitchId=%s entries=%d", tostring(pitchId), #entries)
    for i, def in ipairs(entries) do
        local locked = locks and locks[i] == true
        if DoorUsesDoorSystem(def) then
            ApplyDoorSystemLock(pitchId, i, def, locked)
        else
            ApplyPropDoorLock(pitchId, i, def, locked, isReapply)
        end
    end
end

RegisterNetEvent("seoul_soccer:client:ApplyPitchDoorLocks", function(pitchId, locks)
    if pitchId == nil then return end
    appliedByPitch[tostring(pitchId)] = { pitchId = pitchId, locks = locks or {} }
    ApplyPitchDoorLocks(pitchId, locks)
end)

RegisterNetEvent("seoul_soccer:client:ReleaseAllPitchDoors", function()
    ReleaseAllPitchDoors()
end)

RegisterNetEvent("seoul_soccer:client:PitchDoorLocksNui", function(lobbyId, locks)
    SendNUIMessage({
        action = "pitchDoorLocks",
        data = {
            lobbyId = tonumber(lobbyId) or lobbyId,
            locks = locks or {},
        },
    })
end)

-- Restart sonrasi once temizle, sonra sunucudan guncel kilit durumunu al.
CreateThread(function()
    Wait(800)
    ReleaseAllPitchDoors()
    Wait(400)
    TriggerServerEvent("seoul_soccer:server:RequestPitchDoorState")
end)

CreateThread(function()
    while true do
        local anyActive = false
        for _, entry in pairs(appliedByPitch) do
            if entry and entry.pitchId ~= nil and AnyPitchDoorLocked(entry.locks) then
                anyActive = true
                break
            end
        end
        if anyActive then
            Wait(REAPPLY_LOCKED_MS)
            for _, entry in pairs(appliedByPitch) do
                if entry and entry.pitchId ~= nil and AnyPitchDoorLocked(entry.locks) then
                    ApplyPitchDoorLocks(entry.pitchId, entry.locks, true)
                end
            end
        else
            Wait(5000)
        end
    end
end)

local function FindNearestConfiguredDoor()
    local ped = PlayerPedId()
    local pc = GetEntityCoords(ped)
    local bestPitch, bestIdx, bestDef, bestDist = nil, nil, nil, 9e9
    for _, pitch in ipairs(Config.Pitches or {}) do
        for i, def in ipairs(GetPitchDoorEntries(pitch)) do
            local c = GetDoorSearchCoords(def)
            if not c then goto continue_near end
            local dx, dy, dz = pc.x - c.x, pc.y - c.y, pc.z - c.z
            local d2 = (dx * dx) + (dy * dy) + (dz * dz)
            if d2 < bestDist then
                bestDist = d2
                bestPitch = pitch
                bestIdx = i
                bestDef = def
            end
            ::continue_near::
        end
    end
    return bestPitch, bestIdx, bestDef, math.sqrt(bestDist)
end

--- Kapinin su anki prop konumunu config satiri olarak yaz (F8).
--- 1) Panel tam KAPALI iken: soccer_doorcapture closed
--- 2) Panel tam ACIK iken: soccer_doorcapture open
if Config.Debug == true then
RegisterCommand("soccer_doorcapture", function(_, args)
    local mode = string.lower(tostring(args[1] or "closed"))
    local pitch, idx, def, dist = FindNearestConfiguredDoor()
    if not pitch or not def then
        print("[seoul_soccer:doors] Yakin config kapisi yok.")
        return
    end
    if dist > 25.0 then
        print(("[seoul_soccer:doors] Cok uzaksin (%.1fm). Kapinin yanina gel."):format(dist))
        return
    end
    local ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS_WIDE)
    if ent == 0 then
        print("[seoul_soccer:doors] Prop bulunamadi — model/coords kontrol et.")
        return
    end
    local ec = GetEntityCoords(ent)
    local h = GetEntityHeading(ent)
    local label = GetLocalizedDoorLabel(pitch, def, idx)
    print(("[seoul_soccer:doors] %s (%s) pitch=%s #%d — config.lua doors[] icine kopyala:"):format(
        label, mode, tostring(pitch.id), idx
    ))
    if mode == "open" then
        print(("  openCoords = vector3(%.6f, %.6f, %.6f),"):format(ec.x, ec.y, ec.z))
        print(("  openHeading = %.4f,"):format(h))
    else
        print(("  coords = vector3(%.6f, %.6f, %.6f), -- arama"):format(ec.x, ec.y, ec.z))
        print(("  closedCoords = vector3(%.6f, %.6f, %.6f),"):format(ec.x, ec.y, ec.z))
        print(("  closedHeading = %.4f,"):format(h))
    end
end, false)

RegisterCommand("soccer_doornudge", function(_, args)
    local dx, dy = tonumber(args[1]), tonumber(args[2])
    local dz = tonumber(args[3]) or 0.0
    if dx == nil or dy == nil then return end
    local pitch, idx, def = FindNearestConfiguredDoor()
    if not pitch or not def then return end
    AddRuntimeOffset(pitch.id, idx, dx, dy, dz)
    SnapAndFreezeDoor(pitch.id, idx, def)
end, false)

RegisterCommand("soccer_doorreset", function()
    local pitch, idx, def = FindNearestConfiguredDoor()
    if not pitch or not def then return end
    ClearRuntimeOffset(pitch.id, idx)
    SnapAndFreezeDoor(pitch.id, idx, def)
end, false)

RegisterCommand("soccer_doorrepair", function()
    local pitch, _, _, dist = FindNearestConfiguredDoor()
    if not pitch or dist > 85.0 then
        print("[seoul_soccer:doors] Yakin saha kapisi yok.")
        return
    end
    for i, d in ipairs(GetPitchDoorEntries(pitch)) do
        local tx, ty, tz, heading = GetDoorClosedPivot(pitch.id, i, d)
        if tx then
            local ent = FindDoorEntityForDef(d, REPAIR_STRAY_FIND_RADIUS_M)
            if ent ~= 0 then ApplyEntityPivot(ent, tx, ty, tz, heading) end
        end
    end
    print(("[seoul_soccer:doors] %s pivot onarimi."):format(tostring(pitch.id)))
end, false)

RegisterCommand("soccer_doorshow", function()
    local pitch, idx, def, dist = FindNearestConfiguredDoor()
    if not pitch or not def then
        print("[seoul_soccer:doors] Yakin kapı yok.")
        return
    end
    local model = ResolveDoorModelHash(def.model)
    local ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS_WIDE)
    local ec = (ent ~= 0) and GetEntityCoords(ent) or nil
    print(("[seoul_soccer:doors] pitch=%s #%d dist=%.1f mode=%s entity=%s"):format(
        tostring(pitch.id), idx, dist,
        DoorUsesDoorSystem(def) and "doorsystem" or "prop",
        (ent ~= 0) and tostring(ent) or "NONE — coords/model kontrol et"
    ))
    if ec then
        local cx, cy, cz, ch = GetDoorClosedPivot(pitch.id, idx, def)
        local dx = ec.x - (cx or ec.x)
        local dy = ec.y - (cy or ec.y)
        local dz = ec.z - (cz or ec.z)
        local distPivot = math.sqrt(dx * dx + dy * dy + dz * dz)
        print(("[seoul_soccer:doors]   prop now: %.3f %.3f %.3f h=%.2f | closedCfg sapma: %.3fm"):format(
            ec.x, ec.y, ec.z, GetEntityHeading(ent), distPivot
        ))
        if distPivot > 0.35 then
            print("[seoul_soccer:doors]   ^ sapma buyuk — soccer_doorcapture closed calistir")
        end
    end
end, false)

RegisterCommand("soccer_doordiag", function()
    for _, pitch in ipairs(Config.Pitches or {}) do
        local entries = GetPitchDoorEntries(pitch)
        if #entries > 0 then
            print(("[seoul_soccer:doors] pitch=%s doors=%d"):format(tostring(pitch.id), #entries))
            for i, def in ipairs(entries) do
                local ent = FindDoorEntityForDef(def, DOOR_FIND_RADIUS_WIDE)
                print(("  #%d mode=%s entity=%s"):format(
                    i, DoorUsesDoorSystem(def) and "doorsystem" or "prop",
                    ent ~= 0 and tostring(ent) or "MISSING"
                ))
            end
        end
    end
end, false)

end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    ReleaseAllPitchDoors()
end)
