-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.TGIANN then
        NetworkService.RegisterNetEvent('HandleInventoryState', function(validRequest, state)
            if validRequest then
                exports[Inventory.TGIANN]:SetInventoryActive(state)
            end
        end)
        OpenPlayerInventory = function(targetPlayerId)
            if not InventoryUtils.CanSearch(targetPlayerId) then
                return
            end
            if doesExportExistInResource(Inventory.TGIANN, 'OpenInventory') then
                exports[Inventory.TGIANN]:OpenInventory("otherplayer", targetPlayerId)
                return
            end
            local animDict = "anim@gangops@morgue@table@"
            local animName = "player_search"
            local flag = 49
            CancellableProgress(
                Config.SearchInventory,
                _U("SEARCHING_CITIZEN"),
                animDict,
                animName,
                flag,
                function()
                    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetPlayerId, nil,
                        { showClothe = false })
                end,
                function()
                end,
                {
                    checkDistance = true,
                    target = targetPlayerId,
                })
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
            exports[Inventory.TGIANN]:OpenInventory("stash", ctx.formattedId,
                { maxweight = ctx.maxweight, slots = ctx.slots })
        end
        OpenEvidenceStash = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local retval = UI.Input(_U('EVIDENCE.TITLE'), {
                {
                    label = _U('EVIDENCE.INPUT_LABEL'),
                    placeholder = _U('EVIDENCE.INPUT_PLACEHOLDER'),
                    type = "number",
                    required = true
                },
            })
            if not retval then return end
            local evidenceNumber = retval[tostring(0)]
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false, evidenceNumber)
            if not ctx then
                return dbg.critical("OpenEvidenceStash: Failed to generate context")
            end
            exports[Inventory.TGIANN]:OpenInventory("stash", ctx.formattedId,
                { maxweight = ctx.maxweight, slots = ctx.slots })
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
            exports[Inventory.TGIANN]:OpenInventory("stash", ctx.formattedId,
                { maxweight = ctx.maxweight, slots = ctx.slots })
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
            exports[Inventory.TGIANN]:OpenInventory("stash", ctx.formattedId,
                { maxweight = ctx.maxweight, slots = ctx.slots })
        end
        IsInventoryBusy = function()
            return false
        end
    end
end)
