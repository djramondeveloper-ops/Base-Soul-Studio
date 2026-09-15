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

local isShowingTaxiHelpNotification = false
local isTaxiThreadActive = false

function CreateTaxiThread()
    if not Config.EnableTaxi then
        return
    end

    isTaxiThreadActive = true

    CreateThread(function()
        while isTaxiThreadActive do
            Wait(0)

            -- FIX 6: refresh playerPed every tick instead of capturing once before loop
            -- (stale if ped changes due to model swap or respawn)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distanceToTaxiMarker = #(playerCoords - Config.TaxiMarkerPosition)

            if distanceToTaxiMarker >= 30 then
                isTaxiThreadActive = false
                return
            end

            if distanceToTaxiMarker <= 2.6 then
                if not isShowingTaxiHelpNotification then
                    ShowHelpNotification(_U("call_taxi"), false, true, 10000)
                    isShowingTaxiHelpNotification = true
                end
            else
                isShowingTaxiHelpNotification = false
            end

            if distanceToTaxiMarker <= 10 then
                DrawMarker(
                    1, Config.TaxiMarkerPosition,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    4.6, 4.6, 1.6,
                    204, 235, 52, 150,
                    false, false, 0, false
                )
            else
                Wait(1000)
            end
        end
    end, "Taxi thread")
end

function OnCallTaxiKeyPress()
    if not isTaxiThreadActive or not isShowingTaxiHelpNotification then
        return
    end

    isTaxiThreadActive = false

    local playerPed = PlayerPedId()
    local lastMissionShopId = GetShopIdFromMissionIdentifier(LastMissionIdentifier)
    local spawnData = Config.SpawnTipTruckSpawnPositions[lastMissionShopId] or (tonumber(lastMissionShopId) and Config.SpawnTipTruckSpawnPositions[tonumber(lastMissionShopId)])
    if not spawnData or not spawnData.pos then
        return
    end
    local missionSpawnPosition = spawnData.pos
    local missionSpawnHeading = spawnData.heading or 0.0

    DoScreenFadeOut(300)
    Wait(350)
    SetEntityCoords(playerPed, Config.TeleportPlayer)
    SetEntityHeading(playerPed, Config.TeleportPlayerHeading)
    Wait(500)

    local taxiCamera = CreateCamera(Config.CameraTaxiInfo.pos, Config.CameraTaxiInfo.rot)
    FreezePlayerControls(true)
    taxiCamera.startRendering()
    DisplayCinematicBlackBars(true)
    TriggerEvent("rcore_fuel:hideHud")
    Wait(100)
    DoScreenFadeIn(300)
    Wait(250)

    Animation.Play("phone")
    Wait(1500)

    local taxiVehicle = CreateLocalVehicle("taxi", Config.TaxiPoints.spawnPos, Config.TaxiPoints.spawnHeading)
    local taxiDriver = CreateLocalPed("cs_barry", Config.TaxiPoints.spawnPos + vector3(0, 2, 0))
    currentTaxiVehicle = taxiVehicle
    currentTaxiDriver = taxiDriver

    if not taxiVehicle or taxiVehicle == 0 or not DoesEntityExist(taxiVehicle)
        or not taxiDriver or taxiDriver == 0 or not DoesEntityExist(taxiDriver) then
        taxiCamera.exitCameraSmoothly(500)
        DisplayCinematicBlackBars(false, 500)
        FreezePlayerControls(false)
        TriggerEvent("rcore_fuel:showHud")
        if taxiVehicle and DoesEntityExist(taxiVehicle) then DeleteEntity(taxiVehicle) end
        if taxiDriver and DoesEntityExist(taxiDriver) then DeleteEntity(taxiDriver) end
        isShowingTaxiHelpNotification = false
        isTaxiThreadActive = false
        return
    end

    GiveVehicleKeys(taxiVehicle)

    local warpDeadline = GetGameTimer() + 4000
    while GetVehiclePedIsIn(taxiDriver) == 0 and GetGameTimer() < warpDeadline do
        Wait(33)
        TaskWarpPedIntoVehicle(taxiDriver, taxiVehicle, -1)
    end
    if GetVehiclePedIsIn(taxiDriver) == 0 then
        TaskWarpPedIntoVehicle(taxiDriver, taxiVehicle, -1)
    end

    TaskVehicleDriveToCoordLongrange(
        taxiDriver, taxiVehicle,
        Config.TaxiPoints.drivePos.x, Config.TaxiPoints.drivePos.y, Config.TaxiPoints.drivePos.z,
        15.0, 0, 2.0
    )

    local driveDeadline = GetGameTimer() + 25000
    while #(Config.TaxiPoints.drivePos - GetEntityCoords(taxiVehicle)) > 5 and GetGameTimer() < driveDeadline do
        Wait(100)
    end

    Animation.ResetAll()
    Wait(1000)

    TaskEnterVehicle(playerPed, taxiVehicle, 3000, 1, 1.0, 1, 0)

    local enterVehicleDeadline = GetGameTimer() + 5000
    local enterVehicleTimeout = GetGameTimer() + 8000
    while GetVehiclePedIsIn(playerPed) == 0 and GetGameTimer() < enterVehicleTimeout do
        Wait(33)

        if enterVehicleDeadline < GetGameTimer() then
            TaskWarpPedIntoVehicle(playerPed, taxiVehicle, 1)
        end
    end
    if GetVehiclePedIsIn(playerPed) == 0 then
        TaskWarpPedIntoVehicle(playerPed, taxiVehicle, 1)
    end

    Wait(2000)
    taxiCamera.exitCameraSmoothly(1000)
    DisplayCinematicBlackBars(false, 1000)
    Wait(1000)
    SetCloudHatOpacity(0.1)
    SwitchOutPlayer(playerPed, 0, 1)
    Wait(2000)
    SetFocusPosAndVel(missionSpawnPosition.x, missionSpawnPosition.y, missionSpawnPosition.z, 0.0, 0.0, 0.0)
    SetEntityCoords(taxiVehicle, missionSpawnPosition)
    Wait(2000)
    PlaceObjectOnGroundProperly(taxiVehicle)
    SwitchInPlayer(playerPed)
    SetEntityHeading(taxiVehicle, missionSpawnHeading)
    ClearFocus()
    FreezePlayerControls(false)

    local exitDeadline = GetGameTimer() + 10000
    while GetVehiclePedIsIn(playerPed) ~= 0 and GetGameTimer() < exitDeadline do
        Wait(33)
    end
    if GetVehiclePedIsIn(playerPed) ~= 0 then
        TaskLeaveVehicle(playerPed, taxiVehicle, 16)
    end

    TriggerEvent("rcore_fuel:showHud")
    TaskVehicleDriveWander(taxiDriver, taxiVehicle, 60.0, 447)
    SetVehicleDoorsLocked(taxiVehicle, 2)
    SetBlockingOfNonTemporaryEvents(taxiDriver, true)

    local wanderDeadline = GetGameTimer() + 15000
    while #(missionSpawnPosition - GetEntityCoords(taxiVehicle)) < 50 and GetGameTimer() < wanderDeadline do
        Wait(100)
    end

    RemoveVehicleKeys(taxiVehicle)
    DeleteEntity(taxiVehicle)
    DeleteEntity(taxiDriver)
    currentTaxiVehicle = nil
    currentTaxiDriver = nil
    isShowingTaxiHelpNotification = false
    isTaxiThreadActive = false
end

RegisterKey(
    OnCallTaxiKeyPress,
    "callmetaxifuel",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.CALL_TAXI] and Config.KeyMaps[KeyAction.CALL_TAXI].label) or "Call taxi",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.CALL_TAXI] and Config.KeyMaps[KeyAction.CALL_TAXI].action) or "e"
)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if currentTaxiVehicle and DoesEntityExist(currentTaxiVehicle) then
        RemoveVehicleKeys(currentTaxiVehicle)
        DeleteEntity(currentTaxiVehicle)
        currentTaxiVehicle = nil
    end
    if currentTaxiDriver and DoesEntityExist(currentTaxiDriver) then
        DeleteEntity(currentTaxiDriver)
        currentTaxiDriver = nil
    end
end)
