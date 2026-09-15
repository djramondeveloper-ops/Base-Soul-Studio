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

soundInfo = {}

validListenerTypes = {
    onload = true,
    onerror = true,
    onplay = true,
    onpause = true,
    onresume = true,
    onend = true,
    oncreate = true,
    ontimechange = true,
    onloadSilent = true
}

function DoesListenerExists(listenerType)
    return validListenerTypes[listenerType] ~= nil
end

function CreateSoundHandler(identifier)
    if not identifier then
        identifier = GenerateRandomIdentifier()
    end

    local soundHandler = {
        isPlaying = false,
        soundUrl = "",
        soundKey = "",
        volume = 1.0,
        previousVolume = 1.0,
        position = GetEntityCoords(PlayerPedId()),
        distance = 10,
        identifier = identifier,
        timestamp = 0,
        maxTimestamp = nil,
        isCreated = false,
        CreateMediaCreated = false,
        events = {},
        eventIdentifier = 0,
        loop = false,
        autoplay = false,
        destroyOnFinish = true,
        isFadeActive = false
    }

    soundHandler.IsFadeActive = function()
        return soundHandler.isFadeActive
    end

    soundHandler.FadeOut = function(durationMs)
        soundHandler.isFadeActive = true
        durationMs = math.max(100, tonumber(durationMs) or 1000)
        local startVolume = soundHandler.volume
        local fadeSteps = math.max(1, math.ceil(durationMs / 100))

        for step = 1, fadeSteps do
            local fadeProgress = 1 - (step / fadeSteps)
            soundHandler.SetVolume(startVolume * fadeProgress, true, true)
            Wait(math.max(1, math.floor(durationMs / fadeSteps)))
        end

        soundHandler.volume = 0.0
        soundHandler.SetVolume(0.0, true, true)
        soundHandler.isFadeActive = false
    end

    soundHandler.FadeIn = function(durationMs)
        soundHandler.isFadeActive = true
        durationMs = math.max(100, tonumber(durationMs) or 1000)
        local targetVolume = soundHandler.previousVolume
        local fadeSteps = math.max(1, math.ceil(durationMs / 100))

        for step = 1, fadeSteps do
            local fadeProgress = 1 - (step / fadeSteps)
            local currentVolume = soundHandler.previousVolume - (targetVolume * fadeProgress)
            soundHandler.SetVolume(currentVolume, true, true)
            Wait(math.max(1, math.floor(durationMs / fadeSteps)))
        end

        soundHandler.volume = soundHandler.previousVolume
        soundHandler.SetVolume(soundHandler.previousVolume, true, true)
        soundHandler.isFadeActive = false
    end

    soundHandler.SetDestroyOnFinish = function(destroyOnFinish)
        soundHandler.destroyOnFinish = destroyOnFinish
    end

    soundHandler.IsSupposeToBeDestroyed = function()
        return soundHandler.destroyOnFinish
    end

    soundHandler.AddListener = function(eventType, callback)
        if not DoesListenerExists(eventType) then
            return
        end

        if not soundHandler.events[eventType] then
            soundHandler.events[eventType] = {}
        end

        soundHandler.eventIdentifier = soundHandler.eventIdentifier + 1
        soundHandler.events[eventType][soundHandler.eventIdentifier] = callback
        return soundHandler.eventIdentifier
    end

    soundHandler.HasEventListeners = function(eventType)
        return soundHandler.events[eventType] ~= nil
    end

    soundHandler.GetAllEventListenersFor = function(eventType)
        return soundHandler.events[eventType] or {}
    end

    soundHandler.RemoveListenerByHandler = function(eventType, handlerId)
        if not DoesListenerExists(eventType) then
            return
        end

        if soundHandler.events[eventType] then
            soundHandler.events[eventType][handlerId] = nil
        end
    end

    soundHandler.RemoveListener = function(eventType)
        if not DoesListenerExists(eventType) then
            return
        end

        soundHandler.events[eventType] = nil
    end

    soundHandler.LoadSound = function(a, b)
        local soundUrl = (a == soundHandler and b ~= nil) and b or a
        if type(soundUrl) == "string" then
            soundHandler.soundUrl = soundUrl
        end
    end

    soundHandler.ChangeSound = function(a, b)
        local soundUrl = (a == soundHandler and b ~= nil) and b or a
        soundHandler.LoadSound(soundUrl)
        soundHandler.CreateMedia()
    end

    soundHandler.GetSound = function()
        return soundHandler.soundUrl
    end

    soundHandler.GetAutoPlay = function()
        return soundHandler.autoplay
    end

    soundHandler.SetAutoPlay = function(a, b)
        local autoplay = (a == soundHandler and b ~= nil) and b or a
        soundHandler.autoplay = autoplay == true
        SendNUIMessage({
            type = "autoplay",
            identifier = tostring(soundHandler.identifier),
            autoplay = soundHandler.autoplay
        })
    end

    soundHandler.SetLoop = function(a, b)
        local loop = (a == soundHandler and b ~= nil) and b or a
        soundHandler.loop = loop == true

        if soundHandler.isCreated then
            SendNUIMessage({
                type = "loop",
                identifier = tostring(soundHandler.identifier),
                loop = soundHandler.loop
            })
        end
    end

    soundHandler.IsLooped = function()
        return soundHandler.loop
    end

    soundHandler.SetMaxTimestamp = function(a, b)
        local maxTimestamp = (a == soundHandler and b ~= nil) and b or a
        if type(maxTimestamp) == "number" then
            soundHandler.maxTimestamp = maxTimestamp
        end
    end

    soundHandler.GetMaxTimestamp = function()
        return soundHandler.maxTimestamp
    end

    soundHandler.SetVolume = function(a, b, c, d)
        local volume, skipLocalUpdate, sendUpdate
        if a == soundHandler then
            volume, skipLocalUpdate, sendUpdate = b, c, d
        else
            volume, skipLocalUpdate, sendUpdate = a, b, c
        end
        volume = tonumber(volume) or 1.0

        if not skipLocalUpdate then
            soundHandler.volume = volume
            soundHandler.previousVolume = volume
        end

        if soundHandler.isCreated then
            SendNUIMessage({
                type = "volume",
                identifier = tostring(soundHandler.identifier),
                volume = volume,
                update = sendUpdate
            })
        end
    end

    soundHandler.SetTimestamp = function(a, b)
        local timestamp = (a == soundHandler and b ~= nil) and b or a
        soundHandler.timestamp = tonumber(timestamp) or 0

        if soundHandler.isCreated then
            SendNUIMessage({
                type = "timestamp",
                identifier = tostring(soundHandler.identifier),
                timestamp = soundHandler.timestamp
            })
        end
    end

    soundHandler.GetTimestamp = function()
        return soundHandler.timestamp
    end

    soundHandler.SetPlayingDistance = function(a, b)
        local distance = (a == soundHandler and b ~= nil) and b or a
        soundHandler.distance = tonumber(distance) or 10

        if soundHandler.isCreated then
            SendNUIMessage({
                type = "distance",
                identifier = tostring(soundHandler.identifier),
                distance = soundHandler.distance
            })
        end
    end

    soundHandler.GetPlayingDistance = function()
        return soundHandler.distance
    end

    soundHandler.SetPlayingPosition = function(a, b)
        local position = (a == soundHandler and b ~= nil) and b or a
        if type(position) == "vector3" or (type(position) == "table" and position.x and position.y and position.z) then
            soundHandler.position = position
        end

        if soundHandler.isCreated then
            local p = soundHandler.position or { x = 0, y = 0, z = 0 }
            SendNUIMessage({
                type = "positionSound",
                identifier = tostring(soundHandler.identifier),
                pos = { tonumber(p.x) or 0.0, tonumber(p.y) or 0.0, tonumber(p.z) or 0.0 }
            })
        end
    end

    soundHandler.GetPlayingPosition = function()
        return soundHandler.position
    end

    soundHandler.Play = function()
        SendNUIMessage({
            type = "play",
            identifier = tostring(soundHandler.identifier)
        })
    end

    soundHandler.Pause = function()
        SendNUIMessage({
            type = "pause",
            identifier = tostring(soundHandler.identifier)
        })
    end

    soundHandler.Resume = function()
        SendNUIMessage({
            type = "resume",
            identifier = tostring(soundHandler.identifier)
        })
    end

    soundHandler.IsPlaying = function()
        return soundHandler.isPlaying
    end

    soundHandler.SetPlayingStatus = function(isPlaying)
        soundHandler.isPlaying = isPlaying
    end

    soundHandler.CreateMedia = function(a, b)
        local silentEvent = (a == soundHandler and b ~= nil) and b or (a ~= soundHandler and a or nil)
        soundHandler.CreateMediaCreated = true

        local p = soundHandler.position or { x = 0, y = 0, z = 0 }
        local posX = tonumber(p.x) or 0.0
        local posY = tonumber(p.y) or 0.0
        local posZ = tonumber(p.z) or 0.0

        SendNUIMessage({
            type = "create",
            identifier = tostring(soundHandler.identifier),
            URL = tostring(soundHandler.soundUrl or ""),
            pos = { posX, posY, posZ },
            distance = tonumber(soundHandler.distance) or 10,
            loop = soundHandler.loop == true,
            volume = tonumber(soundHandler.volume) or 1.0,
            silentEvent = silentEvent,
            autoplay = soundHandler.autoplay == true
        })

        soundInfo[identifier] = soundHandler
    end

    soundHandler.SetCreatedStatus = function(isCreated)
        soundHandler.isCreated = isCreated
    end

    soundHandler.IsCreated = function()
        return soundHandler.isCreated
    end

    soundHandler.WasCreatedFunctionCalled = function()
        return soundHandler.CreateMediaCreated
    end

    soundHandler.DeleteMedia = function(keepCreateFlag)
        SendNUIMessage({
            type = "delete",
            identifier = soundHandler.identifier
        })

        if not keepCreateFlag then
            soundHandler.CreateMediaCreated = false
        end

        soundHandler.SetCreatedStatus(false)
        soundHandler.SetPlayingStatus(false)
    end

    soundHandler.Destroy = function()
        soundHandler.DeleteMedia()
        soundInfo[soundHandler.identifier] = nil
    end

    return soundHandler, identifier
end
