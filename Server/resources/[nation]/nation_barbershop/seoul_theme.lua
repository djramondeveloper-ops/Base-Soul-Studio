-- Seoul Theme Bridge - Nation UI
-- Lê a cor global publicada pela ponte AdminControl/vRP e envia para a NUI.

local CurrentTheme = nil

local function normalizeHex(value)
    value = tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', '')

    if value == '' then
        return '#7c3aed'
    end

    if value:sub(1, 1) ~= '#' then
        value = '#' .. value
    end

    if #value == 4 then
        local r, g, b = value:sub(2,2), value:sub(3,3), value:sub(4,4)
        value = '#' .. r .. r .. g .. g .. b .. b
    end

    if not value:match('^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$') then
        return '#7c3aed'
    end

    return value:lower()
end

local function getSeoulTheme()
    local theme = GlobalState['SeoulTheme'] or {}
    local basics = GlobalState['Basics'] or {}

    local primary = theme.PrimaryColor or theme.primary or theme.main or theme.color or theme.CityColorHex or basics.CityColorHex or basics.CityColor or '#7c3aed'

    return {
        primary = normalizeHex(primary),
        themeName = theme.Theme or theme.themeName or basics.Theme or 'default',
        baseName = basics.ServerName or basics.BaseName or basics.Name or 'Seoul',
        logo = theme.Logo or basics.CityLogo or '',
        raw = theme
    }
end

local function sendTheme()
    CurrentTheme = getSeoulTheme()
    SendNUIMessage({
        action = 'seoulTheme',
        type = 'seoulTheme',
        primary = CurrentTheme.primary,
        themeName = CurrentTheme.themeName,
        baseName = CurrentTheme.baseName,
        logo = CurrentTheme.logo,
        theme = CurrentTheme.raw
    })
end

RegisterNUICallback('SeoulThemeReady', function(_, cb)
    sendTheme()
    if cb then cb(true) end
end)

RegisterNetEvent('Seoul:AdminControl:ApplyClientConfig', function()
    Wait(150)
    sendTheme()
end)

AddStateBagChangeHandler('SeoulTheme', 'global', function()
    Wait(150)
    sendTheme()
end)

CreateThread(function()
    Wait(1200)
    sendTheme()
    Wait(2500)
    sendTheme()
    Wait(5000)
    sendTheme()
end)
