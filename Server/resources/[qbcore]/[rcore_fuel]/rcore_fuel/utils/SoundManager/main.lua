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

isPlayerCloseToSound = true
local shouldUnmuteOnNextUpdate = true  -- FIX 1: was global, bak confirms this is file-local
lastPlayerPosition = vector3(0, 0, 0)

function UpdatePlayerPositionInNUI()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    SendNUIMessage({
        type = "playerPosition",
        pos = { playerCoords.x, playerCoords.y, playerCoords.z }
    })
end

function UpdateNUIData()
    if isPlayerCloseToSound then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)

        if #(lastPlayerPosition - playerCoords) >= 0.1 then
            lastPlayerPosition = playerCoords
            UpdatePlayerPositionInNUI()
        end

        if shouldUnmuteOnNextUpdate then
            UpdatePlayerPositionInNUI()
            SendNUIMessage({ type = "unmuteAll" })
            shouldUnmuteOnNextUpdate = false
        end
    else
        if not shouldUnmuteOnNextUpdate then
            shouldUnmuteOnNextUpdate = true
            SendNUIMessage({
                type = "playerPosition",
                pos = { -99999, -99999, -99999 }
            })
            SendNUIMessage({ type = "muteAll" })
        end

        Wait(1000)
    end
end

CreateThread(function()
    local refreshTime = Config.RefreshTime

    while true do
        Wait(refreshTime)
        UpdateNUIData()
    end
end, "updating position for sound")

CreateThread(function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    while true do
        Wait(1000)

        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)

        local silentLoadHandlers = {}

        for soundId, soundHandler in pairs(soundInfo) do
            local distanceToSound = #(soundHandler.GetPlayingPosition() - playerCoords)
            local loadDistance = soundHandler.GetPlayingDistance() + 40

            if distanceToSound < loadDistance then
                if not soundHandler.WasCreatedFunctionCalled() then
                    soundHandler.CreateMedia(true)
                    local listenerHandler = soundHandler.AddListener("onloadSilent", function()
                        soundHandler.SetTimestamp(soundHandler.GetTimestamp())
                        soundHandler.RemoveListenerByHandler("onloadSilent", silentLoadHandlers[soundId])
                        silentLoadHandlers[soundId] = nil
                    end)
                    silentLoadHandlers[soundId] = listenerHandler
                end
            elseif soundHandler.WasCreatedFunctionCalled() then
                soundHandler.DeleteMedia()
                silentLoadHandlers[soundId] = nil
            end
        end
    end
end, "sound loader from cache")

CreateThread(function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    while true do
        Wait(1000)

        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        isPlayerCloseToSound = false

        for _, soundHandler in pairs(soundInfo) do
            if soundHandler.IsPlaying() then
                local distanceToSound = #(soundHandler.GetPlayingPosition() - playerCoords)
                local audibleDistance = soundHandler.GetPlayingDistance() + 40

                if distanceToSound < audibleDistance then
                    isPlayerCloseToSound = true
                    break
                end
            end
        end
    end
end, "isPlayerCloseToSound variable setter")

CreateThread(function()
    Wait(1100)

    while true do
        Wait(1000)

        for _, soundHandler in pairs(soundInfo) do
            if soundHandler.WasCreatedFunctionCalled() then
                local maxTimestamp = soundHandler.GetMaxTimestamp()

                -- FIX 1: was only checking "if maxTimestamp then", which doesn't
                -- catch maxTimestamp being some other truthy-but-non-numeric value
                -- (e.g. a JSON-null sentinel table, if the audio's reported
                -- duration was ever Infinity/NaN) -- guard on the actual type so a
                -- bad value here is skipped instead of crashing the comparison below
                if type(maxTimestamp) == "number" then
                    if soundHandler.GetTimestamp() < maxTimestamp then
                        soundHandler.timestamp = soundHandler.GetTimestamp() + 1
                    elseif soundHandler.IsLooped() then
                        soundHandler.timestamp = 0
                    elseif soundHandler.IsCreated() then
                        soundHandler.DeleteMedia(true)
                    end
                end
            end
        end
    end
end, "updating timestamp of sound")
