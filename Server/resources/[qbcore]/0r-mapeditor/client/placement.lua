local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1
L0_1 = {}
Placement = L0_1
L0_1 = false
L1_1 = 0
L2_1 = 0
L3_1 = nil
L4_1 = 0.0
L5_1 = 0.0
L6_1 = false
L7_1 = nil
L8_1 = false
L9_1 = vector3
L10_1 = 0.0
L11_1 = 0.0
L12_1 = 0.0
L9_1 = L9_1(L10_1, L11_1, L12_1)
L10_1 = vector3
L11_1 = 0.0
L12_1 = 0.0
L13_1 = 1.0
L10_1 = L10_1(L11_1, L12_1, L13_1)
L11_1 = Placement
function L12_1(A0_2)
  local L1_2
  L1_2 = true == A0_2
  L8_1 = L1_2
end
L11_1.SetMultiplace = L12_1
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "placement"
  L2_2 = L1_1
  L0_2, L1_2, L2_2 = L0_2(L1_2, L2_2)
  if L0_2 and L1_2 then
    L3_2 = L1_2
    L4_2 = L2_2 or L4_2
    if not L2_2 then
      L4_2 = vector3
      L5_2 = 0.0
      L6_2 = 0.0
      L7_2 = 1.0
      L4_2 = L4_2(L5_2, L6_2, L7_2)
    end
    return L3_2, L4_2
  end
  L3_2 = Camera
  L3_2 = L3_2.CursorRay
  L3_2, L4_2 = L3_2()
  L5_2 = L4_2 * 10.0
  L5_2 = L3_2 + L5_2
  L6_2 = vector3
  L7_2 = 0.0
  L8_2 = 0.0
  L9_2 = 1.0
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
  return L5_2, L6_2, L7_2, L8_2, L9_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = A0_2
  L2_2 = Config
  L2_2 = L2_2.snap
  L2_2 = L2_2.grid
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.snap
    L2_2 = L2_2.gridSize
    L3_2 = vector3
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L1_2.x
    L5_2 = L5_2 / L2_2
    L5_2 = L5_2 + 0.5
    L4_2 = L4_2(L5_2)
    L4_2 = L4_2 * L2_2
    L5_2 = math
    L5_2 = L5_2.floor
    L6_2 = L1_2.y
    L6_2 = L6_2 / L2_2
    L6_2 = L6_2 + 0.5
    L5_2 = L5_2(L6_2)
    L5_2 = L5_2 * L2_2
    L6_2 = L1_2.z
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L1_2 = L3_2
  end
  L2_2 = Config
  L2_2 = L2_2.snap
  L2_2 = L2_2.snap
  if L2_2 then
    L2_2 = Objects
    L2_2 = L2_2.SnapToNearby
    L3_2 = L1_2
    L4_2 = nil
    L2_2 = L2_2(L3_2, L4_2)
    L1_2 = L2_2
  end
  return L1_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = Config
  L1_2 = L1_2.snap
  L1_2 = L1_2.angle
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.snap
    L1_2 = L1_2.angleStep
    L2_2 = math
    L2_2 = L2_2.floor
    L3_2 = A0_2 / L1_2
    L3_2 = L3_2 + 0.5
    L2_2 = L2_2(L3_2)
    L2_2 = L2_2 * L1_2
    return L2_2
  end
  return A0_2
end
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  function L0_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = Camera
    L0_3 = L0_3.CursorRay
    L0_3, L1_3 = L0_3()
    L2_3 = Config
    L2_3 = L2_3.placement
    L2_3 = L2_3.maxRayDistance
    L2_3 = L1_3 * L2_3
    L2_3 = L0_3 + L2_3
    L3_3 = _ENV
    L4_3 = "StartExpensiveSynchronousShapeTestLosProbe"
    L3_3 = L3_3[L4_3]
    L4_3 = L0_3.x
    L5_3 = L0_3.y
    L6_3 = L0_3.z
    L7_3 = L2_3.x
    L8_3 = L2_3.y
    L9_3 = L2_3.z
    L10_3 = -1
    L11_3 = L1_1
    L12_3 = 4
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    L4_3 = GetShapeTestResult
    L5_3 = L3_3
    L4_3, L5_3, L6_3 = L4_3(L5_3)
    L7_3 = true == L5_3 or 1 == L5_3
    L8_3 = L6_3
    return L7_3, L8_3
  end
  L1_2 = L0_2
  L1_2, L2_2 = L1_2()
  if not L1_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = RequestCollisionAtCoord
  L4_2 = L2_2.x
  L5_2 = L2_2.y
  L6_2 = L2_2.z
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = 1
  L4_2 = 5
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = Wait
    L8_2 = 0
    L7_2(L8_2)
    L7_2 = L0_1
    if not L7_2 then
      L7_2 = nil
      return L7_2
    end
    L7_2 = L0_2
    L7_2, L8_2 = L7_2()
    if L7_2 then
      L9_2 = L8_2 - L2_2
      L9_2 = #L9_2
      L10_2 = 0.01
      if L9_2 < L10_2 then
        L2_2 = L8_2
        break
      end
      L2_2 = L8_2
      L9_2 = RequestCollisionAtCoord
      L10_2 = L2_2.x
      L11_2 = L2_2.y
      L12_2 = L2_2.z
      L9_2(L10_2, L11_2, L12_2)
    end
  end
  L3_2 = L12_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = vector3
  L5_2 = L3_2.x
  L6_2 = L3_2.y
  L7_2 = L3_2.z
  L8_2 = L5_1
  L7_2 = L7_2 + L8_2
  return L4_2(L5_2, L6_2, L7_2)
end
L15_1 = Placement
function L16_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L15_1.IsActive = L16_1
L15_1 = Placement
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    return
  end
  L3_1 = A0_2
  L1_2 = 0.0
  L4_1 = L1_2
  L1_2 = L1_1
  if 0 ~= L1_2 then
    L1_2 = DoesEntityExist
    L2_2 = L1_1
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = SetEntityDrawOutline
      L2_2 = L1_1
      L3_2 = false
      L1_2(L2_2, L3_2)
      L1_2 = DeleteEntity
      L2_2 = L1_1
      L1_2(L2_2)
      L1_2 = 0
      L1_1 = L1_2
    end
  end
  L1_2 = Camera
  L1_2 = L1_2.CursorRay
  L1_2, L2_2 = L1_2()
  L3_2 = L2_2 * 8.0
  L3_2 = L1_2 + L3_2
  L4_2 = L12_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L9_1 = L4_2
  L4_2 = vector3
  L5_2 = 0.0
  L6_2 = 0.0
  L7_2 = 1.0
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L10_1 = L4_2
  L4_2 = L0_1
  if L4_2 then
    return
  end
  L4_2 = 0.0
  L5_1 = L4_2
  L4_2 = true
  L0_1 = L4_2
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = IsEditorUiHovered
      if L0_3 then
        L0_3 = IsEditorUiHovered
        L0_3 = L0_3()
        if L0_3 then
          goto lbl_18
        end
      end
      L0_3 = L11_1
      L0_3, L1_3 = L0_3()
      L2_3 = L12_1
      L3_3 = L0_3
      L2_3 = L2_3(L3_3)
      L9_1 = L2_3
      L10_1 = L1_3
      ::lbl_18::
      L0_3 = IsDisabledControlPressed
      L1_3 = 0
      L2_3 = 21
      L0_3 = L0_3(L1_3, L2_3)
      if L0_3 then
        L1_3 = 0.12
        if L1_3 then
          goto lbl_28
        end
      end
      L1_3 = 0.04
      ::lbl_28::
      L2_3 = IsDisabledControlPressed
      L3_3 = 0
      L4_3 = 38
      L2_3 = L2_3(L3_3, L4_3)
      if L2_3 then
        L2_3 = L5_1
        L2_3 = L2_3 + L1_3
        L5_1 = L2_3
      end
      L2_3 = IsDisabledControlPressed
      L3_3 = 0
      L4_3 = 44
      L2_3 = L2_3(L3_3, L4_3)
      if L2_3 then
        L2_3 = L5_1
        L2_3 = L2_3 - L1_3
        L5_1 = L2_3
      end
      L2_3 = vector3
      L3_3 = L9_1.x
      L4_3 = L9_1.y
      L5_3 = L9_1.z
      L6_3 = L5_1
      L5_3 = L5_3 + L6_3
      L2_3 = L2_3(L3_3, L4_3, L5_3)
      L3_3 = 0.0
      L4_3 = 0.0
      L5_3 = IsDisabledControlPressed
      L6_3 = 0
      L7_3 = 19
      L5_3 = L5_3(L6_3, L7_3)
      if L5_3 then
        L5_3 = L10_1
        if L5_3 then
L5_3 = math
          L5_3 = L5_3.deg
          L6_3 = math
          L6_3 = L6_3.atan
          L7_3 = L10_1.y
          L8_3 = L10_1.z
          L6_3 = L6_3(L7_3, L8_3)
          L5_3 = L5_3(L6_3)
          L3_3 = L5_3
          L5_3 = math
          L5_3 = L5_3.deg
          L6_3 = math
          L6_3 = L6_3.atan
          L7_3 = L10_1.x
          L8_3 = L10_1.z
          L6_3 = L6_3(L7_3, L8_3)
          L6_3 = -L6_3
          L5_3 = L5_3(L6_3)
          L4_3 = L5_3
        end
      end
L5_3 = vector3
      L6_3 = L3_3
      L7_3 = L4_3
      L8_3 = L13_1
      L9_3 = L4_1
      L8_3 = L8_3(L9_3)
      L5_3 = L5_3(L6_3, L7_3, L8_3)
      L6_3 = L1_1
      if 0 ~= L6_3 then
        L6_3 = DoesEntityExist
        L7_3 = L1_1
        L6_3 = L6_3(L7_3)
        if L6_3 then
          L6_3 = GetEntityModel
          L7_3 = L1_1
          L6_3 = L6_3(L7_3)
          L7_3 = joaat
          L8_3 = L3_1
          L7_3 = L7_3(L8_3)
          if L6_3 ~= L7_3 then
            L6_3 = SetEntityDrawOutline
            L7_3 = L1_1
            L8_3 = false
            L6_3(L7_3, L8_3)
            L6_3 = DeleteEntity
            L7_3 = L1_1
            L6_3(L7_3)
            L6_3 = 0
            L1_1 = L6_3
          end
        end
      end
      L6_3 = L1_1
      if 0 ~= L6_3 then
        L6_3 = DoesEntityExist
        L7_3 = L1_1
        L6_3 = L6_3(L7_3)
        if L6_3 then
          goto lbl_136
        end
      end
      L6_3 = Objects
      L6_3 = L6_3.SpawnGhost
      L7_3 = L3_1
      L8_3 = L2_3
      L9_3 = L5_3
      L6_3 = L6_3(L7_3, L8_3, L9_3)
      L1_1 = L6_3
      L6_3 = 0
      L2_1 = L6_3
      goto lbl_154
      ::lbl_136::
      L6_3 = SetEntityCoords
      L7_3 = L1_1
      L8_3 = L2_3.x
      L9_3 = L2_3.y
      L10_3 = L2_3.z
      L11_3 = false
      L12_3 = false
      L13_3 = false
      L14_3 = false
      L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
      L6_3 = SetEntityRotation
      L7_3 = L1_1
      L8_3 = L5_3.x
      L9_3 = L5_3.y
      L10_3 = L5_3.z
      L11_3 = 2
      L12_3 = true
      L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
      ::lbl_154::
      L6_3 = GetGameTimer
      L6_3 = L6_3()
      L7_3 = L2_1
      L7_3 = L6_3 - L7_3
      L8_3 = 400
      if L7_3 > L8_3 then
        L2_1 = L6_3
        L7_3 = Objects
        L7_3 = L7_3.AssignRoomHandle
        L8_3 = L1_1
        L9_3 = L2_3.x
        L10_3 = L2_3.y
        L11_3 = L2_3.z
        L7_3(L8_3, L9_3, L10_3, L11_3)
      end
      L7_3 = L5_1
      if 0.0 ~= L7_3 then
        L7_3 = Camera
        L7_3 = L7_3.GetCoords
        L7_3 = L7_3()
        L8_3 = Camera
        L8_3 = L8_3.GetForward
        L8_3 = L8_3()
        L9_3 = Camera
        L9_3 = L9_3.GetFov
        L9_3 = L9_3()
        L10_3 = "%.2f|%.2f|%.2f|%.2f|%.1f|%.1f|%.1f|%.3f|%.3f|%.3f|%.1f"
        L11_3 = L10_3
        L10_3 = L10_3.format
        L12_3 = L2_3.x
        L13_3 = L2_3.y
        L14_3 = L9_1.z
        L15_3 = L2_3.z
        L16_3 = L7_3.x
        L17_3 = L7_3.y
        L18_3 = L7_3.z
        L19_3 = L8_3.x
        L20_3 = L8_3.y
        L21_3 = L8_3.z
        L22_3 = L9_3
        L10_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3)
        L11_3 = L7_1
        if L10_3 ~= L11_3 then
          L7_1 = L10_3
          L11_3 = SendNUIMessage
          L12_3 = {}
          L12_3.action = "placeLine"
          L13_3 = {}
          L13_3.on = true
          L14_3 = {}
          L15_3 = L7_3.x
          L14_3.x = L15_3
          L15_3 = L7_3.y
          L14_3.y = L15_3
          L15_3 = L7_3.z
          L14_3.z = L15_3
          L15_3 = L8_3.x
          L14_3.fx = L15_3
          L15_3 = L8_3.y
          L14_3.fy = L15_3
          L15_3 = L8_3.z
          L14_3.fz = L15_3
          L14_3.fov = L9_3
          L13_3.cam = L14_3
          L14_3 = {}
          L15_3 = L2_3.x
          L14_3.x = L15_3
          L15_3 = L2_3.y
          L14_3.y = L15_3
          L15_3 = L9_1.z
          L14_3.z = L15_3
          L13_3.a = L14_3
          L14_3 = {}
          L15_3 = L2_3.x
          L14_3.x = L15_3
          L15_3 = L2_3.y
          L14_3.y = L15_3
          L15_3 = L2_3.z
          L14_3.z = L15_3
          L13_3.b = L14_3
          L12_3.data = L13_3
          L11_3(L12_3)
        end
        L11_3 = true
        L6_1 = L11_3
      else
        L7_3 = L6_1
        if L7_3 then
          L7_3 = false
          L6_1 = L7_3
          L7_3 = nil
          L7_1 = L7_3
          L7_3 = SendNUIMessage
          L8_3 = {}
          L8_3.action = "placeLine"
          L9_3 = {}
          L9_3.on = false
          L8_3.data = L9_3
          L7_3(L8_3)
        end
      end
      L7_3 = IsDisabledControlPressed
      L8_3 = 0
      L9_3 = 241
      L7_3 = L7_3(L8_3, L9_3)
      if L7_3 then
        L7_3 = L4_1
        L7_3 = L7_3 + 3.0
        L4_1 = L7_3
      end
      L7_3 = IsDisabledControlPressed
      L8_3 = 0
      L9_3 = 242
      L7_3 = L7_3(L8_3, L9_3)
      if L7_3 then
        L7_3 = L4_1
        L7_3 = L7_3 - 3.0
        L4_1 = L7_3
      end
      L7_3 = IsDisabledControlJustPressed
      L8_3 = 0
      L9_3 = 24
      L7_3 = L7_3(L8_3, L9_3)
      if L7_3 then
        L7_3 = IsEditorUiHovered
        if L7_3 then
          L7_3 = IsEditorUiHovered
          L7_3 = L7_3()
          if L7_3 then
            goto lbl_343
          end
        end
        L7_3 = L14_1
        L7_3 = L7_3()
        L8_3 = L0_1
        if not L8_3 then
          break
        end
        if not L7_3 then
          L7_3 = L2_3
        end
        L8_3 = Maps
        L8_3 = L8_3.PlaceObject
        L9_3 = L3_1
        L10_3 = L7_3
        L11_3 = L5_3
        L8_3 = L8_3(L9_3, L10_3, L11_3)
        L9_3 = MELog
        if L9_3 then
          L9_3 = MELog
          L10_3 = "place"
          L11_3 = L3_1
          L9_3(L10_3, L11_3)
        end
        L9_3 = MEAutoSave
        if L9_3 then
          L9_3 = MEAutoSave
          L10_3 = L8_3
          L9_3(L10_3)
        end
        if L8_3 then
          L9_3 = History
          if L9_3 then
            L9_3 = History
            L9_3 = L9_3.Push
            L10_3 = Cmd
            L10_3 = L10_3.Add
            L11_3 = Objects
            L11_3 = L11_3.UidOf
            L12_3 = L8_3
            L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3 = L11_3(L12_3)
            L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3)
            L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3)
          end
        end
        L9_3 = L8_1
        if not L9_3 then
          L9_3 = Placement
          L9_3 = L9_3.Stop
          L9_3()
        end
      end
      ::lbl_343::
      L7_3 = IsDisabledControlJustPressed
      L8_3 = 0
      L9_3 = 73
      L7_3 = L7_3(L8_3, L9_3)
      if L7_3 then
        L7_3 = Placement
        L7_3 = L7_3.Stop
        L7_3()
      end
      L7_3 = Wait
      L8_3 = 0
      L7_3(L8_3)
    end
  end
  L4_2(L5_2)
end
L15_1.Start = L16_1
L15_1 = Placement
function L16_1()
  local L0_2, L1_2, L2_2
  L0_2 = false
  L0_1 = L0_2
  L0_2 = Raycast
  L0_2 = L0_2.Reset
  L1_2 = "placement"
  L0_2(L1_2)
  L0_2 = L1_1
  if 0 ~= L0_2 then
    L0_2 = DoesEntityExist
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = SetEntityDrawOutline
      L1_2 = L1_1
      L2_2 = false
      L0_2(L1_2, L2_2)
      L0_2 = DeleteEntity
      L1_2 = L1_1
      L0_2(L1_2)
    end
  end
  L0_2 = 0
  L1_1 = L0_2
  L0_2 = L6_1
  if L0_2 then
    L0_2 = false
    L6_1 = L0_2
    L0_2 = nil
    L7_1 = L0_2
    L0_2 = SendNUIMessage
    L1_2 = {}
    L1_2.action = "placeLine"
    L2_2 = {}
    L2_2.on = false
    L1_2.data = L2_2
    L0_2(L1_2)
  end
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "stopBuild"
  L0_2(L1_2)
end
L15_1.Stop = L16_1
