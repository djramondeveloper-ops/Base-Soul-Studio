local LocalesTable = Locales or {}
Locales = LocalesTable

local function translate(key, ...)
    if not Config or not Config.Locale then
        dbg.critical("Cannot find Locale in the config")
        return "not_found_config"
    end

    local currentLocale = Config.Locale
    local localeData = Locales[currentLocale]

    if not localeData then
        dbg.critical("Cannot find locale %s", currentLocale)
        return "not_found_locale"
    end

    if string.find(key, ".", 1, true) then
        local category, localeKey = key:match("([^%.]+)%.([^%.]+)")

        local categoryData = localeData[category]
        if not categoryData then
            dbg.critical(
                "Cannot find locale category %s for string %s in locale %s",
                category,
                localeKey,
                currentLocale
            )
            return key
        end

        local translation = categoryData[localeKey]
        if not translation then
            dbg.critical(
                "Cannot find locale string %s in category %s in locale %s",
                localeKey,
                category,
                currentLocale
            )
            return key
        end

        return string.format(translation, ...)
    end

    local translation = localeData[key]
    if not translation then
        dbg.critical(
            "Cannot find locale string %s in locale %s",
            key,
            currentLocale
        )
        return key
    end

    return string.format(translation, ...)
end

_U = translate