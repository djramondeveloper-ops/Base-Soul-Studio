-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 118 lines → Cleaned: 46 lines
-- =====================================================

InteractionService = {}

function InteractionService.updateStorage(storageData)
    if not storageData then return end
    
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return dbg.critical("Client storage is not available") end
    
    storage.updateStorage(storageData)
end

function InteractionService.updateStorageSpecific(playerId, data, key)
    if not playerId or not key then return end
    
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return dbg.critical("Client storage is not available") end
    
    storage.updateStorageSpecific(playerId, data, key)
end

function InteractionService.isPlayerZiptied(playerId)
    playerId = playerId or MyServerId
    
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isPlayerZiptied(playerId)
end

function InteractionService.isCuffed(playerId)
    playerId = playerId or MyServerId
    
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isCuffed(playerId)
end

function InteractionService.isEscorted(playerId)
    playerId = playerId or MyServerId
    
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isEscorted(playerId)
end
