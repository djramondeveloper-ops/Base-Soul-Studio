
CreateThread(function()
    if Config.Inventories == Inventories.PS then
        Inventory.hasItem = function(client, itemName, amount)
            amount = amount or 1
    
            local player = Framework.getPlayer(client)
    
            if not player then
                return false
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
    
            dbg.debugInventory('Inventory.hasItem: %s (%s) - checking if user has %s amount (%s) with state: %s',
                GetPlayerName(client), client, itemName, amount, ItemInfo.count >= amount or false)
    
            return ItemInfo and ItemInfo.count >= amount or false
        end
    
        Inventory.DoesItemExist = function(itemName, playerId)
            if ServerItems[itemName:upper()] then
                return true
            end

            return false
        end

        Inventory.getInventoryItems = function(playerId)
            local player = Framework.getPlayer(playerId)
    
            if player == nil then return {} end
    
            return player.PlayerData.items
        end
    
        Inventory.clearInventory = function(playerId)
            local state, error_message = pcall(function()
                return Framework.clearInventory(playerId)
            end)
    
            return state
        end
    
        --- @return boolean success
        Inventory.addItem = function(client, item, amount, data)
            local player = Framework.getPlayer(client)
    
            if player == nil then
                return false
            end

            return player.Functions.AddItem(item, amount, nil, data or {})
        end
    
    
        Inventory.removeItem = function(client, item, amount, data)
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
    
            return player.Functions.RemoveItem(item, amount, nil, data or {})
        end
    
    
        Inventory.addMultipleItems = function(client, items)
            if not client then
                return
            end
    
            if not items then
                return
            end
    
            local p = promise.new()
    
            if next(items) then
                for i = 1, #items, 1 do
                    local item = items[i]
    
                    if item and type(item) == "table" and next(item) then
                        local metadata = {}

                        if type(item.info) ~= "nil" then
                            metadata = item.info
                        end

                        if type(item.metadata) ~= "nil" then
                            metadata = item.metadata
                        end

                        Inventory.addItem(client, item.name, item.count, metadata)
                    end
    
                    if i >= #items then
                        p:resolve(true)
                    end
                end
            else
                p:resolve(false)
            end
    
            return Citizen.Await(p)
        end
    
        Inventory.registerUsableItem = function(itemName, cb)
            Framework.object.Functions.CreateUseableItem(itemName, function(source, item)
                cb(source, item.name, item)
            end)
        end
    end
end)