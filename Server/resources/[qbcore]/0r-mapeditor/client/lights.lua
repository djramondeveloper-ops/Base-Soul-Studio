local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1
L0_1 = {}
Lights = L0_1
L0_1 = false
L1_1 = false
L2_1 = {}
L3_1 = 0
L4_1 = {}
L4_1.r = 255
L4_1.g = 200
L4_1.b = 120
L4_1.range = 12.0
L4_1.intensity = 5.0
function L5_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "lights"
  L2_2 = {}
  L3_2 = L0_1
  L2_2.placing = L3_2
  L3_2 = L3_1
  if L3_2 > 0 then
    L3_2 = Lights
    L3_2 = L3_2.Count
    L3_2 = L3_2()
    if L3_2 then
      goto lbl_18
    end
  end
  L3_2 = 0
  ::lbl_18::
  L2_2.count = L3_2
  L3_2 = L4_1.r
  L2_2.r = L3_2
  L3_2 = L4_1.g
  L2_2.g = L3_2
  L3_2 = L4_1.b
  L2_2.b = L3_2
  L3_2 = L4_1.range
  L2_2.range = L3_2
  L3_2 = L4_1.intensity
  L2_2.intensity = L3_2
  L3_2 = Lights
  L3_2 = L3_2.GetListForUI
  L3_2 = L3_2()
  L2_2.list = L3_2
  L1_2.data = L2_2
  L0_2(L1_2)
end
L6_1 = Lights
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 0
  L1_2 = pairs
  L2_2 = L2_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L0_2 = L0_2 + 1
  end
  return L0_2
end
L6_1.Count = L7_1
L6_1 = Lights
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = A0_2 or L4_2
  if not A0_2 then
    L4_2 = L4_1.r
  end
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = A1_2 or L5_2
  if not A1_2 then
    L5_2 = L4_1.g
  end
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = A2_2 or L6_2
  if not A2_2 then
    L6_2 = L4_1.b
  end
  L5_2 = L5_2(L6_2)
  L4_1.b = L5_2
  L4_1.g = L4_2
  L4_1.r = L3_2
end
L6_1.SetColor = L7_1
L6_1 = Lights
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 1.0
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L4_1.range
  end
  L1_2 = L1_2(L2_2, L3_2)
  L4_1.range = L1_2
end
L6_1.SetRange = L7_1
L6_1 = Lights
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 0.5
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L4_1.intensity
  end
  L1_2 = L1_2(L2_2, L3_2)
  L4_1.intensity = L1_2
end
L6_1.SetIntensity = L7_1
L6_1 = Lights
function L7_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L6_1.IsPlacing = L7_1
L6_1 = Lights
function L7_1(A0_2)
  local L1_2
  L1_2 = true == A0_2
  L1_1 = L1_2
end
L6_1.SetActive = L7_1
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Raycast
  L0_2 = L0_2.Cursor
  L1_2 = "lights"
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
L7_1 = Lights
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L3_1
  L1_2 = L1_2 + 1
  L3_1 = L1_2
  L1_2 = L3_1
  L2_2 = {}
  L3_2 = vector3
  L4_2 = 0.0
  L5_2 = 0.0
  L6_2 = 1.0
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = A0_2 + L3_2
  L2_2.coords = L3_2
  L3_2 = L4_1.r
  L2_2.r = L3_2
  L3_2 = L4_1.g
  L2_2.g = L3_2
  L3_2 = L4_1.b
  L2_2.b = L3_2
  L3_2 = L4_1.range
  L2_2.range = L3_2
  L3_2 = L4_1.intensity
  L2_2.intensity = L3_2
  L3_2 = L2_1
  L3_2[L1_2] = L2_2
  L3_2 = L5_1
  L3_2()
  L3_2 = MELog
  if L3_2 then
    L3_2 = MELog
    L4_2 = "light_add"
    L5_2 = "rgb %d,%d,%d r%.0f"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = L4_1.r
    L8_2 = L4_1.g
    L9_2 = L4_1.b
    L10_2 = L4_1.range
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L3_2 = History
  if L3_2 then
    L3_2 = Cmd
    if L3_2 then
      L3_2 = Cmd
      L3_2 = L3_2.LightAdd
      if L3_2 then
        L3_2 = History
        L3_2 = L3_2.IsApplying
        L3_2 = L3_2()
        if not L3_2 then
          L3_2 = History
          L3_2 = L3_2.Push
          L4_2 = Cmd
          L4_2 = L4_2.LightAdd
          L5_2 = L1_2
          L6_2 = {}
          L7_2 = L2_2.coords
          L7_2 = L7_2.x
          L6_2.x = L7_2
          L7_2 = L2_2.coords
          L7_2 = L7_2.y
          L6_2.y = L7_2
          L7_2 = L2_2.coords
          L7_2 = L7_2.z
          L6_2.z = L7_2
          L7_2 = L2_2.r
          L6_2.r = L7_2
          L7_2 = L2_2.g
          L6_2.g = L7_2
          L7_2 = L2_2.b
          L6_2.b = L7_2
          L7_2 = L2_2.range
          L6_2.range = L7_2
          L7_2 = L2_2.intensity
          L6_2.intensity = L7_2
          L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2, L6_2)
          L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
        end
      end
    end
  end
  return L1_2
end
L7_1.Add = L8_1
L7_1 = Lights
function L8_1()
  local L0_2, L1_2
  L0_2 = {}
  L2_1 = L0_2
  L0_2 = L5_1
  L0_2()
end
L7_1.Clear = L8_1
L7_1 = Lights
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = History
  if L0_2 then
    L0_2 = Cmd
    if L0_2 then
      L0_2 = Cmd
      L0_2 = L0_2.LightDel
      if L0_2 then
        L0_2 = Cmd
        L0_2 = L0_2.Batch
        if L0_2 then
          L0_2 = History
          L0_2 = L0_2.IsApplying
          L0_2 = L0_2()
          if not L0_2 then
            L0_2 = {}
            L1_2 = pairs
            L2_2 = L2_1
            L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
            for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
              L7_2 = #L0_2
              L7_2 = L7_2 + 1
              L8_2 = Cmd
              L8_2 = L8_2.LightDel
              L9_2 = L5_2
              L10_2 = {}
              L11_2 = L6_2.coords
              L11_2 = L11_2.x
              L10_2.x = L11_2
              L11_2 = L6_2.coords
              L11_2 = L11_2.y
              L10_2.y = L11_2
              L11_2 = L6_2.coords
              L11_2 = L11_2.z
              L10_2.z = L11_2
              L11_2 = L6_2.r
              L10_2.r = L11_2
              L11_2 = L6_2.g
              L10_2.g = L11_2
              L11_2 = L6_2.b
              L10_2.b = L11_2
              L11_2 = L6_2.range
              L10_2.range = L11_2
              L11_2 = L6_2.intensity
              L10_2.intensity = L11_2
              L8_2 = L8_2(L9_2, L10_2)
              L0_2[L7_2] = L8_2
            end
            L1_2 = #L0_2
            if L1_2 > 0 then
              L1_2 = History
              L1_2 = L1_2.Push
              L2_2 = Cmd
              L2_2 = L2_2.Batch
              L3_2 = locale
              L4_2 = "hist.light_clear"
              L3_2 = L3_2(L4_2)
              L4_2 = L0_2
              L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2, L4_2)
              L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
            end
          end
        end
      end
    end
  end
  L0_2 = {}
  L2_1 = L0_2
  L0_2 = L5_1
  L0_2()
end
L7_1.UserClear = L8_1
L7_1 = Lights
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = L2_1
  L2_2[A0_2] = nil
  L2_2 = L5_1
  L2_2()
  L2_2 = History
  if L2_2 then
    L2_2 = Cmd
    if L2_2 then
      L2_2 = Cmd
      L2_2 = L2_2.LightDel
      if L2_2 then
        L2_2 = History
        L2_2 = L2_2.IsApplying
        L2_2 = L2_2()
        if not L2_2 then
          L2_2 = History
          L2_2 = L2_2.Push
          L3_2 = Cmd
          L3_2 = L3_2.LightDel
          L4_2 = A0_2
          L5_2 = {}
          L6_2 = L1_2.coords
          L6_2 = L6_2.x
          L5_2.x = L6_2
          L6_2 = L1_2.coords
          L6_2 = L6_2.y
          L5_2.y = L6_2
          L6_2 = L1_2.coords
          L6_2 = L6_2.z
          L5_2.z = L6_2
          L6_2 = L1_2.r
          L5_2.r = L6_2
          L6_2 = L1_2.g
          L5_2.g = L6_2
          L6_2 = L1_2.b
          L5_2.b = L6_2
          L6_2 = L1_2.range
          L5_2.range = L6_2
          L6_2 = L1_2.intensity
          L5_2.intensity = L6_2
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
          L2_2(L3_2, L4_2, L5_2, L6_2)
        end
      end
    end
  end
end
L7_1.Remove = L8_1
L7_1 = Lights
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A1_2 then
    return
  end
  L2_2 = L2_1
  L3_2 = {}
  L4_2 = vector3
  L5_2 = A1_2.x
  if not L5_2 then
    L5_2 = 0.0
  end
  L6_2 = A1_2.y
  if not L6_2 then
    L6_2 = 0.0
  end
  L7_2 = A1_2.z
  if not L7_2 then
    L7_2 = 0.0
  end
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.coords = L4_2
  L4_2 = A1_2.r
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.r = L4_2
  L4_2 = A1_2.g
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.g = L4_2
  L4_2 = A1_2.b
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.b = L4_2
  L4_2 = A1_2.range
  if not L4_2 then
    L4_2 = 12.0
  end
  L3_2.range = L4_2
  L4_2 = A1_2.intensity
  if not L4_2 then
    L4_2 = 5.0
  end
  L3_2.intensity = L4_2
  L2_2[A0_2] = L3_2
  L2_2 = L3_1
  if A0_2 > L2_2 then
    L3_1 = A0_2
  end
  L2_2 = L5_1
  L2_2()
end
L7_1.Restore = L8_1
L7_1 = Lights
function L8_1(A0_2)
  local L1_2
  L1_2 = L2_1
  L1_2[A0_2] = nil
  L1_2 = L5_1
  L1_2()
end
L7_1.RemoveById = L8_1
L7_1 = Lights
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L2_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = #L0_2
    L7_2 = L7_2 + 1
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
    L9_2 = L6_2.r
    L8_2.r = L9_2
    L9_2 = L6_2.g
    L8_2.g = L9_2
    L9_2 = L6_2.b
    L8_2.b = L9_2
    L9_2 = L6_2.range
    L8_2.range = L9_2
    L9_2 = L6_2.intensity
    L8_2.intensity = L9_2
    L0_2[L7_2] = L8_2
  end
  return L0_2
end
L7_1.GetAll = L8_1
L7_1 = Lights
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L2_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = #L0_2
    L7_2 = L7_2 + 1
    L8_2 = {}
    L8_2.id = L5_2
    L9_2 = L6_2.coords
    L9_2 = L9_2.x
    L8_2.x = L9_2
    L9_2 = L6_2.coords
    L9_2 = L9_2.y
    L8_2.y = L9_2
    L9_2 = L6_2.coords
    L9_2 = L9_2.z
    L8_2.z = L9_2
    L9_2 = L6_2.r
    L8_2.r = L9_2
    L9_2 = L6_2.g
    L8_2.g = L9_2
    L9_2 = L6_2.b
    L8_2.b = L9_2
    L9_2 = L6_2.range
    L8_2.range = L9_2
    L9_2 = L6_2.intensity
    L8_2.intensity = L9_2
    L0_2[L7_2] = L8_2
  end
  return L0_2
end
L7_1.GetListForUI = L8_1
L7_1 = Lights
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2 + 1
  L3_1 = L1_2
  L2_2 = L3_1
  L1_2 = L2_1
  L3_2 = {}
  L4_2 = vector3
  L5_2 = A0_2.x
  if not L5_2 then
    L5_2 = 0.0
  end
  L6_2 = A0_2.y
  if not L6_2 then
    L6_2 = 0.0
  end
  L7_2 = A0_2.z
  if not L7_2 then
    L7_2 = 0.0
  end
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.coords = L4_2
  L4_2 = A0_2.r
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.r = L4_2
  L4_2 = A0_2.g
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.g = L4_2
  L4_2 = A0_2.b
  if not L4_2 then
    L4_2 = 255
  end
  L3_2.b = L4_2
  L4_2 = A0_2.range
  if not L4_2 then
    L4_2 = 12.0
  end
  L3_2.range = L4_2
  L4_2 = A0_2.intensity
  if not L4_2 then
    L4_2 = 5.0
  end
  L3_2.intensity = L4_2
  L1_2[L2_2] = L3_2
  L1_2 = L5_1
  L1_2()
end
L7_1.AddRaw = L8_1
function L7_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L6_1
      L0_3 = L0_3()
      L1_3 = DrawLightWithRange
      L2_3 = L0_3.x
      L3_3 = L0_3.y
      L4_3 = L0_3.z
      L4_3 = L4_3 + 1.0
      L5_3 = L4_1.r
      L6_3 = L4_1.g
      L7_3 = L4_1.b
      L8_3 = L4_1.range
      L9_3 = L4_1.intensity
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
      L1_3 = DrawMarker
      L2_3 = 28
      L3_3 = L0_3.x
      L4_3 = L0_3.y
      L5_3 = L0_3.z
      L5_3 = L5_3 + 0.2
      L6_3 = 0.0
      L7_3 = 0.0
      L8_3 = 0.0
      L9_3 = 0.0
      L10_3 = 0.0
      L11_3 = 0.0
      L12_3 = 0.5
      L13_3 = 0.5
      L14_3 = 0.5
      L15_3 = L4_1.r
      L16_3 = L4_1.g
      L17_3 = L4_1.b
      L18_3 = 180
      L19_3 = false
      L20_3 = false
      L21_3 = 2
      L22_3 = false
      L23_3 = nil
      L24_3 = nil
      L25_3 = false
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3)
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
            goto lbl_62
          end
        end
        L1_3 = Lights
        L1_3 = L1_3.Add
        L2_3 = L0_3
        L1_3(L2_3)
      end
      ::lbl_62::
      L1_3 = IsDisabledControlJustPressed
      L2_3 = 0
      L3_3 = 73
      L1_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L1_3 = false
        L0_1 = L1_3
        L1_3 = L5_1
        L1_3()
      end
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
    L0_3 = Raycast
    L0_3 = L0_3.Reset
    L1_3 = "lights"
    L0_3(L1_3)
  end
  L0_2(L1_2)
end
L8_1 = Lights
function L9_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1
  if nil == A0_2 then
    L2_2 = L0_1
    L2_2 = not L2_2
    L0_1 = L2_2
  else
    L2_2 = true == A0_2
    L0_1 = L2_2
  end
  L2_2 = L5_1
  L2_2()
  L2_2 = L0_1
  if L2_2 and not L1_2 then
    L2_2 = L7_1
    L2_2()
  end
end
L8_1.Toggle = L9_1
L8_1 = CreateThread
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  while true do
    L0_2 = false
    L1_2 = L1_1
    if L1_2 then
      L1_2 = next
      L2_2 = L2_1
      L1_2 = L1_2(L2_2)
      if L1_2 then
        L1_2 = GetFinalRenderedCamCoord
        L1_2 = L1_2()
        L2_2 = pairs
        L3_2 = L2_1
        L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
        for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
          L8_2 = L7_2.coords
          L8_2 = L1_2 - L8_2
          L8_2 = #L8_2
          L9_2 = L7_2.range
          L9_2 = L9_2 + 60.0
          if L8_2 < L9_2 then
            L8_2 = DrawLightWithRange
            L9_2 = L7_2.coords
            L9_2 = L9_2.x
            L10_2 = L7_2.coords
            L10_2 = L10_2.y
            L11_2 = L7_2.coords
            L11_2 = L11_2.z
            L12_2 = L7_2.r
            L13_2 = L7_2.g
            L14_2 = L7_2.b
            L15_2 = L7_2.range
            L16_2 = L7_2.intensity
            L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
            L0_2 = true
          end
        end
      end
    end
    L1_2 = Wait
    if L0_2 then
      L2_2 = 0
      if L2_2 then
        goto lbl_49
      end
    end
    L2_2 = 250
    ::lbl_49::
    L1_2(L2_2)
  end
end
L8_1(L9_1)
