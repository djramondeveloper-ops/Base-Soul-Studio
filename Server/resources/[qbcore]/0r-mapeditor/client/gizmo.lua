local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
L0_1 = {}
Gizmo = L0_1
L0_1 = false
L1_1 = nil
L2_1 = false
L3_1 = 0.0
L4_1 = 0.0
L5_1 = nil
L6_1 = "translate"
L7_1 = 0
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = A0_2.coords
  L3_2 = L3_2.x
  L2_2.x = L3_2
  L3_2 = A0_2.coords
  L3_2 = L3_2.y
  L2_2.y = L3_2
  L3_2 = A0_2.coords
  L3_2 = L3_2.z
  L2_2.z = L3_2
  L1_2.coords = L2_2
  L2_2 = {}
  L3_2 = A0_2.rot
  L3_2 = L3_2.x
  L2_2.x = L3_2
  L3_2 = A0_2.rot
  L3_2 = L3_2.y
  L2_2.y = L3_2
  L3_2 = A0_2.rot
  L3_2 = L3_2.z
  L2_2.z = L3_2
  L1_2.rot = L2_2
  return L1_2
end
function L9_1()
  local L0_2, L1_2
  L0_2 = IsEditorUiHovered
  if L0_2 then
    L0_2 = IsEditorUiHovered
    L0_2 = L0_2()
  end
  return L0_2
end
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A0_2 then
    L2_2 = DoesEntityExist
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_9
    end
  end
  do return end
  ::lbl_9::
  if A1_2 then
    L2_2 = SetEntityDrawOutlineShader
    L3_2 = 1
    L2_2(L3_2)
    L2_2 = SetEntityDrawOutlineColor
    L3_2 = 46
    L4_2 = 155
    L5_2 = 255
    L6_2 = 255
    L2_2(L3_2, L4_2, L5_2, L6_2)
    L2_2 = SetEntityDrawOutline
    L3_2 = A0_2
    L4_2 = true
    L2_2(L3_2, L4_2)
  else
    L2_2 = SetEntityDrawOutline
    L3_2 = A0_2
    L4_2 = false
    L2_2(L3_2, L4_2)
  end
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = Camera
  L1_2 = L1_2.CursorRay
  L1_2, L2_2 = L1_2()
  L3_2 = Config
  L3_2 = L3_2.placement
  L3_2 = L3_2.maxRayDistance
  L3_2 = L2_2 * L3_2
  L3_2 = L1_2 + L3_2
  L4_2 = _ENV
  L5_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L4_2 = L4_2[L5_2]
  L5_2 = L1_2.x
  L6_2 = L1_2.y
  L7_2 = L1_2.z
  L8_2 = L3_2.x
  L9_2 = L3_2.y
  L10_2 = L3_2.z
  L11_2 = -1
  L12_2 = A0_2 or L12_2
  if not A0_2 then
    L12_2 = 0
  end
  L13_2 = 4
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L5_2 = GetShapeTestResult
  L6_2 = L4_2
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  if true == L6_2 or 1 == L6_2 then
    return L7_2
  end
  L8_2 = L2_2 * 10.0
  L8_2 = L1_2 + L8_2
  return L8_2
end
L12_1 = Gizmo
function L13_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
L12_1.Target = L13_1
L12_1 = Gizmo
function L13_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L1_1
    L0_2 = nil ~= L0_2
  end
  return L0_2
end
L12_1.IsActive = L13_1
L12_1 = Gizmo
function L13_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L12_1.IsGrabbing = L13_1
L12_1 = Gizmo
function L13_1()
  local L0_2, L1_2
  L0_2 = false
  return L0_2
end
L12_1.IsNativeActive = L13_1
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = Objects
    L1_2 = L1_2.Get
    L2_2 = L1_1
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = DoesEntityExist
    L3_2 = L1_2.handle
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_16
    end
  end
  do return end
  ::lbl_16::
  if A0_2 then
    L2_2 = SetEntityAlpha
    L3_2 = L1_2.handle
    L4_2 = Config
    L4_2 = L4_2.placement
    L4_2 = L4_2.ghostAlpha
    L5_2 = false
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = SetEntityCollision
    L3_2 = L1_2.handle
    L4_2 = false
    L5_2 = false
    L2_2(L3_2, L4_2, L5_2)
  else
    L2_2 = Objects
    L2_2 = L2_2.ApplyProps
    L3_2 = L1_2.handle
    L4_2 = L1_2.props
    L2_2(L3_2, L4_2)
  end
end
function L13_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L1_1
  if L0_2 then
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
  end
  if L0_2 then
    L1_2 = L10_1
    L2_2 = L0_2.handle
    L3_2 = false
    L1_2(L2_2, L3_2)
  end
  L1_2 = L2_1
  if L1_2 then
    L1_2 = L12_1
    L2_2 = false
    L1_2(L2_2)
  end
  L1_2 = false
  L2_2 = false
  L3_2 = nil
  L1_1 = L3_2
  L2_1 = L2_2
  L0_1 = L1_2
  L1_2 = Raycast
  L1_2 = L1_2.Reset
  L2_2 = "gizmoGrab"
  L1_2(L2_2)
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "deselect"
  L1_2(L2_2)
end
L14_1 = Gizmo
L14_1.Deselect = L13_1
L14_1 = Gizmo
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = L1_1
  if not L0_2 then
    return
  end
  L0_2 = L2_1
  L0_2 = not L0_2
  L2_1 = L0_2
  L0_2 = L2_1
  if L0_2 then
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L1_2 = L0_2.coords
      L1_2 = L1_2.z
      if L1_2 then
        goto lbl_22
      end
    end
    L1_2 = 0.0
    ::lbl_22::
    L3_1 = L1_2
    L1_2 = 0.0
    L4_1 = L1_2
    if L0_2 then
      L1_2 = L8_1
      L2_2 = L0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        goto lbl_33
      end
    end
    L1_2 = nil
    ::lbl_33::
    L5_1 = L1_2
  else
    L0_2 = MEAutoSave
    if L0_2 then
      L0_2 = MEAutoSave
      L1_2 = L1_1
      L0_2(L1_2)
    end
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
    L1_2 = History
    if L1_2 then
      L1_2 = L5_1
      if L1_2 and L0_2 then
        L1_2 = History
        L1_2 = L1_2.Push
        L2_2 = Cmd
        L2_2 = L2_2.Transform
        L3_2 = Objects
        L3_2 = L3_2.UidOf
        L4_2 = L1_1
        L3_2 = L3_2(L4_2)
        L4_2 = L5_1
        L5_2 = L8_1
        L6_2 = L0_2
        L5_2, L6_2 = L5_2(L6_2)
        L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
        L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
      end
    end
    L1_2 = nil
    L5_1 = L1_2
    L1_2 = Raycast
    L1_2 = L1_2.Reset
    L2_2 = "gizmoGrab"
    L1_2(L2_2)
    L1_2 = SendNUIMessage
    L2_2 = {}
    L2_2.action = "selected"
    L3_2 = Gizmo
    L3_2 = L3_2.Info
    L3_2 = L3_2()
    L2_2.data = L3_2
    L1_2(L2_2)
  end
  L0_2 = L12_1
  L1_2 = L2_1
  L0_2(L1_2)
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "grab"
  L2_2 = {}
  L3_2 = L2_1
  L2_2.on = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L14_1.ToggleGrab = L15_1
L14_1 = Gizmo
function L15_1(A0_2)
  local L1_2, L2_2
  L1_2 = L2_1
  if L1_2 then
    L1_2 = L3_1
    L2_2 = A0_2 or L2_2
    if not A0_2 then
      L2_2 = 0.0
    end
    L1_2 = L1_2 + L2_2
    L3_1 = L1_2
    L1_2 = L4_1
    L2_2 = A0_2 or L2_2
    if not A0_2 then
      L2_2 = 0.0
    end
    L1_2 = L1_2 + L2_2
    L4_1 = L1_2
  end
end
L14_1.AdjustHeight = L15_1
L14_1 = Gizmo
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = Objects
    L1_2 = L1_2.Get
    L2_2 = L1_1
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = L8_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    L3_2 = Objects
    L3_2 = L3_2.Update
    L4_2 = L1_1
    L5_2 = L1_2.coords
    L6_2 = vector3
    L7_2 = L1_2.rot
    L7_2 = L7_2.x
    L8_2 = L1_2.rot
    L8_2 = L8_2.y
    L9_2 = L1_2.rot
    L9_2 = L9_2.z
    L10_2 = A0_2 or L10_2
    if not A0_2 then
      L10_2 = 0.0
    end
    L9_2 = L9_2 + L10_2
    L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L3_2 = MEAutoSave
    if L3_2 then
      L3_2 = MEAutoSave
      L4_2 = L1_1
      L3_2(L4_2)
    end
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L1_1
    L3_2 = L3_2(L4_2)
    L4_2 = History
    if L4_2 and L3_2 then
      L4_2 = L2_1
      if not L4_2 then
        L4_2 = History
        L4_2 = L4_2.Push
        L5_2 = Cmd
        L5_2 = L5_2.Transform
        L6_2 = Objects
        L6_2 = L6_2.UidOf
        L7_2 = L1_1
        L6_2 = L6_2(L7_2)
        L7_2 = L2_2
        L8_2 = L8_1
        L9_2 = L3_2
        L8_2, L9_2, L10_2 = L8_2(L9_2)
        L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
        L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
      end
    end
  end
end
L14_1.AdjustYaw = L15_1
L14_1 = Gizmo
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L1_1
  if L2_2 then
    L2_2 = L2_1
    if not L2_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L2_2 = Objects
  L2_2 = L2_2.Get
  L3_2 = L1_1
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  if A0_2 then
    L3_2 = vector3
    L4_2 = A0_2.x
    L4_2 = L4_2 + 0.0
    L5_2 = A0_2.y
    L5_2 = L5_2 + 0.0
    L6_2 = A0_2.z
    L6_2 = L6_2 + 0.0
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = L2_2.coords
  ::lbl_31::
  if A1_2 then
    L4_2 = vector3
    L5_2 = A1_2.x
    L5_2 = L5_2 + 0.0
    L6_2 = A1_2.y
    L6_2 = L6_2 + 0.0
    L7_2 = A1_2.z
    L7_2 = L7_2 + 0.0
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_47
    end
  end
  L4_2 = L2_2.rot
  ::lbl_47::
  L5_2 = Objects
  L5_2 = L5_2.Update
  L6_2 = L1_1
  L7_2 = L3_2
  L8_2 = L4_2
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = SendNUIMessage
  L6_2 = {}
  L6_2.action = "selected"
  L7_2 = Gizmo
  L7_2 = L7_2.Info
  L7_2 = L7_2()
  L6_2.data = L7_2
  L5_2(L6_2)
end
L14_1.SetTransform = L15_1
L14_1 = Gizmo
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L2_1
  if L0_2 then
    return
  end
  L0_2 = L1_1
  if L0_2 then
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
  end
  if not L0_2 then
    return
  end
  L1_2 = L8_1
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L0_2.coords
  L3_2 = vector3
  L4_2 = 0.0
  L5_2 = 0.0
  L6_2 = 3.0
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L2_2 + L3_2
  L3_2 = L0_2.coords
  L4_2 = vector3
  L5_2 = 0.0
  L6_2 = 0.0
  L7_2 = 100.0
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2 - L4_2
  L4_2 = _ENV
  L5_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L4_2 = L4_2[L5_2]
  L5_2 = L2_2.x
  L6_2 = L2_2.y
  L7_2 = L2_2.z
  L8_2 = L3_2.x
  L9_2 = L3_2.y
  L10_2 = L3_2.z
  L11_2 = 1
  L12_2 = L0_2.handle
  L13_2 = 4
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L5_2 = GetShapeTestResult
  L6_2 = L4_2
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  if true == L6_2 or 1 == L6_2 then
    L8_2 = Objects
    L8_2 = L8_2.Update
    L9_2 = L1_1
    L10_2 = vector3
    L11_2 = L0_2.coords
    L11_2 = L11_2.x
    L12_2 = L0_2.coords
    L12_2 = L12_2.y
    L13_2 = L7_2.z
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = L0_2.rot
    L8_2(L9_2, L10_2, L11_2)
    L8_2 = SendNUIMessage
    L9_2 = {}
    L9_2.action = "selected"
    L10_2 = Gizmo
    L10_2 = L10_2.Info
    L10_2 = L10_2()
    L9_2.data = L10_2
    L8_2(L9_2)
    L8_2 = MEAutoSave
    if L8_2 then
      L8_2 = MEAutoSave
      L9_2 = L1_1
      L8_2(L9_2)
    end
    L8_2 = Objects
    L8_2 = L8_2.Get
    L9_2 = L1_1
    L8_2 = L8_2(L9_2)
    L9_2 = History
    if L9_2 and L8_2 then
      L9_2 = History
      L9_2 = L9_2.Push
      L10_2 = Cmd
      L10_2 = L10_2.Transform
      L11_2 = Objects
      L11_2 = L11_2.UidOf
      L12_2 = L1_1
      L11_2 = L11_2(L12_2)
      L12_2 = L1_2
      L13_2 = L8_1
      L14_2 = L8_2
      L13_2, L14_2 = L13_2(L14_2)
      L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
end
L14_1.Ground = L15_1
L14_1 = Gizmo
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L1_1
  if L0_2 then
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
  end
  if L0_2 then
    L1_2 = L2_1
    if not L1_2 then
      goto lbl_14
    end
  end
  do return end
  ::lbl_14::
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L0_2.props
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  L2_2 = Objects
  L2_2 = L2_2.Spawn
  L3_2 = L0_2.model
  L4_2 = L0_2.coords
  L5_2 = vector3
  L6_2 = 0.5
  L7_2 = 0.5
  L8_2 = 0.0
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2 = L4_2 + L5_2
  L5_2 = L0_2.rot
  L6_2 = L1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if L2_2 then
    L3_2 = L0_2.layer
    if L3_2 then
      L3_2 = L0_2.layer
      if "Default" ~= L3_2 then
        L3_2 = Objects
        L3_2 = L3_2.SetObjectLayer
        L4_2 = L2_2
        L5_2 = L0_2.layer
        L3_2(L4_2, L5_2)
      end
    end
    L3_2 = L0_2.blipOn
    if L3_2 then
      L3_2 = Objects
      L3_2 = L3_2.SetBlip
      L4_2 = L2_2
      L5_2 = L0_2.blipName
      L6_2 = L0_2.blipColor
      L7_2 = L0_2.blipOn
      L3_2(L4_2, L5_2, L6_2, L7_2)
    end
    L3_2 = MEAutoSave
    if L3_2 then
      L3_2 = MEAutoSave
      L4_2 = L2_2
      L3_2(L4_2)
    end
    L3_2 = History
    if L3_2 then
      L3_2 = History
      L3_2 = L3_2.Push
      L4_2 = Cmd
      L4_2 = L4_2.Add
      L5_2 = Objects
      L5_2 = L5_2.UidOf
      L6_2 = L2_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
      L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    end
    L3_2 = Gizmo
    L3_2 = L3_2.Select
    L4_2 = L2_2
    L3_2(L4_2)
  end
end
L14_1.Clone = L15_1
L14_1 = Gizmo
function L15_1(A0_2)
  local L1_2
  L1_2 = A0_2 or nil
  if not A0_2 then
    L1_2 = "translate"
  end
  L6_1 = L1_2
end
L14_1.SetMode = L15_1
L14_1 = Gizmo
function L15_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L1_1
  if L0_2 then
    L0_2 = Objects
    L0_2 = L0_2.Get
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
  end
  if not L0_2 then
    L1_2 = {}
    return L1_2
  end
  L1_2 = {}
  L2_2 = L1_1
  L1_2.id = L2_2
  L2_2 = L0_2.model
  L1_2.model = L2_2
  L2_2 = {}
  L3_2 = L0_2.coords
  L3_2 = L3_2.x
  L2_2.x = L3_2
  L3_2 = L0_2.coords
  L3_2 = L3_2.y
  L2_2.y = L3_2
  L3_2 = L0_2.coords
  L3_2 = L3_2.z
  L2_2.z = L3_2
  L1_2.coords = L2_2
  L2_2 = {}
  L3_2 = L0_2.rot
  L3_2 = L3_2.x
  L2_2.x = L3_2
  L3_2 = L0_2.rot
  L3_2 = L3_2.y
  L2_2.y = L3_2
  L3_2 = L0_2.rot
  L3_2 = L3_2.z
  L2_2.z = L3_2
  L1_2.rot = L2_2
  L2_2 = L0_2.props
  L1_2.props = L2_2
  L2_2 = {}
  L3_2 = L0_2.blipName
  if not L3_2 then
    L3_2 = ""
  end
  L2_2.name = L3_2
  L3_2 = L0_2.blipColor
  if not L3_2 then
    L3_2 = 0
  end
  L2_2.color = L3_2
  L3_2 = L0_2.blipOn
  L3_2 = true == L3_2
  L2_2.on = L3_2
  L1_2.blip = L2_2
  return L1_2
end
L14_1.Info = L15_1
L14_1 = Gizmo
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L1_2 = L0_1
  if L1_2 then
    L1_2 = L1_1
    if L1_2 then
      L1_2 = L1_1
      if L1_2 ~= A0_2 then
        L1_2 = Objects
        L1_2 = L1_2.Get
        L2_2 = L1_1
        L1_2 = L1_2(L2_2)
        if L1_2 then
          L2_2 = L10_1
          L3_2 = L1_2.handle
          L4_2 = false
          L2_2(L3_2, L4_2)
        end
        L2_2 = L2_1
        if L2_2 then
          L2_2 = L12_1
          L3_2 = false
          L2_2(L3_2)
          L2_2 = false
          L2_1 = L2_2
          L2_2 = History
          if L2_2 then
            L2_2 = L5_1
            if L2_2 and L1_2 then
              L2_2 = History
              L2_2 = L2_2.Push
              L3_2 = Cmd
              L3_2 = L3_2.Transform
              L4_2 = Objects
              L4_2 = L4_2.UidOf
              L5_2 = L1_1
              L4_2 = L4_2(L5_2)
              L5_2 = L5_1
              L6_2 = L8_1
              L7_2 = L1_2
              L6_2, L7_2 = L6_2(L7_2)
              L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
              L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
            end
          end
          L2_2 = nil
          L5_1 = L2_2
        end
      end
    end
  end
  L1_1 = A0_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L10_1
    L3_2 = L1_2.handle
    L4_2 = true
    L2_2(L3_2, L4_2)
  end
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "selected"
  L4_2 = Gizmo
  L4_2 = L4_2.Info
  L4_2 = L4_2()
  L3_2.data = L4_2
  L2_2(L3_2)
  L2_2 = L0_1
  if L2_2 then
    return
  end
  L2_2 = true
  L0_1 = L2_2
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L1_1
      if not L0_3 then
        break
      end
      L0_3 = Objects
      L0_3 = L0_3.Get
      L1_3 = L1_1
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        L1_3 = L13_1
        L1_3()
        break
      end
      L1_3 = IsDisabledControlPressed
      L2_3 = 0
      L3_3 = 21
      L1_3 = L1_3(L2_3, L3_3)
      L2_3 = L2_1
      if L2_3 then
        if L1_3 then
          L2_3 = 2.5
          if L2_3 then
            goto lbl_29
          end
        end
        L2_3 = 0.9
        ::lbl_29::
        L3_3 = L0_3.rot
        L3_3 = L3_3.z
        L4_3 = IsDisabledControlPressed
        L5_3 = 0
        L6_3 = 174
        L4_3 = L4_3(L5_3, L6_3)
        if L4_3 then
          L3_3 = L3_3 - L2_3
        end
        L4_3 = IsDisabledControlPressed
        L5_3 = 0
        L6_3 = 175
        L4_3 = L4_3(L5_3, L6_3)
        if L4_3 then
          L3_3 = L3_3 + L2_3
        end
        L4_3 = L0_3.coords
        L4_3 = L4_3.x
        L5_3 = L0_3.coords
        L5_3 = L5_3.y
        L6_3 = L3_1
        L7_3 = L9_1
        L7_3 = L7_3()
        if not L7_3 then
          L7_3 = Raycast
          L7_3 = L7_3.Cursor
          L8_3 = "gizmoGrab"
          L9_3 = L0_3.handle
          L7_3, L8_3 = L7_3(L8_3, L9_3)
          if not L7_3 or not L8_3 then
            L9_3 = Camera
            L9_3 = L9_3.CursorRay
            L9_3, L10_3 = L9_3()
            L11_3 = L10_3 * 10.0
            L8_3 = L9_3 + L11_3
          end
          L9_3 = L8_3.x
          L5_3 = L8_3.y
          L4_3 = L9_3
          L9_3 = Config
          L9_3 = L9_3.snap
          L9_3 = L9_3.surface
          if L9_3 then
            L9_3 = L8_3.z
            L10_3 = L4_1
            L6_3 = L9_3 + L10_3
          end
          L9_3 = Config
          L9_3 = L9_3.snap
          L9_3 = L9_3.grid
          if L9_3 then
            L9_3 = Config
            L9_3 = L9_3.snap
            L9_3 = L9_3.gridSize
            L10_3 = math
            L10_3 = L10_3.floor
            L11_3 = L4_3 / L9_3
            L11_3 = L11_3 + 0.5
            L10_3 = L10_3(L11_3)
            L4_3 = L10_3 * L9_3
            L10_3 = math
            L10_3 = L10_3.floor
            L11_3 = L5_3 / L9_3
            L11_3 = L11_3 + 0.5
            L10_3 = L10_3(L11_3)
            L5_3 = L10_3 * L9_3
          end
          L9_3 = Config
          L9_3 = L9_3.snap
          L9_3 = L9_3.snap
          if L9_3 then
            L9_3 = Objects
            L9_3 = L9_3.SnapToNearby
            L10_3 = vector3
            L11_3 = L4_3
            L12_3 = L5_3
            L13_3 = L6_3
            L10_3 = L10_3(L11_3, L12_3, L13_3)
            L11_3 = L1_1
            L9_3 = L9_3(L10_3, L11_3)
            L10_3 = L9_3.x
            L11_3 = L9_3.y
            L6_3 = L9_3.z
            L5_3 = L11_3
            L4_3 = L10_3
          end
        end
        L7_3 = Objects
        L7_3 = L7_3.Update
        L8_3 = L1_1
        L9_3 = vector3
        L10_3 = L4_3
        L11_3 = L5_3
        L12_3 = L6_3
        L9_3 = L9_3(L10_3, L11_3, L12_3)
        L10_3 = vector3
        L11_3 = L0_3.rot
        L11_3 = L11_3.x
        L12_3 = L0_3.rot
        L12_3 = L12_3.y
        L13_3 = L3_3
        L10_3, L11_3, L12_3, L13_3, L14_3 = L10_3(L11_3, L12_3, L13_3)
        L7_3(L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
        L7_3 = GetGameTimer
        L7_3 = L7_3()
        L8_3 = L7_1
        L8_3 = L7_3 - L8_3
        L9_3 = 250
        if L8_3 > L9_3 then
          L7_1 = L7_3
          L8_3 = SendNUIMessage
          L9_3 = {}
          L9_3.action = "selected"
          L10_3 = Gizmo
          L10_3 = L10_3.Info
          L10_3 = L10_3()
          L9_3.data = L10_3
          L8_3(L9_3)
        end
        L8_3 = IsDisabledControlJustPressed
        L9_3 = 0
        L10_3 = 24
        L8_3 = L8_3(L9_3, L10_3)
        if L8_3 then
          L8_3 = L9_1
          L8_3 = L8_3()
          if not L8_3 then
            L8_3 = Gizmo
            L8_3 = L8_3.ToggleGrab
            L8_3()
          end
        end
      else
        L2_3 = IsDisabledControlJustPressed
        L3_3 = 0
        L4_3 = 172
        L2_3 = L2_3(L3_3, L4_3)
        if not L2_3 then
          L2_3 = IsDisabledControlJustPressed
          L3_3 = 0
          L4_3 = 173
          L2_3 = L2_3(L3_3, L4_3)
          if not L2_3 then
            L2_3 = IsDisabledControlJustPressed
            L3_3 = 0
            L4_3 = 174
            L2_3 = L2_3(L3_3, L4_3)
            if not L2_3 then
              L2_3 = IsDisabledControlJustPressed
              L3_3 = 0
              L4_3 = 175
              L2_3 = L2_3(L3_3, L4_3)
              if not L2_3 then
                goto lbl_328
              end
            end
          end
        end
        if L1_3 then
          L2_3 = Config
          L2_3 = L2_3.precise
          L2_3 = L2_3.moveFast
          if L2_3 then
            goto lbl_211
          end
        end
        L2_3 = Config
        L2_3 = L2_3.precise
        L2_3 = L2_3.move
        ::lbl_211::
        L3_3 = Camera
        L3_3 = L3_3.GetForward
        L3_3 = L3_3()
        L4_3 = vector3
        L5_3 = L3_3.x
        L6_3 = L3_3.y
        L7_3 = 0.0
        L4_3 = L4_3(L5_3, L6_3, L7_3)
        L3_3 = L4_3
        L4_3 = #L3_3
        if L4_3 > 0 then
          L3_3 = L3_3 / L4_3
        end
        L5_3 = vector3
        L6_3 = L3_3.y
        L7_3 = L3_3.x
        L7_3 = -L7_3
        L8_3 = 0.0
        L5_3 = L5_3(L6_3, L7_3, L8_3)
        L6_3 = vector3
        L7_3 = 0.0
        L8_3 = 0.0
        L9_3 = 0.0
        L6_3 = L6_3(L7_3, L8_3, L9_3)
        L7_3 = IsDisabledControlJustPressed
        L8_3 = 0
        L9_3 = 172
        L7_3 = L7_3(L8_3, L9_3)
        if L7_3 then
          L7_3 = L3_3 * L2_3
          L6_3 = L6_3 + L7_3
        end
        L7_3 = IsDisabledControlJustPressed
        L8_3 = 0
        L9_3 = 173
        L7_3 = L7_3(L8_3, L9_3)
        if L7_3 then
          L7_3 = L3_3 * L2_3
          L6_3 = L6_3 - L7_3
        end
        L7_3 = IsDisabledControlJustPressed
        L8_3 = 0
        L9_3 = 174
        L7_3 = L7_3(L8_3, L9_3)
        if L7_3 then
          L7_3 = L5_3 * L2_3
          L6_3 = L6_3 - L7_3
        end
        L7_3 = IsDisabledControlJustPressed
        L8_3 = 0
        L9_3 = 175
        L7_3 = L7_3(L8_3, L9_3)
        if L7_3 then
          L7_3 = L5_3 * L2_3
          L6_3 = L6_3 + L7_3
        end
        L7_3 = #L6_3
        if L7_3 > 0 then
          L7_3 = L8_1
          L8_3 = L0_3
          L7_3 = L7_3(L8_3)
          L8_3 = Objects
          L8_3 = L8_3.Update
          L9_3 = L1_1
          L10_3 = L0_3.coords
          L10_3 = L10_3 + L6_3
          L11_3 = L0_3.rot
          L8_3(L9_3, L10_3, L11_3)
          L8_3 = SendNUIMessage
          L9_3 = {}
          L9_3.action = "selected"
          L10_3 = Gizmo
          L10_3 = L10_3.Info
          L10_3 = L10_3()
          L9_3.data = L10_3
          L8_3(L9_3)
          L8_3 = MEAutoSave
          if L8_3 then
            L8_3 = MEAutoSave
            L9_3 = L1_1
            L8_3(L9_3)
          end
          L8_3 = Objects
          L8_3 = L8_3.Get
          L9_3 = L1_1
          L8_3 = L8_3(L9_3)
          L9_3 = History
          if L9_3 and L8_3 then
            L9_3 = History
            L9_3 = L9_3.Push
            L10_3 = Cmd
            L10_3 = L10_3.Transform
            L11_3 = Objects
            L11_3 = L11_3.UidOf
            L12_3 = L1_1
            L11_3 = L11_3(L12_3)
            L12_3 = L7_3
            L13_3 = L8_1
            L14_3 = L8_3
            L13_3, L14_3 = L13_3(L14_3)
            L10_3, L11_3, L12_3, L13_3, L14_3 = L10_3(L11_3, L12_3, L13_3, L14_3)
            L9_3(L10_3, L11_3, L12_3, L13_3, L14_3)
          end
        end
        ::lbl_328::
        L2_3 = IsDisabledControlJustPressed
        L3_3 = 0
        L4_3 = 73
        L2_3 = L2_3(L3_3, L4_3)
        if L2_3 then
          L2_3 = L13_1
          L2_3()
        end
      end
      L2_3 = Wait
      L3_3 = 0
      L2_3(L3_3)
    end
  end
  L2_2(L3_2)
end
L14_1.Select = L15_1
