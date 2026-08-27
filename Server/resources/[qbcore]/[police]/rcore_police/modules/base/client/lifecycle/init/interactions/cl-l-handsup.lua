-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-handsup.lua
--  Engineered by Eazy Fxap
--  Original: 275 lines → Cleaned: 72 lines
-- =====================================================

local handsUpCooldownTimer = nil
local handsUpState = false
local handsUpDict = HANDS_UP.DICT
local handsUpName = HANDS_UP.NAME
local handsUpFlag = 50
local handsUpAnims = Config.Handsup.Animations
local hasQBSmallResources = false

CreateThread(function()
    table.insert(handsUpAnims, { dict = handsUpDict, name = handsUpName })
    if isResourcePresentProvideless("qb-smallresources") then
        hasQBSmallResources = true
    end
end)

function GetHandsUPState(targetServerId)
    local ped = targetServerId and UtilsService.GetPlayerPedFromServerId(targetServerId) or PlayerPedId()
    if not ped then return handsUpState end
    
    if handsUpAnims and next(handsUpAnims) then
        for _, anim in ipairs(handsUpAnims) do
            if anim.dict ~= "" and anim.name ~= "" then
                if IsEntityPlayingAnim(ped, anim.dict, anim.name, 3) then
                    return true
                end
            end
        end
    end
    return false
end

function HandleHandsUP()
    local cooldown = Config.Handsup.CooldownTime
    local now = GetGameTimer()
    
    if not Config.Handsup.Enable then
        return dbg.debug("Handsup - Player want to use it, but its disabled in config.lua!")
    end
    if hasQBSmallResources then
        return dbg.debug("Handsup - Disabling use of our hands up feature, since detected qb/qbx small resources!")
    end
    if IsBusy then return end
    
    if Config.Handsup.EnableCooldown and handsUpCooldownTimer then
        if cooldown > (now - handsUpCooldownTimer) then return end
    end
    
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(vehicle) then return end
    if not IsPedOnFoot(ped) then return end
    if IsPedCuffed(ped) then return end
    if GetKneeState() then return end
    if InteractionService.isEscorted() then return end
    
    handsUpState = not handsUpState
    
    if not handsUpState then
        if IsEntityPlayingAnim(ped, handsUpDict, handsUpName, 3) then
            Utils.Handsup.Exit(ped)
            return
        end
    end
    
    handsUpCooldownTimer = GetGameTimer()
    UtilsService.LoadAnimationDict(handsUpDict)
    TaskPlayAnim(ped, handsUpDict, handsUpName, 8.0, -8.0, -1, handsUpFlag, 0, false, false, false)
    
    while handsUpState do
        Wait(250)
        if not handsUpState then break end
        
        -- Auto-disable if cuffed or escorted
        if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE or Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE then
            handsUpState = false
            break
        end
        
        -- Ensure anim keeps playing
        if not IsEntityPlayingAnim(ped, handsUpDict, handsUpName, 3) then
            TaskPlayAnim(ped, handsUpDict, handsUpName, 8.0, -8.0, -1, handsUpFlag, 0, false, false, false)
        end
    end
end

RegisterKey(HandleHandsUP, "RCORE_POLICE_HANDSUP", _U("KEY_MAPPING.HANDS_UP"), Config.Handsup.Key or "X")
