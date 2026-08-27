-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-boss_menu.lua
--  Engineered by Eazy Fxap
--  Original: 52 lines → Cleaned: 18 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestBossMenu", function()
    local src = source
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember or not groupData then return end
    
    local globalStateData = GroupsService.GetGlobalStateData(groupData.group)
    StartClient(src, "OpenBossMenu", globalStateData)
end)

RegisterNetEvent("rcore_police:server:requestBossMenuAction", function(actionData)
    local src = source
    if not src then return end
    HandleBossMenuAction(src, actionData)
end)
