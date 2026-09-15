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

TipTruckMissionState = {
    missionVehicle = 0,
    markerOutfit = nil,
    playerExitedVehicle = false,
    IsShowingTutorialCamera = false,
    switchEquip = false,
    createdWaypointEntranceAreal = false,
}

local defaultTipTruckMissionState = DeepCopy(TipTruckMissionState)

CreateVariableResetCallback(function()
    DeleteEntity(TipTruckMissionState.missionVehicle)
    TipTruckMissionState = DeepCopy(defaultTipTruckMissionState)
end)

function IsTutorialCameraDisplaying()
    return TipTruckMissionState.IsShowingTutorialCamera
end

function SetPlayerDressedStatus(isDressed)
    TipTruckMissionState.switchEquip = isDressed
end

function IsPlayerCorrectlyDressedForJob()
    return TipTruckMissionState.switchEquip
end

function GetVehicleTipTruckEntity()
    if not TipTruckMissionState.missionVehicle then
        return 0
    end

    return TipTruckMissionState.missionVehicle
end

function playWardrobeAnimation()
    local playerPed = PlayerPedId()
    local animDict = "mp_clothing@female@shirt"
    local animName = "try_shirt_positive_a"

    RequestAnimDict(animDict)
    local animTimeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(animDict) and GetGameTimer() < animTimeout do
        Wait(33)
    end

    if HasAnimDictLoaded(animDict) then
        TaskPlayAnim(playerPed, animDict, animName, 8.0, 1.0, -1, 48, 0.0, false, false, false)
    end
end

function InitializeTipTruck()
    local shopId = GetShopIdFromMissionIdentifier(MissionIdentifier)
    local spawnData = Config.SpawnTipTruckSpawnPositions[shopId] or (tonumber(shopId) and Config.SpawnTipTruckSpawnPositions[tonumber(shopId)])
    if not spawnData or not spawnData.pos then
        print(string.format("[rcore_fuel] [ERROR] No tipTruckSpawnPosition found for shopId: %s", tostring(shopId)))
        return
    end
    local spawnPosition = spawnData.pos
    local spawnHeading = spawnData.heading or 0.0
    local tipTruckVehicle = CreateNetworkVehicle(Config.TipTruckHash, spawnPosition, spawnHeading)

    GiveVehicleKeys(tipTruckVehicle)
    TipTruckMissionState.missionVehicle = tipTruckVehicle
    SetVehicleExtra(tipTruckVehicle, 2, 1)
    SetVehRadioStation(tipTruckVehicle, "OFF")

    local cameraStartPosition = GetOffsetFromEntityInWorldCoords(tipTruckVehicle, vector3(0, 15.0, 4.0))
    local cameraEndPosition = GetOffsetFromEntityInWorldCoords(tipTruckVehicle, vector3(0, 7.0, 2.0))
    local introCamera = CreateCamera(cameraStartPosition, vector3(-20.0, 0.0, GetEntityHeading(tipTruckVehicle)))

    DoScreenFadeOut(450)
    Wait(500)
    FreezePlayerControls(true)
    introCamera.startRendering()
    introCamera.focusCameraOnCoords(spawnPosition)
    Wait(100)
    introCamera.stopFocusing()
    DoScreenFadeIn(450)
    Wait(500)

    local cameraRotation = introCamera.getCameraRotation()
    introCamera.moveCameraSmoothlyFromPoints({
        {
            pos = cameraEndPosition,
            rot = cameraRotation,
            duration = 3500,
            options = {
                fov = 50.0,
                copyEffects = false,
                offsetDuration = 200,
            },
        },
    })

    Wait(500)
    DoScreenFadeOut(450)
    Wait(500)
    introCamera.disposeCamera()
    DoScreenFadeIn(450)
    Wait(500)
    FreezePlayerControls(false)
end

function ShowTutorialCamera()
    FreezePlayerControls(true)

    local tutorialCamera = CreateCamera(Config.Clues[1].pos, Config.Clues[1].rot)
    TipTruckMissionState.IsShowingTutorialCamera = true

    DoScreenFadeOut(500)
    Wait(500)
    tutorialCamera.startRendering()
    DisplayCinematicBlackBars(true)
    TriggerEvent("rcore_fuel:showHud")
    Wait(200)
    DoScreenFadeIn(500)
    SetFocusPosAndVel(0, 0, 0, 0.0, 0.0, 0.0)

    for _, clue in pairs(Config.Clues) do
        DoScreenFadeOut(500)
        Wait(500)
        tutorialCamera.setCameraCoords(clue.pos)
        tutorialCamera.setCameraRotation(clue.rot)

        local interiorId = GetInteriorAtCoords(clue.pos.x, clue.pos.y, clue.pos.z)
        SetInteriorActive(interiorId, true)
        NewLoadSceneStartSphere(clue.pos.x, clue.pos.y, clue.pos.z, 200.0, 0)

        local sceneTimeout = GetGameTimer() + 5000
        while not IsNewLoadSceneLoaded() and GetGameTimer() < sceneTimeout do
            Wait(0)
        end
        NewLoadSceneStop()

        Wait(700)
        DoScreenFadeIn(500)
        ShowSubtitle(clue.text)
        Wait(clue.sleepTime)
    end

    ShowSubtitle("", 500)
    DoScreenFadeOut(500)
    Wait(500)
    DisplayCinematicBlackBars(false)
    TriggerEvent("rcore_fuel:hideHud")
    tutorialCamera.disposeCamera()
    Wait(200)
    DoScreenFadeIn(500)
    ClearFocus()
    FreezePlayerControls(false)
    TipTruckMissionState.IsShowingTutorialCamera = false
end

function OnTipTruckOutfitMarkerEnter()
    if Config.DisableOutfit then
        ShowHelpNotification(_U("take_card"), false, true, 10000)
    else
        ShowHelpNotification(_U("equip_clothes"), false, true, 10000)
    end
end

function OnTipTruckOutfitMarkerKeyPress()
    if TipTruckMissionState.switchEquip then
        return
    end

    DoScreenFadeOut(500)
    Wait(500)
    TipTruckMissionState.switchEquip = true
    LoadPlayerJobSkin()
    playWardrobeAnimation()
    TipTruckMissionState.markerOutfit.stopRender()
    Wait(100)
    DoScreenFadeIn(500)
end

function SetupTipTruckOutfitMarker()
    if TipTruckMissionState.markerOutfit then
        TipTruckMissionState.markerOutfit.destroy()
        TipTruckMissionState.markerOutfit = nil
    end

    TipTruckMissionState.markerOutfit = createMarker()

    if Config.Debug then
        local debugText = create3DText("Change outfit marker mission job")
        debugText.setPosition(Config.ChangeOutfitLocation)
    end

    TipTruckMissionState.markerOutfit.setRenderDistance(10)
    TipTruckMissionState.markerOutfit.setPosition(Config.ChangeOutfitLocation)
    TipTruckMissionState.markerOutfit.setRotation(true)
    TipTruckMissionState.markerOutfit.setFaceCamera(false)
    TipTruckMissionState.markerOutfit.setType(24)
    TipTruckMissionState.markerOutfit.setScale(vector3(0.5, 0.5, 0.5))
    TipTruckMissionState.markerOutfit.setInRadius(2.5)
    TipTruckMissionState.markerOutfit.setColor({ r = 50, g = 50, b = 255, a = 200 })
    TipTruckMissionState.markerOutfit.setKeys({ 38 })
    TipTruckMissionState.markerOutfit.on("enter", OnTipTruckOutfitMarkerEnter)
    TipTruckMissionState.markerOutfit.on("key", OnTipTruckOutfitMarkerKeyPress)
end

CreateThread(function()
    local hasShownNearbyHelp = false

    while true do
        Wait(1000)

        if DoesEntityExist(GetVehicleTipTruckEntity()) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local truckCoords = GetEntityCoords(GetVehicleTipTruckEntity())
            local distanceToTruck = #(playerCoords - truckCoords)

            if distanceToTruck < 5 and not hasShownNearbyHelp then
                local missionName = GetMissionName()

                if missionName == "oil_entrace_factory" and DoesEntityExist(GetBarrelEntity()) and not IsPlayerInVehicle() then
                    if not DoesPlayerHoldFilledBarrel() then
                        ShowHelpNotification(_U("barrel_not_processed"), false, true, 10000)
                    else
                        ShowHelpNotification(_U("put_barrel_into_truck"), false, true, 10000)
                    end

                    hasShownNearbyHelp = true
                end

                if missionName == "drop_out_barrels" and not IsPlayerInVehicle() then
                    ShowHelpNotification(_U("take_barrel_from_truck"), false, true, 10000)
                    hasShownNearbyHelp = true
                end
            else
                hasShownNearbyHelp = false
            end
        else
            Wait(10000)
        end
    end
end, "render help text for tip truck")

AddEventHandler("rcore_fuel:playerIsTryingToEnterVehicle", function(vehicleEntity)
    if vehicleEntity ~= TipTruckMissionState.missionVehicle then
        return
    end

    if GetMissionName() == "entrace_oil_road" then
        return
    end

    if TipTruckMissionState.createdWaypointEntranceAreal then
        return
    end

    TipTruckMissionState.createdWaypointEntranceAreal = true
    CreateBlipMission(Config.BlipForPlayerToFollowToParkNearOilBuilding)
    CreateMissionZone(Config.BlipForPlayerToFollowToParkNearOilBuilding, "entrace_oil_road")
end)

AddEventHandler("rcore_fuel:enterZone", function(zoneName)
    if zoneName == "entrace_oil_road" then
        for _, parkingSpot in pairs(Config.TipTruckPossibleParkingSpots) do
            if IsSpawnPointClear(parkingSpot, 4.0) then
                CreateBlipMission(parkingSpot)
                CreateMissionZone(parkingSpot, "parking_spot", 5)

                if Config.MissionHelpMarkers[99] then
                    Config.MissionHelpMarkers[99].pos = parkingSpot - vector3(0, 0, 1.5)
                end

                break
            end
        end
    end

    if zoneName == "parking_spot" then
        CreateBlipMission(Config.ChangeOutfitLocation)
        CreateMissionZone(Config.ChangeOutfitLocation, "oil_entrace_factory")

        if not TipTruckMissionState.playerExitedVehicle then
            TipTruckMissionState.playerExitedVehicle = true

            local playerPed = PlayerPedId()
            TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 1)
            Config.MissionHelpMarkers[99].pos = vector3(0, 0, 0)
            Wait(3000)

            if Config.UseTutorialForNewPlayers then
                if GetResourceKvpInt("fuel_camera_guide_1") ~= 0 and not Config.AlwaysShowGuideMission then
                    goto parkingSpotTutorialDone
                end

                SetResourceKvpInt("fuel_camera_guide_1", 1)
                ShowTutorialCamera()
            end
        end
    end

    ::parkingSpotTutorialDone::

    if zoneName == "oil_entrace_factory" then
        DestroyBlipMission()
        SetupTipTruckOutfitMarker()
    end
end)
