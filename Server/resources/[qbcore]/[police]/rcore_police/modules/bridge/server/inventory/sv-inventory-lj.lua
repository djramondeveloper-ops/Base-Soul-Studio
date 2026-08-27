-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.LJ then
        InventoryService.doesItemExist = function(itemName)
            local retval = false
            if ServerItems[itemName:upper()] then
                return true
            end
            return retval
        end
        InventoryService.addItem = function(client, item, amount, data)
            local player = Framework.getPlayer(client)
            if player == nil then
                return false
            end
            if item == 'cash' or item == 'money' then
                player.Functions.AddMoney('cash', amount)
                return true
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            player.Functions.AddItem(item, amount, nil, data or {})
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local player = Framework.getPlayer(client)
            if player == nil then
                return false
            end
            if item == 'cash' or item == 'money' then
                return player.Functions.RemoveMoney('cash', amount)
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            return player.Functions.RemoveItem(item, amount)
        end
        InventoryService.hasItem = function(playerId, itemName, amount)
            amount = amount or 1
            local player = Framework.getPlayer(playerId)
            if not player then
                return
            end
            local item = player.Functions.GetItemByName(itemName) or {}
            local ItemInfo = {
                name = itemName,
                count = item.amount or item.count or 0,
                label = item.label or "none",
                weight = item.weight or 0,
                usable = item.useable or false,
                rare = false,
                canRemove = false
            }
            return ItemInfo and ItemInfo.count and (ItemInfo.count >= amount or false)
        end
        InventoryService.getInventoryItems = function(playerId)
            local player = Framework.getPlayer(playerId)
            if player == nil then return {} end
            return player.PlayerData.items
        end
        InventoryService.RegisterUsableItem = function(itemName, callBack)
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
        InventoryService.setBusyState = function(playerId, state)
            local player = Player(playerId)
            if player then
                player.state.inv_busy = state 
            end
            dbg.info("Inventory state: Setting for %s (%s) to %s inventory", GetPlayerName(playerId), playerId, state and "disabling", "enabling")
        end
    end
end)
