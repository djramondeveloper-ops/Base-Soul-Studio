--- Gol kutusu testi (sunucu + istemci ayni matematik)
-- _G kullanimi: bazi FiveM surumleri shared script _ENV'ini izole eder;
-- _G.GoalShared ile gercek global tabloya yazilir ve tum script'lerden erisilebilir.
_G.GoalShared = _G.GoalShared or {}
GoalShared = _G.GoalShared

local function Gd()
    return Config.GoalDetection or {}
end

--- Tek kale girdisini { min, max, scoringTeam, side } yapisina cevirir.
--- min+max varsa oldugu gibi; yoksa center + (halfExtents veya radius) ile kutu uretilir.
function GoalShared.NormalizeGoalEntry(g)
    if not g then return nil end
    if g.min and g.max then
        return {
            min = g.min,
            max = g.max,
            scoringTeam = g.scoringTeam,
            side = g.side,
        }
    end
    if g.center then
        local cx, cy, cz = g.center.x, g.center.y, g.center.z
        local hx, hy, hz
        if g.halfExtents then
            local he = g.halfExtents
            hx = math.abs(tonumber(he.x) or 2.5)
            hy = math.abs(tonumber(he.y) or 2.5)
            hz = math.abs(tonumber(he.z) or 2.5)
        elseif g.radius then
            local r = math.abs(tonumber(g.radius) or 3.0)
            hx, hy, hz = r, r, r
        else
            hx = math.abs(tonumber(g.defaultHalf) or 3.0)
            hy = hx
            hz = math.abs(tonumber(g.defaultHalfZ) or 2.5)
        end
        return {
            min = vector3(cx - hx, cy - hy, cz - hz),
            max = vector3(cx + hx, cy + hy, cz + hz),
            scoringTeam = g.scoringTeam,
            side = g.side,
        }
    end
    return nil
end

--- min/max vektorlerinden genisletilmis AABB sinirlari (ince Z / dar XY icin)
--- Config.GoalDetection.StrictGoalBounds == true: genisletme yok (halfExtents/min+max tam kullanilir; yanlis gol riskini azaltir)
--- noAirZ = true: GoalAirZHeadroomM uygulanmaz (kale cizgisi segmenti hesabinda kullanilir; Z'yi sismirmemek lazim)
function GoalShared.ExpandedAabbBounds(box, noAirZ)
    if not box or not box.min or not box.max then return nil end
    local mn, mx = box.min, box.max
    local minX, maxX = math.min(mn.x, mx.x), math.max(mn.x, mx.x)
    local minY, maxY = math.min(mn.y, mx.y), math.max(mn.y, mx.y)
    local minZ, maxZ = math.min(mn.z, mx.z), math.max(mn.z, mx.z)

    local gd = Gd()
    if gd.StrictGoalBounds == true then
        if not noAirZ then
            local airZ0 = tonumber(gd.GoalAirZHeadroomM)
            if airZ0 and airZ0 > 0 then
                maxZ = maxZ + airZ0
            end
        end
        return minX, maxX, minY, maxY, minZ, maxZ
    end
    local zMinThickness = tonumber(gd.ZSlabMinThickness) or 0.45
    local zHalfExpand = tonumber(gd.ZSlabHalfHeight) or 2.75
    if (maxZ - minZ) < zMinThickness then
        local mid = (minZ + maxZ) * 0.5
        minZ = mid - zHalfExpand
        maxZ = mid + zHalfExpand
    end

    local xyPad = tonumber(gd.XYEdgePadding) or 0.9
    local minSpan = tonumber(gd.XYMinSpan) or 1.35
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

    --- Yukaridan sut / lob: sadece kutu testi (PointInGoalBox) icin maxZ genisletilir; cizgi segmenti icin degil
    if not noAirZ then
        local airZ = tonumber(gd.GoalAirZHeadroomM)
        if airZ and airZ > 0 then
            maxZ = maxZ + airZ
        end
    end

    return minX, maxX, minY, maxY, minZ, maxZ
end

function GoalShared.PointInGoalBox(pos, box)
    if not pos then return false end
    local minX, maxX, minY, maxY, minZ, maxZ = GoalShared.ExpandedAabbBounds(box)
    if not minX then return false end
    return pos.x >= minX and pos.x <= maxX
        and pos.y >= minY and pos.y <= maxY
        and pos.z >= minZ and pos.z <= maxZ
end

--- Saha->kale birim vektoru u ile baskın ekseni bulur; o eksene dik olan kale on yuzunu secer
--- ve o yuz boyunca direk-uclarini birlestirir.
--- extendEach > 0: segment uzerinde her iki uca bu kadar (m) uzatir (kutu XY genisletmeden cizgi uzunlugu).
local function mouthSegmentFromBoxEdgeXY(box, ux, uy, extendEach)
    if not box or not box.min or not box.max then return nil end
    -- noAirZ=true: kale agzinin geometrik sinirlari; Z headroom burada gereksiz ve yaniltici
    local minX, maxX, minY, maxY, minZ, maxZ = GoalShared.ExpandedAabbBounds(box, true)
    if not minX then return nil end
    local ulen = math.sqrt((ux or 0) * (ux or 0) + (uy or 0) * (uy or 0))
    if ulen < 0.001 then return nil end
    ux, uy = ux / ulen, uy / ulen

    local ax, ay, bx, by
    if math.abs(ux) >= math.abs(uy) then
        -- X baskın: on yuz x = (ux>0 → minX, ux<0 → maxX); genislik Y boyunca
        local fx = (ux > 0) and minX or maxX
        ax, ay, bx, by = fx, minY, fx, maxY
    else
        -- Y baskın: on yuz y = (uy>0 → minY, uy<0 → maxY); genislik X boyunca
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

--- from-to segmentini XY duzleminde her uca ext kadar uzatir (Z ayni kalir).
local function extendExplicitGoalLineXY(fx, fy, fz, tx, ty, tz, extEach)
    local dx, dy = tx - fx, ty - fy
    local span = math.sqrt(dx * dx + dy * dy)
    if span < 1e-4 then return fx, fy, fz, tx, ty, tz end
    local ext = tonumber(extEach) or 0
    if ext <= 0 then return fx, fy, fz, tx, ty, tz end
    local ex = (dx / span) * ext
    local ey = (dy / span) * ext
    return fx - ex, fy - ey, fz, tx + ex, ty + ey, tz
end

--- Capraz sahada AABB sahaya tasmasin: top kale agzindan (saha tarafindan) iceri girmis olmali.
--- intoGoal = normalize(kaleXY - sahaXY); agiz = kaleMerkezi - intoGoal * offset; dot(pos-agiz, intoGoal) >= minDot
--- Kale cizgisi: explicit goalLine { from, to, inside } veya pitch tabanli otomatik segment
function GoalShared.ResolveScoringLine(pitch, raw, box)
    if not pitch or not pitch.coords then return nil end
    local gd = Gd()

    if raw and raw.goalLine and raw.goalLine.from and raw.goalLine.to and raw.goalLine.inside then
        local f, t, ins = raw.goalLine.from, raw.goalLine.to, raw.goalLine.inside
        --- Uzatma: once kale satiri (raw.goalLineExtendEachSideM), sonra GoalLineExplicitExtendEachSideM, yoksa Mouth ile ayni
        local extEach = tonumber(raw.goalLineExtendEachSideM)
        if extEach == nil then extEach = tonumber(gd.GoalLineExplicitExtendEachSideM) end
        if extEach == nil then extEach = tonumber(gd.GoalLineMouthExtendEachSideM) end
        extEach = extEach or 0
        local ax, ay, az, bx, by, bz = extendExplicitGoalLineXY(f.x, f.y, f.z, t.x, t.y, t.z, extEach)
        return {
            ax = ax, ay = ay, az = az,
            bx = bx, by = by, bz = bz,
            ix = ins.x, iy = ins.y, iz = ins.z,
        }
    end

    if gd.UsePitchBasedGoalLine ~= true or (raw and raw.skipPastPlane == true) then
        return nil
    end

    local gx, gy, gz
    if raw and raw.center then
        gx, gy, gz = raw.center.x, raw.center.y, raw.center.z
    elseif box and box.min and box.max then
        gx = (box.min.x + box.max.x) * 0.5
        gy = (box.min.y + box.max.y) * 0.5
        gz = (box.min.z + box.max.z) * 0.5
    else
        return nil
    end

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
        local mx1, my1, mx2, my2, zm = mouthSegmentFromBoxEdgeXY(box, ux, uy, mouthExt)
        if mx1 then
            ax, ay, bx, by = mx1, my1, mx2, my2
            az = zm
            bz = zm
            usedBoxMouth = true
        end
    end
    if not usedBoxMouth then
        local back = tonumber(gd.AutoGoalLineBackFromCenter) or 2.88
        local hw = tonumber(raw and raw.goalLineHalfWidth) or tonumber(gd.AutoGoalLineHalfWidth) or 2.05
        local hy = (raw and raw.halfExtents) and math.abs(tonumber(raw.halfExtents.y) or 0) or 0
        if hy > 0.35 then
            hw = math.min(hw, hy * 0.98)
        end

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
    local ix = gx + ux * deep
    local iy = gy + uy * deep
    local iz = gz

    return { ax = ax, ay = ay, az = az, bx = bx, by = by, bz = bz, ix = ix, iy = iy, iz = iz }
end

--- Cizgi uzerindeki dik yarim duzlem: kale icine dogru n ile dot(pos-mid, n) >= GoalLineMinAdvance
function GoalShared.IsBallPastGoalScoringLine(pitch, raw, pos, box)
    if not pos then return true end
    local line = GoalShared.ResolveScoringLine(pitch, raw, box)
    if not line then
        return GoalShared.IsPastGoalMouthPlane(pitch, raw, pos, box)
    end

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
    if dotIn < 0 then
        nx, ny = n2x, n2y
    end

    local gd = Gd()
    local minAdv = tonumber(gd.GoalLineMinAdvance) or 0.24
    --- Lob: ust Z'de top cizgiyi XY'de henuz az gecmisken gec sayiliyordu; ust bantta daha dusuk esik
    --- noAirZ=true: gerçek kale kutusunun ust siniri; headroom eklenirse band hesabi kayar
    if box then
        local _, _, _, _, zLo, zHi = GoalShared.ExpandedAabbBounds(box, true)
        local span = (zLo and zHi) and (zHi - zLo) or 0
        local frac = tonumber(gd.GoalLineAirZBandFraction)
        if span > 0.15 and frac and frac > 0 and frac < 1 and pos.z >= zLo + span * frac then
            local airAdv = tonumber(gd.GoalLineMinAdvanceAir)
            if airAdv == nil then airAdv = 0.08 end
            minAdv = math.min(minAdv, airAdv)
        end
    end
    local d = ((pos.x - mx) * nx) + ((pos.y - my) * ny)
    return d >= minAdv
end

function GoalShared.GetGoalLineDrawSegments(pitch)
    local out = {}
    if not pitch or type(pitch.goals) ~= "table" then return out end
    for _, raw in ipairs(pitch.goals) do
        local box = GoalShared.NormalizeGoalEntry(raw)
        local line = GoalShared.ResolveScoringLine(pitch, raw, box)
        if line then
            out[#out + 1] = {
                from = vector3(line.ax, line.ay, line.az),
                to   = vector3(line.bx, line.by, line.bz),
            }
        end
    end
    return out
end

function GoalShared.IsPastGoalMouthPlane(pitch, raw, pos, box)
    if not pitch or not pitch.coords or not pos then return true end
    local gd = Gd()
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

function GoalShared.FindScoringTeamAtPosition(pitch, pos)
    if not pitch or type(pitch.goals) ~= "table" or not pos then return nil end
    for _, raw in ipairs(pitch.goals) do
        local box = GoalShared.NormalizeGoalEntry(raw)
        if box and GoalShared.PointInGoalBox(pos, box) and GoalShared.IsBallPastGoalScoringLine(pitch, raw, pos, box) then
            local st = tonumber(box.scoringTeam)
            if st == 1 or st == 2 then
                return st
            end
        end
    end
    return nil
end

function GoalShared.IsBallInAnyGoalZone(pitch, pos)
    return GoalShared.FindScoringTeamAtPosition(pitch, pos) ~= nil
end

--- Trajectory sweep: prevPos → currPos segmenti herhangi bir kale cizgisini geciyorsa takim dondurur.
--- Hizli sutlarda top anlık ornekleme araliginda kale kutusunu tamamen gecebilir (tunneling).
--- 2D cizgi-cizgi kesisimi + Z aralik kontrolu + kale icine dogru yon kontrolu.
function GoalShared.FindScoringTeamForSegment(pitch, prevPos, currPos)
    if not pitch or type(pitch.goals) ~= "table" or not prevPos or not currPos then return nil end
    local pdx = currPos.x - prevPos.x
    local pdy = currPos.y - prevPos.y
    local pdz = currPos.z - prevPos.z
    local segLen2d = math.sqrt((pdx * pdx) + (pdy * pdy))
    -- Cok kisa hareket; anlık kontrol yeterli
    if segLen2d < 0.05 then return nil end

    for _, raw in ipairs(pitch.goals) do
        local box = GoalShared.NormalizeGoalEntry(raw)
        if not box then goto sweepCont end
        local line = GoalShared.ResolveScoringLine(pitch, raw, box)
        if not line then goto sweepCont end

        -- 2D segment kesisimi: (ax,ay)-(bx,by) ve (prevPos.xy)-(currPos.xy)
        local lax, lay = line.ax, line.ay
        local lbx, lby = line.bx, line.by
        local ldx, ldy = lbx - lax, lby - lay

        -- cross2d(a,b) = ax*by - ay*bx
        local denom = ldx * pdy - ldy * pdx
        if math.abs(denom) < 1e-8 then goto sweepCont end -- paralel

        local ex = prevPos.x - lax
        local ey = prevPos.y - lay
        local t = (ex * pdy - ey * pdx) / denom  -- [0,1] = kale cizgisi uzerinde
        local s = (ex * ldy - ey * ldx) / denom  -- [0,1] = top yolu uzerinde

        if t < 0.0 or t > 1.0 or s < 0.0 or s > 1.0 then goto sweepCont end

        -- Z'yi kesisim noktasinda dogrusal interpolasyonla hesapla
        local iz = prevPos.z + s * pdz
        local _, _, _, _, minZ, maxZ = GoalShared.ExpandedAabbBounds(box)
        if not minZ or iz < minZ or iz > maxZ then goto sweepCont end

        -- Yon kontrolu: top kale icine dogru gitmeli (inside noktasina dogru)
        local lmidX = (lax + lbx) * 0.5
        local lmidY = (lay + lby) * 0.5
        local inDotX = line.ix - lmidX
        local inDotY = line.iy - lmidY
        local moveDot = pdx * inDotX + pdy * inDotY
        if moveDot <= 0 then goto sweepCont end -- kale disina dogru gidiyor

        local st = tonumber(box.scoringTeam)
        if st == 1 or st == 2 then return st end
        ::sweepCont::
    end
    return nil
end

--- Kalibrasyon: top konumu ve hangi kale kutusunda (yoksa disarida)
function GoalShared.DebugBallVsGoals(pitch, pos)
    if not pitch or not pos then return "pitch veya pos yok" end
    local st = GoalShared.FindScoringTeamAtPosition(pitch, pos)
    local base = ("top: %.2f  %.2f  %.2f"):format(pos.x, pos.y, pos.z)
    if st then
        return base .. ("  |  kutu + kale cizgisi -> gol: takim %d"):format(st)
    end
    for _, raw in ipairs(pitch.goals or {}) do
        local box = GoalShared.NormalizeGoalEntry(raw)
        if box and GoalShared.PointInGoalBox(pos, box) and not GoalShared.IsBallPastGoalScoringLine(pitch, raw, pos, box) then
            return base .. "  |  kutuda ama kale cizgisi gecilmedi (GoalLineMinAdvance / AutoGoalLineBackFromCenter)"
        end
    end
    return base .. "  |  kutuda degil (min/max/center veya playing durumunu kontrol et)"
end
