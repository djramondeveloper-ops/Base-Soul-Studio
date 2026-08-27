local config = {}

local TypeMap = {
    inform = "info",
    info = "info",
    primary = "info",
    default = "info",
    server = "info",
    weather = "info",

    success = "success",
    sucesso = "success",
    verde = "success",
    dollar = "success",

    error = "error",
    erro = "error",
    negado = "error",
    vermelho = "error",
    sangue = "error",
    policia = "error",

    warning = "warning",
    warn = "warning",
    aviso = "warning",
    amarelo = "warning",
    fome = "warning",
    sede = "warning",
    estresse = "warning",
    bed = "warning"
}

local function SafeGetKvp(getFunction, key, defaultValue)
    local success, result = pcall(getFunction, key)
    if not success then
        DeleteResourceKvp(key)
        return defaultValue
    end
    return result or defaultValue
end

config.notification_audio = (SafeGetKvp(GetResourceKvpInt, "notification_audio", 1) == 1)

local function CleanLegacyText(value)
    if type(value) ~= "string" then
        return value
    end

    -- Compatibilidade com mensagens antigas da base/Reborn/Creative que usavam HTML no Notify.
    -- O seoul_uipack renderiza texto puro, então removemos tags para não aparecer <b>...</b> no jogo.
    value = value:gsub("<br%s*/?>", "\n")
    value = value:gsub("</p%s*>", "\n")
    value = value:gsub("<[^>]*>", "")

    local entities = {
        ["&nbsp;"] = " ",
        ["&amp;"] = "&",
        ["&lt;"] = "<",
        ["&gt;"] = ">",
        ["&quot;"] = "\"",
        ["&#39;"] = "'",
        ["&apos;"] = "'"
    }

    value = value:gsub("&[%w#]+;", function(entity)
        return entities[entity] or entity
    end)

    value = value:gsub("[\t ]+", " ")
    value = value:gsub(" *\n *", "\n")
    value = value:gsub("^%s+", ""):gsub("%s+$", "")

    return value
end

local function normaliseType(value)
    value = tostring(value or "info"):lower()
    return TypeMap[value] or value
end

local function defaultTitleFromType(notifyType)
    if notifyType == "success" then return "Sucesso" end
    if notifyType == "error" then return "Erro" end
    if notifyType == "warning" then return "Atenção" end
    return "Informação"
end

local function currentRouteMatches(route)
    if not route then return true end
    local state = LocalPlayer and LocalPlayer.state
    return not state or state.Route == route
end

function BuildSeoulNotification(...)
    local first, second, third, fourth, fifth, sixth, seventh = ...

    if type(first) == "table" then
        local notification = table.clone and table.clone(first) or first
        notification.type = normaliseType(notification.type or notification.color or notification.theme or third)
        notification.title = CleanLegacyText(notification.title or defaultTitleFromType(notification.type))
        notification.description = CleanLegacyText(notification.description or notification.message or notification.text or notification.title)
        notification.duration = tonumber(notification.duration or notification.time or notification.timer or notification.timeout or fourth) or GetConvarInt("seoul:notificationDuration", 5000)
        notification.position = notification.position or GetConvar("seoul:notificationPosition", "top-center")
        return notification
    end

    -- Base Creative/vRP signature: Notify(Title, Message, Color, Timer, Position, Mode, Route, Silenced)
    -- Common aliases: Notify(Type, Message, Time) or Notify(Message, Type)
    local title = first
    local message = second
    local color = third
    local timer = fourth
    local position = fifth
    local route = seventh

    if type(third) == "number" and fourth == nil then
        -- Notify(Type, Message, Time)
        color = first
        title = nil
        message = second
        timer = third
    elseif type(first) == "string" and second == nil then
        title = nil
        message = first
        color = third or "info"
    end

    if not currentRouteMatches(route) then
        return nil
    end

    local notifyType = normaliseType(color or "info")

    return {
        type = notifyType,
        title = CleanLegacyText(title or defaultTitleFromType(notifyType)),
        description = CleanLegacyText(message or title or ""),
        duration = tonumber(timer) or GetConvarInt("seoul:notificationDuration", 5000),
        position = position or GetConvar("seoul:notificationPosition", "top-center")
    }
end

function Notify(...)
    local notification = BuildSeoulNotification(...)
    if not notification then return false end

    notification.title = CleanLegacyText(notification.title)
    notification.description = CleanLegacyText(notification.description)

    local soundData = nil
    if type(notification.sound) == "table" and config.notification_audio then
        soundData = notification.sound
    end
    notification.sound = nil

    SendNUIMessage({
        action = "notification",
        data = notification
    })

    if not soundData then
        return true
    end

    local hasAudioBank = soundData.bank ~= nil
    if hasAudioBank then
        Utils.requestAudioBank(soundData.bank)
    end

    local soundId = GetSoundId()
    PlaySoundFrontend(soundId, soundData.name, soundData.set, true)
    ReleaseSoundId(soundId)

    if hasAudioBank then
        ReleaseNamedScriptAudioBank(soundData.bank)
    end

    return true
end
