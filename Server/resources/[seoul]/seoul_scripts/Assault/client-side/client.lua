if SeoulScriptsClient and not SeoulScriptsClient.Enabled('Assault') then return end

local assaultToggle = false

local function getAssaultConfig()
    local config = AssaultConfig or {}

    local enabled = config.enable
    if enabled == nil then enabled = config.Enabled end
    if enabled == nil then enabled = true end

    local startTime = tonumber(config.StartTime or config.startTime or config.Start or config.Inicio or config.inicio) or 21
    local endTime = tonumber(config.EndTime or config.endTime or config.End or config.Fim or config.fim) or 6

    startTime = math.floor(startTime) % 24
    endTime = math.floor(endTime) % 24

    return enabled == true, startTime, endTime
end

local function getClockHour(value)
    local hour = tonumber(value)

    if not hour then
        hour = tonumber(GlobalState and GlobalState.clockHours)
    end

    if not hour and GetClockHours then
        hour = tonumber(GetClockHours())
    end

    return math.floor(hour or 12) % 24
end

local clockHours = getClockHour()

local function isAssaultTime(hour, startTime, endTime)
    hour = getClockHour(hour)
    startTime = tonumber(startTime) or 21
    endTime = tonumber(endTime) or 6

    startTime = math.floor(startTime) % 24
    endTime = math.floor(endTime) % 24

    if startTime == endTime then
        return false
    end

    -- Janela cruza meia-noite: ex. 21h até 06h.
    if startTime > endTime then
        return hour >= startTime or hour < endTime
    end

    -- Janela normal: ex. 08h até 18h.
    return hour >= startTime and hour < endTime
end

AddStateBagChangeHandler("clockHours", "", function(_, _, value)
    clockHours = getClockHour(value)
end)

CreateThread(function()
    while true do
        local enabled, startTime, endTime = getAssaultConfig()

        if not enabled then
            if assaultToggle then
                assaultToggle = false
                SendNUIMessage({ action = "hideAssault" })
            end
            Wait(10000)
        else
            local active = isAssaultTime(clockHours, startTime, endTime)

            if active and not assaultToggle then
                assaultToggle = true
                SendNUIMessage({ action = "showAssault" })
            elseif not active and assaultToggle then
                assaultToggle = false
                SendNUIMessage({ action = "hideAssault" })
            end

            Wait(5000)
        end
    end
end)
