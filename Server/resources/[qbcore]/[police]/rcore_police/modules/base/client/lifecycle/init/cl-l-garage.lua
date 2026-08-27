-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-garage.lua
--  Engineered by Eazy Fxap
--  Original: 115 lines → Cleaned: 46 lines
-- =====================================================

NetworkService.RegisterNetEvent("checkDepartmentGarageSpawnPoint", function(success, garageData, vehicleModel, vehiclePrice)
    if not success then return end
    
    dbg.debug("TrySpawnVehicle: Checking for free parking space, to retrieve vehicle from garage!")
    
    Garage.GetFreeSpawnPoint(garageData, function(spawnPoint)
        if not spawnPoint then
            dbg.debug("TrySpawnVehicle: Failed to find any free parking space!")
            Framework.sendNotification(_U("GARAGE.NOT_FREE_PARKING_SPACE"), "error")
            TriggerServerEvent("rcore_police:server:unregisterVehicleSession")
            return
        end
        
        if Config.Garage.NeedsToBuyVehiclesInGarages then
            TriggerServerEvent("rcore_police:server:requestVehicleFromStorage", {
                coords = spawnPoint,
                model = vehicleModel
            })
            return
        end
        
        if Config.Garage.DepartmentsEnableBuyVehicles then
            local payDialog = UI.PayDialog({
                title = _U("GARAGE.PAYDIALOG_TITLE", vehiclePrice),
                desc = _U("GARAGE.PAYDIALOG_DESC")
            })
            
            if payDialog then
                if payDialog.action then
                    TriggerServerEvent("rcore_police:server:requestBuyDepartmentVehicle", {
                        paymentMethod = payDialog.action,
                        coords = spawnPoint,
                        model = vehicleModel
                    })
                else
                    TriggerServerEvent("rcore_police:server:unregisterVehicleSession")
                end
            end
        else
            HandleSpawnVehicle(spawnPoint, vehicleModel)
        end
    end)
end)

NetworkService.RegisterNetEvent("spawnVehicle", function(success, coords, model)
    if success then
        HandleSpawnVehicle(coords, model)
    end
end)
