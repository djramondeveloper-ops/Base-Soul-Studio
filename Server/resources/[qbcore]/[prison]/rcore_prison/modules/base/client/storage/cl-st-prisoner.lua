local function createPrisonerStorage()
    local storage = {
        _prisoner = {}
    }

    function storage.RegisterPrisoner(prisonerData)
        storage._prisoner = prisonerData
        return true
    end

    function storage.UpdatePrisonerDataByKeyValue(key, value)
        if not storage.IsPrisoner() then
            return false
        end

        if not key or not value then
            return false
        end

        storage._prisoner[key] = value
        return true
    end

    function storage.UnregisterPrisoner()
        storage._prisoner = nil
        return true
    end

    function storage.IsPrisoner()
        return storage._prisoner ~= nil and next(storage._prisoner) ~= nil
    end

    function storage.GetPrisonerData()
        if not storage.IsPrisoner() then
            return nil
        end

        return storage._prisoner
    end

    return storage
end

PrisonerStorage = createPrisonerStorage
Object.registerStorage(STORAGE_PRISONER, PrisonerStorage())
