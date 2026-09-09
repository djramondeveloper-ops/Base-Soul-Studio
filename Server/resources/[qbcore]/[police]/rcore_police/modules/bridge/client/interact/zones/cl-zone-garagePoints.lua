-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function HandleVehicleEnterOnSpawnPoint(zone)
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true)
    if not vehicle then
        return dbg.debug('Skipping since player is not in vehicle.')
    end
end
function HandleVehicleOnSpawnPointInteract(zone)
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true)
    if not vehicle then
        return dbg.debug('Skipping since player is not in vehicle.')
    end
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if DoesEntityExist(playerVehicle) then
        UI.HelpKeys(nil, false)
        TriggerServerEvent('rcore_police:server:requestStoreVehicle', VehToNet(playerVehicle), zone.getZoneData())
    end
end
function HandleSpawnVehicle(coords, model)
    dbg.debug('TrySpawnVehicle: Found free spot, loading vehicle spawn 2/3')
    local vehicle, netId = Garage.SpawnVehicle(coords, model)
    if vehicle and DoesEntityExist(vehicle) then
        local job = Framework.job
        local jobName = job and job.name
        TriggerEvent('rcore_police:client:garage:spawnedVehicle', netId, MyServerId, jobName)
        TriggerServerEvent('rcore_police:server:registerVehicle', netId)
    end
    if vehicle then
        TextService.Hide()
        UI.HelpKeys(nil, false)
        GlobalZoneId = nil
        CurrentZone = nil
        AddVehicleKey(vehicle)
        SetVehicleFuel(vehicle)
        HandleVehicleSpawnExtras(vehicle)
    end
end
