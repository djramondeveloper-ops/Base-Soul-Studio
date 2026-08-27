
Bridge = {}

local COLOR = { inform = '~s~', success = '~g~', error = '~r~', warning = '~y~' }

function Bridge.Notify(message, type)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName((COLOR[type] or '~s~') .. message)
    EndTextCommandThefeedPostTicker(false, true)
end

RegisterNetEvent('0r-mapeditor:notify', function(message, type)
    Bridge.Notify(message, type)
end)
