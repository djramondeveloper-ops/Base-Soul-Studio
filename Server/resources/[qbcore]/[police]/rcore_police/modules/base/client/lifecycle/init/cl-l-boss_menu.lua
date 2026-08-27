-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-boss_menu.lua
--  Engineered by Eazy Fxap
--  Original: 35 lines → Cleaned: 14 lines
-- =====================================================

RegisterNetEvent("rcore_police:client:UpdateSpecificGroupData", function(groupId, data)
    GroupsService.UpdateSpecificGroupData(groupId, data)
end)

NetworkService.RegisterNetEvent("OpenBossMenu", function(success, data)
    if success then
        OpenBossMenuCustom(data)
    end
end)
