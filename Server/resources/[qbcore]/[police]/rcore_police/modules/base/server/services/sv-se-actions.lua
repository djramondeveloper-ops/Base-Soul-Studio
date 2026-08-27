-- =====================================================
--  rcore_police · modules/base/server/services/sv-se-actions.lua
--  Engineered by Eazy Fxap
--  Original: 1615 lines → Cleaned: ~300 lines
-- =====================================================

ActionService = {}

function ActionService.SearchPlayer(initiatorSrc, targetSrc)
    local target = IsInDev and initiatorSrc or (targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance))
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if not IsInDev and initiatorSrc == target then
        dbg.debug("SearchInventory: You cannot request search player inventory for yourself!")
        return false, "PLAYER_EQUAL_TARGET"
    end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    local inventory = nil
    if Config.Inventory == Inventory.ESX then
        inventory = InventoryService.getFullInventory(target)
    end
    Framework.sendNotification(initiatorSrc, _U("OFFICER_SEARCH"), "success")
    Framework.sendNotification(target, _U("SEARCH_TARGET"), "success")
    StartClient(initiatorSrc, "SearchPlayer", target, inventory)
end

function ActionService.TakePlayerFromVehicle(initiatorSrc, targetSrc)
    local target = targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance + 1)
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if initiatorSrc == target then return false, "PLAYER_EQUAL_TARGET" end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    if type(initiatorSrc) == "number" then
        if GetVehiclePedIsIn(GetPlayerPed(initiatorSrc), false) > 0 then
            return false, "INITATOR_TRIED_ACTION_FROM_VEHICLE"
        end
    end
    InteractionService.removeState(target, "ESCORT_STATE")
    InteractionService.removeState(initiatorSrc, "ESCORT_STATE")
    StartClient(target, "FromVehicle", initiatorSrc, {
        initiatorDeath = DeathService.GetPlayerState(initiatorSrc),
        targetDeath = DeathService.GetPlayerState(target)
    })
end

function ActionService.PutPlayerInVehicle(initiatorSrc, targetSrc, bypassCuffCheck)
    local target = targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance)
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if initiatorSrc == target then return false, "PLAYER_EQUAL_TARGET" end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    if GetVehiclePedIsIn(GetPlayerPed(initiatorSrc), false) > 0 then
        return false, "INITATOR_TRIED_ACTION_FROM_VEHICLE"
    end
    if not Config.Flags.CuffsRequiredForTransport then
        PutInVehicle(initiatorSrc, target)
        return
    end
    if type(DeathService.GetPlayerState) ~= "nil" then
        if DeathService.GetPlayerState(target) then
            PutInVehicle(initiatorSrc, target)
            return
        end
    end
    if bypassCuffCheck then
        PutInVehicle(initiatorSrc, target)
    else
        if not InteractionService.isCuffed(target) then
            Framework.sendNotification(initiatorSrc, _U("CITIZEN_MUST_CUFFED"), "error")
            return false, "TARGET_NEEDS_TO_BE_CUFFED"
        end
        PutInVehicle(initiatorSrc, target)
    end
end

function PutInVehicle(initiatorSrc, targetSrc)
    if InteractionService.isEscorted(targetSrc) then
        InteractionService.removeState(targetSrc, "ESCORT_STATE")
    end
    if InteractionService.isEscorted(initiatorSrc) then
        InteractionService.removeState(initiatorSrc, "ESCORT_STATE")
    end
    ClearPedTasks(GetPlayerPed(initiatorSrc))
    StartClient(targetSrc, "InVehicle")
end

function ActionService.JailPlayer(initiatorSrc, targetSrc)
    local target = IsInDev and initiatorSrc or (targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance))
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if not IsInDev and initiatorSrc == target then return false, "PLAYER_EQUAL_TARGET" end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    StartClient(initiatorSrc, "JailPlayer", target)
end

function ActionService.SentPlayerToCOMS(initiatorSrc, targetSrc)
    local target = targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance)
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if initiatorSrc == target then return false, "PLAYER_EQUAL_TARGET" end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    StartClient(initiatorSrc, "SentToCOMS", target)
end

function ActionService.RenderFine(targetSrc, amount)
    StartClient(targetSrc, "ShowInvoice", amount)
end

function ActionService.RequestSpike(initiatorSrc)
    if not Config.Props.ModelDataByPropType.SPIKES then return end
    if UsedItemsCache[initiatorSrc] then return end
    UsedItemsCache[initiatorSrc] = true
    StartClient(initiatorSrc, "spawnProp", Config.Props.ModelDataByPropType.SPIKES.prop, PROP_TYPES.SPIKES)
end

function ActionService.RequestWheelClamp(initiatorSrc)
    if not Config.Props.ModelDataByPropType.WHEEL_CLAMP then return end
    if UsedItemsCache[initiatorSrc] then return end
    UsedItemsCache[initiatorSrc] = true
    StartClient(initiatorSrc, "spawnProp", Config.Props.ModelDataByPropType.WHEEL_CLAMP.prop, PROP_TYPES.WHEEL_CLAMP)
end

function ActionService.RequestBarrier(initiatorSrc)
    if not Config.Props.ModelDataByPropType.BARRICADE then return end
    if UsedItemsCache[initiatorSrc] then return end
    UsedItemsCache[initiatorSrc] = true
    StartClient(initiatorSrc, "spawnProp", Config.Props.ModelDataByPropType.BARRICADE.prop, PROP_TYPES.BARRICADE)
end

function ActionService.RequestHeadBag(initiatorSrc, targetSrc)
    StartClient(initiatorSrc, "TaskPlayAnim", {
        animDict = "mp_arresting",
        animName = "a_uncuff",
        animFlag = 49,
        time = 2000,
        target = targetSrc
    })
    Wait(2000)
    if InteractionService.isHeadBagged(targetSrc) then
        InteractionService.removeState(targetSrc, "PAPERBAG_STATE")
        Framework.sendNotification(initiatorSrc, _U("PAPER_BAG.INITIATOR_REMOVED_FROM_TARGET"))
    else
        InteractionService.addState(targetSrc, "PAPERBAG_STATE")
        Framework.sendNotification(initiatorSrc, _U("PAPER_BAG.INITIATOR_ADDED_ON_TARGET"))
    end
    StartClient(targetSrc, "spawnProp", "prop_food_bag2", PROP_TYPES.PAPER_BAG)
end

function ActionService.RequestSpeedCamera(initiatorSrc)
    if not Config.Props.ModelDataByPropType.SPEED_RADAR then return end
    if UsedItemsCache[initiatorSrc] then return end
    UsedItemsCache[initiatorSrc] = true
    StartClient(initiatorSrc, "spawnProp", Config.Props.ModelDataByPropType.SPEED_RADAR.prop, PROP_TYPES.SPEED_RADAR)
end

function ActionService.RequestMegaphone(initiatorSrc)
    StartClient(initiatorSrc, "spawnProp", "prop_megaphone_01", PROP_TYPES.MEGA_PHONE)
end

function ActionService.Escort(initiatorSrc, targetSrc, bypassCuffCheck)
    if not Config.Escort.Enable then return end
    local target = targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance)
    if target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if initiatorSrc == target then
        dbg.debug("Escort: You cannot request escort for yourself!")
        return false, "PLAYER_EQUAL_TARGET"
    end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    if InteractionService.isCuffed(initiatorSrc) then return end
    if GetVehiclePedIsIn(GetPlayerPed(target), false) > 0 then
        return false, "INITIATOR_TRIED_ESCORT_TARGET_IN_VEHICLE"
    end
    if GlobalCache and GlobalCache[target] then
        return false, "ESCAPE_SESSION"
    end
    
    if InteractionService.isEscorted(target) then
        if not bypassCuffCheck then
            Framework.sendNotification(initiatorSrc, _U("ESCORT_INITIATOR_PED_REMOVE"), "success")
            Framework.sendNotification(target, _U("ESCORT_TARGET_PED_REMOVE"), "success")
        end
        ClearPedTasks(GetPlayerPed(target))
        StartClient(initiatorSrc, "StopTask")
        InteractionService.removeState(target, "ESCORT_STATE")
        InteractionService.removeState(initiatorSrc, "ESCORT_STATE")
        StartClient(initiatorSrc, "EscortState", false)
    else
        if not bypassCuffCheck then
            Framework.sendNotification(initiatorSrc, _U("ESCORT_INITIATOR"), "success")
            Framework.sendNotification(target, _U("ESCORT_TARGET"), "success")
        end
        StartClient(initiatorSrc, "TaskPlayAnim", {
            animDict = "rcmnigel1d",
            animName = "base_club_shoulder",
            animFlag = 49,
            time = -1
        })
        InteractionService.addState(target, "ESCORT_STATE")
        InteractionService.addState(initiatorSrc, "ESCORT_STATE")
        StartClient(initiatorSrc, "EscortState", true)
    end
    
    StartClient(target, "EscortPlayer", initiatorSrc, {
        initiatorDeath = DeathService.GetPlayerState(initiatorSrc),
        targetDeath = DeathService.GetPlayerState(target)
    })
end

function ActionService.ForceUncuff(targetSrc)
    if not targetSrc then return false, "TARGET_PLAYER_ID_NIL" end
    if not DoesEntityExist(GetPlayerPed(targetSrc)) then return false, "TARGET_PLAYER_ID_OFFLINE" end
    if not InteractionService.isCuffed(targetSrc) then return false, "TARGET_NOT_CUFFED" end
    
    InteractionService.removeState(targetSrc, "CUFF_STATE")
    TriggerEvent("rcore_police:server:sendHeartBeat", nil, targetSrc, "CUFF_STATE", false)
    StartClient(targetSrc, "RemoveCuffs", true, "cuffs")
    return true, "TARGET_CUFFS_REMOVED"
end

function ActionService.RemoveHandcuff(initiatorSrc, targetSrc, bypassItemsCheck)
    return ActionService.Handcuff(initiatorSrc, targetSrc, bypassItemsCheck, "remove_cuff")
end

function ActionService.ZipTies(initiatorSrc, targetSrc, bypassItemsCheck)
    return ActionService.Handcuff(initiatorSrc, targetSrc, bypassItemsCheck, "ziptie")
end

function ActionService.Handcuff(initiatorSrc, targetSrc, bypassItemsCheck, cuffType, A4_2)
    local target = IsInDev and initiatorSrc or (targetSrc or Utils.getClosestPlayers(initiatorSrc, Config.CheckDistance))
    if not IsInDev and initiatorSrc == target then return false, "PLAYER_EQUAL_TARGET" end
    if not IsInDev and target == -1 then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "TARGET_PLAYER_NOT_FOUND"
    end
    if not Utils.IsPlayerNearAnotherPlayer(initiatorSrc, target, Config.CheckDistance + 0.5) then
        Framework.sendNotification(initiatorSrc, _U("NO_CITIZEN_NEARBY"), "error")
        return false, "INITIATOR_AND_TARGET_NOT_IN_DISTANCE"
    end
    if GetVehiclePedIsIn(GetPlayerPed(initiatorSrc), false) > 0 then
        return false, "INITATOR_TRIED_ACTION_FROM_VEHICLE"
    end
    if InteractionService.isEscorted(target) then
        Framework.sendNotification(initiatorSrc, _U("YOU_CANNOT_DO_THAT_WHILE_ESCORTING_PLAYER"), "error")
        return false, "INITIATOR_CANNOT_REMOVE_CUFF_ON_ESCORTED_TARGET"
    end
    
    local reqItem = Items.Handcuffs
    local keyItem = Items.HandcuffsKeys
    local typeStr = "handcuffs"
    if cuffType == "ziptie" then
        reqItem = Items.Zipties
        typeStr = "ziptie"
    end
    
    local state = "NOT_CUFFED"
    local hasCutters = HasPlayerZiptieCutters(initiatorSrc)
    local hasCuffState, cuffData = InteractionService.HasPlayerState(target, "CUFF_STATE")
    
    if InteractionService.isCuffed(target) then
        if hasCuffState and cuffData and cuffData.type == "ziptie" then
            keyItem = hasCutters and hasCutters or Items.ZipTiesCutter
        end
        
        if not InventoryService.hasItem(initiatorSrc, keyItem) and Config.Cuffing.CheckHasItems then
            local label = Config.ItemsLabels[keyItem] or keyItem
            Framework.sendNotification(initiatorSrc, _U("YOU_DONT_HAVE_ITEM_IN_YOUR_INVENTORY", label), "error")
            return false, "INITIATOR_DONT_HAVE_ITEM_IN_INVENTORY"
        end
        if GetVehiclePedIsIn(GetPlayerPed(target), false) > 0 then
            return false, "INITIATOR_TRIED_REMOVE_CUFFS_FROM_TARGET_IN_VEHICLE"
        end
        if not bypassItemsCheck then
            if hasCuffState and cuffData and cuffData.type == "ziptie" then
                Framework.sendNotification(initiatorSrc, _U("ZIPTIES_INITIATOR_REMOVE"), "success")
                Framework.sendNotification(target, _U("ZIPTIES_TARGET_REMOVE"), "success")
            else
                Framework.sendNotification(initiatorSrc, _U("HANDCUFF_INITIATOR_REMOVE"), "success")
                Framework.sendNotification(target, _U("HANDCUFF_TARGET_REMOVE"), "success")
            end
        end
        
        StartClient(initiatorSrc, "TaskPlayAnim", {
            animDict = "mp_arresting",
            animName = "a_uncuff",
            animFlag = 49,
            time = 2000
        })
        
        InteractionService.removeState(target, "CUFF_STATE", typeStr)
        SetTimeout(2000, function()
            if Config.Cuffing.TakeAndReturnItems then
                local returnItem = reqItem
                if cuffData and cuffData.type == "ziptie" then
                    if not Config.Zipties.ReturnZipTies then return end
                    returnItem = Items.Zipties
                end
                InventoryService.addItem(initiatorSrc, returnItem, 1)
            end
        end)
        state = "NOT_CUFFED"
    else
        if cuffType == "remove_cuff" then
            Framework.sendNotification(initiatorSrc, _U("PLAYER_IS_NOT_HANDCUFFED"), "error")
            return false, "IS_NOT_CUFFED"
        end
        
        if not InventoryService.hasItem(initiatorSrc, reqItem) and Config.Cuffing.CheckHasItems then
            local label = Config.ItemsLabels[reqItem] or reqItem
            Framework.sendNotification(initiatorSrc, _U("YOU_DONT_HAVE_ITEM_IN_YOUR_INVENTORY", label), "error")
            return false, "INITIATOR_DONT_HAVE_ITEM_IN_INVENTORY"
        end
        if GetVehiclePedIsIn(GetPlayerPed(target), false) > 0 then
            return false, "INITIATOR_TRIED_CUFF_TARGET_IN_VEHICLE"
        end
        
        if not bypassItemsCheck then
            if typeStr == "ziptie" then
                Framework.sendNotification(initiatorSrc, _U("ZIPTIES_INITIATOR"), "success")
                Framework.sendNotification(target, _U("ZIPTIES_TARGET"), "success")
            else
                Framework.sendNotification(initiatorSrc, _U("HANDCUFF_INITIATOR"), "success")
                Framework.sendNotification(target, _U("HANDCUFF_TARGET"), "success")
            end
        end
        
        StartClient(initiatorSrc, "TaskPlayAnim", {
            animDict = "cuff",
            animFlag = 49,
            target = target
        })
        
        if Config.Cuffing.TakeAndReturnItems then
            InventoryService.removeItem(initiatorSrc, reqItem, 1)
        end
        
        InteractionService.addState(target, "CUFF_STATE", typeStr)
        state = "CUFFED"
    end
    
    local cuffedBool = (state == "CUFFED")
    TriggerEvent("rcore_police:server:sendHeartBeat", initiatorSrc, target, "CUFF_STATE", cuffedBool)
    StartClient(target, "Handcuff", initiatorSrc, cuffType, A4_2)
    return true, state
end
