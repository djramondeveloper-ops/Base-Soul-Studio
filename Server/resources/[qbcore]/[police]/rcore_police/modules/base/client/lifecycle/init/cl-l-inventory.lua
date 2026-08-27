-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-inventory.lua
--  Engineered by Eazy Fxap
--  Original: 77 lines → Cleaned: 26 lines
-- =====================================================

NetworkService.RegisterNetEvent("InventoryTestSearch", function(success, targetServerId)
    if not success then return end
    
    local serverId = MyServerId
    if Config.Inventory == Inventory.OX then
        serverId = targetServerId
    end
    
    OpenPlayerInventory(serverId)
    Wait(4000)
    
    if not IsNuiFocused() then
        local msg = string.format("Inventory ('%s') UI for search is not detected. Please make sure you are using a supported and up-to-date inventory system!", Config.Inventory)
        Framework.sendNotification(msg)
    end
end)

NetworkService.RegisterNetEvent("InventoryTestStash", function(success)
    if not success then return end
    
    Wait(1000)
    if not IsNuiFocused() then
        local msg = string.format("Inventory ('%s') UI for stash is not detected. Please make sure you are using a supported and up-to-date inventory system!", Config.Inventory)
        Framework.sendNotification(msg)
    end
end)
