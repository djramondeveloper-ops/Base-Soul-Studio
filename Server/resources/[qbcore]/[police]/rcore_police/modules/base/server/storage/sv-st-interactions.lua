-- =====================================================
--  rcore_police · modules/base/server/storage/sv-st-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 386 lines → Cleaned: 116 lines
-- =====================================================

function InteractionStorage()
    local self = {}
    self.storage = {}
    
    RegisterCommand("svStorage", function(src)
        if next(self.storage) then
            tprint(self.storage)
        end
    end)
    
    function self.clearPlayerStorage(src)
        if not src then return end
        
        local srcStr = tostring(src)
        if not self.storage[srcStr] then return end
        
        self.storage[srcStr] = nil
        dbg.debug("Cleared player interaction storage: %s (%s)", src, GetPlayerName(src))
        self.syncStorageSpecific(srcStr, nil, nil)
    end
    
    function self.syncStorageSpecific(src, data, key)
        StartClient(-1, "syncSpecificStorage", src, data, key)
    end
    
    function self.syncToAllPLayers()
        -- Intentionally empty in original source
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
    
    function self.hasState(src, key)
        if not src or not key then return false end
        
        local srcStr = tostring(src)
        if not self.storage[srcStr] then return false end
        if not self.storage[srcStr][key] then return false end
        
        TriggerLocalServerEvent("onState", "hasState", key, src)
        return true, self.storage[srcStr][key]
    end
    
    function self.addState(src, key, data)
        if not src then return end
        
        local srcStr = tostring(src)
        if not self.storage[srcStr] then
            self.storage[srcStr] = {}
        end
        
        dbg.debug("Adding player %s to storage with action: %s", src, key)
        
        local stateData = {}
        if data then
            stateData = { type = data }
        end
        
        TriggerLocalServerEvent("onState", "add", key, src)
        self.storage[srcStr][key] = stateData
        self.syncStorageSpecific(srcStr, stateData, key)
    end
    
    function self.removeState(src, key)
        if not src then return end
        
        local srcStr = tostring(src)
        if not self.storage[srcStr] then return end
        if not self.storage[srcStr][key] then return end
        
        local storageSize = table.size(self.storage[srcStr])
        
        TriggerLocalServerEvent("onState", "remove", key, src)
        dbg.debug("Removing player %s from storage with action: %s", src, key)
        
        self.storage[srcStr][key] = nil
        if storageSize <= 1 then
            self.storage[srcStr] = nil
        end
        
        self.syncStorageSpecific(srcStr, nil, key)
    end
    
    function self.updateState(src, key, data)
        if not src then return end
        
        local srcStr = tostring(src)
        if not self.storage[srcStr] then return end
        
        local stateData = {}
        if data then
            stateData = { type = data }
        end
        
        TriggerLocalServerEvent("onState", "update", key, src)
        dbg.debug("Registering player %s in storage with action: %s", src, key)
        
        self.storage[srcStr][key] = stateData
        self.syncStorageSpecific(srcStr, stateData, key)
    end
    
    function self.isCuffed(src)
        if not src then return false end
        return self.hasState(src, "CUFF_STATE")
    end
    
    function self.isEscorted(src)
        if not src then return false end
        return self.hasState(src, "ESCORT_STATE")
    end
    
    function self.isHeadBagged(src)
        if not src then return false end
        return self.hasState(src, "PAPERBAG_STATE")
    end
    
    return self
end

Object.registerStorage(STORAGE_INTERACTIONS, InteractionStorage())
