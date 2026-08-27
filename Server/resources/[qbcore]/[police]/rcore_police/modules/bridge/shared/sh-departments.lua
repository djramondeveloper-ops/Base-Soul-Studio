-- =====================================================
--  rcore_police · modules/bridge/shared/sh-departments.lua
--  Engineered by Eazy Fxap
--  Original: 647 lines → Cleaned: 270 lines
-- =====================================================

-- ============================================================
--  VEHICLE CACHE & OUTFIT CACHE
-- ============================================================

local vehicleCache = {}
local outfitCache  = {}

-- ============================================================
--  INITIALIZATION: Load police groups from framework
-- ============================================================

CreateThread(function()
    Wait(0)
    local success, groups = Framework.CachePoliceGroups()
    if not success then return end
    RegisterDepartments(groups)
end)

-- ============================================================
--  SERVER-ONLY: Item access check helpers
-- ============================================================

if IsDuplicityVersion() then
    -- Returns true if the player's grade has access to the named item
    function CanAccessItem(job, grade, itemName, isBoss)
        local items, ok = GetAvailableItemsForGrade(job, grade, isBoss)
        if not ok then return false end
        local nameLower = itemName:lower()
        for i = 1, #items do
            if items[i].name:lower() == nameLower then
                return true
            end
        end
        return false
    end

    -- Returns the item storage data if accessible, nil otherwise
    function GetItemStorageData(job, grade, itemName, isBoss)
        local items, ok = GetAvailableItemsForGrade(job, grade, isBoss)
        if not ok then return nil end
        local nameLower = itemName:lower()
        for i = 1, #items do
            if items[i].name:lower() == nameLower then
                return items[i]
            end
        end
        return nil
    end
end

-- ============================================================
--  REGISTER DEPARTMENTS — Apply default templates when not set
-- ============================================================

function RegisterDepartments(groups)
    if not groups or not next(groups) then return end
    for jobName in pairs(groups) do
        if not Config.JobGroups[jobName] then
            Config.JobGroups[jobName] = {}
        end
        local dept = Config.JobGroups[jobName]
        if not dept.Store then
            dept.Store = Config.ItemShop.DefaultDepartmentTemplate
            dbg.debug("Department: Registering store for %s from Config.ItemShop.DefaultDepartmentTemplate", jobName)
        end
        if not dept.VehiclesToGrade then
            dept.VehiclesToGrade = Config.Garage.DefaultDepartmentTemplate
            dbg.debug("Department: Registering vehicles for %s from Config.ItemShop.DefaultDepartmentTemplate", jobName)
        end
        if not dept.Outfits then
            dept.Outfits = Config.Outfits.DefaultDepartmentTemplate
        end
    end
end

-- ============================================================
--  GET AVAILABLE OUTFITS FOR GRADE
--  Returns: outfitList, hasAccess, statusCode
-- ============================================================

function GetAvailableOutfitsForGrade(job, grade, outfitKey, gradeOverride)
    local cacheKey = ("outfits-%s-%d-%s"):format(job, grade, outfitKey)

    -- Return cached result
    if outfitCache[cacheKey] then
        return outfitCache[cacheKey].outfit, true, "CACHED"
    end

    local deptData = Config.JobGroups[job] and Config.JobGroups[job].Outfits
    if not deptData then
        return {}, false, "NO_DEPARTMENT_OUTFIT_DATA"
    end

    local results = {}
    local storage = deptData.storage
    local allowedKeys = {}

    -- Determine minimum grade index
    local ownGradeOnly = Config.Outfits.ShownOwnGradeOutfitsOnly
    local startGrade = (ownGradeOnly or gradeOverride) and grade or 0
    if not ownGradeOnly or not grade then startGrade = 0 end

    for g = startGrade, grade do
        local accessList = deptData.access[g]
        if accessList then
            -- Wildcard access or boss override: include all outfits
            if accessList[1] == "*" or gradeOverride then
                local sortedKeys = {}
                for k in pairs(storage) do table.insert(sortedKeys, k) end
                table.sort(sortedKeys)
                for _, k in ipairs(sortedKeys) do
                    table.insert(results, storage[k])
                end
                outfitCache[cacheKey] = { outfit = results }
                return results, true, "HAS_ACCESS"
            end
            -- Specific outfit keys
            for _, k in ipairs(accessList) do
                allowedKeys[k] = true
            end
        end
    end

    -- Collect sorted allowed outfits
    local sortedAllowed = {}
    for k in pairs(allowedKeys) do table.insert(sortedAllowed, k) end
    table.sort(sortedAllowed)
    for _, k in ipairs(sortedAllowed) do
        if storage[k] then table.insert(results, storage[k]) end
    end

    outfitCache[cacheKey] = { outfit = results }
    return results, true, "HAS_ACCESS"
end

-- ============================================================
--  GET AVAILABLE VEHICLES FOR GRADE
--  Returns: vehicleList, hasAccess, statusCode
-- ============================================================

function GetAvailableVehiclesForGrade(job, grade, isBoss, zoneType)
    local isAirGarage = (zoneType == ZONE_TYPE.GARAGE_AIR)
    local cacheKey = ("vehicles-%s-%d-%s"):format(job, grade, tostring(isAirGarage))

    -- Return cached result
    if vehicleCache[cacheKey] then
        return vehicleCache[cacheKey].vehicles, true, "CACHED"
    end

    local deptData = Config.JobGroups[job] and Config.JobGroups[job].VehiclesToGrade
    if not deptData then
        return {}, false, "NO_DEPARTMENT_VEHICLE_DATA"
    end

    local results = {}
    local storage = deptData.storage
    local allowedKeys = {}
    local canBuy = Config.Garage.DepartmentsEnableBuyVehicles

    for g = 0, grade do
        local accessList = deptData.access[g]
        if accessList then
            -- Wildcard access or boss override: include all vehicles
            if accessList[1] == "*" or isBoss then
                local sortedKeys = {}
                for k in pairs(storage) do table.insert(sortedKeys, k) end
                table.sort(sortedKeys)
                for _, k in ipairs(sortedKeys) do
                    local veh = storage[k]
                    -- Air-garage filter
                    if isAirGarage and not veh.isAir then goto continueWild end
                    if not isAirGarage and veh.isAir then goto continueWild end
                    table.insert(results, {
                        name  = k,
                        label = veh.label,
                        model = veh.model,
                        price = canBuy and (veh.price or 0) or 0,
                        image = veh.image,
                    })
                    ::continueWild::
                end
                vehicleCache[cacheKey] = { vehicles = results }
                return results, true, "HAS_ACCESS"
            end
            -- Specific vehicle keys
            for _, k in ipairs(accessList) do
                allowedKeys[k] = true
            end
        end
    end

    -- Collect sorted allowed vehicles
    local sortedAllowed = {}
    for k in pairs(allowedKeys) do table.insert(sortedAllowed, k) end
    table.sort(sortedAllowed)
    for _, k in ipairs(sortedAllowed) do
        local veh = storage[k]
        if veh then
            -- Air-garage filter
            if isAirGarage and not veh.isAir then goto continueAllowed end
            if not isAirGarage and veh.isAir then goto continueAllowed end
            table.insert(results, {
                name  = k,
                label = veh.label,
                model = veh.model,
                price = canBuy and (veh.price or 0) or 0,
                image = veh.image,
            })
            ::continueAllowed::
        end
    end

    vehicleCache[cacheKey] = { vehicles = results }
    return results, true, "HAS_ACCESS"
end

-- ============================================================
--  GET AVAILABLE ITEMS FOR GRADE
--  Returns: itemList, hasAccess, statusCode
-- ============================================================

function GetAvailableItemsForGrade(job, grade, isBoss)
    if not job then
        return dbg.debug("GetAvailableItemsForGrade: Failed to get job")
    end
    if not grade then
        return dbg.debug("GetAvailableItemsForGrade: Failed to get grade")
    end

    local cacheKey = ("%s-%d"):format(job, grade)

    -- Return cached result
    if vehicleCache[cacheKey] then
        return vehicleCache[cacheKey].items, true, "CACHED"
    end

    local deptData = Config.JobGroups[job] and Config.JobGroups[job].Store
    if not deptData then
        return {}, false, "NO_DEPARTMENT_DATA"
    end

    -- Boss-only shop check
    if deptData.mode == SHOP_STATE.ORDER_BY_BOSS then
        if not isBoss then
            dbg.debug("The department store can be opened by boss only! Since SHOP_STATE is set to SHOP_STATE.ORDER_BY_BOSS!")
            return {}, false, "SHOP_STATE_REQUIRED_BOSS"
        end
    end

    local results = {}
    local storage = deptData.storage
    local allowedKeys = {}

    for g = 0, grade do
        local accessList = deptData.access[g]
        if accessList then
            -- Wildcard or boss override: include all items
            if accessList[1] == "*" or isBoss then
                local sortedKeys = {}
                for k in pairs(storage) do table.insert(sortedKeys, k) end
                table.sort(sortedKeys)
                for i = 1, #sortedKeys do
                    local k = sortedKeys[i]
                    local item = storage[k]
                    table.insert(results, {
                        name  = k,
                        label = item.label,
                        count = item.count,
                        price = item.price,
                    })
                end
                vehicleCache[cacheKey] = { items = results }
                return results, true, "HAS_ACCESS"
            end
            -- Specific item keys
            for i = 1, #accessList do
                allowedKeys[accessList[i]] = true
            end
        end
    end

    -- Collect sorted allowed items
    local sortedAllowed = {}
    for k in pairs(allowedKeys) do table.insert(sortedAllowed, k) end
    table.sort(sortedAllowed)
    for i = 1, #sortedAllowed do
        local k = sortedAllowed[i]
        local item = storage[k]
        if item then
            table.insert(results, {
                name  = k,
                label = item.label,
                count = item.count,
                price = item.price,
            })
        end
    end

    vehicleCache[cacheKey] = { items = results }
    return results, true, "HAS_ACCESS"
end
