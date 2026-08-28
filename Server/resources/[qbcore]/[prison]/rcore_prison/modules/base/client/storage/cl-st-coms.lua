local function createCOMStorage()
    local storage = {
        _comsData = {}
    }

    RegisterCommand("client_data", function()
        if next(storage._comsData) then
            tprint(storage._comsData)
        end
    end, false)

    function storage.RegisterActiveCOMS(comsData)
        storage._comsData = comsData or {}
        return true
    end

    function storage.UpdateCOMSDataByKeyValue(key, value)
        if not storage.IsActiveCOMS() then
            return false
        end

        if not key or not value then
            return false
        end

        storage._comsData[key] = value
        return true
    end

    function storage.UnregisterActiveCOMS()
        storage._comsData = {}
        return true
    end

    function storage.IsActiveCOMS()
        return storage._comsData ~= nil and next(storage._comsData) ~= nil
    end

    -- Compatibility alias used by some decompiled variants.
    storage.IsUserOnCOMS = storage.IsActiveCOMS

    function storage.GetCOMS()
        return storage._comsData
    end

    return storage
end

COMStorage = createCOMStorage
Object.registerStorage(STORAGE_COMS, COMStorage())
