local cameraConfig = Config.Camera or {}
local vehicleCameraConfig = cameraConfig.Vehicle or {}
local selfieCameraConfig = cameraConfig.Selfie or {}
local freezeCameraConfig = cameraConfig.Freeze or {}

local normalMaxFov = cameraConfig.MaxFOV or 60.0
local normalMinFov = cameraConfig.MinFOV or 10.0
local normalMaxLookUp = cameraConfig.MaxLookUp or 80.0
local normalMaxLookDown = cameraConfig.MaxLookDown or -80.0
local allowRunning = cameraConfig.AllowRunning == true

local vehicleZoomEnabled = vehicleCameraConfig.Zoom == true
local vehicleMaxFov = vehicleCameraConfig.MaxFOV or 80.0
local vehicleMinFov = vehicleCameraConfig.MinFOV or 10.0
local vehicleMaxLookUp = vehicleCameraConfig.MaxLookUp or 50.0
local vehicleMaxLookDown = vehicleCameraConfig.MaxLookDown or -30.0
local vehicleMaxLeftRight = vehicleCameraConfig.MaxLeftRight or 120.0
local vehicleMinLeftRight = vehicleCameraConfig.MinLeftRight or -120.0

local selfieMaxFov = selfieCameraConfig.MaxFOV or 80.0
local selfieMinFov = selfieCameraConfig.MinFOV or 50.0
local freezeEnabled = freezeCameraConfig.Enabled == true
local freezeMaxDistance = freezeCameraConfig.MaxDistance or 10.0
local freezeMaxTime = (freezeCameraConfig.MaxTime or 60) * 1000

local selfieOffset = selfieCameraConfig.Offset or vector3(0.1, 0.55, 0.6)
local selfieRotation = selfieCameraConfig.Rotation or vector3(10.0, 0.0, -180.0)
local allowRoll = cameraConfig.Roll == true

local defaultCameraOffset = vector3(0.0, 0.5, 0.6)

local cameraPitch = 0.0
local cameraRoll = 0.0
local cameraFov = 60.0
local previousCamViewMode = 0
local vehicleHeadingOffset = 0.0

local isSelfieCamera = false
local isCameraFrozen = false
local freezeEndsAt = 0
local playerPed = PlayerPedId()
local radioControlsDisabled = false
local movementInputActive = false

local lookSensitivity = GetProfileSetting(754) + 10
local activeCamera = nil

local function updateWalkableCamera()
    local inVehicle = IsPedInAnyVehicle(playerPed, true)

    -- Track WASD movement while on foot.
    movementInputActive = not inVehicle and (
        IsDisabledControlPressed(0, 32) or
        IsDisabledControlPressed(0, 33) or
        IsDisabledControlPressed(0, 34) or
        IsDisabledControlPressed(0, 35)
    )

    HideHudAndRadarThisFrame()
    SetFollowPedCamViewMode(0)
    SetGameplayCamRelativeHeading(0.0)

    -- Disable default camera controls while the custom camera is active.
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 14, true)
    DisableControlAction(0, 15, true)
    DisableControlAction(0, 16, true)
    DisableControlAction(0, 17, true)
    DisableControlAction(0, 99, true)
    DisableControlAction(0, 100, true)
    DisableControlAction(0, 115, true)
    DisableControlAction(0, 116, true)
    DisableControlAction(0, 261, true)
    DisableControlAction(0, 262, true)

    SetPedResetFlag(playerPed, 47, true)

    if isCameraFrozen and not inVehicle then
        local playerCoords = GetEntityCoords(playerPed)
        local cameraCoords = GetCamCoord(activeCamera)
        local distance = #(playerCoords - cameraCoords)

        if distance > freezeMaxDistance or GetGameTimer() > freezeEndsAt then
            isCameraFrozen = false
            ToggleAnimations(true)
            DisplayCameraTip()
        end

        return
    end

    if not allowRunning then
        DisableControlAction(0, 21, true)
    end

    if isSelfieCamera and not inVehicle then
        AttachCamToPedBone_2(
            activeCamera,
            playerPed,
            0,
            selfieRotation.x,
            selfieRotation.y,
            selfieRotation.z,
            selfieOffset.x,
            selfieOffset.y,
            selfieOffset.z,
            true
        )
    elseif not isSelfieCamera and not inVehicle then
        local cameraCoords = GetOffsetFromEntityInWorldCoords(
            playerPed,
            defaultCameraOffset.x,
            defaultCameraOffset.y,
            defaultCameraOffset.z
        )

        local headCoords = GetPedBoneCoords(playerPed, 31086, 0.0, 0.0, 0.0)
        local cameraZ = cameraCoords.z

        if math.abs(headCoords.z - cameraCoords.z) > 0.2 then
            cameraZ = headCoords.z
        end

        DetachCam(activeCamera)
        SetCamCoord(activeCamera, cameraCoords.x, cameraCoords.y, cameraZ)
        SetCamRot(activeCamera, cameraPitch, cameraRoll, GetEntityHeading(playerPed), 2)
    elseif isSelfieCamera and inVehicle then
        AttachCamToPedBone_2(
            activeCamera,
            playerPed,
            0,
            80.0,
            0.0,
            -180.0,
            0.0,
            0.2,
            0.5,
            true
        )
    elseif not isSelfieCamera and inVehicle then
        SetEntityLocallyInvisible(GetTabletObject())
        SetEntityLocallyInvisible(playerPed)

        AttachCamToPedBone_2(
            activeCamera,
            playerPed,
            GetPedBoneIndex(playerPed, 11816),
            cameraPitch,
            0.0,
            vehicleHeadingOffset,
            0.0,
            0.0,
            0.55,
            true
        )
    end

    if inVehicle then
        if not radioControlsDisabled then
            radioControlsDisabled = true
            SetUserRadioControlEnabled(false)
        end
    else
        if radioControlsDisabled then
            radioControlsDisabled = false
            SetUserRadioControlEnabled(true)
        end

        vehicleHeadingOffset = 0.0
    end

    if movementInputActive then
        SetPedResetFlag(playerPed, 69, true)
    elseif not isSelfieCamera and not inVehicle then
        DisableControlAction(0, 30, true)
    end

    if IsNuiFocused() then
        return
    end

    lookSensitivity = ((GetProfileSetting(754) + 10) * (cameraFov / normalMaxFov)) / 5

    local horizontalInput = GetDisabledControlNormal(0, 1)
    if inVehicle then
        vehicleHeadingOffset = clamp(
            vehicleHeadingOffset - (horizontalInput * lookSensitivity),
            vehicleMinLeftRight,
            vehicleMaxLeftRight
        )
    elseif horizontalInput ~= 0.0 then
        SetEntityHeading(
            playerPed,
            GetEntityHeading(playerPed) - (horizontalInput * lookSensitivity)
        )
    end

    local maxFov = normalMaxFov
    local minFov = normalMinFov

    if isSelfieCamera then
        maxFov = selfieMaxFov
        minFov = selfieMinFov
    elseif inVehicle then
        maxFov = vehicleMaxFov
        minFov = vehicleZoomEnabled and vehicleMinFov or vehicleMaxFov
    end

    if IsDisabledControlPressed(0, 180) then
        cameraFov = cameraFov + 5
    elseif IsDisabledControlPressed(0, 181) then
        cameraFov = cameraFov - 5
    end

    cameraFov = clamp(cameraFov, minFov, maxFov)

    local currentFov = GetCamFov(activeCamera)
    if math.abs(currentFov - cameraFov) > 0.1 then
        SetCamFov(activeCamera, currentFov + ((cameraFov - currentFov) / 25))
    end

    if isSelfieCamera then
        return
    end

    local verticalInput = GetDisabledControlNormal(0, 2)
    if verticalInput ~= 0.0 then
        local nextPitch = cameraPitch - (verticalInput * lookSensitivity)

        if inVehicle then
            cameraPitch = clamp(nextPitch, vehicleMaxLookDown, vehicleMaxLookUp)
        else
            cameraPitch = clamp(nextPitch, normalMaxLookDown, normalMaxLookUp)
        end
    end
end

local function updateFrozenCameraHeading()
    local horizontalInput = GetDisabledControlNormal(0, 1)
    if horizontalInput ~= 0.0 then
        SetEntityHeading(
            playerPed,
            GetEntityHeading(playerPed) - (horizontalInput * lookSensitivity)
        )
    end
end

function EnableWalkableCam(enableSelfie)
    if activeCamera then
        debugprint("EnableWalkableCam called while it's already enabled")
        return
    end

    isSelfieCamera = enableSelfie == true
    movementInputActive = false
    cameraFov = 60.0
    playerPed = PlayerPedId()
    previousCamViewMode = GetFollowPedCamViewMode()
    cameraPitch = 0.0
    vehicleHeadingOffset = 0.0
    cameraRoll = 0.0
    isCameraFrozen = false

    activeCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    lookSensitivity = GetProfileSetting(754) + 10

    CreateThread(function()
        while activeCamera do
            Wait(0)

            if movementInputActive or (isCameraFrozen and not IsNuiFocused()) then
                updateFrozenCameraHeading()
            end
        end
    end)

    CreateThread(function()
        while activeCamera do
            Wait(0)
            updateWalkableCamera()
        end

        if radioControlsDisabled then
            radioControlsDisabled = false
            SetUserRadioControlEnabled(true)
        end
    end)

    SetCamFov(activeCamera, cameraFov)
    RenderScriptCams(true, false, 0, true, true)
    SetCamActive(activeCamera, true)
end

function DisableWalkableCam()
    if activeCamera then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(activeCamera, false)
        SetFollowPedCamViewMode(previousCamViewMode)
        activeCamera = nil
    end
end

function IsWalkingCamEnabled()
    return activeCamera ~= nil
end

function IsSelfieCam()
    return isSelfieCamera
end

function IsCameraFrozen()
    return isCameraFrozen
end

function ToggleSelfieCam(enableSelfie)
    isSelfieCamera = enableSelfie == true
    cameraRoll = 0.0
end

AddEventHandler("lb-tablet:keyPressed", function(action)
    if not activeCamera then
        return
    end

    if action == "TakePhoto" then
        SendReactMessage("camera:usedCommand", "takePhoto")
    elseif action == "ToggleFlash" then
        SendReactMessage("camera:usedCommand", "toggleFlash")
    elseif action == "LeftMode" then
        SendReactMessage("camera:usedCommand", "leftMode")
    elseif action == "RightMode" then
        SendReactMessage("camera:usedCommand", "rightMode")
    elseif action == "FlipCamera" then
        SendReactMessage("camera:usedCommand", "toggleFlip")
    elseif action == "FreezeCamera" then
        if not freezeEnabled or isSelfieCamera then
            return
        end

        isCameraFrozen = not isCameraFrozen
        DisplayCameraTip()

        if isCameraFrozen then
            freezeEndsAt = GetGameTimer() + freezeMaxTime
            ToggleAnimations(false)
        end
    elseif action == "RollLeft" or action == "RollRight" then
        if not allowRoll then
            return
        end

        local rollStep = action == "RollLeft" and -0.5 or 0.5
        local bindData = Config.KeyBinds[action].bindData

        while bindData.pressed do
            Wait(0)
            cameraRoll = cameraRoll + rollStep
        end
    end
end)