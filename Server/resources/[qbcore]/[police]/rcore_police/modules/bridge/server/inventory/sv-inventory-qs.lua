-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.QS then
        RegisterNetEvent('rcore_police:server:requestStash', function(lockerId, zoneType, zone)
            local playerId = source
            local state, stashCoords = UtilsService.IsPlayerAtInteract(playerId, zone)
            if not state then
                return
            end
            local playerJob = Framework.getJob(playerId)
            local zoneOwner = UtilsService.GetZoneJob(zone)
            local hasAccess = false
            if type(zoneOwner) == "table" then
                for k, v in pairs(zoneOwner) do
                    if playerJob and playerJob.name == v then
                        hasAccess = true
                    end
                end
            elseif playerJob and playerJob.name == zoneOwner then
                hasAccess = true
            end
            if hasAccess then
                local getLockerSettings = Config.Stashes[zoneType]
                if getLockerSettings then
                    if not doesExportExistInResource(Inventory.QS, 'RegisterStash') then
                        return
                    end
                    exports[Config.Inventory]:RegisterStash(
                        playerId,
                        lockerId,
                        getLockerSettings and getLockerSettings.Slots or nil,
                        getLockerSettings and getLockerSettings.MaxWeight or nil
                    )
                end
            end
        end)
        InventoryService.doesItemExist = function(itemName)
            if not itemName then
                return
            end
            local retval = false
            if doesExportExistInResource(Inventory.QS, 'GetItemList') then
                local itemData = exports[Inventory.QS]:GetItemList(itemName)
                if itemData then
                    return true
                end
            end
            if ServerItems and ServerItems[itemName:upper()] then
                return true
            end
            return retval
        end
        InventoryService.addItem = function(client, item, amount, data)
            if not item then
                return false
            end
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            if item == Items.PaperBag then
                item = 'paper_bag'
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            if not doesExportExistInResource(Inventory.QS, 'AddItem') then
                return false
            end
            exports[Config.Inventory]:AddItem(client, item, amount, nil, data)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            if not doesExportExistInResource(Inventory.QS, 'RemoveItem') then
                return false
            end
            return exports[Config.Inventory]:RemoveItem(client, item, amount, nil, data)
        end
        InventoryService.hasItem = function(client, itemName, amount)
            amount = amount or 1
            local itemCount = exports[Config.Inventory]:GetItemTotalAmount(client, itemName)
            return itemCount and itemCount >= amount or false
        end
        InventoryService.getInventoryItems = function(playerId)
            local player = Framework.getPlayer(playerId)
            local inventory = {}
            if player == nil then return inventory end
            if doesExportExistInResource(Config.Inventory, "GetPlayerInventory") then
                return exports[Config.Inventory]:GetPlayerInventory(playerId)
            end
            if doesExportExistInResource(Config.Inventory, "GetInventory") then
                return exports[Config.Inventory]:GetInventory(playerId)
            end
            if IS_QB[Config.Framework] then
                return player.PlayerData.items
            end
            if Config.Framework == Framework.ESX then
                return player.inventory
            end
            return inventory
        end
        InventoryService.RunTestStash = function(playerId)
            local lockerId = "admin_test_stash"
            local label = "Admin test stash"
            local zoneType = "JOB_STASH"
            local stash = Config.Stashes[zoneType]
            StartClient(playerId, "InventoryTestStash")
            if not doesExportExistInResource(Inventory.QS, 'RegisterStash') then
                return
            end
            exports[Inventory.QS]:RegisterStash(
                playerId,
                lockerId,
                stash.Slots or nil,
                stash.MaxWeight or nil
            )
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
            end
            if IS_QB[Config.Framework] then -- QBCORE, QBOX
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
