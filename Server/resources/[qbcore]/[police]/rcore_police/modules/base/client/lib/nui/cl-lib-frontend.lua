-- =====================================================
--  rcore_police · modules/base/client/lib/nui/cl-lib-frontend.lua
--  Engineered by Eazy Fxap
--  Original: 1078 lines → Cleaned: 240 lines
-- =====================================================

local IsLoaded = false
local PayDialogPromise = nil
local FormDialogPromise = nil
local MinigamePromise = nil
local isHoverContext = false
local hoverContextId = nil
local HoverContexts = {}
local registeredCallbacks = {}

RegisterNuiCallback(NUI_EVENTS.SEND_NOTIFICATION, function(data, cb)
    local msg = _U(string.format("NOTIFY.%s", data.title), data.value)
    Framework.sendNotification(msg, data.type or "success")
    cb("ok")
end)

RegisterNuiCallback("LOADED", function(data, cb)
    IsLoaded = true
    if Locales[Config.Locale] and Locales[Config.Locale].UI then
        dbg.debug("UI Load - Loading translations from Locales[%s].UI category, for UI!", Config.Locale)
    else
        dbg.debug("UI Load - Failed to find translations in Locales[%s].UI category, loading fallback!", Config.Locale)
    end
    
    if IsLoaded and Locales[Config.Locale] and Locales[Config.Locale].UI then
        UI.SendReactMessage(NUI_EVENTS.SENT_UI_TRANSLATIONS, Locales[Config.Locale].UI)
    end
    
    if Config.InventoryImagePaths and next(Config.InventoryImagePaths) then
        local imgPath = Config.InventoryImagePaths[Config.Inventory]
        if imgPath and Config.InventoryImageUseState and Config.Inventory ~= Inventory.ESX then
            dbg.debug("Inventory images: Found supported inventory %s with path %s", Config.Inventory, imgPath)
            UI.SendReactMessage(NUI_EVENTS.IMAGE_PATH, {
                path = imgPath,
                inventory = Config.Inventory
            })
        else
            dbg.debug("Inventory images: Failed to find defined path for %s - using included images for all images in build/items/images", Config.Inventory)
        end
    end
    
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.CLOSE_APP, function(data, cb)
    if IsPropSessionActive then
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
    end
    if IsLoadedRadarSettings then
        IsLoadedRadarSettings = false
    end
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.DELETE_REPORT, function(data, cb)
    TriggerServerEvent("rcore_police:server:requestDeleteReport", data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.SAVE_REPORT, function(data, cb)
    TriggerServerEvent("rcore_police:server:requestSaveReport", data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.SENT_RADIAL_MENU, function(data, cb)
    RadialActionListener(data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.MINIGAME_RESULT, function(data, cb)
    if MinigamePromise == nil then return cb("ok") end
    SetNuiFocus(false, false)
    MinigamePromise:resolve(data)
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.MINIGAME_SOUND, function(status, cb)
    local soundId = -1
    if status == "success" then
        PlaySoundFrontend(soundId, "WIN", "HUD_AWARDS", 0)
    elseif status == "failure" then
        PlaySoundFrontend(soundId, "MissionFailedSounds", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
    end
    ReleaseSoundId(soundId)
    cb("ok")
end)

function startHoverFunction(id, playerPed, color)
    if isHoverContext then
        isHoverContext = false
    end
    if hoverContextId ~= id then
        hoverContextId = id
    end
    isHoverContext = true
    
    local targetCoords = GetEntityCoords(UtilsService.GetPlayerPedFromServerId(id))
    local markerData = Config.SelectPlayers.Marker
    
    HoverContexts[playerPed] = function()
        while isHoverContext do
            Wait(0)
            if hoverContextId ~= id then
                isHoverContext = false
                break
            end
            
            local coords = GetEntityCoords(UtilsService.GetPlayerPedFromServerId(id))
            DrawMarker(markerData.type or 21, coords.x, coords.y, coords.z + 1.1, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.3, 0.3, markerData.r, markerData.g, markerData.b, markerData.a, false, false, 2, false, false, false, false)
        end
    end
end

RegisterNUICallback(NUI_EVENTS.HOVER_CONTEXT, function(data, cb)
    local id = data.hoverFunctionId
    dbg.debug("Hovering context with Id: %s", id)
    
    if isHoverContext and hoverContextId and HoverContexts[hoverContextId] then
        isHoverContext = false
    end
    
    if HoverContexts[id] then
        hoverContextId = id
        isHoverContext = true
        HoverContexts[id]()
    end
    cb("ok")
end)

RegisterNUICallback(NUI_EVENTS.STOP_HOVER_CONTEXT, function(data, cb)
    local id = data.hoverFunctionId
    if isHoverContext and hoverContextId == id then
        isHoverContext = false
        hoverContextId = nil
    end
    cb("ok")
end)

RegisterNuiCallback(NUI_EVENTS.SUBMIT_CONTEXT, function(data, cb)
    if data.event then
        if data.isServer then
            if data.notUnpack then
                TriggerServerEvent(data.event, data.args)
            else
                TriggerServerEvent(data.event, table.unpack(data.args))
            end
        else
            TriggerEvent(data.event, data.args)
        end
    end
    cb("ok")
end)

function RegisterFrontendCallback(event, action, cb)
    if registeredCallbacks[action] then return end
    registeredCallbacks[action] = true
    RegisterNUICallback(event, function(data, nuiCb)
        cb(data)
        nuiCb("ok")
    end)
end

function UI.HelpKeys(data, showState)
    local uiData = {
        title = (data and data.title) or "",
        options = (data and data.keys) or {},
        showState = showState
    }
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, showState)
    UI.SendReactMessage(NUI_EVENTS.HELPKEYS, uiData)
end

function UI.ResetHelpKeys()
    UI.HelpKeys(nil, false)
end

function UI.PayDialog(data)
    PayDialogPromise = promise.new()
    local uiData = {
        title = (data and data.title) or "",
        desc = (data and data.desc) or "",
        payload = (data and data.payload) or {},
        showState = true,
        inputTitle = (data and data.inputTitle) or "",
        showInput = (data and data.showInput) or false
    }
    
    SetNuiFocus(true, true)
    RegisterFrontendCallback(NUI_EVENTS.SENT_PAYDIALOG, NUI_EVENTS.PAY_DIALOG, function(cbData)
        if cbData then
            PayDialogPromise:resolve(cbData)
        else
            PayDialogPromise:resolve(cbData)
        end
        if registeredCallbacks[NUI_EVENTS.PAY_DIALOG] then
            registeredCallbacks[NUI_EVENTS.PAY_DIALOG] = nil
        end
    end)
    
    UI.SendReactMessage(NUI_EVENTS.PAY_DIALOG, uiData)
    return Citizen.Await(PayDialogPromise)
end

function UI.Input(title, options)
    local uiData = {
        title = title,
        options = options,
        showState = true
    }
    FormDialogPromise = promise.new()
    SetNuiFocus(true, true)
    
    RegisterFrontendCallback(NUI_EVENTS.GET_INPUT_DATA, NUI_EVENTS.FORM_DIALOG, function(data)
        if data and next(data) then
            FormDialogPromise:resolve(data)
        else
            FormDialogPromise:resolve(nil)
        end
        if registeredCallbacks[NUI_EVENTS.FORM_DIALOG] then
            registeredCallbacks[NUI_EVENTS.FORM_DIALOG] = nil
        end
    end)
    
    UI.SendReactMessage(NUI_EVENTS.FORM_DIALOG, uiData)
    return Citizen.Await(FormDialogPromise)
end

function UI.RadialMenu(data)
    local uiData = {
        title = data.title or "",
        options = data.options or {},
        showState = true
    }
    SetNuiFocus(true, true)
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    UI.SendReactMessage("RADIAL_MENU", uiData)
end

function UI.ContextMenu(data)
    SetNuiFocus(true, true)
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    UI.SendReactMessage(NUI_EVENTS.CONTEXT_MENU, data)
    SetTimeout(100, function()
        UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    end)
end

function UI.BodyCams(data)
    SetNuiFocus(true, true)
    local opts = (data and data.options and next(data.options)) and data.options or BodyCams
    
    if opts and next(opts) then
        for k, v in pairs(opts) do
            if v.location == "" then
                v.location = GetStreetNameFromCoords(v.playerCoords)
            end
            if v.playerId == MyServerId then
                dbg.debug("Bodycams: You have an active bodycam on yourself, keeping it in UI for testing!")
                -- opts[k] = nil
            end
        end
    end
    
    Wait(0)
    local uiData = {
        title = (data and data.title) or "",
        options = opts,
        showState = true
    }
    
    if Config.Debug then tprint(uiData) end
    
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    UI.SendReactMessage(NUI_EVENTS.BODYCAMS, uiData)
end

function UI.ReportMenu(data)
    SetNuiFocus(true, true)
    local opts = (data and data.options and next(data.options)) and data.options or Reports
    
    local uiData = {
        title = (data and data.title) or "",
        options = opts,
        showState = true
    }
    
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    UI.SendReactMessage(NUI_EVENTS.REPORTS, uiData)
end

function UI.StartMinigame(data)
    MinigamePromise = promise.new()
    SetNuiFocus(true, true)
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, true)
    
    local minigameData = data or {
        speed = Config.Cuffing.Minigame.speed or 3,
        maxFails = Config.Cuffing.Minigame.maxFails or 1,
        maxRevs = Config.Cuffing.Minigame.maxRevs or 1,
        neededPicks = Config.Cuffing.Minigame.neededPicks or 1
    }
    
    UI.SendReactMessage(NUI_EVENTS.START_MINIGAME, minigameData)
    local result = Citizen.Await(MinigamePromise)
    MinigamePromise = nil
    SetNuiFocus(false, false)
    return result
end

function UI.StopMinigame()
    SetNuiFocus(false, false)
    UI.SendReactMessage(NUI_EVENTS.SET_VISIBLE, false)
    UI.SendReactMessage(NUI_EVENTS.STOP_MINIGAME)
end

function UI.SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function OpenBodyCams()
    if Framework.job then
        local jobName = Framework.job.name
        local grade = tonumber(Framework.job.grade)
        local reqGrade = Config.BodyCams.RestrictSpectateByGrades or 0
        
        dbg.debug("BodyCams: Required grade is %s - player has: %s", reqGrade, grade)
        
        if GetDepartmentConfig(jobName) then
            if Config.BodyCams.RestrictByGrades and grade < reqGrade then
                return dbg.critical("You dont have permission to see bodycams feed, required grade is: %s", reqGrade)
            end
            dbg.debug("Has access to open bodycams feed, loading UI!")
            UI.BodyCams()
        else
            dbg.debug("You are in job: %s which is not allowed for bodycams!", jobName)
        end
    else
        dbg.debug("Failed to open bodycams feed - failed to find Framework.job (not any cached data!)")
    end
end

RegisterCommand(Config.BodyCams.CommandName or "bodycams", function()
    if not Config.BodyCams.EnableCommand then return end
    OpenBodyCams()
end, false)
