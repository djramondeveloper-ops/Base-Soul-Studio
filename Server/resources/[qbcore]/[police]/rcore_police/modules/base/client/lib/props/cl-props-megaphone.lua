-- =====================================================
--  rcore_police · modules/base/client/lib/props/cl-props-megaphone.lua
--  Engineered by Eazy Fxap
--  Original: 180 lines → Cleaned: 60 lines
-- =====================================================

MEGAPHONE_KEYS = {
    { key = Config.Megaphone.TurnKey, label = _U("MEGA_PHONE.TURN_STATE") },
    { key = Config.Megaphone.ExitKey, label = _U("MEGA_PHONE.EXIT") },
    { key = "", label = _U("MEGA_PHONE.IS_OFF") }
}

function Props.RequestMegaPhone(model)
    local ped = PlayerPedId()
    
    if GetVehiclePedIsIn(ped, false) ~= 0 and DoesEntityExist(GetVehiclePedIsIn(ped, false)) then
        return Framework.sendNotification(_U("MEGAPHONE_NOT_USEABLE_IN_VEHICLE"), "error")
    end
    
    if Interactions.MegaPhone.state then
        Interactions.MegaPhone.state = false
        if DoesEntityExist(Interactions.MegaPhone.entity) then
            DeleteEntity(Interactions.MegaPhone.entity)
        end
        ClearPedTasksImmediately(ped, true)
        ClearProximity()
        dbg.debug("Removing megaphone from player ped hands!")
        IsPropSessionActive = false
        UI.HelpKeys(nil, false)
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        return
    end
    
    UtilsService.LoadAnimationDict("amb@world_human_mobile_film_shocking@female@base")
    
    local coords = GetEntityCoords(ped)
    local heading = (GetEntityHeading(ped) + 90) % 360
    
    local entity = UtilsService.SpawnObject(model, coords, true, true)
    SetEntityHeading(entity, heading)
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 80.0, true, true, false, true, 1, true)
    
    TaskPlayAnim(ped, "amb@world_human_mobile_film_shocking@female@base", "base", 8.0, -8.0, -1, MOVEMENT_FLAG.MOVE_ALL_BODY, 0, 0, 0, 0)
    
    UI.HelpKeys({ keys = MEGAPHONE_KEYS }, true)
    IsPropSessionActive = false
    Interactions.MegaPhone.state = true
    Interactions.MegaPhone.entity = entity
end
