local originalRequire, originalRegisterCommand, originalRegisterNetEvent, originalCreateThread
local originalRegisterNUICallback, originalAddEventHandler

SH = {}
Intervals = {}
RegisterNetworkFlow = {}

glm = require("glm")
MapsLoaded = false

PRISON_ITEMS = {
    sprunk = true,
    sludgie = true,
    ecola_light = true,
    ecola = true,
    coffee = true,
    water = true,
    fries = true,
    pizza_ham = true,
    chips = true,
    donut = true,
    cigarrete = true
}

local function loadDataFile(dataName)
    local filePath = ("data/%s.lua"):format(dataName)
    local fileContent = LoadResourceFile("rcore_prison", filePath)

    local ok, chunkOrError = pcall(load, fileContent, ("@@rcore_prison/%s"):format(filePath))
    if not ok then
        dbg.critical("Failed to load language file [" .. dataName .. "] (%s)", chunkOrError)
        return nil
    end

    return chunkOrError()
end

fetchData = loadDataFile

function doesExportExistInResource(resourceName, exportName)
    local ok = xpcall(function()
        local _ = exports[resourceName][exportName]
    end, debug.traceback)

    return ok
end

function LoadScriptData(scriptName, resourceName, returnExpression)
    if GetResourceState(resourceName) ~= "started" then
        return nil
    end

    local fileName = ("%s.lua"):format(scriptName)
    local fileContent = LoadResourceFile(resourceName, fileName)

    if not fileContent then
        dbg.critical(
            string.format("Error with loading file %s (script:%s)!", fileName, resourceName)
        )
        return nil
    end

    if not returnExpression then
        return fileContent
    end

    local codeToLoad = fileContent .. "return " .. returnExpression
    local ok, chunkOrError = pcall(load, codeToLoad, fileName, "t")

    if not ok then
        dbg.critical(
            string.format("Cannot load datafile %s with error %s", fileName, chunkOrError)
        )
        return nil
    end

    return chunkOrError()
end

function getInteriorData(presetName)
    local currentResource = GetCurrentResourceName()
    local filePath = ("data/presets/%s.lua"):format(presetName)
    local fileContent = LoadResourceFile(currentResource, filePath)
    local chunkName = ("@@%s/%s"):format(currentResource, filePath)

    if not fileContent then
        local selectedMapGroup = string.match(Config.Map, "_(.+)")
        local selectedMapResources = selectedMapGroup and MapsList[selectedMapGroup] or nil
        local detectedResourceName = nil

        if type(selectedMapResources) == "table" then
            detectedResourceName = selectedMapResources[1]
        end

        local extraGuide = ""
        if selectedMapGroup == "RCORE" then
            extraGuide = [[

- Guide: ^5https://documentation.rcore.cz/paid-resources/rcore_prison/installation#rcore^7]]
        end

        print(([[^3============================================================^7
^3[Map - Configuration Warning]^7
------------------------------------------------------------
- File: rcore_prison/config.lua
- You have selected map: Config.Map = ^5Map.%s^7
- The resource name (^5%s^7) was ^1not detected^7 on your server.
   ➝ Running in standalone mode. Default prison yard will be used.%s
^3============================================================^7
]]):format(
            selectedMapGroup or "UNKNOWN",
            detectedResourceName or "UNKNOWN",
            extraGuide
        ))

        return nil
    end

    local ok, chunkOrError = pcall(load, fileContent, chunkName)
    if not ok then
        dbg.critical(
            "Failed to fetch interior data for map %s with load function! Err: %s",
            presetName or "NIL",
            chunkOrError
        )
        return nil
    end

    return chunkOrError()
end

CreateThread(function()
    Wait(0)

    local selectedPreset = {
        name = Config.Map,
        data = {}
    }

    if string.find(Config.Map, "MAPLIST") then
        local mapGroup = string.match(Config.Map, "_(.+)")
        local resourceList = mapGroup and MapsList[mapGroup] or nil

        if resourceList and next(resourceList) then
            local groupConfig = MapsConfig[mapGroup] or {}
            local requireAll = groupConfig.requireAll or false
            local detectedCount = 0
            local expectedCount = 0

            for key, resourceName in pairs(resourceList) do
                if type(key) == "number" then
                    expectedCount = expectedCount + 1

                    if isResourcePresentProvideless(resourceName) and resourceName ~= NONE_RESOURCE then
                        detectedCount = detectedCount + 1
                    end
                end
            end

            if requireAll then
                if detectedCount == expectedCount and expectedCount > 0 then
                    selectedPreset.name = mapGroup:lower():gsub("_", "-")
                end
            elseif detectedCount > 0 then
                selectedPreset.name = mapGroup:lower():gsub("_", "-")
            end
        end
    end

    Config.Map = selectedPreset.name

    dbg.debug("Loading map data for map named: %s", selectedPreset.name)

    if selectedPreset.name == "prompt" then
        selectedPreset.name = "prompt-prison"
    end

    selectedPreset.data = getInteriorData(selectedPreset.name)

    if not selectedPreset.data then
        selectedPreset.name = STANDALONE
        Config.Map = selectedPreset.name
        selectedPreset.data = getInteriorData(selectedPreset.name)
    end

    if not selectedPreset.name then
        dbg.critical("Failed to load prison preset file, see config for supported maps or add own one.")
        return
    end

    SH.data = selectedPreset.data
    SH.preset = selectedPreset.name

    if type(SH.data) ~= "nil" and SH.data.interaction then
        for _, interactionData in pairs(SH.data.interaction) do
            if type(interactionData.items) ~= "nil" then
                local dealerConfig = nil
                local thirdPartyEscape = Config.Escape and Config.Escape.ThirdParty or {}

                for _, thirdPartyData in pairs(thirdPartyEscape) do
                    if isResourcePresentProvideless(thirdPartyData.ScriptName) then
                        if thirdPartyData.Dealer and thirdPartyData.Dealer.Enable then
                            dealerConfig = thirdPartyData.Dealer
                            break
                        end
                    end
                end

                if dealerConfig and dealerConfig.Enable then
                    local itemExists = false

                    for _, itemData in ipairs(interactionData.items) do
                        if itemData.name == dealerConfig.ItemName then
                            itemExists = true
                            break
                        end
                    end

                    if not itemExists then
                        table.insert(interactionData.items, {
                            name = dealerConfig.ItemName,
                            label = dealerConfig.ItemLabel or dealerConfig.ItemName,
                            price = dealerConfig.Cost
                        })
                    end
                end
            end
        end
    end

    TriggerEvent("rcore_prison:shared:internal:MapLoaded")
end, "sh-init code name: Phoenix")

if isResourceLoaded("ox_lib") then
    local fileName = ("%s.lua"):format("init")
    local fileContent = LoadResourceFile("ox_lib", fileName)
    local chunk = assert(load(fileContent, ("@@ox_lib/%s"):format(fileName)))
    chunk()
end

if isResourceLoaded("ND_Core") then
    local fileName = ("%s.lua"):format("init")
    local fileContent = LoadResourceFile("ND_Core", fileName)
    local chunk = assert(load(fileContent, ("@@ND_Core/%s"):format(fileName)))
    chunk()
end

function isResourcePresentProvideless(resourceName)
    local resourceCount = GetNumResources()

    for i = 0, resourceCount - 1 do
        local currentResource = GetResourceByFindIndex(i)
        if currentResource == resourceName and GetResourceState(currentResource) == "started" then
            return true
        end
    end

    return false
end

function getPoliceCount()
    if not IsDuplicityVersion() then
        return 0
    end

    local officers = Framework.getOfficers()
    if officers and next(officers) then
        return #officers
    end

    return 0
end

function FindTargetResource(pattern)
    local resourceCount = GetNumResources()

    for i = 0, resourceCount - 1 do
        local resourceName = GetResourceByFindIndex(i)

        if string.match(resourceName, pattern) and isResourcePresentProvideless(resourceName) then
            return resourceName
        end
    end

    return nil
end

RegisterCommand("rcore_prison_debug", function(source)
    local debugData = {
        framework = Config.Framework,
        notify = Config.Notifies,
        inventory = Config.Inventories,
        clothing = Config.Cloth,
        dispatch = Config.Dispatch or Config.Dispatches,
        interact = Config.Interactions == "none" and "GTA-DISTANCE" or Config.Interactions,
        menu = Config.Menus,
        phone = Config.Phone,
        textUI = Config.TextUI,
        map = Config.Map,
        prisonVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0),
        policeCount = getPoliceCount()
    }

    if type(debugData) == "table" and next(debugData) then
        tprint(debugData)
    else
        dbg.debug("Debug prison: failed to find any data in the list to debug enviroment!")
    end
end, false)

RegisterCommand("debugNetwork", function(source)
    if source == 0 then
        if RegisterNetworkFlow and next(RegisterNetworkFlow) then
            tprint(RegisterNetworkFlow)
        else
            dbg.debug("The network event flow is empty.")
        end
    end
end, false)

if IsDuplicityVersion() then
    EMULATOR_EVENTS_BY_RESOURCE_NAME = {
        qalle = {
            jail = "esx-qalle-jail:jailPlayer",
            unjail = "esx-qalle-jail:unJailPlayer"
        },
        qbcore = {
            jail = "police:server:JailPlayer",
            coms = "qb-communityservice:server:StartCommunityService"
        },
        quasar = {
            jail = "qs-dispatch:server:addPenalListToPlayer"
        }
    }

    EnableGuidebook = false

    function provideDebugEmulator(debugName, resourceAlias, playerId, eventType)
        if not debugName or not resourceAlias or not playerId or not eventType then
            return
        end

        local eventName = "UNK_EVENT_NAME"
        local emulatorResource = EMULATOR_EVENTS_BY_RESOURCE_NAME[resourceAlias]

        if emulatorResource and emulatorResource[eventType] then
            eventName = emulatorResource[eventType]
        end

        dbg.debugAPI(
            "[%s] was invoked by user [%s | %s] - Loading %s %s event named: %s",
            debugName,
            playerId,
            (GetPlayerName(playerId) or "UNK-PLAYER"),
            eventType,
            resourceAlias or "UNK_RESOURCE",
            eventName
        )
    end
end

function provideExport(exportName, resourceName, exportCallback)
    if not dbg then
        dbg = rdebug()
    end

    if resourceName ~= GetCurrentResourceName() then
        dbg.debugAPI(
            "Providing export emulation for export named: %s | resource: %s",
            exportName,
            resourceName
        )
    end

    AddEventHandler(("__cfx_export_%s_%s"):format(resourceName, exportName), function(setExport)
        dbg.debugAPI(
            "Emulator was called from %s | emulate-resource: %s",
            GetInvokingResource(),
            resourceName
        )

        setExport(exportCallback)
    end)
end

local errorDebugEnabled = Config.ErrorDebug or false
local debugSessions = {}

function StartDebugSession(sessionName)
    if errorDebugEnabled then
        debugSessions[sessionName] = {
            stepCount = 0,
            stepData = {}
        }
    end
end

function DestroyDebugSession(sessionName)
    DisplayCurrentRecordSteps(sessionName)

    if errorDebugEnabled then
        debugSessions[sessionName] = nil
    end
end

function DebugRecordStep(sessionName, stepName)
    if not errorDebugEnabled then
        return
    end

    local session = debugSessions[sessionName]
    if not session then
        return
    end

    session.stepCount = session.stepCount + 1
    session.stepData[session.stepCount] = stepName
end

function DisplayCurrentRecordSteps(sessionName)
    if not errorDebugEnabled then
        return
    end

    local session = debugSessions[sessionName]
    if not session then
        return
    end

    for _, stepName in ipairs(session.stepData) do
        print("^0Step name: ^1" .. tostring(stepName))
    end

    print("^5=====^0")
    print("^0Last step before the error: ^1" .. tostring(session.stepData[#session.stepData]))
end

if errorDebugEnabled then
    originalAddEventHandler = AddEventHandler
    originalRegisterNetEvent = RegisterNetEvent
    originalCreateThread = CreateThread
    originalRegisterCommand = RegisterCommand
    originalRegisterNUICallback = RegisterNUICallback

    local function serializeTable(value, silent, depth, visited)
        depth = depth or 1
        visited = visited or {}

        if type(value) ~= "table" then
            return tostring(value)
        end

        if visited[value] then
            return "{ --[[ circular ]] }"
        end

        visited[value] = true

        local lines = { "{\n" }

        for key, innerValue in pairs(value) do
            local keyText
            if type(key) == "number" or type(key) == "boolean" then
                keyText = "[" .. tostring(key) .. "]"
            else
                keyText = "['" .. tostring(key) .. "']"
            end

            local valueText
            if type(innerValue) == "number" or type(innerValue) == "boolean" then
                valueText = tostring(innerValue)
            elseif type(innerValue) == "table" then
                valueText = serializeTable(innerValue, true, depth + 1, visited)
            else
                valueText = "'" .. tostring(innerValue) .. "'"
            end

            table.insert(
                lines,
                string.rep("\t", depth) .. keyText .. " = " .. valueText .. ",\n"
            )
        end

        table.insert(lines, string.rep("\t", depth - 1) .. "}")
        local output = table.concat(lines)

        if not silent then
            print(output)
        end

        return output
    end

    local function printWrappedError(kind, name, args, err, replicationEvent)
        print("^5=========================^0")
        print("^2Error in: ^1" .. kind .. "^0")

        if name then
            print("^2Event name: ^1" .. tostring(name) .. "^0")
        end

        print("^5=========================^0")

        if name then
            DisplayCurrentRecordSteps(name)
            print("^5=========================^0")
        end

        for index, value in pairs(args or {}) do
            print("^0Argument key: ^1" .. tostring(index))
            print("^0Argument value type: ^1" .. type(value))
            print(" ")

            if type(value) == "table" then
                print("^0Argument value: ^1" .. tostring(value))
                serializeTable(value)
            else
                print("^0Argument value: ^1" .. tostring(value))
            end

            print("^5=====^0")
        end

        print("^5=========================^0")
        print(err)
        print("^5=========================^0")

        if replicationEvent then
            local formattedArgs = {}

            for _, value in ipairs(args or {}) do
                if type(value) == "table" then
                    table.insert(formattedArgs, serializeTable(value, true))
                elseif type(value) == "string" then
                    table.insert(formattedArgs, "'" .. value .. "'")
                else
                    table.insert(formattedArgs, tostring(value))
                end
            end

            print("^0Replication trigger event:")
            print("^1" .. replicationEvent .. "(" .. table.concat(formattedArgs, ",") .. ")")
            print("^5=========================^0")
        end
    end

    RegisterCommand = function(commandName, callback, restricted)
        originalRegisterCommand(commandName, function(...)
            local packedArgs = table.pack(...)
            local ok, err = xpcall(function()
                callback(table.unpack(packedArgs, 1, packedArgs.n))
            end, debug.traceback)

            if not ok then
                printWrappedError("RegisterCommand", commandName, packedArgs, err)
            end
        end, restricted)
    end

    RegisterNetEvent = function(eventName, callback)
        if not callback then
            originalRegisterNetEvent(eventName)
            return
        end

        originalRegisterNetEvent(eventName, function(...)
            local packedArgs = table.pack(...)
            local ok, err = xpcall(function()
                callback(table.unpack(packedArgs, 1, packedArgs.n))
            end, debug.traceback)

            if not ok then
                printWrappedError(
                    "RegisterNetEvent",
                    eventName,
                    packedArgs,
                    err,
                    "TriggerEvent('" .. eventName .. "'"
                )
            end
        end)
    end

    RegisterNUICallback = function(eventName, callback)
        originalRegisterNUICallback(eventName, function(...)
            local packedArgs = table.pack(...)
            local ok, err = xpcall(function()
                callback(table.unpack(packedArgs, 1, packedArgs.n))
            end, debug.traceback)

            if not ok then
                printWrappedError(
                    "RegisterNUICallback",
                    eventName,
                    packedArgs,
                    err,
                    "TriggerEvent('__cfx_nui:" .. eventName .. "'"
                )
            end
        end)
    end

    CreateThread = function(threadCallback, threadName)
        originalCreateThread(function()
            local ok, err = xpcall(threadCallback, debug.traceback)

            if not ok then
                print("=========================")
                print("^2Error in: ^1CreateThread^0")
                print("^1" .. tostring(threadName or "non defined") .. "^0")
                print("=========================")
                DisplayCurrentRecordSteps(threadName)
                print("^5=========================^0")
                print(err)
                print("=========================")
            end
        end)
    end

    AddEventHandler = function(eventName, callback)
        originalAddEventHandler(eventName, function(...)
            local packedArgs = table.pack(...)
            local ok, err = xpcall(function()
                callback(table.unpack(packedArgs, 1, packedArgs.n))
            end, debug.traceback)

            if not ok then
                printWrappedError(
                    "AddEventHandler",
                    eventName,
                    packedArgs,
                    err,
                    "TriggerEvent('" .. eventName .. "'"
                )
            end
        end)
    end
end