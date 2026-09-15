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

-- server/fuel_pump/pricing.lua
-- Server-side fuel pump pricing helpers

--- Returns the price per liter for a given fuel type at a given shop.
--- Falls back to the global default if the shop or its gasPrices entry is missing.
---@param shopId string
---@param fuelType string
---@return number
function GetPricePerLiterForShop(shopId, fuelType)
    if shopId and Config.ShopList[shopId] then
        local shopData = Config.ShopList[shopId]
        if shopData.gasPrices and shopData.gasPrices[fuelType] ~= nil then
            local price = tonumber(shopData.gasPrices[fuelType])
            if price and price > 0 then return price end
        end
    end
    return 2.0 -- global fallback
end

--- Returns whether a shop has capacity remaining for a given fuel type.
--- Returns true when capacity tracking is disabled for that type.
---@param shopId string
---@param fuelType string
---@return boolean
function ShopHasCapacity(shopId, fuelType)
    if not shopId or not Config.ShopList[shopId] then
        return true
    end
    local capacity = Config.ShopList[shopId].capacity
    if not capacity or capacity[fuelType] == nil then
        return true
    end
    return (tonumber(capacity[fuelType]) or 0) > 0
end

--- Decrements and persists shop capacity for a given fuel type.
--- Safe to call every fueling tick; DB write is throttled to every 10 liters.
---@param shopId string
---@param fuelType string
---@param litersTanked number  current total liters tanked in this session
function DecrementAndPersistCapacity(shopId, fuelType, litersTanked)
    if not shopId or not Config.ShopList[shopId] then return end
    local shopData = Config.ShopList[shopId]
    if not shopData.capacity or shopData.capacity[fuelType] == nil then return end

    shopData.capacity[fuelType] = math.max(0, (tonumber(shopData.capacity[fuelType]) or 0) - 1)

    -- Persist every 10 liters, but serialize through the same full-row company
    -- queue used by money/owner changes. Independent async UPDATE snapshots can
    -- otherwise complete out of order and restore stale capacity/money.
    if litersTanked % 10 == 0 then
        PersistCapacityNow(shopId)
    end
end

--- Final capacity persist called when a fueling session ends.
---@param shopId string
function PersistCapacityNow(shopId)
    if not shopId or not Config.ShopList[shopId] then return false end
    local shopData = Config.ShopList[shopId]
    if not shopData.capacity then return false end

    if type(PersistCompanyNow) == "function" then
        return PersistCompanyNow(shopId) == true
    end

    -- Compatibility fallback for unusual custom load orders. The stock resource
    -- defines PersistCompanyNow before gameplay starts, so normal operation uses
    -- the serialized path above.
    MySQL.Async.execute(
        "UPDATE rcore_fuel_companies SET capacity = @capacity WHERE shopId = @shopId",
        {
            ["@capacity"] = json.encode(shopData.capacity),
            ["@shopId"]   = shopId
        }
    )
    return true
end
