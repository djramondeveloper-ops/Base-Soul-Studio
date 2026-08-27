-- =====================================================
--  rcore_police · modules/base/server/services/sv-se-garage.lua
--  Engineered by Eazy Fxap
--  Original: 141 lines → Cleaned: 49 lines
-- =====================================================

GarageService = {}

function GarageService.OrderedVehicles(jobName, amount, src)
    local storage = Object.getStorage(STORAGE_GARAGE)
    if not storage then return end
    
    dbg.debug("Adding OrderedVehicles for job: %s with amount %s by user: %s", jobName, amount, GetPlayerName(src))
    storage.addVehicleCount(jobName, amount)
end

function GarageService.RegisterInitGroups()
    local storage = Object.getStorage(STORAGE_GARAGE)
    if not storage then return end
    
    storage.registerStorage()
end

function GarageService.ReturnedVehicle(jobName)
    local storage = Object.getStorage(STORAGE_GARAGE)
    if not storage then return end
    
    storage.addVehicleCount(jobName, 1)
end

function GarageService.GetStockCount(jobName)
    local storage = Object.getStorage(STORAGE_GARAGE)
    if not storage then return 0 end
    
    return storage.getVehicleCount(jobName)
end

function GarageService.RequestVehicleFromGarage(src, jobName, spawnData, model)
    local storage = Object.getStorage(STORAGE_GARAGE)
    if not storage then return end
    
    local count = storage.getVehicleCount(jobName)
    if count and count > 0 then
        dbg.debug("Requested vehicles from department garage, found enough vehicles!")
        storage.removeVehicleCount(jobName, 1)
        
        spawnVehicleSessions[src].paymentMethod = PAYMENT_METHODS.COMPANY
        StartClient(src, "spawnVehicle", model, spawnData)
        Framework.sendNotification(src, _U("GARAGE.GARAGE_REQUEST_VEH_SUCC"), "success")
    else
        dbg.debug("Requested vehicles from department garage failed, not enough vehicles")
        Framework.sendNotification(src, _U("GARAGE.GARAGE_REQUEST_VEH_FAILURE"), "error")
    end
end
