local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
L0_1 = {}
Clipboard = L0_1
L0_1 = nil
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
  L1_2.action = "clipboard"
  L2_2 = {}
  L3_2 = L0_1
  L3_2 = nil ~= L3_2
  L2_2.has = L3_2
  L3_2 = L0_1
  if L3_2 then
    L3_2 = L0_1.entries
    L3_2 = #L3_2
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = 0
  ::lbl_21::
  L2_2.count = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L3_1 = Clipboard
function L4_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L0_2 = nil ~= L0_2
  return L0_2
end
L3_1.HasContent = L4_1
L3_1 = Clipboard
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L1_1
  L0_2 = L0_2()
  L1_2 = #L0_2
  if 0 == L1_2 then
    L1_2 = Bridge
    L1_2 = L1_2.Notify
    L2_2 = locale
    L3_2 = "notify.copy_none"
    L2_2 = L2_2(L3_2)
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = Objects
  L1_2 = L1_2.CaptureGroup
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L0_1 = L1_2
  L1_2 = L0_1
  if not L1_2 then
    L1_2 = Bridge
    L1_2 = L1_2.Notify
    L2_2 = locale
    L3_2 = "notify.copy_fail"
    L2_2 = L2_2(L3_2)
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = MELog
  if L1_2 then
    L1_2 = MELog
    L2_2 = "copy"
    L3_2 = tostring
    L4_2 = L0_1.entries
    L4_2 = #L4_2
    L3_2, L4_2 = L3_2(L4_2)
    L1_2(L2_2, L3_2, L4_2)
  end
  L1_2 = Bridge
  L1_2 = L1_2.Notify
  L2_2 = locale
  L3_2 = "notify.copied"
  L4_2 = L0_1.entries
  L4_2 = #L4_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = "success"
  L1_2(L2_2, L3_2)
  L1_2 = L2_1
  L1_2()
end
L3_1.Copy = L4_1
function L3_1()
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
L4_1 = Clipboard
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L0_1
  if not L0_2 then
    L0_2 = Bridge
    L0_2 = L0_2.Notify
    L1_2 = locale
    L2_2 = "notify.clipboard_empty"
    L1_2 = L1_2(L2_2)
    L2_2 = "warning"
    L0_2(L1_2, L2_2)
    return
  end
  L0_2 = Objects
  L0_2 = L0_2.PlaceGroup
  L1_2 = L0_1
  L2_2 = L3_1
  L2_2 = L2_2()
  L3_2 = 0.0
  L0_2 = L0_2(L1_2, L2_2, L3_2)
  L1_2 = #L0_2
  if 0 == L1_2 then
    return
  end
  L1_2 = History
  if L1_2 then
    L1_2 = {}
    L2_2 = 1
    L3_2 = #L0_2
    L4_2 = 1
    for L5_2 = L2_2, L3_2, L4_2 do
      L6_2 = #L1_2
      L6_2 = L6_2 + 1
      L7_2 = {}
      L7_2.kind = "add"
      L8_2 = Objects
      L8_2 = L8_2.Snapshot
      L9_2 = L0_2[L5_2]
      L8_2 = L8_2(L9_2)
      L7_2.snapshot = L8_2
      L7_2.label = "Place"
      L1_2[L6_2] = L7_2
    end
    L2_2 = History
    L2_2 = L2_2.Push
    L3_2 = Cmd
    L3_2 = L3_2.Batch
    L4_2 = locale
    L5_2 = "hist.paste"
    L4_2 = L4_2(L5_2)
    L5_2 = L1_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2(L4_2, L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  L1_2 = #L0_2
  if 1 == L1_2 then
    L1_2 = Gizmo
    L1_2 = L1_2.Select
    if L1_2 then
      L1_2 = Gizmo
      L1_2 = L1_2.Select
      L2_2 = L0_2[1]
      L1_2(L2_2)
    end
  end
  L1_2 = MELog
  if L1_2 then
    L1_2 = MELog
    L2_2 = "paste"
    L3_2 = tostring
    L4_2 = #L0_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2(L4_2)
    L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  L1_2 = Bridge
  L1_2 = L1_2.Notify
  L2_2 = locale
  L3_2 = "notify.pasted"
  L4_2 = #L0_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = "success"
  L1_2(L2_2, L3_2)
end
L4_1.Paste = L5_1
