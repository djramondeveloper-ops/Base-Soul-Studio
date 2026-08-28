ClothingService = type(_G.ClothingService) == 'table' and _G.ClothingService or {}

local function getOrDefault(value, defaultValue)
    if value == nil then
        return defaultValue
    end

    return value
end

local function insertCRMEntry(target, component)
    table.insert(target, {
        crm_id = component.componentId,
        crm_style = component.drawableId,
        crm_texture = component.textureId,
    })
end

function ClothingService.SetClothingComponents(ped, components)
    for _, component in ipairs(components) do
        if component.isProp ~= true then
            local componentId = component.componentId
            local drawableId = getOrDefault(component.drawableId, 0)
            local textureId = getOrDefault(component.textureId, 0)

            if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
                return
            end

            SetPedComponentVariation(ped, componentId, drawableId, textureId, 2)
        end
    end
end

function ClothingService.ClearAllPedProps(ped)
    for propId = 0, 7 do
        ClearPedProp(ped, propId)
    end
end

function ClothingService.ResetClothing(ped)
    if not DoesEntityExist(ped) or IsEntityDead(ped) then
        return
    end

    ClothingService.ClearAllPedProps(ped)
    SetPedDefaultComponentVariation(ped)
end

function ClothingService.SetPropComponents(ped, components)
    for _, component in ipairs(components) do
        if component.isProp == true then
            local componentId = component.componentId
            local drawableId = getOrDefault(component.drawableId, 0)
            local textureId = getOrDefault(component.textureId, 0)

            if drawableId == -1 then
                ClearPedProp(ped, componentId)
            else
                if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
                    return
                end

                SetPedPropIndex(ped, componentId, drawableId, textureId, true)
            end
        end
    end
end

function ClothingService.ApplyClothing(ped, components)
    if not ped or not components then
        return
    end

    ClothingService.SetClothingComponents(ped, components)
    ClothingService.SetPropComponents(ped, components)
end

function ClothingService.ConvertClothingComponents(clothingType, data)
    local converters = {
        [Cloth.QB] = ClothingService.ConvertQBClothingToComponents,
        [Cloth.SKINCHANGER] = ClothingService.ConvertSkinchangerToComponents,
        [Cloth.TGIANN] = ClothingService.ConvertTGIANN,
        [Cloth.CRM] = ClothingService.ConvertCRM,
        [Cloth.FAPPEARANCE] = ClothingService.ConvertFivemAppearanceToComponents,
        [Cloth.BL_APPEARANCE] = ClothingService.ConvertBLAppearanceToComponents,
    }

    local converter = converters[clothingType]
    if converter then
        return converter(data)
    end
end

function ClothingService.ConvertCRM(components)
    if not components then
        return
    end

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "tshirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "bproof",
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = "helmet",
        [PROP_COMPONENTS.EARS] = "ears",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "chain",
    }

    local result = {
        crm_clothing = {},
        crm_accessories = {},
    }

    for _, component in ipairs(components) do
        if component.isProp then
            if propMap[component.componentId] then
                insertCRMEntry(result.crm_accessories, component)
            end
        else
            if clothingMap[component.componentId] then
                insertCRMEntry(result.crm_clothing, component)
            end
        end
    end

    return result
end

function ClothingService.ConvertTGIANN(components)
    if not components then
        return
    end

    local defaults = {
        { name = "decals_1", val = 0 },
        { name = "decals_2", val = 0 },
        { name = "pants_1", val = 0 },
        { name = "pants_2", val = 0 },
        { name = "mask_1", val = 0 },
        { name = "mask_2", val = 0 },
        { name = "bproof_1", val = 0 },
        { name = "bproof_2", val = 0 },
        { name = "tshirt_1", val = 0 },
        { name = "tshirt_2", val = 0 },
        { name = "torso_1", val = 0 },
        { name = "torso_2", val = 0 },
        { name = "shoes_1", val = 0 },
        { name = "shoes_2", val = 0 },
        { name = "arms", val = 0 },
        { name = "chain_1", val = 0 },
        { name = "chain_2", val = 0 },
        { name = "helmet_1", val = 0 },
        { name = "helmet_2", val = 0 },
        { name = "glasses_1", val = -1 },
        { name = "glasses_2", val = 0 },
        { name = "watch_1", val = 0 },
        { name = "watch_2", val = 0 },
        { name = "bracelet_1", val = 0 },
        { name = "bracelet_2", val = 0 },
    }

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = { "pants_1", "pants_2" },
        [CLOTHING_COMPONENTS.SHOES] = { "shoes_1", "shoes_2" },
        [CLOTHING_COMPONENTS.SHIRT] = { "tshirt_1", "tshirt_2" },
        [CLOTHING_COMPONENTS.ARMS] = { "arms" },
        [CLOTHING_COMPONENTS.MASKS] = { "mask_1", "mask_2" },
        [CLOTHING_COMPONENTS.BODY] = { "torso_1", "torso_2" },
        [CLOTHING_COMPONENTS.DECALS] = { "decals_1", "decals_2" },
        [CLOTHING_COMPONENTS.BODY_ARMOR] = { "bproof_1", "bproof_2" },
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = { "helmet_1", "helmet_2" },
        [PROP_COMPONENTS.EARS] = { "ear_1", "ear_2" },
        [PROP_COMPONENTS.GLASSES] = { "glasses_1", "glasses_2" },
        [PROP_COMPONENTS.WATCHES] = { "watch_1", "watch_2" },
        [PROP_COMPONENTS.BRACELETS] = { "bracelet_1", "bracelet_2" },
        [PROP_COMPONENTS.ACCESSORY] = { "chain_1", "chain_2" },
    }

    local function setEntryValue(entries, name, value)
        for _, entry in ipairs(entries) do
            if entry.name == name then
                entry.val = value
                break
            end
        end
    end

    for _, component in ipairs(components) do
        local mapping = component.isProp and propMap[component.componentId] or clothingMap[component.componentId]

        if mapping then
            if #mapping == 2 then
                setEntryValue(defaults, mapping[1], component.drawableId)
                setEntryValue(defaults, mapping[2], component.textureId)
            else
                setEntryValue(defaults, mapping[1], component.drawableId)
            end
        end
    end

    return defaults
end

function ClothingService.ConvertQBClothingToComponents(components)
    if not components then
        return
    end

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "t-shirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso2",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "vest",
        [CLOTHING_COMPONENTS.BAGS_AND_PARACHUTE] = "bag",
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = "hat",
        [PROP_COMPONENTS.EARS] = "ear",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "accessory",
    }

    local result = {
        outfitData = {},
    }

    for _, component in ipairs(components) do
        local key = component.isProp and propMap[component.componentId] or clothingMap[component.componentId]

        if key then
            result.outfitData[key] = {
                item = component.drawableId,
                texture = component.textureId,
                defaultItem = 1,
                defaultTexture = 0,
            }
        end
    end

    return result
end

function ClothingService.ConvertSkinchangerToComponents(components)
    if not components then
        return
    end

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "tshirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "bproof",
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = "helmet",
        [PROP_COMPONENTS.EARS] = "ears",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "chain",
    }

    local result = {}

    for _, component in ipairs(components) do
        local key = component.isProp and propMap[component.componentId] or clothingMap[component.componentId]

        if key then
            if key == "arms" and not component.isProp then
                result.arms = component.drawableId
                result.arms_2 = component.textureId
            else
                result[key .. "_1"] = component.drawableId
                result[key .. "_2"] = component.textureId
            end
        end
    end

    return result
end

function ClothingService.ConvertFivemAppearanceToComponents(components)
    if not components then
        return
    end

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "tshirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "bproof",
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = "helmet",
        [PROP_COMPONENTS.EARS] = "ears",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "chain",
    }

    local clothing = {}
    local props = {}

    for _, component in ipairs(components) do
        local converted = {}

        if component.isProp then
            local mappedProp = propMap[component.componentId]
            if mappedProp then
                converted.texture = getOrDefault(component.textureId, -1)
                converted.drawable = getOrDefault(component.drawableId, -1)
                converted.prop_id = component.componentId
                table.insert(props, converted)
            end
        else
            local mappedComponent = clothingMap[component.componentId]
            if mappedComponent then
                converted.texture = getOrDefault(component.textureId, 0)
                converted.drawable = getOrDefault(component.drawableId, 0)
                converted.component_id = component.componentId
                table.insert(clothing, converted)
            end
        end
    end

    return clothing, props
end

function ClothingService.ConvertBLAppearanceToComponents(components)
    if not components then
        return
    end

    local clothingMap = {
        [CLOTHING_COMPONENTS.PANTS] = "legs",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.BODY] = "torsos",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "vest",
        [CLOTHING_COMPONENTS.HAIR_STYLES] = "hair",
        [CLOTHING_COMPONENTS.MASKS] = "masks",
        [CLOTHING_COMPONENTS.BAGS_AND_PARACHUTE] = "bags",
        -- original decompiled code overwrote SHIRT with "jackets"
        [CLOTHING_COMPONENTS.SHIRT] = "jackets",
    }

    local propMap = {
        [PROP_COMPONENTS.HATS] = "hats",
        [PROP_COMPONENTS.EARS] = "earrings",
        [PROP_COMPONENTS.GLASSES] = "glasses",
        [PROP_COMPONENTS.WATCHES] = "watches",
        [PROP_COMPONENTS.BRACELETS] = "bracelets",
    }

    local drawables = {}
    local props = {}

    for _, component in ipairs(components) do
        if component.isProp then
            local mappedProp = propMap[component.componentId]
            if mappedProp then
                props[mappedProp] = {
                    value = getOrDefault(component.drawableId, 0),
                    id = mappedProp,
                    texture = getOrDefault(component.textureId, 0),
                    index = component.componentId,
                }
            end
        else
            local mappedComponent = clothingMap[component.componentId]
            if mappedComponent then
                drawables[mappedComponent] = {
                    value = getOrDefault(component.drawableId, 0),
                    id = mappedComponent,
                    texture = getOrDefault(component.textureId, 0),
                    index = component.componentId,
                }
            end
        end
    end

    return {
        drawables = drawables,
        props = props,
    }
end

return ClothingService