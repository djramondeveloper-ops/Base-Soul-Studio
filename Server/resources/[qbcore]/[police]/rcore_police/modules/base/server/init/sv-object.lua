-- =====================================================
--  rcore_police · modules/base/server/init/sv-object.lua
--  Engineered by Eazy Fxap
--  Original: 116 lines → Cleaned: 44 lines
-- =====================================================

Object = {
    services = {},
    storages = {}
}

function Object.registerService(name, service)
    if not Object.services[name] then
        dbg.debug("Service with name " .. name .. " registered!")
    else
        dbg.error("Service with name " .. name .. " already exists - rewrting!")
    end
    
    Object.services[name] = service
    if service.init then
        pcall(service.init)
    end
    TriggerEvent("rcore_police:server:registeredService", name)
end

function Object.registerStorage(name, storage)
    if not Object.storages[name] then
        dbg.debug("Storage with name " .. name .. " registered!")
    else
        dbg.error("Storage with name " .. name .. " already exists - rewriting!")
    end
    
    Object.storages[name] = storage
    if storage.init then
        pcall(storage.init)
    end
    TriggerEvent("rcore_police:server:registeredStorage", name)
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
