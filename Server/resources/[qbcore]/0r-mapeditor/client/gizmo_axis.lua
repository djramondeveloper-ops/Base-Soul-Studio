local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1
L0_1 = nil
L1_1 = false
L2_1 = nil
L3_1 = nil
L4_1 = nil
L5_1 = 0.0
L6_1 = nil
L7_1 = nil
L8_1 = nil
L9_1 = nil
L10_1 = nil
L11_1 = false
L12_1 = 0.0
L13_1 = 0.0
L14_1 = 0
L15_1 = 0
L16_1 = 0
function L17_1()
  local L0_2, L1_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L16_1 = L0_2
end
MEAxisSuppress = L17_1
L17_1 = Gizmo
function L18_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = false
  L1_2 = nil
  L2_2 = nil
  L3_2 = nil
  L8_1 = L3_2
  L3_1 = L2_2
  L2_1 = L1_2
  L1_1 = L0_2
  L0_2 = nil
  L1_2 = nil
  L2_2 = nil
  L10_1 = L2_2
  L9_1 = L1_2
  L7_1 = L0_2
end
L17_1.AbortAxisDrag = L18_1
function L17_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L6_2 = A4_2 - A2_2
  L6_2 = L6_2 ^ 2
  L7_2 = A5_2 - A3_2
  L7_2 = L7_2 ^ 2
  L6_2 = L6_2 + L7_2
  if 0 == L6_2 then
    L7_2 = A0_2 - A2_2
    L7_2 = L7_2 ^ 2
    L8_2 = A1_2 - A3_2
    L8_2 = L8_2 ^ 2
    L7_2 = L7_2 + L8_2
    return L7_2
  end
  L7_2 = A0_2 - A2_2
  L8_2 = A4_2 - A2_2
  L7_2 = L7_2 * L8_2
  L8_2 = A1_2 - A3_2
  L9_2 = A5_2 - A3_2
  L8_2 = L8_2 * L9_2
  L7_2 = L7_2 + L8_2
  L7_2 = L7_2 / L6_2
  L8_2 = math
  L8_2 = L8_2.max
  L9_2 = 0
  L10_2 = math
  L10_2 = L10_2.min
  L11_2 = 1
  L12_2 = L7_2
  L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L7_2 = L8_2
  L8_2 = A4_2 - A2_2
  L8_2 = L7_2 * L8_2
  L8_2 = A2_2 + L8_2
  L8_2 = A0_2 - L8_2
  L8_2 = L8_2 ^ 2
  L9_2 = A5_2 - A3_2
  L9_2 = L7_2 * L9_2
  L9_2 = A3_2 + L9_2
  L9_2 = A1_2 - L9_2
  L9_2 = L9_2 ^ 2
  L8_2 = L8_2 + L9_2
  return L8_2
end
L18_1 = 22
L19_1 = {}
L20_1 = {}
L21_1 = 0
L22_1 = L18_1
L23_1 = 1
for L24_1 = L21_1, L22_1, L23_1 do
  L25_1 = L24_1 / L18_1
  L25_1 = L25_1 * 2.0
  L26_1 = math
  L26_1 = L26_1.pi
  L25_1 = L25_1 * L26_1
  L26_1 = L24_1 + 1
  L27_1 = math
  L27_1 = L27_1.cos
  L28_1 = L25_1
  L27_1 = L27_1(L28_1)
  L19_1[L26_1] = L27_1
  L26_1 = L24_1 + 1
  L27_1 = math
  L27_1 = L27_1.sin
  L28_1 = L25_1
  L27_1 = L27_1(L28_1)
  L20_1[L26_1] = L27_1
end
L21_1 = 12
L22_1 = {}
L23_1 = {}
L24_1 = 0
L25_1 = L21_1
L26_1 = 1
for L27_1 = L24_1, L25_1, L26_1 do
  L28_1 = L27_1 / L21_1
  L28_1 = L28_1 * 2.0
  L29_1 = math
  L29_1 = L29_1.pi
  L28_1 = L28_1 * L29_1
  L29_1 = L27_1 + 1
  L30_1 = math
  L30_1 = L30_1.cos
  L31_1 = L28_1
  L30_1 = L30_1(L31_1)
  L22_1[L29_1] = L30_1
  L29_1 = L27_1 + 1
  L30_1 = math
  L30_1 = L30_1.sin
  L31_1 = L28_1
  L30_1 = L30_1(L31_1)
  L23_1[L29_1] = L30_1
end
L24_1 = -1.0
L25_1 = -1.0
L26_1 = vector3
L27_1 = 1.0
L28_1 = 0.0
L29_1 = 0.0
L26_1 = L26_1(L27_1, L28_1, L29_1)
L27_1 = vector3
L28_1 = 0.0
L29_1 = 1.0
L30_1 = 0.0
L27_1 = L27_1(L28_1, L29_1, L30_1)
L28_1 = vector3
L29_1 = 0.0
L30_1 = 0.0
L31_1 = 1.0
L28_1 = L28_1(L29_1, L30_1, L31_1)
L29_1 = {}
L30_1 = {}
L30_1.k = "x"
L30_1.v = L26_1
L30_1.r = 236
L30_1.g = 72
L30_1.b = 72
L31_1 = {}
L31_1.k = "y"
L31_1.v = L27_1
L31_1.r = 86
L31_1.g = 208
L31_1.b = 104
L32_1 = {}
L32_1.k = "z"
L32_1.v = L28_1
L32_1.r = 92
L32_1.g = 156
L32_1.b = 255
L29_1[1] = L30_1
L29_1[2] = L31_1
L29_1[3] = L32_1
L30_1 = {}
L31_1 = {}
L31_1.u1 = L27_1
L31_1.u2 = L28_1
L30_1.x = L31_1
L31_1 = {}
L31_1.u1 = L28_1
L31_1.u2 = L26_1
L30_1.y = L31_1
L31_1 = {}
L31_1.u1 = L26_1
L31_1.u2 = L27_1
L30_1.z = L31_1
L31_1 = Gizmo
function L32_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L0_2 = nil ~= L0_2
  return L0_2
end
L31_1.AxisHovered = L32_1
L31_1 = Gizmo
function L32_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
L31_1.IsAxisDragging = L32_1
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.x
  L3_2 = A1_2.x
  L2_2 = L2_2 * L3_2
  L3_2 = A0_2.y
  L4_2 = A1_2.y
  L3_2 = L3_2 * L4_2
  L2_2 = L2_2 + L3_2
  L3_2 = A0_2.z
  L4_2 = A1_2.z
  L3_2 = L3_2 * L4_2
  L2_2 = L2_2 + L3_2
  return L2_2
end
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = A1_2
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = A2_2
  L7_2 = A0_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
function L33_1()
  local L0_2, L1_2
  L0_2 = IsEditorUiHovered
  if L0_2 then
    L0_2 = IsEditorUiHovered
    L0_2 = L0_2()
  end
  return L0_2
end
function L34_1(A0_2)
  local L1_2
  if "x" == A0_2 then
    L1_2 = L26_1
    if L1_2 then
      goto lbl_12
    end
  end
  if "y" == A0_2 then
    L1_2 = L27_1
    if L1_2 then
      goto lbl_12
    end
  end
  L1_2 = L28_1
  ::lbl_12::
  return L1_2
end
function L35_1(A0_2)
  local L1_2
  while true do
    L1_2 = math
    L1_2 = L1_2.pi
    if not (A0_2 > L1_2) then
      break
    end
    L1_2 = math
    L1_2 = L1_2.pi
    L1_2 = 2 * L1_2
    A0_2 = A0_2 - L1_2
  end
  while true do
    L1_2 = math
    L1_2 = L1_2.pi
    L1_2 = -L1_2
    if not (A0_2 < L1_2) then
      break
    end
    L1_2 = math
    L1_2 = L1_2.pi
    L1_2 = 2 * L1_2
    A0_2 = A0_2 + L1_2
  end
  return A0_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = Camera
  L2_2 = L2_2.CursorRay
  L2_2, L3_2 = L2_2()
  L4_2 = L2_2 - A0_2
  L5_2 = L31_1
  L6_2 = L3_2
  L7_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L5_2 * L5_2
  L7_2 = 1.0
  L6_2 = L7_2 - L6_2
  L7_2 = math
  L7_2 = L7_2.abs
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  L8_2 = 1.0E-4
  if L7_2 < L8_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = L31_1
  L8_2 = A1_2
  L9_2 = L4_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L31_1
  L9_2 = L3_2
  L10_2 = L4_2
  L8_2 = L8_2(L9_2, L10_2)
  L8_2 = L5_2 * L8_2
  L7_2 = L7_2 - L8_2
  L7_2 = L7_2 / L6_2
  return L7_2
end
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L34_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = Camera
  L3_2 = L3_2.CursorRay
  L3_2, L4_2 = L3_2()
  L5_2 = L31_1
  L6_2 = L4_2
  L7_2 = L2_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = math
  L6_2 = L6_2.abs
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = 1.0E-4
  if L6_2 < L7_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L31_1
  L7_2 = A0_2 - L3_2
  L8_2 = L2_2
  L6_2 = L6_2(L7_2, L8_2)
  L6_2 = L6_2 / L5_2
  L7_2 = L4_2 * L6_2
  L7_2 = L3_2 + L7_2
  L8_2 = L7_2 - A0_2
  L9_2 = math
  L9_2 = L9_2.atan
  L10_2 = L31_1
  L11_2 = L8_2
  L12_2 = L30_1
  L12_2 = L12_2[A1_2]
  L12_2 = L12_2.u2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L31_1
  L12_2 = L8_2
  L13_2 = L30_1
  L13_2 = L13_2[A1_2]
  L13_2 = L13_2.u1
  L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2)
  return L9_2(L10_2, L11_2, L12_2, L13_2)
end
function L38_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L5_2 = A1_2.k
  L4_2 = L30_1
  L4_2 = L4_2[L5_2]
  L4_2 = L4_2.u1
  L6_2 = A1_2.k
  L5_2 = L30_1
  L5_2 = L5_2[L6_2]
  L5_2 = L5_2.u2
  L7_2 = A3_2 + 1
  L6_2 = L19_1
  L6_2 = L6_2[L7_2]
  L8_2 = A3_2 + 1
  L7_2 = L20_1
  L7_2 = L7_2[L8_2]
  L8_2 = vector3
  L9_2 = A0_2.x
  L10_2 = L4_2.x
  L10_2 = L10_2 * L6_2
  L11_2 = L5_2.x
  L11_2 = L11_2 * L7_2
  L10_2 = L10_2 + L11_2
  L10_2 = L10_2 * A2_2
  L9_2 = L9_2 + L10_2
  L10_2 = A0_2.y
  L11_2 = L4_2.y
  L11_2 = L11_2 * L6_2
  L12_2 = L5_2.y
  L12_2 = L12_2 * L7_2
  L11_2 = L11_2 + L12_2
  L11_2 = L11_2 * A2_2
  L10_2 = L10_2 + L11_2
  L11_2 = A0_2.z
  L12_2 = L4_2.z
  L12_2 = L12_2 * L6_2
  L13_2 = L5_2.z
  L13_2 = L13_2 * L7_2
  L12_2 = L12_2 + L13_2
  L12_2 = L12_2 * A2_2
  L11_2 = L11_2 + L12_2
  return L8_2(L9_2, L10_2, L11_2)
end
function L39_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2, L45_2, L46_2, L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2
  L5_2 = A1_2.k
  L4_2 = L30_1
  L4_2 = L4_2[L5_2]
  L4_2 = L4_2.u1
  L6_2 = A1_2.k
  L5_2 = L30_1
  L5_2 = L5_2[L6_2]
  L5_2 = L5_2.u2
  L6_2 = A1_2.v
  if A3_2 then
    L7_2 = 1.0
    if L7_2 then
      goto lbl_16
    end
  end
  L7_2 = 0.8
  ::lbl_16::
  if A3_2 then
    L8_2 = 255
    if L8_2 then
      goto lbl_22
    end
  end
  L8_2 = 205
  ::lbl_22::
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = A1_2.r
  L10_2 = L10_2 * L7_2
  L9_2 = L9_2(L10_2)
  L10_2 = math
  L10_2 = L10_2.floor
  L11_2 = A1_2.g
  L11_2 = L11_2 * L7_2
  L10_2 = L10_2(L11_2)
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = A1_2.b
  L12_2 = L12_2 * L7_2
  L11_2 = L11_2(L12_2)
  if A3_2 then
    L12_2 = 0.22
    if L12_2 then
      goto lbl_46
    end
  end
  L12_2 = 0.18
  ::lbl_46::
  L12_2 = A2_2 * L12_2
  if A3_2 then
    L13_2 = 0.075
    if L13_2 then
      goto lbl_54
    end
  end
  L13_2 = 0.06
  ::lbl_54::
  L13_2 = A2_2 * L13_2
  L14_2 = A0_2.x
  L15_2 = L6_2.x
  L15_2 = L15_2 * A2_2
  L14_2 = L14_2 + L15_2
  L15_2 = A0_2.y
  L16_2 = L6_2.y
  L16_2 = L16_2 * A2_2
  L15_2 = L15_2 + L16_2
  L16_2 = A0_2.z
  L17_2 = L6_2.z
  L17_2 = L17_2 * A2_2
  L16_2 = L16_2 + L17_2
  L17_2 = A0_2.x
  L18_2 = L6_2.x
  L19_2 = A2_2 - L12_2
  L18_2 = L18_2 * L19_2
  L17_2 = L17_2 + L18_2
  L18_2 = A0_2.y
  L19_2 = L6_2.y
  L20_2 = A2_2 - L12_2
  L19_2 = L19_2 * L20_2
  L18_2 = L18_2 + L19_2
  L19_2 = A0_2.z
  L20_2 = L6_2.z
  L21_2 = A2_2 - L12_2
  L20_2 = L20_2 * L21_2
  L19_2 = L19_2 + L20_2
  if A3_2 then
    L20_2 = 0.014
    if L20_2 then
      goto lbl_104
    end
  end
  L20_2 = 0.009
  ::lbl_104::
  L20_2 = A2_2 * L20_2
  L21_2 = DrawLine
  L22_2 = A0_2.x
  L23_2 = A0_2.y
  L24_2 = A0_2.z
  L25_2 = L17_2
  L26_2 = L18_2
  L27_2 = L19_2
  L28_2 = L9_2
  L29_2 = L10_2
  L30_2 = L11_2
  L31_2 = L8_2
  L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2)
  L21_2 = L20_2 * 0.7
  L22_2 = L4_2.x
  L22_2 = L22_2 * L20_2
  L23_2 = L4_2.y
  L23_2 = L23_2 * L20_2
  L24_2 = L4_2.z
  L24_2 = L24_2 * L20_2
  L25_2 = L5_2.x
  L25_2 = L25_2 * L20_2
  L26_2 = L5_2.y
  L26_2 = L26_2 * L20_2
  L27_2 = L5_2.z
  L27_2 = L27_2 * L20_2
  L28_2 = L4_2.x
  L29_2 = L5_2.x
  L28_2 = L28_2 + L29_2
  L28_2 = L28_2 * L21_2
  L29_2 = L4_2.y
  L30_2 = L5_2.y
  L29_2 = L29_2 + L30_2
  L29_2 = L29_2 * L21_2
  L30_2 = L4_2.z
  L31_2 = L5_2.z
  L30_2 = L30_2 + L31_2
  L30_2 = L30_2 * L21_2
  L31_2 = L4_2.x
  L32_2 = L5_2.x
  L31_2 = L31_2 - L32_2
  L31_2 = L31_2 * L21_2
  L32_2 = L4_2.y
  L33_2 = L5_2.y
  L32_2 = L32_2 - L33_2
  L32_2 = L32_2 * L21_2
  L33_2 = L4_2.z
  L34_2 = L5_2.z
  L33_2 = L33_2 - L34_2
  L33_2 = L33_2 * L21_2
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 + L22_2
  L36_2 = A0_2.y
  L36_2 = L36_2 + L23_2
  L37_2 = A0_2.z
  L37_2 = L37_2 + L24_2
  L38_2 = L17_2 + L22_2
  L39_2 = L18_2 + L23_2
  L40_2 = L19_2 + L24_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 - L22_2
  L36_2 = A0_2.y
  L36_2 = L36_2 - L23_2
  L37_2 = A0_2.z
  L37_2 = L37_2 - L24_2
  L38_2 = L17_2 - L22_2
  L39_2 = L18_2 - L23_2
  L40_2 = L19_2 - L24_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 + L25_2
  L36_2 = A0_2.y
  L36_2 = L36_2 + L26_2
  L37_2 = A0_2.z
  L37_2 = L37_2 + L27_2
  L38_2 = L17_2 + L25_2
  L39_2 = L18_2 + L26_2
  L40_2 = L19_2 + L27_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 - L25_2
  L36_2 = A0_2.y
  L36_2 = L36_2 - L26_2
  L37_2 = A0_2.z
  L37_2 = L37_2 - L27_2
  L38_2 = L17_2 - L25_2
  L39_2 = L18_2 - L26_2
  L40_2 = L19_2 - L27_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 + L28_2
  L36_2 = A0_2.y
  L36_2 = L36_2 + L29_2
  L37_2 = A0_2.z
  L37_2 = L37_2 + L30_2
  L38_2 = L17_2 + L28_2
  L39_2 = L18_2 + L29_2
  L40_2 = L19_2 + L30_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 - L28_2
  L36_2 = A0_2.y
  L36_2 = L36_2 - L29_2
  L37_2 = A0_2.z
  L37_2 = L37_2 - L30_2
  L38_2 = L17_2 - L28_2
  L39_2 = L18_2 - L29_2
  L40_2 = L19_2 - L30_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 + L31_2
  L36_2 = A0_2.y
  L36_2 = L36_2 + L32_2
  L37_2 = A0_2.z
  L37_2 = L37_2 + L33_2
  L38_2 = L17_2 + L31_2
  L39_2 = L18_2 + L32_2
  L40_2 = L19_2 + L33_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = DrawLine
  L35_2 = A0_2.x
  L35_2 = L35_2 - L31_2
  L36_2 = A0_2.y
  L36_2 = L36_2 - L32_2
  L37_2 = A0_2.z
  L37_2 = L37_2 - L33_2
  L38_2 = L17_2 - L31_2
  L39_2 = L18_2 - L32_2
  L40_2 = L19_2 - L33_2
  L41_2 = L9_2
  L42_2 = L10_2
  L43_2 = L11_2
  L44_2 = L8_2
  L34_2(L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2)
  L34_2 = nil
  L35_2 = nil
  L36_2 = nil
  L37_2 = 0
  L38_2 = L21_1
  L39_2 = 1
  for L40_2 = L37_2, L38_2, L39_2 do
    L42_2 = L40_2 + 1
    L41_2 = L22_1
    L41_2 = L41_2[L42_2]
    L43_2 = L40_2 + 1
    L42_2 = L23_1
    L42_2 = L42_2[L43_2]
    L43_2 = L4_2.x
    L43_2 = L43_2 * L41_2
    L44_2 = L5_2.x
    L44_2 = L44_2 * L42_2
    L43_2 = L43_2 + L44_2
    L43_2 = L43_2 * L13_2
    L43_2 = L17_2 + L43_2
    L44_2 = L4_2.y
    L44_2 = L44_2 * L41_2
    L45_2 = L5_2.y
    L45_2 = L45_2 * L42_2
    L44_2 = L44_2 + L45_2
    L44_2 = L44_2 * L13_2
    L44_2 = L18_2 + L44_2
    L45_2 = L4_2.z
    L45_2 = L45_2 * L41_2
    L46_2 = L5_2.z
    L46_2 = L46_2 * L42_2
    L45_2 = L45_2 + L46_2
    L45_2 = L45_2 * L13_2
    L45_2 = L19_2 + L45_2
    if L34_2 then
      L46_2 = DrawPoly
      L47_2 = L14_2
      L48_2 = L15_2
      L49_2 = L16_2
      L50_2 = L34_2
      L51_2 = L35_2
      L52_2 = L36_2
      L53_2 = L43_2
      L54_2 = L44_2
      L55_2 = L45_2
      L56_2 = L9_2
      L57_2 = L10_2
      L58_2 = L11_2
      L59_2 = L8_2
      L46_2(L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2)
      L46_2 = DrawPoly
      L47_2 = L14_2
      L48_2 = L15_2
      L49_2 = L16_2
      L50_2 = L43_2
      L51_2 = L44_2
      L52_2 = L45_2
      L53_2 = L34_2
      L54_2 = L35_2
      L55_2 = L36_2
      L56_2 = L9_2
      L57_2 = L10_2
      L58_2 = L11_2
      L59_2 = L8_2
      L46_2(L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2)
      L46_2 = DrawPoly
      L47_2 = L17_2
      L48_2 = L18_2
      L49_2 = L19_2
      L50_2 = L34_2
      L51_2 = L35_2
      L52_2 = L36_2
      L53_2 = L43_2
      L54_2 = L44_2
      L55_2 = L45_2
      L56_2 = L9_2
      L57_2 = L10_2
      L58_2 = L11_2
      L59_2 = L8_2
      L46_2(L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2)
      L46_2 = DrawPoly
      L47_2 = L17_2
      L48_2 = L18_2
      L49_2 = L19_2
      L50_2 = L43_2
      L51_2 = L44_2
      L52_2 = L45_2
      L53_2 = L34_2
      L54_2 = L35_2
      L55_2 = L36_2
      L56_2 = L9_2
      L57_2 = L10_2
      L58_2 = L11_2
      L59_2 = L8_2
      L46_2(L47_2, L48_2, L49_2, L50_2, L51_2, L52_2, L53_2, L54_2, L55_2, L56_2, L57_2, L58_2, L59_2)
    end
    L46_2 = L43_2
    L47_2 = L44_2
    L36_2 = L45_2
    L35_2 = L47_2
    L34_2 = L46_2
  end
end
function L40_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A2_2 then
    L3_2 = World3dToScreen2d
    L4_2 = A0_2.x
    L5_2 = A0_2.y
    L6_2 = A0_2.z
    L7_2 = A1_2 * 1.25
    L6_2 = L6_2 + L7_2
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      L6_2 = math
      L6_2 = L6_2.abs
      L7_2 = L24_1
      L7_2 = L4_2 - L7_2
      L6_2 = L6_2(L7_2)
      L7_2 = 5.0E-4
      if not (L6_2 > L7_2) then
        L6_2 = math
        L6_2 = L6_2.abs
        L7_2 = L25_1
        L7_2 = L5_2 - L7_2
        L6_2 = L6_2(L7_2)
        L7_2 = 5.0E-4
        if not (L6_2 > L7_2) then
          goto lbl_46
        end
      end
      L6_2 = L4_2
      L25_1 = L5_2
      L24_1 = L6_2
      L6_2 = SendNUIMessage
      L7_2 = {}
      L7_2.action = "gizmoPos"
      L8_2 = {}
      L8_2.on = true
      L8_2.x = L4_2
      L8_2.y = L5_2
      L7_2.data = L8_2
      L6_2(L7_2)
      ::lbl_46::
      return
    end
  end
  L3_2 = L24_1
  if -2.0 ~= L3_2 then
    L3_2 = -2.0
    L4_2 = -2.0
    L25_1 = L4_2
    L24_1 = L3_2
    L3_2 = SendNUIMessage
    L4_2 = {}
    L4_2.action = "gizmoPos"
    L5_2 = {}
    L5_2.on = false
    L4_2.data = L5_2
    L3_2(L4_2)
  end
end
L41_1 = false
L42_1 = nil
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = A0_2.hotMove
  L3_2 = A1_2.hotMove
  if L2_2 == L3_2 then
    L2_2 = A0_2.hotRot
    L3_2 = A1_2.hotRot
    if L2_2 == L3_2 then
      goto lbl_17
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_17::
  function L2_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = math
    L2_3 = L2_3.abs
    L3_3 = A0_3 - A1_3
    L2_3 = L2_3(L3_3)
    L3_3 = 8.0E-4
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2 = L2_2
  L4_2 = A0_2.len
  L5_2 = A1_2.len
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L3_2 = L2_2
    L4_2 = A0_2.ringR
    L5_2 = A1_2.ringR
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = L2_2
      L4_2 = A0_2.obj
      L4_2 = L4_2.x
      L5_2 = A1_2.obj
      L5_2 = L5_2.x
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L3_2 = L2_2
        L4_2 = A0_2.obj
        L4_2 = L4_2.y
        L5_2 = A1_2.obj
        L5_2 = L5_2.y
        L3_2 = L3_2(L4_2, L5_2)
        if L3_2 then
          L3_2 = L2_2
          L4_2 = A0_2.obj
          L4_2 = L4_2.z
          L5_2 = A1_2.obj
          L5_2 = L5_2.z
          L3_2 = L3_2(L4_2, L5_2)
          if L3_2 then
            L3_2 = L2_2
            L4_2 = A0_2.cam
            L4_2 = L4_2.x
            L5_2 = A1_2.cam
            L5_2 = L5_2.x
            L3_2 = L3_2(L4_2, L5_2)
            if L3_2 then
              L3_2 = L2_2
              L4_2 = A0_2.cam
              L4_2 = L4_2.y
              L5_2 = A1_2.cam
              L5_2 = L5_2.y
              L3_2 = L3_2(L4_2, L5_2)
              if L3_2 then
                L3_2 = L2_2
                L4_2 = A0_2.cam
                L4_2 = L4_2.z
                L5_2 = A1_2.cam
                L5_2 = L5_2.z
                L3_2 = L3_2(L4_2, L5_2)
                if L3_2 then
                  L3_2 = L2_2
                  L4_2 = A0_2.cam
                  L4_2 = L4_2.fx
                  L5_2 = A1_2.cam
                  L5_2 = L5_2.fx
                  L3_2 = L3_2(L4_2, L5_2)
                  if L3_2 then
                    L3_2 = L2_2
                    L4_2 = A0_2.cam
                    L4_2 = L4_2.fy
                    L5_2 = A1_2.cam
                    L5_2 = L5_2.fy
                    L3_2 = L3_2(L4_2, L5_2)
                    if L3_2 then
                      L3_2 = L2_2
                      L4_2 = A0_2.cam
                      L4_2 = L4_2.fz
                      L5_2 = A1_2.cam
                      L5_2 = L5_2.fz
                      L3_2 = L3_2(L4_2, L5_2)
                      if L3_2 then
                        L3_2 = math
                        L3_2 = L3_2.abs
                        L4_2 = A0_2.cam
                        L4_2 = L4_2.fov
                        L5_2 = A1_2.cam
                        L5_2 = L5_2.fov
                        L4_2 = L4_2 - L5_2
                        L3_2 = L3_2(L4_2)
                        L4_2 = 0.02
                        L3_2 = L3_2 < L4_2
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
  return L3_2
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2
  if A0_2 then
    L1_2 = true
    L41_1 = L1_2
    L1_2 = L43_1
    L2_2 = A0_2
    L3_2 = L42_1
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      return
    end
    L42_1 = A0_2
    L1_2 = SendNUIMessage
    L2_2 = {}
    L2_2.action = "gizmoGeo"
    L2_2.data = A0_2
    L1_2(L2_2)
  else
    L1_2 = L41_1
    if L1_2 then
      L1_2 = false
      L41_1 = L1_2
      L1_2 = nil
      L42_1 = L1_2
      L1_2 = SendNUIMessage
      L2_2 = {}
      L2_2.action = "gizmoGeo"
      L3_2 = {}
      L3_2.on = false
      L2_2.data = L3_2
      L1_2(L2_2)
    end
  end
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = 0.0
  L2_2 = 0.0
  L3_2 = 0.0
  L4_2 = 0
  L5_2 = 1
  L6_2 = #A0_2
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = Objects
    L9_2 = L9_2.Get
    L10_2 = A0_2[L8_2]
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = L9_2.coords
      L10_2 = L10_2.x
      L1_2 = L1_2 + L10_2
      L10_2 = L9_2.coords
      L10_2 = L10_2.y
      L2_2 = L2_2 + L10_2
      L10_2 = L9_2.coords
      L10_2 = L10_2.z
      L3_2 = L3_2 + L10_2
      L4_2 = L4_2 + 1
    end
  end
  if 0 == L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = vector3
  L6_2 = L1_2 / L4_2
  L7_2 = L2_2 / L4_2
  L8_2 = L3_2 / L4_2
  return L5_2(L6_2, L7_2, L8_2)
end
function L46_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L6_2 = math
  L6_2 = L6_2.cos
  L7_2 = A4_2
  L6_2 = L6_2(L7_2)
  L7_2 = math
  L7_2 = L7_2.sin
  L8_2 = A4_2
  L7_2 = L7_2(L8_2)
  if "z" == A3_2 then
    L8_2 = A0_2.x
    L9_2 = A2_2.x
    L8_2 = L8_2 - L9_2
    L9_2 = A0_2.y
    L10_2 = A2_2.y
    L9_2 = L9_2 - L10_2
    L10_2 = vector3
    L11_2 = A2_2.x
    L12_2 = L8_2 * L6_2
    L11_2 = L11_2 + L12_2
    L12_2 = L9_2 * L7_2
    L11_2 = L11_2 - L12_2
    L12_2 = A2_2.y
    L13_2 = L8_2 * L7_2
    L12_2 = L12_2 + L13_2
    L13_2 = L9_2 * L6_2
    L12_2 = L12_2 + L13_2
    L13_2 = A0_2.z
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = vector3
    L12_2 = A1_2.x
    L13_2 = A1_2.y
    L14_2 = A1_2.z
    L14_2 = L14_2 + A5_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
    return L10_2, L11_2, L12_2, L13_2, L14_2
  elseif "x" == A3_2 then
    L8_2 = A0_2.y
    L9_2 = A2_2.y
    L8_2 = L8_2 - L9_2
    L9_2 = A0_2.z
    L10_2 = A2_2.z
    L9_2 = L9_2 - L10_2
    L10_2 = vector3
    L11_2 = A0_2.x
    L12_2 = A2_2.y
    L13_2 = L8_2 * L6_2
    L12_2 = L12_2 + L13_2
    L13_2 = L9_2 * L7_2
    L12_2 = L12_2 - L13_2
    L13_2 = A2_2.z
    L14_2 = L8_2 * L7_2
    L13_2 = L13_2 + L14_2
    L14_2 = L9_2 * L6_2
    L13_2 = L13_2 + L14_2
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = vector3
    L12_2 = A1_2.x
    L12_2 = L12_2 + A5_2
    L13_2 = A1_2.y
    L14_2 = A1_2.z
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
    return L10_2, L11_2, L12_2, L13_2, L14_2
  else
    L8_2 = A0_2.x
    L9_2 = A2_2.x
    L8_2 = L8_2 - L9_2
    L9_2 = A0_2.z
    L10_2 = A2_2.z
    L9_2 = L9_2 - L10_2
    L10_2 = vector3
    L11_2 = A2_2.x
    L12_2 = L8_2 * L6_2
    L11_2 = L11_2 + L12_2
    L12_2 = L9_2 * L7_2
    L11_2 = L11_2 + L12_2
    L12_2 = A0_2.y
    L13_2 = A2_2.z
    L14_2 = L8_2 * L7_2
    L13_2 = L13_2 - L14_2
    L14_2 = L9_2 * L6_2
    L13_2 = L13_2 + L14_2
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = vector3
    L12_2 = A1_2.x
    L13_2 = A1_2.y
    L13_2 = L13_2 + A5_2
    L14_2 = A1_2.z
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
    return L10_2, L11_2, L12_2, L13_2, L14_2
  end
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L11_1
  if A0_2 ~= L1_2 then
    L11_1 = A0_2
    L1_2 = SendNUIMessage
    L2_2 = {}
    L2_2.action = "marqueeBlock"
    L3_2 = {}
    L3_2.on = A0_2
    L2_2.data = L3_2
    L1_2(L2_2)
  end
end
function L48_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = Gizmo
  L0_2 = L0_2.IsActive
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = Gizmo
    L0_2 = L0_2.IsGrabbing
    L0_2 = L0_2()
    if not L0_2 then
      L0_2 = Gizmo
      L0_2 = L0_2.Target
      L0_2 = L0_2()
      L1_2 = L0_2 or L1_2
      if L0_2 then
        L1_2 = Objects
        L1_2 = L1_2.Get
        L2_2 = L0_2
        L1_2 = L1_2(L2_2)
      end
      if L1_2 then
        L2_2 = "single"
        L3_2 = L1_2.coords
        L4_2 = L0_2
        L5_2 = L1_2
        return L2_2, L3_2, L4_2, L5_2
      end
    end
  end
  L0_2 = Bulk
  if L0_2 then
    L0_2 = Bulk
    L0_2 = L0_2.IsActive
    L0_2 = L0_2()
    if L0_2 then
      L0_2 = Bulk
      L0_2 = L0_2.IsGrabbing
      L0_2 = L0_2()
      if not L0_2 then
        L0_2 = Bulk
        L0_2 = L0_2.SelectedIds
        L0_2 = L0_2()
        L1_2 = #L0_2
        if L1_2 >= 2 then
          L1_2 = L45_1
          L2_2 = L0_2
          L1_2 = L1_2(L2_2)
          if L1_2 then
            L2_2 = "group"
            L3_2 = L1_2
            return L2_2, L3_2
          end
        end
      end
    end
  end
  L0_2 = nil
  return L0_2
end
L49_1 = {}
L49_1.handle = nil
L49_1.rad = 0
L50_1 = CreateThread
function L51_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2
  while true do
    L0_2 = L48_1
    L0_2, L1_2, L2_2, L3_2 = L0_2()
    if L0_2 then
      L4_2 = GetActualScreenResolution
      L4_2, L5_2 = L4_2()
      if not L4_2 or 0 == L4_2 then
        L6_2 = GetActiveScreenResolution
        L6_2, L7_2 = L6_2()
        L5_2 = L7_2
        L4_2 = L6_2
      end
      if not L4_2 or 0 == L4_2 then
        L6_2 = 1920
        L5_2 = 1080
        L4_2 = L6_2
      end
      L6_2 = L32_1
      L7_2 = Camera
      L7_2 = L7_2.GetCoords
      L7_2 = L7_2()
      L7_2 = L7_2 - L1_2
      L7_2 = #L7_2
      L7_2 = L7_2 * 0.11
      L8_2 = 0.6
      L9_2 = 5.0
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L3_2 then
        L7_2 = L3_2.handle
        if L7_2 then
          L7_2 = DoesEntityExist
          L8_2 = L3_2.handle
          L7_2 = L7_2(L8_2)
          if L7_2 then
            L7_2 = L49_1.handle
            L8_2 = L3_2.handle
            if L7_2 ~= L8_2 then
              L7_2 = L3_2.handle
              L49_1.handle = L7_2
              L49_1.rad = 0
              L7_2 = GetEntityModel
              L8_2 = L3_2.handle
              L7_2 = L7_2(L8_2)
              if 0 ~= L7_2 then
                L8_2 = IsModelValid
                L9_2 = L7_2
                L8_2 = L8_2(L9_2)
                if L8_2 then
                  L8_2 = pcall
                  L9_2 = GetModelDimensions
                  L10_2 = L7_2
                  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
                  if L8_2 and L9_2 and L10_2 then
                    L11_2 = L10_2 - L9_2
                    L11_2 = #L11_2
                    L11_2 = L11_2 * 0.5
                    L11_2 = L11_2 + 0.7
                    L49_1.rad = L11_2
                  end
                end
              end
            end
            L7_2 = L49_1.rad
            if L6_2 < L7_2 then
              L7_2 = math
              L7_2 = L7_2.min
              L8_2 = L49_1.rad
              L9_2 = 6.0
              L7_2 = L7_2(L8_2, L9_2)
              L6_2 = L7_2
            end
          end
        end
      end
      L7_2 = L6_2 * 1.2
      L8_2 = GetNuiCursorPosition
      L8_2, L9_2 = L8_2()
      L10_2 = L8_2 or L10_2
      L10_2 = L8_2 and L8_2 >= 0
      L11_2 = GetGameTimer
      L11_2 = L11_2()
      L12_2 = L1_1
      if not L12_2 and L10_2 then
        L12_2 = L33_1
        L12_2 = L12_2()
        if not L12_2 then
          L12_2 = L15_1
          L12_2 = L11_2 - L12_2
          if L12_2 > 30 then
            L15_1 = L11_2
            L12_2 = nil
            L13_2 = 1.0E9
            L14_2 = World3dToScreen2d
            L15_2 = L1_2.x
            L16_2 = L1_2.y
            L17_2 = L1_2.z
            L14_2, L15_2, L16_2 = L14_2(L15_2, L16_2, L17_2)
            L17_2 = nil
            L18_2 = nil
            if L14_2 then
              L19_2 = L15_2 * L4_2
              L18_2 = L16_2 * L5_2
              L17_2 = L19_2
            end
            L19_2 = ipairs
            L20_2 = L29_1
            L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
            for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
              if L14_2 then
                L25_2 = L24_2.v
                L25_2 = L25_2 * L6_2
                L25_2 = L1_2 + L25_2
                L26_2 = World3dToScreen2d
                L27_2 = L25_2.x
                L28_2 = L25_2.y
                L29_2 = L25_2.z
                L26_2, L27_2, L28_2 = L26_2(L27_2, L28_2, L29_2)
                if L26_2 then
                  L29_2 = L27_2 * L4_2
                  L30_2 = L28_2 * L5_2
                  L31_2 = L17_1
                  L32_2 = L8_2
                  L33_2 = L9_2
                  L34_2 = L17_2
                  L35_2 = L18_2
                  L36_2 = L29_2
                  L37_2 = L30_2
                  L31_2 = L31_2(L32_2, L33_2, L34_2, L35_2, L36_2, L37_2)
                  if L31_2 < 100.0 and L13_2 > L31_2 then
                    L32_2 = L31_2
                    L33_2 = "m"
                    L34_2 = L24_2.k
                    L33_2 = L33_2 .. L34_2
                    L12_2 = L33_2
                    L13_2 = L32_2
                  end
                end
              end
              L25_2 = nil
              L26_2 = nil
              L27_2 = 0
              L28_2 = L18_1
              L29_2 = 1
              for L30_2 = L27_2, L28_2, L29_2 do
                L31_2 = L38_1
                L32_2 = L1_2
                L33_2 = L24_2
                L34_2 = L7_2
                L35_2 = L30_2
                L31_2 = L31_2(L32_2, L33_2, L34_2, L35_2)
                L32_2 = World3dToScreen2d
                L33_2 = L31_2.x
                L34_2 = L31_2.y
                L35_2 = L31_2.z
                L32_2, L33_2, L34_2 = L32_2(L33_2, L34_2, L35_2)
                if L32_2 then
                  L35_2 = L33_2 * L4_2
                  L36_2 = L34_2 * L5_2
                  if L25_2 then
                    L37_2 = L17_1
                    L38_2 = L8_2
                    L39_2 = L9_2
                    L40_2 = L25_2
                    L41_2 = L26_2
                    L42_2 = L35_2
                    L43_2 = L36_2
                    L37_2 = L37_2(L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                    if L13_2 > L37_2 then
                      L38_2 = L37_2
                      L39_2 = "r"
                      L40_2 = L24_2.k
                      L39_2 = L39_2 .. L40_2
                      L12_2 = L39_2
                      L13_2 = L38_2
                    end
                  end
                  L37_2 = L35_2
                  L26_2 = L36_2
                  L25_2 = L37_2
                else
                  L35_2 = nil
                  L26_2 = nil
                  L25_2 = L35_2
                end
              end
            end
            L19_2 = 144.0
            L19_2 = L12_2 or L19_2
            if not (L13_2 < L19_2) or not L12_2 then
              L19_2 = nil
            end
            L0_1 = L19_2
            L19_2 = L0_1
            if L19_2 and L17_2 then
              L19_2 = L17_2 - L8_2
              L20_2 = L18_2 - L9_2
              L21_2 = L19_2 * L19_2
              L22_2 = L20_2 * L20_2
              L21_2 = L21_2 + L22_2
              L22_2 = 1024.0
              if L21_2 < L22_2 then
                L21_2 = nil
                L0_1 = L21_2
              end
            end
          end
      end
      else
        L12_2 = L1_1
        if not L12_2 then
          L12_2 = nil
          L0_1 = L12_2
        end
      end
      L12_2 = Camera
      L12_2 = L12_2.GetCoords
      L12_2 = L12_2()
      L13_2 = Camera
      L13_2 = L13_2.GetForward
      L13_2 = L13_2()
      L14_2 = nil
      L15_2 = nil
      L16_2 = L1_1
      if L16_2 then
        L16_2 = L2_1
        if "m" == L16_2 then
          L14_2 = L3_1
        else
          L16_2 = L2_1
          if "r" == L16_2 then
            L15_2 = L3_1
          end
        end
      else
        L16_2 = L0_1
        if L16_2 then
          L16_2 = L0_1
          L17_2 = L16_2
          L16_2 = L16_2.sub
          L18_2 = 1
          L19_2 = 1
          L16_2 = L16_2(L17_2, L18_2, L19_2)
          if "m" == L16_2 then
            L16_2 = L0_1
            L17_2 = L16_2
            L16_2 = L16_2.sub
            L18_2 = 2
            L19_2 = 2
            L16_2 = L16_2(L17_2, L18_2, L19_2)
            L14_2 = L16_2
          else
            L16_2 = L0_1
            L17_2 = L16_2
            L16_2 = L16_2.sub
            L18_2 = 1
            L19_2 = 1
            L16_2 = L16_2(L17_2, L18_2, L19_2)
            if "r" == L16_2 then
              L16_2 = L0_1
              L17_2 = L16_2
              L16_2 = L16_2.sub
              L18_2 = 2
              L19_2 = 2
              L16_2 = L16_2(L17_2, L18_2, L19_2)
              L15_2 = L16_2
            end
          end
        end
      end
      L16_2 = L44_1
      L17_2 = {}
      L17_2.on = true
      L18_2 = {}
      L19_2 = L12_2.x
      L18_2.x = L19_2
      L19_2 = L12_2.y
      L18_2.y = L19_2
      L19_2 = L12_2.z
      L18_2.z = L19_2
      L19_2 = L13_2.x
      L18_2.fx = L19_2
      L19_2 = L13_2.y
      L18_2.fy = L19_2
      L19_2 = L13_2.z
      L18_2.fz = L19_2
      L19_2 = Camera
      L19_2 = L19_2.GetFov
      L19_2 = L19_2()
      L18_2.fov = L19_2
      L17_2.cam = L18_2
      L18_2 = {}
      L19_2 = L1_2.x
      L18_2.x = L19_2
      L19_2 = L1_2.y
      L18_2.y = L19_2
      L19_2 = L1_2.z
      L18_2.z = L19_2
      L17_2.obj = L18_2
      L17_2.len = L6_2
      L17_2.ringR = L7_2
      L17_2.hotMove = L14_2
      L17_2.hotRot = L15_2
      L16_2(L17_2)
      if "single" == L0_2 then
        L16_2 = L40_1
        L17_2 = L1_2
        L18_2 = L6_2
        L19_2 = true
        L16_2(L17_2, L18_2, L19_2)
        L16_2 = L47_1
        L17_2 = false
        L16_2(L17_2)
      else
        L16_2 = L47_1
        L17_2 = L0_1
        L17_2 = nil ~= L17_2 or L17_2
        L16_2(L17_2)
      end
      L16_2 = L0_1
      if L16_2 then
        L16_2 = L1_1
        if not L16_2 then
          L16_2 = L33_1
          L16_2 = L16_2()
          if not L16_2 then
            L16_2 = IsDisabledControlJustPressed
            L17_2 = 0
            L18_2 = 24
            L16_2 = L16_2(L17_2, L18_2)
            if L16_2 then
              L16_2 = GetGameTimer
              L16_2 = L16_2()
              L17_2 = L16_1
              L16_2 = L16_2 - L17_2
              if L16_2 > 80 then
                L16_2 = true
                L1_1 = L16_2
                L16_2 = L0_1
                L17_2 = L16_2
                L16_2 = L16_2.sub
                L18_2 = 1
                L19_2 = 1
                L16_2 = L16_2(L17_2, L18_2, L19_2)
                L2_1 = L16_2
                L16_2 = L0_1
                L17_2 = L16_2
                L16_2 = L16_2.sub
                L18_2 = 2
                L19_2 = 2
                L16_2 = L16_2(L17_2, L18_2, L19_2)
                L3_1 = L16_2
                L4_1 = L1_2
                if "single" == L0_2 then
                  L8_1 = L2_2
                  L16_2 = {}
                  L17_2 = {}
                  L18_2 = L3_2.coords
                  L18_2 = L18_2.x
                  L17_2.x = L18_2
                  L18_2 = L3_2.coords
                  L18_2 = L18_2.y
                  L17_2.y = L18_2
                  L18_2 = L3_2.coords
                  L18_2 = L18_2.z
                  L17_2.z = L18_2
                  L16_2.coords = L17_2
                  L17_2 = {}
                  L18_2 = L3_2.rot
                  L18_2 = L18_2.x
                  L17_2.x = L18_2
                  L18_2 = L3_2.rot
                  L18_2 = L18_2.y
                  L17_2.y = L18_2
                  L18_2 = L3_2.rot
                  L18_2 = L18_2.z
                  L17_2.z = L18_2
                  L16_2.rot = L17_2
                  L7_1 = L16_2
                else
                  L16_2 = Bulk
                  L16_2 = L16_2.SelectedIds
                  L16_2 = L16_2()
                  L9_1 = L16_2
                  L16_2 = {}
                  L10_1 = L16_2
                  L16_2 = 1
                  L17_2 = L9_1
                  L17_2 = #L17_2
                  L18_2 = 1
                  for L19_2 = L16_2, L17_2, L18_2 do
                    L20_2 = L9_1
                    L20_2 = L20_2[L19_2]
                    L21_2 = Objects
                    L21_2 = L21_2.Get
                    L22_2 = L20_2
                    L21_2 = L21_2(L22_2)
                    if L21_2 then
                      L22_2 = L10_1
                      L23_2 = {}
                      L24_2 = {}
                      L25_2 = L21_2.coords
                      L25_2 = L25_2.x
                      L24_2.x = L25_2
                      L25_2 = L21_2.coords
                      L25_2 = L25_2.y
                      L24_2.y = L25_2
                      L25_2 = L21_2.coords
                      L25_2 = L25_2.z
                      L24_2.z = L25_2
                      L23_2.coords = L24_2
                      L24_2 = {}
                      L25_2 = L21_2.rot
                      L25_2 = L25_2.x
                      L24_2.x = L25_2
                      L25_2 = L21_2.rot
                      L25_2 = L25_2.y
                      L24_2.y = L25_2
                      L25_2 = L21_2.rot
                      L25_2 = L25_2.z
                      L24_2.z = L25_2
                      L23_2.rot = L24_2
                      L22_2[L20_2] = L23_2
                    end
                  end
                end
                L16_2 = L2_1
                if "m" == L16_2 then
                  L16_2 = L36_1
                  L17_2 = L1_2
                  L18_2 = L34_1
                  L19_2 = L3_1
                  L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L18_2(L19_2)
                  L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                  L5_1 = L16_2
                else
                  if "single" == L0_2 then
                    L16_2 = vector3
                    L17_2 = L3_2.rot
                    L17_2 = L17_2.x
                    L18_2 = L3_2.rot
                    L18_2 = L18_2.y
                    L19_2 = L3_2.rot
                    L19_2 = L19_2.z
                    L16_2 = L16_2(L17_2, L18_2, L19_2)
                    if L16_2 then
                      goto lbl_503
                    end
                  end
                  L16_2 = nil
                  ::lbl_503::
                  L6_1 = L16_2
                  L16_2 = L37_1
                  L17_2 = L1_2
                  L18_2 = L3_1
                  L16_2 = L16_2(L17_2, L18_2)
                  if not L16_2 then
                    L16_2 = 0.0
                  end
                  L12_1 = L16_2
                  L16_2 = 0.0
                  L13_1 = L16_2
                end
              end
            end
          end
        end
      end
      L16_2 = L1_1
      if L16_2 then
        L16_2 = IsDisabledControlPressed
        L17_2 = 0
        L18_2 = 24
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          L16_2 = L2_1
          if "m" == L16_2 then
            L16_2 = L34_1
            L17_2 = L3_1
            L16_2 = L16_2(L17_2)
            L17_2 = L36_1
            L18_2 = L4_1
            L19_2 = L16_2
            L17_2 = L17_2(L18_2, L19_2)
            if L17_2 then
              L18_2 = L5_1
              if not L18_2 then
                L5_1 = L17_2
              end
              if "single" == L0_2 then
                L18_2 = L4_1
                L19_2 = L5_1
                L19_2 = L17_2 - L19_2
                L19_2 = L16_2 * L19_2
                L18_2 = L18_2 + L19_2
                L19_2 = Config
                L19_2 = L19_2.snap
                L19_2 = L19_2.grid
                if L19_2 then
                  L19_2 = Config
                  L19_2 = L19_2.snap
                  L19_2 = L19_2.gridSize
                  L20_2 = L3_1
                  if "x" == L20_2 then
                    L20_2 = vector3
                    L21_2 = math
                    L21_2 = L21_2.floor
                    L22_2 = L18_2.x
                    L22_2 = L22_2 / L19_2
                    L22_2 = L22_2 + 0.5
                    L21_2 = L21_2(L22_2)
                    L21_2 = L21_2 * L19_2
                    L22_2 = L18_2.y
                    L23_2 = L18_2.z
                    L20_2 = L20_2(L21_2, L22_2, L23_2)
                    L18_2 = L20_2
                  else
                    L20_2 = L3_1
                    if "y" == L20_2 then
                      L20_2 = vector3
                      L21_2 = L18_2.x
                      L22_2 = math
                      L22_2 = L22_2.floor
                      L23_2 = L18_2.y
                      L23_2 = L23_2 / L19_2
                      L23_2 = L23_2 + 0.5
                      L22_2 = L22_2(L23_2)
                      L22_2 = L22_2 * L19_2
                      L23_2 = L18_2.z
                      L20_2 = L20_2(L21_2, L22_2, L23_2)
                      L18_2 = L20_2
                    else
                      L20_2 = vector3
                      L21_2 = L18_2.x
                      L22_2 = L18_2.y
                      L23_2 = math
                      L23_2 = L23_2.floor
                      L24_2 = L18_2.z
                      L24_2 = L24_2 / L19_2
                      L24_2 = L24_2 + 0.5
                      L23_2 = L23_2(L24_2)
                      L23_2 = L23_2 * L19_2
                      L20_2 = L20_2(L21_2, L22_2, L23_2)
                      L18_2 = L20_2
                    end
                  end
                end
                L19_2 = Objects
                L19_2 = L19_2.Update
                L20_2 = L2_2
                L21_2 = L18_2
                L22_2 = L3_2.rot
                L19_2(L20_2, L21_2, L22_2)
              else
                L18_2 = L5_1
                L18_2 = L17_2 - L18_2
                L19_2 = Config
                L19_2 = L19_2.snap
                L19_2 = L19_2.grid
                if L19_2 then
                  L19_2 = Config
                  L19_2 = L19_2.snap
                  L19_2 = L19_2.gridSize
                  L20_2 = math
                  L20_2 = L20_2.floor
                  L21_2 = L18_2 / L19_2
                  L21_2 = L21_2 + 0.5
                  L20_2 = L20_2(L21_2)
                  L18_2 = L20_2 * L19_2
                end
                L19_2 = 1
                L20_2 = L9_1
                L20_2 = #L20_2
                L21_2 = 1
                for L22_2 = L19_2, L20_2, L21_2 do
                  L23_2 = L9_1
                  L23_2 = L23_2[L22_2]
                  L24_2 = L10_1
                  L24_2 = L24_2[L23_2]
                  if L24_2 then
                    L25_2 = Objects
                    L25_2 = L25_2.Get
                    L26_2 = L23_2
                    L25_2 = L25_2(L26_2)
                    if L25_2 then
                      L25_2 = Objects
                      L25_2 = L25_2.Update
                      L26_2 = L23_2
                      L27_2 = vector3
                      L28_2 = L24_2.coords
                      L28_2 = L28_2.x
                      L29_2 = L16_2.x
                      L29_2 = L29_2 * L18_2
                      L28_2 = L28_2 + L29_2
                      L29_2 = L24_2.coords
                      L29_2 = L29_2.y
                      L30_2 = L16_2.y
                      L30_2 = L30_2 * L18_2
                      L29_2 = L29_2 + L30_2
                      L30_2 = L24_2.coords
                      L30_2 = L30_2.z
                      L31_2 = L16_2.z
                      L31_2 = L31_2 * L18_2
                      L30_2 = L30_2 + L31_2
                      L27_2 = L27_2(L28_2, L29_2, L30_2)
                      L28_2 = vector3
                      L29_2 = L24_2.rot
                      L29_2 = L29_2.x
                      L30_2 = L24_2.rot
                      L30_2 = L30_2.y
                      L31_2 = L24_2.rot
                      L31_2 = L31_2.z
                      L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L28_2(L29_2, L30_2, L31_2)
                      L25_2(L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                    end
                  end
                end
              end
            end
          else
            L16_2 = L37_1
            L17_2 = L4_1
            L18_2 = L3_1
            L16_2 = L16_2(L17_2, L18_2)
            if L16_2 then
              L17_2 = L13_1
              L18_2 = L35_1
              L19_2 = L12_1
              L19_2 = L16_2 - L19_2
              L18_2 = L18_2(L19_2)
              L17_2 = L17_2 + L18_2
              L13_1 = L17_2
              L12_1 = L16_2
              L17_2 = math
              L17_2 = L17_2.deg
              L18_2 = L13_1
              L17_2 = L17_2(L18_2)
              L18_2 = Config
              L18_2 = L18_2.snap
              L18_2 = L18_2.angle
              if L18_2 then
                L18_2 = Config
                L18_2 = L18_2.snap
                L18_2 = L18_2.angleStep
                L19_2 = math
                L19_2 = L19_2.floor
                L20_2 = L17_2 / L18_2
                L20_2 = L20_2 + 0.5
                L19_2 = L19_2(L20_2)
                L17_2 = L19_2 * L18_2
              end
              if "single" == L0_2 then
                L18_2 = vector3
                L19_2 = L6_1.x
                L20_2 = L6_1.y
                L21_2 = L6_1.z
                L18_2 = L18_2(L19_2, L20_2, L21_2)
                L19_2 = L3_1
                if "x" == L19_2 then
                  L19_2 = vector3
                  L20_2 = L6_1.x
                  L20_2 = L20_2 + L17_2
                  L21_2 = L6_1.y
                  L22_2 = L6_1.z
                  L19_2 = L19_2(L20_2, L21_2, L22_2)
                  L18_2 = L19_2
                else
                  L19_2 = L3_1
                  if "y" == L19_2 then
                    L19_2 = vector3
                    L20_2 = L6_1.x
                    L21_2 = L6_1.y
                    L21_2 = L21_2 + L17_2
                    L22_2 = L6_1.z
                    L19_2 = L19_2(L20_2, L21_2, L22_2)
                    L18_2 = L19_2
                  else
                    L19_2 = vector3
                    L20_2 = L6_1.x
                    L21_2 = L6_1.y
                    L22_2 = L6_1.z
                    L22_2 = L22_2 + L17_2
                    L19_2 = L19_2(L20_2, L21_2, L22_2)
                    L18_2 = L19_2
                  end
                end
                L19_2 = Objects
                L19_2 = L19_2.Update
                L20_2 = L2_2
                L21_2 = L3_2.coords
                L22_2 = L18_2
                L19_2(L20_2, L21_2, L22_2)
              else
                L18_2 = math
                L18_2 = L18_2.rad
                L19_2 = L17_2
                L18_2 = L18_2(L19_2)
                L19_2 = 1
                L20_2 = L9_1
                L20_2 = #L20_2
                L21_2 = 1
                for L22_2 = L19_2, L20_2, L21_2 do
                  L23_2 = L9_1
                  L23_2 = L23_2[L22_2]
                  L24_2 = L10_1
                  L24_2 = L24_2[L23_2]
                  if L24_2 then
                    L25_2 = Objects
                    L25_2 = L25_2.Get
                    L26_2 = L23_2
                    L25_2 = L25_2(L26_2)
                    if L25_2 then
                      L25_2 = L46_1
                      L26_2 = L24_2.coords
                      L27_2 = L24_2.rot
                      L28_2 = L4_1
                      L29_2 = L3_1
                      L30_2 = L18_2
                      L31_2 = L17_2
                      L25_2, L26_2 = L25_2(L26_2, L27_2, L28_2, L29_2, L30_2, L31_2)
                      L27_2 = Objects
                      L27_2 = L27_2.Update
                      L28_2 = L23_2
                      L29_2 = L25_2
                      L30_2 = L26_2
                      L27_2(L28_2, L29_2, L30_2)
                    end
                  end
                end
              end
            end
          end
          if "single" == L0_2 then
            L16_2 = GetGameTimer
            L16_2 = L16_2()
            L17_2 = L14_1
            L17_2 = L16_2 - L17_2
            L18_2 = 250
            if L17_2 > L18_2 then
              L14_1 = L16_2
              L17_2 = SendNUIMessage
              L18_2 = {}
              L18_2.action = "selected"
              L19_2 = Gizmo
              L19_2 = L19_2.Info
              L19_2 = L19_2()
              L18_2.data = L19_2
              L17_2(L18_2)
            end
          end
        else
          L16_2 = L2_1
          L16_2 = "r" == L16_2
          L17_2 = false
          L18_2 = nil
          L19_2 = nil
          L20_2 = nil
          L8_1 = L20_2
          L3_1 = L19_2
          L2_1 = L18_2
          L1_1 = L17_2
          if "single" == L0_2 then
            L17_2 = MEAutoSave
            if L17_2 then
              L17_2 = MEAutoSave
              L18_2 = L2_2
              L17_2(L18_2)
            end
            L17_2 = History
            if L17_2 then
              L17_2 = L7_1
              if L17_2 then
                L17_2 = History
                L17_2 = L17_2.Push
                L18_2 = Cmd
                L18_2 = L18_2.Transform
                L19_2 = Objects
                L19_2 = L19_2.UidOf
                L20_2 = L2_2
                L19_2 = L19_2(L20_2)
                L20_2 = L7_1
                L21_2 = {}
                L22_2 = {}
                L23_2 = L3_2.coords
                L23_2 = L23_2.x
                L22_2.x = L23_2
                L23_2 = L3_2.coords
                L23_2 = L23_2.y
                L22_2.y = L23_2
                L23_2 = L3_2.coords
                L23_2 = L23_2.z
                L22_2.z = L23_2
                L21_2.coords = L22_2
                L22_2 = {}
                L23_2 = L3_2.rot
                L23_2 = L23_2.x
                L22_2.x = L23_2
                L23_2 = L3_2.rot
                L23_2 = L23_2.y
                L22_2.y = L23_2
                L23_2 = L3_2.rot
                L23_2 = L23_2.z
                L22_2.z = L23_2
                L21_2.rot = L22_2
                L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L18_2(L19_2, L20_2, L21_2)
                L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                L17_2 = nil
                L7_1 = L17_2
              end
            end
            L17_2 = SendNUIMessage
            L18_2 = {}
            L18_2.action = "selected"
            L19_2 = Gizmo
            L19_2 = L19_2.Info
            L19_2 = L19_2()
            L18_2.data = L19_2
            L17_2(L18_2)
          else
            L17_2 = L9_1
            if L17_2 then
              L17_2 = {}
              L18_2 = 1
              L19_2 = L9_1
              L19_2 = #L19_2
              L20_2 = 1
              for L21_2 = L18_2, L19_2, L20_2 do
                L22_2 = L9_1
                L22_2 = L22_2[L21_2]
                L23_2 = L10_1
                L23_2 = L23_2[L22_2]
                L24_2 = Objects
                L24_2 = L24_2.Get
                L25_2 = L22_2
                L24_2 = L24_2(L25_2)
                if L23_2 and L24_2 then
                  L25_2 = #L17_2
                  L25_2 = L25_2 + 1
                  L26_2 = Cmd
                  L26_2 = L26_2.Transform
                  L27_2 = Objects
                  L27_2 = L27_2.UidOf
                  L28_2 = L22_2
                  L27_2 = L27_2(L28_2)
                  L28_2 = L23_2
                  L29_2 = {}
                  L30_2 = {}
                  L31_2 = L24_2.coords
                  L31_2 = L31_2.x
                  L30_2.x = L31_2
                  L31_2 = L24_2.coords
                  L31_2 = L31_2.y
                  L30_2.y = L31_2
                  L31_2 = L24_2.coords
                  L31_2 = L31_2.z
                  L30_2.z = L31_2
                  L29_2.coords = L30_2
                  L30_2 = {}
                  L31_2 = L24_2.rot
                  L31_2 = L31_2.x
                  L30_2.x = L31_2
                  L31_2 = L24_2.rot
                  L31_2 = L31_2.y
                  L30_2.y = L31_2
                  L31_2 = L24_2.rot
                  L31_2 = L31_2.z
                  L30_2.z = L31_2
                  L29_2.rot = L30_2
                  L26_2 = L26_2(L27_2, L28_2, L29_2)
                  L17_2[L25_2] = L26_2
                  L25_2 = MEAutoSave
                  if L25_2 then
                    L25_2 = MEAutoSave
                    L26_2 = L22_2
                    L25_2(L26_2)
                  end
                end
              end
              L18_2 = History
              if L18_2 then
                L18_2 = #L17_2
                if L18_2 > 0 then
                  L18_2 = History
                  L18_2 = L18_2.Push
                  L19_2 = Cmd
                  L19_2 = L19_2.Batch
                  if L16_2 then
                    L20_2 = locale
                    L21_2 = "hist.rotate_selection"
                    L20_2 = L20_2(L21_2)
                    if L20_2 then
                      goto lbl_992
                    end
                  end
                  L20_2 = locale
                  L21_2 = "hist.move_selection"
                  L20_2 = L20_2(L21_2)
                  ::lbl_992::
                  L21_2 = L17_2
                  L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L19_2(L20_2, L21_2)
                  L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                end
              end
              L18_2 = nil
              L19_2 = nil
              L10_1 = L19_2
              L9_1 = L18_2
            end
          end
        end
      end
      L16_2 = Wait
      L17_2 = 0
      L16_2(L17_2)
    else
      L4_2 = L1_1
      if L4_2 then
        L4_2 = L9_1
        if L4_2 then
          L4_2 = {}
          L5_2 = 1
          L6_2 = L9_1
          L6_2 = #L6_2
          L7_2 = 1
          for L8_2 = L5_2, L6_2, L7_2 do
            L9_2 = L9_1
            L9_2 = L9_2[L8_2]
            L10_2 = L10_1
            L10_2 = L10_2[L9_2]
            L11_2 = Objects
            L11_2 = L11_2.Get
            L12_2 = L9_2
            L11_2 = L11_2(L12_2)
            if L10_2 and L11_2 then
              L12_2 = #L4_2
              L12_2 = L12_2 + 1
              L13_2 = Cmd
              L13_2 = L13_2.Transform
              L14_2 = Objects
              L14_2 = L14_2.UidOf
              L15_2 = L9_2
              L14_2 = L14_2(L15_2)
              L15_2 = L10_2
              L16_2 = {}
              L17_2 = {}
              L18_2 = L11_2.coords
              L18_2 = L18_2.x
              L17_2.x = L18_2
              L18_2 = L11_2.coords
              L18_2 = L18_2.y
              L17_2.y = L18_2
              L18_2 = L11_2.coords
              L18_2 = L18_2.z
              L17_2.z = L18_2
              L16_2.coords = L17_2
              L17_2 = {}
              L18_2 = L11_2.rot
              L18_2 = L18_2.x
              L17_2.x = L18_2
              L18_2 = L11_2.rot
              L18_2 = L18_2.y
              L17_2.y = L18_2
              L18_2 = L11_2.rot
              L18_2 = L18_2.z
              L17_2.z = L18_2
              L16_2.rot = L17_2
              L13_2 = L13_2(L14_2, L15_2, L16_2)
              L4_2[L12_2] = L13_2
              L12_2 = MEAutoSave
              if L12_2 then
                L12_2 = MEAutoSave
                L13_2 = L9_2
                L12_2(L13_2)
              end
            end
          end
          L5_2 = History
          if not L5_2 then
            goto lbl_1155
          end
          L5_2 = #L4_2
          if not (L5_2 > 0) then
            goto lbl_1155
          end
          L5_2 = History
          L5_2 = L5_2.Push
          L6_2 = Cmd
          L6_2 = L6_2.Batch
          L7_2 = L2_1
          if "r" == L7_2 then
            L7_2 = locale
            L8_2 = "hist.rotate_selection"
            L7_2 = L7_2(L8_2)
            if L7_2 then
              goto lbl_1093
            end
          end
          L7_2 = locale
          L8_2 = "hist.move_selection"
          L7_2 = L7_2(L8_2)
          ::lbl_1093::
          L8_2 = L4_2
          L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L6_2(L7_2, L8_2)
          L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
        else
          L4_2 = L8_1
          if L4_2 then
            L4_2 = L7_1
            if L4_2 then
              L4_2 = Objects
              L4_2 = L4_2.Get
              L5_2 = L8_1
              L4_2 = L4_2(L5_2)
              if L4_2 then
                L5_2 = MEAutoSave
                if L5_2 then
                  L5_2 = MEAutoSave
                  L6_2 = L8_1
                  L5_2(L6_2)
                end
                L5_2 = History
                if L5_2 then
                  L5_2 = History
                  L5_2 = L5_2.Push
                  L6_2 = Cmd
                  L6_2 = L6_2.Transform
                  L7_2 = Objects
                  L7_2 = L7_2.UidOf
                  L8_2 = L8_1
                  L7_2 = L7_2(L8_2)
                  L8_2 = L7_1
                  L9_2 = {}
                  L10_2 = {}
                  L11_2 = L4_2.coords
                  L11_2 = L11_2.x
                  L10_2.x = L11_2
                  L11_2 = L4_2.coords
                  L11_2 = L11_2.y
                  L10_2.y = L11_2
                  L11_2 = L4_2.coords
                  L11_2 = L11_2.z
                  L10_2.z = L11_2
                  L9_2.coords = L10_2
                  L10_2 = {}
                  L11_2 = L4_2.rot
                  L11_2 = L11_2.x
                  L10_2.x = L11_2
                  L11_2 = L4_2.rot
                  L11_2 = L11_2.y
                  L10_2.y = L11_2
                  L11_2 = L4_2.rot
                  L11_2 = L11_2.z
                  L10_2.z = L11_2
                  L9_2.rot = L10_2
                  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L6_2(L7_2, L8_2, L9_2)
                  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
                end
              end
            end
          end
        end
        ::lbl_1155::
        L4_2 = nil
        L5_2 = nil
        L6_2 = nil
        L7_2 = nil
        L10_1 = L7_2
        L9_1 = L6_2
        L8_1 = L5_2
        L7_1 = L4_2
      end
      L4_2 = L0_1
      if not L4_2 then
        L4_2 = L1_1
        if not L4_2 then
          goto lbl_1179
        end
      end
      L4_2 = nil
      L5_2 = false
      L1_1 = L5_2
      L0_1 = L4_2
      L4_2 = SendNUIMessage
      L5_2 = {}
      L5_2.action = "gizmoPos"
      L6_2 = {}
      L6_2.on = false
      L5_2.data = L6_2
      L4_2(L5_2)
      ::lbl_1179::
      L4_2 = L47_1
      L5_2 = false
      L4_2(L5_2)
      L4_2 = L44_1
      L5_2 = nil
      L4_2(L5_2)
      L4_2 = Wait
      L5_2 = 120
      L4_2(L5_2)
    end
  end
end
L50_1(L51_1)
