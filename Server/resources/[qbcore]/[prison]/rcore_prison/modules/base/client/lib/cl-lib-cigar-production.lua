local CigarProduction = {}

local ARROW_WIDTH = 0.05
local ARROW_HEIGHT = 0.015
local TRACK_WIDTH = 0.04

local MOVE_STEP = Config.Minigame.MoveStep or 0.09
local LEFT_TARGET_X = 0.4
local RIGHT_TARGET_X = 0.6
local HIT_TOLERANCE = Config.Minigame.Tolerance or 0.025

local isMinigameActive = false
local leftQueue = {}
local rightQueue = {}

local currentAnimDict = nil
local currentAnimName = nil

local keyDisplayOrder = Config.Minigame.Keys or { "W", "S", "A", "D" }
local keybinds = Config.Minigame.Keybinds or {
    W = "W",
    S = "S",
    A = "A",
    D = "D"
}

local rightSideBindings = {
    ARROW_UP = "UP",
    ARROW_DOWN = "DOWN",
    LEFT_ARROW = "LEFT",
    RIGHT_ARROW = "RIGHT"
}

local leftInputFailCallback = nil
local rightInputFailCallback = nil

local function tableCount(tbl)
    local count = 0

    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function CigarProduction.RequestOpen()
    TriggerServerEvent("rcore_prison:server:requestCigarProduction", SH.zoneId)
end

local function findMatchingLeftLetter(letter)
    for index, entry in pairs(leftQueue) do
        local distanceFromHitZone = math.abs(entry.time - LEFT_TARGET_X)

        if distanceFromHitZone <= HIT_TOLERANCE and entry.letter == letter then
            return index
        end
    end

    return nil
end

local function findMatchingRightLetter(letter)
    for index, entry in pairs(rightQueue) do
        local screenX = 1.0 - entry.time
        local distanceFromHitZone = math.abs(screenX - RIGHT_TARGET_X)

        if distanceFromHitZone <= HIT_TOLERANCE and entry.letter == letter then
            return index
        end
    end

    return nil
end

local function stopCurrentMinigameAnim()
    StopAnimTask(PlayerPedId(), currentAnimDict, currentAnimName, 1.0)
end

local function generateLetterQueues(totalLetters, startTime)
    local currentTime = startTime or 0.3

    leftQueue = {}
    rightQueue = {}

    for _ = 1, totalLetters do
        local randomOffset = math.random(70, 150) / 1000
        currentTime = currentTime - randomOffset

        table.insert(leftQueue, {
            time = currentTime,
            letter = keyDisplayOrder[math.random(1, #keyDisplayOrder)]
        })

        if math.random(1, 100) < 80 then
            table.insert(rightQueue, {
                time = currentTime,
                letter = keyDisplayOrder[math.random(1, #keyDisplayOrder)]
            })
        end
    end
end

local function failMinigame()
    stopCurrentMinigameAnim()

    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
    Wait(100)

    isMinigameActive = false

    FreezePlayer(PlayerId(), false)
    TriggerEvent("rcore_prison:hudState", "cigar", true)
    TriggerServerEvent("rcore_prison:server:requestCigarProductionFailed", SH.zoneId)
    TriggerLocalClientEvent("onHud", true, "SHOW_HUD", "MINIGAME_FINISHED")
end

local function handleLeftInput(letter, failCallback)
    if not letter then
        return
    end

    local matchIndex = findMatchingLeftLetter(letter)

    if not matchIndex then
        failMinigame()

        if failCallback then
            failCallback()
        end

        return
    end

    leftQueue[matchIndex] = nil
    PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE")
end

local function handleRightInput(letter, failCallback)
    if not letter then
        return
    end

    local matchIndex = findMatchingRightLetter(letter)

    if not matchIndex then
        failMinigame()

        if failCallback then
            failCallback()
        end

        return
    end

    rightQueue[matchIndex] = nil
    PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE")
end

local function finishMinigameSuccess()
    stopCurrentMinigameAnim()
    Wait(100)

    isMinigameActive = false

    TriggerLocalClientEvent("onHud", true, "SHOW_HUD", "MINIGAME_FINISHED")
    FreezePlayer(PlayerId(), false)
end

KeyPressMinigameSuccess = finishMinigameSuccess

local function drawLetter(letter, x, y, highlight)
    SetTextFont(7)
    SetTextScale(1.0, 1.0)

    if highlight then
        SetTextColour(200, 255, 200, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end

    SetTextOutline()
    SetTextCentre(true)
    SetTextJustification(0)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(letter)
    EndTextCommandDisplayText(x, y - 0.027)
end

DrawLetter = drawLetter

local function drawArrow(letter, x, y, highlight)
    RequestStreamedTextureDict("mparrow", false)

    local r, g, b = 255, 255, 255
    if highlight then
        r, g, b = 200, 255, 200
    end

    local aspectRatio = GetAspectRatio()

    if letter == keyDisplayOrder[4] then
        DrawSprite("mparrow", "mp_arrowlarge", x, y, ARROW_HEIGHT, ARROW_HEIGHT * 2 * aspectRatio, 0.0, r, g, b, 255)
    elseif letter == keyDisplayOrder[3] then
        DrawSprite("mparrow", "mp_arrowlarge", x, y, ARROW_HEIGHT, ARROW_HEIGHT * 2 * aspectRatio, 180.0, r, g, b, 255)
    elseif letter == keyDisplayOrder[2] then
        DrawSprite("mparrow", "mp_arrowlarge", x, y, ARROW_HEIGHT * 2, ARROW_HEIGHT * aspectRatio, 90.0, r, g, b, 255)
    elseif letter == keyDisplayOrder[1] then
        DrawSprite("mparrow", "mp_arrowlarge", x, y, ARROW_HEIGHT * 2, ARROW_HEIGHT * aspectRatio, -90.0, r, g, b, 255)
    end
end

local function pressLeftW()
    if not isMinigameActive then
        return
    end

    handleLeftInput(keybinds.W, leftInputFailCallback)
end

local function pressLeftS()
    if not isMinigameActive then
        return
    end

    handleLeftInput(keybinds.S, leftInputFailCallback)
end

local function pressLeftA()
    if not isMinigameActive then
        return
    end

    handleLeftInput(keybinds.A, leftInputFailCallback)
end

local function pressLeftD()
    if not isMinigameActive then
        return
    end

    handleLeftInput(keybinds.D, leftInputFailCallback)
end

local function pressRightW()
    if not isMinigameActive then
        return
    end

    handleRightInput(keybinds.W, rightInputFailCallback)
end

local function pressRightS()
    if not isMinigameActive then
        return
    end

    handleRightInput(keybinds.S, rightInputFailCallback)
end

local function pressRightA()
    if not isMinigameActive then
        return
    end

    handleRightInput(keybinds.A, rightInputFailCallback)
end

local function pressRightD()
    if not isMinigameActive then
        return
    end

    handleRightInput(keybinds.D, rightInputFailCallback)
end

PressLeftW = pressLeftW
PressLeftS = pressLeftS
PressLeftA = pressLeftA
PressLeftD = pressLeftD
PressRightW = pressRightW
PressRightS = pressRightS
PressRightA = pressRightA
PressRightD = pressRightD

RegisterKey(PressLeftW, "MINIGAME_LEFT_W", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_LEFT_W"), keybinds.W)
RegisterKey(PressLeftS, "MINIGAME_LEFT_S", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_LEFT_S"), keybinds.S)
RegisterKey(PressLeftA, "MINIGAME_LEFT_A", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_LEFT_A"), keybinds.A)
RegisterKey(PressLeftD, "MINIGAME_LEFT_D", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_LEFT_D"), keybinds.D)

RegisterKey(PressRightW, "MINIGAME_RIGHT_W", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_RIGHT_W"), rightSideBindings.ARROW_UP)
RegisterKey(PressRightS, "MINIGAME_RIGHT_S", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_RIGHT_S"), rightSideBindings.ARROW_DOWN)
RegisterKey(PressRightA, "MINIGAME_RIGHT_A", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_RIGHT_A"), rightSideBindings.LEFT_ARROW)
RegisterKey(PressRightD, "MINIGAME_RIGHT_D", _U("MINIGAME_CIGAR_PRODUCTION.KEY_MAPPING_PRESS_RIGHT_D"), rightSideBindings.RIGHT_ARROW)

function StartCigarProduction(totalLetters, startTime, animDict, animName, successCallback, failCallback)
    if isMinigameActive then
        return
    end

    FreezePlayer(PlayerId(), true)

    dbg.debug("RCore Minigame: Setting up settings")

    currentAnimDict = animDict
    currentAnimName = animName
    isMinigameActive = true

    RequestStreamedTextureDict("helicopterhud", false)
    TriggerLocalClientEvent("onHud", false, "HIDE_HUD", "MINIGAME_STARTED")

    LoadAnim(animDict)

    TaskPlayAnim(
        PlayerPedId(),
        currentAnimDict,
        currentAnimName,
        5.0,
        1.0,
        -1,
        17,
        0,
        0,
        0,
        0
    )

    generateLetterQueues(totalLetters, startTime)

    dbg.debug("RCore Minigame: Keys are defined!")

    if not keybinds then
        dbg.critical("Minigame keys are not defined!")
        return
    end

    dbg.debug("RCore Minigame: Starting minigame")

    local onFailure = failCallback
    local onSuccess = successCallback

    CreateThread(function()
        while isMinigameActive do
            Wait(0)

            DrawSprite("helicopterhud", "hud_outline", LEFT_TARGET_X, 0.8, ARROW_WIDTH, ARROW_WIDTH * GetAspectRatio(), 0.0, 255, 255, 255, 255)
            DrawRect(0.4, 0.8, TRACK_WIDTH, TRACK_WIDTH * GetAspectRatio(), 0, 0, 0, 150)

            DrawSprite("helicopterhud", "hud_outline", RIGHT_TARGET_X, 0.8, ARROW_WIDTH, ARROW_WIDTH * GetAspectRatio(), 0.0, 255, 255, 255, 255)
            DrawRect(0.6, 0.8, TRACK_WIDTH, TRACK_WIDTH * GetAspectRatio(), 0, 0, 0, 150)

            local remainingInputs = tableCount(leftQueue) + tableCount(rightQueue)
            if remainingInputs == 0 then
                finishMinigameSuccess()

                if onSuccess then
                    dbg.debug("Minigame: Invoking succ callback")
                    onSuccess()
                end

                isMinigameActive = false
                return
            end

            for index, entry in pairs(leftQueue) do
                entry.time = entry.time + MOVE_STEP * GetFrameTime()

                drawLetter(
                    entry.letter,
                    entry.time,
                    0.8,
                    math.abs(entry.time - LEFT_TARGET_X) <= HIT_TOLERANCE
                )

                if entry.time > (LEFT_TARGET_X + HIT_TOLERANCE) then
                    failMinigame()

                    if onFailure then
                        dbg.debug("Minigame: Invoking failure callback")
                        onFailure()
                    end

                    isMinigameActive = false
                    return
                end
            end

            for index, entry in pairs(rightQueue) do
                entry.time = entry.time + MOVE_STEP * GetFrameTime()

                drawArrow(
                    entry.letter,
                    1.0 - entry.time,
                    0.8,
                    math.abs((1.0 - entry.time) - RIGHT_TARGET_X) <= HIT_TOLERANCE
                )

                if entry.time > (RIGHT_TARGET_X + HIT_TOLERANCE) then
                    failMinigame()

                    if onFailure then
                        dbg.debug("Minigame: Invoking failure callback")
                        onFailure()
                    end

                    isMinigameActive = false
                    return
                end
            end
        end
    end, "cl-lib-cigar-production code name: Phoenix")
end

function LoadAnim(animDict)
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end