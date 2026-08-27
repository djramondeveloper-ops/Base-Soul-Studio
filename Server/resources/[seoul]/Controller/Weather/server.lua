if Config.Modules and Config.Modules.Weather == false then return end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL WEATHER BRIDGE
-- Usa exclusivamente o estado climático/horário oficial da Seoul.
-----------------------------------------------------------------------------------------------------------------------------------------
local weatherTypes = {
    BLIZZARD = true, CLEAR = true, CLEARING = true, CLOUDS = true,
    EXTRASUNNY = true, FOGGY = true, HALLOWEEN = true, OVERCAST = true,
    RAIN = true, SMOG = true, SNOWLIGHT = true, THUNDER = true, XMAS = true
}

SeoulRegisterCommand("time",function(source,args)
    if not HasPermission(source,"time") then return end
    local hour = tonumber(args[1])
    local minute = tonumber(args[2])
    if not hour or not minute then return end
    hour = math.max(0,math.min(23,math.floor(hour)))
    minute = math.max(0,math.min(59,math.floor(minute)))
    GlobalState.Hours = hour
    GlobalState.Minutes = minute
end)

SeoulRegisterCommand("weather",function(source,args)
    if not HasPermission(source,"weather") then return end
    local weather = args[1] and string.upper(tostring(args[1])) or nil
    if weather and weatherTypes[weather] then
        GlobalState.Weather = weather
    end
end)
