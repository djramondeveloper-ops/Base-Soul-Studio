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

function RegisterKey(commandHandler, commandPrefix, keyDescription, commandSuffix, inputType)
    if inputType == nil then
        inputType = "keyboard"
    end

    local commandName = commandPrefix .. commandSuffix
    RegisterCommand(commandName, commandHandler, false)
    RegisterKeyMapping(commandName, keyDescription, inputType, commandSuffix)
end

function GenerateRandomIdentifier()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local identifier = ""
    local seed = GetPlayerServerId(PlayerId()) + GetGameTimer()

    for _ = 1, 12 do
        seed = (seed * 214013 + 2531011) % 2147483648
        local index = (math.floor(seed / 65536.0) % #charset) + 1
        identifier = identifier .. string.sub(charset, index, index)
    end

    return identifier
end

function RotationToDirection(rotation)
    local radians = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z,
    }

    return {
        x = -math.sin(radians.z) * math.abs(math.cos(radians.x)),
        y = math.cos(radians.z) * math.abs(math.cos(radians.x)),
        z = math.sin(radians.x),
    }
end

function DisplayCinematicBlackBars(showBars, fadeTime, barSize, callback)
    if showBars then
        SendNUIMessage({
            type = "blackbars",
            size = barSize or 15,
            timeShow = fadeTime or 0,
        })
    else
        SendNUIMessage({
            type = "blackbars",
            size = -1,
            timeShow = fadeTime or 0,
        })
    end

    if callback ~= nil then
        Wait(fadeTime)
        callback()
    end
end

function ShowSubtitle(text, duration, callback)
    duration = duration or 5000

    SendNUIMessage({
        type = "subtitles",
        text = text,
        timer = duration,
    })

    if callback ~= nil then
        Wait(duration)
        callback()
    end
end

function IsPlayerInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function IsPlayerDriver()
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        return GetPedInVehicleSeat(vehicle, -1) == playerPed
    end

    return false
end

function ShowSingularTutorialCamera(
    cameraPosition,
    cameraRotation,
    showBlackBars,
    subtitleText,
    keepCameraActive,
    subtitleDuration,
    beforeFadeCallback,
    skipHudEvents
)
    FreezePlayerControls(true)

    local camera = CreateCamera(cameraPosition, cameraRotation)

    DoScreenFadeOut(500)
    Wait(600)

    if beforeFadeCallback then
        beforeFadeCallback()
    end

    camera.startRendering()

    if showBlackBars then
        DisplayCinematicBlackBars(true)
    end

    if not skipHudEvents then
        TriggerEvent("rcore_fuel:hideHud")
    end

    Wait(200)
    DoScreenFadeIn(500)
    ShowSubtitle(subtitleText, subtitleDuration or 10000)

    Wait(subtitleDuration or 10000)

    if not keepCameraActive then
        DoScreenFadeOut(500)
        Wait(500)
    end

    if showBlackBars then
        DisplayCinematicBlackBars(false)
    end

    if not keepCameraActive then
        camera.disposeCamera()
        Wait(200)
        DoScreenFadeIn(500)
    else
        camera.exitCameraSmoothly(1000)
    end

    ClearFocus()
    FreezePlayerControls(false)

    if not skipHudEvents then
        TriggerEvent("rcore_fuel:showHud")
    end
end
