
Object = type(_G.Object) == 'table' and _G.Object or {}
Blips = type(_G.Blips) == 'table' and _G.Blips or {}
Subtitles = type(_G.Subtitles) == 'table' and _G.Subtitles or {}
Text = type(_G.Text) == 'table' and _G.Text or {}
HelpKeys = type(_G.HelpKeys) == 'table' and _G.HelpKeys or {}
Mugshot = type(_G.Mugshot) == 'table' and _G.Mugshot or {}
Booths = type(_G.Booths) == 'table' and _G.Booths or { callSessionState = false }
ClothingService = type(_G.ClothingService) == 'table' and _G.ClothingService or {}
Canteen = type(_G.Canteen) == 'table' and _G.Canteen or {}
Dialog = type(_G.Dialog) == 'table' and _G.Dialog or {}
Quest = type(_G.Quest) == 'table' and _G.Quest or {}
Cache = type(_G.Cache) == 'table' and _G.Cache or {}
Trade = type(_G.Trade) == 'table' and _G.Trade or {}
Entity = type(_G.Entity) == 'table' and _G.Entity or { cache = {} }
ScaleformUtils = type(_G.ScaleformUtils) == 'table' and _G.ScaleformUtils or {}

Object.services = Object.services or {}
Object.storages = Object.storages or {}
function Object.registerService(serviceName, service)
    local existingService = Object.services[serviceName]

    if not existingService then
        dbg.debug("C - Service with name " .. serviceName .. " registered!")
    else
        dbg.error("C - Service with name " .. serviceName .. " already exists - rewriting!")
    end

    Object.services[serviceName] = service
    pcall(service.init)
end

function Object.registerStorage(storageName, storage)
    local existingStorage = Object.storages[storageName]

    if not existingStorage then
        dbg.debug("C - Storage with name " .. storageName .. " registered!")
    else
        dbg.error("C - Storage with name " .. storageName .. " already exists - rewriting!")
    end

    Object.storages[storageName] = storage
    pcall(storage.init)
end

function Object.getService(serviceName)
    return Object.services[serviceName]
end

function Object.getStorage(storageName)
    return Object.storages[storageName]
end

exports("getObject", function()
    return Object
end)