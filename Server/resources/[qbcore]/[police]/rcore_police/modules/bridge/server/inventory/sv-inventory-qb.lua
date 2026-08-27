-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.QB then
        RegisterNetEvent('rcore_police:server:requestSearchTargetInventory', function(target)
            local playerId = source
            if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.Cuffing.CheckDistance) then
                return Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
            end
            if not doesExportExistInResource(Config.Inventory, "OpenInventoryById") then
                StartClient(playerId, 'FallBackOpenInventory', target)
                return
            end
            exports['qb-inventory']:OpenInventoryById(playerId, target)
        end)
        RegisterNetEvent('rcore_police:server:requestPersonalLocker', function(lockerId, zoneType, zone)
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
                    if not doesExportExistInResource(Config.Inventory, "OpenInventory") then
                        StartClient(playerId, 'FallbackOpenStash', lockerId, zoneType)
                        return
                    end
                    exports[Inventory.QB]:OpenInventory(playerId, lockerId, {
                        maxweight = getLockerSettings.MaxWeight,
                        slots = getLockerSettings.Slots,
                    })
                end
            end
        end)
        RegisterNetEvent('rcore_police:server:requestStash',
            function(lockerId, zoneType, zone, evidenceNumber, isEvidence)
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
                    local label = _U('STASHES.JOB_STASH_LABEL', evidenceNumber)
                    if isEvidence then
                        label = _U('STASHES.EVIDENCE_STASH_LABEL', evidenceNumber)
                    end
                    if getLockerSettings then
                        if not doesExportExistInResource(Config.Inventory, "OpenInventory") then
                            StartClient(playerId, 'FallbackOpenStash', lockerId, zoneType)
                            return
                        end
                        exports['qb-inventory']:OpenInventory(playerId, lockerId, {
                            maxweight = getLockerSettings.MaxWeight,
                            slots = getLockerSettings.Slots,
                            label = label
                        })
                    end
                end
            end)
        InventoryService.doesItemExist = function(itemName)
            local retval = false
            if itemName and ServerItems and ServerItems[itemName:upper()] then
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
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
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
        InventoryService.RunTestStash = function(playerId)
            local lockerId = "admin_test_stash"
            local label = "Admin test stash"
            local zoneType = "JOB_STASH"
            local stash = Config.Stashes[zoneType]
            StartClient(playerId, "InventoryTestStash")
            if not doesExportExistInResource(Config.Inventory, "OpenInventory") then
                StartClient(playerId, 'FallbackOpenStash', lockerId, zoneType)
                return
            end
            exports['qb-inventory']:OpenInventory(playerId, lockerId, {
                maxweight = stash.MaxWeight,
                slots = stash.Slots,
                label = label
            })
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
