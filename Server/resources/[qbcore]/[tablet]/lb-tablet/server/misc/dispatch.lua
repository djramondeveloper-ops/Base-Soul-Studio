local dispatchesByJob = {}
local dispatchJobById = {}

function GetJobDispatches(job)
    return dispatchesByJob[job] or {}
end

exports("GetJobDispatches", GetJobDispatches)

local function GenerateDispatchId()
    local dispatchId = math.random(999999999)

    while dispatchJobById[dispatchId] do
        dispatchId = math.random(999999999)
        Wait(0)
    end

    return dispatchId
end

local function TableContains(tbl, value)
    if not tbl then
        return false
    end

    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end

    return false
end

local function ValidateDispatchOptions(options)
    assert(type(options) == "table", "AddDispatch: options must be a table")

    options.time = math.floor(options.time or 300)
    options.job = options.job or "police"

    assert(
        options.priority == "high" or options.priority == "medium" or options.priority == "low",
        "AddDispatch: options.priority must be 'high', 'medium' or 'low'"
    )

    assert(type(options.code) == "string", "AddDispatch: options.code must be a string")
    assert(type(options.title) == "string", "AddDispatch: options.title must be a string")
    assert(type(options.description) == "string", "AddDispatch: options.description must be a string")
    assert(type(options.location) == "table", "AddDispatch: options.location must be a table")
    assert(type(options.location.label) == "string", "AddDispatch: options.location.label must be a string")

    local coords = options.location.coords
    assert(
        coords and coords.x and coords.y,
        "AddDispatch: options.location.coords must be a vector2 or have x and y keys"
    )

    assert(type(options.time) == "number" and options.time > 0, "AddDispatch: options.time must be a number and greater than 0")

    return options
end

local function RemoveAllDispatches(job)
    if not job then
        debugprint("RemoveAllDispatches: job is nil")
        return false
    end

    if not dispatchesByJob[job] then
        debugprint("RemoveAllDispatches: no dispatches for job", job)
        return true
    end

    debugprint("Removing all dispatches for job", job)

    for dispatchId in pairs(dispatchesByJob[job]) do
        dispatchesByJob[job][dispatchId] = nil
        dispatchJobById[dispatchId] = nil
    end

    TriggerClientEvent("tablet:removeAllDispatches", -1, job)
    return true
end

local function RemoveDispatch(dispatchId)
    TriggerClientEvent("tablet:removeDispatch", -1, dispatchId)

    local job = dispatchJobById[dispatchId]
    if not job then
        debugprint("RemoveDispatch: no dispatchJob", dispatchId)
        return false
    end

    local currentDispatch = dispatchesByJob[job] and dispatchesByJob[job][dispatchId]
    if not currentDispatch then
        debugprint("RemoveDispatch: no currentDispatch", dispatchId)
        return false
    end

    debugprint("Removed dispatch", dispatchId, job)

    dispatchesByJob[job][dispatchId] = nil
    dispatchJobById[dispatchId] = nil

    return true
end

local function QueueDispatchForRemoval(dispatchId, seconds, expectedEndTime)
    debugprint("Queued dispatch", dispatchId, "for removal in", seconds, "seconds")

    SetTimeout(seconds * 1000, function()
        local job = dispatchJobById[dispatchId]
        if not job then
            debugprint("QueueDispatchForRemoval: dispatch", dispatchId, "does not exist (not in dispatchIds)")
            return
        end

        local dispatch = dispatchesByJob[job] and dispatchesByJob[job][dispatchId]
        if not dispatch then
            debugprint("QueueDispatchForRemoval: dispatch", dispatchId, "does not exist (not in dispatches)")
            return
        end

        if dispatch.endTime == expectedEndTime then
            RemoveDispatch(dispatchId)
        else
            debugprint(
                "QueueDispatchForRemoval: dispatch",
                dispatchId,
                "has been updated, not removing. Current end time:",
                dispatch.endTime,
                "Original end time:",
                expectedEndTime
            )
        end
    end)
end

function AddDispatch(options)
    if Config.DispatchEnabled == false then
        debugprint("AddDispatch: Config.DispatchEnabled is set to false")
        return false
    end

    options = ValidateDispatchOptions(options)

    if options.time > 3600 and Config.LongDispatchWarning ~= false then
        infoprint(
            "warning",
            FormatString(
                "A dispatch with the name {name} was added with a time of {time} seconds. This is over an hour. Note that dispatch time is in seconds, not milliseconds. To disable this warning, set Config.LongDispatchWarning to false.",
                {
                    name = options.title,
                    time = options.time
                }
            )
        )
    end

    local dispatchId = GenerateDispatchId()
    local endTime = os.time() + options.time

    local dispatch = {
        id = dispatchId,
        job = options.job,
        priority = options.priority,
        code = options.code,
        title = options.title,
        description = options.description,
        image = options.image,
        timestamp = os.time() * 1000,
        fields = options.fields,
        sound = options.sound,
        location = options.location,
        blip = options.blip,
        responders = options.responders or {},
        endTime = endTime
    }

    dispatchesByJob[options.job] = dispatchesByJob[options.job] or {}
    dispatchesByJob[options.job][dispatchId] = dispatch
    dispatchJobById[dispatchId] = options.job

    TriggerClientEvent("tablet:addDispatch", -1, dispatch)
    QueueDispatchForRemoval(dispatchId, options.time, endTime)

    Log(
        nil,
        "Dispatch",
        "info",
        L("BACKEND.LOGS.NEW_DISPATCH", {
            title = options.title
        }),
        options,
        options.image
    )

    return dispatchId
end

exports("AddDispatch", AddDispatch)

function UpdateDispatch(dispatchId, newOptions)
    local job = dispatchJobById[dispatchId]
    local currentDispatch = job and dispatchesByJob[job] and dispatchesByJob[job][dispatchId]

    if not currentDispatch then
        return false
    end

    newOptions = ValidateDispatchOptions(newOptions)
    newOptions.job = job

    local endTime = os.time() + newOptions.time

    currentDispatch.job = job
    currentDispatch.priority = newOptions.priority
    currentDispatch.code = newOptions.code
    currentDispatch.title = newOptions.title
    currentDispatch.description = newOptions.description
    currentDispatch.image = newOptions.image
    currentDispatch.fields = newOptions.fields
    currentDispatch.sound = newOptions.sound
    currentDispatch.location = newOptions.location
    currentDispatch.blip = newOptions.blip
    currentDispatch.endTime = endTime

    dispatchesByJob[job][dispatchId] = currentDispatch

    TriggerClientEvent("tablet:updateDispatch", -1, currentDispatch)
    QueueDispatchForRemoval(dispatchId, newOptions.time, endTime)

    return true
end

exports("UpdateDispatch", UpdateDispatch)

RegisterNetEvent("tablet:dispatch:respond", function(dispatchId)
    local src = source
    local job = dispatchJobById[dispatchId]
    local dispatch = job and dispatchesByJob[job] and dispatchesByJob[job][dispatchId]

    if not dispatch then
        return
    end

    local unit = GetPlayerUnit(src)
    if not unit then
        local firstname, lastname = GetCharacterName(src)
        unit = (firstname or "") .. " " .. (lastname or "")
        unit = unit:gsub("^%s+", ""):gsub("%s+$", "")
    end

    if job == "police" then
        if not HasPermission(src, "Police", "dispatch", "view") then
            return debugprint("Player does not have permission to view dispatches (police)", src)
        end
    elseif job == "ambulance" then
        if not HasPermission(src, "Ambulance", "dispatch", "view") then
            return debugprint("Player does not have permission to view dispatches (ambulance)", src)
        end
    end

    dispatch.responders = dispatch.responders or {}

    if TableContains(dispatch.responders, unit) then
        return debugprint("Player/unit has already responded to this dispatch", src)
    end

    dispatch.responders[#dispatch.responders + 1] = unit
    dispatchesByJob[job][dispatchId] = dispatch

    TriggerClientEvent("tablet:updateDispatch", -1, dispatch)
end)

exports("GetDispatch", function(dispatchId)
    local job = dispatchJobById[dispatchId]
    if not job then
        return
    end

    return dispatchesByJob[job] and dispatchesByJob[job][dispatchId]
end)

exports("RemoveDispatch", RemoveDispatch)

RegisterNetEvent("lb-tablet:addDispatch", function(options)
    local src = source

    if not Config.AllowClientDispatch then
        infoprint(
            "error",
            GetPlayerName(src) .. " | " .. src .. " tried to add a dispatch from the client, but Config.AllowClientDispatch is set to false"
        )
        return
    end

    AddDispatch(options)
end)

BaseCallback("deleteDispatch", function(src, _, dispatchId)
    local job = dispatchJobById[dispatchId]
    if not job then
        debugprint("deleteDispatch: no dispatchJob (invalid dispatch?)", dispatchId)
        return false
    end

    local permissionGroup = job:gsub("^%l", string.upper)

    if not HasPermission(src, permissionGroup, "dispatch", "delete") then
        debugprint(src, "does not have permission to delete dispatches")
        return false
    end

    return RemoveDispatch(dispatchId)
end)

BaseCallback("clearDispatches", function(src)
    local job = nil

    if HasPermission(src, "Police", "dispatch", "delete") then
        job = "police"
    elseif HasPermission(src, "Ambulance", "dispatch", "delete") then
        job = "ambulance"
    else
        debugprint(src, "does not have permission to clear dispatches")
        return false
    end

    RemoveAllDispatches(job)
    return true
end)