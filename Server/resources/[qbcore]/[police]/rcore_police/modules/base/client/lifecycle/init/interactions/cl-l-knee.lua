-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-knee.lua
--  Engineered by Eazy Fxap
--  Original: 177 lines → Cleaned: 56 lines
-- =====================================================

local kneeCooldownTimer = nil
local kneeState = false
local kneeDict = KNEE.DICT
local kneeName = KNEE.NAME
local kneeFlag = 10

function GetKneeState()
    local ped = PlayerPedId()
    return IsEntityPlayingAnim(ped, kneeDict, kneeName, 3) or kneeState
end

function HandleKneeState()
    local cooldown = Config.Knee.CooldownTime
    local now = GetGameTimer()
    
    if not Config.Knee.Enable then
        return dbg.debug("Knee is not enabled")
    end
    
    if Config.Knee.EnableCooldown and kneeCooldownTimer then
        if cooldown > (now - kneeCooldownTimer) then return end
    end
    
    local ped = PlayerPedId()
    if IsPedCuffed(ped) then return end
    if InteractionService.isEscorted() then return end
    
    kneeState = not kneeState
    
    if not kneeState then
        if IsEntityPlayingAnim(ped, kneeDict, kneeName, 3) then
            return ClearPedTasksImmediately(ped)
        end
    end
    
    kneeCooldownTimer = GetGameTimer()
    UtilsService.LoadAnimationDict(kneeDict)
    TaskPlayAnim(ped, kneeDict, kneeName, 8.0, -8.0, -1, kneeFlag, 3.0, false, false, false)
    
    while kneeState do
        Wait(250)
        if not kneeState then
            kneeState = false
            break
        end
        
        -- Auto-disable if cuffed or escorted
        if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE or Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE then
            kneeState = false
            break
        end
        
        -- Ensure anim keeps playing
        if not IsEntityPlayingAnim(ped, kneeDict, kneeName, 3) then
            TaskPlayAnim(ped, kneeDict, kneeName, 8.0, -8.0, -1, kneeFlag, 3.0, false, false, false)
        end
    end
end

RegisterCommand("knee", function() HandleKneeState() end, false)
