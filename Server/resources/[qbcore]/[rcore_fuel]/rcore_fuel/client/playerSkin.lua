--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

if not Config.SkinChangerType then
    Config.SkinChangerType = SkinChangerType.AUTOMATIC
end

detectedSkinChangerType = Config.SkinChangerType

if Config.SkinChangerType == SkinChangerType.NONE then
    Config.DisableOutfit = true
elseif not Config.DisableOutfit then
    if Config.SkinChangerType == SkinChangerType.AUTOMATIC or Config.SkinChangerType == nil then
        -- FIX 1: this runs immediately at script load time (not deferred), so it
        -- can't rely on IsResourceOnServer (defined in object.lua) having already
        -- loaded -- check GetResourceState directly instead
        for resourceName, skinType in pairs(skinchangerResource) do
            if GetResourceState(resourceName) == "started" or GetResourceState(resourceName) == "starting" then
                detectedSkinChangerType = skinType
                break
            end
        end
    end
end

if Config.DisableOutfit then
    Config.SkinChangerType = SkinChangerType.NONE
    detectedSkinChangerType = SkinChangerType.NONE
end

if detectedSkinChangerType == SkinChangerType.NONE then
    function LoadPlayerSkin(skinData) end
    function LoadPlayerClothes(skinData, clothesData) end
    function GetPlayerSkin(callback)
        callback({})
    end
    function SavePlayerSkin(skinData) end
    function SetPlayerLastSkin(skinData) end
elseif detectedSkinChangerType == SkinChangerType.SKIN_CHANGER
    or detectedSkinChangerType == SkinChangerType.CUI_CHARACTER
    or detectedSkinChangerType == SkinChangerType.RCORE_CLOTHING then

    function LoadPlayerSkin(skinData)
        TriggerEvent("skinchanger:loadSkin", skinData)
    end

    function LoadPlayerClothes(skinData, clothesData)
        TriggerEvent("skinchanger:loadClothes", skinData, clothesData)
    end

    function GetPlayerSkin(callback)
        TriggerEvent("skinchanger:getSkin", callback)
    end

    function SavePlayerSkin(skinData)
        TriggerServerEvent("esx_skin:save", skinData)
    end

    function SetPlayerLastSkin(skinData)
        TriggerEvent("esx_skin:setLastSkin", skinData)
    end
end

if detectedSkinChangerType == SkinChangerType.QB_CLOTHING then
    cachedQbClothingData = {}
    qbSkinFieldMappings = {
        arms = { name = "arms", item = 0 },
        eye_color = { name = "eye_color", item = 0 },
        tshirt_1 = { name = "t-shirt", item = 1 },
        tshirt_2 = { name = "t-shirt", texture = 0 },
        torso_1 = { name = "torso2", item = 1 },
        torso_2 = { name = "torso2", texture = 0 },
        pants_1 = { name = "pants", item = 0 },
        pants_2 = { name = "pants", texture = 0 },
        shoes_1 = { name = "shoes", item = 0 },
        shoes_2 = { name = "shoes", texture = 0 },
        face_1 = { name = "face", item = 0 },
        face_2 = { name = "face", texture = 0 },
        skin = { name = "face", texture = 0 },
        bproof_1 = { name = "vest", item = 0 },
        bproof_2 = { name = "vest", texture = 0 },
        chain_1 = { name = "accessory", item = 0 },
        chain_2 = { name = "accessory", texture = 0 },
        decals_1 = { name = "decals", item = 0 },
        decals_2 = { name = "decals", texture = 0 },
        bags_1 = { name = "bag", item = 0 },
        bags_2 = { name = "bag", texture = 0 },
        ears_1 = { name = "ear", item = 0 },
        ears_2 = { name = "ear", texture = 0 },
        glasses_1 = { name = "glass", item = 0 },
        glasses_2 = { name = "glass", texture = 0 },
        age_1 = { name = "ageing", item = 0 },
        age_2 = { name = "ageing", texture = 0 },
        watches_1 = { name = "watch", item = 0 },
        watches_2 = { name = "watch", texture = 0 },
        mask_1 = { name = "mask", item = 0 },
        mask_2 = { name = "mask", texture = 0 },
        helmet_1 = { name = "hat", item = 0 },
        helmet_2 = { name = "hat", texture = 0 },
        nose_0 = { name = "nose_0", item = 0 },
        nose_1 = { name = "nose_1", item = 0 },
        nose_2 = { name = "nose_2", item = 0 },
        nose_3 = { name = "nose_3", item = 0 },
        nose_4 = { name = "nose_4", item = 0 },
        nose_5 = { name = "nose_5", item = 0 },
        moles_1 = { name = "moles", item = 0 },
        moles_2 = { name = "moles", texture = 0 },
        hair_1 = { name = "hair", item = 0 },
        hair_2 = { name = "hair", texture = 0 },
        eyebrows_1 = { name = "eyebrows", item = 0 },
        eyebrows_2 = { name = "eyebrows", texture = 0 },
        beard_1 = { name = "beard", item = 0 },
        beard_2 = { name = "beard", texture = 0 },
        eye_opening = { name = "nose", item = 0, id = 1 },
        jaw_bone_width = { name = "jaw_bone_width", item = 0 },
        jaw_bone_back_lenght = { name = "jaw_bone_back_lenght", item = 0 },
        lips_thickness_1 = { name = "lips_thickness", item = 0 },
        lips_thickness_2 = { name = "lips_thickness", texture = 0 },
        cheek_1 = { name = "cheek_1", item = 0 },
        cheek_2 = { name = "cheek_2", item = 0 },
        cheek_3 = { name = "cheek_3", item = 0 },
        eyebrown_high = { name = "eyebrown_high", item = 0 },
        eyebrown_forward = { name = "eyebrown_forward", item = 0 },
        chimp_bone_lowering = { name = "chimp_bone_lowering", item = 0 },
        chimp_bone_lenght = { name = "chimp_bone_lenght", item = 0 },
        chimp_bone_width = { name = "chimp_bone_width", item = 0 },
        chimp_hole = { name = "chimp_hole", item = 0 },
        neck_thikness = { name = "neck_thikness", item = 0 },
        blush_1 = { name = "blush", item = 0 },
        blush_2 = { name = "blush", texture = 0 },
        lipstick_1 = { name = "lipstick", item = 0 },
        lipstick_2 = { name = "lipstick", texture = 0 },
        makeup_1 = { name = "makeup", item = 0 },
        makeup_2 = { name = "makeup", texture = 0 },
        bracelets_1 = { name = "bracelet", item = 0 },
        bracelets_2 = { name = "bracelet", texture = 0 },
    }
    SkinDataForQBCore = qbSkinFieldMappings

    function ConvertSkinToQB(skinData, callback)
        GetPlayerSkinNonEdited(function(baseSkin)
            local qbSkin = deepCopy(SkinDataForQBCore)

            for fieldKey, fieldValue in pairs(skinData) do
                local fieldMapping = qbSkinFieldMappings[fieldKey]
                if fieldMapping then
                    if not qbSkin[fieldMapping.name] then
                        qbSkin[fieldMapping.name] = {
                            item = 1,
                            texture = 0,
                            defaultItem = 0,
                            defaultTexture = 0,
                            id = 1,
                        }
                    end
                    local qbField = qbSkin[fieldMapping.name]
                    if fieldMapping.id then
                        qbField.id = fieldValue
                    end
                    if fieldMapping.item then
                        qbField.item = fieldValue
                    end
                    if fieldMapping.texture then
                        qbField.texture = fieldValue
                    end
                end
            end

            for key, value in pairs(baseSkin) do
                if not qbSkin[key] then
                    qbSkin[key] = value
                end
            end

            SkinDataForQBCore = qbSkin
            callback(SkinDataForQBCore)
        end)
    end

    function ConvertSkinToSkinChanger(qbSkin, callback)
        local skinChangerSkin = {}

        for fieldKey, fieldMapping in pairs(qbSkinFieldMappings) do
            local qbField = qbSkin[fieldMapping.name]
            if qbField then
                if fieldMapping.item then
                    skinChangerSkin[fieldKey] = qbField.item
                end
                if fieldMapping.texture then
                    skinChangerSkin[fieldKey] = qbField.texture
                end
            end
        end

        if callback then
            local playerModel = GetEntityModel(PlayerPedId())
            skinChangerSkin.sex = playerModel == GetHashKey("mp_m_freemode_01") and 0 or 1
            callback(skinChangerSkin)
        end
    end

    function LoadPlayerSkin(skinData)
        ConvertSkinToQB(skinData, function(qbSkin)
            TriggerEvent("qb-clothing:client:loadPlayerClothing", qbSkin)
        end)
    end

    function LoadPlayerClothes(skinData, clothesData)
        ConvertSkinToQB(skinData, function(qbSkin)
            TriggerEvent("qb-clothing:client:loadPlayerClothing", qbSkin)
        end)
    end

    function GetPlayerSkin(callback)
        if not Config.OldSystemForQBClothing then
            ConvertSkinToSkinChanger(cachedQbClothingData, callback)
        else
            TriggerEvent("skinchanger:getSkin", function(skin)
                ConvertSkinToSkinChanger(skin, callback)
            end)
        end
    end

    function GetPlayerSkinNonEdited(callback)
        if not Config.OldSystemForQBClothing then
            callback(cachedQbClothingData)
        else
            TriggerEvent("skinchanger:getSkin", callback)
        end
    end

    function SavePlayerSkin(skinData)
        local playerModel = GetEntityModel(PlayerPedId())
        ConvertSkinToQB(skinData, function(qbSkin)
            for key, value in pairs(qbSkin) do
                cachedQbClothingData[key] = value
            end
            TriggerServerEvent("qb-clothing:saveSkin", playerModel, json.encode(qbSkin))
        end)
    end

    function SetPlayerLastSkin(skinData)
    end

    if not Config.OldSystemForQBClothing then
        OnObjectLoaded(function()
            if SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData then
                local playerData = SharedObject.Functions.GetPlayerData()
                if playerData and playerData.citizenid then
                    TriggerServerEvent("qb-clothes:loadPlayerSkin")
                end
            end
        end)

        RegisterNetEvent("qb-clothing:client:loadPlayerClothing", function(clothingData, _)
            for key, value in pairs(clothingData) do
                cachedQbClothingData[key] = value
            end
        end)

        RegisterNetEvent("qb-clothing:client:loadOutfit", function(outfitData)
            for key, value in pairs(outfitData) do
                cachedQbClothingData[key] = value
            end
        end)
    end
end

if detectedSkinChangerType == SkinChangerType.FIVEM_APPEARANCE
    or detectedSkinChangerType == SkinChangerType.ILLENIUM_APPEARANCE then

    appearanceResourceByType = {}
    appearanceResourceByType[SkinChangerType.FIVEM_APPEARANCE] = "fivem-appearance"
    appearanceResourceByType[SkinChangerType.ILLENIUM_APPEARANCE] = "illenium-appearance"

    function BuildAppearanceOverlay(skin, styleKey, colorKey, opacityKey)
        return {
            style = skin[styleKey] or 0,
            color = skin[colorKey] or 0,
            opacity = skin[opacityKey] or 0,
        }
    end

    function BuildAppearanceProp(skin, drawableKey, textureKey, propId, defaultDrawable)
        return {
            drawable = skin[drawableKey] or defaultDrawable,
            texture = skin[textureKey] or defaultDrawable,
            prop_id = propId,
        }
    end

    function BuildAppearanceComponent(componentId, drawable, texture)
        return {
            component_id = componentId,
            drawable = drawable,
            texture = texture,
        }
    end

    function SetPlayerSkin(skinData)
        local playerPed = PlayerPedId()
        local appearanceExport = exports[appearanceResourceByType[detectedSkinChangerType]]
        local targetModel = skinData.sex == 1 and GetHashKey("mp_f_freemode_01") or GetHashKey("mp_m_freemode_01")

        if GetEntityModel(PlayerPedId()) ~= targetModel then
            appearanceExport:setPlayerModel(targetModel)
        end

        appearanceExport:setPedHeadOverlays(playerPed, {
            complexion = BuildAppearanceOverlay(skinData, "complexion_1", "complexion_2", "complexion_3"),
            blemishes = BuildAppearanceOverlay(skinData, "blemishes_1", "blemishes_2", "blemishes_3"),
            makeUp = BuildAppearanceOverlay(skinData, "makeup_1", "makeup_2", "makeup_3"),
            moleAndFreckles = BuildAppearanceOverlay(skinData, "moles_1", "moles_2", "moles_3"),
            ageing = BuildAppearanceOverlay(skinData, "age_1", "age_2", "age_3"),
            beard = BuildAppearanceOverlay(skinData, "beard_1", "beard_2", "beard_3"),
            lipstick = BuildAppearanceOverlay(skinData, "lipstick_1", "lipstick_2", "lipstick_3"),
            bodyBlemishes = BuildAppearanceOverlay(skinData, "bodyb_1", "bodyb_2", "bodyb_3"),
            eyebrows = BuildAppearanceOverlay(skinData, "eyebrows_1", "eyebrows_2", "eyebrows_3"),
            chestHair = BuildAppearanceOverlay(skinData, "chest_1", "chest_2", "chest_3"),
            sunDamage = BuildAppearanceOverlay(skinData, "sun_1", "sun_2", "sun_3"),
            blush = BuildAppearanceOverlay(skinData, "blush_1", "blush_2", "blush_3"),
        })

        appearanceExport:setPedHair(playerPed, {
            style = skinData.hair_1,
            texture = skinData.hair_2,
            color = skinData.hair_color_1,
            highlight = skinData.hair_color_2,
        })

        appearanceExport:setPedProps(playerPed, {
            BuildAppearanceProp(skinData, "helmet_1", "helmet_2", 0, -1),
            BuildAppearanceProp(skinData, "glasses_1", "glasses_2", 1, -1),
            BuildAppearanceProp(skinData, "ears_1", "ears_2", 2, -1),
            BuildAppearanceProp(skinData, "watches_1", "watches_2", 6, -1),
            BuildAppearanceProp(skinData, "bracelets_1", "bracelets_2", 7, -1),
        })

        appearanceExport:setPedComponents(playerPed, {
            BuildAppearanceComponent(0, 0, 0),
            BuildAppearanceComponent(1, skinData.mask_1, skinData.mask_2),
            BuildAppearanceComponent(2, 0, 0),
            BuildAppearanceComponent(3, skinData.arms, 0),
            BuildAppearanceComponent(4, skinData.pants_1, skinData.pants_2),
            BuildAppearanceComponent(5, skinData.bags_1, skinData.bags_2),
            BuildAppearanceComponent(6, skinData.shoes_1, skinData.shoes_2),
            BuildAppearanceComponent(7, skinData.chain_1, skinData.chain_2),
            BuildAppearanceComponent(8, skinData.tshirt_1, skinData.tshirt_2),
            BuildAppearanceComponent(9, skinData.bproof_1, skinData.bproof_2),
            BuildAppearanceComponent(10, skinData.decals_1, skinData.decals_2),
            BuildAppearanceComponent(11, skinData.torso_1, skinData.torso_2),
        })
    end

    function LoadPlayerSkin(skinData)
        SetPlayerSkin(skinData)
    end

    function LoadPlayerClothes(skinData, clothesData)
        SetPlayerSkin(skinData)
    end

    function CopyAppearanceOverlayToSkin(skin, appearance, overlayKey, styleKey, colorKey, opacityKey)
        local overlay = appearance.headOverlays and appearance.headOverlays[overlayKey]
        skin[styleKey] = overlay and overlay.style or 0
        skin[colorKey] = overlay and overlay.color or 0
        skin[opacityKey] = overlay and overlay.opacity or 0
    end

    function CopyAppearanceComponentToSkin(skin, components, componentId, drawableKey, textureKey)
        for _, component in pairs(components or {}) do
            if component.component_id == componentId then
                skin[drawableKey] = component.drawable
                skin[textureKey] = component.texture
                return
            end
        end
    end

    function CopyAppearancePropToSkin(skin, props, propId, drawableKey, textureKey)
        for _, prop in pairs(props or {}) do
            if prop.prop_id == propId then
                skin[drawableKey] = prop.drawable
                skin[textureKey] = prop.texture
                return
            end
        end
    end

    function GetPlayerSkin(callback)
        local appearance = exports[appearanceResourceByType[detectedSkinChangerType]]:getPedAppearance(PlayerPedId())
        local skin = {}

        CopyAppearanceOverlayToSkin(skin, appearance, "complexion", "complexion_1", "complexion_2", "complexion_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "blemishes", "blemishes_1", "blemishes_2", "blemishes_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "makeUp", "makeup_1", "makeup_2", "makeup_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "moleAndFreckles", "moles_1", "moles_2", "moles_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "ageing", "age_1", "age_2", "age_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "beard", "beard_1", "beard_2", "beard_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "lipstick", "lipstick_1", "lipstick_2", "lipstick_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "bodyBlemishes", "bodyb_1", "bodyb_2", "bodyb_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "eyebrows", "eyebrows_1", "eyebrows_2", "eyebrows_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "chestHair", "chest_1", "chest_2", "chest_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "sunDamage", "sun_1", "sun_2", "sun_3")
        CopyAppearanceOverlayToSkin(skin, appearance, "blush", "blush_1", "blush_2", "blush_3")

        if appearance.hair then
            skin.hair_1 = appearance.hair.style
            skin.hair_2 = appearance.hair.texture
            skin.hair_color_1 = appearance.hair.color
            skin.hair_color_2 = appearance.hair.highlight
        end

        CopyAppearancePropToSkin(skin, appearance.props, 0, "helmet_1", "helmet_2")
        CopyAppearancePropToSkin(skin, appearance.props, 1, "glasses_1", "glasses_2")
        CopyAppearancePropToSkin(skin, appearance.props, 2, "ears_1", "ears_2")
        CopyAppearancePropToSkin(skin, appearance.props, 6, "watches_1", "watches_2")
        CopyAppearancePropToSkin(skin, appearance.props, 7, "bracelets_1", "bracelets_2")

        CopyAppearanceComponentToSkin(skin, appearance.components, 1, "mask_1", "mask_2")
        for _, component in pairs(appearance.components or {}) do
            if component.component_id == 3 then
                skin.arms = component.drawable
            end
        end
        CopyAppearanceComponentToSkin(skin, appearance.components, 4, "pants_1", "pants_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 5, "bags_1", "bags_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 6, "shoes_1", "shoes_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 7, "chain_1", "chain_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 8, "tshirt_1", "tshirt_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 9, "bproof_1", "bproof_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 10, "decals_1", "decals_2")
        CopyAppearanceComponentToSkin(skin, appearance.components, 11, "torso_1", "torso_2")

        local playerModel = GetEntityModel(PlayerPedId())
        skin.sex = playerModel == GetHashKey("mp_m_freemode_01") and 0 or 1

        callback(skin)
    end

    function SavePlayerSkin(skinData)
        TriggerServerEvent(
            Config.Fivem_AppearanceSaveEvent,
            exports[appearanceResourceByType[detectedSkinChangerType]]:getPedAppearance(PlayerPedId())
        )
    end

    function SetPlayerLastSkin(skinData)
    end
end

function ResetStuff()
    SkinDataForQBCore = {}
end

defaultPlayerSkinSnapshot = {}
jobSkinSnapshot = {}

function LoadPlayerJobSkin()
    local skinPromise = promise.new()
    GetPlayerSkin(function(currentSkin)
        skinPromise:resolve(currentSkin)
    end)

    local currentSkin = Citizen.Await(skinPromise)
    jobSkinSnapshot = DeepCopy(currentSkin)
    defaultPlayerSkinSnapshot = DeepCopy(currentSkin)

    local genderKey = currentSkin.sex == 0 and "male" or "female"
    for fieldKey, fieldValue in pairs(Config.Skin[genderKey]) do
        defaultPlayerSkinSnapshot[fieldKey] = fieldValue
    end

    LoadPlayerSkin(defaultPlayerSkinSnapshot)
end

function LoadPlayerDefaultSkin()
    LoadPlayerSkin(jobSkinSnapshot)
end
