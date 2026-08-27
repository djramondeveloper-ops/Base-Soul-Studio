-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-duty.lua
--  Engineered by Eazy Fxap
--  Original: 52 lines → Cleaned: 19 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestDuty", function(zoneId)
    local src = source
    
    if not UtilsService.IsPlayerAtInteract(src, zoneId) then
        return dbg.debug("Failed to set duty for player named %s with playerId (%s), player not at request zone area.", GetPlayerName(src), src)
    end
    
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then
        return dbg.debug("Failed to set duty for player named %s with playerId (%s), player is not part of department.", GetPlayerName(src), src)
    end
    
    DutyService.HandlePlayerDuty(src)
end)
