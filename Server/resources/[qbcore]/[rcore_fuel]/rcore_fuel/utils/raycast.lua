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

function CastRayCast(startCoords, endCoords, flags, ignoreEntity)
    if not flags then
        flags = 17
    end

    if not ignoreEntity then
        ignoreEntity = PlayerPedId()
    end

    local shapeTestHandle = StartShapeTestRay(
        startCoords.x, startCoords.y, startCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        flags, ignoreEntity, 1
    )

    return GetShapeTestResultIncludingMaterial(shapeTestHandle)
end

function CastRayCastFromPlayer(ignoreEntity, flags, distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local cameraCoords = GetGameplayCamCoord()
    local cameraDirection = RotationToDirection(GetGameplayCamRot())

    if not distance then
        distance = 15.0
    end

    local targetCoords = {
        x = cameraCoords.x + cameraDirection.x * distance,
        y = cameraCoords.y + cameraDirection.y * distance,
        z = cameraCoords.z + cameraDirection.z * distance,
    }

    if not flags then
        flags = 17
    end

    if not ignoreEntity then
        ignoreEntity = PlayerPedId()
    end

    local shapeTestHandle = StartShapeTestRay(
        playerCoords.x, playerCoords.y, playerCoords.z,
        targetCoords.x, targetCoords.y, targetCoords.z,
        flags, ignoreEntity, 1
    )

    local retval, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTestHandle)

    if hit == 0 then
        hitCoords = vector3(targetCoords.x, targetCoords.y, targetCoords.z)
    end

    return retval, hit, hitCoords, surfaceNormal, entityHit, playerCoords
end
