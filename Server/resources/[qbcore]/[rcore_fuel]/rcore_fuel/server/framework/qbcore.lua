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

local QBCore = nil

function Framework.InitQBCore()
    local resourceName = Config.Framework.QB_CORE_NAME or "qb-core"

    -- Try GetCoreObject (QBCore <=2.0 / Qbox shim)
    local ok, result = pcall(function()
        return exports[resourceName]:GetCoreObject()
    end)
    if not (ok and result) then
        ok, result = pcall(function()
            return exports["qb-core"]:GetCoreObject()
        end)
    end
    if ok and result then
        QBCore = result
        print("[rcore_fuel] QBCore initialised via GetCoreObject()")
    else
        -- Try GetSharedObject (QBCore 2.1+ / QBX)
        local ok2, result2 = pcall(function()
            return exports[resourceName]:GetSharedObject()
        end)
        if not (ok2 and result2) then
            ok2, result2 = pcall(function()
                return exports["qb-core"]:GetSharedObject()
            end)
        end
        if ok2 and result2 then
            QBCore = result2
            print("[rcore_fuel] QBCore initialised via GetSharedObject()")
        else
            -- Event-based fallback (works on all versions)
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
            print("[rcore_fuel] QBCore initialised via QBCore:GetObject event (fallback)")
        end
    end

    local function registerItems(core)
        if core and core.Functions and core.Functions.CreateUseableItem then
            core.Functions.CreateUseableItem("vehicle_manual", function(source, item)
                TriggerClientEvent("rcore_fuel:checkFuelType", source)
            end)
            core.Functions.CreateUseableItem("window_cleaner", function(source, item)
                TriggerClientEvent("rcore_fuel:selectVehicleForCleaning", source)
            end)
            core.Functions.CreateUseableItem("fuel_pump", function(source, item)
                TriggerClientEvent("rcore_fuel:selectCarToPumpOut", source)
            end)
        end
    end

    registerItems(QBCore)

    if GetResourceState("qbx_core") == "started" then
        pcall(function()
            exports.qbx_core:CreateUseableItem("vehicle_manual", function(source, item)
                TriggerClientEvent("rcore_fuel:checkFuelType", source)
            end)
            exports.qbx_core:CreateUseableItem("window_cleaner", function(source, item)
                TriggerClientEvent("rcore_fuel:selectVehicleForCleaning", source)
            end)
            exports.qbx_core:CreateUseableItem("fuel_pump", function(source, item)
                TriggerClientEvent("rcore_fuel:selectCarToPumpOut", source)
            end)
        end)
    end
end

function Framework.GetPlayer(source)
    source = tonumber(source)
    if not source then return nil end

    if not QBCore then
        Framework.InitQBCore()
    end

    if QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
        local p = QBCore.Functions.GetPlayer(source)
        if p then return p end
    end

    if GetResourceState("qbx_core") == "started" then
        local ok, p = pcall(function()
            return exports.qbx_core:GetPlayer(source)
        end)
        if ok and p then return p end
    end

    if GetResourceState("qb-core") == "started" then
        local ok, p = pcall(function()
            return exports["qb-core"]:GetPlayer(source)
        end)
        if ok and p then return p end
    end

    return nil
end

function Framework.GetPlayerIdentifier(source)
    source = tonumber(source)
    if not source then return nil end
    local player = Framework.GetPlayer(source)
    if player and player.PlayerData then
        return player.PlayerData.citizenid
    end
    if GetResourceState("qbx_core") == "started" then
        local ok, p = pcall(function()
            return exports.qbx_core:GetPlayer(source)
        end)
        if ok and p and p.PlayerData then
            return p.PlayerData.citizenid
        end
    end
    return nil
end

function Framework.GetMoney(source, moneyType)
    source = tonumber(source)
    if not source then return 0 end

    local account = (moneyType == "cash") and "cash" or "bank"

    -- 1. Direct qbx_core export check first
    if GetResourceState("qbx_core") == "started" then
        local ok, amount = pcall(function()
            return exports.qbx_core:GetMoney(source, account)
        end)
        if ok and type(amount) == "number" then
            -- qbx_core is authoritative when it exposes the account. Do not merge it
            -- with an ox_inventory item balance; treating two ledgers as interchangeable
            -- makes affordability checks disagree with the ledger that gets charged.
            return amount
        end
    end

    -- 2. QBCore player object check
    local player = Framework.GetPlayer(source)
    if player then
        if player.Functions and player.Functions.GetMoney then
            local ok, m = pcall(function()
                return player.Functions.GetMoney(account)
            end)
            if ok and type(m) == "number" then
                return m
            end
        end
        if player.PlayerData and player.PlayerData.money then
            local m = player.PlayerData.money[account]
            if type(m) == "number" then
                return m
            end
        end
    end

    -- 3. Fallback for cash in ox_inventory
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if account == "cash" and invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local cashItem = Config.CashItem or "money"
        local oxCount = exports.ox_inventory:GetItemCount(source, cashItem) or 0
        if oxCount == 0 then
            oxCount = exports.ox_inventory:GetItemCount(source, "money") or 0
        end
        if oxCount == 0 then
            oxCount = exports.ox_inventory:GetItemCount(source, "cash") or 0
        end
        return oxCount
    end

    return 0
end

function Framework.RemoveMoney(source, moneyType, amount)
    source = tonumber(source)
    amount = tonumber(amount)
    if not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return false end
    amount = math.ceil(amount)
    if amount <= 0 then return true end

    local player = Framework.GetPlayer(source)
    local account = (moneyType == "cash") and "cash" or "bank"

    -- 1. Direct qbx_core export:
    -- In Qbox, exports.qbx_core:RemoveMoney authoritatively updates PlayerData.money[account],
    -- triggers QBCore:Player:SetPlayerData to client (which tuff-hud and other HUDs listen to),
    -- triggers QBCore:Client:OnMoneyChange and hud:client:OnMoneyChange,
    -- and automatically syncs ox_inventory:SetItem(source, "money", newBalance).
    if GetResourceState("qbx_core") == "started" then
        local ok, success = pcall(function()
            return exports.qbx_core:RemoveMoney(source, account, amount, "fuel-payment")
        end)
        if ok and success then
            return true
        end
    end

    -- 2. QBCore player object:
    -- In standard QBCore, player.Functions.RemoveMoney updates PlayerData.money,
    -- emits QBCore:Client:OnMoneyChange, and triggers QBCore:Player:SetPlayerData.
    if player and player.Functions and player.Functions.RemoveMoney then
        local ok, success = pcall(function()
            return player.Functions.RemoveMoney(account, amount, "fuel-payment")
        end)
        if ok and success then
            -- The QBCore money API has already completed the transaction. Mirroring the
            -- same amount into ox_inventory here can double-charge setups whose framework
            -- or inventory bridge already synchronizes cash.
            return true
        end
    end

    -- 3. Fallback: if moneyType is cash and ox_inventory is running, remove item directly
    -- and explicitly update player data and emit client HUD events so HUDs (tuff-hud) update immediately.
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if account == "cash" and invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local itemName = Config.CashItem or "money"
        local oxCount = exports.ox_inventory:GetItemCount(source, itemName) or 0
        if oxCount < amount then
            local altCount = exports.ox_inventory:GetItemCount(source, "money") or 0
            if altCount >= amount then
                oxCount = altCount
                itemName = "money"
            else
                altCount = exports.ox_inventory:GetItemCount(source, "cash") or 0
                if altCount >= amount then
                    oxCount = altCount
                    itemName = "cash"
                end
            end
        end

        if oxCount >= amount then
            local ok, removed = pcall(function()
                return exports.ox_inventory:RemoveItem(source, itemName, amount)
            end)
            if ok and removed then
                if player and player.PlayerData and player.PlayerData.money then
                    player.PlayerData.money.cash = math.max(0, (player.PlayerData.money.cash or 0) - amount)
                    TriggerClientEvent("QBCore:Player:SetPlayerData", source, player.PlayerData)
                    TriggerClientEvent("QBCore:Client:OnMoneyChange", source, "cash", amount, "remove", "fuel-payment")
                    TriggerClientEvent("hud:client:OnMoneyChange", source, "cash", amount, true, "fuel-payment")
                end
                return true
            end
        end
    end

    return false
end

function Framework.AddMoney(source, moneyType, amount)
    source = tonumber(source)
    amount = tonumber(amount)
    if not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return false end
    amount = math.ceil(amount)
    if amount <= 0 then return true end

    local player = Framework.GetPlayer(source)
    local account = (moneyType == "cash") and "cash" or "bank"

    -- 1. Direct qbx_core export:
    if GetResourceState("qbx_core") == "started" then
        local ok, success = pcall(function()
            return exports.qbx_core:AddMoney(source, account, amount, "fuel-refund-or-deposit")
        end)
        if ok and success then
            return true
        end
    end

    -- 2. QBCore player object:
    if player and player.Functions and player.Functions.AddMoney then
        local ok, success = pcall(function()
            return player.Functions.AddMoney(account, amount, "fuel-refund-or-deposit")
        end)
        if ok and success then
            -- As above, successful framework mutation is authoritative. Do not also add
            -- an inventory money item and risk crediting the player twice.
            return true
        end
    end

    -- 3. Fallback: if moneyType is cash and ox_inventory is running
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if account == "cash" and invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local ok, added = pcall(function()
            return exports.ox_inventory:AddItem(source, Config.CashItem or "money", amount)
        end)
        if ok and added then
            if player and player.PlayerData and player.PlayerData.money then
                player.PlayerData.money.cash = (player.PlayerData.money.cash or 0) + amount
                TriggerClientEvent("QBCore:Player:SetPlayerData", source, player.PlayerData)
                TriggerClientEvent("QBCore:Client:OnMoneyChange", source, "cash", amount, "add", "fuel-refund-or-deposit")
                TriggerClientEvent("hud:client:OnMoneyChange", source, "cash", amount, false, "fuel-refund-or-deposit")
            end
            return true
        end
    end

    return false
end

function Framework.ShowNotification(source, message, notifyType)
    source = tonumber(source)
    if not source then return end
    notifyType = notifyType or "primary"

    if GetResourceState("qbx_core") == "started" then
        local ok = pcall(function()
            exports.qbx_core:Notify(source, message, notifyType)
        end)
        if ok then return end
    end

    if GetResourceState("ox_lib") == "started" then
        local libType = "info"
        if notifyType == "error" then libType = "error"
        elseif notifyType == "success" then libType = "success" end
        TriggerClientEvent("ox_lib:notify", source, {
            description = message,
            type = libType
        })
        return
    end

    if QBCore then
        TriggerClientEvent("QBCore:Notify", source, message, notifyType)
    end
end

-- FIX 12: was ignoring the amount param entirely (existence-only check), so
-- InventoryBridge.HasItem's documented "at least `amount`" contract was never honored
function Framework.HasItem(source, itemName, amount)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local count = exports.ox_inventory:GetItemCount(source, itemName) or 0
        return count >= amount
    end
    local player = Framework.GetPlayer(source)
    if player and player.Functions and player.Functions.GetItemByName then
        local item = player.Functions.GetItemByName(itemName)
        return item ~= nil and (item.amount or item.count or 0) >= amount
    end
    return false
end

function Framework.RemoveItem(source, itemName, amount)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local success = exports.ox_inventory:RemoveItem(source, itemName, amount)
        return success and true or false
    end
    local player = Framework.GetPlayer(source)
    if player and player.Functions and player.Functions.RemoveItem then
        return player.Functions.RemoveItem(itemName, amount)
    end
    return false
end

function Framework.AddItem(source, itemName, amount)
    amount = amount or 1
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local success = exports.ox_inventory:AddItem(source, itemName, amount)
        return success and true or false
    end
    local player = Framework.GetPlayer(source)
    if player and player.Functions and player.Functions.AddItem then
        return player.Functions.AddItem(itemName, amount)
    end
    return false
end

function Framework.IsBoss(source, jobName)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job
    if not job or job.name ~= jobName then return false end
    -- FIX 10a: QBCore uses job.grade.level, not job.isboss
    -- Boss grades are typically configured in QBCore jobs; grade >= 3 is a common convention
    -- but the most reliable check is the isboss flag stored per grade in the QBCore job config
    if job.isboss ~= nil then
        return job.isboss == true
    end
    -- Fallback: check grade level if isboss not present (older QBCore builds)
    if job.grade and job.grade.level then
        local jobs = QBCore and QBCore.Shared and QBCore.Shared.Jobs
        local jobConfig = jobs and jobs[jobName]
        if jobConfig and jobConfig.grades then
            for gradeLevel, gradeData in pairs(jobConfig.grades) do
                if gradeData.isboss and tonumber(gradeLevel) == tonumber(job.grade.level) then
                    return true
                end
            end
        end
    end
    return false
end

RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function()
    local src = source
    local player = Framework.GetPlayer(src)
    if player then
        TriggerClientEvent("rcore_fuel:PlayerJobUpdated", src)
    end
end)

RegisterNetEvent("QBCore:Server:OnJobUpdate", function(updatedSource, job)
    -- FIX 10b: QBCore passes source as first arg here, not via `source` magic variable
    TriggerClientEvent("rcore_fuel:PlayerJobUpdated", updatedSource)
end)

-- FIX 8: UpdateWeaponMetaData was called in server/main.lua but never defined
function Framework.UpdateWeaponMetaData(source, weaponId, itemId, metadata)
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem
    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local slot = tonumber(itemId) or tonumber(weaponId)
        if slot then
            return pcall(function()
                -- SetMetadata persists ammo and preserves the existing durability
                -- supplied in metadata. Do not overwrite durability with ammo units.
                exports.ox_inventory:SetMetadata(source, slot, metadata)
            end)
        end
        return false
    end
    local player = Framework.GetPlayer(source)
    if not player then return false end
    -- QBCore CORE inventory stores weapon metadata per slot
    -- Update the item metadata so jerry can fill level persists across sessions
    -- FIX 11: exports["core_inventory"] is always truthy (FiveM returns a proxy table for any
    -- resource name whether or not it's running), so this never actually detected the resource --
    -- it would hard-error with "No such export" on servers not running core_inventory, and the
    -- fallback below was unreachable. Use GetResourceState to actually detect it.
    if invSystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local itemKey = itemId or weaponId
        if itemKey == nil then return false end

        local attempts = {
            function() return exports["core_inventory"]:SetItemMetaData(source, itemKey, metadata) end,
            function() return exports["core_inventory"]:setMetadata(source, itemKey, metadata) end,
            function() return exports["core_inventory"]:updateMetadata(source, itemKey, metadata) end,
        }
        for _, attempt in ipairs(attempts) do
            local ok, result = pcall(attempt)
            -- Some CORE builds return nil on success; explicit false is failure. A
            -- successful pcall alone is insufficient because an export may return false
            -- without throwing, which must not authorize the matching vehicle liter.
            if ok and result ~= false then return true end
        end
        return false
    end
    return false
end


-- Capture this implementation before another framework bridge is loaded. FiveM
-- loads every configured bridge file, so relying on the last global definition
-- makes framework behavior depend on fxmanifest ordering.
QBCoreFrameworkImplementation = {
    Init = Framework.InitQBCore,
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
