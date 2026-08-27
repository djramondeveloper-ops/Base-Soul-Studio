if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Flashbang') then return end

RegisterNetEvent('next-flashbang:detonate', function(pos, players, entity)
    local source = source
    if not SeoulScriptsServer.CheckCooldown(source,'flashbang',1000) then return end
    if not CanDetonateFlashbang(source) then return end
    if type(pos) ~= 'vector3' or type(players) ~= 'table' then
        PunishPlayer(source, 'Parâmetros inválidos.')
        return
    end

    local ped = GetPlayerPed(source)
    if not ped or not DoesEntityExist(ped) then return end
    local srcCoords = GetEntityCoords(ped)
    if #(srcCoords - pos) > (SeoulScripts.Security.FlashbangMaxThrowDistance or 80.0) then
        PunishPlayer(source, 'Explosão muito distante do jogador.')
        return
    end

    local flashbang = entity and NetworkGetEntityFromNetworkId(entity) or 0
    if flashbang and flashbang ~= 0 and DoesEntityExist(flashbang) then
        local timer = GetGameTimer()
        while DoesEntityExist(flashbang) and GetGameTimer() - timer < 1000 do
            pcall(DeleteEntity, flashbang)
            Wait(50)
        end
    end

    local sent = {}
    for _,id in ipairs(players) do
        id = tonumber(id)
        if id and not sent[id] then
            sent[id] = true
            local playerPed = GetPlayerPed(id)
            if playerPed and DoesEntityExist(playerPed) then
                local playerPos = GetEntityCoords(playerPed)
                local distance = #(playerPos - pos)
                if distance <= (ConfigFlash.FlashbangRadius + 0.0) then
                    TriggerClientEvent('next-flashbang:flash', id, pos, distance)
                end
            end
        end
    end
end)
