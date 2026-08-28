function BoothModel()
    return {
        playerId = nil,
        state = CALL_ENUMS.IDLE,
        number = nil,
        coords = vec3(0, 0, 0),
        callData = {}
    }
end
