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

function PushScaleformData(scaleformData)
  if scaleformData.FuelPump then
    DuiMessage(scaleformData.duiObj, {
      type = "fuelData",
      fuelData = scaleformData.fuelData,
    })

    DuiMessage(scaleformData.duiObj, {
      type = "translation",
      fuel = true,
      notOpenMessage = _U("closed"),
      outOfStockMessage = _U("empty"),
    })

    for fuelIndex, fuelEntry in pairs(scaleformData.fuelData or {}) do
      local shopConfig = Config.ShopList and Config.ShopList[scaleformData.identifier]
      -- FIX 5: shopConfig.capacity may be nil for shops without capacity tracking;
      -- treat nil capacity as unlimited (always in stock)
      local shopCapacity = shopConfig and shopConfig.capacity
      local fuelCapacity = shopCapacity and shopCapacity[fuelEntry.fuelType]
      local inStock = (fuelCapacity == nil) or (fuelCapacity >= 1)
      DuiMessage(scaleformData.duiObj, {
        type = "stock",
        index = fuelIndex - 1,
        inStock = inStock,
      })
    end

    local shopConfig = Config.ShopList and Config.ShopList[scaleformData.identifier]
    DuiMessage(scaleformData.duiObj, {
      type = "openstatus",
      open = (shopConfig and shopConfig.open ~= false) and true or false,
    })
    for _, key in ipairs({ "activeFuel", "lerpAmount", "update_cost", "fuelingVisibility" }) do
      local message = scaleformData.duiState and scaleformData.duiState[key]
      if message then DuiMessage(scaleformData.duiObj, message) end
    end
  end

  if scaleformData.tanker then
    local stockList = {}
    local shopConfig = Config.ShopList and Config.ShopList[scaleformData.identifier]

    if shopConfig and shopConfig.capacity then
      for fuelType, currentCapacity in pairs(shopConfig.capacity) do
        local maxCapacity = shopConfig.maxCapacity and shopConfig.maxCapacity[fuelType]
        -- FIX 8: guard against nil or zero maxCapacity (division by zero)
        local pct = 0
        if maxCapacity and maxCapacity > 0 then
          pct = (currentCapacity / maxCapacity) * 100
        end
        table.insert(stockList, {
          name = _U(fuelType),
          value = pct,
          currentCapacity = currentCapacity,
          maxCapacity = maxCapacity or 0,
        })
      end
    end

    DuiMessage(scaleformData.duiObj, {
      type = "update_value",
      stockList = stockList,
    })
  end
end

function RefreshScaleformByIdentifier(identifier)
  for _, scaleformData in pairs(ScaleformCache) do
    if scaleformData.identifier == identifier and scaleformData.duiLoaded then
      PushScaleformData(scaleformData)
    end
  end
end

function RefreshAllScaleformData()
  for _, scaleformData in pairs(ScaleformCache) do
    if scaleformData.duiLoaded then
      PushScaleformData(scaleformData)
    end
  end
end

local pendingDuiObjects = {}

function UpdateScaleformData(data)
  if type(data) ~= "table" or type(data.url) ~= "string" or data.url == "" then
    return
  end

  local identifierNumber = tonumber(data.identifier)
  if not identifierNumber then return end

  for cacheKey, scaleformData in pairs(ScaleformCache) do
    if identifierNumber ~= scaleformData.identifierNumber and identifierNumber ~= cacheKey then
      goto continue
    end

    SetDUILink(scaleformData.duiObj, data.url .. "?identifier=" .. identifierNumber)
    pendingDuiObjects[identifierNumber] = scaleformData.duiObj
    break

    ::continue::
  end
end

RegisterNUICallback("realDuiLoaded", function(data, callback)
  local identifierNumber = type(data) == "table" and tonumber(data.identifier) or nil
  if not identifierNumber then
    if callback then callback("invalid") end
    return
  end

  for cacheKey, scaleformData in pairs(ScaleformCache) do
    if identifierNumber ~= scaleformData.identifierNumber and identifierNumber ~= cacheKey then
      goto continue
    end

    -- A pooled browser can finish an old navigation after its pump was unloaded.
    if not scaleformData.scaleformLoaded or scaleformData.destroying then goto continue end
    scaleformData.duiLoaded = true
    PushScaleformData(scaleformData)
    break

    ::continue::
  end

  if callback then
    callback("ok")
  end
end)

RegisterNUICallback("duiHasLoaded", function(data, callback)
  UpdateScaleformData(data)

  if callback then
    callback("ok")
  end
end)
