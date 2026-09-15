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

local ItemPurchaseCooldown = {}
local ITEM_PURCHASE_COOLDOWN_MS = 1500

local function IsPlayerNearItemShop(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end

    local coords = GetEntityCoords(ped)
    for _, shopPosition in pairs(Config.ItemShopPosition or {}) do
        if #(coords - shopPosition) <= 5.0 then
            return true
        end
    end

    return false
end

RegisterNetEvent("rcore_fuel:buyItem", function(key, paymentType)
    local src = source

    if not Config.EnableItemShop or not IsPlayerNearItemShop(src) then
        return
    end

    if paymentType ~= "cash" and paymentType ~= "bank" then
        Framework.ShowNotification(src, "Invalid payment type.")
        return
    end

    key = tonumber(key) or key
    local itemData = Config.ItemShopItems[key]
    if not itemData or not itemData.item then
        return
    end

    local now = GetGameTimer()
    local lastPurchase = ItemPurchaseCooldown[src]
    if lastPurchase and now - lastPurchase < ITEM_PURCHASE_COOLDOWN_MS then
        return
    end
    ItemPurchaseCooldown[src] = now

    local price = math.max(0, math.floor(tonumber(itemData.price) or 1000))
    if Framework.GetMoney(src, paymentType) < price then
        Framework.ShowNotification(src, "You do not have enough money!")
        return
    end

    -- Charge first. The old flow granted the item before checking whether the
    -- money removal actually succeeded, which could produce free items.
    if not Framework.RemoveMoney(src, paymentType, price) then
        Framework.ShowNotification(src, "Payment failed!")
        return
    end

    local itemAdded = InventoryBridge.AddItem(src, itemData.item, 1)
    if not itemAdded then
        -- Roll the charge back if the inventory is full or the item is invalid.
        Framework.AddMoney(src, paymentType, price)
        Framework.ShowNotification(src, "Cannot carry this item (inventory full or item invalid)!")
        return
    end

    Framework.ShowNotification(src, string.format("You bought %s for $%d.", itemData.label or itemData.item, price))
end)


AddEventHandler("playerDropped", function()
    ItemPurchaseCooldown[source] = nil
end)
