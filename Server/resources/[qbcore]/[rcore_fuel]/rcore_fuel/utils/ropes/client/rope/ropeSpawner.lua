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

WasMemoryClearedSwitch = true

CreateThread(function()
    while true do
        Wait(1000)
        RefreshRopes()
    end
end, "Rope creator")

function TryLoadRopeTexturesAndGetStatus()
    local loadAttempts = 0

    while not RopeAreTexturesLoaded() and loadAttempts < 60 do
        Wait(16)
        RopeLoadTextures()
        loadAttempts = loadAttempts + 1
    end

    return RopeAreTexturesLoaded()
end

function AttachRope(startEntity, endEntity, startOffset, endOffset, ropeConfig)
    if not DoesEntityExist(startEntity) or not DoesEntityExist(endEntity) then
        return
    end

    local startWorldCoords = GetOffsetFromEntityInWorldCoords(startEntity, startOffset)
    local endWorldCoords = GetOffsetFromEntityInWorldCoords(endEntity, endOffset)

    local ropeEntity = AddRope(
        startWorldCoords.x,
        startWorldCoords.y,
        startWorldCoords.z,
        ropeConfig.rotation.x,
        ropeConfig.rotation.y,
        ropeConfig.rotation.z,
        ropeConfig.data.maxLength,
        ropeConfig.data.ropeType,
        ropeConfig.data.initLength,
        ropeConfig.data.minLength,
        ropeConfig.data.lengthChangeRate,
        ropeConfig.data.onlyPPU,
        ropeConfig.data.collisionOn,
        ropeConfig.data.lockFromFront,
        ropeConfig.data.timeMultiplier,
        ropeConfig.data.breakable
    )

    AttachEntitiesToRope(
        ropeEntity,
        startEntity,
        endEntity,
        startWorldCoords.x,
        startWorldCoords.y,
        startWorldCoords.z,
        endWorldCoords.x,
        endWorldCoords.y,
        endWorldCoords.z,
        ropeConfig.data.initLength / 2,
        false,
        false,
        nil,
        nil
    )

    WasMemoryClearedSwitch = false
    return ropeEntity
end

function DestroyCachedRope(ropeEntry)
    if ropeEntry.ropeEntity then
        DeleteRope(ropeEntry.ropeEntity)
    end
    ropeEntry.ropeEntity = nil
    ropeEntry.created = nil
end

function MarkRopeCreatedIfValid(ropeEntry, ropeEntity)
    if ropeEntity then
        ropeEntry.ropeEntity = ropeEntity
        ropeEntry.created = true
        return true
    end
    -- Texture/entity creation can fail transiently. Leave it retryable next refresh.
    ropeEntry.ropeEntity = nil
    ropeEntry.created = nil
    return false
end

function RefreshRopes()
    for ropeHandler, ropeEntry in pairs(RopeCache) do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if ropeEntry.ropeType == RopeType.Attached then
            local entityData = ropeEntry.entityData
            local entityAttachData = ropeEntry.entityAttachData
            local firstEntityType = entityData[1]
            local secondEntityType = entityAttachData[1]

            if firstEntityType == EntityType.Networked and secondEntityType == EntityType.Networked then
                local _, firstNetId = GetDataFromEntityRope(entityData)
                local _, secondNetId = GetDataFromEntityRope(entityAttachData)
                local endpointsExist = NetworkDoesEntityExistWithNetworkId(firstNetId)
                    and NetworkDoesEntityExistWithNetworkId(secondNetId)

                if endpointsExist then
                    local firstEntityCoords = GetEntityCoords(NetToEnt(firstNetId))
                    local distanceToPlayer = #(playerCoords - firstEntityCoords)

                    if distanceToPlayer <= 30 then
                        if not ropeEntry.ropeEntity and not RopeCache[ropeHandler].created then
                            if TryLoadRopeTexturesAndGetStatus() then
                                MarkRopeCreatedIfValid(ropeEntry, AttachRope(
                                    NetToEnt(firstNetId),
                                    NetToEnt(secondNetId),
                                    ropeEntry.ropeStartPos,
                                    ropeEntry.ropeEndPos,
                                    ropeEntry
                                ))
                            else
                                ropeEntry.created = nil
                            end
                        end
                    elseif ropeEntry.ropeEntity then
                        DestroyCachedRope(ropeEntry)
                    end
                elseif ropeEntry.ropeEntity or ropeEntry.created then
                    DestroyCachedRope(ropeEntry)
                end
            elseif (firstEntityType == EntityType.Networked and secondEntityType == EntityType.Local)
                or (firstEntityType == EntityType.Local and secondEntityType == EntityType.Networked) then

                local networkedEntityData = entityData
                local localEntityData = entityAttachData

                if firstEntityType == EntityType.Local then
                    networkedEntityData = entityAttachData
                    localEntityData = entityData
                end

                local _, networkId = GetDataFromEntityRope(networkedEntityData)
                local _, localCoords, modelHash = GetDataFromEntityRope(localEntityData)
                local distanceToLocal = #(playerCoords - localCoords)
                local networkExists = NetworkDoesEntityExistWithNetworkId(networkId)

                if distanceToLocal <= 30 and networkExists then
                    local localEntity = GetClosestObjectOfType(localCoords, 3.0, modelHash, false, false, false)
                    if DoesEntityExist(localEntity) then
                        if not ropeEntry.ropeEntity and not RopeCache[ropeHandler].created then
                            if TryLoadRopeTexturesAndGetStatus() then
                                MarkRopeCreatedIfValid(ropeEntry, AttachRope(
                                    NetToEnt(networkId),
                                    localEntity,
                                    ropeEntry.ropeStartPos,
                                    ropeEntry.ropeEndPos,
                                    ropeEntry
                                ))
                            else
                                ropeEntry.created = nil
                            end
                        end
                    elseif ropeEntry.ropeEntity or ropeEntry.created then
                        DestroyCachedRope(ropeEntry)
                    end
                elseif ropeEntry.ropeEntity or ropeEntry.created then
                    DestroyCachedRope(ropeEntry)
                end
            elseif firstEntityType == EntityType.Local and secondEntityType == EntityType.Local then
                local _, firstLocalCoords, firstModelHash = GetDataFromEntityRope(entityData)
                local _, secondLocalCoords, secondModelHash = GetDataFromEntityRope(entityAttachData)
                local distanceToFirst = #(playerCoords - firstLocalCoords)
                local distanceToSecond = #(playerCoords - secondLocalCoords)

                if distanceToFirst <= 30 and distanceToSecond <= 30 then
                    local firstEntity = GetClosestObjectOfType(firstLocalCoords, 3.0, firstModelHash, false, false, false)
                    local secondEntity = GetClosestObjectOfType(secondLocalCoords, 3.0, secondModelHash, false, false, false)

                    if DoesEntityExist(firstEntity) and DoesEntityExist(secondEntity) then
                        if not ropeEntry.ropeEntity and not RopeCache[ropeHandler].created then
                            if TryLoadRopeTexturesAndGetStatus() then
                                MarkRopeCreatedIfValid(ropeEntry, AttachRope(
                                    firstEntity,
                                    secondEntity,
                                    ropeEntry.ropeStartPos,
                                    ropeEntry.ropeEndPos,
                                    ropeEntry
                                ))
                            else
                                ropeEntry.created = nil
                            end
                        end
                    elseif ropeEntry.ropeEntity or ropeEntry.created then
                        DestroyCachedRope(ropeEntry)
                    end
                elseif ropeEntry.ropeEntity or ropeEntry.created then
                    DestroyCachedRope(ropeEntry)
                end
            end
        elseif ropeEntry.ropeType == RopeType.Static then
            local distanceToStart = #(playerCoords - ropeEntry.ropeStartPos)

            if distanceToStart <= 30 then
                if not ropeEntry.ropeEntity and not RopeCache[ropeHandler].created then
                    if TryLoadRopeTexturesAndGetStatus() then
                        WasMemoryClearedSwitch = false
                        MarkRopeCreatedIfValid(ropeEntry, AddRope(
                            ropeEntry.ropeStartPos.x,
                            ropeEntry.ropeStartPos.y,
                            ropeEntry.ropeStartPos.z,
                            ropeEntry.rotation.x,
                            ropeEntry.rotation.y,
                            ropeEntry.rotation.z,
                            ropeEntry.data.maxLength,
                            ropeEntry.data.ropeType,
                            ropeEntry.data.initLength,
                            ropeEntry.data.minLength,
                            ropeEntry.data.lengthChangeRate,
                            ropeEntry.data.onlyPPU,
                            ropeEntry.data.collisionOn,
                            ropeEntry.data.lockFromFront,
                            ropeEntry.data.timeMultiplier,
                            ropeEntry.data.breakable
                        ))
                    else
                        ropeEntry.created = nil
                    end
                end
            elseif ropeEntry.ropeEntity or ropeEntry.created then
                DestroyCachedRope(ropeEntry)
            end
        end
    end

    if not IsAnyRopeActive() then
        if not WasMemoryClearedSwitch then
            WasMemoryClearedSwitch = true
            TriggerEvent("rcore_fuel:unloadedRopeTextures")
        end
    end

    if IsAnyRopeActive() and not RopeAreTexturesLoaded() then
        RopeLoadTextures()
    end
end

function GetDataFromEntityRope(entityRopeData)
    if entityRopeData[1] == EntityType.Networked then
        return entityRopeData[1], entityRopeData[2]
    end

    if entityRopeData[1] == EntityType.Local then
        return entityRopeData[1], entityRopeData[2], entityRopeData[3]
    end
end
