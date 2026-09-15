local function refreshPlayerData()
    if not PlayerData or not PlayerData.citizenid then
        local ok, data = pcall(function() return QBCore.Functions.GetPlayerData() end)
        if ok and type(data) == 'table' then
            PlayerData = data
        end
    end
    return PlayerData or {}
end

local function getMessagesCallBack()
    return lib.callback.await('mri_Qadmin:callback:GetMessages', false)
end

RegisterNUICallback("GetMessages", function(_, cb)
    local data = getMessagesCallBack()
    local pd = refreshPlayerData()
    cb({
        messages = data or {},
        myCitizenid = pd.citizenid or tostring(GetPlayerServerId(PlayerId()))
    })
end)

RegisterNUICallback("SendMessage", function(msgData, cb)
    local message = msgData
    local mentions = {}

    if type(msgData) == 'table' then
        message = msgData.message or msgData.text or msgData.content or ''
        mentions = msgData.mentions or {}
    end

    if type(message) ~= 'string' or message == '' then
        cb(0)
        return
    end

    TriggerServerEvent("mri_Qadmin:server:sendMessage", message, nil, mentions)
    cb(1)
end)

RegisterNUICallback("GetStaffPlayers", function(_, cb)
    local staff = lib.callback.await('mri_Qadmin:callback:GetStaffPlayers', false)
    cb(staff or {})
end)

RegisterNetEvent('mri_Qadmin:client:newMessage', function(msg)
    SendNUIMessage({ action = 'newMessage', data = msg, type = 'newMessage', message = msg })
end)

RegisterNetEvent('mri_Qadmin:client:mentioned', function(senderName)
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    QBCore.Functions.Notify((senderName or 'Staff') .. ' te marcou no Staff Chat!', 'primary', 6000)
    SendNUIMessage({ action = 'mentioned', data = { senderName = senderName }, type = 'mentioned', senderName = senderName })
end)
