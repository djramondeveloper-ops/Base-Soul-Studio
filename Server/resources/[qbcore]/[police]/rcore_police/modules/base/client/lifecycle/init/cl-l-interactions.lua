-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 371 lines → Cleaned: 89 lines
-- =====================================================

RegisterNetEvent("rcore_police:client:syncStorage", function(storageData)
    InteractionService.updateStorage(storageData)
end)

RegisterNetEvent("rcore_police:client:syncSpecificStorage", function(playerId, data, key)
    InteractionService.updateStorageSpecific(playerId, data, key)
end)

NetworkService.RegisterNetEvent("StopTask", function(success)
    if not success then return end
    
    local ped = PlayerPedId()
    if IsActiveAnimGlobally and next(IsActiveAnimGlobally) then
        local dict = IsActiveAnimGlobally.dict
        local name = IsActiveAnimGlobally.name
        if IsEntityPlayingAnim(ped, dict, name, 3) then
            StopEntityAnim(ped, dict, name, 1.0)
        end
        IsActiveAnimGlobally = nil
        ClearPedTasksImmediately(ped)
        SetTimeout(100, function()
            ClearPedTasksImmediately(ped)
        end)
        dbg.debug("Stopped active anim.")
    else
        ClearPedTasksImmediately(ped)
    end
end)

NetworkService.RegisterNetEvent("TaskPlayAnim", function(success, animData)
    if not success then return end
    
    local ped = PlayerPedId()
    local dict = animData.animDict
    local name = animData.animName
    local flag = animData.animFlag or 49
    local duration = animData.time or 2000
    
    if dict == "cuff" then
        local position = UtilsService.IsPlayerInFrontOrBehind(animData.target, true)
        if position == "front" then
            dict = "mp_arresting"
            name = "a_uncuff"
            duration = 2000
        else
            dict = "mp_arrest_paired"
            name = "cop_p3_fwd"
            duration = 500
        end
        Interactions.RunCuffPre("officer")
        SetTimeout(0, function() Sounds.PlayHandcuff() end)
    elseif name == "a_uncuff" then
        SetTimeout(0, function() Sounds.PlayUncuff() end)
    end
    
    UtilsService.LoadAnimationDict(dict)
    TaskPlayAnim(ped, dict, name, 8.0, -8, -1, flag, 0, false, false, false)
    IsActiveAnimGlobally = { state = true, dict = dict, name = name }
    
    if duration == -1 then return end
    Wait(duration)
    ClearPedTasksImmediately(ped)
    IsActiveAnimGlobally = nil
end)

NetworkService.RegisterNetEvent("RemoveCuffs", function(success, cuffData, targetData)
    if success then
        Interactions.RemoveCuffs(targetData, cuffData)
    end
end)

NetworkService.RegisterNetEvent("Handcuff", function(success, cuffData, targetData, removeData)
    if not success then return end
    dbg.debug("Cuff state: %s", Interactions.Cuff.TARGET_PLAYER_CUFF_STATE)
    
    if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE then
        return Interactions.RemoveCuffs(removeData, targetData)
    end
    Interactions.SetCitizenCuffs(cuffData, targetData)
end)

NetworkService.RegisterNetEvent("EscortPlayer", function(success, escortData, targetData)
    if success then
        Interactions.SetCitizenEscort(escortData, targetData)
    end
end)

NetworkService.RegisterNetEvent("JailPlayer", function(success, jailData)
    if success then
        SentPlayerToPrison(jailData)
    end
end)

NetworkService.RegisterNetEvent("SentToCOMS", function(success, data)
    if success then
        SentPlayerToCOMS(data)
    end
end)

NetworkService.RegisterNetEvent("InVehicle", function(success)
    if success then
        Interactions.PutPlayerInVehicle()
    end
end)

NetworkService.RegisterNetEvent("FromVehicle", function(success, vehicleData, seatData)
    if success then
        Interactions.TakePlayerFromVehicle(vehicleData, seatData)
    end
end)

NetworkService.RegisterNetEvent("TacklePlayer", function(success, tackleData)
    if success then
        TacklePlayer(tackleData)
    end
end)

NetworkService.RegisterNetEvent("TackleCuffPlayer", function(success, data)
    if success then
        TackleCuffPlayer(data)
    end
end)

NetworkService.RegisterNetEvent("TackleRemove", function(success, data)
    if success then
        TackleReset(data, false)
    end
end)

NetworkService.RegisterNetEvent("PunchSync", function(success, punchData, extraData)
    if success then
        PunchSync(punchData, extraData)
    end
end)

NetworkService.RegisterNetEvent("SearchPlayer", function(success, targetId, searchData)
    if not success then return end
    
    targetId = tonumber(targetId)
    if Config.Inventory == Inventory.ESX then
        ShowPlayerInventory(targetId, searchData)
    else
        OpenPlayerInventory(targetId)
    end
end)
