local nuiOpen = false
local modelCreated = {}
local currentColor = "#ffffff"
local runtimeTextureReady = false

local function closeNui()
    if not nuiOpen then return end
    nuiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "CLOSE" })
end

local function hexToRgb(hex)
    if type(hex) ~= "string" or not hex:match("^#%x%x%x%x%x%x$") then
        hex = "#ffffff"
    end

    return {
        r = tonumber(hex:sub(2, 3), 16) or 255,
        g = tonumber(hex:sub(4, 5), 16) or 255,
        b = tonumber(hex:sub(6, 7), 16) or 255
    }
end

local function setColor(colorHex)
    local colorRgb = hexToRgb(colorHex)
    local textureName = "techdevontop"

    if colorRgb.r == 255 and colorRgb.g == 255 and colorRgb.b == 255 then
        RemoveReplaceTexture("mainTexture", textureName)
        currentColor = "#ffffff"
        return
    end

    local txd = "txd_seoul_vinewood"
    local txn = "txn_seoul_vinewood"
    local dict = CreateRuntimeTxd(txd)
    local texture = CreateRuntimeTexture(dict, txn, 4, 4)

    SetRuntimeTexturePixel(texture, 0, 0, colorRgb.r, colorRgb.g, colorRgb.b, 255)
    CommitRuntimeTexture(texture)
    AddReplaceTexture("mainTexture", textureName, txd, txn)
    runtimeTextureReady = true
    currentColor = colorHex
end

local function clearModels()
    for i = 1, #modelCreated do
        local entity = modelCreated[i]
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
    modelCreated = {}
end

local function requestLetterModel(letter)
    local hash = joaat(letter)
    RequestModel(hash)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do
        Wait(0)
    end

    if not HasModelLoaded(hash) then
        return nil
    end

    return hash
end

local function updateMap(data)
    clearModels()
    if type(data) ~= "table" then return end

    local completeText = data[1]
    local color = data[2]
    if type(completeText) ~= "string" then return end

    setColor(color or "#ffffff")

    local maxCharacters = math.min(#Config.Coords, tonumber(Config.MaxCharacters) or #Config.Coords)
    completeText = completeText:upper():sub(1, maxCharacters)

    for i = 1, #completeText do
        local letter = completeText:sub(i, i)
        local slot = Config.Coords[i]

        if slot and letter ~= " " and letter:match("^[A-Z]$") then
            local hash = requestLetterModel(letter:lower())
            if hash then
                local obj = CreateObjectNoOffset(hash, slot.coordinate.x, slot.coordinate.y, slot.coordinate.z, false, false, false)
                if obj and obj ~= 0 then
                    SetEntityHeading(obj, slot.heading)
                    FreezeEntityPosition(obj, true)
                    SetEntityAsMissionEntity(obj, true, true)
                    modelCreated[#modelCreated + 1] = obj
                end
                SetModelAsNoLongerNeeded(hash)
            end
        end
    end
end

CreateThread(function()
    Wait(500)
    TriggerServerEvent("seoul_vinewood:loadText")
end)

RegisterNetEvent("seoul_vinewood:openNui", function(text, color)
    nuiOpen = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "SET_LOCALES",
        locales = Config.Locales
    })

    SendNUIMessage({
        type = "OPEN",
        text = text,
        color = color
    })

    SendNUIMessage({
        type = "CONFIG",
        maxSize = math.min(tonumber(Config.MaxCharacters) or #Config.Coords, #Config.Coords)
    })
end)

RegisterNetEvent("seoul_vinewood:applyText", function(data)
    updateMap(data)

    if nuiOpen then
        SendNUIMessage({
            type = "UPDATE",
            text = data and data[1] or Config.DefaultText,
            color = data and data[2] or Config.DefaultColor
        })
    end
end)

RegisterNUICallback("saveText", function(data, cb)
    TriggerServerEvent("seoul_vinewood:saveText", data)
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback("close", function(_, cb)
    closeNui()
    if cb then cb({ ok = true }) end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    closeNui()
    clearModels()
    if runtimeTextureReady and currentColor ~= "#ffffff" then
        RemoveReplaceTexture("mainTexture", "techdevontop")
    end
end)
