local CachedUseableItems = {}

CreateThread(function()
    if Config.Inventories == Inventories.JAKSAM then
        Inventory.hasItem = function(client, item, amount)
            if amount == nil then
                amount = 1
            end

            local itemAmount = exports[Inventories.JAKSAM]:getTotalItemAmount(client, item)

            return itemAmount >= amount
        end

        --- @return boolean success
        Inventory.addItem = function(client, item, amount, data)
            exports[Inventories.JAKSAM]:addItem(client, item, amount, data)
            return true
        end

        Inventory.DoesItemExist = function(itemName, playerId)
            if doesExportExistInResource(Inventories.JAKSAM, "getStaticItem") then
                local retval = exports[Inventories.JAKSAM]:getStaticItem(itemName)

                if retval == false then
                    dbg.critical(
                    "Failed to find item named %s - needed for rcore_prison. (Please define your items in your inventory)",
                        itemName)
                end

                return retval
            end

            return true
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

                    if item and next(item) then
                        Inventory.addItem(client, item.name, item.count, item.metadata)
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

        Inventory.removeItem = function(client, item, amount, data)
            exports[Inventories.JAKSAM]:removeItem(client, item, amount, data)
            return true
        end

        Inventory.registerUsableItem = function(name, cb)
            if CachedUseableItems[name] then
                return
            end

            if not doesExportExistInResource(Inventories.JAKSAM, "registerUsableItem") then
                dbg.critical("Update your %s, since registerUsableItem is missing (Not issue of rcore_prison)", Config.Inventories)
                return
            end

            CachedUseableItems[name] = true

            exports[Inventories.JAKSAM]:registerUsableItem(name, function(playerId, itemName, inventoryItem)
                cb(playerId, itemName, nil, inventoryItem.metadata)
            end)
        end

        Inventory.getInventoryItems = function(playerId)
            local items = {}

            if doesExportExistInResource(Inventories.JAKSAM, "getInventory") then
                local retval = exports[Inventories.JAKSAM]:getInventory(playerId)

                if retval and type(retval.items) ~= nil then
                    items = retval.items
                end
            end

            return items
        end

        Inventory.clearInventory = function(playerId)
            local retval = false

            if not doesExportExistInResource(Inventories.JAKSAM, "clearInventory") then
                dbg.critical("Update your %s, since clearInventory is missing (Not issue of rcore_prison)", Config.Inventories)
                return retval
            end

            if type(Inventory.KeepSessionItems) ~= "nil" then
                retval = exports[Inventories.JAKSAM]:clearInventory(playerId, Inventory.KeepSessionItems)
            else
                retval = exports[Inventories.JAKSAM]:clearInventory(playerId)
            end

            return retval
        end
    end
end, "sv-mf_inventory code name: Phoenix")
