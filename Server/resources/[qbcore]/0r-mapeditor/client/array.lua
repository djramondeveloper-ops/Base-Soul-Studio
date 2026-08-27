local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1
L0_1 = {}
Array = L0_1
L0_1 = 200
L1_1 = 1000
L2_1 = false
L3_1 = nil
L4_1 = {}
L5_1 = {}
L5_1.pattern = "linear"
L5_1.count = 3
L5_1.spacing = 2.0
L5_1.heading = 0.0
L5_1.rows = 2
L5_1.cols = 2
L5_1.spacingX = 2.0
L5_1.spacingY = 2.0
L5_1.radius = 5.0
L5_1.faceCenter = false
L6_1 = Array
function L7_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L6_1.IsActive = L7_1
function L6_1()
  local L0_2, L1_2, L2_2
  L0_2 = Bulk
  L0_2 = L0_2.IsActive
  if L0_2 then
    L0_2 = Bulk
    L0_2 = L0_2.IsActive
    L0_2 = L0_2()
    if L0_2 then
      L0_2 = Bulk
      L0_2 = L0_2.SelectedIds
      L0_2 = L0_2()
      L1_2 = #L0_2
      if L1_2 > 0 then
        return L0_2
      end
    end
  end
  L0_2 = Gizmo
  L0_2 = L0_2.Target
  if L0_2 then
    L0_2 = Gizmo
    L0_2 = L0_2.Target
    L0_2 = L0_2()
  end
  if L0_2 then
    L1_2 = {}
    L2_2 = L0_2
    L1_2[1] = L2_2
    if L1_2 then
      goto lbl_34
    end
  end
  L1_2 = {}
  ::lbl_34::
  return L1_2
end
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = math
  L0_2 = L0_2.rad
  L1_2 = L5_1.heading
  L0_2 = L0_2(L1_2)
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.sin
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  L1_2.x = L2_2
  L2_2 = math
  L2_2 = L2_2.cos
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  L1_2.y = L2_2
  L2_2 = {}
  L3_2 = L1_2.y
  L2_2.x = L3_2
  L3_2 = L1_2.x
  L3_2 = -L3_2
  L2_2.y = L3_2
  L3_2 = L2_2
  L4_2 = L1_2
  return L3_2, L4_2
end
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = L3_1.centroid
  L1_2 = {}
  L2_2 = L5_1.pattern
  if "linear" == L2_2 then
    L2_2 = L7_1
    L2_2, L3_2 = L2_2()
    L4_2 = 1
    L5_2 = math
    L5_2 = L5_2.max
    L6_2 = 0
    L7_2 = math
    L7_2 = L7_2.floor
    L8_2 = L5_1.count
    L7_2 = L7_2(L8_2)
    L7_2 = L7_2 - 1
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = 1
    for L7_2 = L4_2, L5_2, L6_2 do
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L9_2 = {}
      L10_2 = L0_2.x
      L11_2 = L3_2.x
      L12_2 = L5_1.spacing
      L11_2 = L11_2 * L12_2
      L11_2 = L11_2 * L7_2
      L10_2 = L10_2 + L11_2
      L9_2.x = L10_2
      L10_2 = L0_2.y
      L11_2 = L3_2.y
      L12_2 = L5_1.spacing
      L11_2 = L11_2 * L12_2
      L11_2 = L11_2 * L7_2
      L10_2 = L10_2 + L11_2
      L9_2.y = L10_2
      L10_2 = L0_2.z
      L9_2.z = L10_2
      L9_2.yaw = 0.0
      L1_2[L8_2] = L9_2
    end
  else
    L2_2 = L5_1.pattern
    if "grid" == L2_2 then
      L2_2 = L7_1
      L2_2, L3_2 = L2_2()
      L4_2 = 0
      L5_2 = math
      L5_2 = L5_2.floor
      L6_2 = L5_1.rows
      L5_2 = L5_2(L6_2)
      L5_2 = L5_2 - 1
      L6_2 = 1
      for L7_2 = L4_2, L5_2, L6_2 do
        L8_2 = 0
        L9_2 = math
        L9_2 = L9_2.floor
        L10_2 = L5_1.cols
        L9_2 = L9_2(L10_2)
        L9_2 = L9_2 - 1
        L10_2 = 1
        for L11_2 = L8_2, L9_2, L10_2 do
          if 0 ~= L7_2 or 0 ~= L11_2 then
            L12_2 = #L1_2
            L12_2 = L12_2 + 1
            L13_2 = {}
            L14_2 = L0_2.x
            L15_2 = L2_2.x
            L16_2 = L5_1.spacingX
            L15_2 = L15_2 * L16_2
            L15_2 = L15_2 * L11_2
            L14_2 = L14_2 + L15_2
            L15_2 = L3_2.x
            L16_2 = L5_1.spacingY
            L15_2 = L15_2 * L16_2
            L15_2 = L15_2 * L7_2
            L14_2 = L14_2 + L15_2
            L13_2.x = L14_2
            L14_2 = L0_2.y
            L15_2 = L2_2.y
            L16_2 = L5_1.spacingX
            L15_2 = L15_2 * L16_2
            L15_2 = L15_2 * L11_2
            L14_2 = L14_2 + L15_2
            L15_2 = L3_2.y
            L16_2 = L5_1.spacingY
            L15_2 = L15_2 * L16_2
            L15_2 = L15_2 * L7_2
            L14_2 = L14_2 + L15_2
            L13_2.y = L14_2
            L14_2 = L0_2.z
            L13_2.z = L14_2
            L13_2.yaw = 0.0
            L1_2[L12_2] = L13_2
          end
        end
      end
    else
      L2_2 = math
      L2_2 = L2_2.max
      L3_2 = 2
      L4_2 = math
      L4_2 = L4_2.floor
      L5_2 = L5_1.count
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2)
      L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L3_2 = 0
      L4_2 = L2_2 - 1
      L5_2 = 1
      for L6_2 = L3_2, L4_2, L5_2 do
        L7_2 = math
        L7_2 = L7_2.pi
        L7_2 = 2.0 * L7_2
        L7_2 = L7_2 / L2_2
        L7_2 = L6_2 * L7_2
        L8_2 = #L1_2
        L8_2 = L8_2 + 1
        L9_2 = {}
        L10_2 = L0_2.x
        L11_2 = math
        L11_2 = L11_2.sin
        L12_2 = L7_2
        L11_2 = L11_2(L12_2)
        L12_2 = L5_1.radius
        L11_2 = L11_2 * L12_2
        L10_2 = L10_2 + L11_2
        L9_2.x = L10_2
        L10_2 = L0_2.y
        L11_2 = math
        L11_2 = L11_2.cos
        L12_2 = L7_2
        L11_2 = L11_2(L12_2)
        L12_2 = L5_1.radius
        L11_2 = L11_2 * L12_2
        L10_2 = L10_2 + L11_2
        L9_2.y = L10_2
        L10_2 = L0_2.z
        L9_2.z = L10_2
        L10_2 = L5_1.faceCenter
        if L10_2 then
          L10_2 = math
          L10_2 = L10_2.deg
          L11_2 = L7_2
          L10_2 = L10_2(L11_2)
          if L10_2 then
            goto lbl_188
          end
        end
        L10_2 = 0.0
        ::lbl_188::
        L9_2.yaw = L10_2
        L1_2[L8_2] = L9_2
      end
    end
  end
  return L1_2
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = 1
  L1_2 = L4_1
  L1_2 = #L1_2
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = DoesEntityExist
    L5_2 = L4_1
    L5_2 = L5_2[L3_2]
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = SetEntityDrawOutline
      L5_2 = L4_1
      L5_2 = L5_2[L3_2]
      L6_2 = false
      L4_2(L5_2, L6_2)
      L4_2 = DeleteEntity
      L5_2 = L4_1
      L5_2 = L5_2[L3_2]
      L4_2(L5_2)
    end
  end
  L0_2 = {}
  L4_1 = L0_2
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L0_2 = L9_1
  L0_2()
  L0_2 = L3_1
  if not L0_2 then
    return
  end
  L0_2 = L8_1
  L0_2 = L0_2()
  L1_2 = L0_1
  L2_2 = 1
  L3_2 = #L0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    if L1_2 <= 0 then
      break
    end
    L6_2 = L0_2[L5_2]
    L7_2 = ipairs
    L8_2 = L3_1.entries
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      if L1_2 <= 0 then
        break
      end
      L13_2 = L12_2.offset
      L13_2 = L13_2.x
      L14_2 = L12_2.offset
      L14_2 = L14_2.y
      L15_2 = L6_2.yaw
      if 0.0 ~= L15_2 then
        L15_2 = math
        L15_2 = L15_2.rad
        L16_2 = L6_2.yaw
        L15_2 = L15_2(L16_2)
        L16_2 = math
        L16_2 = L16_2.cos
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        L17_2 = math
        L17_2 = L17_2.sin
        L18_2 = L15_2
        L17_2 = L17_2(L18_2)
        L18_2 = L13_2 * L16_2
        L19_2 = L14_2 * L17_2
        L18_2 = L18_2 - L19_2
        L19_2 = L13_2 * L17_2
        L20_2 = L14_2 * L16_2
        L14_2 = L19_2 + L20_2
        L13_2 = L18_2
      end
      L15_2 = Objects
      L15_2 = L15_2.SpawnGhost
      L16_2 = L12_2.snapshot
      L16_2 = L16_2.model
      L17_2 = vector3
      L18_2 = L6_2.x
      L18_2 = L18_2 + L13_2
      L19_2 = L6_2.y
      L19_2 = L19_2 + L14_2
      L20_2 = L6_2.z
      L21_2 = L12_2.offset
      L21_2 = L21_2.z
      L20_2 = L20_2 + L21_2
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      L18_2 = vector3
      L19_2 = L12_2.rot
      L19_2 = L19_2.x
      L20_2 = L12_2.rot
      L20_2 = L20_2.y
      L21_2 = L12_2.rot
      L21_2 = L21_2.z
      L22_2 = L6_2.yaw
      L21_2 = L21_2 + L22_2
      L18_2, L19_2, L20_2, L21_2, L22_2 = L18_2(L19_2, L20_2, L21_2)
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
      if 0 ~= L15_2 then
        L16_2 = L4_1
        L16_2 = #L16_2
        L17_2 = L16_2 + 1
        L16_2 = L4_1
        L16_2[L17_2] = L15_2
        L1_2 = L1_2 - 1
      end
    end
  end
end
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L3_1
  if L0_2 then
    L0_2 = L8_1
    L0_2 = L0_2()
    if L0_2 then
      goto lbl_10
    end
  end
  L0_2 = {}
  ::lbl_10::
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "array"
  L3_2 = {}
  L4_2 = L2_1
  L3_2.active = L4_2
  L4_2 = L5_1.pattern
  L3_2.pattern = L4_2
  L4_2 = L5_1.count
  L3_2.count = L4_2
  L4_2 = L5_1.spacing
  L3_2.spacing = L4_2
  L4_2 = L5_1.heading
  L3_2.heading = L4_2
  L4_2 = L5_1.rows
  L3_2.rows = L4_2
  L4_2 = L5_1.cols
  L3_2.cols = L4_2
  L4_2 = L5_1.spacingX
  L3_2.spacingX = L4_2
  L4_2 = L5_1.spacingY
  L3_2.spacingY = L4_2
  L4_2 = L5_1.radius
  L3_2.radius = L4_2
  L4_2 = L5_1.faceCenter
  L3_2.faceCenter = L4_2
  L4_2 = #L0_2
  L3_2.preview = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
end
L12_1 = Array
function L13_1(A0_2)
  local L1_2
  if "linear" == A0_2 or "radial" == A0_2 or "grid" == A0_2 then
    L5_1.pattern = A0_2
    L1_2 = L10_1
    L1_2()
    L1_2 = L11_1
    L1_2()
  end
end
L12_1.SetPattern = L13_1
L12_1 = Array
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L5_1
  L2_2 = L2_2[A0_2]
  if nil == L2_2 or nil == A1_2 then
    return
  end
  L2_2 = type
  L3_2 = L5_1
  L3_2 = L3_2[A0_2]
  L2_2 = L2_2(L3_2)
  if "boolean" == L2_2 then
    L2_2 = L5_1
    L3_2 = true == A1_2
    L2_2[A0_2] = L3_2
  else
    L2_2 = L5_1
    L3_2 = tonumber
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = L5_1
      L3_2 = L3_2[A0_2]
    end
    L2_2[A0_2] = L3_2
  end
  L2_2 = L10_1
  L2_2()
  L2_2 = L11_1
  L2_2()
end
L12_1.SetParam = L13_1
L12_1 = Array
function L13_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L6_1
  L0_2 = L0_2()
  L1_2 = #L0_2
  if 0 == L1_2 then
    L1_2 = Bridge
    L1_2 = L1_2.Notify
    L2_2 = locale
    L3_2 = "notify.select_first"
    L2_2 = L2_2(L3_2)
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    L1_2 = false
    return L1_2
  end
  L1_2 = Objects
  L1_2 = L1_2.CaptureGroup
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L3_1 = L1_2
  L1_2 = L3_1
  if not L1_2 then
    L1_2 = Bridge
    L1_2 = L1_2.Notify
    L2_2 = locale
    L3_2 = "notify.array_capture_fail"
    L2_2 = L2_2(L3_2)
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    L1_2 = false
    return L1_2
  end
  L1_2 = true
  L2_1 = L1_2
  L1_2 = L10_1
  L1_2()
  L1_2 = L11_1
  L1_2()
  L1_2 = true
  return L1_2
end
L12_1.Open = L13_1
L12_1 = Array
function L13_1()
  local L0_2, L1_2
  L0_2 = false
  L2_1 = L0_2
  L0_2 = L9_1
  L0_2()
  L0_2 = nil
  L3_1 = L0_2
  L0_2 = L11_1
  L0_2()
end
L12_1.Cancel = L13_1
L12_1 = Array
function L13_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = L2_1
  if L0_2 then
    L0_2 = L3_1
    if L0_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L0_2 = L8_1
  L0_2 = L0_2()
  L1_2 = #L0_2
  L2_2 = L3_1.entries
  L2_2 = #L2_2
  L1_2 = L1_2 * L2_2
  L2_2 = L1_1
  if L1_2 > L2_2 then
    L1_2 = Bridge
    L1_2 = L1_2.Notify
    L2_2 = locale
    L3_2 = "notify.array_too_large"
    L4_2 = L1_1
    L2_2 = L2_2(L3_2, L4_2)
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = {}
  L2_2 = 1
  L3_2 = #L0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L0_2[L5_2]
    L7_2 = Objects
    L7_2 = L7_2.PlaceGroup
    L8_2 = L3_1
    L9_2 = vector3
    L10_2 = L6_2.x
    L11_2 = L6_2.y
    L12_2 = L6_2.z
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = L6_2.yaw
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = 1
    L9_2 = #L7_2
    L10_2 = 1
    for L11_2 = L8_2, L9_2, L10_2 do
      L12_2 = #L1_2
      L12_2 = L12_2 + 1
      L13_2 = {}
      L13_2.kind = "add"
      L14_2 = Objects
      L14_2 = L14_2.Snapshot
      L15_2 = L7_2[L11_2]
      L14_2 = L14_2(L15_2)
      L13_2.snapshot = L14_2
      L13_2.label = "Place"
      L1_2[L12_2] = L13_2
    end
  end
  L2_2 = History
  if L2_2 then
    L2_2 = #L1_2
    if L2_2 > 0 then
      L2_2 = History
      L2_2 = L2_2.Push
      L3_2 = Cmd
      L3_2 = L3_2.Batch
      L4_2 = locale
      L5_2 = "hist.array"
      L4_2 = L4_2(L5_2)
      L5_2 = L1_2
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L3_2(L4_2, L5_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
  L2_2 = MELog
  if L2_2 then
    L2_2 = MELog
    L3_2 = "array"
    L4_2 = L5_1.pattern
    L5_2 = " x"
    L6_2 = #L0_2
    L4_2 = L4_2 .. L5_2 .. L6_2
    L2_2(L3_2, L4_2)
  end
  L2_2 = Bridge
  L2_2 = L2_2.Notify
  L3_2 = locale
  L4_2 = "notify.array_placed"
  L5_2 = #L1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = "success"
  L2_2(L3_2, L4_2)
  L2_2 = L10_1
  L2_2()
end
L12_1.Apply = L13_1
L12_1 = AddEventHandler
L13_1 = "onResourceStop"
function L14_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L9_1
    L1_2()
  end
end
L12_1(L13_1, L14_1)
