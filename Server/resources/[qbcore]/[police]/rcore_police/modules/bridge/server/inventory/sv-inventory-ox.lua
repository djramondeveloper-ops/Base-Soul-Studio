-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local OX_INVENTORY_ITEMS_DEPLOY = {
    {
        name = Items.Spikes,
        label = Config.ItemsLabels[Items.Spikes],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.SpeedCamera,
        label = Config.ItemsLabels[Items.SpeedCamera],
        weight = 100,
        stack = false,
        close = true,
    },
    {
        name = Items.Megaphone,
        label = Config.ItemsLabels[Items.Megaphone],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.Barrier,
        label = Config.ItemsLabels[Items.Barrier],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.Handcuffs,
        label = Config.ItemsLabels[Items.Handcuffs],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.HandcuffsKeys,
        label = Config.ItemsLabels[Items.HandcuffsKeys],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.Zipties,
        label = Config.ItemsLabels[Items.Zipties],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.PaperBag,
        label = Config.ItemsLabels[Items.PaperBag],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.BodyCam,
        label = Config.ItemsLabels[Items.BodyCam],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.BodyCamTablet,
        label = Config.ItemsLabels[Items.BodyCamTablet],
        weight = 100,
        stack = true,
        close = true,
    },
    {
        name = Items.PanicButton,
        label = Config.ItemsLabels[Items.PanicButton],
        weight = 100,
        stack = true,
        close = true,
    },
}
local cachedItems = nil

local function shouldUseOxInventory()
    if Config.Inventory == Inventory.OX then
        return true
    end

    if Config.Inventory == Inventory.CHEEZA and isResourcePresentProvideless(Inventory.OX) then
        Config.Inventory = Inventory.OX
        return true
    end

    return false
end

if shouldUseOxInventory() then
        InventoryService.RunTestStash = function(playerId)
            local lockerId = "admin_test_stash"
            local label = "Admin test stash"
            local zoneType = "JOB_STASH"
            local stash = Config.Stashes[zoneType]
            StartClient(playerId, "InventoryTestStash")
            exports.ox_inventory:RegisterStash(lockerId, label, stash.Slots, stash.MaxWeight)
            exports.ox_inventory:forceOpenInventory(playerId, 'stash', lockerId)
        end
        RegisterNetEvent('rcore_police:server:requestOpenInventory', function(target)
            local playerId = source
            local isMember = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not isMember then return end
            if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance + 0.5) then
                Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
                return
            end
            if doesExportExistInResource(Inventory.OX, 'forceOpenInventory') then
                exports.ox_inventory:forceOpenInventory(playerId, 'player', tonumber(target))
            else
                StartClient(playerId, 'FallBackOpenInventory', target)
            end
        end)
        RegisterNetEvent('rcore_police:server:requestPersonalLocker', function(lockerId, zoneType, zone)
            local playerId = source
            local identifier = Framework.getIdentifier(playerId)
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
                    exports.ox_inventory:RegisterStash(lockerId, _U('STASHES.PERSONAL_LOCKER_LABEL'),
                        getLockerSettings.Slots, getLockerSettings.MaxWeight, identifier)
                end
            end
        end)
        RegisterNetEvent('rcore_police:server:requestStash',
            function(lockerId, zoneType, zone, evidenceNumber, isEvidence)
                local playerId = source
                local identifier = Framework.getIdentifier(playerId)
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
                    if getLockerSettings then
                        if isEvidence then
                            label = _U('STASHES.EVIDENCE_STASH_LABEL', evidenceNumber)
                        end
                        if evidenceNumber then
                            identifier = nil
                        end
                        if not doesExportExistInResource(Inventory.OX, 'RegisterStash') then
                            return
                        end
                        exports.ox_inventory:RegisterStash(lockerId, label, getLockerSettings.Slots,
                            getLockerSettings.MaxWeight, identifier)
                    end
                end
            end)
        InventoryService.doesItemExist = function(itemName)
            if not itemName then
                return true
            end
            if not cachedItems then
                cachedItems = {}
                for item, data in pairs(exports.ox_inventory:Items()) do
                    cachedItems[item:upper()] = {}
                end
            end
            if cachedItems[itemName:upper()] then
                return true
            end
            if doesExportExistInResource(Inventory.OX, 'Items') then
                return exports[Config.Inventory]:Items(itemName:upper()) ~= nil
            end
            if ServerItems and ServerItems[itemName:upper()] then
                return true
            end
            return false
        end
        InventoryService.addItem = function(client, item, amount, metadata)
            if not InventoryService.doesItemExist(item) then
                Framework.sendNotification(client, _U('UNDEFINED_ITEM_ERROR', item), 'error')
                dbg.critical(
                    'AddItem: Failed to add item (%s) to player named %s (%s) since doesnt exist on your server!', item,
                    GetPlayerName(client), client)
                return false
            end
            exports[Config.Inventory]:AddItem(client, item, amount, metadata)
            return true
        end
        InventoryService.removeItem = function(client, item, amount, data)
            exports[Config.Inventory]:RemoveItem(client, item, amount)
        end
        InventoryService.hasItem = function(playerId, itemName, amount)
            amount = amount or 1
            local currentAmount = exports[Config.Inventory]:Search(playerId, 'count', itemName)
            local count = 0
            if type(currentAmount) == "number" then
                count = currentAmount
            elseif type(currentAmount) == "table" then
                for _, v in pairs(currentAmount) do
                    if type(v) == "number" then
                        count = count + v
                    elseif type(v) == "table" and v.count then
                        count = count + v.count
                    end
                end
            end
            return count >= amount
        end
        AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
            TriggerEvent('bridge:usedItem', playerId, name, slotId, metadata)
        end)
        InventoryService.RegisterUsableItem = function(itemName, callBack)
            AddEventHandler('bridge:usedItem', function(playerId, name, slotId, metadata)
                if name == itemName then
                    if UseableItemsCooldowns[playerId] then
                        return
                    end
                    UseableItemsCooldowns[playerId] = true
                    SetTimeout(1 * 1000, function()
                        UseableItemsCooldowns[playerId] = false
                    end)
                    callBack(playerId, metadata)
                end
            end)
        end
        AssetDeployer:registerCopyFilesDeploy('items-images', Inventory.OX, 'assets/inventoryImages', 'web/images',
            function(data)
                local files = {}
                for _, item in ipairs(data) do
                    table.insert(files, item .. '.png')
                end
                return files
            end,
            { Items.Spikes, Items.SpeedCamera, Items.Barrier, Items.Megaphone, Items.Handcuffs, Items.HandcuffsKeys,
                Items.Zipties, Items.PaperBag, Items.BodyCam, Items.BodyCamTablet, Items.PanicButton }
        )
        AssetDeployer:registerFileDeploy('items', Inventory.OX, 'data/items.lua', function(file, data)
            file = appendAfterReturn(file, ASSET_DEPLOYER_WATERMARK_PREFIX)
            local itemTemplate = [[
        ['%s'] = {
            label = '%s',
            weight = %s,
            stack = %s,
            close = %s,
            consume = %s,
        },
            ]]
            for _, item in ipairs(data) do
                local buttons = ''
                local formattedItem = itemTemplate:format(
                    item.name,
                    item.label,
                    item.weight,
                    item.stack,
                    item.close,
                    item.consume
                )
                file = appendAfterReturn(file, formattedItem)
            end
            return file
        end, OX_INVENTORY_ITEMS_DEPLOY)
        InventoryService.setBusyState = function(playerId, state)
            local player = Player(playerId)
            if player then
                player.state:set('invBusy', state, true)
            end
            dbg.info("Inventory state: Setting for %s (%s) to %s inventory - state: %s", GetPlayerName(playerId),
                playerId, state and "disabling" or "enabling", state)
        end
end
