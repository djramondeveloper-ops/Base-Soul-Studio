local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1
L0_1 = {}
WorldProps = L0_1
L0_1 = false
L1_1 = 0
L2_1 = {}
function L3_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_17
    end
    L1_2 = joaat
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_17
    end
  end
  L1_2 = A0_2
  ::lbl_17::
  return L1_2
end
function L4_1(A0_2)
  local L1_2, L2_2
  L1_2 = Objects
  L1_2 = L1_2.IdByHandle
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = nil ~= L1_2
  return L1_2
end
L5_1 = WorldProps
function L6_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L5_1.IsActive = L6_1
L5_1 = WorldProps
function L6_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L5_1.GetHidden = L6_1
L5_1 = WorldProps
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = CreateModelHideExcludingScriptObjects
  L2_2 = A0_2.x
  L3_2 = A0_2.y
  L4_2 = A0_2.z
  L5_2 = A0_2.radius
  if not L5_2 then
    L5_2 = 0.25
  end
  L6_2 = L3_1
  L7_2 = A0_2.model
  L6_2 = L6_2(L7_2)
  L7_2 = true
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L2_1
  L1_2 = #L1_2
  L2_2 = L1_2 + 1
  L1_2 = L2_1
  L1_2[L2_2] = A0_2
  L1_2 = MEDockDirty
  if L1_2 then
    L1_2 = MEDockDirty
    L2_2 = "hidden"
    L1_2(L2_2)
  end
end
L5_1.HideEntry = L6_1
L5_1 = WorldProps
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = RemoveModelHide
  L2_2 = A0_2.x
  L3_2 = A0_2.y
  L4_2 = A0_2.z
  L5_2 = A0_2.radius
  if not L5_2 then
    L5_2 = 0.25
  end
  L6_2 = L3_1
  L7_2 = A0_2.model
  L6_2 = L6_2(L7_2)
  L7_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L2_1
  L1_2 = #L1_2
  L2_2 = 1
  L3_2 = -1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = L2_1
    L5_2 = L5_2[L4_2]
    if L5_2 == A0_2 then
      L5_2 = table
      L5_2 = L5_2.remove
      L6_2 = L2_1
      L7_2 = L4_2
      L5_2(L6_2, L7_2)
      break
    end
  end
  L1_2 = MEDockDirty
  if L1_2 then
    L1_2 = MEDockDirty
    L2_2 = "hidden"
    L1_2(L2_2)
  end
end
L5_1.RestoreEntry = L6_1
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = GetEntityModel
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = GetEntityCoords
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L3_2.model = L1_2
  L4_2 = L2_2.x
  L3_2.x = L4_2
  L4_2 = L2_2.y
  L3_2.y = L4_2
  L4_2 = L2_2.z
  L3_2.z = L4_2
  L3_2.radius = 0.25
  L4_2 = WorldProps
  L4_2 = L4_2.HideEntry
  L5_2 = L3_2
  L4_2(L5_2)
  L4_2 = Bridge
  L4_2 = L4_2.Notify
  L5_2 = locale
  L6_2 = "notify.world_hidden"
  L5_2 = L5_2(L6_2)
  L6_2 = "success"
  L4_2(L5_2, L6_2)
  L4_2 = History
  if L4_2 then
    L4_2 = Cmd
    if L4_2 then
      L4_2 = Cmd
      L4_2 = L4_2.WorldHide
      if L4_2 then
        L4_2 = History
        L4_2 = L4_2.Push
        L5_2 = Cmd
        L5_2 = L5_2.WorldHide
        L6_2 = L3_2
        L5_2, L6_2 = L5_2(L6_2)
        L4_2(L5_2, L6_2)
      end
    end
  end
end
L6_1 = WorldProps
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L2_1
  L1_2 = #L0_2
  L0_2 = L2_1
  L0_2 = L0_2[L1_2]
  if not L0_2 then
    return
  end
  L1_2 = RemoveModelHide
  L2_2 = L0_2.x
  L3_2 = L0_2.y
  L4_2 = L0_2.z
  L5_2 = L0_2.radius
  L6_2 = L3_1
  L7_2 = L0_2.model
  L6_2 = L6_2(L7_2)
  L7_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L2_1
  L2_2 = #L1_2
  L1_2 = L2_1
  L1_2[L2_2] = nil
  L1_2 = History
  if L1_2 then
    L1_2 = History
    L1_2 = L1_2.DropWorldHide
    if L1_2 then
      L1_2 = History
      L1_2 = L1_2.DropWorldHide
      L2_2 = L0_2
      L1_2(L2_2)
    end
  end
  L1_2 = MEDockDirty
  if L1_2 then
    L1_2 = MEDockDirty
    L2_2 = "hidden"
    L1_2(L2_2)
  end
  L1_2 = Bridge
  L1_2 = L1_2.Notify
  L2_2 = locale
  L3_2 = "notify.restored_last"
  L2_2 = L2_2(L3_2)
  L3_2 = "inform"
  L1_2(L2_2, L3_2)
end
L6_1.UndoLast = L7_1
L6_1 = WorldProps
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = RemoveModelHide
  L3_2 = L1_2.x
  L4_2 = L1_2.y
  L5_2 = L1_2.z
  L6_2 = L1_2.radius
  L7_2 = L3_1
  L8_2 = L1_2.model
  L7_2 = L7_2(L8_2)
  L8_2 = false
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  L2_2 = table
  L2_2 = L2_2.remove
  L3_2 = L2_1
  L4_2 = A0_2
  L2_2(L3_2, L4_2)
  L2_2 = History
  if L2_2 then
    L2_2 = History
    L2_2 = L2_2.DropWorldHide
    if L2_2 then
      L2_2 = History
      L2_2 = L2_2.DropWorldHide
      L3_2 = L1_2
      L2_2(L3_2)
    end
  end
  L2_2 = MEDockDirty
  if L2_2 then
    L2_2 = MEDockDirty
    L3_2 = "hidden"
    L2_2(L3_2)
  end
  L2_2 = Bridge
  L2_2 = L2_2.Notify
  L3_2 = locale
  L4_2 = "notify.restored_prop"
  L3_2 = L3_2(L4_2)
  L4_2 = "inform"
  L2_2(L3_2, L4_2)
end
L6_1.RemoveAt = L7_1
L6_1 = WorldProps
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = WorldProps
  L1_2 = L1_2.Clear
  L1_2()
  L1_2 = 1
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = {}
  end
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = A0_2[L4_2]
    L6_2 = CreateModelHideExcludingScriptObjects
    L7_2 = L5_2.x
    L8_2 = L5_2.y
    L9_2 = L5_2.z
    L10_2 = L5_2.radius
    if not L10_2 then
      L10_2 = 0.25
    end
    L11_2 = L3_1
    L12_2 = L5_2.model
    L11_2 = L11_2(L12_2)
    L12_2 = true
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    L6_2 = L2_1
    L6_2 = #L6_2
    L7_2 = L6_2 + 1
    L6_2 = L2_1
    L8_2 = {}
    L9_2 = L5_2.model
    L8_2.model = L9_2
    L9_2 = L5_2.x
    L8_2.x = L9_2
    L9_2 = L5_2.y
    L8_2.y = L9_2
    L9_2 = L5_2.z
    L8_2.z = L9_2
    L9_2 = L5_2.radius
    if not L9_2 then
      L9_2 = 0.25
    end
    L8_2.radius = L9_2
    L6_2[L7_2] = L8_2
  end
end
L6_1.ApplyHidden = L7_1
L6_1 = WorldProps
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = 1
  L1_2 = L2_1
  L1_2 = #L1_2
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = L2_1
    L4_2 = L4_2[L3_2]
    L5_2 = RemoveModelHide
    L6_2 = L4_2.x
    L7_2 = L4_2.y
    L8_2 = L4_2.z
    L9_2 = L4_2.radius
    L10_2 = L3_1
    L11_2 = L4_2.model
    L10_2 = L10_2(L11_2)
    L11_2 = false
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  L0_2 = {}
  L2_1 = L0_2
end
L6_1.Clear = L7_1
function L6_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = Raycast
      L0_3 = L0_3.Cursor
      L1_3 = "worldprops"
      L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
      L4_3 = 0
      if L0_3 and L3_3 and 0 ~= L3_3 then
        L5_3 = GetEntityType
        L6_3 = L3_3
        L5_3 = L5_3(L6_3)
        if 3 == L5_3 then
          L5_3 = L4_1
          L6_3 = L3_3
          L5_3 = L5_3(L6_3)
          if not L5_3 then
            L4_3 = L3_3
          end
        end
      end
      L5_3 = L1_1
      if L4_3 ~= L5_3 then
        L5_3 = L1_1
        if 0 ~= L5_3 then
          L5_3 = DoesEntityExist
          L6_3 = L1_1
          L5_3 = L5_3(L6_3)
          if L5_3 then
            L5_3 = SetEntityDrawOutline
            L6_3 = L1_1
            L7_3 = false
            L5_3(L6_3, L7_3)
          end
        end
        L1_1 = L4_3
        L5_3 = L1_1
        if 0 ~= L5_3 then
          L5_3 = SetEntityDrawOutlineShader
          L6_3 = 1
          L5_3(L6_3)
          L5_3 = SetEntityDrawOutlineColor
          L6_3 = 255
          L7_3 = 70
          L8_3 = 70
          L9_3 = 255
          L5_3(L6_3, L7_3, L8_3, L9_3)
          L5_3 = SetEntityDrawOutline
          L6_3 = L1_1
          L7_3 = true
          L5_3(L6_3, L7_3)
        end
      end
      L5_3 = L1_1
      if 0 ~= L5_3 then
        L5_3 = IsEditorUiHovered
        if L5_3 then
          L5_3 = IsEditorUiHovered
          L5_3 = L5_3()
          if L5_3 then
            goto lbl_89
          end
        end
        L5_3 = IsDisabledControlJustPressed
        L6_3 = 0
        L7_3 = 24
        L5_3 = L5_3(L6_3, L7_3)
        if L5_3 then
          L5_3 = L1_1
          L6_3 = DoesEntityExist
          L7_3 = L5_3
          L6_3 = L6_3(L7_3)
          if L6_3 then
            L6_3 = SetEntityDrawOutline
            L7_3 = L5_3
            L8_3 = false
            L6_3(L7_3, L8_3)
          end
          L6_3 = 0
          L1_1 = L6_3
          L6_3 = L5_1
          L7_3 = L5_3
          L6_3(L7_3)
        end
      end
      ::lbl_89::
      L5_3 = Wait
      L6_3 = 0
      L5_3(L6_3)
    end
    L0_3 = L1_1
    if 0 ~= L0_3 then
      L0_3 = DoesEntityExist
      L1_3 = L1_1
      L0_3 = L0_3(L1_3)
      if L0_3 then
        L0_3 = SetEntityDrawOutline
        L1_3 = L1_1
        L2_3 = false
        L0_3(L1_3, L2_3)
      end
      L0_3 = 0
      L1_1 = L0_3
    end
    L0_3 = Raycast
    L0_3 = L0_3.Reset
    L1_3 = "worldprops"
    L0_3(L1_3)
  end
  L0_2(L1_2)
end
L7_1 = WorldProps
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
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
    L2_2 = L1_1
    if 0 ~= L2_2 then
      L2_2 = DoesEntityExist
      L3_2 = L1_1
      L2_2 = L2_2(L3_2)
      if L2_2 then
        L2_2 = SetEntityDrawOutline
        L3_2 = L1_1
        L4_2 = false
        L2_2(L3_2, L4_2)
      end
      L2_2 = 0
      L1_1 = L2_2
    end
  end
  L2_2 = L0_1
  if L2_2 and not L1_2 then
    L2_2 = L6_1
    L2_2()
  end
  L2_2 = L0_1
  return L2_2
end
L7_1.Toggle = L8_1
L7_1 = AddEventHandler
L8_1 = "onResourceStop"
function L9_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = WorldProps
    L1_2 = L1_2.Clear
    L1_2()
  end
end
L7_1(L8_1, L9_1)
