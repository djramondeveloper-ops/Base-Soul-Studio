local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1
L0_1 = {}
Align = L0_1
L0_1 = false
function L1_1()
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
function L2_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "align"
  L2_2 = {}
  L3_2 = L0_1
  L2_2.active = L3_2
  L3_2 = L1_1
  L3_2 = L3_2()
  L3_2 = #L3_2
  L2_2.count = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L3_1 = Align
function L4_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L3_1.IsActive = L4_1
L3_1 = Align
function L4_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L2_1
    L0_2()
  end
end
L3_1.OnBulkChanged = L4_1
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
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
  L5_2 = math
  L5_2 = L5_2.huge
  L6_2 = math
  L6_2 = L6_2.huge
  L6_2 = -L6_2
  L7_2 = 1
  L8_2 = #A0_2
  L9_2 = 1
  for L10_2 = L7_2, L8_2, L9_2 do
    L11_2 = Objects
    L11_2 = L11_2.Get
    L12_2 = A0_2[L10_2]
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L11_2.coords
      L13_2 = L12_2.x
      if L1_2 > L13_2 then
        L1_2 = L12_2.x
      end
      L13_2 = L12_2.x
      if L2_2 < L13_2 then
        L2_2 = L12_2.x
      end
      L13_2 = L12_2.y
      if L3_2 > L13_2 then
        L3_2 = L12_2.y
      end
      L13_2 = L12_2.y
      if L4_2 < L13_2 then
        L4_2 = L12_2.y
      end
      L13_2 = L12_2.z
      if L5_2 > L13_2 then
        L5_2 = L12_2.z
      end
      L13_2 = L12_2.z
      if L6_2 < L13_2 then
        L6_2 = L12_2.z
      end
    end
  end
  L7_2 = {}
  L7_2.minx = L1_2
  L7_2.maxx = L2_2
  L7_2.miny = L3_2
  L7_2.maxy = L4_2
  L7_2.minz = L5_2
  L7_2.maxz = L6_2
  return L7_2
end
function L4_1(A0_2)
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
L5_1 = Align
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L1_1
  L2_2 = L2_2()
  L3_2 = #L2_2
  if L3_2 < 2 then
    L3_2 = Bridge
    L3_2 = L3_2.Notify
    L4_2 = locale
    L5_2 = "notify.align_need2"
    L4_2 = L4_2(L5_2)
    L5_2 = "error"
    L3_2(L4_2, L5_2)
    return
  end
  L3_2 = L3_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = nil
  if "x" == A0_2 then
    if "min" == A1_2 then
      L5_2 = L3_2.minx
      L4_2 = L5_2 or L4_2
    end
    if not L5_2 then
      if "max" == A1_2 then
        L5_2 = L3_2.maxx
        L4_2 = L5_2 or L4_2
      end
      if not L5_2 then
        L5_2 = L3_2.minx
        L6_2 = L3_2.maxx
        L5_2 = L5_2 + L6_2
        L4_2 = L5_2 * 0.5
      end
    end
  elseif "y" == A0_2 then
    if "min" == A1_2 then
      L5_2 = L3_2.miny
      L4_2 = L5_2 or L4_2
    end
    if not L5_2 then
      if "max" == A1_2 then
        L5_2 = L3_2.maxy
        L4_2 = L5_2 or L4_2
      end
      if not L5_2 then
        L5_2 = L3_2.miny
        L6_2 = L3_2.maxy
        L5_2 = L5_2 + L6_2
        L4_2 = L5_2 * 0.5
      end
    end
  else
    if "min" == A1_2 then
      L5_2 = L3_2.minz
      if L5_2 then
        goto lbl_72
        L4_2 = L5_2 or L4_2
      end
    end
    if "max" == A1_2 then
      L5_2 = L3_2.maxz
      if L5_2 then
        goto lbl_72
        L4_2 = L5_2 or L4_2
      end
    end
    L5_2 = L3_2.minz
    L6_2 = L3_2.maxz
    L5_2 = L5_2 + L6_2
    L4_2 = L5_2 * 0.5
  end
  ::lbl_72::
  L5_2 = {}
  L6_2 = 1
  L7_2 = #L2_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = L2_2[L9_2]
    L11_2 = Objects
    L11_2 = L11_2.Get
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L4_1
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L13_2 = vector3
      L14_2 = L4_2 or L14_2
      if "x" ~= A0_2 or not L4_2 then
        L14_2 = L11_2.coords
        L14_2 = L14_2.x
      end
      L15_2 = L4_2 or L15_2
      if "y" ~= A0_2 or not L4_2 then
        L15_2 = L11_2.coords
        L15_2 = L15_2.y
      end
      L16_2 = L4_2 or L16_2
      if "z" ~= A0_2 or not L4_2 then
        L16_2 = L11_2.coords
        L16_2 = L16_2.z
      end
      L13_2 = L13_2(L14_2, L15_2, L16_2)
      L14_2 = Objects
      L14_2 = L14_2.Update
      L15_2 = L10_2
      L16_2 = L13_2
      L17_2 = L11_2.rot
      L14_2(L15_2, L16_2, L17_2)
      L14_2 = MEAutoSave
      if L14_2 then
        L14_2 = MEAutoSave
        L15_2 = L10_2
        L14_2(L15_2)
      end
      L14_2 = Objects
      L14_2 = L14_2.Get
      L15_2 = L10_2
      L14_2 = L14_2(L15_2)
      L15_2 = #L5_2
      L15_2 = L15_2 + 1
      L16_2 = {}
      L16_2.kind = "transform"
      L17_2 = Objects
      L17_2 = L17_2.UidOf
      L18_2 = L10_2
      L17_2 = L17_2(L18_2)
      L16_2.uid = L17_2
      L16_2.before = L12_2
      L17_2 = L4_1
      L18_2 = L14_2
      L17_2 = L17_2(L18_2)
      L16_2.after = L17_2
      L16_2.label = "Align"
      L5_2[L15_2] = L16_2
    end
  end
  L6_2 = History
  if L6_2 then
    L6_2 = #L5_2
    if L6_2 > 0 then
      L6_2 = History
      L6_2 = L6_2.Push
      L7_2 = Cmd
      L7_2 = L7_2.Batch
      L8_2 = locale
      L9_2 = "hist.align"
      L8_2 = L8_2(L9_2)
      L9_2 = L5_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2, L9_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    end
  end
  L6_2 = MELog
  if L6_2 then
    L6_2 = MELog
    L7_2 = "align"
    L8_2 = A0_2
    L9_2 = ":"
    L10_2 = A1_2
    L8_2 = L8_2 .. L9_2 .. L10_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = L2_1
  L6_2()
end
L5_1.Do = L6_1
L5_1 = Align
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = L1_1
  L1_2 = L1_2()
  L2_2 = #L1_2
  if L2_2 < 3 then
    L2_2 = Bridge
    L2_2 = L2_2.Notify
    L3_2 = locale
    L4_2 = "notify.distribute_need3"
    L3_2 = L3_2(L4_2)
    L4_2 = "error"
    L2_2(L3_2, L4_2)
    return
  end
  function L2_2(A0_3)
    local L1_3, L2_3
    L1_3 = Objects
    L1_3 = L1_3.Get
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L2_3 = 0.0
      return L2_3
    end
    L2_3 = A0_2
    if "x" == L2_3 then
      L2_3 = L1_3.coords
      L2_3 = L2_3.x
      return L2_3
    else
      L2_3 = A0_2
      if "y" == L2_3 then
        L2_3 = L1_3.coords
        L2_3 = L2_3.y
        return L2_3
      else
        L2_3 = L1_3.coords
        L2_3 = L2_3.z
        return L2_3
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L1_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L2_2
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    L3_3 = L2_2
    L4_3 = A1_3
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  L3_2 = L2_2
  L4_2 = L1_2[1]
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2
  L5_2 = #L1_2
  L5_2 = L1_2[L5_2]
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2 - L3_2
  L6_2 = #L1_2
  L6_2 = L6_2 - 1
  L5_2 = L5_2 / L6_2
  L6_2 = {}
  L7_2 = 1
  L8_2 = #L1_2
  L9_2 = 1
  for L10_2 = L7_2, L8_2, L9_2 do
    L11_2 = L1_2[L10_2]
    L12_2 = Objects
    L12_2 = L12_2.Get
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L13_2 = L4_1
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      L14_2 = L10_2 - 1
      L14_2 = L5_2 * L14_2
      L14_2 = L3_2 + L14_2
      L15_2 = vector3
      L16_2 = L14_2 or L16_2
      if "x" ~= A0_2 or not L14_2 then
        L16_2 = L12_2.coords
        L16_2 = L16_2.x
      end
      L17_2 = L14_2 or L17_2
      if "y" ~= A0_2 or not L14_2 then
        L17_2 = L12_2.coords
        L17_2 = L17_2.y
      end
      L18_2 = L14_2 or L18_2
      if "z" ~= A0_2 or not L14_2 then
        L18_2 = L12_2.coords
        L18_2 = L18_2.z
      end
      L15_2 = L15_2(L16_2, L17_2, L18_2)
      L16_2 = Objects
      L16_2 = L16_2.Update
      L17_2 = L11_2
      L18_2 = L15_2
      L19_2 = L12_2.rot
      L16_2(L17_2, L18_2, L19_2)
      L16_2 = MEAutoSave
      if L16_2 then
        L16_2 = MEAutoSave
        L17_2 = L11_2
        L16_2(L17_2)
      end
      L16_2 = Objects
      L16_2 = L16_2.Get
      L17_2 = L11_2
      L16_2 = L16_2(L17_2)
      L17_2 = #L6_2
      L17_2 = L17_2 + 1
      L18_2 = {}
      L18_2.kind = "transform"
      L19_2 = Objects
      L19_2 = L19_2.UidOf
      L20_2 = L11_2
      L19_2 = L19_2(L20_2)
      L18_2.uid = L19_2
      L18_2.before = L13_2
      L19_2 = L4_1
      L20_2 = L16_2
      L19_2 = L19_2(L20_2)
      L18_2.after = L19_2
      L18_2.label = "Distribute"
      L6_2[L17_2] = L18_2
    end
  end
  L7_2 = History
  if L7_2 then
    L7_2 = #L6_2
    if L7_2 > 0 then
      L7_2 = History
      L7_2 = L7_2.Push
      L8_2 = Cmd
      L8_2 = L8_2.Batch
      L9_2 = locale
      L10_2 = "hist.distribute"
      L9_2 = L9_2(L10_2)
      L10_2 = L6_2
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L8_2(L9_2, L10_2)
      L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    end
  end
  L7_2 = MELog
  if L7_2 then
    L7_2 = MELog
    L8_2 = "distribute"
    L9_2 = A0_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = L2_1
  L7_2()
end
L5_1.Distribute = L6_1
L5_1 = Align
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L1_2 = L1_1
  L1_2 = L1_2()
  L2_2 = #L1_2
  if L2_2 < 1 then
    L2_2 = Bridge
    L2_2 = L2_2.Notify
    L3_2 = locale
    L4_2 = "notify.mirror_need1"
    L3_2 = L3_2(L4_2)
    L4_2 = "error"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L3_1
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "x+" == A0_2 or "x-" == A0_2 then
    L3_2 = "x"
    if L3_2 then
      goto lbl_25
    end
  end
  L3_2 = "y"
  ::lbl_25::
  if "x+" == A0_2 then
    L4_2 = L2_2.maxx
    if L4_2 then
      goto lbl_41
    end
  end
  if "x-" == A0_2 then
    L4_2 = L2_2.minx
    if L4_2 then
      goto lbl_41
    end
  end
  if "y+" == A0_2 then
    L4_2 = L2_2.maxy
    if L4_2 then
      goto lbl_41
    end
  end
  L4_2 = L2_2.miny
  ::lbl_41::
  L5_2 = {}
  L6_2 = 1
  L7_2 = #L1_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = L1_2[L9_2]
    L11_2 = Objects
    L11_2 = L11_2.Get
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = Objects
      L12_2 = L12_2.Snapshot
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      L13_2 = L11_2.coords
      L13_2 = L13_2.x
      L14_2 = L11_2.coords
      L14_2 = L14_2.y
      L15_2 = L11_2.coords
      L15_2 = L15_2.z
      L16_2 = L11_2.rot
      L16_2 = L16_2.z
      if "x" == L3_2 then
        L17_2 = 2.0 * L4_2
        L18_2 = L11_2.coords
        L18_2 = L18_2.x
        L13_2 = L17_2 - L18_2
        L17_2 = L11_2.rot
        L17_2 = L17_2.z
        L16_2 = -L17_2
      else
        L17_2 = 2.0 * L4_2
        L18_2 = L11_2.coords
        L18_2 = L18_2.y
        L14_2 = L17_2 - L18_2
        L17_2 = L11_2.rot
        L17_2 = L17_2.z
        L18_2 = 180.0
        L16_2 = L18_2 - L17_2
      end
      L17_2 = {}
      L18_2 = pairs
      L19_2 = L11_2.props
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L17_2[L22_2] = L23_2
      end
      L18_2 = Objects
      L18_2 = L18_2.Spawn
      L19_2 = L11_2.model
      L20_2 = vector3
      L21_2 = L13_2
      L22_2 = L14_2
      L23_2 = L15_2
      L20_2 = L20_2(L21_2, L22_2, L23_2)
      L21_2 = vector3
      L22_2 = L11_2.rot
      L22_2 = L22_2.x
      L23_2 = L11_2.rot
      L23_2 = L23_2.y
      L24_2 = L16_2
      L21_2 = L21_2(L22_2, L23_2, L24_2)
      L22_2 = L17_2
      L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
      if L18_2 then
        L19_2 = L12_2.layer
        if L19_2 then
          L19_2 = L12_2.layer
          if "Default" ~= L19_2 then
            L19_2 = Objects
            L19_2 = L19_2.SetObjectLayer
            L20_2 = L18_2
            L21_2 = L12_2.layer
            L19_2(L20_2, L21_2)
          end
        end
        L19_2 = L12_2.blip
        if L19_2 then
          L19_2 = L12_2.blip
          L19_2 = L19_2.on
          if L19_2 then
            L19_2 = Objects
            L19_2 = L19_2.SetBlip
            L20_2 = L18_2
            L21_2 = L12_2.blip
            L21_2 = L21_2.name
            L22_2 = L12_2.blip
            L22_2 = L22_2.color
            L23_2 = L12_2.blip
            L23_2 = L23_2.on
            L19_2(L20_2, L21_2, L22_2, L23_2)
          end
        end
        L19_2 = MEAutoSave
        if L19_2 then
          L19_2 = MEAutoSave
          L20_2 = L18_2
          L19_2(L20_2)
        end
        L19_2 = #L5_2
        L19_2 = L19_2 + 1
        L20_2 = {}
        L20_2.kind = "add"
        L21_2 = Objects
        L21_2 = L21_2.Snapshot
        L22_2 = L18_2
        L21_2 = L21_2(L22_2)
        L20_2.snapshot = L21_2
        L20_2.label = "Place"
        L5_2[L19_2] = L20_2
      end
    end
  end
  L6_2 = History
  if L6_2 then
    L6_2 = #L5_2
    if L6_2 > 0 then
      L6_2 = History
      L6_2 = L6_2.Push
      L7_2 = Cmd
      L7_2 = L7_2.Batch
      L8_2 = locale
      L9_2 = "hist.mirror"
      L8_2 = L8_2(L9_2)
      L9_2 = L5_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L7_2(L8_2, L9_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    end
  end
  L6_2 = MELog
  if L6_2 then
    L6_2 = MELog
    L7_2 = "mirror"
    L8_2 = A0_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = Bridge
  L6_2 = L6_2.Notify
  L7_2 = locale
  L8_2 = "notify.mirrored"
  L9_2 = #L5_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = "success"
  L6_2(L7_2, L8_2)
  L6_2 = L2_1
  L6_2()
end
L5_1.Mirror = L6_1
L5_1 = Align
function L6_1(A0_2)
  local L1_2
  if nil == A0_2 then
    L1_2 = L0_1
    L1_2 = not L1_2
    L0_1 = L1_2
  else
    L1_2 = true == A0_2
    L0_1 = L1_2
  end
  L1_2 = L2_1
  L1_2()
  L1_2 = L0_1
  return L1_2
end
L5_1.Toggle = L6_1
