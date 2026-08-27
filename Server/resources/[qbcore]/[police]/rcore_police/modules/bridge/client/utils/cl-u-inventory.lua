-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



InventoryUtils = InventoryUtils or {}
local function splitVersion(version)
    local t = {}
    for num in string.gmatch(version, "%d+") do
        table.insert(t, tonumber(num))
    end
    return t
end
local function isVersionGreaterThan(v1, v2)
    local ver1 = splitVersion(v1)
    local ver2 = splitVersion(v2)
    local len = math.max(#ver1, #ver2)
    for i = 1, len do
        local a = ver1[i] or 0
        local b = ver2[i] or 0
        if a > b then return true end
        if a < b then return false end
    end
    return false
end
function InventoryUtils.GetStashContext(zoneType, zone, isPersonal, input)
    if not zone or not zoneType then return nil end
    local separator = Config.Inventory == Inventory.QS and "-" or "_"
    local baseIdParts = { zone.preset, zone.index, zoneType }
    if Config.Inventory == Inventory.QS then
        local version = GetResourceMetadata(Inventory.QS, 'version', 0)
        local isRunningAdvancedVersion = LoadResourceFile("qs-inventory", "html/assets/map-bg.png")
        if version and isVersionGreaterThan(version, '3.3.90') or isRunningAdvancedVersion then
            separator = '_'
        end
    end
    if isPersonal then
        table.insert(baseIdParts, Framework.identifier)
    end
    if input then
        table.insert(baseIdParts, tostring(input))
    end
    local baseId = table.concat(baseIdParts, separator)
    local stashConfig = Config.Stashes[zoneType]
    if not stashConfig then return nil end
    return {
        id = baseId,
        formattedId = baseId,
        type = zoneType,
        slots = stashConfig.Slots,
        maxweight = stashConfig.MaxWeight,
        rawZone = zone
    }
end
function InventoryUtils.CanSearch(target)
    local targetPed = UtilsService.GetPlayerPedFromServerId(target)
    if not targetPed then return false end
    local isDead    = DeadUtils.IsTargetPlayerDead(target)
    local isCuffed  = IsPedCuffed(targetPed)
    local isHandsUp = GetHandsUPState(target)
    local flags     = Config.Escort.Flags
    if isDead then
        return isDead
    end
    if flags.RequireCuffed and flags.RequireHandsup then
        if isCuffed or isHandsUp then
            return true
        else
            Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_HANDSUP"))
            return false
        end
    elseif flags.RequireCuffed then
        if isCuffed then
            return true
        else
            Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED"))
            return false
        end
    elseif flags.RequireHandsup then
        if isHandsUp then
            return true
        else
            Framework.sendNotification(_U("ACTIONS_REQUIRE_HANDSUP"))
            return false
        end
    end
    return true
end
