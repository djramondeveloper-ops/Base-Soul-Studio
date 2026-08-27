-- =====================================================
--  rcore_police · modules/bridge/sv-bridge.lua
--  Engineered by Eazy Fxap
--  Original: 381 lines → Cleaned: 125 lines
-- =====================================================

-- ============================================================
--  DEFAULT BRIDGE FLAGS (used if Config.Bridges not set)
-- ============================================================

local defaultBridges = {
    Database           = true,
    Framework          = true,
    Inventory          = true,
    Clothing           = true,
    Prison             = true,
    Invoices           = true,
    Dispatch           = true,
    Garages            = true,
    Fuel               = true,
    Licence            = true,
    Menu               = true,
    Notify             = true,
    Society            = true,
    TextUI             = true,
    Duty               = true,
    Keys               = true,
    PG                 = true,
    MDT                = true,
}

BridgeLoader = {}

-- ============================================================
--  CLOTHING VERSION RESOLUTION
--  Detects wasabi variant of fivem-appearance
-- ============================================================

local function resolveClothing(current)
    local resolved = nil
    if isResourcePresentProvideless(Clothing.FAPPEARANCE) then
        local author = GetResourceMetadata(Clothing.FAPPEARANCE, "author", 1)
        if author and author == "wasabirobby" then
            resolved = Clothing.WASABI
        end
    end
    if resolved ~= current and resolved then return resolved end
    return current
end

-- ============================================================
--  SOCIETY VERSION RESOLUTION
--  qb-banking >= 2.0.0 uses QB_BANKING, older uses QB_MANAGEMENT
-- ============================================================

local function resolveSociety(current)
    local resolved = nil
    if isResourcePresentProvideless(Society.QB_BANKING) and not resolved then
        local ver = GetResourceMetadata(Society.QB_BANKING, "version", 0)
        if ver and ver < "2.0.0" and isResourcePresentProvideless(Society.QB_MANAGEMENT) then
            resolved = Society.QB_MANAGEMENT
        end
    end
    if isResourcePresentProvideless(Society.QB_MANAGEMENT) and not resolved then
        local ver = GetResourceMetadata(Society.QB_BANKING, "version", 0)
        if ver and ver >= "2.0.0" and isResourcePresentProvideless(Society.QB_BANKING) then
            resolved = Society.QB_BANKING
        end
    end
    if resolved ~= current and resolved then return resolved end
    return current
end

-- ============================================================
--  INVENTORY VERSION RESOLUTION
-- ============================================================

local function resolveInventory(current)
    if current == Inventory.OX then return current end
    if isResourcePresentProvideless(Inventory.OX) then return Inventory.OX end

    local resolved = nil
    if isResourcePresentProvideless(Inventory.CHEEZA) then resolved = Inventory.CHEEZA end
    if isResourcePresentProvideless(Inventory.MF)     then resolved = Inventory.MF     end
    if resolved ~= current and resolved then return resolved end
    return current
end

-- ============================================================
--  AUTO-DETECT BRIDGE VALUES FROM CONFIG
-- ============================================================

local function setupBridges()
    local activeBridges = Bridges or defaultBridges

    for bridgeName in pairs(activeBridges) do
        local configValue = Config[bridgeName]

        if configValue == AUTO_DETECT then
            local bridgeTable = _G[bridgeName]
            if bridgeTable == nil then
                dbg.critical("Auto detect for bridge %s failed. Please set it manually in the configuration file. [_G]", bridgeName)
            else
                local foundKey = nil
                local orderedKeys = ORDERED_KEYS[bridgeName]
                if orderedKeys then
                    for _, key in ipairs(orderedKeys) do
                        local resourceName = bridgeTable[key]
                        if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                            foundKey = key
                            break
                        end
                    end
                else
                    for key, resourceName in pairs(bridgeTable) do
                        if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                            foundKey = key
                            break
                        end
                    end
                end

                if foundKey ~= nil then
                    local resourceName = bridgeTable[foundKey]
                    if bridgeName == "Inventory" then resourceName = resolveInventory(resourceName) end
                    if bridgeName == "Society"   then resourceName = resolveSociety(resourceName)   end
                    if bridgeName == "Clothing"  then resourceName = resolveClothing(resourceName)  end
                    Config[bridgeName] = resourceName
                    dbg.debug("Auto detect for bridge %s succeeded: %s, %s", bridgeName, foundKey, resourceName)
                elseif bridgeTable.NONE ~= nil then
                    Config[bridgeName] = bridgeTable.NONE
                    dbg.debug("Auto detect for bridge %s succeeded: %s, %s", bridgeName, "NONE", bridgeTable.NONE)
                else
                    dbg.critical("Auto detect for bridge %s failed. Please set it manually in the configuration file.", bridgeName)
                end
            end

        elseif configValue ~= nil and configValue ~= AUTO_DETECT then
            local bridgeTable = _G[bridgeName]
            if bridgeTable == nil then
                dbg.critical("Auto detect for bridge %s failed. Please set it manually in the configuration file. [_G]", bridgeName)
            else
                local foundKey = nil
                local orderedKeys = ORDERED_KEYS[bridgeName]
                if orderedKeys then
                    for _, key in ipairs(orderedKeys) do
                        local resourceName = bridgeTable[key]
                        if resourceName == configValue and isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                            foundKey = key
                            break
                        end
                    end
                else
                    for key, resourceName in pairs(bridgeTable) do
                        if resourceName == configValue and isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                            foundKey = key
                            break
                        end
                    end
                end

                if foundKey ~= nil then
                    local resourceName = bridgeTable[foundKey]
                    if bridgeName == "Inventory" then resourceName = resolveInventory(resourceName) end
                    Config[bridgeName] = resourceName
                    dbg.debug("Auto detect for bridge %s succeeded: %s, %s", bridgeName, foundKey, resourceName)
                elseif bridgeTable.NONE ~= nil then
                    Config[bridgeName] = bridgeTable.NONE
                    dbg.debug("Auto detect for bridge %s succeeded: %s, %s", bridgeName, "NONE", bridgeTable.NONE)
                else
                    dbg.critical("Auto detect for bridge %s failed. Please set it manually in the configuration file.", bridgeName)
                end
            end

        elseif configValue == nil then
            dbg.critical("Auto detect for bridge %s failed because the value was nil. Please set it manually in the configuration file.", bridgeName)
        end
    end

    TriggerEvent("rcore_police:server:internal:isBridgeReady")
end

-- ============================================================
--  ENTRY POINT
-- ============================================================

CreateThread(setupBridges)
