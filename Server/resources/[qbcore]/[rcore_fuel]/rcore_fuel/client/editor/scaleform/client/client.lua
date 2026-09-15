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

if not Config.ScaleformEditor then
    return
end

xPosEdit = 0.0
yPosEdit = 0.0
zPosEdit = 0.0
xScale = 0.0
yScale = 0.0
zScale = 0.0
xRot = 0.0
yRot = 0.0
zRot = 0.0

local selectedEntity = 0
local editSpeed = 0.0005
local editMode = 0
local editorPhase = 0
local editModeLabel = ""
local hasRaycastHit = false

local ScaleformEditMode = {
    POS = 0,
    SCALE = 1,
    ROT = 2,
}

local ScaleformEditorPhase = {
    SELECT_OBJECT = 0,
    RENDER_TELEVISION = 1,
}

CreateThread(function()
    if not Config.ScaleformEditor then
        return
    end

    while true do
        Wait(0)

        if editorPhase == ScaleformEditorPhase.SELECT_OBJECT then
            local _hitCoords, hitType, _surfaceNormal, _entityHit, hitEntity = CastRayCastFromPlayer(
                PlayerPedId(),
                4294967295,
                10.0
            )

            hasRaycastHit = hitType == 1

            if hitType == 1 and GetEntityType(hitEntity) ~= 0 then
                DrawBoundingBox(GetEntityBoundingBox(hitEntity), 125, 125, 255, 125)
                selectedEntity = hitEntity
            end

            showEditorSubtitle("Select object with raycast then left click mouse to confirm the object")
        end

        if editorPhase == ScaleformEditorPhase.RENDER_TELEVISION then
            if IsControlJustReleased(1, 21) then
                editMode = editMode + 1

                if editMode == 2 then
                    editMode = 0
                end

                if editMode == ScaleformEditMode.POS then
                    ShowHelpNotification(
                        "~INPUT_SPRINT~ will change size/position\n"
                            .. "~INPUT_PHONE~ ~INPUT_CELLPHONE_DOWN~ up/down speed change\n"
                            .. "~INPUT_VEH_SUB_PITCH_UD~ up/down\n"
                            .. "~INPUT_VEH_SUB_TURN_LEFT_ONLY~ ~INPUT_VEH_SUB_TURN_RIGHT_ONLY~ left/right\n"
                            .. "~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ backwards/forward",
                        false,
                        false,
                        9000000
                    )
                elseif editMode == ScaleformEditMode.SCALE then
                    ShowHelpNotification(
                        "~INPUT_SPRINT~ will change size/position\n"
                            .. "~INPUT_PHONE~ ~INPUT_CELLPHONE_DOWN~ up/down speed change\n"
                            .. "~INPUT_VEH_SUB_PITCH_UD~ up/down\n"
                            .. "~INPUT_VEH_SUB_TURN_LEFT_ONLY~ ~INPUT_VEH_SUB_TURN_RIGHT_ONLY~ left/right\n",
                        false,
                        false,
                        9000000
                    )
                end
            end

            if IsControlPressed(1, 27) then
                editSpeed = editSpeed + 0.000005
            end

            if IsControlPressed(1, 173) then
                editSpeed = editSpeed - 0.000005

                if editSpeed <= 0.0 then
                    editSpeed = 0.000005
                end
            end

            if IsControlPressed(1, 127) then
                if editMode == ScaleformEditMode.POS then
                    zPosEdit = zPosEdit + editSpeed
                elseif editMode == ScaleformEditMode.SCALE then
                    yScale = yScale + editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    zRot = zRot + editSpeed
                end
            end

            if IsControlPressed(1, 126) then
                if editMode == ScaleformEditMode.POS then
                    zPosEdit = zPosEdit - editSpeed
                elseif editMode == ScaleformEditMode.SCALE then
                    yScale = yScale - editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    zRot = zRot - editSpeed
                end
            end

            if IsControlPressed(1, 124) then
                if editMode == ScaleformEditMode.POS then
                    xPosEdit = xPosEdit - editSpeed
                elseif editMode == ScaleformEditMode.SCALE then
                    xScale = xScale + editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    xRot = xRot - editSpeed
                end
            end

            if IsControlPressed(1, 125) then
                if editMode == ScaleformEditMode.POS then
                    xPosEdit = xPosEdit + editSpeed
                elseif editMode == ScaleformEditMode.SCALE then
                    xScale = xScale - editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    xRot = xRot + editSpeed
                end
            end

            if IsControlPressed(0, 117) then
                if editMode == ScaleformEditMode.POS then
                    yPosEdit = yPosEdit - editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    yRot = yRot - editSpeed
                end
            end

            if IsControlPressed(0, 118) then
                if editMode == ScaleformEditMode.POS then
                    yPosEdit = yPosEdit + editSpeed
                elseif editMode == ScaleformEditMode.ROT then
                    yRot = yRot + editSpeed
                end
            end

            if editMode == ScaleformEditMode.POS then
                editModeLabel = "positon"
            elseif editMode == ScaleformEditMode.SCALE then
                editModeLabel = "scale"
            elseif editMode == ScaleformEditMode.ROT then
                editModeLabel = "rotation"
            end

            showEditorSubtitle(
                "Left click on mouse to save! Atm you're changing: "
                    .. editModeLabel
                    .. ", edit speed: "
                    .. editSpeed
            )
        end

        ::continue::
    end
end, "Editor for scaleform")

RegisterCommand("scaleformeditor", function()
    xPosEdit = 0.0
    yPosEdit = 0.0
    zPosEdit = 0.0
    xScale = 0.0
    yScale = 0.0
    zScale = 0.0
    xRot = 0.0
    yRot = 0.0
    zRot = 0.0
    selectedEntity = 0
    editSpeed = 0.0005
    editMode = 0
    editorPhase = 0
    editModeLabel = ""
    print("variables restarted")
end)

RegisterKey(function()
    if not Config.ScaleformEditor then
        return
    end

    -- FIX 2: same gap as the station/vehicle editors -- Config.ScaleformEditor
    -- is a server-wide flag, not a per-player permission, so add the same
    -- IsPlayerInGroup check every other editor command in this resource uses
    if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
        return
    end

    ClearPedTasksImmediately(PlayerPedId())

    if editorPhase == ScaleformEditorPhase.RENDER_TELEVISION then
        GetOffsetFromEntityInWorldCoords(selectedEntity, xPosEdit, yPosEdit, zPosEdit)
        local _scaleformMeta, baseScreenSize = GetScaleformMetaData(
            GetEntityModel(selectedEntity),
            selectedEntity,
            "R"
        )
        baseScreenSize = baseScreenSize - vector3(xScale, yScale, zScale)

        local scaleformConfig = {
            Job = "nil",
            ItemToOpen = "nil",
            ScreenOffSet = vector3(xPosEdit, yPosEdit, zPosEdit),
            ScreenSize = vector3(xScale, yScale, zScale),
            distanceToOpen = Config.DefaultOpenDistance,
            distance = Config.visibleDistance,
            CameraOffSet = {
                x = 0.0,
                y = -3.0,
                z = 0.35,
                rotationOffset = vector3(0, 0, 0),
            },
        }

        local dumpedConfig = Dump(scaleformConfig, true)

        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "display_for_copy",
            text = "[" .. GetEntityModel(selectedEntity) .. "] = " .. dumpedConfig .. ",",
        })
        ExecuteCommand("scaleformeditor")
        return
    end

    if editorPhase == ScaleformEditorPhase.SELECT_OBJECT and hasRaycastHit then
        editorPhase = ScaleformEditorPhase.RENDER_TELEVISION

        if not Config.resolution[GetEntityModel(selectedEntity)] then
            Config.resolution[GetEntityModel(selectedEntity)] = {
                fake = true,
            }
        end

        DestroyDuiAndScaleform()

        local pumpSquareOffset, pumpSquareOffsetAlt = GetOffsetsForUIFlipForDispenserPump(selectedEntity)

        CreateVirtualScaleform("editor", {
            ModelHash = GetEntityModel(selectedEntity),
            entity = selectedEntity,
            entityHit = selectedEntity,
            URL = "nui://rcore_fuel/html/FuelPump/index.html",
            align = AlignTypes.RIGHT,
        }, {
            fuelData = { 1, 2 },
            identifier = "editor",
            FuelPump = true,
            FuelPumpSquares = {
                { GetOffsetFromEntityInWorldCoords(selectedEntity, pumpSquareOffsetAlt) },
                { GetOffsetFromEntityInWorldCoords(selectedEntity, pumpSquareOffset) },
            },
        }, GetEntityCoords(selectedEntity))

        ShowHelpNotification(
            "~INPUT_SPRINT~ will change size/position\n"
                .. "~INPUT_PHONE~ ~INPUT_CELLPHONE_DOWN~ up/down speed change\n"
                .. "~INPUT_VEH_SUB_PITCH_UD~ up/down\n"
                .. "~INPUT_VEH_SUB_TURN_LEFT_ONLY~ ~INPUT_VEH_SUB_TURN_RIGHT_ONLY~ left/right\n"
                .. "~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ backwards/forward",
            false,
            false,
            9000000
        )
    end
end, "television_mouse_click", "Mouse left", "MOUSE_LEFT", "MOUSE_BUTTON")

function showEditorSubtitle(text)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(1000, 1)
end

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
