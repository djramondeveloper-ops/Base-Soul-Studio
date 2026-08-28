-- [AI CLEANUP] Decompiled Lua - Fix these:
-- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
-- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
-- 3. Replace goto/label with while/repeat-until where possible
-- 4. Remove decompiler comments, add meaningful ones
-- 5. Fix indentation and formatting

local SHX0_1, SHX1_1, SHX2_1, SHX3_1, SHX4_1, SHX5_1, SHX6_1, SHX7_1, SHX8_1, SHX9_1, SHX10_1, SHX11_1, SHX12_1, SHX13_1, SHX14_1, SHX15_1, SHX16_1
SHX0_1 = json
SHX0_1 = SHX0_1.decode
SHX1_1 = LoadResourceFile
SHX2_1 = GetCurrentResourceName
SHX2_1 = SHX2_1()
SHX3_1 = "hideModels.json"
SHX1_1, SHX2_1, SHX3_1, SHX4_1, SHX5_1, SHX6_1, SHX7_1, SHX8_1, SHX9_1, SHX10_1, SHX11_1, SHX12_1, SHX13_1, SHX14_1, SHX15_1, SHX16_1 = SHX1_1(SHX2_1, SHX3_1)
SHX0_1 = SHX0_1(SHX1_1, SHX2_1, SHX3_1, SHX4_1, SHX5_1, SHX6_1, SHX7_1, SHX8_1, SHX9_1, SHX10_1, SHX11_1, SHX12_1, SHX13_1, SHX14_1, SHX15_1, SHX16_1)
SHX1_1 = {}
SHX2_1 = {}
SHX3_1 = vector3
SHX4_1 = 1692.05
SHX5_1 = 2542.4
SHX6_1 = 46.13
SHX3_1 = SHX3_1(SHX4_1, SHX5_1, SHX6_1)
SHX2_1.pos = SHX3_1
SHX3_1 = {}
SHX4_1 = "rcore_solitary_confinement"
SHX3_1[1] = SHX4_1
SHX2_1.models = SHX3_1
SHX3_1 = {}
SHX4_1 = vector3
SHX5_1 = 1692.05
SHX6_1 = 2555.55
SHX7_1 = 46.13
SHX4_1 = SHX4_1(SHX5_1, SHX6_1, SHX7_1)
SHX3_1.pos = SHX4_1
SHX4_1 = {}
SHX5_1 = "rcore_solitary_confinement"
SHX4_1[1] = SHX5_1
SHX3_1.models = SHX4_1
SHX1_1[1] = SHX2_1
SHX1_1[2] = SHX3_1
SHX2_1 = {}
SHX3_1 = {}
SHX4_1 = vec3
SHX5_1 = 1762.1488037109
SHX6_1 = 2520.3435058594
SHX7_1 = 55.697269439697
SHX4_1 = SHX4_1(SHX5_1, SHX6_1, SHX7_1)
SHX3_1.pos = SHX4_1
SHX4_1 = {}
SHX5_1 = "prop_fnclink_04g"
SHX6_1 = "prop_fnclink_07a"
SHX7_1 = "prop_fnclink_02gate7"
SHX4_1[1] = SHX5_1
SHX4_1[2] = SHX6_1
SHX4_1[3] = SHX7_1
SHX3_1.models = SHX4_1
SHX4_1 = {}
SHX5_1 = vec3
SHX6_1 = 1730.4412841797
SHX7_1 = 2505.3696289062
SHX8_1 = 54.482242584229
SHX5_1 = SHX5_1(SHX6_1, SHX7_1, SHX8_1)
SHX4_1.pos = SHX5_1
SHX5_1 = {}
SHX6_1 = "prop_fnclink_04g"
SHX7_1 = "prop_fnclink_07a"
SHX8_1 = "prop_fnclink_02gate7"
SHX5_1[1] = SHX6_1
SHX5_1[2] = SHX7_1
SHX5_1[3] = SHX8_1
SHX4_1.models = SHX5_1
SHX5_1 = {}
SHX6_1 = vec3
SHX7_1 = 1708.9898681641
SHX8_1 = 2481.3503417969
SHX9_1 = 55.659435272217
SHX6_1 = SHX6_1(SHX7_1, SHX8_1, SHX9_1)
SHX5_1.pos = SHX6_1
SHX6_1 = {}
SHX7_1 = "prop_fnclink_04g"
SHX8_1 = "prop_fnclink_07a"
SHX9_1 = "prop_fnclink_02gate7"
SHX6_1[1] = SHX7_1
SHX6_1[2] = SHX8_1
SHX6_1[3] = SHX9_1
SHX5_1.models = SHX6_1
SHX6_1 = {}
SHX7_1 = vec3
SHX8_1 = 1676.4783935547
SHX9_1 = 2481.255859375
SHX10_1 = 55.754264831543
SHX7_1 = SHX7_1(SHX8_1, SHX9_1, SHX10_1)
SHX6_1.pos = SHX7_1
SHX7_1 = {}
SHX8_1 = "prop_fnclink_04g"
SHX9_1 = "prop_fnclink_07a"
SHX10_1 = "prop_fnclink_02gate7"
SHX7_1[1] = SHX8_1
SHX7_1[2] = SHX9_1
SHX7_1[3] = SHX10_1
SHX6_1.models = SHX7_1
SHX7_1 = {}
SHX8_1 = vec3
SHX9_1 = 1647.7017822266
SHX10_1 = 2489.9313964844
SHX11_1 = 55.785671234131
SHX8_1 = SHX8_1(SHX9_1, SHX10_1, SHX11_1)
SHX7_1.pos = SHX8_1
SHX8_1 = {}
SHX9_1 = "prop_fnclink_04g"
SHX10_1 = "prop_fnclink_07a"
SHX11_1 = "prop_fnclink_02gate7"
SHX8_1[1] = SHX9_1
SHX8_1[2] = SHX10_1
SHX8_1[3] = SHX11_1
SHX7_1.models = SHX8_1
SHX8_1 = {}
SHX9_1 = vec3
SHX10_1 = 1620.6755371094
SHX11_1 = 2514.4812011719
SHX12_1 = 54.462142944336
SHX9_1 = SHX9_1(SHX10_1, SHX11_1, SHX12_1)
SHX8_1.pos = SHX9_1
SHX9_1 = {}
SHX10_1 = "prop_fnclink_04g"
SHX11_1 = "prop_fnclink_07a"
SHX12_1 = "prop_fnclink_02gate7"
SHX9_1[1] = SHX10_1
SHX9_1[2] = SHX11_1
SHX9_1[3] = SHX12_1
SHX8_1.models = SHX9_1
SHX9_1 = {}
SHX10_1 = vec3
SHX11_1 = 1610.2094726562
SHX12_1 = 2537.56640625
SHX13_1 = 55.785671234131
SHX10_1 = SHX10_1(SHX11_1, SHX12_1, SHX13_1)
SHX9_1.pos = SHX10_1
SHX10_1 = {}
SHX11_1 = "prop_fnclink_04g"
SHX12_1 = "prop_fnclink_07a"
SHX13_1 = "prop_fnclink_02gate7"
SHX10_1[1] = SHX11_1
SHX10_1[2] = SHX12_1
SHX10_1[3] = SHX13_1
SHX9_1.models = SHX10_1
SHX10_1 = {}
SHX11_1 = vec3
SHX12_1 = 1610.0725097656
SHX13_1 = 2569.8654785156
SHX14_1 = 55.67618560791
SHX11_1 = SHX11_1(SHX12_1, SHX13_1, SHX14_1)
SHX10_1.pos = SHX11_1
SHX11_1 = {}
SHX12_1 = "prop_fnclink_04g"
SHX13_1 = "prop_fnclink_07a"
SHX14_1 = "prop_fnclink_02gate7"
SHX11_1[1] = SHX12_1
SHX11_1[2] = SHX13_1
SHX11_1[3] = SHX14_1
SHX10_1.models = SHX11_1
SHX11_1 = {}
SHX12_1 = vec3
SHX13_1 = 1673.1008300781
SHX14_1 = 2564.9768066406
SHX15_1 = 55.672519683838
SHX12_1 = SHX12_1(SHX13_1, SHX14_1, SHX15_1)
SHX11_1.pos = SHX12_1
SHX12_1 = {}
SHX13_1 = "prop_fnclink_04g"
SHX14_1 = "prop_fnclink_07a"
SHX15_1 = "prop_fnclink_02gate7"
SHX12_1[1] = SHX13_1
SHX12_1[2] = SHX14_1
SHX12_1[3] = SHX15_1
SHX11_1.models = SHX12_1
SHX12_1 = {}
SHX13_1 = vec3
SHX14_1 = 1736.0969238281
SHX15_1 = 2562.6652832031
SHX16_1 = 55.615928649902
SHX13_1 = SHX13_1(SHX14_1, SHX15_1, SHX16_1)
SHX12_1.pos = SHX13_1
SHX13_1 = {}
SHX14_1 = "prop_fnclink_04g"
SHX15_1 = "prop_fnclink_07a"
SHX16_1 = "prop_fnclink_02gate7"
SHX13_1[1] = SHX14_1
SHX13_1[2] = SHX15_1
SHX13_1[3] = SHX16_1
SHX12_1.models = SHX13_1
SHX2_1[1] = SHX3_1
SHX2_1[2] = SHX4_1
SHX2_1[3] = SHX5_1
SHX2_1[4] = SHX6_1
SHX2_1[5] = SHX7_1
SHX2_1[6] = SHX8_1
SHX2_1[7] = SHX9_1
SHX2_1[8] = SHX10_1
SHX2_1[9] = SHX11_1
SHX2_1[10] = SHX12_1
SHX3_1 = {}
SHX4_1 = {}
SHX5_1 = vec3
SHX6_1 = 1618.511963
SHX7_1 = 2584.306396
SHX8_1 = 45.961891
SHX5_1 = SHX5_1(SHX6_1, SHX7_1, SHX8_1)
SHX4_1.pos = SHX5_1
SHX4_1.dist = 4.0
SHX5_1 = {}
SHX6_1 = "prop_fnclink_10d"
SHX5_1[1] = SHX6_1
SHX4_1.models = SHX5_1
SHX5_1 = {}
SHX6_1 = vec3
SHX7_1 = 1624.8140869140625
SHX8_1 = 2585.554931640625
SHX9_1 = 45.61105346679687
SHX6_1 = SHX6_1(SHX7_1, SHX8_1, SHX9_1)
SHX5_1.pos = SHX6_1
SHX5_1.dist = 0.1
SHX6_1 = {}
SHX7_1 = "prop_fnclink_10d"
SHX8_1 = "prop_fnclink_10e"
SHX6_1[1] = SHX7_1
SHX6_1[2] = SHX8_1
SHX5_1.models = SHX6_1
SHX3_1[1] = SHX4_1
SHX3_1[2] = SHX5_1
SHX4_1 = AddEventHandler
SHX5_1 = "playerSpawned"
function SHX6_1()
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX0_2, SHX1_2
  SHX0_2 = HideModels
  SHX0_2()
end
SHX4_1(SHX5_1, SHX6_1)
SHX4_1 = CreateThread
function SHX5_1()
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX0_2, SHX1_2
  SHX0_2 = Wait
  SHX1_2 = 3000
  SHX0_2(SHX1_2)
  SHX0_2 = HideModels
  SHX0_2()
end
SHX6_1 = "cl-lib-hide_models code name: Phoenix"
SHX4_1(SHX5_1, SHX6_1)
function SHX4_1()
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX0_2, SHX1_2, SHX2_2, SHX3_2, SHX4_2, SHX5_2, SHX6_2, SHX7_2, SHX8_2, SHX9_2, SHX10_2, SHX11_2, SHX12_2, SHX13_2, SHX14_2, SHX15_2, SHX16_2, SHX17_2, SHX18_2, SHX19_2, SHX20_2
  SHX0_2 = SHX0_1
  if SHX0_2 then
    SHX0_2 = next
    SHX1_2 = SHX0_1
    SHX0_2 = SHX0_2(SHX1_2)
    if SHX0_2 then
      SHX0_2 = pairs
      SHX1_2 = SHX0_1
      SHX0_2, SHX1_2, SHX2_2, SHX3_2 = SHX0_2(SHX1_2)
      for SHX4_2, SHX5_2 in SHX0_2, SHX1_2, SHX2_2, SHX3_2 do
        SHX6_2 = SHX5_2.resource
        if "NONE" ~= SHX6_2 then
          SHX6_2 = isResourceLoaded
          SHX7_2 = SHX5_2.resource
          SHX6_2 = SHX6_2(SHX7_2)
          if not SHX6_2 then
            goto SHX_LABEL_39
          end
        end
        SHX6_2 = SHX5_2.distance
        if not SHX6_2 then
          SHX6_2 = 0.01
        end
        SHX7_2 = SHX5_2.model
        if SHX7_2 then
          SHX7_2 = CreateModelHide
          SHX8_2 = SHX5_2.pos
          SHX8_2 = SHX8_2.x
          SHX9_2 = SHX5_2.pos
          SHX9_2 = SHX9_2.y
          SHX10_2 = SHX5_2.pos
          SHX10_2 = SHX10_2.z
          SHX11_2 = SHX6_2
          SHX12_2 = SHX5_2.model
          SHX13_2 = true
          SHX7_2(SHX8_2, SHX9_2, SHX10_2, SHX11_2, SHX12_2, SHX13_2)
        end
        -- [FIX IF ERROR] Move ::SHX_LABEL_39:: outside nested blocks until all 'goto SHX_LABEL_39' can see it
        ::SHX_LABEL_39::
      end
    end
  end
  SHX0_2 = Assets
  if SHX0_2 then
    SHX0_2 = Assets
    SHX0_2 = SHX0_2.EnableGatesOnTopofStairs
    if not SHX0_2 then
      SHX0_2 = 8.0
      SHX1_2 = pairs
      SHX2_2 = SHX2_1
      SHX1_2, SHX2_2, SHX3_2, SHX4_2 = SHX1_2(SHX2_2)
      for SHX5_2, SHX6_2 in SHX1_2, SHX2_2, SHX3_2, SHX4_2 do
        SHX7_2 = SHX6_2.pos
        SHX8_2 = SHX6_2.models
        if SHX8_2 then
          SHX8_2 = next
          SHX9_2 = SHX6_2.models
          SHX8_2 = SHX8_2(SHX9_2)
          if SHX8_2 then
            SHX8_2 = pairs
            SHX9_2 = SHX6_2.models
            SHX8_2, SHX9_2, SHX10_2, SHX11_2 = SHX8_2(SHX9_2)
            for SHX12_2, SHX13_2 in SHX8_2, SHX9_2, SHX10_2, SHX11_2 do
              if SHX13_2 and SHX7_2 then
                SHX14_2 = CreateModelHide
                SHX15_2 = SHX7_2.x
                SHX16_2 = SHX7_2.y
                SHX17_2 = SHX7_2.z
                SHX18_2 = SHX0_2
                SHX19_2 = SHX13_2
                SHX20_2 = true
                SHX14_2(SHX15_2, SHX16_2, SHX17_2, SHX18_2, SHX19_2, SHX20_2)
              end
            end
          end
        end
      end
    end
  end
  SHX0_2 = Assets
  if SHX0_2 then
    SHX0_2 = Assets
    SHX0_2 = SHX0_2.UnloadSolitaryCells
    if SHX0_2 then
      SHX0_2 = 8.0
      SHX1_2 = pairs
      SHX2_2 = SHX1_1
      SHX1_2, SHX2_2, SHX3_2, SHX4_2 = SHX1_2(SHX2_2)
      for SHX5_2, SHX6_2 in SHX1_2, SHX2_2, SHX3_2, SHX4_2 do
        SHX7_2 = SHX6_2.pos
        SHX8_2 = SHX6_2.models
        if SHX8_2 then
          SHX8_2 = next
          SHX9_2 = SHX6_2.models
          SHX8_2 = SHX8_2(SHX9_2)
          if SHX8_2 then
            SHX8_2 = pairs
            SHX9_2 = SHX6_2.models
            SHX8_2, SHX9_2, SHX10_2, SHX11_2 = SHX8_2(SHX9_2)
            for SHX12_2, SHX13_2 in SHX8_2, SHX9_2, SHX10_2, SHX11_2 do
              if SHX13_2 and SHX7_2 then
                SHX14_2 = CreateModelHide
                SHX15_2 = SHX7_2.x
                SHX16_2 = SHX7_2.y
                SHX17_2 = SHX7_2.z
                SHX18_2 = SHX0_2
                SHX19_2 = SHX13_2
                SHX20_2 = true
                SHX14_2(SHX15_2, SHX16_2, SHX17_2, SHX18_2, SHX19_2, SHX20_2)
              end
            end
          end
        end
      end
    end
  end
  SHX0_2 = Assets
  if SHX0_2 then
    SHX0_2 = Assets
    SHX0_2 = SHX0_2.UnloadWallsWhenOnFullPrompt
    if SHX0_2 then
      SHX0_2 = Config
      SHX0_2 = SHX0_2.Map
      if "prompt-full" == SHX0_2 then
        SHX0_2 = pairs
        SHX1_2 = SHX3_1
        SHX0_2, SHX1_2, SHX2_2, SHX3_2 = SHX0_2(SHX1_2)
        for SHX4_2, SHX5_2 in SHX0_2, SHX1_2, SHX2_2, SHX3_2 do
          SHX6_2 = SHX5_2.pos
          SHX7_2 = SHX5_2.dist
          if SHX7_2 then
            SHX7_2 = SHX5_2.dist
            if SHX7_2 then
              goto SHX_LABEL_151
            end
          end
          SHX7_2 = 1.0
          -- [FIX IF ERROR] Move ::SHX_LABEL_151:: outside nested blocks until all 'goto SHX_LABEL_151' can see it
          ::SHX_LABEL_151::
          SHX8_2 = SHX5_2.models
          if SHX8_2 then
            SHX8_2 = next
            SHX9_2 = SHX5_2.models
            SHX8_2 = SHX8_2(SHX9_2)
            if SHX8_2 then
              SHX8_2 = pairs
              SHX9_2 = SHX5_2.models
              SHX8_2, SHX9_2, SHX10_2, SHX11_2 = SHX8_2(SHX9_2)
              for SHX12_2, SHX13_2 in SHX8_2, SHX9_2, SHX10_2, SHX11_2 do
                if SHX13_2 and SHX6_2 then
                  SHX14_2 = CreateModelHide
                  SHX15_2 = SHX6_2.x
                  SHX16_2 = SHX6_2.y
                  SHX17_2 = SHX6_2.z
                  SHX18_2 = SHX7_2
                  SHX19_2 = SHX13_2
                  SHX20_2 = true
                  SHX14_2(SHX15_2, SHX16_2, SHX17_2, SHX18_2, SHX19_2, SHX20_2)
                end
              end
            end
          end
        end
      end
    end
  end
end
HideModels = SHX4_1
