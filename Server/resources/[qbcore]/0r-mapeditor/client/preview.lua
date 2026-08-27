local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1
L0_1 = {}
Preview = L0_1
L0_1 = false
L1_1 = nil
L2_1 = nil
L3_1 = 1.0
L4_1 = 0.0
L5_1 = 0
L6_1 = {}
L6_1.cx = 0.16
L6_1.cy = 0.74
L6_1.fh = 0.16
function L7_1()
  local L0_2, L1_2, L2_2
  L0_2 = L1_1
  if L0_2 then
    L0_2 = DoesEntityExist
    L1_2 = L1_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = SetEntityDrawOutline
      L1_2 = L1_1
      L2_2 = false
      L0_2(L1_2, L2_2)
      L0_2 = DeleteEntity
      L1_2 = L1_1
      L0_2(L1_2)
    end
  end
  L0_2 = nil
  L1_1 = L0_2
end
L8_1 = Preview
function L9_1(A0_2, A1_2, A2_2)
  local L3_2
  if A0_2 then
    L6_1.cx = A0_2
  end
  if A1_2 then
    L6_1.cy = A1_2
  end
  if A2_2 then
    L3_2 = 0.02
    if A2_2 > L3_2 then
      L6_1.fh = A2_2
    end
  end
end
L8_1.SetCard = L9_1
L8_1 = Preview
function L9_1()
  local L0_2, L1_2
  L0_2 = false
  L0_1 = L0_2
  L0_2 = L5_1
  L0_2 = L0_2 + 1
  L5_1 = L0_2
  L0_2 = L7_1
  L0_2()
  L0_2 = nil
  L2_1 = L0_2
end
L8_1.Stop = L9_1
L8_1 = Preview
function L9_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L1_1
    L0_2 = nil ~= L0_2
  end
  return L0_2
end
L8_1.IsActive = L9_1
function L8_1()
  local L0_2, L1_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L1_1
      if not L0_3 then
        break
      end
      L0_3 = DoesEntityExist
      L1_3 = L1_1
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        break
      end
      L0_3 = L4_1
      L0_3 = L0_3 + 0.6
      L0_3 = L0_3 % 360.0
      L4_1 = L0_3
      L0_3 = Camera
      L0_3 = L0_3.ScreenToWorldRay
      L1_3 = L6_1.cx
      L2_3 = L6_1.cy
      L0_3, L1_3 = L0_3(L1_3, L2_3)
      L2_3 = math
      L2_3 = L2_3.tan
      L3_3 = math
      L3_3 = L3_3.rad
      L4_3 = Camera
      L4_3 = L4_3.GetVFov
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L4_3()
      L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
      L3_3 = L3_3 * 0.5
      L2_3 = L2_3(L3_3)
      L3_3 = L3_1
      L3_3 = L3_3 * 1.7
      L4_3 = math
      L4_3 = L4_3.max
      L5_3 = L6_1.fh
      L6_3 = 0.04
      L4_3 = L4_3(L5_3, L6_3)
      L4_3 = L4_3 * L2_3
      L3_3 = L3_3 / L4_3
      L4_3 = L3_1
      L4_3 = L4_3 + 0.6
      if L3_3 < L4_3 then
        L4_3 = L3_1
        L3_3 = L4_3 + 0.6
      end
      L4_3 = L1_3 * L3_3
      L4_3 = L0_3 + L4_3
      L5_3 = SetEntityCoordsNoOffset
      L6_3 = L1_1
      L7_3 = L4_3.x
      L8_3 = L4_3.y
      L9_3 = L4_3.z
      L10_3 = false
      L11_3 = false
      L12_3 = false
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
      L5_3 = SetEntityRotation
      L6_3 = L1_1
      L7_3 = -12.0
      L8_3 = 0.0
      L9_3 = L4_1
      L10_3 = 2
      L11_3 = true
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
      L5_3 = Wait
      L6_3 = 0
      L5_3(L6_3)
    end
  end
  L0_2(L1_2)
end
L9_1 = Preview
function L10_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    return
  end
  L4_2 = Preview
  L4_2 = L4_2.SetCard
  L5_2 = A1_2
  L6_2 = A2_2
  L7_2 = A3_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = true
  L0_1 = L4_2
  L4_2 = L2_1
  if A0_2 == L4_2 then
    L4_2 = L1_1
    if L4_2 then
      L4_2 = DoesEntityExist
      L5_2 = L1_1
      L4_2 = L4_2(L5_2)
      if L4_2 then
        return
      end
    end
  end
  L4_2 = L5_1
  L4_2 = L4_2 + 1
  L5_1 = L4_2
  L4_2 = L5_1
  L2_1 = A0_2
  L5_2 = L7_1
  L5_2()
  L5_2 = CreateThread
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = joaat
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L1_3 = IsModelValid
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      return
    end
    L1_3 = RequestModel
    L2_3 = L0_3
    L1_3(L2_3)
    L1_3 = GetGameTimer
    L1_3 = L1_3()
    while true do
      L2_3 = HasModelLoaded
      L3_3 = L0_3
      L2_3 = L2_3(L3_3)
      if L2_3 then
        break
      end
      L2_3 = GetGameTimer
      L2_3 = L2_3()
      L2_3 = L2_3 - L1_3
      L3_3 = 2000
      if not (L2_3 < L3_3) then
        break
      end
      L2_3 = Wait
      L3_3 = 0
      L2_3(L3_3)
    end
    L2_3 = L4_2
    L3_3 = L5_1
    if L2_3 == L3_3 then
      L2_3 = L0_1
      if L2_3 then
        goto lbl_42
      end
    end
    L2_3 = SetModelAsNoLongerNeeded
    L3_3 = L0_3
    L2_3(L3_3)
    do return end
    ::lbl_42::
    L2_3 = HasModelLoaded
    L3_3 = L0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      return
    end
    L2_3 = Camera
    L2_3 = L2_3.GetCoords
    L2_3 = L2_3()
    L3_3 = CreateObjectNoOffset
    L4_3 = L0_3
    L5_3 = L2_3.x
    L6_3 = L2_3.y
    L7_3 = L2_3.z
    L7_3 = L7_3 - 300.0
    L8_3 = false
    L9_3 = false
    L10_3 = false
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    L4_3 = SetEntityCollision
    L5_3 = L3_3
    L6_3 = false
    L7_3 = false
    L4_3(L5_3, L6_3, L7_3)
    L4_3 = FreezeEntityPosition
    L5_3 = L3_3
    L6_3 = true
    L4_3(L5_3, L6_3)
    L4_3 = SetEntityInvincible
    L5_3 = L3_3
    L6_3 = true
    L4_3(L5_3, L6_3)
    L4_3 = SetEntityLodDist
    L5_3 = L3_3
    L6_3 = 2000
    L4_3(L5_3, L6_3)
    L4_3 = SetEntityAlpha
    L5_3 = L3_3
    L6_3 = 255
    L7_3 = false
    L4_3(L5_3, L6_3, L7_3)
    L4_3 = SetModelAsNoLongerNeeded
    L5_3 = L0_3
    L4_3(L5_3)
    L4_3 = 0.5
    L3_1 = L4_3
    if 0 ~= L0_3 then
      L4_3 = IsModelValid
      L5_3 = L0_3
      L4_3 = L4_3(L5_3)
      if L4_3 then
        L4_3 = pcall
        L5_3 = GetModelDimensions
        L6_3 = L0_3
        L4_3, L5_3, L6_3 = L4_3(L5_3, L6_3)
        if L4_3 and L5_3 and L6_3 then
          L7_3 = L6_3 - L5_3
          L7_3 = #L7_3
          L7_3 = L7_3 * 0.5
          L3_1 = L7_3
        end
      end
    end
    L4_3 = L3_1
    L5_3 = 0.15
    if L4_3 < L5_3 then
      L4_3 = 0.5
      L3_1 = L4_3
    end
    L4_3 = L4_2
    L5_3 = L5_1
    if L4_3 == L5_3 then
      L4_3 = L0_1
      if L4_3 then
        goto lbl_138
      end
    end
    L4_3 = DoesEntityExist
    L5_3 = L3_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = SetEntityDrawOutline
      L5_3 = L3_3
      L6_3 = false
      L4_3(L5_3, L6_3)
      L4_3 = DeleteEntity
      L5_3 = L3_3
      L4_3(L5_3)
    end
    do return end
    ::lbl_138::
    L1_1 = L3_3
    L4_3 = 215.0
    L4_1 = L4_3
    L4_3 = L8_1
    L4_3()
  end
  L5_2(L6_2)
end
L9_1.Show = L10_1
