-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.NONE then
        InventoryService.addItem = function(client, itemName, amount, metadata)
            local retval = false
            local player = Framework.getPlayer(client)
            if Config.Framework == Framework.ESX and player then
                if itemName == 'cash' or itemName == 'money' then
                    return player.addMoney(amount)
                end
                local match = string.match(itemName, "^WEAPON_(.*)")
                if match then
                    return player.addWeapon(itemName:lower(), math.random(30, 120))
                end
                player.addInventoryItem(itemName, amount)
                retval = true
            elseif IS_QB[Config.Framework] and player then -- QBCORE, QBOX
                if itemName == 'cash' or itemName == 'money' then
                    return player.Functions.AddMoney('cash', amount)
                end
                player.Functions.AddItem(itemName, amount, nil, metadata or {})
                retval = true
            else
                retval = true
            end
            return retval
        end
        InventoryService.removeItem = function(client, itemName, amount, metadata)
            local retval = false
            local player = Framework.getPlayer(client)
            if Config.Framework == Framework.ESX and player then
                if itemName == 'cash' or itemName == 'money' then
                    return player.removeMoney(amount)
                end
                local match = string.match(itemName, "^WEAPON_(.*)")
                if match then
                    return player.removeWeapon(itemName:lower(), math.random(30, 120))
                end
                retval = player.removeInventoryItem(itemName, amount)
            elseif IS_QB[Config.Framework] and player then -- QBCORE, QBOX
                if itemName == 'cash' or itemName == 'money' then
                    return player.Functions.RemoveMoney('cash', amount)
                end
                local match = string.match(itemName, "^WEAPON_(.*)")
                if match then
                    itemName = itemName:lower()
                end
                player.Functions.RemoveItem(itemName, amount, nil, metadata or {})
                retval = true
            else
                retval = true
            end
            return retval
        end
        InventoryService.hasItem = function(client, itemName, amount)
            amount = amount or 1
            local retval = false
            if Config.Framework == Framework.ESX then
                local player = Framework.getPlayer(client)
                local success, result = pcall(function()
                    return player.getInventoryItem(itemName) and (player.getInventoryItem(itemName).count > amount)
                end)
                retval = result
            elseif IS_QB[Config.Framework] then -- QBCORE, QBOX
                local player = Framework.getPlayer(client)
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
                retval = ItemInfo and ItemInfo.count and (ItemInfo.count >= amount or false)
            else
                retval = true
            end
            return retval
        end
        InventoryService.doesItemExist = function(itemName)
            if Config.Framework == Framework.NONE then
                return true
            end
            if ServerItems[itemName:upper()] then
                return true
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
            else
                callBack(nil, nil)
            end
        end
        InventoryService.getFullInventory = function(client)
            local playerInventory = {}
            local player = Framework.getPlayer(client)
            if IS_QB[Config.Framework] and player then
                return player.PlayerData.items
            end
            if Config.Framework == Framework.ESX and player then
                local items = player.getInventory()
                local loadout = player.getLoadout(false)
                if items and next(items) then
                    for _, v in pairs(items) do
                        if v.count and v.count > 0 then
                            playerInventory[#playerInventory + 1] = {
                                name = v.name,
                                count = v.count,
                                label = v.label,
                                weight = v.weight,
                                useable = v.useable,
                                rare = v.rare,
                                type = 'item',
                            }
                        end
                    end
                end
                if loadout and next(loadout) then
                    for _, weapon in pairs(loadout) do
                        playerInventory[#playerInventory + 1] = {
                            name = weapon.name,
                            count = 1,
                            label = weapon.label,
                            weight = weapon.weight or 0,
                            useable = false,
                            rare = false,
                            type = 'weapon',
                        }
                    end
                end
            end
            return playerInventory
        end
        InventoryService.setBusyState = function(playerId, state)
            local player = Player(playerId)
            if player then
                player.state.inv_busy = state
                player.state.invBusy = state
                dbg.info("Inventory state: Setting for %s (%s) to %s inventory", GetPlayerName(playerId), playerId,
                state and "disabling", "enabling")
            end
        end
    end
end)
