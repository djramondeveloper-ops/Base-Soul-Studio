PrologService = {}

local isCutsceneRunning = false

function PrologService.GetPlayerCutSceneState()
    return isCutsceneRunning
end

function PrologService.Start()
    if Config.Prolog.ResetCache and Cache.GetPrologKVP() == 1 then
        dbg.debug("Prolog cache reset")
        Cache.DeletePrologKVP()
    end

    if Cache.GetPrologKVP() ~= 0 then
        dbg.debug("Skipping prolog as it has already been started before.")
        return true
    end

    isCutsceneRunning = true

    dbg.debug("Prolog started")
    Cache.SetPrologKVP(1)

    local cameraConfig = SH.data.cameraProlog
    local playerPed = PlayerPedId()
    local prisonYard = SH.data.prisonYard

    NetworkStartSoloTutorialSession()
    FreezeEntityPosition(playerPed, true)
    DisplayRadar(false)

    SetEntityCoords(playerPed, prisonYard)
    SetEntityHeading(playerPed, 0.0)

    local camera = CreateCameraLib(cameraConfig.initCameraPosition, cameraConfig.initCameraRot)

    Wait(0)
    SetGameplayCamRelativeRotation(
        cameraConfig.initGameplayCamRot.x,
        cameraConfig.initGameplayCamRot.y,
        cameraConfig.initGameplayCamRot.z
    )

    HelpKeys.Show({
        {
            label = _U("PROLOG.SKIP_HELP_LABEL"),
            keyName = "E"
        }
    }, Config.Prolog.SkipHelpKeyPosition)

    camera.startRendering()
    camera.skippable()
    camera.ActiveFXEffect(CameraAnimFX.INTRO_LOGO, 0, false)

    dbg.debug(">> Start init camera prolog")
    camera.moveCameraSmoothlyFromPoints(cameraConfig.points)
    dbg.debug(">> Finish init camera prolog")

    camera.exitCameraSmoothly(3000)
    camera.StopAllFXEffects()

    Subtitles.Hide()
    HelpKeys.Hide()

    SetTimeout(1000, function()
        DisplayRadar(true)
        NetworkEndTutorialSession()
        FreezeEntityPosition(playerPed, false)
        isCutsceneRunning = false
    end)

    return true
end

callback.register("prolog", function()
    PrologService.Start()
    return true
end)
