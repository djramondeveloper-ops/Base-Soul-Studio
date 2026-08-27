-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-clothing.lua
--  Engineered by Eazy Fxap
--  Original: 963 lines → Cleaned: 240 lines
-- =====================================================

ClothingService = {}

function ClothingService.SetClothingComponents(ped, components)
    for _, comp in ipairs(components) do
        if comp.isProp ~= true then
            SetPedComponentVariation(ped, comp.componentId, comp.drawableId or 0, comp.textureId or 0, 2)
        end
    end
end

function ClothingService.ClearAllPedProps(ped)
    for i = 0, 7, 1 do
        ClearPedProp(ped, i)
    end
end

function ClothingService.ResetClothing(ped)
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        ClearAllPedProps(ped)
        SetPedDefaultComponentVariation(ped)
    end
end

function ClothingService.SetPropComponents(ped, components)
    for _, comp in ipairs(components) do
        if comp.isProp == true then
            if comp.drawableId == -1 then
                ClearPedProp(ped, comp.componentId)
            else
                SetPedPropIndex(ped, comp.componentId, comp.drawableId or 0, comp.textureId or 0, true)
            end
        end
    end
end

function ClothingService.ApplyClothing(ped, components)
    if not ped or not components then return end
    ClothingService.SetClothingComponents(ped, components)
    ClothingService.SetPropComponents(ped, components)
end

function ClothingService.ConvertClothingComponents(resourceType, components)
    if resourceType == Clothing.QB then
        return ClothingService.ConvertQBClothingToComponents(components)
    elseif resourceType == Clothing.SKINCHANGER then
        return ClothingService.ConvertSkinchangerToComponents(components)
    elseif resourceType == Clothing.TGIANN then
        return ClothingService.ConvertTGIANN(components)
    elseif resourceType == Clothing.CRM then
        return ClothingService.ConvertCRM(components)
    elseif resourceType == Clothing.FAPPEARANCE then
        return ClothingService.ConvertFivemAppearanceToComponents(components)
    elseif resourceType == Clothing.BL_APPEARANCE then
        return ClothingService.ConvertBLAppearanceToComponents(components)
    end
end

function ClothingService.ConvertCRM(components)
    if not components then return end
    local mappedComp = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "tshirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "bproof"
    }
    local mappedProps = {
        [PROP_COMPONENTS.HATS] = "helmet",
        [PROP_COMPONENTS.EARS] = "ears",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "chain"
    }
    
    local out = { crm_clothing = {}, crm_accessories = {} }
    for _, comp in ipairs(components) do
        if comp.isProp then
            local pName = mappedProps[comp.componentId]
            table.insert(out.crm_accessories, {
                crm_id = comp.componentId,
                crm_style = comp.drawableId,
                crm_texture = comp.textureId
            })
        else
            local cName = mappedComp[comp.componentId]
            table.insert(out.crm_clothing, {
                crm_id = comp.componentId,
                crm_style = comp.drawableId,
                crm_texture = comp.textureId
            })
        end
    end
    return out
end

function ClothingService.ConvertSkinchangerToComponents(components)
    if not components then return end
    local mappedComp = {
        [CLOTHING_COMPONENTS.PANTS] = { "pants_1", "pants_2" },
        [CLOTHING_COMPONENTS.SHOES] = { "shoes_1", "shoes_2" },
        [CLOTHING_COMPONENTS.SHIRT] = { "tshirt_1", "tshirt_2" },
        [CLOTHING_COMPONENTS.ARMS] = { "arms" },
        [CLOTHING_COMPONENTS.MASKS] = { "mask_1", "mask_2" },
        [CLOTHING_COMPONENTS.BODY] = { "torso_1", "torso_2" },
        [CLOTHING_COMPONENTS.DECALS] = { "decals_1", "decals_2" },
        [CLOTHING_COMPONENTS.BODY_ARMOR] = { "bproof_1", "bproof_2" }
    }
    local mappedProps = {
        [PROP_COMPONENTS.HATS] = { "helmet_1", "helmet_2" },
        [PROP_COMPONENTS.EARS] = { "ears_1", "ears_2" },
        [PROP_COMPONENTS.GLASSES] = { "glasses_1", "glasses_2" },
        [PROP_COMPONENTS.WATCHES] = { "watch_1", "watch_2" },
        [PROP_COMPONENTS.BRACELETS] = { "bracelet_1", "bracelet_2" },
        [PROP_COMPONENTS.ACCESSORY] = { "chain_1", "chain_2" }
    }
    
    local out = {}
    for _, comp in ipairs(components) do
        local m = comp.isProp and mappedProps[comp.componentId] or mappedComp[comp.componentId]
        if m then
            if #m == 2 then
                out[m[1]] = comp.drawableId
                out[m[2]] = comp.textureId
            else
                out[m[1]] = comp.drawableId
            end
        end
    end
    return out
end

function ClothingService.ConvertQBClothingToComponents(components)
    if not components then return end
    local mappedComp = {
        [CLOTHING_COMPONENTS.PANTS] = "pants",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "t-shirt",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.MASKS] = "mask",
        [CLOTHING_COMPONENTS.BODY] = "torso2",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "vest",
        [CLOTHING_COMPONENTS.BAGS_AND_PARACHUTE] = "bag"
    }
    local mappedProps = {
        [PROP_COMPONENTS.HATS] = "hat",
        [PROP_COMPONENTS.EARS] = "ear",
        [PROP_COMPONENTS.GLASSES] = "glass",
        [PROP_COMPONENTS.WATCHES] = "watch",
        [PROP_COMPONENTS.BRACELETS] = "bracelet",
        [PROP_COMPONENTS.ACCESSORY] = "accessory"
    }
    
    local out = { outfitData = {} }
    for _, comp in ipairs(components) do
        local m = comp.isProp and mappedProps[comp.componentId] or mappedComp[comp.componentId]
        if m then
            out.outfitData[m] = {
                item = comp.drawableId,
                texture = comp.textureId,
                defaultItem = 1,
                defaultTexture = 0
            }
        end
    end
    return out
end

function ClothingService.ConvertTGIANN(components)
    -- Just reuse the skinchanger conversion logic as they use the same variable structure
    return ClothingService.ConvertSkinchangerToComponents(components)
end

function ClothingService.ConvertFivemAppearanceToComponents(components)
    if not components then return end
    local mappedComp = {
        [CLOTHING_COMPONENTS.PANTS] = "legs",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "jackets",
        [CLOTHING_COMPONENTS.BODY] = "torsos",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "vest",
        [CLOTHING_COMPONENTS.HAIR_STYLES] = "hair",
        [CLOTHING_COMPONENTS.MASKS] = "masks",
        [CLOTHING_COMPONENTS.BAGS_AND_PARACHUTE] = "bags"
    }
    local mappedProps = {
        [PROP_COMPONENTS.HATS] = "hats",
        [PROP_COMPONENTS.EARS] = "earrings",
        [PROP_COMPONENTS.GLASSES] = "glasses",
        [PROP_COMPONENTS.WATCHES] = "watches",
        [PROP_COMPONENTS.BRACELETS] = "bracelets"
    }

    local out = {}
    local outProps = {}

    for _, comp in ipairs(components) do
        if not comp.isProp then
            local m = mappedComp[comp.componentId]
            if m then
                table.insert(out, {
                    component_id = comp.componentId,
                    drawable = comp.drawableId or 0,
                    texture = comp.textureId or 0
                })
            end
        else
            local m = mappedProps[comp.componentId]
            if m then
                table.insert(outProps, {
                    prop_id = comp.componentId,
                    drawable = comp.drawableId or -1,
                    texture = comp.textureId or -1
                })
            end
        end
    end
    
    return out, outProps
end

function ClothingService.ConvertBLAppearanceToComponents(components)
    if not components then return end
    local mappedComp = {
        [CLOTHING_COMPONENTS.PANTS] = "legs",
        [CLOTHING_COMPONENTS.SHOES] = "shoes",
        [CLOTHING_COMPONENTS.SHIRT] = "shirts",
        [CLOTHING_COMPONENTS.BODY] = "torsos",
        [CLOTHING_COMPONENTS.DECALS] = "decals",
        [CLOTHING_COMPONENTS.ARMS] = "arms",
        [CLOTHING_COMPONENTS.BODY_ARMOR] = "vest",
        [CLOTHING_COMPONENTS.HAIR_STYLES] = "hair",
        [CLOTHING_COMPONENTS.MASKS] = "masks",
        [CLOTHING_COMPONENTS.BAGS_AND_PARACHUTE] = "bags"
    }
    local mappedProps = {
        [PROP_COMPONENTS.HATS] = "hats",
        [PROP_COMPONENTS.EARS] = "earrings",
        [PROP_COMPONENTS.GLASSES] = "glasses",
        [PROP_COMPONENTS.WATCHES] = "watches",
        [PROP_COMPONENTS.BRACELETS] = "bracelets"
    }

    local drawables = {}
    local props = {}

    for _, comp in ipairs(components) do
        if not comp.isProp then
            local m = mappedComp[comp.componentId]
            if m then
                drawables[m] = {
                    index = comp.componentId,
                    value = comp.drawableId or 0,
                    texture = comp.textureId or 0,
                    id = m
                }
            end
        else
            local m = mappedProps[comp.componentId]
            if m then
                props[m] = {
                    index = comp.componentId,
                    value = comp.drawableId or 0,
                    texture = comp.textureId or 0,
                    id = m
                }
            end
        end
    end

    return { drawables = drawables, props = props }
end
