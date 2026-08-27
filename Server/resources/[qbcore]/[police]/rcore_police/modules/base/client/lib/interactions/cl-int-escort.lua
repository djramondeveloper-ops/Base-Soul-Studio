-- =====================================================
--  rcore_police · modules/base/client/lib/interactions/cl-int-escort.lua
--  Engineered by Eazy Fxap
--  Original: 281 lines → Cleaned: 85 lines
-- =====================================================

function Interactions.SetCitizenEscort(escortData, targetData)
    local ped = PlayerPedId()
    local initiatorPed = UtilsService.GetPlayerPedFromServerId(escortData)
    
    if not initiatorPed then return end
    
    if escortData == ped then
        return print("You cant escort yourself!")
    end
    
    if Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE then
        return Interactions.StopCitizenEscort(ped)
    end
    
    if IsEntityAttached(ped) then
        DetachEntity(ped, false, false)
    end
    
    if Interactions.Cuff.TARGET_PLAYER_CUFF_STATE then
        Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = false
    end
    
    if escortEscape then
        escortEscape = false
    end
    
    UI.StopMinigame()
    
    if not IsPedCuffed(ped) then
        UtilsService.LoadAnimationDict("mp_arresting")
    end
    
    dbg.debug("Loading escort on citizen.")
    UtilsService.LoadAnimationDict("anim@move_m@prisoner_cuffed")
    TriggerEvent("rcore_police:client:listener", { action = "ESCORT", state = true })
    
    Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE = true
    
    local isDead = Player(escortData or UtilsService.GetServerIdFromPed(ped)).state.rcorePoliceDead
    if targetData and targetData.targetDeath then isDead = true end
    
    if isDead then
        UtilsService.LoadAnimationDict("nm")
        AttachEntityToEntity(ped, initiatorPed, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
        TaskPlayAnim(ped, "nm", "firemans_carry", 8.0, -8.0, -1, 33, 0, false, false, false)
    else
        if not IsPedCuffed(ped) and Config.Escort.BreakWhenNotCuffsOn then
            UI.HelpKeys({ keys = { { key = Config.Escort.BreakWhenNotCuffsOnKey, label = _U("ATTEMPT_BREAK_LABEL") } } }, true)
        end
    end
    
    Interactions.Escort.Session = {
        initiatorPlayerId = escortData,
        initiatorPed = initiatorPed,
        targetPed = ped,
        targetServerId = UtilsService.GetServerIdFromPed(ped),
        targetDead = targetData and targetData.targetDeath or false,
        initiatorDead = targetData and targetData.initiatorDeath or false,
        animDict = "anim@move_m@prisoner_cuffed",
        animName = "walk"
    }
    
    if not (targetData and targetData.targetDeath) and not isDead then
        UtilsService.AttachFromPedToTarget(initiatorPed, ped)
    end
end

function Interactions.StopCitizenEscort(ped)
    if not Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE then
        return dbg.debug("StopCitizenEscort: Not found any active session, canceling action.")
    end
    
    local plyPed = PlayerPedId()
    DetachEntity(plyPed, false, false)
    DetachEntity(ped, false, false)
    
    Interactions.Escort.TARGET_PLAYER_ESCORT_CITIZEN_STATE = false
    Interactions.Escort.Session = nil
    
    TriggerEvent("rcore_police:client:listener", { action = "ESCORT", state = false })
    
    if InteractionService.isCuffed() then
        Interactions.Cuff.TARGET_PLAYER_CUFF_STATE = true
    end
    
    if escortEscape then
        escortEscape = false
    end
    
    if not IsPedCuffed(ped) and Config.Escort.BreakWhenNotCuffsOn then
        UI.HelpKeys(nil, false)
    end
    
    dbg.debug("StopCitizenEscort: Removing escort from you, since initiator has done it.")
end
