local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1
L0_1 = {}
Fill = L0_1
L0_1 = false
L1_1 = nil
L2_1 = 4.0
L3_1 = "grid"
L4_1 = "random"
L5_1 = {}
L6_1 = false
function L7_1(A0_2, A1_2, A2_2)
  return math.max(A1_2, math.min(A2_2, A0_2))
end
function L8_1()
  local L0_2, L1_2
  L0_2 = IsEditorUiHovered
  if L0_2 then
    L0_2 = IsEditorUiHovered
    L0_2 = L0_2()
  end
  return L0_2
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "fill"
  L2_2 = {}
  L3_2 = L0_1
  L2_2.active = L3_2
  L3_2 = L6_1
  L2_2.picking = L3_2
  L3_2 = L6_1
  L3_2 = not L3_2
  L2_2.ready = L3_2
  L3_2 = L5_1
  L3_2 = #L3_2
  L2_2.vcount = L3_2
  L3_2 = L2_1
  L2_2.spacing = L3_2
  L3_2 = L3_1
  L2_2.layout = L3_2
  L3_2 = L4_1
  L2_2.heading = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L10_1 = Fill
function L11_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L10_1.IsActive = L11_1
L10_1 = Fill
function L11_1(A0_2)
  local L1_2
  if A0_2 then
    L1_1 = A0_2
  end
end
L10_1.SetModel = L11_1
L10_1 = Fill
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L7_1
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L2_1
  end
  L3_2 = 0.5
  L4_2 = 30.0
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_1 = L1_2
  L1_2 = L9_1
  L1_2()
end
L10_1.SetSpacing = L11_1
L10_1 = Fill
function L11_1(A0_2)
  local L1_2
  if "random" == A0_2 then
    L1_2 = "random"
    if L1_2 then
      goto lbl_7
    end
  end
  L1_2 = "grid"
  ::lbl_7::
  L3_1 = L1_2
  L1_2 = L9_1
  L1_2()
end
L10_1.SetLayout = L11_1
L10_1 = Fill
function L11_1(A0_2)
  local L1_2
  if "fixed" == A0_2 then
    L1_2 = "fixed"
    if L1_2 then
      goto lbl_7
    end
  end
  L1_2 = "random"
  ::lbl_7::
  L4_1 = L1_2
  L1_2 = L9_1
  L1_2()
end
L10_1.SetHeading = L11_1
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "fill"
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 and L1_2 then
    return L1_2
  end
  L2_2 = Camera
  L2_2 = L2_2.CursorRay
  L2_2, L3_2 = L2_2()
  L4_2 = L3_2 * 20.0
  L4_2 = L2_2 + L4_2
  return L4_2
end
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = _ENV
  L4_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L3_2 = L3_2[L4_2]
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2 + 8.0
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2 - 80.0
  L10_2 = 1
  L11_2 = 0
  L12_2 = 4
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = GetShapeTestResult
  L5_2 = L3_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  if true == L5_2 or 1 == L5_2 then
    return L6_2
  end
  L7_2 = nil
  return L7_2
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = false
  L3_2 = L5_1
  L3_2 = #L3_2
  L4_2 = 1
  L5_2 = L5_1
  L5_2 = #L5_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L5_1
    L8_2 = L8_2[L7_2]
    L9_2 = L5_1
    L9_2 = L9_2[L3_2]
    L10_2 = L8_2.y
    L10_2 = A1_2 < L10_2
    L11_2 = L9_2.y
    L11_2 = A1_2 < L11_2
    if L10_2 ~= L11_2 then
      L10_2 = L9_2.x
      L11_2 = L8_2.x
      L10_2 = L10_2 - L11_2
      L11_2 = L8_2.y
      L11_2 = A1_2 - L11_2
      L10_2 = L10_2 * L11_2
      L11_2 = L9_2.y
      L12_2 = L8_2.y
      L11_2 = L11_2 - L12_2
      L10_2 = L10_2 / L11_2
      L11_2 = L8_2.x
      L10_2 = L10_2 + L11_2
      if A0_2 < L10_2 then
        L2_2 = not L2_2
      end
    end
    L3_2 = L7_2
  end
  return L2_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2
  L1_2 = L5_1
  L1_2 = #L1_2
  if 0 == L1_2 then
    return
  end
  function L1_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L2_3 = DrawLine
    L3_3 = A0_3.x
    L4_3 = A0_3.y
    L5_3 = A0_3.z
    L5_3 = L5_3 + 0.06
    L6_3 = A1_3.x
    L7_3 = A1_3.y
    L8_3 = A1_3.z
    L8_3 = L8_3 + 0.06
    L9_3 = 80
    L10_3 = 220
    L11_3 = 255
    L12_3 = 200
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
  end
  L2_2 = 1
  L3_2 = L5_1
  L3_2 = #L3_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L5_1
    L6_2 = L6_2[L5_2]
    L8_2 = L5_2 + 1
    L7_2 = L5_1
    L7_2 = L7_2[L8_2]
    L7_2 = A0_2 or L7_2
    if not L7_2 and (not A0_2 or not A0_2) then
      L7_2 = L5_1
      L7_2 = L7_2[1]
    end
    if L7_2 then
      L8_2 = L1_2
      L9_2 = L6_2
      L10_2 = L7_2
      L8_2(L9_2, L10_2)
    end
    L8_2 = DrawMarker
    L9_2 = 28
    L10_2 = L6_2.x
    L11_2 = L6_2.y
    L12_2 = L6_2.z
    L12_2 = L12_2 + 0.1
    L13_2 = 0.0
    L14_2 = 0.0
    L15_2 = 0.0
    L16_2 = 0.0
    L17_2 = 0.0
    L18_2 = 0.0
    L19_2 = 0.5
    L20_2 = 0.5
    L21_2 = 0.5
    L22_2 = 80
    L23_2 = 220
    L24_2 = 255
    L25_2 = 220
    L26_2 = false
    L27_2 = false
    L28_2 = 2
    L29_2 = false
    L30_2 = nil
    L31_2 = nil
    L32_2 = false
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2)
  end
  if not A0_2 then
    L2_2 = L5_1
    L2_2 = #L2_2
    if L2_2 >= 3 then
      L2_2 = L1_2
      L3_2 = L5_1
      L4_2 = #L3_2
      L3_2 = L5_1
      L3_2 = L3_2[L4_2]
      L4_2 = L5_1
      L4_2 = L4_2[1]
      L2_2(L3_2, L4_2)
    end
  end
end
L14_1 = Fill
function L15_1()
  local L0_2, L1_2
  L0_2 = {}
  L5_1 = L0_2
  L0_2 = true
  L6_1 = L0_2
  L0_2 = L9_1
  L0_2()
end
L14_1.Reselect = L15_1
L14_1 = Fill
function L15_1()
  local L0_2, L1_2
  L0_2 = L5_1
  L0_2 = #L0_2
  if L0_2 >= 3 then
    L0_2 = false
    L6_1 = L0_2
    L0_2 = L9_1
    L0_2()
  end
end
L14_1.Finish = L15_1
L14_1 = Fill
function L15_1()
  local L0_2, L1_2
  L0_2 = L5_1
  L0_2 = #L0_2
  if L0_2 > 0 then
    L0_2 = L5_1
    L1_2 = #L0_2
    L0_2 = L5_1
    L0_2[L1_2] = nil
    L0_2 = L9_1
    L0_2()
  end
end
L14_1.Undo = L15_1
function L14_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L10_1
      L0_3 = L0_3()
      L1_3 = L6_1
      if L1_3 then
        L1_3 = DrawMarker
        L2_3 = 28
        L3_3 = L0_3.x
        L4_3 = L0_3.y
        L5_3 = L0_3.z
        L5_3 = L5_3 + 0.1
        L6_3 = 0.0
        L7_3 = 0.0
        L8_3 = 0.0
        L9_3 = 0.0
        L10_3 = 0.0
        L11_3 = 0.0
        L12_3 = 0.5
        L13_3 = 0.5
        L14_3 = 0.5
        L15_3 = 255
        L16_3 = 255
        L17_3 = 255
        L18_3 = 160
        L19_3 = false
        L20_3 = false
        L21_3 = 2
        L22_3 = false
        L23_3 = nil
        L24_3 = nil
        L25_3 = false
        L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3)
        L1_3 = L13_1
        L2_3 = L0_3
        L1_3(L2_3)
        L1_3 = IsDisabledControlJustPressed
        L2_3 = 0
        L3_3 = 24
        L1_3 = L1_3(L2_3, L3_3)
        if L1_3 then
          L1_3 = L8_1
          L1_3 = L1_3()
          if not L1_3 then
            L1_3 = L5_1
            L1_3 = #L1_3
            L2_3 = L1_3 + 1
            L1_3 = L5_1
            L1_3[L2_3] = L0_3
            L1_3 = L9_1
            L1_3()
          end
        end
      else
        L1_3 = L5_1
        L1_3 = #L1_3
        if L1_3 >= 3 then
          L1_3 = L13_1
          L2_3 = nil
          L1_3(L2_3)
        end
      end
      L1_3 = IsDisabledControlJustPressed
      L2_3 = 0
      L3_3 = 73
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = Fill
        L1_3 = L1_3.Toggle
        L2_3 = false
        L1_3(L2_3)
      end
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
  end
  L0_2(L1_2)
end
L15_1 = Fill
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A1_2 then
    L1_1 = A1_2
  end
  L2_2 = L0_1
  if nil == A0_2 then
    L3_2 = L0_1
    L3_2 = not L3_2
    L0_1 = L3_2
  else
    L3_2 = true == A0_2
    L0_1 = L3_2
  end
  L3_2 = L0_1
  if L3_2 then
    L3_2 = L5_1
    L3_2 = #L3_2
    if L3_2 < 3 then
      L3_2 = {}
      L5_1 = L3_2
      L3_2 = true
      L6_1 = L3_2
    end
  else
    L3_2 = {}
    L4_2 = false
    L6_1 = L4_2
    L5_1 = L3_2
    L3_2 = Raycast
    L3_2 = L3_2.Reset
    L4_2 = "fill"
    L3_2(L4_2)
  end
  L3_2 = L9_1
  L3_2()
  L3_2 = L0_1
  if L3_2 and not L2_2 then
    L3_2 = L14_1
    L3_2()
  end
end
L15_1.Toggle = L16_1
L15_1 = Fill
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = L5_1
  L0_2 = #L0_2
  if not (L0_2 < 3) then
    L0_2 = L1_1
    if L0_2 then
      goto lbl_9
    end
  end
  do return end
  ::lbl_9::
  L0_2 = {}
  L1_2 = math
  L1_2 = L1_2.huge
  L2_2 = math
  L2_2 = L2_2.huge
  L2_2 = -L2_2
  L3_2 = math
  L3_2 = L3_2.huge
  L4_2 = math
  L4_2 = L4_2.huge
  L4_2 = -L4_2
  L5_2 = 0.0
  L6_2 = 1
  L7_2 = L5_1
  L7_2 = #L7_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = L5_1
    L10_2 = L10_2[L9_2]
    L11_2 = math
    L11_2 = L11_2.min
    L12_2 = L1_2
    L13_2 = L10_2.x
    L11_2 = L11_2(L12_2, L13_2)
    L1_2 = L11_2
    L11_2 = math
    L11_2 = L11_2.max
    L12_2 = L2_2
    L13_2 = L10_2.x
    L11_2 = L11_2(L12_2, L13_2)
    L2_2 = L11_2
    L11_2 = math
    L11_2 = L11_2.min
    L12_2 = L3_2
    L13_2 = L10_2.y
    L11_2 = L11_2(L12_2, L13_2)
    L3_2 = L11_2
    L11_2 = math
    L11_2 = L11_2.max
    L12_2 = L4_2
    L13_2 = L10_2.y
    L11_2 = L11_2(L12_2, L13_2)
    L4_2 = L11_2
    L11_2 = L10_2.z
    L5_2 = L5_2 + L11_2
  end
  L6_2 = L5_1
  L6_2 = #L6_2
  L6_2 = L5_2 / L6_2
  L7_2 = 0
  function L8_2()
    local L0_3, L1_3
    L0_3 = L4_1
    if "fixed" == L0_3 then
      L0_3 = 0.0
      if L0_3 then
        goto lbl_12
      end
    end
    L0_3 = math
    L0_3 = L0_3.random
    L0_3 = L0_3()
    L0_3 = L0_3 * 360.0
    ::lbl_12::
    return L0_3
  end
  L9_2 = L3_1
  if "grid" == L9_2 then
    L9_2 = L1_2
    while L2_2 >= L9_2 do
      L10_2 = L3_2
      while L4_2 >= L10_2 do
        L11_2 = L12_1
        L12_2 = L9_2
        L13_2 = L10_2
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L11_2 = L11_1
          L12_2 = L9_2
          L13_2 = L10_2
          L14_2 = L6_2
          L11_2 = L11_2(L12_2, L13_2, L14_2)
          if L11_2 then
L12_2 = Maps
            L12_2 = L12_2.PlaceObject
            L13_2 = L1_1
            L14_2 = L11_2
            L15_2 = vector3
            L16_2 = 0.0
            L17_2 = 0.0
            L18_2 = L8_2
            L18_2 = L18_2()
            L15_2 = L15_2(L16_2, L17_2, L18_2)
            L12_2 = L12_2(L13_2, L14_2, L15_2)
            L13_2 = MEAutoSave
            if L13_2 then
              L13_2 = MEAutoSave
              L14_2 = L12_2
              L13_2(L14_2)
            end
            if L12_2 then
              L13_2 = #L0_2
              L13_2 = L13_2 + 1
              L14_2 = Objects
              L14_2 = L14_2.UidOf
              L15_2 = L12_2
              L14_2 = L14_2(L15_2)
              L0_2[L13_2] = L14_2
              L7_2 = L7_2 + 1
            end
          end
        end
        L11_2 = L2_1
        L10_2 = L10_2 + L11_2
      end
      L11_2 = L2_1
      L9_2 = L9_2 + L11_2
    end
  else
    L9_2 = L7_1
    L10_2 = math
    L10_2 = L10_2.floor
    L11_2 = L2_2 - L1_2
    L12_2 = L4_2 - L3_2
    L11_2 = L11_2 * L12_2
    L12_2 = L2_1
    L13_2 = L2_1
    L12_2 = L12_2 * L13_2
    L11_2 = L11_2 / L12_2
    L10_2 = L10_2(L11_2)
    L11_2 = 1
    L12_2 = 5000
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = 0
    while L7_2 < L9_2 do
      L11_2 = L9_2 * 4
      if not (L10_2 < L11_2) then
        break
      end
      L10_2 = L10_2 + 1
      L11_2 = math
      L11_2 = L11_2.random
      L11_2 = L11_2()
      L12_2 = L2_2 - L1_2
      L11_2 = L11_2 * L12_2
      L11_2 = L1_2 + L11_2
      L12_2 = math
      L12_2 = L12_2.random
      L12_2 = L12_2()
      L13_2 = L4_2 - L3_2
      L12_2 = L12_2 * L13_2
      L12_2 = L3_2 + L12_2
      L13_2 = L12_1
      L14_2 = L11_2
      L15_2 = L12_2
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 then
        L13_2 = L11_1
        L14_2 = L11_2
        L15_2 = L12_2
        L16_2 = L6_2
        L13_2 = L13_2(L14_2, L15_2, L16_2)
        if L13_2 then
          L14_2 = Maps
          L14_2 = L14_2.PlaceObject
          L15_2 = L1_1
          L16_2 = L13_2
          L17_2 = vector3
          L18_2 = 0.0
          L19_2 = 0.0
          L20_2 = L8_2
          L20_2 = L20_2()
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2, L19_2, L20_2)
          L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
          L15_2 = MEAutoSave
          if L15_2 then
            L15_2 = MEAutoSave
            L16_2 = L14_2
            L15_2(L16_2)
          end
          if L14_2 then
            L15_2 = #L0_2
            L15_2 = L15_2 + 1
            L16_2 = Objects
            L16_2 = L16_2.UidOf
            L17_2 = L14_2
            L16_2 = L16_2(L17_2)
            L0_2[L15_2] = L16_2
            L7_2 = L7_2 + 1
          end
        end
      end
    end
  end
  L9_2 = History
  if L9_2 then
    L9_2 = #L0_2
    if L9_2 > 0 then
      L9_2 = {}
      L10_2 = 1
      L11_2 = #L0_2
      L12_2 = 1
      for L13_2 = L10_2, L11_2, L12_2 do
        L14_2 = Objects
        L14_2 = L14_2.IdByUid
        L15_2 = L0_2[L13_2]
        L14_2 = L14_2(L15_2)
        if L14_2 then
          L15_2 = #L9_2
          L15_2 = L15_2 + 1
          L16_2 = {}
          L16_2.kind = "add"
          L17_2 = Objects
          L17_2 = L17_2.Snapshot
          L18_2 = L14_2
          L17_2 = L17_2(L18_2)
          L16_2.snapshot = L17_2
          L16_2.label = "Place"
          L9_2[L15_2] = L16_2
        end
      end
      L10_2 = #L9_2
      if L10_2 > 0 then
        L10_2 = History
        L10_2 = L10_2.Push
        L11_2 = Cmd
        L11_2 = L11_2.Batch
        L12_2 = locale
        L13_2 = "hist.fill"
        L12_2 = L12_2(L13_2)
        L13_2 = L9_2
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2(L12_2, L13_2)
        L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      end
    end
  end
  L9_2 = MELog
  if L9_2 then
    L9_2 = MELog
    L10_2 = "fill"
    L11_2 = tostring
    L12_2 = L7_2
    L11_2 = L11_2(L12_2)
    L12_2 = " x "
    L13_2 = L1_1
    L14_2 = " ("
    L15_2 = L3_1
    L16_2 = ", "
    L17_2 = L5_1
    L17_2 = #L17_2
    L18_2 = "-gon)"
    L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
    L9_2(L10_2, L11_2)
  end
end
L15_1.DoFill = L16_1
