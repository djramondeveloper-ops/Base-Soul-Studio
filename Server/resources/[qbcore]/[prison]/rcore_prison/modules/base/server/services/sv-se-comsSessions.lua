COMSessionsService = COMSessionsService or {}

local function getSessionsStorage()
    local storage = Object.getStorage(STORAGE_COMS_SESSIONS)

    if not storage then
        dbg.critical("Storage not found")
        return nil
    end

    return storage
end

function COMSessionsService.RegisterZone(zoneId, verticesTarget, verticesDone)
    local sessionsStorage = getSessionsStorage()
    if not sessionsStorage then
        return nil
    end

    if sessionsStorage.getSession(zoneId) then
        dbg.critical("Zone already registered")
        return nil
    end

    local session = COMSSessionsModel()
    session.zoneId = zoneId
    session.verticesTarget = verticesTarget
    session.verticesDone = verticesDone

    return sessionsStorage.registerSession(session)
end

function COMSessionsService.GetZoneData(zoneId)
    local sessionsStorage = getSessionsStorage()
    if not sessionsStorage then
        return nil
    end

    return sessionsStorage.getSession(zoneId)
end

function COMSessionsService.UpdateDataByKey(zoneId, key, value)
    local sessionsStorage = getSessionsStorage()
    if not sessionsStorage then
        return false, nil
    end

    return sessionsStorage.updateSessionByKeyValue(zoneId, key, value)
end
