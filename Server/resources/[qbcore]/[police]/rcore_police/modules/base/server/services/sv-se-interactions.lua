-- =====================================================
--  rcore_police · modules/base/server/services/sv-se-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 197 lines → Cleaned: 64 lines
-- =====================================================

InteractionService = {}

function InteractionService.addState(src, key, data)
    if not src then return end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return end
    
    storage.addState(src, key, data)
end

function InteractionService.removeState(src, key, data)
    if not src then return end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return end
    
    storage.removeState(src, key, data)
end

function InteractionService.updateState(src, key, data)
    if not src then return end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return end
    
    storage.updateState(src, key, data)
end

function InteractionService.isCuffed(src)
    if not src then return false end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isCuffed(src)
end

function InteractionService.isEscorted(src)
    if not src then return false end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isEscorted(src)
end

function InteractionService.isHeadBagged(src)
    if not src then return false end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isHeadBagged(src)
end

function InteractionService.isPlayerZiptied(src)
    if not src then return false end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return false end
    
    return storage.isPlayerZiptied(src)
end

function InteractionService.HasPlayerState(src, key)
    if not src or not key then return nil end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return nil end
    
    return storage.hasState(src, key)
end

function InteractionService.clearPlayerStorage(src)
    if not src then return end
    local storage = Object.getStorage(STORAGE_INTERACTIONS)
    if not storage then return end
    
    storage.clearPlayerStorage(src)
end
