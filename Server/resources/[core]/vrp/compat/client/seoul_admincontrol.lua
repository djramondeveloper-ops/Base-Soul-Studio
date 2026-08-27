-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL CLIENT RUNTIME - FASE 2
-- Aplica em runtime o que vem da ponte AdminControl -> vRP: tema do Global.lua, necessidades, NPC density e MaxHealth.
-----------------------------------------------------------------------------------------------------------------------------------------
local Current = {
    lastReload = 0,
    hungerDelay = nil,
    thirstDelay = nil,
    maxHealth = nil,
    themeColor = nil,
    npc = {
        PedDensity = 0.5,
        VehicleDensity = 0.4,
        ParkedVehicle = 0.4
    }
}

local function toNumber(value, fallback)
    local number = tonumber(value)
    if number == nil then return fallback end
    return number
end

local function clamp(value, min, max)
    value = toNumber(value, min)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function normalizeHex(value, fallback)
    value = tostring(value or "")
    local hex = value:match("#%x%x%x%x%x%x")
    if hex then return hex end

    local r, g, b = value:match("rgb%((%d+)%s*,%s*(%d+)%s*,%s*(%d+)%)")
    if r and g and b then
        return string.format("#%02X%02X%02X", math.max(0, math.min(255, tonumber(r) or 0)), math.max(0, math.min(255, tonumber(g) or 0)), math.max(0, math.min(255, tonumber(b) or 0)))
    end

    return fallback or "#1EA1DA"
end

local function safeGet(root, ...)
    local current = root
    for i = 1, select("#", ...) do
        if type(current) ~= "table" then return nil end
        current = current[select(i, ...)]
    end
    return current
end

local function calculateNeedDelay(tempo, amount)
    tempo = math.max(1, math.floor(toNumber(tempo, 90)))
    amount = toNumber(amount, 1)

    if amount <= 0 then
        return 2147483647
    end

    return math.max(1000, math.floor((tempo / amount) * 1000))
end

local function applyTheme(theme, basics)
    local primary = normalizeHex(
        safeGet(theme, "Primary") or safeGet(theme, "CityColorHex") or safeGet(basics, "CityColorHex"),
        "#1EA1DA"
    )

    if Current.themeColor == primary then return end
    Current.themeColor = primary

    if type(Theme) == "table" then
        Theme.main = primary
        Theme.mainText = Theme.mainText or "#ffffff"
        Theme.common = primary

        Theme.accept = type(Theme.accept) == "table" and Theme.accept or {}
        Theme.accept.background = primary
        Theme.accept.letter = Theme.accept.letter or "#dcffe9"

        Theme.hud = type(Theme.hud) == "table" and Theme.hud or {}
        Theme.hud.health = primary
        Theme.hud.progress = type(Theme.hud.progress) == "table" and Theme.hud.progress or {}
        Theme.hud.progress.circle = primary
    end

    TriggerEvent("Seoul:ThemeUpdated", Theme or { main = primary })
end

local function applyNeeds(config)
    local needs = safeGet(config, "Base", "Needs") or {}
    local tempo = toNumber(needs.Tempo, 90)
    local fome = toNumber(needs.Fome, 2)
    local sede = toNumber(needs.Sede, 1)

    local hungerDelay = calculateNeedDelay(tempo, fome)
    local thirstDelay = calculateNeedDelay(tempo, sede)

    if Current.hungerDelay ~= hungerDelay then
        Current.hungerDelay = hungerDelay
        TriggerEvent("Hunger", hungerDelay)
    end

    if Current.thirstDelay ~= thirstDelay then
        Current.thirstDelay = thirstDelay
        TriggerEvent("Thirst", thirstDelay)
    end
end

local function applyNpcControl(config)
    local npc = safeGet(config, "Base", "NpcControl") or {}

    Current.npc.PedDensity = clamp(npc.PedDensity, 0.0, 0.99)
    Current.npc.VehicleDensity = clamp(npc.VehicleDensity, 0.0, 0.99)
    Current.npc.ParkedVehicle = clamp(npc.ParkedVehicle, 0.0, 0.99)
end

local function applyMaxHealth(config, basics)
    local maxHealth = math.max(100, math.floor(toNumber(safeGet(config, "Base", "MaxHealth") or safeGet(basics, "MaxHealth"), 400)))
    Current.maxHealth = maxHealth

    local ped = PlayerPedId()
    if ped and ped > 0 then
        if GetEntityMaxHealth(ped) ~= maxHealth then
            SetPedMaxHealth(ped, maxHealth)
        end

        if GetEntityHealth(ped) > maxHealth then
            SetEntityHealth(ped, maxHealth)
        end
    end
end

local function applyRuntimeConfig(config, theme, basics)
    config = type(config) == "table" and config or (GlobalState["SeoulAdminControl"] or {})
    theme = type(theme) == "table" and theme or (GlobalState["SeoulTheme"] or {})
    basics = type(basics) == "table" and basics or (GlobalState["Basics"] or {})

    applyTheme(theme, basics)
    applyNeeds(config)
    applyNpcControl(config)
    applyMaxHealth(config, basics)
end

RegisterNetEvent("Seoul:AdminControl:ApplyClientConfig")
AddEventHandler("Seoul:AdminControl:ApplyClientConfig", function(config, theme, basics)
    applyRuntimeConfig(config, theme, basics)
end)

CreateThread(function()
    Wait(2500)
    applyRuntimeConfig()

    while true do
        local state = GlobalState["SeoulAdminControl"] or {}
        local lastReload = tonumber(state.LastReload or 0) or 0

        if lastReload ~= Current.lastReload then
            Current.lastReload = lastReload
            applyRuntimeConfig(state, GlobalState["SeoulTheme"], GlobalState["Basics"])
        else
            applyMaxHealth(state, GlobalState["Basics"])
        end

        Wait(3000)
    end
end)

CreateThread(function()
    while true do
        local ped = Current.npc.PedDensity or 0.5
        local vehicle = Current.npc.VehicleDensity or 0.4
        local parked = Current.npc.ParkedVehicle or 0.4

        SetPedDensityMultiplierThisFrame(ped)
        SetScenarioPedDensityMultiplierThisFrame(ped, ped)
        SetVehicleDensityMultiplierThisFrame(vehicle)
        SetRandomVehicleDensityMultiplierThisFrame(vehicle)
        SetParkedVehicleDensityMultiplierThisFrame(parked)

        Wait(0)
    end
end)
