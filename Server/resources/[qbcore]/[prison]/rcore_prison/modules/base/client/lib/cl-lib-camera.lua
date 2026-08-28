local controlsFrozen = false
local prologSkipped = false

function CreateCameraLib(startCoords, startRotation)
    local camera = {
        cameraEntity = CreateCamWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            startCoords.x, startCoords.y, startCoords.z,
            startRotation.x, startRotation.y, startRotation.z,
            GetGameplayCamFov(),
            false,
            0
        ),
        activeEffects = {},
        activeFxEffects = {},
        isPointing = false,
        canSkip = false,
        skipped = false
    }

    function camera.skippable()
        camera.canSkip = not camera.canSkip
        dbg.debug("Camera is skippable: %s", camera.canSkip)

        if not camera.canSkip then
            return
        end

        CreateThread(function()
            while camera.canSkip do
                if IsDisabledControlJustReleased(0, 38) then
                    dbg.debug("Camera has been skipped")

                    camera.skipped = true
                    camera.canSkip = false

                    camera.StopAllFXEffects()
                    Subtitles.Hide()
                    HelpKeys.Hide()

                    SetTimeout(1000, function()
                        DisplayRadar(true)
                        NetworkEndTutorialSession()
                        Subtitles.Hide()
                        HelpKeys.Hide()
                    end)

                    camera.exitCameraSmoothly(0)
                    break
                end

                Citizen.Wait(0)
            end
        end, "cl-lib-camera code name: Phoenix")
    end

    function camera.playCameraEffects(effects)
        for _, effectData in pairs(effects) do
            local effect = {
                effectName = effectData.effectName,
                intensity = effectData.intensity
            }

            camera.activeEffects[effectData.type] = effect
            playEffectOnCamera(camera.cameraEntity, effectData.type, effect)
        end
    end

    function camera.playerCameraEffectsInDuration(effects, duration)
        for _, effectData in pairs(effects) do
            camera.activeEffects[effectData.type] = effectData
        end

        CreateThread(function()
            local currentCoords = camera.getCameraCoords()
            local currentRotation = camera.getCameraRotation()

            local nextCamera = CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                currentCoords.x, currentCoords.y, currentCoords.z,
                currentRotation.x, currentRotation.y, currentRotation.z,
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
        end, "cl-lib-camera code name: Omega")
    end

    function camera.stopCameraEffects(effectType, duration)
        for activeType in pairs(camera.activeEffects) do
            if activeType == effectType then
                camera.activeEffects[activeType] = nil
            end
        end

        CreateThread(function()
            local currentCoords = camera.getCameraCoords()
            local currentRotation = camera.getCameraRotation()

            local nextCamera = CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                currentCoords.x, currentCoords.y, currentCoords.z,
                currentRotation.x, currentRotation.y, currentRotation.z,
                camera.getCameraFov(),
                false,
                0
            )

            for activeType, effectData in pairs(camera.activeEffects) do
                playEffectOnCamera(nextCamera, activeType, effectData)
            end

            SetCamActiveWithInterp(nextCamera, camera.cameraEntity, duration, true, true)
            Wait(duration)

            SetCamActive(camera.cameraEntity, false)
            DestroyCam(camera.cameraEntity)

            camera.cameraEntity = nextCamera
            camera.startRendering()
        end, "cl-lib-camera code name: Beta")
    end

    function camera.ActiveFXEffect(effectName, duration, looped)
        camera.activeFxEffects[effectName] = {
            duration = duration,
            looped = looped,
            effectName = effectName
        }

        if not IsCamActive(camera.cameraEntity) then
            return
        end

        AnimpostfxPlay(effectName, duration, looped)
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
                intensity = intensity
            }
        })
    end

    function camera.getMotionBlurStrength()
        local blurEffect = camera.activeEffects[CameraEffect.BLUR]
        if blurEffect then
            return blurEffect.intensity
        end

        return 0.0
    end

    function camera.lerpMortionBlurStrength(intensity, duration)
        camera.playerCameraEffectsInDuration({
            {
                type = CameraEffect.BLUR,
                intensity = intensity
            }
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
            {
                fov = GetGameplayCamFov()
            }
        )

        FreezeEntityPosition(playerPed, false)
        FreezePlayerControls(false)

        camera.cameraEntity = nil
        camera.stopRendering()
    end

    function camera.getShakeCameraIntensity()
        local shakeEffect = camera.activeEffects[CameraEffect.SHAKE_CAMERA]
        if shakeEffect then
            return shakeEffect.intensity
        end

        return 0.0
    end

    function camera.shakeCamera(effectName, intensity)
        camera.playCameraEffects({
            {
                type = CameraEffect.SHAKE_CAMERA,
                effectName = effectName,
                intensity = intensity
            }
        })
    end

    function camera.lerpShakeCamera(effectName, intensity, duration)
        camera.playerCameraEffectsInDuration({
            {
                type = CameraEffect.SHAKE_CAMERA,
                effectName = effectName,
                intensity = intensity
            }
        }, duration)
    end

    function camera.stopShakeCamera(duration)
        camera.stopCameraEffects(CameraEffect.SHAKE_CAMERA, duration)
    end

    function camera.moveCameraSmoothlyToCoords(
        targetCoords,
        targetRotation,
        duration,
        options,
        subtitleText,
        textTimeout,
        textRenderTime,
        model,
        pointIndex
    )
        if not IsCamActive(camera.cameraEntity) then
            return
        end

        options = options or {
            fov = camera.getCameraFov(),
            copyEffects = false,
            offsetDuration = 0
        }

        if camera.skipped then
            return
        end

        camera.stopFocusing()

        local nextCamera = CreateCamWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            targetCoords.x, targetCoords.y, targetCoords.z,
            targetRotation.x, targetRotation.y, targetRotation.z,
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

        SetTimeout(textTimeout or 0, function()
            if not subtitleText then
                return
            end

            Subtitles.Show(subtitleText)
        end)

        if camera.skipped then
            return
        end

        local stopAt = GetGameTimer() + duration - (options.offsetDuration or 0)

        while stopAt > GetGameTimer() do
            if camera.skipped then
                SetCamActive(nextCamera, false)
                DestroyCam(nextCamera)
                DestroyCam(camera.cameraEntity)
                camera.cameraEntity = nil
                return
            end

            Wait(0)
        end

        if camera.skipped then
            SetCamActive(nextCamera, false)
            DestroyCam(nextCamera)
            DestroyCam(camera.cameraEntity)
            camera.cameraEntity = nil
            return
        end

        SetCamActive(camera.cameraEntity, false)
        DestroyCam(camera.cameraEntity)

        camera.cameraEntity = nextCamera
        camera.startRendering()
    end

    function camera.moveCameraSmoothlyFromPoints(points)
        camera.cameraSmoothPoints = points

        for pointIndex, pointData in pairs(camera.cameraSmoothPoints) do
            if camera.skipped then
                break
            end

            camera.moveCameraSmoothlyToCoords(
                pointData.pos,
                pointData.rot,
                pointData.duration,
                pointData.options,
                pointData.text,
                pointData.textTimeout,
                pointData.textRenderTime,
                pointData.model,
                pointIndex
            )
        end

        HelpKeys.Hide()
        Subtitles.Hide()
    end

    function camera.focusCameraOnCoords(coords)
        PointCamAtCoord(camera.cameraEntity, coords.x, coords.y, coords.z)
        camera.isPointing = true
    end

    function camera.focusCameraOnEntity(entity, offset)
        offset = offset or vector3(0, 0, 0)

        PointCamAtEntity(
            camera.cameraEntity,
            entity,
            offset.x,
            offset.y,
            offset.z,
            true
        )

        camera.isPointing = true
    end

    function camera.focusCameraOnPedBone(ped, boneIndex, offset)
        PointCamAtPedBone(
            camera.cameraEntity,
            ped,
            boneIndex,
            offset.x,
            offset.y,
            offset.z,
            true
        )

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

    function camera.lerpCameraFov(fov, duration)
        camera.moveCameraSmoothlyToCoords(
            camera.getCameraCoords(),
            camera.getCameraRotation(),
            duration,
            {
                fov = fov,
                copyEffects = true
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

function FreezePlayerControls(state)
    controlsFrozen = state
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

        if not controlsFrozen then
            Wait(100)
        else
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
        end
    end
end, "cl-lib-camera code name: Bravo")

function SkipProlog()
    if controlsFrozen then
        prologSkipped = true
        dbg.critical("Prolog was skipped")
    end
end