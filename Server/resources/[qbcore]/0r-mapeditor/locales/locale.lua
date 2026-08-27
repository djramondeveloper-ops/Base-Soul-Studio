local function loadLang(lang)
    local raw = LoadResourceFile(GetCurrentResourceName(), 'locales/' .. lang .. '.json')
    if not raw then return nil end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then return nil end
    return data
end

local function deepmerge(base, over)
    local out = {}
    for k, v in pairs(base) do
        if type(v) == 'table' then out[k] = deepmerge(v, {}) else out[k] = v end
    end
    if type(over) == 'table' then
        for k, v in pairs(over) do
            if type(v) == 'table' and type(out[k]) == 'table' then
                out[k] = deepmerge(out[k], v)
            else
                out[k] = v
            end
        end
    end
    return out
end

local function build()
    local en = loadLang('en') or {}
    local lang = (Config and Config.locale) or 'en'
    if lang ~= 'en' then
        local over = loadLang(lang)
        if over then return deepmerge(en, over) end
        print(('[0r-mapeditor] locale "%s" not found, using en'):format(tostring(lang)))
    end
    return en
end

local Locale = build()

local function lookup(key)
    local cur = Locale
    for part in string.gmatch(key, '[^.]+') do
        if type(cur) ~= 'table' then return nil end
        cur = cur[part]
    end
    return cur
end

local function fmt(str, ...)
    local args = { ... }
    if #args == 0 then return str end
    return (str:gsub('{(%d+)}', function(n)
        local v = args[tonumber(n)]
        return v ~= nil and tostring(v) or ('{' .. n .. '}')
    end))
end

function locale(key, ...)
    local s = lookup(key)
    if type(s) ~= 'string' then return key end
    return fmt(s, ...)
end

function GetLocaleTable() return Locale end
