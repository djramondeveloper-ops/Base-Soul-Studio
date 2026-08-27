-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-cuffs.lua
--  Engineered by Eazy Fxap
--  Original: 86 lines → Cleaned: 29 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestCuffEscape", function(target, arg2, arg3)
    local src = source
    
    if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance) then
        return
    end
    
    if not GlobalCache[target] then
        GlobalCache[target] = true
    end
    
    SetTimeout(5000, function()
        GlobalCache[target] = nil
    end)
    
    InteractionService.removeState(target, "CUFF_STATE")
    InteractionService.removeState(src, "CUFF_STATE")
    
    InteractionService.removeState(src, "ESCORT_STATE")
    InteractionService.removeState(target, "ESCORT_STATE")
    
    Framework.sendNotification(src, _U("MINIGAME_ESCORT_ESCAPE_FOR_TARGET"), "success")
    Framework.sendNotification(target, _U("MINIGAME_ESCORT_ESCAPE_FOR_OFFICER"), "success")
    
    StartClient(target, "PunchSync", src, arg2)
end)
