local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1
L0_1 = {}
Bulk = L0_1
L0_1 = false
L1_1 = {}
L2_1 = 0
L3_1 = false
L4_1 = 0.0
L5_1 = nil
L6_1 = {}
function L7_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "bulk"
  L2_2 = {}
  L3_2 = L0_1
  L2_2.active = L3_2
  L3_2 = L2_1
  L2_2.count = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
  L0_2 = Align
  if L0_2 then
    L0_2 = Align
    L0_2 = L0_2.OnBulkChanged
    if L0_2 then
      L0_2 = Align
      L0_2 = L0_2.OnBulkChanged
      L0_2()
    end
  end
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = Objects
  L2_2 = L2_2.Get
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = DoesEntityExist
    L4_2 = L2_2.handle
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  if A1_2 then
    L3_2 = SetEntityDrawOutlineShader
    L4_2 = 1
    L3_2(L4_2)
    L3_2 = SetEntityDrawOutlineColor
    L4_2 = 255
    L5_2 = 196
    L6_2 = 64
    L7_2 = 255
    L3_2(L4_2, L5_2, L6_2, L7_2)
    L3_2 = SetEntityDrawOutline
    L4_2 = L2_2.handle
    L5_2 = true
    L3_2(L4_2, L5_2)
  else
    L3_2 = SetEntityDrawOutline
    L4_2 = L2_2.handle
    L5_2 = false
    L3_2(L4_2, L5_2)
  end
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = A0_2.coords
  L2_2 = vector3
  L3_2 = 0.0
  L4_2 = 0.0
  L5_2 = 3.0
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L1_2 + L2_2
  L2_2 = A0_2.coords
  L3_2 = vector3
  L4_2 = 0.0
  L5_2 = 0.0
  L6_2 = 100.0
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L2_2 - L3_2
  L3_2 = _ENV
  L4_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L3_2 = L3_2[L4_2]
  L4_2 = L1_2.x
  L5_2 = L1_2.y
  L6_2 = L1_2.z
  L7_2 = L2_2.x
  L8_2 = L2_2.y
  L9_2 = L2_2.z
  L10_2 = 1
  L11_2 = A0_2.handle
  L12_2 = 4
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = GetShapeTestResult
  L5_2 = L3_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  if true == L5_2 or 1 == L5_2 then
    L7_2 = L6_2.z
    return L7_2
  end
  L7_2 = A0_2.coords
  L7_2 = L7_2.z
  return L7_2
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = Camera
  L0_2 = L0_2.CursorRay
  L0_2, L1_2 = L0_2()
  L2_2 = Config
  L2_2 = L2_2.placement
  L2_2 = L2_2.maxRayDistance
  L2_2 = L1_2 * L2_2
  L2_2 = L0_2 + L2_2
  L3_2 = _ENV
  L4_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L3_2 = L3_2[L4_2]
  L4_2 = L0_2.x
  L5_2 = L0_2.y
  L6_2 = L0_2.z
  L7_2 = L2_2.x
  L8_2 = L2_2.y
  L9_2 = L2_2.z
  L10_2 = -1
  L11_2 = 0
  L12_2 = 4
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = GetShapeTestResult
  L5_2 = L3_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  if true == L5_2 or 1 == L5_2 then
    return L6_2
  end
  L7_2 = L1_2 * 10.0
  L7_2 = L0_2 + L7_2
  return L7_2
end
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L11_1.IsActive = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2
  L0_2 = L3_1
  return L0_2
end
L11_1.IsGrabbing = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L11_1.Count = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = #L0_2
    L6_2 = L6_2 + 1
    L0_2[L6_2] = L5_2
  end
  return L0_2
end
L11_1.SelectedIds = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = pairs
  L1_2 = L1_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2 in L0_2, L1_2, L2_2, L3_2 do
    L5_2 = L8_1
    L6_2 = L4_2
    L7_2 = false
    L5_2(L6_2, L7_2)
  end
  L0_2 = {}
  L1_1 = L0_2
  L0_2 = 0
  L2_1 = L0_2
  L0_2 = false
  L3_1 = L0_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "bulkGrab"
  L2_2 = {}
  L2_2.on = false
  L1_2.data = L2_2
  L0_2(L1_2)
  L0_2 = L7_1
  L0_2()
end
L11_1.Clear = L12_1
L11_1 = Bulk
function L12_1(A0_2)
  local L1_2
  if nil == A0_2 then
    L1_2 = L0_1
    L1_2 = not L1_2
    L0_1 = L1_2
  else
    L1_2 = true == A0_2
    L0_1 = L1_2
  end
  L1_2 = L0_1
  if not L1_2 then
    L1_2 = Bulk
    L1_2 = L1_2.Clear
    L1_2()
  end
  L1_2 = L7_1
  L1_2()
  L1_2 = L0_1
  return L1_2
end
L11_1.Toggle = L12_1
L11_1 = Bulk
function L12_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = L1_1
    L1_2[A0_2] = nil
    L1_2 = L2_1
    L1_2 = L1_2 - 1
    L2_1 = L1_2
    L1_2 = L8_1
    L2_2 = A0_2
    L3_2 = false
    L1_2(L2_2, L3_2)
  else
    L1_2 = L1_1
    L1_2[A0_2] = true
    L1_2 = L2_1
    L1_2 = L1_2 + 1
    L2_1 = L1_2
    L1_2 = L8_1
    L2_2 = A0_2
    L3_2 = true
    L1_2(L2_2, L3_2)
  end
  L1_2 = L7_1
  L1_2()
end
L11_1.ToggleId = L12_1
L11_1 = Bulk
function L12_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = L1_1
    L1_2 = L1_2[A0_2]
    if not L1_2 then
      L1_2 = L1_1
      L1_2[A0_2] = true
      L1_2 = L2_1
      L1_2 = L1_2 + 1
      L2_1 = L1_2
      L1_2 = L8_1
      L2_2 = A0_2
      L3_2 = true
      L1_2(L2_2, L3_2)
    end
  end
end
L11_1.AddId = L12_1
L11_1 = Bulk
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = pairs
  L5_2 = Objects
  L5_2 = L5_2.All
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L5_2()
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = World3dToScreen2d
    L11_2 = L9_2.coords
    L11_2 = L11_2.x
    L12_2 = L9_2.coords
    L12_2 = L12_2.y
    L13_2 = L9_2.coords
    L13_2 = L13_2.z
    L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2, L13_2)
    if L10_2 and A0_2 <= L11_2 and A2_2 >= L11_2 and A1_2 <= L12_2 and A3_2 >= L12_2 then
      L13_2 = Bulk
      L13_2 = L13_2.AddId
      L14_2 = L8_2
      L13_2(L14_2)
    end
  end
  L4_2 = L7_1
  L4_2()
end
L11_1.SelectBox = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = #L0_2
    L6_2 = L6_2 + 1
    L0_2[L6_2] = L5_2
  end
  L1_2 = MEDeleteBatch
  if L1_2 then
    L1_2 = MEDeleteBatch
    L2_2 = L0_2
    L3_2 = "Bulk Delete"
    L1_2(L2_2, L3_2)
  else
    L1_2 = 1
    L2_2 = #L0_2
    L3_2 = 1
    for L4_2 = L1_2, L2_2, L3_2 do
      L5_2 = Objects
      L5_2 = L5_2.Remove
      L6_2 = L0_2[L4_2]
      L5_2(L6_2)
    end
  end
  L1_2 = {}
  L1_1 = L1_2
  L1_2 = 0
  L2_1 = L1_2
  L1_2 = false
  L3_1 = L1_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "bulkGrab"
  L3_2 = {}
  L3_2.on = false
  L2_2.data = L3_2
  L1_2(L2_2)
  L1_2 = L7_1
  L1_2()
end
L11_1.DeleteAll = L12_1
L11_1 = Bulk
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = Objects
    L6_2 = L6_2.Get
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = {}
      L8_2 = {}
      L9_2 = L6_2.coords
      L9_2 = L9_2.x
      L8_2.x = L9_2
      L9_2 = L6_2.coords
      L9_2 = L9_2.y
      L8_2.y = L9_2
      L9_2 = L6_2.coords
      L9_2 = L9_2.z
      L8_2.z = L9_2
      L7_2.coords = L8_2
      L8_2 = {}
      L9_2 = L6_2.rot
      L9_2 = L9_2.x
      L8_2.x = L9_2
      L9_2 = L6_2.rot
      L9_2 = L9_2.y
      L8_2.y = L9_2
      L9_2 = L6_2.rot
      L9_2 = L9_2.z
      L8_2.z = L9_2
      L7_2.rot = L8_2
      L8_2 = L9_1
      L9_2 = L6_2
      L8_2 = L8_2(L9_2)
      L9_2 = Objects
      L9_2 = L9_2.Update
      L10_2 = L5_2
      L11_2 = vector3
      L12_2 = L6_2.coords
      L12_2 = L12_2.x
      L13_2 = L6_2.coords
      L13_2 = L13_2.y
      L14_2 = L8_2
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      L12_2 = L6_2.rot
      L9_2(L10_2, L11_2, L12_2)
      L9_2 = MEAutoSave
      if L9_2 then
        L9_2 = MEAutoSave
        L10_2 = L5_2
        L9_2(L10_2)
      end
      L9_2 = Objects
      L9_2 = L9_2.Get
      L10_2 = L5_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        L10_2 = #L0_2
        L10_2 = L10_2 + 1
        L11_2 = Cmd
        L11_2 = L11_2.Transform
        L12_2 = Objects
        L12_2 = L12_2.UidOf
        L13_2 = L5_2
        L12_2 = L12_2(L13_2)
        L13_2 = L7_2
        L14_2 = {}
        L15_2 = {}
        L16_2 = L9_2.coords
        L16_2 = L16_2.x
        L15_2.x = L16_2
        L16_2 = L9_2.coords
        L16_2 = L16_2.y
        L15_2.y = L16_2
        L16_2 = L9_2.coords
        L16_2 = L16_2.z
        L15_2.z = L16_2
        L14_2.coords = L15_2
        L15_2 = {}
        L16_2 = L9_2.rot
        L16_2 = L16_2.x
        L15_2.x = L16_2
        L16_2 = L9_2.rot
        L16_2 = L16_2.y
        L15_2.y = L16_2
        L16_2 = L9_2.rot
        L16_2 = L16_2.z
        L15_2.z = L16_2
        L14_2.rot = L15_2
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L0_2[L10_2] = L11_2
      end
    end
  end
  L1_2 = History
  if L1_2 then
    L1_2 = #L0_2
    if L1_2 > 0 then
      L1_2 = History
      L1_2 = L1_2.Push
      L2_2 = Cmd
      L2_2 = L2_2.Batch
      L3_2 = locale
      L4_2 = "hist.ground_selection"
      L3_2 = L3_2(L4_2)
      L4_2 = L0_2
      L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L2_2(L3_2, L4_2)
      L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    end
  end
end
L11_1.GroundAll = L12_1
L11_1 = Bulk
function L12_1(A0_2)
  local L1_2
  L1_2 = L3_1
  if L1_2 then
    L1_2 = L4_1
    L1_2 = L1_2 + A0_2
    L4_1 = L1_2
  end
end
L11_1.AdjustHeight = L12_1
function L11_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3
    while true do
      L0_3 = L3_1
      if not L0_3 then
        break
      end
      L0_3 = L2_1
      if not (L0_3 > 0) then
        break
      end
      L0_3 = Raycast
      L0_3 = L0_3.Cursor
      L1_3 = "bulkGrab"
      L0_3, L1_3 = L0_3(L1_3)
      if not L0_3 or not L1_3 then
        L2_3 = L10_1
        L2_3 = L2_3()
        L1_3 = L2_3
      end
      L2_3 = L1_3.x
      L3_3 = L5_1.x
      L2_3 = L2_3 - L3_3
      L3_3 = L1_3.y
      L4_3 = L5_1.y
      L3_3 = L3_3 - L4_3
      L4_3 = pairs
      L5_3 = L1_1
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3 in L4_3, L5_3, L6_3, L7_3 do
        L9_3 = L6_1
        L9_3 = L9_3[L8_3]
        L10_3 = Objects
        L10_3 = L10_3.Get
        L11_3 = L8_3
        L10_3 = L10_3(L11_3)
        if L9_3 and L10_3 then
          L11_3 = Objects
          L11_3 = L11_3.Update
          L12_3 = L8_3
          L13_3 = vector3
          L14_3 = L9_3.x
          L14_3 = L14_3 + L2_3
          L15_3 = L9_3.y
          L15_3 = L15_3 + L3_3
          L16_3 = L9_3.z
          L17_3 = L4_1
          L16_3 = L16_3 + L17_3
          L13_3 = L13_3(L14_3, L15_3, L16_3)
          L14_3 = L10_3.rot
          L11_3(L12_3, L13_3, L14_3)
        end
      end
      L4_3 = IsDisabledControlJustPressed
      L5_3 = 0
      L6_3 = 24
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 then
        L4_3 = IsEditorUiHovered
        if L4_3 then
          L4_3 = IsEditorUiHovered
          L4_3 = L4_3()
          if L4_3 then
            goto lbl_76
          end
        end
        L4_3 = Bulk
        L4_3 = L4_3.GrabToggle
        L4_3()
      end
      ::lbl_76::
      L4_3 = Wait
      L5_3 = 0
      L4_3(L5_3)
    end
    L0_3 = Raycast
    L0_3 = L0_3.Reset
    L1_3 = "bulkGrab"
    L0_3(L1_3)
  end
  L0_2(L1_2)
end
L12_1 = Bulk
function L13_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = L2_1
  if 0 == L0_2 then
    return
  end
  L0_2 = L3_1
  L1_2 = L3_1
  L1_2 = not L1_2
  L3_1 = L1_2
  L1_2 = L3_1
  if L1_2 then
    L1_2 = 0.0
    L4_1 = L1_2
    L1_2 = L10_1
    L1_2 = L1_2()
    L5_1 = L1_2
    L1_2 = {}
    L6_1 = L1_2
    L1_2 = pairs
    L2_2 = L1_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2 in L1_2, L2_2, L3_2, L4_2 do
      L6_2 = Objects
      L6_2 = L6_2.Get
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if L6_2 then
        L7_2 = L6_1
        L8_2 = L6_2.coords
        L7_2[L5_2] = L8_2
      end
    end
  else
    L1_2 = {}
    L2_2 = pairs
    L3_2 = L1_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2 in L2_2, L3_2, L4_2, L5_2 do
      L7_2 = Objects
      L7_2 = L7_2.Get
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      L8_2 = L6_1
      L8_2 = L8_2[L6_2]
      if L7_2 and L8_2 then
        L9_2 = #L1_2
        L9_2 = L9_2 + 1
        L10_2 = Cmd
        L10_2 = L10_2.Transform
        L11_2 = Objects
        L11_2 = L11_2.UidOf
        L12_2 = L6_2
        L11_2 = L11_2(L12_2)
        L12_2 = {}
        L13_2 = {}
        L14_2 = L8_2.x
        L13_2.x = L14_2
        L14_2 = L8_2.y
        L13_2.y = L14_2
        L14_2 = L8_2.z
        L13_2.z = L14_2
        L12_2.coords = L13_2
        L13_2 = {}
        L14_2 = L7_2.rot
        L14_2 = L14_2.x
        L13_2.x = L14_2
        L14_2 = L7_2.rot
        L14_2 = L14_2.y
        L13_2.y = L14_2
        L14_2 = L7_2.rot
        L14_2 = L14_2.z
        L13_2.z = L14_2
        L12_2.rot = L13_2
        L13_2 = {}
        L14_2 = {}
        L15_2 = L7_2.coords
        L15_2 = L15_2.x
        L14_2.x = L15_2
        L15_2 = L7_2.coords
        L15_2 = L15_2.y
        L14_2.y = L15_2
        L15_2 = L7_2.coords
        L15_2 = L15_2.z
        L14_2.z = L15_2
        L13_2.coords = L14_2
        L14_2 = {}
        L15_2 = L7_2.rot
        L15_2 = L15_2.x
        L14_2.x = L15_2
        L15_2 = L7_2.rot
        L15_2 = L15_2.y
        L14_2.y = L15_2
        L15_2 = L7_2.rot
        L15_2 = L15_2.z
        L14_2.z = L15_2
        L13_2.rot = L14_2
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        L1_2[L9_2] = L10_2
        L9_2 = MEAutoSave
        if L9_2 then
          L9_2 = MEAutoSave
          L10_2 = L6_2
          L9_2(L10_2)
        end
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
        L5_2 = "hist.move_selection"
        L4_2 = L4_2(L5_2)
        L5_2 = L1_2
        L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L3_2(L4_2, L5_2)
        L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      end
    end
  end
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "bulkGrab"
  L3_2 = {}
  L4_2 = L3_1
  L3_2.on = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
  L1_2 = L3_1
  if L1_2 and not L0_2 then
    L1_2 = L11_1
    L1_2()
  end
end
L12_1.GrabToggle = L13_1
