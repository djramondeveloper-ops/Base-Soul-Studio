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

BarrelMissionState = {
    barrelInHandEntity = 0,
    processedBarrelEntityInHand = 0,
    entityAttachedListToTipTruck = {},
    currentBoneIndexArray = 0,
    possibleBones = Config.AttachableBonesTipTruck,
    fullBarrel = false,
}

local defaultBarrelMissionState = DeepCopy(BarrelMissionState)
local isBarrelActionBusy = false

CreateVariableResetCallback(function()
    DeleteEntity(BarrelMissionState.barrelInHandEntity)
    DeleteEntity(BarrelMissionState.processedBarrelEntityInHand)
    -- FIX 3: delete barrel entities still attached to the tip truck before reset
    for _, attachedEntity in pairs(BarrelMissionState.entityAttachedListToTipTruck) do
        if attachedEntity and DoesEntityExist(attachedEntity) then
            DeleteEntity(attachedEntity)
        end
    end
    BarrelMissionState = DeepCopy(defaultBarrelMissionState)
    isBarrelActionBusy = false
end)

function DoesPlayerHoldFilledBarrel()
    return GetBarrelEntity() == BarrelMissionState.processedBarrelEntityInHand
end

function PutBarrelInMissionVehicle()
    BarrelMissionState.currentBoneIndexArray = BarrelMissionState.currentBoneIndexArray + 1

    local playerCoords = GetEntityCoords(PlayerPedId())
    local tipTruckEntity = GetVehicleTipTruckEntity()
    local barrelEntity = CreateNetworkedObject("prop_barrel_01a", playerCoords)
    local boneIndex = GetEntityBoneIndexByName(tipTruckEntity, BarrelMissionState.possibleBones[BarrelMissionState.currentBoneIndexArray])

    AttachEntityToEntity(
        barrelEntity, tipTruckEntity, boneIndex,
        0.0, 0.0, 1.13,
        0, 0.0, 0.0, 0.0,
        -- FIX 11: last param (syncRot) should be false, matching bak -- the
        -- translation shifted in a spurious extra value bak itself ignored
        1, false, false, false, false
    )

    BarrelMissionState.entityAttachedListToTipTruck[BarrelMissionState.currentBoneIndexArray] = barrelEntity
    BarrelMissionState.fullBarrel = false
end

function TakeBarrelFromVehicle()
    if BarrelMissionState.currentBoneIndexArray == 0 then
        return
    end

    local playerPed = PlayerPedId()
    DeleteEntity(BarrelMissionState.entityAttachedListToTipTruck[BarrelMissionState.currentBoneIndexArray])
    -- FIX 10: nil the slot to prevent stale entity handle lingering in the table
    BarrelMissionState.entityAttachedListToTipTruck[BarrelMissionState.currentBoneIndexArray] = nil

    BarrelMissionState.barrelInHandEntity = CreateNetworkedObject("prop_barrel_01a", GetEntityCoords(playerPed))
    AttachEntityToEntity(
        BarrelMissionState.barrelInHandEntity, playerPed, GetPedBoneIndex(playerPed, 11816),
        -0.3, 0.3, -0.1,
        0.0, 0.0, 0.0,
        1, 1, 0, 1, 0, 1
    )

    BarrelMissionState.currentBoneIndexArray = BarrelMissionState.currentBoneIndexArray - 1
end

function GetBarrelEntity()
    if not BarrelMissionState.barrelInHandEntity then
        return 0
    end

    return BarrelMissionState.barrelInHandEntity
end

function BarrelHandling()
    if isBarrelActionBusy or not IsPlayerCorrectlyDressedForJob() then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, barrelLocation in pairs(Config.BarrelSpawnLocations) do
        if #(playerCoords - barrelLocation.pos) < 2 then
            if DoesEntityExist(GetBarrelEntity()) then
                isBarrelActionBusy = true
                RotatePlayerTowardsCoords(barrelLocation.pos)
                Animation.Play("pickup")
                Wait(1000)
                BarrelMissionState.fullBarrel = false
                DeleteEntity(BarrelMissionState.barrelInHandEntity)
                Animation.ResetAll()
                isBarrelActionBusy = false
                return
            end

            if BarrelMissionState.currentBoneIndexArray == #BarrelMissionState.possibleBones then
                return
            end

            isBarrelActionBusy = true
            RotatePlayerTowardsCoords(barrelLocation.pos)
            Animation.Play("pickup")
            Wait(1000)
            Animation.Play("hold")

            BarrelMissionState.barrelInHandEntity = CreateNetworkedObject("prop_barrel_01a", playerCoords)
            AttachEntityToEntity(
                BarrelMissionState.barrelInHandEntity, playerPed, GetPedBoneIndex(playerPed, 11816),
                -0.3, 0.3, -0.1,
                0.0, 0.0, 0.0,
                1, 1, 0, 1, 0, 1
            )

            isBarrelActionBusy = false
            BarrelMissionState.fullBarrel = false
            ShowHelpNotification(_U("drop_barrel_info"), false, true, 10000)
            return
        end
    end
end

if Config.TargetZoneType == 0 then
    AddEventHandler("rcore_fuel:sendKeyCode", function(keyCode)
        if keyCode == "E" then
            BarrelHandling()
        end
    end)
else
    AddEventHandler("rcore_fuel:pickup_barrel", BarrelHandling)
end

function ResetBarrelEntityAfterTimeout(processingLocation, locationIndex, barrelEntity)
    Wait(Config.TimeToProcessBarrel * 2)

    if not DoesEntityExist(barrelEntity) or processingLocation.entityBarrel ~= barrelEntity then
        return
    end

    if processingLocation.modalBar then
        processingLocation.modalBar.Delete()
        processingLocation.modalBar = nil
    end

    TriggerServerEvent("rcore_fuel:processBarrelLocation:setStatus", locationIndex, false)
    DeleteEntity(barrelEntity)
    Config.ProcessingLocationForBarrel[locationIndex].entityBarrel = nil
    Config.ProcessingLocationForBarrel[locationIndex].lastBarrelEntity = nil
end

function ProcessBarrelLocation()
    if isBarrelActionBusy or not IsPlayerCorrectlyDressedForJob() then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for locationIndex, processingLocation in pairs(Config.ProcessingLocationForBarrel) do
        if #(playerCoords - processingLocation.pos) < 2 then
            if not processingLocation.busy then
                if DoesEntityExist(GetBarrelEntity())
                    and BarrelMissionState.processedBarrelEntityInHand ~= BarrelMissionState.barrelInHandEntity
                then
                    isBarrelActionBusy = true
                    Animation.Play("pickup")

                    local barrelPlacementCoords = GetOffsetFromEntityInWorldCoords(
                        processingLocation.entity,
                        vector3(0, 1, 0.5)
                    )

                    RotatePlayerTowardsCoords(barrelPlacementCoords)
                    Wait(1000)
                    DeleteEntity(BarrelMissionState.barrelInHandEntity)

                    processingLocation.entityBarrel = CreateNetworkedObject("prop_barrel_01a", barrelPlacementCoords)
                    FreezeEntityPosition(processingLocation.entityBarrel, true)
                    processingLocation.timeFinish = GetGameTimer() + Config.TimeToProcessBarrel

                    TriggerServerEvent(
                        "rcore_fuel:processBarrelLocation:setStatus",
                        locationIndex,
                        true,
                        ObjToNet(processingLocation.entityBarrel)
                    )

                    Animation.ResetAll()

                    processingLocation.modalBar = CreateProgressBarAtLocation()
                    processingLocation.modalBar.SetPosition(barrelPlacementCoords + vector3(0, 0, 1))
                    processingLocation.modalBar.SetDescription(_U("processing_oil"))
                    processingLocation.modalBar.SetProgressBarTime(Config.TimeToProcessBarrel)
                    processingLocation.modalBar.Create()

                    CreateThread(function()
                        ResetBarrelEntityAfterTimeout(processingLocation, locationIndex, processingLocation.entityBarrel)
                    end, "Reseting barrel entity if too long")

                    isBarrelActionBusy = false
                    return
                end
            elseif processingLocation.timeFinish and processingLocation.timeFinish < GetGameTimer() then
                if not DoesEntityExist(GetBarrelEntity()) then
                    processingLocation.timeFinish = nil
                    isBarrelActionBusy = true
                    RotatePlayerTowardsCoords(processingLocation.pos)
                    Animation.Play("pickup")
                    Wait(1000)
                    Animation.Play("hold")
                    DeleteEntity(processingLocation.entityBarrel)

                    BarrelMissionState.barrelInHandEntity = CreateNetworkedObject("prop_barrel_01a", processingLocation.pos)
                    BarrelMissionState.processedBarrelEntityInHand = BarrelMissionState.barrelInHandEntity

                    AttachEntityToEntity(
                        BarrelMissionState.barrelInHandEntity, playerPed, GetPedBoneIndex(playerPed, 11816),
                        -0.3, 0.3, -0.1,
                        0.0, 0.0, 0.0,
                        1, 1, 0, 1, 0, 1
                    )

                    BarrelMissionState.fullBarrel = true
                    isBarrelActionBusy = false
                    processingLocation.entityBarrel = nil

                    if processingLocation.modalBar then
                        processingLocation.modalBar.Delete()
                        processingLocation.modalBar = nil
                    end

                    TriggerServerEvent("rcore_fuel:processBarrelLocation:setStatus", locationIndex, false)
                end
            end
        end
    end
end

if Config.TargetZoneType == 0 then
    AddEventHandler("rcore_fuel:sendKeyCode", function(keyCode)
        if keyCode == "E" then
            ProcessBarrelLocation()
        end
    end)
else
    AddEventHandler("rcore_fuel:process_barrel", ProcessBarrelLocation)
end

function PlaceBarrelIntoVehicle()
    if isBarrelActionBusy or not IsPlayerCorrectlyDressedForJob() then
        return
    end

    local tipTruckEntity = GetVehicleTipTruckEntity()
    local playerPed = PlayerPedId()
    local distanceToTruck = #(GetEntityCoords(tipTruckEntity) - GetEntityCoords(playerPed))

    if distanceToTruck >= 5 then
        return
    end

    local missionName = GetMissionName()

    if missionName == "drop_out_barrels" then
        isBarrelActionBusy = true

        if not DoesEntityExist(GetBarrelEntity()) and not IsPlayerInVehicle() then
            Animation.Play("pickup")
            Wait(1000)
            TakeBarrelFromVehicle()
        end

        isBarrelActionBusy = false
        return
    end

    if missionName == "oil_entrace_factory" then
        isBarrelActionBusy = true

        if DoesEntityExist(GetBarrelEntity())
            and BarrelMissionState.processedBarrelEntityInHand == BarrelMissionState.barrelInHandEntity
        then
            Animation.Play("pickup")
            Wait(1000)
            PutBarrelInMissionVehicle()
            DeleteEntity(BarrelMissionState.barrelInHandEntity)
            Animation.ResetAll()
            BarrelMissionState.processedBarrelEntityInHand = nil
            BarrelMissionState.barrelInHandEntity = nil

            if BarrelMissionState.currentBoneIndexArray == #BarrelMissionState.possibleBones then
                ShowHelpNotification(_U("all_barrel_pickup"), false, true, 10000)
                CreateBlipMission(Config.DriveLocationForBarrelDropOut)
                CreateMissionZone(Config.DriveLocationForBarrelDropOut, "drop_barrels_to_process", 15)
            end
        end

        isBarrelActionBusy = false
    end
end

AddEventHandler("rcore_fuel:sendKeyCode", function(keyCode)
    if keyCode == "E" then
        PlaceBarrelIntoVehicle()
    end
end)

function StoreBarrelsInStorage()
    if GetMissionName() ~= "drop_out_barrels" or isBarrelActionBusy then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not DoesEntityExist(GetBarrelEntity()) then
        return
    end

    for _, dropLocation in pairs(Config.DropFilledBarrelsLocation) do
        if #(playerCoords - dropLocation) < 2 then
            isBarrelActionBusy = true
            Animation.Play("pickup")
            Wait(1000)
            DeleteEntity(BarrelMissionState.barrelInHandEntity)

            if BarrelMissionState.currentBoneIndexArray == 0 then
                ShowHelpNotification(_U("all_barrel_stored"), false, true, 10000)
                CreateBlipMission(Config.WhereToParkTheTipTruck)
                CreateMissionZone(Config.WhereToParkTheTipTruck, "parking_tip_truck", 5)
            end

            isBarrelActionBusy = false
            return
        end
    end
end

if Config.TargetZoneType == 0 then
    AddEventHandler("rcore_fuel:sendKeyCode", function(keyCode)
        if keyCode == "E" then
            StoreBarrelsInStorage()
        end
    end)
else
    CreateThread(function()
        local targetConfig = Config.DropFilledBarrelsLocationTarget

        CreateTargetZone(targetConfig.pos, targetConfig.length, targetConfig.width, targetConfig.heading, {
            {
                distance = 1.1,
                num = 1,
                type = "client",
                event = "rcore_fuel:StoreBarrelsInStorage",
                icon = _U("target_store_icon"),
                label = _U("target_store_label"),
                targeticon = _U("target_store_targeticon"),
                canInteract = function()
                    return true
                end,
                drawColor = { 255, 255, 255, 255 },
                successDrawColor = { 30, 144, 255, 255 },
                eventAction = "StoreBarrelsInStorage",
            },
        })
    end, "creating storage target")

    AddEventHandler("rcore_fuel:StoreBarrelsInStorage", StoreBarrelsInStorage)
end

function DestroyBarrelProcessingSoundAfterDelay(processingLocation, generation, pumpSound)
    Wait(Config.TimeToProcessBarrel + 1000)

    if processingLocation.soundGeneration ~= generation then
        return
    end

    if processingLocation.pumpSound == pumpSound and pumpSound then
        pcall(function() pumpSound.Destroy() end)
        processingLocation.pumpSound = nil
    end
end

RegisterNetEvent("rcore_fuel:processBarrelLocation:setStatus", function(locationIndex, isBusy)
    locationIndex = tonumber(locationIndex)
    local processingLocation = locationIndex and Config.ProcessingLocationForBarrel[locationIndex]
    if not processingLocation then return end
    processingLocation.busy = isBusy == true
    processingLocation.soundGeneration = (processingLocation.soundGeneration or 0) + 1
    local soundGeneration = processingLocation.soundGeneration

    if isBusy then
        -- FIX 2: was calling processingLocation.eleSound.Destroy() but eleSound doesn't
        -- exist here -- only pumpSound is created for barrel processing
        if processingLocation.pumpSound then
            processingLocation.pumpSound.Destroy()
            processingLocation.pumpSound = nil
        end

        processingLocation.pumpSound = CreateSoundHandler("pump_process_" .. locationIndex)
        processingLocation.pumpSound.LoadSound(SoundEffect.LIQUID_POURING_LOOP)
        processingLocation.pumpSound.SetPlayingPosition(processingLocation.pos)
        processingLocation.pumpSound.SetVolume(Config.LiquidVolume or 0.75)
        processingLocation.pumpSound.SetLoop(true)
        processingLocation.pumpSound.SetAutoPlay(true)
        processingLocation.pumpSound.CreateMedia()

        local pumpSound = processingLocation.pumpSound
        CreateThread(function()
            DestroyBarrelProcessingSoundAfterDelay(processingLocation, soundGeneration, pumpSound)
        end, "destroying sound for barrel")
    elseif processingLocation.pumpSound then
        processingLocation.pumpSound.Destroy()
        processingLocation.pumpSound = nil
    end
end)

AddEventHandler("rcore_fuel:enterZone", function(zoneName)
    if zoneName == "drop_barrels_to_process" then
        DestroyBlipMission()
        CreateMissionZone("drop_out_barrels")

        local playerPed = PlayerPedId()
        TaskVehicleTempAction(playerPed, GetVehiclePedIsIn(playerPed, false), 1, 1000)

        local dropOutCamera = Config.PutBarrelsLocationCamera
        ShowSingularTutorialCamera(dropOutCamera.pos, dropOutCamera.rot, true, _U("what_to_do_in_drop_out_barrels"))
    end
end)

CreateThread(function()
    local isNearDropLocation = false
    local lastPlayerCoords = vector3(0, 0, 0)

    while true do
        Wait(1000)

        if IsPlayerInMission() then
            isNearDropLocation = false
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            if GetMissionName() == "drop_out_barrels" then
                if #(playerCoords - lastPlayerCoords) > 2 then
                    for _, dropLocation in pairs(Config.DropFilledBarrelsLocation) do
                        if #(playerCoords - dropLocation) < 2 then
                            isNearDropLocation = true
                            lastPlayerCoords = playerCoords
                        end
                    end

                    if isNearDropLocation then
                        if DoesEntityExist(GetBarrelEntity()) then
                            ShowHelpNotification(_U("store_barrel"), false, true, 10000)
                        else
                            ShowHelpNotification(_U("missing_barrel"), true, true, 5000)
                        end
                    end
                end
            else
                Wait(5000)
            end
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)

        if IsPlayerCorrectlyDressedForJob() then
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, processingLocation in pairs(Config.ProcessingLocationForBarrel) do
                if #(playerCoords - processingLocation.pos) < 2 then
                    if processingLocation.entered then
                        goto continueProcessingLocation
                    end

                    if BarrelMissionState.fullBarrel then
                        ShowHelpNotification(_U("wrong_barrel"), true, true, 5000)
                    elseif not DoesEntityExist(GetBarrelEntity()) and processingLocation.busy ~= true then
                        ShowHelpNotification(_U("missing_barrel"), true, true, 5000)
                    elseif processingLocation.busy then
                        if processingLocation.timeFinish ~= nil then
                            if processingLocation.timeFinish < GetGameTimer() then
                                if Config.TargetZoneType == 0 then
                                    ShowHelpNotification(_U("barrel_done"), true, true, 5000)
                                else
                                    ShowHelpNotification(_U("barrel_done_interaction"), true, true, 5000)
                                end
                            else
                                ShowHelpNotification(_U("barrel_wait"), true, true, 5000)
                            end
                        end
                    else
                        ShowHelpNotification(_U("place_barrel"), true, true, 5000)
                    end

                    processingLocation.entered = true
                else
                    processingLocation.entered = nil
                end

                ::continueProcessingLocation::
            end
        end
    end
end, "notification for processing barrel")

CreateThread(function()
    while true do
        Wait(1000)

        if not IsPlayerCorrectlyDressedForJob() then
            Wait(4000)
        elseif DoesEntityExist(GetBarrelEntity()) then
            if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 49) then
                Animation.Play("hold")
            end
        elseif IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 49) then
            Animation.ResetAll()
        end
    end
end)

function FadeOutAndDeleteDroppedBarrel(droppedBarrelEntity)
    Wait(5000)

    local alpha = 255
    while alpha > 0 do
        Wait(1)
        alpha = alpha - 2
        SetEntityAlpha(droppedBarrelEntity, alpha, false)
    end

    -- FIX 3: removed collectgarbage() from render loop (causes frame spikes)
    SetEntityAlpha(droppedBarrelEntity, 0, false)
    DeleteEntity(droppedBarrelEntity)
end

function OnDropBarrelKeyPress()
    if isBarrelActionBusy or not IsPlayerCorrectlyDressedForJob() then
        return
    end

    local barrelEntity = GetBarrelEntity()
    if not DoesEntityExist(barrelEntity) then
        return
    end

    isBarrelActionBusy = true
    Animation.Play("pickup")
    Wait(1000)

    local droppedBarrelEntity = CreateLocalObject(
        GetEntityModel(barrelEntity),
        GetEntityCoords(barrelEntity)
    )

    SetEntityHeading(droppedBarrelEntity, GetEntityHeading(barrelEntity))
    SetEntityRotation(droppedBarrelEntity, GetEntityRotation(barrelEntity))
    FreezeEntityPosition(droppedBarrelEntity, false)
    SetEntityHasGravity(droppedBarrelEntity, true)
    ApplyForceToEntity(droppedBarrelEntity, 1, 1.1, 1.1, 1.1, 0, 0, 0, 0, false, false, false, true, true)

    BarrelMissionState.fullBarrel = false
    CreateThread(function()
        FadeOutAndDeleteDroppedBarrel(droppedBarrelEntity)
    end)

    DeleteEntity(BarrelMissionState.barrelInHandEntity)
    Animation.ResetAll()
    isBarrelActionBusy = false
end

RegisterKey(
    OnDropBarrelKeyPress,
    "dropbarrel",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.DROP_BARREL] and Config.KeyMaps[KeyAction.DROP_BARREL].label) or "Drop barrel",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.DROP_BARREL] and Config.KeyMaps[KeyAction.DROP_BARREL].action) or "x"
)
