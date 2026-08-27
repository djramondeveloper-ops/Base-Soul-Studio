-- =====================================================
--  rcore_police · modules/base/client/init/cl-object.lua
--  Engineered by Eazy Fxap
--  Original: 162 lines → Cleaned: 60 lines
-- =====================================================

Object = {
    services = {},
    storages = {},
    _ObjectHashes = {},
    _ModelNames = {}
}

function Object.registerService(name, service)
    if not Object.services[name] then
        dbg.debug("Service with name " .. name .. " registered!")
    else
        dbg.error("Service with name " .. name .. " already exists - rewriting!")
    end
    Object.services[name] = service
    pcall(service.init)
    TriggerEvent("rcore_police:client:registeredService", name)
end

function Object.registerStorage(name, storage)
    if not Object.storages[name] then
        dbg.debug("Storage with name " .. name .. " registered!")
    else
        dbg.error("Storage with name " .. name .. " already exists - rewriting!")
    end
    Object.storages[name] = storage
    pcall(storage.init)
    TriggerEvent("rcore_police:client:registeredStorage", name)
end

function Object.getHash(key)
    if not Object._ObjectHashes[key] then
        Object._ObjectHashes[key] = GetHashKey(key)
    end
    return Object._ObjectHashes[key]
end

function Object.getModelName(key, entity)
    if not Object._ModelNames[key] then
        Object._ModelNames[key] = GetEntityArchetypeName(entity)
    end
    return Object._ModelNames[key]
end

function Object.getService(name)
    return Object.services[name]
end

function Object.getStorage(name)
    return Object.storages[name]
end

exports("getObject", function()
    return Object
end)
