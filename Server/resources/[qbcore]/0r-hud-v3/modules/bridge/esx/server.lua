
RegisterNetEvent('esx_ambulancejob:setDeathStatus', function(state)
    local src = source
    TriggerClientEvent(_e('client:setPlayerDeathStatus'), src, state)
end)

