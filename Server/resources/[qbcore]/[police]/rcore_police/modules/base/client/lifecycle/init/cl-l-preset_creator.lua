-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-preset_creator.lua
--  Engineered by Eazy Fxap
--  Original: 23 lines → Cleaned: 11 lines
-- =====================================================

NetworkService.RegisterNetEvent("PresetCreator", function(success)
    if success then
        HandlePresetCreator()
    end
end)
