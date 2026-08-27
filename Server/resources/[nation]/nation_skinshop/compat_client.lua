local savedClothes = {}

local function normalizeCoords(coords)
    if not coords then return nil end
    return vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
end

local function applyClothes(data, save)
    if type(data) ~= "table" or not next(data) then return end
    savedClothes = data
    resetClothing(data)
    if save then
        func.updateClothes()
    end
end

RegisterNetEvent("skinshop:Apply", function(data, save)
    if not data then
        data = func.getSavedClothes()
    end
    applyClothes(data, save)
end)

RegisterNetEvent("skinshop:Open", function()
    TriggerEvent("nation_skinshop:toggleMenu", "compat")
end)

RegisterNetEvent("nation_skinshop:Insert", function(data)
    local coords = normalizeCoords(data and (data.Coords or data.coords))
    if not coords then return end
    skinshops[#skinshops + 1] = {
        coords = coords,
        permission = data.Permission or data.permission,
        clothes = getClothes
    }
end)

local componentModes = {
    Mask = { component = 1, key = "mask" },
    Pants = { component = 4, key = "pants" },
    Shirt = { component = 8, key = "tshirt" },
    Torso = { component = 11, key = "torso" },
    Vest = { component = 9, key = "vest" },
    Shoes = { component = 6, key = "shoes" },
    Arms = { component = 3, key = "arms" },
    Accessory = { component = 7, key = "accessory" }
}

for mode, config in pairs(componentModes) do
    RegisterNetEvent("skinshop:set" .. mode, function()
        if not next(savedClothes) then savedClothes = func.getSavedClothes() or {} end
        local item = savedClothes[config.key]
        if item then
            local ped = PlayerPedId()
            if GetPedDrawableVariation(ped, config.component) == item.item then
                SetPedComponentVariation(ped, config.component, 0, 0, 0)
            else
                SetPedComponentVariation(ped, config.component, item.item, item.texture or 0, 0)
            end
        end
    end)
end

local propModes = {
    Hat = { prop = 0, key = "hat" },
    Glasses = { prop = 1, key = "glass" }
}

for mode, config in pairs(propModes) do
    RegisterNetEvent("skinshop:set" .. mode, function()
        if not next(savedClothes) then savedClothes = func.getSavedClothes() or {} end
        local item = savedClothes[config.key]
        if item then
            local ped = PlayerPedId()
            if GetPedPropIndex(ped, config.prop) == item.item then
                ClearPedProp(ped, config.prop)
            else
                SetPedPropIndex(ped, config.prop, item.item, item.texture or 0, false)
            end
        end
    end)
end

RegisterNetEvent("skinshop:Backpack", function(data)
    local ped = PlayerPedId()
    local model = GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") and "mp_f_freemode_01" or "mp_m_freemode_01"
    local backpack = data and data[model]
    if backpack then
        SetPedComponentVariation(ped, 5, backpack.Model or 0, backpack.Texture or 0, 0)
    end
end)

RegisterNetEvent("skinshop:BackpackRemove", function()
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
end)

CreateThread(function()
    Wait(1000)
    for _, data in ipairs(func.getDynamicShops() or {}) do
        TriggerEvent("nation_skinshop:Insert", data)
    end
end)

exports("Apply", function(data)
    if not data then data = func.getSavedClothes() end
    applyClothes(data, false)
end)
