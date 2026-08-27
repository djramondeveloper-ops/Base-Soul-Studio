local Tunnel = module("vrp", "lib/Tunnel")
local vRPC = Tunnel.getInterface("vRP")

local function normalizeCoords(coords)
    if not coords then return nil end
    return vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
end

RegisterNetEvent("barbershop:Apply", function(data)
    if data then
        vRPC.Barbershop(data)
        return
    end

    local char, legacy = func.getSavedChar()
    if char and next(char) then
        TriggerEvent("nation_barbershop:init", char)
    elseif legacy and next(legacy) then
        vRPC.Barbershop(legacy)
    end
end)

RegisterNetEvent("barbershop:Open", function()
    TriggerEvent("nation_barbershop:toggleMenu")
end)

RegisterNetEvent("nation_barbershop:Insert", function(data)
    local coords = normalizeCoords(data and (data.Coords or data.coords))
    if not coords then return end
    local id = #barberShops + 1
    barberShops[id] = { coords = coords, perm = data.Permission or data.permission }
    barberChairs[id] = {{ coords = coords, h = data.Heading or data.heading or 0.0, offset = vec3(0.0, -0.7, 0.0) }}
end)

CreateThread(function()
    Wait(1000)
    for _, data in ipairs(func.getDynamicShops() or {}) do
        TriggerEvent("nation_barbershop:Insert", data)
    end
end)

exports("Apply", function(data)
    TriggerEvent("barbershop:Apply", data)
end)
