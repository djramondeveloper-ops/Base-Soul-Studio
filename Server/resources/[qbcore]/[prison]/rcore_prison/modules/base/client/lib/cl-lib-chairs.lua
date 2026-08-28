local Chairs = {}

CurrentPoint = nil

local currentRaycastEntity = nil
local currentSeatOption = {}
local cycleIntervals = {}

local ENTITY_HEADING_MAP = {
    [-1760759129] = 180.0,
    [1953006958] = 0.0,
    [-382290129] = 180.0,
    [-628719744] = 180.0,
    [493125771] = -220.0,
    [2056257134] = 180.0,
    [-931009034] = -220.0
}

local DEG2RAD = math.pi / 180.0
local RAD2DEG = 180.0 / math.pi

local function SetCycle(name, interval, callback, onFinish)
    local existing = cycleIntervals[name]

    if not existing and interval then
        cycleIntervals[name] = interval

        CreateThread(function()
            while cycleIntervals[name] ~= -1 do
                local currentInterval = cycleIntervals[name]
                Wait(currentInterval)
                callback(currentInterval)
            end

            cycleIntervals[name] = nil

            if onFinish then
                onFinish()
            end
        end, "cl-lib-chairs code name: Phoenix")
    elseif interval then
        cycleIntervals[name] = interval
    end
end

local function ClearCycle(name)
    if cycleIntervals[name] then
        cycleIntervals[name] = -1
    end
end

local function RotationToDirection(rotation)
    local rot = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }

    return {
        x = -math.sin(rot.z) * math.abs(math.cos(rot.x)),
        y = math.cos(rot.z) * math.abs(math.cos(rot.x)),
        z = math.sin(rot.x)
    }
end

local function RayCastGamePlayCamera(traceFlags, ignoreEntity, p8, distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoords = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)

    local destination = {
        x = cameraCoords.x + direction.x * distance,
        y = cameraCoords.y + direction.y * distance,
        z = cameraCoords.z + direction.z * distance
    }

    local rayHandle = StartShapeTestRay(
        cameraCoords.x, cameraCoords.y, cameraCoords.z,
        destination.x, destination.y, destination.z,
        traceFlags or -1,
        ignoreEntity or 0,
        p8 or 4
    )

    local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
    return hit, entityHit, endCoords
end

local function GetHeadingFromDirection(entity)
    local coords = GetEntityCoords(entity)
    local angle = math.atan2(-coords.x, coords.y)
    return angle * RAD2DEG
end

local function GetHeadDirection(entity)
    local heading = GetEntityHeading(entity) * DEG2RAD
    local x = math.cos(heading)
    local y = -math.sin(heading)
    local angle = math.atan2(y, x)

    return angle * RAD2DEG
end

local function GetEntityHeadingFromEntity(entity, targetEntity)
    local entityCoords = GetEntityCoords(entity)
    local targetCoords = GetEntityCoords(targetEntity)
    local diff = targetCoords - entityCoords
    local angle = math.atan2(-diff.x, diff.y)

    return angle * RAD2DEG
end

local function SetEntityHeadingLookAt(entity, targetEntity)
    local entityCoords = GetEntityCoords(entity)
    local targetCoords = GetEntityCoords(targetEntity)
    local diff = targetCoords - entityCoords
    local angle = math.atan2(-diff.x, diff.y)

    SetEntityHeading(entity, angle * RAD2DEG)
end

local function Draw3DText(x, y, z, text)
    local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)

    if not onScreen then
        return
    end

    SetTextScale(0.6, 0.6)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(screenX, screenY)
end

local function GetEntityVector(entity, direction)
    local result = nil

    if DoesEntityExist(entity) then
        local coords = GetEntityCoords(entity)
        local forward = GetEntityForwardVector(entity)

        if direction == "front" then
            result = coords + (forward / 2.3)
        else
            result = coords - (forward / 2.3)
        end
    end

    return result
end

local function GetExitCoordsFromEntity(action, seatType)
    local ped = PlayerPedId()
    local exitCoords = nil
    local skipExitAnim = false

    if action == "sit" or action == "lay" then
        if seatType == "bed" or seatType == "noback" then
            skipExitAnim = true
            exitCoords = GetEntityVector(ped, "front")
        else
            exitCoords = GetEntityVector(ped, "back")
        end
    elseif action == "back" then
        if not seatType then
            skipExitAnim = true
        end

        exitCoords = GetEntityVector(ped, "front")
    end

    local debugMessage = ("Generating correct exit point for [%s] | [%s] -> [%s]"):format(
        tostring(action),
        tostring(seatType),
        tostring(exitCoords)
    )

    if debugMessage then
        dbg.debug("%s", debugMessage)
    end

    return exitCoords, skipExitAnim
end

local function ExitFunc(seatRegistration)
    local ped = PlayerPedId()
    local chairConfig = SH.data.Chairs[joaat(seatRegistration.model)]

    if not chairConfig then
        return
    end

    local exitCoords, skipExitAnim = GetExitCoordsFromEntity(seatRegistration.seatType, chairConfig.type)

    if chairConfig.type == "bed" then
        ClearPedTasksImmediately(ped)
    end

    currentSeatOption = {}
    ClearCycle("chairs_exit")

    hintState = false
    validEntity = false

    ClearAllHelpMessages()
    FreezeEntityPosition(ped, false)

    if exitCoords then
        SetEntityCoords(ped, exitCoords)
    end

    SetEntityCollision(ped, true, true)

    local exitAnim = ENUMS.ANIMS.EXIT
    local exitHeading = 0.0

    if IsModelInCdimage("ch_prop_casino_door_01b") then
        LoadAnim(exitAnim.animDict)
    else
        dbg.debug("CHAIRS: Failed to detect anim dict [%s] using fallback", exitAnim.animDict)
    end

    if exitCoords and not skipExitAnim then
        TaskPlayAnimAdvanced(
            ped,
            exitAnim.animDict,
            exitAnim.animName,
            exitCoords.x,
            exitCoords.y,
            exitCoords.z,
            0.0,
            0.0,
            exitHeading,
            8.0,
            1.0,
            -1,
            2,
            0.0,
            0.0,
            0.0
        )

        Wait(2500)
    else
        Wait(1500)
    end

    ClearPedTasksImmediately(ped)
    Wait(500)

    dbg.debug("CHAIRS: ExitFunc - activating raycast? 1.")
    HandleRaycastInterval("init")
end

local function GetPointByOffset(entity, offset)
    local point = GetOffsetFromEntityInWorldCoords(entity, offset)

    if not point then
        return nil
    end

    return point
end

local function GetClosestPoint(entity, positions)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    local closestIndex = nil
    local closestPoint = nil

    for index = 1, #positions do
        local offset = positions[index].offset
        local worldPoint = GetPointByOffset(entity, offset)

        if Config.Chairs.DebugSeatPos then
            DrawBox(worldPoint, worldPoint + 0.1, 200, 255, 250, 255)
        end

        local distance = #(worldPoint - pedCoords)
        if distance <= Config.Chairs.SeatDistCheck then
            closestIndex = index
            closestPoint = worldPoint
            break
        end
    end

    return closestIndex, closestPoint
end

local function GetAnimTypeByAction(action, seatData)
    dbg.debug("CHAIRS: Getting anim type by action [%s] | [%s]", action, seatData)

    local animData = nil

    if seatData then
        if action == "sit" or action == "back" then
            animData = seatData.anim.sit or seatData.anim.scenario
        elseif action == "lay" then
            animData = seatData.anim.lay
        end
    else
        dbg.debug("CHAIRS: No data found for anim type [%s]", action)
    end

    dbg.debug("CHAIRS: Anim type found [%s]", animData)
    return animData
end

local function LoadAnimDict(animData)
    RequestAnimDict(animData.dict)

    while not HasAnimDictLoaded(animData.dict) do
        RequestAnimDict(animData.dict)
        Wait(0)
    end
end

local function MakePlayerFaceEntity(ped, entity)
    SetEntityHeadingLookAt(ped, entity)
    TaskTurnPedToFaceEntity(ped, entity, -1)
end

local function HandleInteraction(action, entity, seatData, seatIndex)
    dbg.debug(
        "CHAIRS: Starting sitting interaction at [%s] | [%s] | [%s] | [%s]",
        action,
        entity,
        seatData,
        seatIndex
    )

    local model = seatData and seatData.model or nil
    if not model then
        return dbg.critical("CHAIRS: No model found for entity [%s]", entity)
    end

    dbg.debug("CHAIRS: Model found [%s]", model)

    local animData = GetAnimTypeByAction(action, seatData)
    local targetPoint = CurrentPoint
    local ped = PlayerPedId()

    MakePlayerFaceEntity(ped, entity)
    SetPedResetFlag(ped, 322, true)
    Wait(250)

    local heading = GetEntityHeadingFromEntity(ped, entity)

    if action == "back" then
        heading = GetEntityHeadingFromEntity(ped, entity) - 180
    else
        local brokenOffset = IsEntityHavingBrokenOffset(seatData.model)
        if brokenOffset then
            heading = GetEntityHeadingFromEntity(ped, entity) - brokenOffset
        else
            heading = GetEntityHeadingFromEntity(ped, entity)
        end
    end

    dbg.debug("CHAIRS: Heading for entity [%s] | [%s]", entity, heading)

    if animData.dict then
        dbg.debug("CHAIRS: Loading anim dict [%s]", animData.dict)

        if not DoesAnimDictExist(animData.dict) then
            return dbg.error("CHAIRS: Anim dict [%s] does not exist", animData.dict)
        end

        RequestAnimDict(animData.dict)
        dbg.debug("CHAIRS: Loaded anim dict [%s]", animData.dict)
        dbg.debug("CHAIRS: Anim data [%s] | [%s]", animData.dict, animData.name)

        EXIT_MODE = true

        TaskPlayAnimAdvanced(
            ped,
            animData.dict,
            animData.name,
            targetPoint.x,
            targetPoint.y,
            targetPoint.z,
            0.0,
            0.0,
            heading,
            8.0,
            1.0,
            -1,
            2,
            0.0,
            0,
            0
        )
    else
        dbg.debug("CHAIRS: Anim data [%s] | [%s]", animData.dict, animData.name)

        EXIT_MODE = true

        TaskStartScenarioAtPosition(
            ped,
            animData.name,
            targetPoint.x,
            targetPoint.y,
            targetPoint.z,
            heading,
            0,
            true,
            true
        )
    end

    HandleRaycastInterval("exit")
    Wait(1000)

    dbg.debug("CHAIRS: Player should be sitting loading and exit interval")

    HelpKeys.Show({
        {
            label = _U("CHAIRS.EXIT"),
            keyName = "E"
        }
    }, "top-left")

    SetCycle("chairs_exit", 0, function()
        local pressed = IsControlJustPressed(0, 38)
        if not pressed then
            pressed = IsDisabledControlJustPressed(0, 38)
        end

        if pressed then
            HelpKeys.Hide()

            SetTimeout(1500, function()
                EXIT_MODE = false
                currentRaycastEntity = nil
            end)

            TriggerServerEvent("rcore_prison:server:unregisterSeat", seatIndex, model)
        end
    end)
end

local function IsEntityAModel(entity)
    local ok, lodDist = pcall(GetEntityLodDist, entity)
    local value = ok and lodDist or nil
    return value and value > 0
end

function HandleRaycastInterval(mode)
    if mode == "init" then
        SetCycle("raycast_check", 0, function()
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local hit, entity, hitCoords = RayCastGamePlayCamera(511, 0, 4, 10.0)
            local cameraDistance = #(hitCoords - pedCoords)

            if hit and cameraDistance < 2 then
                if entity ~= currentRaycastEntity and entity ~= 0 then
                    if IsEntityAModel(entity) then
                        local insidePrison = IsPointInPolygon(
                            vec2(pedCoords.x, pedCoords.y),
                            SH.data.prisonVertices
                        )

                        local modelHash = GetEntityModel(entity)

                        if not insidePrison then
                            return
                        end

                        local entityCoords = GetEntityCoords(entity)
                        local entityDistance = #(hitCoords - entityCoords)

                        if entityDistance >= 6.0 then
                            return
                        end

                        local seatData = GetSeatDataFromEntityModel(modelHash)

                        if seatData then
                            local seatType = seatData.type
                            local hints = {}

                            if seatType == "noback" then
                                table.insert(hints, {
                                    label = _U("CHAIRS.SIT_BACK"),
                                    keyName = "E"
                                })
                            elseif seatType == "bed" then
                                table.insert(hints, {
                                    label = _U("CHAIRS.LAY"),
                                    keyName = "H"
                                })
                            elseif seatType == "nobed" then
                                hints[#hints + 1] = {
                                    label = _U("CHAIRS.SIT_FRONT"),
                                    keyName = "E"
                                }
                                hints[#hints + 1] = {
                                    label = _U("CHAIRS.SIT_BACK"),
                                    keyName = "G"
                                }
                            elseif seatType == "back" then
                                hints[#hints + 1] = {
                                    label = _U("CHAIRS.SIT_FRONT"),
                                    keyName = "E"
                                }
                                hints[#hints + 1] = {
                                    label = _U("CHAIRS.LAY"),
                                    keyName = "H"
                                }
                                hints[#hints + 1] = {
                                    label = _U("CHAIRS.SIT_BACK"),
                                    keyName = "G"
                                }
                            end

                            HelpKeys.Show(hints, "top-left")
                            currentSeatOption = HandleSeatOptions(seatData, entity)
                        end
                    else
                        if not SH.zoneId then
                            HelpKeys.Hide()
                        end
                    end
                end
            end

            if currentSeatOption and currentSeatOption.entity ~= currentRaycastEntity then
                entity = 0
            end

            currentRaycastEntity = entity

            if not SH.zoneId and cameraDistance > 4 then
                HelpKeys.Hide()
            end

            Wait(0)
        end)
    else
        ClearCycle("raycast_check")
    end
end

local function GetPlayerPedOrVehicle(playerId)
    local ped = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 or not vehicle then
        return ped
    end

    return vehicle
end

local function GetSeatDataFromEntityModel(modelName)
    local seatData = SH.data.Chairs[joaat(modelName)]

    if not seatData then
        return nil
    end

    return seatData
end

local function IsEntityHavingBrokenOffset(modelName)
    return ENTITY_HEADING_MAP[joaat(modelName)]
end

local function LoadAnim(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
end

local function HandleSeatOptions(seatData, entity)
    local seatIndex = nil
    local worldPoint = nil

    if seatData then
        local positions = seatData.positions
        seatIndex, worldPoint = GetClosestPoint(entity, positions)
    end

    if seatIndex then
        return {
            idx = seatIndex,
            point = worldPoint,
            data = seatData,
            entity = entity
        }
    end
end

function START_SIT_E()
    if EXIT_MODE then
        return
    end

    if currentSeatOption and next(currentSeatOption) then
        CurrentPoint = currentSeatOption.point

        TriggerServerEvent(
            "rcore_prison:server:registerSeat",
            currentSeatOption.entity,
            "sit",
            currentSeatOption.idx,
            currentSeatOption.data.model
        )
    end
end

function START_SIT_BACK()
    if EXIT_MODE then
        return
    end

    if currentSeatOption and next(currentSeatOption) then
        CurrentPoint = currentSeatOption.point

        TriggerServerEvent(
            "rcore_prison:server:registerSeat",
            currentSeatOption.entity,
            "back",
            currentSeatOption.idx,
            currentSeatOption.data.model
        )
    end
end

function START_LAY()
    if EXIT_MODE then
        return
    end

    if currentSeatOption and next(currentSeatOption) then
        CurrentPoint = currentSeatOption.point

        TriggerServerEvent(
            "rcore_prison:server:registerSeat",
            currentSeatOption.entity,
            "lay",
            currentSeatOption.idx,
            currentSeatOption.data.model
        )
    end
end

RegisterKey(START_LAY, "STAND_LAY", "Stand lay", "H")
RegisterKey(START_SIT_BACK, "STAND_BACK", "Stand sit back", "G")
RegisterKey(START_SIT_E, "STAND_FRONT", "Start sit front", "E")