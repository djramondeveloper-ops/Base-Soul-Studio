--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

local ESX = nil

function Framework.InitESX()
    if ESX then return end

    if GetResourceState(Config.Framework.ES_EXTENDED_NAME or "es_extended") == "started" then
        local ok, sharedObject = pcall(function()
            return exports[Config.Framework.ES_EXTENDED_NAME or "es_extended"]:getSharedObject()
        end)
        if ok and sharedObject then ESX = sharedObject end
    end

    if not ESX then
        TriggerEvent(Config.Framework.ESX_SHARED_OBJECT or "esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end

    if not ESX then
        print("^1[rcore_fuel] ESX is selected but es_extended could not be initialized.^7")
        return
    end

    if ESX.RegisterUsableItem then
        ESX.RegisterUsableItem("vehicle_manual", function(source)
            TriggerClientEvent("rcore_fuel:checkFuelType", source)
        end)
        ESX.RegisterUsableItem("window_cleaner", function(source)
            TriggerClientEvent("rcore_fuel:selectVehicleForCleaning", source)
        end)
        ESX.RegisterUsableItem("fuel_pump", function(source)
            TriggerClientEvent("rcore_fuel:selectCarToPumpOut", source)
        end)
    end
end

function Framework.GetPlayer(source)
    source = tonumber(source)
    if not source then return nil end
    if not ESX then Framework.InitESX() end
    if ESX and ESX.GetPlayerFromId then
        return ESX.GetPlayerFromId(source)
    end
    return nil
end

function Framework.GetPlayerIdentifier(source)
    local player = Framework.GetPlayer(source)
    if not player then return nil end
    if player.getIdentifier then
        local ok, identifier = pcall(function() return player.getIdentifier() end)
        if ok and identifier then return identifier end
    end
    return player.identifier
end

function Framework.GetMoney(source, moneyType)
    local player = Framework.GetPlayer(source)
    if not player then return 0 end

    if moneyType == "bank" then
        if player.getAccount then
            local account = player.getAccount("bank")
            return account and tonumber(account.money) or 0
        end
        return 0
    end

    if player.getMoney then
        return tonumber(player.getMoney()) or 0
    end
    return tonumber(player.money) or 0
end

function Framework.RemoveMoney(source, moneyType, amount)
    amount = tonumber(amount)
    if not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return false end
    amount = math.ceil(amount)
    if amount <= 0 then return true end
    local player = Framework.GetPlayer(source)
    if not player or Framework.GetMoney(source, moneyType) < amount then return false end

    if moneyType == "bank" then
        if not player.removeAccountMoney then return false end
        local ok = pcall(function() player.removeAccountMoney("bank", amount, "rcore_fuel") end)
        return ok
    end

    if not player.removeMoney then return false end
    local ok = pcall(function() player.removeMoney(amount, "rcore_fuel") end)
    return ok
end

function Framework.AddMoney(source, moneyType, amount)
    amount = tonumber(amount)
    if not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return false end
    amount = math.ceil(amount)
    if amount <= 0 then return true end
    local player = Framework.GetPlayer(source)
    if not player then return false end

    if moneyType == "bank" then
        if not player.addAccountMoney then return false end
        local ok = pcall(function() player.addAccountMoney("bank", amount, "rcore_fuel") end)
        return ok
    end

    if not player.addMoney then return false end
    local ok = pcall(function() player.addMoney(amount, "rcore_fuel") end)
    return ok
end

function Framework.ShowNotification(source, message, notifyType)
    local player = Framework.GetPlayer(source)
    if player and player.showNotification then
        player.showNotification(message)
    else
        TriggerClientEvent("esx:showNotification", source, message)
    end
end

function Framework.HasItem(source, itemName, amount)
    amount = math.max(1, math.floor(tonumber(amount) or 1))
    local player = Framework.GetPlayer(source)
    if not player or not player.getInventoryItem then return false end
    local item = player.getInventoryItem(itemName)
    return item and (tonumber(item.count) or 0) >= amount or false
end

function Framework.RemoveItem(source, itemName, amount)
    amount = math.max(1, math.floor(tonumber(amount) or 1))
    local player = Framework.GetPlayer(source)
    if not player or not player.removeInventoryItem or not Framework.HasItem(source, itemName, amount) then return false end
    local ok = pcall(function() player.removeInventoryItem(itemName, amount) end)
    return ok
end

function Framework.AddItem(source, itemName, amount)
    amount = math.max(1, math.floor(tonumber(amount) or 1))
    local player = Framework.GetPlayer(source)
    if not player or not player.addInventoryItem then return false end
    if player.canCarryItem and not player.canCarryItem(itemName, amount) then return false end
    local ok = pcall(function() player.addInventoryItem(itemName, amount) end)
    return ok
end

function Framework.IsBoss(source, jobName)
    local player = Framework.GetPlayer(source)
    local job = player and player.job
    if not job or job.name ~= jobName then return false end
    return job.grade_name == "boss" or job.grade_name == "owner"
end

function Framework.UpdateWeaponMetaData(source, weaponId, itemId, metadata)
    if Config.InventorySystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local slot = tonumber(itemId) or tonumber(weaponId)
        if slot then
            return pcall(function()
                -- SetMetadata persists ammo and preserves the existing durability
                -- supplied in metadata. Do not overwrite durability with ammo units.
                exports.ox_inventory:SetMetadata(source, slot, metadata)
            end)
        end
    elseif Config.InventorySystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local itemKey = itemId or weaponId
        if itemKey ~= nil then
            -- core_inventory metadata belongs to the inventory backend, not ESX.
            -- Supporting it here keeps the authoritative jerry-can transaction usable
            -- on ESX + CORE instead of silently failing every metadata acknowledgement.
            local attempts = {
                function() return exports.core_inventory:SetItemMetaData(source, itemKey, metadata) end,
                function() return exports.core_inventory:setMetadata(source, itemKey, metadata) end,
                function() return exports.core_inventory:updateMetadata(source, itemKey, metadata) end,
            }
            for _, attempt in ipairs(attempts) do
                local ok, result = pcall(attempt)
                if ok and result ~= false then return true end
            end
        end
    end
    return false
end

ESXFrameworkImplementation = {
    Init = Framework.InitESX,
    GetPlayer = Framework.GetPlayer,
    GetPlayerIdentifier = Framework.GetPlayerIdentifier,
    GetMoney = Framework.GetMoney,
    RemoveMoney = Framework.RemoveMoney,
    AddMoney = Framework.AddMoney,
    ShowNotification = Framework.ShowNotification,
    HasItem = Framework.HasItem,
    RemoveItem = Framework.RemoveItem,
    AddItem = Framework.AddItem,
    IsBoss = Framework.IsBoss,
    UpdateWeaponMetaData = Framework.UpdateWeaponMetaData,
}
