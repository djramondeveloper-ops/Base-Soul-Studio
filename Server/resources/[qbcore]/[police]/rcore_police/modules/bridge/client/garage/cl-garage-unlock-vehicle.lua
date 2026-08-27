-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function UnlockVehicle(vehicleId, data)
    local plyPed = PlayerPedId()
    if not DoesEntityExist(vehicleId) then
        return dbg.critical('Failed to unlock vehicle, entity doesnt exist!')
    end
    IsBusy = true
    if Config.UnlockVehicle.UseProgressBar then
		SetTimeout(100, function()
            TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true) 
        end)
        CancellableProgress(
            Config.UnlockVehicle.ProgressBarTime * 1000,
            _U('UNLOCKING_VEHICLE'),
            'missheistdockssetup1clipboard@base',
            'base',
            1,
            function()
                SetVehicleUnlockedState(vehicleId, plyPed)
            end,
            function()
                IsBusy = false
            end,
            {}
        )
    else
        TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(Config.UnlockVehicle.ProgressBarTime * 1000)
        SetVehicleUnlockedState(vehicleId, plyPed)
    end
end
function SetVehicleUnlockedState(vehicleId, plyPed)
    if not vehicleId then
        return
    end
    ClearPedTasksImmediately(plyPed)
    Framework.sendNotification(_U('VEHICLE_UNLOCKED'), 'success')
    SetVehicleDoorsLocked(vehicleId, 1)
    SetVehicleDoorsLockedForAllPlayers(vehicleId, false)
    dbg.debug('Unlocking vehicle!')
    IsBusy = false
end
