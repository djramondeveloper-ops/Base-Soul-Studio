--[[
  locales/<Config.Locale>.json yüklenir; yoksa locales/en.json.
  Lua: L("server.key", ...) — %d, %s için string.format
  NUI: initLocale ile ui + locale gönderilir (GetNuiLocalePayload).
]]

LocaleData = LocaleData or {}
LocaleLoadedLang = nil

local function getResourceName()
    if GetCurrentResourceName then
        return GetCurrentResourceName()
    end
    return "seoul_soccer"
end

local function decodeJson(raw)
    if not raw or raw == "" then
        return nil
    end
    if json and json.decode then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == "table" then
            return decoded
        end
    end
    return nil
end

local function loadLocaleFile()
    local lang = (Config and Config.Locale) or "en"
    if type(lang) ~= "string" or lang == "" then
        lang = "en"
    end
    local res = getResourceName()
    local path = ("locales/%s.json"):format(lang)
    local raw = LoadResourceFile(res, path)
    local data = decodeJson(raw)
    if not data and lang ~= "en" then
        raw = LoadResourceFile(res, "locales/en.json")
        data = decodeJson(raw)
    end
    LocaleData = data or {}
    LocaleLoadedLang = lang
end

loadLocaleFile()

local localeNodeCache = {}

local function localeNode(path)
    if type(path) ~= "string" then
        return nil
    end
    local cached = localeNodeCache[path]
    if cached ~= nil then
        return cached ~= false and cached or nil
    end
    local node = LocaleData
    for segment in string.gmatch(path, "[^%.]+") do
        if type(node) ~= "table" then
            localeNodeCache[path] = false
            return nil
        end
        node = node[segment]
    end
    localeNodeCache[path] = node ~= nil and node or false
    return node
end

--- @param path string örn. "server.lobby_created"
--- @vararg any string.format için
function L(path, ...)
    local phrase = localeNode(path)
    if type(phrase) ~= "string" then
        return tostring(path)
    end
    if select("#", ...) > 0 then
        local ok, out = pcall(string.format, phrase, ...)
        if ok then
            return out
        end
        return phrase
    end
    return phrase
end

--- Localized phrase with an explicit fallback. The fallback supports string.format too.
function LOr(path, fallback, ...)
    local phrase = localeNode(path)
    if type(phrase) ~= "string" or phrase == "" then
        phrase = tostring(fallback or path)
    end
    if select("#", ...) > 0 then
        local ok, out = pcall(string.format, phrase, ...)
        if ok then return out end
    end
    return phrase
end

local function normalizeLocaleId(value)
    value = tostring(value or ""):lower()
    value = value:gsub("[^%w_%-]+", "_"):gsub("_+", "_")
    return value:gsub("^_", ""):gsub("_$", "")
end

function ResolveLocalizedName(section, id, fallback)
    local key = normalizeLocaleId(id)
    if key ~= "" then
        return LOr(("config.%s.%s"):format(tostring(section or ""), key), fallback or id)
    end
    return tostring(fallback or id or "")
end

function GetLocalizedBallName(ball)
    if type(ball) ~= "table" then return ResolveLocalizedName("balls", ball, ball) end
    return ResolveLocalizedName("balls", ball.id, ball.name or ball.id)
end

function GetLocalizedPitchName(pitch)
    if type(pitch) ~= "table" then return ResolveLocalizedName("pitches", pitch, pitch) end
    return ResolveLocalizedName("pitches", pitch.id, pitch.name or pitch.id)
end

function GetLocalizedDoorLabel(pitch, door, index)
    local pitchId = type(pitch) == "table" and pitch.id or pitch
    local fallback = type(door) == "table" and door.label or nil
    local doorId = type(door) == "table" and (door.id or door.localeId) or door
    doorId = doorId or ((normalizeLocaleId(pitchId) ~= "" and normalizeLocaleId(pitchId) .. "_") or "") .. tostring(index or "")
    return ResolveLocalizedName("doors", doorId, fallback or LOr("client.door_fallback", "Door %d", tonumber(index) or 0))
end

function GetNuiLocalePayload()
    local balls = {}
    if type(Config) == "table" and type(Config.Balls) == "table" then
        for _, b in ipairs(Config.Balls) do
            if type(b) == "table" and b.id then
                balls[#balls + 1] = {
                    id = tostring(b.id),
                    name = GetLocalizedBallName(b),
                    image = b.image and tostring(b.image) or "",
                    model = b.model and tostring(b.model) or "",
                }
            end
        end
    end
    return {
        locale = (Config and Config.Locale) or "en",
        ui = LocaleData.ui or {},
        defaults = LocaleData.defaults or {},
        balls = balls,
    }
end

--- Config.Keybinds ile locales.json keybinds.desc birleştirir (NUI + warmup)
function GetLocalizedKeybinds()
    local kb = (Config and Config.Keybinds) or {}
    local loc = (LocaleData and LocaleData.keybinds) or {}
    local function mergeRows(cfgRows, locRows)
        local out = {}
        if type(cfgRows) ~= "table" then
            return out
        end
        for i, row in ipairs(cfgRows) do
            local desc = row.desc
            local locRow = type(locRows) == "table" and locRows[i] or nil
            if type(locRow) == "table" and type(locRow.desc) == "string" then
                desc = locRow.desc
            end
            out[i] = {
                key = row.key,
                desc = desc or row.key or "",
            }
        end
        return out
    end
    return {
        player = mergeRows(kb.player, loc.player),
        goalkeeper = mergeRows(kb.goalkeeper, loc.goalkeeper),
        host = mergeRows(kb.host, loc.host),
    }
end

--- Config.ShotTrailPresets[1..n]; 0 = kapali, -1 = rastgele
function GetDefaultShotTrailPresetIndex()
    local st = (Config and Config.ShotTrail) or {}
    local idx = tonumber(st.DefaultPresetIndex)
    if idx == nil then return -1 end
    return math.floor(idx)
end

function GetShotTrailPresetLabel(presetIndex)
    presetIndex = math.floor(tonumber(presetIndex) or 0)
    if presetIndex == -1 then
        return L("shotFx.random")
    end
    if presetIndex <= 0 then
        return L("shotFx.off")
    end
    local presets = (Config and Config.ShotTrailPresets) or {}
    local preset = presets[presetIndex]
    if type(preset) ~= "table" then
        return L("shotFx.off")
    end
    local key = tostring(preset.labelKey or preset.id or "unknown")
    local locKey = "shotFx." .. key
    local text = L(locKey)
    if text and text ~= locKey then
        return text
    end
    if type(preset.label) == "string" and preset.label ~= "" then
        return preset.label
    end
    return key
end

function GetShotTrailPresetCount()
    local presets = (Config and Config.ShotTrailPresets) or {}
    return type(presets) == "table" and #presets or 0
end
