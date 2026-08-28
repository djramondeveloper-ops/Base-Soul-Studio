local _unusedA, _unusedB

function isResourceLoaded(resourceName)
    if resourceName == NONE_RESOURCE then
        return true
    end

    if resourceName == "null" or resourceName == nil then
        dbg.critical("isResourceLoaded: Resource is not defined - received %s", resourceName)
        return false
    end

    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

local function serializeTable(data, printResult, options)
    options = options or {}

    local function serialize(value, depth, visited)
        local valueType = type(value)

        if valueType == "number" or valueType == "boolean" then
            return tostring(value)
        end

        if valueType == "string" then
            if options.quoteStrings then
                return string.format("%q", value)
            end
            return value
        end

        if valueType ~= "table" then
            return tostring(value)
        end

        if visited[value] then
            return "<recursive>"
        end

        visited[value] = true

        local indent = string.rep("\t", depth)
        local childIndent = string.rep("\t", depth + 1)
        local lines = { "{" }

        for key, val in pairs(value) do
            local keyType = type(key)
            local formattedKey

            if options.rawKeys then
                formattedKey = tostring(key)
            elseif keyType == "number" or keyType == "boolean" then
                formattedKey = string.format("[%s]", tostring(key))
            else
                formattedKey = string.format("['%s']", tostring(key))
            end

            local line = childIndent .. formattedKey .. " = " .. serialize(val, depth + 1, visited)
            table.insert(lines, line .. ",")
        end

        table.insert(lines, indent .. "}")
        visited[value] = nil

        return table.concat(lines, "\n")
    end

    local result = serialize(data, 0, {})

    if not printResult then
        print(result)
    end

    return result
end

function dTable(data, printResult)
    return serializeTable(data, printResult, {
        quoteStrings = true,
        rawKeys = false
    })
end

function tprint(data)
    print(json.encode(data, { indent = true }))
end

function afprint(message, level, ...)
    print(string.format("%s %s", level, string.format(message, ...)))
end

function fprint(message, level, ...)
    print(string.format("%s %s", level, string.format(message, ...)))
end

function sprint(message, ...)
    return string.format(message, ...)
end

function isBridgeLoaded(_bridgeName, _bridgeType)
    return true
end

function isNumber(value)
    if not value then
        return nil
    end

    return tostring(value):match("^%d+$") ~= nil
end

function table.len(tbl)
    local count = 0

    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function DeepCopy(original)
    local visited = {}

    local function copy(value)
        if type(value) ~= "table" then
            return value
        end

        if visited[value] then
            return visited[value]
        end

        local cloned = {}
        visited[value] = cloned

        for key, val in pairs(value) do
            cloned[copy(key)] = copy(val)
        end

        return setmetatable(cloned, getmetatable(value))
    end

    return copy(original)
end

function table.merge(baseTable, extraTable)
    local merged = DeepCopy(baseTable)

    for key, value in pairs(extraTable) do
        if type(value) == "table" and type(merged[key]) == "table" then
            merged[key] = table.merge(merged[key], value)
        else
            merged[key] = DeepCopy(value)
        end
    end

    return merged
end

function SecondsToClock(seconds)
    local totalSeconds = tonumber(seconds)

    if not totalSeconds or totalSeconds <= 0 then
        return "00:00:00"
    end

    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds - (hours * 3600)) / 60)
    local secs = math.floor(totalSeconds - (hours * 3600) - (minutes * 60))

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function formatPossible(possibleValues, prefix)
    local formatted = {}

    for key in pairs(possibleValues) do
        table.insert(formatted, string.format("^1%s.%s^7", prefix, key))
    end

    return table.concat(formatted, ", ")
end

function isTable(value)
    return value ~= nil and type(value) == "table"
end

function table.isEmpty(value)
    if isTable(value) then
        return next(value) == nil
    end

    return true
end

function table.size(tbl)
    local count = 0

    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function isDebugAllowed(debugType)
    local allowed = false

    if Config.DebugPlayerLoad then
        Config.DebugLevel = { "PLAYER_LOAD" }
    end

    if Config.DebugLevel then
        if isTable(Config.DebugLevel) then
            if not table.isEmpty(Config.DebugLevel) then
                for _, value in pairs(Config.DebugLevel) do
                    if value == debugType then
                        allowed = true
                    end
                end
            end
        elseif Config.DebugLevel == debugType then
            allowed = true
        end
    end

    return allowed
end

function rdebug()
    local logger = {
        prefix = "System"
    }

    function logger.info(message, ...)
        if isDebugAllowed("INFO") then
            print("^5[" .. logger.prefix .. " | info] ^7" .. sprint(message, ...))
        end
    end

    function logger.init(message, ...)
        if isDebugAllowed("INFO") then
            print("^7" .. sprint(message, ...))
        end
    end

    function logger.success(message, ...)
        if isDebugAllowed("SUCCESS") then
            print("^3[" .. logger.prefix .. " | success] ^7" .. sprint(message, ...))
        end
    end

    function logger.critical(message, ...)
        if isDebugAllowed("CRITICAL") then
            print("^1[" .. logger.prefix .. " | critical] ^7" .. sprint(message, ...))
        end
    end

    function logger.error(message, ...)
        if isDebugAllowed("ERROR") then
            print("^1[" .. logger.prefix .. " | error] ^7" .. sprint(message, ...))
        end
    end

    function logger.security(message, ...)
        if isDebugAllowed("SECURITY") then
            print("^3[" .. logger.prefix .. " | security] ^7" .. sprint(message, ...))
        end
    end

    function logger.securitySpam(message, ...)
        if isDebugAllowed("SECURITY_SPAM") then
            print("^3[" .. logger.prefix .. " | security] ^7" .. sprint(message, ...))
        end
    end

    function logger.bridge(message, ...)
        if Config.Debug then
            print("^4[BRIDGE] ^7" .. sprint(message, ...))
        end
    end

    function logger.debugClothing(message, ...)
        if Config.DebugClothing then
            print("^2[ Clothing module ] | debug] ^7" .. sprint(message, ...))
        end
    end

    function logger.debugNetwork(message, ...)
        if isDebugAllowed("NETWORK") and Config.Debug then
            print("^3[ Network | debug] ^7" .. sprint(message, ...))
        end
    end

    function logger.debugAPI(message, ...)
        if Config.DebugAPI then
            print("^5[ API module ] | debug] ^7" .. sprint(message, ...) ..
                [[

 ^3This debug message can be disabled in configs/config.lua - DebugAPI = false]])
        end
    end

    function logger.debugInventory(message, ...)
        if Config.DebugInventory then
            print("^5[ Inventory module ] | debug] ^7" .. sprint(message, ...))
        end
    end

    function logger.debug(message, ...)
        if isDebugAllowed("DEBUG") and Config.Debug then
            print("^3[ Debug ] ^7" .. sprint(message, ...))
        end
    end

    function logger.playerLoad(message, ...)
        if isDebugAllowed("PLAYER_LOAD") and Config.Debug then
            print("^5[ PLAYER LOAD ] ^7" .. sprint(message, ...))
        end
    end

    function logger.job(message, ...)
        if isDebugAllowed("JOB") and Config.Debug then
            print("^6[ JOB ] ^7" .. sprint(message, ...))
        end
    end

    function logger.cuffs(message, ...)
        if isDebugAllowed("CUFFS") and Config.Debug then
            print("^3[ CUFFS ] ^7" .. sprint(message, ...))
        end
    end

    function logger.menu(message, ...)
        if isDebugAllowed("MENU") and Config.Debug then
            print("^3[ Menu ] ^7" .. sprint(message, ...))
        end
    end

    function logger.setupPrefix(prefix)
        logger.prefix = prefix
    end

    function logger.getPrefix()
        return logger.prefix
    end

    return logger
end

function dprint(message, ...)
    local logger = rdebug()
    logger.info(message, ...)
end

function SetCycle(cycleName, intervalMs, callback, onStop)
    if not Intervals[cycleName] and intervalMs then
        collectgarbage("collect")
        Intervals[cycleName] = intervalMs

        CreateThread(function()
            local currentInterval

            repeat
                currentInterval = Intervals[cycleName]
                Wait(currentInterval)
                callback(currentInterval)
            until currentInterval == -1

            if onStop then
                onStop()
            end

            Intervals[cycleName] = nil
        end, "sh-utils code name: Phoenix")
    elseif intervalMs then
        Intervals[cycleName] = intervalMs
    end
end

function IsIntervalRunning(cycleName)
    return Intervals[cycleName] ~= nil
end

function ClearCycle(cycleName)
    Intervals[cycleName] = -1
end

function DrawDebugPolyZone(points)
    local previousPoint = nil
    local firstPoint = nil

    for index, point in ipairs(points) do
        local currentPoint = vector3(point.x, point.y, point.z)

        if previousPoint then
            DrawLine(previousPoint, currentPoint, 255, 0, 0, 255)
            Draw3DText(
                currentPoint.x,
                currentPoint.y,
                currentPoint.z,
                tostring(index) .. "\n" .. tostring(point),
                255,
                0,
                0,
                255
            )
        else
            firstPoint = currentPoint
        end

        previousPoint = currentPoint

        if index == #points and firstPoint then
            DrawLine(previousPoint, firstPoint, 255, 0, 0, 255)
            Draw3DText(
                firstPoint.x,
                firstPoint.y,
                firstPoint.z,
                tostring(#points) .. "\n" .. tostring(firstPoint),
                255,
                0,
                0,
                255
            )
        end
    end
end

function GetImageByName(imageName)
    return "./images/menu/" .. imageName .. ".png"
end

function IsPointInPolygon(point, polygon)
    if not point then
        return true
    end

    if point.x == 0.0 and point.y == 0.0 then
        return true
    end

    local polygonSize = #polygon
    local inside = false

    for i = 1, polygonSize do
        local current = polygon[i]
        local nextPoint = polygon[(i % polygonSize) + 1]

        local intersects = (current.y > point.y) ~= (nextPoint.y > point.y)
        if intersects then
            local edgeX = ((nextPoint.x - current.x) * (point.y - current.y) / (nextPoint.y - current.y)) + current.x
            if point.x < edgeX then
                inside = not inside
            end
        end
    end

    return inside
end

function CalculateCentroid(points)
    local totalX, totalY, totalZ = 0, 0, 0
    local count = #points

    for _, point in ipairs(points) do
        totalX = totalX + point.x
        totalY = totalY + point.y
        totalZ = totalZ + point.z
    end

    return vector3(totalX / count, totalY / count, totalZ / count)
end

function printResource(resources)
    for _, resource in pairs(resources) do
        print("^3" .. resource.name .. "^7")

        if resource.version then
            print("^7version: ^3" .. resource.version)
        end

        if resource.database then
            print("^7database: ^3" .. resource.database)
        end

        if resource.debug then
            print("^7debug: ^3" .. resource.debug)
        end

        if resource.locale then
            print("^7locale: ^3" .. resource.locale)
        end

        if resource.preset then
            print("^7map: ^3" .. resource.preset)
        end

        if resource.notify then
            print("^7notify: ^3" .. resource.notify)
        end

        if resource.inventory then
            if resource.inventory == "auto_detect" then
                resource.inventory = "none"
            end
            print("^7inventory: ^3" .. resource.inventory)
        end

        if resource.dispatch then
            print("^7dispatch: ^3" .. resource.dispatch)
        end

        if resource.clothing then
            print("^7clothing: ^3" .. resource.clothing)
        end

        if resource.framework then
            print("^7framework: ^3" .. resource.framework)
        end

        if resource.jailTime then
            print("^7jail time conversion: ^3" .. resource.jailTime)
        end

        if resource.phone then
            local phoneName = resource.phone
            if phoneName == "auto_detect" then
                phoneName = "Not any supported phone loaded"
            end
            print("^7phone: ^3" .. phoneName)
        end

        if resource.economy then
            print("^7economy item: ^3" .. resource.economy)
        end

        if resource.docs then
            print([[

^7Docs: ^3 ]] .. resource.docs)
        end
    end
end

function renderResourceInfo()
    local resourceInfo = {
        {
            name = GetCurrentResourceName(),
            version = GetResourceMetadata(GetCurrentResourceName(), "version", 0),
            preset = SH.preset,
            database = Bridge.SQL,
            locale = Config.Locale,
            framework = Config.Framework,
            jailTime = Config.Time,
            phone = Bridge.Phone,
            dispatch = Bridge.Dispatch,
            debug = tostring(Config.Debug),
            clothing = Bridge.Clothing,
            inventory = Config.Inventories,
            notify = Config.Framework,
            economy = Config.EconomyItem,
            docs = string.format(
                "%s/%s",
                "https://documentation.rcore.cz/paid-resources",
                GetCurrentResourceName()
            )
        }
    }

    printResource(resourceInfo)
end

function GetReducingTimeType()
    return Config.ReduceSentenceType
end

if IsDuplicityVersion() then
    function StartClient(targetPlayer, eventName, ...)
        local resourceName = GetCurrentResourceName()

        if not eventName then
            return dbg.critical("Invalid event name for %s", resourceName)
        end

        local fullEventName = string.format("%s:%s", resourceName, "client:" .. eventName)
        if not fullEventName then
            return
        end

        local targetName
        if targetPlayer == -1 then
            targetName = "ALL PLAYERS"
        else
            targetName = GetPlayerName(targetPlayer)
        end

        if targetName == nil then
            targetName = ""
        end

        dbg.debugNetwork(
            "Starting client with %s for user %s | Target: %s",
            eventName,
            targetName,
            targetPlayer
        )

        TriggerLatentClientEvent(fullEventName, targetPlayer, 1000000, ...)
    end
else
    function RegisterKey(callback, commandName, description, defaultKey, inputDevice)
        inputDevice = inputDevice or "keyboard"

        dbg.debug("Registering key %s %s %s", defaultKey, commandName, description)

        RegisterCommand(commandName .. defaultKey, callback, false)
        RegisterKeyMapping(
            commandName .. defaultKey,
            "PRISON: " .. description,
            inputDevice,
            defaultKey
        )
    end

    function RaycastFromCamera(flags)
        local cameraPos, cameraDir = GetWorldCoordFromScreenCoord(0.5, 0.5)
        local destination = cameraPos + (cameraDir * 10)
        local rayHandle = StartShapeTestLosProbe(
            cameraPos.x,
            cameraPos.y,
            cameraPos.z,
            destination.x,
            destination.y,
            destination.z,
            flags,
            PlayerPedId(),
            4
        )

        while true do
            Wait(0)

            local result, hit, endCoords, surfaceNormal, materialHash, entityHit =
                GetShapeTestResultIncludingMaterial(rayHandle)

            if result ~= 1 then
                return hit, entityHit, endCoords, surfaceNormal, materialHash
            end
        end
    end
end

function dumpTable(data, printResult)
    return serializeTable(data, printResult, {
        quoteStrings = true,
        rawKeys = true
    })
end