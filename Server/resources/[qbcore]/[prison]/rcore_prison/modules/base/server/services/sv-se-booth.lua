BoothService = BoothService or {}

local function getBoothStorage()
    return Object.getStorage(STORAGE_BOOTH)
end

function BoothService.GetBooth(number)
    local boothStorage = getBoothStorage()
    if not boothStorage then
        return
    end

    local invokingResource = GetInvokingResource() or "Internal script heartbeat"

    dbg.debug(
        "BoothStorage: Was invoked by resource named %s - checking number if its phone booth: %s",
        invokingResource,
        number
    )

    return boothStorage.getBooth(number)
end

exports("GetBooth", BoothService.GetBooth)

function BoothService.CanCall(number)
    local booth = BoothService.GetBooth(number)
    if not booth then
        return false, "BOOTH_NOT_FOUND"
    end

    if booth.state ~= CALL_ENUMS.IDLE then
        return false, "BOOTH_NOT_IDLE"
    end

    local activeCallCount = booth.callData and table.size(booth.callData) or 0
    if activeCallCount > 0 then
        return false, "BOOTH_ACTIVE_CALL"
    end

    if not booth.playerId then
        return false, "BOOTH_PLAYER_NOT_FOUND"
    end

    return true, "CAN_DO_CALL", booth.playerId
end

exports("GetBoothCallState", BoothService.CanCall)

function BoothService.IsOcuppied(number, playerId)
    local booth = BoothService.GetBooth(number)
    if not booth then
        return false, "NOT_ACTIVE"
    end

    if not booth.playerId then
        return false, "ACTIVE"
    end

    if booth.playerId ~= playerId then
        return false, "ACTIVE"
    end

    return true
end

function BoothService.SendHeartbeat(eventName, callback, ...)
    local payload = ...

    TriggerEvent("rcore_prison:server:booth:HeartBeat", eventName, payload, function(response)
        callback(response)
    end)
end

function BoothService.Register(booths)
    local boothStorage = getBoothStorage()
    if not boothStorage or not booths then
        return
    end

    for _, boothData in pairs(booths) do
        local booth = BoothModel()
        booth.number = boothData.number
        booth.coords = vec3(boothData.coords.x, boothData.coords.y, boothData.coords.z)

        boothStorage.registerBooth(booth)
    end
end
