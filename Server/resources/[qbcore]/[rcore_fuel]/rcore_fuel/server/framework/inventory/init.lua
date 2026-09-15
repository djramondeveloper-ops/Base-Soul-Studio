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

-- server/framework/inventory/init.lua
-- Inventory sync bridge: routes item operations through the active inventory system.

InventoryBridge = {}

--- Give an item to a player.
---@param src      number
---@param itemName string
---@param amount   number
---@param metadata table|nil
---@return boolean success
function InventoryBridge.AddItem(src, itemName, amount, metadata)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    local lowerName = string.lower(tostring(itemName or ""))
    if (lowerName == "weapon_petrolcan" or lowerName == "weapon_petrolcan_empty") and metadata == nil then
        if Config.JerryCanStartsFull ~= false then
            metadata = { ammo = 100, durability = 100 }
        else
            metadata = { ammo = 0, durability = 0 }
        end
    end

    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local success = exports.ox_inventory:AddItem(src, itemName, amount, metadata)
        return success and true or false
    end
    if invSystem == Inventory.QS and GetResourceState("qs-inventory") == "started" then
        return exports['qs-inventory']:AddItem(src, itemName, amount, metadata)
    end
    if invSystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local ok, success = pcall(function()
            return exports['core_inventory']:addItem(src, itemName, amount, metadata)
        end)
        -- Current core_inventory documents addItem as boolean. Treat nil as failure
        -- instead of turning a non-committed/unknown result into a successful purchase.
        return ok and success == true
    end
    return Framework.AddItem(src, itemName, amount)
end

--- Remove an item from a player.
---@param src      number
---@param itemName string
---@param amount   number
---@return boolean success
function InventoryBridge.RemoveItem(src, itemName, amount)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local success = exports.ox_inventory:RemoveItem(src, itemName, amount)
        return success and true or false
    end
    if invSystem == Inventory.QS and GetResourceState("qs-inventory") == "started" then
        return exports['qs-inventory']:RemoveItem(src, itemName, amount)
    end
    if invSystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local ok, success = pcall(function()
            return exports['core_inventory']:removeItem(src, itemName, amount)
        end)
        -- removeItem has the same explicit boolean contract.
        return ok and success == true
    end
    return Framework.RemoveItem(src, itemName, amount)
end

--- Check if a player has at least `amount` of an item.
---@param src      number
---@param itemName string
---@param amount   number
---@return boolean
function InventoryBridge.HasItem(src, itemName, amount)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local count = exports.ox_inventory:GetItemCount(src, itemName) or 0
        return count >= amount
    end
    if invSystem == Inventory.QS and GetResourceState("qs-inventory") == "started" then
        local count = exports['qs-inventory']:GetItemTotalAmount(src, itemName) or 0
        return count >= amount
    end
    if invSystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local ok, hasItem = pcall(function()
            return exports['core_inventory']:hasItem(src, itemName, amount)
        end)
        return ok and hasItem == true
    end
    return Framework.HasItem(src, itemName, amount)
end

-- Inventory mutation is intentionally server-only. Exposing AddItem/RemoveItem as
-- net events lets any client grant or delete arbitrary items from its own inventory.
-- Keep the bridge functions callable by trusted server code only.

RegisterServerCallback("rcore_fuel:inventory:hasItem", function(source, cb, itemName, amount)
    if type(itemName) ~= "string" or itemName == "" or #itemName > 100 then
        cb(false)
        return
    end
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 or amount > 10000 then
        cb(false)
        return
    end
    cb(InventoryBridge.HasItem(source, itemName, amount))
end)

-- Window cleaner is intentionally not consumed by the inventory's normal use action.
-- Remove exactly one only after the client finishes the complete cleaning sequence.
RegisterNetEvent("rcore_fuel:consumeWindowCleaner", function()
    local src = source
    if not src or src <= 0 then return end

    if InventoryBridge.HasItem(src, "window_cleaner", 1) then
        InventoryBridge.RemoveItem(src, "window_cleaner", 1)
    end
end)

