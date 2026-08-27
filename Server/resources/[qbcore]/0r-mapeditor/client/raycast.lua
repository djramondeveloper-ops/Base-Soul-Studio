local L0_1, L1_1, L2_1
L0_1 = {}
Raycast = L0_1
L0_1 = {}
L1_1 = Raycast
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = L0_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L4_2 = {}
    L4_2.hit = false
    L3_2 = L4_2
    L4_2 = L0_1
    L4_2[A0_2] = L3_2
  end
  L4_2 = L3_2.pending
  if L4_2 then
    L4_2 = GetShapeTestResult
    L5_2 = L3_2.pending
    L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2)
    if 1 ~= L4_2 then
      L3_2.pending = nil
      L9_2 = true == L5_2 or 1 == L5_2
      L3_2.hit = L9_2
      L9_2 = L6_2
      L10_2 = L7_2
      L3_2.entity = L8_2
      L3_2.normal = L10_2
      L3_2.coords = L9_2
    end
  end
  L4_2 = L3_2.pending
  if not L4_2 then
    L4_2 = Camera
    L4_2 = L4_2.CursorRay
    L4_2, L5_2 = L4_2()
    L6_2 = Config
    L6_2 = L6_2.placement
    L6_2 = L6_2.maxRayDistance
    L6_2 = L5_2 * L6_2
    L6_2 = L4_2 + L6_2
    L7_2 = StartShapeTestLosProbe
    L8_2 = L4_2.x
    L9_2 = L4_2.y
    L10_2 = L4_2.z
    L11_2 = L6_2.x
    L12_2 = L6_2.y
    L13_2 = L6_2.z
    L14_2 = A2_2 or L14_2
    if not A2_2 then
      L14_2 = -1
    end
    L15_2 = A1_2 or L15_2
    if not A1_2 then
      L15_2 = 0
    end
    L16_2 = 4
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L3_2.pending = L7_2
  end
  L4_2 = L3_2.hit
  L4_2 = true == L4_2
  L5_2 = L3_2.coords
  L6_2 = L3_2.normal
  L7_2 = L3_2.entity
  return L4_2, L5_2, L6_2, L7_2
end
L1_1.Cursor = L2_1
L1_1 = Raycast
function L2_1(A0_2)
  local L1_2
  L1_2 = L0_1
  L1_2[A0_2] = nil
end
L1_1.Reset = L2_1
