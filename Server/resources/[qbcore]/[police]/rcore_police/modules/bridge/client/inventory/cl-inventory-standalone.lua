-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.NONE then
        OpenPlayerInventory = function(targetPlayerId)
            if not InventoryUtils.CanSearch(targetPlayerId) then
                return false
            end
            ExecuteCommand('search')
            ExecuteCommand('robplayer') 
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
