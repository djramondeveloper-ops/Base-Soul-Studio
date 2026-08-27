local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1
L0_1 = {}
AreaDelete = L0_1
L0_1 = false
L1_1 = 8.0
function L2_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "areadelete"
  L2_2 = {}
  L3_2 = L0_1
  L2_2.active = L3_2
  L3_2 = L1_1
  L2_2.radius = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L3_1 = AreaDelete
function L4_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L3_1.IsActive = L4_1
L3_1 = AreaDelete
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 2.0
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 60.0
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L1_1
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  L1_1 = L1_2
  L1_2 = L2_1
  L1_2()
end
L3_1.SetRadius = L4_1
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "areadelete"
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
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = L1_1
  L3_2 = L1_1
  L2_2 = L2_2 * L3_2
  L3_2 = pairs
  L4_2 = Objects
  L4_2 = L4_2.All
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2()
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.coords
    L9_2 = L9_2.x
    L10_2 = A0_2.x
    L9_2 = L9_2 - L10_2
    L10_2 = L8_2.coords
    L10_2 = L10_2.y
    L11_2 = A0_2.y
    L10_2 = L10_2 - L11_2
    L11_2 = L9_2 * L9_2
    L12_2 = L10_2 * L10_2
    L11_2 = L11_2 + L12_2
    if L2_2 >= L11_2 then
      L11_2 = #L1_2
      L11_2 = L11_2 + 1
      L1_2[L11_2] = L7_2
    end
  end
  L3_2 = #L1_2
  if L3_2 > 0 then
    L3_2 = MEDeleteBatch
    if L3_2 then
      L3_2 = MEDeleteBatch
      L4_2 = L1_2
      L5_2 = "Area Delete"
      L3_2(L4_2, L5_2)
    else
      L3_2 = 1
      L4_2 = #L1_2
      L5_2 = 1
      for L6_2 = L3_2, L4_2, L5_2 do
        L7_2 = Objects
        L7_2 = L7_2.Remove
        L8_2 = L1_2[L6_2]
        L7_2(L8_2)
      end
    end
    L3_2 = MELog
    if L3_2 then
      L3_2 = MELog
      L4_2 = "area_delete"
      L5_2 = tostring
      L6_2 = #L1_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    end
    L3_2 = Bridge
    L3_2 = L3_2.Notify
    L4_2 = locale
    L5_2 = "notify.deleted_n"
    L6_2 = #L1_2
    L4_2 = L4_2(L5_2, L6_2)
    L5_2 = "inform"
    L3_2(L4_2, L5_2)
  end
end
function L5_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3
    L0_3 = 0
    while true do
      L1_3 = L0_1
      if not L1_3 then
        break
      end
      L1_3 = L3_1
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
      L13_3 = L1_1
      L13_3 = L13_3 * 2.0
      L14_3 = L1_1
      L14_3 = L14_3 * 2.0
      L15_3 = 0.4
      L16_3 = 230
      L17_3 = 70
      L18_3 = 70
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
          L3_3 = AreaDelete
          L3_3 = L3_3.SetRadius
          L4_3 = L1_1
          L4_3 = L4_3 + 0.6
          L3_3(L4_3)
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
          L3_3 = AreaDelete
          L3_3 = L3_3.SetRadius
          L4_3 = L1_1
          L4_3 = L4_3 - 0.6
          L3_3(L4_3)
          L0_3 = L2_3
        end
      end
      L3_3 = IsDisabledControlJustPressed
      L4_3 = 0
      L5_3 = 24
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 then
        L3_3 = IsEditorUiHovered
        if L3_3 then
          L3_3 = IsEditorUiHovered
          L3_3 = L3_3()
          if L3_3 then
            goto lbl_90
          end
        end
        L3_3 = L4_1
        L4_3 = L1_3
        L3_3(L4_3)
      end
      ::lbl_90::
      L3_3 = IsDisabledControlJustPressed
      L4_3 = 0
      L5_3 = 73
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 then
        L3_3 = AreaDelete
        L3_3 = L3_3.Toggle
        L4_3 = false
        L3_3(L4_3)
      end
      L3_3 = Wait
      L4_3 = 0
      L3_3(L4_3)
    end
  end
  L0_2(L1_2)
end
L6_1 = AreaDelete
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1
  if nil == A0_2 then
    L2_2 = L0_1
    L2_2 = not L2_2
    L0_1 = L2_2
  else
    L2_2 = true == A0_2
    L0_1 = L2_2
  end
  L2_2 = L0_1
  if not L2_2 then
    L2_2 = Raycast
    L2_2 = L2_2.Reset
    L3_2 = "areadelete"
    L2_2(L3_2)
  end
  L2_2 = L2_1
  L2_2()
  L2_2 = L0_1
  if L2_2 and not L1_2 then
    L2_2 = L5_1
    L2_2()
  end
end
L6_1.Toggle = L7_1
