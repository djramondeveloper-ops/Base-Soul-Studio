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

if not Config.Debug then
    return
end

local isInEditor = false
local highlightedPumpEntity = nil
local selectedPumpEntity = nil
local pumpPositionList = {}
local gasPrices = {}
local buyMenuMarkerPos = nil
local bossMenuMarkerPos = nil
local blipPosition = nil
local editorBlipId = nil
local cameraPosition = nil
local cameraRotation = nil
local entityHeading = 0.0
local spawnedEditorEntities = {}
local tankerObjectEntity = nil
local scaleformTankerEntity = nil
local tipTruckEntity = nil
local tapObjectEntity = nil
local missionBlipPosition = nil

local EditorStep = {
    PUMPS = 1,
    BUY_MENU = 2,
    BOSS_MENU = 3,
    BLIP = 4,
    CAMERA_POSITION = 5,
    TANKER_OBJECT = 6,
    SCALEFORM_TANKER = 7,
    TIPTRUCK = 8,
    TAP_POSITION = 9,
    MISSION_BLIP_POSITION = 10,
    SHOP_SETTINGS = 11,
}

local stepHelpTexts = {
    [EditorStep.PUMPS] = [[
Creating new fuel pumps
~g~Left click = Select pump
~r~Right click = proceed to next step]],
    [EditorStep.BUY_MENU] = [[
Buy company marker position
~r~Left click = proceed to next step]],
    [EditorStep.BOSS_MENU] = [[
Player boss menu position
~r~Left click = proceed to next step]],
    [EditorStep.BLIP] = [[
Blip minimap position
~r~Left click = proceed to next step]],
    [EditorStep.TANKER_OBJECT] = [[
Tanker placement
~r~Left click = create object
~b~Right click = next step
~g~MW UP/DOWN = rotation]],
    [EditorStep.SCALEFORM_TANKER] = [[
Scaleform placement
~r~Left click = proceed to next step
~g~MW UP/DOWN = rotation]],
    [EditorStep.CAMERA_POSITION] = [[
Camera buy position
~r~Left click = proceed to next step
~b~Right click = save camera pos + rot]],
    [EditorStep.SHOP_SETTINGS] = "Shop settings",
    [EditorStep.TIPTRUCK] = [[
Vehicle spawn location
~r~Left click = proceed to next step
~g~MW UP/DOWN = rotation]],
    [EditorStep.TAP_POSITION] = [[
Tap position
~r~Left click = proceed to next step
~g~MW UP/DOWN = rotation]],
    [EditorStep.MISSION_BLIP_POSITION] = [[
Blip mission position
~r~Left click = proceed to next step]],
}

local currentEditorStep = EditorStep.PUMPS

local rotationEnabledSteps = {
    [EditorStep.TANKER_OBJECT] = true,
    [EditorStep.SCALEFORM_TANKER] = true,
    [EditorStep.TIPTRUCK] = true,
    [EditorStep.TAP_POSITION] = true,
}

function GetStationEditorPlacementEntity()
    return tapObjectEntity or tipTruckEntity or tankerObjectEntity
end

function ResetVariables()
    for _, entity in pairs(spawnedEditorEntities) do
        DeleteEntity(entity)
    end

    RemoveBlip(editorBlipId)

    spawnedEditorEntities = {}
    scaleformTankerEntity = nil
    tapObjectEntity = nil
    blipPosition = nil
    bossMenuMarkerPos = nil
    buyMenuMarkerPos = nil
    highlightedPumpEntity = nil
    selectedPumpEntity = nil
    tankerObjectEntity = nil
    tipTruckEntity = nil
    cameraPosition = nil
    cameraRotation = nil
    entityHeading = 0.0
    pumpPositionList = {}
    gasPrices = {}
    missionBlipPosition = nil
end

RegisterCommand("pumpeditor", function(source)
    -- FIX 1: every other editor command in this resource (e.g. offsetfueling)
    -- requires IsPlayerInGroup before granting access; this one had no permission
    -- check at all, so any connected player could open the full station editor
    -- (pump positions, camera angles, tanker spawns, shop settings) while the
    -- server owner has Config.Debug enabled to set stations up.
    if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
        TriggerEvent("chat:addMessage", {
            args = {
                "^1SYSTEM",
                "Warning you do not have permission to open this command. You did not added the 'add_ace' or you dont have on your character 'add_principal'",
            },
        })
        return
    end

    isInEditor = not isInEditor
    print("isInEditor", isInEditor)

    if not isInEditor then
        currentEditorStep = EditorStep.PUMPS
        ResetVariables()
    end
end)

CreateThread(function()
    while true do
        Wait(0)

        if not isInEditor then
            Wait(1000)
            goto continue
        end

        if rotationEnabledSteps[currentEditorStep] then
            if IsControlPressed(0, 96) then
                entityHeading = entityHeading + 1.0
                SetEntityHeading(GetStationEditorPlacementEntity(), entityHeading)
            end

            if IsControlPressed(0, 97) then
                entityHeading = entityHeading - 1.0
                SetEntityHeading(GetStationEditorPlacementEntity(), entityHeading)
            end
        end

        ::continue::
    end
end, "editor for station setting entity heading")

RegisterKey(function()
    if not isInEditor then
        return
    end

    ClearPedTasksImmediately(PlayerPedId())

    if currentEditorStep == EditorStep.PUMPS then
        if DoesEntityExist(highlightedPumpEntity) then
            SetNuiFocus(true, true)
            SendNUIMessage({ type = "show_dispenser_settings" })
            selectedPumpEntity = highlightedPumpEntity
        end
        return
    end

    if currentEditorStep == EditorStep.BUY_MENU then
        currentEditorStep = EditorStep.BOSS_MENU
        return
    end

    if currentEditorStep == EditorStep.BOSS_MENU then
        currentEditorStep = EditorStep.BLIP
        return
    end

    if currentEditorStep == EditorStep.BLIP then
        currentEditorStep = EditorStep.CAMERA_POSITION
        return
    end

    if currentEditorStep == EditorStep.CAMERA_POSITION then
        if cameraPosition then
            currentEditorStep = EditorStep.TANKER_OBJECT
        end
        return
    end

    if currentEditorStep == EditorStep.TANKER_OBJECT then
        tankerObjectEntity = CreateLocalObject("prop_storagetank_03b", GetEntityCoords(PlayerPedId()))
        FreezeEntityPosition(tankerObjectEntity, true)
        SetEntityHeading(tankerObjectEntity, entityHeading)
        table.insert(spawnedEditorEntities, tankerObjectEntity)
        return
    end

    if currentEditorStep == EditorStep.SCALEFORM_TANKER then
        currentEditorStep = EditorStep.TIPTRUCK
        scaleformTankerEntity = tankerObjectEntity
        tankerObjectEntity = nil
        tipTruckEntity = CreateLocalVehicle(Config.TipTruckHash, GetEntityCoords(PlayerPedId()), heading)
        FreezeEntityPosition(tipTruckEntity, true)
        SetEntityHeading(tipTruckEntity, entityHeading)
        SetEntityCollision(tipTruckEntity, false, true)
        table.insert(spawnedEditorEntities, tipTruckEntity)
        return
    end

    if currentEditorStep == EditorStep.TIPTRUCK then
        currentEditorStep = EditorStep.TAP_POSITION
        tapObjectEntity = CreateLocalObject("prop_roofpipe_01", GetEntityCoords(PlayerPedId()))
        FreezeEntityPosition(tapObjectEntity, true)
        SetEntityHeading(tapObjectEntity, entityHeading)
        table.insert(spawnedEditorEntities, tapObjectEntity)
        return
    end

    if currentEditorStep == EditorStep.TAP_POSITION then
        currentEditorStep = EditorStep.MISSION_BLIP_POSITION
        return
    end

    if currentEditorStep == EditorStep.MISSION_BLIP_POSITION then
        currentEditorStep = EditorStep.SHOP_SETTINGS
    end

    if currentEditorStep == EditorStep.SHOP_SETTINGS then
        SetNuiFocus(true, true)
        SendNUIMessage({ type = "shopSettings" })
    end
end, "fuel_pump_editor_click_left", "Mouse left", "MOUSE_LEFT", "MOUSE_BUTTON")

RegisterKey(function()
    if not isInEditor then
        return
    end

    if currentEditorStep == EditorStep.PUMPS then
        currentEditorStep = EditorStep.BUY_MENU
        return
    end

    if currentEditorStep == EditorStep.CAMERA_POSITION then
        cameraPosition = GetGameplayCamCoord()
        cameraRotation = GetGameplayCamRot()
        return
    end

    if currentEditorStep == EditorStep.TANKER_OBJECT and #spawnedEditorEntities ~= 0 then
        currentEditorStep = EditorStep.SCALEFORM_TANKER
        DeleteEntity(tankerObjectEntity)
        tankerObjectEntity = CreateLocalObject(1340914825, GetEntityCoords(PlayerPedId()))
        FreezeEntityPosition(tankerObjectEntity, true)
        SetEntityHeading(tankerObjectEntity, entityHeading)
        table.insert(spawnedEditorEntities, tankerObjectEntity)
    end
end, "fuel_pump_editor_click_right", "Mouse right", "MOUSE_RIGHT", "MOUSE_BUTTON")

CreateThread(function()
    while true do
        Wait(0)

        if not isInEditor then
            Wait(1000)
            goto continue
        end

        ShowNativeSubtitles(stepHelpTexts[currentEditorStep])

        local raycastOrigin = GetStationEditorPlacementEntity() or PlayerPedId()
        local _hitCoords, hitType, hitCoords, _surfaceNormal, hitEntity, rayOrigin = CastRayCastFromPlayer(
            raycastOrigin,
            4294967295,
            20.0
        )

        DrawLine(rayOrigin, hitCoords, 255, 255, 255, 255)

        if hitType == 1 then
            if GetEntityType(hitEntity) == 3 and currentEditorStep == EditorStep.PUMPS then
                if IsModelAllowedDispenser(GetEntityModel(hitEntity)) then
                    highlightedPumpEntity = hitEntity
                else
                    highlightedPumpEntity = nil
                end
            end

            if currentEditorStep == EditorStep.MISSION_BLIP_POSITION then
                missionBlipPosition = hitCoords + vector3(0, 0, 1)
            end

            if currentEditorStep == EditorStep.BUY_MENU then
                buyMenuMarkerPos = hitCoords + vector3(0, 0, 1)
            end

            if currentEditorStep == EditorStep.BOSS_MENU then
                bossMenuMarkerPos = hitCoords + vector3(0, 0, 1)
            end

            if currentEditorStep == EditorStep.BLIP then
                blipPosition = hitCoords
                RemoveBlip(editorBlipId)
                editorBlipId = createBlip("Editor blip", 361, blipPosition, {
                    type = 4,
                    scale = 1.0,
                    color = 0,
                    shortRange = true,
                })
            end
        else
            highlightedPumpEntity = nil
        end

        if currentEditorStep == EditorStep.SCALEFORM_TANKER and tankerObjectEntity then
            SetEntityCoords(tankerObjectEntity, hitCoords + vector3(0, 0, 1.25))
        end

        if currentEditorStep == EditorStep.TANKER_OBJECT and tankerObjectEntity then
            SetEntityCoords(tankerObjectEntity, hitCoords)
        end

        if currentEditorStep == EditorStep.TIPTRUCK and tipTruckEntity then
            SetEntityCoords(tipTruckEntity, hitCoords + vector3(0, 0, 0.1))
        end

        if currentEditorStep == EditorStep.TAP_POSITION and tapObjectEntity then
            SetEntityCoords(tapObjectEntity, hitCoords - vector3(0, 0, 0.28))
        end

        ::continue::
    end
end, "station thread for setting coords")

CreateThread(function()
    while true do
        Wait(0)

        if not isInEditor and not highlightedPumpEntity then
            Wait(1000)
            goto continue
        end

        if highlightedPumpEntity then
            DrawBoundingBox(GetEntityBoundingBox(highlightedPumpEntity), 125, 125, 255, 125)
        end

        ::continue::
    end
end, "station glowing box")

CreateThread(function()
    while true do
        Wait(0)

        if not isInEditor then
            Wait(1000)
            goto continue
        end

        for _, pumpData in pairs(pumpPositionList) do
            local fuelTypeLabels = ""

            for _, fuelType in pairs(pumpData.fuelTypeList) do
                fuelTypeLabels = _U(fuelType) .. "," .. fuelTypeLabels
            end

            draw3DText(pumpData.pos + vector3(0, 0, 2), string.format("%s", fuelTypeLabels))

            if pumpData.entity and DoesEntityExist(pumpData.entity) then
                local pumpModelHash = GetEntityModel(pumpData.entity)
                local resolutionConfig = Config.resolution[pumpModelHash] or Config.resolution[GetHashKey("prop_gas_pump_1a")]
                local screenOffset = resolutionConfig.ScreenOffSet[pumpData.align]
                draw3DText(GetOffsetFromEntityInWorldCoords(pumpData.entity, screenOffset), "[RENDER]")
            end
        end

        if missionBlipPosition then
            draw3DText(missionBlipPosition, "Mission blip position")
            DrawMarker(28, missionBlipPosition, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 150, false, false, 0, false)
        end

        if bossMenuMarkerPos then
            draw3DText(bossMenuMarkerPos, "Player Boss action marker")
            DrawMarker(31, bossMenuMarkerPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 150, false, false, 0, false)
        end

        if buyMenuMarkerPos then
            draw3DText(buyMenuMarkerPos, "Buy menu marker")
            DrawMarker(29, buyMenuMarkerPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 150, false, false, 0, false)
        end

        if blipPosition then
            draw3DText(blipPosition, "Blip position")
            DrawMarker(28, blipPosition, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 150, false, false, 0, false)
        end

        if cameraPosition then
            draw3DText(cameraPosition, "Camera")
            DrawMarker(0, cameraPosition, 0.0, 0.0, 0.0, cameraRotation.x, cameraRotation.y, cameraRotation.z, 0.6, 0.6, 0.6, 255, 255, 255, 150, false, false, 0, false)
        end

        ::continue::
    end
end, "marker positions for station utilities")

RegisterNUICallback("insertShop", function(data, callback)
    local maxCapacityByFuelType = {}
    local initialCapacityByFuelType = {}

    for fuelType in pairs(gasPrices) do
        maxCapacityByFuelType[fuelType] = tonumber(data.maxTanker)
        initialCapacityByFuelType[fuelType] = tonumber(data.maxTanker)
    end

    local objectSpawnerList = {}

    for _, entity in pairs(spawnedEditorEntities) do
        if GetEntityModel(entity) == GetHashKey("prop_storagetank_03b") then
            table.insert(objectSpawnerList, {
                model = "prop_storagetank_03b",
                pos = GetEntityCoords(entity),
                heading = GetEntityHeading(entity),
                renderDistance = 100.0,
            })
        end
    end

    for _, pumpData in pairs(pumpPositionList) do
        pumpData.entity = nil
    end

    local shopConfigText = '["' .. data.identifier .. [[
"] = {
    -- blip on minimap/full map position
    enableBlip = ]] .. tostring(data.enableBlip or "false") .. [[
,
    blipScale = 0.7,
    blipPosition = ]] .. tostring(blipPosition) .. [[
,
    blipSprite = ]] .. tonumber(data.blipSprite) .. [[
,
    blipName = "]] .. data.blipName .. [[
",

    -- boss marker for the owner of the company
    companyMenuMarkerPos = ]] .. tostring(bossMenuMarkerPos) .. [[
,

     -- boss menu marker style
    companyMenuMarkerStyle = {
        size = vector3(1.0, 1.0, 1.0),
        rotate = true,
        faceCamera = false,
        color = { r = 255, g = 255, b = 255, a = 100 },
        type = 31,
    },

    -- marker where player can buy the company
    buyCompanyMarker = ]] .. tostring(buyMenuMarkerPos) .. [[
,

    -- buy marker style
    buyCompanyMarkerStyle = {
        size = vector3(1.0, 1.0, 1.0),
        rotate = true,
        faceCamera = false,
        color = { r = 0, g = 255, b = 0, a = 100 },
        type = 29,
    },

    -- Enable/Disable buying of the station?
    EnableBuyingCompany = false,

    -- when player buy the company where should the camera be rendered at
    buyCompanyCameraPosition = {
        pos = ]] .. tostring(cameraPosition) .. [[
,
        rot = ]] .. tostring(cameraRotation) .. [[
,
    },

    -- Society info
    EnableSociety = ]] .. tostring(data.enableSociety or "false") .. [[
,
    SocietyLabel = "]] .. data.societyName .. [[
",
    --SocietyName = "society_jobname",

    Job = "]] .. data.jobName .. [[
",
    Data = { type = "private", },

    -- works only for ESX this option
    ESX_BossOption = {
        withdraw = true,
        deposit = true,
        wash = false,
        employees = true,
        grades = true,
    },

    -- fuel pump position where player can fuel his car
    pumpPosition =  ]] .. dump(pumpPositionList, true, "removeKeyNumber") .. [[
,

    -- spawn info of the mission vehicle
    tipTruckSpawnPosition = {
        -- position of the spawn
        pos = ]] .. tostring(GetEntityCoords(tipTruckEntity)) .. [[
,

        -- heading of the vehicle
        heading = ]] .. GetEntityHeading(tipTruckEntity) .. [[
,
    },

    -- Tanker scaleform + blip mission
    tankerScaleform = {
        -- Mission blip on minimap where player have to drive after picking up phantom
        missionBlipPosition = ]] .. tostring(missionBlipPosition) .. [[
,

        -- position of the scaleform
        pos = ]] .. tostring(GetEntityCoords(scaleformTankerEntity)) .. [[
,

        -- rotation of the scaleform
        heading = ]] .. GetEntityHeading(scaleformTankerEntity) .. [[
,

        -- This is actually TV object hidden so we can display the nice 3D UI
        model = ]] .. GetEntityModel(scaleformTankerEntity) .. [[
,
    },

    -- this is the tap where player will attach the nozzle from phantom
    tankerTapPosition = {
        -- position of the tap
        pos = ]] .. tostring(GetEntityCoords(tapObjectEntity)) .. [[
,

        -- heading of the tap
        heading = ]] .. GetEntityHeading(tapObjectEntity) .. [[
,

        -- render distance of the tap
        renderDistance = 100.0,
    },

    -- current capacity the tanker has
    -- do not change
    capacity = ]] .. dump(initialCapacityByFuelType, true, "gasPrices") .. [[
,

    -- default prices of the fuel per liter
    -- for example if you set here 50$ then one liter of fuel will cost 50$
    gasPrices = ]] .. dump(gasPrices, true, "gasPrices") .. [[
,

    -- maximum capacity the tanker can have
    maxCapacity = ]] .. dump(maxCapacityByFuelType, true, "gasPrices") .. [[
,

    -- Hourly income is how much money the gas station will make every hour so there is passive income. So location far away from town where no player is have at least a chance to make something
    -- by setting value to "0" there wont be any passive income.
    hourlyIncome = 1000,

    -- do not change
    -- you will have to change this value in game not in config this is just placeholder for default value
    price = ]] .. tonumber(data.shopCost) .. [[
,

    -- do not change
    open = true,

    -- do not change, will also not work unless society is enabled
    fuel_only_employee = ]] .. tostring(data.employeesOnly or "false") .. [[
,

    -- do not change
    for_sale = true,

    -- do not change
    -- keep also default value "none"
    owner_identifier = "none",

    -- spawner object for this specific fuel station
    objectSpawner = ]] .. dump(objectSpawnerList, true, "removeKeyNumber") .. [[
,
},
        ]]

    Wait(500)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "display_for_copy",
        text = shopConfigText,
    })

    if callback then
        callback("ok")
    end
end)

RegisterNUICallback("insertDispenser", function(data, callback)
    SetNuiFocus(false, false)

    local selectedFuelTypes = {}
    for _, fuelType in pairs(data.fuel) do
        table.insert(selectedFuelTypes, tonumber(fuelType))
    end

    for index, pumpData in pairs(pumpPositionList) do
        if pumpData.entity ~= selectedPumpEntity then
            if DoesEntityExist(pumpData.entity) then
                goto continue_dispenser_cleanup
            end

            if #(pumpData.pos - GetEntityCoords(selectedPumpEntity)) >= 0.1 then
                goto continue_dispenser_cleanup
            end
        end

        pumpPositionList[index] = nil
        break

        ::continue_dispenser_cleanup::
    end

    table.insert(pumpPositionList, {
        entity = selectedPumpEntity,
        pos = GetEntityCoords(selectedPumpEntity),
        hash = GetEntityModel(selectedPumpEntity),
        fuelTypeList = selectedFuelTypes,
        fuelType = -1,
        align = data.align,
    })

    for _, fuelType in pairs(data.fuel) do
        gasPrices[tonumber(fuelType)] = tonumber(data.price)
    end

    if callback then
        callback("ok")
    end
end)

RegisterNUICallback("init", function(_data, callback)
    for label, key in pairs(FuelType) do
        SendNUIMessage({
            type = "insertFuelTypes",
            label = label,
            key = key,
        })
    end

    if callback then
        callback("ok")
    end
end)

function GetBoundingBoxPolyMatrix(boundingBoxCorners)
    return {
        { boundingBoxCorners[3], boundingBoxCorners[2], boundingBoxCorners[1] },
        { boundingBoxCorners[4], boundingBoxCorners[3], boundingBoxCorners[1] },
        { boundingBoxCorners[5], boundingBoxCorners[6], boundingBoxCorners[7] },
        { boundingBoxCorners[5], boundingBoxCorners[7], boundingBoxCorners[8] },
        { boundingBoxCorners[3], boundingBoxCorners[4], boundingBoxCorners[7] },
        { boundingBoxCorners[8], boundingBoxCorners[7], boundingBoxCorners[4] },
        { boundingBoxCorners[1], boundingBoxCorners[2], boundingBoxCorners[5] },
        { boundingBoxCorners[6], boundingBoxCorners[5], boundingBoxCorners[2] },
        { boundingBoxCorners[2], boundingBoxCorners[3], boundingBoxCorners[6] },
        { boundingBoxCorners[3], boundingBoxCorners[7], boundingBoxCorners[6] },
        { boundingBoxCorners[5], boundingBoxCorners[8], boundingBoxCorners[4] },
        { boundingBoxCorners[5], boundingBoxCorners[4], boundingBoxCorners[1] },
    }
end

function GetBoundingBoxEdgeMatrix(boundingBoxCorners)
    return {
        { boundingBoxCorners[1], boundingBoxCorners[2] },
        { boundingBoxCorners[2], boundingBoxCorners[3] },
        { boundingBoxCorners[3], boundingBoxCorners[4] },
        { boundingBoxCorners[4], boundingBoxCorners[1] },
        { boundingBoxCorners[5], boundingBoxCorners[6] },
        { boundingBoxCorners[6], boundingBoxCorners[7] },
        { boundingBoxCorners[7], boundingBoxCorners[8] },
        { boundingBoxCorners[8], boundingBoxCorners[5] },
        { boundingBoxCorners[1], boundingBoxCorners[5] },
        { boundingBoxCorners[2], boundingBoxCorners[6] },
        { boundingBoxCorners[3], boundingBoxCorners[7] },
        { boundingBoxCorners[4], boundingBoxCorners[8] },
    }
end

function GetEntityBoundingBox(entity)
    local modelHash = GetEntityModel(entity)
    local minDimensions, maxDimensions = GetModelDimensions(modelHash)
    local padding = 0.001

    return {
        GetOffsetFromEntityInWorldCoords(entity, minDimensions.x - padding, minDimensions.y - padding, minDimensions.z - padding),
        GetOffsetFromEntityInWorldCoords(entity, maxDimensions.x + padding, minDimensions.y - padding, minDimensions.z - padding),
        GetOffsetFromEntityInWorldCoords(entity, maxDimensions.x + padding, maxDimensions.y + padding, minDimensions.z - padding),
        GetOffsetFromEntityInWorldCoords(entity, minDimensions.x - padding, maxDimensions.y + padding, minDimensions.z - padding),
        GetOffsetFromEntityInWorldCoords(entity, minDimensions.x - padding, minDimensions.y - padding, maxDimensions.z + padding),
        GetOffsetFromEntityInWorldCoords(entity, maxDimensions.x + padding, minDimensions.y - padding, maxDimensions.z + padding),
        GetOffsetFromEntityInWorldCoords(entity, maxDimensions.x + padding, maxDimensions.y + padding, maxDimensions.z + padding),
        GetOffsetFromEntityInWorldCoords(entity, minDimensions.x - padding, maxDimensions.y + padding, maxDimensions.z + padding),
    }
end

function DrawPolyMatrix(polygonMatrix, red, green, blue, alpha)
    for _, triangle in pairs(polygonMatrix) do
        DrawPoly(
            triangle[1].x,
            triangle[1].y,
            triangle[1].z,
            triangle[2].x,
            triangle[2].y,
            triangle[2].z,
            triangle[3].x,
            triangle[3].y,
            triangle[3].z,
            red,
            green,
            blue,
            alpha
        )
    end
end

function DrawEdgeMatrix(edgeMatrix)
    for _, edge in pairs(edgeMatrix) do
        DrawLine(
            edge[1].x,
            edge[1].y,
            edge[1].z,
            edge[2].x,
            edge[2].y,
            edge[2].z
        )
    end
end

function DrawBoundingBox(boundingBoxCorners, red, green, blue, alpha)
    DrawPolyMatrix(GetBoundingBoxPolyMatrix(boundingBoxCorners), red, green, blue, alpha)
    DrawEdgeMatrix(GetBoundingBoxEdgeMatrix(boundingBoxCorners), 255, 255, 255, 255)
end

function DrawEntityBoundingBox(entity, red, green, blue, alpha)
    DrawBoundingBox(GetEntityBoundingBox(entity), red, green, blue, alpha)
end
