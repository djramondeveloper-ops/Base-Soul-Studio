local function normalizeCoords(coords)
    if not coords then return nil end
    return vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
end

local function applyLegacy(data)
    local ped = PlayerPedId()
    ClearPedDecorations(ped)
    for collection, overlayName in pairs(data or {}) do
        AddPedDecorationFromHashes(ped, overlayName, collection)
    end
end

RegisterNetEvent("tattooshop:Apply", function(data)
    if not data then
        local nationData, legacy = func.getSavedTattoos()
        if nationData and (next(nationData.tattoos or {}) or (nationData.overlay or 0) > 0) then
            reloadTattoos(nationData)
        else
            applyLegacy(legacy)
        end
    elseif data.tattoos or data.overlay then
        reloadTattoos(data)
    else
        applyLegacy(data)
    end
end)

RegisterNetEvent("tattooshop:Open", function()
    TriggerEvent("nation_tattoos:toggleMenu")
end)

RegisterNetEvent("nation_tattoos:Insert", function(data)
    local coords = normalizeCoords(data and (data.Coords or data.coords))
    if not coords then return end
    tattooShops[#tattooShops + 1] = {
        coords = coords,
        h = data.Heading or data.heading or 0.0,
        perm = data.Permission or data.permission
    }
end)

CreateThread(function()
    Wait(1000)
    for _, data in ipairs(func.getDynamicShops() or {}) do
        TriggerEvent("nation_tattoos:Insert", data)
    end
end)

exports("Apply", function(data)
    TriggerEvent("tattooshop:Apply", data)
end)
