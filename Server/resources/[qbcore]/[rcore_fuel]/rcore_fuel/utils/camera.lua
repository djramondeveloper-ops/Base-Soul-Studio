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

local arePlayerControlsFrozen = false

function CreateCamera(position, rotation)
    local camera = {
        cameraEntity = CreateCamWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            position.x,
            position.y,
            position.z,
            rotation.x,
            rotation.y,
            rotation.z,
            GetGameplayCamFov(),
            false,
            0
        ),
        activeEffects = {},
        activeFxEffects = {},
        isPointing = false,
    }

    function camera.playCameraEffects(effects)
        for _, effect in pairs(effects) do
            camera.activeEffects[effect.type] = {
                effectName = effect.effectName,
                intensity = effect.intensity,
            }

            playEffectOnCamera(camera.cameraEntity, effect.type, camera.activeEffects[effect.type])
        end
    end

    function camera.playerCameraEffectsInDuration(effects, duration)
        for _, effect in pairs(effects) do
            camera.activeEffects[effect.type] = effect
        end

        CreateThread(function()
            local currentCoords = camera.getCameraCoords()
            local currentRotation = camera.getCameraRotation()
            local nextCamera = CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                currentCoords.x,
                currentCoords.y,
                currentCoords.z,
                currentRotation.x,
                currentRotation.y,
                currentRotation.z,
                camera.getCameraFov(),
                false,
                0
            )

            SetCamActiveWithInterp(nextCamera, camera.cameraEntity, duration, 1, 1)

            for effectType, effectData in pairs(camera.activeEffects) do
                playEffectOnCamera(nextCamera, effectType, effectData)
            end

            Wait(duration)
            SetCamActive(camera.cameraEntity, false)
            DestroyCam(camera.cameraEntity)
            camera.cameraEntity = nextCamera
            camera.startRendering()
        end, "playerCameraEffectsInDuration")
    end

    function camera.stopCameraEffects(effectType, duration)
        for activeEffectType in pairs(camera.activeEffects) do
            if activeEffectType == effectType then
                camera.activeEffects[activeEffectType] = nil
            end
        end

        CreateThread(function()
            local currentCoords = camera.getCameraCoords()
            local currentRotation = camera.getCameraRotation()
            local nextCamera = CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                currentCoords.x,
                currentCoords.y,
                currentCoords.z,
                currentRotation.x,
                currentRotation.y,
                currentRotation.z,
                camera.getCameraFov(),
                false,
                0
            )

            for activeEffectType, effectData in pairs(camera.activeEffects) do
                playEffectOnCamera(nextCamera, activeEffectType, effectData)
            end

            SetCamActiveWithInterp(nextCamera, camera.cameraEntity, duration, true, true)
            Wait(duration)
            SetCamActive(camera.cameraEntity, false)
            DestroyCam(camera.cameraEntity)
            camera.cameraEntity = nextCamera
            camera.startRendering()
        end, "stopCameraEffects")
    end

    function camera.ActiveFXEffect(effectName, duration, looped)
        camera.activeFxEffects[effectName] = {
            duration = duration,
            looped = looped,
            effectName = effectName,
        }

        if IsCamActive(camera.cameraEntity) then
            AnimpostfxPlay(effectName, duration, looped)
        end
    end

    function camera.StopFXeffect(effectName)
        camera.activeFxEffects[effectName] = nil
        AnimpostfxStop(effectName)
    end

    function camera.StopAllFXEffects()
        for effectName in pairs(camera.activeFxEffects) do
            AnimpostfxStop(effectName)
        end

        camera.activeFxEffects = {}
    end

    function camera.GetAllActiveFXEffects()
        return camera.activeFxEffects
    end

    function camera.setMotionBlurStrength(intensity)
        camera.playCameraEffects({
            {
                type = CameraEffect.BLUR,
                intensity = intensity,
            },
        })
    end

    function camera.getMotionBlurStrength()
        local blurEffect = camera.activeEffects[CameraEffect.BLUR]
        return blurEffect and blurEffect.intensity or 0.0
    end

    function camera.lerpMortionBlurStrength(intensity, duration)
        camera.playerCameraEffectsInDuration({
            {
                type = CameraEffect.BLUR,
                intensity = intensity,
            },
        }, duration)
    end

    function camera.exitCameraSmoothly(duration)
        if not IsCamActive(camera.cameraEntity) then
            return
        end

        duration = duration or 3000

        local playerPed = PlayerPedId()
        FreezeEntityPosition(playerPed, true)
        FreezePlayerControls(true)
        Wait(200)

        camera.moveCameraSmoothlyToCoords(
            GetGameplayCamCoord(),
            GetGameplayCamRot(),
            duration,
            { fov = GetGameplayCamFov() }
        )

        FreezeEntityPosition(playerPed, false)
        FreezePlayerControls(false)
        camera.stopRendering()
        camera.disposeCamera()
    end

    function camera.getShakeCameraIntensity()
        local shakeEffect = camera.activeEffects[CameraEffect.SHAKE_CAMERA]
        return shakeEffect and shakeEffect.intensity or 0.0
    end

    function camera.shakeCamera(effectName, intensity)
        camera.playCameraEffects({
            {
                type = CameraEffect.SHAKE_CAMERA,
                effectName = effectName,
                intensity = intensity,
            },
        })
    end

    function camera.lerpShakeCamera(effectName, intensity, duration)
        camera.playerCameraEffectsInDuration({
            {
                type = CameraEffect.SHAKE_CAMERA,
                effectName = effectName,
                intensity = intensity,
            },
        }, duration)
    end

    function camera.stopShakeCamera(duration)
        camera.stopCameraEffects(CameraEffect.SHAKE_CAMERA, duration)
    end

    function camera.moveCameraSmoothlyToCoords(targetPosition, targetRotation, duration, options, skipWait)
        if not IsCamActive(camera.cameraEntity) then
            return
        end

        options = options or {
            fov = camera.getCameraFov(),
            copyEffects = false,
            offsetDuration = 0,
        }

        camera.stopFocusing()

        local nextCamera = CreateCamWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            targetPosition.x,
            targetPosition.y,
            targetPosition.z,
            targetRotation.x,
            targetRotation.y,
            targetRotation.z,
            options.fov or camera.getCameraFov(),
            false,
            0
        )

        if options.copyEffects then
            for effectType, effectData in pairs(camera.activeEffects) do
                playEffectOnCamera(nextCamera, effectType, effectData)
            end
        end

        SetCamActiveWithInterp(nextCamera, camera.cameraEntity, duration, true, true)

        if not skipWait then
            Wait(duration - (options.offsetDuration or 0))
        end

        if options.text then
            ShowSubtitle(options.text)
        end

        if options.sleep then
            Wait(options.sleep)
        end

        if options.cb then
            options.cb()
        end

        SetCamActive(camera.cameraEntity, false)
        DestroyCam(camera.cameraEntity)
        camera.cameraEntity = nextCamera
        camera.startRendering()
    end

    function camera.moveCameraSmoothlyFromPoints(points, waitOnFirstPoint)
        for _, point in pairs(points) do
            camera.moveCameraSmoothlyToCoords(
                point.pos,
                point.rot,
                point.duration,
                point.options,
                waitOnFirstPoint
            )
            waitOnFirstPoint = false
        end
    end

    function camera.focusCameraOnCoords(targetCoords)
        PointCamAtCoord(camera.cameraEntity, targetCoords.x, targetCoords.y, targetCoords.z)
        camera.isPointing = true
    end

    function camera.focusCameraOnEntity(entity, offset)
        offset = offset or vector3(0, 0, 0)
        PointCamAtEntity(camera.cameraEntity, entity, offset.x, offset.y, offset.z, 1)
        camera.isPointing = true
    end

    function camera.focusCameraOnPedBone(ped, boneIndex, offset)
        PointCamAtPedBone(camera.cameraEntity, ped, boneIndex, offset.x, offset.y, offset.z, 1)
        camera.isPointing = true
    end

    function camera.stopFocusing()
        StopCamPointing(camera.cameraEntity)
        camera.isPointing = false
    end

    function camera.isCameraFocusing()
        return camera.isPointing
    end

    function camera.setCameraRotation(rotation)
        SetCamRot(camera.cameraEntity, rotation.x, rotation.y, rotation.z, 2)
    end

    function camera.getCameraRotation()
        return GetCamRot(camera.cameraEntity, 2)
    end

    function camera.setCameraCoords(coords)
        SetCamCoord(camera.cameraEntity, coords.x, coords.y, coords.z)
    end

    function camera.getCameraCoords()
        return GetCamCoord(camera.cameraEntity)
    end

    function camera.setCameraFov(fov)
        SetCamFov(camera.cameraEntity, fov)
    end

    function camera.lerpCameraFov(targetFov, duration)
        camera.moveCameraSmoothlyToCoords(
            camera.getCameraCoords(),
            camera.getCameraRotation(),
            duration,
            {
                fov = targetFov,
                copyEffects = true,
            }
        )
    end

    function camera.getCameraFov()
        return GetCamFov(camera.cameraEntity)
    end

    function camera.startRendering()
        SetCamActive(camera.cameraEntity, true)
        RenderScriptCams(true, true, 1, true, true)

        for effectName, effectData in pairs(camera.activeFxEffects) do
            AnimpostfxStop(effectName)
            AnimpostfxPlay(effectData.effectName, effectData.duration, effectData.looped)
        end
    end

    function camera.stopRendering()
        SetCamActive(camera.cameraEntity, false)
        RenderScriptCams(false, false, 1, false, false)

        for effectName in pairs(camera.activeFxEffects) do
            AnimpostfxStop(effectName)
        end
    end

    function camera.disposeCamera()
        if IsCamActive(camera.cameraEntity) then
            RenderScriptCams(false, false, 1, false, false)
        end

        SetCamActive(camera.cameraEntity, false)
        DestroyCam(camera.cameraEntity)
    end

    function camera.getCameraEntity()
        return camera.cameraEntity
    end

    return camera
end

function FreezePlayerControls(freezeControls)
    arePlayerControlsFrozen = freezeControls
end

function playEffectOnCamera(cameraEntity, effectType, effectData)
    if effectType == CameraEffect.SHAKE_CAMERA then
        ShakeCam(cameraEntity, effectData.effectName, effectData.intensity)
    end

    if effectType == CameraEffect.BLUR then
        SetCamMotionBlurStrength(cameraEntity, effectData.intensity)
    end
end

CreateThread(function()
    while true do
        Wait(0)

        if not arePlayerControlsFrozen then
            Wait(1000)
        else
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
        end
    end
end, "disabling controls during freezePlayerControls variable")
