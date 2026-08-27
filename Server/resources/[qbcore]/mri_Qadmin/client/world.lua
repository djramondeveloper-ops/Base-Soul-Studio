-- Changes the time
RegisterNetEvent('mri_Qadmin:client:ChangeTime', function(srcData, selectedData)
    local data = CheckDataFromKey(srcData)
    if not data or not CheckPerms(data.perms) then return end
    local time = selectedData["Time Events"].value

    if not time then return end

    TriggerServerEvent('mri_Qadmin:server:SetSeoulTime', time, 0)
    TriggerServerEvent('mri_Qadmin:server:LogClientAction', 'server', 'info', ('Hora: alterada para %s'):format(tostring(time)), {})
end)

-- Changes the weather
RegisterNetEvent('mri_Qadmin:client:ChangeWeather', function(srcData, selectedData)
    local data = CheckDataFromKey(srcData)
    if not data or not CheckPerms(data.perms) then return end
    local weather = selectedData["Weather"].value

    TriggerServerEvent('mri_Qadmin:server:SetSeoulWeather', weather)
    TriggerServerEvent('mri_Qadmin:server:LogClientAction', 'server', 'info', ('Clima: alterado para %s'):format(tostring(weather)), {})
end)

RegisterNetEvent('mri_Qadmin:client:copyToClipboard', function(srcData, selectedData)
    local data = CheckDataFromKey(srcData)
    if not data or not CheckPerms(data.perms) then return end

    local dropdown = selectedData["Copy Coords"].value
    local ped = PlayerPedId()
    local string = nil
    if dropdown == 'vector2' then
        local coords = GetEntityCoords(ped)
        local x = QBCore.Shared.Round(coords.x, 2)
        local y = QBCore.Shared.Round(coords.y, 2)
        string = "vector2(".. x ..", ".. y ..")"
        QBCore.Functions.Notify(locale("notifications.copy_vector2"), 'success')
    elseif dropdown == 'vector3' then
        local coords = GetEntityCoords(ped)
        local x = QBCore.Shared.Round(coords.x, 2)
        local y = QBCore.Shared.Round(coords.y, 2)
        local z = QBCore.Shared.Round(coords.z, 2)
        string = "vector3(".. x ..", ".. y ..", ".. z ..")"
        QBCore.Functions.Notify(locale("notifications.copy_vector3"), 'success')
    elseif dropdown == 'vector4' then
        local coords = GetEntityCoords(ped)
        local x = QBCore.Shared.Round(coords.x, 2)
        local y = QBCore.Shared.Round(coords.y, 2)
        local z = QBCore.Shared.Round(coords.z, 2)
        local heading = GetEntityHeading(ped)
        local h = QBCore.Shared.Round(heading, 2)
        string = "vector4(".. x ..", ".. y ..", ".. z ..", ".. h ..")"
        QBCore.Functions.Notify(locale("notifications.copy_vector4"), 'success')
    elseif dropdown == 'heading' then
        local heading = GetEntityHeading(ped)
        local h = QBCore.Shared.Round(heading, 2)
        string = h
        QBCore.Functions.Notify(locale("notifications.copy_heading"), 'success')
    elseif string == nil then
        QBCore.Functions.Notify(locale("notifications.empty_input"), 'error')
    end

    -- Only copy when we actually built a value (avoid clipboarding nil).
    if string ~= nil then
        lib.setClipboard(string)
    end

end)

RegisterNetEvent('mri_Qadmin:client:SeoulBlackout', function(state)
    SetArtificialLightsState(state and true or false)
    SetArtificialLightsStateAffectsVehicles(false)
end)

RegisterNetEvent('mri_Qadmin:client:SeoulGotoWaypoint', function(srcData)
    local data = CheckDataFromKey(srcData)
    if data and not CheckPerms(data.perms) then return end
    local wp = GetFirstBlipInfoId(8)
    if DoesBlipExist(wp) then
        local coords = GetBlipCoords(wp)
        local z = coords.z
        local found, groundZ = false, z
        for i = 0, 24 do
            local probeZ = coords.z + (i * 25.0)
            RequestCollisionAtCoord(coords.x, coords.y, probeZ)
            found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, probeZ, true)
            if found then break end
            Wait(50)
        end
        if found then z = groundZ end
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, z + 0.5, false, false, false, false)
        TriggerServerEvent('mri_Qadmin:server:LogClientAction', 'players', 'info', ('Teleporte: admin foi para waypoint (%.1f, %.1f)'):format(coords.x, coords.y), {})
    else
        QBCore.Functions.Notify(locale('notifications.no_waypoint') or 'Nenhum waypoint definido.', 'error')
    end
end)

RegisterNetEvent('mri_Qadmin:client:SeoulFixVehicle', function(srcData)
    local data = CheckDataFromKey(srcData)
    if data and not CheckPerms(data.perms) then return end
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then veh = GetVehiclePedIsIn(ped, true) end
    if veh and veh ~= 0 then
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        QBCore.Functions.Notify('Veículo reparado.', 'success')
        TriggerServerEvent('mri_Qadmin:server:LogClientAction', 'vehicles', 'info', 'Veículo: admin reparou o veículo', {})
    else
        QBCore.Functions.Notify(locale('notifications.not_in_vehicle') or 'Você não está em um veículo.', 'error')
    end
end)
