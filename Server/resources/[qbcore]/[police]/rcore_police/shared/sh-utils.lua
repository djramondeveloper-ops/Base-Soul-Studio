-- =====================================================
--  rcore_police · shared/sh-utils.lua
--  Engineered by Eazy Fxap
--  Original: 1506 lines → Cleaned: 550 lines
-- =====================================================

-- ============================================================
--  RESOURCE STATE HELPERS
-- ============================================================

function isResourceLoaded(resourceName)
    if resourceName == NONE_RESOURCE then return true end
    if resourceName == "null" or resourceName == nil then return false end
    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

-- Capitalize first letter of a string
function c(str)
    return str:gsub("^%l", string.upper)
end

-- Parse a version string "X.Y.Z" into a table of numbers
function sVersion(versionStr)
    local parts = {}
    for num in string.gmatch(versionStr, "%d+") do
        table.insert(parts, tonumber(num))
    end
    return parts
end

-- Compare two version strings for equality
function IsVersionEqual(vA, vB)
    local a = sVersion(vA)
    local b = sVersion(vB)
    local maxLen = math.max(#a, #b)
    for i = 1, maxLen do
        local ai = a[i] or 0
        local bi = b[i] or 0
        if ai ~= bi then return false end
    end
    return true
end

-- Pretty-print a table as indented JSON
function tprint(tbl)
    print(json.encode(tbl, { indent = true }))
end

-- Print with a label prefix and format args
function afprint(fmt, label, ...)
    print(("%s %s"):format(label, fmt:format(...)))
end

function fprint(fmt, label, ...)
    print(("%s %s"):format(label, fmt:format(...)))
end

-- String format helper
function sprint(fmt, ...)
    return string.format(fmt, ...)
end

-- Returns true if the string represents a positive integer
function isNumber(str)
    if not str then return nil end
    return str:match("^%d+$") ~= nil
end

-- ============================================================
--  PLAYER DISPLAY HELPERS
-- ============================================================

function getPlayerLabelByShowMode(playerId)
    local mode = Config.SelectPlayers.ShowMode:upper()
    if not mode then
        mode = SHOW_MODE.ID
    end

    if mode == SHOW_MODE.ID then
        return ("%s: #%s"):format(_U("SELECT_PLAYERS.PLAYER"), playerId)
    elseif mode == SHOW_MODE.OOC_ID then
        return ("%s: %s #%s"):format(_U("SELECT_PLAYERS.PLAYER"), GetPlayerName(playerId), playerId)
    end
    return nil
end

-- ============================================================
--  VEHICLE SPEED CONVERSION
-- ============================================================

function getVehicleSpeed(rawSpeed)
    local unit = Config.Props.SpeedCamera.SpeedType:upper()
    if unit == "MPH" then
        return rawSpeed * 2.236936
    elseif unit == "KMH" then
        return rawSpeed * 3.6
    else
        return rawSpeed
    end
end

-- ============================================================
--  TABLE UTILITIES
-- ============================================================

-- Count all key-value pairs in a table (including non-sequential)
function table.len(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- Deep copy a table (recursive)
function table.deepcopy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}
    for k, v in next, orig do
        copy[table.deepcopy(k)] = table.deepcopy(v)
    end
    return setmetatable(copy, table.deepcopy(getmetatable(orig)))
end

-- Deep merge tbl2 into a copy of tbl1
function table.merge(tbl1, tbl2)
    local result = table.deepcopy(tbl1)
    for k, v in pairs(tbl2) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = table.merge(result[k], v)
        else
            result[k] = table.deepcopy(v)
        end
    end
    return result
end

-- Format possible key-value pairs as a readable string
function formatPossible(tbl, prefix)
    local parts = {}
    for k in pairs(tbl) do
        table.insert(parts, ("^1%s.%s^7"):format(prefix, k))
    end
    return table.concat(parts, ", ")
end

-- Returns true if the value is a non-nil table
function isTable(val)
    if val == nil then return false end
    return type(val) == "table"
end

-- Returns true if the value is not a table, or is an empty table
function table.isEmpty(val)
    if not isTable(val) then return true end
    return next(val) == nil
end

-- Count all pairs in a table (returns 0 if nil)
function table.size(tbl)
    if not tbl then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- ============================================================
--  DEBUG LEVEL CHECK
-- ============================================================

function isDebugAllowed(level)
    local debugLevel = Config and Config.DebugLevel
    if not debugLevel then return false end

    if isTable(debugLevel) then
        if table.isEmpty(debugLevel) then return false end
        for _, v in pairs(debugLevel) do
            if v == level then return true end
        end
        return false
    else
        return debugLevel == level
    end
end

-- ============================================================
--  DEBUG LOGGER FACTORY
-- ============================================================

function rdebug()
    local logger = { prefix = "System" }

    function logger.info(fmt, ...)
        if isDebugAllowed("INFO") then
            print("^5[" .. logger.prefix .. " | info] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.init(fmt, ...)
        if isDebugAllowed("INFO") then
            print("^7" .. sprint(fmt, ...))
        end
    end

    function logger.success(fmt, ...)
        if isDebugAllowed("SUCCESS") then
            print("^3[" .. logger.prefix .. " | success] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.critical(fmt, ...)
        if isDebugAllowed("CRITICAL") then
            print("^1[" .. logger.prefix .. " | critical] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.error(fmt, ...)
        if isDebugAllowed("ERROR") then
            print("^1[" .. logger.prefix .. " | error] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.security(fmt, ...)
        if isDebugAllowed("SECURITY") then
            print("^3[" .. logger.prefix .. " | security] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.securitySpam(fmt, ...)
        if isDebugAllowed("SECURITY_SPAM") then
            print("^3[" .. logger.prefix .. " | security] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.bridge(fmt, ...)
        if Config.Debug then
            print("^4[BRIDGE] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.debugClothing(fmt, ...)
        if Config.DebugClothing then
            print("^2[ Clothing module ] | debug] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.debugNetwork(fmt, ...)
        if isDebugAllowed("NETWORK") and Config.Debug then
            print("^3[ Network | debug] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.debugAPI(fmt, ...)
        if Config.DebugAPI then
            print("^5[ API module ] | debug] ^7" .. sprint(fmt, ...) ..
                "\n ^3This debug message can be disabled in configs/config.lua - DebugAPI = false")
        end
    end

    function logger.debugInventory(fmt, ...)
        if Config.DebugInventory then
            print("^5[ Inventory module ] | debug] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.debug(fmt, ...)
        if isDebugAllowed("DEBUG") and Config.Debug then
            print("^3[ Debug ] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.menu(fmt, ...)
        if isDebugAllowed("MENU") and Config.Debug then
            print("^3[ Menu ] ^7" .. sprint(fmt, ...))
        end
    end

    function logger.setupPrefix(newPrefix)
        logger.prefix = newPrefix
    end

    function logger.getPrefix()
        return logger.prefix
    end

    return logger
end

-- Shorthand debug print (info level)
function dprint(fmt, ...)
    rdebug().info(fmt, ...)
end

-- ============================================================
--  IMAGE HELPERS
-- ============================================================

function GetImageByName(name)
    return "./images/menu/" .. name .. ".png"
end

-- ============================================================
--  GEOMETRY — POINT IN POLYGON
-- ============================================================

function IsPointInPolygon(point, polygon)
    if not point then return true end
    if point.x == 0.0 and point.y == 0.0 then return true end

    local count = #polygon
    local inside = false
    for i = 1, count do
        local vi = polygon[i]
        local vj = polygon[(i % count) + 1]
        if (vi.y > point.y) ~= (vj.y > point.y) then
            local intersectX = (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x
            if point.x < intersectX then
                inside = not inside
            end
        end
    end
    return inside
end

-- Calculate the centroid (average position) of a polygon
function CalculateCentroid(points)
    local sumX, sumY, sumZ = 0, 0, 0
    local count = #points
    for _, p in ipairs(points) do
        sumX = sumX + p.x
        sumY = sumY + p.y
        sumZ = sumZ + p.z
    end
    return vector3(sumX / count, sumY / count, sumZ / count)
end

-- ============================================================
--  RESOURCE PRINT UTILITY
-- ============================================================

function printResource(resources)
    for _, res in pairs(resources) do
        print("^3" .. res.name .. "^7")
        if res.version   then print("^7version: ^3"               .. res.version)   end
        if res.database  then print("^7database: ^3"              .. res.database)  end
        if res.debug     then print("^7debug: ^3"                 .. tostring(res.debug)) end
        if res.locale    then print("^7locale: ^3"                .. res.locale)    end
        if res.preset    then print("^7map: ^3"                   .. res.preset)    end
        if res.notify    then print("^7notify: ^3"                .. res.notify)    end
        if res.inventory then
            if res.inventory == "auto_detect" then res.inventory = "none" end
            print("^7inventory: ^3" .. res.inventory)
        end
        if res.dispatch  then print("^7dispatch: ^3"              .. res.dispatch)  end
        if res.clothing  then print("^7clothing: ^3"              .. res.clothing)  end
        if res.framework then print("^7framework: ^3"             .. res.framework) end
        if res.jailTime  then print("^7jail time conversion: ^3"  .. res.jailTime)  end
        if res.phone then
            local phoneDisplay = res.phone
            if phoneDisplay == "auto_detect" then
                phoneDisplay = "Not any supported phone loaded"
            end
            print("^7phone: ^3" .. phoneDisplay)
        end
        if res.economy   then print("^7economy item: ^3"          .. res.economy)   end
        if res.docs      then print("\n^7Docs: ^3 "               .. res.docs)      end
    end
end

-- ============================================================
--  SAFE NUMBER CONVERSION
-- ============================================================

function safeNumber(val, default)
    if val == nil then return default end
    local n = tonumber(val)
    if n == nil then
        return default or 0
    end
    return n
end

-- ============================================================
--  SERVER-SIDE: CLIENT EVENT TRIGGER WITH DEBUG
-- ============================================================

if IsDuplicityVersion() then
    function StartClient(target, eventName, ...)
        local resourceName = GetCurrentResourceName()
        if not eventName then
            return dbg.critical("Invalid event name for %s", resourceName)
        end
        local fullEvent = ("%s:%s"):format(resourceName, "client:" .. eventName)
        if not fullEvent then return end

        local targetLabel = (target == -1) and "ALL PLAYERS" or GetPlayerName(target)
        dbg.debug("Starting client with %s for user %s | Target: %s", eventName, targetLabel, target)
        TriggerClientEvent(fullEvent, target, ...)
    end

-- ============================================================
--  CLIENT-SIDE: PED IGNORE AND KEY REGISTRATION
-- ============================================================
else
    function MakePedIgnoreHitFromOtherPlayer(ped, enable)
        if not DoesEntityExist(ped) or not IsEntityAPed(ped) then return end

        if enable then
            SetEntityInvincible(ped, true)
            SetPedCanBeTargetted(ped, false)
            SetEntityCompletelyDisableCollision(ped, true, true)
            SetEntityCanBeDamaged(ped, false)
            SetPedCanRagdoll(ped, false)
            FreezeEntityPosition(ped, true)
            SetEntityProofs(ped, false, true, false, false, false, false, false, false)
            SetBlockingOfNonTemporaryEvents(ped, true)
        else
            SetPedCanRagdoll(ped, true)
            SetEntityInvincible(ped, false)
            SetPedCanBeTargetted(ped, true)
            SetEntityCanBeDamaged(ped, true)
            FreezeEntityPosition(ped, false)
            SetEntityProofs(ped, false, false, false, false, false, false, false, false)
            SetBlockingOfNonTemporaryEvents(ped, false)
        end
    end

    function RegisterKey(callback, keyName, description, keyCode, inputType, options)
        if inputType == nil then inputType = "keyboard" end
        dbg.debug("Registering key %s %s %s", keyCode, keyName, description)

        if options ~= nil and type(options) == "table" and next(options) then
            if options.state then
                local lastUsed = nil
                local cooldown = options.cooldown
                RegisterCommand(keyName .. keyCode, function()
                    local now = GetGameTimer()
                    if lastUsed and (now - lastUsed) < cooldown then return end
                    lastUsed = now
                    callback()
                end, false)
            else
                RegisterCommand(keyName .. keyCode, callback, false)
            end
        else
            RegisterCommand(keyName .. keyCode, callback, false)
        end

        RegisterKeyMapping(keyName .. keyCode, "POLICE: " .. description, inputType, keyCode)
    end
end

-- ============================================================
--  TABLE DUMP (DEBUG) — Converts a table to a readable string
-- ============================================================

function dumpTable(tbl, noReturn)
    local visited = {}
    local stack   = {}
    local parts   = {}
    local depth   = 1
    local result  = "{\n"
    local current = tbl

    while true do
        local count = 0
        for _ in pairs(current) do count = count + 1 end

        local idx = 1
        for k, v in pairs(current) do
            local keyStr, kt, vt, kt2
            -- Skip already-visited entries
            if visited[current] ~= nil and not (idx >= visited[current]) then
                goto continue
            end

            -- Append separator
            if string.find(result, "}", #result, true) then
                result = result .. ",\n"
            elseif not string.find(result, "\n", #result, true) then
                result = result .. "\n"
            end
            table.insert(parts, result)
            result = ""

            -- Determine key display
            kt = type(k)
            if kt == "number" or kt == "boolean" then
                keyStr = tostring(k)
            else
                keyStr = tostring(k)
            end

            -- Determine value display
            vt = type(v)
            if vt == "number" or vt == "boolean" then
                result = result .. string.rep("\t", depth) .. keyStr .. " = " .. tostring(v)
            elseif vt == "table" then
                kt2 = type(k)
                if kt2 == "number" then
                    result = result .. string.rep("\t", depth) .. "{\n"
                else
                    result = result .. string.rep("\t", depth) .. keyStr .. " = {\n"
                end
                table.insert(stack, current)
                table.insert(stack, v)
                visited[current] = idx + 1
                break
            elseif vt == "vector3" then
                result = result .. string.rep("\t", depth) .. keyStr .. " = " .. tostring(v)
            else
                result = result .. string.rep("\t", depth) .. keyStr .. " = '" .. tostring(v) .. "'"
            end

            ::continue::
            if idx == count then
                result = result .. "\n" .. string.rep("\t", depth - 1) .. "}"
            else
                result = result .. ","
            end
            idx = idx + 1
        end

        if count == 0 then
            result = result .. "\n" .. string.rep("\t", depth - 1)
        end

        if #stack <= 0 then break end

        current = stack[#stack]
        stack[#stack] = nil
        if visited[current] == nil then
            depth = depth + 1
        else
            depth = depth - 1
        end
    end

    table.insert(parts, result)
    result = table.concat(parts)
    return result
end
