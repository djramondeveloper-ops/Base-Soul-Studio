-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.MF then
        OpenPlayerInventory = function(targetPlayerId)
            TriggerServerEvent('rcore_police:server:requestPlayerInventory', targetPlayerId)
        end
        AddEventHandler('rcore_police:client:takePlayerItem', function(args)
            TriggerServerEvent("rcore_police:server:takePlayerItem", args)
        end)
        ShowPlayerInventory = function(targetPlayerId, inventory)
            local animDict = "anim@gangops@morgue@table@"
            local animName = "player_search"
            local flag = 49
            local playerInventory = {}
            if InventoryUtils.CanSearch(targetPlayerId) then
                CancellableProgress(
                    Config.SearchInventory,
                    _U("SEARCHING_CITIZEN"),
                    animDict,
                    animName,
                    flag,
                    function()
                        if inventory and next(inventory) then
                            for index, item in ipairs(inventory) do
                                playerInventory[#playerInventory + 1] = {
                                    type = 'button',
                                    header = item.label,
                                    description = '',
                                    params = {
                                        isClient = true,
                                        event = 'rcore_police:client:takePlayerItem',
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
                        else
                            return Framework.sendNotification(_U("EMPTY_INVENTORY"), "error")
                        end
                    end,
                    function()
                    end,
                    {
                        checkDistance = true,
                        target = targetPlayerId,
                    })
            end
        end
        OpenPersonalLocker = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local lockerId = ('%s_%s_%s_%s'):format(zone.preset, zone.index, zoneType, Framework.identifier)
            local getLockerSettings = Config.Stashes[zoneType]
            dbg.debug('OPEN_PERSONAL_LOCKER: Function is not defined')
        end
        OpenJobStash = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local lockerId = ('%s_%s_%s'):format(zone.preset, zone.index, zoneType)
            local getStorageSettings = Config.Stashes[zoneType]
            dbg.debug('OpenJobStash: Function is not defined')
        end
        OpenEvidenceStash = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local lockerId = ('%s_%s_%s'):format(zone.preset, zone.index, zoneType)
            local getStorageSettings = Config.Stashes[zoneType]
            dbg.debug('OPEN_EVIDENCE_STASH: Function is not defined')
        end
        OpenWeaponStorage = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local storageId = ('%s_%s_%s'):format(zone.preset, zone.index, zoneType)
            local getStorageSettings = Config.Stashes[zoneType]
            dbg.debug('OPEN_WEAPON_SHOP: Function is not defined')
        end
        IsInventoryBusy = function()
            return false
        end
    end
end)
