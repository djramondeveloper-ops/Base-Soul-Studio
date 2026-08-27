-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local ESX_ITEMS_DEPLOY = {
    {
        name = Items.Spikes,
        label = Config.ItemsLabels[Items.Spikes],
        weight = 50,
    },
    {
        name = Items.SpeedCamera,
        label = Config.ItemsLabels[Items.SpeedCamera],
        weight = 50,
    },
    {
        name = Items.Megaphone,
        label = Config.ItemsLabels[Items.Megaphone],
        weight = 50,
    },
    {
        name = Items.Barrier,
        label = Config.ItemsLabels[Items.Barrier],
        weight = 50,
    },
    {
        name = Items.Handcuffs,
        label = Config.ItemsLabels[Items.Handcuffs],
        weight = 50,
    },
    {
        name = Items.HandcuffsKeys,
        label = Config.ItemsLabels[Items.HandcuffsKeys],
        weight = 50,
    },
}
local function shouldUseCheezaInventory()
    if Config.Inventory ~= Inventory.CHEEZA then
        return false
    end

    if isResourcePresentProvideless(Inventory.OX) then
        Config.Inventory = Inventory.OX
        return false
    end

    return true
end

CreateThread(function()
    if shouldUseCheezaInventory() then
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
        InventoryService.getFullInventory = function(playerId)
            local player = Framework.getPlayer(playerId)
            if not player then
                return nil
            end
            local items = player.getInventory()
            local loadout = player.getLoadout(false)
            local playerInventory = {}
            if doesExportExistInResource(Config.Inventory, "getPlayerInventory") then
                return exports[Config.Inventory]:getPlayerInventory(player)
            end
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
            return playerInventory
        end
        InventoryService.hasItem = function(client, itemName, amount)
            amount = amount or 1
            local player = Framework.getPlayer(client)
            if player == nil then
                return false
            end
            local state, result = pcall(function()
                local item = player.getInventoryItem(itemName)
                if item and item.count > amount then
                    return true
                else
                    return false
                end
            end)
            return result
        end
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
                return player.addMoney(amount)
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                player.addWeapon(item:lower(), math.random(30, 120))
                return true
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical('AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item, GetPlayerName(client), client)
                return false
            end
            player.addInventoryItem(item, amount)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local player = Framework.getPlayer(client)
            if player == nil then
                return false
            end
            if item == 'cash' or item == 'money' then
                return player.removeMoney(amount)
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                return player.removeWeapon(item:lower(), math.random(30, 120))
            end
            player.removeInventoryItem(item, amount)
        end
        InventoryService.RegisterUsableItem = function(itemName, callBack)
            if not Framework.object then
                return
            end

            local registerUsableItem = Framework.object.RegisterUsableItem
            if type(registerUsableItem) ~= "function" and Framework.object.Functions then
                registerUsableItem = Framework.object.Functions.CreateUseableItem
            end
            if type(registerUsableItem) ~= "function" then
                return
            end

            registerUsableItem(itemName, function(source)
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
        AssetDeployer:registerDeploy('items', Framework.ESX, function(data)
            local items = Framework.object and Framework.object.Items
            if items and next(items) then
                for _, item in ipairs(data) do
                    if items and not items[item.name] then
                        if item.name and item.label and item.weight then
                            MySQL.Sync.execute(
                            'INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES (?, ?, ?, 0, 1)', {
                                item.name,
                                item.label,
                                item.weight
                            })
                        end
                    end
                end
            end
            return true
        end, ESX_ITEMS_DEPLOY)
        InventoryService.setBusyState = function(playerId, state)
            StartClient(playerId, "HandleInventoryState", state)
             dbg.info("Inventory state: Setting for %s (%s) to %s inventory", GetPlayerName(playerId), playerId, state and "disabling", "enabling")
        end
    end
end)
