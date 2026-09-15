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

PhantomMissionState = {
    phantomVeh = 0,
    phantomTrailer = 0,
    hoseFuelerStatus = false,
    hoseAttachedToValve = false,
    disableHoseForTruck = false,
    cantTankAnymore = false,
    switchFuelEnterMission = false,
    pointToNewMission = false,
    rope = 0,
    invisibleRope = 0,
    object = 0,
    fuelNozzle = 0,
    finalOutfitMarker = nil,
}

local defaultPhantomMissionState = DeepCopy(PhantomMissionState)
local isPhantomActionBusy = false

CreateVariableResetCallback(function()
    DeleteEntity(PhantomMissionState.phantomVeh)
    DeleteEntity(PhantomMissionState.phantomTrailer)
    DeleteEntity(PhantomMissionState.object)
    DeleteSyncedRope(PhantomMissionState.rope)
    DeleteSyncedRope(PhantomMissionState.invisibleRope)

    if PhantomMissionState.fuelNozzle then
        DeleteEntity(PhantomMissionState.fuelNozzle)
        PhantomMissionState.fuelNozzle = nil
    end

    -- FIX 12: finalOutfitMarker (a createMarker() object backed by markers.lua's
    -- shared registry) was never destroyed on mission reset -- just discarding the
    -- reference left it permanently registered in that shared render/interaction
    -- loop, an orphaned marker that never goes away.
    if PhantomMissionState.finalOutfitMarker then
        PhantomMissionState.finalOutfitMarker.destroy()
        PhantomMissionState.finalOutfitMarker = nil
    end

    Config.MissionHelpMarkers[5].render = true
    Config.MissionHelpMarkers[6].render = true
    PhantomMissionState = DeepCopy(defaultPhantomMissionState)
    isPhantomActionBusy = false
end)

function GetPhantomVehicleEntity()
    return PhantomMissionState.phantomVeh
end

function GetTrailerVehicleEntity()
    return PhantomMissionState.phantomTrailer
end

function AttachInvisibleRopeToPlayerForTanker(_trailerEntity)
    if not Config.DisableRopes then
        return
    end

    local playerPed = PlayerPedId()
    PhantomMissionState.fuelNozzle = CreateNetworkedObject("prop_cs_fuel_nozle", GetEntityCoords(playerPed))

    AttachEntityToEntity(
        PhantomMissionState.fuelNozzle, playerPed,
        GetPedBoneIndex(GetPlayerPed(PlayerId()), 36029),
        0.05, 0.0, 0.0,
        0.0, -90.0, -90.0,
        1, 1, 0, 1, 0, 1
    )
end

function DeleteInvisibleRope()
    if PhantomMissionState.invisibleRope ~= 0 then
        DeleteRope(PhantomMissionState.invisibleRope)
        PhantomMissionState.invisibleRope = 0
    end

    if Config.DisableRopes and PhantomMissionState.fuelNozzle then
        DeleteEntity(PhantomMissionState.fuelNozzle)
        PhantomMissionState.fuelNozzle = nil
    end
end

function AttachRopeToTruckAndFuelTank(fuelTankEntity, attachToTank)
    local playerPed = PlayerPedId()
    local trailerEntity = PhantomMissionState.phantomTrailer
    local interactionPosition = GetOffsetFromEntityInWorldCoords(fuelTankEntity, vector3(1.0, 0, 0))

    if not GoToCoordsWithHeadingInTime(playerPed, interactionPosition, GetEntityHeading(fuelTankEntity) - 270, 1500) then
        return
    end
    PhantomMissionState.hoseAttachedToValve = attachToTank
    Animation.Play("mechanic")
    Wait(2000)

    if attachToTank then
        local trailerOffset = vector3(1, -6.1, -1.1)
        local tankOffset = vector3(0.15, 0, 1.2)

        DeleteSyncedRope(PhantomMissionState.rope)
        DeleteEntity(PhantomMissionState.object)
        DeleteInvisibleRope()

        PhantomMissionState.rope = AttachSyncedRopeToEntity(
            { EntityType.Networked, ObjToNet(trailerEntity) },
            { EntityType.Local, GetEntityCoords(fuelTankEntity), GetEntityModel(fuelTankEntity) },
            trailerOffset,
            tankOffset,
            vec3(0.0, 0.0, 0.0)
        )
    else
        local trailerOffset = vector3(1, -6.1, -1.1)
        local handOffset = vector3(0.0, 0, 0.0)

        PhantomMissionState.object = CreateNetworkedObject("p_cs_cam_phone", GetEntityCoords(playerPed))
        AttachEntityToEntity(
            PhantomMissionState.object, playerPed,
            GetPedBoneIndex(GetPlayerPed(PlayerId()), 6286),
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            1, 1, 0, 1, 0, 1
        )
        SetEntityAlpha(PhantomMissionState.object, 0.0)

        DeleteSyncedRope(PhantomMissionState.rope)
        PhantomMissionState.rope = AttachSyncedRopeToEntity(
            { EntityType.Networked, ObjToNet(trailerEntity) },
            { EntityType.Networked, ObjToNet(PhantomMissionState.object) },
            trailerOffset,
            handOffset,
            vec3(0.0, 0.0, 0.0)
        )

        AttachInvisibleRopeToPlayerForTanker(PhantomMissionState.phantomTrailer)
    end

    Wait(1000)
    ClearPedTasks(playerPed)
    FreezePlayerControls(false)
end

function SetEquipHoseFuelerStatus(enableHose)
    local playerPed = PlayerPedId()
    local trailerEntity = PhantomMissionState.phantomTrailer

    if not trailerEntity then
        return
    end

    if not GoToCoordsWithHeadingInTime(
        playerPed,
        GetOffsetFromEntityInWorldCoords(trailerEntity, vector3(1, -7.0, -2.5)),
        GetEntityHeading(trailerEntity),
        1500
    ) then
        return
    end

    FreezeEntityPosition(trailerEntity, enableHose)

    PhantomMissionState.object = CreateNetworkedObject("p_cs_cam_phone", GetEntityCoords(playerPed))
    AttachEntityToEntity(
        PhantomMissionState.object, playerPed,
        GetPedBoneIndex(GetPlayerPed(PlayerId()), 6286),
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        1, 1, 0, 1, 0, 1
    )
    SetEntityAlpha(PhantomMissionState.object, 0.0)

    Wait(500)

    local hoseCamera = CreateCamera(GetGameplayCamCoord(), GetGameplayCamRot())
    FreezePlayerControls(true)
    hoseCamera.startRendering()

    local cameraPosition = GetOffsetFromEntityInWorldCoords(trailerEntity, vector3(1, -10.0, -2.0))
    hoseCamera.moveCameraSmoothlyFromPoints({
        {
            pos = cameraPosition,
            rot = vector3(20.0, 0.0, GetEntityHeading(trailerEntity)),
            duration = 1500,
            options = {
                fov = 50.0,
                copyEffects = false,
                offsetDuration = 0,
            },
        },
    })

    Wait(100)
    Animation.Play("namaste")
    Wait(2000)

    if enableHose then
        AttachInvisibleRopeToPlayerForTanker(PhantomMissionState.phantomTrailer)
        PhantomMissionState.rope = AttachSyncedRopeToEntity(
            { EntityType.Networked, ObjToNet(trailerEntity) },
            { EntityType.Networked, ObjToNet(PhantomMissionState.object) },
            vector3(1, -6.1, -1.1),
            vector3(0.0, 0.0, 0.0),
            vec3(0.0, 0.0, 0.0)
        )
    else
        DeleteSyncedRope(PhantomMissionState.rope)
        DeleteInvisibleRope()
    end

    PhantomMissionState.hoseFuelerStatus = enableHose
    hoseCamera.exitCameraSmoothly(1500)
    FreezePlayerControls(false)
    ClearPedTasks(playerPed)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    DeleteSyncedRope(PhantomMissionState.rope)
    DeleteEntity(PhantomMissionState.object)
end)

AddEventHandler("rcore_fuel:playerIsTryingToEnterVehicle", function(vehicleEntity)
    if vehicleEntity ~= PhantomMissionState.phantomVeh then
        return
    end

    local missionName = GetMissionName()

    if missionName ~= "tank_phantom_fuel" then
        SetVehicleDoorsLocked(vehicleEntity, 1)

        if not PhantomMissionState.switchFuelEnterMission then
            CreateBlipMission(Config.BlipOnMapAfterPickingUpTruck)
            CreateMissionZone(Config.BlipOnMapAfterPickingUpTruck, "tank_phantom_fuel", 5)
            PhantomMissionState.switchFuelEnterMission = true
        end
    end

    if missionName == "tank_phantom_fuel" then
        SetVehicleDoorsLocked(vehicleEntity, 1)
    end
end)

AddEventHandler("rcore_fuel:playerIsExitingVehicle", function(vehicleEntity)
    if vehicleEntity == PhantomMissionState.phantomVeh then
        SetVehicleDoorsLocked(vehicleEntity, 2)
    end
end)

function DestroyMissionFuelPipeSoundsAfterDelay(fuelPipeConfig, generation, eleSound, pumpSound)
    Wait(Config.FuelingTankerTime + 1000)

    -- A later mission can reuse the same config entry before this delayed cleanup
    -- fires. Never let an old timer destroy a newer mission's sounds.
    if fuelPipeConfig.soundGeneration ~= generation then
        return
    end

    if fuelPipeConfig.eleSound == eleSound and eleSound then
        pcall(function() eleSound.Destroy() end)
        fuelPipeConfig.eleSound = nil
    end

    if fuelPipeConfig.pumpSound == pumpSound and pumpSound then
        pcall(function() pumpSound.Destroy() end)
        fuelPipeConfig.pumpSound = nil
    end
end

RegisterNetEvent("rcore_fuel:missionFuelpipe:setStatus", function(isBusy)
    local missionFuelPipe = Config.MissionFuelPipe
    missionFuelPipe.busy = isBusy

    missionFuelPipe.soundGeneration = (missionFuelPipe.soundGeneration or 0) + 1
    local soundGeneration = missionFuelPipe.soundGeneration

    if isBusy then
        if missionFuelPipe.eleSound then
            pcall(function() missionFuelPipe.eleSound.Destroy() end)
            missionFuelPipe.eleSound = nil
        end

        if missionFuelPipe.pumpSound then
            pcall(function() missionFuelPipe.pumpSound.Destroy() end)
            missionFuelPipe.pumpSound = nil
        end

        missionFuelPipe.eleSound = CreateSoundHandler("ele_fuelPipe_1")
        missionFuelPipe.eleSound.LoadSound(SoundEffect.FUEL_PUMP_SOUND_ELE_LOOP)
        missionFuelPipe.eleSound.SetPlayingPosition(missionFuelPipe.pos)
        missionFuelPipe.eleSound.SetVolume(Config.ElectricHummingVolume or 0.4)
        missionFuelPipe.eleSound.SetLoop(true)
        missionFuelPipe.eleSound.SetAutoPlay(true)
        missionFuelPipe.eleSound.CreateMedia()

        missionFuelPipe.pumpSound = CreateSoundHandler("pump_fuelPipe_1")
        missionFuelPipe.pumpSound.LoadSound(SoundEffect.LIQUID_POURING_LOOP)
        missionFuelPipe.pumpSound.SetPlayingPosition(missionFuelPipe.pos)
        missionFuelPipe.pumpSound.SetVolume(Config.LiquidVolume or 0.75)
        missionFuelPipe.pumpSound.SetLoop(true)
        missionFuelPipe.pumpSound.SetAutoPlay(true)
        missionFuelPipe.pumpSound.CreateMedia()

        local eleSound = missionFuelPipe.eleSound
        local pumpSound = missionFuelPipe.pumpSound
        CreateThread(function()
            DestroyMissionFuelPipeSoundsAfterDelay(missionFuelPipe, soundGeneration, eleSound, pumpSound)
        end, "destroying fuel pumping sound")
    else
        if missionFuelPipe.eleSound then
            missionFuelPipe.eleSound.Destroy()
            missionFuelPipe.eleSound = nil
        end

        if missionFuelPipe.pumpSound then
            missionFuelPipe.pumpSound.Destroy()
            missionFuelPipe.pumpSound = nil
        end
    end
end)

function HandleHoseAttachmentToPhantomTrailerValve()
    local playerPed = PlayerPedId()
    local trailerEntity = PhantomMissionState.phantomTrailer

    if not trailerEntity
        or PhantomMissionState.hoseAttachedToValve
        or PhantomMissionState.disableHoseForTruck
        or not DoesEntityExist(trailerEntity)
    then
        return
    end

    local valvePosition = GetOffsetFromEntityInWorldCoords(trailerEntity, vector3(1, -6.5, -2.5))
    local distanceToValve = #(valvePosition - GetEntityCoords(playerPed))

    if distanceToValve >= 2.5 then
        return
    end

    isPhantomActionBusy = true
    SetEquipHoseFuelerStatus(not PhantomMissionState.hoseFuelerStatus)

    if PhantomMissionState.pointToNewMission then
        CreateBlipMission(Config.DespawnPhantomTruckLocation)
        CreateMissionZone(Config.DespawnPhantomTruckLocation, "despawn_phantom", 10)
        PhantomMissionState.pointToNewMission = false
    end

    isPhantomActionBusy = false
end

CreateThread(function()
    local hasShownNozzleHelp = false

    while true do
        Wait(1000)

        if DoesEntityExist(PhantomMissionState.phantomTrailer) then
            local playerPed = PlayerPedId()
            local valvePosition = GetOffsetFromEntityInWorldCoords(
                PhantomMissionState.phantomTrailer,
                vector3(1, -6.5, -2.5)
            )
            local distanceToValve = #(valvePosition - GetEntityCoords(playerPed))

            if distanceToValve < 2.5 and not hasShownNozzleHelp then
                hasShownNozzleHelp = true
                ShowHelpNotification(_U("phantom_nozzle_info"), false, true, 10000)
            elseif distanceToValve > 10.0 then
                -- FIX 3: only reset once player is clearly away (>10m),
                -- not immediately on leaving 2.5m, which caused notification spam
                hasShownNozzleHelp = false
            end
        else
            Wait(10000)
        end
    end
end, "message for phantom truck")

function UpdateFinalTankerFuelCapacity(shopId, fuelData, fuelPipeConfig, generation)
    local finishTime = GetGameTimer() + Config.FuelingTankerTime
    local fuelToTank = fuelData.fuelToTank
    local fueledAmount = 0

    while finishTime > GetGameTimer() and fuelToTank > fueledAmount
        and fuelPipeConfig.isFuelingBroadcast == true and fuelPipeConfig.soundGeneration == generation do
        local remainingTime = finishTime - GetGameTimer()
        local remainingFuel = fuelToTank - fueledAmount
        local waitDuration = math.min(remainingTime, 1000)
        Wait(waitDuration)

        -- FIX 2: guard division by zero on the final tick when remainingTime == 0
        local divisor = (waitDuration > 0) and (remainingTime / waitDuration) or 1
        local fuelIncrement = remainingFuel / divisor
        fueledAmount = fueledAmount + fuelIncrement

        -- FIX 11: guard nil capacity table before incrementing
        local shopCapacity = Config.ShopList[shopId] and Config.ShopList[shopId].capacity
        if shopCapacity and shopCapacity[fuelData.fuelType] ~= nil then
            shopCapacity[fuelData.fuelType] = shopCapacity[fuelData.fuelType] + fuelIncrement
        end

        if #(GetEntityCoords(PlayerPedId()) - fuelPipeConfig.pos) < 10 then
            RefreshScaleformByIdentifier(shopId)
        end
    end
end

RegisterNetEvent("rcore_fuel:startFinalTankerSound", function(shouldPlay, shopId, fuelData)
    local finalFuelPipe = Config.FinalFuelPipe and Config.FinalFuelPipe[shopId]
    if not finalFuelPipe then
        return
    end

    finalFuelPipe.soundGeneration = (finalFuelPipe.soundGeneration or 0) + 1
    local generation = finalFuelPipe.soundGeneration

    -- Always tear down the previous generation first. Duplicate/late network events
    -- otherwise stack looped media instances on the same station pipe.
    if finalFuelPipe.eleSound then
        pcall(function() finalFuelPipe.eleSound.Destroy() end)
        finalFuelPipe.eleSound = nil
    end
    if finalFuelPipe.pumpSound then
        pcall(function() finalFuelPipe.pumpSound.Destroy() end)
        finalFuelPipe.pumpSound = nil
    end

    if not shouldPlay then
        finalFuelPipe.isFuelingBroadcast = false
        return
    end

    finalFuelPipe.isFuelingBroadcast = true
    finalFuelPipe.eleSound = CreateSoundHandler()
    finalFuelPipe.eleSound.LoadSound(SoundEffect.FUEL_PUMP_SOUND_ELE_LOOP)
    finalFuelPipe.eleSound.SetPlayingPosition(finalFuelPipe.pos)
    finalFuelPipe.eleSound.SetVolume(Config.ElectricHummingVolume or 0.4)
    finalFuelPipe.eleSound.SetLoop(true)
    finalFuelPipe.eleSound.SetAutoPlay(true)
    finalFuelPipe.eleSound.CreateMedia()

    finalFuelPipe.pumpSound = CreateSoundHandler()
    finalFuelPipe.pumpSound.LoadSound(SoundEffect.LIQUID_POURING_LOOP)
    finalFuelPipe.pumpSound.SetPlayingPosition(finalFuelPipe.pos)
    finalFuelPipe.pumpSound.SetVolume(Config.LiquidVolume or 0.75)
    finalFuelPipe.pumpSound.SetLoop(true)
    finalFuelPipe.pumpSound.SetAutoPlay(true)
    finalFuelPipe.pumpSound.CreateMedia()

    local eleSound = finalFuelPipe.eleSound
    local pumpSound = finalFuelPipe.pumpSound

    if fuelData then
        CreateThread(function()
            UpdateFinalTankerFuelCapacity(shopId, fuelData, finalFuelPipe, generation)
        end, "phantom refueling reserves")
    end

    CreateThread(function()
        Wait(Config.FuelingTankerTime)
        if finalFuelPipe.soundGeneration ~= generation then return end
        finalFuelPipe.isFuelingBroadcast = false

        if finalFuelPipe.eleSound == eleSound and eleSound then
            pcall(function() eleSound.Destroy() end)
            finalFuelPipe.eleSound = nil
        end
        if finalFuelPipe.pumpSound == pumpSound and pumpSound then
            pcall(function() pumpSound.Destroy() end)
            finalFuelPipe.pumpSound = nil
        end
    end, "final tanker sound timeout")
end)

function OnFinalTankerFuelKeyPress()
    if GetMissionName() ~= "tank_the_final_tanker" or isPhantomActionBusy then
        return
    end

    local playerPed = PlayerPedId()
    local shopId = GetShopIdFromMissionIdentifier(MissionIdentifier)
    local finalFuelPipe = shopId and Config.FinalFuelPipe[shopId]
    local spawnObject = shopId and Config.SpawnObject[shopId]
    if not finalFuelPipe or not spawnObject then
        return
    end
    local distanceToPipe = #(finalFuelPipe.pos - GetEntityCoords(playerPed))

    if distanceToPipe >= 3.0 or not PhantomMissionState.hoseFuelerStatus or PhantomMissionState.cantTankAnymore then
        HandleHoseAttachmentToPhantomTrailerValve()
        return
    end

    if not finalFuelPipe.busy then
        isPhantomActionBusy = true

        AttachRopeToTruckAndFuelTank(
            spawnObject.entity,
            true
        )

        finalFuelPipe.busy = true
        finalFuelPipe.modalBar = CreateProgressBarAtLocation()
        finalFuelPipe.modalBar.SetPosition(GetEntityCoords(PlayerPedId()) + vector3(0, 0, 1))
        finalFuelPipe.modalBar.SetDescription(_U("final_pumping"))
        finalFuelPipe.modalBar.SetProgressBarTime(Config.FuelingTankerTime)
        finalFuelPipe.modalBar.Create()

        -- FIX 5: pass PendingMissionFuelData so all clients can run UpdateFinalTankerFuelCapacity
        TriggerServerEvent("rcore_fuel:startFinalTankerSound", true, shopId, PendingMissionFuelData)
        Wait(Config.FuelingTankerTime)
        TriggerServerEvent("rcore_fuel:startFinalTankerSound", false, shopId)
        -- FIX 10: guard against mission being cancelled during the blocking Wait
        if IsPlayerInMission() then
            TriggerServerEvent("rcore_fuel:finishTheMission")
        end
        isPhantomActionBusy = false
        return
    end

    isPhantomActionBusy = true
    PhantomMissionState.cantTankAnymore = true
    finalFuelPipe.busy = nil

    AttachRopeToTruckAndFuelTank(
        spawnObject.entity,
        false
    )

    finalFuelPipe.modalBar.Delete()
    finalFuelPipe.modalBar = nil
    ShowHelpNotification(_U("go_store_phantom"), false, true, 10000)
    PhantomMissionState.pointToNewMission = true
    isPhantomActionBusy = false
end

function OnPhantomFuelPipeKeyPress()
    if GetMissionName() ~= "tank_phantom_fuel" or isPhantomActionBusy then
        return
    end

    Wait(500)

    local playerPed = PlayerPedId()
    local missionFuelPipe = Config.MissionFuelPipe
    local distanceToPipe = #(missionFuelPipe.pos - GetEntityCoords(playerPed))

    if distanceToPipe >= 3.0 or not PhantomMissionState.hoseFuelerStatus or PhantomMissionState.cantTankAnymore then
        HandleHoseAttachmentToPhantomTrailerValve()
        return
    end

    if not missionFuelPipe.busy then
        isPhantomActionBusy = true

        AttachRopeToTruckAndFuelTank(missionFuelPipe.entity, true)
        TriggerServerEvent("rcore_fuel:missionFuelpipe:setStatus", true)
        missionFuelPipe.busy = true
        missionFuelPipe.timeFinish = GetGameTimer() + Config.FuelingTankerTime
        missionFuelPipe.modalBar = CreateProgressBarAtLocation()
        missionFuelPipe.modalBar.SetPosition(GetEntityCoords(PlayerPedId()) + vector3(0, 0, 1))
        missionFuelPipe.modalBar.SetDescription(_U("final_pumping"))
        missionFuelPipe.modalBar.SetProgressBarTime(Config.FuelingTankerTime)
        missionFuelPipe.modalBar.Create()

        Wait(1000)
        isPhantomActionBusy = false
        return
    end

    if missionFuelPipe.timeFinish < GetGameTimer() then
        isPhantomActionBusy = true
        PhantomMissionState.cantTankAnymore = true
        missionFuelPipe.timeFinish = nil

        AttachRopeToTruckAndFuelTank(missionFuelPipe.entity, false)
        TriggerServerEvent("rcore_fuel:missionFuelpipe:setStatus", false)
        missionFuelPipe.busy = false
        missionFuelPipe.modalBar.Delete()
        missionFuelPipe.modalBar = nil

        local shopId = GetShopIdFromMissionIdentifier(MissionIdentifier)
        local tankerPosition = shopId and Config.TankerShopPosition[shopId]
        if not tankerPosition then
            isPhantomActionBusy = false
            return
        end

        CreateBlipMission(tankerPosition)
        CreateMissionZone(
            tankerPosition,
            "tank_the_final_tanker",
            30.0
        )

        Wait(1000)
        isPhantomActionBusy = false
    end
end

function ShowNpcWorkerGuideCamera(npcWorkerConfig)
    local cameraConfig = Config.CameraFacingNPC
    ShowSingularTutorialCamera(
        cameraConfig.pos,
        cameraConfig.rot,
        false,
        "",
        true,
        6000,
        function()
            RotatePlayerTowardsCoords(npcWorkerConfig.pos)
        end,
        true
    )
    Wait(33)
end

function OnTalkToNpcKeyPress()
    if GetMissionName() ~= "talk_to_npc" or DoesEntityExist(GetPhantomVehicleEntity()) then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - Config.PositionWhereToPickUpFuelTruck) >= 2 then
        return
    end

    for _, spawnPoint in pairs(Config.FuelTruckSpawnList) do
        if not IsSpawnPointClear(spawnPoint.pos, 4.0) then
            goto continueSpawnPoint
        end

        local phantomVehicle = CreateNetworkVehicle(
            Config.FuelTruckModel,
            spawnPoint.pos,
            spawnPoint.heading
        )
        GiveVehicleKeys(phantomVehicle)

        local phantomTrailer = CreateNetworkVehicle(
            Config.FuelTruckTrailerModel,
            spawnPoint.pos,
            spawnPoint.heading
        )

        PhantomMissionState.phantomVeh = phantomVehicle
        PhantomMissionState.phantomTrailer = phantomTrailer
        SetEntityHeading(phantomVehicle, spawnPoint.heading)
        AttachVehicleToTrailer(phantomVehicle, phantomTrailer, 30.0)
        SetVehicleDoorsLocked(phantomVehicle, 2)

        local npcWorkerConfig = Config.SpawnNPCList.worker
        local npcWorkerEntity = npcWorkerConfig.entity

        DisplayCinematicBlackBars(true)
        TriggerEvent("rcore_fuel:hideHud")

        CreateThread(function()
            ShowNpcWorkerGuideCamera(npcWorkerConfig)
        end, "showing guide for speaking NPC")

        Wait(1000)
        Animation.Play("comeatmebro")
        Wait(3500)
        Animation.ResetAll()
        Animation.ResetAll(npcWorkerEntity)
        Animation.Play(npcWorkerEntity, "boi")
        Wait(3500)
        Animation.ResetAll(npcWorkerEntity)
        Animation.Play(npcWorkerEntity, npcWorkerConfig.anim)
        Wait(1000)

        local pickupCamera = CreateCamera(GetGameplayCamCoord(), GetGameplayCamRot())
        pickupCamera.startRendering()
        FreezePlayerControls(true)

        pickupCamera.moveCameraSmoothlyFromPoints({
            {
                pos = playerCoords + vector3(0, 0, 10),
                rot = GetGameplayCamRot(),
                duration = 2500,
                options = {
                    fov = 50.0,
                    copyEffects = false,
                    offsetDuration = 500,
                },
            },
            {
                pos = GetOffsetFromEntityInWorldCoords(phantomVehicle, vector3(0, 15.0, 10.0)),
                rot = vector3(-30.0, 0.0, GetEntityHeading(phantomVehicle) - 180),
                duration = 2500,
                options = {
                    fov = 50.0,
                    copyEffects = false,
                    sleep = 1500,
                },
            },
            {
                pos = playerCoords + vector3(0, 0, 10),
                rot = GetGameplayCamRot(),
                duration = 1500,
                options = {
                    fov = 50.0,
                    copyEffects = false,
                    offsetDuration = 700,
                },
            },
        })

        pickupCamera.exitCameraSmoothly(1000)
        DisplayCinematicBlackBars(false)
        FreezePlayerControls(false)
        TriggerEvent("rcore_fuel:showHud")
        break

        ::continueSpawnPoint::
    end
end

AddEventHandler("rcore_fuel:sendKeyCode", function(keyCode)
    if keyCode ~= "E" then
        return
    end

    OnFinalTankerFuelKeyPress()
    OnPhantomFuelPipeKeyPress()
    OnTalkToNpcKeyPress()
end)

function SmoothlyRemoveVehicle(vehicleEntity, trailerEntity, onComplete)
    CreateThread(function()
        local alpha = 255

        while alpha > 0 do
            Wait(1)
            alpha = alpha - 2
            SetEntityAlpha(vehicleEntity, alpha, false)

            if trailerEntity then
                SetEntityAlpha(trailerEntity, alpha, false)
            end
        end

        -- FIX 9: removed collectgarbage() from render loop; it causes frame spikes
        SetEntityAlpha(vehicleEntity, 0, false)
        DeleteEntity(vehicleEntity)

        if trailerEntity then
            DeleteEntity(trailerEntity)
        end

        if onComplete then
            onComplete()
        end
    end, "Smoothly remove vehicle thread")
end

function OnFinalOutfitMarkerEnter()
    if Config.DisableOutfit then
        ShowHelpNotification(_U("return_card"), false, true, 10000)
    else
        ShowHelpNotification(_U("back_to_civil_clothes"), false, true, 10000)
    end
end

function OnFinalOutfitMarkerKeyPress()
    if isPhantomActionBusy then
        return
    end

    isPhantomActionBusy = true
    DoScreenFadeOut(500)
    Wait(500)
    SetPlayerDressedStatus(false)
    LoadPlayerDefaultSkin()
    playWardrobeAnimation()
    ResetAllMissionVariables()
    DestroyBlipMission()
    DestroyMissionZone()
    ShowHelpNotification(_U("mission_successfull"), false, true, 10000)
    TriggerServerEvent("rcore_fuel:missionEndedForPlayer")
    CreateTaxiThread()
    Wait(100)
    DoScreenFadeIn(500)

    CreateThread(function()
        Wait(100)
        isPhantomActionBusy = false

        if PhantomMissionState.finalOutfitMarker then
            PhantomMissionState.finalOutfitMarker.destroy()
            PhantomMissionState.finalOutfitMarker = nil
        end
    end)
end

function SetupFinalOutfitMarker()
    PhantomMissionState.finalOutfitMarker = createMarker()

    if Config.Debug then
        local debugText = create3DText("Change outfit marker final taxi")
        debugText.setPosition(Config.ChangeToCivilMarkerOutfit)
    end

    PhantomMissionState.finalOutfitMarker.setRenderDistance(20)
    PhantomMissionState.finalOutfitMarker.setPosition(Config.ChangeToCivilMarkerOutfit)
    PhantomMissionState.finalOutfitMarker.setRotation(true)
    PhantomMissionState.finalOutfitMarker.setFaceCamera(false)
    PhantomMissionState.finalOutfitMarker.setType(24)
    PhantomMissionState.finalOutfitMarker.setScale(vector3(0.5, 0.5, 0.5))
    PhantomMissionState.finalOutfitMarker.setInRadius(2.5)
    PhantomMissionState.finalOutfitMarker.setColor({ r = 50, g = 50, b = 255, a = 200 })
    PhantomMissionState.finalOutfitMarker.setKeys({ 38 })
    PhantomMissionState.finalOutfitMarker.on("enter", OnFinalOutfitMarkerEnter)
    PhantomMissionState.finalOutfitMarker.on("key", OnFinalOutfitMarkerKeyPress)
end

function PlayNpcCameraTourAfterTipTruckParking()
    local tourCamera = CreateCamera(GetGameplayCamCoord(), GetGameplayCamRot())
    tourCamera.startRendering()
    TriggerEvent("rcore_fuel:hideHud")
    FreezePlayerControls(true)

    local cameraPoints = {}
    for _, cameraPoint in pairs(Config.CameraNPCSmoothLookPosition) do
        table.insert(cameraPoints, {
            pos = cameraPoint.pos,
            rot = cameraPoint.rot,
            duration = cameraPoint.time,
            options = {
                fov = 50.0,
                copyEffects = false,
                offsetDuration = cameraPoint.time / 3,
                text = cameraPoint.text,
            },
        })
    end

    DisplayCinematicBlackBars(true)
    tourCamera.moveCameraSmoothlyFromPoints(cameraPoints)
    Wait(3000)

    local returnCameraPoints = {}
    for index = 1, #cameraPoints do
        local reversePoint = cameraPoints[#cameraPoints - index + 1]
        reversePoint.options.text = nil
        returnCameraPoints[index] = reversePoint
    end

    tourCamera.moveCameraSmoothlyFromPoints(returnCameraPoints)
    tourCamera.exitCameraSmoothly(2500)
    DisplayCinematicBlackBars(false)
    TriggerEvent("rcore_fuel:showHud")
    FreezePlayerControls(false)
end

AddEventHandler("rcore_fuel:enterZone", function(zoneName)
    if zoneName == "talk_to_npc" then
        ShowHelpNotification(_U("press_to_speak_with_npc"), false, true, 10000)
    end

    if zoneName == "tank_phantom_fuel" then
        if GetResourceKvpInt("fuel_camera_guide_2") ~= 0 and not Config.AlwaysShowGuideMission then
            goto tankPhantomFuelGuideDone
        end

        SetResourceKvpInt("fuel_camera_guide_2", 1)
        SendNUIMessage({ type = "show_guide_tube" })
        SetNuiFocus(true, true)
    end

    ::tankPhantomFuelGuideDone::

    if zoneName == "despawn_phantom" then
        local playerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)

        TaskLeaveVehicle(playerPed, currentVehicle, 1)
        SetVehicleDoorsLocked(GetPhantomVehicleEntity(), 2)
        Wait(1000)
        RemoveVehicleKeys(GetPhantomVehicleEntity())
        SmoothlyRemoveVehicle(GetPhantomVehicleEntity(), GetTrailerVehicleEntity())

        Config.MissionHelpMarkers[5].render = false
        CreateBlipMission(Config.ChangeToCivilMarkerOutfit)
        CreateMissionZone(Config.ChangeToCivilMarkerOutfit, "final_change_outfit", 5)
        SetupFinalOutfitMarker()
    end

    if zoneName == "tank_the_final_tanker" then
        PhantomMissionState.cantTankAnymore = false
    end

    if zoneName == "parking_tip_truck" then
        local playerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)

        TaskLeaveVehicle(playerPed, currentVehicle, 1)
        SetVehicleDoorsLocked(GetVehicleTipTruckEntity(), 2)
        Wait(1000)
        RemoveVehicleKeys(currentVehicle)
        Config.MissionHelpMarkers[6].render = false

        SmoothlyRemoveVehicle(GetVehicleTipTruckEntity(), nil, function()
            CreateBlipMission(Config.PositionWhereToPickUpFuelTruck)
            CreateMissionZone(Config.PositionWhereToPickUpFuelTruck, "talk_to_npc", 5)
            PlayNpcCameraTourAfterTipTruckParking()
        end)
    end
end)
