-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-tackle.lua
--  Engineered by Eazy Fxap
--  Original: 160 lines → Cleaned: 52 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestTacklePlayer", function(target)
    local src = source
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    
    if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance + 10.0) then
        return
    end
    
    SetTackleState(target, true)
    SetTackleState(src, true)
    
    StartClient(target, "TacklePlayer", src)
end)

RegisterNetEvent("rcore_police:server:requestTackleEnableMovement", function(target)
    local src = source
    
    if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance) then
        return
    end
    
    SetTackleState(target, false)
    SetTackleState(src, false)
    
    StartClient(target, "TackleRemove", src)
end)

RegisterNetEvent("rcore_police:server:requestTackleCuff", function(target)
    local src = source
    
    if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance) then
        return
    end
    
    StartClient(target, "TackleCuffPlayer", src)
    
    SetTackleState(target, true)
    SetTackleState(src, true)
    
    SetTimeout(5000, function()
        SetTackleState(target, false)
        SetTackleState(src, false)
        
        ActionService.Handcuff(src, target, false, nil, true)
        
        Wait(1500)
        
        ActionService.Escort(src, target)
    end)
end)

function SetTackleState(player, state)
    Player(player).state:set("rcorePoliceTackle", state, true)
    dbg.debug("Tackle: Setting a state for (%s) %s to state %s", GetPlayerName(player), player, state)
end
