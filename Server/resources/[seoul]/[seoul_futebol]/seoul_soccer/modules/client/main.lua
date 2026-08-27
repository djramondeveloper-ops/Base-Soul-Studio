-- GoalShared shared script'ten gelmeli; bazi FiveM ortamlarinda global gorulmuyor.
-- Fallback: goals.lua yuklenemediyse ayni fonksiyonlari burada tanimla.
if not GoalShared then
    GoalShared = {}
    GoalShared.NormalizeGoalEntry = function(g)
        if not g then return nil end
        if g.min and g.max then
            return { min = g.min, max = g.max, scoringTeam = g.scoringTeam, side = g.side }
        end
        if g.center then
            local c  = g.center
            local hx, hy, hz
            if g.halfExtents then
                hx = math.abs(tonumber(g.halfExtents.x) or 2.5)
                hy = math.abs(tonumber(g.halfExtents.y) or 2.5)
                hz = math.abs(tonumber(g.halfExtents.z) or 2.5)
            else
                local r = math.abs(tonumber(g.radius) or 3.0)
                hx, hy, hz = r, r, r
            end
            return {
                min = vector3(c.x - hx, c.y - hy, c.z - hz),
                max = vector3(c.x + hx, c.y + hy, c.z + hz),
                scoringTeam = g.scoringTeam,
                side = g.side,
            }
        end
        return nil
    end
    GoalShared.ExpandedAabbBounds = function(box, noAirZ)
        if not box or not box.min or not box.max then return nil end
        local mn, mx = box.min, box.max
        local gd = Config.GoalDetection or {}
        local minX, maxX = math.min(mn.x, mx.x), math.max(mn.x, mx.x)
        local minY, maxY = math.min(mn.y, mx.y), math.max(mn.y, mx.y)
        local minZ, maxZ = math.min(mn.z, mx.z), math.max(mn.z, mx.z)
        if gd.StrictGoalBounds == true then
            if not noAirZ then
                local airZ0 = tonumber(gd.GoalAirZHeadroomM)
                if airZ0 and airZ0 > 0 then maxZ = maxZ + airZ0 end
            end
            return minX, maxX, minY, maxY, minZ, maxZ
        end
        local zMinThick = tonumber(gd.ZSlabMinThickness) or 0.45
        local zHalfExp  = tonumber(gd.ZSlabHalfHeight)   or 2.75
        if (maxZ - minZ) < zMinThick then
            local mid = (minZ + maxZ) * 0.5
            minZ, maxZ = mid - zHalfExp, mid + zHalfExp
        end
        local xyPad  = tonumber(gd.XYEdgePadding) or 0.9
        local minSpan = tonumber(gd.XYMinSpan)    or 1.35
        if (maxX - minX) < minSpan then
            local cx = (minX + maxX) * 0.5
            local half = minSpan * 0.5 + xyPad
            minX, maxX = cx - half, cx + half
        end
        if (maxY - minY) < minSpan then
            local cy = (minY + maxY) * 0.5
            local half = minSpan * 0.5 + xyPad
            minY, maxY = cy - half, cy + half
        end
        if not noAirZ then
            local airZ1 = tonumber(gd.GoalAirZHeadroomM)
            if airZ1 and airZ1 > 0 then maxZ = maxZ + airZ1 end
        end
        return minX, maxX, minY, maxY, minZ, maxZ
    end
    GoalShared.PointInGoalBox = function(pos, box)
        if not pos then return false end
        local minX, maxX, minY, maxY, minZ, maxZ = GoalShared.ExpandedAabbBounds(box)
        if not minX then return false end
        return pos.x >= minX and pos.x <= maxX
           and pos.y >= minY and pos.y <= maxY
           and pos.z >= minZ and pos.z <= maxZ
    end
    local function mouthSegmentFromBoxEdgeXY_fb(box, ux, uy, extendEach)
        if not box or not box.min or not box.max then return nil end
        -- noAirZ=true: kale agzi geometrisi; Z headroom burada yaniltici
        local minX, maxX, minY, maxY, minZ, maxZ = GoalShared.ExpandedAabbBounds(box, true)
        if not minX then return nil end
        local ulen = math.sqrt((ux or 0) * (ux or 0) + (uy or 0) * (uy or 0))
        if ulen < 0.001 then return nil end
        ux, uy = ux / ulen, uy / ulen
        local ax, ay, bx, by
        if math.abs(ux) >= math.abs(uy) then
            local fx = (ux > 0) and minX or maxX
            ax, ay, bx, by = fx, minY, fx, maxY
        else
            local fy = (uy > 0) and minY or maxY
            ax, ay, bx, by = minX, fy, maxX, fy
        end
        local dx, dy = bx - ax, by - ay
        local span = math.sqrt(dx * dx + dy * dy)
        if span < 0.03 then return nil end
        local ext = tonumber(extendEach) or 0
        if ext > 0 then
            local ex = (dx / span) * ext
            local ey = (dy / span) * ext
            ax, ay = ax - ex, ay - ey
            bx, by = bx + ex, by + ey
        end
        return ax, ay, bx, by, (minZ + maxZ) * 0.5
    end
    GoalShared.ResolveScoringLine = function(pitch, raw, box)
        if not pitch or not pitch.coords then return nil end
        local gd = Config.GoalDetection or {}
        if raw and raw.goalLine and raw.goalLine.from and raw.goalLine.to and raw.goalLine.inside then
            local f, t, ins = raw.goalLine.from, raw.goalLine.to, raw.goalLine.inside
            local extEach = tonumber(raw.goalLineExtendEachSideM)
            if extEach == nil then extEach = tonumber(gd.GoalLineExplicitExtendEachSideM) end
            if extEach == nil then extEach = tonumber(gd.GoalLineMouthExtendEachSideM) end
            extEach = extEach or 0
            local dx, dy = t.x - f.x, t.y - f.y
            local span = math.sqrt(dx * dx + dy * dy)
            local ax, ay, az, bx, by, bz = f.x, f.y, f.z, t.x, t.y, t.z
            if span > 1e-4 and extEach > 0 then
                local ex = (dx / span) * extEach
                local ey = (dy / span) * extEach
                ax, ay = f.x - ex, f.y - ey
                bx, by = t.x + ex, t.y + ey
            end
            return { ax = ax, ay = ay, az = az, bx = bx, by = by, bz = bz, ix = ins.x, iy = ins.y, iz = ins.z }
        end
        if gd.UsePitchBasedGoalLine ~= true or (raw and raw.skipPastPlane == true) then return nil end
        local gx, gy, gz
        if raw and raw.center then
            gx, gy, gz = raw.center.x, raw.center.y, raw.center.z
        elseif box and box.min and box.max then
            gx = (box.min.x + box.max.x) * 0.5
            gy = (box.min.y + box.max.y) * 0.5
            gz = (box.min.z + box.max.z) * 0.5
        else return nil end
        local cx, cy = pitch.coords.x, pitch.coords.y
        local vdx, vdy = gx - cx, gy - cy
        local len = math.sqrt((vdx * vdx) + (vdy * vdy))
        if len < 0.25 then return nil end
        local ux, uy = vdx / len, vdy / len
        local tx, ty = -uy, ux
        local mouthExt = tonumber(raw and raw.goalLineMouthExtendEachSideM)
            or tonumber(gd.GoalLineMouthExtendEachSideM) or 0
        local ax, ay, az, bx, by, bz
        local usedBoxMouth = false
        if gd.GoalLineUseBoxMouthEdge ~= false and box and box.min and box.max then
            local mx1, my1, mx2, my2, zm = mouthSegmentFromBoxEdgeXY_fb(box, ux, uy, mouthExt)
            if mx1 then
                ax, ay, bx, by, az, bz = mx1, my1, mx2, my2, zm, zm
                usedBoxMouth = true
            end
        end
        if not usedBoxMouth then
            local back = tonumber(gd.AutoGoalLineBackFromCenter) or 2.88
            local hw = tonumber(raw and raw.goalLineHalfWidth) or tonumber(gd.AutoGoalLineHalfWidth) or 2.05
            local hy = (raw and raw.halfExtents) and math.abs(tonumber(raw.halfExtents.y) or 0) or 0
            if hy > 0.35 then hw = math.min(hw, hy * 0.98) end
            local mx = gx - ux * back
            local my = gy - uy * back
            ax = mx + tx * (-hw)
            ay = my + ty * (-hw)
            az = gz
            bx = mx + tx * hw
            by = my + ty * hw
            bz = gz
        end
        local deep = tonumber(gd.AutoGoalLineInsideDepth) or 0.48
        return { ax = ax, ay = ay, az = az, bx = bx, by = by, bz = bz, ix = gx + ux * deep, iy = gy + uy * deep, iz = gz }
    end
    GoalShared.IsBallPastGoalScoringLine = function(pitch, raw, pos, box)
        if not pos then return true end
        local line = GoalShared.ResolveScoringLine(pitch, raw, box)
        if not line then return GoalShared.IsPastGoalMouthPlane(pitch, raw, pos, box) end
        local mx = (line.ax + line.bx) * 0.5
        local my = (line.ay + line.by) * 0.5
        local lax, lay = line.bx - line.ax, line.by - line.ay
        local llen = math.sqrt((lax * lax) + (lay * lay))
        if llen < 0.05 then return true end
        local wx, wy = lax / llen, lay / llen
        local n1x, n1y = -wy, wx
        local n2x, n2y = wy, -wx
        local dotIn = (line.ix - mx) * n1x + (line.iy - my) * n1y
        local nx, ny = n1x, n1y
        if dotIn < 0 then nx, ny = n2x, n2y end
        local gd = Config.GoalDetection or {}
        local minAdv = tonumber(gd.GoalLineMinAdvance) or 0.24
        if box then
            -- noAirZ=true: gerçek kale Z siniri; headroom dahil olursa band hesabi kayar
            local _, _, _, _, zLo, zHi = GoalShared.ExpandedAabbBounds(box, true)
            local span = (zLo and zHi) and (zHi - zLo) or 0
            local frac = tonumber(gd.GoalLineAirZBandFraction)
            if span > 0.15 and frac and frac > 0 and frac < 1 and pos.z >= zLo + span * frac then
                local airAdv = tonumber(gd.GoalLineMinAdvanceAir)
                if airAdv == nil then airAdv = 0.08 end
                minAdv = math.min(minAdv, airAdv)
            end
        end
        return (((pos.x - mx) * nx) + ((pos.y - my) * ny)) >= minAdv
    end
    GoalShared.GetGoalLineDrawSegments = function(pitch)
        local out = {}
        if not pitch or type(pitch.goals) ~= "table" then return out end
        for _, raw in ipairs(pitch.goals) do
            local box = GoalShared.NormalizeGoalEntry(raw)
            local line = GoalShared.ResolveScoringLine(pitch, raw, box)
            if line then
                out[#out + 1] = { from = vector3(line.ax, line.ay, line.az), to = vector3(line.bx, line.by, line.bz) }
            end
        end
        return out
    end
    GoalShared.IsPastGoalMouthPlane = function(pitch, raw, pos, box)
        if not pitch or not pitch.coords or not pos then return true end
        local gd = Config.GoalDetection or {}
        if gd.RequirePastFieldPlane ~= true then return true end
        if raw and raw.skipPastPlane == true then return true end
        local gx, gy
        if raw and raw.center then
            gx, gy = raw.center.x, raw.center.y
        elseif box and box.min and box.max then
            gx = (box.min.x + box.max.x) * 0.5
            gy = (box.min.y + box.max.y) * 0.5
        else
            return true
        end
        local cx, cy = pitch.coords.x, pitch.coords.y
        local vdx, vdy = gx - cx, gy - cy
        local len = math.sqrt((vdx * vdx) + (vdy * vdy))
        if len < 0.25 then return true end
        local ix, iy = vdx / len, vdy / len
        local off = tonumber(gd.GoalMouthOffsetFromCenter) or 1.38
        local mx = gx - ix * off
        local my = gy - iy * off
        local minDot = tonumber(gd.GoalPastPlaneMinDot) or 0.14
        local dot = ((pos.x - mx) * ix) + ((pos.y - my) * iy)
        return dot >= minDot
    end
    GoalShared.FindScoringTeamAtPosition = function(pitch, pos)
        if not pitch or type(pitch.goals) ~= "table" or not pos then return nil end
        for _, raw in ipairs(pitch.goals) do
            local box = GoalShared.NormalizeGoalEntry(raw)
            if box and GoalShared.PointInGoalBox(pos, box) and GoalShared.IsBallPastGoalScoringLine(pitch, raw, pos, box) then
                local st = tonumber(box.scoringTeam)
                if st == 1 or st == 2 then return st end
            end
        end
        return nil
    end
    GoalShared.IsBallInAnyGoalZone = function(pitch, pos)
        return GoalShared.FindScoringTeamAtPosition(pitch, pos) ~= nil
    end
    GoalShared.DebugBallVsGoals = function(pitch, pos)
        if not pitch or not pos then return "pitch veya pos yok" end
        local st = GoalShared.FindScoringTeamAtPosition(pitch, pos)
        local base = ("top: %.2f  %.2f  %.2f"):format(pos.x, pos.y, pos.z)
        if st then return base .. ("  ->  gol takim %d"):format(st) end
        return base .. "  ->  kutuda degil"
    end
end

local isUiOpen  = false
--- NPC menuden acildiysa: lobi pitchId (CreateLobby 'random' yerine)
local lastMenuPitchId = nil
--- Aktif lobi daveti (K/J ile kabul / red)
local pendingLobbyInviteId = nil
local matchData = nil   -- { lobbyId, isHost, keybinds, hostKeys }
local lobbySettingsPanelOpen = false
--- Uniform modulu (formalar). Ilk tanim erken yapilir ki asagidaki callback / event handler'lar
--- tablo referansi uzerinden runtime'da fonksiyonlara erisebilsin.
local Uniform = { Apply = function() end, Remove = function() end, ReapplyIfTeamChanged = function() end }
local isInfoBoxHidden = false
local isScoreboardModalVisible = false
local footballUiDeathClosed = false
--- Shot trail: GoalScored / MatchEnded event'leri bu fonksiyondan once kayitli; forward decl gerekli.
local CancelActiveShotTrailFx
local goalDebugClientToggle = false
--- Host lobi olustururken "envanter + silah cekme" iznini kapatabilir (matchData.allowInventory == false).
--- Aktif mac boyunca oyuncunun invBusy state bag'ini true'ya cekip envanter UI'sini engelleriz.
local inventoryLockedState = false

local function SetInventoryLockedState(locked)
    if inventoryLockedState == locked then return end
    inventoryLockedState = locked
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.set then
        -- ox_inventory / qs-inventory / qb-inventory invBusy state bag'ini dinler.
        pcall(function() LocalPlayer.state:set('invBusy', locked and true or false, true) end)
        pcall(function() LocalPlayer.state:set('invOpen', false, true) end)
    end
end

local goalDebugLastNotify = 0
local ballControl = {
    entity = nil,
    netId = 0,
    owner = 0,
    lastClaimTry = 0,
    lastStealTry = 0,
    lastKick = 0,
    shootHoldStart = nil,
    crossHoldStart = nil,
    chargeUiLastPush = 0,
    pickupLockUntil = 0,
    chargeUiVisible = false,
    chargeUiValue = 0.0,
    chargeUiMode = "shot",
    visibilityNetId = 0,
    lastLodApplyAt = 0,
    entityNetId = 0,
    lastEntityNetCheckAt = 0,
    dribblePrepEntity = 0,
    dribblePrepGuard = false,
    lastDribblePrepAt = 0,
    animLockUntil = 0,
    lastSlideTackle = 0,
    slideActive = false,
    lastTeammateWarn = 0,
    -- Slide miss: ragdoll guard'in ilk stumble frame'ini "ragdoll" say\u0131p derhal kesmesini engeller.
    stumbleUntil = 0,
    -- Slide cooldown HUD'unda "hazir" ping sesi icin tek sefer tetikleyici.
    slidePingPlayed = false,
    -- Stand tackle (E tap, sprint YOK, rakip sahip): ayri cooldown.
    lastStandTackle = 0,
    -- Jockey stance: ne zamandan beri aktif oldugu (ms). 0 = pasif.
    jockeyActiveSince = 0,
    -- Jockey SetPedMoveRateOverride uyguland\u0131 m\u0131 (pasife donerken reset).
    jockeyApplied = false,
    -- Hard slide magduruna kisa sureli ragdoll izni (global anti-ragdoll guard bypass).
    ragdollExemptUntil = 0,
    -- SHIFT + E "basili tut" soft steal sarjinin baslangici (ms). 0 = aktif degil.
    softStealHoldStart = 0,
    -- Charge baslanginda hedeflenen top sahibinin server id'si (owner degisirse charge iptal).
    softStealOwnerAtStart = 0,
    -- Son soft steal iptalinin sebebi -> tek-seferlik notify icin.
    softStealLastCancel = 0,
    -- SHIFT + E ile E-alone stand tackle arasinda key release sirasi kaynakli karisikligi onler.
    lastSprintHeldAt = 0,
    -- SHIFT + E sirasinda hedef oyuncu ile fizik temasindan dogan dusmeyi engelleyen pencere.
    softContactGuardUntil = 0,
    softContactGuardTarget = 0,
    -- Basarili soft steal sonrasi yeni top sahibinin kendi topu/rakibi ile dusmesini engelleyen pencere.
    softPostStealGuardUntil = 0,
    softPostStealTarget = 0,
    softStealInputLockUntil = 0,
    softStealAttemptLockUntil = 0,
    -- Hard slide denemesinde server onayini izlemek icin (aynı slide icinde retry).
    lastHardStealSuccessAt = 0,
    --- Pas/sut/orta aninda dribble mıknatısını (coords + v) gecici kapat; impulsün ezilmesini azaltır.
    dribbleMagnetSuspendedUntil = 0,
    --- Sert kayma bitiminden sonra loose top icin otomatik claim baskisini kes (ms, 0 = kapali).
    postSlideAutoClaimSuppressUntil = 0,
    --- Top owner 0 iken proximity auto-claim baskisi (slide sonrasi OwnerlessMs ile eslenir).
    autoClaimBlockedUntil = 0,
    --- Sahipsiz top: BallOwnerChanged(0) ile baslatilir; LooseBallForceStopAfterMs icin.
    looseSinceGameTimer = nil,
    --- Araca binince top birakildi; ayni oturumda spam onleme.
    vehicleBallDropLatched = false,
}

local goalieControl = {
    interactLockUntil = 0,
    lastRequest = 0,
    holding = false,
    holdTeam = 0,
    holdUntil = 0,
    releaseHoldStart = nil,
    releaseMode = nil,
    ballAttached = false,
    gkAnimRefreshAt = 0,
    holdMeta = nil,
    holdAnim = nil,
}

--- RequestAnimDict + bekleme (erken tanim: satir ~782 kaleci tutma vb. once cagrilir)
local function LoadAnimDict(dict, timeoutMs)
    if not dict or dict == "" then return false end
    if HasAnimDictLoaded(dict) then return true end
    local timeoutAt = GetGameTimer() + (timeoutMs or 1000)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
        if GetGameTimer() > timeoutAt then
            return false
        end
    end
    return true
end

--- RegisterNetEvent'lerden once (lexical scope); vektor3 benzeri .x/.y/.z alanlari
local function DistanceBetween(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
end

local function Distance2D(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return math.sqrt((dx * dx) + (dy * dy))
end

--- Erken RegisterNetEvent (kaleci tutma) icin lexical scope; tanimlari asagida atanıyor
local TryResolveBallEntity
local AttachBallToKeeperHand
local DetachBallFromKeeperHand
local StopBallForGoalkeeperCatch

local function SetSoccerPedRagdollBlocked(ped, blocked)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    local enabled = not blocked
    if SetPedCanRagdoll then
        SetPedCanRagdoll(ped, enabled)
    end
    if SetPedCanRagdollFromPlayerImpact then
        SetPedCanRagdollFromPlayerImpact(ped, enabled)
    end
    if SetPedRagdollOnCollision then
        SetPedRagdollOnCollision(ped, enabled)
    end
    if blocked and ResetPedRagdollTimer then
        ResetPedRagdollTimer(ped)
    end
end

local function IsSoftStealGuardActive()
    local now = GetGameTimer()
    return now < (tonumber(ballControl.softContactGuardUntil) or 0)
        or now < (tonumber(ballControl.softPostStealGuardUntil) or 0)
end

local function SetSoftStealBallCollisionBlocked(ballEnt, blocked)
    if not ballEnt or ballEnt == 0 or not DoesEntityExist(ballEnt) then return end
    if SetEntityNoCollisionEntity then
        local ped = PlayerPedId()
        if ped and ped ~= 0 and DoesEntityExist(ped) then
            SetEntityNoCollisionEntity(ped, ballEnt, true)
            SetEntityNoCollisionEntity(ballEnt, ped, true)
        end
    end
    if SetEntityCollision then
        SetEntityCollision(ballEnt, not blocked, not blocked)
    end
    if SetEntityRecordsCollisions then
        SetEntityRecordsCollisions(ballEnt, not blocked)
    end
end

--- SHIFT+E spam'inde her cagrida ClearPedSecondaryTask locomotion ile carpisip dusme tetikleyebilir.
local softStealLastSecondaryClearAt = 0

local function ClearSoftStealPedTasks()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then return end

    SetSoccerPedRagdollBlocked(ped, true)
    -- Soft steal kosarken calisir; ClearPedTasksImmediately ped'in locomotion task'ini
    -- sert kesip GTA fizik motorunda falling/ragdoll tetikleyebiliyor.
    -- Bu yüzden sadece secondary/upper-body task'i temizle; art arda basimda debounce.
    local now = GetGameTimer()
    if now - softStealLastSecondaryClearAt > 380 then
        softStealLastSecondaryClearAt = now
        ClearPedSecondaryTask(ped)
    end
end

local function StartSoftContactGuard(targetSrc, durationMs)
    targetSrc = tonumber(targetSrc) or 0
    if targetSrc == 0 or targetSrc == GetPlayerServerId(PlayerId()) then return end

    local now = GetGameTimer()
    local untilAt = now + math.max(150, tonumber(durationMs) or 900)
    ballControl.softContactGuardTarget = targetSrc
    ballControl.softContactGuardUntil = math.max(tonumber(ballControl.softContactGuardUntil) or 0, untilAt)

    local ped = PlayerPedId()
    SetSoccerPedRagdollBlocked(ped, true)
    ClearSoftStealPedTasks()
end

local function StartSoftPostStealGuard(targetSrc, durationMs)
    targetSrc = tonumber(targetSrc) or 0
    local now = GetGameTimer()
    local currentTarget = tonumber(ballControl.softPostStealTarget) or 0
    local currentUntil = tonumber(ballControl.softPostStealGuardUntil) or 0
    if targetSrc == 0 then
        targetSrc = currentTarget
    end
    local alreadyActive = targetSrc ~= 0 and targetSrc == currentTarget and now < currentUntil
    local untilAt = now + math.max(250, tonumber(durationMs) or 2500)
    ballControl.softPostStealGuardUntil = math.max(currentUntil, untilAt)
    local softCfg = ((Config.StealSystem or {}).SoftSteal or {})
    local inputLockMs = tonumber(softCfg.InputLockMs) or 350
    if not alreadyActive then
        ballControl.softStealInputLockUntil = math.max(tonumber(ballControl.softStealInputLockUntil) or 0, now + math.max(0, inputLockMs))
    end
    if targetSrc ~= 0 and targetSrc ~= GetPlayerServerId(PlayerId()) then
        ballControl.softPostStealTarget = targetSrc
    end

    local ped = PlayerPedId()
    SetSoccerPedRagdollBlocked(ped, true)
    -- Kosarken momentumu aniden sifirlamak (ozellikle SHIFT+E spam'i) GTA'da trip/fall uretir; sadece zaten bozuksa duzelt.
    if DoesEntityExist(ped) and not alreadyActive and (IsPedRagdoll(ped) or (IsPedFalling and IsPedFalling(ped))) then
        if ResetPedRagdollTimer then
            ResetPedRagdollTimer(ped)
        end
        ClearPedSecondaryTask(ped)
        SetSoccerPedRagdollBlocked(ped, true)
    end
    if DoesEntityExist(ped) and SetEntityNoCollisionEntity then
        local ballEnt = TryResolveBallEntity and TryResolveBallEntity() or nil
        if ballEnt and ballEnt ~= 0 and DoesEntityExist(ballEnt) then
            SetSoftStealBallCollisionBlocked(ballEnt, true)
            SetEntityNoCollisionEntity(ped, ballEnt, true)
            SetEntityNoCollisionEntity(ballEnt, ped, true)
        end
        if targetSrc ~= 0 then
            local targetPly = GetPlayerFromServerId(targetSrc)
            if targetPly ~= -1 then
                local targetPed = GetPlayerPed(targetPly)
                if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
                    SetEntityNoCollisionEntity(ped, targetPed, true)
                    SetEntityNoCollisionEntity(targetPed, ped, true)
                end
            end
        end
    end
end

local function ResetBallControl()
    ballControl.entity = nil
    ballControl.netId = 0
    ballControl.owner = 0
    ballControl.lastClaimTry = 0
    ballControl.lastStealTry = 0
    ballControl.lastKick = 0
    ballControl.shootHoldStart = nil
    ballControl.crossHoldStart = nil
    ballControl.chargeUiLastPush = 0
    ballControl.pickupLockUntil = 0
    ballControl.chargeUiVisible = false
    ballControl.chargeUiValue = 0.0
    ballControl.chargeUiMode = "shot"
    ballControl.visibilityNetId = 0
    ballControl.stumbleUntil = 0
    ballControl.slidePingPlayed = false
    ballControl.lastStandTackle = 0
    ballControl.jockeyActiveSince = 0
    ballControl.jockeyApplied = false
    ballControl.lastLodApplyAt = 0
    ballControl.animLockUntil = 0
    ballControl.lastSlideTackle = 0
    ballControl.slideActive = false
    ballControl.lastTeammateWarn = 0
    ballControl.softStealHoldStart = 0
    ballControl.softStealOwnerAtStart = 0
    ballControl.softStealLastCancel = 0
    ballControl.lastSprintHeldAt = 0
    ballControl.softContactGuardUntil = 0
    ballControl.softContactGuardTarget = 0
    ballControl.softPostStealGuardUntil = 0
    ballControl.softPostStealTarget = 0
    ballControl.softStealInputLockUntil = 0
    ballControl.softStealAttemptLockUntil = 0
    ballControl.lastHardStealSuccessAt = 0
    ballControl.ragdollExemptUntil = 0
    ballControl.dribbleMagnetSuspendedUntil = 0
    ballControl.postSlideAutoClaimSuppressUntil = 0
    ballControl.autoClaimBlockedUntil = 0
    ballControl.looseSinceGameTimer = nil
    ballControl.vehicleBallDropLatched = false
    goalieControl.interactLockUntil = 0
    goalieControl.lastRequest = 0
    goalieControl.holding = false
    goalieControl.holdTeam = 0
    goalieControl.holdUntil = 0
    goalieControl.releaseHoldStart = nil
    goalieControl.releaseMode = nil
    goalieControl.gkAnimRefreshAt = 0
    goalieControl.holdMeta = nil
    goalieControl.holdAnim = nil
    if goalieControl.ballAttached then
        local ent = ballControl.entity
        if ent and ent ~= 0 and DoesEntityExist(ent) then
            DetachEntity(ent, true, false)
            SetEntityDynamic(ent, true)
            if SetEntityCollision then SetEntityCollision(ent, true, true) end
            ActivatePhysics(ent)
        end
        goalieControl.ballAttached = false
    end
    pcall(ClearPedSecondaryTask, PlayerPedId())
end

local function SetShotChargeUI(visible, value, mode)
    local normalized = math.max(0.0, math.min(1.0, value or 0.0))
    mode = mode or "shot"
    if visible and ballControl.chargeUiVisible == visible then
        if ballControl.chargeUiMode == mode and math.abs((ballControl.chargeUiValue or 0.0) - normalized) < 0.01 then return end
    end

    ballControl.chargeUiVisible = visible
    ballControl.chargeUiValue = normalized
    ballControl.chargeUiMode = mode

    SendNUIMessage({
        action = "shotCharge",
        data = {
            visible = visible,
            value = normalized,
            mode = mode
        }
    })
end

-- ─────────────────────────────────────────────
-- Menü Aç/Kapat
-- ─────────────────────────────────────────────
if Config.Commands and type(Config.Commands.OpenMenu) == "string" and Config.Commands.OpenMenu ~= "" then
    RegisterCommand(Config.Commands.OpenMenu, function()
        ToggleUI(not isUiOpen)
    end, false)
end

if Config.Commands.GoalDebugToggle then
    RegisterCommand(Config.Commands.GoalDebugToggle, function()
        goalDebugClientToggle = not goalDebugClientToggle
        Bridge.Notify(
            goalDebugClientToggle and L("client.goal_debug_on") or L("client.goal_debug_off"),
            "inform",
            4000
        )
    end, false)
end

function ToggleUI(state, pitchId)
    if not state then
        StopJerseyPreviewCamera()
    end
    isUiOpen = state
    if state then
        lastMenuPitchId = pitchId or nil
    else
        lastMenuPitchId = nil
    end
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = "initLocale",
        data   = GetNuiLocalePayload()
    })
    SendNUIMessage({
        action = "setVisible",
        data   = state
    })
    SendNUIMessage({
        action = "setMenuPitch",
        data   = state and pitchId or nil
    })
    if state then
        SendNUIMessage({
            action = "setMyId",
            data   = GetPlayerServerId(PlayerId())
        })
        TriggerServerEvent('seoul_soccer:server:RequestLobbies')
    end
end

RegisterNetEvent('seoul_soccer:client:LobbyMenuLiveTick', function(payload)
    if type(payload) ~= "table" then return end
    SendNUIMessage({
        action = "lobbyLiveTick",
        data   = payload
    })
end)

--- Gol sevinci: prompt (Y/N, focus yok) -> picker (SetNuiFocus + tikla).
local goalCelebrationState = nil -- nil | "prompt" | "picker"

local function ClearGoalCelebrationUi()
    goalCelebrationState = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeGoalCelebrationPrompt' })
    SendNUIMessage({ action = 'closeGoalCelebrationPicker' })
end

local function HideFootballUiBecauseDead()
    if isUiOpen then
        ToggleUI(false)
    end

    lobbySettingsPanelOpen = false
    isScoreboardModalVisible = false
    SetShotChargeUI(false, 0.0)
    ClearGoalCelebrationUi()
    SetNuiFocus(false, false)

    SendNUIMessage({ action = "hideFootballUiOnDeath" })
    SendNUIMessage({ action = "toggleMatchScoreboard", data = { visible = false } })
    SendNUIMessage({ action = "toggleLobbySettingsPanel", data = { open = false } })
end

local function StartGoalCelebrationTimeoutWatch(expectedState, durationMs)
    durationMs = math.max(1200, tonumber(durationMs) or 6000)
    CreateThread(function()
        local deadline = GetGameTimer() + durationMs
        while goalCelebrationState == expectedState and GetGameTimer() < deadline do
            Wait(120)
        end
        if goalCelebrationState == expectedState then
            ClearGoalCelebrationUi()
        end
    end)
end

local function OpenGoalCelebrationPrompt(timeoutMs)
    local gc = Config.GoalCelebration or {}
    goalCelebrationState = 'prompt'
    SendNUIMessage({
        action = 'initLocale',
        data   = GetNuiLocalePayload(),
    })
    SendNUIMessage({
        action = 'showGoalCelebrationPrompt',
        data = {
            timeoutMs = timeoutMs,
            acceptKey = tostring(gc.AcceptKeyLabel or 'Y'),
            declineKey = tostring(gc.DeclineKeyLabel or 'N'),
        },
    })
    StartGoalCelebrationTimeoutWatch('prompt', timeoutMs)
end

local function OpenGoalCelebrationPicker(timeoutMs)
    goalCelebrationState = 'picker'
    SendNUIMessage({ action = 'closeGoalCelebrationPrompt' })
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openGoalCelebrationPicker',
        data = { timeoutMs = timeoutMs },
    })
    StartGoalCelebrationTimeoutWatch('picker', timeoutMs)
end

--- NUI'den secilen gol sevinci (senaryo / kisa anim). FinishGoalCelebrationPick'ten once tanimlanmali.
local FLIP_CELEBRATION_ANIMS = {
    -- rpemotes / dpemotes "flip" — yerde on takla
    { dict = 'anim@arena@celeb@flat@solo@no_props@', clip = 'flip_a_player_a' },
    -- "flip2" — cartwheel / cap flip
    { dict = 'anim@arena@celeb@flat@solo@no_props@', clip = 'cap_a_player_a' },
}

--- Gol sevinci "wave": rcmfanatic1/celebrate bircok clientta yok veya clip hatali; el sallama animleri.
local WAVE_CELEBRATION_ANIMS = {
    { dict = 'friends@frj@ig_1', clip = 'wave_a', flags = 49 },
    { dict = 'friends@frj@ig_1', clip = 'wave_b', flags = 49 },
}

local function PlayCelebrationAnim(ped, dict, anim, durMs, playMs, animFlags)
    if not LoadAnimDict(dict, 2200) or not HasAnimDictLoaded(dict) then
        return false, durMs
    end
    playMs = playMs or -1
    animFlags = tonumber(animFlags)
    if animFlags == nil then animFlags = 0 end
    TaskPlayAnim(ped, dict, anim, 4.0, -4.0, playMs, animFlags, 0.0, false, false, false)
    local waitMs = durMs
    if (not waitMs or waitMs <= 0) and GetAnimDuration then
        local ok, durSec = pcall(GetAnimDuration, dict, anim)
        if ok and durSec and durSec > 0.15 then
            waitMs = math.floor((durSec * 1000) + 400)
        end
    end
    if not waitMs or waitMs < 2200 then
        waitMs = durMs or 5200
    end
    return true, waitMs
end

local function PlayFlipCelebration(ped, fallbackDurMs, cfgFlipDurMs)
    fallbackDurMs = math.max(2800, tonumber(fallbackDurMs) or 5200)
    local fixedMs = tonumber(cfgFlipDurMs) or 0
    for i = 1, #FLIP_CELEBRATION_ANIMS do
        local entry = FLIP_CELEBRATION_ANIMS[i]
        local dict, clip = entry.dict, entry.clip
        local targetWait = fixedMs > 0 and fixedMs or fallbackDurMs
        local ok, waitMs = PlayCelebrationAnim(ped, dict, clip, targetWait, -1, 0)
        if ok then
            return true, waitMs
        end
    end
    return false, fallbackDurMs
end

local function PlayWaveCelebration(ped, fallbackDurMs)
    fallbackDurMs = math.max(2200, tonumber(fallbackDurMs) or 5200)
    for i = 1, #WAVE_CELEBRATION_ANIMS do
        local entry = WAVE_CELEBRATION_ANIMS[i]
        local dict, clip = entry.dict, entry.clip
        local flags = tonumber(entry.flags) or 49
        local ok, waitMs = PlayCelebrationAnim(ped, dict, clip, fallbackDurMs, -1, flags)
        if ok then
            return true, waitMs
        end
    end
    return false, fallbackDurMs
end

local function PlayGoalCelebrationChoice(id)
    id = tostring(id or '')
    if id == '' or id == 'skip' then return end
    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    local gc = Config.GoalCelebration or {}
    local dur = math.max(2200, math.min(15000, tonumber(gc.AnimDurationMs) or 5200))

    if ClearPedSecondaryTask then
        pcall(ClearPedSecondaryTask, ped)
    end
    ClearPedTasks(ped)
    Wait(1)

    local started = false
    if id == 'cheer' then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CHEERING', 0, true)
        started = true
    elseif id == 'flex' then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MUSCLE_FLEX', 0, true)
        started = true
    elseif id == 'party' then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_PARTYING', 0, true)
        started = true
    elseif id == 'wave' then
        local waveOk, waveWait = PlayWaveCelebration(ped, dur)
        started = waveOk
        if waveOk and waveWait then dur = waveWait end
        if not started then
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CHEERING', 0, true)
            started = true
        end
    elseif id == 'flip' then
        local flipCfgMs = tonumber(gc.FlipAnimDurationMs) or 0
        local flipOk, flipWait = PlayFlipCelebration(ped, dur, flipCfgMs)
        if flipOk then
            started = true
            dur = flipWait or dur
        else
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CHEERING', 0, true)
            started = true
        end
    else
        return
    end

    if not started then return end

    CreateThread(function()
        Wait(dur)
        if DoesEntityExist(ped) then
            ClearPedTasks(ped)
        end
    end)
end

local function FinishGoalCelebrationPick(id)
    if goalCelebrationState ~= 'picker' then return end
    id = tostring(id or '')
    ClearGoalCelebrationUi()
    if id ~= '' and id ~= 'skip' then
        PlayGoalCelebrationChoice(id)
    end
end

RegisterNUICallback('closeUI', function(data, cb)
    ToggleUI(false)
    cb('ok')
end)

RegisterNUICallback('goalCelebrationPick', function(data, cb)
    data = data or {}
    FinishGoalCelebrationPick(tostring(data.id or ''))
    cb('ok')
end)

RegisterNUICallback('goalCelebrationDismiss', function(_, cb)
    ClearGoalCelebrationUi()
    cb('ok')
end)

RegisterCommand('seoul_soccer_celeb_accept', function()
    if goalCelebrationState ~= 'prompt' then return end
    local gc = Config.GoalCelebration or {}
    local ms = math.max(3500, math.min(20000, tonumber(gc.PickerTimeoutMs) or 11000))
    OpenGoalCelebrationPicker(ms)
end, false)

RegisterCommand('seoul_soccer_celeb_decline', function()
    if goalCelebrationState == 'prompt' then
        ClearGoalCelebrationUi()
    end
end, false)

do
    local gc = Config.GoalCelebration or {}
    RegisterKeyMapping(
        'seoul_soccer_celeb_accept',
        LOr('client.keymap_celebration_accept', 'Soccer: accept goal celebration'),
        'keyboard',
        tostring(gc.AcceptKeybind or 'y')
    )
    RegisterKeyMapping(
        'seoul_soccer_celeb_decline',
        LOr('client.keymap_celebration_decline', 'Soccer: decline goal celebration'),
        'keyboard',
        tostring(gc.DeclineKeybind or 'n')
    )
end

RegisterNUICallback('uiNotify', function(data, cb)
    data = data or {}
    Bridge.Notify(tostring(data.message or ''), data.type or 'error', tonumber(data.duration) or 5000)
    cb('ok')
end)

local function GetUniformNumberConfig()
    local cfg = Config.UniformNumbers or {}
    local min = math.floor(tonumber(cfg.Min) or 1)
    local max = math.floor(tonumber(cfg.Max) or 10)
    if max < min then max = min end
    local def = math.floor(tonumber(cfg.Default) or max)
    if def < min then def = min end
    if def > max then def = max end
    return min, max, def
end

local function ResolveJerseyNumber(raw)
    local min, max, def = GetUniformNumberConfig()
    local n = tonumber(raw)
    if not n then return def end
    n = math.floor(n)
    if n < min then n = min end
    if n > max then n = max end
    return n
end

local selectedJerseyNumber = nil

--- Lobi: forma numarasini gostermek icin scripted kamera (NUI). Baslangic: pedin arkasi;
--- sol/sag NUI ile kamera ped etrafinda yorunge (heading degil — on/yan/arka gorunur).
local jerseyPreviewCam = nil
local jerseyPreviewCamActive = false
local jerseyPreviewCamOrbitRad = 0.0

function StopJerseyPreviewCamera()
    jerseyPreviewCamActive = false
    jerseyPreviewCamOrbitRad = 0.0
    local cam = jerseyPreviewCam
    jerseyPreviewCam = nil
    if cam and cam ~= 0 and DoesCamExist(cam) then
        RenderScriptCams(false, true, 250, true, false)
        DestroyCam(cam, false)
    end
end

local function StartJerseyPreviewCamera()
    StopJerseyPreviewCamera()
    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    if not cam or cam == 0 then return end

    jerseyPreviewCam = cam
    jerseyPreviewCamActive = true
    jerseyPreviewCamOrbitRad = 0.0

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 320, true, false)

    local dist = 2.9
    local zLift = 0.48
    local aimZ = 0.35
    local fov = 47.0

    CreateThread(function()
        local c = cam
        while jerseyPreviewCamActive and c and c ~= 0 and DoesCamExist(c) do
            ped = PlayerPedId()
            if not ped or ped == 0 or not DoesEntityExist(ped) then break end
            local pos = GetEntityCoords(ped)
            local fwd = GetEntityForwardVector(ped)
            if not fwd then break end
            -- Varsayilan: pedin arkasinda (forma numarasi); orbit ile etrafinda doner.
            local backX = -fwd.x * dist
            local backY = -fwd.y * dist
            local orbit = jerseyPreviewCamOrbitRad
            local cos_o, sin_o = math.cos(orbit), math.sin(orbit)
            local rx = (backX * cos_o) - (backY * sin_o)
            local ry = (backX * sin_o) + (backY * cos_o)
            local camPos = vector3(pos.x + rx, pos.y + ry, pos.z + zLift)
            SetCamCoord(c, camPos.x, camPos.y, camPos.z)
            PointCamAtEntity(c, ped, 0.0, 0.0, aimZ, true)
            SetCamFov(c, fov)
            Wait(16)
        end
    end)
end

local function ClampJerseyTextureId(n)
    return ResolveJerseyNumber(n)
end

-- ─────────────────────────────────────────────
-- Lobi NUI Olayları
-- ─────────────────────────────────────────────
RegisterNUICallback('createLobby', function(data, cb)
    data = data or {}
    if (not data.pitchId or data.pitchId == 'random') and lastMenuPitchId then
        data.pitchId = lastMenuPitchId
    end
    TriggerServerEvent('seoul_soccer:server:CreateLobby', data)
    cb('ok')
end)

RegisterNUICallback('updateLobbySettings', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:UpdateLobbySettings', data.lobbyId, data)
    cb('ok')
end)

RegisterNUICallback('openLobbySettingsPanel', function(_, cb)
    SetNuiFocus(true, true)
    lobbySettingsPanelOpen = true
    cb('ok')
end)

RegisterNUICallback('closeLobbySettingsPanel', function(_, cb)
    SetNuiFocus(false, false)
    lobbySettingsPanelOpen = false
    cb('ok')
end)

RegisterNUICallback('joinLobby', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:JoinLobby', data.lobbyId, data.teamIndex, data.password)
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:KickPlayerFromLobby', data.lobbyId, data.targetSrc)
    cb('ok')
end)

RegisterNUICallback('validateLobbyPassword', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:ValidateLobbyPassword', data.lobbyId, data.password)
    cb('ok')
end)

RegisterNUICallback('setLobbyTeamName', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:SetLobbyTeamName', data.lobbyId, data.teamIndex, data.name)
    cb('ok')
end)

RegisterNUICallback('setJerseyNumber', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:SetJerseyNumber', data.lobbyId, data.jerseyNumber)
    local number = ResolveJerseyNumber(tonumber(data.number) or tonumber(data.jerseyNumber))
    selectedJerseyNumber = number
    local activeTeam = (Uniform.GetCurrentTeam and Uniform.GetCurrentTeam()) or 0
    if activeTeam == 1 or activeTeam == 2 then
        Uniform.Apply(activeTeam, number)
    end
    cb({ success = true, number = number })
end)

RegisterNUICallback('toggleJerseyPreviewCamera', function(_, cb)
    if jerseyPreviewCamActive then
        StopJerseyPreviewCamera()
        cb({ ok = true, active = false })
    else
        StartJerseyPreviewCamera()
        cb({ ok = true, active = jerseyPreviewCamActive })
    end
end)

RegisterNUICallback('stopJerseyPreviewCamera', function(_, cb)
    StopJerseyPreviewCamera()
    cb({ ok = true, active = false })
end)

RegisterNUICallback('jerseyPreviewCameraRotatePed', function(data, cb)
    if not jerseyPreviewCamActive then
        cb({ ok = false })
        return
    end
    data = data or {}
    local deg = tonumber(data.degrees) or tonumber(data.delta) or 0.0
    if deg > 90.0 then deg = 90.0 end
    if deg < -90.0 then deg = -90.0 end
    if math.abs(deg) < 0.01 then
        cb({ ok = true })
        return
    end
    -- Ped heading degil: kamera ofsetini dunya Z etrafinda dondur (on/yan/arka).
    jerseyPreviewCamOrbitRad = jerseyPreviewCamOrbitRad + math.rad(deg)
    cb({ ok = true })
end)

RegisterNUICallback('inviteToLobby', function(data, cb)
    data = data or {}
    TriggerServerEvent('seoul_soccer:server:InvitePlayerToLobby', data.lobbyId, data.targetId, data.teamIndex)
    cb('ok')
end)

--- NUI: yakindaki oyuncu server id listesi -> sunucu isim cozumler (bir round-trip)
local nearbyInvitePending = {}

RegisterNetEvent('seoul_soccer:client:NearbyPlayerNamesResult', function(requestId, players)
    requestId = tonumber(requestId)
    local fn = requestId and nearbyInvitePending[requestId] or nil
    if not fn then return end
    nearbyInvitePending[requestId] = nil
    fn(players or {})
end)

RegisterNUICallback('getNearbyPlayersForInvite', function(data, cb)
    data = data or {}
    local cfg = Config.NearbyInvite or {}
    local radius = tonumber(cfg.ClientScanRadius) or 18.0

    local excludeSet = {}
    if type(data.excludeIds) == "table" then
        for _, v in ipairs(data.excludeIds) do
            local n = tonumber(v)
            if n then excludeSet[n] = true end
        end
    end

    local myPed = PlayerPedId()
    if not myPed or myPed == 0 then
        cb({ ok = true, players = {} })
        return
    end
    local myCoords = GetEntityCoords(myPed)
    local mySrc = GetPlayerServerId(PlayerId())
    excludeSet[mySrc] = true

    local nearbyIds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local sid = GetPlayerServerId(player)
        if sid and not excludeSet[sid] then
            local ped = GetPlayerPed(player)
            if ped and ped ~= 0 and ped ~= myPed then
                local c = GetEntityCoords(ped)
                if #(myCoords - c) <= radius then
                    nearbyIds[#nearbyIds + 1] = sid
                end
            end
        end
    end

    local requestId = math.random(1, 2147483646)
    nearbyInvitePending[requestId] = function(players)
        cb({ ok = true, players = players })
    end

    SetTimeout(8000, function()
        local fn = nearbyInvitePending[requestId]
        if fn then
            nearbyInvitePending[requestId] = nil
            fn({})
        end
    end)

    TriggerServerEvent('seoul_soccer:server:ResolveNearbyInviteTargets', requestId, nearbyIds)
end)

RegisterNUICallback('leaveTeam', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:LeaveTeam', data.lobbyId)
    cb('ok')
end)

RegisterNUICallback('leaveLobby', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:LeaveLobby', data.lobbyId)
    Uniform.Remove()
    cb('ok')
end)

RegisterNUICallback('disbandLobby', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:DisbandLobby', data.lobbyId)
    Uniform.Remove()
    cb('ok')
end)

RegisterNUICallback('startMatch', function(data, cb)
    -- data = lobbyId (number)
    TriggerServerEvent('seoul_soccer:server:StartMatch', data)
    cb('ok')
end)

RegisterNUICallback('beginMatch', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:BeginMatch', data.lobbyId)
    cb('ok')
end)

RegisterNUICallback('togglePause', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:TogglePause', data.lobbyId)
    cb('ok')
end)

RegisterNUICallback('endMatch', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:EndMatch', data.lobbyId)
    cb('ok')
end)

RegisterNUICallback('togglePitchDoor', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:TogglePitchDoor', data.lobbyId, data.doorIndex)
    cb('ok')
end)

RegisterNUICallback('getLeaderboard', function(data, cb)
    TriggerServerEvent('seoul_soccer:server:RequestLeaderboard')
    cb('ok')
end)

RegisterNUICallback('setWaypoint', function(data, cb)
    local pitchId = tostring(data and data.pitchId or "")
    local pitch = GetPitchById(pitchId)
    if pitch and pitch.coords then
        SetNewWaypoint(pitch.coords.x, pitch.coords.y)
    end
    cb('ok')
end)

-- ─────────────────────────────────────────────
-- Leaderboard Sync
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:client:LeaderboardData', function(data)
    SendNUIMessage({
        action = 'leaderboardData',
        data   = data or {}
    })
end)

-- ─────────────────────────────────────────────
-- Lobi Sync
-- ─────────────────────────────────────────────
local function GetUiPitchList()
    local list = {}
    for _, pitch in ipairs(Config.Pitches or {}) do
        list[#list + 1] = {
            id = pitch.id,
            name = GetLocalizedPitchName(pitch),
            image = pitch.image or "match.png"
        }
    end
    return list
end

RegisterNetEvent('seoul_soccer:client:SyncLobbies', function(lobbies)
    SendNUIMessage({
        action = "syncLobbies",
        data   = {
            lobbies = lobbies or {},
            pitches = GetUiPitchList()
        }
    })

    if matchData and matchData.lobbyId then
        return
    end

    local mySrc = GetPlayerServerId(PlayerId())
    local myTeam = 0
    local myNumber = nil

    for _, lobby in pairs(lobbies or {}) do
        local t1 = (lobby.team1 or {}).players or {}
        for _, p in ipairs(t1) do
            if tonumber(p.src) == mySrc then
                myTeam = 1
                myNumber = tonumber(p.jerseyNumber)
                break
            end
        end
        if myTeam ~= 0 then break end

        local t2 = (lobby.team2 or {}).players or {}
        for _, p in ipairs(t2) do
            if tonumber(p.src) == mySrc then
                myTeam = 2
                myNumber = tonumber(p.jerseyNumber)
                break
            end
        end
        if myTeam ~= 0 then break end
    end

    if myTeam == 1 or myTeam == 2 then
        if myNumber ~= nil then
            selectedJerseyNumber = ClampJerseyTextureId(myNumber)
        end
        Uniform.Apply(myTeam, myNumber)
    else
        Uniform.Remove()
    end
end)

--- Sunucu tarafi sifre dogrulama cevabi: NUI'ye iletilir ki UI prompt kapansin ya da hata gostersin.
RegisterNetEvent('seoul_soccer:client:LobbyPasswordResult', function(lobbyId, success)
    SendNUIMessage({
        action = "lobbyPasswordResult",
        data   = {
            lobbyId = tonumber(lobbyId),
            success = success == true,
        }
    })
end)

RegisterNetEvent('seoul_soccer:client:CreateLobbyResult', function(ok, message, lobbyId)
    SendNUIMessage({
        action = "createLobbyResult",
        data   = {
            ok = ok == true,
            message = tostring(message or ""),
            lobbyId = tonumber(lobbyId),
        }
    })
end)

RegisterNetEvent('seoul_soccer:client:ShowLobbyInvite', function(data)
    data = data or {}
    pendingLobbyInviteId = tonumber(data.lobbyId)
    SendNUIMessage({
        action = 'initLocale',
        data   = GetNuiLocalePayload()
    })
    SendNUIMessage({
        action = 'showLobbyInvite',
        data   = data,
    })
end)

RegisterNetEvent('seoul_soccer:client:ClearLobbyInvite', function()
    pendingLobbyInviteId = nil
    SendNUIMessage({ action = 'hideLobbyInvite' })
end)

RegisterCommand('seoul_soccer_invite_accept', function()
    if not pendingLobbyInviteId then return end
    TriggerServerEvent('seoul_soccer:server:AcceptLobbyInvite', pendingLobbyInviteId)
end, false)

RegisterCommand('seoul_soccer_invite_decline', function()
    if not pendingLobbyInviteId then return end
    TriggerServerEvent('seoul_soccer:server:DeclineLobbyInvite', pendingLobbyInviteId)
end, false)

RegisterKeyMapping('seoul_soccer_invite_accept', LOr('client.keymap_invite_accept', 'Soccer: accept lobby invite'), 'keyboard', 'k')
RegisterKeyMapping('seoul_soccer_invite_decline', LOr('client.keymap_invite_decline', 'Soccer: decline lobby invite'), 'keyboard', 'j')

RegisterCommand('+seoul_soccer_hold_scoreboard', function()
    if not matchData or not matchData.lobbyId then return end
    local st = tostring(matchData.state or "")
    if st ~= "warmup" and st ~= "countdown" and st ~= "playing" and st ~= "paused" then
        return
    end
    isScoreboardModalVisible = true
    SendNUIMessage({
        action = "toggleMatchScoreboard",
        data = { visible = true }
    })
end, false)

RegisterCommand('-seoul_soccer_hold_scoreboard', function()
    isScoreboardModalVisible = false
    SendNUIMessage({
        action = "toggleMatchScoreboard",
        data = { visible = false }
    })
end, false)
RegisterKeyMapping('+seoul_soccer_hold_scoreboard', LOr('client.keymap_hold_scoreboard', 'Soccer: hold in-match scoreboard'), 'keyboard', 'o')

-- ─────────────────────────────────────────────
-- WARMUP: Maç başlatıldı → NUI kapanır, scoreboard açılır
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:client:EnterWarmup', function(data)
    data.state = "warmup"
    matchData = data
    isInfoBoxHidden = false
    isScoreboardModalVisible = false
    ResetBallControl()
    ballControl.netId = data.ballNetId or 0
    ballControl.owner = data.ballOwner or 0
    matchData.kickoffLockActive = (data.kickoffLockActive == true)
    matchData.kickoffAllowedTeam = tonumber(data.kickoffAllowedTeam) or 0
    matchData.kickoffBlockedTeam = tonumber(data.kickoffBlockedTeam) or 0
    local hold = data.goalkeeperHold or {}
    if tonumber(hold.src) == GetPlayerServerId(PlayerId()) then
        goalieControl.holding = true
        goalieControl.holdTeam = tonumber(hold.team) or 0
        goalieControl.holdUntil = tonumber(hold.untilTime) or 0
        goalieControl.holdMeta = hold.catchMeta
    end

    -- Takim formasini uygula (ped hazir oldugunda)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local tries = 0
        while (not ped or ped == 0 or not DoesEntityExist(ped)) and tries < 20 do
            Citizen.Wait(100)
            ped = PlayerPedId()
            tries = tries + 1
        end
        local myTeam = tonumber((matchData or {}).myTeam) or 0
        if myTeam == 1 or myTeam == 2 then
            -- Ikinci arguman verilmezse Uniform.Apply icinde GetMyJerseyNumber() cagrilir (local,
            -- bu satirda henuz scope'ta olmadigi icin burada dogrudan cagirma).
            Uniform.Apply(myTeam)
        end
    end)

    -- NUI menüyü kapat
    ToggleUI(false)

    -- Scoreboard + Tuş Rehberini NUI'ye gönder (ayrı bir tam-ekran NUI katmanı)
    SendNUIMessage({
        action   = "enterWarmup",
        data     = data
    })
    SendNUIMessage({
        action = "toggleInfoBox",
        data   = { hidden = false }
    })
    SendNUIMessage({
        action = "toggleMatchScoreboard",
        data   = { visible = false }
    })
    SetShotChargeUI(false, 0.0)
    SetNuiFocus(false, false)
end)

-- ─────────────────────────────────────────────
-- Maç Durumu Değişti (playing / paused)
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:client:MatchStateChanged', function(state, timeLeft)
    if matchData then
        matchData.state = state
        matchData.timeLeft = timeLeft
    end
    SendNUIMessage({
        action = "matchStateChanged",
        data   = { state = state, timeLeft = timeLeft }
    })
end)

RegisterNetEvent('seoul_soccer:client:UpdateLobbySettingsResult', function(ok, message)
    SendNUIMessage({
        action = 'updateLobbySettingsResult',
        data = { success = ok == true, message = tostring(message or '') },
    })
end)

RegisterNetEvent('seoul_soccer:client:LobbySettingsUpdated', function(data)
    if not matchData or type(data) ~= 'table' then return end

    if data.team1 then matchData.team1 = data.team1 end
    if data.team2 then matchData.team2 = data.team2 end
    if data.timeLeft ~= nil then matchData.timeLeft = tonumber(data.timeLeft) or matchData.timeLeft end
    if data.duration ~= nil then matchData.duration = tonumber(data.duration) or matchData.duration end
    if data.targetGoals ~= nil then matchData.targetGoals = tonumber(data.targetGoals) or 0 end
    if data.format ~= nil then matchData.format = data.format end
    if data.name ~= nil then matchData.name = data.name end
    if data.ballId ~= nil then matchData.ballId = data.ballId end
    if data.ballOutline ~= nil then matchData.ballOutline = data.ballOutline == true end
    if data.allowBothTeamsTouchAfterGoal ~= nil then
        matchData.allowBothTeamsTouchAfterGoal = data.allowBothTeamsTouchAfterGoal == true
    end
    if data.spawnAtOwnHalfAfterGoal ~= nil then
        matchData.spawnAtOwnHalfAfterGoal = data.spawnAtOwnHalfAfterGoal == true
    end
    if data.allowInventory ~= nil then
        matchData.allowInventory = data.allowInventory ~= false
        if matchData.allowInventory == false then
            SetInventoryLockedState(true)
        else
            SetInventoryLockedState(false)
        end
    end
    if data.state ~= nil then matchData.state = data.state end

    SendNUIMessage({ action = 'lobbySettingsUpdated', data = data })
end)

--- Host degistiginde (eski host disconnect) anlik gecis: matchData + NUI refresh.
RegisterNetEvent('seoul_soccer:client:ShotTrailPresetChanged', function(index, label)
    if not matchData then return end
    matchData.shotTrailPresetIndex = math.floor(tonumber(index) or 0)
    matchData.shotTrailPresetLabel = tostring(label or "")
    SendNUIMessage({
        action = "shotTrailPresetChanged",
        data = {
            index = matchData.shotTrailPresetIndex,
            label = matchData.shotTrailPresetLabel,
        },
    })
end)

RegisterCommand('seoul_soccer_cycle_shot_fx', function()
    if not matchData or not matchData.isHost or not matchData.lobbyId then return end
    local st = tostring(matchData.state or "")
    if st ~= "warmup" and st ~= "countdown" and st ~= "playing" and st ~= "paused" then
        return
    end
    TriggerServerEvent('seoul_soccer:server:CycleShotTrailPreset', matchData.lobbyId)
end, false)

RegisterKeyMapping(
    'seoul_soccer_cycle_shot_fx',
    LOr('client.keymap_cycle_shot_fx', 'Soccer: cycle shot trail effect (host)'),
    'keyboard',
    'i'
)

local function IsClientLobbySettingsEditable(stateName)
    local st = tostring(stateName or "")
    return st == "waiting" or st == "warmup" or st == "countdown" or st == "playing" or st == "paused"
end

RegisterCommand('seoul_soccer_lobby_settings', function()
    if not matchData or not matchData.isHost or not matchData.lobbyId then return end
    if not IsClientLobbySettingsEditable(matchData.state) then return end
    SendNUIMessage({
        action = 'toggleLobbySettingsPanel',
        data = { open = not lobbySettingsPanelOpen },
    })
end, false)

RegisterKeyMapping(
    'seoul_soccer_lobby_settings',
    LOr('client.keymap_lobby_settings', 'Soccer: lobby settings (host)'),
    'keyboard',
    'u'
)

RegisterNetEvent('seoul_soccer:client:HostTransferred', function(data)
    if not data or not matchData then return end

    local preservedState = matchData.state or "warmup"
    local preservedTimeLeft = tonumber(matchData.timeLeft) or (tonumber(data.timeLeft) or 0)

    matchData.isHost         = data.isHost == true
    matchData.team1          = data.team1 or matchData.team1
    matchData.team2          = data.team2 or matchData.team2
    matchData.myTeam         = data.myTeam or matchData.myTeam
    matchData.pitchDoors     = data.pitchDoors or matchData.pitchDoors
    matchData.pitchDoorLocks = data.pitchDoorLocks or matchData.pitchDoorLocks
    matchData.matchStats     = data.matchStats or matchData.matchStats
    matchData.keybinds       = data.keybinds or matchData.keybinds
    matchData.hostKeys       = data.hostKeys or matchData.hostKeys
    matchData.uiKeys         = data.uiKeys or matchData.uiKeys
    if data.kickoffLockActive ~= nil then
        matchData.kickoffLockActive = data.kickoffLockActive == true
    end
    if data.kickoffAllowedTeam ~= nil then
        matchData.kickoffAllowedTeam = tonumber(data.kickoffAllowedTeam) or 0
    end
    if data.kickoffBlockedTeam ~= nil then
        matchData.kickoffBlockedTeam = tonumber(data.kickoffBlockedTeam) or 0
    end

    -- NUI scoreboard'u yeni isHost degeriyle re-render et (enterWarmup action'i reuse).
    local nuiPayload = {}
    for k, v in pairs(data) do nuiPayload[k] = v end
    nuiPayload.state    = preservedState
    nuiPayload.timeLeft = preservedTimeLeft
    SendNUIMessage({ action = "enterWarmup", data = nuiPayload })

    -- Aktif macta state'i geri yukle (enterWarmup NUI'de warmup moda dondurebilir).
    if preservedState == "playing" or preservedState == "paused" or preservedState == "countdown" then
        SendNUIMessage({
            action = "matchStateChanged",
            data   = { state = preservedState, timeLeft = preservedTimeLeft }
        })
    end

    -- Host transferi sirasinda takim degisebilir: forma senkronu
    Uniform.ReapplyIfTeamChanged()
end)

RegisterNetEvent('seoul_soccer:client:StartCountdown', function()
    if matchData then
        matchData.state = "countdown"
    end
    SendNUIMessage({
        action = "initLocale",
        data   = GetNuiLocalePayload()
    })
    SendNUIMessage({
        action = "matchStateChanged",
        data   = { state = "countdown", timeLeft = matchData and matchData.timeLeft or 0 }
    })
    SendNUIMessage({
        action = "startCountdown"
    })
end)

-- ─────────────────────────────────────────────
-- Timer Tick (her saniye)
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:client:TimerTick', function(timeLeft, score1, score2)
    if matchData then
        matchData.timeLeft = timeLeft
    end
    SendNUIMessage({
        action = "timerTick",
        data   = { timeLeft = timeLeft, score1 = score1, score2 = score2 }
    })
end)

local function ApplyClientGoalBallDrop()
    CreateThread(function()
        ballControl.owner = 0
        ballControl.shootHoldStart = nil
        ballControl.crossHoldStart = nil
        local goalResetDelay = math.max(0, tonumber((Config.GoalDetection or {}).BallResetDelayMs) or 3500)
        ballControl.dribbleMagnetSuspendedUntil = GetGameTimer() + goalResetDelay + 500
        if matchData then
            matchData.ballOwner = 0
        end

        for _ = 1, 8 do
            local ent = TryResolveBallEntity and TryResolveBallEntity()
            if not ent or ent == 0 or not DoesEntityExist(ent) then
                Wait(35)
            else
                if goalieControl.ballAttached and DetachBallFromKeeperHand then
                    DetachBallFromKeeperHand(ent)
                    goalieControl.ballAttached = false
                end
                if FreezeEntityPosition then
                    FreezeEntityPosition(ent, false)
                end
                if NetworkHasControlOfEntity and NetworkRequestControlOfEntity
                    and not NetworkHasControlOfEntity(ent) then
                    NetworkRequestControlOfEntity(ent)
                end

                local pos = GetEntityCoords(ent)
                if pos and GetGroundZFor_3dCoord then
                    local bump = tonumber((Config.GoalDetection or {}).BallSpawnAboveGround) or 0.14
                    local okg, r1, r2 = pcall(GetGroundZFor_3dCoord, pos.x, pos.y, pos.z + 2.0, false)
                    local gz = nil
                    if okg and r1 == true and type(r2) == "number" then
                        gz = r2
                    elseif okg and type(r1) == "number" then
                        gz = r1
                    end
                    if gz and gz > -400.0 and (pos.z - gz) > 0.35 then
                        SetEntityCoordsNoOffset(ent, pos.x, pos.y, gz + bump, false, false, false)
                    end
                end
                if PlaceObjectOnGroundProperly then
                    pcall(PlaceObjectOnGroundProperly, ent)
                end
                if SetEntityVelocity then
                    SetEntityVelocity(ent, 0.0, 0.0, -4.5)
                end
                if SetEntityAngularVelocity then
                    SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0)
                end
                break
            end
        end
    end)
end

RegisterNetEvent('seoul_soccer:client:BallCenterReady', function()
    local now = GetGameTimer()
    ballControl.owner = 0
    ballControl.dribbleMagnetSuspendedUntil = 0
    ballControl.pickupLockUntil = 0
    ballControl.autoClaimBlockedUntil = 0
    ballControl.postSlideAutoClaimSuppressUntil = 0
    ballControl.lastClaimTry = now - 1000
    if matchData then
        matchData.ballOwner = 0
    end
end)

RegisterNetEvent('seoul_soccer:client:GoalScored', function(payload)
    payload = payload or {}
    CancelActiveShotTrailFx()
    ApplyClientGoalBallDrop()
    if matchData and payload.matchStats then
        matchData.matchStats = payload.matchStats
    end
    if matchData then
        if payload.kickoffLockActive ~= nil then
            matchData.kickoffLockActive = payload.kickoffLockActive == true
        end
        if payload.kickoffAllowedTeam ~= nil then
            matchData.kickoffAllowedTeam = tonumber(payload.kickoffAllowedTeam) or 0
        end
        if payload.kickoffBlockedTeam ~= nil then
            matchData.kickoffBlockedTeam = tonumber(payload.kickoffBlockedTeam) or 0
        end
    end
    if PlaySoundFrontend then
        pcall(PlaySoundFrontend, -1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
    end
    SendNUIMessage({
        action = 'goalScored',
        data   = payload
    })

    local gc = Config.GoalCelebration or {}
    local mySrc = GetPlayerServerId(PlayerId())
    local scorer = tonumber(payload.scorerSrc) or 0
    if gc.Enabled ~= false and scorer == mySrc and scorer ~= 0 and payload.isOwnGoal ~= true then
        local promptMs = math.max(2500, math.min(15000, tonumber(gc.PromptTimeoutMs) or 7500))
        OpenGoalCelebrationPrompt(promptMs)
    end
end)

RegisterNetEvent('seoul_soccer:client:TeleportToKickoff', function(coords, heading)
    CreateThread(function()
        DoScreenFadeOut(400)
        Wait(400)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
            SetEntityHeading(ped, heading)
        end
        Wait(400)
        DoScreenFadeIn(400)
    end)
end)

-- ─────────────────────────────────────────────
-- Maç Bitti
-- ─────────────────────────────────────────────
RegisterNetEvent('seoul_soccer:client:MatchEnded', function(score1, score2)
    StopJerseyPreviewCamera()
    ClearGoalCelebrationUi()
    CancelActiveShotTrailFx()
    matchData = nil
    lobbySettingsPanelOpen = false
    SetNuiFocus(false, false)
    isInfoBoxHidden = false
    isScoreboardModalVisible = false
    ResetBallControl()
    SetShotChargeUI(false, 0.0)
    Uniform.Remove()
    -- Mac boyunca kapatilan ragdoll'u GTA varsayilanina geri al.
    local ped = PlayerPedId()
    SetSoccerPedRagdollBlocked(ped, false)
    -- Envanter / silah kilidini kaldir (host "envanter kapali" ayarini sectiyse).
    if inventoryLockedState and LocalPlayer and LocalPlayer.state and LocalPlayer.state.set then
        pcall(function() LocalPlayer.state:set('invBusy', false, true) end)
    end
    inventoryLockedState = false
    if DoesEntityExist(ped) and SetPedCanSwitchWeapon then
        SetPedCanSwitchWeapon(ped, true)
    end
    SendNUIMessage({
        action = "matchEnded",
        data   = { score1 = score1, score2 = score2 }
    })
end)

RegisterNetEvent('seoul_soccer:client:RemovedFromMatch', function(reason)
    StopJerseyPreviewCamera()
    ClearGoalCelebrationUi()
    CancelActiveShotTrailFx()
    matchData = nil
    lobbySettingsPanelOpen = false
    SetNuiFocus(false, false)
    isInfoBoxHidden = false
    isScoreboardModalVisible = false
    ResetBallControl()
    SetShotChargeUI(false, 0.0)
    Uniform.Remove()
    local ped = PlayerPedId()
    SetSoccerPedRagdollBlocked(ped, false)
    -- Envanter / silah kilidini kaldir.
    if inventoryLockedState and LocalPlayer and LocalPlayer.state and LocalPlayer.state.set then
        pcall(function() LocalPlayer.state:set('invBusy', false, true) end)
    end
    inventoryLockedState = false
    if DoesEntityExist(ped) and SetPedCanSwitchWeapon then
        SetPedCanSwitchWeapon(ped, true)
    end
    SendNUIMessage({
        action = "removedFromMatch",
        data   = { reason = reason or "" }
    })
    if reason and tostring(reason) ~= "" then
        Bridge.Notify(tostring(reason), "error", 4500)
    end
end)

RegisterNetEvent('seoul_soccer:client:BallOwnerChanged', function(ownerSrc, ballNetId)
    ballControl.owner = tonumber(ownerSrc) or 0
    if (tonumber(ballControl.owner) or 0) == 0 then
        ballControl.looseSinceGameTimer = GetGameTimer()
    else
        ballControl.looseSinceGameTimer = nil
    end
    local mySrc = GetPlayerServerId(PlayerId())
    local newNet = tonumber(ballNetId) or 0
    if newNet ~= 0 then
        if ballControl.netId ~= newNet then
            ballControl.entity = nil
            ballControl.visibilityNetId = 0
            ballControl.lastLodApplyAt = 0
        end
        ballControl.netId = newNet
    end
    if matchData then
        matchData.ballNetId = ballControl.netId
        matchData.ballOwner = ballControl.owner
    end
    -- Post-steal guard sadece gercek SHIFT+E temas penceresi acikken baslasin.
    -- Aksi halde (rakipten pas alma vb.) softStealOwnerAtStart eski kalip her sahiplenmede
    -- top collision kapatiliyor; sut/pas impulse gorunmez veya top yerinde kaliyor.
    if matchData and ballControl.owner == mySrc then
        local nowBo = GetGameTimer()
        local contactUntilBo = tonumber(ballControl.softContactGuardUntil) or 0
        local stealTargetBo = tonumber(ballControl.softContactGuardTarget) or tonumber(ballControl.softStealOwnerAtStart) or 0
        if stealTargetBo ~= 0 and stealTargetBo ~= mySrc and nowBo < contactUntilBo then
            local softCfg = (Config.StealSystem or {}).SoftSteal or {}
            local postGuardMs = tonumber(softCfg.PostStealGuardMs) or 2500
            StartSoftPostStealGuard(stealTargetBo, postGuardMs)
        end

        -- Rakitten gelen paslar dahil; entity control eski sahibindeyken
        -- NetworkRequestControlOfEntity 120ms magnet penceresinden daha uzun surebilir.
        -- 2 saniye boyunca agresif control acquisition thread: sunucu migration acigi (server fix)
        -- ile birlikte ilk birkaç iste basarim elde edilmeli.
        local acqNetId = newNet ~= 0 and newNet or (tonumber(ballControl.netId) or 0)
        if acqNetId ~= 0 then
            local acqOwner = mySrc
            CreateThread(function()
                local endAt = GetGameTimer() + 2000
                while GetGameTimer() < endAt do
                    if (tonumber(ballControl.owner) or 0) ~= acqOwner then return end
                    local ent = TryResolveBallEntity and TryResolveBallEntity()
                    if ent and ent ~= 0 and DoesEntityExist(ent) then
                        if NetworkHasControlOfEntity(ent) then return end
                        NetworkRequestControlOfEntity(ent)
                        if NetworkRequestControlOfNetworkId then
                            NetworkRequestControlOfNetworkId(acqNetId)
                        end
                    end
                    Wait(50)
                end
            end)
        end
    end
    if matchData and ballControl.owner ~= mySrc then
        ballControl.shootHoldStart = nil
        ballControl.crossHoldStart = nil
        -- Sahipsiz (0) geciste dribble suppress'u sifirlama: LooseBallAfterSlide kisa bir pencere acar;
        -- aksi halde BallOwnerChanged(0) hemen ardindan mıknatısı tekrar acip topu geri cekerdi.
        if ballControl.owner ~= 0 then
            ballControl.dribbleMagnetSuspendedUntil = 0
        end
        SetShotChargeUI(false, 0.0)
    end
    if matchData and (tonumber(ballControl.owner) or 0) == 0 then
        local t = GetGameTimer() + 200
        ballControl.autoClaimBlockedUntil = math.max(tonumber(ballControl.autoClaimBlockedUntil) or 0, t)
    end
end)

--- Sahipsiz top: sunucu konum/hiz (NetworkHasControl olmayan istemciler) ile hizalar.
RegisterNetEvent('seoul_soccer:client:BallLoosePhysicsSync', function(lobbyId, x, y, z, vx, vy, vz)
    if not matchData or tonumber(matchData.lobbyId) ~= tonumber(lobbyId) then return end
    local st = matchData.state
    if st ~= "playing" and st ~= "paused" and st ~= "countdown" then return end
    if tonumber(ballControl.owner) ~= 0 then return end
    local ent = TryResolveBallEntity()
    if not ent or ent == 0 or not DoesEntityExist(ent) then return end
    if NetworkHasControlOfEntity and NetworkHasControlOfEntity(ent) then return end
    local bx, by, bz = x + 0.0, y + 0.0, z + 0.0
    local bp = GetEntityCoords(ent)
    if not bp then return end
    local thr = tonumber((Config.BallStreaming or {}).LooseSyncApplyThreshold) or 0.42
    local dx = bx - bp.x
    local dy = by - bp.y
    local dz = bz - bp.z
    if math.sqrt(dx * dx + dy * dy + dz * dz) < thr then return end
    SetEntityCoordsNoOffset(ent, bx, by, bz, false, false, false)
    if SetEntityVelocity then
        SetEntityVelocity(ent, (tonumber(vx) or 0.0) + 0.0, (tonumber(vy) or 0.0) + 0.0, (tonumber(vz) or 0.0) + 0.0)
    end
end)

--- Sahipsiz top: yatay surtunme + istege bagli N saniye sonra tam durma. Yalnizca ag kontrolu bizdeyken.
CreateThread(function()
    while true do
        if not matchData then
            Wait(2000)
        else
            local bs = Config.BallStreaming or {}
            local fr = bs.LooseBallGroundFriction
            local frictionOn = fr and fr.Enabled ~= false
            local forceMs = tonumber(bs.LooseBallForceStopAfterMs) or 0
            local forceOn = forceMs > 0
            if not frictionOn and not forceOn then
                Wait(2000)
            else
                local interval = frictionOn and math.max(18, math.floor(tonumber(fr.ClientIntervalMs) or 42))
                    or math.max(80, 140)
                Wait(interval)
                if matchData then
                local st = matchData.state
                local playingLike = (st == "playing" or st == "paused" or st == "countdown")
                if playingLike and (tonumber(ballControl.owner) or 0) == 0 then
                    if not ballControl.looseSinceGameTimer then
                        ballControl.looseSinceGameTimer = GetGameTimer()
                    end
                    local ent = TryResolveBallEntity and TryResolveBallEntity()
                    if ent and ent ~= 0 and DoesEntityExist(ent)
                        and NetworkHasControlOfEntity and NetworkHasControlOfEntity(ent)
                        and GetEntityVelocity and SetEntityVelocity
                    then
                        local function ballNearGroundForForceStop()
                            local maxH = tonumber(bs.LooseBallForceStopMaxHeightAboveGround) or 0.78
                            if not GetGroundZFor_3dCoord or not GetEntityCoords then return false end
                            local p = GetEntityCoords(ent)
                            if not p then return false end
                            local okg, r1, r2 = pcall(GetGroundZFor_3dCoord, p.x, p.y, p.z + 0.55, false)
                            local gz = nil
                            if okg and r1 == true and type(r2) == "number" then
                                gz = r2
                            elseif okg and type(r1) == "number" then
                                gz = r1
                            end
                            if not gz or gz <= -400.0 then return false end
                            return (p.z - gz) <= maxH
                        end

                        local didForceStop = false
                        if forceOn and ballControl.looseSinceGameTimer then
                            local elapsed = GetGameTimer() - ballControl.looseSinceGameTimer
                            if elapsed >= forceMs and ballNearGroundForForceStop() then
                                SetEntityVelocity(ent, 0.0, 0.0, 0.0)
                                if SetEntityAngularVelocity then
                                    SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0)
                                end
                                didForceStop = true
                            end
                        end

                        if frictionOn and not didForceStop then
                            local okv, vel = pcall(GetEntityVelocity, ent)
                            if okv and vel then
                                local vx = tonumber(vel.x) or 0.0
                                local vy = tonumber(vel.y) or 0.0
                                local vz = tonumber(vel.z) or 0.0
                                local horiz = math.sqrt(vx * vx + vy * vy)
                                local stopB = tonumber(fr.StopHorizontalBelow) or 0.085
                                if horiz < stopB then
                                    if horiz > 0.002 then
                                        SetEntityVelocity(ent, 0.0, 0.0, vz)
                                    end
                                    if SetEntityAngularVelocity then
                                        SetEntityAngularVelocity(ent, 0.0, 0.0, 0.0)
                                    end
                                else
                                    local groundOk = true
                                    local maxHgt = tonumber(fr.MaxHeightAboveGroundForFriction)
                                    if maxHgt == nil then maxHgt = 0.85 end
                                    if maxHgt >= 0.0 and GetGroundZFor_3dCoord and GetEntityCoords then
                                        local p = GetEntityCoords(ent)
                                        if p then
                                            local okg, r1, r2 = pcall(GetGroundZFor_3dCoord, p.x, p.y, p.z + 0.45, false)
                                            local gz = nil
                                            if okg and r1 == true and type(r2) == "number" then
                                                gz = r2
                                            elseif okg and type(r1) == "number" then
                                                gz = r1
                                            end
                                            if gz and gz > -400.0 and (p.z - gz) > maxHgt then
                                                groundOk = false
                                            end
                                        end
                                    end
                                    local function pickHorizontalRetain(baseRetain, horizSpeed)
                                        local r = tonumber(baseRetain) or 0.90
                                        if r < 0.45 then r = 0.45 end
                                        if r > 0.998 then r = 0.998 end
                                        local maxHRef = tonumber(fr.MaxHorizontalSpeedToApply) or 8.0
                                        if maxHRef > 0.5 and horizSpeed > maxHRef then
                                            local fastR = tonumber(fr.HorizontalRetainHighSpeed) or 0.965
                                            if fastR < r then fastR = r end
                                            if fastR > 0.998 then fastR = 0.998 end
                                            r = fastR
                                        end
                                        return r
                                    end

                                    if groundOk then
                                        local retain = pickHorizontalRetain(tonumber(fr.HorizontalRetainPerStep) or 0.90, horiz)
                                        vx, vy = vx * retain, vy * retain
                                        if math.sqrt(vx * vx + vy * vy) < stopB then
                                            vx, vy = 0.0, 0.0
                                        end
                                        SetEntityVelocity(ent, vx, vy, vz)
                                        if SetEntityAngularVelocity and GetEntityRotationVelocity then
                                            local okw, angVel = pcall(GetEntityRotationVelocity, ent)
                                            if okw and angVel then
                                                local ax = (tonumber(angVel.x) or 0.0) * retain
                                                local ay = (tonumber(angVel.y) or 0.0) * retain
                                                local az = (tonumber(angVel.z) or 0.0) * retain
                                                if math.abs(ax) < 0.05 then ax = 0.0 end
                                                if math.abs(ay) < 0.05 then ay = 0.0 end
                                                if math.abs(az) < 0.05 then az = 0.0 end
                                                SetEntityAngularVelocity(ent, ax, ay, az)
                                            end
                                        end
                                    else
                                        -- Zemin Z tutmuyorsa (addon saha / MLO): eski kodda surtunme hic uygulanmiyordu.
                                        local retainAir = pickHorizontalRetain(tonumber(fr.HorizontalRetainAirborne) or 0.968, horiz)
                                        vx, vy = vx * retainAir, vy * retainAir
                                        if math.sqrt(vx * vx + vy * vy) < stopB then
                                            vx, vy = 0.0, 0.0
                                        end
                                        SetEntityVelocity(ent, vx, vy, vz)
                                        if SetEntityAngularVelocity and GetEntityRotationVelocity then
                                            local okw, angVel = pcall(GetEntityRotationVelocity, ent)
                                            if okw and angVel then
                                                local ax = (tonumber(angVel.x) or 0.0) * retainAir
                                                local ay = (tonumber(angVel.y) or 0.0) * retainAir
                                                local az = (tonumber(angVel.z) or 0.0) * retainAir
                                                if math.abs(ax) < 0.05 then ax = 0.0 end
                                                if math.abs(ay) < 0.05 then ay = 0.0 end
                                                if math.abs(az) < 0.05 then az = 0.0 end
                                                SetEntityAngularVelocity(ent, ax, ay, az)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif (tonumber(ballControl.owner) or 0) ~= 0 then
                    ballControl.looseSinceGameTimer = nil
                end
                end
            end
        end
    end
end)

--- Gol sonrasi kickoff kilidi (sunucu otoritesi).
RegisterNetEvent('seoul_soccer:client:KickoffLockState', function(active, allowedTeam, blockedTeam)
    if not matchData then return end
    matchData.kickoffLockActive = active == true
    matchData.kickoffAllowedTeam = tonumber(allowedTeam) or 0
    matchData.kickoffBlockedTeam = tonumber(blockedTeam) or 0
end)

RegisterNetEvent('seoul_soccer:client:SoftStealContactGuard', function(otherSrc, durationMs)
    local now = GetGameTimer()
    local other = tonumber(otherSrc) or 0
    local currentTarget = tonumber(ballControl.softContactGuardTarget) or 0
    local currentUntil = tonumber(ballControl.softContactGuardUntil) or 0
    if other ~= 0 and other == currentTarget and now < currentUntil then
        local extendMs = math.max(150, tonumber(durationMs) or 900)
        ballControl.softContactGuardUntil = math.max(currentUntil, now + extendMs)
        SetSoccerPedRagdollBlocked(PlayerPedId(), true)
        return
    end

    ClearSoftStealPedTasks()
    StartSoftContactGuard(other, durationMs)
end)


local function ResolveGoalkeeperHoldAnim(meta)
    local gkCfg = Config.Goalkeeper or {}
    local baseFlag = tonumber(gkCfg.HoldAnimTaskFlag)
    if baseFlag == nil then baseFlag = 49 end
    local base = {
        dict = gkCfg.HoldAnimDict or "",
        clip = gkCfg.HoldAnimClip or "",
        flag = baseFlag,
        durationMs = -1,
        attachDelayMs = tonumber(gkCfg.HoldAttachDelayMs) or 280,
        refresh = true,
        key = "default",
    }

    local animCfg = gkCfg.CatchAnimations or {}
    if animCfg.Enabled == false or type(meta) ~= "table" then
        return base
    end

    local clips = animCfg.Clips or animCfg.Animations or {}
    if type(clips) ~= "table" then return base end

    local source = tostring(meta.source or "")
    local height = tostring(meta.height or "")
    local direction = tostring(meta.direction or "")
    local animKey = tostring(meta.animKey or "")
    local candidates = {}

    local function addCandidate(key)
        if key and key ~= "" then
            candidates[#candidates + 1] = key
        end
    end

    if source ~= "" and animKey ~= "" then addCandidate(source .. "_" .. animKey) end
    if source ~= "" and height ~= "" and direction ~= "" then addCandidate(source .. "_" .. height .. "_" .. direction) end
    addCandidate(animKey)
    if height ~= "" and direction ~= "" then addCandidate(height .. "_" .. direction) end
    if source ~= "" and height ~= "" then addCandidate(source .. "_" .. height) end
    addCandidate(height)
    addCandidate(source)
    addCandidate("default")

    for i = 1, #candidates do
        local key = candidates[i]
        local entry = clips[key]
        if type(entry) == "table" then
            local dict = entry.dict or entry.animDict or entry.Dict or entry.AnimDict or ""
            local clip = entry.clip or entry.anim or entry.name or entry.Clip or entry.Anim or ""
            if dict ~= "" and clip ~= "" then
                local flag = tonumber(entry.flag or entry.flags or entry.taskFlag or entry.TaskFlag) or base.flag
                local durationMs = tonumber(entry.durationMs or entry.DurationMs or entry.duration or entry.Duration)
                if durationMs == nil then durationMs = base.durationMs end
                local attachDelayMs = tonumber(entry.attachDelayMs or entry.AttachDelayMs) or base.attachDelayMs
                return {
                    dict = dict,
                    clip = clip,
                    flag = flag,
                    durationMs = durationMs,
                    attachDelayMs = attachDelayMs,
                    refresh = entry.refresh ~= false and entry.Refresh ~= false,
                    key = key,
                }
            end
        end
    end

    return base
end

local function PlayGoalkeeperHoldAnim(ped, meta)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return nil end
    local anim = ResolveGoalkeeperHoldAnim(meta)
    goalieControl.holdAnim = anim
    if not anim or anim.dict == "" or anim.clip == "" then return anim end
    if LoadAnimDict(anim.dict, 2500) then
        TaskPlayAnim(ped, anim.dict, anim.clip, 8.0, -8.0, tonumber(anim.durationMs) or -1, tonumber(anim.flag) or 49, 0.0, false, false, false)
    end
    return anim
end

RegisterNetEvent('seoul_soccer:client:GoalkeepersChanged', function(goalkeepers)
    if matchData then
        matchData.goalkeepers = goalkeepers or {}
    end
    SendNUIMessage({
        action = "goalkeepersChanged",
        data = goalkeepers or {}
    })
end)

RegisterNetEvent('seoul_soccer:client:GoalkeeperHoldChanged', function(payload)
    payload = payload or {}
    local holderSrc = tonumber(payload.src) or 0
    local myId = GetPlayerServerId(PlayerId())

    if holderSrc == myId then
        goalieControl.holding = true
        goalieControl.holdTeam = tonumber(payload.team) or 0
        goalieControl.holdUntil = tonumber(payload.untilTime) or 0
        goalieControl.releaseHoldStart = nil
        goalieControl.releaseMode = nil
        goalieControl.gkAnimRefreshAt = 0
        goalieControl.holdMeta = payload.catchMeta
        goalieControl.holdAnim = nil
        ballControl.shootHoldStart = nil
        ballControl.crossHoldStart = nil

        -- Tutma animasyonunu başlat ve topu ele yapıştır
        CreateThread(function()
            local ped = PlayerPedId()
            if not DoesEntityExist(ped) or IsEntityDead(ped) then return end
            if IsPedRagdoll(ped) or IsPedInAnyVehicle(ped, false) then return end

            local gkCfg = Config.Goalkeeper or {}
            local activeAnim = PlayGoalkeeperHoldAnim(ped, goalieControl.holdMeta)
            local catchHeight = type(goalieControl.holdMeta) == "table" and tostring(goalieControl.holdMeta.height or "") or ""
            local shouldStopCatchBall = catchHeight == "low" or catchHeight == "high"
            local caughtEnt = TryResolveBallEntity()
            if shouldStopCatchBall and caughtEnt and StopBallForGoalkeeperCatch then
                StopBallForGoalkeeperCatch(caughtEnt)
            end

            --[[
                if LoadAnimDict(animDict, 2500) then
                    local animFlag = tonumber(gkCfg.HoldAnimTaskFlag)
                    if animFlag == nil then animFlag = 49 end
                    -- -1: süre sonsuz (döngü clip'lerde)
                    TaskPlayAnim(ped, animDict, animClip, 8.0, -8.0, -1, animFlag, 0.0, false, false, false)
                end
            end

            -- Animasyon yerleşsin, ardından topu ele yapıştır (kısa beklemede ofset kemikle hizalanmaz)
            ]]
            local attachDelay = tonumber(activeAnim and activeAnim.attachDelayMs) or tonumber(gkCfg.HoldAttachDelayMs)
            if attachDelay == nil or attachDelay < 0 then attachDelay = 280 end
            Wait(math.floor(attachDelay + 0.5))
            if not goalieControl.holding then return end
            local ent = caughtEnt
            if not ent or ent == 0 or not DoesEntityExist(ent) then
                ent = TryResolveBallEntity()
            end
            if shouldStopCatchBall and ent and StopBallForGoalkeeperCatch then
                StopBallForGoalkeeperCatch(ent)
            end
            if ent and AttachBallToKeeperHand(ent, ped) then
                goalieControl.ballAttached = true
            end
        end)
    else
        if goalieControl.holding then
            SetShotChargeUI(false, 0.0)
            -- Animasyonu durdur ve topu serbest bırak
            local ped = PlayerPedId()
            ClearPedSecondaryTask(ped)
            if goalieControl.ballAttached then
                local ent = TryResolveBallEntity()
                if ent then DetachBallFromKeeperHand(ent) end
                goalieControl.ballAttached = false
            end
        end
        goalieControl.holding = false
        goalieControl.holdTeam = 0
        goalieControl.holdUntil = 0
        goalieControl.releaseHoldStart = nil
        goalieControl.releaseMode = nil
        goalieControl.gkAnimRefreshAt = 0
        goalieControl.holdMeta = nil
        goalieControl.holdAnim = nil
    end
end)

RegisterNetEvent('seoul_soccer:client:GoalkeeperParry', function(src)
    if tonumber(src) == GetPlayerServerId(PlayerId()) then
        Bridge.Notify(L("client.gk_parry_success"), "success", 1300)
    end
end)

-- Top sahibi calindiginda "stumble" reaksiyonu (RAGDOLL DEGIL).
-- Server SetLobbyBallOwner oncesi cagirir: eski sahip animasyon + kisa hareket kilidi + hafif geriye itilir.
-- ONEMLI: hard steal'de magdurun kilit suresi hirsizin slide animLockUntil'inden (DurationMs, ~900ms)
-- daha UZUN olmali; boylece kayarak muhadelelye giden oyuncu TOPU ALIR ALMAZ once ayaklanir / hareket
-- edebilir, magdur bir an sendelemede kalir. Asimetri gercekci bir "temiz mudahale" hissi verir.
-- mode: "hard" | "soft" | "stand" | fouled: (bool) arkadan slide foul flag'i.
RegisterNetEvent('seoul_soccer:client:BallStolen', function(attackerSrc, mode, fouled)
    local isHard = (mode == "hard")
    local isStand = (mode == "stand")
    local isSoft = (not isHard and not isStand)

    -- SHIFT+E (soft steal): sadece sahiplik degisir. Geri uyumluluk icin event gelirse de
    -- animLock, animasyon, push veya ragdoll uygulanmaz.
    if isSoft then
        if fouled == true then
            Bridge.Notify(L("client.slide_back_foul"), "error", 1600)
        end
        return
    end

    -- Top sahipligi: ragdoll/arac/olu kontrollerinden ONCE guncellenmeli; aksi halde bir kare daha
    -- dribble dongusu topu ayaga ceker (saldirgan yerel itis + ping yarisi).
    if isHard then
        ballControl.owner = 0
    else
        ballControl.owner = tonumber(attackerSrc) or 0
    end
    if matchData then
        matchData.ballOwner = ballControl.owner
    end
    ballControl.shootHoldStart = nil
    ballControl.crossHoldStart = nil
    SetShotChargeUI(false, 0.0)

    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsEntityDead(ped) then return end
    if IsPedInAnyVehicle(ped, false) then return end
    if IsPedRagdoll(ped) then return end

    -- Futbol-uyumlu stumble animasyonlari:
    --  * Hard: reaction@shove_back (sarhoş idle'dan belirgin futbol "sendeleme").
    --  * Stand: kisa shove reaksiyonu.
    -- Flag 48 = 16 (player control) + 32 (cancelable); LOOPING (1) yok.
    local dict, clip, animMs
    if isHard then
        dict = "reaction@shove"
        clip = "shove_back"
        animMs = 900
    else
        dict = "reaction@shove"
        clip = "shove_back"
        animMs = 420
    end

    if not LoadAnimDict(dict, 400) then
        -- reaction@shove pack'te yoksa en yakin mevcut fallback'e don.
        dict = "random@domestic"
        clip = "pickup_low"
        LoadAnimDict(dict, 400)
    end
    TaskPlayAnim(ped, dict, clip, 6.0, -4.0, animMs, 48, 0.0, false, false, false)

    -- Hard tackle'da hafif geriye itilme: saldirganin forward vector'u yonunde kisa bir push.
    -- Z hizini koruyoruz ki zemindeyken zipla/ucma olmasin.
    if isHard then
        local atkId = tonumber(attackerSrc) or 0
        if atkId ~= 0 then
            local atkPly = GetPlayerFromServerId(atkId)
            if atkPly ~= -1 then
                local atkPed = GetPlayerPed(atkPly)
                if atkPed and atkPed ~= 0 and DoesEntityExist(atkPed) then
                    local fwd = GetEntityForwardVector(atkPed)
                    local curVel = GetEntityVelocity(ped)
                    local keepZ = (curVel and curVel.z) or 0.0
                    SetEntityVelocity(ped, fwd.x * 3.0, fwd.y * 3.0, keepZ)
                end
            end
        end
    end

    -- R (hard slide): magdur oyuncu KESINLIKLE yere duser + top bosa dusmus durumda.
    -- Global anti-ragdoll thread'i bu pencere boyunca bypass edilir.
    -- Order: exemptUntil -> CanRagdoll(true) -> ClearPedTasks (guard'in hemen once kapatmasini ters cevir)
    -- -> SetPedToRagdoll. Boylece SHIFT+E yol acik, R yol gecici izinli.
    if isHard then
        local slideCfgHS = Config.SlideTackle or {}
        local rgMs = math.max(300, tonumber(slideCfgHS.VictimRagdollMs) or 1200)
        local nowRg = GetGameTimer()
        ballControl.ragdollExemptUntil = nowRg + rgMs
        SetSoccerPedRagdollBlocked(ped, false)
        if ResetPedRagdollTimer then
            ResetPedRagdollTimer(ped)
        end
        if SetPedToRagdoll then
            -- ragdollType 0 (RELAX) = dogal "trip and fall"; bounds gercekcidir.
            SetPedToRagdoll(ped, rgMs, rgMs, 0, false, false, false)
        end
    end

    -- Hareket kilidi: hard'da 1150ms (slide ~900ms'den belirgin uzun), stand'de 500ms, soft'da 260ms.
    local lockMs
    if isHard then lockMs = 1150
    elseif isStand then lockMs = 500
    else lockMs = 260 end
    local nowLock = GetGameTimer()
    ballControl.animLockUntil = nowLock + lockMs
    -- Hard slide: top bosa dusuyor; magdurun animLock bitsin bitmesin topu auto-claim etmesin.
    -- Pickup lock sureyi biraz daha ileriye tasir (saldirgan + magdur ayni tecrubeyi yasar).
    if isHard then
        local slideCfg = Config.SlideTackle or {}
        local popCfg = slideCfg.LooseBallPop or {}
        local victimLockMs = tonumber(popCfg.VictimPickupLockMs) or 1200
        local reclaimLockMs = math.max(victimLockMs, tonumber(popCfg.VictimReclaimBlockMs) or victimLockMs)
        ballControl.lastClaimTry = nowLock
        ballControl.pickupLockUntil = math.max(ballControl.pickupLockUntil or 0, nowLock + reclaimLockMs)
    end
    Bridge.Notify(L("client.ball_stolen_you"), "error", 1400)

    if fouled == true then
        Bridge.Notify(L("client.slide_back_foul"), "error", 1600)
    end
end)

-- Hirsiza basari bildirimi (sesli/gorsel feedback icin).
RegisterNetEvent('seoul_soccer:client:BallStealSuccess', function(mode, fouled)
    local key
    if mode == "hard" then key = "client.ball_stolen_success_hard"
    elseif mode == "stand" then key = "client.stand_tackle_success"
    else key = "client.ball_stolen_success" end
    if mode == "soft" then
        local softCfg = (Config.StealSystem or {}).SoftSteal or {}
        local postGuardMs = tonumber(softCfg.PostStealGuardMs) or 2500
        StartSoftPostStealGuard(tonumber(ballControl.softContactGuardTarget) or tonumber(ballControl.softStealOwnerAtStart) or 0, postGuardMs)
    elseif mode == "hard" then
        ballControl.lastHardStealSuccessAt = GetGameTimer()
    end
    Bridge.Notify(L(key), "success", 1200)
    if fouled == true then
        Bridge.Notify(L("client.slide_back_foul"), "warning", 1600)
    end
end)

-- Slide tackle sonrasi top bosta: server onayi geldiginde calisir.
-- Event geri uyumlu: eski sunucu sadece (lobbyId) gonderir; yeni sunucu ek arg'lar gonderebilir.
--   (lobbyId)
--   (lobbyId, attackerSrc, ballNetId, fwd, stampMs)
RegisterNetEvent('seoul_soccer:client:LooseBallAfterSlide', function(lobbyId, attackerSrc, ballNetId, fwd, stampMs)
    if not matchData or tonumber(matchData.lobbyId) ~= tonumber(lobbyId) then return end
    local slideCfg = Config.SlideTackle or {}
    local popCfg = slideCfg.LooseBallPop or {}
    local popLockMs = tonumber(popCfg.AttackerPickupLockMs) or 1000
    ballControl.pickupLockUntil = math.max(ballControl.pickupLockUntil or 0, GetGameTimer() + popLockMs)

    local useFwd = nil
    if type(fwd) == "table" and tonumber(fwd.x) and tonumber(fwd.y) then
        useFwd = { x = tonumber(fwd.x) or 0.0, y = tonumber(fwd.y) or 0.0, z = tonumber(fwd.z) or 0.0 }
    else
        useFwd = ballControl.slideLastFwd
        local fwdAt = tonumber(ballControl.slideLastFwdAt) or 0
        if not useFwd or (GetGameTimer() - fwdAt) > 1200 then
            return
        end
    end

    local resolvedNet = tonumber(ballNetId) or 0
    local ballEnt = nil
    if resolvedNet ~= 0 and NetworkGetEntityFromNetworkId then
        ballEnt = NetworkGetEntityFromNetworkId(resolvedNet)
    end
    if not ballEnt or ballEnt == 0 or not DoesEntityExist(ballEnt) then
        ballEnt = TryResolveBallEntity()
    end
    if not ballEnt or ballEnt == 0 then
        return
    end

    local stamp = tonumber(stampMs) or 0
    local netIdForStamp = resolvedNet
    if stamp > 0 and netIdForStamp == 0 and NetworkGetNetworkIdFromEntity then
        netIdForStamp = NetworkGetNetworkIdFromEntity(ballEnt) or 0
    end
    if stamp > 0 and netIdForStamp ~= 0 then
        _G.__0rSoccerLoosePopStamps = _G.__0rSoccerLoosePopStamps or {}
        local lastStamp = tonumber(_G.__0rSoccerLoosePopStamps[netIdForStamp]) or 0
        if lastStamp >= stamp then
            return
        end
        _G.__0rSoccerLoosePopStamps[netIdForStamp] = stamp
    end

    local function canSkipBecauseAlreadyMoved(attSrc)
        if not GetEntitySpeed then return false end
        local spd = GetEntitySpeed(ballEnt) or 0.0
        if spd >= 2.4 then
            return true
        end
        attSrc = tonumber(attSrc) or 0
        if attSrc ~= 0 then
            local ply = GetPlayerFromServerId(attSrc)
            if ply ~= -1 then
                local ap = GetPlayerPed(ply)
                if ap and ap ~= 0 and DoesEntityExist(ap) then
                    local bp = GetEntityCoords(ballEnt)
                    local pp = GetEntityCoords(ap)
                    local dist = DistanceBetween(pp, bp)
                    if dist >= math.max(1.6, tonumber(popCfg.ForwardOffset) or 1.0) then
                        return true
                    end
                end
            end
        end
        return false
    end

    if canSkipBecauseAlreadyMoved(attackerSrc) then
        return
    end

    if not RequestBallControl then
        return
    end
    local hasControl = RequestBallControl(ballEnt)
    if not hasControl then
        local retryUntil = GetGameTimer() + 260
        while GetGameTimer() < retryUntil do
            Wait(40)
            if RequestBallControl(ballEnt) then
                hasControl = true
                break
            end
        end
    end
    if not hasControl then
        return
    end

    local nowLb = GetGameTimer()
    -- Fizik uygulanmadan hemen once: sahipsiz + kisa mıknatıs kesintisi (BallOwnerChanged gec gelirse bile).
    ballControl.owner = 0
    matchData.ballOwner = 0
    ballControl.looseSinceGameTimer = nowLb
    local ownerlessMs = math.max(400, tonumber(popCfg.OwnerlessMs) or 700)
    ballControl.autoClaimBlockedUntil = math.max(
        tonumber(ballControl.autoClaimBlockedUntil) or 0,
        nowLb + ownerlessMs
    )
    ballControl.dribbleMagnetSuspendedUntil = math.max(
        tonumber(ballControl.dribbleMagnetSuspendedUntil) or 0,
        nowLb + 450
    )

    -- Top cikisi: saldirgan ped'i (slide yapan). Stream disi / yoksa top koordinatindan ileri it.
    local originPed = nil
    local atkSrc = tonumber(attackerSrc) or 0
    if atkSrc ~= 0 then
        local atkPly = GetPlayerFromServerId(atkSrc)
        if atkPly ~= -1 then
            local ap = GetPlayerPed(atkPly)
            if ap and ap ~= 0 and DoesEntityExist(ap) then
                originPed = ap
            end
        end
    end

    local myPos
    local pedSpeed
    if originPed and DoesEntityExist(originPed) then
        myPos = GetEntityCoords(originPed)
        pedSpeed = GetEntitySpeed(originPed) or 0.0
    else
        myPos = GetEntityCoords(ballEnt)
        pedSpeed = math.max(3.8, tonumber(popCfg.MinSpeed) or 5.5)
    end

    local popMin = tonumber(popCfg.MinSpeed) or 5.5
    local popMax = tonumber(popCfg.MaxSpeed) or 9.0
    local popBonus = tonumber(popCfg.SpeedBonus) or 2.0
    local popLift = tonumber(popCfg.Lift) or 1.2
    local popForward = tonumber(popCfg.ForwardOffset) or 1.0
    local popHeightAbovePed = tonumber(popCfg.HeightAbovePed) or 0.55
    local popSpeed = math.max(popMin, math.min(pedSpeed + popBonus, popMax))

    SetEntityDynamic(ballEnt, true)
    if ActivatePhysics then ActivatePhysics(ballEnt) end
    if SetEntityCollision then SetEntityCollision(ballEnt, true, true) end
    -- Top zaten saldirgan clientinda push alindi ise bu ikinci coords snap idempotenttir.
    local tx = myPos.x + (useFwd.x * popForward)
    local ty = myPos.y + (useFwd.y * popForward)
    local tz = myPos.z + popHeightAbovePed
    SetEntityCoordsNoOffset(ballEnt, tx, ty, tz, false, false, false)
    SetEntityVelocity(ballEnt, useFwd.x * popSpeed, useFwd.y * popSpeed, popLift)
    if ApplyBallGroundRollAngularVelocity then
        ApplyBallGroundRollAngularVelocity(ballEnt, useFwd, popSpeed)
    end
end)

-- Eski knockdown event'i: tamamen kaldirildi. Geri uyumluluk icin bos handler biraktik;
-- eski surum sunucu bu event'i gonderirse client ragdoll olmasin.
RegisterNetEvent('seoul_soccer:client:HardTackled', function(attackerSrc, knockdownMs, recoveryMs, pushPower)
    return
end)

local function GetPitchById(pitchId)
    for _, pitch in ipairs(Config.Pitches or {}) do
        if pitch.id == pitchId then
            return pitch
        end
    end
    return nil
end

local lastInstantOobReportAt = 0

--- Config.PitchBounds.InstantBallOobCenterRespawn: top cizgi disina cikinca sunucuya bildir.
local function TryReportInstantBallOutOfBounds()
    local pb = Config.PitchBounds or {}
    if pb.InstantBallOobCenterRespawn ~= true then return end
    if not matchData or not matchData.lobbyId or not matchData.pitchId then return end
    local st = tostring(matchData.state or "")
    if st ~= "playing" and st ~= "paused" then return end

    local pitch = GetPitchById(matchData.pitchId)
    if not pitch or not pitch.coords then return end

    local radius = tonumber(pitch.radius) or 50.0
    local mult = tonumber(pb.BallOutOfBoundsRadiusMultiplier) or 2.75
    local maxDist = radius * mult
    local cx, cy = pitch.coords.x, pitch.coords.y

    local ballPos
    local ent = ballControl.entity
    if ent and ent ~= 0 and DoesEntityExist(ent) then
        ballPos = GetEntityCoords(ent)
    end
    if not ballPos then
        local netId = tonumber(matchData.ballNetId) or tonumber(ballControl.netId) or 0
        if netId ~= 0 and NetworkDoesNetworkIdExist and NetworkGetEntityFromNetworkId then
            local okNet, exists = pcall(NetworkDoesNetworkIdExist, netId)
            if okNet and exists then
                local e = NetworkGetEntityFromNetworkId(netId)
                if e and e ~= 0 and DoesEntityExist(e) then
                    ballPos = GetEntityCoords(e)
                end
            end
        end
    end
    if not ballPos then return end

    local dx = ballPos.x - cx
    local dy = ballPos.y - cy
    if math.sqrt((dx * dx) + (dy * dy)) <= maxDist then return end

    local now = GetGameTimer() or 0
    if now - lastInstantOobReportAt < 350 then return end
    lastInstantOobReportAt = now
    TriggerServerEvent('seoul_soccer:server:ReportBallOutOfBounds', matchData.lobbyId, ballPos.x, ballPos.y, ballPos.z)
end

CreateThread(function()
    while true do
        local pb = Config.PitchBounds or {}
        if pb.InstantBallOobCenterRespawn == true and matchData and matchData.lobbyId then
            TryReportInstantBallOutOfBounds()
            Wait(math.max(50, tonumber(pb.InstantBallOobClientCheckMs) or 100))
        else
            Wait(2000)
        end
    end
end)

--- Savunulan kale onune (saha merkezine dogru) marker konumu + renk (1=Kirmizi, 2=Mavi)
local function BuildGoalMarkerSlots(pitchId)
    local pitch = GetPitchById(pitchId)
    if not pitch or not pitch.coords or type(pitch.goals) ~= "table" then
        return {}
    end

    local fc = pitch.coords
    local gm = Config.GoalMarkers or {}
    local offset = math.max(0.0, tonumber(gm.OffsetTowardField) or 3.5)
    local zBump = tonumber(gm.ZBump) or 0.35
    local c1 = gm.Team1Color or { 240, 55, 55 }
    local c2 = gm.Team2Color or { 55, 145, 255 }

    local slots = {}
    for _, raw in ipairs(pitch.goals) do
        local g = GoalShared.NormalizeGoalEntry(raw)
        if not g then goto next_goal end
        local st = tonumber(g.scoringTeam)
        if st ~= 1 and st ~= 2 then goto next_goal end

        local defender = (st == 2) and 1 or 2
        local gc = vector3(
            (g.min.x + g.max.x) * 0.5,
            (g.min.y + g.max.y) * 0.5,
            (g.min.z + g.max.z) * 0.5
        )

        local dx = fc.x - gc.x
        local dy = fc.y - gc.y
        local len = math.sqrt((dx * dx) + (dy * dy))
        if len > 0.2 then
            dx = (dx / len) * offset
            dy = (dy / len) * offset
        else
            dx, dy = 0.0, 0.0
        end

        local pos = vector3(gc.x + dx, gc.y + dy, gc.z + zBump)
        local col = (defender == 1) and c1 or c2
        slots[#slots + 1] = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            defender = defender,
            r = tonumber(col[1]) or 255,
            g = tonumber(col[2]) or 50,
            b = tonumber(col[3]) or 50,
        }
        ::next_goal::
    end
    return slots
end

local function GoalMarkersShouldShow()
    if not matchData then return false end
    local st = tostring(matchData.state or "")
    local gm = Config.GoalMarkers or {}
    local during = gm.ShowDuring
    if type(during) == "table" then
        for _, name in ipairs(during) do
            if st == tostring(name) then return true end
        end
        return false
    end
    return st == "warmup"
end

local function GetTeamDisplayName(teamIndex)
    teamIndex = tonumber(teamIndex)
    if not matchData or (teamIndex ~= 1 and teamIndex ~= 2) then return "" end
    if teamIndex == 1 then
        return (matchData.team1 and matchData.team1.name) or L("defaults.team1_name")
    end
    return (matchData.team2 and matchData.team2.name) or L("defaults.team2_name")
end

local function GetMyTeamIndex()
    if not matchData then return 0 end
    local myTeam = tonumber(matchData.myTeam) or 0
    if myTeam == 1 or myTeam == 2 then return myTeam end

    local myId = GetPlayerServerId(PlayerId())
    for _, p in ipairs(((matchData.team1 or {}).players) or {}) do
        if tonumber(p.src) == myId then return 1 end
    end
    for _, p in ipairs(((matchData.team2 or {}).players) or {}) do
        if tonumber(p.src) == myId then return 2 end
    end
    return 0
end

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local width = math.min(0.28, 0.012 + (string.len(text) * 0.0048))
    DrawRect(screenX, screenY + 0.014, width, 0.032, 0, 0, 0, 105)

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r or 255, g or 255, b or 255, 230)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(screenX, screenY)
end

local function GoalMarkerResolveAlpha(gm)
    local base = math.floor(math.max(0, math.min(255, tonumber(gm.Alpha) or 140)))
    if gm.Pulse == false then return base end
    local speed = tonumber(gm.PulseSpeed) or 2.0
    local amp = math.max(0.0, math.min(0.9, tonumber(gm.PulseAmplitude) or 0.28))
    local t = (GetGameTimer() or 0) / 1000.0
    local wave = 0.5 + 0.5 * math.sin(t * speed)
    return math.floor(math.max(0, math.min(255, base * (1.0 - amp + amp * wave))))
end

local function DrawGoalMarkerShape(mtype, x, y, z, sx, sy, sz, r, g, b, a, bob, faceCam, rotZ)
    if not DrawMarker then return end
    DrawMarker(
        mtype,
        x + 0.0, y + 0.0, z + 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, rotZ or 0.0,
        sx, sy, sz,
        r, g, b, a,
        bob == true,
        faceCam == true,
        2,
        false,
        nil,
        nil,
        false
    )
end

local function DrawGoalMarkerLabels(slots, gm)
    if gm.ShowLabels == false or not slots or #slots == 0 then return end
    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    local playerPos = GetEntityCoords(ped)
    local maxDist = math.max(8.0, tonumber(gm.LabelDrawDistance) or 52.0)
    local zLabel = tonumber(gm.LabelZOffset) or 1.45
    local myTeam = GetMyTeamIndex()

    for _, m in ipairs(slots) do
        local dx = playerPos.x - m.x
        local dy = playerPos.y - m.y
        local dz = playerPos.z - m.z
        if math.sqrt((dx * dx) + (dy * dy) + (dz * dz)) > maxDist then goto next_label end

        local defender = tonumber(m.defender) or 0
        local teamName = GetTeamDisplayName(defender)
        local tr = tonumber(m.r) or 255
        local tg = tonumber(m.g) or 255
        local tb = tonumber(m.b) or 255

        local label = ""
        if myTeam == 1 or myTeam == 2 then
            if defender == myTeam then
                label = ("%s · %s"):format(L("client.goal_marker_yours"), teamName)
            else
                label = ("%s · %s"):format(L("client.goal_marker_opponent"), teamName)
            end
        else
            label = ("%s · %s"):format(teamName, L("client.goal_marker_neutral", defender))
        end

        if label ~= "" then
            DrawText3D(m.x, m.y, m.z + zLabel, label, tr, tg, tb)
        end
        ::next_label::
    end
end

local function DrawGoalMarkersForSlots(slots, gm)
    if not slots or #slots == 0 then return end
    gm = gm or {}
    local style = string.lower(tostring(gm.Style or "sign"))
    local alpha = GoalMarkerResolveAlpha(gm)

    for _, m in ipairs(slots) do
        local x, y, z = m.x, m.y, m.z
        local r, g, b = m.r, m.g, m.b

        if style == "sign" then
            if gm.ShowGroundPatch ~= false then
                local ring = gm.GroundRing or {}
                local sc = ring.Scale or { x = 1.75, y = 1.75, z = 0.14 }
                local mtype = tonumber(ring.Type) or 25
                DrawGoalMarkerShape(mtype, x, y, z - 0.02, sc.x, sc.y, sc.z, r, g, b, math.floor(alpha * 0.55), false, false)
            end
        elseif style == "chevron" then
            local mtype = tonumber(gm.MarkerType) or 2
            local sc = gm.Scale or {}
            DrawGoalMarkerShape(
                mtype, x, y, z,
                tonumber(sc.x) or 1.35, tonumber(sc.y) or 1.35, tonumber(sc.z) or 1.85,
                r, g, b, alpha,
                gm.BobUpAndDown == true, gm.FaceCamera == true
            )
        elseif style == "aura" then
            local aura = gm.Aura or {}
            local o = aura.OuterScale or { x = 3.35, y = 3.35, z = 0.14 }
            local i = aura.InnerScale or { x = 2.05, y = 2.05, z = 0.18 }
            local p = aura.PostScale or { x = 0.45, y = 0.45, z = 1.35 }
            DrawGoalMarkerShape(25, x, y, z - 0.03, o.x, o.y, o.z, r, g, b, math.floor(alpha * 0.55), false, false)
            DrawGoalMarkerShape(25, x, y, z - 0.02, i.x, i.y, i.z, r, g, b, alpha, false, false)
            DrawGoalMarkerShape(1, x, y, z + 0.35, p.x, p.y, p.z, r, g, b, math.floor(alpha * 0.72), false, false)
        elseif style == "minimal" then
            local ring = gm.GroundRing or {}
            local sc = ring.Scale or { x = 2.2, y = 2.2, z = 0.16 }
            local mtype = tonumber(ring.Type) or 25
            DrawGoalMarkerShape(mtype, x, y, z - 0.02, sc.x, sc.y, sc.z, r, g, b, alpha, false, false)
        else
            local ring = gm.GroundRing or {}
            local sc = ring.Scale or { x = 2.85, y = 2.85, z = 0.22 }
            local mtype = tonumber(ring.Type) or 25
            DrawGoalMarkerShape(mtype, x, y, z - 0.02, sc.x, sc.y, sc.z, r, g, b, math.floor(alpha * 0.62), false, false)
            DrawGoalMarkerShape(
                mtype, x, y, z - 0.015,
                sc.x * 0.62, sc.y * 0.62, sc.z * 1.15,
                r, g, b, alpha, false, false
            )
        end

        if style ~= "sign" and gm.DrawLight ~= false and DrawLightWithRange then
            local light = gm.Light or {}
            local lr = tonumber(light.Range) or 4.5
            local li = tonumber(light.Intensity) or 0.55
            local lz = tonumber(light.ZOffset) or 0.45
            DrawLightWithRange(x, y, z + lz, r, g, b, lr, li)
        end
    end

    if style == "sign" or gm.ShowLabels == true then
        DrawGoalMarkerLabels(slots, gm)
    end
end

local function GetTeamIndexForSrc(src)
    src = tonumber(src)
    if not matchData or not src or src == 0 then return 0 end
    for _, p in ipairs(((matchData.team1 or {}).players) or {}) do
        if tonumber(p.src) == src then return 1 end
    end
    for _, p in ipairs(((matchData.team2 or {}).players) or {}) do
        if tonumber(p.src) == src then return 2 end
    end
    return 0
end

--- Gol atan takim kickoff kilidinde topa fiziksel temas/ittirme yapamasin (SetEntityNoCollisionEntity).
local function UpdateKickoffBallCollisions()
    if not matchData or not matchData.lobbyId or not SetEntityNoCollisionEntity then return end
    local st = matchData.state
    if st ~= "playing" and st ~= "paused" and st ~= "countdown" then return end
    local ballEnt = TryResolveBallEntity()
    if not ballEnt or ballEnt == 0 or not DoesEntityExist(ballEnt) then return end

    local lock = matchData.kickoffLockActive == true
    local blocked = tonumber(matchData.kickoffBlockedTeam) or 0

    for _, ply in ipairs(GetActivePlayers()) do
        local oPed = GetPlayerPed(ply)
        if oPed and oPed ~= 0 and DoesEntityExist(oPed) then
            local src = GetPlayerServerId(ply)
            local team = GetTeamIndexForSrc(src)
            local noBall = lock and blocked ~= 0 and team == blocked
            SetEntityNoCollisionEntity(oPed, ballEnt, noBall)
            SetEntityNoCollisionEntity(ballEnt, oPed, noBall)
        end
    end
end

CreateThread(function()
    while true do
        if matchData and matchData.lobbyId then
            UpdateKickoffBallCollisions()
            Wait(75)
        else
            Wait(2000)
        end
    end
end)

local function GetPlayerJerseyNumberBySrc(src)
    src = tonumber(src)
    if not matchData or not src or src == 0 then return nil end
    for _, p in ipairs(((matchData.team1 or {}).players) or {}) do
        if tonumber(p.src) == src then
            return ResolveJerseyNumber(p.jerseyNumber)
        end
    end
    for _, p in ipairs(((matchData.team2 or {}).players) or {}) do
        if tonumber(p.src) == src then
            return ResolveJerseyNumber(p.jerseyNumber)
        end
    end
    return nil
end

local function GetMyJerseyNumber()
    return GetPlayerJerseyNumberBySrc(GetPlayerServerId(PlayerId()))
end

-- ─────────────────────────────────────────────
-- Takım Formaları (Uniform System)
--   Config.Uniforms konfigurasyonundaki "en son drawable" sentinel'lerini runtime'da
--   GetNumberOfPedDrawableVariations ile cozer. Boylece kiyafet pack'i eklenip
--   cikarildiginda forma otomatik dogru drawable'a oturur.
-- ─────────────────────────────────────────────
local UNIFORM_COMPONENT_MAP = {
    ["mask"]    = { slot = 1,  kind = "comp" },
    ["arms"]    = { slot = 3,  kind = "comp" },
    ["pants"]   = { slot = 4,  kind = "comp" },
    ["bag"]     = { slot = 5,  kind = "comp" },
    ["shoes"]   = { slot = 6,  kind = "comp" },
    ["chain"]   = { slot = 7,  kind = "comp" },
    ["t-shirt"] = { slot = 8,  kind = "comp" },
    ["bproof"]  = { slot = 9,  kind = "comp" },
    ["decals"]  = { slot = 10, kind = "comp" },
    ["torso2"]  = { slot = 11, kind = "comp" },
    ["hat"]     = { slot = 0,  kind = "prop" },
    ["glass"]   = { slot = 1,  kind = "prop" },
    ["ear"]     = { slot = 2,  kind = "prop" },
}

--- GTA freemode: bazi parcalar (ozellikle torso2=11) uygulaninca decals=10 texture sifirlanir.
--- `pairs(outfit)` sirasiz oldugu icin bazen decals once torso2 sonra gelir ve numara yanlis kalir.
--- Sabit sira: taban katmanlar -> torso2 -> prop'lar -> decals en sonda (numara/her zaman son yazar).
local UNIFORM_APPLY_ORDER = {
    "mask", "arms", "pants", "bag", "shoes", "chain",
    "t-shirt", "bproof",
    "torso2",
    "hat", "glass", "ear",
    "decals",
}

local savedAppearance = nil
local currentUniformTeam = 0

local function UniformIsMaleFreemode(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return true end
    -- MP freemode: model hash en guvenilir yol (IsPedMale bazı build'lerde yok / yanlis donebilir).
    if GetEntityModel then
        local m = GetEntityModel(ped)
        local hF = GetHashKey("mp_f_freemode_01")
        local hM = GetHashKey("mp_m_freemode_01")
        if m == hF then return false end
        if m == hM then return true end
    end
    if IsPedMale then
        local ok, isMale = pcall(IsPedMale, ped)
        if ok then return isMale == true end
    end
    return true
end

local function GetUniformCollectionName()
    local cfg = Config.UniformCollection or {}
    if cfg.Enabled == false then return nil end
    local name = tostring(cfg.Name or "as_football")
    if name == "" then return nil end
    return name
end

local function GetCollectionDrawableCount(ped, slot, collectionName)
    if not collectionName or type(GetNumberOfPedCollectionDrawableVariations) ~= "function" then return 0 end
    local ok, count = pcall(GetNumberOfPedCollectionDrawableVariations, ped, slot, collectionName)
    return ok and math.max(0, tonumber(count) or 0) or 0
end

local function GetCollectionTextureCount(ped, slot, collectionName, drawable)
    if not collectionName or type(GetNumberOfPedCollectionTextureVariations) ~= "function" then return 0 end
    local ok, count = pcall(GetNumberOfPedCollectionTextureVariations, ped, slot, collectionName, drawable)
    return ok and math.max(0, tonumber(count) or 0) or 0
end

local function SetCollectionComponent(ped, slot, collectionName, drawable, texture)
    if type(SetPedCollectionComponentVariation) ~= "function" then return false end
    if type(IsPedCollectionComponentVariationValid) == "function" then
        local ok, valid = pcall(IsPedCollectionComponentVariationValid, ped, slot, collectionName, drawable, texture, 0)
        if ok and valid ~= true then return false end
    end
    local ok = pcall(SetPedCollectionComponentVariation, ped, slot, collectionName, drawable, texture, 0)
    return ok
end

local function ResolveUniformDrawable(ped, slot, kind, cfgItem, cfgFallback)
    local count
    if kind == "prop" then
        count = GetNumberOfPedPropDrawableVariations(ped, slot)
    else
        count = GetNumberOfPedDrawableVariations(ped, slot)
    end
    count = tonumber(count) or 0
    cfgItem = tonumber(cfgItem) or 0

    -- Prop: config'te item=-1 "prop kaldir" (GTA drawable -1). Component sentinel degil.
    if kind == "prop" and cfgItem == -1 then
        return -1
    end

    local resolved
    if cfgItem < 0 then
        resolved = count + cfgItem
    else
        resolved = cfgItem
    end

    if cfgFallback ~= nil then
        local fb = tonumber(cfgFallback)
        if fb and (resolved < 0 or resolved < fb) then
            resolved = fb
        end
    end

    if kind == "prop" then
        if resolved < -1 then resolved = -1 end
        if count > 0 and resolved >= count then resolved = count - 1 end
    else
        if resolved < 0 then resolved = 0 end
        if count > 0 and resolved >= count then resolved = count - 1 end
    end
    return resolved
end

local function ResolveUniformTexture(ped, slot, drawable, kind, cfgTex, cfgFallbackTex)
    if kind == "prop" and (drawable or -1) == -1 then return 0 end

    local txCount
    if kind == "prop" then
        txCount = GetNumberOfPedPropTextureVariations(ped, slot, drawable)
    else
        txCount = GetNumberOfPedTextureVariations(ped, slot, drawable)
    end
    txCount = tonumber(txCount) or 0
    cfgTex = tonumber(cfgTex) or 0

    local resolved
    if cfgTex < 0 then
        resolved = txCount + cfgTex
    else
        resolved = cfgTex
    end

    if cfgFallbackTex ~= nil then
        local fb = tonumber(cfgFallbackTex)
        if fb and (resolved < 0 or resolved < fb) then
            resolved = fb
        end
    end

    if resolved < 0 then resolved = 0 end
    if txCount > 0 and resolved >= txCount then resolved = txCount - 1 end
    return resolved
end

local function SnapshotAppearance(ped)
    ped = ped or PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return nil end
    local snap = { comps = {}, props = {} }
    for _, entry in pairs(UNIFORM_COMPONENT_MAP) do
        if entry.kind == "comp" then
            snap.comps[entry.slot] = {
                drawable = (GetPedDrawableVariation and GetPedDrawableVariation(ped, entry.slot)) or 0,
                texture  = (GetPedTextureVariation and GetPedTextureVariation(ped, entry.slot)) or 0,
                palette  = (GetPedPaletteVariation and GetPedPaletteVariation(ped, entry.slot)) or 0,
            }
        else
            snap.props[entry.slot] = {
                drawable = (GetPedPropIndex and GetPedPropIndex(ped, entry.slot)) or -1,
                texture  = (GetPedPropTextureIndex and GetPedPropTextureIndex(ped, entry.slot)) or 0,
            }
        end
    end
    return snap
end

local function RestoreAppearance(snap)
    if not snap then return end
    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    for slot, v in pairs(snap.comps or {}) do
        if SetPedComponentVariation then
            SetPedComponentVariation(ped, slot, tonumber(v.drawable) or 0, tonumber(v.texture) or 0, tonumber(v.palette) or 0)
        end
    end
    for slot, v in pairs(snap.props or {}) do
        local d = tonumber(v.drawable)
        if d == nil or d == -1 then
            if ClearPedProp then ClearPedProp(ped, slot) end
        else
            if SetPedPropIndex then
                SetPedPropIndex(ped, slot, d, tonumber(v.texture) or 0, true)
            end
        end
    end
end

local function ResolveNumberTexture(entry, jerseyNumber)
    if type(entry) ~= "table" then return nil end
    local number = ResolveJerseyNumber(jerseyNumber)
    if type(entry.numberTextures) == "table" then
        local mapped = entry.numberTextures[number]
        if mapped == nil then
            mapped = entry.numberTextures[tostring(number)]
        end
        if mapped ~= nil then
            return mapped
        end
    end
    local offset = tonumber(entry.numberTextureOffset)
    if offset == nil then offset = -1 end
    return number + offset
end

--- Kadin (torso2): numara ayri drawable. Pack duzeni: [Kirmizi #1..#10][Mavi #1..#10] sonda;
--- Mavi #10 = son index (count-1), Kirmizi #10 = ondan tam bir blok once (count-1-maxJersey).

local function ApplyUniformToPed(ped, outfit, jerseyNumber, teamIndex)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    if type(outfit) ~= "table" then return end
    teamIndex = tonumber(teamIndex) or 0
    local collectionName = GetUniformCollectionName()
    local isMale = UniformIsMaleFreemode(ped)

    local function tryCollectionUniform(name, entry, slot, kind)
        if kind ~= "comp" or not collectionName then return false end

        -- O pack as_football usa indexes locais estáveis:
        -- masculino torso2: drawable 0=vermelho, 1=azul; textura 0..9 = camisa 1..10.
        -- feminino torso2: drawables 0..9=vermelho #1..#10, 10..19=azul #1..#10.
        if name == "torso2" then
            local n = ResolveJerseyNumber(jerseyNumber)
            local drawable, texture
            if isMale then
                -- Config original: team A = ultimo drawable da collection (1), team B = penultimo (0).
                drawable = (teamIndex == 2) and 0 or 1
                texture = math.max(0, n - 1)
            else
                drawable = ((teamIndex == 2) and 10 or 0) + math.max(0, n - 1)
                texture = 0
            end
            local count = GetCollectionDrawableCount(ped, slot, collectionName)
            if count > 0 and drawable < count then
                local txCount = GetCollectionTextureCount(ped, slot, collectionName, drawable)
                if txCount <= 0 or texture < txCount then
                    return SetCollectionComponent(ped, slot, collectionName, drawable, texture)
                end
            end
            return false
        end

        -- Pants/shoes do mesmo pack: usa index local esperado por equipe/gênero.
        if name == "pants" or name == "shoes" then
            local localIndex
            if isMale then
                -- Masculino: vermelho usa o segundo drawable; azul usa o primeiro.
                localIndex = (teamIndex == 2) and 0 or 1
            elseif name == "pants" then
                -- Feminino pants: vermelho primeiro; azul segundo.
                localIndex = (teamIndex == 2) and 1 or 0
            else
                -- Feminino shoes: vermelho segundo; azul primeiro.
                localIndex = (teamIndex == 2) and 0 or 1
            end
            local count = GetCollectionDrawableCount(ped, slot, collectionName)
            if count > localIndex then
                return SetCollectionComponent(ped, slot, collectionName, localIndex, 0)
            end
        end
        return false
    end

    local function applyOne(name, entry)
        local mapped = UNIFORM_COMPONENT_MAP[name]
        if not mapped or type(entry) ~= "table" then return end
        local slot, kind = mapped.slot, mapped.kind

        if tryCollectionUniform(name, entry, slot, kind) then return end

        -- Fallback global para servidores sem suporte às collection natives ou pack ausente.
        if entry.usePlayerNumberAsDrawable == true and kind == "comp" then
            local count = tonumber(GetNumberOfPedDrawableVariations(ped, slot)) or 0
            local minN, maxJersey, defN = GetUniformNumberConfig()
            local n = ResolveJerseyNumber(jerseyNumber)
            if n < minN then n = minN end
            if n > maxJersey then n = maxJersey end
            if n < 1 then n = defN end
            local delta = maxJersey - n
            local lastIdx = math.max(0, count - 1)
            local drawable
            if teamIndex == 2 then
                drawable = lastIdx - delta
            elseif teamIndex == 1 then
                drawable = (lastIdx - maxJersey) - delta
            else
                drawable = ResolveUniformDrawable(ped, slot, kind, entry.item, entry.fallbackItem)
            end
            if drawable < 0 then drawable = 0 end
            if count > 0 and drawable >= count then drawable = count - 1 end
            local texture = ResolveUniformTexture(ped, slot, drawable, kind, entry.texture, entry.fallbackTexture)
            if SetPedComponentVariation then SetPedComponentVariation(ped, slot, drawable, texture, 0) end
            return
        end

        local drawable = ResolveUniformDrawable(ped, slot, kind, entry.item, entry.fallbackItem)
        local textureCfg = entry.texture
        if entry.usePlayerNumber == true and entry.usePlayerNumberAsDrawable ~= true then
            textureCfg = ResolveNumberTexture(entry, jerseyNumber)
        end
        local texture = ResolveUniformTexture(ped, slot, drawable, kind, textureCfg, entry.fallbackTexture)

        if kind == "prop" then
            if drawable == -1 then
                if ClearPedProp then ClearPedProp(ped, slot) end
            else
                if SetPedPropIndex then SetPedPropIndex(ped, slot, drawable, texture, true) end
            end
        elseif SetPedComponentVariation then
            SetPedComponentVariation(ped, slot, drawable, texture, 0)
        end
    end

    local applied = {}
    for _, name in ipairs(UNIFORM_APPLY_ORDER) do
        applied[name] = true
        applyOne(name, outfit[name])
    end
    for name, entry in pairs(outfit) do
        if not applied[name] then applyOne(name, entry) end
    end

    for _, name in ipairs({ "torso2", "decals" }) do
        local entry = outfit[name]
        if type(entry) == "table" and (entry.usePlayerNumber == true or entry.usePlayerNumberAsDrawable == true) then
            applyOne(name, entry)
        end
    end
end

function Uniform.Apply(teamIndex, jerseyNumber)
    teamIndex = tonumber(teamIndex) or 0
    if teamIndex ~= 1 and teamIndex ~= 2 then return end

    local uniCfg = Config.Uniforms or {}
    local teamKey = (teamIndex == 1) and "team_a" or "team_b"
    local teamData = uniCfg[teamKey]
    if type(teamData) ~= "table" then return end

    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    local genderKey = UniformIsMaleFreemode(ped) and "male" or "female"
    local outfit = ((teamData[genderKey]) or {}).outfitData
    if type(outfit) ~= "table" then
        outfit = (((teamData.male) or {}).outfitData) or (((teamData.female) or {}).outfitData)
    end
    if type(outfit) ~= "table" then return end

    if not savedAppearance then
        savedAppearance = SnapshotAppearance(ped)
    end

    ApplyUniformToPed(ped, outfit, jerseyNumber or GetMyJerseyNumber(), teamIndex)
    selectedJerseyNumber = ClampJerseyTextureId(jerseyNumber or GetMyJerseyNumber())
    currentUniformTeam = teamIndex
end

function Uniform.Remove()
    if savedAppearance then
        RestoreAppearance(savedAppearance)
        savedAppearance = nil
    end
    currentUniformTeam = 0
end

function Uniform.GetCurrentTeam()
    return currentUniformTeam
end

function Uniform.ReapplyIfTeamChanged()
    local newTeam = GetMyTeamIndex()
    if newTeam == currentUniformTeam then return end
    if newTeam == 1 or newTeam == 2 then
        Uniform.Apply(newTeam, GetMyJerseyNumber())
    else
        Uniform.Remove()
    end
end

local function GetGoalkeeperEntry(teamIndex)
    if not matchData or not matchData.goalkeepers then return nil end
    local keepers = matchData.goalkeepers
    return keepers[teamIndex] or keepers[tostring(teamIndex)]
end

local function GetGoalkeeperInfo(teamIndex)
    local entry = GetGoalkeeperEntry(teamIndex)
    if type(entry) == "table" then
        return tonumber(entry.src) or 0, entry.name
    end
    return tonumber(entry) or 0, nil
end

local function GetDefendingTeamForGoal(scoringTeam)
    scoringTeam = tonumber(scoringTeam)
    if scoringTeam == 1 then return 2 end
    if scoringTeam == 2 then return 1 end
    return 0
end

local function BuildGoalkeeperSlots(pitchId)
    local gk = Config.Goalkeeper or {}
    if gk.Enabled == false then return {} end

    local pitch = GetPitchById(pitchId)
    if not pitch or not pitch.coords or type(pitch.goals) ~= "table" then
        return {}
    end

    local offset = math.max(0.0, tonumber(gk.OffsetTowardField) or 2.8)
    local zOffset = tonumber(gk.TextZOffset) or 1.15
    local slots = {}

    for _, raw in ipairs(pitch.goals) do
        local goalBox = GoalShared.NormalizeGoalEntry(raw)
        if not goalBox then goto next_gk_goal end
        local defendingTeam = GetDefendingTeamForGoal(goalBox.scoringTeam)
        if defendingTeam ~= 1 and defendingTeam ~= 2 then goto next_gk_goal end

        local center = vector3(
            (goalBox.min.x + goalBox.max.x) * 0.5,
            (goalBox.min.y + goalBox.max.y) * 0.5,
            (goalBox.min.z + goalBox.max.z) * 0.5
        )

        local dx = pitch.coords.x - center.x
        local dy = pitch.coords.y - center.y
        local len = math.sqrt((dx * dx) + (dy * dy))
        if len > 0.2 then
            center = vector3(center.x + ((dx / len) * offset), center.y + ((dy / len) * offset), center.z)
        end

        slots[#slots + 1] = {
            team = defendingTeam,
            side = goalBox.side or ("Takim " .. tostring(defendingTeam) .. " kalesi"),
            x = center.x,
            y = center.y,
            z = center.z + zOffset,
        }

        ::next_gk_goal::
    end

    return slots
end

local function IsGoalkeeperStateActive()
    if not matchData or not matchData.lobbyId then return false end
    local state = matchData.state
    return state == "warmup" or state == "countdown" or state == "playing" or state == "paused"
end

local function GetClosestOwnGoalkeeperSlot(pos, maxDistance)
    if not pos or not matchData or not matchData.pitchId then return nil, nil end
    local myTeam = GetMyTeamIndex()
    if myTeam ~= 1 and myTeam ~= 2 then return nil, nil end

    maxDistance = tonumber(maxDistance) or 2.8
    local closestSlot = nil
    local closestDist = nil
    for _, slot in ipairs(BuildGoalkeeperSlots(matchData.pitchId)) do
        if slot.team == myTeam then
            local dx = pos.x - slot.x
            local dy = pos.y - slot.y
            local dz = pos.z - slot.z
            local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
            if dist <= maxDistance and (not closestDist or dist < closestDist) then
                closestSlot = slot
                closestDist = dist
            end
        end
    end

    return closestSlot, closestDist
end

local function IsMyGoalkeeper()
    local myTeam = GetMyTeamIndex()
    if myTeam ~= 1 and myTeam ~= 2 then return false, myTeam end
    local keeperSrc = GetGoalkeeperInfo(myTeam)
    return keeperSrc == GetPlayerServerId(PlayerId()), myTeam
end

local function IsMyGoalkeeperHolding()
    if not goalieControl.holding then return false end
    if ballControl.owner ~= GetPlayerServerId(PlayerId()) then return false end

    local myTeam = GetMyTeamIndex()
    if myTeam ~= 1 and myTeam ~= 2 then return false end
    local keeperSrc = GetGoalkeeperInfo(myTeam)
    if keeperSrc ~= GetPlayerServerId(PlayerId()) then return false end

    return true
end

--- Mac topu modeli (ozellikle addon prop) istemcide yuklu degilse ag entity bazen gorunmez kalir
local function WaitForMatchBallModel()
    if not matchData then return end
    local bs = Config.BallStreaming or {}
    local timeoutMs = tonumber(bs.ModelLoadTimeoutMs) or 15000
    local modelName = matchData.ballModel
    if not modelName or modelName == "" then return end
    local h = GetHashKey(modelName)
    local okModel = (IsModelValid and IsModelValid(h)) or (IsModelInCdimage and IsModelInCdimage(h))
    if not okModel then return end
    if HasModelLoaded(h) then return end
    RequestModel(h)
    local t0 = GetGameTimer()
    while not HasModelLoaded(h) and (GetGameTimer() - t0) < timeoutMs do
        RequestModel(h)
        Wait(50)
    end
end

local function EnsureBallVisibility(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    local netId = 0
    if NetworkGetNetworkIdFromEntity then
        netId = NetworkGetNetworkIdFromEntity(entity) or 0
    end

    local bs = Config.BallStreaming or {}
    local lodDist = math.floor(tonumber(bs.LodDist) or 65535)
    local cullRadius = tonumber(bs.CullingRadius) or 15000.0
    local reapplyMs = tonumber(bs.ReapplyVisibilityMs)
    if reapplyMs == nil then reapplyMs = 2500 end

    local now = GetGameTimer()
    if netId ~= 0 and ballControl.visibilityNetId == netId and reapplyMs > 0 then
        if (now - (ballControl.lastLodApplyAt or 0)) < reapplyMs then
            return
        end
    end

    ballControl.lastLodApplyAt = now
    if netId ~= 0 then
        ballControl.visibilityNetId = netId
    end

    if SetEntityAsMissionEntity then
        SetEntityAsMissionEntity(entity, true, false)
    end
    if SetEntityVisible then
        SetEntityVisible(entity, true, false)
    end
    if ResetEntityAlpha then
        pcall(ResetEntityAlpha, entity)
    elseif SetEntityAlpha then
        pcall(SetEntityAlpha, entity, 255, false)
    end
    if SetEntityLodDist then
        SetEntityLodDist(entity, lodDist)
    end
    if SetEntityDistanceCullingRadius then
        SetEntityDistanceCullingRadius(entity, cullRadius)
    end
end

TryResolveBallEntity = function()
    local now = GetGameTimer and GetGameTimer() or 0
    if ballControl.entity and DoesEntityExist(ballControl.entity) then
        local expectedNet = (matchData and tonumber(matchData.ballNetId)) or 0
        local bs = Config.BallStreaming or {}
        local reapplyMs = tonumber(bs.ReapplyVisibilityMs)
        if reapplyMs == nil then reapplyMs = 2500 end
        local needsVisibilityRefresh = reapplyMs <= 0 or (now - (ballControl.lastLodApplyAt or 0)) >= reapplyMs
        if expectedNet ~= 0 and NetworkGetNetworkIdFromEntity then
            if ballControl.entityNetId == expectedNet
                and (now - (tonumber(ballControl.lastEntityNetCheckAt) or 0)) < 500
            then
                if needsVisibilityRefresh then
                    EnsureBallVisibility(ballControl.entity)
                end
                return ballControl.entity
            end
            local nid = NetworkGetNetworkIdFromEntity(ballControl.entity) or 0
            ballControl.entityNetId = nid
            ballControl.lastEntityNetCheckAt = now
            if nid == 0 or nid ~= expectedNet then
                ballControl.entity = nil
                ballControl.entityNetId = 0
            else
                if needsVisibilityRefresh then
                    EnsureBallVisibility(ballControl.entity)
                end
                return ballControl.entity
            end
        else
            if needsVisibilityRefresh then
                EnsureBallVisibility(ballControl.entity)
            end
            return ballControl.entity
        end
    end

    if ballControl.netId and ballControl.netId ~= 0 and NetworkDoesNetworkIdExist(ballControl.netId) then
        local entity = NetworkGetEntityFromNetworkId(ballControl.netId)
        if entity and entity ~= 0 and DoesEntityExist(entity) then
            ballControl.entity = entity
            ballControl.entityNetId = ballControl.netId
            ballControl.lastEntityNetCheckAt = now
            EnsureBallVisibility(entity)
            return entity
        end
    end

    if not matchData or not matchData.pitchId then return nil end

    local perfC = (Config.Performance and Config.Performance.Client) or {}
    local missCacheMs = math.max(0, tonumber(perfC.BallResolveMissCacheMs) or 140)
    if missCacheMs > 0
        and (tonumber(ballControl.lastResolveMissAt) or 0) > 0
        and (now - (tonumber(ballControl.lastResolveMissAt) or 0)) < missCacheMs
    then
        return nil
    end

    local pitch = GetPitchById(matchData.pitchId)
    if not pitch or not pitch.coords then
        ballControl.lastResolveMissAt = now
        return nil
    end
    local center = pitch.coords

    local modelHash = GetHashKey(matchData.ballModel or "p_ld_soc_ball_01")
    local searchRadius = math.max(100.0, (pitch.radius or 50.0) * 2.75)
    local expectedNet = tonumber(matchData.ballNetId) or 0
    if expectedNet == 0 then
        expectedNet = tonumber(ballControl.netId) or 0
    end

    local function acceptEntity(entity)
        if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
        ballControl.entity = entity
        if NetworkGetNetworkIdFromEntity then
            local nid = NetworkGetNetworkIdFromEntity(entity) or 0
            if nid ~= 0 then
                ballControl.netId = nid
                ballControl.entityNetId = nid
                ballControl.lastEntityNetCheckAt = now
            elseif expectedNet ~= 0 then
                ballControl.netId = expectedNet
                ballControl.entityNetId = expectedNet
                ballControl.lastEntityNetCheckAt = now
            end
        elseif expectedNet ~= 0 then
            ballControl.netId = expectedNet
            ballControl.entityNetId = expectedNet
            ballControl.lastEntityNetCheckAt = now
        end
        EnsureBallVisibility(entity)
        ballControl.lastResolveMissAt = 0
        return entity
    end

    if expectedNet ~= 0 and GetGamePool and NetworkGetNetworkIdFromEntity and GetEntityModel then
        local okPool, pool = pcall(function() return GetGamePool("CObject") end)
        if okPool and type(pool) == "table" then
            for _, e in ipairs(pool) do
                if e and e ~= 0 and DoesEntityExist(e) then
                    local okM, m = pcall(GetEntityModel, e)
                    if okM and m == modelHash then
                        local nid = NetworkGetNetworkIdFromEntity(e) or 0
                        if nid ~= 0 and nid == expectedNet then
                            return acceptEntity(e)
                        end
                    end
                end
            end
        end
    end

    local entity = GetClosestObjectOfType(center.x, center.y, center.z, searchRadius, modelHash, false, false, false)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        if expectedNet ~= 0 and NetworkGetNetworkIdFromEntity then
            local nid = NetworkGetNetworkIdFromEntity(entity) or 0
            if nid ~= 0 and nid ~= expectedNet then
                ballControl.lastResolveMissAt = now
                return nil
            end
        end
        return acceptEntity(entity)
    end

    ballControl.lastResolveMissAt = now
    return nil
end

CreateThread(function()
    while true do
        if not matchData or not matchData.pitchId then
            Wait(2000)
            goto ball_vis_cont
        end
        Wait(400)
        if not matchData or not matchData.pitchId then
            goto ball_vis_cont
        end
        if (ballControl.netId or 0) == 0 and matchData.ballNetId and matchData.ballNetId ~= 0 then
            ballControl.netId = matchData.ballNetId
        end
        WaitForMatchBallModel()
        if not matchData then
            goto ball_vis_cont
        end
        if (ballControl.netId or 0) ~= 0 or (ballControl.entity and DoesEntityExist(ballControl.entity)) then
            TryResolveBallEntity()
        end
        ::ball_vis_cont::
    end
end)

local function DrawHorizontalRing(cx, cy, cz, radius, segments, r, g, b, a)
    if not DrawLine then return end
    segments = math.max(8, math.floor(tonumber(segments) or 24))
    radius = tonumber(radius) or 0.35
    local twoPi = 6.28318530718
    for i = 0, segments - 1 do
        local ang1 = (i / segments) * twoPi
        local ang2 = ((i + 1) / segments) * twoPi
        local x1 = cx + math.cos(ang1) * radius
        local y1 = cy + math.sin(ang1) * radius
        local x2 = cx + math.cos(ang2) * radius
        local y2 = cy + math.sin(ang2) * radius
        DrawLine(x1, y1, cz, x2, y2, cz, r, g, b, a)
    end
end

local function RgbaFromSpec(spec, r0, g0, b0, a0)
    if type(spec) ~= "table" then
        return r0, g0, b0, a0
    end
    local r = tonumber(spec[1] ~= nil and spec[1] or spec.r) or r0
    local g = tonumber(spec[2] ~= nil and spec[2] or spec.g) or g0
    local b = tonumber(spec[3] ~= nil and spec[3] or spec.b) or b0
    local a = tonumber(spec[4] ~= nil and spec[4] or spec.a) or a0
    return math.floor(math.max(0, math.min(255, r))),
        math.floor(math.max(0, math.min(255, g))),
        math.floor(math.max(0, math.min(255, b))),
        math.floor(math.max(0, math.min(255, a)))
end

--- Kuresel stroke: top yuzeyinde StrokeRings+1 adet enlem dairesi (latitude rings)
--- Her halka r*cos(phi) yaricapinda, r*sin(phi) yuksekliginde — tam kure profili.
local function DrawBallSphereStroke(pos, cfg)
    local r     = tonumber(cfg.StrokeRadius)   or 0.12
    local rings = math.max(1, math.floor(tonumber(cfg.StrokeRings)    or 4))
    local segs  = math.max(6, math.floor(tonumber(cfg.StrokeSegments) or 24))
    local sr, sg, sb, sa = RgbaFromSpec(cfg.StrokeColor, 255, 255, 255, 230)

    local halfPi = math.pi * 0.5
    for i = 0, rings do
        local phi  = -halfPi + (i / rings) * math.pi  -- -π/2 … +π/2
        local rRing = r * math.cos(phi)
        local zRing = pos.z + r * math.sin(phi)
        if rRing > 0.004 then
            DrawHorizontalRing(pos.x, pos.y, zRing, rRing, segs, sr, sg, sb, sa)
        end
    end
end

local function DrawBallOutlineRings(entity)
    local cfg = Config.BallOutline or {}
    if cfg.Enabled == false then return end
    local ok, pos = pcall(GetEntityCoords, entity)
    if not ok or not pos then return end

    if cfg.StrokeOnBall == true then
        DrawBallSphereStroke(pos, cfg)
        return
    end

    -- Eski halka modu (StrokeOnBall = false)
    local radius = tonumber(cfg.Radius) or 0.40
    local zOff   = tonumber(cfg.ZOffset) or 0.04
    local segs   = tonumber(cfg.Segments) or 40
    local cz     = pos.z + zOff

    local ir, ig, ib, ia   = RgbaFromSpec(cfg.InnerColor, 255, 235, 40, 245)
    local orR, og, ob, oa  = RgbaFromSpec(cfg.OuterColor, 255, 42, 42, 235)

    DrawHorizontalRing(pos.x, pos.y, cz, radius, segs, ir, ig, ib, ia)
    local outerMul = tonumber(cfg.OuterMul) or 1.22
    if outerMul > 1.001 then
        local zBump = tonumber(cfg.OuterZBump) or 0.03
        DrawHorizontalRing(pos.x, pos.y, cz + zBump, radius * outerMul, segs, orR, og, ob, oa)
    end
end

--- Motor outline (SetEntityDrawOutline): top prop'u "secili" gibi cizer; DrawLine'dan bagimsiz.
local ballOutlineLastEntity = 0

local function BallOutlineEntityNativeAvailable()
    return type(SetEntityDrawOutline) == "function"
end

local function ClearBallEntityOutline()
    if ballOutlineLastEntity ~= 0 and SetEntityDrawOutline then
        pcall(SetEntityDrawOutline, ballOutlineLastEntity, false)
    end
    ballOutlineLastEntity = 0
end

local function ApplyBallEntityOutline(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) or not SetEntityDrawOutline then return end
    local cfg = Config.BallOutline or {}
    local r, g, b, a = RgbaFromSpec(cfg.OutlineColor, 255, 235, 55, 255)
    if SetEntityDrawOutlineColor then
        pcall(SetEntityDrawOutlineColor, r, g, b, a)
    end
    if SetEntityDrawOutlineShader then
        local sh = tonumber(cfg.OutlineShader)
        if sh == nil then sh = 1 end
        pcall(SetEntityDrawOutlineShader, sh)
    end
    pcall(SetEntityDrawOutline, entity, true)
    ballOutlineLastEntity = entity
end

local function RequestBallControl(entity, timeoutMs)
    if not entity or entity == 0 then return false end
    if NetworkHasControlOfEntity(entity) then return true end

    timeoutMs = tonumber(timeoutMs) or 120
    local netId = 0
    if NetworkGetNetworkIdFromEntity then
        netId = NetworkGetNetworkIdFromEntity(entity) or 0
    end

    NetworkRequestControlOfEntity(entity)
    if netId ~= 0 and NetworkRequestControlOfNetworkId then
        NetworkRequestControlOfNetworkId(netId)
    end

    local timeoutAt = GetGameTimer() + timeoutMs
    while not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeoutAt do
        Wait(5)
        NetworkRequestControlOfEntity(entity)
        if netId ~= 0 and NetworkRequestControlOfNetworkId then
            NetworkRequestControlOfNetworkId(netId)
        end
    end
    return NetworkHasControlOfEntity(entity)
end

StopBallForGoalkeeperCatch = function(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    if not RequestBallControl(entity, 260) then return false end

    if FreezeEntityPosition then FreezeEntityPosition(entity, false) end
    if SetEntityDynamic then SetEntityDynamic(entity, true) end
    if ActivatePhysics then ActivatePhysics(entity) end
    SetEntityVelocity(entity, 0.0, 0.0, 0.0)
    if SetEntityAngularVelocity then
        SetEntityAngularVelocity(entity, 0.0, 0.0, 0.0)
    end
    return true
end

local function ClampNumber(value, minValue, maxValue)
    value = tonumber(value) or minValue
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function LerpNumber(minValue, maxValue, amount)
    return minValue + ((maxValue - minValue) * amount)
end

local function ApplyPowerCurve(amount, curve)
    amount = ClampNumber(amount or 0.0, 0.0, 1.0)
    curve = tonumber(curve) or 1.0
    if curve <= 0.0 then
        curve = 1.0
    end
    return amount ^ curve
end

local function GetBallActionConfig()
    return Config.BallActions or {}
end

--- Aktif mac topu icin yuvarlanma yaricapi (m); ozel prop buyuk/kucukse Config.Balls'da rollRadius verin
local function GetBallRollRadius()
    local cfg = GetBallActionConfig()
    local def = tonumber(cfg.DribbleRollRadius) or 0.11
    if def < 0.04 then def = 0.11 end
    local modelName = matchData and matchData.ballModel
    if not modelName or not Config.Balls then return def end
    for _, b in ipairs(Config.Balls) do
        if b and b.model == modelName then
            local r = tonumber(b.rollRadius)
            if r and r >= 0.04 then return r end
            break
        end
    end
    return def
end

--- Config.Balls syntheticRoll == false ise GTA fizigine birak (cift donus olmasin)
local function BallUsesSyntheticRoll()
    local modelName = matchData and matchData.ballModel
    if not modelName or not Config.Balls then return true end
    for _, b in ipairs(Config.Balls) do
        if b and b.model == modelName then
            return b.syntheticRoll ~= false
        end
    end
    return true
end

--- Yatay zeminde kayma: omega = gain * (worldUp x v) / R  (vanilla top fizigi; addon prop'larda elle gerekir)
local function ApplyBallGroundRollAngularVelocity(entity, dir, horizontalSpeed)
    if not BallUsesSyntheticRoll() then return end
    if not entity or entity == 0 or not dir or not SetEntityAngularVelocity then return end
    local speed = tonumber(horizontalSpeed) or 0.0
    if speed < 0.02 then
        SetEntityAngularVelocity(entity, 0.0, 0.0, 0.0)
        return
    end
    local cfg = GetBallActionConfig()
    local gain = tonumber(cfg.DribbleRollGain) or 1.0
    local r = GetBallRollRadius()
    local scale = gain / r
    local vx = dir.x * speed
    local vy = dir.y * speed
    local wx = -vy * scale
    local wy = vx * scale
    local maxW = tonumber(cfg.MaxSyntheticRollOmega) or 28.0
    if maxW > 0.0 then
        local mag = math.sqrt((wx * wx) + (wy * wy))
        if mag > maxW and mag > 0.001 then
            local s = maxW / mag
            wx, wy = wx * s, wy * s
        end
    end
    SetEntityAngularVelocity(entity, wx, wy, 0.0)
end

local function ApplyBallVelocity(entity, dir, horizontalSpeed, lift)
    if not entity or entity == 0 or not dir then return end
    SetEntityVelocity(entity, dir.x * horizontalSpeed, dir.y * horizontalSpeed, lift)
end

local function AcquireBallControlForAction(entity, cfg)
    local ent = entity
    if (not ent or ent == 0 or not DoesEntityExist(ent)) and TryResolveBallEntity then
        ent = TryResolveBallEntity()
    end
    if not ent or ent == 0 or not DoesEntityExist(ent) then
        return false, entity
    end

    local baseTimeout = math.max(80, tonumber((cfg or {}).ControlTimeoutMs) or 650)
    local retries = math.max(1, math.floor(tonumber((cfg or {}).ControlRetries) or 3))
    local stepMs = math.max(0, tonumber((cfg or {}).ControlRetryStepMs) or 180)

    for attempt = 1, retries do
        local timeoutMs = baseTimeout + ((attempt - 1) * stepMs)
        if RequestBallControl(ent, timeoutMs) then
            return true, ent
        end
        if TryResolveBallEntity then
            local refreshed = TryResolveBallEntity()
            if refreshed and refreshed ~= 0 and DoesEntityExist(refreshed) then
                ent = refreshed
            end
        end
        Wait(5)
    end
    return false, ent
end

--- Sut aninda topu ped ayagi hizasina yakin + zemin ustu (ped.z-0.9 cogu haritada yer alti)
local function GetKickBallSpawnCoords(ped, fwd, spawnOffset)
    local cfg = GetBallActionConfig()
    local pedPos = GetEntityCoords(ped)
    local zDown = tonumber(cfg.KickSpawnZBelowPed) or 0.42
    if zDown < 0.15 then zDown = 0.15 end
    if zDown > 1.2 then zDown = 1.2 end
    local clear = tonumber(cfg.KickSpawnGroundClearance) or 0.14
    local sx = pedPos.x + (fwd.x * spawnOffset)
    local sy = pedPos.y + (fwd.y * spawnOffset)
    local sz = pedPos.z - zDown
    if GetGroundZFor_3dCoord then
        local ok, r1, r2 = pcall(GetGroundZFor_3dCoord, sx + 0.0, sy + 0.0, pedPos.z + 4.0, false)
        local gz = nil
        if ok and r1 == true and type(r2) == "number" then
            gz = r2
        elseif ok and type(r1) == "number" then
            gz = r1
        end
        if gz and gz > -400.0 and gz < 2000.0 then
            sz = math.max(sz, gz + clear)
        end
    end
    if RequestCollisionAtCoord then
        pcall(RequestCollisionAtCoord, sx, sy, sz)
    end
    return sx, sy, sz
end

-- Vurus fiziğini tek yerden uygular. requireControl=true ise kontrol zorunlu,
-- false ise kontrol alinmasa da best-effort impulse dener.
local function ApplyBallImpulseFromPlayer(entity, ped, fwd, startX, startY, startZ, horizontalSpeed, lift, cfg, requireControl)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false, false end
    local hasControl = false
    local ctrlTryMs = math.max(0, tonumber((cfg or {}).NoControlRequestMs) or 40)
    if requireControl then
        hasControl = RequestBallControl(entity, math.max(80, ctrlTryMs))
        if not hasControl then
            return false, false
        end
    else
        hasControl = RequestBallControl(entity, ctrlTryMs)
    end

    SetEntityDynamic(entity, true)
    ActivatePhysics(entity)
    if SetEntityCollision then
        SetEntityCollision(entity, true, true)
    end
    if SetEntityRecordsCollisions then
        SetEntityRecordsCollisions(entity, true)
    end
    SetEntityCoordsNoOffset(entity, startX, startY, startZ, false, false, false)
    if SetEntityAngularVelocity then
        SetEntityAngularVelocity(entity, 0.0, 0.0, 0.0)
    end
    SetEntityVelocity(entity, 0.0, 0.0, 0.0)
    ApplyBallVelocity(entity, fwd, horizontalSpeed, lift)
    ApplyBallGroundRollAngularVelocity(entity, fwd, horizontalSpeed)

    -- Hold sadece kontrol bizdeyse anlamli; kontrolsuz durumda asiri trafik yaratmayalim.
    if hasControl then
        local holdMs = math.max(0, tonumber((cfg or {}).VelocityHoldMs) or 180)
        local intervalMs = math.max(10, tonumber((cfg or {}).VelocityHoldIntervalMs) or 20)
        if holdMs > 0 then
            local entRef = entity
            local dir = vector3(fwd.x, fwd.y, fwd.z)
            local speed = horizontalSpeed
            local liftValue = lift
            CreateThread(function()
                local endAt = GetGameTimer() + holdMs
                while GetGameTimer() < endAt do
                    Wait(intervalMs)
                    if not entRef or entRef == 0 or not DoesEntityExist(entRef) then return end
                    -- Kontrol yoksa kısa timeout ile yeniden dene; başarısız olsa bile
                    -- velocity uygulamaya devam et (lokal simülasyon kopar ama impulse gider).
                    if not NetworkHasControlOfEntity(entRef) then
                        RequestBallControl(entRef, 120)
                    end
                    ApplyBallVelocity(entRef, dir, speed, liftValue)
                    ApplyBallGroundRollAngularVelocity(entRef, dir, speed)
                end
            end)
        end
    end

    return true, hasControl
end

local function KickBall(entity, horizontalSpeed, lift)
    if (not entity or entity == 0 or not DoesEntityExist(entity)) and TryResolveBallEntity then
        entity = TryResolveBallEntity()
    end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    local ped = PlayerPedId()
    local camRot = GetGameplayCamRot(2)
    local camYawRad = math.rad(camRot.z)
    local camFwdX = -math.sin(camYawRad)
    local camFwdY = math.cos(camYawRad)
    local camFwdLen = math.sqrt(camFwdX * camFwdX + camFwdY * camFwdY)
    if camFwdLen > 0.001 then camFwdX = camFwdX / camFwdLen; camFwdY = camFwdY / camFwdLen end
    local fwd = { x = camFwdX, y = camFwdY, z = 0.0 }
    local pedSpeed = GetEntitySpeed(ped)
    local cfg = GetBallActionConfig()
    local spawnOffset = (tonumber(cfg.KickSpawnOffset) or 1.05) + math.min(0.55, pedSpeed * 0.10)
    local startX, startY, startZ = GetKickBallSpawnCoords(ped, fwd, spawnOffset)
    horizontalSpeed = math.max(0.0, tonumber(horizontalSpeed) or 0.0)
    lift = tonumber(lift) or 0.0

    local hasControl, controlledEnt = AcquireBallControlForAction(entity, cfg)
    if hasControl then
        local applied = ApplyBallImpulseFromPlayer(
            controlledEnt, ped, fwd, startX, startY, startZ, horizontalSpeed, lift, cfg, true
        )
        if applied then return true end
    end

    -- Fail-safe: kontrol alınamasa da lokal impulse dene (animasyon var ama top gitmiyor hissini azaltır).
    if cfg.AllowKickWithoutControl ~= false then
        local fallbackEnt = (controlledEnt and controlledEnt ~= 0 and DoesEntityExist(controlledEnt)) and controlledEnt or entity
        local applied = ApplyBallImpulseFromPlayer(
            fallbackEnt, ped, fwd, startX, startY, startZ, horizontalSpeed, lift, cfg, false
        )
        if applied then return true end
    end

    return false
end

--- Sut (F basili) basarili olduktan sonra topun arkasinda / uzerinde alev Ptfx (config: BallActions.Shot.ShotTrailFx).
local shotTrailPtfxReady = {}
local shotTrailSessionGen = 0
local shotTrailBallFireHandle = 0
local shotTrailBallFireEntity = 0

local function EnsureShotTrailPtfxAsset(asset)
    asset = tostring(asset or "core")
    if shotTrailPtfxReady[asset] then return true end
    if not RequestNamedPtfxAsset or not HasNamedPtfxAssetLoaded then return false end
    RequestNamedPtfxAsset(asset)
    local t0 = GetGameTimer()
    while not HasNamedPtfxAssetLoaded(asset) and (GetGameTimer() - t0) < 2200 do
        Wait(10)
    end
    if not HasNamedPtfxAssetLoaded(asset) then return false end
    shotTrailPtfxReady[asset] = true
    return true
end

local function GetShotTrailPowerFactor(initialHorizontalShotSpeed, shotCfg, charge)
    if charge ~= nil then
        return ClampNumber(charge, 0.0, 1.0)
    end
    local minSpeed = tonumber(shotCfg.MinSpeed) or 8.0
    local maxSpeed = tonumber(shotCfg.MaxSpeed) or 34.0
    local shotSpeed = tonumber(initialHorizontalShotSpeed) or minSpeed
    return ClampNumber((shotSpeed - minSpeed) / math.max(0.001, maxSpeed - minSpeed), 0.0, 1.0)
end

--- Pas haric: guc + sans kapisi (Config.ShotTrail / Shot.ShotTrailFx).
local function GetShotTrailGateConfig()
    local globalCfg = Config.ShotTrail or {}
    local ba = GetBallActionConfig()
    local fx = (ba.Shot or {}).ShotTrailFx or {}

    local chance = tonumber(globalCfg.SpawnChance)
    if chance == nil then chance = tonumber(fx.SpawnChance) end
    if chance == nil then chance = 0.42 end

    local minCharge = tonumber(globalCfg.MinCharge)
    if minCharge == nil then minCharge = tonumber(fx.MinCharge) end
    if minCharge == nil then minCharge = 0.58 end

    local minShotSpeed = tonumber(globalCfg.MinShotSpeed)
    if minShotSpeed == nil then minShotSpeed = tonumber(fx.MinShotSpeed) end
    if minShotSpeed == nil then minShotSpeed = 13.5 end

    return {
        spawnChance = ClampNumber(chance, 0.0, 1.0),
        minCharge = ClampNumber(minCharge, 0.0, 1.0),
        minShotSpeed = math.max(0.0, minShotSpeed),
    }
end

local function ShouldApplyShotTrailFx(horizontalSpeed, charge)
    local gate = GetShotTrailGateConfig()
    if charge ~= nil and charge < gate.minCharge then
        return false
    end
    local spd = tonumber(horizontalSpeed) or 0.0
    if spd < gate.minShotSpeed then
        return false
    end
    if gate.spawnChance <= 0.0 then
        return false
    end
    if gate.spawnChance >= 1.0 then
        return true
    end
    return math.random() < gate.spawnChance
end

local function LerpShotTrailRange(rangeSpec, fallbackMin, fallbackMax, power)
    local minVal = tonumber(rangeSpec and (rangeSpec.Min or rangeSpec.MinMs)) or fallbackMin
    local maxVal = tonumber(rangeSpec and (rangeSpec.Max or rangeSpec.MaxMs)) or fallbackMax
    if maxVal < minVal then minVal, maxVal = maxVal, minVal end
    return LerpNumber(minVal, maxVal, power)
end

local function GetShotTrailLayers(trail)
    local layers = trail.Layers
    if type(layers) == "table" and #layers > 0 then
        local out = {}
        for i = 1, #layers do
            local layer = layers[i]
            if type(layer) == "table" then
                out[#out + 1] = layer
            end
        end
        if #out > 0 then return out end
    end
    return {
        {
            Asset = trail.Asset or "scr_indep_fireworks",
            Effect = trail.Effect or "scr_indep_firework_trail_spawn",
            ScaleMul = 1.0,
            EveryNth = 1,
        },
    }
end

local function MergeShotTrailPreset(base, preset)
    local out = {}
    if type(base) == "table" then
        for k, v in pairs(base) do
            out[k] = v
        end
    end
    if type(preset) ~= "table" then
        return out
    end
    for k, v in pairs(preset) do
        if k ~= "id" and k ~= "labelKey" and k ~= "label" then
            out[k] = v
        end
    end
    if preset.Layers ~= nil then
        out.Layers = preset.Layers
    end
    if preset.BallFire ~= nil then
        out.BallFire = preset.BallFire
    end
    return out
end

--- Lobi host preset (I), rastgele (-1) veya config varsayilani.
--- forShot=true iken idx=-1 -> her sutte rastgele preset (1..n).
local function ResolveShotTrailFxConfig(forShot)
    local ba = GetBallActionConfig()
    local shot = ba.Shot or {}
    local base = shot.ShotTrailFx or {}
    local idx = 0
    if matchData and matchData.shotTrailPresetIndex ~= nil then
        idx = math.floor(tonumber(matchData.shotTrailPresetIndex) or 0)
    end
    if idx == -1 then
        if forShot ~= true then
            local off = MergeShotTrailPreset(base, {})
            off.Enabled = false
            off.Layers = {}
            if type(off.BallFire) == "table" then
                off.BallFire = { Enabled = false }
            end
            return off
        end
        local presets = Config.ShotTrailPresets or {}
        local n = type(presets) == "table" and #presets or 0
        if n < 1 then
            idx = 0
        else
            idx = math.random(1, n)
        end
    end
    if idx <= 0 then
        local off = MergeShotTrailPreset(base, {})
        off.Enabled = false
        off.Layers = {}
        if type(off.BallFire) == "table" then
            off.BallFire = { Enabled = false }
        end
        return off
    end
    local presets = Config.ShotTrailPresets or {}
    local preset = presets[idx]
    if type(preset) ~= "table" then
        return base
    end
    local out = MergeShotTrailPreset(base, preset)
    out.Enabled = preset.Enabled ~= false
    return out
end

local function CollectShotTrailAssets(trail, layers)
    local assets = {}
    for _, layer in ipairs(layers) do
        assets[tostring(layer.Asset or trail.Asset or "core")] = true
    end
    local ballFire = trail.BallFire
    if type(ballFire) == "table" and ballFire.Enabled ~= false then
        assets[tostring(ballFire.Asset or trail.Asset or "core")] = true
    end
    return assets
end

local function SpawnShotTrailPtfxBurst(asset, effect, px, py, pz, scale, networked, loopedMs)
    if not HasNamedPtfxAssetLoaded(asset) then return end
    if UseParticleFxAssetNextCall then
        UseParticleFxAssetNextCall(asset)
    end
    scale = math.max(0.08, math.min(2.8, tonumber(scale) or 0.12))
    loopedMs = math.floor(tonumber(loopedMs) or 0)

    if loopedMs > 0 and StartParticleFxLoopedAtCoord then
        local ok, handle = pcall(
            StartParticleFxLoopedAtCoord,
            effect, px + 0.0, py + 0.0, pz + 0.0, 0.0, 0.0, 0.0, scale, false, false, false, false
        )
        if ok and handle and handle ~= 0 and StopParticleFxLooped then
            CreateThread(function()
                Wait(loopedMs)
                pcall(StopParticleFxLooped, handle, false)
            end)
        end
        return
    end

    if networked and StartNetworkedParticleFxNonLoopedAtCoord then
        pcall(StartNetworkedParticleFxNonLoopedAtCoord, effect, px + 0.0, py + 0.0, pz + 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
    elseif StartParticleFxNonLoopedAtCoord then
        pcall(StartParticleFxNonLoopedAtCoord, effect, px + 0.0, py + 0.0, pz + 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
    end
end

local function ShotTrailLayerAssetReady(layer, trail, loadedAssets)
    local asset = tostring(layer.Asset or trail.Asset or "core")
    if type(loadedAssets) == "table" then
        return loadedAssets[asset] == true
    end
    return HasNamedPtfxAssetLoaded(asset)
end

local function SpawnShotTrailLayerBursts(layer, trail, px, py, pz, baseScale, networked, vel, loadedAssets)
    if not ShotTrailLayerAssetReady(layer, trail, loadedAssets) then return end

    local layerAsset = tostring(layer.Asset or trail.Asset or "scr_indep_fireworks")
    local layerEffect = tostring(layer.Effect or trail.Effect or "scr_indep_firework_trail_spawn")
    local layerScale = baseScale * (tonumber(layer.ScaleMul) or 1.0)
    local burstCount = math.max(1, math.min(4, math.floor(tonumber(layer.BurstCount) or tonumber(trail.BurstCount) or 1)))
    local zBump = tonumber(layer.ZBump) or tonumber(trail.ZBump) or 0.12
    local spread = math.max(0.0, tonumber(layer.Spread) or tonumber(trail.Spread) or 0.14)
    local loopedMs = tonumber(layer.LoopedMs) or tonumber(trail.LoopedMs) or 0

    local perpX, perpY = 0.0, 0.0
    if vel and (math.abs(vel.x) + math.abs(vel.y)) > 0.001 then
        local len = math.sqrt((vel.x * vel.x) + (vel.y * vel.y))
        if len > 0.001 then
            perpX = -vel.y / len
            perpY = vel.x / len
        end
    end

    for b = 1, burstCount do
        local side = (b == 1) and 0.0 or (((b % 2) == 0) and 1.0 or -1.0) * spread * (math.ceil(b / 2))
        local pzUse = pz + zBump + ((b - 1) * 0.04)
        SpawnShotTrailPtfxBurst(layerAsset, layerEffect, px + (perpX * side), py + (perpY * side), pzUse, layerScale, networked, loopedMs)
    end
end

local function StartBallShotFireLooped(entity, trail, power)
    local ballFire = trail.BallFire
    if type(ballFire) ~= "table" or ballFire.Enabled == false then return 0 end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return 0 end

    local asset = tostring(ballFire.Asset or trail.Asset or "core")
    local effect = tostring(ballFire.Effect or trail.Effect or "ent_sht_petrol_fire")
    if not EnsureShotTrailPtfxAsset(asset) then return 0 end
    if UseParticleFxAssetNextCall then
        UseParticleFxAssetNextCall(asset)
    end

    local fallbackScale = tonumber(trail.Scale) or 0.22
    local scale = LerpShotTrailRange(
        ballFire.ScaleFromShot,
        tonumber(ballFire.Scale) or (fallbackScale * 0.95),
        math.max((tonumber(ballFire.Scale) or fallbackScale) * 2.1, fallbackScale * 1.85),
        power
    )
    scale = math.max(0.06, scale)
    local off = ballFire.Offset or {}
    local ox = tonumber(off.x) or 0.0
    local oy = tonumber(off.y) or 0.0
    local oz = tonumber(off.z) or -0.03
    local networked = ballFire.Networked
    if networked == nil then networked = trail.Networked ~= false end

    if networked and StartNetworkedParticleFxLoopedOnEntity then
        local ok, handle = pcall(
            StartNetworkedParticleFxLoopedOnEntity,
            effect, entity, ox, oy, oz, 0.0, 0.0, 0.0, scale, false, false, false
        )
        if ok and handle then return handle end
    end
    if StartParticleFxLoopedOnEntity then
        local ok, handle = pcall(
            StartParticleFxLoopedOnEntity,
            effect, entity, ox, oy, oz, 0.0, 0.0, 0.0, scale, false, false, false
        )
        if ok and handle then return handle end
    end
    return 0
end

local function StopBallShotFireLooped(handle)
    if not handle or handle == 0 or not StopParticleFxLooped then return end
    pcall(StopParticleFxLooped, handle, false)
end

local function ClearBallEntityShotTrailPtfx(entity, handle)
    StopBallShotFireLooped(handle)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        if RemoveParticleFxFromEntity then
            pcall(RemoveParticleFxFromEntity, entity, false)
        end
    end
end

--- Gol / mac bitisi / yeni sut: tum aktif iz + top alevi (looped) iptal.
CancelActiveShotTrailFx = function()
    shotTrailSessionGen = shotTrailSessionGen + 1
    local ent = shotTrailBallFireEntity
    local handle = shotTrailBallFireHandle
    shotTrailBallFireHandle = 0
    shotTrailBallFireEntity = 0
    ClearBallEntityShotTrailPtfx(ent, handle)
end

local function ShotTrailBallSpeeds(vel)
    if not vel then return 0.0, 0.0 end
    local vx, vy, vz = vel.x + 0.0, vel.y + 0.0, vel.z + 0.0
    local spd3 = math.sqrt((vx * vx) + (vy * vy) + (vz * vz))
    local spd2 = math.sqrt((vx * vx) + (vy * vy))
    return spd3, spd2
end

local function ShotTrailResolveStopThresholds(trail)
    local stop3 = math.max(0.08, tonumber(trail.StopSpeed) or 0.52)
    local stop2 = math.max(0.06, tonumber(trail.StopHorizontalSpeed) or 0.4)
    local settledMs = math.max(0, math.floor(tonumber(trail.StopSettledMs) or 90))
    local hard3 = tonumber(trail.StopSpeedHard)
    local hard2 = tonumber(trail.StopHorizontalSpeedHard)

    if type(trail.BallFire) == "table" and trail.BallFire.Enabled ~= false then
        stop3 = math.min(stop3, tonumber(trail.BallFireStopSpeed) or 0.42)
        stop2 = math.min(stop2, tonumber(trail.BallFireStopHorizontalSpeed) or 0.34)
        settledMs = math.min(settledMs, math.floor(tonumber(trail.BallFireStopSettledMs) or 55))
        if hard3 == nil then hard3 = 0.26 end
        if hard2 == nil then hard2 = 0.2 end
    end

    if hard3 == nil then hard3 = 0.3 end
    if hard2 == nil then hard2 = 0.24 end
    return stop3, stop2, settledMs, hard3, hard2
end

--- Top durunca true: dusuk hiz + kisa sure sabit; cok yavas = daha hizli kes (alev loop icin).
local function ShotTrailBallHasStopped(ent, trail, slowSinceMs, lastPos, lastPosAtMs)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return true end
    local vel = GetEntityVelocity(ent)
    if not vel then return true end

    local spd3, spd2 = ShotTrailBallSpeeds(vel)
    local stop3, stop2, settledMs, hard3, hard2 = ShotTrailResolveStopThresholds(trail)
    local now = GetGameTimer() or 0

    if spd3 <= hard3 or spd2 <= hard2 then
        if not slowSinceMs then return false end
        local hardSettle = math.max(0, math.floor(tonumber(trail.StopSettledMsHard) or 35))
        if (now - slowSinceMs) < hardSettle then return false end
        return true
    end

    local isSlow = spd3 <= stop3 or spd2 <= stop2
    if not isSlow then
        return false
    end

    if settledMs > 0 then
        if not slowSinceMs then return false end
        if (now - slowSinceMs) < settledMs then return false end
    end

    local dispMs = math.max(0, math.floor(tonumber(trail.StopDisplacementMs) or 160))
    local dispMin = math.max(0.02, tonumber(trail.StopDisplacementMin) or 0.07)
    if dispMs > 0 and lastPos and lastPosAtMs and (now - lastPosAtMs) >= dispMs then
        local pos = GetEntityCoords(ent)
        if pos then
            local dx = pos.x - lastPos.x
            local dy = pos.y - lastPos.y
            local dz = pos.z - lastPos.z
            local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
            if dist > dispMin then
                return false
            end
        end
    end

    return true
end

local function BeginBallShotTrailFx(ballEntity, initialHorizontalShotSpeed, charge, forceBypassChance)
    if not forceBypassChance and not ShouldApplyShotTrailFx(initialHorizontalShotSpeed, charge) then
        return
    end

    local ba = GetBallActionConfig()
    local shotCfg = ba.Shot or {}
    local trail = ResolveShotTrailFxConfig(true)
    if trail.Enabled == false then return end

    local gate = GetShotTrailGateConfig()
    local minShot = math.max(gate.minShotSpeed, tonumber(trail.MinShotSpeed) or 0.0)
    if minShot > 0.0 and (tonumber(initialHorizontalShotSpeed) or 0.0) < minShot then
        return
    end

    local power = GetShotTrailPowerFactor(initialHorizontalShotSpeed, shotCfg, charge)
    local layers = GetShotTrailLayers(trail)
    local assets = CollectShotTrailAssets(trail, layers)

    local durationMs = math.floor(LerpShotTrailRange(
        trail.DurationFromShot,
        tonumber(trail.DurationMs) or 1050,
        math.max(tonumber(trail.DurationMs) or 1050, 1280),
        power
    ))
    durationMs = math.max(120, math.min(2400, durationMs))

    local intervalMs = math.max(14, math.min(200, tonumber(trail.IntervalMs) or 26))
    local behind = math.max(0.06, tonumber(trail.OffsetBehind) or 0.38)
    local baseScale = LerpShotTrailRange(
        trail.ScaleFromShot,
        tonumber(trail.Scale) or 0.22,
        math.max(tonumber(trail.Scale) or 0.22, 0.44),
        power
    )
    local spawnOnBall = trail.SpawnOnBall ~= false
    local ballZBump = tonumber(trail.BallZBump) or 0.18
    local minSpawnSpd = math.max(0.35, tonumber(trail.MinBallSpeed) or 1.15)
    local networked = trail.Networked == true
    local startDelayMs = math.max(0, tonumber(trail.StartDelayMs) or 300)
    local minDistPed = math.max(0.5, tonumber(trail.MinDistanceFromPed) or 1.35)

    CancelActiveShotTrailFx()
    local sessionGen = shotTrailSessionGen

    CreateThread(function()
        local loadedAssets = {}
        for asset in pairs(assets) do
            if EnsureShotTrailPtfxAsset(asset) then
                loadedAssets[asset] = true
            end
        end
        local hasReadyLayer = false
        for _, layer in ipairs(layers) do
            if ShotTrailLayerAssetReady(layer, trail, loadedAssets) then
                hasReadyLayer = true
                break
            end
        end
        if not hasReadyLayer then return end

        local ent = ballEntity
        local ped = PlayerPedId()
        local ballFireHandle = 0
        local stop3, stop2 = ShotTrailResolveStopThresholds(trail)

        local function endTrailFx()
            if ballFireHandle ~= 0 then
                ClearBallEntityShotTrailPtfx(ent, ballFireHandle)
                if shotTrailBallFireHandle == ballFireHandle then
                    shotTrailBallFireHandle = 0
                    shotTrailBallFireEntity = 0
                end
                ballFireHandle = 0
            end
        end

        if startDelayMs > 0 then
            local delayEnd = GetGameTimer() + startDelayMs
            while GetGameTimer() < delayEnd do
                if sessionGen ~= shotTrailSessionGen then return end
                Wait(25)
            end
        end

        if sessionGen ~= shotTrailSessionGen then return end

        if (trail.BallFire or {}).Enabled == true then
            ballFireHandle = StartBallShotFireLooped(ent, trail, power)
            if ballFireHandle and ballFireHandle ~= 0 then
                shotTrailBallFireHandle = ballFireHandle
                shotTrailBallFireEntity = ent
            end
        end

        local endAt = GetGameTimer() + durationMs
        local tick = 0
        local slowSinceMs = nil
        local lastPos = nil
        local lastPosAtMs = 0

        while GetGameTimer() < endAt do
            if sessionGen ~= shotTrailSessionGen then
                endTrailFx()
                return
            end
            if not ent or ent == 0 or not DoesEntityExist(ent) then
                endTrailFx()
                break
            end
            local vel = GetEntityVelocity(ent)
            if not vel then
                endTrailFx()
                break
            end
            local vx, vy, vz = vel.x + 0.0, vel.y + 0.0, vel.z + 0.0
            local spd, spd2 = ShotTrailBallSpeeds(vel)
            local now = GetGameTimer() or 0

            if spd <= stop3 or spd2 <= stop2 then
                if not slowSinceMs then slowSinceMs = now end
            else
                slowSinceMs = nil
            end

            local pos = GetEntityCoords(ent)
            if not pos then
                endTrailFx()
                break
            end

            if lastPos then
                local dx = pos.x - lastPos.x
                local dy = pos.y - lastPos.y
                local dz = pos.z - lastPos.z
                if math.sqrt((dx * dx) + (dy * dy) + (dz * dz)) >= 0.04 then
                    lastPos = vector3(pos.x, pos.y, pos.z)
                    lastPosAtMs = now
                end
            else
                lastPos = vector3(pos.x, pos.y, pos.z)
                lastPosAtMs = now
            end

            if ShotTrailBallHasStopped(ent, trail, slowSinceMs, lastPos, lastPosAtMs) then
                endTrailFx()
                break
            end

            local tooCloseToPed = false
            if ped and ped ~= 0 and DoesEntityExist(ped) then
                local pedPos = GetEntityCoords(ped)
                if pedPos then
                    local dx = pos.x - pedPos.x
                    local dy = pos.y - pedPos.y
                    local dz = pos.z - pedPos.z
                    tooCloseToPed = ((dx * dx) + (dy * dy) + (dz * dz)) < (minDistPed * minDistPed)
                end
            end

            if not tooCloseToPed and spd >= minSpawnSpd then
                tick = tick + 1
                local inv = 1.0 / math.max(0.001, spd)
                local bx, by, bz = pos.x + 0.0, pos.y + 0.0, pos.z + 0.0
                local px = bx - (vx * inv * behind)
                local py = by - (vy * inv * behind)
                local pz = bz - (vz * inv * behind) - 0.08

                local velForSpread = { x = vx, y = vy, z = vz }
                for _, layer in ipairs(layers) do
                    local everyNth = math.max(1, math.floor(tonumber(layer.EveryNth) or 1))
                    if (tick % everyNth) == 0 then
                        SpawnShotTrailLayerBursts(layer, trail, px, py, pz, baseScale, networked, velForSpread, loadedAssets)
                        if spawnOnBall then
                            SpawnShotTrailLayerBursts(layer, trail, bx, by, bz + ballZBump, baseScale * 0.92, networked, velForSpread, loadedAssets)
                        end
                    end
                end
            end

            Wait(intervalMs)
        end

        endTrailFx()
    end)
end

--- Baska bir oyuncunun sutu: lobideki diger istemcilerde sut izi (BeginBallShotTrailFx yalnizca sut sahibinde calisiyordu).
RegisterNetEvent('seoul_soccer:client:LobbyShotTrailFx', function(ballNetId, shotPower, charge)
    local nid = tonumber(ballNetId) or 0
    local sp = tonumber(shotPower)
    local ch = tonumber(charge)
    if nid == 0 or not sp or ch == nil then return end
    ch = math.max(0.0, math.min(1.0, ch))
    sp = math.max(0.0, math.min(55.0, sp))

    local st = Config.ShotTrail or {}
    if st.SyncRemoteShotTrailToLobby == false then return end

    CreateThread(function()
        local deadline = (GetGameTimer() or 0) + 900
        local ent = 0
        while (GetGameTimer() or 0) < deadline do
            if NetworkDoesNetworkIdExist and NetworkGetEntityFromNetworkId then
                local okExist, exists = pcall(NetworkDoesNetworkIdExist, nid)
                if okExist and exists then
                    local okEnt, e = pcall(NetworkGetEntityFromNetworkId, nid)
                    if okEnt and e and e ~= 0 and DoesEntityExist and DoesEntityExist(e) then
                        ent = e
                        break
                    end
                end
            end
            Wait(25)
        end
        if ent == 0 then return end
        BeginBallShotTrailFx(ent, sp, ch, true)
    end)
end)

local function GetPassVelocity(charge)
    local cfg = GetBallActionConfig()
    local passCfg = cfg.Pass or {}
    charge = ApplyPowerCurve(charge or 1.0, passCfg.PowerCurve or 1.0)

    local fallbackSpeed = tonumber(passCfg.Speed) or 8.0
    local fallbackLift = tonumber(passCfg.Lift) or 0.6
    local minSpeed = tonumber(passCfg.MinSpeed) or (fallbackSpeed * 0.5)
    local maxSpeed = tonumber(passCfg.MaxSpeed) or fallbackSpeed
    local minLift = tonumber(passCfg.MinLift) or (fallbackLift * 0.5)
    local maxLift = tonumber(passCfg.MaxLift) or fallbackLift

    return LerpNumber(minSpeed, maxSpeed, charge), LerpNumber(minLift, maxLift, charge)
end

local function GetShotVelocity(charge)
    local cfg = GetBallActionConfig()
    local shotCfg = cfg.Shot or {}
    charge = ApplyPowerCurve(charge or 0.0, shotCfg.PowerCurve or 1.0)
    local minSpeed = tonumber(shotCfg.MinSpeed) or 12.0
    local maxSpeed = tonumber(shotCfg.MaxSpeed) or 26.0
    local minLift = tonumber(shotCfg.MinLift) or 1.2
    local maxLift = tonumber(shotCfg.MaxLift) or 3.8
    return LerpNumber(minSpeed, maxSpeed, charge), LerpNumber(minLift, maxLift, charge)
end

local function GetCrossVelocity(charge)
    local cfg = GetBallActionConfig()
    local crossCfg = cfg.Cross or {}
    charge = ClampNumber(charge or 0.0, 0.0, 1.0)
    charge = ApplyPowerCurve(charge, crossCfg.PowerCurve or 1.0)

    local fallbackSpeed = tonumber(crossCfg.Speed) or 16.5
    local fallbackLift = tonumber(crossCfg.Lift) or 5.6
    local minSpeed = tonumber(crossCfg.MinSpeed) or (fallbackSpeed * 0.75)
    local maxSpeed = tonumber(crossCfg.MaxSpeed) or fallbackSpeed
    local minLift = tonumber(crossCfg.MinLift) or (fallbackLift * 0.75)
    local maxLift = tonumber(crossCfg.MaxLift) or fallbackLift

    return LerpNumber(minSpeed, maxSpeed, charge), LerpNumber(minLift, maxLift, charge)
end

--- Sut/pas/orta sirasinda dribble dongusunun topu ayaga cekip v=0 yapmasini gecici kapat (ag kontrol yarisi).
local function BeginBallDeliveryFromFootSuppress()
    local cfg = GetBallActionConfig()
    local holdMs = math.max(0, tonumber(cfg.VelocityHoldMs) or 180)
    local retries = math.max(1, math.floor(tonumber(cfg.ControlRetries) or 3))
    local baseTimeout = math.max(80, tonumber(cfg.ControlTimeoutMs) or 650)
    local stepMs = math.max(0, tonumber(cfg.ControlRetryStepMs) or 180)
    local controlWorstMs = 0
    for a = 1, retries do
        controlWorstMs = controlWorstMs + baseTimeout + ((a - 1) * stepMs)
    end
    ballControl.dribbleMagnetSuspendedUntil = GetGameTimer() + 280 + controlWorstMs + holdMs + 220
end

local function ClearBallDeliveryFromFootSuppress()
    ballControl.dribbleMagnetSuspendedUntil = 0
end

local function CarryGoalkeeperBall(entity, ped)
    if not entity or entity == 0 or not ped or ped == 0 then return false end
    local gk = Config.Goalkeeper or {}
    local fwd = GetEntityForwardVector(ped)
    local pedPos = GetEntityCoords(ped)
    local offset = tonumber(gk.CarryOffset) or 0.72
    local height = tonumber(gk.CarryHeight) or 0.28
    local targetX = pedPos.x + (fwd.x * offset)
    local targetY = pedPos.y + (fwd.y * offset)
    local targetZ = pedPos.z + height

    if RequestBallControl(entity, 80) then
        SetEntityDynamic(entity, true)
        ActivatePhysics(entity)
        SetEntityCoordsNoOffset(entity, targetX, targetY, targetZ, false, false, false)
        SetEntityVelocity(entity, 0.0, 0.0, 0.0)
        if SetEntityAngularVelocity then
            SetEntityAngularVelocity(entity, 0.0, 0.0, 0.0)
        end
        return true
    end

    return false
end

-- Topu kalecinin sağ eline yapıştır
AttachBallToKeeperHand = function(entity, ped)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end
    if not RequestBallControl(entity, 400) then return false end
    local gkCfg = Config.Goalkeeper or {}
    local boneTag = tonumber(gkCfg.HoldBoneTag) or 57005 -- 57005 = SKEL_R_Hand; 6286 = IK_R_Hand (denenebilir)
    local boneIdx = GetPedBoneIndex(ped, boneTag)
    if not boneIdx or boneIdx == -1 then
        boneIdx = GetPedBoneIndex(ped, 57005)
    end
    local ox = tonumber(gkCfg.HoldBoneOffsetX) or 0.0
    local oy = tonumber(gkCfg.HoldBoneOffsetY) or 0.12
    local oz = tonumber(gkCfg.HoldBoneOffsetZ) or 0.05
    local rx = tonumber(gkCfg.HoldBoneRotX) or 0.0
    local ry = tonumber(gkCfg.HoldBoneRotY) or 0.0
    local rz = tonumber(gkCfg.HoldBoneRotZ) or 0.0
    SetEntityDynamic(entity, false)
    if SetEntityCollision then SetEntityCollision(entity, false, false) end
    AttachEntityToEntity(entity, ped, boneIdx, ox, oy, oz, rx, ry, rz, true, true, false, true, 1, true)
    return true
end

-- Topu elden ayır ve fiziği geri aç
DetachBallFromKeeperHand = function(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    DetachEntity(entity, true, false)
    SetEntityDynamic(entity, true)
    if SetEntityCollision then SetEntityCollision(entity, true, true) end
    ActivatePhysics(entity)
    return true
end

local function ReleaseGoalkeeperBall(entity, horizontalSpeed, lift)
    if (not entity or entity == 0 or not DoesEntityExist(entity)) and TryResolveBallEntity then
        entity = TryResolveBallEntity()
    end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    -- Elden bırakmadan önce attachment'ı kaldır
    if goalieControl.ballAttached then
        DetachBallFromKeeperHand(entity)
        goalieControl.ballAttached = false
    end
    ClearPedSecondaryTask(PlayerPedId())
    local ped = PlayerPedId()
    local fwd = GetEntityForwardVector(ped)
    local pedPos = GetEntityCoords(ped)
    local gk = Config.Goalkeeper or {}
    local cfg = GetBallActionConfig()
    local offset = tonumber(gk.CarryOffset) or 0.72
    local height = tonumber(gk.CarryHeight) or 0.28
    local startX = pedPos.x + (fwd.x * offset)
    local startY = pedPos.y + (fwd.y * offset)
    local startZ = pedPos.z + height
    horizontalSpeed = math.max(0.0, tonumber(horizontalSpeed) or 0.0)
    lift = tonumber(lift) or 0.0

    local hasControl, controlledEnt = AcquireBallControlForAction(entity, cfg)
    if hasControl then
        local applied = ApplyBallImpulseFromPlayer(
            controlledEnt, ped, fwd, startX, startY, startZ, horizontalSpeed, lift, cfg, true
        )
        if applied then return true end
    end

    if cfg.AllowKickWithoutControl ~= false then
        local fallbackEnt = (controlledEnt and controlledEnt ~= 0 and DoesEntityExist(controlledEnt)) and controlledEnt or entity
        local applied = ApplyBallImpulseFromPlayer(
            fallbackEnt, ped, fwd, startX, startY, startZ, horizontalSpeed, lift, cfg, false
        )
        if applied then return true end
    end

    return false
end

-- Sut/pas/kaleci cikisinda fizik uygulamasi basarisiz olursa topun oyuncuda "kilitli" kalmasini engeller.
-- Sahipligi serbest birakir; mumkunse topu one hafif iter ve kisa sure geri alma kilidi koyar.
local function ForceLooseBallAfterFailedAction(entity, lobbyId, nowMs, opts)
    if not lobbyId then return false end
    opts = opts or {}

    local didNudge = false
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        local cfg = GetBallActionConfig()
        local hasControl, controlledEnt = AcquireBallControlForAction(entity, cfg)
        local useEnt = (controlledEnt and controlledEnt ~= 0 and DoesEntityExist(controlledEnt)) and controlledEnt or entity
        local ped = PlayerPedId()
        local fwd = GetEntityForwardVector(ped)
        local spawnOffset = tonumber(opts.SpawnOffset) or tonumber(cfg.KickSpawnOffset) or 0.92
        local sx, sy, sz = GetKickBallSpawnCoords(ped, fwd, spawnOffset)
        local pushSpeed = math.max(0.0, tonumber(opts.PushSpeed) or 4.2)
        local pushLift = tonumber(opts.PushLift)
        if pushLift == nil then pushLift = 0.35 end

        if hasControl then
            local applied = ApplyBallImpulseFromPlayer(useEnt, ped, fwd, sx, sy, sz, pushSpeed, pushLift, cfg, true)
            didNudge = applied or false
        elseif cfg.AllowKickWithoutControl ~= false then
            local applied = ApplyBallImpulseFromPlayer(useEnt, ped, fwd, sx, sy, sz, pushSpeed, pushLift, cfg, false)
            didNudge = applied or false
        end
    end

    local actionKind = type(opts.ActionKind) == 'string' and opts.ActionKind or nil
    TriggerServerEvent('seoul_soccer:server:ReleaseBallPossession', lobbyId, actionKind)
    ballControl.owner = 0
    ballControl.looseSinceGameTimer = nowMs
    ballControl.lastClaimTry = nowMs
    local lockMs = math.max(350, tonumber(opts.PickupLockMs) or 700)
    ballControl.pickupLockUntil = math.max(ballControl.pickupLockUntil or 0, nowMs + lockMs)
    return didNudge
end

--- Araba / moto vb.: top ayaginda veya kaleci elindeyken araca binince sahiplik birakilir.
local function DropBallBecauseEnteredVehicle(entity, lobbyId, nowMs)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    if not lobbyId then return false end
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return false end

    if IsMyGoalkeeperHolding() then
        if goalieControl.ballAttached and DetachBallFromKeeperHand then
            DetachBallFromKeeperHand(entity)
            goalieControl.ballAttached = false
        end
        goalieControl.holding = false
        goalieControl.holdTeam = 0
        goalieControl.holdUntil = 0
        goalieControl.releaseHoldStart = nil
        goalieControl.releaseMode = nil
        goalieControl.gkAnimRefreshAt = 0
        goalieControl.holdMeta = nil
        goalieControl.holdAnim = nil
        goalieControl.attachRetryAt = 0
    end

    ForceLooseBallAfterFailedAction(entity, lobbyId, nowMs, {
        PickupLockMs = 520,
        PushSpeed = 4.0,
        PushLift = 0.42,
        ActionKind = 'vehicle_drop',
    })
    ballControl.shootHoldStart = nil
    ballControl.crossHoldStart = nil
    goalieControl.releaseHoldStart = nil
    goalieControl.releaseMode = nil
    SetShotChargeUI(false, 0.0)
    Bridge.Notify(L('client.ball_dropped_vehicle'), 'success', 1600)
    return true
end

local function GetGoalkeeperReleaseVelocity(mode, charge)
    local gk = Config.Goalkeeper or {}
    local releaseCfg = mode == "punt" and (gk.Punt or {}) or (gk.Throw or {})
    charge = ClampNumber(charge or 0.0, 0.0, 1.0)

    local minSpeed = tonumber(releaseCfg.MinSpeed) or (mode == "punt" and 15.0 or 8.0)
    local maxSpeed = tonumber(releaseCfg.MaxSpeed) or (mode == "punt" and 32.0 or 17.0)
    local minLift = tonumber(releaseCfg.MinLift) or (mode == "punt" and 2.0 or 0.6)
    local maxLift = tonumber(releaseCfg.MaxLift) or (mode == "punt" and 5.2 or 1.8)

    return LerpNumber(minSpeed, maxSpeed, charge), LerpNumber(minLift, maxLift, charge)
end

local KickAnimMale = {
    dict = "anim_heist@arcade@shared@male@right@",
    clip = "kick",
    flags = 1,
    tapDuration = 900,
    shotDuration = 1150,
    tapImpact = 180,
    shotImpact = 260
}

local KickAnimFemale = {
    dict = "anim_heist@arcade@degenatron@female@right@",
    clip = "kick",
    flags = 1,
    tapDuration = 900,
    shotDuration = 1150,
    tapImpact = 180,
    shotImpact = 260
}

local KickAnimFallback = {
    dict = "missheistdockssetup1ig_13@kick_idle",
    clip = "guard_beatup_kickidle_guard2",
    flags = 1,
    tapDuration = 950,
    shotDuration = 1200,
    tapImpact = 220,
    shotImpact = 300
}

local function IsPedMaleSafe(ped)
    if IsPedMale then
        return IsPedMale(ped)
    end
    local model = GetEntityModel(ped)
    return model == GetHashKey("mp_m_freemode_01")
end

local function GetKickAnimProfile(ped)
    local isMale = IsPedMaleSafe(ped)
    return isMale and KickAnimMale or KickAnimFemale
end

local function GetKickAnimWindow(isStrongShot)
    local cfg = Config.ShotAnimation or {}
    local startAt = cfg.StartAt
    local endAt = cfg.EndAt

    if isStrongShot and cfg.StartAtHold ~= nil then
        startAt = cfg.StartAtHold
    elseif (not isStrongShot) and cfg.StartAtTap ~= nil then
        startAt = cfg.StartAtTap
    end

    if isStrongShot and cfg.EndAtHold ~= nil then
        endAt = cfg.EndAtHold
    elseif (not isStrongShot) and cfg.EndAtTap ~= nil then
        endAt = cfg.EndAtTap
    end

    startAt = tonumber(startAt) or 0.0
    endAt = tonumber(endAt) or 1.0

    if startAt < 0.0 then startAt = 0.0 end
    if startAt > 0.90 then startAt = 0.90 end
    if endAt < 0.10 then endAt = 0.10 end
    if endAt > 1.0 then endAt = 1.0 end

    if endAt <= startAt then
        endAt = math.min(1.0, startAt + 0.10)
    end

    return startAt, endAt
end

local function PlayKickAnimation(isStrongShot, isStationary)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsEntityDead(ped) then return false, 0, 0 end
    if IsPedRagdoll(ped) or IsPedFalling(ped) then return false, 0, 0 end
    if IsPedInAnyVehicle(ped, false) then return false, 0, 0 end

    local profile = GetKickAnimProfile(ped)
    if not LoadAnimDict(profile.dict, 1200) then
        profile = KickAnimFallback
        if not LoadAnimDict(profile.dict, 1200) then
            return false, 0, 0
        end
    end

    local baseDuration = isStrongShot and profile.shotDuration or profile.tapDuration
    local impactMs = isStrongShot and profile.shotImpact or profile.tapImpact
    local startAt, endAt = GetKickAnimWindow(isStrongShot)
    local playRatio = math.max(0.08, endAt - startAt)
    local duration = math.max(130, math.floor(baseDuration * playRatio))

    local unarmedHash = GetHashKey("WEAPON_UNARMED")
    if GetSelectedPedWeapon(ped) ~= unarmedHash then
        SetCurrentPedWeapon(ped, unarmedHash, true)
    end

    if IsEntityPlayingAnim(ped, profile.dict, profile.clip, 3) then
        ClearPedSecondaryTask(ped)
    end

    local animFlags = profile.flags
    if not isStationary then
        -- Kosarken tam-body anim yerine upper-body oynat; hiz kesilmesini azaltir.
        animFlags = 49
    end

    TaskPlayAnim(ped, profile.dict, profile.clip, 8.0, 1.0, duration, animFlags, 0.0, false, false, false)
    if startAt > 0.0 and SetEntityAnimCurrentTime then
        local pedRef = ped
        local dictRef = profile.dict
        local clipRef = profile.clip
        CreateThread(function()
            Wait(1)
            if DoesEntityExist(pedRef) and IsEntityPlayingAnim(pedRef, dictRef, clipRef, 3) then
                SetEntityAnimCurrentTime(pedRef, dictRef, clipRef, startAt)
            end
        end)
    end

    impactMs = math.max(60, math.floor(impactMs * playRatio))
    if impactMs > (duration - 20) then
        impactMs = math.max(50, duration - 20)
    end

    return true, impactMs, duration, isStationary
end

--- Kayma XY dogrultusu (fwd) ile hedefe hizalama dot'u; yan kayma dusuk deger verir.
local function SlideEngageDotXY(fx, fy, fromX, fromY, toX, toY)
    local dx, dy = toX - fromX, toY - fromY
    local ld = math.sqrt(dx * dx + dy * dy)
    local lf = math.sqrt(fx * fx + fy * fy)
    if ld < 0.04 or lf < 0.04 then return -1.0 end
    return (dx * fx + dy * fy) / (ld * lf)
end

local function ClientNormalizeFlatXY(x, y)
    local l = math.sqrt(x * x + y * y)
    if l < 0.05 then return nil end
    return x / l, y / l
end

--- Heading slab ekseni: "slide" = kayma vektoru, "ped" = oyuncu baktigi yon.
local function ClientHardStealAxisFwd(slideCfg, activeFwdX, activeFwdY)
    local axis = tostring(slideCfg.HardStealHeadingAxis or "slide"):lower()
    if axis == "ped" then
        local ped = PlayerPedId()
        local f = GetEntityForwardVector(ped)
        if not f then return activeFwdX, activeFwdY end
        return f.x, f.y
    end
    return activeFwdX, activeFwdY
end

--- Top / sahip heading koridorunda mi? (HardStealUseHeadingDistance false ise nil = cagiran daire kullanir)
local function ClientHardStealSlabOk(myPos, tx, ty, axisFx, axisFy, slideCfg)
    if slideCfg.HardStealUseHeadingDistance == false then return nil end
    local fx, fy = ClientNormalizeFlatXY(axisFx, axisFy)
    if not fx or not fy then return false end
    local vx, vy = tx - myPos.x, ty - myPos.y
    local along = vx * fx + vy * fy
    local lateral = math.abs(vx * (-fy) + vy * fx)
    local alongMax = tonumber(slideCfg.HardStealHeadingAlongMax) or 3.55
    local latMax = tonumber(slideCfg.HardStealHeadingLateralMax) or 1.52
    local behind = tonumber(slideCfg.HardStealHeadingBehindAllow) or 0.42
    return along >= -behind - 0.02 and along <= alongMax + 0.02 and lateral <= latMax + 0.02
end

--- Hard slide: kayma yonu top / sahip / (owner 0 iken) menzildeki rakibe dogru mu?
local function ClientHardSlideEngages(slideCfg, fwdX, fwdY, myPos, ballEnt, ownerSrc, enemyReachDist)
    local minD = tonumber(slideCfg.HardStealEngageMinDot) or 0
    if minD <= 0 then return true end
    local best = -1.0
    if ballEnt and ballEnt ~= 0 and DoesEntityExist(ballEnt) then
        local bp = GetEntityCoords(ballEnt)
        if bp then
            best = math.max(best, SlideEngageDotXY(fwdX, fwdY, myPos.x, myPos.y, bp.x, bp.y))
        end
    end
    local os = tonumber(ownerSrc) or 0
    if os ~= 0 then
        local ownerPly = GetPlayerFromServerId(os)
        if ownerPly ~= -1 then
            local ownerPed = GetPlayerPed(ownerPly)
            if ownerPed and ownerPed ~= 0 and DoesEntityExist(ownerPed) then
                local op = GetEntityCoords(ownerPed)
                if op then
                    best = math.max(best, SlideEngageDotXY(fwdX, fwdY, myPos.x, myPos.y, op.x, op.y))
                end
            end
        end
    else
        local myTm = GetMyTeamIndex()
        local reach = tonumber(enemyReachDist) or 3.2
        for _, ply in ipairs(GetActivePlayers()) do
            if ply ~= PlayerId() then
                local op = GetPlayerPed(ply)
                if op and op ~= 0 and DoesEntityExist(op) then
                    local oSr = GetPlayerServerId(ply)
                    local oTm = GetTeamIndexForSrc(oSr)
                    if myTm == 0 or oTm == 0 or oTm ~= myTm then
                        local opos = GetEntityCoords(op)
                        if opos and Distance2D(myPos, opos) <= reach then
                            best = math.max(best, SlideEngageDotXY(fwdX, fwdY, myPos.x, myPos.y, opos.x, opos.y))
                        end
                    end
                end
            end
        end
    end
    return best >= minD
end

-- ─────────────────────────────────────────────
-- Sert Top Çalma (R tuşu / slide tackle)
-- Fixes:
--  * Pre-distance gate: ball/owner çok uzaksa cooldown YAZILMAZ, uyarı verilir.
--  * MissCooldown vs HitCooldown: başarısız slide kısa ceza, başarılı uzun cooldown.
--  * Sustain force: SetEntityVelocity override yerine ApplyForceToEntity (collision hissi korunur).
--  * Carry Z: pedZ + CarryZOffset (top zemin altına düşmez).
--  * Steerable slide: YawNudgeDegrees kadar yön nudge (A/D tuşlar\u0131 ile).
--  * Miss stumble: topa değmezse saldırgan kısa stumble olur (risk/ödül).
-- ─────────────────────────────────────────────
local function PerformHardTackle()
    if ballControl.slideActive then return end
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsEntityDead(ped) then return end
    if IsPedRagdoll(ped) or IsPedInAnyVehicle(ped, false) then return end
    if (IsPedFalling and IsPedFalling(ped)) or (IsPedJumping and IsPedJumping(ped)) or (IsEntityInAir and IsEntityInAir(ped)) then return end

    local slideCfg = Config.SlideTackle or {}
    local now = GetGameTimer()
    local hitCooldownMs = tonumber(slideCfg.CooldownMs) or 6500
    local missCooldownMs = tonumber(slideCfg.MissCooldownMs) or 4500
    local lastHardTackle = tonumber(ballControl.lastSlideTackle) or 0
    local effectiveCooldown = tonumber(ballControl.lastSlideCooldown) or hitCooldownMs
    if lastHardTackle > 0 and (now - lastHardTackle) <= effectiveCooldown then
        local waitSeconds = math.ceil((effectiveCooldown - (now - lastHardTackle)) / 1000)
        Bridge.Notify(L("client.steal_wait", waitSeconds), "warning", 1600)
        return
    end

    local canRunSlide = (IsPedSprinting and IsPedSprinting(ped)) or (IsPedRunning and IsPedRunning(ped))
    if not canRunSlide then
        Bridge.Notify(L("client.steal_need_run"), "warning", 2000)
        return
    end

    -- Ön-mesafe filtresi: oyuncu topa/sahibe cok uzakta ise slide başlatma, cooldown yazma.
    local preMaxDist = tonumber(slideCfg.PreCheckMaxDistance) or 6.0
    if preMaxDist > 0 then
        local myPos = GetEntityCoords(ped)
        local closeEnough = false
        local ballEntPre = TryResolveBallEntity()
        if ballEntPre then
            local bp = GetEntityCoords(ballEntPre)
            if bp and DistanceBetween(myPos, bp) <= preMaxDist then
                closeEnough = true
            end
        end
        if not closeEnough and ballControl.owner ~= 0 then
            local ownerPly = GetPlayerFromServerId(ballControl.owner)
            if ownerPly ~= -1 then
                local ownerPed = GetPlayerPed(ownerPly)
                if ownerPed and ownerPed ~= 0 and DoesEntityExist(ownerPed) then
                    if DistanceBetween(myPos, GetEntityCoords(ownerPed)) <= preMaxDist then
                        closeEnough = true
                    end
                end
            end
        end
        -- Istemci ballOwner gecikmesi: 0 gorunup sahada rakip varken yine de slide'a izin ver; sunucu dogrular.
        if not closeEnough then
            local myTPre = GetMyTeamIndex()
            for _, ply in ipairs(GetActivePlayers()) do
                if ply ~= PlayerId() then
                    local oPed = GetPlayerPed(ply)
                    if oPed and oPed ~= 0 and DoesEntityExist(oPed) then
                        local oSrc = GetPlayerServerId(ply)
                        local oTeam = GetTeamIndexForSrc(oSrc)
                        if myTPre == 0 or oTeam == 0 or oTeam ~= myTPre then
                            if DistanceBetween(myPos, GetEntityCoords(oPed)) <= preMaxDist then
                                closeEnough = true
                                break
                            end
                        end
                    end
                end
            end
        end
        if not closeEnough then
            Bridge.Notify(L("client.steal_too_far"), "warning", 1600)
            return
        end
    end

    local minEngageDot = tonumber(slideCfg.HardStealEngageMinDot) or 0
    if minEngageDot > 0 then
        local stealDistPre = tonumber(slideCfg.StealDistance) or 2.15
        local ownerExPre = tonumber(slideCfg.OwnerReachExtra) or 0.48
        local myPosE = GetEntityCoords(ped)
        local fwdE = GetEntityForwardVector(ped)
        if fwdE then
            local axPre, ayPre = ClientHardStealAxisFwd(slideCfg, fwdE.x, fwdE.y)
            if not ClientHardSlideEngages(
                slideCfg,
                axPre,
                ayPre,
                myPosE,
                TryResolveBallEntity(),
                tonumber(ballControl.owner) or 0,
                stealDistPre + ownerExPre
            ) then
                Bridge.Notify(L("client.steal_slide_wrong_angle"), "warning", 1600)
                return
            end
        end
    end

    ballControl.slideActive = true
    ballControl.animLockUntil = now + (tonumber(slideCfg.DurationMs) or 900)

    local dict = "missheistfbi3b_ig6_v2"
    local clip = "rubble_slide_alt_franklin"
    if not LoadAnimDict(dict, 1000) then
        ballControl.slideActive = false
        ballControl.animLockUntil = 0
        Bridge.Notify(L("client.steal_anim_load_failed"), "warning", 1600)
        return
    end

    -- Slide penceresinde fizik temasindan kaynakli ragdoll'u engelle.
    if SetPedCanRagdoll then
        SetPedCanRagdoll(ped, false)
    end

    local durationMs = tonumber(slideCfg.DurationMs) or 900
    local stealDist = tonumber(slideCfg.StealDistance) or 2.15
    local carryZOffset = tonumber(slideCfg.CarryZOffset) or 0.05
    local yawNudgeMaxDeg = math.max(0.0, tonumber(slideCfg.YawNudgeDegrees) or 15.0)
    local hardStealRetryMs = math.max(80, tonumber(slideCfg.HardStealRetryMs) or 150)
    local sustainProfile = slideCfg.SustainProfile or {}
    local sustainMax = tonumber(sustainProfile.MaxSpeed) or 7.5
    local sustainMin = tonumber(sustainProfile.MinSpeed) or 3.0
    local sustainDecay = tonumber(sustainProfile.DecayFactor) or 0.55
    local sustainGain = tonumber(sustainProfile.ForceGain) or 60.0

    -- Başlangıç forward vektörü; steerable slide için her tick ±yawNudgeMax derece döndürülür.
    local baseFwd = GetEntityForwardVector(ped)
    -- Slide sonrasi top fizik dogrultusu icin LooseBallAfterSlide event'inde kullanilir.
    ballControl.slideLastFwd = { x = baseFwd.x, y = baseFwd.y, z = baseFwd.z }
    ballControl.slideLastFwdAt = now
    -- MISS cooldown varsayılan olarak yazılır; slide içinde top calınırsa HIT cooldown'a yükseltilir.
    ballControl.lastSlideTackle = now
    ballControl.lastSlideCooldown = missCooldownMs
    ballControl.slidePingPlayed = false
    local curSpeed = GetEntitySpeed(ped) or 0.0
    local pushSpeed = math.max(4.5, math.min(curSpeed + 2.8, sustainMax))
    -- İlk impulse (velocity), sonrası force. Başlangıçtaki "sıçrayış" hissini koruruz.
    local currentVel0 = GetEntityVelocity(ped)
    local keepZ0 = (currentVel0 and currentVel0.z) or 0.0
    SetEntityVelocity(ped, baseFwd.x * pushSpeed, baseFwd.y * pushSpeed, keepZ0)

    -- Anim flag = 0 (normal playback + blend-out). HOLD_LAST_FRAME yok.
    TaskPlayAnim(ped, dict, clip, 8.0, -4.0, durationMs, 0, 0.0, false, false, false)

    CreateThread(function()
        local startTime = GetGameTimer()
        local stolen = false
        local lastHardStealReqAt = 0
        local pushedOnHardAttempt = false
        local mySrc = GetPlayerServerId(PlayerId())
        -- Netcode toleransi: slide aninda owner ped konumu gec gelebilir.
        -- Biraz daha genis owner fallback, "anim oynadi ama tackle hit sayilmadi" hissini azaltir.
        local ownerReachExtra = tonumber(slideCfg.OwnerReachExtra) or 0.48
        local ownerReachDist = stealDist + ownerReachExtra
        local sustainUntil = startTime + math.floor(durationMs * 0.85)

        -- Steerable slide: A/D tuşlarından yaw nudge. Her tick -1..+1 input okur.
        local function computeNudgedForward()
            if yawNudgeMaxDeg <= 0.0 then return baseFwd end
            local steer = GetDisabledControlNormal(0, 35) - GetDisabledControlNormal(0, 34)
            local nudge = -steer * yawNudgeMaxDeg
            if nudge == 0.0 then return baseFwd end
            local rad = math.rad(nudge)
            local c, s = math.cos(rad), math.sin(rad)
            return {
                x = baseFwd.x * c - baseFwd.y * s,
                y = baseFwd.x * s + baseFwd.y * c,
                z = baseFwd.z,
            }
        end

        while GetGameTimer() - startTime < durationMs do
            Wait(30)
            if not matchData or not matchData.lobbyId then break end
            local nowT = GetGameTimer()
            if not stolen and (tonumber(ballControl.lastHardStealSuccessAt) or 0) >= startTime then
                stolen = true
            end

            local activeFwd = computeNudgedForward()
            ballControl.slideLastFwd = { x = activeFwd.x, y = activeFwd.y, z = activeFwd.z }
            ballControl.slideLastFwdAt = nowT

            -- Forward momentum sustain (ilk %85 sure): ApplyForceToEntity ile kuvvet, velocity override DEĞİL.
            -- Böylece duvar / başka oyuncu teması oyuncuyu durdurabilir (FIFA hissi).
            if nowT <= sustainUntil and DoesEntityExist(ped) and not IsPedRagdoll(ped) then
                local elapsed = nowT - startTime
                local decay = 1.0 - (elapsed / durationMs) * sustainDecay
                local targetSpeed = math.max(sustainMin, pushSpeed * decay)
                local curVel = GetEntityVelocity(ped)
                local curXYSpeed = math.sqrt(((curVel and curVel.x) or 0.0) * ((curVel and curVel.x) or 0.0)
                    + ((curVel and curVel.y) or 0.0) * ((curVel and curVel.y) or 0.0))
                local deficit = targetSpeed - curXYSpeed
                if deficit > 0.0 and ApplyForceToEntity then
                    -- force = gain * deficit (N), yön = activeFwd (XY). Tick=30ms hesabı.
                    local f = sustainGain * deficit
                    -- Force type 1 = internal (kg dikkate alır), rel=true, p6/p7 oneShot, useGravity=true.
                    ApplyForceToEntity(ped, 1, activeFwd.x * f * 0.001, activeFwd.y * f * 0.001, 0.0,
                        0.0, 0.0, 0.0, 0, false, true, true, false, true)
                end
            end

            -- Top calma kontrolu (stolen olsa bile top tasima icin dongu devam eder).
            -- Sunucu ile ayni mantik: HardStealRequireBallAndOwner true iken top sahibi varken hem top hem sahip;
            -- owner istemci 0 iken (desync) top VEYA yakin rakip ile istek.
            if not stolen then
                local ownerSrc = tonumber(ballControl.owner) or 0
                if ownerSrc ~= mySrc then
                    local myPos = GetEntityCoords(PlayerPedId())
                    local stealCfgSlide = Config.StealSystem or {}
                    local ballReachSlide = slideCfg.BallReach or {}
                    local zTolHardSlide = tonumber(ballReachSlide.ZToleranceHard) or 1.2
                    local hardBallDistSlide = tonumber(slideCfg.HardStealBallDistance)
                        or math.max(stealDist, tonumber(stealCfgSlide.StealBallDistance) or stealDist)
                    local extraBallSlide = tonumber(slideCfg.ServerHardBallExtraTol) or 0.28
                    local hardBallTolSlide = hardBallDistSlide + extraBallSlide

                    local axf, axY = ClientHardStealAxisFwd(slideCfg, activeFwd.x, activeFwd.y)

                    local ballCloseSlide = false
                    local ent = TryResolveBallEntity()
                    if ent then
                        local ballPos = GetEntityCoords(ent)
                        if ballPos and myPos then
                            local dz = math.abs((myPos.z or 0.0) - (ballPos.z or 0.0))
                            local slabBall = ClientHardStealSlabOk(myPos, ballPos.x, ballPos.y, axf, axY, slideCfg)
                            if slabBall == nil then
                                local dxy = Distance2D(myPos, ballPos)
                                ballCloseSlide = (dxy <= hardBallTolSlide) and (dz <= zTolHardSlide)
                            else
                                ballCloseSlide = slabBall and (dz <= zTolHardSlide)
                            end
                        end
                    end

                    local ownerCloseSlide = false
                    if ownerSrc ~= 0 then
                        local ownerPly = GetPlayerFromServerId(ownerSrc)
                        if ownerPly ~= -1 then
                            local ownerPed = GetPlayerPed(ownerPly)
                            if ownerPed and ownerPed ~= 0 and DoesEntityExist(ownerPed) then
                                local op = GetEntityCoords(ownerPed)
                                if op then
                                    local slabOwn = ClientHardStealSlabOk(myPos, op.x, op.y, axf, axY, slideCfg)
                                    if slabOwn == nil then
                                        ownerCloseSlide = DistanceBetween(myPos, op) <= ownerReachDist
                                    else
                                        ownerCloseSlide = slabOwn == true
                                    end
                                end
                            end
                        end
                    end

                    local enemyCloseSlide = false
                    if ownerSrc == 0 then
                        local myTmSl = GetMyTeamIndex()
                        for _, ply in ipairs(GetActivePlayers()) do
                            if ply ~= PlayerId() then
                                local op = GetPlayerPed(ply)
                                if op and op ~= 0 and DoesEntityExist(op) then
                                    local oSr = GetPlayerServerId(ply)
                                    local oTm = GetTeamIndexForSrc(oSr)
                                    if myTmSl == 0 or oTm == 0 or oTm ~= myTmSl then
                                        if Distance2D(myPos, GetEntityCoords(op)) <= ownerReachDist then
                                            enemyCloseSlide = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end

                    local requireBothSlide = slideCfg.HardStealRequireBallAndOwner ~= false
                    local canSteal = false
                    if ownerSrc ~= 0 then
                        if requireBothSlide then
                            canSteal = ballCloseSlide and ownerCloseSlide
                        else
                            canSteal = ballCloseSlide or ownerCloseSlide
                        end
                    else
                        canSteal = ballCloseSlide or enemyCloseSlide
                    end

                    if canSteal then
                        if not ClientHardSlideEngages(slideCfg, axf, axY, myPos, ent, ownerSrc, ownerReachDist) then
                            canSteal = false
                        end
                    end

                    if canSteal then
                        if (nowT - lastHardStealReqAt) >= hardStealRetryMs then
                            lastHardStealReqAt = nowT
                            TriggerServerEvent(
                                'seoul_soccer:server:RequestBallPossession',
                                matchData.lobbyId,
                                true,
                                "hard",
                                activeFwd.x,
                                activeFwd.y
                            )
                        end

                        -- Yerel top itisi YOK: sunucu onayi + BallStolen gelene kadar magdur istemcisi
                        -- topu hala kendinde sanip dribble mıknatısi ile geri cekerdi (snap-back).
                        -- Hareket sunucu entity + LooseBallAfterSlide ile gelir.
                        if not pushedOnHardAttempt then
                            pushedOnHardAttempt = true
                            local popLockMs = tonumber((slideCfg.LooseBallPop or {}).AttackerPickupLockMs) or 1000
                            ballControl.pickupLockUntil = math.max(
                                ballControl.pickupLockUntil or 0,
                                GetGameTimer() + popLockMs
                            )
                        end
                    end
                end
            end
        end

        -- Son hard istegi slide sonuna cok yakin gittiyse, server ack'i icin kisa pencere (ping icin esnetildi).
        if not stolen and lastHardStealReqAt > 0 then
            local graceMs = math.max(180, tonumber(slideCfg.ServerAckGraceMs) or 420)
            local graceUntil = GetGameTimer() + graceMs
            while GetGameTimer() < graceUntil do
                if (tonumber(ballControl.lastHardStealSuccessAt) or 0) >= startTime then
                    stolen = true
                    break
                end
                Wait(5)
            end
        end

        -- Slide sonu temizligi.
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            if IsEntityPlayingAnim(ped, dict, clip, 3) then
                StopAnimTask(ped, dict, clip, -4.0)
            end
            if ClearPedSecondaryTask then ClearPedSecondaryTask(ped) end
        end

        if stolen then
            -- HIT: uzun cooldown'a yükselt; pickup grace uygula.
            ballControl.lastSlideCooldown = hitCooldownMs
            local pickGrace = tonumber(slideCfg.PostStealPickupLockMs) or 450
            ballControl.pickupLockUntil = math.max(
                ballControl.pickupLockUntil or 0,
                GetGameTimer() + pickGrace
            )
        else
            -- MISS: kisa stumble + kisa cooldown + notify.
            -- cooldown zaten missCooldownMs olarak set edilmişti (lastSlideCooldown).
            -- random@domestic / pickup_low yerine shove: yerden top alma animasyonuna benzemesin.
            local stumbleMs = math.max(200, tonumber(slideCfg.MissStumbleMs) or 600)
            ballControl.stumbleUntil = GetGameTimer() + stumbleMs
            ballControl.animLockUntil = math.max(ballControl.animLockUntil or 0, ballControl.stumbleUntil)
            if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                local sDict = "reaction@shove"
                local sClip = "shove_back"
                if LoadAnimDict(sDict, 450) then
                    TaskPlayAnim(ped, sDict, sClip, 5.0, -4.0, math.min(stumbleMs, 720), 48, 0.0, false, false, false)
                end
            end
            Bridge.Notify(L("client.slide_missed"), "warning", 1200)
        end

        local postSuppressMs = math.max(0, tonumber(slideCfg.PostSlideAutoClaimSuppressMs) or 1100)
        if postSuppressMs > 0 then
            ballControl.postSlideAutoClaimSuppressUntil = GetGameTimer() + postSuppressMs
        end

        ballControl.slideActive = false
    end)
end


CreateThread(function()
    while true do
        local loopWait = 500
        local loopEntity, loopPed, loopPlayerPos, loopBallPos, loopDistance, loopHasBall
        if matchData and matchData.lobbyId then
            loopWait = 0
            -- MatchEnded vb. bu yield sirasinda matchData nil olabilir
            if not matchData or not matchData.lobbyId then
                goto continue
            end

            local state = matchData.state
            -- Top sadece mac/pause fazinda (F5 sonrasi); lobide olmayanlarin client dongusu yine matchData olmadan calismaz.
            local canBallActions = (state == "playing" or state == "paused")
            if not canBallActions then
                if ballControl.chargeUiVisible then
                    ballControl.shootHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                goto continue
            end

            local entity = TryResolveBallEntity()
            if not entity then
                if ballControl.chargeUiVisible then
                    ballControl.shootHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                goto continue
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) or IsEntityDead(ped) then
                if ballControl.chargeUiVisible then
                    ballControl.shootHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                goto continue
            end

            local myId = GetPlayerServerId(PlayerId())
            local playerPos = GetEntityCoords(ped)
            local ballPos = GetEntityCoords(entity)
            local distance = DistanceBetween(playerPos, ballPos)
            local hasBall = (ballControl.owner == myId)
            loopEntity, loopPed = entity, ped
            loopPlayerPos, loopBallPos = playerPos, ballPos
            loopDistance, loopHasBall = distance, hasBall
            local now = GetGameTimer()
            if not IsPedInAnyVehicle(ped, false) then
                ballControl.vehicleBallDropLatched = false
            end
            local animLocked = now < (ballControl.animLockUntil or 0)
            local pk = Config.PlayerKeys or {}
            local stealCfg = Config.StealSystem or {}
            local ballActionCfg = GetBallActionConfig()
            local kickKey = pk.Kick or 23
            local crossKey = pk.Cross or 47
            local stealKey = pk.Steal or 38
            local hardStealKey = pk.HardSteal or 45
            local fastDribbleKey = pk.FastDribble or 44
            local claimDistance = tonumber(stealCfg.ClaimDistance) or 1.55
            local stealBallDistance = tonumber(stealCfg.StealBallDistance) or tonumber(stealCfg.StealDistance) or 1.55
            local stealCooldownMs = tonumber(stealCfg.ClientStealCooldownMs) or 350
            local maxChargeMs = math.max(1.0, tonumber(ballActionCfg.ChargeMs) or 1100.0)
            local tapThresholdMs = math.max(0.0, tonumber(ballActionCfg.TapThresholdMs) or 220.0)

            if animLocked then
                DisableControlAction(0, 30, true) -- LEFT/RIGHT
                DisableControlAction(0, 31, true) -- FORWARD/BACK
                DisableControlAction(0, 32, true) -- MOVE UP
                DisableControlAction(0, 33, true) -- MOVE DOWN
                DisableControlAction(0, 34, true) -- MOVE LEFT
                DisableControlAction(0, 35, true) -- MOVE RIGHT
                DisableControlAction(0, 21, true) -- SPRINT
                DisableControlAction(0, 22, true) -- JUMP
            end

            if hasBall then
                if IsPedInAnyVehicle(ped, false) then
                    if not ballControl.vehicleBallDropLatched then
                        ballControl.vehicleBallDropLatched = true
                        DropBallBecauseEnteredVehicle(entity, matchData.lobbyId, now)
                    end
                    goto continue
                end

                if IsMyGoalkeeperHolding() then
                    if state ~= "paused" and not animLocked then
                        DisableControlAction(0, kickKey, true)
                        DisableControlAction(0, crossKey, true)

                        -- Top elde attach edilmişse manuel pozisyonlama gerekmez; değilse 500ms'de bir retry yap
                        if not goalieControl.ballAttached then
                            if goalieControl.holding and (now - (goalieControl.attachRetryAt or 0)) > 500 then
                                goalieControl.attachRetryAt = now
                                if AttachBallToKeeperHand(entity, ped) then
                                    goalieControl.ballAttached = true
                                end
                            end
                            if not goalieControl.ballAttached then
                                CarryGoalkeeperBall(entity, ped)
                            end
                        else
                            local activeAnim = goalieControl.holdAnim or ResolveGoalkeeperHoldAnim(goalieControl.holdMeta)
                            local d = activeAnim and activeAnim.dict or ""
                            local c = activeAnim and activeAnim.clip or ""
                            if d ~= "" and c ~= "" and activeAnim.refresh ~= false and (now - (goalieControl.gkAnimRefreshAt or 0)) > 650 then
                                goalieControl.gkAnimRefreshAt = now
                                if not IsEntityPlayingAnim(ped, d, c, 3) and LoadAnimDict(d, 600) then
                                    local f = tonumber(activeAnim and activeAnim.flag)
                                    if f == nil then f = 49 end
                                    TaskPlayAnim(ped, d, c, 8.0, -8.0, tonumber(activeAnim and activeAnim.durationMs) or -1, f, 0.0, false, false, false)
                                end
                            end
                        end

                        if IsDisabledControlJustPressed(0, kickKey) then
                            goalieControl.releaseMode = "throw"
                            goalieControl.releaseHoldStart = now
                            ballControl.chargeUiLastPush = 0
                            SetShotChargeUI(true, 0.0, "keeper_throw")
                        end

                        if IsDisabledControlJustPressed(0, crossKey) then
                            goalieControl.releaseMode = "punt"
                            goalieControl.releaseHoldStart = now
                            ballControl.chargeUiLastPush = 0
                            SetShotChargeUI(true, 0.0, "keeper_punt")
                        end

                        if goalieControl.releaseHoldStart then
                            local releaseMode = goalieControl.releaseMode or "throw"
                            local releaseKey = releaseMode == "punt" and crossKey or kickKey
                            local uiMode = releaseMode == "punt" and "keeper_punt" or "keeper_throw"
                            local heldMs = now - goalieControl.releaseHoldStart
                            local charge = math.min(1.0, heldMs / maxChargeMs)

                            if IsDisabledControlPressed(0, releaseKey) and (now - ballControl.chargeUiLastPush) > 50 then
                                ballControl.chargeUiLastPush = now
                                SetShotChargeUI(true, charge, uiMode)
                            end

                            if IsDisabledControlJustReleased(0, releaseKey) and (now - ballControl.lastKick) > 180 then
                                local gkReleaseKind = releaseMode == 'punt' and 'keeper_punt' or 'keeper_throw'
                                goalieControl.releaseHoldStart = nil
                                goalieControl.releaseMode = nil
                                ballControl.lastKick = now
                                ballControl.lastClaimTry = now
                                local gkCfg = Config.Goalkeeper or {}
                                ballControl.pickupLockUntil = now + (tonumber(gkCfg.ReleasePickupLockMs) or 900)
                                SetShotChargeUI(false, 0.0)

                                local releaseSpeed, releaseLift = GetGoalkeeperReleaseVelocity(releaseMode, charge)
                                local released = ReleaseGoalkeeperBall(entity, releaseSpeed, releaseLift)

                                if not matchData or not matchData.lobbyId then
                                    SetShotChargeUI(false, 0.0)
                                    goto continue
                                end

                                if not released then
                                    Bridge.Notify(L("client.ball_control_failed"), "warning", 1600)
                                    ForceLooseBallAfterFailedAction(entity, matchData.lobbyId, now, {
                                        PickupLockMs = tonumber(gkCfg.ReleasePickupLockMs) or 900,
                                        PushSpeed = 5.2,
                                        PushLift = 0.55
                                    })
                                    ballControl.lastKick = now - 60
                                    goto continue
                                end

                                TriggerServerEvent('seoul_soccer:server:ReleaseBallPossession', matchData.lobbyId, gkReleaseKind)
                                ballControl.owner = 0
                                goalieControl.holding = false
                                goalieControl.holdTeam = 0
                                goalieControl.holdUntil = 0
                                goalieControl.ballAttached = false
                                goalieControl.gkAnimRefreshAt = 0
                                goalieControl.holdMeta = nil
                                goalieControl.holdAnim = nil
                                goto continue
                            elseif not IsDisabledControlPressed(0, releaseKey) then
                                goalieControl.releaseHoldStart = nil
                                goalieControl.releaseMode = nil
                                SetShotChargeUI(false, 0.0)
                            end
                        end
                    else
                        goalieControl.releaseHoldStart = nil
                        goalieControl.releaseMode = nil
                        SetShotChargeUI(false, 0.0)
                    end

                    goto continue
                end

                if state ~= "paused" and not animLocked then
                    DisableControlAction(0, kickKey, true)
                    DisableControlAction(0, crossKey, true)

                    local crossCooldownPre = tonumber((ballActionCfg.Cross or {}).CooldownMs) or 450
                    local preemptKick = false
                    if ballControl.shootHoldStart then
                        local shotHeldPre = now - ballControl.shootHoldStart
                        preemptKick = (IsDisabledControlJustReleased(0, kickKey)
                            or (shotHeldPre >= 35 and not IsDisabledControlPressed(0, kickKey)))
                            and ((now - ballControl.lastKick) > 80)
                    end
                    local preemptCross = false
                    if ballControl.crossHoldStart then
                        local crossHeldPre = now - ballControl.crossHoldStart
                        local crossRelPre = IsDisabledControlJustReleased(0, crossKey)
                            or (crossHeldPre >= 35 and not IsDisabledControlPressed(0, crossKey))
                        preemptCross = crossRelPre and ((now - ballControl.lastKick) > crossCooldownPre)
                    end
                    if preemptKick or preemptCross then
                        BeginBallDeliveryFromFootSuppress()
                    end

                    local fwd = GetEntityForwardVector(ped)
                    local pedSpeed = GetEntitySpeed(ped)
                    local isMoving = pedSpeed > 0.12
                    local offset = IsControlPressed(0, fastDribbleKey) and 1.02 or 0.78
                    if not isMoving then
                        offset = 0.70
                    end
                    local targetX = playerPos.x + (fwd.x * offset)
                    local targetY = playerPos.y + (fwd.y * offset)
                    if GetGroundZFor_3dCoord and (now - (ballControl.lastGroundProbeAt or 0)) > 200 then
                        ballControl.lastGroundProbeAt = now
                        local ok, _, gz = pcall(GetGroundZFor_3dCoord, targetX, targetY, playerPos.z + 2.0, false)
                        if ok and gz then ballControl.cachedGroundZ = gz end
                    end
                    local baseZ = playerPos.z - (isMoving and 0.92 or 0.86)
                    local groundFloor = (ballControl.cachedGroundZ or baseZ) + 0.12
                    local targetZ = math.max(baseZ, groundFloor)

                    local magnetSuspended = GetGameTimer() < (tonumber(ballControl.dribbleMagnetSuspendedUntil) or 0)
                    if not magnetSuspended and RequestBallControl(entity) then
                        local softStealGuardActive = IsSoftStealGuardActive()
                        local perfC = (Config.Performance and Config.Performance.Client) or {}
                        local prepMs = math.max(80, tonumber(perfC.DribbleSetupRefreshMs) or 250)
                        local prepDue = ballControl.dribblePrepEntity ~= entity
                            or ballControl.dribblePrepGuard ~= softStealGuardActive
                            or (now - (tonumber(ballControl.lastDribblePrepAt) or 0)) >= prepMs

                        if prepDue then
                            SetEntityDynamic(entity, true)
                            ActivatePhysics(entity)
                            if SetEntityCollision then
                                SetEntityCollision(entity, not softStealGuardActive, not softStealGuardActive)
                            end
                            if SetEntityRecordsCollisions then
                                SetEntityRecordsCollisions(entity, not softStealGuardActive)
                            end
                            ballControl.dribblePrepEntity = entity
                            ballControl.dribblePrepGuard = softStealGuardActive
                            ballControl.lastDribblePrepAt = now
                        end

                        -- No-collision uses this-frame semantics, so keep it per tick while dribbling.
                        if SetEntityNoCollisionEntity then
                            SetEntityNoCollisionEntity(ped, entity, true)
                            SetEntityNoCollisionEntity(entity, ped, true)
                        end
                        SetEntityCoordsNoOffset(entity, targetX, targetY, targetZ, false, false, false)
                        if isMoving then
                            local netSync = (ballActionCfg and ballActionCfg.DribbleNetSync) or {}
                            local netSyncEnabled = netSync.Enabled ~= false
                            local rollSpeed
                            if netSyncEnabled then
                                local gain = tonumber(netSync.SpeedGain) or 1.15
                                local minSpeed = tonumber(netSync.MinSpeed) or 2.6
                                local maxSpeed = tonumber(netSync.MaxSpeed) or 8.2
                                if maxSpeed < minSpeed then maxSpeed = minSpeed end
                                rollSpeed = pedSpeed * gain
                                -- MinSpeed: sadece gercekten yuruyen/kosan pedde; mikro hizda taban = surtunmesiz suruklenme
                                local minFloorPed = tonumber(netSync.MinSpeedApplyAbovePedSpeed)
                                if not minFloorPed or minFloorPed < 0.05 then
                                    minFloorPed = math.max(0.35, minSpeed * 0.5)
                                end
                                if rollSpeed < minSpeed and pedSpeed >= minFloorPed then
                                    rollSpeed = minSpeed
                                end
                                if rollSpeed > maxSpeed then rollSpeed = maxSpeed end
                            else
                                -- Geri uyumluluk: eski davranis.
                                rollSpeed = math.min(2.6, pedSpeed * 0.85)
                            end
                            SetEntityVelocity(entity, fwd.x * rollSpeed, fwd.y * rollSpeed, 0.0)
                            ApplyBallGroundRollAngularVelocity(entity, fwd, rollSpeed)
                        else
                            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
                            if SetEntityAngularVelocity then
                                SetEntityAngularVelocity(entity, 0.0, 0.0, 0.0)
                            end
                        end
                    end
                    if not matchData or not matchData.lobbyId then
                        ClearBallDeliveryFromFootSuppress()
                        goto continue
                    end
                end

                if state ~= "paused" and not animLocked then
                    if IsDisabledControlJustPressed(0, crossKey) then
                        ballControl.shootHoldStart = nil
                        ballControl.crossHoldStart = now
                        ballControl.chargeUiLastPush = 0
                        SetShotChargeUI(true, 0.0, "cross")
                    end

                    if ballControl.crossHoldStart and IsDisabledControlPressed(0, crossKey) then
                        local heldMs = now - ballControl.crossHoldStart
                        local charge = math.min(1.0, heldMs / maxChargeMs)
                        if (now - ballControl.chargeUiLastPush) > 50 then
                            ballControl.chargeUiLastPush = now
                            SetShotChargeUI(true, charge, "cross")
                        end
                    end

                    local crossReleased = false
                    if ballControl.crossHoldStart then
                        local crossHeldMs = now - ballControl.crossHoldStart
                        crossReleased = IsDisabledControlJustReleased(0, crossKey)
                            or (crossHeldMs >= 35 and not IsDisabledControlPressed(0, crossKey))
                    end
                    if crossReleased then
                        local crossCfg = ballActionCfg.Cross or {}
                        local crossCooldownMs = tonumber(crossCfg.CooldownMs) or 450
                        if (now - ballControl.lastKick) > crossCooldownMs then
                            BeginBallDeliveryFromFootSuppress()
                            local holdTime = now - ballControl.crossHoldStart
                            local charge = math.min(1.0, holdTime / maxChargeMs)
                            ballControl.crossHoldStart = nil
                            ballControl.lastKick = now
                            ballControl.lastClaimTry = now
                            ballControl.pickupLockUntil = now + (tonumber(crossCfg.PickupLockMs) or 700)
                            SetShotChargeUI(false, 0.0)

                            local pedSpeedCross = GetEntitySpeed(ped) or 0.0
                            local isStationaryCross = pedSpeedCross <= 0.42
                            local animPlayed, animImpactMs, animTotalMs, isStationaryAnim = PlayKickAnimation(true, isStationaryCross)
                            if animPlayed then
                                if isStationaryAnim then
                                    local lockMs = math.min(650, math.max(animTotalMs or 0, 280))
                                    ballControl.animLockUntil = now + lockMs
                                    Wait(math.min(260, animImpactMs or 120))
                                else
                                    ballControl.animLockUntil = now
                                    Wait(math.min(80, math.floor((animImpactMs or 120) * 0.45)))
                                end
                            end

                            if not matchData or not matchData.lobbyId then
                                ballControl.owner = 0
                                SetShotChargeUI(false, 0.0)
                                ClearBallDeliveryFromFootSuppress()
                                goto continue
                            end

                            local crossPower, crossLift = GetCrossVelocity(charge)
                            BeginBallDeliveryFromFootSuppress()
                            local kicked = KickBall(entity, crossPower, crossLift)

                            if not matchData or not matchData.lobbyId then
                                ballControl.owner = 0
                                SetShotChargeUI(false, 0.0)
                                ClearBallDeliveryFromFootSuppress()
                                goto continue
                            end

                            if not kicked then
                                Bridge.Notify(L("client.ball_control_failed"), "warning", 1600)
                                ForceLooseBallAfterFailedAction(entity, matchData.lobbyId, now, {
                                    PickupLockMs = tonumber(crossCfg.PickupLockMs) or 700,
                                    PushSpeed = math.max(4.8, crossPower * 0.35),
                                    PushLift = math.max(0.35, crossLift * 0.30)
                                })
                                ballControl.lastKick = now - 60
                                ClearBallDeliveryFromFootSuppress()
                                goto continue
                            end

                            TriggerServerEvent('seoul_soccer:server:ReleaseBallPossession', matchData.lobbyId, 'cross')
                            ballControl.owner = 0
                            local crossDoneAt = GetGameTimer()
                            ballControl.lastClaimTry = crossDoneAt
                            ballControl.pickupLockUntil = math.max(
                                tonumber(ballControl.pickupLockUntil) or 0,
                                crossDoneAt + 380
                            )
                            ClearBallDeliveryFromFootSuppress()
                            goto continue
                        else
                            ballControl.crossHoldStart = nil
                            SetShotChargeUI(false, 0.0)
                        end
                    end

                    if IsDisabledControlJustPressed(0, kickKey) then
                        ballControl.crossHoldStart = nil
                        ballControl.shootHoldStart = now
                        ballControl.chargeUiLastPush = 0
                        SetShotChargeUI(true, 0.0)
                    end

                    if ballControl.shootHoldStart and IsDisabledControlPressed(0, kickKey) then
                        local heldMs = now - ballControl.shootHoldStart
                        local charge = math.min(1.0, heldMs / maxChargeMs)
                        if (now - ballControl.chargeUiLastPush) > 50 then
                            ballControl.chargeUiLastPush = now
                            SetShotChargeUI(true, charge)
                        end
                    end

                    local kickReleased = false
                    if ballControl.shootHoldStart then
                        local shotHeldMs = now - ballControl.shootHoldStart
                        kickReleased = IsDisabledControlJustReleased(0, kickKey)
                            or (shotHeldMs >= 35 and not IsDisabledControlPressed(0, kickKey))
                    end

                    if kickReleased and (now - ballControl.lastKick) > 80 then
                        BeginBallDeliveryFromFootSuppress()
                        local holdTime = now - ballControl.shootHoldStart
                        local charge = math.min(1.0, holdTime / maxChargeMs)
                        local pedSpeedShot = GetEntitySpeed(ped) or 0.0
                        local isTap = holdTime < tapThresholdMs
                        ballControl.shootHoldStart = nil
                        ballControl.lastKick = now
                        ballControl.lastClaimTry = now
                        local passCfg = ballActionCfg.Pass or {}
                        local shotCfg = ballActionCfg.Shot or {}
                        ballControl.pickupLockUntil = now + (isTap and (tonumber(passCfg.PickupLockMs) or 420) or (tonumber(shotCfg.PickupLockMs) or 760))
                        SetShotChargeUI(false, 0.0)

                        local isStationaryShot = pedSpeedShot <= 0.42
                        local animPlayed, animImpactMs, animTotalMs, isStationaryAnim = PlayKickAnimation(not isTap, isStationaryShot)
                        if animPlayed then
                            if isStationaryAnim then
                                local lockMs = math.min(650, math.max(animTotalMs or 0, 280))
                                ballControl.animLockUntil = now + lockMs
                                Wait(math.min(260, animImpactMs or 120))
                            else
                                -- Kosu halinde oyuncuyu kilitleme; sadece cok kisa bir bekleme ile top temas zamanini koru.
                                ballControl.animLockUntil = now
                                Wait(math.min(80, math.floor((animImpactMs or 120) * 0.45)))
                            end
                        end

                        if not matchData or not matchData.lobbyId then
                            ballControl.shootHoldStart = nil
                            ballControl.owner = 0
                            SetShotChargeUI(false, 0.0)
                            ClearBallDeliveryFromFootSuppress()
                            goto continue
                        end

                        local remoteShotPower, remoteCharge = nil, nil
                        if isTap then
                            local tapCharge = holdTime > 0 and math.min(1.0, holdTime / math.max(1.0, tapThresholdMs)) or 0.0
                            local passPower, passLift = GetPassVelocity(tapCharge)
                            BeginBallDeliveryFromFootSuppress()
                            local kicked = KickBall(entity, passPower, passLift) -- Tap: pas
                            if not kicked then
                                Bridge.Notify(L("client.ball_control_failed"), "warning", 1600)
                                ForceLooseBallAfterFailedAction(entity, matchData.lobbyId, now, {
                                    PickupLockMs = tonumber(passCfg.PickupLockMs) or 420,
                                    PushSpeed = math.max(3.8, passPower * 0.35),
                                    PushLift = math.max(0.22, passLift * 0.35)
                                })
                                ballControl.lastKick = now - 60
                                ClearBallDeliveryFromFootSuppress()
                                goto continue
                            end
                        else
                            local shotPower, lift = GetShotVelocity(charge)
                            BeginBallDeliveryFromFootSuppress()
                            local kicked = KickBall(entity, shotPower, lift) -- Hold: şut (tap degil)
                            if not kicked then
                                Bridge.Notify(L("client.ball_control_failed"), "warning", 1600)
                                ForceLooseBallAfterFailedAction(entity, matchData.lobbyId, now, {
                                    PickupLockMs = tonumber(shotCfg.PickupLockMs) or 760,
                                    PushSpeed = math.max(4.6, shotPower * 0.30),
                                    PushLift = math.max(0.30, lift * 0.35)
                                })
                                ballControl.lastKick = now - 60
                                ClearBallDeliveryFromFootSuppress()
                                goto continue
                            end
                            -- Pas (isTap) dalinda cagrilmaz; zayif sut + SpawnChance icinde ShouldApplyShotTrailFx.
                            local applyTrail = ShouldApplyShotTrailFx(shotPower, charge)
                            remoteShotPower, remoteCharge, remoteApplyTrail = shotPower, charge, applyTrail
                            if applyTrail then
                                BeginBallShotTrailFx(entity, shotPower, charge, true)
                            end
                        end

                        if not matchData or not matchData.lobbyId then
                            ballControl.shootHoldStart = nil
                            ballControl.owner = 0
                            SetShotChargeUI(false, 0.0)
                            ClearBallDeliveryFromFootSuppress()
                            goto continue
                        end

                        local releaseKind = isTap and 'pass' or 'shot'
                        if releaseKind == 'shot' and remoteShotPower then
                            TriggerServerEvent(
                                'seoul_soccer:server:ReleaseBallPossession',
                                matchData.lobbyId,
                                releaseKind,
                                remoteShotPower,
                                remoteCharge or 0.0,
                                remoteApplyTrail == true
                            )
                        else
                            TriggerServerEvent('seoul_soccer:server:ReleaseBallPossession', matchData.lobbyId, releaseKind)
                        end
                        ballControl.owner = 0
                        -- Kick tamamlandiktan sonra (AcquireBallControl bekleme suresi dahil)
                        -- aninda re-claim dongusu olusmasini engelle: lastClaimTry ve pickupLock guncelle.
                        local kickDoneAt = GetGameTimer()
                        ballControl.lastClaimTry = kickDoneAt
                        ballControl.pickupLockUntil = math.max(
                            tonumber(ballControl.pickupLockUntil) or 0,
                            kickDoneAt + (isTap and 380 or 680)
                        )
                        ClearBallDeliveryFromFootSuppress()
                    elseif kickReleased then
                        ballControl.shootHoldStart = nil
                        SetShotChargeUI(false, 0.0)
                    end
                else
                    if ballControl.shootHoldStart then
                        ballControl.shootHoldStart = nil
                        SetShotChargeUI(false, 0.0)
                    end
                    if ballControl.crossHoldStart then
                        ballControl.crossHoldStart = nil
                        SetShotChargeUI(false, 0.0)
                    end
                end

                if ballControl.shootHoldStart and not IsDisabledControlPressed(0, kickKey) then
                    ballControl.shootHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                if ballControl.crossHoldStart and not IsDisabledControlPressed(0, crossKey) then
                    ballControl.crossHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
            else
                if ballControl.shootHoldStart then
                    ballControl.shootHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                if ballControl.crossHoldStart then
                    ballControl.crossHoldStart = nil
                    SetShotChargeUI(false, 0.0)
                end
                -- R (hard slide): animLock altinda da dinle; INPUT disabled iken IsDisabledControlJustPressed gerekir.
                -- ballOwner==0 desync: sadece "owner~=0" ile kilitleme yapma; takim arkadasi sadece owner bilinirken.
                do
                    local rSlide = IsControlJustPressed(0, hardStealKey) or IsDisabledControlJustPressed(0, hardStealKey)
                    local ownSlide = tonumber(ballControl.owner) or 0
                    local myTmSlide = GetMyTeamIndex()
                    local otSlide = GetTeamIndexForSrc(ownSlide)
                    local blockTeamSlide = (ownSlide ~= 0 and myTmSlide ~= 0 and otSlide ~= 0 and myTmSlide == otSlide)
                    if rSlide
                        and matchData.state == "playing"
                        and not ballControl.slideActive
                        and ownSlide ~= myId
                        and not blockTeamSlide
                    then
                        PerformHardTackle()
                    end
                end
                if state ~= "paused" and not animLocked then
                    local gkCfg = Config.Goalkeeper or {}
                    local nearOwnGoalkeeperSlot = nil
                    local inOwnGoalkeeperArea = false
                    if gkCfg.Enabled ~= false then
                        nearOwnGoalkeeperSlot = GetClosestOwnGoalkeeperSlot(playerPos, tonumber(gkCfg.InteractDistance) or 2.8)
                        if IsMyGoalkeeper() then
                            inOwnGoalkeeperArea = GetClosestOwnGoalkeeperSlot(playerPos, tonumber(gkCfg.AreaRadius) or 8.0) ~= nil
                        end
                    end

                    local canPickup = now >= (ballControl.pickupLockUntil or 0)
                        and now >= (tonumber(ballControl.postSlideAutoClaimSuppressUntil) or 0)
                        and now >= (tonumber(ballControl.autoClaimBlockedUntil) or 0)
                    if ballControl.owner == 0 and not inOwnGoalkeeperArea and canPickup and distance <= claimDistance and (now - ballControl.lastClaimTry) > 220 then
                        ballControl.lastClaimTry = now
                        TriggerServerEvent('seoul_soccer:server:RequestBallPossession', matchData.lobbyId, false)
                    end

                    local myTeamForSteal = GetMyTeamIndex()
                    local ownerTeamForSteal = GetTeamIndexForSrc(ballControl.owner)
                    local isTeammateOwner = (myTeamForSteal ~= 0 and ownerTeamForSteal ~= 0 and myTeamForSteal == ownerTeamForSteal)
                    local ownerDistanceForSteal = nil
                    local ownerSpeedForSteal = nil
                    if ballControl.owner ~= 0 and ballControl.owner ~= myId then
                        local ownerPly = GetPlayerFromServerId(ballControl.owner)
                        if ownerPly ~= -1 then
                            local ownerPed = GetPlayerPed(ownerPly)
                            if ownerPed and ownerPed ~= 0 and DoesEntityExist(ownerPed) then
                                ownerDistanceForSteal = Distance2D(playerPos, GetEntityCoords(ownerPed))
                                ownerSpeedForSteal = GetEntitySpeed(ownerPed) or 0.0
                            end
                        end
                    end

                    -- Tus haritasi:
                    --  * E (tap, sprint YOK) = kaleci slot / save / pickup (yukaridaki blok yonetir).
                    --  * SoftSteal.RequireSprint true: SHIFT + E (sprint + E) = yumuşak çalma.
                    --  * SoftSteal.RequireSprint false: sadece E = yumuşak çalma (sprint sartı yok).
                    --  * R (tek tus) = kayarak top calma (slide tackle), kosma/sprint sarti PerformHardTackle icinde.
                    local stealJustPressed = IsControlJustPressed(0, stealKey) or IsDisabledControlJustPressed(0, stealKey)
                    local sprintHeld = IsControlPressed(0, 21)
                        or IsDisabledControlPressed(0, 21)
                        or IsControlPressed(2, 21)
                        or (IsPedSprinting and IsPedSprinting(ped))
                        or (IsPedRunning and IsPedRunning(ped))
                    if sprintHeld then
                        ballControl.lastSprintHeldAt = now
                    end
                    local sprintHeldForSteal = sprintHeld or (now - (tonumber(ballControl.lastSprintHeldAt) or 0)) <= 300
                    local softCfg = stealCfg.SoftSteal or {}
                    local softRequireSprint = (softCfg.RequireSprint ~= false)
                    local sprintOkForSoft = (not softRequireSprint) or sprintHeldForSteal

                    -- Takim arkadasi uyari: soft çalma girisimi, topa yakin ama sahip takim arkadasi.
                    if stealJustPressed
                        and sprintOkForSoft
                        and not nearOwnGoalkeeperSlot
                        and not inOwnGoalkeeperArea
                        and distance <= (stealBallDistance + 0.2)
                        and ballControl.owner ~= 0
                        and ballControl.owner ~= myId
                        and isTeammateOwner
                        and (now - (ballControl.lastTeammateWarn or 0)) > 1200
                    then
                        ballControl.lastTeammateWarn = now
                        Bridge.Notify(L("client.teammate_no_steal"), "warning", 1200)
                    end

                    -- Soft steal: yakin baskida aninda top kapma (RequireSprint ayarina gore SHIFT sarti).
                    -- Progress bar / bekleme / animasyon / itme / stumble / ragdoll yok.
                    local softOwnerMaxDist = tonumber(stealCfg.StealOwnerDistance) or tonumber(stealCfg.StealDistance) or tonumber(softCfg.MaxDistance) or stealBallDistance
                    if ownerSpeedForSteal ~= nil and ownerSpeedForSteal <= (tonumber(stealCfg.StationaryOwnerSpeed) or 0.25) then
                        softOwnerMaxDist = tonumber(stealCfg.StationaryOwnerDistance) or softOwnerMaxDist
                    end
                    local softAttemptGuardDist = tonumber(softCfg.CollisionGuardDistance)
                        or math.max(softOwnerMaxDist + 1.0, 2.75)
                    local softSpamLockMs = math.max(250, tonumber(softCfg.SpamLockMs) or tonumber(softCfg.InputLockMs) or 650)
                    local softAttemptLocked = now < (tonumber(ballControl.softStealAttemptLockUntil) or 0)

                    local canSoftStealNow = sprintOkForSoft
                        and not nearOwnGoalkeeperSlot
                        and not inOwnGoalkeeperArea
                        and now >= (goalieControl.interactLockUntil or 0)
                        and (ownerDistanceForSteal == nil or ownerDistanceForSteal <= softOwnerMaxDist)
                        and ballControl.owner ~= 0
                        and ballControl.owner ~= myId
                        and not isTeammateOwner
                        and matchData.state == "playing"

                    local canStartSoftAttemptGuard = stealJustPressed
                        and sprintOkForSoft
                        and not nearOwnGoalkeeperSlot
                        and not inOwnGoalkeeperArea
                        and ballControl.owner ~= 0
                        and ballControl.owner ~= myId
                        and not isTeammateOwner
                        and matchData.state == "playing"
                        and (ownerDistanceForSteal == nil or ownerDistanceForSteal <= softAttemptGuardDist)

                    local softStealBlockStarted = false
                    if canStartSoftAttemptGuard and not softAttemptLocked then
                        softStealBlockStarted = true
                        local ownerAtSteal = tonumber(ballControl.owner) or 0
                        local guardMs = tonumber(softCfg.ContactGuardMs) or 1500
                        ballControl.softStealAttemptLockUntil = now + softSpamLockMs
                        ClearSoftStealPedTasks()
                        StartSoftContactGuard(ownerAtSteal, guardMs)
                        ballControl.softStealHoldStart = 0
                        ballControl.softStealOwnerAtStart = ownerAtSteal
                        TriggerServerEvent('seoul_soccer:server:BeginSoftStealContactGuard', matchData.lobbyId, ownerAtSteal, guardMs)
                        if canSoftStealNow and (now - ballControl.lastStealTry) > stealCooldownMs then
                            ballControl.lastStealTry = now
                            TriggerServerEvent('seoul_soccer:server:RequestBallPossession', matchData.lobbyId, true, "soft")
                        end
                    end

                    -- Stand tackle: E (sprint YOK) rakip sahipken topa yakin + keeper alani disi.
                    -- SoftSteal.RequireSprint false iken ayni E ile yumuşak çalma da tetiklenir; bu blokta cakisir.
                    local standCfg = Config.StandTackle or {}
                    if standCfg.Enabled ~= false
                        and softRequireSprint
                        and not softStealBlockStarted
                        and stealJustPressed
                        and not sprintHeldForSteal
                        and not nearOwnGoalkeeperSlot
                        and not inOwnGoalkeeperArea
                        and ballControl.owner ~= 0
                        and ballControl.owner ~= myId
                        and not isTeammateOwner
                        and matchData.state == "playing"
                    then
                        local standCooldown = tonumber(standCfg.CooldownMs) or 1500
                        local lastStand = tonumber(ballControl.lastStandTackle) or 0
                        local standDist = tonumber(standCfg.StealBallDistance) or 1.6
                        -- Jockey bonusu: BonusAfterJockeyMs süresi boyunca aktif ise reach artar.
                        local jockeyCfg = Config.Jockey or {}
                        local jockeySince = tonumber(ballControl.jockeyActiveSince) or 0
                        local jockeyBonus = 0.0
                        if jockeySince > 0 and (now - jockeySince) >= (tonumber(jockeyCfg.BonusAfterJockeyMs) or 500) then
                            jockeyBonus = tonumber(standCfg.BonusReachWhileJockey) or 0.0
                        end
                        local effStandDist = standDist + jockeyBonus
                        if (now - lastStand) > standCooldown and distance <= effStandDist then
                            ballControl.lastStandTackle = now
                            -- Uzanma animasyonu.
                            local stDict = tostring(standCfg.AnimDict or "melee@unarmed@streamed_core")
                            local stClip = tostring(standCfg.AnimClip or "short_0_punch")
                            local stMs = math.max(200, tonumber(standCfg.AnimMs) or 450)
                            if LoadAnimDict(stDict, 300) then
                                TaskPlayAnim(ped, stDict, stClip, 8.0, -4.0, stMs, 48, 0.0, false, false, false)
                            end
                            ballControl.animLockUntil = math.max(ballControl.animLockUntil or 0, now + stMs)
                            TriggerServerEvent('seoul_soccer:server:RequestBallPossession', matchData.lobbyId, true, "stand")
                        end
                    end
                end
            end
        end

        ::continue::
            if not matchData or not matchData.lobbyId then
                loopWait = 500
            elseif loopWait == 0 then
                local perf = (Config.Performance and Config.Performance.Client) or {}
                local farMs = math.max(1, math.min(80, tonumber(perf.BallLoopIdleMs) or 22))
                local farDist = math.max(8.0, tonumber(perf.BallLoopIdleDistance) or 18.0)
                local lobbyMs = math.max(1, math.min(300, tonumber(perf.BallLoopLobbyPhaseMs) or 120))
                local noBallMs = math.max(1, math.min(200, tonumber(perf.BallLoopNoBallMs) or 45))
                local farDistSq = farDist * farDist

                local st = matchData.state
                if st ~= "playing" and st ~= "paused" then
                    loopWait = lobbyMs
                else
                    local ent = loopEntity
                    if not ent or ent == 0 or not DoesEntityExist(ent) then
                        ent = TryResolveBallEntity()
                    end
                    if not ent or ent == 0 or not DoesEntityExist(ent) then
                        loopWait = noBallMs
                    else
                        local isOwner = loopHasBall
                        if isOwner == nil then
                            local myId = GetPlayerServerId(PlayerId())
                            isOwner = ballControl.owner == myId
                        end
                        if not isOwner then
                            local ped = loopPed or PlayerPedId()
                            if ped and ped ~= 0 and DoesEntityExist(ped) then
                                local pp = loopPlayerPos or GetEntityCoords(ped)
                                local bp = (ent == loopEntity and loopBallPos) or GetEntityCoords(ent)
                                if pp and bp then
                                    local dx, dy, dz = pp.x - bp.x, pp.y - bp.y, pp.z - bp.z
                                    if (dx * dx + dy * dy + dz * dz) > farDistSq
                                        and not ballControl.chargeUiVisible
                                        and not ballControl.shootHoldStart
                                        and not ballControl.crossHoldStart
                                        and not ballControl.slideActive
                                        and not goalieControl.releaseHoldStart then
                                        loopWait = farMs
                                    end
                                end
                            end
                        end
                    end
                end
            end
        Wait(loopWait)
    end
end)

-- Slide tackle cooldown HUD: sol alt kosede kalan sureyi gosterir.
-- Miss/Hit farkli cooldown; ballControl.lastSlideCooldown runtime degeri kullanir.
-- Cooldown biter bitmez PlaySoundFrontend ile kisa ping (sound-ready).
CreateThread(function()
    while true do
        if not matchData or not matchData.lobbyId
            or (matchData.state ~= "playing" and matchData.state ~= "paused")
        then
            Wait(2000)
        elseif isInfoBoxHidden then
            Wait(250)
        else
            local slideCfg = Config.SlideTackle or {}
            local cooldownMs = tonumber(ballControl.lastSlideCooldown) or tonumber(slideCfg.CooldownMs) or 6500
            local lastAt = tonumber(ballControl.lastSlideTackle) or 0
            if lastAt > 0 then
                local now = GetGameTimer()
                local remaining = (lastAt + cooldownMs) - now
                if remaining > 0 then
                    ballControl.slidePingPlayed = false
                    local secs = math.ceil(remaining / 1000)
                    SetTextFont(4)
                    SetTextScale(0.36, 0.36)
                    SetTextColour(255, 230, 120, 235)
                    SetTextDropshadow(2, 0, 0, 0, 200)
                    SetTextEdge(1, 0, 0, 0, 200)
                    SetTextDropShadow()
                    SetTextOutline()
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName(LOr('client.slide_cooldown_hud', 'R  |  %ds', secs))
                    EndTextCommandDisplayText(0.018, 0.945)
                    local pct = 1.0 - (remaining / cooldownMs)
                    if pct < 0 then pct = 0 elseif pct > 1 then pct = 1 end
                    DrawRect(0.055, 0.965, 0.09, 0.006, 40, 40, 40, 180)
                    DrawRect(0.055 - (0.09 * 0.5) + (0.09 * pct * 0.5), 0.965, 0.09 * pct, 0.006, 255, 230, 120, 230)
                    local perfHud = (Config.Performance and Config.Performance.Client) or {}
                    local slideMs = math.max(0, tonumber(perfHud.SlideCooldownHudMs) or 33)
                    Wait(slideMs > 0 and slideMs or 0)
                else
                    if not ballControl.slidePingPlayed then
                        ballControl.slidePingPlayed = true
                        if PlaySoundFrontend then
                            PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", true)
                        end
                    end
                    Wait(250)
                end
            else
                Wait(250)
            end
        end
    end
end)

-- SHIFT + E soft steal charge HUD. Ortada alt kesim, kisa bir "dolum cubugu".
-- Charge aktifken kisa aralikla yield (varsayilan 16ms ~60Hz); iptal/bitiste 60ms/250ms.
CreateThread(function()
    while true do
        if not matchData or not matchData.lobbyId or matchData.state ~= "playing" then
            Wait(2000)
        else
            local softCfg = (Config.StealSystem or {}).SoftSteal or {}
            local showHud = (softCfg.ShowHud ~= false)
            local holdMs = math.max(100, tonumber(softCfg.HoldMs) or 650)
            local startedAt = tonumber(ballControl.softStealHoldStart) or 0
            if showHud and startedAt > 0 and not isInfoBoxHidden then
                local perfHud = (Config.Performance and Config.Performance.Client) or {}
                local softMs = math.max(0, tonumber(perfHud.SoftStealHudMs) or 16)
                Wait(softMs > 0 and softMs or 0)
                local now = GetGameTimer()
                local elapsed = now - startedAt
                if elapsed < 0 then elapsed = 0 end
                local pct = elapsed / holdMs
                if pct < 0 then pct = 0 elseif pct > 1 then pct = 1 end

                SetTextFont(4)
                SetTextScale(0.38, 0.38)
                SetTextColour(255, 235, 160, 240)
                SetTextDropshadow(2, 0, 0, 0, 210)
                SetTextEdge(1, 0, 0, 0, 210)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(true)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName(LOr('client.soft_steal_hud', 'SHIFT + E  |  %d%%', math.floor(pct * 100 + 0.5)))
                EndTextCommandDisplayText(0.5, 0.86)

                local barW, barH = 0.16, 0.008
                DrawRect(0.5, 0.895, barW, barH, 30, 30, 30, 200)
                local fillW = barW * pct
                DrawRect(0.5 - (barW * 0.5) + (fillW * 0.5), 0.895, fillW, barH, 255, 225, 120, 235)
            else
                Wait(60)
            end
        end
    end
end)

-- YENI: Jockey stance. Sprint + yon tusu + rakip top sahibi + yakinda => hareket hizi nerfi.
-- Stand tackle reach bonusu da bu surenin aktif olmasina baglidir (config.Jockey.BonusAfterJockeyMs).
CreateThread(function()
    while true do
        local jockeyCfg = Config.Jockey or {}
        if jockeyCfg.Enabled == false or not matchData or not matchData.lobbyId
            or (matchData.state ~= "playing" and matchData.state ~= "paused") then
            if ballControl.jockeyApplied then
                local ped = PlayerPedId()
                if ped and DoesEntityExist(ped) and SetPedMoveRateOverride then
                    SetPedMoveRateOverride(ped, 1.0)
                end
                ballControl.jockeyApplied = false
            end
            ballControl.jockeyActiveSince = 0
            Wait(2000)
            goto jockey_continue
        end
        Wait(120)

        local ped = PlayerPedId()
        if not DoesEntityExist(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped, false)
            or IsPedRagdoll(ped) or ballControl.slideActive then
            if ballControl.jockeyApplied and SetPedMoveRateOverride then
                SetPedMoveRateOverride(ped, 1.0)
            end
            ballControl.jockeyApplied = false
            ballControl.jockeyActiveSince = 0
            goto jockey_continue
        end

        local myId = GetPlayerServerId(PlayerId())
        local ownerSrc = ballControl.owner
        local isHostileOwner = (ownerSrc ~= 0 and ownerSrc ~= myId)
        local myTeam = GetMyTeamIndex and GetMyTeamIndex() or 0
        local ownerTeam = GetTeamIndexForSrc and GetTeamIndexForSrc(ownerSrc) or 0
        if myTeam ~= 0 and ownerTeam ~= 0 and myTeam == ownerTeam then
            isHostileOwner = false
        end

        local shouldJockey = false
        if isHostileOwner then
            local sprintHeld = IsControlPressed(0, 21)
            local anyMoveHeld = IsControlPressed(0, 32) or IsControlPressed(0, 33)
                or IsControlPressed(0, 34) or IsControlPressed(0, 35)
            if sprintHeld and anyMoveHeld then
                local ownerPly = GetPlayerFromServerId(ownerSrc)
                if ownerPly ~= -1 then
                    local ownerPed = GetPlayerPed(ownerPly)
                    if ownerPed and ownerPed ~= 0 and DoesEntityExist(ownerPed) then
                        local myPos = GetEntityCoords(ped)
                        local ownerPos = GetEntityCoords(ownerPed)
                        local maxDist = tonumber(jockeyCfg.MaxDistance) or 2.0
                        local dx = ownerPos.x - myPos.x
                        local dy = ownerPos.y - myPos.y
                        local d2d = math.sqrt(dx * dx + dy * dy)
                        if d2d > 0.001 and d2d <= maxDist then
                            local fwd = GetEntityForwardVector(ped)
                            local fwdLen = math.sqrt(fwd.x * fwd.x + fwd.y * fwd.y)
                            if fwdLen > 0.001 then
                                local dot = ((dx / d2d) * (fwd.x / fwdLen)) + ((dy / d2d) * (fwd.y / fwdLen))
                                local minDot = tonumber(jockeyCfg.FacingDotMin) or 0.35
                                if dot >= minDot then
                                    shouldJockey = true
                                end
                            end
                        end
                    end
                end
            end
        end

        local now = GetGameTimer()
        if shouldJockey then
            if ballControl.jockeyActiveSince == 0 then
                ballControl.jockeyActiveSince = now
            end
            if not ballControl.jockeyApplied and SetPedMoveRateOverride then
                local rate = tonumber(jockeyCfg.MoveRateMul) or 0.70
                if rate < 0.3 then rate = 0.3 end
                if rate > 1.0 then rate = 1.0 end
                SetPedMoveRateOverride(ped, rate)
                ballControl.jockeyApplied = true
            end
        else
            if ballControl.jockeyApplied and SetPedMoveRateOverride then
                SetPedMoveRateOverride(ped, 1.0)
            end
            ballControl.jockeyApplied = false
            ballControl.jockeyActiveSince = 0
        end

        ::jockey_continue::
    end
end)

-- Top sahibi ile rakip oyuncu top calma baski mesafesine girdiginde collision'i
-- surekli kapat. Bunu sadece SHIFT+E basildiktan sonra yapmak gec kalabiliyor;
-- GTA fizik motoru daha ilk temas aninda iki ped'i birbirine taktirip dusurebiliyor.
CreateThread(function()
    while true do
        local activeMatch = matchData and matchData.state == "playing"
        local ownerSrc = tonumber(ballControl.owner) or 0
        local perfC = (Config.Performance and Config.Performance.Client) or {}
        local scanMs = math.max(0, tonumber(perfC.SoftProximityGuardScanMs) or 16)
        local farScanMs = math.max(scanMs, tonumber(perfC.SoftProximityGuardFarScanMs) or 45)
        local waitMs = (activeMatch and ownerSrc ~= 0) and (scanMs > 0 and scanMs or 0) or 500

        if activeMatch and ownerSrc ~= 0 then
            local myPed = PlayerPedId()
            if DoesEntityExist(myPed) and not IsEntityDead(myPed) and not IsPedInAnyVehicle(myPed, false) then
                local now = GetGameTimer()
                local mySrc = GetPlayerServerId(PlayerId())
                local myTeam = GetTeamIndexForSrc(mySrc)
                local ownerTeam = GetTeamIndexForSrc(ownerSrc)
                local stealCfg = Config.StealSystem or {}
                local softCfg = stealCfg.SoftSteal or {}
                local guardDist = tonumber(softCfg.CollisionGuardDistance)
                    or (math.max(
                        tonumber(stealCfg.StealOwnerDistance) or 1.55,
                        tonumber(stealCfg.StationaryOwnerDistance) or 2.05
                    ) + 0.30)
                if guardDist < 5.0 then
                    guardDist = 5.0
                end
                local guardDistSq = guardDist * guardDist
                local nearExtra = math.max(0.0, tonumber(perfC.SoftProximityGuardNearExtraDistance) or 2.0)
                local nearScanDist = guardDist + nearExtra
                local nearScanDistSq = nearScanDist * nearScanDist
                local closestDistSq = nil
                local myPos = GetEntityCoords(myPed)
                local ballEnt = TryResolveBallEntity and TryResolveBallEntity() or nil
                local applied = false

                local function applyNoCollisionWith(otherPed)
                    if not otherPed or otherPed == 0 or not DoesEntityExist(otherPed) then return end
                    local otherPos = GetEntityCoords(otherPed)
                    if otherPos then
                        local dx, dy = myPos.x - otherPos.x, myPos.y - otherPos.y
                        local distSq = (dx * dx) + (dy * dy)
                        if not closestDistSq or distSq < closestDistSq then
                            closestDistSq = distSq
                        end
                        if distSq > guardDistSq then return end
                        if SetEntityNoCollisionEntity then
                            SetEntityNoCollisionEntity(myPed, otherPed, true)
                            SetEntityNoCollisionEntity(otherPed, myPed, true)
                            if ballEnt and ballEnt ~= 0 and DoesEntityExist(ballEnt) then
                                SetEntityNoCollisionEntity(myPed, ballEnt, true)
                                SetEntityNoCollisionEntity(ballEnt, myPed, true)
                            end
                        end
                        applied = true
                    end
                end

                if ownerSrc == mySrc then
                    for _, ply in ipairs(GetActivePlayers()) do
                        if ply ~= PlayerId() then
                            local otherSrc = GetPlayerServerId(ply)
                            local otherTeam = GetTeamIndexForSrc(otherSrc)
                            local knownTeammate = (otherTeam ~= 0 and myTeam ~= 0 and otherTeam == myTeam)
                            if not knownTeammate then
                                applyNoCollisionWith(GetPlayerPed(ply))
                            end
                        end
                    end
                elseif not (ownerTeam ~= 0 and myTeam ~= 0 and ownerTeam == myTeam) then
                    local ownerPly = GetPlayerFromServerId(ownerSrc)
                    if ownerPly ~= -1 then
                        applyNoCollisionWith(GetPlayerPed(ownerPly))
                    end
                end

                if applied then
                    local allowRagdoll = now < (tonumber(ballControl.ragdollExemptUntil) or 0)
                    if not allowRagdoll then
                        SetSoccerPedRagdollBlocked(myPed, true)
                        ballControl.lastProximityRagdollBlockAt = now
                    end
                    waitMs = 0
                else
                    local allowRagdoll = now < (tonumber(ballControl.ragdollExemptUntil) or 0)
                    if not allowRagdoll and (now - (tonumber(ballControl.lastProximityRagdollBlockAt) or 0)) > 250 then
                        SetSoccerPedRagdollBlocked(myPed, true)
                        ballControl.lastProximityRagdollBlockAt = now
                    end
                    if closestDistSq and closestDistSq <= nearScanDistSq then
                        waitMs = scanMs > 0 and scanMs or 0
                    else
                        waitMs = farScanMs
                    end
                end
            end
        else
            waitMs = 500
        end

        Wait(waitMs)
    end
end)

-- SHIFT + E top calma sirasinda iki oyuncu birbirinin collision capsule'ina girdiginde
-- GTA fizik motoru koddan bagimsiz falling/ragdoll uretebilir. Bu pencere sadece soft steal
-- hedefiyle lokal no-collision uygular; hard/stand tackle davranisina dokunmaz.
CreateThread(function()
    local lastSoftRecoverAt = 0
    local lastSoftFullScanAt = 0
    while true do
        local now = GetGameTimer()
        local guardUntil = tonumber(ballControl.softContactGuardUntil) or 0
        local postGuardUntil = tonumber(ballControl.softPostStealGuardUntil) or 0
        local guardActive = now < guardUntil or now < postGuardUntil
        if matchData and (matchData.state == "playing" or matchData.state == "paused") and guardActive then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                SetSoccerPedRagdollBlocked(ped, true)
                if now < (tonumber(ballControl.softStealInputLockUntil) or 0) then
                    DisableControlAction(0, 21, true) -- sprint
                    DisableControlAction(0, 30, true)
                    DisableControlAction(0, 31, true)
                    DisableControlAction(0, 32, true)
                    DisableControlAction(0, 33, true)
                    DisableControlAction(0, 34, true)
                    DisableControlAction(0, 35, true)
                    -- Her frame hiz sifirlama sprint + spam'de fizik motorunda dusme/takilmaya yol aciyordu.
                end

                local targetSrc = tonumber(ballControl.softContactGuardTarget) or 0
                if targetSrc == 0 then
                    targetSrc = tonumber(ballControl.softPostStealTarget) or 0
                end
                if targetSrc ~= 0 then
                    local targetPly = GetPlayerFromServerId(targetSrc)
                    if targetPly ~= -1 then
                        local targetPed = GetPlayerPed(targetPly)
                        if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) and SetEntityNoCollisionEntity then
                            SetEntityNoCollisionEntity(ped, targetPed, true)
                            SetEntityNoCollisionEntity(targetPed, ped, true)
                        end
                    end
                end
                if SetEntityNoCollisionEntity then
                    local perfC = (Config.Performance and Config.Performance.Client) or {}
                    local fullScanMs = math.max(16, tonumber(perfC.SoftContactGuardFullScanMs) or 50)
                    if (now - lastSoftFullScanAt) >= fullScanMs then
                        lastSoftFullScanAt = now
                        local softCfg = ((Config.StealSystem or {}).SoftSteal or {})
                        local guardDist = tonumber(softCfg.CollisionGuardDistance) or 5.0
                        local guardDistSq = guardDist * guardDist
                        local pedPos = GetEntityCoords(ped)
                        local ppx, ppy = pedPos.x, pedPos.y
                        local myPly = PlayerId()
                        for _, ply in ipairs(GetActivePlayers()) do
                            if ply ~= myPly then
                                local otherPed = GetPlayerPed(ply)
                                if otherPed and otherPed ~= 0 and DoesEntityExist(otherPed) then
                                    local otherPos = GetEntityCoords(otherPed)
                                    if otherPos then
                                        local dx, dy = ppx - otherPos.x, ppy - otherPos.y
                                        if (dx * dx + dy * dy) <= guardDistSq then
                                            SetEntityNoCollisionEntity(ped, otherPed, true)
                                            SetEntityNoCollisionEntity(otherPed, ped, true)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                local ballEnt = TryResolveBallEntity and TryResolveBallEntity() or nil
                if ballEnt and ballEnt ~= 0 and DoesEntityExist(ballEnt) and SetEntityNoCollisionEntity then
                    if now < postGuardUntil then
                        SetSoftStealBallCollisionBlocked(ballEnt, true)
                    end
                    SetEntityNoCollisionEntity(ped, ballEnt, true)
                    SetEntityNoCollisionEntity(ballEnt, ped, true)
                end

                -- Normal kosuyu kesme; sadece fizik motoru yine de falling/ragdoll baslattiysa
                -- attacker yere yapismadan anti-ragdoll'u taze tut. Burada SetPedToRagdoll
                -- veya ClearPedTasksImmediately kullanma; ikisi de soft steal'de dusmeyi tetikleyebilir.
                local isDown = IsPedRagdoll(ped) or (IsPedFalling and IsPedFalling(ped))
                if isDown and (now - lastSoftRecoverAt) > 120 then
                    if ResetPedRagdollTimer then
                        ResetPedRagdollTimer(ped)
                    end
                    ClearPedSecondaryTask(ped)
                    SetSoccerPedRagdollBlocked(ped, true)
                    lastSoftRecoverAt = now
                end
            end
            local perfC = (Config.Performance and Config.Performance.Client) or {}
            local softPoll = math.max(0, tonumber(perfC.SoftContactGuardPollMs) or 2)
            Wait(softPoll > 0 and softPoll or 0)
        else
            if guardUntil > 0 and now >= guardUntil then
                ballControl.softContactGuardUntil = 0
                ballControl.softContactGuardTarget = 0
            end
            if postGuardUntil > 0 and now >= postGuardUntil then
                ballControl.softPostStealGuardUntil = 0
                ballControl.softPostStealTarget = 0
            end
            if (tonumber(ballControl.softStealInputLockUntil) or 0) > 0 and now >= (tonumber(ballControl.softStealInputLockUntil) or 0) then
                ballControl.softStealInputLockUntil = 0
            end
            Wait(250)
        end
    end
end)

-- Mac kapsami: fizik temasindan kaynakli ragdoll'u tamamen kapat.
-- Slide yapan hem kendini hem de rakibi (ayni client'ta calisan thread) ragdoll'dan korur.
-- Mac bittiginde veya oyuncu sahadan cikdiginda native motor varsayilani geri alir.
-- SHIFT+E soft steal pencereleri + spam kilidi sirasinda 500ms beklemek yerine tick basi blokla (arada dusme olmasin).
CreateThread(function()
    while true do
        local waitMs = 500
        if matchData and (matchData.state == "playing" or matchData.state == "paused") then
            local now = GetGameTimer()
            if now < (tonumber(ballControl.softContactGuardUntil) or 0)
                or now < (tonumber(ballControl.softPostStealGuardUntil) or 0)
                or now < (tonumber(ballControl.softStealAttemptLockUntil) or 0)
                or now < (tonumber(ballControl.softStealInputLockUntil) or 0) then
                waitMs = 0
            end
        end
        Wait(waitMs)
        if matchData and (matchData.state == "playing" or matchData.state == "paused") then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                -- Hard slide magduruna gecici ragdoll izni verildiyse bu pencerede kapatma.
                local allowRagdoll = (GetGameTimer() < (tonumber(ballControl.ragdollExemptUntil) or 0))
                if not allowRagdoll then
                    SetSoccerPedRagdollBlocked(ped, true)
                end
                if SetPedCanBeKnockedOffVehicle then
                    SetPedCanBeKnockedOffVehicle(ped, 1)
                end
            end
        end
    end
end)

-- Mac kapsami: saldiri / yumruk / silah kontrollerini kapat.
-- R (45 = RELOAD / HardSteal) native melee ile cakisiyor; oyuncular R'ye basarken
-- birbirine yumruk atmasin diye 140-142, 24, 257, 263-264, 331 ve silah wheel kontrollerini
-- tick basina DisableControlAction ile kapatiriz. DisablePlayerFiring silah ates kilidi.
-- Warmup dahil tum aktif mac safhalarinda aktif; mac bitince thread idle'a girer.
--
-- Ek: Host lobiyi olustururken "envanter/silah" iznini kapattiysa (matchData.allowInventory == false)
-- envanter acma (TAB/M) ve silah cekme yollari da tick basina engellenir, state bag ile
-- ox_inventory gibi ucuncu parti resource'lar da 'invBusy' olarak gorur ve UI'yi acmaz.
-- NOT: SetInventoryLockedState dosya basinda tanimli (LobbySettingsUpdated / MatchEnded icin).
local cachedUnarmedHash = nil
CreateThread(function()
    while true do
        if matchData
            and (matchData.state == "warmup"
                 or matchData.state == "countdown"
                 or matchData.state == "playing"
                 or matchData.state == "paused")
        then
            DisableControlAction(0, 24,  true) -- INPUT_ATTACK (LMB)
            DisableControlAction(0, 25,  true) -- INPUT_AIM   (RMB)
            DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
            DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
            DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
            DisableControlAction(0, 257, true) -- INPUT_ATTACK2
            DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
            DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
            DisableControlAction(0, 331, true) -- INPUT_MELEE_BLOCK
            DisableControlAction(0, 37,  true) -- INPUT_SELECT_WEAPON (wheel)
            DisableControlAction(0, 12,  true) -- INPUT_WEAPON_WHEEL_UD
            DisableControlAction(0, 13,  true) -- INPUT_WEAPON_WHEEL_LR
            DisableControlAction(0, 14,  true) -- INPUT_WEAPON_WHEEL_NEXT
            DisableControlAction(0, 15,  true) -- INPUT_WEAPON_WHEEL_PREV
            DisableControlAction(0, 157, true) -- INPUT_SELECT_WEAPON_UNARMED
            DisableControlAction(0, 158, true) -- INPUT_SELECT_WEAPON_MELEE
            DisableControlAction(0, 159, true) -- INPUT_SELECT_WEAPON_HANDGUN
            DisableControlAction(0, 160, true) -- INPUT_SELECT_WEAPON_SHOTGUN
            DisableControlAction(0, 161, true) -- INPUT_SELECT_WEAPON_SMG
            DisableControlAction(0, 162, true) -- INPUT_SELECT_WEAPON_AUTO_RIFLE
            DisableControlAction(0, 163, true) -- INPUT_SELECT_WEAPON_SNIPER
            DisableControlAction(0, 164, true) -- INPUT_SELECT_WEAPON_HEAVY
            DisableControlAction(0, 165, true) -- INPUT_SELECT_WEAPON_SPECIAL
            if DisablePlayerFiring then
                DisablePlayerFiring(PlayerId(), true)
            end

            if matchData.allowInventory == false then
                if not inventoryLockedState then
                    SetInventoryLockedState(true)
                end
                DisableControlAction(0, 244, true) -- INPUT_INTERACTION_MENU (M)
                DisableControlAction(0, 288, true) -- INPUT_REPLAY_START_STOP_RECORDING (F1)
                DisableControlAction(0, 289, true) -- INPUT_REPLAY_START_STOP_RECORDING_ICON (F2 - qb-inventory)
                DisableControlAction(0, 170, true) -- INPUT_SAVE_REPLAY_CLIP (F3 - bazi envanterler)
                DisableControlAction(0, 166, true) -- INPUT_SELECT_CHARACTER_MICHAEL (F5)
                DisableControlAction(0, 167, true) -- INPUT_SELECT_CHARACTER_FRANKLIN (F6)
                DisableControlAction(0, 168, true) -- INPUT_SELECT_CHARACTER_TREVOR (F7)
                DisableControlAction(0, 303, true) -- INPUT_ENTER (menu acanlar)
                DisableControlAction(0, 245, true) -- INPUT_MP_TEXT_CHAT_ALL (T)
                local ped = PlayerPedId()
                if ped ~= 0 and DoesEntityExist(ped) then
                    if not cachedUnarmedHash then
                        cachedUnarmedHash = GetHashKey("WEAPON_UNARMED")
                    end
                    local curWep = GetSelectedPedWeapon(ped)
                    if curWep ~= cachedUnarmedHash then
                        SetCurrentPedWeapon(ped, cachedUnarmedHash, true)
                    end
                    if SetPedCanSwitchWeapon then
                        SetPedCanSwitchWeapon(ped, false)
                    end
                end
            elseif inventoryLockedState then
                SetInventoryLockedState(false)
            end

            local perfC = (Config.Performance and Config.Performance.Client) or {}
            local wPoll = math.max(0, tonumber(perfC.WeaponBlockPollMs) or 2)
            Wait(wPoll > 0 and wPoll or 0)
        else
            if inventoryLockedState then
                SetInventoryLockedState(false)
                local ped = PlayerPedId()
                if ped ~= 0 and DoesEntityExist(ped) and SetPedCanSwitchWeapon then
                    SetPedCanSwitchWeapon(ped, true)
                end
            end
            Wait(2000)
        end
    end
end)

-- Yedek guard: ragdoll/falling state'i gene de olusursa aktif dusmeyi uzatmadan
-- ragdoll timer'ini resetler. Soft steal yolunda SetPedToRagdoll / ClearPedTasksImmediately yok.
CreateThread(function()
    local ragdollSince = 0
    local lastRecoverAt = 0
    while true do
        if not matchData or (matchData.state ~= "playing" and matchData.state ~= "paused") then
            ragdollSince = 0
            Wait(2000)
            goto ragdoll_guard_continue
        end
        Wait(60)

        local ped = PlayerPedId()
        if not DoesEntityExist(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then
            ragdollSince = 0
            goto ragdoll_guard_continue
        end

        local now = GetGameTimer()
        local slideCfg = Config.SlideTackle or {}
        local maxRagdollMs = math.max(120, tonumber(slideCfg.MaxRagdollMs) or 300)
        if now < (tonumber(ballControl.ragdollExemptUntil) or 0) then
            ragdollSince = 0
            goto ragdoll_guard_continue
        end
        local softGuardActive = now < (tonumber(ballControl.softContactGuardUntil) or 0)
            or now < (tonumber(ballControl.softPostStealGuardUntil) or 0)
        if softGuardActive then
            maxRagdollMs = 60
        end
        local isDown = IsPedRagdoll(ped) or (IsPedFalling and IsPedFalling(ped))

        if softGuardActive and isDown then
            SetSoccerPedRagdollBlocked(ped, true)
            if ResetPedRagdollTimer then
                ResetPedRagdollTimer(ped)
            end
            ClearPedSecondaryTask(ped)
            ragdollSince = 0
            goto ragdoll_guard_continue
        end

        if isDown then
            if ragdollSince == 0 then ragdollSince = now end
            if (now - ragdollSince) >= maxRagdollMs and (now - lastRecoverAt) > 250 then
                SetSoccerPedRagdollBlocked(ped, true)
                if ResetPedRagdollTimer then
                    ResetPedRagdollTimer(ped)
                end
                ClearPedSecondaryTask(ped)
                -- Kullanicinin yakindaki surekli thread'i zaten false'a getirecek; burada da tutarli birak.
                SetSoccerPedRagdollBlocked(ped, true)
                lastRecoverAt = now
                ragdollSince = 0
            end
        else
            ragdollSince = 0
        end
        ::ragdoll_guard_continue::
    end
end)

CreateThread(function()
    while true do
        local perfC = (Config.Performance and Config.Performance.Client) or {}
        local hostPoll = math.max(0, tonumber(perfC.HostUiPollMs) or 2)
        if not matchData or not matchData.lobbyId then
            Wait(2000)
        else
            Wait(hostPoll > 0 and hostPoll or 0)
        end
        local md = matchData
        if md and md.lobbyId then
            local uiKey = (Config.UIKeys and Config.UIKeys.ToggleInfo) or 74
            if IsControlJustPressed(0, uiKey) then
                isInfoBoxHidden = not isInfoBoxHidden
                SendNUIMessage({
                    action = "toggleInfoBox",
                    data   = { hidden = isInfoBoxHidden }
                })
            end
        end

        if md and md.isHost and md.lobbyId then
            local hk = md.hostKeys or Config.HostKeys or {}

            local function HostKeyJustPressed(key)
                key = tonumber(key)
                if not key then return false end
                return IsControlJustPressed(0, key) or IsDisabledControlJustPressed(0, key)
            end

            if HostKeyJustPressed(hk.StartMatch) then
                if md.state == "warmup" then
                    TriggerServerEvent('seoul_soccer:server:BeginMatch', md.lobbyId)
                end
            end

            if HostKeyJustPressed(hk.TogglePause) then
                if md.state == "playing" or md.state == "paused" then
                    TriggerServerEvent('seoul_soccer:server:TogglePause', md.lobbyId)
                end
            end

            if HostKeyJustPressed(hk.EndMatch) then
                TriggerServerEvent('seoul_soccer:server:EndMatch', md.lobbyId)
            end

            if hk.ToggleDoors and HostKeyJustPressed(hk.ToggleDoors) then
                local st = md.state
                if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
                    local hasDoors = type(md.pitchDoors) == "table" and #md.pitchDoors > 0
                    if hasDoors then
                        TriggerServerEvent('seoul_soccer:server:TogglePitchDoor', md.lobbyId, 0)
                    end
                end
            end
        end
    end
end)

-- ─────────────────────────────────────────────
-- NPC NETWORK SYNC + OX_TARGET (Seoul / OneSync)
-- NPC nasce no servidor; target e registrado no HANDLE LOCAL quando a entidade
-- entra no scope do player. Isso e compativel com o ox_target usado na Seoul.
-- ─────────────────────────────────────────────
local soccerNpcNetIds = {}
local soccerNpcEntities = {}
local soccerNpcTargetEntities = {}
local soccerNpcTargetNames = {}
local targetUnavailableWarned = false

local function GetPitchConfigById(pitchId)
    if type(Config.Pitches) ~= "table" then return nil end
    for _, pitch in ipairs(Config.Pitches) do
        if tostring(pitch.id) == tostring(pitchId) then
            return pitch
        end
    end
    return nil
end

local function GetNpcTargetName(pitchId)
    return ("seoul_soccer_pitch_%s"):format(tostring(pitchId))
end

local function BuildNpcTargetOptions(pitch)
    local pitchId = pitch.id
    return {
        {
            name     = GetNpcTargetName(pitchId),
            label    = LOr('config.target_ped_label', Config.TargetPed.label),
            icon     = Config.TargetPed.icon,
            distance = Config.TargetPed.distance,
            onSelect = function()
                ToggleUI(not isUiOpen, pitchId)
            end
        }
    }
end

local function RemoveLocalNpcTarget(pitchId)
    local entity = soccerNpcTargetEntities[pitchId]
    local targetName = soccerNpcTargetNames[pitchId] or GetNpcTargetName(pitchId)

    if entity and entity ~= 0 then
        pcall(Bridge.RemoveTargetEntity, entity, { targetName })
    end

    soccerNpcTargetEntities[pitchId] = nil
    soccerNpcTargetNames[pitchId] = nil
end

local function RegisterLocalNpcTarget(pitch, ped)
    if not pitch or not ped or ped == 0 or not DoesEntityExist(ped) then return false end

    if soccerNpcTargetEntities[pitch.id] == ped then
        return true
    end

    -- Se o mesmo NPC saiu e voltou do scope, o handle local pode mudar.
    RemoveLocalNpcTarget(pitch.id)

    local ok, added = pcall(Bridge.AddTargetEntity, ped, BuildNpcTargetOptions(pitch), Config.TargetPed.distance)
    if not ok then
        print(("[seoul_soccer] ERRO target local %s: %s"):format(tostring(pitch.id), tostring(added)))
        return false
    end

    if added == true then
        soccerNpcTargetEntities[pitch.id] = ped
        soccerNpcTargetNames[pitch.id] = GetNpcTargetName(pitch.id)
        print(("[seoul_soccer] ox_target registrado: %s (entity %s)"):format(tostring(pitch.id), tostring(ped)))
        return true
    end

    if not targetUnavailableWarned then
        targetUnavailableWarned = true
        Bridge.Notify(L("client.target_missing"), "warning", 7000)
    end
    return false
end

local function ConfigureStreamedSoccerNpc(pitchId, netId)
    if not NetworkDoesEntityExistWithNetworkId(netId) then return false end

    local ped = NetworkGetEntityFromNetworkId(netId)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end

    local pitch = GetPitchConfigById(pitchId)
    if not pitch then return false end

    local changedEntity = soccerNpcEntities[pitchId] ~= ped
    if changedEntity then
        soccerNpcEntities[pitchId] = ped

        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetEntityInvincible(ped, true)
        SetPedCanPlayGestureAnims(ped, false)
        SetPedCanSwitchWeapon(ped, false)
        SetPedCanRagdoll(ped, false)
        SetPedKeepTask(ped, true)
        FreezeEntityPosition(ped, true)

        if NetworkHasControlOfEntity(ped) or NetworkRequestControlOfEntity(ped) then
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
        end

        print(("[seoul_soccer] NPC sincronizado: %s (netId %s / entity %s)"):format(
            tostring(pitchId), tostring(netId), tostring(ped)
        ))
    end

    -- O target e sempre associado ao handle local streamado, nao ao netId.
    RegisterLocalNpcTarget(pitch, ped)
    return true
end

RegisterNetEvent("seoul_soccer:client:SyncNpcs", function(snapshot)
    if type(snapshot) ~= "table" then return end

    for pitchId, oldNetId in pairs(soccerNpcNetIds) do
        local newNetId = tonumber(snapshot[pitchId])
        if not newNetId or newNetId <= 0 or newNetId ~= oldNetId then
            RemoveLocalNpcTarget(pitchId)
            soccerNpcNetIds[pitchId] = nil
            soccerNpcEntities[pitchId] = nil
        end
    end

    for pitchId, rawNetId in pairs(snapshot) do
        local netId = tonumber(rawNetId)
        local pitch = GetPitchConfigById(pitchId)
        if pitch and netId and netId > 0 then
            if soccerNpcNetIds[pitchId] ~= netId then
                RemoveLocalNpcTarget(pitchId)
                soccerNpcNetIds[pitchId] = netId
                soccerNpcEntities[pitchId] = nil
            end
            ConfigureStreamedSoccerNpc(pitchId, netId)
        end
    end
end)

-- Pede a lista dos NPCs ao servidor assim que a sessao existir.
CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(250) end
    while not PlayerPedId() or PlayerPedId() == 0 do Wait(250) end
    Wait(1000)
    TriggerServerEvent("seoul_soccer:server:RequestNpcs")
end)

-- Quando o ped entra/sai do culling do OneSync, o handle local pode mudar.
-- Reassocia o target apenas quando necessario; nao recria NPC nenhum.
CreateThread(function()
    while true do
        Wait(500)
        for pitchId, netId in pairs(soccerNpcNetIds) do
            local current = soccerNpcEntities[pitchId]
            if current and (not DoesEntityExist(current) or not NetworkDoesEntityExistWithNetworkId(netId)) then
                RemoveLocalNpcTarget(pitchId)
                soccerNpcEntities[pitchId] = nil
            end

            if not soccerNpcEntities[pitchId] or soccerNpcTargetEntities[pitchId] ~= soccerNpcEntities[pitchId] then
                ConfigureStreamedSoccerNpc(pitchId, netId)
            end
        end
    end
end)

-- Gol: sunucu bazen top koordinatini guncellemez; kaledeyken istemci konumu gonderir
-- Wait(100) → Wait(40): hizli sutlarda top 100ms'de 3.4m gider, kale kutusu 2.44m derindir → tunneling
CreateThread(function()
    local lastSend = 0
    local lastDebugEnt = 0
    local lastDebugPos = 0
    while true do
        if not matchData or matchData.state ~= "playing" or not matchData.lobbyId or not matchData.pitchId then
            Wait(2000)
            goto goal_suggest_cont
        end
        Wait(40)
        if not matchData or matchData.state ~= "playing" or not matchData.pitchId then goto goal_suggest_cont end
        local gd = Config.GoalDetection or {}
        local dbg = gd.Debug == true or goalDebugClientToggle
        local pitch = GetPitchById(matchData.pitchId)
        if not pitch then goto goal_suggest_cont end
        local ent = TryResolveBallEntity()
        local now = GetGameTimer()
        if not ent then
            if dbg and now - lastDebugEnt > 3000 then
                lastDebugEnt = now
            end
            goto goal_suggest_cont
        end
        local c = GetEntityCoords(ent)
        if not c then goto goal_suggest_cont end
        if dbg and now - lastDebugPos > 2000 then
            lastDebugPos = now
        end
        if not GoalShared.IsBallInAnyGoalZone(pitch, c) then goto goal_suggest_cont end
        if now - lastSend < 30 then goto goal_suggest_cont end
        lastSend = now
        TriggerServerEvent('seoul_soccer:server:SuggestBallGoalAt', matchData.lobbyId, c.x, c.y, c.z)
        ::goal_suggest_cont::
    end
end)

-- Config.GoalDetection.Debug veya /soccer_goaldebug: top kale kutusunda mi (kalibrasyon)
CreateThread(function()
    while true do
        Wait(850)
        local gd = Config.GoalDetection or {}
        if not gd.Debug and not goalDebugClientToggle then
            goto dbg_skip
        end
        if not matchData or matchData.state ~= "playing" or not matchData.pitchId then
            goto dbg_skip
        end
        local pitch = GetPitchById(matchData.pitchId)
        if not pitch then goto dbg_skip end
        local ent = TryResolveBallEntity()
        if not ent then
            goto dbg_skip
        end
        local c = GetEntityCoords(ent)
        if not c then goto dbg_skip end
        local msg = GoalShared.DebugBallVsGoals(pitch, c)
        local niv = tonumber(gd.DebugNotifyIntervalMs) or 0
        if niv > 0 then
            local now = GetGameTimer()
            if now - goalDebugLastNotify >= niv then
                goalDebugLastNotify = now
                Bridge.Notify(msg, "inform", math.min(math.max(niv - 200, 1500), 9000))
            end
        end
        ::dbg_skip::
    end
end)

-- Kaleci noktaları: iki kalede DrawText, sadece kendi kalende E ile rol alinir.
CreateThread(function()
    while true do
        local waitMs = 250
        local gk = Config.Goalkeeper or {}
        if matchData and matchData.pitchId and IsGoalkeeperStateActive() and gk.Enabled ~= false then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                local myId = GetPlayerServerId(PlayerId())
                local myTeam = GetMyTeamIndex()
                local playerPos = GetEntityCoords(ped)
                local textDistance = tonumber(gk.TextDistance) or 13.0
                local interactDistance = tonumber(gk.InteractDistance) or 2.8
                local key = tonumber(gk.Key) or 38
                local keyLabel = tostring(gk.KeyLabel or "E")
                local exitKey = tonumber(gk.ExitKey) or 73
                local closestOwnSlot = nil
                local closestOwnDist = nil
                local canTryGoalkeeperSave = false
                local canTryGoalkeeperPickup = false
                local shouldDraw = false

                for _, slot in ipairs(BuildGoalkeeperSlots(matchData.pitchId)) do
                    local dx = playerPos.x - slot.x
                    local dy = playerPos.y - slot.y
                    local dz = playerPos.z - slot.z
                    local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))

                    if dist <= textDistance then
                        shouldDraw = true
                        local keeperSrc, keeperName = GetGoalkeeperInfo(slot.team)
                        local text = LOr('client.gk_opponent_goal', 'Opponent goal')
                        local r, g, b = 245, 245, 245

                        if slot.team == myTeam then
                            if keeperSrc == myId then
                                text = LOr('client.gk_you', 'Goalkeeper: You')
                                r, g, b = 95, 210, 255
                            elseif keeperSrc ~= 0 then
                                text = LOr('client.gk_occupied', 'Goalkeeper: %s', keeperName or LOr('client.gk_occupied_fallback', 'Occupied'))
                                r, g, b = 246, 201, 14
                            else
                                text = LOr('client.gk_take_role', '[%s] Become goalkeeper', keyLabel)
                                r, g, b = 77, 230, 115
                            end
                        else
                            r, g, b = 255, 120, 120
                        end

                        DrawText3D(slot.x, slot.y, slot.z, text, r, g, b)
                    end

                    if slot.team == myTeam and dist <= interactDistance and (not closestOwnDist or dist < closestOwnDist) then
                        closestOwnSlot = slot
                        closestOwnDist = dist
                    end
                end

                local isKeeper = IsMyGoalkeeper()
                local pickupCfg = gk.PickupAtFeet or {}
                local pickupKey = tonumber(pickupCfg.Key) or 47
                local pickupKeyLabel = tostring(pickupCfg.KeyLabel or "G")
                if isKeeper and not IsMyGoalkeeperHolding() and matchData.state ~= "paused" then
                    local areaSlot = GetClosestOwnGoalkeeperSlot(playerPos, tonumber(gk.AreaRadius) or 8.0)
                    local ent = TryResolveBallEntity()
                    if areaSlot and ent and ballControl.owner ~= myId then
                        local ballPos = GetEntityCoords(ent)
                        local playerSaveDistance = tonumber(gk.SavePromptDistance) or tonumber(gk.ParryDistance) or 8.0
                        local goalSaveDistance = tonumber(gk.GoalPointPromptDistance) or playerSaveDistance
                        local ballNearPlayer = ballPos and DistanceBetween(playerPos, ballPos) <= playerSaveDistance
                        local ballNearGoalkeeperArea = ballPos and Distance2D(areaSlot, ballPos) <= goalSaveDistance
                        if ballNearPlayer or ballNearGoalkeeperArea then
                            shouldDraw = true
                            canTryGoalkeeperSave = true
                            DrawText3D(playerPos.x, playerPos.y, playerPos.z + 1.15, LOr('client.gk_catch_save', '[%s] Catch / Save', keyLabel), 95, 210, 255)
                        end

                        if pickupCfg.Enabled ~= false and ballPos then
                            local onlyLoose = (pickupCfg.OnlyLooseBall ~= false)
                            local ballOwnerSrc = tonumber(ballControl.owner) or 0
                            local looseOk = (ballOwnerSrc == 0) or (not onlyLoose)
                            local pickupMaxDist = tonumber(pickupCfg.BallMaxDistance) or 2.0
                            local pickupMaxZ = tonumber(pickupCfg.BallMaxZAbovePed) or 1.3
                            local pickupPromptDist = tonumber(pickupCfg.PromptDistance) or (pickupMaxDist + 2.0)
                            local pickupMaxSpeed = tonumber(pickupCfg.BallMaxSpeed) or 4.5
                            local ballSpeedForPickup = 0.0
                            if GetEntitySpeed then
                                local ok, sp = pcall(GetEntitySpeed, ent)
                                if ok and sp then ballSpeedForPickup = sp end
                            end
                            local dxyz = DistanceBetween(playerPos, ballPos)
                            local zDelta = ballPos.z - playerPos.z
                            local lowEnough = (zDelta <= pickupMaxZ)
                            local slowEnough = (ballSpeedForPickup <= pickupMaxSpeed)
                            if looseOk and dxyz <= pickupPromptDist and lowEnough then
                                shouldDraw = true
                                if dxyz <= pickupMaxDist and slowEnough then
                                    canTryGoalkeeperPickup = true
                                    DrawText3D(playerPos.x, playerPos.y, playerPos.z + 0.92, LOr('client.gk_pickup_ball', '[%s] Pick up ball', pickupKeyLabel), 120, 235, 150)
                                else
                                    DrawText3D(playerPos.x, playerPos.y, playerPos.z + 0.92, LOr('client.gk_move_closer', '[%s] Move closer to the ball', pickupKeyLabel), 180, 180, 180)
                                end
                            end
                        end
                    end
                end

                if isKeeper then
                    shouldDraw = true
                end

                if shouldDraw then
                    waitMs = 0
                end

                local savePressed = canTryGoalkeeperSave and IsControlJustPressed(0, key)
                local pickupPressed = canTryGoalkeeperPickup and IsControlJustPressed(0, pickupKey)
                if savePressed and matchData and matchData.lobbyId then
                    local now = GetGameTimer()
                    local saveCooldownMs = tonumber(gk.SaveCooldownMs) or 1450
                    if (now - (goalieControl.lastRequest or 0)) > saveCooldownMs then
                        goalieControl.lastRequest = now
                        goalieControl.interactLockUntil = now + 400
                        TriggerServerEvent('seoul_soccer:server:RequestGoalkeeperSave', matchData.lobbyId)
                    end
                elseif pickupPressed and matchData and matchData.lobbyId then
                    local now = GetGameTimer()
                    local pickupCooldownMs = tonumber(pickupCfg.CooldownMs) or 800
                    if (now - (goalieControl.lastRequest or 0)) > pickupCooldownMs then
                        goalieControl.lastRequest = now
                        goalieControl.interactLockUntil = now + 350
                        TriggerServerEvent('seoul_soccer:server:RequestGoalkeeperPickup', matchData.lobbyId)
                    end
                elseif closestOwnSlot and IsControlJustPressed(0, key) and matchData and matchData.lobbyId then
                    local now = GetGameTimer()
                    local keeperSrc = GetGoalkeeperInfo(closestOwnSlot.team)
                    if keeperSrc == 0 and (now - (goalieControl.lastRequest or 0)) > 500 then
                        goalieControl.lastRequest = now
                        goalieControl.interactLockUntil = now + 400
                        TriggerServerEvent('seoul_soccer:server:ToggleGoalkeeper', matchData.lobbyId, closestOwnSlot.team)
                    end
                end

                if isKeeper and IsControlJustPressed(0, exitKey) then
                    local now = GetGameTimer()
                    if (now - (goalieControl.lastRequest or 0)) > 500 then
                        goalieControl.lastRequest = now
                        goalieControl.interactLockUntil = now + 400
                        if matchData and matchData.lobbyId then
                            TriggerServerEvent('seoul_soccer:server:LeaveGoalkeeper', matchData.lobbyId)
                        end
                    end
                end
            end
        else
            waitMs = 2000
        end
        Wait(waitMs)
    end
end)

--- Gol cizgisi debug: DrawLine kalinligi yok; GoalLineDebugThicknessM > 0 ise XY'de paralel cizgiler (gol mantigi degismez)
local function DrawGoalDebugSegment(seg, r, g, b, a)
    if not DrawLine or not seg or not seg.from or not seg.to then return end
    local fx, fy, fz = seg.from.x, seg.from.y, seg.from.z
    local tx, ty, tz = seg.to.x, seg.to.y, seg.to.z
    local thick = tonumber((Config.GoalDetection or {}).GoalLineDebugThicknessM) or 0
    if thick <= 0 then
        DrawLine(fx, fy, fz, tx, ty, tz, r, g, b, a)
        return
    end
    local dx, dy = tx - fx, ty - fy
    local len = math.sqrt((dx * dx) + (dy * dy))
    if len < 0.001 then
        DrawLine(fx, fy, fz, tx, ty, tz, r, g, b, a)
        return
    end
    local px, py = -dy / len, dx / len
    local half = thick * 0.5
    local step = math.min(0.035, math.max(0.012, thick / 6))
    local o = -half
    while o <= half + 0.00001 do
        DrawLine(
            fx + px * o, fy + py * o, fz,
            tx + px * o, ty + py * o, tz,
            r, g, b, a
        )
        o = o + step
    end
end

-- Gol kale cizgisi (otomatik veya goals[].goalLine): kalibrasyon icin yesil DrawLine
CreateThread(function()
    while true do
        local waitMs = 2000
        local gd = Config.GoalDetection or {}
        if gd.DrawGoalLineDebug and matchData and matchData.pitchId then
            local st = matchData.state
            if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
                local pitch = GetPitchById(matchData.pitchId)
                if pitch and GoalShared and GoalShared.GetGoalLineDrawSegments and DrawLine then
                    local ped = PlayerPedId()
                    local playerPos = (ped and ped ~= 0) and GetEntityCoords(ped)
                    local close = false
                    if playerPos then
                        for _, seg in ipairs(GoalShared.GetGoalLineDrawSegments(pitch)) do
                            local midX = (seg.from.x + seg.to.x) * 0.5
                            local midY = (seg.from.y + seg.to.y) * 0.5
                            local midZ = (seg.from.z + seg.to.z) * 0.5
                            local dx = playerPos.x - midX
                            local dy = playerPos.y - midY
                            local dz = playerPos.z - midZ
                            local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                            if dist < 120.0 then
                                close = true
                                break
                            end
                        end
                    end

                    if close then
                        waitMs = 0
                        for _, seg in ipairs(GoalShared.GetGoalLineDrawSegments(pitch)) do
                            DrawGoalDebugSegment(seg, 0, 255, 100, 220)
                        end
                    else
                        waitMs = 400
                    end
                else
                    waitMs = 400
                end
            end
        end
        Wait(waitMs)
    end
end)

-- Kale isaretleri: warmup + countdown (Config.GoalMarkers.ShowDuring)
CreateThread(function()
    while true do
        local waitMs = 2000
        if GoalMarkersShouldShow() then
            local gm = Config.GoalMarkers or {}
            if gm.Enabled ~= false and matchData and matchData.pitchId then
                local slots = BuildGoalMarkerSlots(matchData.pitchId)
                if #slots > 0 then
                    local ped = PlayerPedId()
                    local playerPos = (ped and ped ~= 0) and GetEntityCoords(ped)
                    local close = false
                    if playerPos then
                        for _, m in ipairs(slots) do
                            local dx = playerPos.x - m.x
                            local dy = playerPos.y - m.y
                            local dz = playerPos.z - m.z
                            local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                            if dist < 120.0 then
                                close = true
                                break
                            end
                        end
                    end

                    if close then
                        waitMs = 0
                        DrawGoalMarkersForSlots(slots, gm)
                    else
                        waitMs = 500
                    end
                else
                    waitMs = 500
                end
            else
                waitMs = 1000
            end
        end
        Wait(waitMs)
    end
end)

-- Top vurgusu: ballOutline — entity_outline (secili prop) veya drawline (eski halkalar)
CreateThread(function()
    while true do
        local waitMs = 2000
        if matchData and matchData.ballOutline == true then
            local st = matchData.state
            if st == "warmup" or st == "countdown" or st == "playing" or st == "paused" then
                waitMs = 120
                local cfg = Config.BallOutline or {}
                local mode = string.lower(tostring(cfg.Mode or "entity_outline"))
                local useOutline = (mode ~= "drawline") and BallOutlineEntityNativeAvailable()

                if useOutline then
                    local ent = TryResolveBallEntity()
                    if not ent or ent == 0 or not DoesEntityExist(ent) then
                        ClearBallEntityOutline()
                    else
                        waitMs = 0
                        if ballOutlineLastEntity ~= 0 and ballOutlineLastEntity ~= ent and SetEntityDrawOutline then
                            pcall(SetEntityDrawOutline, ballOutlineLastEntity, false)
                        end
                        ApplyBallEntityOutline(ent)
                    end
                else
                    ClearBallEntityOutline()
                    local ent = TryResolveBallEntity()
                    if ent and ent ~= 0 and DoesEntityExist(ent) then
                        waitMs = 0
                        DrawBallOutlineRings(ent)
                    end
                end
            else
                ClearBallEntityOutline()
            end
        else
            ClearBallEntityOutline()
        end
        Wait(waitMs)
    end
end)

CreateThread(function()
    Wait(1)
    SendNUIMessage({
        action = "initLocale",
        data   = GetNuiLocalePayload()
    })
end)

CreateThread(function()
    while true do
        local waitMs = 500
        local shouldWatch = isUiOpen or matchData ~= nil or goalCelebrationState ~= nil or ballControl.chargeUiVisible == true

        if shouldWatch then
            waitMs = 150
            local ped = PlayerPedId()
            local isDead = ped and ped ~= 0 and DoesEntityExist(ped)
                and (IsEntityDead(ped) or IsPedDeadOrDying(ped, true))

            if isDead then
                if not footballUiDeathClosed then
                    footballUiDeathClosed = true
                    HideFootballUiBecauseDead()
                end
            else
                footballUiDeathClosed = false
            end
        else
            footballUiDeathClosed = false
        end

        Wait(waitMs)
    end
end)

-- ─────────────────────────────────────────────
-- Harita Blipleri
-- ─────────────────────────────────────────────
local pitchBlips = {}

local function CreatePitchBlips()
    local cfg = Config.MapBlips
    if not cfg or cfg.Enabled ~= true then return end
    if type(Config.Pitches) ~= "table" then return end

    for _, pitch in ipairs(Config.Pitches) do
        if pitch.coords then
            local blip = AddBlipForCoord(pitch.coords.x, pitch.coords.y, pitch.coords.z)
            SetBlipSprite(blip, tonumber(cfg.Sprite) or 58)
            SetBlipColour(blip, tonumber(cfg.Color) or 2)
            SetBlipScale(blip, tonumber(cfg.Scale) or 1.0)
            SetBlipAsShortRange(blip, cfg.ShortRange == true)
            local label = cfg.Label and LOr('config.map_blip_fallback', tostring(cfg.Label)) or GetLocalizedPitchName(pitch)
            if label == "" then label = LOr('config.map_blip_fallback', 'Soccer Pitch') end
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(label)
            EndTextCommandSetBlipName(blip)
            pitchBlips[#pitchBlips + 1] = blip
        end
    end
end

local function RemovePitchBlips()
    for _, blip in ipairs(pitchBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    pitchBlips = {}
end

CreateThread(function()
    Wait(500) -- streaming ve config yüklemesini bekle
    CreatePitchBlips()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    StopJerseyPreviewCamera()
    ClearBallEntityOutline()
    RemovePitchBlips()
    Uniform.Remove()
    for pitchId in pairs(soccerNpcNetIds) do
        RemoveLocalNpcTarget(pitchId)
    end
    soccerNpcNetIds = {}
    soccerNpcEntities = {}
end)
