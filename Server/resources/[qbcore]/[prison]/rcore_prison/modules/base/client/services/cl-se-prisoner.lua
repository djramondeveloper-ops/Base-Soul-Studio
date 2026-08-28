PrisonService = {}

local function getPrisonerStorage()
    return Object.getStorage(STORAGE_PRISONER)
end

local function getDebugSolitaryValue()
    if SH.solitaryLeft and SH.solitaryLeft > 0 then
        return SH.solitaryLeft
    end

    return "not_in_solitary"
end

RegisterCommand("rcore_prison_debug_release", function()
    local debugData = {
        jail_time = SH.timeLeft,
        solitary_time = getDebugSolitaryValue(),
        render_state = SH.isRenderingTime
    }

    if type(debugData) == "table" and next(debugData) then
        tprint(debugData)
    end
end)

function PrisonService.SendHeartbeat(eventName, ...)
    TriggerEvent("rcore_prison:client:heartbeat", eventName, ...)
end

function PrisonService.IsPrisoner()
    local storage = getPrisonerStorage()
    if not storage then
        return false
    end

    return storage.IsPrisoner()
end

function PrisonService.RegisterPrisoner(prisonerData)
    local prisoner = PrisonerModel()
    local storage = getPrisonerStorage()

    if not storage then
        return
    end

    prisoner.id = prisonerData.prisoner_id
    prisoner.charId = prisonerData.owner
    prisoner.jail_time = prisonerData.jail_time
    prisoner.jail_reason = prisonerData.jail_reason
    prisoner.officerName = prisonerData.officerName
    prisoner.state = prisonerData.state
    prisoner.perollDone = prisonerData.perollDone

    storage.RegisterPrisoner(prisoner)

    PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_LOADED, {
        prisoner = prisonerData
    })
end

function PrisonService.ClearPrisonerData(keepPrisonBreakOutfit)
    local storage = getPrisonerStorage()
    if not storage then
        return
    end

    storage.UnregisterPrisoner()

    SH.isRenderingTime = false
    SH.isRenderingPrisonMap = false
    Booths.callSessionState = false
    SH.isSolitaryDone = false
    SH.screen = nil
    SH.zoneId = nil

    HideApp()
    HelpKeys.Hide()
    Text.Hide()
    Subtitles.Hide()

    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        visible = false,
        screen = nil
    })

    Blips.RemoveByType("RELEASE")
    DestroyAllMenus()
    TextService.Hide()
    ClearAllHelpMessages()
    BusyspinnerOff()

    if keepPrisonBreakOutfit then
        PlayerEscaped()
        dbg.debug("Prisoner data were cleared, but the outfit was kept since Prison Break!")
        return
    end

    SetTimeout(1000, function()
        dbg.debug("Removing loaded UI as fallback!")

        SH.isRenderingTime = false
        TextService.Hide()
        HelpKeys.Hide()
        Text.Hide()
        Subtitles.Hide()
    end)

    PrisonService.SendHeartbeat(HEARTBEAT_EVENTS.PRISONER_RELEASED)
end

function PrisonService.DisplayPrisonMap()
    if not Config.DisplayPrisonMap then
        return
    end

    SH.isRenderingPrisonMap = true

    _SetRadarAsInteriorThisFrame = SetRadarAsInteriorThisFrame
    _SetRadarAsExteriorThisFrame = SetRadarAsExteriorThisFrame

    while SH.isRenderingPrisonMap do
        Wait(0)
        _SetRadarAsInteriorThisFrame("V_FakePrison", 1700.0, 2580.0, 0.0, 0)
        _SetRadarAsExteriorThisFrame()
    end
end

function PrisonService.HandleJailTime(jailSeconds, restartCurrentTimer, solitarySeconds)
    local jailEndTime = GetGameTimer() + (jailSeconds * 1000)
    local solitaryDuration = solitarySeconds and (solitarySeconds * 1000) or 0
    local solitaryEndTime = GetGameTimer() + solitaryDuration
    local waitPromise = promise.new()
    local resolved = false

    if not Config.RenderJailTime then
        dbg.bridge("Jail time is disabled in the config!")
    end

    if solitarySeconds and not restartCurrentTimer then
        restartCurrentTimer = true
    end

    if restartCurrentTimer then
        SH.isRenderingTime = false
        Text.Hide()
        Wait(1000)
        dbg.debug("RequestRelease: Jail time has been updated, stopping the current time and starting a new one!")
    end

    if SH.isRenderingTime then
        dbg.bridge("Jail time is already running!")
        return
    end

    if SH.isSolitaryDone then
        SH.isSolitaryDone = false
    end

    SH.isRenderingTime = true
    SH.solitaryLeft = nil
    SH.timeLeft = nil

    CreateThread(function()
        while SH.isRenderingTime do
            Wait(0)

            local jailTimeLeft = Time.GetTimeLeftFromGameTime(jailEndTime)
            local solitaryTimeLeft = Time.GetTimeLeftFromGameTime(solitaryEndTime)

            if solitaryTimeLeft <= 0 and not SH.isSolitaryDone then
                SH.isSolitaryDone = true
                SH.solitaryLeft = nil
                SolitaryService.ReleasePrisoner()
            end

            if not Config.RenderJailTime and jailTimeLeft <= 0 then
                if SH.solitaryLeft == nil then
                    SH.isRenderingTime = false
                end

                Text.Hide()

                if not resolved then
                    resolved = true
                    waitPromise:resolve(true)
                end
            end

            if jailTimeLeft > 0 then
                if Config.RenderJailTime then
                    if solitaryTimeLeft > 0 then
                        PrisonService.DisplayTime(_U(
                            "DISPLAY_SOLITARY_TIME_WITH_JAIL",
                            Time.DynamicSecondsToClock(jailTimeLeft),
                            Time.DynamicSecondsToClock(solitaryTimeLeft)
                        ))
                    else
                        PrisonService.DisplayTime(_U(
                            "DISPLAY_JAIL_TIME",
                            Time.DynamicSecondsToClock(jailTimeLeft)
                        ))
                    end
                end
            elseif jailTimeLeft <= 0 then
                if SH.solitaryLeft == nil then
                    SH.isRenderingTime = false
                end

                Text.Hide()

                if not resolved then
                    resolved = true
                    waitPromise:resolve(true)
                end
            end

            if jailTimeLeft <= 0 and solitaryTimeLeft > 0 then
                PrisonService.DisplayTime(_U(
                    "DISPLAY_SOLITARY_TIME_WITH_JAIL",
                    Time.DynamicSecondsToClock(jailTimeLeft),
                    Time.DynamicSecondsToClock(solitaryTimeLeft)
                ))
            end

            SH.solitaryLeft = solitaryTimeLeft
            SH.timeLeft = jailTimeLeft

            Wait(1000)
        end
    end, "cl-se-prisoner code name: Phoenix")

    dbg.debug("RequestRelease: Jail time has started 1/2")
    Citizen.Await(waitPromise)
    dbg.debug("RequestRelease: Jail time has finished - continue.")

    PrisonService.HandleEnforceRelease()
end

function PrisonService.HandleEnforceRelease()
    if Config.Release.AtCheckpoint then
        if SH.solitaryLeft and SH.solitaryLeft > 0 then
            dbg.debug("RequestRelease: Release at checkpoint is enabled, but the solitary time is not finished yet!")
            return
        end

        TextService.Render(_U("RELEASE.RELEASE_READY_TEXT"))

        if SH.data.interaction then
            Subtitles.Show(_U("RELEASE.RELEASE_READY_SUBTITLE"))

            for _, interactionData in pairs(SH.data.interaction) do
                if interactionData.releasePlayerOption then
                    SetNewWaypoint(interactionData.coords.x, interactionData.coords.y)
                    Blips.CreateSquaredArea(interactionData.coords, "RELEASE")
                end
            end
        end

        dbg.debug("RequestRelease: Release at checkpoint is enabled, you need to get to the checkpoint!")
        return
    end

    TriggerServerEvent("rcore_prison:server:requestRelease")
end

function PrisonService.DisplayTime(text)
    TextService.Render(text)
end

Object.registerService(SERVICE_PRISONER, PrisonService)
