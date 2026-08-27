-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-props.lua
--  Engineered by Eazy Fxap
--  Original: 615 lines → Cleaned: 130 lines
-- =====================================================

ObjectPlacer = {
    IsPlacing = false,
    PROP_PLACE_FAIL_GROUND = "ground",
    PROP_PLACE_FAIL_OTHER = "other"
}

local activePlacement = false

local function RotationToDirection(rotation)
    local rot = {
        x = math.rad(rotation.x),
        y = math.rad(rotation.y),
        z = math.rad(rotation.z)
    }
    return {
        x = -math.sin(rot.z) * math.abs(math.cos(rot.x)),
        y = math.cos(rot.z) * math.abs(math.cos(rot.x)),
        z = math.sin(rot.x)
    }
end

local function GetCoordsFromCam(distance)
    local rot = GetGameplayCamRot(2)
    local dir = RotationToDirection(rot)
    local camCoords = GetGameplayCamCoord()
    
    return vector3(
        camCoords.x + dir.x * distance,
        camCoords.y + dir.y * distance,
        camCoords.z + dir.z * distance
    )
end

local function HandleRotationInput(currentRot)
    BlockWeaponWheelThisFrame()
    DisableControlAction(0, 36, true)
    DisableControlAction(0, 14, true)
    DisableControlAction(0, 15, true)
    
    if IsDisabledControlJustPressed(0, 14) then
        return (currentRot - 5) % 360
    end
    
    if IsDisabledControlJustPressed(0, 15) then
        return (currentRot + 5) % 360
    end
    
    return currentRot
end

function ObjectPlacer.startPlace(model, cbSuccess, cbCancel, cbFail, checkZ, zOffset, opts)
    if activePlacement then return end
    activePlacement = true
    ObjectPlacer.IsPlacing = true
    
    UtilsService.LoadModel(model)
    local ped = PlayerPedId()
    local spawnCoords = GetEntityCoords(ped)
    local obj = UtilsService.SpawnObject(model, spawnCoords, false, false)
    
    local heading = (GetEntityHeading(ped) - 90) % 360
    SetEntityHeading(obj, heading)
    
    local dimensions = GetModelDimensions(model)
    local zDim = math.abs(dimensions.z)
    
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, false, false)
    SetEntityDrawOutline(obj, true)
    
    if Config.Props.PlaceEditorOutlineColor then
        SetEntityDrawOutlineColor(
            Config.Props.PlaceEditorOutlineColor.r,
            Config.Props.PlaceEditorOutlineColor.g,
            Config.Props.PlaceEditorOutlineColor.b,
            Config.Props.PlaceEditorOutlineColor.a
        )
    end
    
    SetCurrentPedWeapon(ped, -1569615261, true)
    PlaceObjectOnGroundProperly(obj)
    
    local isSpeedCam = (model == "rds_speed_camera")
    local helpKeys = {}
    for _, k in ipairs(Config.Props.HelpKeys) do
        table.insert(helpKeys, k)
    end
    table.insert(helpKeys, { label = "", key = "" })
    UI.HelpKeys({ keys = helpKeys }, true)
    
    local maxDist = Config.Props.PlaceEditorDistance
    local notPlacable = false
    local placable = false
    
    while activePlacement do
        local camCoords = GetGameplayCamCoord()
        local objCoords = GetEntityCoords(obj)
        local forwardVec = GetEntityForwardVector(obj)
        local targetCoords = GetCoordsFromCam(1000000.0)
        
        local ray1 = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 4294967295, ped, 4)
        local _, hit1, endCoords1, _, _ = GetShapeTestResult(ray1)
        
        local ray2 = StartShapeTestRay(objCoords.x, objCoords.y, objCoords.z, objCoords.x, objCoords.y, objCoords.z - 10, 1, obj, 4)
        local _, hit2, endCoords2, _, _ = GetShapeTestResult(ray2)
        
        local distToFloor = #(objCoords - endCoords2)
        local pedCoords = GetEntityCoords(ped)
        local distToPed = #(pedCoords - endCoords1)
        
        if maxDist < distToPed then
            if not notPlacable then
                helpKeys[#helpKeys].label = _U("PROP_EDITOR.PROP_FAR_AWAY_BLOCKED")
                notPlacable = true
                placable = false
                UI.HelpKeys({ keys = helpKeys }, true)
            end
            local oc = Config.Props.PlaceEditorOutlineNotPlacableColor
            SetEntityDrawOutlineColor(oc.r, oc.g, oc.b, oc.a)
        else
            if not placable then
                helpKeys[#helpKeys].label = _U("PROP_EDITOR.CAN_PLACE_PROP")
                placable = true
                notPlacable = false
                UI.HelpKeys({ keys = helpKeys }, true)
            end
            local oc = Config.Props.PlaceEditorOutlineColor
            SetEntityDrawOutlineColor(oc.r, oc.g, oc.b, oc.a)
        end
        
        if Config.Props.AllowDrawLineDirectionHelper and isSpeedCam then
            local distCheck = Config.Props.SpeedCamera.CheckDistance
            local lineEnd = vector3(
                objCoords.x + forwardVec.x * distCheck,
                objCoords.y + forwardVec.y * distCheck,
                objCoords.z + forwardVec.z * distCheck
            )
            DrawLine(objCoords.x, objCoords.y, objCoords.z + 0.5, lineEnd.x, lineEnd.y, lineEnd.z + 0.5, 0, 255, 0, 255)
        end
        
        SetEntityCoords(obj, endCoords1.x, endCoords1.y, endCoords1.z + math.abs(zDim))
        SetEntityHeading(obj, heading)
        
        DisableControlAction(0, 38, true)
        if IsDisabledControlJustPressed(0, 38) then
            local placeCoords = vector3(endCoords1.x, endCoords1.y, endCoords1.z + math.abs(zDim))
            local distFail = false
            
            if opts and opts.coords then
                if #(opts.coords - endCoords1) > opts.distance then
                    distFail = true
                end
            end
            
            if distFail or notPlacable then
                Framework.sendNotification(_U("PROP_EDITOR.PROP_FAR_AWAY_BLOCKED"), "error")
            else
                if not checkZ or (distToFloor < (zDim + 0.1)) then
                    local floorDist = #(objCoords - vector3(0,0,0))
                    if floorDist > 10.0 then
                        if cbSuccess then
                            UI.HelpKeys(nil, false)
                            SetEntityAlpha(obj, 0, false)
                            SetEntityDrawOutline(obj, false)
                            PlaceObjectOnGroundProperly(obj)
                            activePlacement = false
                            ObjectPlacer.IsPlacing = false
                            dbg.debug("ObjectPlacer: Success entity has validation location to be placed at!")
                            cbSuccess(placeCoords, obj, heading)
                        end
                        activePlacement = false
                    elseif distToFloor > 1.0 then
                        if cbFail then
                            activePlacement = false
                            ObjectPlacer.IsPlacing = false
                            dbg.debug("ObjectPlacer: Fail ground")
                            cbFail(ObjectPlacer.PROP_PLACE_FAIL_GROUND)
                        end
                    elseif cbFail then
                        activePlacement = false
                        ObjectPlacer.IsPlacing = false
                        dbg.debug("ObjectPlacer: Fail other")
                        cbFail(ObjectPlacer.PROP_PLACE_FAIL_OTHER)
                    end
                end
            end
        end
        
        DisableControlAction(0, 74, true)
        if IsDisabledControlJustPressed(0, 74) then
            ClearPedTasks(ped)
            activePlacement = false
            UI.HelpKeys(nil, false)
            if cbCancel then
                activePlacement = false
                ObjectPlacer.IsPlacing = false
                cbCancel()
            end
            SetEntityDrawOutline(obj, false)
            DeleteObject(obj)
        end
        
        if activePlacement then
            SetEntityAlpha(obj, 180, false)
            heading = HandleRotationInput(heading)
        end
        Wait(0)
    end
    
    ObjectPlacer.IsPlacing = false
    SetEntityDrawOutline(obj, false)
    UI.HelpKeys(nil, false)
    DeleteObject(obj)
    activePlacement = false
end

function ObjectPlacer.isPlacing()
    return ObjectPlacer.IsPlacing
end
