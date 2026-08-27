-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-sounds.lua
--  Engineered by Eazy Fxap
--  Original: 204 lines → Cleaned: 80 lines
-- =====================================================

function Sounds.PlayHandcuff(coords)
    local soundName = "rcore_basic_handcuff"
    coords = coords or GetEntityCoords(PlayerPedId())
    
    local xSoundStr = string.format("%s_%s", MyServerId, "cuff")
    
    if isResourcePresentProvideless("xsound") then
        exports.xsound:PlayUrlPos(xSoundStr, "https://rco.re/product/rcore_police/sounds/cuff.mp3", 0.1, coords, false)
        exports.xsound:Distance(xSoundStr, 10.0)
    else
        while not RequestScriptAudioBank("audiodirectory/basic", false) do
            Wait(0)
        end
        local soundId = GetSoundId()
        PlaySoundFromCoord(soundId, soundName, coords.x, coords.y, coords.z, "rcore_police", false, 0, false)
        ReleaseSoundId(soundId)
        ReleaseNamedScriptAudioBank("audiodirectory/basic")
    end
end

function Sounds.PlayUncuff(coords)
    local soundName = "rcore_basic_unlock"
    coords = coords or GetEntityCoords(PlayerPedId())
    
    local xSoundStr = string.format("%s_%s", MyServerId, "uncuff")
    
    if isResourcePresentProvideless("xsound") then
        exports.xsound:PlayUrlPos(xSoundStr, "https://rco.re/product/rcore_police/sounds/uncuff.mp3", 0.1, coords, false)
        exports.xsound:Distance(xSoundStr, 10.0)
    else
        while not RequestScriptAudioBank("audiodirectory/basic", false) do
            Wait(0)
        end
        local soundId = GetSoundId()
        PlaySoundFromCoord(soundId, soundName, coords.x, coords.y, coords.z, "rcore_police", false, 0, false)
        ReleaseSoundId(soundId)
        ReleaseNamedScriptAudioBank("audiodirectory/basic")
    end
end

function Sounds.PlaySpeedCamera(coords)
    local soundName = "GENERIC_CAMERA_FLASH"
    coords = coords or GetEntityCoords(PlayerPedId())
    
    while not RequestScriptAudioBank("SCRIPT/Distant_Camera_Flash", false) do
        Wait(0)
    end
    
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, soundName, coords.x, coords.y, coords.z, nil, false, 0, false)
    ReleaseSoundId(soundId)
    ReleaseNamedScriptAudioBank("SCRIPT/Distant_Camera_Flash")
end
