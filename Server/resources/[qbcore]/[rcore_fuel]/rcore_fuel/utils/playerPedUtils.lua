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

local isWalkingToCoords = false
local walkingGeneration = 0

function Lerp(startValue, endValue, alpha)
    return startValue + ((endValue - startValue) * alpha)
end

function LerpAngle(startAngle, endAngle, alpha)
    local delta = ((endAngle - startAngle + 540) % 360) - 180
    local result = ((startAngle + (delta * alpha) + 180) % 360) - 180

    if result < -180 then
        result = result + 360
    elseif result > 180 then
        result = result - 360
    end

    return result
end

function RotatePlayerTowardsCoords(targetCoords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local heading = GetHeadingFromVector_2d(
        targetCoords.x - playerCoords.x,
        targetCoords.y - playerCoords.y
    )

    SetEntityHeading(playerPed, heading)
end

function GetPotentitalHeadingForCoords(targetCoords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    return GetHeadingFromVector_2d(
        targetCoords.x - playerCoords.x,
        targetCoords.y - playerCoords.y
    )
end

function GetPlayerServerID()
    -- The local player's server id should come from PlayerId(). Entity ownership can
    -- migrate and is not a reliable identity source for gameplay/network events.
    return GetPlayerServerId(PlayerId())
end

function GetShortestAngleDistance(startAngle, endAngle)
    return ((endAngle - startAngle + 540) % 360) - 180
end

function LerpAngleShortest(startAngle, endAngle, alpha)
    return startAngle + (GetShortestAngleDistance(startAngle, endAngle) * alpha)
end

function GetGroundLevelZ(coords)
    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1.0, true)
    if foundGround then
        -- In GTA V, ped root entity coords are roughly ~0.98m to 1.0m above terrain surface.
        -- Setting ped coords directly to groundZ sinks the ped's pelvis to the floor.
        return groundZ + 0.98
    end

    -- Ground queries can fail in interiors, on streamed geometry, or while collision
    -- is still loading. Falling back to the interpolated Z avoids snapping the ped to 0.
    return coords.z
end

function IsPlayerWalkingToCoordinates()
    return isWalkingToCoords
end

function CancelWalkToCoordinates()
    walkingGeneration = walkingGeneration + 1
    isWalkingToCoords = false
end

function GoToCoordsWithHeadingInTime(ped, targetCoords, targetHeading, lerpDuration, canContinue, options)
    if isWalkingToCoords or not ped or not DoesEntityExist(ped) or not targetCoords then
        return false, "busy_or_invalid_target"
    end

    walkingGeneration = walkingGeneration + 1
    local generation = walkingGeneration
    isWalkingToCoords = true
    targetHeading = targetHeading % 360
    -- Native walking handles terrain and obstacles. Never pull a blocked ped
    -- through a car/pump, or repeatedly add the entity radius to its Z position.
    local destination = vector3(targetCoords.x, targetCoords.y, GetGroundLevelZ(targetCoords))
    options = options or {}
    local positionTolerance = options.positionTolerance or 0.35
    local heightTolerance = options.heightTolerance or 0.35
    local headingTolerance = options.headingTolerance or 3.0
    local function atDestination()
        local delta = GetEntityCoords(ped) - destination
        return delta.x * delta.x + delta.y * delta.y <= positionTolerance * positionTolerance
            and math.abs(delta.z) <= heightTolerance
    end
    local timeout = math.min(15000, math.max(2500, #(GetEntityCoords(ped) - destination) * 1500))
    local deadline = GetGameTimer() + timeout
    local function valid()
        return generation == walkingGeneration and DoesEntityExist(ped)
            and not IsEntityDead(ped) and not IsPedRagdoll(ped)
            and not IsPedInAnyVehicle(ped, false)
            and (not canContinue or canContinue())
    end
    local function finish(success, reason)
        if generation == walkingGeneration then
            isWalkingToCoords = false
            if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedRagdoll(ped) then
                ClearPedTasks(ped)
            end
        end
        return success, reason
    end
    if not valid() then return finish(false, "interrupted") end
    TaskFollowNavMeshToCoord(ped, destination.x, destination.y, destination.z,
        1.0, math.floor(timeout), 0.15, 0, targetHeading)
    while not atDestination() do
        Wait(50)
        if not valid() then return finish(false, "interrupted") end
        if GetGameTimer() >= deadline then return finish(false, "position_timeout") end
    end
    if not valid() then return finish(false, "interrupted") end
    local headingTimeout = math.max(250, tonumber(lerpDuration) or 1000)
    TaskAchieveHeading(ped, targetHeading, math.floor(headingTimeout))
    deadline = GetGameTimer() + headingTimeout
    while math.abs(GetShortestAngleDistance(GetEntityHeading(ped), targetHeading)) > headingTolerance do
        Wait(0)
        if not valid() then return finish(false, "interrupted") end
        if GetGameTimer() >= deadline then
            if options.finishHeading and atDestination() then
                -- Finish orientation in place; do not teleport through the pump
                -- when its collision makes the native stop short of the offset.
                SetEntityHeading(ped, targetHeading)
                break
            end
            return finish(false, "heading_timeout")
        end
    end
    return finish(valid())
end

function IsPlayerAtCertainHeading(centerHeading, headingRange)
    local playerHeading = (GetEntityHeading(PlayerPedId()) + 360) % 360
    local minHeading = (centerHeading - headingRange + 360) % 360
    local maxHeading = (centerHeading + headingRange) % 360

    if minHeading <= maxHeading then
        return playerHeading >= minHeading and playerHeading <= maxHeading
    end

    return playerHeading >= minHeading or playerHeading <= maxHeading
end
