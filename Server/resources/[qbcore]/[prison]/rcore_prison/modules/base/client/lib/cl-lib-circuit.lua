local defaultTextureDicts = {
    "mpcircuithack",
    "mpcircuithack",
    "mpcircuithack"
}

local defaultLevelPortLayouts = {
    [1] = {
        { 0.24, 0.50, 0.04, 0.06, 90.0 },
        { 0.76, 0.50, 0.04, 0.06, 270.0 }
    },
    [2] = {
        { 0.24, 0.36, 0.04, 0.06, 90.0 },
        { 0.76, 0.64, 0.04, 0.06, 270.0 }
    },
    [3] = {
        { 0.24, 0.64, 0.04, 0.06, 90.0 },
        { 0.76, 0.36, 0.04, 0.06, 270.0 }
    },
    [4] = {
        { 0.20, 0.28, 0.04, 0.06, 90.0 },
        { 0.80, 0.72, 0.04, 0.06, 270.0 }
    },
    [5] = {
        { 0.20, 0.72, 0.04, 0.06, 90.0 },
        { 0.80, 0.28, 0.04, 0.06, 270.0 }
    },
    [6] = {
        { 0.18, 0.50, 0.04, 0.06, 90.0 },
        { 0.82, 0.50, 0.04, 0.06, 270.0 }
    }
}

local defaultLevelPathLayouts = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {}
}

local textureDicts = type(SHX0_1) == "table" and SHX0_1 or defaultTextureDicts
local isPlaying = SHX1_1 == true
local currentBackgroundDict = type(SHX2_1) == "string" and SHX2_1 or textureDicts[2]
local currentBackgroundSprite = type(SHX3_1) == "string" and SHX3_1 or "cblevel1"
local currentLevel = type(SHX4_1) == "number" and SHX4_1 or 1
local levelPortLayouts = type(SHX5_1) == "table" and SHX5_1 or defaultLevelPortLayouts
local levelPathLayouts = type(SHX6_1) == "table" and SHX6_1 or defaultLevelPathLayouts
local placedSegments = type(SHX7_1) == "table" and SHX7_1 or {}
local activeSegment = SHX8_1
local previousSegment = SHX9_1
local pulseAlpha = type(SHX10_1) == "number" and SHX10_1 or 255
local sparkAlpha = type(SHX11_1) == "number" and SHX11_1 or 255
local trailColor = type(SHX12_1) == "table" and SHX12_1 or { 69, 237, 170, 255 }
local hasFinished = SHX13_1 == true
local hackingMessageScaleform = type(SHX14_1) == "number" and SHX14_1 or 0
local trailSoundId = type(SHX15_1) == "number" and SHX15_1 or -1
local lastFrameTime = type(SHX16_1) == "number" and SHX16_1 or 0
local onFinish = type(SHX17_1) == "function" and SHX17_1 or nil
local remainingLives = type(SHX18_1) == "number" and SHX18_1 or 3
local hasCrashed = SHX19_1 == true
local cellWidth = type(SHX20_1) == "number" and SHX20_1 or 0.010
local cellHeight = type(SHX21_1) == "number" and SHX21_1 or 0.014
local backgroundAlpha = type(SHX22_1) == "number" and SHX22_1 or 255
ScaleformUtils = type(_G.ScaleformUtils) == "table" and _G.ScaleformUtils or (type(SHX23_1) == "table" and SHX23_1 or {})

local function loadResources()
    for _, textureDict in pairs(textureDicts) do
        RequestStreamedTextureDict(textureDict)

        while not HasStreamedTextureDictLoaded(textureDict) do
            Wait(0)
        end
    end

    RequestScriptAudioBank("DLC_MPHEIST/HEIST_HACK_SNAKE", false, -1)

    hackingMessageScaleform = RequestScaleformMovie("HACKING_MESSAGE")
    while not HasScaleformMovieLoaded(hackingMessageScaleform) do
        Wait(0)
    end
end

local function unloadResources()
    for _, textureDict in pairs(textureDicts) do
        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
    end

    SetScaleformMovieAsNoLongerNeeded(hackingMessageScaleform)
end

local function drawSpriteFromTopLeft(dict, sprite, x, y, width, height, r, g, b, a)
    DrawSprite(
        dict,
        sprite,
        x + (width * 0.5),
        y + (height * 0.5),
        width,
        height,
        0.0,
        r,
        g,
        b,
        a
    )
end

local function getSegmentRect(segment)
    local x = segment[2]
    local y = segment[3]
    local width = cellWidth
    local height = cellHeight
    local direction = segment[1]
    local length = segment[4]

    if direction == 0 then
        width = width * length
    elseif direction == 1 then
        width = width * length
        x = (x - width) + cellWidth
    elseif direction == 2 then
        height = height * length
        y = (y - height) + cellHeight
    elseif direction == 3 then
        height = height * length
    end

    return x, y, width, height
end

local function getSegmentEnd(segment)
    local x = segment[2]
    local y = segment[3]
    local direction = segment[1]
    local length = segment[4]

    if direction == 0 then
        x = x + (length * cellWidth)
    elseif direction == 1 then
        x = x - (length * cellWidth)
    elseif direction == 2 then
        y = y - (length * cellHeight)
    elseif direction == 3 then
        y = y + (length * cellHeight)
    end

    return x, y
end

local function segmentsOverlap(segmentA, segmentB)
    local ax, ay, aw, ah = getSegmentRect(segmentA)
    local bx, by, bw, bh = getSegmentRect(segmentB)

    local overlapLeft = math.max(ax, bx)
    local overlapRight = math.min(ax + aw, bx + bw)
    local overlapTop = math.max(ay, by)
    local overlapBottom = math.min(ay + ah, by + bh)

    return overlapLeft <= overlapRight and overlapTop <= overlapBottom
end

local function isCrashState()
    for _, segment in pairs(placedSegments) do
        if segment ~= activeSegment and segment ~= previousSegment then
            if segmentsOverlap(activeSegment, segment) then
                return true
            end
        end
    end

    local headX, headY = getSegmentEnd(activeSegment)

    if headX < 0.15 or headX > 0.84 or headY < 0.15 or headY > 0.84 then
        return true
    end

    return false
end

local function pushSegment(direction)
    local newSegment = {
        direction,
        0.565,
        0.7,
        0.0,
        true
    }

    if activeSegment then
        newSegment[2], newSegment[3] = getSegmentEnd(activeSegment)
        previousSegment = activeSegment
    else
        newSegment[2] = levelPortLayouts[currentLevel][1][1]
        newSegment[3] = levelPortLayouts[currentLevel][1][2]
    end

    activeSegment = newSegment
    table.insert(placedSegments, newSegment)

    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
end

local function showDisplayScaleform(title, message, r, g, b, immediate)
    ScaleformUtils.CallFunction(
        hackingMessageScaleform,
        false,
        "SET_DISPLAY",
        title,
        message,
        r,
        g,
        b,
        immediate
    )
end

function ClearScreen()
    BeginScaleformMovieMethod(hackingMessageScaleform, "SET_DISPLAY")
    ScaleformMovieMethodAddParamInt(-1)
    EndScaleformMovieMethod()
end

function ReconnectingScreen()
    showDisplayScaleform(
        _U("CIRCUIT_MINIGAME.RECONNECT_TITLE"),
        ("%s [%s]"):format(_U("CIRCUIT_MINIGAME.RECONNECT_MESSAGE"), remainingLives),
        45,
        203,
        134,
        true
    )
end

function ShowSuccScreen()
    showDisplayScaleform(
        _U("CIRCUIT_MINIGAME.FINISH_TITLE"),
        _U("CIRCUIT_MINIGAME.FINISH_MESSAGE"),
        45,
        203,
        134,
        true
    )
end

function ShowFailureScreen()
    showDisplayScaleform(
        _U("CIRCUIT_MINIGAME.FAILED_TITLE"),
        _U("CIRCUIT_MINIGAME.FAILED_MESSAGE"),
        45,
        203,
        134,
        true
    )
end

function PlayerExit()
    if not isPlaying then
        return dbg.debug("playing__failure")
    end

    if hasCrashed then
        return dbg.debug("crashed_failure")
    end

    dbg.debug("Player is exiting the circuit minigame.")

    HelpKeys.Hide()
    isPlaying = false

    if onFinish then
        onFinish(false)
    end
end

local function handleSuccess()
    StopSound(trailSoundId)

    local goalSoundId = GetSoundId()
    PlaySoundFrontend(goalSoundId, "Goal", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
    ShowSuccScreen()

    CreateThread(function()
        Wait(500)

        for _ = 1, 3 do
            for alpha = 255, 0, -10 do
                trailColor[4] = alpha
                Wait(33)
            end
        end

        StopSound(goalSoundId)

        isPlaying = false
        if onFinish then
            onFinish(true)
        end
    end, "cl-lib-circuit code name: Phoenix")
end

local function drawPlacedSegments()
    for _, segment in pairs(placedSegments) do
        if segment[5] then
            local x, y, width, height = getSegmentRect(segment)

            drawSpriteFromTopLeft(
                "mpcircuithack",
                "tail",
                x,
                y,
                width,
                height,
                trailColor[1],
                trailColor[2],
                trailColor[3],
                trailColor[4]
            )
        end
    end
end

local function drawCurrentHead()
    if not activeSegment then
        return
    end

    local headX, headY = getSegmentEnd(activeSegment)

    local headWidth = 0.015
    local headHeight = 0.02
    local sparkWidth = headWidth * 2
    local sparkHeight = headWidth * 2

    pulseAlpha = Repeat(GetGameTimer() * 2, 130)

    if not hasFinished then
        drawSpriteFromTopLeft(
            "mpcircuithack",
            "light",
            headX - (sparkWidth / 2.2),
            headY - (sparkHeight / 2.5),
            sparkWidth,
            sparkHeight,
            trailColor[1],
            trailColor[2],
            trailColor[3],
            pulseAlpha
        )
    end

    drawSpriteFromTopLeft(
        "mpcircuithack",
        "head",
        headX - (headWidth / 2.5),
        headY - (headHeight / 2.5),
        headWidth,
        headHeight,
        trailColor[1],
        trailColor[2],
        trailColor[3],
        trailColor[4]
    )

    drawSpriteFromTopLeft(
        "mpcircuithack",
        "spark",
        headX - (sparkWidth / 2.5),
        headY - (sparkHeight / 2.5),
        sparkWidth,
        sparkHeight,
        255,
        255,
        255,
        sparkAlpha
    )

    local targetPort = levelPortLayouts[currentLevel][2]
    local distanceToGoal = #(vector2(headX, headY) - vector2(targetPort[1], targetPort[2]))

    if distanceToGoal < 0.03 and not hasFinished then
        hasFinished = true
        handleSuccess()
    end
end

local function drawPorts()
    local startPort = levelPortLayouts[currentLevel][1]
    local endPort = levelPortLayouts[currentLevel][2]

    DrawSprite(
        "mpcircuithack",
        "genericport",
        startPort[1],
        startPort[2],
        startPort[3],
        startPort[4],
        startPort[5],
        255,
        255,
        255,
        255
    )

    DrawSprite(
        "mpcircuithack",
        "genericport",
        endPort[1],
        endPort[2],
        endPort[3],
        endPort[4],
        endPort[5],
        255,
        255,
        255,
        255
    )
end

local function drawBackground()
    DrawSprite(
        currentBackgroundDict,
        currentBackgroundSprite,
        0.5,
        0.5,
        1.0,
        1.0,
        0.0,
        255,
        255,
        255,
        backgroundAlpha
    )
end

local function handleFailure()
    PlaySoundFrontend(-1, "Failure", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
    hasCrashed = true

    CreateThread(function()
        sparkAlpha = 255
        trailColor = { 237, 68, 71, 255 }

        if hasCrashed then
            ReconnectingScreen()
        end

        Wait(500)

        for alpha = 255, 0, -10 do
            trailColor[4] = alpha
            sparkAlpha = alpha
            Wait(33)
        end

        Wait(33)

        placedSegments = {}
        activeSegment = nil
        previousSegment = nil
        remainingLives = remainingLives - 1

        Wait(1000)

        if remainingLives > 0 then
            StartPlaying(currentLevel, remainingLives, true)
        else
            isPlaying = false

            if onFinish then
                onFinish(false)
            end

            ShowFailureScreen()
            Jobs.ExitJob(MinigameStates.CIRCUIT_NOT_ENOUGH_LIFES)
        end
    end, "cl-lib-circuit code name: Alfa")
end

local function handleControls()
    if not activeSegment then
        return
    end

    local keybinds = Config.Circuit.Keybinds

    if IsControlJustPressed(0, keybinds.ARROW_UP) then
        dbg.debug("ELECTRICIAN - ARROW UP")

        if activeSegment[1] ~= 2 and activeSegment[1] ~= 3 then
            pushSegment(2)
        end
    end

    if IsControlJustPressed(0, keybinds.ARROW_DOWN) then
        dbg.debug("ELECTRICIAN - ARROW DOWN")

        if activeSegment[1] ~= 3 and activeSegment[1] ~= 2 then
            pushSegment(3)
        end
    end

    if IsControlJustPressed(0, keybinds.LEFT_ARROW) then
        dbg.debug("ELECTRICIAN - LEFT ARROW")

        if activeSegment[1] ~= 1 and activeSegment[1] ~= 0 then
            pushSegment(1)
        end
    end

    if IsControlJustPressed(0, keybinds.RIGHT_ARROW) then
        dbg.debug("ELECTRICIAN - RIGHT ARROW")

        if activeSegment[1] ~= 0 and activeSegment[1] ~= 1 then
            pushSegment(0)
        end
    end

    if IsControlJustPressed(0, keybinds.BACKSPACE) then
        dbg.debug("ELECTRICIAN - EXITING")
        PlayerExit()
    end
end

function StartPlaying(level, lifes, isRestart, withTrailSound)
    if isPlaying and not isRestart then
        return
    end

    if type(level) ~= "number" then
        level = 1
    end

    if not levelPortLayouts[level] then
        level = 1
    end

    if not levelPathLayouts[level] then
        levelPathLayouts[level] = {}
    end

    if hasCrashed then
        ClearScreen()
    end

    remainingLives = lifes
    hasFinished = false
    isPlaying = true

    if level <= 3 then
        currentBackgroundDict = textureDicts[2]
    else
        currentBackgroundDict = textureDicts[3]
    end

    currentBackgroundSprite = ("cblevel%s"):format(level)
    currentLevel = level

    activeSegment = nil
    previousSegment = nil
    trailColor = { 69, 237, 170, 255 }
    placedSegments = {}
    hasCrashed = false
    lastFrameTime = GetGameTimer()
    trailSoundId = GetSoundId()

    PlaySoundFrontend(-1, "Start", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)

    if withTrailSound then
        PlaySoundFrontend(trailSoundId, "Trail_Custom", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
    end

    for i = 1, #levelPathLayouts[currentLevel] do
        table.insert(placedSegments, levelPathLayouts[currentLevel][i])
    end

    pushSegment(0)

    if isRestart then
        return
    end

    local helpKeyOverrides = Config.Circuit.HelpKeys or nil

    CreateThread(function()
        local frameStart = GetGameTimer()

        HelpKeys.Show({
            { label = _U("CIRCUIT_MINIGAME.GUIDE"), keyName = "" },
            {
                label = _U("CIRCUIT_MINIGAME.EXIT"),
                keyName = helpKeyOverrides and helpKeyOverrides.EXIT or "BACKSPACE"
            },
            {
                label = _U("CIRCUIT_MINIGAME.ARROW_UP"),
                keyName = helpKeyOverrides and helpKeyOverrides.ARROW_UP or "ArrowUp"
            },
            {
                label = _U("CIRCUIT_MINIGAME.ARROW_DOWN"),
                keyName = helpKeyOverrides and helpKeyOverrides.ARROW_DOWN or "ArrowDown"
            },
            {
                label = _U("CIRCUIT_MINIGAME.ARROW_LEFT"),
                keyName = helpKeyOverrides and helpKeyOverrides.ARROW_LEFT or "ArrowLeft"
            },
            {
                label = _U("CIRCUIT_MINIGAME.ARROW_RIGHT"),
                keyName = helpKeyOverrides and helpKeyOverrides.ARROW_RIGHT or "ArrowRight"
            }
        }, "top-left")

        while isPlaying do
            ResetScriptGfxAlign()

            drawBackground()
            drawPlacedSegments()
            drawCurrentHead()
            drawPorts()

            if HasScaleformMovieLoaded(hackingMessageScaleform) then
                DrawScaleformMovieFullscreen(hackingMessageScaleform, 100, 100, 100, 255, 0)
            end

            handleControls()

            if not hasFinished and isCrashState() then
                hasFinished = true
                handleFailure()
            end

            Wait(0)

            if activeSegment and not hasFinished then
                local now = GetGameTimer()
                local delta = now - frameStart

                activeSegment[4] = activeSegment[4] + (0.035 * delta)
                frameStart = now
            else
                frameStart = GetGameTimer()
            end
        end

        unloadResources()
    end, "cl-lib-circuit code name: Omega")
end

function Clamp(value, minValue, maxValue)
    if value < minValue then
        value = minValue
    elseif value > maxValue then
        value = maxValue
    end

    return value
end

function Repeat(value, maxValue)
    local repeatedValue = value - (math.floor(value / maxValue) * maxValue)
    return Clamp(repeatedValue, 0.0, maxValue)
end

function GetTextFromKey(key)
    local text = GetLabelText(key)
    if not text or text == "NULL" then
        return "unk"
    end

    return text
end

function ScaleformUtils.Request(scaleformName)
    local scaleform = RequestScaleformMovie(scaleformName)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    return scaleform
end

function ScaleformUtils.CallFunction(scaleform, expectsReturn, methodName, ...)
    BeginScaleformMovieMethod(scaleform, methodName)

    local args = { ... }

    for i = 1, #args do
        local value = args[i]
        local valueType = type(value)

        if valueType == "boolean" then
            ScaleformMovieMethodAddParamBool(value)
        elseif valueType == "number" then
            if tostring(value):find("%.") then
                ScaleformMovieMethodAddParamFloat(value)
            else
                ScaleformMovieMethodAddParamInt(value)
            end
        elseif valueType == "string" then
            ScaleformMovieMethodAddParamTextureNameString(value)
        end
    end

    if expectsReturn then
        return EndScaleformMovieMethodReturnValue()
    end

    EndScaleformMovieMethod()
end

Controller = {}

function Controller.LoadAndStart(level, lifes, callback)
    onFinish = callback

    CreateThread(function()
        loadResources()
        StartPlaying(level, lifes)
    end, "cl-lib-circuit code name: Beta")
end

function Controller.IsActive()
    return isPlaying
end

function Controller.Stop()
    isPlaying = false
end

exports("GetCircuitBoard", function()
    return Controller
end)

CreateThread(function()
    AddTextEntry("PRISON_CIRCUIT_HACK", _U("CIRCUIT_MINIGAME.GUIDE"))
end, "cl-lib-circuit code name: Bravo")