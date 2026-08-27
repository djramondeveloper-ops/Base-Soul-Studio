-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.CODEM then
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
                        TriggerServerEvent('codem-inventory:server:robplayer', targetPlayerId)
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
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, true)
            if not ctx then
                return dbg.critical("OpenPersonalLocker: Failed to generate context")
            end
            TriggerServerEvent("inventory:server:OpenInventory", "stash", ctx.formattedId, {
                maxweight = ctx.maxweight,
                slots = ctx.slots
            })
            TriggerEvent("inventory:client:SetCurrentStash", ctx.formattedId)
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
                return dbg.critical("OpenPersonalLocker: Failed to generate context")
            end
            TriggerServerEvent("inventory:server:OpenInventory", "stash", ctx.formattedId, {
                maxweight = ctx.maxweight,
                slots = ctx.slots
            })
            TriggerEvent("inventory:client:SetCurrentStash", ctx.formattedId)
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
                return dbg.critical("OpenPersonalLocker: Failed to generate context")
            end
            TriggerServerEvent("inventory:server:OpenInventory", "stash", ctx.formattedId, {
                maxweight = ctx.maxweight,
                slots = ctx.slots
            })
            TriggerEvent("inventory:client:SetCurrentStash", ctx.formattedId)
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
            TriggerServerEvent("inventory:server:OpenInventory", "stash", ctx.formattedId, {
                maxweight = ctx.maxweight,
                slots = ctx.slots
            })
            TriggerEvent("inventory:client:SetCurrentStash", ctx.formattedId)
        end
        IsInventoryBusy = function()
            return LocalPlayer.state.inv_busy
        end
    end
end)
