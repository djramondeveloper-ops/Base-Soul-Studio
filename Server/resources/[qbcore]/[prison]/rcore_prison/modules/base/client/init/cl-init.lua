local playerServerId = GetPlayerServerId(PlayerId())

PrisonService = nil
MyServerId = playerServerId
IsAtBooth = false
RestrictZone = {}

DoScreenFadeIn(0)

CreateThread(function()
    RemoveAllTargetZones()

    local timeoutAt = GetGameTimer() + 10000

    while GetGameTimer() < timeoutAt do
        if Object and Object.getService and Object.getService(SERVICE_PRISONER) then
            break
        end

        Wait(50)
    end

    PrisonService = Object and Object.getService and Object.getService(SERVICE_PRISONER) or nil

    if not PrisonService then
        dbg.critical("Cannot find prison service - cl-init.lua")
        return
    end

    FreezePlayer(PlayerId(), false)
    Text.Hide()
    HelpKeys.Hide()
    Subtitles.Hide()
    Sound.StopAlarm()
    Sound.HandleAnnoucement(Config.PrisonYardAnnoucement)
    Mugshot.ResetHeadMemory()
    FreezeEntityPosition(PlayerPedId(), false)
    FreezePlayer(PlayerId(), false)

    while Config.DebugEnviroment do
        Wait(0)
        DrawDebugPolyZone(SH.data.prisonVertices, 1)
    end
end, "cl-init code name: Phoenix")