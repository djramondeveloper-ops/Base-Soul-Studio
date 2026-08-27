--[[
    Seoul LB Phone - Charging Stations
    Jogador chega perto do ponto configurado e aperta E para carregar o celular devagar.
    Mantém a bateria nativa do lb-phone: usa ToggleCharging, GetBattery e SetBattery.
]]

local resourceName = GetCurrentResourceName()
local charging = false
local currentStation = nil
local nextChargeAt = 0

local function seoulDebug(message)
    if Config and Config.Debug then
        print(("^2[Seoul LB Phone]^7 %s"):format(message))
    end
end

local function notify(message)
    if not Config or not Config.SeoulCharging or Config.SeoulCharging.Notify ~= true then
        return
    end

    if GetResourceState("seoul_uipack") == "started" then
        TriggerEvent("Notify", "Celular", message, "verde", 5000)
        return
    end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function helpText(message)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function setCharging(state)
    state = state == true

    if charging == state then
        return
    end

    charging = state

    local ok = pcall(function()
        exports[resourceName]:ToggleCharging(state)
    end)

    if not ok and type(ToggleCharging) == "function" then
        pcall(ToggleCharging, state)
    end

    if state then
        nextChargeAt = GetGameTimer() + ((Config.SeoulCharging.ChargeEverySeconds or 10) * 1000)
        notify("Celular conectado ao carregador.")
    else
        currentStation = nil
        notify("Celular desconectado do carregador.")
    end
end

local function getBattery()
    local ok, battery = pcall(function()
        return exports[resourceName]:GetBattery()
    end)

    if ok and type(battery) == "number" then
        return math.floor(battery)
    end

    return 100
end

local function setBattery(value)
    value = math.max(0, math.min(100, math.floor(value)))

    local ok = pcall(function()
        exports[resourceName]:SetBattery(value)
    end)

    if not ok then
        seoulDebug("SetBattery export ainda não disponível.")
    end
end

local function drawMarker(coords)
    DrawMarker(
        2,
        coords.x, coords.y, coords.z + 0.15,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.22, 0.22, 0.22,
        0, 180, 255, 160,
        false, true, 2,
        false, nil, nil, false
    )
end

local function getNearestStation(playerCoords)
    local cfg = Config and Config.SeoulCharging
    if not cfg or cfg.Enabled ~= true or type(cfg.Stations) ~= "table" then
        return nil, nil
    end

    local nearest, nearestDistance
    local markerDistance = cfg.MarkerDistance or 12.0

    for i = 1, #cfg.Stations do
        local station = cfg.Stations[i]
        local coords = station and station.coords

        if coords then
            local distance = #(playerCoords - coords)

            if distance <= markerDistance and (not nearestDistance or distance < nearestDistance) then
                nearest = station
                nearestDistance = distance
            end
        end
    end

    return nearest, nearestDistance
end

CreateThread(function()
    while Config == nil or Config.SeoulCharging == nil do
        Wait(500)
    end

    while true do
        local sleep = 1000
        local cfg = Config.SeoulCharging

        if cfg.Enabled == true then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local station, distance = getNearestStation(coords)

            if station then
                sleep = 0

                if cfg.DrawMarker == true then
                    drawMarker(station.coords)
                end

                if distance <= (cfg.Distance or 2.0) then
                    local label = station.label or "Carregador"
                    local battery = getBattery()

                    if charging and currentStation == station then
                        helpText(("~b~%s~s~\nBateria: ~g~%s%%~s~ | Aperte ~INPUT_CONTEXT~ para desconectar."):format(label, battery))
                    else
                        helpText(("~b~%s~s~\nBateria: ~g~%s%%~s~ | Aperte ~INPUT_CONTEXT~ para carregar."):format(label, battery))
                    end

                    if IsControlJustPressed(0, cfg.Key or 38) then
                        if charging and currentStation == station then
                            setCharging(false)
                        else
                            currentStation = station
                            setCharging(true)
                        end
                    end
                elseif charging and currentStation == station then
                    setCharging(false)
                end
            elseif charging then
                setCharging(false)
            end
        elseif charging then
            setCharging(false)
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while Config == nil or Config.SeoulCharging == nil do
        Wait(500)
    end

    while true do
        if charging then
            local now = GetGameTimer()

            if now >= nextChargeAt then
                local battery = getBattery()
                local amount = Config.SeoulCharging.ChargeAmount or 1
                local every = Config.SeoulCharging.ChargeEverySeconds or 10

                if battery >= 100 then
                    setBattery(100)
                    setCharging(false)
                    notify("Celular carregado completamente.")
                else
                    setBattery(math.min(100, battery + amount))
                    nextChargeAt = now + (every * 1000)
                end
            end

            Wait(500)
        else
            Wait(1500)
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == resourceName and charging then
        if type(ToggleCharging) == "function" then
            pcall(ToggleCharging, false)
        end
    end
end)
