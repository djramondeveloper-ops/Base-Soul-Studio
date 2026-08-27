-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-weapon_shop.lua
--  Engineered by Eazy Fxap
--  Original: 67 lines → Cleaned: 29 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestBuyItemFromDepartmentStore", function(data)
    local src = source
    
    dbg.debug("Player %s requested transaction for department store!", GetPlayerName(src))
    
    if Config.Debug then
        tprint(data)
    end
    
    if not data then
        return dbg.debug("Buy item from department store: Not received any data")
    end
    
    if not UtilsService.IsPlayerAtInteract(src, data.zone) then
        return dbg.critical("Buy item from department store: Player is not at store interact")
    end
    
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then
        return dbg.critical("Buy item from department store: Player is not part of department to access this store!")
    end
    
    RequestGetItemFromStore(src, data.item, data.paymentMethod, data.amount)
end)
