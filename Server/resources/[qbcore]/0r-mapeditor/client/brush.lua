local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1
L0_1 = {}
Brush = L0_1
L0_1 = Config
L0_1 = L0_1.brush
L1_1 = false
L2_1 = nil
L3_1 = L0_1.radius
L4_1 = L0_1.density
L5_1 = L0_1.alignToSurface
L6_1 = L0_1.randomYaw
L7_1 = 0
L8_1 = {}
L9_1 = {}
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L9_1
  L1_2 = #L1_2
  if 0 == L1_2 then
    return
  end
  L1_2 = {}
  L2_2 = 1
  L3_2 = L9_1
  L3_2 = #L3_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = Objects
    L6_2 = L6_2.IdByUid
    L7_2 = L9_1
    L7_2 = L7_2[L5_2]
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = #L1_2
      L7_2 = L7_2 + 1
      L8_2 = {}
      L8_2.kind = "add"
      L9_2 = Objects
      L9_2 = L9_2.Snapshot
      L10_2 = L6_2
      L9_2 = L9_2(L10_2)
      L8_2.snapshot = L9_2
      L8_2.label = "Place"
      L1_2[L7_2] = L8_2
    end
  end
  L2_2 = {}
  L9_1 = L2_2
  L2_2 = History
  if L2_2 then
    L2_2 = #L1_2
    if L2_2 > 0 then
      L2_2 = History
      L2_2 = L2_2.Push
      L3_2 = Cmd
      L3_2 = L3_2.Batch
      L4_2 = A0_2 or L4_2
      if not A0_2 then
        L4_2 = locale
        L5_2 = "hist.brush"
        L4_2 = L4_2(L5_2)
      end
      L5_2 = L1_2
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2, L5_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    end
  end
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L8_1
  L1_2 = #L1_2
  L2_2 = L1_2 + 1
  L1_2 = L8_1
  L1_2[L2_2] = A0_2
  L1_2 = L8_1
  L1_2 = #L1_2
  L2_2 = 400
  if L1_2 > L2_2 then
    L1_2 = table
    L1_2 = L1_2.remove
    L2_2 = L8_1
    L3_2 = 1
    L1_2(L2_2, L3_2)
  end
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L0_1.spacing
  L2_2 = L0_1.spacing
  L1_2 = L1_2 * L2_2
  L2_2 = L8_1
  L2_2 = #L2_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = L8_1
  L5_2 = #L5_2
  L5_2 = L5_2 - 120
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = -1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L8_1
    L6_2 = L6_2[L5_2]
    L7_2 = L6_2.x
    L8_2 = A0_2.x
    L7_2 = L7_2 - L8_2
    L8_2 = L6_2.y
    L9_2 = A0_2.y
    L8_2 = L8_2 - L9_2
    L9_2 = L7_2 * L7_2
    L10_2 = L8_2 * L8_2
    L9_2 = L9_2 + L10_2
    if L1_2 > L9_2 then
      L9_2 = true
      return L9_2
    end
  end
  L2_2 = false
  return L2_2
end
function L13_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "brush"
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 and L1_2 then
    return L1_2
  end
  L2_2 = Camera
  L2_2 = L2_2.CursorRay
  L2_2, L3_2 = L2_2()
  L4_2 = L3_2 * 15.0
  L4_2 = L2_2 + L4_2
  return L4_2
end
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = _ENV
  L4_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L3_2 = L3_2[L4_2]
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2 + 6.0
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2 - 60.0
  L10_2 = 1
  L11_2 = 0
  L12_2 = 4
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = GetShapeTestResult
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  if true == L5_2 or 1 == L5_2 then
    L8_2 = L6_2
    L9_2 = L7_2
    return L8_2, L9_2
  end
  L8_2 = nil
  return L8_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L6_1
  if L1_2 then
    L1_2 = math
    L1_2 = L1_2.random
    L1_2 = L1_2()
    L1_2 = L1_2 * 360.0
    if L1_2 then
      goto lbl_12
    end
  end
  L1_2 = 0.0
  ::lbl_12::
  L2_2 = 0.0
  L3_2 = 0.0
  L4_2 = L5_1
  if L4_2 and A0_2 then
    L4_2 = math
    L4_2 = L4_2.deg
    L5_2 = math
    L5_2 = L5_2.atan
    L6_2 = A0_2.y
    L7_2 = A0_2.z
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    L2_2 = L4_2
    L4_2 = math
    L4_2 = L4_2.deg
    L5_2 = math
    L5_2 = L5_2.atan
    L6_2 = A0_2.x
    L7_2 = A0_2.z
    L5_2 = L5_2(L6_2, L7_2)
    L5_2 = -L5_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
  end
  L4_2 = L0_1.randomTilt
  if not L4_2 then
    L4_2 = 0.0
  end
  if L4_2 > 0 then
    L5_2 = math
    L5_2 = L5_2.random
    L5_2 = L5_2()
    L5_2 = L5_2 * 2
    L5_2 = L5_2 - 1
    L5_2 = L5_2 * L4_2
    L2_2 = L2_2 + L5_2
    L5_2 = math
    L5_2 = L5_2.random
    L5_2 = L5_2()
    L5_2 = L5_2 * 2
    L5_2 = L5_2 - 1
    L5_2 = L5_2 * L4_2
    L3_2 = L3_2 + L5_2
  end
  L5_2 = vector3
  L6_2 = L2_2
  L7_2 = L3_2
  L8_2 = L1_2
  return L5_2(L6_2, L7_2, L8_2)
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = math
  L1_2 = L1_2.random
  L1_2 = L1_2()
  L2_2 = math
  L2_2 = L2_2.pi
  L1_2 = L1_2 * L2_2
  L1_2 = L1_2 * 2.0
  L2_2 = math
  L2_2 = L2_2.sqrt
  L3_2 = math
  L3_2 = L3_2.random
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2()
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L3_2 = L3_1
  L2_2 = L2_2 * L3_2
  L3_2 = A0_2.x
  L4_2 = math
  L4_2 = L4_2.cos
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L4_2 = L4_2 * L2_2
  L3_2 = L3_2 + L4_2
  L4_2 = A0_2.y
  L5_2 = math
  L5_2 = L5_2.sin
  L6_2 = L1_2
  L5_2 = L5_2(L6_2)
  L5_2 = L5_2 * L2_2
  L4_2 = L4_2 + L5_2
  L5_2 = L14_1
  L6_2 = L3_2
  L7_2 = L4_2
  L8_2 = A0_2.z
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = L12_1
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      goto lbl_51
    end
  end
  L7_2 = false
  do return L7_2 end
  ::lbl_51::
  L7_2 = Maps
  L7_2 = L7_2.PlaceObject
  L8_2 = L2_1
  L9_2 = L5_2
  L10_2 = L15_1
  L11_2 = L6_2
  L10_2, L11_2 = L10_2(L11_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if not L7_2 then
    L8_2 = false
    return L8_2
  end
  L8_2 = MEAutoSave
  if L8_2 then
    L8_2 = MEAutoSave
    L9_2 = L7_2
    L8_2(L9_2)
  end
  L8_2 = L9_1
  L8_2 = #L8_2
  L9_2 = L8_2 + 1
  L8_2 = L9_1
  L10_2 = Objects
  L10_2 = L10_2.UidOf
  L11_2 = L7_2
  L10_2 = L10_2(L11_2)
  L8_2[L9_2] = L10_2
  L8_2 = L11_1
  L9_2 = L5_2
  L8_2(L9_2)
  L8_2 = true
  return L8_2
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = 0
    return L2_2
  end
  L2_2 = 0
  L3_2 = 1
  L4_2 = A0_2 * 3
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    if A0_2 <= L2_2 then
      break
    end
    L7_2 = L16_1
    L8_2 = A1_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L2_2 = L2_2 + 1
    end
  end
  return L2_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "brush"
  L2_2 = {}
  L3_2 = L1_1
  L2_2.active = L3_2
  L3_2 = L3_1
  L2_2.radius = L3_2
  L3_2 = L4_1
  L2_2.density = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L19_1 = Brush
function L20_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
L19_1.IsActive = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2
  if A0_2 then
    L2_1 = A0_2
  end
end
L19_1.SetModel = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = L0_1.minRadius
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = L0_1.maxRadius
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L3_1
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  L3_1 = L1_2
end
L19_1.SetRadius = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 1
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L4_1
  end
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L4_1 = L1_2
end
L19_1.SetDensity = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2
  L1_2 = true == A0_2
  L5_1 = L1_2
end
L19_1.SetAlign = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2
  L1_2 = true == A0_2
  L6_1 = L1_2
end
L19_1.SetRandomYaw = L20_1
L19_1 = Brush
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L1_1
  if L0_2 then
    L0_2 = L2_1
    if L0_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L0_2 = {}
  L9_1 = L0_2
  L0_2 = L17_1
  L1_2 = L0_1.scatterCount
  L2_2 = L13_1
  L2_2, L3_2, L4_2, L5_2 = L2_2()
  L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  L1_2 = L10_1
  L2_2 = "Scatter"
  L1_2(L2_2)
  L1_2 = MELog
  if L1_2 then
    L1_2 = MELog
    L2_2 = "scatter"
    L3_2 = tostring
    L4_2 = L0_2
    L3_2 = L3_2(L4_2)
    L4_2 = " x "
    L5_2 = L2_1
    L3_2 = L3_2 .. L4_2 .. L5_2
    L1_2(L2_2, L3_2)
  end
end
L19_1.Scatter = L20_1
L19_1 = Brush
function L20_1(A0_2)
  local L1_2, L2_2
  if A0_2 then
    L2_1 = A0_2
  end
  L1_2 = L1_1
  if L1_2 then
    L1_2 = L18_1
    L1_2()
    return
  end
  L1_2 = true
  L1_1 = L1_2
  L1_2 = {}
  L8_1 = L1_2
  L1_2 = L18_1
  L1_2()
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3
    L0_3 = 0
    while true do
      L1_3 = L1_1
      if not L1_3 then
        break
      end
      L1_3 = L13_1
      L1_3 = L1_3()
      L2_3 = DrawMarker
      L3_3 = 1
      L4_3 = L1_3.x
      L5_3 = L1_3.y
      L6_3 = L1_3.z
      L6_3 = L6_3 + 0.05
      L7_3 = 0.0
      L8_3 = 0.0
      L9_3 = 0.0
      L10_3 = 0.0
      L11_3 = 0.0
      L12_3 = 0.0
      L13_3 = L3_1
      L13_3 = L13_3 * 2.0
      L14_3 = L3_1
      L14_3 = L14_3 * 2.0
      L15_3 = 0.4
      L16_3 = 80
      L17_3 = 220
      L18_3 = 255
      L19_3 = 90
      L20_3 = false
      L21_3 = false
      L22_3 = 2
      L23_3 = false
      L24_3 = nil
      L25_3 = nil
      L26_3 = false
      L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3)
      L2_3 = GetGameTimer
      L2_3 = L2_3()
      L3_3 = IsDisabledControlPressed
      L4_3 = 0
      L5_3 = 241
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 then
        L3_3 = L2_3 - L0_3
        if L3_3 > 40 then
          L3_3 = Brush
          L3_3 = L3_3.SetRadius
          L4_3 = L3_1
          L4_3 = L4_3 + 0.4
          L3_3(L4_3)
          L3_3 = L18_1
          L3_3()
          L0_3 = L2_3
        end
      end
      L3_3 = IsDisabledControlPressed
      L4_3 = 0
      L5_3 = 242
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 then
        L3_3 = L2_3 - L0_3
        if L3_3 > 40 then
          L3_3 = Brush
          L3_3 = L3_3.SetRadius
          L4_3 = L3_1
          L4_3 = L4_3 - 0.4
          L3_3(L4_3)
          L3_3 = L18_1
          L3_3()
          L0_3 = L2_3
        end
      end
      L3_3 = IsEditorUiHovered
      if L3_3 then
        L3_3 = IsEditorUiHovered
        L3_3 = L3_3()
      end
      L4_3 = IsDisabledControlPressed
      L5_3 = 0
      L6_3 = 24
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 and not L3_3 then
        L4_3 = GetGameTimer
        L4_3 = L4_3()
        L5_3 = L7_1
        L5_3 = L4_3 - L5_3
        L6_3 = L0_1.tickMs
        if not L6_3 then
          L6_3 = 70
        end
        if L5_3 >= L6_3 then
          L7_1 = L4_3
          L5_3 = L17_1
          L6_3 = L4_1
          L7_3 = L1_3
          L5_3(L6_3, L7_3)
        end
      else
        L4_3 = IsDisabledControlPressed
        L5_3 = 0
        L6_3 = 24
        L4_3 = L4_3(L5_3, L6_3)
        if not L4_3 then
          L4_3 = L8_1
          L4_3 = #L4_3
          if L4_3 > 0 then
            L4_3 = {}
            L8_1 = L4_3
            L4_3 = L10_1
            L5_3 = "Brush"
            L4_3(L5_3)
          end
        end
      end
      L4_3 = IsDisabledControlJustPressed
      L5_3 = 0
      L6_3 = 73
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 then
        L4_3 = Brush
        L4_3 = L4_3.Stop
        L4_3()
      end
      L4_3 = Wait
      L5_3 = 0
      L4_3(L5_3)
    end
  end
  L1_2(L2_2)
end
L19_1.Start = L20_1
L19_1 = Brush
function L20_1()
  local L0_2, L1_2
  L0_2 = L1_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L1_1 = L0_2
  L0_2 = L10_1
  L1_2 = "Brush"
  L0_2(L1_2)
  L0_2 = {}
  L8_1 = L0_2
  L0_2 = Raycast
  L0_2 = L0_2.Reset
  L1_2 = "brush"
  L0_2(L1_2)
  L0_2 = L18_1
  L0_2()
end
L19_1.Stop = L20_1
