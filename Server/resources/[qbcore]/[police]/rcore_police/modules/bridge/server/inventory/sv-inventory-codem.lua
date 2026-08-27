-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.CODEM then
        local codem = exports['codem-inventory']
        InventoryService.doesItemExist = function(itemName)
            return true
        end
        InventoryService.addItem = function(client, item, amount, metadata)
            if not doesExportExistInResource(Inventory.CODEM, 'AddItem') then
                dbg.critical(
                'Inventory: Failed to add item named %s, for client %s since RemoveItem doesnt exist in your inventory!',
                    item, GetPlayerName(client))
                return
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            item = item:lower()
            codem:AddItem(client, item, amount, nil, metadata)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            if not doesExportExistInResource(Inventory.CODEM, 'RemoveItem') then
                dbg.critical(
                'Inventory: Failed to remove item named %s, for client %s since RemoveItem doesnt exist in your inventory!',
                    item, GetPlayerName(client))
                return
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'RemoveItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            item = item:lower()
            codem:RemoveItem(client, item, amount)
            return true
        end
        InventoryService.hasItem = function(playerId, item, amount)
            amount = amount or 1
            if not doesExportExistInResource(Inventory.CODEM, 'GetItemsTotalAmount') then
                dbg.critical(
                'Inventory: Failed to get GetItemsTotalAmount for item named %s, for client %s since RemoveItem doesnt exist in your inventory!',
                    item, GetPlayerName(playerId))
                return
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(playerId, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'HasItem: Failed to check item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(playerId), playerId)
                return false
            end
            item = item:lower()
            local inventoryAmount = codem:GetItemsTotalAmount(playerId, item) or 0
            inventoryAmount = tonumber(inventoryAmount) or 0
            return inventoryAmount >= amount
        end
        InventoryService.getInventoryItems = function(playerId)
            local identifier = Framework.getIdentifier(playerId)
            if not doesExportExistInResource(Inventory.CODEM, 'GetInventory') then
                dbg.critical(
                'Inventory: Failed to inventory items, for client %s since GetInventory doesnt exist in your inventory!',
                    GetPlayerName(playerId))
                return
            end
            return codem:GetInventory(identifier, source)
        end
        InventoryService.RegisterUsableItem = function(itemName, callBack)
            if not Framework.object then
                return
            end
            if Config.Framework == Framework.ESX then
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
            elseif IS_QB[Config.Framework] then -- QBCORE, QBOX
                Framework.object.Functions.CreateUseableItem(itemName, function(source, item)
                    if UseableItemsCooldowns[source] then
                        return
                    end
                    UseableItemsCooldowns[source] = true
                    SetTimeout(1 * 1000, function()
                        UseableItemsCooldowns[source] = false
                    end)
                    callBack(source, item.info or item.metadata or {})
                end)
            else
                callBack(nil, nil)
            end
        end
        InventoryService.setBusyState = function(playerId, state)
            local player = Player(playerId)
            if player then
                player.state.inv_busy = state 
            end
            dbg.info("Inventory state: Setting for %s (%s) to %s inventory", GetPlayerName(playerId), playerId, state and "disabling", "enabling")
        end
    end
end)
