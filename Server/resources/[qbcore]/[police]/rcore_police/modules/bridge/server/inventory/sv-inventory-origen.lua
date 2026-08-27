-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.ORIGEN then
        InventoryService.RunTestStash = function(playerId)
            local lockerId = "admin_test_stash"
            local label = "Admin test stash"
            local zoneType = "JOB_STASH"
            local stash = Config.Stashes[zoneType]
            StartClient(playerId, "InventoryTestStash")
            if not doesExportExistInResource(Inventory.ORIGEN, 'registerStash') then
                return
            end
            exports.origen_inventory:registerStash(lockerId, {
                label = label,
                slots = stash.Slots,
                weight = stash.MaxWeight
            })
        end
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
                    if doesExportExistInResource(Inventory.ORIGEN, 'registerStash') then
                        exports.origen_inventory:registerStash(lockerId, {
                            label = "Police stash",
                            slots = getLockerSettings.Slots,
                            weight = getLockerSettings.MaxWeight
                        })
                    else
                        dbg.critical(
                        'Inventory: Failed to open stash named: %s for user named %s since registerStash doesnt exist in your inventory: %s',
                            lockerId, GetPlayerName(playerId), Inventory.ORIGEN)
                    end
                end
            end
        end)
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
        InventoryService.doesItemExist = function(itemName, playerId)
            if doesExportExistInResource(Inventory.ORIGEN, 'Items') then
                local itemData = exports[Inventory.ORIGEN]:Items(itemName)
                if itemData then
                    return true
                end
            end
            if ServerItems[itemName:upper()] then
                return true
            end
            return false
        end
        InventoryService.addItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                if doesExportExistInResource(Config.Inventory, "GiveWeaponToPlayer") then
                    exports[Config.Inventory]:GiveWeaponToPlayer(client, item:lower(), math.random(30, 120))
                    return true
                else
                    item = item:lower()
                end
            end
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            exports[Config.Inventory]:AddItem(client, item, amount, nil, data, true)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            local match = string.match(item, "^WEAPON_(.*)")
            if match then
                item = item:lower()
            end
            return exports[Config.Inventory]:RemoveItem(client, item, amount, nil, true)
        end
        InventoryService.getFullInventory = function(playerId)
            return exports[Config.Inventory]:GetInventory(playerId)
        end
        InventoryService.hasItem = function(client, itemName, amount)
            local src = client
            amount = amount or 1
            local item = exports[Config.Inventory]:GetItemByName(src, itemName)
            local hasItem = exports[Config.Inventory]:HasItem(src, itemName, amount)
            if not hasItem then
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
            return ItemInfo and ItemInfo.count >= amount or false
        end
        InventoryService.RegisterUsableItem = function(itemName, callBack)
            if not Framework.object then
                return
            end
            if doesExportExistInResource(itemName, 'CreateUseableItem') then
                exports[Inventory.ORIGEN]:CreateUseableItem(itemName, function(source, item)
                    if UseableItemsCooldowns[source] then
                        return
                    end
                    UseableItemsCooldowns[source] = true
                    SetTimeout(1 * 1000, function()
                        UseableItemsCooldowns[source] = false
                    end)
                    callBack(source, item.info or item.metadata or {})
                end)
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
