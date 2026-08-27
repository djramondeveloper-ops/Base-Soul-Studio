-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.CORE then
        RegisterNetEvent('rcore_police:server:requestPlayerInventory', function(targetPlayerId)
            local playerId = source
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not state then
                return
            end
            if not Utils.IsPlayerNearAnotherPlayer(playerId, targetPlayerId, Config.CheckDistance) then
                return
            end
            ActionService.SearchPlayer(playerId, targetPlayerId)
        end)
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
                if Config.Framework == Framework.ESX then
                    player.Functions.AddMoney('cash', amount)
                    return true
                end
                if Config.Framework == Framework.ESX then
                    player.addMoney(amount)
                    return true
                end
            end
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
            if Config.Framework == Framework.ESX then
                player.addInventoryItem(item, amount, data)
            end
            if IS_QB[Config.Framework] then
                player.Functions.AddItem(item, amount, nil, data)
            end
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local player = Framework.getPlayer(client)
            if player == nil then
                return false
            end
            if item == 'cash' or item == 'money' then
                if Config.Framework == Framework.ESX then
                    return player.Functions.AddMoney('cash', amount)
                end
                if Config.Framework == Framework.ESX then
                    return player.addMoney(amount)
                end
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            if Config.Framework == Framework.ESX then
                player.addInventoryItem(item, amount, data)
            elseif Config.Framework == Framework.QBCore or Config.Framework == Framework.QBOX then
                player.Functions.AddItem(item, amount, nil, data)
            end
        end
        InventoryService.getFullInventory = function(playerId)
            local player = Framework.getPlayer(playerId)
            if player == nil then return {} end
            local inventory = {}
            local content = {}
            local primary = {}
            if Config.Framework == Framework.ESX then
                content = exports[Config.Inventory]:getInventory('content-' .. player.getIdentifier():gsub(':', ''))
                primary = exports[Config.Inventory]:getInventory('primary-' .. player.getIdentifier():gsub(':', ''))
                inventory = table.merge(content, primary)
            end
            if IS_QB[Config.Framework] then
                content = exports[Config.Inventory]:getInventory('content-' .. player.PlayerData.citizenid)
                primary = exports[Config.Inventory]:getInventory('primary-' .. player.PlayerData.citizenid)
                inventory = table.merge(content, primary)
            end
            return inventory or {}
        end
        InventoryService.hasItem = function(client, itemName, amount)
            if client == nil then return {} end
            local player = Framework.getPlayer(client)
            amount = amount or 1
            if player == nil then return {} end
            if Config.Framework == Framework.ESX then
                local item = player.getInventoryItem(itemName)
                return item and item.count >= amount
            end
            if IS_QB[Config.Framework] then
                local items = player.Functions.GetItemsByName(itemName)
                return items and #items >= amount
            end
            return false
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
        end
    end
end)
