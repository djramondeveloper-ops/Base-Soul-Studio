NetworkService.RegisterNetEvent("prisonerHeartbeat", function(success, prisonerData, clearReason)
    if not success then
        return
    end

    if prisonerData then
        dbg.debug("Your prisoner data were loaded from server!")

        FreezeEntityPosition(PlayerPedId(), false)
        FreezePlayer(PlayerId(), false)

        PrisonService.RegisterPrisoner(prisonerData)

        if not Config.DisplayPrisonMapForEverybody then
            SetTimeout(0, function()
                pcall(function()
                    PrisonService.DisplayPrisonMap()
                end)
            end)
        end

        PrisonService.HandleJailTime(
            prisonerData.jail_time,
            prisonerData.hasTimeChange,
            prisonerData.solitary_time
        )

        return
    end

    dbg.debug("Your prisoner data were deleted!")
    PrisonService.ClearPrisonerData(clearReason)
end)

RegisterNuiCallback("getPrisoners", function(data, cb)
    local prisoners = callback.await("rcore_prison:server:getAllPrisoners", false, data)
    cb(prisoners)
end)
