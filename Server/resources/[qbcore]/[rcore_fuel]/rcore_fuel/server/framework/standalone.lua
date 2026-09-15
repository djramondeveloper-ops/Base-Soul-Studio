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

function Framework.InitStandalone()
end

function Framework.GetPlayer(source)
    return nil
end

function Framework.GetPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.find(id, "license:") then
            return id
        end
    end
    return "license:standalone_" .. source
end

function Framework.GetMoney(source, moneyType)
    return 1000000
end

function Framework.RemoveMoney(source, moneyType, amount)
    return true
end

function Framework.AddMoney(source, moneyType, amount)
    return true
end

function Framework.ShowNotification(source, message)
    TriggerClientEvent("chat:addMessage", source, {
        args = { "[rcore_fuel]", message }
    })
end

function Framework.HasItem(source, itemName)
    return true
end

function Framework.RemoveItem(source, itemName, amount)
    return true
end

function Framework.AddItem(source, itemName, amount)
    return true
end

function Framework.IsBoss(source, jobName)
    return true
end

-- Standalone framework may still use a supported inventory backend.
function Framework.UpdateWeaponMetaData(source, weaponId, itemId, metadata)
    if Config.InventorySystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local slot = tonumber(itemId) or tonumber(weaponId)
        if not slot then return false end
        local ok, result = pcall(function()
            return exports.ox_inventory:SetMetadata(source, slot, metadata)
        end)
        return ok and result ~= false
    end

    if Config.InventorySystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local itemKey = itemId or weaponId
        if itemKey == nil then return false end
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

    return false
end

StandaloneFrameworkImplementation = {
    Init = Framework.InitStandalone,
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
