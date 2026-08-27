-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-emergency.lua
--  Engineered by Eazy Fxap
--  Original: 99 lines → Cleaned: 40 lines
-- =====================================================

NetworkService.RegisterNetEvent("RenderEmergencyBlip", function(success, coords, callName)
    if not success then return end

    local blipCfg = Config.EmergencyCall.Blip
    local alpha = 250

    if Config.EmergencyCall.PlaySound then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        dbg.debug("Emergency call: Playing sound name Lose_1st from audio bank named GTAO_FM_Events_Soundset, if you cant hear it then you hit audio bank limit!!!")
    end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipCfg.Sprite)
    SetBlipColour(blip, blipCfg.Colour)
    SetBlipDisplay(blip, blipCfg.Display)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, blipCfg.Scale)
    SetBlipAsShortRange(blip, false)
    PulseBlip(blip)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(callName)
    EndTextCommandSetBlipName(blip)

    while alpha > 0 do
        Wait(720)
        alpha = alpha - 1
        SetBlipAlpha(blip, alpha)
        if alpha <= 0 then
            RemoveBlip(blip)
        end
    end
end)
