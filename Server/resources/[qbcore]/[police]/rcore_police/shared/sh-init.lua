-- =====================================================
--  rcore_police · shared/sh-init.lua
--  Engineered by Eazy Fxap
--  Original: 1791 lines → Cleaned: 580 lines
-- =====================================================

-- ============================================================
--  GLOBAL NAMESPACE INIT
-- ============================================================

SH        = {}
Intervals = {}
Maps      = {}
glm       = require("glm")

-- ============================================================
--  OPTIONAL FRAMEWORK LOADER (ox_lib, ND_Core)
-- ============================================================

if isResourceLoaded("ox_lib") then
    local initFile = LoadResourceFile("ox_lib", "init.lua")
    assert(load(initFile, ("@@ox_lib/%s"):format("init.lua")))()
end

if isResourceLoaded("ND_Core") then
    local initFile = LoadResourceFile("ND_Core", "init.lua")
    assert(load(initFile, ("@@ND_Core/%s"):format("init.lua")))()
end

-- ============================================================
--  EXPORT EXISTENCE CHECK
-- ============================================================

function doesExportExistInResource(resourceName, exportName)
    local ok = xpcall(function()
        local _ = exports[resourceName][exportName]
    end, debug.traceback)
    return ok
end

-- ============================================================
--  WAIT FOR CONDITION WITH TIMEOUT
-- ============================================================

-- Polls condition() every 250ms until it returns true or timeout (ms) is reached
-- Returns true if condition passed, false if timed out
function WaitFor(condition, timeoutMs)
    local elapsed = 0
    local interval = 250
    while true do
        if condition() then return true end
        Wait(interval)
        elapsed = elapsed + interval
        if elapsed >= timeoutMs then return false end
    end
end

-- ============================================================
--  TABLE → LUA CODE SERIALIZER
-- ============================================================

-- Detects if a string value is a special Lua expression (locale ref, vec, etc.)
local function isSpecialExpression(str)
    return str:match("^_U%b()$")
        or str:match("^vec3%b()$")
        or str:match("^vector3%b()$")
        or str:match("^ZONE_TYPE%..+$")
        or str:match("^MAP_TYPES%..+$")
        or str:match("^MAPS%..+$")
end

-- Serialize a value to Lua source code
local function serializeValue(val, depth)
    if not depth then depth = 1 end
    local indent = string.rep("    ", depth)
    local vt = type(val)

    if vt == "string" then
        if isSpecialExpression(val) then
            return val
        else
            return string.format("%q", val)
        end
    elseif vt == "number" or vt == "boolean" then
        return tostring(val)
    elseif vt == "table" then
        -- Handle vector3 tables
        if val.x and val.y and val.z then
            return ("vec3(%.6f, %.6f, %.6f)"):format(val.x, val.y, val.z)
        end
        local result = "{\n"
        for k, v in pairs(val) do
            local keyStr
            if type(k) == "string" then
                keyStr = ("%s%s = "):format(indent, k)
            else
                keyStr = ("%s[%s] = "):format(indent, tostring(k))
            end
            result = result .. keyStr .. serializeValue(v, depth + 1) .. ",\n"
        end
        return result .. string.rep("    ", depth - 1) .. "}"
    else
        return string.format("%q", tostring(val or "nil"))
    end
end

-- Dumps a table entry as runnable Lua code that sets Maps[key] = value
function dumpTableLuaCode(key, tbl)
    local keyStr = tostring(key)
    local valStr = serializeValue(tbl, 2)
    return "CreateThread(function()\n" ..
           ("    Maps[%q] = %s\n"):format(keyStr, valStr) ..
           "end)"
end

-- ============================================================
--  TABLE DUMP (see also sh-utils.lua's dumpTable — this one is
--  the shared init version used for debug serialization)
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
            local keyStr, kt, vt
            if visited[current] ~= nil and not (idx >= visited[current]) then
                goto shContinue
            end

            if string.find(result, "}", #result, true) then
                result = result .. ",\n"
            elseif not string.find(result, "\n", #result, true) then
                result = result .. "\n"
            end
            table.insert(parts, result)
            result = ""

            -- Format the key
            kt = type(k)
            if kt == "number" or kt == "boolean" then
                keyStr = "[" .. tostring(k) .. "]"
            else
                keyStr = "['" .. tostring(k) .. "']"
            end

            -- Format the value
            vt = type(v)
            if vt == "number" or vt == "boolean" then
                result = result .. string.rep("\t", depth) .. keyStr .. " = " .. tostring(v)
            elseif vt == "table" then
                result = result .. string.rep("\t", depth) .. keyStr .. " = {\n"
                table.insert(stack, current)
                table.insert(stack, v)
                visited[current] = idx + 1
                break
            else
                result = result .. string.rep("\t", depth) .. keyStr .. " = '" .. tostring(v) .. "'"
            end

            ::shContinue::
            if idx == count then
                result = result .. "\n" .. string.rep("\t", depth - 1) .. "}"
            else
                result = result .. ","
            end
            idx = idx + 1
        end

        if count == 0 then
            result = result .. "\n" .. string.rep("\t", depth - 1) .. "}"
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
    if not noReturn then end
    return result
end

-- ============================================================
--  EXPORT EMULATION (provide an export from a different resource)
-- ============================================================

function provideExport(exportName, resourceName, callback)
    if not resourceName then resourceName = GetCurrentResourceName() end
    if resourceName ~= GetCurrentResourceName() then
        dbg.debugAPI("Providing export emulation for export named: %s | resource: %s", exportName, resourceName)
    end
    local eventName = ("__cfx_export_%s_%s"):format(resourceName, exportName)
    AddEventHandler(eventName, function(cb)
        dbg.debugAPI("Emulator was called from %s | emulate-resource: %s", GetInvokingResource(), resourceName)
        cb(callback)
    end)
end

-- ============================================================
--  SAFE CALL WRAPPER
-- ============================================================

function safeCallFunction(fn, fnName, ...)
    local ok, result = pcall(fn, ...)
    if not ok then
        dbg.critical("Safe call for function named (%s) result: %s", fnName, result)
    end
    return ok, result
end

-- ============================================================
--  EXTRACT JOB NAMES FROM JOB GROUPS TABLE
-- ============================================================

function extractJobNames(jobGroups)
    local names = { "leo" }
    if jobGroups and next(jobGroups) then
        for jobName in pairs(jobGroups) do
            table.insert(names, jobName)
        end
    end
    return names
end

-- ============================================================
--  RESOURCE DETECTION HELPERS
-- ============================================================

-- Returns true if resource is loaded AND present (no provides-chain)
function isResourcePresentProvideless(resourceName)
    for i = 0, GetNumResources() - 1 do
        local res = GetResourceByFindIndex(i)
        if res == resourceName then
            local state = GetResourceState(res)
            return state == "started" or state == "starting"
        end
    end
    return false
end

-- Find first resource whose name matches a pattern and is loaded
function FindTargetResource(pattern)
    for i = 0, GetNumResources() - 1 do
        local res = GetResourceByFindIndex(i)
        if res:match(pattern) and isResourcePresentProvideless(res) then
            return res
        end
    end
end

-- ============================================================
--  POLICE JOB LIST
-- ============================================================

PoliceJobs = extractJobNames(Config.JobGroups or {})

-- Seoul: jobs oficiais usam LSPD/PRPD em maiusculas.
-- Mantem uma unica configuracao por departamento e resolve comparacoes legadas sem aliases duplicados.
function GetDepartmentConfig(jobName)
    if not jobName then return nil, nil end
    if Config.JobGroups[jobName] then return Config.JobGroups[jobName], jobName end
    local wanted = tostring(jobName):lower()
    for configuredName, department in pairs(Config.JobGroups or {}) do
        if tostring(configuredName):lower() == wanted then
            return department, configuredName
        end
    end
    return nil, nil
end

-- ============================================================
--  OX INVENTORY COMPATIBILITY CHECK
-- ============================================================

CreateThread(function()
    -- ox_inventory 2.41.0 + QBCore: force DisableInventoryWhileCuffed = false
    if Config.Inventory == Inventory.OX and Config.Framework == Framework.QBCore then
        local ver = GetResourceMetadata(Inventory.OX, "version", 0)
        if ver and IsVersionEqual(ver, "2.41.0") then
            Config.Cuffing.DisableInventoryWhileCuffed = false
        end
    end
end)

-- ============================================================
--  DEBUG ERROR SESSION SYSTEM
-- ============================================================

local debugErrorEnabled = Config.DebugError or false
local debugSessions     = {}

function StartDebugSession(sessionName)
    if debugErrorEnabled then
        debugSessions[sessionName] = { stepCount = 0, stepData = {} }
    end
end

function DestroyDebugSession(sessionName)
    DisplayCurrentRecordSteps(sessionName)
    if debugErrorEnabled then
        debugSessions[sessionName] = nil
    end
end

function DebugRecordStep(sessionName, stepLabel)
    if debugErrorEnabled then
        local session = debugSessions[sessionName]
        if session then
            session.stepCount = session.stepCount + 1
            session.stepData[session.stepCount] = stepLabel
        end
    end
end

function DisplayCurrentRecordSteps(sessionName)
    if debugErrorEnabled then
        local session = debugSessions[sessionName]
        if session then
            for _, stepName in ipairs(session.stepData) do
                print("^0Step name: ^1" .. tostring(stepName))
            end
            print("^5=====^0")
            local lastStep = session.stepData[#session.stepData]
            print("^0Last step before the error: ^1" .. tostring(lastStep))
        end
    end
end

-- ============================================================
--  DEBUG ERROR WRAPPERS
--  When Config.DebugError = true, wraps FiveM API calls with
--  xpcall to display detailed error output on failure.
-- ============================================================

if debugErrorEnabled then
    -- Helper: print argument dump for a call
    local function printArgDump(args, eventName, errorMsg, dumpFn, isNui)
        print("^5=========================^0")
        if isNui then
            print("^2Error in: ^1RegisterNUICallback^0")
        else
            print("^2Error in: ^1RegisterNetEvent^0")
        end
        print("^2Event name: ^1" .. eventName .. "^0")
        print("^5=========================^0")
        DisplayCurrentRecordSteps(eventName)
        print("^5=========================^0")
        for k, v in pairs(args) do
            print("^0Argument key: ^1" .. tostring(k))
            print("^0Argument value type: ^1" .. type(v))
            print(" ")
            if type(v) == "table" then
                print("^0Argument value: ^1" .. tostring(v))
                dumpFn(v)
            else
                print("^0Argument value: ^1" .. tostring(v))
            end
            print("^5=====^0")
        end
        print("^5=========================^0")
        print(errorMsg)
        print("^5=========================^0")

        -- Build replication trigger string
        local argStr = ""
        for i = 1, 12 do
            local a = args[i]
            if type(a) == "table" then
                argStr = argStr .. dumpFn(a, true) .. ","
            elseif type(a) == "string" then
                argStr = argStr .. "'" .. a .. "',"
            else
                argStr = argStr .. tostring(a) .. ","
            end
        end
        local cleanArgs = argStr:gsub("\n", ""):sub(1, -2)
        local prefix = isNui and "^1TriggerEvent('__cfx_nui:" or "^1TriggerEvent('"
        print("^0Replication trigger event:")
        print(prefix .. eventName .. "', " .. cleanArgs .. ")")
        print("^5=========================^0")
    end

    -- Store original versions
    local _AddEventHandler   = AddEventHandler
    local _RegisterNetEvent  = RegisterNetEvent
    local _CreateThread      = CreateThread
    local _RegisterCommand   = RegisterCommand
    local _RegisterNUICallback = RegisterNUICallback

    -- Wrap RegisterCommand with xpcall
    function RegisterCommand(cmdName, handler)
        _RegisterCommand(cmdName, function(source, args, rawCmd)
            local ok, err = xpcall(function()
                handler(source, args, rawCmd)
            end, debug.traceback)
            if not ok then
                print("^5=========================^0")
                print("^2Error in: ^1RegisterCommand^0")
                print("^2Event name: ^1" .. cmdName .. "^0")
                print("^5=========================^0")
                DisplayCurrentRecordSteps(cmdName)
                print("^5=========================^0")
                local argDump = { source, args, rawCmd }
                for k, v in pairs(argDump) do
                    print("^0Argument key: ^1" .. tostring(k))
                    print("^0Argument value type: ^1" .. type(v))
                    print(" ")
                    if type(v) == "table" then
                        print("^0Argument value: ^1" .. tostring(v))
                        dumpTable(v)
                    else
                        print("^0Argument value: ^1" .. tostring(v))
                    end
                    print("^5=====^0")
                end
                print("^5=========================^0")
                print(err)
                print("^5=========================^0")
            end
        end)
    end

    -- Wrap RegisterNetEvent with xpcall
    function RegisterNetEvent(eventName, handler)
        if not handler then
            _RegisterNetEvent(eventName)
            return
        end
        _RegisterNetEvent(eventName, function(...)
            local args = { ... }
            local ok, err = xpcall(function()
                handler(table.unpack(args))
            end, debug.traceback)
            if not ok then
                printArgDump(args, eventName, err, dumpTable, false)
            end
        end)
    end

    -- Wrap RegisterNUICallback with xpcall
    function RegisterNUICallback(callbackName, handler)
        _RegisterNUICallback(callbackName, function(...)
            local args = { ... }
            local ok, err = xpcall(function()
                handler(table.unpack(args))
            end, debug.traceback)
            if not ok then
                printArgDump(args, callbackName, err, dumpTable, true)
            end
        end)
    end

    -- Wrap CreateThread with xpcall
    function CreateThread(fn, threadName)
        _CreateThread(function()
            local ok, err = xpcall(fn, debug.traceback)
            if not ok then
                print("=========================")
                print("^2Error in: ^1CreateThread^0")
                print("^1" .. (threadName or "non defined") .. "^0")
                print("=========================")
                DisplayCurrentRecordSteps(threadName)
                print("^5=========================^0")
                print(err)
                print("=========================")
            end
        end)
    end

    -- Wrap AddEventHandler with xpcall
    function AddEventHandler(eventName, handler)
        _AddEventHandler(eventName, function(...)
            local args = { ... }
            local ok, err = xpcall(function()
                handler(table.unpack(args))
            end, debug.traceback)
            if not ok then
                printArgDump(args, eventName, err, dumpTable, false)
            end
        end)
    end
end
