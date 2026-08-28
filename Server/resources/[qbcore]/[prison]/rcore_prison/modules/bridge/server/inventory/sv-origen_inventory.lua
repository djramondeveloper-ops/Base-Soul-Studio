ESX_ITEMS_DEPLOY = {
    {
        name = 'sprunk',
        label = 'Sprunk',
        weight = 100,
    },
    {
        name = 'sludgie',
        label = 'Sludgie',
        weight = 250,
    },
    {
        name = 'ecola_light',
        label = 'Ecola light',
        weight = 100,
    },
    {
        name = 'ecola',
        label = 'Ecola',
        weight = 100,
    },
    {
        name = 'coffee',
        label = 'Coffee',
        weight = 100,
    },
    {
        name = 'coffee',
        label = 'Coffee',
        weight = 100,
    },
    {
        name = 'water',
        label = 'Water',
        weight = 100,
    },
    {
        name = 'fries',
        label = 'Fries',
        weight = 100,
    },
    {
        name = 'pizza_ham',
        label = 'Pizza Ham',
        weight = 100,
    },
    {
        name = 'chips',
        label = 'Chips',
        weight = 100,
    },
    {
        name = 'donut',
        label = 'Donut',
        weight = 100,
    },
    {
        name = 'wire_cutter',
        label = 'Wire cutter',
        weight = 100,
    },
    {
        name = 'cigarrete',
        label = 'Cigarrete',
        weight = 100,
    },
}

QB_INVENTORY_ITEMS_DEPLOY = {
    {
        name = 'sprunk', 
        label = 'Sprunk',
        weight = 100,
        type = 'item',
        image = 'sprunk.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'sludgie',
        label = 'Sludgie',
        weight = 100,
        type = 'item',
        image = 'sludgie.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'ecola_light',
        label = 'Ecola light',
        weight = 100,
        type = 'item',
        image = 'ecola_light.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'ecola',
        label = 'Ecola',
        weight = 100,
        type = 'item',
        image = 'ecola.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'coffee',
        label = 'Coffee',
        weight = 100,
        type = 'item',
        image = 'ecola.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'water',
        label = 'Water',
        weight = 100,
        type = 'item',
        image = 'water.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'fries',
        label = 'Fries',
        weight = 100,
        type = 'item',
        image = 'fries.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'pizza_ham',
        label = 'Pizza Ham',
        weight = 100,
        type = 'item',
        image = 'pizza_ham.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'chips',
        label = 'Chips',
        weight = 100,
        type = 'item',
        image = 'chips.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'donut',
        label = 'Donut',
        weight = 100,
        type = 'item',
        image = 'donut.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'cigarrete',
        label = 'cigarrete',
        weight = 100,
        type = 'item',
        image = 'cigarrete.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    {
        name = 'prison_tablet',
        label = 'Prison Tablet',
        weight = 100,
        type = 'item',
        image = 'prison_tablet.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
}


CreateThread(function()
    if Config.Inventories == Inventories.ORIGEN then
        Inventory.hasItem = function(client, itemName, amount)
            local src = source
            amount = amount or 1

            local item = exports[Inventories.ORIGEN]:GetItemByName(src, itemName)
            local hasItem = exports[Inventories.ORIGEN]:HasItem(src, itemName, amount)

            if not hasItem then
                dbg.debugInventory("Inventory.hasItem: Item %s doesnt exist!", itemName)
                return false
            end

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

        Inventory.getInventoryItems = function(playerId)
            local items = {}

            if doesExportExistInResource(Inventories.ORIGEN, "GetInventory") then
                local retval = exports[Inventories.ORIGEN]:GetInventory(playerId)

                if retval and type(retval.inventory) ~= nil then
                    retval = retval.inventory
                end

                return retval
            end

            if doesExportExistInResource(Inventories.ORIGEN, "getItems") then
                return exports[Inventories.ORIGEN]:getItems(playerId)
            end

            return items
        end

        Inventory.DoesItemExist = function(itemName, playerId)
            if doesExportExistInResource(Inventories.ORIGEN, 'Items') then
                local itemData = exports[Inventories.ORIGEN]:Items(itemName)

                if itemData then
                    return true
                end
            end

            if ServerItems[itemName:upper()] then
                return true
            end

            return false
        end

        Inventory.registerUsableItem = function(itemName, cb)
            if doesExportExistInResource(Inventories.ORIGEN, 'CreateUseableItem') then
                exports[Inventories.ORIGEN]:CreateUseableItem(itemName, function(src, item)
                    cb(src, item.name, item)
                end)

                return
            end

            if Config.Framework == Framework.QBCore then
                Framework.object.Functions.CreateUseableItem(itemName, function(source, item)
                    cb(source, item.name, item)
                end)
            end

            if Config.Framework == Framework.ESX then
                Framework.object.RegisterUsableItem(itemName, function(source, item)
                    cb(source, item.name, item)
                end)
            end
        end

        Inventory.removeItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            local state = false

            if match then
                item = item:lower()
            end

            if doesExportExistInResource(Inventories.ORIGEN, "RemoveItem") then
                return exports[Inventories.ORIGEN]:RemoveItem(client, item, amount, nil, true)
            end

            if doesExportExistInResource(Inventories.ORIGEN, "removeItem") then
                return exports[Inventories.ORIGEN]:removeItem(client, item, amount) 
            end

            return state
        end


        --- @return boolean success
        Inventory.addItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            local state = false

            if match then
                return exports[Inventories.ORIGEN]:GiveWeaponToPlayer(client, item:lower(), math.random(30, 120))
            end

            if doesExportExistInResource(Inventories.ORIGEN, "addItem") then
                return exports[Inventories.ORIGEN]:addItem(client, item, amount, data) 
            end

            if doesExportExistInResource(Inventories.ORIGEN, "AddItem") then
                return exports[Inventories.ORIGEN]:AddItem(client, item, amount, nil, data, true)
            end

            return state
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
                        local amount = 1

                        if item.count and type(item.count) ~= nil then
                            amount = item.count
                        end

                        if item.amount and type(item.amount) ~= nil then
                            amount = item.amount
                        end

                        Inventory.addItem(client, item.name, amount, item.metadata)
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

        Inventory.clearInventory = function(playerId)
            if doesExportExistInResource(Inventories.ORIGEN, "ClearInventory") then
                return exports[Inventories.ORIGEN]:ClearInventory(playerId, {})
            end

            return false
        end

        if Config.Framework == Framework.ESX then
            AssetDeployer:registerDeploy('items', Framework.ESX, function(data)
                for _, item in ipairs(data) do
                    MySQL.Sync.execute(
                        'INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES (?, ?, ?, 0, 1)', {
                            item.name,
                            item.label,
                            item.weight
                        })
                end

                return true
            end, ESX_ITEMS_DEPLOY)
        end
    end
end)
