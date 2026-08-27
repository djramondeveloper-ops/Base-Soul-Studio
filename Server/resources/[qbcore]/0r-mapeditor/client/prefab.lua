local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1
L0_1 = {}
Prefab = L0_1
L0_1 = false
L1_1 = nil
L2_1 = {}
L3_1 = 0.0
function L4_1()
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
L5_1 = Prefab
function L6_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L5_1.IsActive = L6_1
L5_1 = Prefab
function L6_1()
  local L0_2, L1_2
  L0_2 = TriggerServerEvent
  L1_2 = "0r-mapeditor:getPrefabs"
  L0_2(L1_2)
end
L5_1.RequestList = L6_1
L5_1 = Prefab
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L4_1
  L2_2 = L2_2()
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = Bridge
    L3_2 = L3_2.Notify
    L4_2 = locale
    L5_2 = "notify.prefab_select"
    L4_2 = L4_2(L5_2)
    L5_2 = "error"
    L3_2(L4_2, L5_2)
    return
  end
  L3_2 = Objects
  L3_2 = L3_2.CaptureGroup
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = Bridge
    L4_2 = L4_2.Notify
    L5_2 = locale
    L6_2 = "notify.prefab_capture_fail"
    L5_2 = L5_2(L6_2)
    L6_2 = "error"
    L4_2(L5_2, L6_2)
    return
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2.entries
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.snapshot
    L11_2 = L11_2.props
    if not L11_2 then
      L11_2 = {}
    end
    L12_2 = L10_2.snapshot
    L12_2 = L12_2.blip
    if not L12_2 then
      L12_2 = {}
    end
    L13_2 = #L4_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L10_2.snapshot
    L15_2 = L15_2.model
    L14_2.model = L15_2
    L15_2 = L10_2.offset
    L15_2 = L15_2.x
    L14_2.ox = L15_2
    L15_2 = L10_2.offset
    L15_2 = L15_2.y
    L14_2.oy = L15_2
    L15_2 = L10_2.offset
    L15_2 = L15_2.z
    L14_2.oz = L15_2
    L15_2 = L10_2.rot
    L15_2 = L15_2.x
    L14_2.rx = L15_2
    L15_2 = L10_2.rot
    L15_2 = L15_2.y
    L14_2.ry = L15_2
    L15_2 = L10_2.rot
    L15_2 = L15_2.z
    L14_2.rz = L15_2
    L15_2 = L11_2.lod
    L14_2.lod = L15_2
    L15_2 = L11_2.alpha
    L14_2.alpha = L15_2
    L15_2 = L11_2.collision
    L15_2 = false ~= L15_2
    L14_2.collision = L15_2
    L15_2 = L11_2.frozen
    L15_2 = false ~= L15_2
    L14_2.frozen = L15_2
    L15_2 = L11_2.visible
    L15_2 = false ~= L15_2
    L14_2.visible = L15_2
    L15_2 = {}
    L16_2 = L12_2.name
    if not L16_2 then
      L16_2 = ""
    end
    L15_2.name = L16_2
    L16_2 = L12_2.color
    if not L16_2 then
      L16_2 = 0
    end
    L15_2.color = L16_2
    L16_2 = L12_2.on
    L16_2 = true == L16_2
    L15_2.on = L16_2
    L14_2.blip = L15_2
    L15_2 = L10_2.snapshot
    L15_2 = L15_2.layer
    if not L15_2 then
      L15_2 = "Default"
    end
    L14_2.layer = L15_2
    L4_2[L13_2] = L14_2
  end
  L5_2 = TriggerServerEvent
  L6_2 = "0r-mapeditor:savePrefab"
  L7_2 = {}
  L8_2 = A0_2 or L8_2
  if not A0_2 then
    L8_2 = "Prefab"
  end
  L7_2.name = L8_2
  L8_2 = A1_2 or L8_2
  if not A1_2 then
    L8_2 = "general"
  end
  L7_2.category = L8_2
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = {}
  L9_2.entries = L4_2
  L8_2 = L8_2(L9_2)
  L7_2.data = L8_2
  L5_2(L6_2, L7_2)
end
L5_1.SaveCurrent = L6_1
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = type
      L4_2 = L2_2.entries
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        goto lbl_20
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_20::
  L3_2 = {}
  L4_2 = 1
  L5_2 = L2_2.entries
  L5_2 = #L5_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L2_2.entries
    L8_2 = L8_2[L7_2]
    L9_2 = {}
    L10_2 = {}
    L11_2 = L8_2.model
    L10_2.model = L11_2
    L11_2 = {}
    L12_2 = L8_2.lod
    L11_2.lod = L12_2
    L12_2 = L8_2.alpha
    L11_2.alpha = L12_2
    L12_2 = L8_2.collision
    L12_2 = false ~= L12_2
    L11_2.collision = L12_2
    L12_2 = L8_2.frozen
    L12_2 = false ~= L12_2
    L11_2.frozen = L12_2
    L12_2 = L8_2.visible
    L12_2 = false ~= L12_2
    L11_2.visible = L12_2
    L10_2.props = L11_2
    L11_2 = L8_2.blip
    L10_2.blip = L11_2
    L11_2 = L8_2.layer
    if not L11_2 then
      L11_2 = "Default"
    end
    L10_2.layer = L11_2
    L9_2.snapshot = L10_2
    L10_2 = {}
    L11_2 = L8_2.ox
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.x = L11_2
    L11_2 = L8_2.oy
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.y = L11_2
    L11_2 = L8_2.oz
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.z = L11_2
    L9_2.offset = L10_2
    L10_2 = {}
    L11_2 = L8_2.rx
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.x = L11_2
    L11_2 = L8_2.ry
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.y = L11_2
    L11_2 = L8_2.rz
    if not L11_2 then
      L11_2 = 0.0
    end
    L10_2.z = L11_2
    L9_2.rot = L10_2
    L3_2[L7_2] = L9_2
  end
  L4_2 = {}
  L4_2.entries = L3_2
  return L4_2
end
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = 1
  L1_2 = L2_1
  L1_2 = #L1_2
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = DoesEntityExist
    L5_2 = L2_1
    L5_2 = L5_2[L3_2]
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = SetEntityDrawOutline
      L5_2 = L2_1
      L5_2 = L5_2[L3_2]
      L6_2 = false
      L4_2(L5_2, L6_2)
      L4_2 = DeleteEntity
      L5_2 = L2_1
      L5_2 = L5_2[L3_2]
      L4_2(L5_2)
    end
  end
  L0_2 = {}
  L2_1 = L0_2
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = math
  L3_2 = L3_2.rad
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = 0.0
  end
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.cos
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.sin
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = A0_2 * L4_2
  L7_2 = A1_2 * L5_2
  L6_2 = L6_2 - L7_2
  L7_2 = A0_2 * L5_2
  L8_2 = A1_2 * L4_2
  L7_2 = L7_2 + L8_2
  return L6_2, L7_2
end
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "prefab"
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 and L1_2 then
    return L1_2
  end
  L2_2 = Camera
  L2_2 = L2_2.CursorRay
  L2_2, L3_2 = L2_2()
  L4_2 = L3_2 * 10.0
  L4_2 = L2_2 + L4_2
  return L4_2
end
L9_1 = Prefab
function L10_1()
  local L0_2, L1_2, L2_2
  L0_2 = false
  L0_1 = L0_2
  L0_2 = L6_1
  L0_2()
  L0_2 = Raycast
  L0_2 = L0_2.Reset
  L1_2 = "prefab"
  L0_2(L1_2)
  L0_2 = nil
  L1_1 = L0_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "prefabPlacing"
  L2_2 = {}
  L2_2.on = false
  L1_2.data = L2_2
  L0_2(L1_2)
end
L9_1.Cancel = L10_1
L9_1 = Prefab
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = Prefab
  L1_2 = L1_2.Cancel
  L1_2()
  L1_2 = L5_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.entries
    L2_2 = #L2_2
    if 0 ~= L2_2 then
      goto lbl_21
    end
  end
  L2_2 = Bridge
  L2_2 = L2_2.Notify
  L3_2 = locale
  L4_2 = "notify.prefab_invalid"
  L3_2 = L3_2(L4_2)
  L4_2 = "error"
  L2_2(L3_2, L4_2)
  do return end
  ::lbl_21::
  L2_2 = Placement
  L2_2 = L2_2.Stop
  L2_2()
  L2_2 = Gizmo
  L2_2 = L2_2.Deselect
  L2_2()
  L2_2 = Brush
  L2_2 = L2_2.Stop
  L2_2()
  L2_2 = Fill
  L2_2 = L2_2.Toggle
  L3_2 = false
  L2_2(L3_2)
  L2_2 = Lights
  L2_2 = L2_2.Toggle
  L3_2 = false
  L2_2(L3_2)
  L2_2 = Array
  if L2_2 then
    L2_2 = Array
    L2_2 = L2_2.Cancel
    L2_2()
  end
  L1_1 = L1_2
  L2_2 = 0.0
  L3_1 = L2_2
  L2_2 = true
  L0_1 = L2_2
  L2_2 = ipairs
  L3_2 = L1_1.entries
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L2_1
    L8_2 = #L8_2
    L9_2 = L8_2 + 1
    L8_2 = L2_1
    L10_2 = Objects
    L10_2 = L10_2.SpawnGhost
    L11_2 = L7_2.snapshot
    L11_2 = L11_2.model
    L12_2 = vector3
    L13_2 = 0.0
    L14_2 = 0.0
    L15_2 = 0.0
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    L13_2 = vector3
    L14_2 = L7_2.rot
    L14_2 = L14_2.x
    L15_2 = L7_2.rot
    L15_2 = L15_2.y
    L16_2 = L7_2.rot
    L16_2 = L16_2.z
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L8_2[L9_2] = L10_2
  end
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "prefabPlacing"
  L4_2 = {}
  L4_2.on = true
  L3_2.data = L4_2
  L2_2(L3_2)
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L8_1
      L0_3 = L0_3()
      L1_3 = IsDisabledControlPressed
      L2_3 = 0
      L3_3 = 241
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = L3_1
        L1_3 = L1_3 + 3.0
        L3_1 = L1_3
      end
      L1_3 = IsDisabledControlPressed
      L2_3 = 0
      L3_3 = 242
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = L3_1
        L1_3 = L1_3 - 3.0
        L3_1 = L1_3
      end
      L1_3 = 1
      L2_3 = L1_1.entries
      L2_3 = #L2_3
      L3_3 = 1
      for L4_3 = L1_3, L2_3, L3_3 do
        L5_3 = L1_1.entries
        L5_3 = L5_3[L4_3]
        L6_3 = L2_1
        L6_3 = L6_3[L4_3]
        if L6_3 then
          L7_3 = DoesEntityExist
          L8_3 = L6_3
          L7_3 = L7_3(L8_3)
          if L7_3 then
            L7_3 = L7_1
            L8_3 = L5_3.offset
            L8_3 = L8_3.x
            L9_3 = L5_3.offset
            L9_3 = L9_3.y
            L10_3 = L3_1
            L7_3, L8_3 = L7_3(L8_3, L9_3, L10_3)
            L9_3 = SetEntityCoordsNoOffset
            L10_3 = L6_3
            L11_3 = L0_3.x
            L11_3 = L11_3 + L7_3
            L12_3 = L0_3.y
            L12_3 = L12_3 + L8_3
            L13_3 = L0_3.z
            L14_3 = L5_3.offset
            L14_3 = L14_3.z
            L13_3 = L13_3 + L14_3
            L14_3 = false
            L15_3 = false
            L16_3 = false
            L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
            L9_3 = SetEntityRotation
            L10_3 = L6_3
            L11_3 = L5_3.rot
            L11_3 = L11_3.x
            L12_3 = L5_3.rot
            L12_3 = L12_3.y
            L13_3 = L5_3.rot
            L13_3 = L13_3.z
            L14_3 = L3_1
            L13_3 = L13_3 + L14_3
            L14_3 = 2
            L15_3 = true
            L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
          end
        end
      end
      L1_3 = IsDisabledControlJustPressed
      L2_3 = 0
      L3_3 = 24
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = IsEditorUiHovered
        if L1_3 then
          L1_3 = IsEditorUiHovered
          L1_3 = L1_3()
          if L1_3 then
            goto lbl_157
          end
        end
        L1_3 = Objects
        L1_3 = L1_3.PlaceGroup
        L2_3 = L1_1
        L3_3 = L0_3
        L4_3 = L3_1
        L1_3 = L1_3(L2_3, L3_3, L4_3)
        L2_3 = History
        if L2_3 then
          L2_3 = #L1_3
          if L2_3 > 0 then
            L2_3 = {}
            L3_3 = 1
            L4_3 = #L1_3
            L5_3 = 1
            for L6_3 = L3_3, L4_3, L5_3 do
              L7_3 = #L2_3
              L7_3 = L7_3 + 1
              L8_3 = {}
              L8_3.kind = "add"
              L9_3 = Objects
              L9_3 = L9_3.Snapshot
              L10_3 = L1_3[L6_3]
              L9_3 = L9_3(L10_3)
              L8_3.snapshot = L9_3
              L8_3.label = "Place"
              L2_3[L7_3] = L8_3
            end
            L3_3 = History
            L3_3 = L3_3.Push
            L4_3 = Cmd
            L4_3 = L4_3.Batch
            L5_3 = locale
            L6_3 = "hist.prefab"
            L5_3 = L5_3(L6_3)
            L6_3 = L2_3
            L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L4_3(L5_3, L6_3)
            L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
          end
        end
        L2_3 = MELog
        if L2_3 then
          L2_3 = MELog
          L3_3 = "prefab_place"
          L4_3 = tostring
          L5_3 = #L1_3
          L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L4_3(L5_3)
          L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
        end
        L2_3 = Bridge
        L2_3 = L2_3.Notify
        L3_3 = locale
        L4_3 = "notify.prefab_placed"
        L5_3 = #L1_3
        L3_3 = L3_3(L4_3, L5_3)
        L4_3 = "success"
        L2_3(L3_3, L4_3)
        L2_3 = Prefab
        L2_3 = L2_3.Cancel
        L2_3()
        break
      end
      ::lbl_157::
      L1_3 = IsDisabledControlJustPressed
      L2_3 = 0
      L3_3 = 73
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = Prefab
        L1_3 = L1_3.Cancel
        L1_3()
        break
      end
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
  end
  L2_2(L3_2)
end
L9_1.Place = L10_1
L9_1 = RegisterNetEvent
L10_1 = "0r-mapeditor:prefabData"
function L11_1(A0_2)
  local L1_2, L2_2
  if A0_2 then
    L1_2 = A0_2.data
    if L1_2 then
      L1_2 = Prefab
      L1_2 = L1_2.Place
      L2_2 = A0_2.data
      L1_2(L2_2)
    end
  end
end
L9_1(L10_1, L11_1)
L9_1 = AddEventHandler
L10_1 = "onResourceStop"
function L11_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L6_1
    L1_2()
  end
end
L9_1(L10_1, L11_1)
