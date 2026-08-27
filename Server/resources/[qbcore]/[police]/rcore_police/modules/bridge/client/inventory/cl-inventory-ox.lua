-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Inventory == Inventory.OX then
        NetworkService.RegisterNetEvent('FallBackOpenInventory', function(validRequest, targetPlayerId)
            if validRequest then
                if not targetPlayerId then
                    return
                end
                exports.ox_inventory:openInventory('player', targetPlayerId)
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
                        TriggerServerEvent('rcore_police:server:requestOpenInventory', targetPlayerId)
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
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false)
            if not ctx then
                return dbg.critical("OpenJobStash: Failed to generate context")
            end
            TriggerServerEvent('rcore_police:server:requestPersonalLocker', ctx.formattedId, ctx.type, ctx.rawZone)
            Wait(0)
            exports.ox_inventory:openInventory('stash', { id = ctx.formattedId, owner = Framework.identifier })
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
                return dbg.critical("OpenJobStash: Failed to generate context")
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone, evidenceNumber,
                true)
            Wait(0)
            exports.ox_inventory:openInventory('stash', ctx.formattedId)
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
            Wait(0)
            exports.ox_inventory:openInventory('stash', ctx.formattedId)
        end
        OpenWeaponStorage = function(internalZone)
            local zone = internalZone.getZoneData()
            local zoneType = internalZone.getZoneType()
            if not zone then
                return
            end
            local ctx = InventoryUtils.GetStashContext(zoneType, zone, false)
            if not ctx then
                return dbg.critical("OpenJobStash: Failed to generate context")
            end
            TriggerServerEvent('rcore_police:server:requestStash', ctx.formattedId, ctx.type, ctx.rawZone)
            Wait(0)
            exports.ox_inventory:openInventory('stash', ctx.formattedId)
        end
        IsInventoryBusy = function()
            return LocalPlayer.state.invOpen
        end
    end
end)
