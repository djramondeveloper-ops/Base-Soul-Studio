-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Prison == Prison.QB_PRISON then
        RegisterNetEvent('rcore_police:server:requestPrison', function(target, time)
            local playerId = source
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not state then return end
            if not target or not time then return end
            local targetPed = GetPlayerPed(playerId)
            if not DoesEntityExist(targetPed) then return end
            if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance) then
                Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
                return
            end
            local TargetPlayer = Framework.getPlayer(target)
            if not TargetPlayer then return end
            local currentDate = os.date('*t')
            if currentDate.day == 31 then
                currentDate.day = 30
            end
            TargetPlayer.Functions.SetMetaData('injail', time)
            TargetPlayer.Functions.SetMetaData('criminalrecord', {
                hasRecord = true,
                date = currentDate
            })
            TriggerClientEvent(Config.Events['QBCore:Client:OnPlayerLoaded'], target)
        end)
    end
end)
