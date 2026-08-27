-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-vehicle.lua
--  Engineered by Eazy Fxap
--  Original: 62 lines → Cleaned: 24 lines
-- =====================================================

NetworkService.RegisterNetEvent("handleVehicleTask", function(success, action, vehicle, data)
    if not success then return end
    if not DoesEntityExist(vehicle) then return end
    
    dbg.debug("handleVehicleTask named %s -> for vehicle %s", action, GetEntityArchetypeName(vehicle))
    
    if action == MENU_ACTIONS.IMPOUND_VEHICLE then
        ImpoundVehicle(vehicle, data.owned, data.netId)
    elseif action == MENU_ACTIONS.SHOW_VEHICLE_INFORMATION then
        ShowVehicleInformation(vehicle, data)
    elseif action == MENU_ACTIONS.UNLOCK_VEHICLE then
        UnlockVehicle(vehicle, data)
    end
end)
