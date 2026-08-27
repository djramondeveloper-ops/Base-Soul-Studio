-- =====================================================
--  rcore_police · shared/sh-locale.lua
--  Engineered by Eazy Fxap
--  Original: 130 lines → Cleaned: 80 lines
-- =====================================================

-- ============================================================
--  LOCALE INITIALIZATION
-- ============================================================

if not Locales then
    Locales = {}
end

-- ============================================================
--  _U — Locale String Lookup
--  Usage: _U("key") or _U("category.key") with optional format args
-- ============================================================

local function localeGet(key, ...)
    if not Config or not Config.Locale then
        dbg.critical("Cannot find Locale in the config")
        return "not_found_config"
    end

    local locale = Locales[Config.Locale]
    if not locale then
        dbg.critical("Cannot find locale %s", Config.Locale)
        return "not_found_locale"
    end

    -- Dot-notation key: "category.string"
    if string.find(key, ".", 1, true) then
        local category, str = key:match("([^%.]+)%.([^%.]+)")
        local cat = locale[category]
        if not cat then
            dbg.critical("Cannot find locale category %s for string %s in locale %s", category, str, Config.Locale)
            return key
        end
        local entry = cat[str]
        if not entry then
            dbg.critical("Cannot find locale string %s in category %s in locale %s", str, category, Config.Locale)
            return key
        end
        return string.format(entry, ...)
    end

    -- Flat key
    local entry = locale[key]
    if not entry then
        dbg.critical("Cannot find locale string %s in locale %s", key, Config.Locale)
        return key
    end
    return string.format(entry, ...)
end

_U = localeGet
