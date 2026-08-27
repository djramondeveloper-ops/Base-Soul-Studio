-- Seoul Base: Config.Prison = NONE uses the current LB Tablet vRP jail adapter.
-- Confirmed export: exports['lb-tablet']:JailPlayer(identifier, seconds, reason, officerSource)
if Config.Prison == Prison.NONE then

    RegisterNetEvent('rcore_police:server:requestSeoulPrison', function(target, minutes, reason)
        local src = source
        target = tonumber(target)
        minutes = math.floor(tonumber(minutes) or 0)
        reason = tostring(reason or 'Prisao policial'):sub(1, 240)

        local isMember = GroupsService.IsPlayerMemberOfGroup(src)
        if not isMember then return end
        if not target or target <= 0 or target == src or minutes <= 0 then return end
        if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance + 0.5) then
            return Framework.sendNotification(src, _U('NO_CITIZEN_NEARBY'), 'error')
        end
        if GetResourceState('lb-tablet') ~= 'started' then
            return Framework.sendNotification(src, 'LB Tablet nao esta iniciado; prisao cancelada.', 'error')
        end

        local identifier = Framework.getIdentifier(target)
        if not identifier then return end

        local ok, jailed = pcall(function()
            return exports['lb-tablet']:JailPlayer(identifier, minutes * 60, reason, src)
        end)

        if not ok or jailed ~= true then
            return Framework.sendNotification(src, 'Nao foi possivel registrar a prisao no sistema atual.', 'error')
        end

        Framework.sendNotification(src, ('Prisao registrada por %d minuto(s).'):format(minutes), 'success')
    end)
end
