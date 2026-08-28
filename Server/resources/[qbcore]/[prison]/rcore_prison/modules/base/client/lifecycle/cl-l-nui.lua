-- [AI CLEANUP] Decompiled Lua - Fix these:
-- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
-- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
-- 3. Replace goto/label with while/repeat-until where possible
-- 4. Remove decompiler comments, add meaningful ones
-- 5. Fix indentation and formatting

local SHX0_1, SHX1_1, SHX2_1
SHX0_1 = NetworkService
SHX0_1 = SHX0_1.RegisterNetEvent
SHX1_1 = "openMDW"
function SHX2_1(SHX0_2)
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX1_2
  if SHX0_2 then
    SHX1_2 = FrontendService
    SHX1_2 = SHX1_2.OpenMDW
    SHX1_2()
  end
end
SHX0_1(SHX1_1, SHX2_1)
SHX0_1 = RegisterNuiCallback
SHX1_1 = "ADD_SENTENCE"
function SHX2_1(SHX0_2, SHX1_2)
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX2_2, SHX3_2, SHX4_2
  SHX2_2 = TriggerServerEvent
  SHX3_2 = "rcore_prison:server:requestAddSentence"
  SHX4_2 = SHX0_2
  SHX2_2(SHX3_2, SHX4_2)
  SHX2_2 = SHX1_2
  SHX3_2 = "OK"
  SHX2_2(SHX3_2)
end
SHX0_1(SHX1_1, SHX2_1)
SHX0_1 = RegisterNUICallback
SHX1_1 = "call"
function SHX2_1(SHX0_2, SHX1_2)
  -- [AI CLEANUP] Decompiled Lua - Fix these:
  -- 1. Move ::SHX_LABEL_XX:: outside nested blocks if 'no visible label' error
  -- 2. Rename SHX0_1, SHX1_2 variables to meaningful names
  -- 3. Replace goto/label with while/repeat-until where possible
  -- 4. Remove decompiler comments, add meaningful ones
  -- 5. Fix indentation and formatting
  
  local SHX2_2, SHX3_2, SHX4_2, SHX5_2
  SHX2_2 = FrontendService
  SHX2_2 = SHX2_2.HandleShowState
  SHX3_2 = false
  SHX2_2(SHX3_2)
  SHX2_2 = TriggerServerEvent
  SHX3_2 = "rcore_prison:server:requestBoothCall"
  SHX4_2 = SH
  SHX4_2 = SHX4_2.zoneId
  SHX5_2 = SHX0_2
  SHX2_2(SHX3_2, SHX4_2, SHX5_2)
  SHX2_2 = SHX1_2
  SHX3_2 = "OK"
  SHX2_2(SHX3_2)
end
SHX0_1(SHX1_1, SHX2_1)
