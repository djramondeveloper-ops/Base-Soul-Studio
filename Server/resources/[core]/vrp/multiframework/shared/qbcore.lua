-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL MULTIFRAMEWORK V2 - QBCORE SHARED
-- Completa QBCore.Shared usando a configuracao real de Groups da Seoul.
-----------------------------------------------------------------------------------------------------------------------------------------
if not SeoulMultiframework or not SeoulMultiframework.QBCore or SeoulMultiframework.QBCore.Enabled == false then
    return
end

QBCore = QBCore or {}
QBShared = QBShared or {}
QBCore.Shared = QBShared

QBShared.Jobs = QBShared.Jobs or {}
QBShared.Gangs = QBShared.Gangs or {}
QBShared.Items = QBShared.Items or {}
QBShared.Vehicles = QBShared.Vehicles or {}
QBShared.Weapons = QBShared.Weapons or {}
QBShared.Locations = QBShared.Locations or {}

local Config = SeoulMultiframework.QBCore

local function groupData(name)
    return type(Groups) == "table" and Groups[name] or nil
end

local function buildGrades(data)
    local grades = {}
    local hierarchy = type(data) == "table" and data.Hierarchy or nil
    local salary = type(data) == "table" and data.Salary or nil
    local count = type(hierarchy) == "table" and #hierarchy or 0

    if count == 0 then
        grades["0"] = {
            name = "Membro",
            payment = 0,
            isboss = true,
            seoulLevel = 1
        }
        return grades
    end

    for seoulLevel = 1, count do
        local qbLevel
        if Config.UseQBCoreGradeOrder then
            qbLevel = count - seoulLevel
        else
            qbLevel = seoulLevel
        end

        grades[tostring(qbLevel)] = {
            name = tostring(hierarchy[seoulLevel] or ("Cargo " .. tostring(seoulLevel))),
            payment = tonumber(salary and salary[seoulLevel] or 0) or 0,
            isboss = seoulLevel == 1,
            seoulLevel = seoulLevel
        }
    end

    return grades
end

local function buildEntry(name, gang)
    local data = groupData(name)
    if type(data) ~= "table" then return nil end

    local entry = {
        label = tostring(data.Name or name),
        defaultDuty = data.Service ~= false,
        offDutyPay = false,
        grades = buildGrades(data),
        seoulGroup = name
    }

    if gang then
        entry.defaultDuty = nil
        entry.offDutyPay = nil
    end

    return entry
end

local function rebuildSharedGroups()
    QBShared.Jobs.unemployed = QBShared.Jobs.unemployed or {
        label = "Civilian",
        defaultDuty = true,
        offDutyPay = false,
        grades = { ["0"] = { name = "Freelancer", payment = 0, isboss = false, seoulLevel = 0 } }
    }

    QBShared.Gangs.none = QBShared.Gangs.none or {
        label = "No Gang",
        grades = { ["0"] = { name = "none", isboss = false, seoulLevel = 0 } }
    }

    for _, name in ipairs(Config.Jobs or {}) do
        local entry = buildEntry(name, false)
        if entry then QBShared.Jobs[name] = entry end
    end

    for _, name in ipairs(Config.Gangs or {}) do
        local entry = buildEntry(name, true)
        if entry then QBShared.Gangs[name] = entry end
    end
end

rebuildSharedGroups()

SeoulMultiframework.QBCore.RebuildSharedGroups = rebuildSharedGroups
