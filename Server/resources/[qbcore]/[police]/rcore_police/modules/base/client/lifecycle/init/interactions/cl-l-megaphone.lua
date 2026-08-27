-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-megaphone.lua
--  Engineered by Eazy Fxap
--  Original: 238 lines → Cleaned: 72 lines
-- =====================================================

local MEGAPHONE_WAIT = 250
local MEGAPHONE_ANIM_DICT = "amb@world_human_mobile_film_shocking@female@base"
local MEGAPHONE_ANIM_NAME = "base"
local megaphoneActive = false

CreateThread(function()
    UtilsService.LoadAnimationDict(MEGAPHONE_ANIM_DICT)
    while true do
        Wait(MEGAPHONE_WAIT)
        if Interactions.MegaPhone.state then
            local ped = PlayerPedId()
            DisablePlayerFiring(PlayerId(), true)
            if not IsEntityPlayingAnim(ped, MEGAPHONE_ANIM_DICT, MEGAPHONE_ANIM_NAME, 3) then
                TaskPlayAnim(ped, MEGAPHONE_ANIM_DICT, MEGAPHONE_ANIM_NAME, 8.0, -8, -1, MOVEMENT_FLAG.MOVE_ALL_BODY, 0, 0, 0, 0)
            end
        end
    end
end)

function IsTargetUsingMegaphone(ped)
    if not ped then return false end
    return IsEntityPlayingAnim(ped, MEGAPHONE_ANIM_DICT, MEGAPHONE_ANIM_NAME, 3)
end

function ClearProximity()
    if isResourcePresentProvideless(THIRD_PARTY_RESOURCE.PMA_VOICE) then
        exports["pma-voice"]:clearProximityOverride()
    end
end

local function setMegaphoneKeyActive()
    local entry = { label = _U("MEGA_PHONE.IS_ON"), key = "" }
    if MEGAPHONE_KEYS[3] then
        MEGAPHONE_KEYS[3].label = entry.label
        MEGAPHONE_KEYS[3].key = entry.key
        dbg.debug("Updated third MEGAPHONE_KEY")
    end
end

function HandleOverrideProximity()
    if not Config.Megaphone.Enable then return end
    if not Interactions.MegaPhone.state then return end
    
    megaphoneActive = not megaphoneActive
    
    if isResourcePresentProvideless(THIRD_PARTY_RESOURCE.PMA_VOICE) then
        dbg.debug("Setting proximity range since having megaphone!")
        
        if megaphoneActive then
            setMegaphoneKeyActive()
            exports["pma-voice"]:overrideProximityRange(Config.Megaphone.HearRangeRadius or 50.0, megaphoneActive)
        else
            ClearProximity()
            if MEGAPHONE_KEYS[3] then
                MEGAPHONE_KEYS[3].label = _U("MEGA_PHONE.IS_OFF")
                MEGAPHONE_KEYS[3].key = ""
                dbg.debug("Updated third MEGAPHONE_KEY to inactive")
            end
        end
        
        UI.HelpKeys({ keys = MEGAPHONE_KEYS }, true)
    end
end

function ExitMegaphone()
    if Interactions.MegaPhone.state then
        Props.RequestMegaPhone()
    end
end

if Config.Megaphone.Enable then
    RegisterKey(HandleOverrideProximity, "RCORE_POLICE_INTERACT_MEGAPHONE", _U("KEY_MAPPING.MEGAPHONE_STATE"), Config.Megaphone.TurnKey, nil, { state = true, cooldown = 1000 })
    RegisterKey(ExitMegaphone, "RCORE_POLICE_INTERACT_MEGAPHONE_EXIT", _U("KEY_MAPPING.MEGAPHONE_EXIT"), Config.Megaphone.ExitKey, nil, { state = true, cooldown = 1000 })
end
