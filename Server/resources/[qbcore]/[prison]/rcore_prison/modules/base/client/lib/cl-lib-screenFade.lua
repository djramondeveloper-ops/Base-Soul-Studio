local registerNetEvent = NetworkService.RegisterNetEvent

local function handleScreenFadeIn(shouldFade, duration)
    if not shouldFade then
        return
    end

    dbg.debug("Screen fade in request received!")
    DoScreenFadeIn(duration)
end

registerNetEvent("screenFadeIn", handleScreenFadeIn)

local function handleScreenFadeOut(shouldFade, duration)
    if not shouldFade then
        return
    end

    dbg.debug("Screen fade out request received!")
    DoScreenFadeOut(duration)
end

registerNetEvent("screenFadeOut", handleScreenFadeOut)