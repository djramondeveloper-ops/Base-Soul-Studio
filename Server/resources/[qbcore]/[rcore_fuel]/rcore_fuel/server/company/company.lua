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

PendingFuelMissions = PendingFuelMissions or {}

local function IsRealCompanyOwner(identifier)
    return identifier ~= nil and identifier ~= false and identifier ~= "" and identifier ~= "none"
end

local function FindOnlineSourceByIdentifier(identifier)
    if not IsRealCompanyOwner(identifier) then return nil end
    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        if src and Framework.GetPlayerIdentifier(src) == identifier then
            return src
        end
    end
    return nil
end

local function FiniteNumber(value)
    local n = tonumber(value)
    if not n or n ~= n or n == math.huge or n == -math.huge then return nil end
    return n
end

local function ShopSupportsFuelType(shopData, fuelType)
    if not shopData then return false end
    fuelType = FiniteNumber(fuelType)
    if not fuelType then return end
    fuelType = math.floor(fuelType)
    return (shopData.gasPrices and shopData.gasPrices[fuelType] ~= nil)
        or (shopData.capacity and shopData.capacity[fuelType] ~= nil)
        or (shopData.maxCapacity and shopData.maxCapacity[fuelType] ~= nil)
end

local function CompanyDataAvailable()
    return type(IsRCoreFuelCompanyDataReady) ~= "function" or IsRCoreFuelCompanyDataReady() == true
end

local function PlayerNearCompanyMarker(src, shopData, purchaseMarker)
    if not shopData then return false end
    local marker = purchaseMarker and shopData.buyCompanyMarker or shopData.companyMenuMarkerPos
    if not marker then return false end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - marker) <= 12.0
end

local function RollCompanyFuelPrice(priceData)
    if type(priceData) ~= "table" then return nil end

    local minPrice = tonumber(priceData.min)
    local maxPrice = tonumber(priceData.max)
    if not minPrice or not maxPrice then
        return tonumber(priceData.current)
    end

    if maxPrice < minPrice then
        minPrice, maxPrice = maxPrice, minPrice
    end

    local value = minPrice + (math.random() * (maxPrice - minPrice))
    return math.floor(value * 100 + 0.5) / 100
end

local function EnsureCompanyFuelPrices(forceReroll)
    for _, priceData in pairs(Config.CompanyGasPrices or {}) do
        if forceReroll or tonumber(priceData.current) == nil then
            priceData.current = RollCompanyFuelPrice(priceData)
        end
    end
end

function GetCompanyFuelPrice(fuelType)
    EnsureCompanyFuelPrices(false)
    local priceData = Config.CompanyGasPrices and Config.CompanyGasPrices[fuelType]
    return priceData and tonumber(priceData.current) or nil
end

function GetPendingFuelMission(missionId)
    return missionId and PendingFuelMissions[missionId] or nil
end

function FindPendingFuelMissionByWorker(workerSource)
    workerSource = tonumber(workerSource)
    local currentIdentifier = nil
    if workerSource and GetPlayerName(workerSource) then
        currentIdentifier = Framework.GetPlayerIdentifier(workerSource)
    end

    for missionId, mission in pairs(PendingFuelMissions) do
        if tonumber(mission.workerSource) == workerSource then
            -- If this source is currently occupied, require the same stable framework
            -- identity. If it is disconnected (playerDropped cleanup), source matching
            -- is still sufficient to find and clear the abandoned mission.
            if currentIdentifier and mission.workerIdentifier
                and currentIdentifier ~= mission.workerIdentifier then
                -- Source ID was reused by a different player; keep looking.
            else
                return missionId, mission
            end
        end
    end
    return nil, nil
end

function ClearPendingFuelMission(missionId)
    local mission = PendingFuelMissions[missionId]
    if not mission then return nil end

    local shopData = Config.ShopList and Config.ShopList[mission.shopId]
    if mission.finalFuelActive == true then
        TriggerClientEvent("rcore_fuel:startFinalTankerSound", -1, false, mission.shopId, nil)
        mission.finalFuelActive = false
        mission.finalFuelStartedAt = nil
    end
    if shopData and (shopData.isMissionRunning == missionId or shopData.isMissionRunning == true) then
        shopData.isMissionRunning = nil
        TriggerClientEvent("rcore_fuel:updateConfig", -1, {
            [mission.shopId] = { isMissionRunning = false, capacity = shopData.capacity }
        })
    end

    PendingFuelMissions[missionId] = nil
    return mission
end

local CompanyPurchaseLocks = {}
local CompanyBuyerLocks = {}
local StockPurchaseLocks = {}

CreateThread(function()
    EnsureCompanyFuelPrices(true)
    TriggerClientEvent("rcore_fuel:syncCompanyGasPrice", -1, Config.CompanyGasPrices)

    while true do
        Wait(60 * 60 * 1000)
        EnsureCompanyFuelPrices(true)
        TriggerClientEvent("rcore_fuel:syncCompanyGasPrice", -1, Config.CompanyGasPrices)
    end
end)

RegisterServerCallback("rcore_fuel:buyCompany", function(source, cb, paymentType, shopId)
    if type(IsRCoreFuelCompanyDataReady) == "function" and not IsRCoreFuelCompanyDataReady() then
        cb(false)
        return
    end

    local playerIdentifier = Framework.GetPlayerIdentifier(source)
    if not playerIdentifier then cb(false) return end
    -- FIX 8a: validate paymentType
    if paymentType ~= "cash" and paymentType ~= "bank" then cb(false) return end

    local shopData = Config.ShopList[shopId]
    if not shopData or shopData.EnableBuyingCompany ~= true or shopData.for_sale ~= true then
        cb(false)
        return
    end
    if not PlayerNearCompanyMarker(source, shopData, true) then
        cb(false)
        return
    end
    if CompanyPurchaseLocks[shopId] or CompanyBuyerLocks[playerIdentifier] then
        cb(false)
        return
    end
    -- Lock both the station and buyer identity. A per-shop lock alone lets one player
    -- race purchases for two different stations and make both handlers observe the same
    -- pre-purchase owned-company count, bypassing MaximumOwnedCompanyPerPlayer.
    CompanyPurchaseLocks[shopId] = true
    CompanyBuyerLocks[playerIdentifier] = true
    local function finishPurchase(result)
        CompanyPurchaseLocks[shopId] = nil
        CompanyBuyerLocks[playerIdentifier] = nil
        cb(result == true)
    end

    local previousOwner = IsRealCompanyOwner(shopData.owner_identifier) and shopData.owner_identifier or nil
    if previousOwner == playerIdentifier then
        finishPurchase(false)
        return
    end

    -- Player-owned companies can be listed for resale. Because framework money
    -- APIs only operate safely on online players, require the seller online before
    -- accepting the buyer's payment rather than silently destroying sale proceeds.
    local sellerSource = previousOwner and FindOnlineSourceByIdentifier(previousOwner) or nil
    if previousOwner and not sellerSource then
        Framework.ShowNotification(source, "The current owner must be online to complete this sale.", "error")
        finishPurchase(false)
        return
    end

    -- FIX 6: enforce MaximumOwnedCompanyPerPlayer limit (was never checked)
    local maxOwned = Config.MaximumOwnedCompanyPerPlayer
    if maxOwned and maxOwned > 0 then
        local ownedCount = 0
        for _, sd in pairs(Config.ShopList) do
            if sd.owner_identifier == playerIdentifier then
                ownedCount = ownedCount + 1
            end
        end
        if ownedCount >= maxOwned then
            finishPurchase(false)
            return
        end
    end

    local price = math.max(0, math.floor(tonumber(shopData.price) or 100000))
    if Framework.GetMoney(source, paymentType) < price then
        Framework.ShowNotification(source, "You do not have enough money to buy this company.")
        finishPurchase(false)
        return
    end

    local success = Framework.RemoveMoney(source, paymentType, price)
    if not success then
        Framework.ShowNotification(source, "Failed to process payment.")
        finishPurchase(false)
        return
    end

    if sellerSource then
        local paidSeller = Framework.AddMoney(sellerSource, "bank", price)
        if not paidSeller then
            Framework.AddMoney(source, paymentType, price)
            Framework.ShowNotification(source, "The seller could not receive payment; your purchase was refunded.", "error")
            finishPurchase(false)
            return
        end
        Framework.ShowNotification(sellerSource, string.format("Your fuel company sold for $%d.", price), "success")
    end

    -- Ownership changes invalidate any delivery requested by the previous owner.
    local runningMissionId = shopData.isMissionRunning
    local runningMission = runningMissionId and GetPendingFuelMission(runningMissionId) or nil
    if runningMission then
        local workerSource = tonumber(runningMission.workerSource)
        local sameWorker = workerSource and GetPlayerName(workerSource)
            and (not runningMission.workerIdentifier
                or Framework.GetPlayerIdentifier(workerSource) == runningMission.workerIdentifier)
        if sameWorker then
            TriggerClientEvent("rcore_fuel:forceMissionCancelled", workerSource)
            Framework.ShowNotification(workerSource, "The station was sold; your fuel-delivery mission was cancelled.")
            UnregisterDriver(workerSource)
        end
        ClearPendingFuelMission(runningMissionId)
    end

    shopData.owner_identifier = playerIdentifier
    shopData.for_sale = false
    shopData.open = true

    PersistCompanyNow(shopId)

    local changes = {}
    changes[shopId] = {
        owner_identifier = playerIdentifier,
        for_sale = false,
        open = true
    }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
    finishPurchase(true)
end)

RegisterNetEvent("rcore_fuel:setSellStatus", function(shopId, isForSale, sellPrice)
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.EnableBuyingCompany ~= true or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    local newForSale = isForSale == true or isForSale == 1
    local newPrice = shopData.price

    -- Validate first, mutate second. The old order flipped the in-memory for_sale
    -- flag before validating the requested price, so an invalid price could still
    -- leave the station purchasable at its previous price until the next restart.
    if sellPrice ~= nil then
        local parsedSell = FiniteNumber(sellPrice)
        local minSell = Config.MinimumPriceOfGasStation or Config.MinCompanyPrice or 10000
        local maxSell = Config.MaxCompanyPrice or 2147483647
        if parsedSell and parsedSell >= minSell and parsedSell <= maxSell then
            newPrice = math.floor(parsedSell)
        else
            Framework.ShowNotification(src, string.format(
                "Invalid sale price. Must be between $%d and $%d.", minSell, maxSell))
            return
        end
    end

    shopData.for_sale = newForSale
    shopData.price = newPrice

    PersistCompanyNow(shopId)

    local changes = {}
    changes[shopId] = {
        for_sale = shopData.for_sale,
        price = shopData.price
    }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
end)

RegisterNetEvent("rcore_fuel:setOpenStatus", function(shopId, isOpen)
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    shopData.open = isOpen == true or isOpen == 1

    PersistCompanyNow(shopId)

    local changes = {}
    changes[shopId] = {
        open = shopData.open
    }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
end)

RegisterNetEvent("rcore_fuel:setFuelPrice", function(shopId, newPrice, fuelType)
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    -- Only configured fuel grades may be repriced. Without this check a modified
    -- client can inject arbitrary keys into the persisted gasPrices JSON.
    if not shopData.gasPrices then return end
    fuelType = FiniteNumber(fuelType)
    if not fuelType then return end
    fuelType = math.floor(fuelType)
    if shopData.gasPrices[fuelType] == nil then return end

    -- FIX 7a: validate price is a positive number within configured bounds
    local parsedPrice = FiniteNumber(newPrice)
    local minPrice = FiniteNumber(Config.MinFuelPrice) or 0.01
    local maxPrice = FiniteNumber(Config.MaxFuelPrice) or 100.0
    local lockedMax = Config.LockedFuelPrice and FiniteNumber(Config.LockedFuelPrice[fuelType])
    if lockedMax and lockedMax > 0 then
        maxPrice = math.min(maxPrice, lockedMax)
    end
    if not parsedPrice or parsedPrice < minPrice or parsedPrice > maxPrice then
        Framework.ShowNotification(src, string.format("Invalid price. Must be between $%.2f and $%.2f.", minPrice, maxPrice))
        return
    end
    shopData.gasPrices[fuelType] = parsedPrice

    PersistCompanyNow(shopId)

    local changes = {}
    changes[shopId] = {
        gasPrices = shopData.gasPrices
    }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
end)

RegisterNetEvent("rcore_fuel:depositMoney", function(shopId, moneyType, amount)
    -- FIX 8b: validate moneyType
    if moneyType ~= "cash" and moneyType ~= "bank" then return end
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    amount = math.floor(FiniteNumber(amount) or 0)
    if amount <= 0 then return end

    if Framework.GetMoney(src, moneyType) < amount then
        Framework.ShowNotification(src, "You do not have enough money.")
        return
    end
    if not Framework.RemoveMoney(src, moneyType, amount) then
        Framework.ShowNotification(src, "Failed to process the deposit.")
        return
    end
    shopData.money = (shopData.money or 0) + amount
    PersistCompanyNow(shopId)
    local changes = {}
    changes[shopId] = { money = shopData.money }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
    TriggerClientEvent("rcore_fuel:refreshMoneyManagementMenu", src, shopData.money)
end)

RegisterNetEvent("rcore_fuel:withDrawMoney", function(shopId, moneyType, amount)
    -- FIX 8c: validate moneyType
    if moneyType ~= "cash" and moneyType ~= "bank" then return end
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    -- FIX 22: match depositMoney's FIX 3 -- floor the amount to prevent the same
    -- fractional-amount exploit (this shares the exact same money-in/money-out
    -- shape depositMoney does, but was missing the floor)
    amount = math.floor(FiniteNumber(amount) or 0)
    if amount <= 0 then return end

    if (shopData.money or 0) >= amount then
        -- Deduct from the shop first, then credit the player. Framework.AddMoney
        -- returns an explicit success value; restore the shop balance on failure.
        shopData.money = shopData.money - amount
        if not Framework.AddMoney(src, moneyType, amount) then
            shopData.money = shopData.money + amount
            Framework.ShowNotification(src, "Failed to process the withdrawal.")
            return
        end

        PersistCompanyNow(shopId)

        local changes = {}
        changes[shopId] = { money = shopData.money }
        TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
        TriggerClientEvent("rcore_fuel:refreshMoneyManagementMenu", src, shopData.money)
    end
end)

RegisterNetEvent("rcore_fuel:setEmployeeStatus", function(shopId, status)
    local src = source
    if not CompanyDataAvailable() then return end
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    local shopData = Config.ShopList[shopId]

    if not shopData or shopData.owner_identifier ~= playerIdentifier then
        return
    end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    shopData.fuel_only_employee = status == true or status == 1

    PersistCompanyNow(shopId)

    local changes = {}
    changes[shopId] = {
        fuel_only_employee = shopData.fuel_only_employee
    }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
end)

-- FIX 2: rcore_fuel:fetchCompanyGasPrice was called by client on load but had no server handler.
-- Without this, Config.CompanyGasPrices on the client is never populated, so company-specific
-- fuel prices are never applied to the pump display or billing calculations.
RegisterNetEvent("rcore_fuel:fetchCompanyGasPrice", function()
    local src = source
    _G.rcoreFuelConfigSyncCooldown = _G.rcoreFuelConfigSyncCooldown or {}
    local now = GetGameTimer()
    local last = _G.rcoreFuelConfigSyncCooldown[src]
    if last and now - last < 3000 then return end
    _G.rcoreFuelConfigSyncCooldown[src] = now

    EnsureCompanyFuelPrices(false)
    TriggerClientEvent("rcore_fuel:syncCompanyGasPrice", src, Config.CompanyGasPrices)
end)

-- FIX 1: rcore_fuel:BuyFuelStock - no server handler existed.
-- Called when owner buys fuel stock directly (Config.SkipMissionForFuelType = true).
-- Deducts money, validates capacity, then increments the shop's fuel capacity and persists.
RegisterNetEvent("rcore_fuel:BuyFuelStock", function(shopId, fuelType, liters, cashType)
    local src = source
    if not CompanyDataAvailable() then return end

    -- FIX 30: rate-limit stock purchases. This protects against accidental double clicks
    -- and event spam clients attempting repeated supplier withdrawals.
    _G.rcoreFuelStockPurchaseCooldown = _G.rcoreFuelStockPurchaseCooldown or {}
    local now = os.time()
    if (_G.rcoreFuelStockPurchaseCooldown[src] or 0) > now - 3 then return end
    _G.rcoreFuelStockPurchaseCooldown[src] = now

    -- Validate inputs
    if cashType ~= "cash" and cashType ~= "bank" and cashType ~= "society" then return end
    if not shopId or fuelType == nil or not liters then return end
    fuelType = FiniteNumber(fuelType)
    if not fuelType then return end
    fuelType = math.floor(fuelType)
    -- FIX 2: clamp liters to prevent negative or absurdly large purchases
    liters = FiniteNumber(liters) or 0
    if liters <= 0 or liters > 10000 then return end

    local shopData = Config.ShopList[shopId]
    if not shopData or not ShopSupportsFuelType(shopData, fuelType) then return end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    local skipMissionAllowed = false
    for _, allowedFuelType in pairs(Config.SkipMissionForFuelType or {}) do
        if allowedFuelType == fuelType then
            skipMissionAllowed = true
            break
        end
    end
    if not skipMissionAllowed then
        Framework.ShowNotification(src, "This fuel type must be restocked through a delivery mission.")
        return
    end

    -- Serialize stock purchases per station/fuel type. The per-player cooldown above
    -- does not stop two authorized players from both reading the same free capacity,
    -- paying, and then overfilling the tank.
    local stockLockKey = tostring(shopId) .. ":" .. tostring(fuelType)
    if StockPurchaseLocks[stockLockKey] then
        Framework.ShowNotification(src, "A fuel stock purchase is already being processed for this tank.")
        return
    end

    local stockLockToken = {}
    StockPurchaseLocks[stockLockKey] = stockLockToken
    local function releaseStockPurchaseLock()
        if StockPurchaseLocks[stockLockKey] == stockLockToken then
            StockPurchaseLocks[stockLockKey] = nil
        end
    end

    -- Safety net for unexpected framework/export failures that interrupt the handler.
    SetTimeout(15000, releaseStockPurchaseLock)

    local currentCapacity = (shopData.capacity and tonumber(shopData.capacity[fuelType])) or 0
    local maxCapacity = shopData.maxCapacity and tonumber(shopData.maxCapacity[fuelType])
    if maxCapacity then
        local missingCapacity = math.max(0, math.floor(maxCapacity - currentCapacity))
        if missingCapacity <= 0 then
            Framework.ShowNotification(src, "This fuel tank is already full.")
            releaseStockPurchaseLock()
            return
        end
        liters = math.min(math.floor(liters), missingCapacity)
    else
        liters = math.floor(liters)
    end

    -- Must be the shop owner or society boss. Preserve this stable identity because
    -- ESX society withdrawal can yield while waiting for addon-account; a numeric FiveM
    -- source may be recycled during that wait.
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then
        releaseStockPurchaseLock()
        return
    end
    if shopData.owner_identifier ~= identifier then
        if not (shopData.EnableSociety and Framework.IsBoss(src, shopData.Job)) then
            Framework.ShowNotification(src, "You are not authorised to buy fuel stock for this station.")
            releaseStockPurchaseLock()
            return
        end
    end

    -- Calculate cost using CompanyGasPrices
    local pricePerLiter = GetCompanyFuelPrice(fuelType)
    if not pricePerLiter or pricePerLiter <= 0 then
        Framework.ShowNotification(src, "Fuel supplier price is unavailable. Try again shortly.")
        releaseStockPurchaseLock()
        return
    end
    local totalCost = math.max(1, math.floor(pricePerLiter * liters + 0.5))

    -- Fix 1: "society" cashType uses the company/society fund, not the player's wallet
    -- FIX 16: re-check EnableSociety here -- the client only offers this option when
    -- it's true, but a shop *owner* skips the EnableSociety branch in the authorisation
    -- check above entirely, so a spoofed client could still request "society" payment
    -- on a shop that doesn't have the feature enabled
    if cashType == "society" then
        if not shopData.EnableSociety then
            Framework.ShowNotification(src, "This station doesn't support society payments.")
            releaseStockPurchaseLock()
            return
        end
        local withdrawn = Society.Withdraw(shopData.Job, totalCost)
        if not withdrawn then
            if Framework.GetPlayerIdentifier(src) == identifier then
                Framework.ShowNotification(src, "The company doesn't have enough funds.")
            end
            releaseStockPurchaseLock()
            return
        end
    else
        if Framework.GetMoney(src, cashType) < totalCost then
            Framework.ShowNotification(src, "You don't have enough money to buy this fuel stock.")
            releaseStockPurchaseLock()
            return
        end
        if not Framework.RemoveMoney(src, cashType, totalCost) then
            Framework.ShowNotification(src, "Payment failed while buying fuel stock.")
            releaseStockPurchaseLock()
            return
        end
    end

    -- Add to capacity
    if not shopData.capacity then shopData.capacity = {} end
    shopData.capacity[fuelType] = (shopData.capacity[fuelType] or 0) + liters

    -- Persist before releasing the lock so a following purchase sees committed capacity.
    PersistCapacityNow(shopId)
    releaseStockPurchaseLock()

    if Framework.GetPlayerIdentifier(src) == identifier then
        Framework.ShowNotification(src, string.format(
            "Purchased %d liters of %s for $%d.", liters, tostring(GetFuelLabelByType(fuelType) or fuelType), totalCost))
    end

    -- Sync update to all clients
    local changes = {}
    changes[shopId] = { capacity = shopData.capacity }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)
end)

-- FIX 2: rcore_fuel:OwnerSelectedForRefuel - no server handler existed.
-- Called when an owner selects a nearby worker player to run a fuel delivery mission.
-- Sends the mission request to the selected worker and marks the shop as mission-running.
RegisterNetEvent("rcore_fuel:OwnerSelectedForRefuel", function(workerSource, workerName, shopId, liters, fuelType, cashType)
    local src = source
    if not CompanyDataAvailable() then return end
    workerSource = FiniteNumber(workerSource)
    if workerSource then workerSource = math.floor(workerSource) end
    liters = math.floor(FiniteNumber(liters) or 0)
    fuelType = FiniteNumber(fuelType)
    if fuelType then fuelType = math.floor(fuelType) end

    if cashType ~= "cash" and cashType ~= "bank" and cashType ~= "society" then return end
    if not shopId or fuelType == nil or liters <= 0 or liters > 10000 or not workerSource then return end
    if tonumber(workerSource) == tonumber(src) then
        Framework.ShowNotification(src, "You cannot assign a delivery mission to yourself.")
        return
    end

    local shopData = Config.ShopList[shopId]
    if not shopData or not ShopSupportsFuelType(shopData, fuelType) then return end
    if not PlayerNearCompanyMarker(src, shopData, false) then return end

    for _, skipFuelType in pairs(Config.SkipMissionForFuelType or {}) do
        if skipFuelType == fuelType then
            Framework.ShowNotification(src, "This fuel type does not require a delivery mission.")
            return
        end
    end

    local identifier = Framework.GetPlayerIdentifier(src)
    if shopData.owner_identifier ~= identifier then
        if not (shopData.EnableSociety and Framework.IsBoss(src, shopData.Job)) then
            Framework.ShowNotification(src, "You are not authorised to request a refuel mission.")
            return
        end
    end

    if cashType == "society" and not shopData.EnableSociety then
        Framework.ShowNotification(src, "This station doesn't support society payments.")
        return
    end

    if shopData.isMissionRunning then
        Framework.ShowNotification(src, "A mission is already running for this station.")
        return
    end

    if not GetPlayerName(workerSource) then
        Framework.ShowNotification(src, "That player is no longer available.")
        return
    end
    local workerIdentifier = Framework.GetPlayerIdentifier(workerSource)
    if not workerIdentifier then
        Framework.ShowNotification(src, "That player's framework identity is not ready yet.")
        return
    end

    local existingMissionId = FindPendingFuelMissionByWorker(workerSource)
    if existingMissionId then
        Framework.ShowNotification(src, "That player already has a pending fuel mission.")
        return
    end

    -- The client only shows nearby players, but validate proximity again server-side.
    local ownerPed = GetPlayerPed(src)
    local workerPed = GetPlayerPed(workerSource)
    if ownerPed == 0 or workerPed == 0
        or #(GetEntityCoords(ownerPed) - GetEntityCoords(workerPed)) > 15.0 then
        Framework.ShowNotification(src, "That player is too far away.")
        return
    end

    local pricePerLiter = GetCompanyFuelPrice(fuelType)
    if not pricePerLiter or pricePerLiter <= 0 then
        Framework.ShowNotification(src, "Fuel supplier price is unavailable. Try again shortly.")
        return
    end

    local currentCapacity = (shopData.capacity and tonumber(shopData.capacity[fuelType])) or 0
    local maxCapacity = (shopData.maxCapacity and tonumber(shopData.maxCapacity[fuelType]))
    if maxCapacity then
        local missingCapacity = math.max(0, math.floor(maxCapacity - currentCapacity))
        if missingCapacity <= 0 then
            Framework.ShowNotification(src, "This fuel tank is already full.")
            return
        end
        liters = math.min(liters, missingCapacity)
    end

    local totalCost = math.max(1, math.floor(pricePerLiter * liters + 0.5))
    if cashType ~= "society" and Framework.GetMoney(src, cashType) < totalCost then
        Framework.ShowNotification(src, "You don't have enough money for this fuel delivery.")
        return
    end

    local missionId = tostring(shopId) .. "_" .. tostring(GetGameTimer())
    PendingFuelMissions[missionId] = {
        missionId = missionId,
        ownerSource = src,
        ownerIdentifier = identifier,
        workerSource = workerSource,
        workerIdentifier = workerIdentifier,
        shopId = shopId,
        liters = liters,
        fuelType = fuelType,
        cashType = cashType,
        pricePerLiter = pricePerLiter,
        accepted = false,
        createdAt = os.time(),
    }
    shopData.isMissionRunning = missionId
    TriggerClientEvent("rcore_fuel:updateConfig", -1, {
        [shopId] = { isMissionRunning = missionId }
    })

    local actualWorkerName = GetPlayerName(workerSource) or workerName or tostring(workerSource)
    Framework.ShowNotification(src, string.format("Mission request sent to %s.", actualWorkerName))

    local fuelData = {
        fuelType = fuelType,
        fuelToTank = liters,
        cashType = cashType,
        shopId = shopId,
    }
    local requestText = string.format(
        "Fuel delivery mission: %d liters of %s to station %s. Accept?",
        liters, tostring(GetFuelLabelByType(fuelType) or fuelType), tostring(shopId))

    TriggerClientEvent("rcore_fuel:showFuelRequest", workerSource, requestText, missionId)
    TriggerClientEvent("rcore_fuel:prepareMissionData", workerSource, missionId, fuelData)
end)

-- FIX v8: cleanup transient server cooldown state when players leave.
-- Prevents stale source IDs accumulating after reconnects.
AddEventHandler("playerDropped", function()
    local src = source
    if _G.rcoreFuelStockPurchaseCooldown then
        _G.rcoreFuelStockPurchaseCooldown[src] = nil
    end
    if _G.rcoreFuelConfigSyncCooldown then
        _G.rcoreFuelConfigSyncCooldown[src] = nil
    end
end)
