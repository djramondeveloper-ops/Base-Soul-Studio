-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.MF then
        InventoryService.doesItemExist = function(itemName)
            local retval = false
            if ServerItems[itemName:upper()] then
                return true
            end
            return retval
        end
        InventoryService.addItem = function(client, item, amount, data)
            local identifier = Framework.getIdentifier(client)
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            exports[Config.Inventory]:addInventoryItem(identifier, item, amount, client, nil, data)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local identifier = Framework.getIdentifier(client)
            exports[Config.Inventory]:removeInventoryItem(identifier, item, amount, client, data, data)
        end
        InventoryService.getFullInventory = function(client)
            local identifier = Framework.getIdentifier(client)
            return exports[Config.Inventory]:getInventoryItems(identifier)
        end
        InventoryService.hasItem = function(client, itemName, amount)
            amount = amount or 1
            local identifier = Framework.getIdentifier(client)
            local item = exports[Config.Inventory]:getInventoryItem(identifier, itemName)
            return item and item.count >= amount
        end
        InventoryService.RegisterUsableItem = function(itemName, callBack)
            if not Framework.object then
                return
            end
            Framework.object.RegisterUsableItem(itemName, function(source)
                if UseableItemsCooldowns[source] then
                    return
                end
                UseableItemsCooldowns[source] = true
                SetTimeout(1 * 1000, function()
                    UseableItemsCooldowns[source] = false
                end)
                callBack(source, nil)
            end)
        end
        InventoryService.setBusyState = function(playerId, state)
        end
    end
end)
