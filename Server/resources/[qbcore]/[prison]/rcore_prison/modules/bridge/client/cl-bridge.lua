local enabledBridgeChecks = {
  Database = true,
  Framework = true,
  Inventories = true,
  Cloth = true,
  Dispatches = true,
  Menus = true,
  Notifies = true,
  Interactions = true,
  TextUI = true,
  Map = true
}

local orderedBridgeKeys = {
  TextUI = {
    "RCORE",
    "OX",
    "OKOK",
    "ESX",
    "QBCORE",
    "NONE"
  },
  Framework = {
    "QBCore",
    "ESX",
    "QBOX",
    "NDCore",
    "NONE"
  },
  Notifies = {
    "QBOX",
    "ESX",
    "QBCORE",
    "ESX_NOTIFY",
    "MYTHIC",
    "OKOK",
    "BRUTAL",
    "OX",
    "NONE"
  },
  Menus = {
    "RCORE",
    "ESX_CONTEXT",
    "OX",
    "QB",
    "NONE"
  },
  Database = {
    "OX",
    "MYSQL_ASYNC",
    "GHMATTI",
    "NONE"
  },
  Interactions = {
    "OX",
    "QB",
    "Q",
    "MV",
    "NONE"
  },
  Map = {
    "PROMPT_FULL",
    "PROMPT",
    "ALCATRAZ",
    "RCORE",
    "GABZ",
    "UNCLE",
    "YBN",
    "DESERTOS",
    "NONE"
  },
  Cloth = {
    "RCORE",
    "FAPPEARANCE",
    "IAPPEARANCE",
    "BL_APPEARANCE",
    "CODEM",
    "CRM",
    "TGIANN",
    "MOV",
    "WASABI",
    "ESX",
    "QB",
    "NONE"
  },
  Inventories = {
    "OX",
    "MF",
    "CHEEZA",
    "QB",
    "QS",
    "PS",
    "LJ",
    "CORE",
    "CODEM",
    "TGIANN",
    "ORIGEN",
    "AK_47",
    "ESX",
    "NONE"
  },
  Dispatches = {
    "RCORE",
    "LB",
    "QS",
    "CD",
    "CORE",
    "DUSA",
    "PS",
    "LOVE_SCRIPTS",
    "CODEM",
    "TK",
    "ORIGEN",
    "REDUTZU",
    "NONE"
  }
}

local function normalizeMapName(mapName)
  return mapName:lower():gsub("_", "-")
end

local function detectMapFromResources(mapName, resourceList)
  local mapConfig = MapsConfig[mapName] or {}
  local requireAll = mapConfig.requireAll or false
  local foundCount = 0
  local totalCount = 0

  for key, resourceName in pairs(resourceList) do
    if type(key) == "number" then
      totalCount = totalCount + 1

      if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
        foundCount = foundCount + 1
      end
    end
  end

  if requireAll then
    if foundCount == totalCount and totalCount > 0 then
      return normalizeMapName(mapName)
    end
  elseif foundCount > 0 then
    return normalizeMapName(mapName)
  end

  return nil
end

local function detectMapBridge(selectedMap)
  local detectedMap = nil

  if selectedMap == AUTO_DETECT then
    for mapName, resourceList in pairs(MapsList) do
      detectedMap = detectMapFromResources(mapName, resourceList)
      if detectedMap then
        break
      end
    end
  elseif string.find(selectedMap, "MAPLIST") then
    local mapKey = string.match(selectedMap, "_(.+)")
    local resourceList = MapsList[mapKey]

    if resourceList and next(resourceList) then
      detectedMap = detectMapFromResources(mapKey, resourceList)
    end
  end

  return detectedMap or Map.NONE
end

local function resolveClothingException(selectedClothing)
  local resolvedClothing = selectedClothing
  local detectedException = nil

  if isResourcePresentProvideless(Cloth.FAPPEARANCE) then
    local author = GetResourceMetadata(Cloth.FAPPEARANCE, "author", 1)

    if author and author == "wasabirobby" then
      detectedException = Cloth.WASABI
    end
  end

  if isResourcePresentProvideless(Cloth.FAPPEARANCE) then
    local author = GetResourceMetadata(Cloth.FAPPEARANCE, "author", 1)

    if author and author == "snakewiz" then
      detectedException = Cloth.FAPPEARANCE
    end
  end

  if detectedException and detectedException ~= selectedClothing then
    resolvedClothing = detectedException
  end

  return resolvedClothing
end

local function resolveInventoryException(selectedInventory)
  local resolvedInventory = selectedInventory
  local detectedException = nil

  if selectedInventory ~= AUTO_DETECT and selectedInventory ~= Inventories.CHEEZA then
    return selectedInventory
  end

  if isResourcePresentProvideless(Inventories.CHEEZA) then
    detectedException = Inventories.CHEEZA
  end

  if isResourcePresentProvideless(Inventories.MF) then
    detectedException = Inventories.MF
  end

  if detectedException and detectedException ~= selectedInventory then
    resolvedInventory = detectedException
  end

  return resolvedInventory
end

local function resolveBridgeSelections()
  for bridgeKey in pairs(enabledBridgeChecks) do
    local configValue = Config[bridgeKey]

    if configValue == AUTO_DETECT then
      local bridgeList = _G[bridgeKey]

      if bridgeList == nil then
        dbg.critical(
          "Auto detect for bridge %s failed. Please set it manually in the configuration file. [_G]",
          bridgeKey
        )
      else
        local detectedBridgeKey = nil
        local priorityKeys = nil

        if ORDERED_KEYS and ORDERED_KEYS[bridgeKey] then
          priorityKeys = ORDERED_KEYS[bridgeKey]
        else
          priorityKeys = orderedBridgeKeys[bridgeKey]
        end

        if priorityKeys then
          if bridgeKey == MAP then
            detectedBridgeKey = detectMapBridge(AUTO_DETECT)
          else
            for _, bridgeName in ipairs(priorityKeys) do
              local resourceName = bridgeList[bridgeName]

              if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                detectedBridgeKey = bridgeName
                break
              end
            end
          end
        else
          if bridgeKey == MAP then
            detectedBridgeKey = detectMapBridge(AUTO_DETECT)
          else
            for bridgeName, resourceName in pairs(bridgeList) do
              if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                detectedBridgeKey = bridgeName
                break
              end
            end
          end
        end

        if detectedBridgeKey ~= nil then
          local resolvedBridge = bridgeList[detectedBridgeKey] or detectedBridgeKey

          if bridgeKey == INVENTORY then
            resolvedBridge = resolveInventoryException(resolvedBridge)
          end

          if bridgeKey == CLOTHING then
            resolvedBridge = resolveClothingException(resolvedBridge)
          end

          if bridgeKey == "Framework" and isResourcePresentProvideless(Framework.QBOX) then
            resolvedBridge = Framework.QBOX
          end

          Config[bridgeKey] = resolvedBridge

          dbg.debug(
            "Auto detect for bridge %s succeeded: %s, %s",
            bridgeKey,
            detectedBridgeKey,
            resolvedBridge
          )
        else
          if bridgeList.NONE ~= nil then
            Config[bridgeKey] = bridgeList.NONE

            dbg.debug(
              "Auto detect for bridge %s succeeded: %s, %s",
              bridgeKey,
              "NONE",
              bridgeList.NONE
            )
          else
            dbg.critical(
              "Auto detect for bridge %s failed. Please set it manually in the configuration file.",
              bridgeKey
            )
          end
        end
      end
    else
      if configValue ~= nil and configValue ~= AUTO_DETECT then
        local bridgeList = _G[bridgeKey]

        if bridgeList == nil then
          dbg.critical(
            "Manual select for bridge %s failed. Please set it manually in the configuration file. Maybe change AUTO_DETECT instead?",
            bridgeKey
          )
        else
          if bridgeKey == INVENTORY then
            local previousInventory = configValue
            Config[bridgeKey] = resolveInventoryException(Config[bridgeKey])

            dbg.debug(
              "We found exception in inventory - changing from %s to %s",
              previousInventory,
              Config[bridgeKey]
            )
          end

          if bridgeKey == CLOTHING then
            local previousClothing = configValue
            Config[bridgeKey] = resolveClothingException(Config[bridgeKey])

            dbg.debug(
              "We found exception in apperance - changing from %s to %s",
              previousClothing,
              Config[bridgeKey]
            )
          end

          if bridgeKey == "Framework" and isResourcePresentProvideless(Framework.QBOX) then
            Config[bridgeKey] = Framework.QBOX
          end
        end
      elseif Config[bridgeKey] == nil then
        dbg.critical(
          "Auto detect for bridge %s failed because the value was nil. Please set it manually in the configuration file.",
          bridgeKey
        )
      end
    end
  end
end

CreateThread(function()
  resolveBridgeSelections()
end)
