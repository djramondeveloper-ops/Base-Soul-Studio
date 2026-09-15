--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

function MergeDefaultRopeData(ropeData)
    if not ropeData then
        ropeData = {}
    end

    local defaultRopeData = {
        maxLength = 4.0,
        ropeType = 6,
        initLength = 10.0,
        minLength = 1.0,
        lengthChangeRate = 0,
        onlyPPU = 0,
        collisionOn = 1,
        lockFromFront = 2,
        timeMultiplier = 0.2,
        breakable = 0,
    }

    for key, value in pairs(defaultRopeData) do
        if not ropeData[key] then
            ropeData[key] = value
        end
    end

    return ropeData
end

local pendingRopes = {}
local cancelledRopes = {}

function IsRopeRequestCancelled(handler)
    local expires = cancelledRopes[handler]
    if expires and GetGameTimer() < expires then return true end
    cancelledRopes[handler] = nil
    return false
end

RegisterNetEvent("rcore_rope:sync:AddResult", function(handler, reason)
    if source ~= 65535 then return end
    local request = pendingRopes[handler]
    if request then request.reason = reason end
end)

local function RequestSyncedRope(entry)
    for handler in pairs(cancelledRopes) do IsRopeRequestCancelled(handler) end
    local handler = entry.ropeHandler
    local request = {}
    pendingRopes[handler] = request
    local deadline = GetGameTimer() + 5000
    local nextAttempt = 0
    while not RopeCache[handler] and GetGameTimer() < deadline do
        if request.reason and request.reason ~= "endpoint_not_ready" and request.reason ~= "rate_limited" then
            break
        end
        if GetGameTimer() >= nextAttempt then
            nextAttempt = GetGameTimer() + 250
            TriggerServerEvent("rcore_rope:sync:AddToCache", entry)
        end
        Wait(33)
    end
    pendingRopes[handler] = nil
    if RopeCache[handler] then return handler end

    cancelledRopes[handler] = GetGameTimer() + 60000
    TriggerServerEvent("rcore_rope:sync:RemoveFromCache", handler)
    print(string.format("[rcore_fuel] Rope sync failed (%s): %s", handler, request.reason or "no_server_response"))
    return nil
end

function AttachSyncedRopeToEntity(entityData, entityAttachData, ropeStartPos, ropeEndPos, rotation, ropeData)
    local ropeHandler = GenerateRandomIdentifier()
    ropeData = MergeDefaultRopeData(ropeData)

    return RequestSyncedRope({
        ropeType = RopeType.Attached,
        ropeHandler = ropeHandler,
        entityData = entityData,
        entityAttachData = entityAttachData,
        ropeStartPos = ropeStartPos,
        ropeEndPos = ropeEndPos,
        rotation = rotation,
        data = ropeData,
    })

end

function CreateSyncedRope(ropeStartPos, rotation, ropeData)
    local ropeHandler = GenerateRandomIdentifier()
    ropeData = MergeDefaultRopeData(ropeData)

    return RequestSyncedRope({
        ropeType = RopeType.Static,
        ropeHandler = ropeHandler,
        ropeStartPos = ropeStartPos,
        rotation = rotation,
        data = ropeData,
    })

end

function DeleteSyncedRope(ropeHandler)
    if not ropeHandler then
        return
    end

    TriggerServerEvent("rcore_rope:sync:RemoveFromCache", ropeHandler)
    cancelledRopes[ropeHandler] = GetGameTimer() + 60000
    RemoveRopeFromHandler(ropeHandler)
end
