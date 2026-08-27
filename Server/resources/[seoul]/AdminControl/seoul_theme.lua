local function NormalizeHex(value, fallback)
    value = tostring(value or fallback or "#F20089"):gsub("%s+", "")

    if value:sub(1, 1) ~= "#" then value = "#" .. value end

    if value:match("^#%x%x%x%x%x%x$") then return value end

    if value:match("^#%x%x%x$") then
        local r, g, b = value:sub(2, 2), value:sub(3, 3), value:sub(4, 4)
        return "#" .. r .. r .. g .. g .. b .. b
    end

    return fallback or "#F20089"
end

local function BuildTheme(payload)
    local theme = type(payload) == "table" and (payload.Theme or payload.SeoulTheme or payload) or GlobalState["SeoulTheme"]
    local basics = GlobalState["Basics"]
    local color = "#F20089"
    local name = "default"

    if type(theme) == "table" then
        color = theme.Primary or theme.CityColorHex or theme.Main or theme.main or color
        name = theme.Theme or theme.Name or theme.themeName or name
    end

    if type(basics) == "table" then
        color = basics.CityColorHex or color
        name = basics.Theme or name
    end

    color = NormalizeHex(color)

    return {
        action = "seoulTheme",
        event = "seoulTheme",
        primary = color,
        color = color,
        theme = name
    }
end

local function ApplyTheme(payload)
    SendNUIMessage(BuildTheme(payload))
end

RegisterNetEvent("Seoul:AdminControl:ApplyClientConfig", function(payload)
    Wait(150)
    ApplyTheme(payload)
end)

AddStateBagChangeHandler("SeoulTheme", "global", function(_, _, value)
    Wait(150)
    ApplyTheme(value)
end)

CreateThread(function()
    Wait(1500)
    ApplyTheme()
end)

exports("ApplySeoulTheme", ApplyTheme)
