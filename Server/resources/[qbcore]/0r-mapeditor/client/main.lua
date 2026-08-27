local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1
L0_1 = false
L1_1 = false
L2_1 = false
L3_1 = 0
L4_1 = false
L5_1 = false
L6_1 = false
L7_1 = nil
function L8_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = GetNameOfZone
  L4_2 = A0_2 + 0.0
  L5_2 = A1_2 + 0.0
  L6_2 = A2_2 + 0.0
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 or "" == L3_2 then
    L4_2 = "Unknown"
    return L4_2
  end
  L4_2 = GetLabelText
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 or "" == L4_2 or "NULL" == L4_2 then
    return L3_2
  end
  return L4_2
end
function L9_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
IsEditorUiHovered = L9_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = TriggerServerEvent
  L3_2 = "0r-mapeditor:log"
  L4_2 = A0_2
  L5_2 = tostring
  L6_2 = A1_2 or L6_2
  if not A1_2 then
    L6_2 = ""
  end
  L5_2, L6_2 = L5_2(L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
MELog = L9_1
L9_1 = {}
L10_1 = 0
function L11_1(A0_2)
  local L1_2
  if not A0_2 then
    return
  end
  L1_2 = L9_1
  L1_2[A0_2] = true
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L10_1 = L1_2
end
MEAutoSave = L11_1
L11_1 = CreateThread
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = next
    L1_2 = L9_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = GetGameTimer
      L0_2 = L0_2()
      L1_2 = L10_1
      L0_2 = L0_2 - L1_2
      L1_2 = 600
      if L0_2 > L1_2 then
        L0_2 = L9_1
        L1_2 = {}
        L9_1 = L1_2
        L1_2 = pairs
        L2_2 = L0_2
        L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
        for L5_2 in L1_2, L2_2, L3_2, L4_2 do
          L6_2 = Objects
          L6_2 = L6_2.Get
          L7_2 = L5_2
          L6_2 = L6_2(L7_2)
          if L6_2 then
            L6_2 = Maps
            L6_2 = L6_2.SaveObject
            L7_2 = L5_2
            L6_2(L7_2)
          end
        end
      end
    end
    L0_2 = Wait
    L1_2 = 300
    L0_2(L1_2)
  end
end
L11_1(L12_1)
function L11_1()
  local L0_2, L1_2
  L0_2 = {}
  L9_1 = L0_2
end
MEAutoSaveReset = L11_1
L11_1 = {}
function L12_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1
  if L1_2 then
    L1_2 = A0_2 or L1_2
    if not A0_2 then
      L1_2 = "objects"
    end
    L2_2 = L11_1
    L2_2[L1_2] = true
  end
end
MEDockDirty = L12_1
L12_1 = CreateThread
function L13_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  while true do
    L0_2 = next
    L1_2 = L11_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = L11_1
      L1_2 = {}
      L11_1 = L1_2
      L1_2 = Objects
      if L1_2 then
        L1_2 = Objects
        L1_2 = L1_2.Count
        if L1_2 then
          L1_2 = Objects
          L1_2 = L1_2.Count
          L1_2 = L1_2()
          if L1_2 then
            goto lbl_23
          end
        end
      end
      L1_2 = 0
      ::lbl_23::
      L2_2 = WorldProps
      if L2_2 then
        L2_2 = WorldProps
        L2_2 = L2_2.GetHidden
        if L2_2 then
          L2_2 = WorldProps
          L2_2 = L2_2.GetHidden
          L2_2 = L2_2()
          if L2_2 then
            goto lbl_37
          end
        end
      end
      L2_2 = {}
      ::lbl_37::
      L2_2 = #L2_2
      L3_2 = Objects
      if L3_2 then
        L3_2 = Objects
        L3_2 = L3_2.DeletedCount
        if L3_2 then
          L3_2 = Objects
          L3_2 = L3_2.DeletedCount
          L3_2 = L3_2()
          if L3_2 then
            goto lbl_51
          end
        end
      end
      L3_2 = 0
      ::lbl_51::
      L4_2 = pairs
      L5_2 = L0_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2 in L4_2, L5_2, L6_2, L7_2 do
        L9_2 = SendNUIMessage
        L10_2 = {}
        L10_2.action = "dockRefresh"
        L11_2 = {}
        L11_2.kind = L8_2
        L11_2.created = L1_2
        L11_2.hidden = L2_2
        L11_2.deletedObjs = L3_2
        L10_2.data = L11_2
        L9_2(L10_2)
      end
    end
    L0_2 = Wait
    L1_2 = 300
    L0_2(L1_2)
  end
end
L12_1(L13_1)
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = 1
  L5_2 = #A0_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = Objects
    L8_2 = L8_2.Snapshot
    L9_2 = A0_2[L7_2]
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L10_2 = {}
      L10_2.kind = "delete"
      L10_2.snapshot = L8_2
      L10_2.skipDb = true
      L10_2.label = "Delete"
      L2_2[L9_2] = L10_2
      L9_2 = L8_2.dbId
      if L9_2 then
        L9_2 = #L3_2
        L9_2 = L9_2 + 1
        L10_2 = L8_2.dbId
        L3_2[L9_2] = L10_2
      end
      L9_2 = Objects
      L9_2 = L9_2.Remove
      L10_2 = A0_2[L7_2]
      L11_2 = true
      L9_2(L10_2, L11_2)
    end
  end
  L4_2 = #L3_2
  if L4_2 > 0 then
    L4_2 = TriggerServerEvent
    L5_2 = "0r-mapeditor:deleteObjects"
    L6_2 = {}
    L6_2.dbIds = L3_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = History
  if L4_2 then
    L4_2 = #L2_2
    if L4_2 > 0 then
      L4_2 = History
      L4_2 = L4_2.Push
      L5_2 = Cmd
      L5_2 = L5_2.Batch
      L6_2 = A1_2 or L6_2
      if not A1_2 then
        L6_2 = locale
        L7_2 = "hist.delete"
        L6_2 = L6_2(L7_2)
      end
      L7_2 = L2_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2)
      L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    end
  end
end
MEDeleteBatch = L12_1
function L12_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Gizmo
  L0_2 = L0_2.Target
  L0_2 = L0_2()
  if L0_2 then
    L1_2 = Objects
    L1_2 = L1_2.Get
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = SendNUIMessage
      L2_2 = {}
      L2_2.action = "reselect"
      L3_2 = Gizmo
      L3_2 = L3_2.Info
      L3_2 = L3_2()
      L2_2.data = L3_2
      L1_2(L2_2)
  end
  elseif L0_2 then
    L1_2 = Gizmo
    L1_2 = L1_2.Deselect
    L1_2()
  end
end
refreshSelectionAfterHistory = L12_1
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L7_1
  if L0_2 then
    L0_2 = L7_1
    return L0_2
  end
  L0_2 = LoadResourceFile
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  L2_2 = "data/props.json"
  L0_2 = L0_2(L1_2, L2_2)
  if L0_2 then
    L1_2 = json
    L1_2 = L1_2.decode
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_24
    end
  end
  L1_2 = {}
  L2_2 = {}
  L1_2.props = L2_2
  ::lbl_24::
  L7_1 = L1_2
  L1_2 = L7_1.props
  if not L1_2 then
    L1_2 = {}
  end
  L7_1.props = L1_2
  L1_2 = 1
  L2_2 = Config
  L2_2 = L2_2.customProps
  if not L2_2 then
    L2_2 = {}
  end
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = Config
    L5_2 = L5_2.customProps
    L5_2 = L5_2[L4_2]
    if L5_2 then
      L6_2 = L5_2.model
      if L6_2 then
        L6_2 = L7_1.props
        L7_2 = L7_1.props
        L7_2 = #L7_2
        L7_2 = L7_2 + 1
        L8_2 = {}
        L9_2 = L5_2.model
        L8_2.model = L9_2
        L9_2 = L5_2.label
        if not L9_2 then
          L9_2 = L5_2.model
        end
        L8_2.label = L9_2
        L9_2 = L5_2.category
        if not L9_2 then
          L9_2 = "misc"
        end
        L8_2.category = L9_2
        L9_2 = L5_2.sub
        L8_2.sub = L9_2
        L6_2[L7_2] = L8_2
      end
    end
  end
  L1_2 = L7_1
  return L1_2
end
function L13_1(A0_2)
  local L1_2, L2_2
  L1_2 = Objects
  L1_2 = L1_2.IdByHandle
  L2_2 = A0_2
  return L1_2(L2_2)
end
L14_1 = {}
L15_1 = 0
L16_1 = nil
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2
  L0_2 = GetNuiCursorPosition
  L0_2, L1_2 = L0_2()
  if not L0_2 or L0_2 < 0 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = GetActualScreenResolution
  L2_2, L3_2 = L2_2()
  if not L2_2 or 0 == L2_2 then
    L4_2 = GetActiveScreenResolution
    L4_2, L5_2 = L4_2()
    L3_2 = L5_2
    L2_2 = L4_2
  end
  if not L2_2 or 0 == L2_2 then
    L4_2 = 1920
    L3_2 = 1080
    L2_2 = L4_2
  end
  L4_2 = Camera
  L4_2 = L4_2.GetCoords
  L4_2 = L4_2()
  L5_2 = nil
  L6_2 = 1.0E18
  L7_2 = pairs
  L8_2 = Objects
  L8_2 = L8_2.All
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2 = L8_2()
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = DoesEntityExist
    L14_2 = L12_2.handle
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L13_2 = World3dToScreen2d
      L14_2 = L12_2.coords
      L14_2 = L14_2.x
      L15_2 = L12_2.coords
      L15_2 = L15_2.y
      L16_2 = L12_2.coords
      L16_2 = L16_2.z
      L13_2, L14_2, L15_2 = L13_2(L14_2, L15_2, L16_2)
      if L13_2 then
        L16_2 = math
        L16_2 = L16_2.abs
        L17_2 = L14_2 * L2_2
        L17_2 = L17_2 - L0_2
        L16_2 = L16_2(L17_2)
        L17_2 = 900.0
        if L16_2 < L17_2 then
          L16_2 = math
          L16_2 = L16_2.abs
          L17_2 = L15_2 * L3_2
          L17_2 = L17_2 - L1_2
          L16_2 = L16_2(L17_2)
          L17_2 = 900.0
          if L16_2 < L17_2 then
            L16_2 = GetEntityModel
            L17_2 = L12_2.handle
            L16_2 = L16_2(L17_2)
            L17_2 = L14_1
            L17_2 = L17_2[L16_2]
            if not L17_2 and 0 ~= L16_2 then
              L18_2 = IsModelValid
              L19_2 = L16_2
              L18_2 = L18_2(L19_2)
              if L18_2 then
                L18_2 = pcall
                L19_2 = GetModelDimensions
                L20_2 = L16_2
                L18_2, L19_2, L20_2 = L18_2(L19_2, L20_2)
                if L18_2 and L19_2 and L20_2 then
                  L21_2 = {}
                  L22_2 = L19_2
                  L23_2 = L20_2
                  L21_2[1] = L22_2
                  L21_2[2] = L23_2
                  L17_2 = L21_2
                  L21_2 = L14_1
                  L21_2[L16_2] = L17_2
                end
              end
            end
            L18_2 = L17_2 or L18_2
            if L17_2 then
              L18_2 = L17_2[1]
            end
            L19_2 = L17_2 or L19_2
            if L17_2 then
              L19_2 = L17_2[2]
            end
            if L18_2 and L19_2 then
              L20_2 = 1.0E9
              L21_2 = 1.0E9
              L22_2 = -1.0E9
              L23_2 = -1.0E9
              L24_2 = false
              L25_2 = 0
              L26_2 = 1
              L27_2 = 1
              for L28_2 = L25_2, L26_2, L27_2 do
                L29_2 = 0
                L30_2 = 1
                L31_2 = 1
                for L32_2 = L29_2, L30_2, L31_2 do
                  L33_2 = 0
                  L34_2 = 1
                  L35_2 = 1
                  for L36_2 = L33_2, L34_2, L35_2 do
                    L37_2 = GetOffsetFromEntityInWorldCoords
                    L38_2 = L12_2.handle
                    if 0 == L28_2 then
                      L39_2 = L18_2.x
                      if L39_2 then
                        goto lbl_139
                      end
                    end
                    L39_2 = L19_2.x
                    ::lbl_139::
                    if 0 == L32_2 then
                      L40_2 = L18_2.y
                      if L40_2 then
                        goto lbl_145
                      end
                    end
                    L40_2 = L19_2.y
                    ::lbl_145::
                    if 0 == L36_2 then
                      L41_2 = L18_2.z
                      if L41_2 then
                        goto lbl_151
                      end
                    end
                    L41_2 = L19_2.z
                    ::lbl_151::
                    L37_2 = L37_2(L38_2, L39_2, L40_2, L41_2)
                    L38_2 = World3dToScreen2d
                    L39_2 = L37_2.x
                    L40_2 = L37_2.y
                    L41_2 = L37_2.z
                    L38_2, L39_2, L40_2 = L38_2(L39_2, L40_2, L41_2)
                    if L38_2 then
                      L41_2 = L39_2 * L2_2
                      L42_2 = L40_2 * L3_2
                      if L20_2 > L41_2 then
                        L20_2 = L41_2
                      end
                      if L22_2 < L41_2 then
                        L22_2 = L41_2
                      end
                      if L21_2 > L42_2 then
                        L21_2 = L42_2
                      end
                      if L23_2 < L42_2 then
                        L23_2 = L42_2
                      end
                      L24_2 = true
                    end
                  end
                end
              end
              if L24_2 and L0_2 >= L20_2 and L0_2 <= L22_2 and L1_2 >= L21_2 and L1_2 <= L23_2 then
                L25_2 = L12_2.coords
                L25_2 = L25_2 - L4_2
                L25_2 = #L25_2
                if L6_2 > L25_2 then
                  L26_2 = L25_2
                  L5_2 = L11_2
                  L6_2 = L26_2
                end
              end
            end
          end
        end
      end
    end
  end
  return L5_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L0_1
  if L0_2 then
    return
  end
  L0_2 = true
  L0_1 = L0_2
  L0_2 = false
  L6_1 = L0_2
  L0_2 = false
  L2_1 = L0_2
  L0_2 = 0
  L3_1 = L0_2
  L0_2 = false
  L4_1 = L0_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = SetEntityInvincible
  L2_2 = L0_2
  L3_2 = true
  L1_2(L2_2, L3_2)
  L1_2 = SetEntityHealth
  L2_2 = L0_2
  L3_2 = GetEntityMaxHealth
  L4_2 = L0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2(L4_2)
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L1_2 = SetNuiFocus
  L2_2 = true
  L3_2 = true
  L1_2(L2_2, L3_2)
  L1_2 = SetNuiFocusKeepInput
  L2_2 = true
  L1_2(L2_2)
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "open"
  L3_2 = {}
  L4_2 = {}
  L5_2 = Config
  L5_2 = L5_2.categories
  L4_2.categories = L5_2
  L5_2 = Config
  L5_2 = L5_2.snap
  L4_2.snap = L5_2
  L5_2 = Config
  L5_2 = L5_2.keybind
  L4_2.keybind = L5_2
  L5_2 = Config
  L5_2 = L5_2.map
  L4_2.map = L5_2
  L3_2.config = L4_2
  L4_2 = L12_1
  L4_2 = L4_2()
  L3_2.props = L4_2
  L4_2 = Objects
  L4_2 = L4_2.Count
  L4_2 = L4_2()
  L3_2.created = L4_2
  L4_2 = WorldProps
  if L4_2 then
    L4_2 = WorldProps
    L4_2 = L4_2.GetHidden
    L4_2 = L4_2()
    if L4_2 then
      goto lbl_72
    end
  end
  L4_2 = {}
  ::lbl_72::
  L4_2 = #L4_2
  L3_2.hidden = L4_2
  L4_2 = GetLocaleTable
  L4_2 = L4_2()
  L3_2.locale = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
  L1_2 = Objects
  L1_2 = L1_2.ShowBlips
  L2_2 = true
  L1_2(L2_2)
  L1_2 = ipairs
  L2_2 = GetGamePool
  L3_2 = "CObject"
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2)
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = Entity
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L7_2 = L7_2.state
    L8_2 = L7_2 or L8_2
    if L7_2 then
      L8_2 = L7_2["0rme"]
    end
    if L8_2 then
      L9_2 = L8_2.model
      if L9_2 then
        L9_2 = Objects
        L9_2 = L9_2.IdByHandle
        L10_2 = L6_2
        L9_2 = L9_2(L10_2)
        if not L9_2 then
          L9_2 = Objects
          L9_2 = L9_2.Adopt
          L10_2 = L6_2
          L11_2 = L8_2
          L9_2(L10_2, L11_2)
        end
      end
    end
  end
  L1_2 = MEDockDirty
  if L1_2 then
    L1_2 = MEDockDirty
    L2_2 = "objects"
    L1_2(L2_2)
  end
  L1_2 = Maps
  L1_2 = L1_2.RequestList
  L1_2()
  L1_2 = Lights
  if L1_2 then
    L1_2 = Lights
    L1_2 = L1_2.SetActive
    L2_2 = true
    L1_2(L2_2)
  end
  L1_2 = History
  if L1_2 then
    L1_2 = History
    L1_2 = L1_2.Sync
    L1_2()
  end
  L1_2 = Camera
  L1_2 = L1_2.Start
  L1_2()
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "freecam"
  L3_2 = {}
  L3_2.on = true
  L2_2.data = L3_2
  L1_2(L2_2)
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "bigmap"
  L3_2 = {}
  L4_2 = L3_1
  L3_2.mode = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
end
function L19_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L0_1 = L0_2
  L0_2 = false
  L5_1 = L0_2
  L0_2 = false
  L6_1 = L0_2
  L0_2 = false
  L2_1 = L0_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = SetEntityInvincible
  L2_2 = L0_2
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = FreezeEntityPosition
  L2_2 = L0_2
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = Placement
  L1_2 = L1_2.Stop
  L1_2()
  L1_2 = Gizmo
  L1_2 = L1_2.Deselect
  L1_2()
  L1_2 = Bulk
  L1_2 = L1_2.Toggle
  L2_2 = false
  L1_2(L2_2)
  L1_2 = WorldProps
  L1_2 = L1_2.Toggle
  L2_2 = false
  L1_2(L2_2)
  L1_2 = Preview
  L1_2 = L1_2.Stop
  L1_2()
  L1_2 = Brush
  L1_2 = L1_2.Stop
  L1_2()
  L1_2 = Fill
  L1_2 = L1_2.Toggle
  L2_2 = false
  L1_2(L2_2)
  L1_2 = Lights
  L1_2 = L1_2.Toggle
  L2_2 = false
  L1_2(L2_2)
  L1_2 = AreaDelete
  L1_2 = L1_2.Toggle
  L2_2 = false
  L1_2(L2_2)
  L1_2 = Array
  if L1_2 then
    L1_2 = Array
    L1_2 = L1_2.Cancel
    L1_2()
  end
  L1_2 = Align
  if L1_2 then
    L1_2 = Align
    L1_2 = L1_2.Toggle
    L2_2 = false
    L1_2(L2_2)
  end
  L1_2 = Prefab
  if L1_2 then
    L1_2 = Prefab
    L1_2 = L1_2.Cancel
    L1_2()
  end
  L1_2 = Camera
  L1_2 = L1_2.Stop
  L1_2()
  L1_2 = 0
  L3_1 = L1_2
  L1_2 = SetBigmapActive
  L2_2 = false
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = DisplayRadar
  L2_2 = true
  L1_2(L2_2)
  L1_2 = SetNuiFocusKeepInput
  L2_2 = false
  L1_2(L2_2)
  L1_2 = SetNuiFocus
  L2_2 = false
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "close"
  L1_2(L2_2)
  TriggerEvent("0r-mapeditor:editorClosed")
  L1_2 = true
  L4_1 = L1_2
end
L20_1 = CreateThread
function L21_1()
  local L0_2, L1_2
  while true do
    L0_2 = L4_1
    if L0_2 then
      L0_2 = L0_1
      if not L0_2 then
        L0_2 = Objects
        if L0_2 then
          L0_2 = Objects
          L0_2 = L0_2.Count
          if L0_2 then
            L0_2 = Objects
            L0_2 = L0_2.Count
            L0_2 = L0_2()
            if L0_2 > 0 then
              L0_2 = DisplayRadar
              L1_2 = true
              L0_2(L1_2)
              L0_2 = Wait
              L1_2 = 0
              L0_2(L1_2)
          end
        end
      end
    end
    else
      L0_2 = Wait
      L1_2 = 500
      L0_2(L1_2)
    end
  end
end
L20_1(L21_1)
L20_1 = RegisterNetEvent
L21_1 = "0r-mapeditor:openGranted"
function L22_1()
  local L0_2, L1_2
  L0_2 = L18_1
  L0_2()
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "0r-mapeditor:logs"
function L22_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "logs"
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = {}
  end
  L2_2.data = L3_2
  L1_2(L2_2)
end
L20_1(L21_1, L22_1)
L20_1 = nil
L21_1 = CreateThread
function L22_1()
  local L0_2, L1_2, L2_2, L3_2
  while true do
    L0_2 = L0_1
    if L0_2 then
      L0_2 = Config
      L0_2 = L0_2.freezeStatus
      if false ~= L0_2 then
        L0_2 = L20_1
        if nil == L0_2 then
          L0_2 = GetResourceState
          L1_2 = "es_extended"
          L0_2 = L0_2(L1_2)
          if "started" == L0_2 then
            L0_2 = "esx"
            L20_1 = L0_2
          else
            L0_2 = GetResourceState
            L1_2 = "qbx_core"
            L0_2 = L0_2(L1_2)
            if "started" ~= L0_2 then
              L0_2 = GetResourceState
              L1_2 = "qb-core"
              L0_2 = L0_2(L1_2)
              if "started" ~= L0_2 then
                goto lbl_32
              end
            end
            L0_2 = "qb"
            L20_1 = L0_2
            goto lbl_34
            ::lbl_32::
            L0_2 = false
            L20_1 = L0_2
          end
        end
        ::lbl_34::
        L0_2 = L20_1
        if "esx" == L0_2 then
          L0_2 = TriggerEvent
          L1_2 = "esx_status:set"
          L2_2 = "hunger"
          L3_2 = 1000000
          L0_2(L1_2, L2_2, L3_2)
          L0_2 = TriggerEvent
          L1_2 = "esx_status:set"
          L2_2 = "thirst"
          L3_2 = 1000000
          L0_2(L1_2, L2_2, L3_2)
        else
          L0_2 = L20_1
          if "qb" == L0_2 then
            L0_2 = TriggerServerEvent
            L1_2 = "QBCore:Server:SetMetaData"
            L2_2 = "hunger"
            L3_2 = 100
            L0_2(L1_2, L2_2, L3_2)
            L0_2 = TriggerServerEvent
            L1_2 = "QBCore:Server:SetMetaData"
            L2_2 = "thirst"
            L3_2 = 100
            L0_2(L1_2, L2_2, L3_2)
          end
        end
      end
    end
    L0_2 = Wait
    L1_2 = 3000
    L0_2(L1_2)
  end
end
L21_1(L22_1)
L21_1 = CreateThread
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L0_2 = PlayerId
  L0_2 = L0_2()
  L1_2 = 0
  while true do
    L2_2 = L0_1
    if L2_2 then
      L2_2 = DisablePlayerFiring
      L3_2 = L0_2
      L4_2 = true
      L2_2(L3_2, L4_2)
      L2_2 = DisableAllControlActions
      L3_2 = 0
      L2_2(L3_2)
      L2_2 = Camera
      L2_2 = L2_2.IsActive
      L2_2 = L2_2()
      if not L2_2 then
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 30
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 31
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 32
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 33
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 34
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 35
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 21
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
        L2_2 = EnableControlAction
        L3_2 = 0
        L4_2 = 22
        L5_2 = true
        L2_2(L3_2, L4_2, L5_2)
      end
      L2_2 = PlayerPedId
      L2_2 = L2_2()
      L3_2 = SetEntityInvincible
      L4_2 = L2_2
      L5_2 = true
      L3_2(L4_2, L5_2)
      L3_2 = SetEntityHealth
      L4_2 = L2_2
      L5_2 = GetEntityMaxHealth
      L6_2 = L2_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L5_2(L6_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      L3_2 = DisplayRadar
      L4_2 = L3_1
      L4_2 = 2 ~= L4_2
      L3_2(L4_2)
      L3_2 = L3_1
      if 1 == L3_2 then
        L3_2 = GetGameTimer
        L3_2 = L3_2()
        L3_2 = L3_2 - L1_2
        L4_2 = 500
        if L3_2 > L4_2 then
          L3_2 = SetBigmapActive
          L4_2 = true
          L5_2 = false
          L3_2(L4_2, L5_2)
          L3_2 = GetGameTimer
          L3_2 = L3_2()
          L1_2 = L3_2
        end
      end
      L3_2 = IsRawKeyDown
      L4_2 = 17
      L3_2 = L3_2(L4_2)
      if not L3_2 then
        L3_2 = IsRawKeyDown
        L4_2 = 162
        L3_2 = L3_2(L4_2)
        if not L3_2 then
          L3_2 = IsRawKeyDown
          L4_2 = 163
          L3_2 = L3_2(L4_2)
        end
      end
      L4_2 = History
      if L4_2 then
        L4_2 = L2_1
        if not L4_2 and L3_2 then
          L4_2 = IsRawKeyPressed
          L5_2 = 90
          L4_2 = L4_2(L5_2)
          if L4_2 then
            L4_2 = IsRawKeyDown
            L5_2 = 16
            L4_2 = L4_2(L5_2)
            if not L4_2 then
              L4_2 = IsRawKeyDown
              L5_2 = 160
              L4_2 = L4_2(L5_2)
              if not L4_2 then
                L4_2 = IsRawKeyDown
                L5_2 = 161
                L4_2 = L4_2(L5_2)
              end
            end
            if L4_2 then
              L5_2 = History
              L5_2 = L5_2.Redo
              L5_2()
            else
              L5_2 = History
              L5_2 = L5_2.Undo
              L5_2()
            end
            L5_2 = refreshSelectionAfterHistory
            L5_2()
          else
            L4_2 = IsRawKeyPressed
            L5_2 = 89
            L4_2 = L4_2(L5_2)
            if L4_2 then
              L4_2 = History
              L4_2 = L4_2.Redo
              L4_2()
              L4_2 = refreshSelectionAfterHistory
              L4_2()
            else
              L4_2 = IsRawKeyPressed
              L5_2 = 67
              L4_2 = L4_2(L5_2)
              if L4_2 then
                L4_2 = Clipboard
                if L4_2 then
                  L4_2 = Clipboard
                  L4_2 = L4_2.Copy
                  L4_2()
                end
              else
                L4_2 = IsRawKeyPressed
                L5_2 = 86
                L4_2 = L4_2(L5_2)
                if L4_2 then
                  L4_2 = Clipboard
                  if L4_2 then
                    L4_2 = Clipboard
                    L4_2 = L4_2.Paste
                    L4_2()
                  end
                end
              end
            end
          end
        end
      end
      L4_2 = L2_1
      if not L4_2 then
        L4_2 = IsRawKeyPressed
        L5_2 = 20
        L4_2 = L4_2(L5_2)
        if L4_2 then
          L4_2 = L5_1
          L4_2 = not L4_2
          L5_1 = L4_2
          L4_2 = SendNUIMessage
          L5_2 = {}
          L5_2.action = "toast"
          L6_2 = locale
          L7_2 = "toast.free_cursor"
          L8_2 = L5_1
          if L8_2 then
            L8_2 = locale
            L9_2 = "common.on"
            L8_2 = L8_2(L9_2)
            if L8_2 then
              goto lbl_208
            end
          end
          L8_2 = locale
          L9_2 = "common.off"
          L8_2 = L8_2(L9_2)
          ::lbl_208::
          L6_2 = L6_2(L7_2, L8_2)
          L5_2.data = L6_2
          L4_2(L5_2)
        end
      end
      L4_2 = Camera
      L4_2 = L4_2.IsActive
      L4_2 = L4_2()
      L5_2 = L5_1
      if not L5_2 then
        L5_2 = IsDisabledControlPressed
        L6_2 = 0
        L7_2 = 44
        L5_2 = L5_2(L6_2, L7_2)
        if not L5_2 and not L4_2 then
          L5_2 = EnableControlAction
          L6_2 = 0
          L7_2 = 1
          L8_2 = true
          L5_2(L6_2, L7_2, L8_2)
          L5_2 = EnableControlAction
          L6_2 = 0
          L7_2 = 2
          L8_2 = true
          L5_2(L6_2, L7_2, L8_2)
        end
      end
      L5_2 = L2_1
      if not L5_2 then
        L5_2 = IsRawKeyPressed
        L6_2 = 88
        L5_2 = L5_2(L6_2)
        if L5_2 then
          L5_2 = Gizmo
          L5_2 = L5_2.Deselect
          L5_2()
          L5_2 = Bulk
          L5_2 = L5_2.IsActive
          L5_2 = L5_2()
          if L5_2 then
            L5_2 = Bulk
            L5_2 = L5_2.Clear
            L5_2()
          end
        end
      end
      L5_2 = Placement
      L5_2 = L5_2.IsActive
      L5_2 = L5_2()
      if not L5_2 then
        L5_2 = L1_1
        if not L5_2 then
          L5_2 = Gizmo
          L5_2 = L5_2.IsGrabbing
          L5_2 = L5_2()
          if not L5_2 then
            L5_2 = Bulk
            L5_2 = L5_2.IsActive
            L5_2 = L5_2()
            if not L5_2 then
              L5_2 = WorldProps
              L5_2 = L5_2.IsActive
              L5_2 = L5_2()
              if not L5_2 then
                L5_2 = Brush
                L5_2 = L5_2.IsActive
                L5_2 = L5_2()
                if not L5_2 then
                  L5_2 = Fill
                  L5_2 = L5_2.IsActive
                  L5_2 = L5_2()
                  if not L5_2 then
                    L5_2 = Lights
                    L5_2 = L5_2.IsPlacing
                    L5_2 = L5_2()
                    if not L5_2 then
                      L5_2 = AreaDelete
                      L5_2 = L5_2.IsActive
                      L5_2 = L5_2()
                      if not L5_2 then
                        L5_2 = Prefab
                        if L5_2 then
                          L5_2 = Prefab
                          L5_2 = L5_2.IsActive
                          L5_2 = L5_2()
                          if L5_2 then
                            goto lbl_444
                          end
                        end
                        L5_2 = Array
                        if L5_2 then
                          L5_2 = Array
                          L5_2 = L5_2.IsActive
                          L5_2 = L5_2()
                          if L5_2 then
                            goto lbl_444
                          end
                        end
                        L5_2 = Align
                        if L5_2 then
                          L5_2 = Align
                          L5_2 = L5_2.IsActive
                          L5_2 = L5_2()
                          if L5_2 then
                            goto lbl_444
                          end
                        end
                        L5_2 = IsDisabledControlJustPressed
                        L6_2 = 0
                        L7_2 = 24
                        L5_2 = L5_2(L6_2, L7_2)
                        if L5_2 then
                          L5_2 = nil
                          L6_2 = Camera
                          L6_2 = L6_2.CursorRay
                          L6_2, L7_2 = L6_2()
                          L8_2 = Config
                          L8_2 = L8_2.placement
                          L8_2 = L8_2.maxRayDistance
                          L8_2 = L7_2 * L8_2
                          L8_2 = L6_2 + L8_2
                          L9_2 = _ENV
                          L10_2 = "StartExpensiveSynchronousShapeTestLosProbe"
                          L9_2 = L9_2[L10_2]
                          L10_2 = L6_2.x
                          L11_2 = L6_2.y
                          L12_2 = L6_2.z
                          L13_2 = L8_2.x
                          L14_2 = L8_2.y
                          L15_2 = L8_2.z
                          L16_2 = -1
                          L17_2 = PlayerPedId
                          L17_2 = L17_2()
                          L18_2 = 4
                          L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
                          L10_2 = GetShapeTestResult
                          L11_2 = L9_2
                          L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2)
                          if (true == L11_2 or 1 == L11_2) and L14_2 and 0 ~= L14_2 then
                            L15_2 = L13_1
                            L16_2 = L14_2
                            L15_2 = L15_2(L16_2)
                            L5_2 = L15_2
                          end
                          if not L5_2 then
                            L15_2 = L17_1
                            L15_2 = L15_2()
                            L5_2 = L15_2
                          end
                          L15_2 = Gizmo
                          L15_2 = L15_2.AxisHovered
                          L15_2 = L15_2()
                          if not L15_2 then
                            L15_2 = Gizmo
                            L15_2 = L15_2.IsAxisDragging
                            L15_2 = L15_2()
                          end
                          if not L15_2 then
                            if L5_2 then
                              L16_2 = Gizmo
                              L16_2 = L16_2.Select
                              L17_2 = L5_2
                              L16_2(L17_2)
                            else
                              L16_2 = Gizmo
                              L16_2 = L16_2.Deselect
                              L16_2()
                            end
                          end
                          if L5_2 then
                            L16_2 = Gizmo
                            L16_2 = L16_2.Target
                            L16_2 = L16_2()
                            if L5_2 == L16_2 then
                              L16_2 = GetGameTimer
                              L16_2 = L16_2()
                              L17_2 = L16_1
                              if L17_2 == L5_2 then
                                L17_2 = L15_1
                                L17_2 = L16_2 - L17_2
                                L18_2 = 400
                                if L17_2 < L18_2 then
                                  L17_2 = 0
                                  L18_2 = nil
                                  L16_1 = L18_2
                                  L15_1 = L17_2
                                  L17_2 = MEAxisSuppress
                                  if L17_2 then
                                    L17_2 = MEAxisSuppress
                                    L17_2()
                                  end
                                  L17_2 = Gizmo
                                  L17_2 = L17_2.AbortAxisDrag
                                  if L17_2 then
                                    L17_2 = Gizmo
                                    L17_2 = L17_2.AbortAxisDrag
                                    L17_2()
                                  end
                                  L17_2 = SendNUIMessage
                                  L18_2 = {}
                                  L18_2.action = "cardMode"
                                  L19_2 = {}
                                  L19_2.open = true
                                  L18_2.data = L19_2
                                  L17_2(L18_2)
                              end
                              else
                                L17_2 = L16_2
                                L16_1 = L5_2
                                L15_1 = L17_2
                              end
                          end
                          else
                            L16_2 = 0
                            L17_2 = nil
                            L16_1 = L17_2
                            L15_1 = L16_2
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      ::lbl_444::
      L5_2 = Bulk
      L5_2 = L5_2.IsActive
      L5_2 = L5_2()
      if L5_2 then
        L5_2 = L6_1
        if not L5_2 then
          L5_2 = Bulk
          L5_2 = L5_2.IsGrabbing
          L5_2 = L5_2()
          if not L5_2 then
            L5_2 = Gizmo
            L5_2 = L5_2.AxisHovered
            L5_2 = L5_2()
            if not L5_2 then
              L5_2 = Gizmo
              L5_2 = L5_2.IsAxisDragging
              L5_2 = L5_2()
              if not L5_2 then
                L5_2 = L1_1
                if not L5_2 then
                  L5_2 = IsDisabledControlJustPressed
                  L6_2 = 0
                  L7_2 = 24
                  L5_2 = L5_2(L6_2, L7_2)
                  if L5_2 then
                    L5_2 = Camera
                    L5_2 = L5_2.CursorRay
                    L5_2, L6_2 = L5_2()
                    L7_2 = Config
                    L7_2 = L7_2.placement
                    L7_2 = L7_2.maxRayDistance
                    L7_2 = L6_2 * L7_2
                    L7_2 = L5_2 + L7_2
                    L8_2 = _ENV
                    L9_2 = "StartExpensiveSynchronousShapeTestLosProbe"
                    L8_2 = L8_2[L9_2]
                    L9_2 = L5_2.x
                    L10_2 = L5_2.y
                    L11_2 = L5_2.z
                    L12_2 = L7_2.x
                    L13_2 = L7_2.y
                    L14_2 = L7_2.z
                    L15_2 = -1
                    L16_2 = PlayerPedId
                    L16_2 = L16_2()
                    L17_2 = 4
                    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
                    L9_2 = GetShapeTestResult
                    L10_2 = L8_2
                    L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2)
                    L14_2 = nil
                    if (true == L10_2 or 1 == L10_2) and L13_2 and 0 ~= L13_2 then
                      L15_2 = L13_1
                      L16_2 = L13_2
                      L15_2 = L15_2(L16_2)
                      L14_2 = L15_2
                    end
                    if not L14_2 then
                      L15_2 = L17_1
                      L15_2 = L15_2()
                      L14_2 = L15_2
                    end
                    if not L14_2 then
                      L15_2 = Bulk
                      L15_2 = L15_2.Clear
                      L15_2()
                    end
                  end
                end
              end
            end
          end
        end
      end
      L5_2 = Wait
      L6_2 = 0
      L5_2(L6_2)
    else
      L2_2 = Wait
      L3_2 = 200
      L2_2(L3_2)
    end
  end
end
L21_1(L22_1)
function L21_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L19_1
    L0_2()
  else
    L0_2 = TriggerServerEvent
    L1_2 = "0r-mapeditor:requestOpen"
    L0_2(L1_2)
  end
end
-- Seoul Base: a abertura principal do Prop Editor e exclusiva do AdminControl.
-- O comando /mapeditor e o key mapping F7 foram removidos de proposito.
L22_1 = RegisterNUICallback
L23_1 = "close"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L19_1
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "hover"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = A0_2.hover
    L2_2 = true == L2_2
  end
  L1_1 = L2_2
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "typing"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = A0_2.on
    L2_2 = true == L2_2
  end
  L2_1 = L2_2
  L2_2 = L0_1
  if L2_2 then
    L2_2 = SetNuiFocusKeepInput
    L3_2 = L2_1
    L3_2 = not L3_2
    L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "undo"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = History
  if L2_2 then
    L2_2 = History
    L2_2 = L2_2.Undo
    L2_2()
  end
  L2_2 = refreshSelectionAfterHistory
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "redo"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = History
  if L2_2 then
    L2_2 = History
    L2_2 = L2_2.Redo
    L2_2()
  end
  L2_2 = refreshSelectionAfterHistory
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "copy"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Clipboard
  L2_2 = L2_2.Copy
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
L22_1 = RegisterNUICallback
L23_1 = "paste"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Clipboard
  L2_2 = L2_2.Paste
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L22_1(L23_1, L24_1)
function L22_1(A0_2)
  local L1_2, L2_2, L3_2
  if "place" ~= A0_2 then
    L1_2 = Placement
    L1_2 = L1_2.Stop
    L1_2()
  end
  if "brush" ~= A0_2 then
    L1_2 = Brush
    L1_2 = L1_2.Stop
    L1_2()
  end
  if "fill" ~= A0_2 then
    L1_2 = Fill
    L1_2 = L1_2.Toggle
    L2_2 = false
    L1_2(L2_2)
  end
  if "lights" ~= A0_2 then
    L1_2 = Lights
    L1_2 = L1_2.Toggle
    L2_2 = false
    L1_2(L2_2)
  end
  if "area" ~= A0_2 then
    L1_2 = AreaDelete
    L1_2 = L1_2.Toggle
    L2_2 = false
    L1_2(L2_2)
  end
  if "world" ~= A0_2 then
    L1_2 = WorldProps
    L1_2 = L1_2.IsActive
    L1_2 = L1_2()
    if L1_2 then
      L1_2 = WorldProps
      L1_2 = L1_2.Toggle
      L2_2 = false
      L1_2(L2_2)
      L1_2 = SendNUIMessage
      L2_2 = {}
      L2_2.action = "worldDelete"
      L3_2 = {}
      L3_2.on = false
      L2_2.data = L3_2
      L1_2(L2_2)
    end
  end
  L1_2 = Array
  if L1_2 and "array" ~= A0_2 then
    L1_2 = Array
    L1_2 = L1_2.Cancel
    L1_2()
  end
  if "array" ~= A0_2 and "align" ~= A0_2 then
    L1_2 = Gizmo
    L1_2 = L1_2.Deselect
    L1_2()
  end
end
L23_1 = RegisterNUICallback
L24_1 = "arrayToggle"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "array"
      L2_2(L3_2)
      L2_2 = Array
      L2_2 = L2_2.Open
      L2_2 = L2_2()
      L3_2 = SendNUIMessage
      L4_2 = {}
      L4_2.action = "array"
      L5_2 = {}
      L5_2.active = L2_2
      L4_2.data = L5_2
      L3_2(L4_2)
  end
  else
    L2_2 = Array
    L2_2 = L2_2.Cancel
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "arrayPattern"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = Array
    L2_2 = L2_2.SetPattern
    L3_2 = A0_2.pattern
    L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "arrayParam"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = Array
    L2_2 = L2_2.SetParam
    L3_2 = A0_2.key
    L4_2 = A0_2.value
    L2_2(L3_2, L4_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "arrayApply"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Array
  L2_2 = L2_2.Apply
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "alignToggle"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "align"
      L2_2(L3_2)
    end
  end
  L2_2 = Align
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "alignDo"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = Align
    L2_2 = L2_2.Do
    L3_2 = A0_2.axis
    L4_2 = A0_2.mode
    L2_2(L3_2, L4_2)
    L2_2 = refreshSelectionAfterHistory
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "distributeDo"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = Align
    L2_2 = L2_2.Distribute
    L3_2 = A0_2.axis
    L2_2(L3_2)
    L2_2 = refreshSelectionAfterHistory
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "mirrorDo"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = Align
    L2_2 = L2_2.Mirror
    L3_2 = A0_2.dir
    L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getPrefabs"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Prefab
  L2_2 = L2_2.RequestList
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "savePrefab"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = A0_2.name
    if L2_2 then
      L2_2 = Prefab
      L2_2 = L2_2.SaveCurrent
      L3_2 = A0_2.name
      L4_2 = A0_2.category
      L2_2(L3_2, L4_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "placePrefab"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = A0_2.id
    if L2_2 then
      L2_2 = TriggerServerEvent
      L3_2 = "0r-mapeditor:getPrefab"
      L4_2 = A0_2.id
      L2_2(L3_2, L4_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "deletePrefab"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = A0_2.id
    if L2_2 then
      L2_2 = TriggerServerEvent
      L3_2 = "0r-mapeditor:deletePrefab"
      L4_2 = A0_2.id
      L2_2(L3_2, L4_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNetEvent
L24_1 = "0r-mapeditor:prefabList"
function L25_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "prefabList"
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = {}
  end
  L2_2.data = L3_2
  L1_2(L2_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "build"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Preview
  L2_2 = L2_2.Stop
  L2_2()
  L2_2 = Gizmo
  L2_2 = L2_2.Deselect
  L2_2()
  L2_2 = Fill
  L2_2 = L2_2.IsActive
  L2_2 = L2_2()
  if L2_2 then
    L2_2 = Fill
    L2_2 = L2_2.SetModel
    L3_2 = A0_2.model
    L2_2(L3_2)
  else
    L2_2 = Brush
    L2_2 = L2_2.IsActive
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = Brush
      L2_2 = L2_2.SetModel
      L3_2 = A0_2.model
      L2_2(L3_2)
    else
      L2_2 = L22_1
      L3_2 = "place"
      L2_2(L3_2)
      L2_2 = Placement
      L2_2 = L2_2.Start
      L3_2 = A0_2.model
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushToggle"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "brush"
      L2_2(L3_2)
      L2_2 = Brush
      L2_2 = L2_2.Start
      L3_2 = A0_2.model
      L2_2(L3_2)
  end
  else
    L2_2 = Brush
    L2_2 = L2_2.Stop
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushRadius"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Brush
  L2_2 = L2_2.SetRadius
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.r
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushDensity"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Brush
  L2_2 = L2_2.SetDensity
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.d
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushAlign"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Brush
  L2_2 = L2_2.SetAlign
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
    L3_2 = true == L3_2
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushYaw"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Brush
  L2_2 = L2_2.SetRandomYaw
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
    L3_2 = true == L3_2
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "brushScatter"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Brush
  L2_2 = L2_2.Scatter
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillToggle"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "fill"
      L2_2(L3_2)
    end
  end
  L2_2 = Fill
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L4_2 = A0_2 or L4_2
  if A0_2 then
    L4_2 = A0_2.model
  end
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillSpacing"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.SetSpacing
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.spacing
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillLayout"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.SetLayout
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.layout
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillHeading"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.SetHeading
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.heading
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillReselect"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.Reselect
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillFinish"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.Finish
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillUndo"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.Undo
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "fillDo"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Fill
  L2_2 = L2_2.DoFill
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "areaDelete"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "area"
      L2_2(L3_2)
    end
  end
  L2_2 = AreaDelete
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "lightToggle"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "lights"
      L2_2(L3_2)
    end
  end
  L2_2 = Lights
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "lightColor"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = Lights
    L2_2 = L2_2.SetColor
    L3_2 = A0_2.r
    L4_2 = A0_2.g
    L5_2 = A0_2.b
    L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "lightRange"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Lights
  L2_2 = L2_2.SetRange
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.range
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "lightIntensity"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Lights
  L2_2 = L2_2.SetIntensity
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.intensity
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "lightClear"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Lights
  L2_2 = L2_2.UserClear
  if L2_2 then
    L2_2 = Lights
    L2_2 = L2_2.UserClear
    L2_2()
  else
    L2_2 = Lights
    L2_2 = L2_2.Clear
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "removeLight"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.id
    if L2_2 then
      L2_2 = Lights
      L2_2 = L2_2.Remove
      L3_2 = A0_2.id
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getLayersFull"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = Objects
  L3_2 = L3_2.LayersFull
  L3_2 = L3_2()
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "addLayer"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Objects
  L2_2 = L2_2.AddLayer
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.name
  end
  L2_2(L3_2)
  L2_2 = MELog
  L3_2 = "layer_add"
  if A0_2 then
    L4_2 = A0_2.name
    if L4_2 then
      goto lbl_15
    end
  end
  L4_2 = ""
  ::lbl_15::
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "removeLayer"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Objects
  L2_2 = L2_2.RemoveLayer
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.name
  end
  L2_2(L3_2)
  L2_2 = MELog
  L3_2 = "layer_remove"
  if A0_2 then
    L4_2 = A0_2.name
    if L4_2 then
      goto lbl_15
    end
  end
  L4_2 = ""
  ::lbl_15::
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "setObjectLayer"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if A0_2 then
    L2_2 = A0_2.id
    if L2_2 then
      L2_2 = Objects
      L2_2 = L2_2.Get
      L3_2 = A0_2.id
      L2_2 = L2_2(L3_2)
    end
    if L2_2 then
      L3_2 = {}
      L4_2 = L2_2.layer
      if not L4_2 then
        L4_2 = "Default"
      end
      L3_2.layer = L4_2
      if L3_2 then
        goto lbl_22
      end
    end
    L3_2 = nil
    ::lbl_22::
    L4_2 = Objects
    L4_2 = L4_2.SetObjectLayer
    L5_2 = A0_2.id
    L6_2 = A0_2.name
    L4_2(L5_2, L6_2)
    L4_2 = A0_2.id
    if L4_2 then
      L4_2 = Objects
      L4_2 = L4_2.Get
      L5_2 = A0_2.id
      L4_2 = L4_2(L5_2)
    end
    L5_2 = History
    if L5_2 and L3_2 and L4_2 then
      L5_2 = History
      L5_2 = L5_2.Push
      L6_2 = Cmd
      L6_2 = L6_2.Props
      L7_2 = Objects
      L7_2 = L7_2.UidOf
      L8_2 = A0_2.id
      L7_2 = L7_2(L8_2)
      L8_2 = L3_2
      L9_2 = {}
      L10_2 = L4_2.layer
      if not L10_2 then
        L10_2 = "Default"
      end
      L9_2.layer = L10_2
      L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2)
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "layerVisible"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = Objects
    L2_2 = L2_2.SetLayerVisible
    L3_2 = A0_2.name
    L4_2 = A0_2.on
    L4_2 = true == L4_2
    L2_2(L3_2, L4_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getHidden"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = WorldProps
  L3_2 = L3_2.GetHidden
  L3_2 = L3_2()
  L4_2 = 1
  L5_2 = #L3_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = {}
    L8_2.index = L7_2
    L9_2 = tostring
    L10_2 = L3_2[L7_2]
    L10_2 = L10_2.model
    L9_2 = L9_2(L10_2)
    L8_2.model = L9_2
    L9_2 = L3_2[L7_2]
    L9_2 = L9_2.x
    L8_2.x = L9_2
    L9_2 = L3_2[L7_2]
    L9_2 = L9_2.y
    L8_2.y = L9_2
    L9_2 = L3_2[L7_2]
    L9_2 = L9_2.z
    L8_2.z = L9_2
    L9_2 = L8_1
    L10_2 = L3_2[L7_2]
    L10_2 = L10_2.x
    L11_2 = L3_2[L7_2]
    L11_2 = L11_2.y
    L12_2 = L3_2[L7_2]
    L12_2 = L12_2.z
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2.zone = L9_2
    L2_2[L7_2] = L8_2
  end
  L4_2 = A1_2
  L5_2 = L2_2
  L4_2(L5_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "restoreHidden"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.index
    if L2_2 then
      L2_2 = WorldProps
      L2_2 = L2_2.RemoveAt
      L3_2 = A0_2.index
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getDeletedObjects"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = Objects
  L3_2 = L3_2.DeletedList
  L3_2 = L3_2()
  L4_2 = 1
  L5_2 = #L3_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L3_2[L7_2]
    L9_2 = {}
    L10_2 = L8_2.uid
    L9_2.uid = L10_2
    L10_2 = tostring
    L11_2 = L8_2.model
    L10_2 = L10_2(L11_2)
    L9_2.model = L10_2
    L10_2 = L8_2.x
    L9_2.x = L10_2
    L10_2 = L8_2.y
    L9_2.y = L10_2
    L10_2 = L8_2.z
    L9_2.z = L10_2
    L10_2 = L8_1
    L11_2 = L8_2.x
    L12_2 = L8_2.y
    L13_2 = L8_2.z
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L9_2.zone = L10_2
    L2_2[L7_2] = L9_2
  end
  L4_2 = A1_2
  L5_2 = L2_2
  L4_2(L5_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "restoreObject"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = A0_2.uid
    if L2_2 then
      L2_2 = Objects
      L2_2 = L2_2.RestoreDeleted
      L3_2 = A0_2.uid
      L2_2 = L2_2(L3_2)
      if L2_2 then
        L3_2 = History
        if L3_2 then
          L3_2 = Cmd
          if L3_2 then
            L3_2 = Cmd
            L3_2 = L3_2.Add
            if L3_2 then
              L3_2 = History
              L3_2 = L3_2.Push
              L4_2 = Cmd
              L4_2 = L4_2.Add
              L5_2 = A0_2.uid
              L4_2, L5_2 = L4_2(L5_2)
              L3_2(L4_2, L5_2)
            end
          end
        end
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getLogs"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = TriggerServerEvent
  L3_2 = "0r-mapeditor:getLogs"
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "stopBuild"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Placement
  L2_2 = L2_2.Stop
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "saveMap"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = Maps
  L2_2 = L2_2.Save
  L3_2 = A0_2.name
  L4_2 = A0_2.category
  L5_2 = A0_2.permanent
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getMaps"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Maps
  L2_2 = L2_2.RequestList
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "getExport"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Maps
  L2_2 = L2_2.Export
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "publishYmap"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Maps
  if L2_2 then
    L2_2 = Maps
    L2_2 = L2_2.PublishYmap
    if L2_2 then
      L2_2 = Maps
      L2_2 = L2_2.PublishYmap
      L2_2()
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNetEvent
L24_1 = "0r-mapeditor:ymapResult"
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L0_1
  if not L3_2 then
    return
  end
  if A2_2 then
    L3_2 = Bridge
    L3_2 = L3_2.Notify
    L4_2 = locale
    L5_2 = "notify.published"
    L6_2 = A0_2
    L4_2 = L4_2(L5_2, L6_2)
    L5_2 = "success"
    L3_2(L4_2, L5_2)
  else
    L3_2 = Bridge
    L3_2 = L3_2.Notify
    L4_2 = locale
    L5_2 = "notify.publish_fail"
    L4_2 = L4_2(L5_2)
    L5_2 = "error"
    L3_2(L4_2, L5_2)
  end
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "importJson"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.json
    if L2_2 then
      L2_2 = Maps
      L2_2 = L2_2.ImportJson
      L3_2 = A0_2.json
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "loadMap"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Maps
  L2_2 = L2_2.RequestLoad
  L3_2 = A0_2.id
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "deselect"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Gizmo
  L2_2 = L2_2.Deselect
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "grab"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Gizmo
  L2_2 = L2_2.ToggleGrab
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "grabHeight"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Gizmo
  L2_2 = L2_2.AdjustHeight
  if A0_2 then
    L3_2 = A0_2.dir
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = 0
  ::lbl_9::
  L3_2 = L3_2 * 0.25
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "grabRotate"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Gizmo
  L2_2 = L2_2.AdjustYaw
  if A0_2 then
    L3_2 = A0_2.dir
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = 0
  ::lbl_9::
  L3_2 = L3_2 * 5.0
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNUICallback
L24_1 = "deleteSelected"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L4_2 = MELog
    L5_2 = "delete"
    if L3_2 then
      L6_2 = L3_2.model
      if L6_2 then
        goto lbl_18
      end
    end
    L6_2 = ""
    ::lbl_18::
    L4_2(L5_2, L6_2)
    L4_2 = Objects
    L4_2 = L4_2.Snapshot
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    L5_2 = Maps
    L5_2 = L5_2.DeleteObject
    L6_2 = L2_2
    L5_2(L6_2)
    L5_2 = History
    if L5_2 and L4_2 then
      L5_2 = History
      L5_2 = L5_2.Push
      L6_2 = Cmd
      L6_2 = L6_2.Delete
      L7_2 = L4_2
      L6_2, L7_2 = L6_2(L7_2)
      L5_2(L6_2, L7_2)
    end
    L5_2 = Gizmo
    L5_2 = L5_2.Deselect
    L5_2()
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L23_1(L24_1, L25_1)
L23_1 = nil
L24_1 = RegisterNUICallback
L25_1 = "setObjectProps"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L4_2 = {}
      L5_2 = {}
      L6_2 = L3_2.props
      L6_2 = L6_2.collision
      L5_2.collision = L6_2
      L6_2 = L3_2.props
      L6_2 = L6_2.frozen
      L5_2.frozen = L6_2
      L6_2 = L3_2.props
      L6_2 = L6_2.visible
      L5_2.visible = L6_2
      L6_2 = L3_2.props
      L6_2 = L6_2.alpha
      L5_2.alpha = L6_2
      L6_2 = L3_2.props
      L6_2 = L6_2.lod
      L5_2.lod = L6_2
      L4_2.props = L5_2
      if L4_2 then
        goto lbl_35
      end
    end
    L4_2 = nil
    ::lbl_35::
    L5_2 = Objects
    L5_2 = L5_2.SetProps
    L6_2 = L2_2
    L7_2 = A0_2.props
    if not L7_2 then
      L7_2 = {}
    end
    L5_2(L6_2, L7_2)
    L5_2 = MEAutoSave
    L6_2 = L2_2
    L5_2(L6_2)
    L5_2 = Objects
    L5_2 = L5_2.Get
    L6_2 = L2_2
    L5_2 = L5_2(L6_2)
    if A0_2 then
      L6_2 = A0_2.live
      if L6_2 then
        L6_2 = L23_1
        if nil == L6_2 then
          L23_1 = L4_2
        end
    end
    else
      L6_2 = L23_1
      if not L6_2 then
        L6_2 = L4_2
      end
      L7_2 = nil
      L23_1 = L7_2
      L7_2 = History
      if L7_2 and L6_2 and L5_2 then
        L7_2 = History
        L7_2 = L7_2.Push
        L8_2 = Cmd
        L8_2 = L8_2.Props
        L9_2 = Objects
        L9_2 = L9_2.UidOf
        L10_2 = L2_2
        L9_2 = L9_2(L10_2)
        L10_2 = L6_2
        L11_2 = {}
        L12_2 = {}
        L13_2 = L5_2.props
        L13_2 = L13_2.collision
        L12_2.collision = L13_2
        L13_2 = L5_2.props
        L13_2 = L13_2.frozen
        L12_2.frozen = L13_2
        L13_2 = L5_2.props
        L13_2 = L13_2.visible
        L12_2.visible = L13_2
        L13_2 = L5_2.props
        L13_2 = L13_2.alpha
        L12_2.alpha = L13_2
        L13_2 = L5_2.props
        L13_2 = L13_2.lod
        L12_2.lod = L13_2
        L11_2.props = L12_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2, L10_2, L11_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
      end
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNUICallback
L25_1 = "setBlip"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  if L2_2 and A0_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L4_2 = {}
      L5_2 = {}
      L6_2 = L3_2.blipName
      if not L6_2 then
        L6_2 = ""
      end
      L5_2.name = L6_2
      L6_2 = L3_2.blipColor
      if not L6_2 then
        L6_2 = 0
      end
      L5_2.color = L6_2
      L6_2 = L3_2.blipOn
      L6_2 = true == L6_2
      L5_2.on = L6_2
      L4_2.blip = L5_2
      if L4_2 then
        goto lbl_38
      end
    end
    L4_2 = nil
    ::lbl_38::
    L5_2 = Objects
    L5_2 = L5_2.SetBlip
    L6_2 = L2_2
    L7_2 = A0_2.name
    L8_2 = A0_2.color
    L9_2 = A0_2.on
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = MELog
    L6_2 = "blip"
    L7_2 = A0_2.name
    if not L7_2 then
      L7_2 = ""
    end
    L5_2(L6_2, L7_2)
    L5_2 = MEAutoSave
    L6_2 = L2_2
    L5_2(L6_2)
    L5_2 = Objects
    L5_2 = L5_2.Get
    L6_2 = L2_2
    L5_2 = L5_2(L6_2)
    L6_2 = History
    if L6_2 and L4_2 and L5_2 then
      L6_2 = History
      L6_2 = L6_2.Push
      L7_2 = Cmd
      L7_2 = L7_2.Props
      L8_2 = Objects
      L8_2 = L8_2.UidOf
      L9_2 = L2_2
      L8_2 = L8_2(L9_2)
      L9_2 = L4_2
      L10_2 = {}
      L11_2 = {}
      L12_2 = L5_2.blipName
      if not L12_2 then
        L12_2 = ""
      end
      L11_2.name = L12_2
      L12_2 = L5_2.blipColor
      if not L12_2 then
        L12_2 = 0
      end
      L11_2.color = L12_2
      L12_2 = L5_2.blipOn
      L12_2 = true == L12_2
      L11_2.on = L12_2
      L10_2.blip = L11_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2, L9_2, L10_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNUICallback
L25_1 = "gravity"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
  end
  if L3_2 then
    L4_2 = DoesEntityExist
    L5_2 = L3_2.handle
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = L3_2.handle
      L5_2 = Objects
      L5_2 = L5_2.UidOf
      L6_2 = L2_2
      L5_2 = L5_2(L6_2)
      L6_2 = {}
      L7_2 = {}
      L8_2 = L3_2.coords
      L8_2 = L8_2.x
      L7_2.x = L8_2
      L8_2 = L3_2.coords
      L8_2 = L8_2.y
      L7_2.y = L8_2
      L8_2 = L3_2.coords
      L8_2 = L8_2.z
      L7_2.z = L8_2
      L6_2.coords = L7_2
      L7_2 = {}
      L8_2 = L3_2.rot
      L8_2 = L8_2.x
      L7_2.x = L8_2
      L8_2 = L3_2.rot
      L8_2 = L8_2.y
      L7_2.y = L8_2
      L8_2 = L3_2.rot
      L8_2 = L8_2.z
      L7_2.z = L8_2
      L6_2.rot = L7_2
      L7_2 = L3_2.props
      L7_2.frozen = false
      L7_2 = L3_2.props
      L7_2.collision = true
      L7_2 = FreezeEntityPosition
      L8_2 = L4_2
      L9_2 = false
      L7_2(L8_2, L9_2)
      L7_2 = SetEntityCollision
      L8_2 = L4_2
      L9_2 = true
      L10_2 = true
      L7_2(L8_2, L9_2, L10_2)
      L7_2 = SetEntityHasGravity
      L8_2 = L4_2
      L9_2 = true
      L7_2(L8_2, L9_2)
      L7_2 = ActivatePhysics
      L8_2 = L4_2
      L7_2(L8_2)
      L7_2 = MELog
      L8_2 = "gravity"
      L9_2 = L3_2.model
      L7_2(L8_2, L9_2)
      L7_2 = CreateThread
      function L8_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
        L0_3 = 0
        while true do
          L1_3 = 6000
          if not (L0_3 < L1_3) then
            break
          end
          L1_3 = DoesEntityExist
          L2_3 = L4_2
          L1_3 = L1_3(L2_3)
          if not L1_3 then
            break
          end
          L1_3 = Wait
          L2_3 = 150
          L1_3(L2_3)
          L0_3 = L0_3 + 150
          L1_3 = 450
          if L0_3 > L1_3 then
            L1_3 = GetEntityVelocity
            L2_3 = L4_2
            L1_3 = L1_3(L2_3)
            L1_3 = #L1_3
            L2_3 = 0.05
            if L1_3 < L2_3 then
              break
            end
          end
        end
        L1_3 = DoesEntityExist
        L2_3 = L4_2
        L1_3 = L1_3(L2_3)
        if L1_3 then
          L1_3 = Objects
          L1_3 = L1_3.Get
          L2_3 = L2_2
          L1_3 = L1_3(L2_3)
          if L1_3 then
            goto lbl_38
          end
        end
        do return end
        ::lbl_38::
        L1_3 = GetEntityCoords
        L2_3 = L4_2
        L1_3 = L1_3(L2_3)
        L2_3 = FreezeEntityPosition
        L3_3 = L4_2
        L4_3 = true
        L2_3(L3_3, L4_3)
        L2_3 = Objects
        L2_3 = L2_3.Update
        L3_3 = L2_2
        L4_3 = L1_3
        L5_3 = L3_2.rot
        L2_3(L3_3, L4_3, L5_3)
        L2_3 = L3_2.props
        L2_3.frozen = true
        L2_3 = MEAutoSave
        if L2_3 then
          L2_3 = MEAutoSave
          L3_3 = L2_2
          L2_3(L3_3)
        end
        L2_3 = History
        if L2_3 then
          L2_3 = History
          L2_3 = L2_3.Push
          L3_3 = Cmd
          L3_3 = L3_3.Transform
          L4_3 = L5_2
          L5_3 = L6_2
          L6_3 = {}
          L7_3 = {}
          L8_3 = L1_3.x
          L7_3.x = L8_3
          L8_3 = L1_3.y
          L7_3.y = L8_3
          L8_3 = L1_3.z
          L7_3.z = L8_3
          L6_3.coords = L7_3
          L7_3 = {}
          L8_3 = L3_2.rot
          L8_3 = L8_3.x
          L7_3.x = L8_3
          L8_3 = L3_2.rot
          L8_3 = L8_3.y
          L7_3.y = L8_3
          L8_3 = L3_2.rot
          L8_3 = L8_3.z
          L7_3.z = L8_3
          L6_3.rot = L7_3
          L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = L3_3(L4_3, L5_3, L6_3)
          L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
        end
        L2_3 = SendNUIMessage
        L3_3 = {}
        L3_3.action = "selected"
        L4_3 = Gizmo
        L4_3 = L4_3.Info
        L4_3 = L4_3()
        L3_3.data = L4_3
        L2_3(L3_3)
      end
      L7_2(L8_2)
    end
  end
  L4_2 = A1_2
  L5_2 = {}
  L4_2(L5_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNUICallback
L25_1 = "replaceModel"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = A0_2.model
    if L3_2 then
      L3_2 = Objects
      L3_2 = L3_2.Get
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      L4_2 = L3_2 or L4_2
      if L3_2 then
        L4_2 = L3_2.model
      end
      L5_2 = Objects
      L5_2 = L5_2.Replace
      L6_2 = L2_2
      L7_2 = A0_2.model
      L5_2(L6_2, L7_2)
      L5_2 = MELog
      L6_2 = "replace"
      L7_2 = A0_2.model
      L5_2(L6_2, L7_2)
      L5_2 = MEAutoSave
      L6_2 = L2_2
      L5_2(L6_2)
      L5_2 = History
      if L5_2 and L4_2 then
        L5_2 = History
        L5_2 = L5_2.Push
        L6_2 = Cmd
        L6_2 = L6_2.Replace
        L7_2 = Objects
        L7_2 = L7_2.UidOf
        L8_2 = L2_2
        L7_2 = L7_2(L8_2)
        L8_2 = L4_2
        L9_2 = A0_2.model
        L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
        L5_2(L6_2, L7_2, L8_2, L9_2)
      end
      L5_2 = Gizmo
      L5_2 = L5_2.Select
      L6_2 = L2_2
      L5_2(L6_2)
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNUICallback
L25_1 = "setSnap"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = pairs
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = Config
    L8_2 = L8_2.snap
    L8_2[L6_2] = L7_2
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L24_1(L25_1, L26_1)
function L24_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = Camera
  L0_2 = L0_2.IsActive
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = Camera
    L0_2 = L0_2.Stop
    L0_2()
  else
    L0_2 = Camera
    L0_2 = L0_2.Start
    L0_2()
  end
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "freecam"
  L2_2 = {}
  L3_2 = Camera
  L3_2 = L3_2.IsActive
  L3_2 = L3_2()
  L2_2.on = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "toast"
  L2_2 = Camera
  L2_2 = L2_2.IsActive
  L2_2 = L2_2()
  if L2_2 then
    L2_2 = locale
    L3_2 = "toast.freecam_on"
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_46
    end
  end
  L2_2 = locale
  L3_2 = "toast.freecam_off"
  L2_2 = L2_2(L3_2)
  ::lbl_46::
  L1_2.data = L2_2
  L0_2(L1_2)
end
L25_1 = RegisterNUICallback
L26_1 = "toggleFreecam"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L24_1
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "setMode"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = Gizmo
  L2_2 = L2_2.SetMode
  if A0_2 then
    L3_2 = A0_2.mode
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = "translate"
  ::lbl_9::
  L2_2(L3_2)
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "mode"
  L4_2 = {}
  L5_2 = A0_2 or L5_2
  if A0_2 then
    L5_2 = A0_2.mode
  end
  L4_2.mode = L5_2
  L3_2.data = L4_2
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "setMultiplace"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Placement
  L2_2 = L2_2.SetMultiplace
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
    L3_2 = true == L3_2
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "setStep"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = tonumber
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.step
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0.25
  end
  L3_2 = Config
  L3_2 = L3_2.snap
  L3_2.gridSize = L2_2
  L3_2 = Config
  L3_2 = L3_2.precise
  L3_2.move = L2_2
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "setAngle"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = tonumber
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.angle
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 15.0
  end
  L3_2 = Config
  L3_2 = L3_2.snap
  L3_2.angleStep = L2_2
  L3_2 = Config
  L3_2 = L3_2.precise
  L3_2.rotate = L2_2
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "ground"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Gizmo
  L2_2 = L2_2.Ground
  L2_2()
  L2_2 = MELog
  L3_2 = "ground"
  L4_2 = ""
  L2_2(L3_2, L4_2)
  L2_2 = MEAutoSave
  L3_2 = Gizmo
  L3_2 = L3_2.Target
  L3_2, L4_2 = L3_2()
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "clone"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Gizmo
  L2_2 = L2_2.Clone
  L2_2()
  L2_2 = MELog
  L3_2 = "clone"
  L4_2 = ""
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "setTransform"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Gizmo
  L2_2 = L2_2.SetTransform
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.coords
  end
  L4_2 = A0_2 or L4_2
  if A0_2 then
    L4_2 = A0_2.rot
  end
  L2_2(L3_2, L4_2)
  L2_2 = MEAutoSave
  L3_2 = Gizmo
  L3_2 = L3_2.Target
  L3_2, L4_2 = L3_2()
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "resetTransform"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = Gizmo
  L2_2 = L2_2.Target
  L2_2 = L2_2()
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
  end
  if L3_2 and A0_2 then
    L4_2 = A0_2.pos
    if L4_2 then
      L4_2 = L3_2.initCoords
      if L4_2 then
        goto lbl_21
      end
    end
    L4_2 = L3_2.coords
    ::lbl_21::
    L5_2 = A0_2.rot
    if L5_2 then
      L5_2 = L3_2.initRot
      if L5_2 then
        goto lbl_28
      end
    end
    L5_2 = L3_2.rot
    ::lbl_28::
    L6_2 = Gizmo
    L6_2 = L6_2.SetTransform
    L7_2 = L4_2
    L8_2 = L5_2
    L6_2(L7_2, L8_2)
    L6_2 = MEAutoSave
    L7_2 = L2_2
    L6_2(L7_2)
  end
  L4_2 = A1_2
  L5_2 = {}
  L4_2(L5_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "worldDelete"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "world"
      L2_2(L3_2)
    end
  end
  L2_2 = WorldProps
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2 = L2_2(L3_2)
  L3_2 = MELog
  L4_2 = "world_eraser"
  if L2_2 then
    L5_2 = "on"
    if L5_2 then
      goto lbl_23
    end
  end
  L5_2 = "off"
  ::lbl_23::
  L3_2(L4_2, L5_2)
  L3_2 = SendNUIMessage
  L4_2 = {}
  L4_2.action = "worldDelete"
  L5_2 = {}
  L5_2.on = L2_2
  L4_2.data = L5_2
  L3_2(L4_2)
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "worldUndo"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = WorldProps
  L2_2 = L2_2.UndoLast
  L2_2()
  L2_2 = MELog
  L3_2 = "world_restore"
  L4_2 = ""
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "bulkToggle"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L22_1
      L3_2 = "bulk"
      L2_2(L3_2)
    end
  end
  L2_2 = Bulk
  L2_2 = L2_2.Toggle
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "bulkGrab"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Bulk
  L2_2 = L2_2.GrabToggle
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "bulkGround"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Bulk
  L2_2 = L2_2.GroundAll
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "bulkDelete"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MELog
  L3_2 = "bulk_delete"
  L4_2 = tostring
  L5_2 = Bulk
  L5_2 = L5_2.Count
  L5_2 = L5_2()
  L4_2, L5_2 = L4_2(L5_2)
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = Bulk
  L2_2 = L2_2.DeleteAll
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "bulkClear"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Bulk
  L2_2 = L2_2.Clear
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "boxSelect"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A0_2 then
    L2_2 = Bulk
    L2_2 = L2_2.SelectBox
    L3_2 = A0_2.x1
    L4_2 = A0_2.y1
    L5_2 = A0_2.x2
    L6_2 = A0_2.y2
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "marqueeState"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = A0_2.open
    L2_2 = true == L2_2
  end
  L6_1 = L2_2
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "marqueeDrag"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L0_1
  if L2_2 then
    L2_2 = SetNuiFocusKeepInput
    if A0_2 then
      L3_2 = A0_2.on
    end
    L3_2 = L2_1
    L3_2 = true ~= L3_2 and L3_2
    L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "pointToggle"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = Camera
  L2_2 = L2_2.CursorRay
  L2_2, L3_2 = L2_2()
  L4_2 = Config
  L4_2 = L4_2.placement
  L4_2 = L4_2.maxRayDistance
  L4_2 = L3_2 * L4_2
  L4_2 = L2_2 + L4_2
  L5_2 = _ENV
  L6_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L5_2 = L5_2[L6_2]
  L6_2 = L2_2.x
  L7_2 = L2_2.y
  L8_2 = L2_2.z
  L9_2 = L4_2.x
  L10_2 = L4_2.y
  L11_2 = L4_2.z
  L12_2 = -1
  L13_2 = 0
  L14_2 = 4
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = GetShapeTestResult
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2)
  L11_2 = nil
  if (true == L7_2 or 1 == L7_2) and L10_2 and 0 ~= L10_2 then
    L12_2 = L13_1
    L13_2 = L10_2
    L12_2 = L12_2(L13_2)
    L11_2 = L12_2
  end
  if not L11_2 then
    L12_2 = L17_1
    L12_2 = L12_2()
    L11_2 = L12_2
  end
  if L11_2 then
    L12_2 = Bulk
    L12_2 = L12_2.ToggleId
    L13_2 = L11_2
    L12_2(L13_2)
  else
    L12_2 = Bulk
    L12_2 = L12_2.Clear
    L12_2()
  end
  L12_2 = A1_2
  L13_2 = {}
  L12_2(L13_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "toggleBigmap"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L3_1
  L2_2 = L2_2 + 1
  L2_2 = L2_2 % 3
  L3_1 = L2_2
  L2_2 = L3_1
  if 1 ~= L2_2 then
    L2_2 = SetBigmapActive
    L3_2 = false
    L4_2 = false
    L2_2(L3_2, L4_2)
  end
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "bigmap"
  L4_2 = {}
  L5_2 = L3_1
  L4_2.mode = L5_2
  L3_2.data = L4_2
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "getObjects"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = pairs
  L4_2 = Objects
  L4_2 = L4_2.All
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2()
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L10_2.id = L7_2
    L11_2 = L8_2.model
    L10_2.model = L11_2
    L11_2 = L8_2.coords
    L11_2 = L11_2.x
    L10_2.x = L11_2
    L11_2 = L8_2.coords
    L11_2 = L11_2.y
    L10_2.y = L11_2
    L11_2 = L8_2.coords
    L11_2 = L11_2.z
    L10_2.z = L11_2
    L11_2 = L8_2.props
    L11_2 = L11_2.visible
    L11_2 = false ~= L11_2
    L10_2.visible = L11_2
    L11_2 = L8_1
    L12_2 = L8_2.coords
    L12_2 = L12_2.x
    L13_2 = L8_2.coords
    L13_2 = L13_2.y
    L14_2 = L8_2.coords
    L14_2 = L14_2.z
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    L10_2.zone = L11_2
    L2_2[L9_2] = L10_2
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L2_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.id
    L3_3 = A1_3.id
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  L3_2 = A1_2
  L4_2 = L2_2
  L3_2(L4_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "removeObject"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = Objects
    L2_2 = L2_2.Get
    L3_2 = A0_2.id
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = Gizmo
      L2_2 = L2_2.Target
      L2_2 = L2_2()
      L3_2 = A0_2.id
      if L2_2 == L3_2 then
        L2_2 = Gizmo
        L2_2 = L2_2.Deselect
        L2_2()
      end
      L2_2 = Objects
      L2_2 = L2_2.Snapshot
      L3_2 = A0_2.id
      L2_2 = L2_2(L3_2)
      L3_2 = Objects
      L3_2 = L3_2.Remove
      L4_2 = A0_2.id
      L3_2(L4_2)
      L3_2 = History
      if L3_2 and L2_2 then
        L3_2 = History
        L3_2 = L3_2.Push
        L4_2 = Cmd
        L4_2 = L4_2.Delete
        L5_2 = L2_2
        L4_2, L5_2 = L4_2(L5_2)
        L3_2(L4_2, L5_2)
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "toggleVisible"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = Objects
    L2_2 = L2_2.Get
    L3_2 = A0_2.id
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    L3_2 = Objects
    L3_2 = L3_2.SetProps
    L4_2 = A0_2.id
    L5_2 = {}
    L6_2 = L2_2.props
    L6_2 = L6_2.visible
    L6_2 = false == L6_2
    L5_2.visible = L6_2
    L3_2(L4_2, L5_2)
    L3_2 = MEAutoSave
    L4_2 = A0_2.id
    L3_2(L4_2)
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "selectObject"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = Objects
    L2_2 = L2_2.Get
    L3_2 = A0_2.id
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = Gizmo
      L2_2 = L2_2.Select
      L3_2 = A0_2.id
      L2_2(L3_2)
      L2_2 = SendNUIMessage
      L3_2 = {}
      L3_2.action = "selected"
      L4_2 = Gizmo
      L4_2 = L4_2.Info
      L4_2 = L4_2()
      L3_2.data = L4_2
      L2_2(L3_2)
      L2_2 = SendNUIMessage
      L3_2 = {}
      L3_2.action = "cardMode"
      L4_2 = {}
      L4_2.open = true
      L3_2.data = L4_2
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterNUICallback
L26_1 = "teleportTo"
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = A0_2.id
    if L2_2 then
      L2_2 = Objects
      L2_2 = L2_2.Get
      L3_2 = A0_2.id
      L2_2 = L2_2(L3_2)
    end
  end
  L3_2 = nil
  if L2_2 then
    L3_2 = L2_2.coords
  elseif A0_2 then
    L4_2 = A0_2.x
    if L4_2 then
      L4_2 = vector3
      L5_2 = A0_2.x
      L5_2 = L5_2 + 0.0
      L6_2 = A0_2.y
      L6_2 = L6_2 + 0.0
      L7_2 = A0_2.z
      L7_2 = L7_2 + 0.0
      L4_2 = L4_2(L5_2, L6_2, L7_2)
      L3_2 = L4_2
    end
  end
  if L3_2 then
    L4_2 = Camera
    L4_2 = L4_2.IsActive
    L4_2 = L4_2()
    if L4_2 then
      L4_2 = Camera
      L4_2 = L4_2.SetCoords
      L5_2 = Camera
      L5_2 = L5_2.GetForward
      L5_2 = L5_2()
      L5_2 = L5_2 * 4.0
      L5_2 = L3_2 - L5_2
      L6_2 = vector3
      L7_2 = 0.0
      L8_2 = 0.0
      L9_2 = 2.0
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      L5_2 = L5_2 + L6_2
      L4_2(L5_2)
    else
      L4_2 = SetEntityCoords
      L5_2 = PlayerPedId
      L5_2 = L5_2()
      L6_2 = L3_2.x
      L7_2 = L3_2.y
      L8_2 = L3_2.z
      L8_2 = L8_2 + 1.0
      L9_2 = false
      L10_2 = false
      L11_2 = false
      L12_2 = false
      L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    end
  end
  L4_2 = A1_2
  L5_2 = {}
  L4_2(L5_2)
end
L25_1(L26_1, L27_1)
L25_1 = RegisterCommand
L26_1 = "0r_me_freecam"
function L27_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L2_1
    if not L0_2 then
      L0_2 = L24_1
      L0_2()
    end
  end
end
L28_1 = false
L25_1(L26_1, L27_1, L28_1)
L25_1 = RegisterKeyMapping
L26_1 = "0r_me_freecam"
L27_1 = "Map Editor: Toggle Freecam"
L28_1 = "keyboard"
L29_1 = "F"
L25_1(L26_1, L27_1, L28_1, L29_1)
L25_1 = RegisterCommand
L26_1 = "0r_me_done"
function L27_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L2_1
    if not L0_2 then
      L0_2 = Placement
      L0_2 = L0_2.Stop
      L0_2()
      L0_2 = Gizmo
      L0_2 = L0_2.Deselect
      L0_2()
    end
  end
end
L28_1 = false
L25_1(L26_1, L27_1, L28_1)
L25_1 = RegisterKeyMapping
L26_1 = "0r_me_done"
L27_1 = "Map Editor: Done Editing"
L28_1 = "keyboard"
L29_1 = "RETURN"
L25_1(L26_1, L27_1, L28_1, L29_1)
L25_1 = RegisterCommand
L26_1 = "0r_me_clone"
function L27_1()
  local L0_2, L1_2, L2_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L2_1
    if not L0_2 then
      L0_2 = Gizmo
      L0_2 = L0_2.Target
      L0_2 = L0_2()
      if L0_2 then
        L0_2 = IsRawKeyDown
        L1_2 = 17
        L0_2 = L0_2(L1_2)
        if not L0_2 then
          L0_2 = IsRawKeyDown
          L1_2 = 162
          L0_2 = L0_2(L1_2)
          if not L0_2 then
            L0_2 = IsRawKeyDown
            L1_2 = 163
            L0_2 = L0_2(L1_2)
            if not L0_2 then
              L0_2 = Gizmo
              L0_2 = L0_2.Clone
              L0_2()
              L0_2 = MELog
              L1_2 = "clone"
              L2_2 = "C"
              L0_2(L1_2, L2_2)
            end
          end
        end
      end
    end
  end
end
L28_1 = false
L25_1(L26_1, L27_1, L28_1)
L25_1 = RegisterKeyMapping
L26_1 = "0r_me_clone"
L27_1 = "Map Editor: Copy / Clone Object"
L28_1 = "keyboard"
L29_1 = "C"
L25_1(L26_1, L27_1, L28_1, L29_1)
L25_1 = RegisterCommand
L26_1 = "0r_me_delete"
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L2_1
    if not L0_2 then
      L0_2 = Bulk
      L0_2 = L0_2.IsActive
      L0_2 = L0_2()
      if L0_2 then
        L0_2 = Bulk
        L0_2 = L0_2.Count
        L0_2 = L0_2()
        if L0_2 > 0 then
          L0_2 = MELog
          L1_2 = "bulk_delete"
          L2_2 = tostring
          L3_2 = Bulk
          L3_2 = L3_2.Count
          L3_2, L4_2, L5_2 = L3_2()
          L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
          L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
          L0_2 = Bulk
          L0_2 = L0_2.DeleteAll
          L0_2()
      end
      else
        L0_2 = Gizmo
        L0_2 = L0_2.Target
        L0_2 = L0_2()
        if L0_2 then
          L1_2 = Objects
          L1_2 = L1_2.Get
          L2_2 = L0_2
          L1_2 = L1_2(L2_2)
          L2_2 = MELog
          L3_2 = "delete"
          if L1_2 then
            L4_2 = L1_2.model
            if L4_2 then
              goto lbl_46
            end
          end
          L4_2 = ""
          ::lbl_46::
          L2_2(L3_2, L4_2)
          L2_2 = Objects
          L2_2 = L2_2.Snapshot
          L3_2 = L0_2
          L2_2 = L2_2(L3_2)
          L3_2 = Maps
          L3_2 = L3_2.DeleteObject
          L4_2 = L0_2
          L3_2(L4_2)
          L3_2 = History
          if L3_2 and L2_2 then
            L3_2 = History
            L3_2 = L3_2.Push
            L4_2 = Cmd
            L4_2 = L4_2.Delete
            L5_2 = L2_2
            L4_2, L5_2 = L4_2(L5_2)
            L3_2(L4_2, L5_2)
          end
          L3_2 = Gizmo
          L3_2 = L3_2.Deselect
          L3_2()
        end
      end
    end
  end
end
L28_1 = false
L25_1(L26_1, L27_1, L28_1)
L25_1 = RegisterKeyMapping
L26_1 = "0r_me_delete"
L27_1 = "Map Editor: Delete Selected Object(s)"
L28_1 = "keyboard"
L29_1 = "DELETE"
L25_1(L26_1, L27_1, L28_1, L29_1)
L25_1 = AddEventHandler
L26_1 = "onResourceStop"
function L27_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L0_1
    if L1_2 then
      L1_2 = Camera
      L1_2 = L1_2.Stop
      L1_2()
      L1_2 = SetNuiFocusKeepInput
      L2_2 = false
      L1_2(L2_2)
      L1_2 = SetNuiFocus
      L2_2 = false
      L3_2 = false
      L1_2(L2_2, L3_2)
    end
  end
end
L25_1(L26_1, L27_1)
