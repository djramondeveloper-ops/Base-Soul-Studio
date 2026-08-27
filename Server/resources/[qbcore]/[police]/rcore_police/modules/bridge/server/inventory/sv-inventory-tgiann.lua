-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.TGIANN then
        InventoryService.doesItemExist = function(itemName)
            if doesExportExistInResource(Inventory.TGIANN, 'Items') then
                local itemData = exports[Inventory.TGIANN]:Items(itemName)
                if itemData then
                    return true
                end
            end
            if ServerItems and ServerItems[itemName:upper()] then
                return true
            end
            return false
        end
        InventoryService.addItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            exports[Config.Inventory]:AddItem(client, item, amount, nil, data, false)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            return exports[Config.Inventory]:RemoveItem(client, item, amount, nil)
        end
        InventoryService.getFullInventory = function(playerId)
            if not playerId then
                return {}
            end
            return exports[Config.Inventory]:GetPlayerItems(playerId)
        end
        InventoryService.hasItem = function(client, itemName, amount)
            amount = amount or 1
            local match = string.match(itemName, "^WEAPON_(.*)")
            if match then
                itemName = itemName:lower()
            end
            local item = exports[Config.Inventory]:GetItemByName(client, itemName) or {}
            local ItemInfo = {
                name = itemName,
                count = item.amount or item.count or 0,
                label = item.label or "none",
                weight = item.weight or 0,
                usable = item.useable or false,
                rare = false,
                canRemove = false
            }
            return ItemInfo and ItemInfo.count >= amount or false
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
            end
        end
        InventoryService.setBusyState = function(playerId, state)
            StartClient(playerId, "HandleInventoryState", state)
            dbg.info("Inventory state: Setting for %s (%s) to %s inventory", GetPlayerName(playerId), playerId, state and "disabling", "enabling")
        end
    end
end)
