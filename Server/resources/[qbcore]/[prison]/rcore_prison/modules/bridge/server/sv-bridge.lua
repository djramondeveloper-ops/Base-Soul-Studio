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
  Phones = true,
  Map = true
}

local defaultOrderedKeys = {
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
  Phones = {
    "LB",
    "NONE"
  },
  Cloth = {
    "RCORE",
    "FAPPEARANCE",
    "IAPPEARANCE",
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
    "JAKSAM",
    "MF",
    "CHEEZA",
    "QS",
    "PS",
    "LJ",
    "CORE",
    "CODEM",
    "TGIANN",
    "ORIGEN",
    "AK_47",
    "OX",
    "ESX",
    "QB",
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

AssetDeployer = createDeployer()
AssetDeployer:registerDefaultCommand("prisonsetup")
AssetDeployer:registerResetDeployCommand()

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

local function normalizeMapName(mapName)
  return mapName:lower():gsub("_", "-")
end

local function detectMapBridge(selectedMap)
  local detectedMap = nil

  if selectedMap == AUTO_DETECT then
    for mapName, resourceList in pairs(MapsList) do
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
          detectedMap = normalizeMapName(mapName)
          break
        end
      elseif foundCount > 0 then
        detectedMap = normalizeMapName(mapName)
        break
      end
    end
  elseif string.find(selectedMap, "MAPLIST") then
    local mapKey = string.match(selectedMap, "_(.+)")
    local resourceList = MapsList[mapKey]

    if resourceList and next(resourceList) then
      local mapConfig = MapsConfig[mapKey] or {}
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
          detectedMap = normalizeMapName(mapKey)
        end
      elseif foundCount > 0 then
        detectedMap = normalizeMapName(mapKey)
      end
    end
  end

  return detectedMap or Map.NONE
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

  if isResourcePresentProvideless(Inventories.QS) then
    detectedException = Inventories.QS
  end

  if detectedException and detectedException ~= selectedInventory then
    resolvedInventory = detectedException
  end

  return resolvedInventory
end

local function bootstrapBridges()
  SetTimeout(500, function()
    AssetDeployer:setSaveDeployInCache(true)
    AssetDeployer:suggestDeploys(true)
  end)

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
        local orderedKeys = nil

        if ORDERED_KEYS and ORDERED_KEYS[bridgeKey] then
          orderedKeys = ORDERED_KEYS[bridgeKey]
        else
          orderedKeys = defaultOrderedKeys[bridgeKey]
        end

        if orderedKeys then
          if bridgeKey == "Map" then
            detectedBridgeKey = detectMapBridge(AUTO_DETECT)
          else
            for _, bridgeName in ipairs(orderedKeys) do
              local resourceName = bridgeList[bridgeName]

              if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                detectedBridgeKey = bridgeName
                break
              end
            end
          end
        else
          for bridgeName, resourceName in pairs(bridgeList) do
            if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
              detectedBridgeKey = bridgeName
              break
            end
          end
        end

        if detectedBridgeKey ~= nil then
          local resolvedBridge = bridgeList[detectedBridgeKey] or detectedBridgeKey

          if bridgeKey == "Inventories" then
            resolvedBridge = resolveInventoryException(resolvedBridge)
          end

          if bridgeKey == "Cloth" then
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
      if configValue ~= nil then
        if configValue ~= AUTO_DETECT then
          local bridgeList = _G[bridgeKey]

          if bridgeList == nil then
            dbg.critical(
              "Manual select for bridge %s failed. Please set it manually in the configuration file. Maybe change AUTO_DETECT instead?",
              bridgeKey
            )
          else
            if bridgeKey == "Inventories" then
              local previousInventory = configValue
              Config[bridgeKey] = resolveInventoryException(Config[bridgeKey])

              dbg.debug(
                "We found exception in inventory - changing from %s to %s",
                previousInventory,
                Config[bridgeKey]
              )
            end

            if bridgeKey == "Cloth" then
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
  bootstrapBridges()
end)

function BridgeLoadedHeartbeat()
  local timeoutAt = GetGameTimer() + 10000

  while GetGameTimer() < timeoutAt do
    if PrisonService and ChatService and COMSService and PrisonAccountService and LogService and AccountLogService then
      break
    end

    Wait(50)
  end

  if PrisonService and PrisonService.loadAllPrisoners then PrisonService.loadAllPrisoners() end
  if ChatService and ChatService.RegisterAllSuggestions then ChatService.RegisterAllSuggestions() end
  if COMSService and COMSService.loadAllUsers then COMSService.loadAllUsers() end
  if PrisonAccountService and PrisonAccountService.LoadAllAccounts then PrisonAccountService.LoadAllAccounts() end
  if LogService and LogService.LoadAllLogs then LogService.LoadAllLogs() end
  if AccountLogService and AccountLogService.LoadAllLogs then AccountLogService.LoadAllLogs() end
end
