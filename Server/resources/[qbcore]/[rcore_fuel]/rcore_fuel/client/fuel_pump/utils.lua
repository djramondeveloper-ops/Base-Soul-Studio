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

local dispenserRopeId = nil
local fuelPourFxHandle = nil
local fuelFxGeneration = 0
local dispenserGunEntity = nil
local isHoldingDispenserGun = false

function IsPlayerHoldingDispenserGun()
    return isHoldingDispenserGun
end

function SetPlayerStateHoldingDispenserGun(state)
    isHoldingDispenserGun = state
end

function StartFuelFXOnEntity(entity, onComplete)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    StopFuelFXOnEntity()
    local generation = fuelFxGeneration

    local ptfxAsset = "core"
    RequestNamedPtfxAsset(ptfxAsset)

    local timeoutAt = GetGameTimer() + 5000
    while not HasNamedPtfxAssetLoaded(ptfxAsset) and GetGameTimer() < timeoutAt do
        Wait(0)
    end
    if not HasNamedPtfxAssetLoaded(ptfxAsset) then
        print("[rcore_fuel] Timed out loading fuel particle effects.")
        return false
    end
    if generation ~= fuelFxGeneration or not DoesEntityExist(entity) then return false end

    SetPtfxAssetNextCall(ptfxAsset)
    fuelPourFxHandle = StartParticleFxLoopedOnEntity("weap_petrol_can", entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    local handle = fuelPourFxHandle
    Wait(5000)

    if generation == fuelFxGeneration and fuelPourFxHandle == handle then
        if onComplete then
            onComplete()
        end

        -- The completion callback may already stop fueling and delete the FX.
        if fuelPourFxHandle == handle then
            StopParticleFxLooped(handle, 0)
            fuelPourFxHandle = nil
        end
    end

    if generation == fuelFxGeneration then RemoveNamedPtfxAsset(ptfxAsset) end
end

function IsPouringFuelFXPlaying()
    return fuelPourFxHandle ~= nil
end

function StopFuelFXOnEntity()
    fuelFxGeneration = fuelFxGeneration + 1
    if fuelPourFxHandle ~= nil then
        StopParticleFxLooped(fuelPourFxHandle, 0)
        -- FIX 5: clear the handle here too, matching StartFuelFXOnEntity's own
        -- cleanup, so IsPouringFuelFXPlaying() can actually detect an early stop
        fuelPourFxHandle = nil
    end
end

function GetEntityDispenserGun()
    return dispenserGunEntity
end

function AttachFuelNozzleToPed(nozzle, ped, handBone)
    if not nozzle or not DoesEntityExist(nozzle) or not DoesEntityExist(ped) then return false end
    SetEntityCollision(nozzle, false, false)
    -- Follow the animated left hand rather than the separate IK target.
    AttachEntityToEntity(nozzle, ped, GetPedBoneIndex(ped, handBone or 18905),
        0.05, 0.0, 0.0, 0.0, -90.0, -90.0,
        true, true, false, true, 0, true)
    return true
end

function EquipDispenserGun(pumpEntity, side)
    if not pumpEntity or pumpEntity == 0 or not DoesEntityExist(pumpEntity) then return false end

    local playerPed = PlayerPedId()
    local ropeAttachOffset = GetOffsetCoordsForRopeFuelDispenser(pumpEntity, side)
    if not ropeAttachOffset then return false end
    local gunModel = GetDispenserGunModel(GetEntityModel(pumpEntity))

    dispenserGunEntity = CreateNetworkedObject(gunModel, GetEntityCoords(playerPed))
    if not dispenserGunEntity or dispenserGunEntity == 0 or not DoesEntityExist(dispenserGunEntity) then
        dispenserGunEntity = nil
        print("[rcore_fuel] Failed to create dispenser nozzle object.")
        return false
    end
    if IsEntityDead(playerPed) or IsPedRagdoll(playerPed) or PlayerPedId() ~= playerPed then
        DisposeDispenserGun()
        return false
    end
    SetEntityCollision(dispenserGunEntity, false, false)

    local gunAttachOffset = vector3(0, 0, -0.17)
    AttachFuelNozzleToPed(dispenserGunEntity, playerPed)

    dispenserRopeId = AttachSyncedRopeToEntity(
        { EntityType.Networked, ObjToNet(dispenserGunEntity) },
        { EntityType.Local, GetEntityCoords(pumpEntity), GetEntityModel(pumpEntity) },
        gunAttachOffset,
        ropeAttachOffset,
        vec3(0.0, 0.0, 0.0)
    )

    if not dispenserRopeId then
        DisposeDispenserGun()
        ShowNotification("The fuel hose could not sync. Please try picking up the nozzle again.")
        return false
    end
    if not dispenserGunEntity or not DoesEntityExist(dispenserGunEntity)
        or PlayerPedId() ~= playerPed or IsEntityDead(playerPed) or IsPedRagdoll(playerPed) then
        DisposeDispenserGun()
        return false
    end
    return true
end

function DisposeDispenserGun()
    if dispenserRopeId then
        DeleteSyncedRope(dispenserRopeId)
        dispenserRopeId = nil
    end
    if dispenserGunEntity and dispenserGunEntity ~= 0 and DoesEntityExist(dispenserGunEntity) then
        DeleteEntity(dispenserGunEntity)
    end
    dispenserGunEntity = nil
    isHoldingDispenserGun = false
    StopFuelFXOnEntity()
end

function GetVehicleOffsetFuelingAnimation(vehicleModel)
    local fuelingOffset = ExistingFuelingOffsetVehicles[vehicleModel]
        or ExistingFuelingOffsetVehicles[vehicleModel - 4294967296]
        or ExistingFuelingOffsetVehicles[vehicleModel + 4294967296]

    if fuelingOffset then
        return vector3(fuelingOffset.offset.x, fuelingOffset.offset.y, fuelingOffset.offset.z), fuelingOffset.heading, true
    end

    return vector3(-1.5, -2.0, 0.0), 100.0
end

function GetVehicleFuelingPosition(vehicle)
    local model = GetEntityModel(vehicle)
    local offset, heading, configured = GetVehicleOffsetFuelingAnimation(model)
    if not configured then
        local minimum, maximum = GetModelDimensions(model)
        local cap = GetEntityBoneIndexByName(vehicle, "petrolcap")
        if cap ~= -1 then
            local position = GetWorldPositionOfEntityBone(vehicle, cap)
            local localCap = GetOffsetFromEntityGivenWorldCoords(vehicle, position.x, position.y, position.z)
            local right = localCap.x > 0
            offset = vector3(right and (maximum.x + 0.55) or (minimum.x - 0.55), localCap.y, 0.0)
            heading = right and 270.0 or 90.0
        else
            offset = vector3(minimum.x - 0.55, minimum.y * 0.65, 0.0)
            heading = 90.0
        end
    end
    local position = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    return vector3(position.x, position.y, GetGroundLevelZ(position)), (GetEntityHeading(vehicle) - heading) % 360
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    -- FIX 4: removed duplicate DeleteEntity; DisposeDispenserGun already deletes the entity
    DisposeDispenserGun()
end)
