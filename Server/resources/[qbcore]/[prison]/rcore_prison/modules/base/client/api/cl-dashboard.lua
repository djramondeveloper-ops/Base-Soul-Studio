function OpenDashboard()
    ExecuteCommand(Config.Commands.JailCP or 'jailcp')
end

RegisterNetEvent('rcore_prison:client:openDashboard', OpenDashboard)

exports('OpenDashboard', OpenDashboard)

