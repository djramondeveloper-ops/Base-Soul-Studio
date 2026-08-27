-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-props.lua
--  Engineered by Eazy Fxap
--  Original: 632 lines → Cleaned: 198 lines
-- =====================================================

local ObjectPool = {}
local RemovingProps = {}

AddEventHandler("rcore_police:server:playerUnloaded", function(src)
    if not src then return end
    
    if next(RemovingProps) then
        for propId, propData in pairs(RemovingProps) do
            if propData.initiator == src then
                RemovingProps[propId] = nil
                break
            end
        end
    end
end)

AddEventHandler("rcore_police:server:playerLoaded", function(src)
    if not src then return end
    
    if next(ObjectPool) then
        StartClient(src, "SyncObjectPoolForUser", ObjectPool)
    end
end)

RegisterNetEvent("rcore_police:server:requestSpeedCameraFine", function(propId, entityNetId)
    local src = source
    local prop = ObjectPool[propId]
    if not prop then return end
    
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    local fineAmount = prop.fine
    
    dbg.debug("Speed camera: Requesting speed camera fine for user %s (%s)", GetPlayerName(src), src)
    
    if DoesEntityExist(entity) and fineAmount then
        local speed = GetEntitySpeed(entity)
        local plate = GetVehicleNumberPlateText(entity)
        local ped = GetPlayerPed(src)
        
        local seatIndex = -1
        if SEAT_INDEXES and SEAT_INDEXES.DRIVER_SEAT then
            seatIndex = SEAT_INDEXES.DRIVER_SEAT
        end
        
        if GetPedInVehicleSeat(entity, seatIndex) ~= ped then
            return dbg.debug("Speed camera: Ignoring player named %s (%s) since user is not driver of vehicle but passenger.", GetPlayerName(src), src)
        end
        
        if Config.Props.SpeedCamera.IgnoreFineForDepartments then
            local job = Framework.getJob(src)
            if job and job.name then
                local jobNameLower = job.name:lower()
                if Config.Props.SpeedCamera.IgnoreJobList[jobNameLower] then
                    dbg.debug("Speed camera: Disabled fine for player named %s with playerId %s since part of department group!", GetPlayerName(src), src)
                    return
                end
            end
        end
        
        dbg.debug("Speed camera: Using invoice mode: %s", Config.Props.SpeedCamera.InvoiceMode)
        
        local invoiceData = {}
        if prop.job then
            invoiceData.job = prop.job
        end
        invoiceData.issuer = prop.issuer
        
        if Config.Props.SpeedCamera.InvoiceMode == 1 then
            dbg.debug("Speed camera: Using direct invoice to player with playerId: %s", src)
            Framework.sendNotification(src, _U("SPEED_RADAR.RECEIVED_FINE", fineAmount, _U("CURRENCY_SYMBOL"), math.floor(getVehicleSpeed(speed))), "success")
            CreateInvoiceToPlayerInVehicle(src, src, fineAmount, invoiceData)
        elseif Config.Props.SpeedCamera.InvoiceMode == 2 then
            dbg.debug("Speed camera: Using direct to owner of player vehicle with plate: %s", plate)
            CreateOfflineInvoiceForVehicle(plate, fineAmount, math.floor(getVehicleSpeed(speed)), prop.issuer)
        else
            dbg.debug("Speed camera: Using direct invoice to player with playerId: %s fallback", src)
            Framework.sendNotification(src, _U("SPEED_RADAR.RECEIVED_FINE", fineAmount, _U("CURRENCY_SYMBOL"), math.floor(getVehicleSpeed(speed))), "success")
            CreateInvoiceToPlayerInVehicle(src, src, fineAmount, invoiceData)
        end
        
        StartClient(src, "RenderVehicleFlash", propId)
    end
end)

RegisterNetEvent("rcore_police:server:deployProp", function(propData)
    local src = source
    if not propData then return end
    
    local hadUsedItem = UsedItemsCache[src]
    if hadUsedItem then
        UsedItemsCache[src] = nil
    end
    
    if next(ObjectPool) then
        if checkIfPlaceOccupied(src, ObjectPool) then
            Framework.sendNotification(src, _U("PROPS.CANNOT_PLACE_ON_ANOTHER_OBJECT"), "error")
            return
        end
    end
    
    local propTypeData = Config.Props.ModelDataByPropType[propData.type]
    local itemName = propTypeData and propTypeData.itemName or propData.type
    
    if Config.Props.CheckHasItem and itemName then
        if not InventoryService.hasItem(src, itemName, 1) then
            return Framework.sendNotification(src, _U("PROPS.YOU_DONT_HAVE_ITEM_IN_INVENTORY", itemName), "error")
        end
    end
    
    local propId = #ObjectPool + 1
    ObjectPool[propId] = propData
    
    local job = Framework.getJob(src)
    if job then
        propData.job = job.name or nil
    end
    propData.issuer = tonumber(Framework.getIdentifier(src)) or 0
    
    Utils.Log("Objects", ("Player named %s (%s) (%s) placed object %s at coords: %s"):format(
        Framework.getCharacterShortName(src),
        Framework.getIdentifier(src),
        source,
        propData.type,
        propData.pos
    ))
    
    StartClient(-1, "syncObjectPool", propId, propData)
    
    if hadUsedItem and itemName then
        if Config.Props.TakeItemWhenPlacingProp then
            InventoryService.removeItem(src, itemName, 1)
        end
    end
end)

RegisterNetEvent("rcore_police:server:resetPropDeployState", function(propId)
    local src = source
    if not propId then return end
    
    local removingProp = RemovingProps[propId]
    if not removingProp then return end
    
    if removingProp.initiator == src then
        dbg.debug("Pool was restarted for user named %s", GetPlayerName(src))
        RemovingProps[propId] = nil
    end
end)

RegisterNetEvent("rcore_police:server:requestRemoveProp", function(propId, propType)
    local src = source
    if not propId then return end
    
    if RemovingProps[propId] then
        return Framework.sendNotification(src, _U("PROPS.ALREADY_PICKING_UP"), "error")
    end
    
    if not ObjectPool[propId] then return end
    
    local propTypeData = Config.Props.ModelDataByPropType[propType]
    if propTypeData and propTypeData.needItem then
        if not InventoryService.hasItem(src, propTypeData.needItem) then
            Framework.sendNotification(src, _U("PROPS.OBJECT_REQUIRES_ITEM_FOR_PICKUP", propTypeData.needItemLabel or propTypeData.needItem), "error")
            return
        end
    end
    
    RemovingProps[propId] = { initiator = src }
    StartClient(src, "StartRemovingPropTask", propId, propType)
end)

RegisterNetEvent("rcore_police:server:removePropDeploy", function(propId, propType)
    local src = source
    if not propId then return end
    
    local propData = ObjectPool[propId]
    if propData then
        local propTypeData = Config.Props.ModelDataByPropType[propType]
        
        if RemovingProps[propId] then
            RemovingProps[propId] = nil
        end
        
        if propTypeData and propTypeData.needItem then
            if not InventoryService.hasItem(src, propTypeData.needItem) then
                Framework.sendNotification(src, _U("PROPS.OBJECT_REQUIRES_ITEM_FOR_PICKUP", propTypeData.needItemLabel or propTypeData.needItem), "error")
                return
            end
        end
        
        table.remove(ObjectPool, propId)
        StartClient(-1, "syncObjectPool", propId, nil)
        
        if propTypeData and Config.Props.ReturnItemWhenRemoveProp and propTypeData.itemName then
            InventoryService.addItem(src, propTypeData.itemName, 1)
        end
        
        Framework.sendNotification(src, _U("PROPS.OBJECT_PICKED_UP"), "success")
    end
end)

RegisterNetEvent("rcore_police:server:unregisterDeploy", function()
    local src = source
    if UsedItemsCache[src] then
        UsedItemsCache[src] = nil
    end
end)

function checkIfPlaceOccupied(playerSrc, pool)
    local isOccupied = false
    if pool and next(pool) then
        local ped = GetPlayerPed(playerSrc)
        local pCoords = GetEntityCoords(ped)
        
        for _, propData in pairs(pool) do
            local distance = #(propData.pos - pCoords)
            local checkDist = Config.Props.DistanceBetweenProps
            
            if propData.type == PROP_TYPES.WHEEL_CLAMP then
                checkDist = Config.Props.DistanceBetweenWheelClamp
            end
            
            if distance <= checkDist then
                isOccupied = true
                break
            end
        end
    end
    return isOccupied
end
