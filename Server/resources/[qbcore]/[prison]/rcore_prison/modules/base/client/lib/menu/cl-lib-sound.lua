Sound = {}

function Sound.HandleAnnoucement(isEnabled)
    Sound.HandleAmbientSound("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_GENERAL", isEnabled)
end

function Sound.HandleAlarmAnnoucement(isEnabled)
    Sound.HandleAmbientSound("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_ALARM", isEnabled)
end

function Sound.HandleAmbientSound(zoneName, isEnabled)
    SetAmbientZoneState(zoneName, isEnabled, true)
end

CreateThread(function()
    if Config.Sounds and Config.Sounds.UseCustomAlarmSound then
        dbg.debug("Audio bank is disabled, using own solution")
        return
    end

    Sound.RequestAlarm()
end)

function Sound.StartAlarm(isActive)
    if isActive then
        dbg.debug("Alarm started, since Prison break is active!")
        Sound.HandleAlarmAnnoucement(true)
        Sound.SetPrisonAlarm(true)
    else
        Sound.StopAlarm()
    end
end

function Sound.StopAlarm()
    Sound.HandleAlarmAnnoucement(false)
    Sound.SetPrisonAlarm(false)
end

function Sound.RequestAlarm()
    PrepareAlarm("PRISON_ALARMS")
end

function Sound.SetPrisonAlarm(isEnabled)
    local useCustomAlarm = false

    if Config.Sounds and Config.Sounds.UseCustomAlarmSound then
        useCustomAlarm = true
    else
        useCustomAlarm = isResourcePresentProvideless("xsound")
    end

    if useCustomAlarm then
        if isEnabled then
            dbg.debug("Starting alarm sound - custom")
            StartAlarm()
        else
            dbg.debug("Stopping alarm sound - custom")
            StopAlarm()
        end
        return
    end

    if isEnabled then
        StartAlarm("PRISON_ALARMS", true)
    else
        StopAlarm("PRISON_ALARMS", true)
    end
end