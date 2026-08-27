-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



AddEventHandler('rcore_police:server:sendHeartBeat', function(playerId, target, action, state)
    if IS_QB[Config.Framework] and action == 'CUFF_STATE' then
        Framework.setHandcuffMetadata(target, state)        
    end
    if action == "CUFF_STATE" and Config.Cuffing.DisableInventoryWhileCuffed then
        InventoryService.setBusyState(target, state)
    end
end)
AddEventHandler("rcore_police:server:playerUnloaded", function(playerId)
    if Config.Cuffing.DisableInventoryWhileCuffed then
        InventoryService.setBusyState(playerId, false)
    end
end)
CreateThread(function()
    if Config.Inventory == Inventory.NONE then
        dbg.info("Warning: Failed to find any supported inventory!\n- Running standalone inventory bridge: Search, Stashes features are not going to work!") 
    end
end)
