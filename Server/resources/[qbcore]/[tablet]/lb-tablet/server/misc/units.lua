local unitsByJob = {}
local playerUnits = {}

function GetUnits(job)
    return unitsByJob[job] or {}
end

exports("GetUnits", GetUnits)

function GetPlayerUnit(source)
    local playerData = playerUnits[source]
    return playerData and playerData.unit or nil
end

exports("GetPlayerUnit", GetPlayerUnit)

function SetPlayerUnit(source, job, unitName)
    local jobUnits = unitsByJob[job]
    if not jobUnits then
        debugprint("No units for job", job)
        return false
    end

    if not jobUnits[unitName] then
        debugprint("No unit for job", job, unitName)
        return false
    end

    local oldData = playerUnits[source]

    playerUnits[source] = {
        unit = unitName,
        job = job
    }

    TriggerClientEvent("tablet:setPlayerUnit", -1, job, {
        unit = unitName,
        source = source,
        oldUnit = oldData and oldData.unit or nil
    })

    TriggerEvent("lb-tablet:playerUnitUpdated", source, job, unitName)

    return true
end

exports("SetPlayerUnit", SetPlayerUnit)

function ResetPlayerUnit(source)
    local playerData = playerUnits[source]
    if not playerData then
        return
    end

    TriggerClientEvent("tablet:setPlayerUnit", -1, playerData.job, {
        unit = nil,
        source = source,
        oldUnit = playerData.unit
    })

    TriggerEvent("lb-tablet:playerUnitUpdated", source, playerData.job)

    playerUnits[source] = nil
end

exports("ResetPlayerUnit", ResetPlayerUnit)

function CreateUnit(job, unitName, status)
    local jobUnits = unitsByJob[job] or {}

    if jobUnits[unitName] then
        debugprint("Unit already exists", job, unitName)
        return false
    end

    jobUnits[unitName] = {
        name = unitName,
        status = status or "available"
    }

    unitsByJob[job] = jobUnits

    TriggerClientEvent("tablet:unitCreated", -1, job, unitName, jobUnits[unitName].status)
    TriggerEvent("lb-tablet:unitCreated", job, unitName, jobUnits[unitName].status)

    return true
end

exports("CreateUnit", CreateUnit)

function RemoveUnit(job, unitName)
    local jobUnits = unitsByJob[job]
    if not jobUnits then
        debugprint("No units for job", job)
        return false
    end

    if not jobUnits[unitName] then
        return true
    end

    local toReset = {}

    for source, playerData in pairs(playerUnits) do
        if playerData.job == job and playerData.unit == unitName then
            toReset[#toReset + 1] = source
        end
    end

    for i = 1, #toReset do
        ResetPlayerUnit(toReset[i])
    end

    jobUnits[unitName] = nil

    TriggerClientEvent("tablet:unitRemoved", -1, job, unitName)
    TriggerEvent("lb-tablet:unitRemoved", job, unitName)

    return true
end

exports("RemoveUnit", RemoveUnit)

function SetUnitStatus(job, unitName, status)
    local jobUnits = unitsByJob[job]
    if not jobUnits then
        debugprint("No units for job", job)
        return false
    end

    local unitData = jobUnits[unitName]
    if not unitData then
        debugprint("No unit for job", job, unitName)
        return false
    end

    unitData.status = status

    TriggerClientEvent("tablet:unitUpdated", -1, job, {
        unit = unitName,
        status = status
    })

    TriggerEvent("lb-tablet:unitStatusUpdated", job, unitName, status)

    return true
end

exports("SetUnitStatus", SetUnitStatus)

function RenameUnit(job, oldName, newName)
    local jobUnits = unitsByJob[job]
    if not jobUnits then
        debugprint("No units for job", job)
        return false
    end

    local unitData = jobUnits[oldName]
    if not unitData then
        debugprint("No unit for job", job, oldName)
        return false
    end

    if jobUnits[newName] then
        debugprint("Unit already exists", job, newName)
        return false
    end

    jobUnits[newName] = unitData
    jobUnits[newName].name = newName
    jobUnits[oldName] = nil

    for source, playerData in pairs(playerUnits) do
        if playerData.job == job and playerData.unit == oldName then
            playerData.unit = newName
        end
    end

    TriggerClientEvent("tablet:unitUpdated", -1, job, {
        unit = oldName,
        newName = newName
    })

    TriggerEvent("lb-tablet:unitRenamed", job, oldName, newName)

    return true
end

exports("RenameUnit", RenameUnit)

OnPlayerDisconnect(function(source)
    playerUnits[source] = nil
end)

AddEventHandler("lb-tablet:jobUpdated", function(source, grade)
    local playerData = playerUnits[source]
    if not playerData then
        return
    end

    local jobConfig

    if playerData.job == "police" then
        jobConfig = Config.Police
    elseif playerData.job == "ambulance" then
        jobConfig = Config.Ambulance
    else
        return
    end

    if not jobConfig or not jobConfig.Permissions or not jobConfig.Permissions[grade] then
        ResetPlayerUnit(source)
    end
end)

local function loadDefaultUnits(job, jobConfig)
    if not jobConfig or not jobConfig.DefaultUnits then
        return
    end

    for i = 1, #jobConfig.DefaultUnits do
        local unitData = jobConfig.DefaultUnits[i]
        CreateUnit(job, unitData.name, unitData.status)
    end
end

loadDefaultUnits("police", Config.Police)
loadDefaultUnits("ambulance", Config.Ambulance)