-- =====================================================
--  rcore_police · modules/base/server/storage/sv-st-garage.lua
--  Engineered by Eazy Fxap
--  Original: 200 lines → Cleaned: 81 lines
-- =====================================================

function GarageStorage()
    local self = {}
    self.storage = {}
    
    RegisterCommand("svGarageStorage", function(src)
        if next(self.storage) then
            tprint(self.storage)
        end
    end)
    
    function self.getKVPKey(jobName)
        return ("%s_%s_%s"):format(GetCurrentResourceName(), jobName, "garage")
    end
    
    function self.syncKVP(jobName, amount)
        local key = self.getKVPKey(jobName)
        if key then
            SetResourceKvpInt(key, amount)
        else
            dbg.critical("Storage for garage, failed to sync since key doesnt exist for job: %s", jobName)
        end
    end
    
    function self.getAmountFromKVP(jobName)
        local key = self.getKVPKey(jobName)
        local val = GetResourceKvpInt(key)
        local status = "UNDEFINED_KVP"
        
        if val > 0 then
            status = "DEFINED_KVP"
        else
            val = 0
        end
        
        return val, status
    end
    
    function self.registerStorage()
        for jobName, _ in pairs(Config.JobGroups) do
            local amount, status = self.getAmountFromKVP(jobName)
            if status then
                dbg.debug("Garage register for group %s status code: %s", jobName, status)
            end
            self.storage[jobName] = amount
        end
    end
    
    function self.addVehicleCount(jobName, amount)
        if not self.storage[jobName] then
            return dbg.critical("Storage for job %s doesnt exist, failed to add vehicle count", jobName)
        end
        
        local newAmount = self.storage[jobName] + amount
        dbg.debug("Garage storage: Add vehicle count for job %s with new amount: %s", jobName, newAmount)
        
        self.storage[jobName] = newAmount
        self.syncKVP(jobName, newAmount)
        GroupsService.UpdateGlobalState(jobName)
    end
    
    function self.removeVehicleCount(jobName, amount)
        if not self.storage[jobName] then
            return dbg.critical("Storage for job %s doesnt exist, failed to remove vehicle count", jobName)
        end
        
        local newAmount = self.storage[jobName] - amount
        dbg.debug("Garage storage: Removing vehicle count for job %s with new amount: %s", jobName, newAmount)
        
        self.storage[jobName] = newAmount
        self.syncKVP(jobName, newAmount)
        GroupsService.UpdateGlobalState(jobName)
    end
    
    function self.getVehicleCount(jobName)
        if not jobName then return 0 end
        if not self.storage[jobName] then return 0 end
        return self.storage[jobName]
    end
    
    return self
end

Object.registerStorage(STORAGE_GARAGE, GarageStorage())
