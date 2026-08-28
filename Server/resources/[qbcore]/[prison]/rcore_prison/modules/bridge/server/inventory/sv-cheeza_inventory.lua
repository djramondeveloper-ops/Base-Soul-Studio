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
        name = 'prison_tablet',
        label = 'Prison Tablet',
        weight = 100,
    },
    {
        name = 'screwdriver',
        label = 'Screw Driver',
        weight = 100,
    },
}

local ITEM_TYPES = {
    WEAPON = "item_weapon",
    MONEY = "item_account",
    ITEM = "item_standard",
}

local ItemTransforms = {
    account = function(accountName, accountData)
        local labels = {
            money = "Cash",
            black_money = "Black Money"
        }

        return {
            type = 'item_account',
            name = accountName,
            label = labels[accountName] or accountName,
            count = accountData.money or 0,
            use = false,
            remove = true,
        }
    end,

    inventory = function(item)
        return {
            type = 'item_standard',
            name = item.name,
            label = item.label,
            count = item.count,
            use = item.usable,
            remove = item.canRemove
        }
    end,

    weapon = function(weapon)
        return {
            type = 'item_weapon',
            tintIndex = weapon.tintIndex or 0,
            components = weapon.components or {},
            name = weapon.name,
            label = weapon.label,
            count = weapon.ammo,
            health = weapon.health or 100,
            use = false,
            remove = true
        }
    end
}

CreateThread(function()
    if Config.Inventories == Inventories.CHEEZA then
        Inventory.hasItem = function(client, item, amount)
            local player = Framework.getPlayer(client)
            local retval = false

            if player == nil then
                return retval
            end

            if not amount then
                amount = 1
            end

            local playerInventory = Inventory.getInventoryItems(client)

            if playerInventory and next(playerInventory) then
                for k, v in pairs(playerInventory) do
                    if v.name:lower() == item:lower() and v.count >= amount then
                        retval = true
                    end
                end
            end

            return retval
        end

        Inventory.getInventoryItems = function(playerId)
            local player = Framework.getPlayer(playerId)
            if not player then return nil end

            local items = {}
            local accounts = { 'money', 'black_money' }

            for _, accountName in ipairs(accounts) do
                local account = player.getAccount(accountName)
                if account and type(account.money) == "number" and account.money > 0 then
                    items[#items + 1] = ItemTransforms.account(accountName, account)
                end
            end

            local inventory = player.getInventory()

            if inventory and type(inventory) == "table" then
                for _, item in pairs(inventory) do
                    if item and type(item.count) == "number" and item.count > 0 then
                        items[#items + 1] = ItemTransforms.inventory(item)
                    end
                end
            end

            local loadout = player.getLoadout()

            if loadout and type(loadout) == "table" then
                for _, weapon in pairs(loadout) do
                    if weapon and type(weapon) == "table" then
                        items[#items + 1] = ItemTransforms.weapon(weapon)
                    end
                end
            end

            return items
        end
 Inventory.addItem = function(client, item, amount, itemType)
            local player = Framework.getPlayer(client)

            if player == nil then
                return false
            end

            if not amount then
                amount = 1
            end

            if itemType == ITEM_TYPES.MONEY then
                if item == "cash" then
                    item = "money"
                end

                if item == 'money' or item == 'black_money' then
                    local account = player.getAccount(item)

                    if account then
                        player.setAccountMoney(item, account.money + amount)
                        return true
                    end
                end

                return player.addMoney(amount)
            end

            if itemType == ITEM_TYPES.WEAPON then
                if type(player.addWeapon) == "nil" then
                    return dbg.critical(
                        "AddItem: Failed for user %s (%s)\nReason: player.addWeapon doesnt exist in your playerClass.\nFramework version: %s\nInventory: %s",
                        GetPlayerName(client), client, GetResourceMetadata(Config.Framework, 'version', 0),
                        Config.Inventories)
                end
                
                return player.addWeapon(item, amount or 0, 100)
            end

            if not Inventory.DoesItemExist(item, client) then
                return dbg.critical("AddItem: Failed for user %s (%s) since item named %s doesnt exist on your server!",
                    GetPlayerName(client), client, item)
            end

            player.addInventoryItem(item, amount)
        end


        Inventory.removeItem = function(client, item, amount, itemType)
            local player = Framework.getPlayer(client)

            if player == nil then
                return false
            end

            if not amount then
                amount = 1
            end

            if itemType == ITEM_TYPES.MONEY then
                if item == "cash" then
                    item = "money"
                end

                if item == 'money' or item == 'black_money' then
                    local account = player.getAccount(item)

                    if account and account.money >= amount then
                        player.setAccountMoney(item, account.money - amount)
                        return true
                    end

                    return false
                end

                return player.removeMoney(amount)
            end

            if itemType == ITEM_TYPES.WEAPON then
                if type(player.removeWeapon) == "nil" then
                    return dbg.critical(
                        "RemoveItem: Failed for user %s (%s)\nReason: player.removeWeapon doesnt exist in your playerClass.\nFramework version: %s\nInventory: %s",
                        GetPlayerName(client), client, GetResourceMetadata(Config.Framework, 'version', 0),
                        Config.Inventories)
                end

                return player.removeWeapon(item)
            end

            if not Inventory.DoesItemExist(item, client) then
                return dbg.critical(
                    "RemoveItem: Failed for user %s (%s) since item named %s doesnt exist on your server!",
                    GetPlayerName(client), client, item)
            end

            player.removeInventoryItem(item, amount)
        end

        Inventory.DoesItemExist = function(itemName, playerId)
            if ServerItems[itemName:upper()] then
                return true
            end

            return false
        end

        Inventory.registerUsableItem = function(name, cb)
            Framework.object.RegisterUsableItem(name, function(source)
                cb(source, name)
            end)
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
                        Inventory.addItem(client, item.name, item.count, item.type)
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

        Inventory.clearInventory = function(client)
            local playerInventory = Inventory.getInventoryItems(client)

            if type(playerInventory) == "table" then
                for k, item in pairs(playerInventory) do
                    if item and type(item) == "table" then
                        if not Inventory.KeepSessionItemsWithName[item.name] then
                            Inventory.removeItem(client, item.name, item.count, item.type)
                        end
                    end
                end
            end

            TriggerEvent("esx:playerInventoryCleared", client)
            TriggerEvent("esx:playerLoadoutCleared", client)

            return true
        end

        AssetDeployer:registerDeploy('items', Framework.ESX, function(data)
            for _, item in ipairs(data) do
                MySQL.Sync.execute('INSERT INTO items (name, label, weight, rare, can_remove) VALUES (?, ?, ?, 0, 1)', {
                    item.name,
                    item.label,
                    item.weight
                })
            end

            return true
        end, ESX_ITEMS_DEPLOY)
    end
end)
