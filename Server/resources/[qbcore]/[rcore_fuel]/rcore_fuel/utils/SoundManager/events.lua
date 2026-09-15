--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

SoundStatusPlayingMap = {
    onplay = true,
    onpause = false,
    onresume = true,
    onloadSilent = true,
}

RegisterNUICallback("init", function(_, callback)
    SendNUIMessage({
        type = "timer",
        time = Config.RefreshTime,
    })

    if callback then
        callback("ok")
    end
end)

RegisterNUICallback("sound_status", function(data, callback)
    local sound = soundInfo[data.id]

    if sound then
        if sound:HasEventListeners(data.type) then
            for listenerId, listener in pairs(sound:GetAllEventListenersFor(data.type)) do
                CreateThread(function()
                    listener(sound, listenerId)
                end, "sound status event cb 26")
            end
        end

        local playingStatus = SoundStatusPlayingMap[data.type]
        -- `false` is a valid status for onpause; checking truthiness skipped it.
        if playingStatus ~= nil then
            sound:SetPlayingStatus(playingStatus)
        end

        if data.type == "onload" then
            sound:SetMaxTimestamp(data.info.maxTime)

            local distanceToSound = #(sound:GetPlayingPosition() - GetEntityCoords(PlayerPedId()))
            if distanceToSound < sound:GetPlayingDistance() + 40 then
                isPlayerCloseToSound = true
                UpdateNUIData()
            end
        end

        if data.type == "oncreate" then
            sound:SetCreatedStatus(true)
        end

        if data.type == "onend" then  -- FIX 1: else was attached to this outer check instead of
            if sound:IsSupposeToBeDestroyed() then  -- the inner IsSupposeToBeDestroyed() check below,
                if not sound:IsLooped() then  -- making the DeleteMedia() cleanup path unreachable dead code
                    sound:Destroy()
                end
            else
                if not sound:IsLooped() then
                    sound:DeleteMedia()
                end
            end
        end
    end

    if callback then
        callback("ok")
    end
end)
