local function getSelectedPlayer(data)
    if not data then return nil end
    local v = data.Player or data.player or data.id or data.source or data.target or data.targetId or data.playerId
    if type(v) == 'table' then v = v.value or v.id or v.source or v.targetId or v.citizenid end
    return tonumber(v)
end

-- Open Inventory
RegisterNetEvent('mri_Qadmin:client:openInventory', function(_, selectedData)
    if not CheckPerms('qadmin.action.open_inventory') then return end
    local player = getSelectedPlayer(selectedData)

    if Config.Inventory == 'ox_inventory' then
        TriggerEvent("mri_Qadmin:client:CloseUI")
        Wait(150)
        TriggerServerEvent("mri_Qadmin:server:OpenInv", player)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", player)
    end
end)

-- Open Stash
RegisterNetEvent('mri_Qadmin:client:openStash', function(_, selectedData)
    if not CheckPerms('qadmin.action.open_stash') then return end
    local stash = selectedData["Stash"].value

    if Config.Inventory == 'ox_inventory' then
        TriggerServerEvent("mri_Qadmin:server:OpenStash", stash)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "stash", tostring(stash))
        TriggerEvent("inventory:client:SetCurrentStash", tostring(stash))
    end
end)

-- Open Trunk
RegisterNetEvent('mri_Qadmin:client:openTrunk', function(data, selectedData)
    if not CheckPerms('qadmin.action.open_trunk') then return end
    local vehiclePlate = selectedData["Plate"].value

    if Config.Inventory == 'ox_inventory' then
        TriggerServerEvent("mri_Qadmin:server:OpenTrunk", data, vehiclePlate)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "trunk", tostring(vehiclePlate))
        TriggerEvent("inventory:client:SetCurrentStash", tostring(vehiclePlate))
    end
end)

--------------------------------------------------------------------------------
-- NUI Callbacks Bridging
--------------------------------------------------------------------------------

RegisterNUICallback('mri_Qadmin:callback:GetPlayerInventory', function(data, cb)
    local resp = lib.callback.await('mri_Qadmin:callback:GetPlayerInventory', false, data.targetId)
    cb(resp)
end)

RegisterNUICallback('mri_Qadmin:callback:GetVehicleInventory', function(data, cb)
    local resp = lib.callback.await('mri_Qadmin:callback:GetVehicleInventory', false, data.plate, data.type)
    cb(resp)
end)

RegisterNUICallback('mri_Qadmin:server:RemoveInventoryItem', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:RemoveInventoryItem', false, data.targetId, data.item, data.count, data.slot, data.type)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:TransferItemToSelf', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:TransferItemToSelf', false, data.targetId, data.item, data.count, data.slot, data.type)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:CopyInventoryToSelf', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:CopyInventoryToSelf', false, data.targetId, data.type)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:ClearPlayerInventory', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:ClearPlayerInventory', false, data.targetId, data.type)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:GiveInventoryItem', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:GiveInventoryItem', false, data.targetId, data.item, data.count, data.type)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:MoveInventoryItem', function(data, cb)
    local success = lib.callback.await('mri_Qadmin:server:MoveInventoryItem', false, data)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:StartWatchingInventory', function(data, cb)
    local inventoryId = data.type == 'player' and tonumber(data.id) or (data.type == 'trunk' and 'trunk'..data.id or 'glovebox'..data.id)
    local success = lib.callback.await('mri_Qadmin:server:StartWatchingInventory', false, inventoryId)
    cb(success)
end)

RegisterNUICallback('mri_Qadmin:server:StopWatchingInventory', function(data, cb)
    local inventoryId = data.type == 'player' and tonumber(data.id) or (data.type == 'trunk' and 'trunk'..data.id or 'glovebox'..data.id)
    local success = lib.callback.await('mri_Qadmin:server:StopWatchingInventory', false, inventoryId)
    cb(success)
end)

RegisterNetEvent('mri_Qadmin:client:InventoryUpdated', function(inventoryId)
    SendNUIMessage({
        action = 'inventoryUpdate',
        data = {
            inventoryId = inventoryId
        }
    })
end)
