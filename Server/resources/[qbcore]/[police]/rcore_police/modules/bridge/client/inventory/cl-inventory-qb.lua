-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.QB then
        NetworkService.RegisterNetEvent('FallbackOpenStash', function(validRequest, id, zoneType)
            if validRequest then
                if not id then
                    return
                end
                local getStorageSettings = Config.Stashes[zoneType]
                TriggerServerEvent("inventory:server:OpenInventory", "stash", id, {
                    maxweight = getStorageSettings.MaxWeight,
                    slots = getStorageSettings.Slots,
                })
                TriggerEvent("inventory:client:SetCurrentStash", id)
            end
        end)
        NetworkService.RegisterNetEvent('FallBackOpenInventory', function(validRequest, targetPlayerId)
            if validRequest then
                if not targetPlayerId then
                    return
                end
                TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', targetPlayerId)
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
                        TriggerServerEvent('rcore_police:server:requestSearchTargetInventory', targetPlayerId)
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
            TriggerServerEvent('rcore_police:server:requestPersonalLocker', ctx.formattedId, ctx.type, ctx.rawZone)
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
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, evidenceNumber)
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
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone,
                jobSharedStorage)
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
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone)
        end
        IsInventoryBusy = function()
            return LocalPlayer.state.inv_busy
        end
    end
end)
