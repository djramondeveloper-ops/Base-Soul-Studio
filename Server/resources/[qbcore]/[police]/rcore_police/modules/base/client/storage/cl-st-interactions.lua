-- =====================================================
--  rcore_police · modules/base/client/storage/cl-st-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 184 lines → Cleaned: 61 lines
-- =====================================================

function InteractionStorage()
    local self = {}
    self.storage = {}

    RegisterCommand("clStorage", function(src)
        if self.storage and next(self.storage) then
            tprint(self.storage)
        end
    end)

    function self.hasState(src, key)
        if not src or not key then return false end
        local srcStr = tostring(src)
        
        if not self.storage[srcStr] then return false end
        if not self.storage[srcStr][key] then return false end
        
        return true
    end

    function self.updateStorageSpecific(src, data, key)
        local srcStr = tostring(src)
        
        if not self.storage[srcStr] then
            self.storage[srcStr] = {}
        end
        
        if data then
            self.storage[srcStr][key] = data
        else
            self.storage[srcStr][key] = nil
        end
    end

    function self.updateStorage(storageData)
        self.storage = storageData
        if IsInDev then
        end
    end

    function self.isPlayerZiptied(src)
        if not src then return false end
        local srcStr = tostring(src)
        
        if not self.storage[srcStr] then return false end
        
        local cuffState = self.storage[srcStr].CUFF_STATE
        if not cuffState then return false end
        
        if cuffState.type == "ziptie" then
            return true
        end
        return false
    end

    function self.isCuffed(src)
        if not src then return false end
        return self.hasState(src, "CUFF_STATE")
    end

    function self.isEscorted(src)
        if not src then return false end
        return self.hasState(src, "ESCORT_STATE")
    end

    return self
end

Object.registerStorage(STORAGE_INTERACTIONS, InteractionStorage())
