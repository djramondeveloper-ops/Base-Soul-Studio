-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL OX INVENTORY BRIDGE
-- Quando ox_inventory estiver iniciado e UsingOxInventory=true, a API vRP passa a falar com OX.
-----------------------------------------------------------------------------------------------------------------------------------------
local function oxReady()
    return UsingOxInventory and GetResourceState("ox_inventory") == "started"
end

local function normalizeItem(item)
    return Seoul and Seoul.NormalizeItem and Seoul.NormalizeItem(item) or item
end

local function src(passport)
    return vRP.Source(parseInt(passport))
end

local function toVrpInventory(oxInv)
    local result = {}
    if oxInv and oxInv.items then
        for slot, data in pairs(oxInv.items) do
            if data and data.name then
                result[tostring(data.slot or slot)] = {
                    item = data.name,
                    amount = data.count or data.amount or 0,
                    metadata = data.metadata
                }
            end
        end
    end
    return result
end

local _Inventory = vRP.Inventory
local _GenerateItem = vRP.GenerateItem
local _GiveItem = vRP.GiveItem
local _TakeItem = vRP.TakeItem
local _RemoveItem = vRP.RemoveItem
local _ItemAmount = vRP.ItemAmount
local _InventoryItemAmount = vRP.InventoryItemAmount
local _InventoryWeight = vRP.InventoryWeight
local _GetWeight = vRP.GetWeight
local _CheckWeight = vRP.CheckWeight
local _ClearInventory = vRP.ClearInventory

function vRP.Inventory(Passport)
    if oxReady() then
        local source = src(Passport)
        if source then return toVrpInventory(exports.ox_inventory:GetInventory(source)) end
        return {}
    end
    return _Inventory(Passport)
end

function vRP.ItemAmount(Passport, Item)
    Item = normalizeItem(Item)
    if oxReady() then
        local source = src(Passport)
        if source then return exports.ox_inventory:GetItem(source, Item, nil, true) or 0 end
        return 0
    end
    return _ItemAmount(Passport, Item)
end

function vRP.InventoryItemAmount(Passport, Item)
    Item = normalizeItem(Item)

    if oxReady() then
        local source = src(Passport)
        if not source then
            return { 0, "" }
        end

        local itemSplit = SplitOne and SplitOne(Item) or tostring(Item):match("^[^-]+") or Item
        local inventory = exports.ox_inventory:GetInventory(source)

        if inventory and inventory.items then
            for slot, data in pairs(inventory.items) do
                if data and data.name then
                    local itemName = data.name
                    local currentSplit = SplitOne and SplitOne(itemName) or tostring(itemName):match("^[^-]+") or itemName

                    if itemSplit == currentSplit then
                        return {
                            data.count or data.amount or 0,
                            itemName,
                            data.slot or slot
                        }
                    end
                end
            end
        end

        return { 0, "" }
    end

    return _InventoryItemAmount(Passport, Item)
end

function vRP.GenerateItem(Passport, Item, Amount, Notify, Slot, Metadata)
    Item = normalizeItem(Item)
    Amount = parseInt(Amount)
    if oxReady() then
        local source = src(Passport)
        if source and Amount > 0 then
            return exports.ox_inventory:AddItem(source, Item, Amount, Metadata, Slot)
        end
        return false
    end
    return _GenerateItem(Passport, Item, Amount, Notify, Slot)
end

function vRP.GiveItem(Passport, Item, Amount, Notify, Slot, Metadata)
    Item = normalizeItem(Item)
    Amount = parseInt(Amount)
    if oxReady() then
        local source = src(Passport)
        if source and Amount > 0 then
            return exports.ox_inventory:AddItem(source, Item, Amount, Metadata, Slot)
        end
        return false
    end
    return _GiveItem(Passport, Item, Amount, Notify, Slot)
end

function vRP.TakeItem(Passport, Item, Amount, Notify, Slot, Metadata)
    Item = normalizeItem(Item)
    Amount = parseInt(Amount, true)

    if oxReady() then
        local source = src(Passport)
        if not source or Amount <= 0 then
            return false
        end

        local itemName = SplitOne and SplitOne(Item) or tostring(Item):match("^[^-]+") or Item
        local slotNumber = Slot and tonumber(Slot) or nil
        local removed = false
        local response

        if slotNumber then
            removed, response = exports.ox_inventory:RemoveItem(source, itemName, Amount, Metadata, slotNumber)

            if not removed then
                local slotData = exports.ox_inventory:GetSlot(source, slotNumber)
                if slotData and slotData.name and (slotData.name == itemName or (SplitOne and SplitOne(slotData.name) == itemName)) then
                    removed, response = exports.ox_inventory:RemoveItem(source, slotData.name, Amount, slotData.metadata, slotData.slot)
                end
            end
        else
            removed, response = exports.ox_inventory:RemoveItem(source, itemName, Amount, Metadata)
        end

        if not removed and Notify then
            print(("^3[Seoul][OX]^7 Falha ao remover item %sx %s do Passport %s slot %s: %s"):format(Amount, tostring(itemName), tostring(Passport), tostring(Slot), tostring(response)))
        end

        return removed and true or false
    end

    return _TakeItem(Passport, Item, Amount, Notify, Slot, Metadata)
end

function vRP.RemoveItem(Passport, Item, Amount, Notify, Slot, Metadata)
    Item = normalizeItem(Item)
    if oxReady() then return vRP.TakeItem(Passport, Item, Amount, Notify, Slot, Metadata) end
    return _RemoveItem(Passport, Item, Amount, Notify)
end

function vRP.CheckWeight(Passport, Item, Amount, Metadata)
    Item = normalizeItem(Item)
    if oxReady() then
        local source = src(Passport)
        if source then return exports.ox_inventory:CanCarryItem(source, Item, parseInt(Amount), Metadata) end
        return false
    end
    return _CheckWeight(Passport, Item, Amount)
end

function vRP.InventoryWeight(Passport)
    if oxReady() then
        local source = src(Passport)
        local inv = source and exports.ox_inventory:GetInventory(source)
        return inv and ((inv.weight or 0) / 1000) or 0
    end
    return _InventoryWeight(Passport)
end

function vRP.GetWeight(Passport, Ignore)
    if oxReady() then
        local source = src(Passport)
        local inv = source and exports.ox_inventory:GetInventory(source)
        return inv and ((inv.maxWeight or 0) / 1000) or (_GetWeight(Passport, Ignore) or 0)
    end
    return _GetWeight(Passport, Ignore)
end

function vRP.ClearInventory(Passport, Ignore)
    if oxReady() then
        local source = src(Passport)
        if source then return exports.ox_inventory:ClearInventory(source) end
        return false
    end
    return _ClearInventory(Passport, Ignore)
end

-- lower aliases reamarrados após override
vRP.getInventory = vRP.Inventory
vRP.getInventoryItemAmount = function(user_id, item) return vRP.ItemAmount(user_id, item) end
vRP.giveInventoryItem = function(user_id, item, amount, notify, slot, metadata) return vRP.GenerateItem(user_id, item, amount, notify, slot, metadata) end
vRP.tryGetInventoryItem = function(user_id, item, amount, slot, notify, metadata) return vRP.TakeItem(user_id, item, amount, notify, slot, metadata) end
vRP.removeInventoryItem = function(user_id, item, amount, slot, notify, metadata) return vRP.TakeItem(user_id, item, amount, notify, slot, metadata) end
vRP.computeInvWeight = vRP.InventoryWeight

CreateThread(function()
    Wait(1000)
    if UsingOxInventory and GetResourceState("ox_inventory") == "missing" then
        print("^3[Seoul]^7 UsingOxInventory=true, mas ox_inventory não foi encontrado. Coloque ox_inventory em [Scripts] ou desligue UsingOxInventory.")
    elseif UsingOxInventory then
        if tostring(GetConvar("seoul:debug", "false")):lower() == "true" then print("^2[Seoul]^7 OX Inventory bridge ativo.") end
    end
end)
