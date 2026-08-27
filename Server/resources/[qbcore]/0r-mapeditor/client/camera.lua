local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1
L0_1 = Config
L0_1 = L0_1.camera
L1_1 = {}
Camera = L1_1
L1_1 = nil
L2_1 = false
L3_1 = false
L4_1 = vector3
L5_1 = 0.0
L6_1 = 0.0
L7_1 = 0.0
L4_1 = L4_1(L5_1, L6_1, L7_1)
L5_1 = vector3
L6_1 = 0.0
L7_1 = 0.0
L8_1 = 0.0
L5_1 = L5_1(L6_1, L7_1, L8_1)
L6_1 = -1
L7_1 = nil
L8_1 = nil
L9_1 = nil
L10_1 = nil
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = GetFrameCount
  L0_2 = L0_2()
  L1_2 = L6_1
  if L0_2 == L1_2 then
    return
  end
  L6_1 = L0_2
  L1_2 = L2_1
  if L1_2 then
    L1_2 = L4_1
    L7_1 = L1_2
    L1_2 = L5_1
    L8_1 = L1_2
    L1_2 = L0_1.fov
    L10_1 = L1_2
  else
    L1_2 = GetGameplayCamCoord
    L1_2 = L1_2()
    L7_1 = L1_2
    L1_2 = GetGameplayCamRot
    L2_2 = 2
    L1_2 = L1_2(L2_2)
    L8_1 = L1_2
    L1_2 = GetGameplayCamFov
    L1_2 = L1_2()
    L10_1 = L1_2
  end
  L1_2 = math
  L1_2 = L1_2.rad
  L2_2 = L8_1.x
  L1_2 = L1_2(L2_2)
  L2_2 = math
  L2_2 = L2_2.rad
  L3_2 = L8_1.z
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.cos
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = vector3
  L5_2 = math
  L5_2 = L5_2.sin
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L5_2 = -L5_2
  L5_2 = L5_2 * L3_2
  L6_2 = math
  L6_2 = L6_2.cos
  L7_2 = L2_2
  L6_2 = L6_2(L7_2)
  L6_2 = L6_2 * L3_2
L7_2 = math
  L7_2 = L7_2.sin
  L8_2 = L1_2
  L7_2 = L7_2(L8_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L9_1 = L4_2
end
L12_1 = -1
L13_1 = {}
L13_1.w = 0
L13_1.h = 0
L14_1 = {}
L14_1.x = 0
L14_1.y = 0
L15_1 = {}
L15_1.origin = nil
L15_1.dir = nil
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L11_1
  L0_2()
  L0_2 = GetFrameCount
  L0_2 = L0_2()
  L1_2 = L12_1
  if L0_2 == L1_2 then
    return
  end
  L12_1 = L0_2
  L1_2 = GetActualScreenResolution
  L1_2, L2_2 = L1_2()
  if not L1_2 or 0 == L1_2 then
    L3_2 = GetActiveScreenResolution
    L3_2, L4_2 = L3_2()
    L2_2 = L4_2
    L1_2 = L3_2
  end
  if not L1_2 or 0 == L1_2 then
    L3_2 = 1920
    L2_2 = 1080
    L1_2 = L3_2
  end
  L3_2 = L1_2
  L13_1.h = L2_2
  L13_1.w = L3_2
  L3_2 = GetNuiCursorPosition
  L3_2, L4_2 = L3_2()
  if not L3_2 or L3_2 < 0 then
    L3_2 = L1_2 / 2
  end
  if not L4_2 or L4_2 < 0 then
    L4_2 = L2_2 / 2
  end
  L5_2 = L3_2
  L14_1.y = L4_2
  L14_1.x = L5_2
  L15_1.origin = nil
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = -89.0
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 89.0
  L5_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2)
  return L1_2(L2_2, L3_2)
end
function L18_1()
  local L0_2, L1_2
  L0_2 = L11_1
  L0_2()
  L0_2 = L8_1
  return L0_2
end
function L19_1()
  local L0_2, L1_2
  L0_2 = L11_1
  L0_2()
  L0_2 = L10_1
  return L0_2
end
L20_1 = Camera
function L21_1()
  local L0_2, L1_2
  L0_2 = L11_1
  L0_2()
  L0_2 = L9_1
  return L0_2
end
L20_1.GetForward = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2
  L0_2 = L11_1
  L0_2()
  L0_2 = L7_1
  return L0_2
end
L20_1.GetCoords = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L20_1.IsActive = L21_1
L20_1 = Camera
function L21_1(A0_2)
  local L1_2
  L4_1 = A0_2
  L1_2 = -1
  L6_1 = L1_2
  L1_2 = -1
  L12_1 = L1_2
end
L20_1.SetCoords = L21_1
L20_1 = Camera
L20_1.GetFov = L19_1
L20_1 = Camera
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L16_1
  L2_2()
  L2_2 = L13_1.w
  L3_2 = L13_1.h
  L4_2 = A0_2 * 2.0
  L4_2 = L4_2 - 1.0
  L5_2 = A1_2 * 2.0
  L5_2 = L5_2 - 1.0
  L6_2 = L9_1
  L7_2 = vector3
  L8_2 = L6_2.y
  L9_2 = L6_2.x
  L9_2 = -L9_2
  L10_2 = 0.0
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = #L7_2
  if L8_2 > 0 then
    L9_2 = L7_2 / L8_2
    if L9_2 then
      goto lbl_33
      L7_2 = L9_2 or L7_2
    end
  end
  L9_2 = vector3
  L10_2 = 1.0
  L11_2 = 0.0
  L12_2 = 0.0
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L7_2 = L9_2
  ::lbl_33::
  L9_2 = vector3
  L10_2 = L7_2.y
  L11_2 = L6_2.z
  L10_2 = L10_2 * L11_2
  L11_2 = L7_2.z
  L12_2 = L6_2.y
  L11_2 = L11_2 * L12_2
  L10_2 = L10_2 - L11_2
  L11_2 = L7_2.z
  L12_2 = L6_2.x
  L11_2 = L11_2 * L12_2
  L12_2 = L7_2.x
  L13_2 = L6_2.z
  L12_2 = L12_2 * L13_2
  L11_2 = L11_2 - L12_2
  L12_2 = L7_2.x
  L13_2 = L6_2.y
  L12_2 = L12_2 * L13_2
  L13_2 = L7_2.y
  L14_2 = L6_2.x
  L13_2 = L13_2 * L14_2
  L12_2 = L12_2 - L13_2
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L10_2 = math
  L10_2 = L10_2.tan
  L11_2 = math
  L11_2 = L11_2.rad
  L12_2 = L10_1
  L11_2 = L11_2(L12_2)
  L11_2 = L11_2 * 0.5
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2 / L3_2
  L12_2 = L4_2 * L10_2
  L12_2 = L12_2 * L11_2
  L12_2 = L7_2 * L12_2
  L12_2 = L6_2 + L12_2
  L13_2 = -L5_2
  L13_2 = L13_2 * L10_2
  L13_2 = L9_2 * L13_2
  L12_2 = L12_2 + L13_2
  L13_2 = #L12_2
  if L13_2 > 0 then
    L12_2 = L12_2 / L13_2
  end
  L14_2 = L7_1
  L15_2 = L12_2
  return L14_2, L15_2
end
L20_1.ScreenToWorldRay = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L16_1
  L0_2()
  L0_2 = L15_1.origin
  if L0_2 then
    L0_2 = L15_1.origin
    L1_2 = L15_1.dir
    return L0_2, L1_2
  end
  L0_2 = L13_1.w
  L1_2 = L13_1.h
  L2_2 = L14_1.x
  L3_2 = L14_1.y
  L4_2 = Camera
  L4_2 = L4_2.ScreenToWorldRay
  L5_2 = L2_2 / L0_2
  L6_2 = L3_2 / L1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  L15_1.origin = L4_2
  L15_1.dir = L5_2
  L6_2 = L4_2
  L7_2 = L5_2
  return L6_2, L7_2
end
L20_1.CursorRay = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2
  L0_2 = L19_1
  return L0_2()
end
L20_1.GetVFov = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = L2_1
  if L0_2 then
    return
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = vector3
  L3_2 = 0.0
  L4_2 = 0.0
  L5_2 = 1.2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L1_2 + L2_2
  L4_1 = L1_2
  L1_2 = GetGameplayCamRot
  L2_2 = 2
  L1_2 = L1_2(L2_2)
  L2_2 = vector3
  L3_2 = L1_2.x
  L4_2 = 0.0
  L5_2 = L1_2.z
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L5_1 = L2_2
  L2_2 = CreateCamWithParams
  L3_2 = "DEFAULT_SCRIPTED_CAMERA"
  L4_2 = L4_1.x
  L5_2 = L4_1.y
  L6_2 = L4_1.z
  L7_2 = L5_1.x
  L8_2 = 0.0
  L9_2 = L5_1.z
  L10_2 = L0_1.fov
  L10_2 = L10_2 + 0.0
  L11_2 = false
  L12_2 = 0
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L1_1 = L2_2
  L2_2 = SetCamActive
  L3_2 = L1_1
  L4_2 = true
  L2_2(L3_2, L4_2)
  L2_2 = RenderScriptCams
  L3_2 = true
  L4_2 = false
  L5_2 = 0
  L6_2 = true
  L7_2 = false
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L2_2 = FreezeEntityPosition
  L3_2 = L0_2
  L4_2 = true
  L2_2(L3_2, L4_2)
  L2_2 = SetEntityVisible
  L3_2 = L0_2
  L4_2 = false
  L5_2 = false
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = SetEntityCollision
  L3_2 = L0_2
  L4_2 = false
  L5_2 = false
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = true
  L2_1 = L2_2
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3
    L0_3 = nil
    L1_3 = nil
    while true do
      L2_3 = L2_1
      if not L2_3 then
        break
      end
      L2_3 = GetFrameTime
      L2_3 = L2_3()
      L3_3 = 1.0
      L4_3 = IsDisabledControlPressed
      L5_3 = 0
      L6_3 = 21
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 then
        L3_3 = L0_1.fastMultiplier
      end
      L4_3 = IsDisabledControlPressed
      L5_3 = 0
      L6_3 = 19
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 then
        L3_3 = L0_1.slowMultiplier
      end
      L4_3 = Camera
      L4_3 = L4_3.GetForward
      L4_3 = L4_3()
      L5_3 = L4_3.y
      L6_3 = L4_3.x
      L6_3 = -L6_3
      L7_3 = L5_3 * L5_3
      L8_3 = L6_3 * L6_3
      L7_3 = L7_3 + L8_3
      if L7_3 > 0 then
        L8_3 = math
        L8_3 = L8_3.sqrt
        L9_3 = L7_3
        L8_3 = L8_3(L9_3)
        L9_3 = L5_3 / L8_3
        L6_3 = L6_3 / L8_3
        L5_3 = L9_3
      end
      L8_3 = 0.0
      L9_3 = 0.0
      L10_3 = 0.0
      L11_3 = IsDisabledControlPressed
      L12_3 = 0
      L13_3 = 32
      L11_3 = L11_3(L12_3, L13_3)
      if L11_3 then
        L11_3 = L4_3.x
        L8_3 = L8_3 + L11_3
        L11_3 = L4_3.y
        L9_3 = L9_3 + L11_3
        L11_3 = L4_3.z
        L10_3 = L10_3 + L11_3
      end
      L11_3 = IsDisabledControlPressed
      L12_3 = 0
      L13_3 = 33
      L11_3 = L11_3(L12_3, L13_3)
      if L11_3 then
        L11_3 = L4_3.x
        L8_3 = L8_3 - L11_3
        L11_3 = L4_3.y
        L9_3 = L9_3 - L11_3
        L11_3 = L4_3.z
        L10_3 = L10_3 - L11_3
      end
      L11_3 = IsDisabledControlPressed
      L12_3 = 0
      L13_3 = 34
      L11_3 = L11_3(L12_3, L13_3)
      if L11_3 then
        L8_3 = L8_3 - L5_3
        L9_3 = L9_3 - L6_3
      end
      L11_3 = IsDisabledControlPressed
      L12_3 = 0
      L13_3 = 35
      L11_3 = L11_3(L12_3, L13_3)
      if L11_3 then
        L8_3 = L8_3 + L5_3
        L9_3 = L9_3 + L6_3
      end
      L11_3 = L8_3 * L8_3
      L12_3 = L9_3 * L9_3
      L11_3 = L11_3 + L12_3
      L12_3 = L10_3 * L10_3
      L11_3 = L11_3 + L12_3
      if L11_3 > 0 then
        L12_3 = math
        L12_3 = L12_3.sqrt
        L13_3 = L11_3
        L12_3 = L12_3(L13_3)
        L13_3 = vector3
        L14_3 = L4_1.x
        L15_3 = L8_3 / L12_3
        L16_3 = L0_1.moveSpeed
        L16_3 = L16_3 * L3_3
        L16_3 = L16_3 * L2_3
        L15_3 = L15_3 * L16_3
        L14_3 = L14_3 + L15_3
        L15_3 = L4_1.y
        L16_3 = L9_3 / L12_3
        L17_3 = L0_1.moveSpeed
        L17_3 = L17_3 * L3_3
        L17_3 = L17_3 * L2_3
        L16_3 = L16_3 * L17_3
        L15_3 = L15_3 + L16_3
        L16_3 = L4_1.z
        L17_3 = L10_3 / L12_3
        L18_3 = L0_1.moveSpeed
        L18_3 = L18_3 * L3_3
        L18_3 = L18_3 * L2_3
        L17_3 = L17_3 * L18_3
        L16_3 = L16_3 + L17_3
        L13_3 = L13_3(L14_3, L15_3, L16_3)
        L4_1 = L13_3
      end
      L12_3 = IsDisabledControlPressed
      L13_3 = 0
      L14_3 = 25
      L12_3 = L12_3(L13_3, L14_3)
      if L12_3 then
        L13_3 = L3_1
        if not L13_3 then
          L13_3 = true
          L3_1 = L13_3
          L13_3 = SetNuiFocus
          L14_3 = true
          L15_3 = false
          L13_3(L14_3, L15_3)
        end
      end
      if not L12_3 then
        L13_3 = L3_1
        if L13_3 then
          L13_3 = false
          L3_1 = L13_3
          L13_3 = SetNuiFocus
          L14_3 = true
          L15_3 = true
          L13_3(L14_3, L15_3)
        end
      end
      L13_3 = L3_1
      if L13_3 then
        L13_3 = GetDisabledControlNormal
        L14_3 = 0
        L15_3 = 1
        L13_3 = L13_3(L14_3, L15_3)
        L14_3 = L0_1.mouseSensitivity
        L13_3 = L13_3 * L14_3
        L14_3 = GetDisabledControlNormal
        L15_3 = 0
        L16_3 = 2
        L14_3 = L14_3(L15_3, L16_3)
        L15_3 = L0_1.mouseSensitivity
        L14_3 = L14_3 * L15_3
        L15_3 = vector3
        L16_3 = L17_1
        L17_3 = L5_1.x
        L17_3 = L17_3 - L14_3
        L16_3 = L16_3(L17_3)
        L17_3 = 0.0
        L18_3 = L5_1.z
        L18_3 = L18_3 - L13_3
        L15_3 = L15_3(L16_3, L17_3, L18_3)
        L5_1 = L15_3
      end
      if L0_3 then
        L13_3 = L4_1
        L13_3 = L13_3 - L0_3
        L13_3 = #L13_3
        L14_3 = 1.0E-4
        if not (L13_3 > L14_3) then
          goto lbl_232
        end
      end
      L13_3 = SetCamCoord
      L14_3 = L1_1
      L15_3 = L4_1.x
      L16_3 = L4_1.y
      L17_3 = L4_1.z
      L13_3(L14_3, L15_3, L16_3, L17_3)
      L13_3 = SetFocusPosAndVel
      L14_3 = L4_1.x
      L15_3 = L4_1.y
      L16_3 = L4_1.z
      L17_3 = 0.0
      L18_3 = 0.0
      L19_3 = 0.0
      L13_3(L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
      L0_3 = L4_1
      ::lbl_232::
      if L1_3 then
        L13_3 = L5_1
        L13_3 = L13_3 - L1_3
        L13_3 = #L13_3
        L14_3 = 1.0E-4
        if not (L13_3 > L14_3) then
          goto lbl_249
        end
      end
      L13_3 = SetCamRot
      L14_3 = L1_1
      L15_3 = L5_1.x
      L16_3 = 0.0
      L17_3 = L5_1.z
      L18_3 = 2
      L13_3(L14_3, L15_3, L16_3, L17_3, L18_3)
      L1_3 = L5_1
      ::lbl_249::
      L13_3 = Wait
      L14_3 = 0
      L13_3(L14_3)
    end
  end
  L2_2(L3_2)
end
L20_1.Start = L21_1
L20_1 = Camera
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L2_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L2_1 = L0_2
  L0_2 = L3_1
  if L0_2 then
    L0_2 = false
    L3_1 = L0_2
    L0_2 = SetNuiFocus
    L1_2 = true
    L2_2 = true
    L0_2(L1_2, L2_2)
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = RenderScriptCams
  L2_2 = false
  L3_2 = false
  L4_2 = 0
  L5_2 = true
  L6_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  L1_2 = L1_1
  if L1_2 then
    L1_2 = DestroyCam
    L2_2 = L1_1
    L3_2 = false
    L1_2(L2_2, L3_2)
    L1_2 = nil
    L1_1 = L1_2
  end
  L1_2 = GetGroundZFor_3dCoord
  L2_2 = L4_1.x
  L3_2 = L4_1.y
  L4_2 = L4_1.z
  L5_2 = false
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if L1_2 then
    L3_2 = SetEntityCoords
    L4_2 = L0_2
    L5_2 = L4_1.x
    L6_2 = L4_1.y
    L7_2 = L2_2
    L8_2 = false
    L9_2 = false
    L10_2 = false
    L11_2 = false
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  else
    L3_2 = SetEntityCoords
    L4_2 = L0_2
    L5_2 = L4_1.x
    L6_2 = L4_1.y
    L7_2 = L4_1.z
    L7_2 = L7_2 - 1.0
    L8_2 = false
    L9_2 = false
    L10_2 = false
    L11_2 = false
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  L3_2 = FreezeEntityPosition
  L4_2 = L0_2
  L5_2 = false
  L3_2(L4_2, L5_2)
  L3_2 = SetEntityVisible
  L4_2 = L0_2
  L5_2 = true
  L6_2 = false
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = SetEntityCollision
  L4_2 = L0_2
  L5_2 = true
  L6_2 = true
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = ClearFocus
  L3_2()
end
L20_1.Stop = L21_1
