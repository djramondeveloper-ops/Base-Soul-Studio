-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.ORIGEN then
        NetworkService.RegisterNetEvent('HandleInventoryState', function(validRequest, state)
            if validRequest then
                if state then
                    exports.origen_inventory:LockInventory()
                else
                    exports.origen_inventory:UnlockInventory()
                end
            end
        end)
        OpenPlayerInventory = function(targetPlayerId)
            local animDict = "anim@gangops@morgue@table@"
            local animName = "player_search"
            local flag = 49
            if InventoryUtils.CanSearch(targetPlayerId) then
                CancellableProgress(
                    Config.SearchInventory,
                    _U("SEARCHING_CITIZEN"),
                    animDict,
                    animName,
                    flag,
                    function()
                        if doesExportExistInResource(Inventory.ORIGEN, 'openInventory') then
                            exports.origen_inventory:openInventory('player', targetPlayerId)
                            return
                        end
                        TriggerServerEvent('rcore_police:server:requestPlayerInventory', targetPlayerId)
                    end,
                    function()
                    end,
                    {
                        checkDistance = true,
                        target = targetPlayerId,
                    })
            end
        end
        ShowPlayerInventory = function(targetPlayerId, inventory)
            local playerInventory = {}
            if inventory and next(inventory) then
                for index, item in ipairs(inventory) do
                    playerInventory[#playerInventory + 1] = {
                        type = 'button',
                        header = item.label,
                        description = '',
                        params = {
                            isServer = true,
                            event = 'rcore_police:server:takePlayerItem',
                            args = {
                                item = item.name,
                                count = item.count,
                                targetPlayerId = targetPlayerId,
                            },
                            icon = item.icon or '',
                        },
                    }
                end
                UI:CreateMenu(MENU_ID_LIST.PLAYER_INVENTORY, _U('JOB_MENU.MENU_TITLE'), playerInventory, true)
            end
        end
        OpenPersonalLocker = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, true)
            if not ctx then
                return dbg.critical("OpenPersonalLocker: Failed to generate context")
            end
            if not doesExportExistInResource(Inventory.ORIGEN, 'openInventory') then
                dbg.critical('OpenPersonalLocker: Failed to open stash since openInventory export doesnt exist!')
                return
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, false)
            exports[Inventory.ORIGEN]:openInventory('stash', ctx.formattedId)
        end
        OpenJobStash = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local retval = UI.Input(_U('JOB_STASH.TITLE'), {
                {
                    label = _U('JOB_STASH.INPUT_LABEL'),
                    placeholder = _U('JOB_STASH.INPUT_PLACEHOLDER'),
                    type = "number",
                    required = true
                },
            })
            if not retval then return end
            local jobSharedStorage = retval[tostring(0)]
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false, jobSharedStorage)
            if not ctx then
                return dbg.critical("OpenJobStash: Failed to generate context")
            end
            if not doesExportExistInResource(Inventory.ORIGEN, 'openInventory') then
                dbg.critical('OpenJobStash: Failed to open stash since openInventory export doesnt exist!')
                return
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, false)
            exports[Inventory.ORIGEN]:openInventory('stash', ctx.formattedId)
        end
        OpenEvidenceStash = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false)
            if not ctx then
                return dbg.critical("OpenEvidenceStash: Failed to generate context")
            end
            if not doesExportExistInResource(Inventory.ORIGEN, 'openInventory') then
                dbg.critical('OpenEvidenceStash: Failed to open stash since openInventory export doesnt exist!')
                return
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, false)
            exports[Inventory.ORIGEN]:openInventory('stash', ctx.formattedId)
        end
        OpenWeaponStorage = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false)
            if not ctx then
                return dbg.critical("OpenWeaponStorage: Failed to generate context")
            end
            if not doesExportExistInResource(Inventory.ORIGEN, 'openInventory') then
                dbg.critical('OpenWeaponStorage: Failed to open stash since openInventory export doesnt exist!')
                return
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, false)
            exports[Inventory.ORIGEN]:openInventory('stash', ctx.formattedId)
        end
        IsInventoryBusy = function()
            return false
        end
    end
end)
