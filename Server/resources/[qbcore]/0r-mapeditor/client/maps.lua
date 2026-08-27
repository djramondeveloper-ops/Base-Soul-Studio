local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1
L0_1 = {}
Maps = L0_1
L0_1 = nil
L1_1 = nil
L2_1 = false
L3_1 = 0
L4_1 = {}
L5_1 = Maps
function L6_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L1_2 = L1_1
  return L0_2, L1_2
end
L5_1.Current = L6_1
L5_1 = Maps
function L6_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = A3_2 or nil
  if not A3_2 then
    L4_2 = {}
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.lod
    L4_2.lod = L5_2
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.alpha
    L4_2.alpha = L5_2
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.collision
    L4_2.collision = L5_2
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.frozen
    L4_2.frozen = L5_2
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.visible
    L4_2.visible = L5_2
  end
  L5_2 = Objects
  L5_2 = L5_2.Spawn
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = L4_2
  return L5_2(L6_2, L7_2, L8_2, L9_2)
end
L5_1.PlaceObject = L6_1
L5_1 = nil
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L5_1
  if L0_2 then
    L0_2 = L5_1
    return L0_2
  end
  L0_2 = {}
  L5_1 = L0_2
  L0_2 = LoadResourceFile
  L1_2 = "0r-props-unlock"
  L2_2 = "unlocked_models.json"
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = L0_2 or L3_2
  if not L0_2 then
    L3_2 = ""
  end
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = type
      L4_2 = L2_2.models
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = 1
        L4_2 = L2_2.models
        L4_2 = #L4_2
        L5_2 = 1
        for L6_2 = L3_2, L4_2, L5_2 do
          L7_2 = tostring
          L8_2 = L2_2.models
          L8_2 = L8_2[L6_2]
          L7_2 = L7_2(L8_2)
          L8_2 = L7_2
          L7_2 = L7_2.lower
          L7_2 = L7_2(L8_2)
          L8_2 = L5_1
          L8_2[L7_2] = true
        end
      end
    end
  end
  L3_2 = L5_1
  return L3_2
end
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = L6_1
  L0_2 = L0_2()
  L1_2 = {}
  L2_2 = {}
  L3_2 = pairs
  L4_2 = Objects
  L4_2 = L4_2.All
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2()
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.adopted
    if not L9_2 then
      L9_2 = tostring
      L10_2 = L8_2.model
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2
      L9_2 = L9_2.lower
      L9_2 = L9_2(L10_2)
      L10_2 = L0_2[L9_2]
      if L10_2 then
        L10_2 = L2_2[L9_2]
        if not L10_2 then
          L2_2[L9_2] = true
          L10_2 = #L1_2
          L10_2 = L10_2 + 1
          L1_2[L10_2] = L9_2
        end
      end
    end
  end
  return L1_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.adopted
    if not L2_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L2_2 = TriggerServerEvent
  L3_2 = "0r-mapeditor:saveObject"
  L4_2 = {}
  L5_2 = L0_1
  L4_2.mapId = L5_2
  L5_2 = L1_1
  L4_2.name = L5_2
  L4_2.localId = A0_2
  L5_2 = L1_2.dbId
  L4_2.dbId = L5_2
  L5_2 = {}
  L6_2 = L1_2.model
  L5_2.model = L6_2
  L6_2 = L1_2.coords
  L6_2 = L6_2.x
  L5_2.x = L6_2
  L6_2 = L1_2.coords
  L6_2 = L6_2.y
  L5_2.y = L6_2
  L6_2 = L1_2.coords
  L6_2 = L6_2.z
  L5_2.z = L6_2
  L6_2 = L1_2.rot
  L6_2 = L6_2.x
  L5_2.rx = L6_2
  L6_2 = L1_2.rot
  L6_2 = L6_2.y
  L5_2.ry = L6_2
  L6_2 = L1_2.rot
  L6_2 = L6_2.z
  L5_2.rz = L6_2
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = L1_2.props
  L7_2 = L7_2.lod
  if not L7_2 then
    L7_2 = Config
    L7_2 = L7_2.objectDefaults
    L7_2 = L7_2.lod
  end
  L6_2 = L6_2(L7_2)
  L5_2.lod = L6_2
  L6_2 = L1_2.props
  L6_2 = L6_2.collision
  L6_2 = false ~= L6_2
  L5_2.collision = L6_2
  L6_2 = L1_2.props
  L6_2 = L6_2.frozen
  L6_2 = false ~= L6_2
  L5_2.frozen = L6_2
  L6_2 = L1_2.props
  L6_2 = L6_2.visible
  L6_2 = false ~= L6_2
  L5_2.visible = L6_2
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = L1_2.props
  L7_2 = L7_2.alpha
  if not L7_2 then
    L7_2 = 255
  end
  L6_2 = L6_2(L7_2)
  L5_2.alpha = L6_2
  L6_2 = L1_2.blipOn
  L6_2 = true == L6_2
  L5_2.blipOn = L6_2
  L6_2 = L1_2.blipName
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.blipName = L6_2
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = L1_2.blipColor
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  L5_2.blipColor = L6_2
  L4_2.object = L5_2
  L2_2(L3_2, L4_2)
end
L9_1 = Maps
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = Objects
  L1_2 = L1_2.Get
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L1_2 = L0_1
  if not L1_2 then
    L1_2 = L2_1
    if L1_2 then
      L1_2 = GetGameTimer
      L1_2 = L1_2()
      L2_2 = L3_1
      L1_2 = L1_2 - L2_2
      L2_2 = 8000
      if L1_2 < L2_2 then
        L1_2 = L4_1
        L1_2[A0_2] = true
        return
      end
    end
    L1_2 = true
    L2_1 = L1_2
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L3_1 = L1_2
  end
  L1_2 = L8_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L9_1.SaveObject = L10_1
L9_1 = Maps
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = Objects
  L1_2 = L1_2.Remove
  L2_2 = A0_2
  L1_2(L2_2)
end
L9_1.DeleteObject = L10_1
L9_1 = Maps
function L10_1()
  local L0_2, L1_2
  L0_2 = Objects
  L0_2 = L0_2.Clear
  L0_2()
  L0_2 = WorldProps
  if L0_2 then
    L0_2 = WorldProps
    L0_2 = L0_2.Clear
    L0_2()
  end
  L0_2 = Lights
  if L0_2 then
    L0_2 = Lights
    L0_2 = L0_2.Clear
    L0_2()
  end
  L0_2 = nil
  L1_2 = nil
  L1_1 = L1_2
  L0_1 = L0_2
  L0_2 = false
  L1_2 = {}
  L4_1 = L1_2
  L2_1 = L0_2
  L0_2 = History
  if L0_2 then
    L0_2 = History
    L0_2 = L0_2.Clear
    L0_2()
  end
  L0_2 = MEAutoSaveReset
  if L0_2 then
    L0_2 = MEAutoSaveReset
    L0_2()
  end
  L0_2 = Array
  if L0_2 then
    L0_2 = Array
    L0_2 = L0_2.Cancel
    L0_2()
  end
  L0_2 = Prefab
  if L0_2 then
    L0_2 = Prefab
    L0_2 = L0_2.Cancel
    L0_2()
  end
end
L9_1.New = L10_1
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = {}
  L1_2 = WorldProps
  if L1_2 then
    L1_2 = WorldProps
    L1_2 = L1_2.GetHidden
    L1_2 = L1_2()
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = {}
  ::lbl_13::
  L2_2 = 1
  L3_2 = #L1_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = {}
    L7_2 = tostring
    L8_2 = L1_2[L5_2]
    L8_2 = L8_2.model
    L7_2 = L7_2(L8_2)
    L6_2.model = L7_2
    L7_2 = L1_2[L5_2]
    L7_2 = L7_2.x
    L6_2.x = L7_2
    L7_2 = L1_2[L5_2]
    L7_2 = L7_2.y
    L6_2.y = L7_2
    L7_2 = L1_2[L5_2]
    L7_2 = L7_2.z
    L6_2.z = L7_2
    L7_2 = L1_2[L5_2]
    L7_2 = L7_2.radius
    L6_2.radius = L7_2
    L0_2[L5_2] = L6_2
  end
  return L0_2
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = Objects
  L2_2 = L2_2.All
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L2_2()
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.adopted
    if not L7_2 then
      L7_2 = #L0_2
      L7_2 = L7_2 + 1
      L8_2 = {}
      L8_2.localId = L5_2
      L9_2 = L6_2.eid
      L8_2.eid = L9_2
      L9_2 = L6_2.model
      L8_2.model = L9_2
      L9_2 = L6_2.coords
      L9_2 = L9_2.x
      L8_2.x = L9_2
      L9_2 = L6_2.coords
      L9_2 = L9_2.y
      L8_2.y = L9_2
      L9_2 = L6_2.coords
      L9_2 = L9_2.z
      L8_2.z = L9_2
      L9_2 = L6_2.rot
      L9_2 = L9_2.x
      L8_2.rx = L9_2
      L9_2 = L6_2.rot
      L9_2 = L9_2.y
      L8_2.ry = L9_2
      L9_2 = L6_2.rot
      L9_2 = L9_2.z
      L8_2.rz = L9_2
      L9_2 = math
      L9_2 = L9_2.floor
      L10_2 = L6_2.props
      L10_2 = L10_2.lod
      if not L10_2 then
        L10_2 = Config
        L10_2 = L10_2.objectDefaults
        L10_2 = L10_2.lod
      end
      L9_2 = L9_2(L10_2)
      L8_2.lod = L9_2
      L9_2 = L6_2.props
      L9_2 = L9_2.collision
      L9_2 = false ~= L9_2
      L8_2.collision = L9_2
      L9_2 = L6_2.props
      L9_2 = L9_2.frozen
      L9_2 = false ~= L9_2
      L8_2.frozen = L9_2
      L9_2 = L6_2.props
      L9_2 = L9_2.visible
      L9_2 = false ~= L9_2
      L8_2.visible = L9_2
      L9_2 = math
      L9_2 = L9_2.floor
      L10_2 = L6_2.props
      L10_2 = L10_2.alpha
      if not L10_2 then
        L10_2 = 255
      end
      L9_2 = L9_2(L10_2)
      L8_2.alpha = L9_2
      L9_2 = L6_2.blipOn
      L9_2 = true == L9_2
      L8_2.blipOn = L9_2
      L9_2 = L6_2.blipName
      if not L9_2 then
        L9_2 = ""
      end
      L8_2.blipName = L9_2
      L9_2 = math
      L9_2 = L9_2.floor
      L10_2 = L6_2.blipColor
      if not L10_2 then
        L10_2 = 0
      end
      L9_2 = L9_2(L10_2)
      L8_2.blipColor = L9_2
      L9_2 = L6_2.interior
      L9_2 = nil ~= L9_2
      L8_2.interior = L9_2
      L0_2[L7_2] = L8_2
    end
  end
  return L0_2
end
L11_1 = Maps
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L0_1
  if not L3_2 then
    L3_2 = true
    L2_1 = L3_2
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_1 = L3_2
  end
  L3_2 = TriggerServerEvent
  L4_2 = "0r-mapeditor:saveMap"
  L5_2 = {}
  L6_2 = L0_1
  L5_2.id = L6_2
  L6_2 = A0_2 or L6_2
  if not A0_2 then
    L6_2 = L1_1
    if not L6_2 then
      L6_2 = "Untitled"
    end
  end
  L5_2.name = L6_2
  L6_2 = A1_2 or L6_2
  if not A1_2 then
    L6_2 = "general"
  end
  L5_2.category = L6_2
  L6_2 = false ~= A2_2
  L5_2.permanent = L6_2
  L6_2 = L10_1
  L6_2 = L6_2()
  L5_2.objects = L6_2
  L6_2 = L9_1
  L6_2 = L6_2()
  L5_2.hidden = L6_2
  L6_2 = Lights
  if L6_2 then
    L6_2 = Lights
    L6_2 = L6_2.GetAll
    L6_2 = L6_2()
    if L6_2 then
      goto lbl_47
    end
  end
  L6_2 = {}
  ::lbl_47::
  L5_2.lights = L6_2
  L3_2(L4_2, L5_2)
end
L11_1.Save = L12_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  if not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = {}
  L3_2 = "local objects = {"
  L2_2[1] = L3_2
  L3_2 = 1
  L4_2 = #A0_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = A0_2[L6_2]
    L8_2 = #L2_2
    L8_2 = L8_2 + 1
    L9_2 = "  { eid = \"%s\", model = \"%s\", x = %.3f, y = %.3f, z = %.3f, rx = %.3f, ry = %.3f, rz = %.3f, lod = %d, alpha = %d, collision = %s, frozen = %s, visible = %s },"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L7_2.eid
    if not L11_2 then
      L11_2 = ""
    end
    L12_2 = L7_2.model
    L13_2 = L7_2.x
    L14_2 = L7_2.y
    L15_2 = L7_2.z
    L16_2 = L7_2.rx
    if not L16_2 then
      L16_2 = 0.0
    end
    L17_2 = L7_2.ry
    if not L17_2 then
      L17_2 = 0.0
    end
    L18_2 = L7_2.rz
    if not L18_2 then
      L18_2 = 0.0
    end
    L19_2 = math
    L19_2 = L19_2.floor
    L20_2 = L7_2.lod
    if not L20_2 then
      L20_2 = 500
    end
    L19_2 = L19_2(L20_2)
    L20_2 = math
    L20_2 = L20_2.floor
    L21_2 = L7_2.alpha
    if not L21_2 then
      L21_2 = 255
    end
    L20_2 = L20_2(L21_2)
    L21_2 = tostring
    L22_2 = L7_2.collision
    L22_2 = false ~= L22_2
    L21_2 = L21_2(L22_2)
    L22_2 = tostring
    L23_2 = L7_2.frozen
    L23_2 = false ~= L23_2
    L22_2 = L22_2(L23_2)
    L23_2 = tostring
    L24_2 = L7_2.visible
    L24_2 = false ~= L24_2
    L23_2, L24_2 = L23_2(L24_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L2_2[L8_2] = L9_2
  end
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "}"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "local hidden = {"
  L3_2 = 1
  L4_2 = #A1_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = A1_2[L6_2]
    L8_2 = #L2_2
    L8_2 = L8_2 + 1
    L9_2 = "  { model = \"%s\", x = %.3f, y = %.3f, z = %.3f, radius = %.3f },"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = tostring
    L12_2 = L7_2.model
    L11_2 = L11_2(L12_2)
    L12_2 = L7_2.x
    L13_2 = L7_2.y
    L14_2 = L7_2.z
    L15_2 = L7_2.radius
    if not L15_2 then
      L15_2 = 0.25
    end
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L2_2[L8_2] = L9_2
  end
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "}"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "CreateThread(function()"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "  for _, h in ipairs(hidden) do"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    local hm = tonumber(h.model) or joaat(h.model)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    CreateModelHideExcludingScriptObjects(h.x, h.y, h.z, h.radius or 0.25, hm, true)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "  end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "  for _, o in ipairs(objects) do"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    local mh = tonumber(o.model) or joaat(o.model)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    RequestModel(mh)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    while not HasModelLoaded(mh) do Wait(0) end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    local e = CreateObjectNoOffset(mh, o.x, o.y, o.z, false, false, false)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    SetEntityRotation(e, o.rx, o.ry, o.rz, 2, true)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    if o.lod then SetEntityLodDist(e, o.lod) end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    if o.collision == false then SetEntityCollision(e, false, false) else SetEntityCollision(e, true, true) end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    SetEntityVisible(e, o.visible ~= false, false)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    if o.alpha and o.alpha < 255 then SetEntityAlpha(e, o.alpha, false) end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    FreezeEntityPosition(e, o.frozen ~= false)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    SetModelAsNoLongerNeeded(mh)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "    Entity(e).state:set(\"0rme\", { eid = o.eid, model = o.model, x = o.x, y = o.y, z = o.z, rx = o.rx, ry = o.ry, rz = o.rz, lod = o.lod, alpha = o.alpha, collision = o.collision, frozen = o.frozen, visible = o.visible }, false)"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "  end"
  L3_2 = #L2_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = "end)"
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L2_2
  L5_2 = "\n"
  return L3_2(L4_2, L5_2)
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "&"
  L4_2 = "&amp;"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "<"
  L4_2 = "&lt;"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = ">"
  L4_2 = "&gt;"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L13_1(A0_2)
  local L1_2, L2_2
  L1_2 = joaat
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = 2147483647
  if L1_2 > L2_2 then
    L1_2 = L1_2 - 4294967296
  end
  return L1_2
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = {}
  L3_2 = A0_2.w
  L4_2 = A1_2.w
  L3_2 = L3_2 * L4_2
  L4_2 = A0_2.x
  L5_2 = A1_2.x
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.y
  L5_2 = A1_2.y
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.z
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L2_2.w = L3_2
  L3_2 = A0_2.w
  L4_2 = A1_2.x
  L3_2 = L3_2 * L4_2
  L4_2 = A0_2.x
  L5_2 = A1_2.w
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L4_2 = A0_2.y
  L5_2 = A1_2.z
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.y
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L2_2.x = L3_2
  L3_2 = A0_2.w
  L4_2 = A1_2.y
  L3_2 = L3_2 * L4_2
  L4_2 = A0_2.x
  L5_2 = A1_2.z
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.y
  L5_2 = A1_2.w
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.x
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L2_2.y = L3_2
  L3_2 = A0_2.w
  L4_2 = A1_2.z
  L3_2 = L3_2 * L4_2
  L4_2 = A0_2.x
  L5_2 = A1_2.y
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L4_2 = A0_2.y
  L5_2 = A1_2.x
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.w
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L2_2.z = L3_2
  return L2_2
end
function L15_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = math
  L4_2 = L4_2.rad
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  L4_2 = L4_2 * 0.5
  L5_2 = math
  L5_2 = L5_2.sin
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  L6_2 = {}
  L7_2 = math
  L7_2 = L7_2.cos
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  L6_2.w = L7_2
  L7_2 = A0_2 * L5_2
  L6_2.x = L7_2
  L7_2 = A1_2 * L5_2
  L6_2.y = L7_2
  L7_2 = A2_2 * L5_2
  L6_2.z = L7_2
  return L6_2
end
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L14_1
  L4_2 = L14_1
  L5_2 = L15_1
  L6_2 = 0.0
  L7_2 = 1.0
  L8_2 = 0.0
  L9_2 = A1_2 or L9_2
  if not A1_2 then
    L9_2 = 0.0
  end
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L6_2 = L15_1
  L7_2 = 1.0
  L8_2 = 0.0
  L9_2 = 0.0
  L10_2 = A0_2 or L10_2
  if not A0_2 then
    L10_2 = 0.0
  end
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L5_2 = L15_1
  L6_2 = 0.0
  L7_2 = 0.0
  L8_2 = 1.0
  L9_2 = A2_2 or L9_2
  if not A2_2 then
    L9_2 = 0.0
  end
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  L3_2 = "<SpoonerPlacements>"
  L4_2 = "  <ClearDatabase>true</ClearDatabase>"
  L5_2 = "  <ClearWorld>0</ClearWorld>"
  L6_2 = "  <IplsToLoad />"
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L2_2 = 1
  L3_2 = #A0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = A0_2[L5_2]
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "  <Placement>"
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <ModelHash>"
    L9_2 = L13_1
    L10_2 = L6_2.model
    L9_2 = L9_2(L10_2)
    L10_2 = "</ModelHash>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "    <Type>3</Type>"
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <Dynamic>"
    L9_2 = L6_2.collision
    if false == L9_2 then
      L9_2 = "true"
      if L9_2 then
        goto lbl_43
      end
    end
    L9_2 = "false"
    ::lbl_43::
    L10_2 = "</Dynamic>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <FrozenPos>"
    L9_2 = L6_2.frozen
    if false ~= L9_2 then
      L9_2 = "true"
      if L9_2 then
        goto lbl_57
      end
    end
    L9_2 = "false"
    ::lbl_57::
    L10_2 = "</FrozenPos>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <HashName>"
    L9_2 = L12_1
    L10_2 = L6_2.model
    L9_2 = L9_2(L10_2)
    L10_2 = "</HashName>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "    <InitialHandle>0</InitialHandle>"
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <OpacityLevel>"
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = L6_2.alpha
    if not L10_2 then
      L10_2 = 255
    end
    L9_2 = L9_2(L10_2)
    L10_2 = "</OpacityLevel>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <LodDistance>"
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = L6_2.lod
    if not L10_2 then
      L10_2 = 500
    end
    L9_2 = L9_2(L10_2)
    L10_2 = "</LodDistance>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "    <IsVisible>"
    L9_2 = L6_2.visible
    if false ~= L9_2 then
      L9_2 = "true"
      if L9_2 then
        goto lbl_113
      end
    end
    L9_2 = "false"
    ::lbl_113::
    L10_2 = "</IsVisible>"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "    <PositionRotation>"
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <X>%.4f</X>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.x
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <Y>%.4f</Y>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.y
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <Z>%.4f</Z>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.z
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <Pitch>%.4f</Pitch>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.rx
    if not L10_2 then
      L10_2 = 0.0
    end
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <Roll>%.4f</Roll>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.ry
    if not L10_2 then
      L10_2 = 0.0
    end
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = "      <Yaw>%.4f</Yaw>"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2.rz
    if not L10_2 then
      L10_2 = 0.0
    end
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "    </PositionRotation>"
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = "  </Placement>"
  end
  L2_2 = #L1_2
  L2_2 = L2_2 + 1
  L1_2[L2_2] = "</SpoonerPlacements>"
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = L1_2
  L4_2 = "\n"
  return L2_2(L3_2, L4_2)
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = tostring
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = "custom_map"
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "[^%w_]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  if "" == L2_2 then
    L2_2 = "custom_map"
  end
  L3_2 = 999999.0
  L4_2 = 999999.0
  L5_2 = 999999.0
  L6_2 = -999999.0
  L7_2 = -999999.0
  L8_2 = -999999.0
  L9_2 = 1
  L10_2 = #A0_2
  L11_2 = 1
  for L12_2 = L9_2, L10_2, L11_2 do
    L13_2 = A0_2[L12_2]
    L14_2 = L13_2.x
    if L3_2 > L14_2 then
      L3_2 = L13_2.x
    end
    L14_2 = L13_2.y
    if L4_2 > L14_2 then
      L4_2 = L13_2.y
    end
    L14_2 = L13_2.z
    if L5_2 > L14_2 then
      L5_2 = L13_2.z
    end
    L14_2 = L13_2.x
    if L6_2 < L14_2 then
      L6_2 = L13_2.x
    end
    L14_2 = L13_2.y
    if L7_2 < L14_2 then
      L7_2 = L13_2.y
    end
    L14_2 = L13_2.z
    if L8_2 < L14_2 then
      L8_2 = L13_2.z
    end
  end
  L9_2 = #A0_2
  if 0 == L9_2 then
    L9_2 = 0.0
    L10_2 = 0.0
    L11_2 = 0.0
    L12_2 = 0.0
    L13_2 = 0.0
    L8_2 = 0.0
    L7_2 = L13_2
    L6_2 = L12_2
    L5_2 = L11_2
    L4_2 = L10_2
    L3_2 = L9_2
  end
  L9_2 = {}
  L10_2 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  L11_2 = "<CMapData>"
  L12_2 = "  <name>"
  L13_2 = L2_2
  L14_2 = "</name>"
  L12_2 = L12_2 .. L13_2 .. L14_2
  L13_2 = "  <parent />"
  L14_2 = "  <flags value=\"0\" />"
  L15_2 = "  <contentFlags value=\"65\" />"
  L16_2 = "  <streamingExtentsMin x=\"%.4f\" y=\"%.4f\" z=\"%.4f\" />"
  L17_2 = L16_2
  L16_2 = L16_2.format
  L18_2 = L3_2 - 50.0
  L19_2 = L4_2 - 50.0
  L20_2 = L5_2 - 50.0
  L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
  L17_2 = "  <streamingExtentsMax x=\"%.4f\" y=\"%.4f\" z=\"%.4f\" />"
  L18_2 = L17_2
  L17_2 = L17_2.format
  L19_2 = L6_2 + 50.0
  L20_2 = L7_2 + 50.0
  L21_2 = L8_2 + 50.0
  L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
  L18_2 = "  <entitiesExtentsMin x=\"%.4f\" y=\"%.4f\" z=\"%.4f\" />"
  L19_2 = L18_2
  L18_2 = L18_2.format
  L20_2 = L3_2 - 25.0
  L21_2 = L4_2 - 25.0
  L22_2 = L5_2 - 25.0
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
  L19_2 = "  <entitiesExtentsMax x=\"%.4f\" y=\"%.4f\" z=\"%.4f\" />"
  L20_2 = L19_2
  L19_2 = L19_2.format
  L21_2 = L6_2 + 25.0
  L22_2 = L7_2 + 25.0
  L23_2 = L8_2 + 25.0
  L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
  L20_2 = "  <entities>"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L9_2[8] = L17_2
  L9_2[9] = L18_2
  L9_2[10] = L19_2
  L9_2[11] = L20_2
  L10_2 = 1
  L11_2 = #A0_2
  L12_2 = 1
  for L13_2 = L10_2, L11_2, L12_2 do
    L14_2 = A0_2[L13_2]
    L15_2 = L16_1
    L16_2 = L14_2.rx
    if not L16_2 then
      L16_2 = 0.0
    end
    L17_2 = L14_2.ry
    if not L17_2 then
      L17_2 = 0.0
    end
    L18_2 = L14_2.rz
    if not L18_2 then
      L18_2 = 0.0
    end
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "    <Item type=\"CEntityDef\">"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L17_2 = "      <archetypeName>"
    L18_2 = L12_1
    L19_2 = L14_2.model
    L18_2 = L18_2(L19_2)
    L19_2 = "</archetypeName>"
    L17_2 = L17_2 .. L18_2 .. L19_2
    L9_2[L16_2] = L17_2
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <flags value=\"0\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <guid value=\"0\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L17_2 = "      <position x=\"%.4f\" y=\"%.4f\" z=\"%.4f\" />"
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = L14_2.x
    L20_2 = L14_2.y
    L21_2 = L14_2.z
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
    L9_2[L16_2] = L17_2
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L17_2 = "      <rotation x=\"%.6f\" y=\"%.6f\" z=\"%.6f\" w=\"%.6f\" />"
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = L15_2.x
    L19_2 = -L19_2
    L20_2 = L15_2.y
    L20_2 = -L20_2
    L21_2 = L15_2.z
    L21_2 = -L21_2
    L22_2 = L15_2.w
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
    L9_2[L16_2] = L17_2
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <scaleXY value=\"1\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <scaleZ value=\"1\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <parentIndex value=\"-1\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L17_2 = "      <lodDist value=\"%d\" />"
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = math
    L19_2 = L19_2.floor
    L20_2 = L14_2.lod
    if not L20_2 then
      L20_2 = 500
    end
    L19_2, L20_2, L21_2, L22_2, L23_2 = L19_2(L20_2)
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L9_2[L16_2] = L17_2
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <childLodDist value=\"0\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <lodLevel>LODTYPES_DEPTH_ORPHANHD</lodLevel>"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <numChildren value=\"0\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <priorityLevel>PRI_REQUIRED</priorityLevel>"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <extensions />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <ambientOcclusionMultiplier value=\"255\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <artificialAmbientOcclusion value=\"255\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "      <tintValue value=\"0\" />"
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = "    </Item>"
  end
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  </entities>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <containerLods />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <boxOccluders />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <occludeModels />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <physicsDictionaries />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <instancedData>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <ImapLink />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <PropInstanceList />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <GrassInstanceList />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  </instancedData>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <timeCycleModifiers />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <carGenerators />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <LODLightsSOA />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <DistantLODLightsSOA />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  <block>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <version value=\"0\" />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <flags value=\"0\" />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L11_2 = "    <name>"
  L12_2 = L2_2
  L13_2 = "</name>"
  L11_2 = L11_2 .. L12_2 .. L13_2
  L9_2[L10_2] = L11_2
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <exportedBy>0r-mapeditor</exportedBy>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <owner />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "    <time />"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "  </block>"
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L9_2[L10_2] = "</CMapData>"
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L9_2
  L12_2 = "\n"
  return L10_2(L11_2, L12_2)
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = {}
  L2_2 = "model,x,y,z,rx,ry,rz,lod,collision,frozen,visible,alpha"
  L1_2[1] = L2_2
  L2_2 = 1
  L3_2 = #A0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = A0_2[L5_2]
    L7_2 = tostring
    L8_2 = L6_2.model
    L7_2 = L7_2(L8_2)
    L8_2 = L7_2
    L7_2 = L7_2.gsub
    L9_2 = "[,\r\n]"
    L10_2 = ""
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = #L1_2
    L8_2 = L8_2 + 1
    L9_2 = "%s,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%d,%s,%s,%s,%d"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L7_2
    L12_2 = L6_2.x
    L13_2 = L6_2.y
    L14_2 = L6_2.z
    L15_2 = L6_2.rx
    if not L15_2 then
      L15_2 = 0.0
    end
    L16_2 = L6_2.ry
    if not L16_2 then
      L16_2 = 0.0
    end
    L17_2 = L6_2.rz
    if not L17_2 then
      L17_2 = 0.0
    end
    L18_2 = math
    L18_2 = L18_2.floor
    L19_2 = L6_2.lod
    if not L19_2 then
      L19_2 = 500
    end
    L18_2 = L18_2(L19_2)
    L19_2 = tostring
    L20_2 = L6_2.collision
    L20_2 = false ~= L20_2
    L19_2 = L19_2(L20_2)
    L20_2 = tostring
    L21_2 = L6_2.frozen
    L21_2 = false ~= L21_2
    L20_2 = L20_2(L21_2)
    L21_2 = tostring
    L22_2 = L6_2.visible
    L22_2 = false ~= L22_2
    L21_2 = L21_2(L22_2)
    L22_2 = math
    L22_2 = L22_2.floor
    L23_2 = L6_2.alpha
    if not L23_2 then
      L23_2 = 255
    end
    L22_2, L23_2 = L22_2(L23_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L1_2[L8_2] = L9_2
  end
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = L1_2
  L4_2 = "\n"
  return L2_2(L3_2, L4_2)
end
function L20_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.collision
  L1_2 = false == L1_2
  return L1_2
end
function L21_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L4_2 = {}
  if A0_2 then
    L5_2 = #A0_2
    if L5_2 > 0 then
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "local scripted = {"
      L5_2 = 1
      L6_2 = #A0_2
      L7_2 = 1
      for L8_2 = L5_2, L6_2, L7_2 do
        L9_2 = A0_2[L8_2]
        L10_2 = #L4_2
        L10_2 = L10_2 + 1
        L11_2 = "  { model = \"%s\", x = %.3f, y = %.3f, z = %.3f, rx = %.3f, ry = %.3f, rz = %.3f, lod = %d, alpha = %d, collision = %s, frozen = %s, visible = %s },"
        L12_2 = L11_2
        L11_2 = L11_2.format
        L13_2 = L9_2.model
        L14_2 = L9_2.x
        L15_2 = L9_2.y
        L16_2 = L9_2.z
        L17_2 = L9_2.rx
        if not L17_2 then
          L17_2 = 0.0
        end
        L18_2 = L9_2.ry
        if not L18_2 then
          L18_2 = 0.0
        end
        L19_2 = L9_2.rz
        if not L19_2 then
          L19_2 = 0.0
        end
        L20_2 = math
        L20_2 = L20_2.floor
        L21_2 = L9_2.lod
        if not L21_2 then
          L21_2 = 500
        end
        L20_2 = L20_2(L21_2)
        L21_2 = math
        L21_2 = L21_2.floor
        L22_2 = L9_2.alpha
        if not L22_2 then
          L22_2 = 255
        end
        L21_2 = L21_2(L22_2)
        L22_2 = tostring
        L23_2 = L9_2.collision
        L23_2 = false ~= L23_2
        L22_2 = L22_2(L23_2)
        L23_2 = tostring
        L24_2 = L9_2.frozen
        L24_2 = false ~= L24_2
        L23_2 = L23_2(L24_2)
        L24_2 = tostring
        L25_2 = L9_2.visible
        L25_2 = false ~= L25_2
        L24_2, L25_2 = L24_2(L25_2)
        L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
        L4_2[L10_2] = L11_2
      end
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "}"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "local roomPend = {}"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "local function roomKey(it, x, y, z)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  local c = GetInteriorRoomCount(it) or 0"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  for ri = 1, c - 1 do"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    local ax, ay, az, bx, by, bz = GetInteriorRoomExtents(it, ri)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    if ax and x >= ax and x <= bx and y >= ay and y <= by and z >= az and z <= bz then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      local nm = GetInteriorRoomName(it, ri)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      if nm and nm ~= \"\" then return joaat(nm) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  return 0"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "local function assignRoom(e, x, y, z)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  local it = GetInteriorAtCoords(x, y, z)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  if it == 0 then return false end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  local rk = roomKey(it, x, y, z)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  if rk == 0 then rk = GetRoomKeyFromEntity(PlayerPedId()) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  if rk ~= 0 then ForceRoomForEntity(e, it, rk); return true end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  return false"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "CreateThread(function()"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  for _, o in ipairs(scripted) do"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    local mh = tonumber(o.model) or joaat(o.model)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    if IsModelValid(mh) then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      RequestModel(mh)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      local t = 0"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      while not HasModelLoaded(mh) and t < 500 do Wait(0); t = t + 1 end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      if HasModelLoaded(mh) then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        local e = CreateObjectNoOffset(mh, o.x, o.y, o.z, false, false, false)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        if e ~= 0 and DoesEntityExist(e) then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          SetEntityRotation(e, o.rx, o.ry, o.rz, 2, true)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          if o.lod then SetEntityLodDist(e, o.lod) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          if o.collision == false then SetEntityCollision(e, false, false) else SetEntityCollision(e, true, true) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          SetEntityVisible(e, o.visible ~= false, false)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          if o.alpha and o.alpha < 255 then SetEntityAlpha(e, o.alpha, false) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          FreezeEntityPosition(e, o.frozen ~= false)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "          if not assignRoom(e, o.x, o.y, o.z) then roomPend[#roomPend + 1] = { e = e, x = o.x, y = o.y, z = o.z } end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        SetModelAsNoLongerNeeded(mh)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  while #roomPend > 0 do"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    Wait(3000)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    local pc = GetEntityCoords(PlayerPedId())"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    for i = #roomPend, 1, -1 do"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      local p = roomPend[i]"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      if not DoesEntityExist(p.e) then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        table.remove(roomPend, i)"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      elseif #(pc - vector3(p.x, p.y, p.z)) < 80.0 then"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "        if assignRoom(p.e, p.x, p.y, p.z) then table.remove(roomPend, i) end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "      end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "    end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "  end"
      L5_2 = #L4_2
      L5_2 = L5_2 + 1
      L4_2[L5_2] = "end)"
    end
  end
  L5_2 = {}
  L6_2 = 1
  L7_2 = A1_2 or L7_2
  if not A1_2 then
    L7_2 = {}
  end
  L7_2 = #L7_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = A1_2[L9_2]
    L10_2 = L10_2.frozen
    if false ~= L10_2 then
      L10_2 = #L5_2
      L10_2 = L10_2 + 1
      L11_2 = A1_2[L9_2]
      L5_2[L10_2] = L11_2
    end
  end
  L6_2 = #L5_2
  if L6_2 > 0 then
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "local frozenObjs = {"
    L6_2 = 1
    L7_2 = #L5_2
    L8_2 = 1
    for L9_2 = L6_2, L7_2, L8_2 do
      L10_2 = L5_2[L9_2]
      L11_2 = #L4_2
      L11_2 = L11_2 + 1
      L12_2 = "  { model = \"%s\", x = %.3f, y = %.3f, z = %.3f },"
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L10_2.model
      L15_2 = L10_2.x
      L16_2 = L10_2.y
      L17_2 = L10_2.z
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      L4_2[L11_2] = L12_2
    end
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "}"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "CreateThread(function()"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "  while true do"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "    local pc = GetEntityCoords(PlayerPedId())"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "    local claimed = {}"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "    for i = 1, #frozenObjs do"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "      local o = frozenObjs[i]"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "      if #(pc - vector3(o.x, o.y, o.z)) < 150.0 then"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "        local mh = tonumber(o.model) or joaat(o.model)"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "        local e = GetClosestObjectOfType(o.x, o.y, o.z, 1.5, mh, false, false, false)"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "        if e ~= 0 and DoesEntityExist(e) and not claimed[e] then claimed[e] = true; FreezeEntityPosition(e, true) end"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "      end"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "    end"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "    Wait(2000)"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "  end"
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L4_2[L6_2] = "end)"
  end
  if A2_2 then
    L6_2 = #A2_2
    if L6_2 > 0 then
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "local hidden = {"
      L6_2 = 1
      L7_2 = #A2_2
      L8_2 = 1
      for L9_2 = L6_2, L7_2, L8_2 do
        L10_2 = A2_2[L9_2]
        L11_2 = #L4_2
        L11_2 = L11_2 + 1
        L12_2 = "  { model = \"%s\", x = %.3f, y = %.3f, z = %.3f, radius = %.3f },"
        L13_2 = L12_2
        L12_2 = L12_2.format
        L14_2 = tostring
        L15_2 = L10_2.model
        L14_2 = L14_2(L15_2)
        L15_2 = L10_2.x
        L16_2 = L10_2.y
        L17_2 = L10_2.z
        L18_2 = L10_2.radius
        if not L18_2 then
          L18_2 = 0.25
        end
        L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
        L4_2[L11_2] = L12_2
      end
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "}"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "CreateThread(function()"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "  for _, h in ipairs(hidden) do"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "    local hm = tonumber(h.model) or joaat(h.model)"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "    CreateModelHideExcludingScriptObjects(h.x, h.y, h.z, h.radius or 0.25, hm, true)"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "  end"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "end)"
    end
  end
  if A3_2 then
    L6_2 = #A3_2
    if L6_2 > 0 then
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "local lights = {"
      L6_2 = 1
      L7_2 = #A3_2
      L8_2 = 1
      for L9_2 = L6_2, L7_2, L8_2 do
        L10_2 = A3_2[L9_2]
        L11_2 = #L4_2
        L11_2 = L11_2 + 1
        L12_2 = "  { x = %.3f, y = %.3f, z = %.3f, r = %d, g = %d, b = %d, range = %.2f, intensity = %.2f },"
        L13_2 = L12_2
        L12_2 = L12_2.format
        L14_2 = L10_2.x
        L15_2 = L10_2.y
        L16_2 = L10_2.z
        L17_2 = math
        L17_2 = L17_2.floor
        L18_2 = L10_2.r
        if not L18_2 then
          L18_2 = 255
        end
        L17_2 = L17_2(L18_2)
        L18_2 = math
        L18_2 = L18_2.floor
        L19_2 = L10_2.g
        if not L19_2 then
          L19_2 = 255
        end
        L18_2 = L18_2(L19_2)
        L19_2 = math
        L19_2 = L19_2.floor
        L20_2 = L10_2.b
        if not L20_2 then
          L20_2 = 255
        end
        L19_2 = L19_2(L20_2)
        L20_2 = L10_2.range
        if not L20_2 then
          L20_2 = 12.0
        end
        L21_2 = L10_2.intensity
        if not L21_2 then
          L21_2 = 5.0
        end
        L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
        L4_2[L11_2] = L12_2
      end
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "}"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "CreateThread(function()"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "  while true do"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "    for i = 1, #lights do"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "      local l = lights[i]"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "      DrawLightWithRange(l.x, l.y, l.z, l.r, l.g, l.b, l.range, l.intensity)"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "    end"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "    Wait(0)"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "  end"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L4_2[L6_2] = "end)"
    end
  end
  L6_2 = #L4_2
  if 0 == L6_2 then
    L6_2 = ""
    return L6_2
  end
  L6_2 = table
  L6_2 = L6_2.concat
  L7_2 = L4_2
  L8_2 = "\n"
  return L6_2(L7_2, L8_2)
end
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = table
  L0_2 = L0_2.concat
  L1_2 = {}
  L2_2 = "fx_version 'cerulean'"
  L3_2 = "game 'gta5'"
  L4_2 = ""
  L5_2 = "this_is_a_map 'yes'"
  L6_2 = ""
  L7_2 = "client_script 'client.lua'"
  L8_2 = ""
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L2_2 = "\n"
  return L0_2(L1_2, L2_2)
end
L23_1 = Maps
function L24_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = L10_1
  L0_2 = L0_2()
  L1_2 = L9_1
  L1_2 = L1_2()
  L2_2 = Lights
  if L2_2 then
    L2_2 = Lights
    L2_2 = L2_2.GetAll
    L2_2 = L2_2()
    if L2_2 then
      goto lbl_15
    end
  end
  L2_2 = {}
  ::lbl_15::
  L3_2 = L1_1
  if not L3_2 then
    L3_2 = "Untitled"
  end
  L4_2 = L0_1
  if L4_2 then
    L4_2 = L3_2
    L5_2 = "-"
    L6_2 = L0_1
    L4_2 = L4_2 .. L5_2 .. L6_2
    L3_2 = L4_2
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = 1
  L7_2 = #L0_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = L0_2[L9_2]
    L11_2 = L20_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = L10_2.interior
      if not L11_2 then
        L11_2 = GetInteriorAtCoords
        L12_2 = L10_2.x
        L13_2 = L10_2.y
        L14_2 = L10_2.z
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        if 0 == L11_2 then
          goto lbl_56
        end
      end
    end
    L11_2 = #L5_2
    L11_2 = L11_2 + 1
    L5_2[L11_2] = L10_2
    goto lbl_60
    ::lbl_56::
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L4_2[L11_2] = L10_2
    ::lbl_60::
  end
  L6_2 = json
  L6_2 = L6_2.encode
  L7_2 = {}
  L8_2 = L1_1
  if not L8_2 then
    L8_2 = "Untitled"
  end
  L7_2.name = L8_2
  L7_2.objects = L0_2
  L7_2.hidden = L1_2
  L7_2.lights = L2_2
  L6_2 = L6_2(L7_2)
  L7_2 = TriggerServerEvent
  L8_2 = "0r-mapeditor:publishYmap"
  L9_2 = L3_2
  L10_2 = L19_1
  L11_2 = L4_2
  L10_2 = L10_2(L11_2)
  L11_2 = L21_1
  L12_2 = L5_2
  L13_2 = L4_2
  L14_2 = L1_2
  L15_2 = L2_2
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  L12_2 = L22_1
  L12_2 = L12_2()
  L13_2 = L6_2
  L14_2 = L7_1
  L14_2, L15_2 = L14_2()
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L7_2 = MELog
  if L7_2 then
    L7_2 = MELog
    L8_2 = "publish_ymap"
    L9_2 = L3_2
    L7_2(L8_2, L9_2)
  end
end
L23_1.PublishYmap = L24_1
L23_1 = Maps
function L24_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = {}
  L1_2 = L1_1
  if not L1_2 then
    L1_2 = "Untitled"
  end
  L0_2.name = L1_2
  L1_2 = L10_1
  L1_2 = L1_2()
  L0_2.objects = L1_2
  L1_2 = L9_1
  L1_2 = L1_2()
  L0_2.hidden = L1_2
  L1_2 = Lights
  if L1_2 then
    L1_2 = Lights
    L1_2 = L1_2.GetAll
    L1_2 = L1_2()
    if L1_2 then
      goto lbl_24
    end
  end
  L1_2 = {}
  ::lbl_24::
  L0_2.lights = L1_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "exportData"
  L3_2 = {}
  L4_2 = json
  L4_2 = L4_2.encode
  L5_2 = L0_2
  L4_2 = L4_2(L5_2)
  L3_2.json = L4_2
  L4_2 = L11_1
  L5_2 = L0_2.objects
  L6_2 = L0_2.hidden
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.lua = L4_2
  L4_2 = L18_1
  L5_2 = L0_2.objects
  L6_2 = L0_2.name
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.ymap = L4_2
  L4_2 = L17_1
  L5_2 = L0_2.objects
  L4_2 = L4_2(L5_2)
  L3_2.menyoo = L4_2
  L4_2 = L19_1
  L5_2 = L0_2.objects
  L4_2 = L4_2(L5_2)
  L3_2.csv = L4_2
  L4_2 = L0_2.objects
  L4_2 = #L4_2
  L3_2.count = L4_2
  L4_2 = L7_1
  L4_2 = L4_2()
  L4_2 = #L4_2
  L3_2.customCount = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
  L1_2 = MELog
  if L1_2 then
    L1_2 = MELog
    L2_2 = "export"
    L3_2 = tostring
    L4_2 = L0_2.objects
    L4_2 = #L4_2
    L3_2 = L3_2(L4_2)
    L4_2 = " objects"
    L3_2 = L3_2 .. L4_2
    L1_2(L2_2, L3_2)
  end
end
L23_1.Export = L24_1
L23_1 = Maps
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
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
      goto lbl_21
    end
  end
  L3_2 = Bridge
  L3_2 = L3_2.Notify
  L4_2 = locale
  L5_2 = "notify.invalid_json"
  L4_2 = L4_2(L5_2)
  L5_2 = "error"
  L3_2(L4_2, L5_2)
  do return end
  ::lbl_21::
  L3_2 = L1_1
  if not L3_2 then
    L3_2 = L2_2.name
    L1_1 = L3_2
  end
  L3_2 = L2_2.objects
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = 1
  L5_2 = #L3_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L3_2[L7_2]
    L9_2 = Objects
    L9_2 = L9_2.Spawn
    L10_2 = L8_2.model
    L11_2 = vector3
    L12_2 = L8_2.x
    L13_2 = L8_2.y
    L14_2 = L8_2.z
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    L12_2 = vector3
    L13_2 = L8_2.rx
    if not L13_2 then
      L13_2 = 0.0
    end
    L14_2 = L8_2.ry
    if not L14_2 then
      L14_2 = 0.0
    end
    L15_2 = L8_2.rz
    if not L15_2 then
      L15_2 = 0.0
    end
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    L13_2 = {}
    L14_2 = L8_2.lod
    L13_2.lod = L14_2
    L14_2 = L8_2.alpha
    L13_2.alpha = L14_2
    L14_2 = L8_2.collision
    L14_2 = false ~= L14_2
    L13_2.collision = L14_2
    L14_2 = L8_2.frozen
    L14_2 = false ~= L14_2
    L13_2.frozen = L14_2
    L14_2 = L8_2.visible
    L14_2 = false ~= L14_2
    L13_2.visible = L14_2
    L14_2 = nil
    L15_2 = L8_2.eid
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    if L9_2 then
      L10_2 = MEAutoSave
      if L10_2 then
        L10_2 = MEAutoSave
        L11_2 = L9_2
        L10_2(L11_2)
      end
    end
  end
  L4_2 = WorldProps
  if L4_2 then
    L4_2 = L2_2.hidden
    if L4_2 then
      L4_2 = 1
      L5_2 = L2_2.hidden
      L5_2 = #L5_2
      L6_2 = 1
      for L7_2 = L4_2, L5_2, L6_2 do
        L8_2 = L2_2.hidden
        L8_2 = L8_2[L7_2]
        L9_2 = WorldProps
        L9_2 = L9_2.HideEntry
        L10_2 = {}
        L11_2 = L8_2.model
        L10_2.model = L11_2
        L11_2 = L8_2.x
        L10_2.x = L11_2
        L11_2 = L8_2.y
        L10_2.y = L11_2
        L11_2 = L8_2.z
        L10_2.z = L11_2
        L11_2 = L8_2.radius
        if not L11_2 then
          L11_2 = 0.25
        end
        L10_2.radius = L11_2
        L9_2(L10_2)
      end
    end
  end
  L4_2 = Lights
  if L4_2 then
    L4_2 = L2_2.lights
    if L4_2 then
      L4_2 = 1
      L5_2 = L2_2.lights
      L5_2 = #L5_2
      L6_2 = 1
      for L7_2 = L4_2, L5_2, L6_2 do
        L8_2 = Lights
        L8_2 = L8_2.AddRaw
        L9_2 = L2_2.lights
        L9_2 = L9_2[L7_2]
        L8_2(L9_2)
      end
    end
  end
  L4_2 = MELog
  if L4_2 then
    L4_2 = MELog
    L5_2 = "import"
    L6_2 = tostring
    L7_2 = #L3_2
    L6_2 = L6_2(L7_2)
    L7_2 = " objects"
    L6_2 = L6_2 .. L7_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = Bridge
  L4_2 = L4_2.Notify
  L5_2 = locale
  L6_2 = "notify.imported"
  L7_2 = #L3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = "success"
  L4_2(L5_2, L6_2)
  L4_2 = MEDockDirty
  if L4_2 then
    L4_2 = MEDockDirty
    L5_2 = "objects"
    L4_2(L5_2)
    L4_2 = MEDockDirty
    L5_2 = "hidden"
    L4_2(L5_2)
  end
  L4_2 = SendNUIMessage
  L5_2 = {}
  L5_2.action = "mapLoaded"
  L6_2 = {}
  L7_2 = L0_1
  L6_2.id = L7_2
  L7_2 = L1_1
  if not L7_2 then
    L7_2 = L2_2.name
    if not L7_2 then
      L7_2 = "Imported"
    end
  end
  L6_2.name = L7_2
  L7_2 = Objects
  L7_2 = L7_2.Count
  L7_2 = L7_2()
  L6_2.count = L7_2
  L5_2.data = L6_2
  L4_2(L5_2)
end
L23_1.ImportJson = L24_1
L23_1 = Maps
function L24_1()
  local L0_2, L1_2
  L0_2 = TriggerServerEvent
  L1_2 = "0r-mapeditor:getMaps"
  L0_2(L1_2)
end
L23_1.RequestList = L24_1
L23_1 = Maps
function L24_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = TriggerServerEvent
  L2_2 = "0r-mapeditor:requestLoad"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L23_1.RequestLoad = L24_1
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = Objects
  L1_2 = L1_2.Clear
  L1_2()
  L1_2 = 1
  L2_2 = A0_2.objects
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = A0_2.objects
    L5_2 = L5_2[L4_2]
    L6_2 = Objects
    L6_2 = L6_2.Spawn
    L7_2 = L5_2.model
    L8_2 = vector3
    L9_2 = L5_2.x
    L10_2 = L5_2.y
    L11_2 = L5_2.z
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L9_2 = vector3
    L10_2 = L5_2.rx
    L11_2 = L5_2.ry
    L12_2 = L5_2.rz
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = {}
    L11_2 = L5_2.lod
    L10_2.lod = L11_2
    L11_2 = L5_2.alpha
    L10_2.alpha = L11_2
    L11_2 = L5_2.collision
    L11_2 = 1 == L11_2
    L10_2.collision = L11_2
    L11_2 = L5_2.frozen
    L11_2 = 1 == L11_2
    L10_2.frozen = L11_2
    L11_2 = L5_2.visible
    L11_2 = 1 == L11_2
    L10_2.visible = L11_2
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    if L6_2 then
      L7_2 = L5_2.id
      if L7_2 then
        L7_2 = Objects
        L7_2 = L7_2.SetDbId
        L8_2 = L6_2
        L9_2 = L5_2.id
        L7_2(L8_2, L9_2)
      end
    end
    if L6_2 then
      L7_2 = L5_2.blip_on
      if 1 ~= L7_2 then
        L7_2 = L5_2.blip_on
        if true ~= L7_2 then
          goto lbl_89
        end
      end
      L7_2 = Objects
      L7_2 = L7_2.SetBlip
      L8_2 = L6_2
      L9_2 = L5_2.blip_name
      if not L9_2 then
        L9_2 = ""
      end
      L10_2 = L5_2.blip_color
      if not L10_2 then
        L10_2 = 0
      end
      L11_2 = true
      L7_2(L8_2, L9_2, L10_2, L11_2)
    end
    ::lbl_89::
  end
end
L24_1 = RegisterNetEvent
L25_1 = "0r-mapeditor:loadMap"
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L23_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = WorldProps
  if L1_2 then
    L1_2 = WorldProps
    L1_2 = L1_2.ApplyHidden
    L2_2 = A0_2.hidden
    if not L2_2 then
      L2_2 = {}
    end
    L1_2(L2_2)
  end
  L1_2 = Lights
  if L1_2 then
    L1_2 = Lights
    L1_2 = L1_2.Clear
    L1_2()
    L1_2 = A0_2.lights
    if L1_2 then
      L1_2 = 1
      L2_2 = A0_2.lights
      L2_2 = #L2_2
      L3_2 = 1
      for L4_2 = L1_2, L2_2, L3_2 do
        L5_2 = A0_2.lights
        L5_2 = L5_2[L4_2]
        L6_2 = Lights
        L6_2 = L6_2.AddRaw
        L7_2 = {}
        L8_2 = L5_2.x
        L7_2.x = L8_2
        L8_2 = L5_2.y
        L7_2.y = L8_2
        L8_2 = L5_2.z
        L7_2.z = L8_2
        L8_2 = L5_2.r
        L7_2.r = L8_2
        L8_2 = L5_2.g
        L7_2.g = L8_2
        L8_2 = L5_2.b
        L7_2.b = L8_2
        L8_2 = L5_2.range_m
        if not L8_2 then
          L8_2 = L5_2.range
        end
        L7_2.range = L8_2
        L8_2 = L5_2.intensity
        L7_2.intensity = L8_2
        L6_2(L7_2)
      end
    end
  end
  L1_2 = A0_2.id
  L2_2 = A0_2.name
  L1_1 = L2_2
  L0_1 = L1_2
  L1_2 = false
  L2_2 = {}
  L4_1 = L2_2
  L2_1 = L1_2
  L1_2 = History
  if L1_2 then
    L1_2 = History
    L1_2 = L1_2.Clear
    L1_2()
  end
  L1_2 = MEAutoSaveReset
  if L1_2 then
    L1_2 = MEAutoSaveReset
    L1_2()
  end
  L1_2 = Array
  if L1_2 then
    L1_2 = Array
    L1_2 = L1_2.Cancel
    L1_2()
  end
  L1_2 = Prefab
  if L1_2 then
    L1_2 = Prefab
    L1_2 = L1_2.Cancel
    L1_2()
  end
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "mapLoaded"
  L3_2 = {}
  L4_2 = A0_2.id
  L3_2.id = L4_2
  L4_2 = A0_2.name
  L3_2.name = L4_2
  L4_2 = A0_2.objects
  L4_2 = #L4_2
  L3_2.count = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNetEvent
L25_1 = "0r-mapeditor:objectSaved"
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    return
  end
  L1_2 = A0_2.mapId
  if L1_2 then
    L1_2 = L0_1
    if not L1_2 then
      L1_2 = A0_2.mapId
      L2_2 = A0_2.name
      L1_1 = L2_2
      L0_1 = L1_2
      L1_2 = false
      L2_1 = L1_2
      L1_2 = L4_1
      L2_2 = {}
      L4_1 = L2_2
      L2_2 = pairs
      L3_2 = L1_2
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
      for L6_2 in L2_2, L3_2, L4_2, L5_2 do
        L7_2 = Objects
        L7_2 = L7_2.Get
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if L7_2 then
          L7_2 = L8_1
          L8_2 = L6_2
          L7_2(L8_2)
        end
      end
    end
  end
  L1_2 = A0_2.localId
  if L1_2 then
    L1_2 = A0_2.dbId
    if L1_2 then
      L1_2 = Objects
      L1_2 = L1_2.SetDbId
      L2_2 = A0_2.localId
      L3_2 = A0_2.dbId
      L1_2(L2_2, L3_2)
    end
  end
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "mapSaved"
  L3_2 = {}
  L4_2 = L0_1
  L3_2.id = L4_2
  L4_2 = L1_1
  L3_2.name = L4_2
  L2_2.data = L3_2
  L1_2(L2_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNetEvent
L25_1 = "0r-mapeditor:mapSaved"
function L26_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = A0_2
  L1_1 = A1_2
  L0_1 = L4_2
  L4_2 = false
  L2_1 = L4_2
  L4_2 = type
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = 1
    L5_2 = #A3_2
    L6_2 = 1
    for L7_2 = L4_2, L5_2, L6_2 do
      L8_2 = Objects
      L8_2 = L8_2.SetDbId
      L9_2 = A3_2[L7_2]
      L9_2 = L9_2.localId
      L10_2 = A3_2[L7_2]
      L10_2 = L10_2.dbId
      L8_2(L9_2, L10_2)
    end
  end
  L4_2 = L4_1
  L5_2 = {}
  L4_1 = L5_2
  L5_2 = pairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2 in L5_2, L6_2, L7_2, L8_2 do
    L10_2 = Objects
    L10_2 = L10_2.Get
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L10_2 = L8_1
      L11_2 = L9_2
      L10_2(L11_2)
    end
  end
  L5_2 = Bridge
  L5_2 = L5_2.Notify
  L6_2 = locale
  L7_2 = "notify.map_saved"
  L8_2 = A1_2
  L9_2 = A2_2 or L9_2
  if not A2_2 then
    L9_2 = 0
  end
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = "success"
  L5_2(L6_2, L7_2)
  L5_2 = SendNUIMessage
  L6_2 = {}
  L6_2.action = "mapSaved"
  L7_2 = {}
  L7_2.id = A0_2
  L7_2.name = A1_2
  L6_2.data = L7_2
  L5_2(L6_2)
end
L24_1(L25_1, L26_1)
L24_1 = RegisterNetEvent
L25_1 = "0r-mapeditor:mapList"
function L26_1(A0_2)
  local L1_2, L2_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.action = "mapList"
  L2_2.data = A0_2
  L1_2(L2_2)
end
L24_1(L25_1, L26_1)
