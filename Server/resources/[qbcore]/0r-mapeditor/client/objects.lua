local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1
L0_1 = {}
Objects = L0_1
L0_1 = {}
L1_1 = {}
L2_1 = {}
L3_1 = 0
L4_1 = 0
L5_1 = "Default"
L6_1 = {}
L7_1 = {}
L8_1 = {}
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = 1
  L2_2 = L8_1
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = L8_1
    L5_2 = L5_2[L4_2]
    L5_2 = L5_2.uid
    if L5_2 == A0_2 then
      return L4_2
    end
  end
  L1_2 = nil
  return L1_2
end
L10_1 = nil
L11_1 = 0
function L12_1()
  local L0_2, L1_2, L2_2
  L0_2 = L10_1
  if not L0_2 then
    L0_2 = string
    L0_2 = L0_2.format
    L1_2 = "%x"
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L2_2 = L2_2 % 16777215
    L0_2 = L0_2(L1_2, L2_2)
    L10_1 = L0_2
  end
  L0_2 = L11_1
  L0_2 = L0_2 + 1
  L11_1 = L0_2
  L0_2 = L10_1
  L1_2 = "-"
  L2_2 = L11_1
  L0_2 = L0_2 .. L1_2 .. L2_2
  return L0_2
end
L13_1 = 8.0
L14_1 = {}
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L13_1
  L3_2 = A0_2 / L3_2
  L2_2 = L2_2(L3_2)
  L3_2 = ":"
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L13_1
  L5_2 = A1_2 / L5_2
  L4_2 = L4_2(L5_2)
  L2_2 = L2_2 .. L3_2 .. L4_2
  return L2_2
end
function L16_1(A0_2, A1_2)
  local L2_2
  L2_2 = A1_2 or nil
  if A1_2 then
    L2_2 = L14_1
    L2_2 = L2_2[A1_2]
  end
  if L2_2 then
    L2_2[A0_2] = nil
  end
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L14_1
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L3_2 = {}
    L2_2 = L3_2
    L3_2 = L14_1
    L3_2[A1_2] = L2_2
  end
  L2_2[A0_2] = true
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = A0_2 or L1_2
  if "number" ~= L1_2 or not A0_2 then
    L1_2 = joaat
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  L2_2 = IsModelValid
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = RequestModel
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = HasModelLoaded
    L4_2 = L1_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    L4_2 = 5000
    if not (L3_2 < L4_2) then
      break
    end
    L3_2 = Wait
    L4_2 = 0
    L3_2(L4_2)
  end
  L3_2 = HasModelLoaded
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = nil
    return L3_2
  end
  return L1_2
end
L19_1 = Objects
L19_1.LoadModel = L18_1
L19_1 = Objects
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = DoesEntityExist
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  L2_2 = A1_2.lod
  if L2_2 then
    L2_2 = SetEntityLodDist
    L3_2 = A0_2
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = A1_2.lod
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = A1_2.collision
  L2_2 = false ~= L2_2
  L3_2 = SetEntityCollision
  L4_2 = A0_2
  L5_2 = L2_2
  L6_2 = L2_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = FreezeEntityPosition
  L4_2 = A0_2
  L5_2 = A1_2.frozen
  L5_2 = false ~= L5_2
  L3_2(L4_2, L5_2)
  L3_2 = SetEntityVisible
  L4_2 = A0_2
  L5_2 = A1_2.visible
  L5_2 = false ~= L5_2
  L6_2 = false
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = SetEntityAlpha
  L4_2 = A0_2
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = A1_2.alpha
  if not L6_2 then
    L6_2 = 255
  end
  L5_2 = L5_2(L6_2)
  L6_2 = false
  L3_2(L4_2, L5_2, L6_2)
end
L19_1.ApplyProps = L20_1
L19_1 = false
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = A0_2.blip
  if L1_2 then
    L1_2 = DoesBlipExist
    L2_2 = A0_2.blip
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = RemoveBlip
      L2_2 = A0_2.blip
      L1_2(L2_2)
    end
  end
  L1_2 = AddBlipForCoord
  L2_2 = A0_2.coords
  L2_2 = L2_2.x
  L3_2 = A0_2.coords
  L3_2 = L3_2.y
  L4_2 = A0_2.coords
  L4_2 = L4_2.z
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = SetBlipSprite
  L3_2 = L1_2
  L4_2 = 1
  L2_2(L3_2, L4_2)
  L2_2 = SetBlipScale
  L3_2 = L1_2
  L4_2 = 0.85
  L2_2(L3_2, L4_2)
  L2_2 = SetBlipColour
  L3_2 = L1_2
  L4_2 = A0_2.blipColor
  if not L4_2 then
    L4_2 = 0
  end
  L2_2(L3_2, L4_2)
  L2_2 = SetBlipAsShortRange
  L3_2 = L1_2
  L4_2 = false
  L2_2(L3_2, L4_2)
  L2_2 = SetBlipDisplay
  L3_2 = L1_2
  L4_2 = 6
  L2_2(L3_2, L4_2)
  L2_2 = BeginTextCommandSetBlipName
  L3_2 = "STRING"
  L2_2(L3_2)
  L2_2 = AddTextComponentSubstringPlayerName
  L3_2 = A0_2.blipName
  if nil ~= L3_2 then
    L3_2 = A0_2.blipName
    if "" ~= L3_2 then
      L3_2 = A0_2.blipName
      if L3_2 then
        goto lbl_63
      end
    end
  end
  L3_2 = tostring
  L4_2 = A0_2.model
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "_"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  ::lbl_63::
  L2_2(L3_2)
  L2_2 = EndTextCommandSetBlipName
  L3_2 = L1_2
  L2_2(L3_2)
  A0_2.blip = L1_2
end
function L21_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.blip
  if L1_2 then
    L1_2 = DoesBlipExist
    L2_2 = A0_2.blip
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = RemoveBlip
      L2_2 = A0_2.blip
      L1_2(L2_2)
    end
  end
  A0_2.blip = nil
end
L22_1 = Objects
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L19_1 = A0_2
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if A0_2 then
      L7_2 = L6_2.blipOn
      if L7_2 then
        L7_2 = L20_1
        L8_2 = L6_2
        L7_2(L8_2)
    end
    else
      L7_2 = L21_1
      L8_2 = L6_2
      L7_2(L8_2)
    end
  end
end
L22_1.ShowBlips = L23_1
L22_1 = Objects
function L23_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L0_1
  L4_2 = L4_2[A0_2]
  if not L4_2 then
    return
  end
  if nil ~= A1_2 then
    L4_2.blipName = A1_2
  end
  if nil ~= A2_2 then
    L5_2 = math
    L5_2 = L5_2.floor
    L6_2 = A2_2
    L5_2 = L5_2(L6_2)
    L4_2.blipColor = L5_2
  end
  if nil ~= A3_2 then
    L5_2 = true == A3_2
    L4_2.blipOn = L5_2
  end
  L5_2 = L19_1
  if L5_2 then
    L5_2 = L4_2.blipOn
    if L5_2 then
      L5_2 = L20_1
      L6_2 = L4_2
      L5_2(L6_2)
  end
  else
    L5_2 = L21_1
    L6_2 = L4_2
    L5_2(L6_2)
  end
end
L22_1.SetBlip = L23_1
L22_1 = Objects
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L18_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = 0
    return L4_2
  end
  L4_2 = CreateObjectNoOffset
  L5_2 = L3_2
  L6_2 = A1_2.x
  L7_2 = A1_2.y
  L8_2 = A1_2.z
  L9_2 = false
  L10_2 = false
  L11_2 = false
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = SetModelAsNoLongerNeeded
  L6_2 = L3_2
  L5_2(L6_2)
  L5_2 = SetEntityRotation
  L6_2 = L4_2
  L7_2 = A2_2.x
  L8_2 = A2_2.y
  L9_2 = A2_2.z
  L10_2 = 2
  L11_2 = true
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = SetEntityCollision
  L6_2 = L4_2
  L7_2 = false
  L8_2 = false
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = FreezeEntityPosition
  L6_2 = L4_2
  L7_2 = true
  L5_2(L6_2, L7_2)
  L5_2 = SetEntityAlpha
  L6_2 = L4_2
  L7_2 = Config
  L7_2 = L7_2.placement
  L7_2 = L7_2.ghostAlpha
  L8_2 = false
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = SetEntityDrawOutlineShader
  L6_2 = 1
  L5_2(L6_2)
  L5_2 = SetEntityDrawOutlineColor
  L6_2 = 46
  L7_2 = 155
  L8_2 = 255
  L9_2 = 255
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = SetEntityDrawOutline
  L6_2 = L4_2
  L7_2 = true
  L5_2(L6_2, L7_2)
  return L4_2
end
L22_1.SpawnGhost = L23_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = GetInteriorRoomCount
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = 1
  L6_2 = L4_2 - 1
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = GetInteriorRoomExtents
    L10_2 = A0_2
    L11_2 = L8_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2)
    if L9_2 and A1_2 >= L9_2 and A1_2 <= L12_2 and A2_2 >= L10_2 and A2_2 <= L13_2 and A3_2 >= L11_2 and A3_2 <= L14_2 then
      L15_2 = GetInteriorRoomName
      L16_2 = A0_2
      L17_2 = L8_2
      L15_2 = L15_2(L16_2, L17_2)
      if L15_2 and "" ~= L15_2 then
        L16_2 = joaat
        L17_2 = L15_2
        return L16_2(L17_2)
      end
    end
  end
  L5_2 = 0
  return L5_2
end
function L23_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if A0_2 and 0 ~= A0_2 then
    L4_2 = DoesEntityExist
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_12
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_12::
  L4_2 = GetInteriorAtCoords
  L5_2 = A1_2
  L6_2 = A2_2
  L7_2 = A3_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if 0 == L4_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L22_1
  L6_2 = L4_2
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if 0 == L5_2 then
    L6_2 = PlayerPedId
    L6_2 = L6_2()
    L7_2 = GetInteriorFromEntity
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 == L4_2 then
      L7_2 = GetRoomKeyFromEntity
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      L5_2 = L7_2
    end
  end
  if 0 == L5_2 then
    L6_2 = GetRoomKeyFromGameplayCam
    L6_2 = L6_2()
    L5_2 = L6_2
  end
  if 0 ~= L5_2 then
    L6_2 = ForceRoomForEntity
    L7_2 = A0_2
    L8_2 = L4_2
    L9_2 = L5_2
    L6_2(L7_2, L8_2, L9_2)
    L6_2 = true
    return L6_2
  end
  L6_2 = false
  return L6_2
end
L24_1 = Objects
L24_1.AssignRoomHandle = L23_1
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    return
  end
  L1_2 = A0_2.coords
  L2_2 = GetInteriorAtCoords
  L3_2 = L1_2.x
  L4_2 = L1_2.y
  L5_2 = L1_2.z
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if 0 == L2_2 then
    A0_2.interior = nil
    A0_2.roomOk = true
    return
  end
  A0_2.interior = L2_2
  L3_2 = L23_1
  L4_2 = A0_2.handle
  L5_2 = L1_2.x
  L6_2 = L1_2.y
  L7_2 = L1_2.z
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  A0_2.roomOk = L3_2
end
L25_1 = CreateThread
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  while true do
    L0_2 = Wait
    L1_2 = 2000
    L0_2(L1_2)
    L0_2 = GetEntityCoords
    L1_2 = PlayerPedId
    L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L1_2()
    L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L1_2 = pairs
    L2_2 = L0_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.roomOk
      if not L7_2 then
        L7_2 = L6_2.adopted
        if not L7_2 then
          L7_2 = DoesEntityExist
          L8_2 = L6_2.handle
          L7_2 = L7_2(L8_2)
          if L7_2 then
            L7_2 = L6_2.coords
            L7_2 = L7_2.x
            L8_2 = L0_2.x
            L7_2 = L7_2 - L8_2
            L8_2 = L6_2.coords
            L8_2 = L8_2.y
            L9_2 = L0_2.y
            L8_2 = L8_2 - L9_2
            L9_2 = L7_2 * L7_2
            L10_2 = L8_2 * L8_2
            L9_2 = L9_2 + L10_2
            L10_2 = 6400.0
            if L9_2 < L10_2 then
              L9_2 = L24_1
              L10_2 = L6_2
              L9_2(L10_2)
            end
          end
        end
      end
    end
  end
end
L25_1(L26_1)
L25_1 = Objects
function L26_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L6_2 = L18_1
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = CreateObjectNoOffset
  L8_2 = L6_2
  L9_2 = A1_2.x
  L10_2 = A1_2.y
  L11_2 = A1_2.z
  L12_2 = false
  L13_2 = false
  L14_2 = false
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L8_2 = SetModelAsNoLongerNeeded
  L9_2 = L6_2
  L8_2(L9_2)
  if 0 ~= L7_2 then
    L8_2 = DoesEntityExist
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      goto lbl_29
    end
  end
  L8_2 = nil
  do return L8_2 end
  ::lbl_29::
  L8_2 = SetEntityRotation
  L9_2 = L7_2
  L10_2 = A2_2.x
  L11_2 = A2_2.y
  L12_2 = A2_2.z
  L13_2 = 2
  L14_2 = true
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not A3_2 then
    L8_2 = {}
    A3_2 = L8_2
  end
  L8_2 = Objects
  L8_2 = L8_2.ApplyProps
  L9_2 = L7_2
  L10_2 = A3_2
  L8_2(L9_2, L10_2)
  L8_2 = L3_1
  L8_2 = L8_2 + 1
  L3_1 = L8_2
  if not A4_2 then
    L8_2 = L4_1
    L8_2 = L8_2 + 1
    L4_1 = L8_2
    A4_2 = L4_1
  else
    L8_2 = L4_1
    if A4_2 > L8_2 then
      L4_1 = A4_2
    end
  end
  L9_2 = L3_1
  L8_2 = L0_1
  L10_2 = {}
  L10_2.handle = L7_2
  L10_2.model = A0_2
  L10_2.coords = A1_2
  L10_2.rot = A2_2
  L10_2.initCoords = A1_2
  L10_2.initRot = A2_2
  L10_2.props = A3_2
  L11_2 = L5_1
  L10_2.layer = L11_2
  L10_2.uid = A4_2
  L11_2 = A5_2 or L11_2
  if not A5_2 then
    L11_2 = L12_1
    L11_2 = L11_2()
  end
  L10_2.eid = L11_2
  L8_2[L9_2] = L10_2
  L8_2 = L1_1
  L9_2 = L3_1
  L8_2[L7_2] = L9_2
  L8_2 = L2_1
  L9_2 = L3_1
  L8_2[A4_2] = L9_2
  L9_2 = L3_1
  L8_2 = L0_1
  L8_2 = L8_2[L9_2]
  L9_2 = L15_1
  L10_2 = A1_2.x
  L11_2 = A1_2.y
  L9_2 = L9_2(L10_2, L11_2)
  L8_2.cell = L9_2
  L8_2 = L17_1
  L9_2 = L3_1
  L11_2 = L3_1
  L10_2 = L0_1
  L10_2 = L10_2[L11_2]
  L10_2 = L10_2.cell
  L8_2(L9_2, L10_2)
  L8_2 = MEDockDirty
  if L8_2 then
    L8_2 = MEDockDirty
    L9_2 = "objects"
    L8_2(L9_2)
  end
  L8_2 = L19_1
  if L8_2 then
    L9_2 = L3_1
    L8_2 = L0_1
    L8_2 = L8_2[L9_2]
    L8_2 = L8_2.blipOn
    if L8_2 then
      L8_2 = L20_1
      L10_2 = L3_1
      L9_2 = L0_1
      L9_2 = L9_2[L10_2]
      L8_2(L9_2)
    end
  end
  L9_2 = L5_1
  L8_2 = L6_1
  L8_2 = L8_2[L9_2]
  if false == L8_2 then
    L8_2 = SetEntityVisible
    L9_2 = L7_2
    L10_2 = false
    L11_2 = false
    L8_2(L9_2, L10_2, L11_2)
  end
  L8_2 = L24_1
  L10_2 = L3_1
  L9_2 = L0_1
  L9_2 = L9_2[L10_2]
  L8_2(L9_2)
  L8_2 = L3_1
  L9_2 = L7_2
  return L8_2, L9_2
end
L25_1.Spawn = L26_1
L25_1 = Objects
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if A0_2 then
    L2_2 = DoesEntityExist
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_10
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_10::
  L2_2 = L1_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L1_1
    L2_2 = L2_2[A0_2]
    return L2_2
  end
  L2_2 = vector3
  L3_2 = A1_2.x
  L3_2 = L3_2 + 0.0
  L4_2 = A1_2.y
  L4_2 = L4_2 + 0.0
  L5_2 = A1_2.z
  L5_2 = L5_2 + 0.0
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = vector3
  L4_2 = A1_2.rx
  if not L4_2 then
    L4_2 = 0.0
  end
  L4_2 = L4_2 + 0.0
  L5_2 = A1_2.ry
  if not L5_2 then
    L5_2 = 0.0
  end
  L5_2 = L5_2 + 0.0
  L6_2 = A1_2.rz
  if not L6_2 then
    L6_2 = 0.0
  end
  L6_2 = L6_2 + 0.0
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = {}
  L5_2 = A1_2.lod
  if not L5_2 then
    L5_2 = Config
    L5_2 = L5_2.objectDefaults
    L5_2 = L5_2.lod
  end
  L4_2.lod = L5_2
  L5_2 = A1_2.alpha
  if not L5_2 then
    L5_2 = 255
  end
  L4_2.alpha = L5_2
  L5_2 = A1_2.collision
  L5_2 = false ~= L5_2
  L4_2.collision = L5_2
  L5_2 = A1_2.frozen
  L5_2 = false ~= L5_2
  L4_2.frozen = L5_2
  L5_2 = A1_2.visible
  L5_2 = false ~= L5_2
  L4_2.visible = L5_2
  L5_2 = L3_1
  L5_2 = L5_2 + 1
  L3_1 = L5_2
  L5_2 = L4_1
  L5_2 = L5_2 + 1
  L4_1 = L5_2
  L5_2 = L4_1
  L7_2 = L3_1
  L6_2 = L0_1
  L8_2 = {}
  L8_2.handle = A0_2
  L9_2 = A1_2.model
  L8_2.model = L9_2
  L8_2.coords = L2_2
  L8_2.rot = L3_2
  L8_2.initCoords = L2_2
  L8_2.initRot = L3_2
  L8_2.props = L4_2
  L9_2 = L5_1
  L8_2.layer = L9_2
  L8_2.uid = L5_2
  L9_2 = A1_2.eid
  if not L9_2 then
    L9_2 = L12_1
    L9_2 = L9_2()
  end
  L8_2.eid = L9_2
  L8_2.adopted = true
  L6_2[L7_2] = L8_2
  L6_2 = L1_1
  L7_2 = L3_1
  L6_2[A0_2] = L7_2
  L6_2 = L2_1
  L7_2 = L3_1
  L6_2[L5_2] = L7_2
  L7_2 = L3_1
  L6_2 = L0_1
  L6_2 = L6_2[L7_2]
  L7_2 = L15_1
  L8_2 = L2_2.x
  L9_2 = L2_2.y
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.cell = L7_2
  L6_2 = L17_1
  L7_2 = L3_1
  L9_2 = L3_1
  L8_2 = L0_1
  L8_2 = L8_2[L9_2]
  L8_2 = L8_2.cell
  L6_2(L7_2, L8_2)
  L6_2 = Objects
  L6_2 = L6_2.ApplyProps
  L7_2 = A0_2
  L8_2 = L4_2
  L6_2(L7_2, L8_2)
  L6_2 = MEDockDirty
  if L6_2 then
    L6_2 = MEDockDirty
    L7_2 = "objects"
    L6_2(L7_2)
  end
  L6_2 = L3_1
  return L6_2
end
L25_1.Adopt = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
L25_1.Get = L26_1
L25_1 = Objects
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 0
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L0_2 = L0_2 + 1
  end
  return L0_2
end
L25_1.Count = L26_1
L25_1 = Objects
function L26_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
L25_1.All = L26_1
L25_1 = Objects
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L2_2 = Config
  L2_2 = L2_2.snap
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.snap
    L2_2 = L2_2.snap
    if L2_2 then
      goto lbl_11
    end
  end
  do return A0_2 end
  ::lbl_11::
  L2_2 = Config
  L2_2 = L2_2.snap
  L2_2 = L2_2.snapRadius
  if not L2_2 then
    L2_2 = 4.0
  end
  L3_2 = Config
  L3_2 = L3_2.snap
  L3_2 = L3_2.snapThreshold
  if not L3_2 then
    L3_2 = 0.5
  end
  L4_2 = L2_2 * L2_2
  L5_2 = A0_2.x
  L6_2 = A0_2.y
  L7_2 = A0_2.z
  L8_2 = L3_2
  L9_2 = L3_2
  L10_2 = L3_2
  L11_2 = math
  L11_2 = L11_2.ceil
  L12_2 = L13_1
  L12_2 = L2_2 / L12_2
  L11_2 = L11_2(L12_2)
  if L11_2 < 1 then
    L11_2 = 1
  end
  L12_2 = math
  L12_2 = L12_2.floor
  L13_2 = A0_2.x
  L14_2 = L13_1
  L13_2 = L13_2 / L14_2
  L12_2 = L12_2(L13_2)
  L13_2 = math
  L13_2 = L13_2.floor
  L14_2 = A0_2.y
  L15_2 = L13_1
  L14_2 = L14_2 / L15_2
  L13_2 = L13_2(L14_2)
  L14_2 = L12_2 - L11_2
  L15_2 = L12_2 + L11_2
  L16_2 = 1
  for L17_2 = L14_2, L15_2, L16_2 do
    L18_2 = L13_2 - L11_2
    L19_2 = L13_2 + L11_2
    L20_2 = 1
    for L21_2 = L18_2, L19_2, L20_2 do
      L22_2 = L17_2
      L23_2 = ":"
      L24_2 = L21_2
      L22_2 = L22_2 .. L23_2 .. L24_2
      L23_2 = L14_1
      L22_2 = L23_2[L22_2]
      if L22_2 then
        L23_2 = pairs
        L24_2 = L22_2
        L23_2, L24_2, L25_2, L26_2 = L23_2(L24_2)
        for L27_2 in L23_2, L24_2, L25_2, L26_2 do
          L28_2 = L0_1
          L28_2 = L28_2[L27_2]
          if L28_2 and L27_2 ~= A1_2 then
            L29_2 = L28_2.coords
            if L29_2 then
              L29_2 = L28_2.coords
              L29_2 = L29_2.x
              L30_2 = A0_2.x
              L29_2 = L29_2 - L30_2
              L30_2 = L28_2.coords
              L30_2 = L30_2.y
              L31_2 = A0_2.y
              L30_2 = L30_2 - L31_2
              L31_2 = L29_2 * L29_2
              L32_2 = L30_2 * L30_2
              L31_2 = L31_2 + L32_2
              if L4_2 >= L31_2 then
                if L29_2 < 0 then
                  L31_2 = -L29_2
                  if L31_2 then
                    goto lbl_111
                  end
                end
                L31_2 = L29_2
                ::lbl_111::
                if L30_2 < 0 then
                  L32_2 = -L30_2
                  if L32_2 then
                    goto lbl_117
                  end
                end
                L32_2 = L30_2
                ::lbl_117::
                L33_2 = L28_2.coords
                L33_2 = L33_2.z
                L34_2 = A0_2.z
                L33_2 = L33_2 - L34_2
                if L33_2 < 0 then
                  L34_2 = -L33_2
                  if L34_2 then
                    goto lbl_128
                  end
                end
                L34_2 = L33_2
                ::lbl_128::
                if L8_2 > L31_2 then
                  L8_2 = L31_2
                  L35_2 = L28_2.coords
                  L5_2 = L35_2.x
                end
                if L9_2 > L32_2 then
                  L9_2 = L32_2
                  L35_2 = L28_2.coords
                  L6_2 = L35_2.y
                end
                if L10_2 > L34_2 then
                  L10_2 = L34_2
                  L35_2 = L28_2.coords
                  L7_2 = L35_2.z
                end
              end
            end
          end
        end
      end
    end
  end
  L14_2 = vector3
  L15_2 = L5_2
  L16_2 = L6_2
  L17_2 = L7_2
  return L14_2(L15_2, L16_2, L17_2)
end
L25_1.SnapToNearby = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
L25_1.IdByHandle = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
L25_1.IdByUid = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L1_2.uid
  end
  return L2_2
end
L25_1.UidOf = L26_1
L25_1 = Objects
function L26_1(A0_2, A1_2)
  local L2_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2.dbId = A1_2
  end
end
L25_1.SetDbId = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L1_2.props
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L2_2[L7_2] = L8_2
  end
  L3_2 = {}
  L4_2 = L1_2.uid
  L3_2.uid = L4_2
  L4_2 = L1_2.eid
  L3_2.eid = L4_2
  L4_2 = L1_2.model
  L3_2.model = L4_2
  L4_2 = L1_2.dbId
  L3_2.dbId = L4_2
  L4_2 = L1_2.layer
  if not L4_2 then
    L4_2 = "Default"
  end
  L3_2.layer = L4_2
  L4_2 = L1_2.adopted
  L3_2.adopted = L4_2
  L4_2 = {}
  L5_2 = L1_2.coords
  L5_2 = L5_2.x
  L4_2.x = L5_2
  L5_2 = L1_2.coords
  L5_2 = L5_2.y
  L4_2.y = L5_2
  L5_2 = L1_2.coords
  L5_2 = L5_2.z
  L4_2.z = L5_2
  L3_2.coords = L4_2
  L4_2 = {}
  L5_2 = L1_2.rot
  L5_2 = L5_2.x
  L4_2.x = L5_2
  L5_2 = L1_2.rot
  L5_2 = L5_2.y
  L4_2.y = L5_2
  L5_2 = L1_2.rot
  L5_2 = L5_2.z
  L4_2.z = L5_2
  L3_2.rot = L4_2
  L3_2.props = L2_2
  L4_2 = {}
  L5_2 = L1_2.blipName
  if not L5_2 then
    L5_2 = ""
  end
  L4_2.name = L5_2
  L5_2 = L1_2.blipColor
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.color = L5_2
  L5_2 = L1_2.blipOn
  L5_2 = true == L5_2
  L4_2.on = L5_2
  L3_2.blip = L4_2
  return L3_2
end
L25_1.Snapshot = L26_1
L25_1 = Objects
function L26_1()
  local L0_2, L1_2
  L0_2 = L8_1
  L0_2 = #L0_2
  return L0_2
end
L25_1.DeletedCount = L26_1
L25_1 = Objects
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = {}
  L1_2 = L8_1
  L1_2 = #L1_2
  L2_2 = 1
  L3_2 = -1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = L8_1
    L5_2 = L5_2[L4_2]
    L6_2 = #L0_2
    L6_2 = L6_2 + 1
    L7_2 = {}
    L8_2 = L5_2.uid
    L7_2.uid = L8_2
    L8_2 = L5_2.model
    L7_2.model = L8_2
    L8_2 = L5_2.coords
    L8_2 = L8_2.x
    L7_2.x = L8_2
    L8_2 = L5_2.coords
    L8_2 = L8_2.y
    L7_2.y = L8_2
    L8_2 = L5_2.coords
    L8_2 = L8_2.z
    L7_2.z = L8_2
    L0_2[L6_2] = L7_2
  end
  return L0_2
end
L25_1.DeletedList = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L9_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = Objects
  L2_2 = L2_2.Recreate
  L3_2 = L8_1
  L3_2 = L3_2[L1_2]
  return L2_2(L3_2)
end
L25_1.RestoreDeleted = L26_1
L25_1 = Objects
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2.props
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  L2_2 = Objects
  L2_2 = L2_2.Spawn
  L3_2 = A0_2.model
  L4_2 = vector3
  L5_2 = A0_2.coords
  L5_2 = L5_2.x
  L6_2 = A0_2.coords
  L6_2 = L6_2.y
  L7_2 = A0_2.coords
  L7_2 = L7_2.z
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = vector3
  L6_2 = A0_2.rot
  L6_2 = L6_2.x
  L7_2 = A0_2.rot
  L7_2 = L7_2.y
  L8_2 = A0_2.rot
  L8_2 = L8_2.z
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = L1_2
  L7_2 = A0_2.uid
  L8_2 = A0_2.eid
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L9_1
  L4_2 = A0_2.uid
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = table
    L4_2 = L4_2.remove
    L5_2 = L8_1
    L6_2 = L3_2
    L4_2(L5_2, L6_2)
    L4_2 = MEDockDirty
    if L4_2 then
      L4_2 = MEDockDirty
      L5_2 = "deleted"
      L4_2(L5_2)
    end
  end
  L4_2 = A0_2.adopted
  if L4_2 then
    L4_2 = L0_1
    L4_2 = L4_2[L2_2]
    if L4_2 then
      L4_2.adopted = true
    end
  end
  L4_2 = A0_2.layer
  if L4_2 then
    L4_2 = A0_2.layer
    if "Default" ~= L4_2 then
      L4_2 = Objects
      L4_2 = L4_2.SetObjectLayer
      L5_2 = L2_2
      L6_2 = A0_2.layer
      L4_2(L5_2, L6_2)
    end
  end
  L4_2 = A0_2.blip
  if L4_2 then
    L4_2 = Objects
    L4_2 = L4_2.SetBlip
    L5_2 = L2_2
    L6_2 = A0_2.blip
    L6_2 = L6_2.name
    L7_2 = A0_2.blip
    L7_2 = L7_2.color
    L8_2 = A0_2.blip
    L8_2 = L8_2.on
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
  L4_2 = A0_2.dbId
  if L4_2 then
    L4_2 = Objects
    L4_2 = L4_2.SetDbId
    L5_2 = L2_2
    L6_2 = A0_2.dbId
    L4_2(L5_2, L6_2)
  end
  L4_2 = MEAutoSave
  if L4_2 then
    L4_2 = MEAutoSave
    L5_2 = L2_2
    L4_2(L5_2)
  end
  return L2_2
end
L25_1.Recreate = L26_1
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = math
  L3_2 = L3_2.rad
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = 0.0
  end
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.cos
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.sin
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = A0_2 * L4_2
  L7_2 = A1_2 * L5_2
  L6_2 = L6_2 - L7_2
  L7_2 = A0_2 * L5_2
  L8_2 = A1_2 * L4_2
  L7_2 = L7_2 + L8_2
  return L6_2, L7_2
end
L26_1 = Objects
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  if A0_2 then
    L1_2 = #A0_2
    if 0 ~= L1_2 then
      goto lbl_8
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_8::
  L1_2 = {}
  L2_2 = 0.0
  L3_2 = 0.0
  L4_2 = 0.0
  L5_2 = 1
  L6_2 = #A0_2
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = Objects
    L9_2 = L9_2.Snapshot
    L10_2 = A0_2[L8_2]
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = #L1_2
      L10_2 = L10_2 + 1
      L1_2[L10_2] = L9_2
      L10_2 = L9_2.coords
      L10_2 = L10_2.x
      L2_2 = L2_2 + L10_2
      L10_2 = L9_2.coords
      L10_2 = L10_2.y
      L3_2 = L3_2 + L10_2
      L10_2 = L9_2.coords
      L10_2 = L10_2.z
      L4_2 = L4_2 + L10_2
    end
  end
  L5_2 = #L1_2
  if 0 == L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = {}
  L7_2 = L2_2 / L5_2
  L6_2.x = L7_2
  L7_2 = L3_2 / L5_2
  L6_2.y = L7_2
  L7_2 = L4_2 / L5_2
  L6_2.z = L7_2
  L7_2 = {}
  L8_2 = 1
  L9_2 = L5_2
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = L1_2[L11_2]
    L13_2 = {}
    L13_2.snapshot = L12_2
    L14_2 = L12_2.rot
    L13_2.rot = L14_2
    L14_2 = {}
    L15_2 = L12_2.coords
    L15_2 = L15_2.x
    L16_2 = L6_2.x
    L15_2 = L15_2 - L16_2
    L14_2.x = L15_2
    L15_2 = L12_2.coords
    L15_2 = L15_2.y
    L16_2 = L6_2.y
    L15_2 = L15_2 - L16_2
    L14_2.y = L15_2
    L15_2 = L12_2.coords
    L15_2 = L15_2.z
    L16_2 = L6_2.z
    L15_2 = L15_2 - L16_2
    L14_2.z = L15_2
    L13_2.offset = L14_2
    L7_2[L11_2] = L13_2
  end
  L8_2 = {}
  L8_2.centroid = L6_2
  L8_2.entries = L7_2
  return L8_2
end
L26_1.CaptureGroup = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  if not A0_2 then
    L3_2 = {}
    return L3_2
  end
  if not A2_2 then
    A2_2 = 0.0
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A0_2.entries
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.offset
    L10_2 = L10_2.x
    L11_2 = L9_2.offset
    L11_2 = L11_2.y
    if 0.0 ~= A2_2 then
      L12_2 = L25_1
      L13_2 = L10_2
      L14_2 = L11_2
      L15_2 = A2_2
      L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
      L11_2 = L13_2
      L10_2 = L12_2
    end
    L12_2 = vector3
    L13_2 = A1_2.x
    L13_2 = L13_2 + L10_2
    L14_2 = A1_2.y
    L14_2 = L14_2 + L11_2
    L15_2 = A1_2.z
    L16_2 = L9_2.offset
    L16_2 = L16_2.z
    L15_2 = L15_2 + L16_2
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    L13_2 = vector3
    L14_2 = L9_2.rot
    L14_2 = L14_2.x
    L15_2 = L9_2.rot
    L15_2 = L15_2.y
    L16_2 = L9_2.rot
    L16_2 = L16_2.z
    L16_2 = L16_2 + A2_2
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    L14_2 = {}
    L15_2 = pairs
    L16_2 = L9_2.snapshot
    L16_2 = L16_2.props
    if not L16_2 then
      L16_2 = {}
    end
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      L14_2[L19_2] = L20_2
    end
    L15_2 = Objects
    L15_2 = L15_2.Spawn
    L16_2 = L9_2.snapshot
    L16_2 = L16_2.model
    L17_2 = L12_2
    L18_2 = L13_2
    L19_2 = L14_2
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
    if L15_2 then
      L16_2 = L9_2.snapshot
      L16_2 = L16_2.layer
      if L16_2 then
        L16_2 = L9_2.snapshot
        L16_2 = L16_2.layer
        if "Default" ~= L16_2 then
          L16_2 = Objects
          L16_2 = L16_2.SetObjectLayer
          L17_2 = L15_2
          L18_2 = L9_2.snapshot
          L18_2 = L18_2.layer
          L16_2(L17_2, L18_2)
        end
      end
      L16_2 = L9_2.snapshot
      L16_2 = L16_2.blip
      if L16_2 then
        L17_2 = L16_2.on
        if L17_2 then
          L17_2 = Objects
          L17_2 = L17_2.SetBlip
          L18_2 = L15_2
          L19_2 = L16_2.name
          L20_2 = L16_2.color
          L21_2 = L16_2.on
          L17_2(L18_2, L19_2, L20_2, L21_2)
        end
      end
      L17_2 = MEAutoSave
      if L17_2 then
        L17_2 = MEAutoSave
        L18_2 = L15_2
        L17_2(L18_2)
      end
      L17_2 = #L3_2
      L17_2 = L17_2 + 1
      L3_2[L17_2] = L15_2
    end
  end
  return L3_2
end
L26_1.PlaceGroup = L27_1
L26_1 = Objects
function L27_1()
  local L0_2, L1_2
  L0_2 = L5_1
  return L0_2
end
L26_1.CurrentLayer = L27_1
L26_1 = Objects
function L27_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2 or L1_2
  if nil == A0_2 or "" == A0_2 or not A0_2 then
    L1_2 = "Default"
  end
  L5_1 = L1_2
  L1_2 = L5_1
  if "Default" ~= L1_2 then
    L2_2 = L5_1
    L1_2 = L7_1
    L1_2[L2_2] = true
  end
end
L26_1.SetCurrentLayer = L27_1
L26_1 = Objects
function L27_1(A0_2)
  local L1_2
  if A0_2 and "" ~= A0_2 and "Default" ~= A0_2 then
    L1_2 = L7_1
    L1_2[A0_2] = true
  end
end
L26_1.AddLayer = L27_1
L26_1 = Objects
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 or "Default" == A0_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.layer
    if not L7_2 then
      L7_2 = "Default"
    end
    if L7_2 == A0_2 then
      L6_2.layer = "Default"
      L7_2 = DoesEntityExist
      L8_2 = L6_2.handle
      L7_2 = L7_2(L8_2)
      if L7_2 then
        L7_2 = Objects
        L7_2 = L7_2.ApplyProps
        L8_2 = L6_2.handle
        L9_2 = L6_2.props
        L7_2(L8_2, L9_2)
      end
    end
  end
  L1_2 = L7_1
  L1_2[A0_2] = nil
  L1_2 = L6_1
  L1_2[A0_2] = nil
end
L26_1.RemoveLayer = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = A1_2 or L3_2
  if not A1_2 or "" == A1_2 or not A1_2 then
    L3_2 = "Default"
  end
  L2_2.layer = L3_2
  L3_2 = L2_2.layer
  if "Default" ~= L3_2 then
    L4_2 = L2_2.layer
    L3_2 = L7_1
    L3_2[L4_2] = true
  end
  L3_2 = DoesEntityExist
  L4_2 = L2_2.handle
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L2_2.layer
    L3_2 = L6_1
    L3_2 = L3_2[L4_2]
    if false == L3_2 then
      L3_2 = SetEntityVisible
      L4_2 = L2_2.handle
      L5_2 = false
      L6_2 = false
      L3_2(L4_2, L5_2, L6_2)
    else
      L3_2 = Objects
      L3_2 = L3_2.ApplyProps
      L4_2 = L2_2.handle
      L5_2 = L2_2.props
      L3_2(L4_2, L5_2)
    end
  end
end
L26_1.SetObjectLayer = L27_1
L26_1 = Objects
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = {}
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L7_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = {}
    L7_2.name = L6_2
    L8_2 = L6_1
    L8_2 = L8_2[L6_2]
    L8_2 = false ~= L8_2
    L7_2.visible = L8_2
    L8_2 = {}
    L7_2.objects = L8_2
    L0_2[L6_2] = L7_2
  end
  L2_2 = pairs
  L3_2 = L0_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.layer
    if not L8_2 then
      L8_2 = "Default"
    end
    if "Default" == L8_2 then
      L9_2 = #L1_2
      L9_2 = L9_2 + 1
      L10_2 = {}
      L10_2.id = L6_2
      L11_2 = L7_2.model
      L10_2.model = L11_2
      L1_2[L9_2] = L10_2
    else
      L9_2 = L0_2[L8_2]
      if not L9_2 then
        L9_2 = {}
        L9_2.name = L8_2
        L10_2 = L6_1
        L10_2 = L10_2[L8_2]
        L10_2 = false ~= L10_2
        L9_2.visible = L10_2
        L10_2 = {}
        L9_2.objects = L10_2
        L0_2[L8_2] = L9_2
      end
      L9_2 = L0_2[L8_2]
      L9_2 = L9_2.objects
      L10_2 = #L9_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L11_2.id = L6_2
      L12_2 = L7_2.model
      L11_2.model = L12_2
      L9_2[L10_2] = L11_2
    end
  end
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L2_2[L9_2] = L8_2
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L2_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.name
    L3_3 = A1_3.name
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L1_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.id
    L3_3 = A1_3.id
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  L3_2 = 1
  L4_2 = #L2_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = table
    L7_2 = L7_2.sort
    L8_2 = L2_2[L6_2]
    L8_2 = L8_2.objects
    function L9_2(A0_3, A1_3)
      local L2_3, L3_3
      L2_3 = A0_3.id
      L3_3 = A1_3.id
      L2_3 = L2_3 > L3_3
      return L2_3
    end
    L7_2(L8_2, L9_2)
  end
  L3_2 = {}
  L3_2.layers = L2_2
  L3_2.created = L1_2
  return L3_2
end
L26_1.LayersFull = L27_1
L26_1 = Objects
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = {}
  L2_2 = L5_1
  L2_2 = L1_2[L2_2]
  if not L2_2 then
    L2_2 = L5_1
    L3_2 = {}
    L4_2 = L5_1
    L3_2.name = L4_2
    L3_2.count = 0
    L5_2 = L5_1
    L4_2 = L6_1
    L4_2 = L4_2[L5_2]
    L4_2 = false ~= L4_2
    L3_2.visible = L4_2
    L1_2[L2_2] = L3_2
    L2_2 = #L0_2
    L2_2 = L2_2 + 1
    L3_2 = L5_1
    L0_2[L2_2] = L3_2
  end
  L2_2 = pairs
  L3_2 = L0_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.layer
    if not L8_2 then
      L8_2 = "Default"
    end
    L9_2 = L1_2[L8_2]
    if not L9_2 then
      L9_2 = {}
      L9_2.name = L8_2
      L9_2.count = 0
      L10_2 = L6_1
      L10_2 = L10_2[L8_2]
      L10_2 = false ~= L10_2
      L9_2.visible = L10_2
      L1_2[L8_2] = L9_2
      L9_2 = #L0_2
      L9_2 = L9_2 + 1
      L0_2[L9_2] = L8_2
    end
    L9_2 = L1_2[L8_2]
    L10_2 = L1_2[L8_2]
    L10_2 = L10_2.count
    L10_2 = L10_2 + 1
    L9_2.count = L10_2
  end
  L2_2 = {}
  L3_2 = 1
  L4_2 = #L0_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = L0_2[L6_2]
    L7_2 = L1_2[L7_2]
    L2_2[L6_2] = L7_2
  end
  return L2_2
end
L26_1.LayerSummary = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L6_1
  L2_2[A0_2] = A1_2
  L2_2 = pairs
  L3_2 = L0_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.layer
    if not L8_2 then
      L8_2 = "Default"
    end
    if L8_2 == A0_2 then
      L8_2 = DoesEntityExist
      L9_2 = L7_2.handle
      L8_2 = L8_2(L9_2)
      if L8_2 then
        if A1_2 then
          L8_2 = Objects
          L8_2 = L8_2.ApplyProps
          L9_2 = L7_2.handle
          L10_2 = L7_2.props
          L8_2(L9_2, L10_2)
        else
          L8_2 = SetEntityVisible
          L9_2 = L7_2.handle
          L10_2 = false
          L11_2 = false
          L8_2(L9_2, L10_2, L11_2)
        end
      end
    end
  end
end
L26_1.SetLayerVisible = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = L0_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    return
  end
  L4_2 = DoesEntityExist
  L5_2 = L3_2.handle
  L4_2 = L4_2(L5_2)
  if A1_2 then
    L3_2.coords = A1_2
    if L4_2 then
      L5_2 = SetEntityCoords
      L6_2 = L3_2.handle
      L7_2 = A1_2.x
      L8_2 = A1_2.y
      L9_2 = A1_2.z
      L10_2 = false
      L11_2 = false
      L12_2 = false
      L13_2 = false
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    end
    L5_2 = L3_2.blip
    if L5_2 then
      L5_2 = DoesBlipExist
      L6_2 = L3_2.blip
      L5_2 = L5_2(L6_2)
      if L5_2 then
        L5_2 = SetBlipCoords
        L6_2 = L3_2.blip
        L7_2 = A1_2.x
        L8_2 = A1_2.y
        L9_2 = A1_2.z
        L5_2(L6_2, L7_2, L8_2, L9_2)
      end
    end
    L5_2 = L15_1
    L6_2 = A1_2.x
    L7_2 = A1_2.y
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = L3_2.cell
    if L5_2 ~= L6_2 then
      L6_2 = L16_1
      L7_2 = A0_2
      L8_2 = L3_2.cell
      L6_2(L7_2, L8_2)
      L6_2 = L17_1
      L7_2 = A0_2
      L8_2 = L5_2
      L6_2(L7_2, L8_2)
      L3_2.cell = L5_2
    end
    if L4_2 then
      L6_2 = GetGameTimer
      L6_2 = L6_2()
      L7_2 = L3_2.roomAt
      if not L7_2 then
        L7_2 = 0
      end
      L7_2 = L6_2 - L7_2
      L8_2 = 400
      if L7_2 > L8_2 then
        L3_2.roomAt = L6_2
        L7_2 = L24_1
        L8_2 = L3_2
        L7_2(L8_2)
      end
    end
  end
  if A2_2 then
    L3_2.rot = A2_2
    if L4_2 then
      L5_2 = SetEntityRotation
      L6_2 = L3_2.handle
      L7_2 = A2_2.x
      L8_2 = A2_2.y
      L9_2 = A2_2.z
      L10_2 = 2
      L11_2 = true
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    end
  end
end
L26_1.Update = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = pairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2.props
    L9_2[L7_2] = L8_2
  end
  L3_2 = Objects
  L3_2 = L3_2.ApplyProps
  L4_2 = L2_2.handle
  L5_2 = L2_2.props
  L3_2(L4_2, L5_2)
end
L26_1.SetProps = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = L18_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    return
  end
  L4_2 = DoesEntityExist
  L5_2 = L2_2.handle
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = SetEntityDrawOutline
    L5_2 = L2_2.handle
    L6_2 = false
    L4_2(L5_2, L6_2)
    L4_2 = DeleteEntity
    L5_2 = L2_2.handle
    L4_2(L5_2)
  end
  L5_2 = L2_2.handle
  L4_2 = L1_1
  L4_2[L5_2] = nil
  L4_2 = CreateObjectNoOffset
  L5_2 = L3_2
  L6_2 = L2_2.coords
  L6_2 = L6_2.x
  L7_2 = L2_2.coords
  L7_2 = L7_2.y
  L8_2 = L2_2.coords
  L8_2 = L8_2.z
  L9_2 = false
  L10_2 = false
  L11_2 = false
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = SetModelAsNoLongerNeeded
  L6_2 = L3_2
  L5_2(L6_2)
  L5_2 = SetEntityRotation
  L6_2 = L4_2
  L7_2 = L2_2.rot
  L7_2 = L7_2.x
  L8_2 = L2_2.rot
  L8_2 = L8_2.y
  L9_2 = L2_2.rot
  L9_2 = L9_2.z
  L10_2 = 2
  L11_2 = true
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = Objects
  L5_2 = L5_2.ApplyProps
  L6_2 = L4_2
  L7_2 = L2_2.props
  L5_2(L6_2, L7_2)
  L5_2 = L4_2
  L2_2.model = A1_2
  L2_2.handle = L5_2
  L5_2 = L1_1
  L5_2[L4_2] = A0_2
  L5_2 = L24_1
  L6_2 = L2_2
  L5_2(L6_2)
end
L26_1.Replace = L27_1
L26_1 = Objects
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = L2_2.dbId
  if L3_2 and not A1_2 then
    L3_2 = TriggerServerEvent
    L4_2 = "0r-mapeditor:deleteObject"
    L5_2 = L2_2.dbId
    L3_2(L4_2, L5_2)
  end
  L3_2 = L2_2.adopted
  if L3_2 then
    L3_2 = Objects
    L3_2 = L3_2.Snapshot
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L4_2 = L9_1
      L5_2 = L3_2.uid
      L4_2 = L4_2(L5_2)
      if L4_2 then
        L5_2 = L8_1
        L5_2[L4_2] = L3_2
      else
        L5_2 = L8_1
        L5_2 = #L5_2
        L6_2 = L5_2 + 1
        L5_2 = L8_1
        L5_2[L6_2] = L3_2
      end
    end
  end
  L3_2 = L21_1
  L4_2 = L2_2
  L3_2(L4_2)
  L4_2 = L2_2.handle
  L3_2 = L1_1
  L3_2[L4_2] = nil
  L4_2 = L2_2.uid
  L3_2 = L2_1
  L3_2[L4_2] = nil
  L3_2 = L16_1
  L4_2 = A0_2
  L5_2 = L2_2.cell
  L3_2(L4_2, L5_2)
  L3_2 = DoesEntityExist
  L4_2 = L2_2.handle
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = SetEntityDrawOutline
    L4_2 = L2_2.handle
    L5_2 = false
    L3_2(L4_2, L5_2)
    L3_2 = DeleteEntity
    L4_2 = L2_2.handle
    L3_2(L4_2)
  end
  L3_2 = L0_1
  L3_2[A0_2] = nil
  L3_2 = MEDockDirty
  if L3_2 then
    L3_2 = MEDockDirty
    L4_2 = "objects"
    L3_2(L4_2)
    L3_2 = MEDockDirty
    L4_2 = "deleted"
    L3_2(L4_2)
  end
end
L26_1.Remove = L27_1
L26_1 = Objects
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = pairs
  L1_2 = L0_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = L21_1
    L7_2 = L5_2
    L6_2(L7_2)
    L6_2 = DoesEntityExist
    L7_2 = L5_2.handle
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = SetEntityDrawOutline
      L7_2 = L5_2.handle
      L8_2 = false
      L6_2(L7_2, L8_2)
      L6_2 = DeleteEntity
      L7_2 = L5_2.handle
      L6_2(L7_2)
    end
  end
  L0_2 = {}
  L0_1 = L0_2
  L0_2 = {}
  L1_1 = L0_2
  L0_2 = {}
  L2_1 = L0_2
  L0_2 = {}
  L8_1 = L0_2
  L0_2 = {}
  L14_1 = L0_2
  L0_2 = 0
  L3_1 = L0_2
  L0_2 = 0
  L4_1 = L0_2
  L0_2 = MEDockDirty
  if L0_2 then
    L0_2 = MEDockDirty
    L1_2 = "deleted"
    L0_2(L1_2)
  end
end
L26_1.Clear = L27_1
L26_1 = AddEventHandler
L27_1 = "onResourceStop"
function L28_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = Objects
    L1_2 = L1_2.Clear
    L1_2()
  end
end
L26_1(L27_1, L28_1)
