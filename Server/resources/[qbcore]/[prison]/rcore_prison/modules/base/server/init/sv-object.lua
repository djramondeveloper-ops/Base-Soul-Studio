Inventory = Inventory or {}
Dispatch = Dispatch or {}
PlayerLoadedPool = PlayerLoadedPool or {}
ServerItems = ServerItems or {}
RestrictZone = RestrictZone or {}

Object = {}
Object.services = {}
Object.storages = {}

local function safeInit(instance, name, objectType)
    if type(instance) ~= 'table' or type(instance.init) ~= 'function' then
        return
    end

    local ok, err = pcall(instance.init)
    if not ok and dbg and dbg.error then
        dbg.error('%s %s init failed: %s', objectType, tostring(name), tostring(err))
    end
end

function Object.registerService(serviceName, service)
    if not Object.services[serviceName] then
        if dbg and dbg.debug then
            dbg.debug('Service with name %s registered!', tostring(serviceName))
        end
    else
        if dbg and dbg.error then
            dbg.error('Service with name %s already exists - rewriting!', tostring(serviceName))
        end
    end

    Object.services[serviceName] = service
    safeInit(service, serviceName, 'Service')
    TriggerEvent('rcore_prison:server:registeredService', serviceName)
end

function Object.registerStorage(storageName, storage)
    if not Object.storages[storageName] then
        if dbg and dbg.debug then
            dbg.debug('Storage with name %s registered!', tostring(storageName))
        end
    else
        if dbg and dbg.error then
            dbg.error('Storage with name %s already exists - rewriting!', tostring(storageName))
        end
    end

    Object.storages[storageName] = storage
    safeInit(storage, storageName, 'Storage')
    TriggerEvent('rcore_prison:server:registeredStorage', storageName)
end

function Object.getService(serviceName)
    return Object.services[serviceName]
end

function Object.getStorage(storageName)
    return Object.storages[storageName]
end

exports('getObject', function()
    return Object
end)
