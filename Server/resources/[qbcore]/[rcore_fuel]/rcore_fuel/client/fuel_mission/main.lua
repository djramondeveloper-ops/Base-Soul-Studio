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

MissionIdentifier = nil
MissionVariables = {}
LastMissionIdentifier = ""

-- FIX 7: MissionIdentifier is "shopId_timestamp" (see acceptedRefuelMission
-- server-side), but Config.SpawnTipTruckSpawnPositions is keyed by shopId
-- alone (client/init.lua) -- every direct lookup by the full mission
-- identifier always misses. Extract the shopId back out for that lookup.
-- Greedy match correctly handles shopIds that themselves contain underscores.
function GetShopIdFromMissionIdentifier(missionIdentifier)
    if not missionIdentifier then
        return nil
    end
    local extracted = string.match(missionIdentifier, "^(.*)_%d+$") or missionIdentifier
    if Config.SpawnTipTruckSpawnPositions[extracted] then
        return extracted
    elseif tonumber(extracted) and Config.SpawnTipTruckSpawnPositions[tonumber(extracted)] then
        return tonumber(extracted)
    end
    return extracted
end

function CreateVariableResetCallback(resetCallback)
    table.insert(MissionVariables, resetCallback)
end

function ResetAllMissionVariables()
    for _, resetCallback in pairs(MissionVariables) do
        resetCallback()
    end
end

function IsPlayerInMission()
    return MissionIdentifier ~= nil
end

CreateVariableResetCallback(function()
    MissionIdentifier = nil
end)

RegisterCommand("cancelfuelmission", function(source, args)
    if IsPlayerInMission() then
        TriggerServerEvent("rcore_fuel:playerCancelMission")
        ResetAllMissionVariables()
        DestroyBlipMission()
        DestroyMissionZone()

        if IsPlayerCorrectlyDressedForJob() then
            DoScreenFadeOut(500)
            Wait(500)
            LoadPlayerDefaultSkin()
            playWardrobeAnimation()
            Wait(100)
            DoScreenFadeIn(500)
        end

        if args[1] then
            ShowNotification(_U("mission_canceled_by_owner"))
        else
            ShowNotification(_U("mission_canceled"))
        end
    else
        ShowNotification(_U("not_in_mission"))
    end
end)

RegisterNetEvent("rcore_fuel:cancelMissionForPlayer", function()
    ExecuteCommand("cancelfuelmission 1")
end)

-- FIX 3: server sends this when owner force-cancels the mission;
-- route through the same cancel command so all variables/blips/zones reset cleanly
RegisterNetEvent("rcore_fuel:forceMissionCancelled", function()
    ExecuteCommand("cancelfuelmission 1")
end)

RegisterNetEvent("rcore_fuel:startFuelMission", function(missionId)
    MissionIdentifier = missionId
    LastMissionIdentifier = missionId
    local sId = GetShopIdFromMissionIdentifier(MissionIdentifier)
    local spawnData = Config.SpawnTipTruckSpawnPositions[sId] or (tonumber(sId) and Config.SpawnTipTruckSpawnPositions[tonumber(sId)])
    if spawnData and spawnData.pos then
        CreateBlipMission(spawnData.pos, -1)
    end
    InitializeTipTruck()
end)

if Config.UseLights then
    CreateThread(function()
        local waitTime = 1000

        while true do
            Wait(waitTime)
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, lightSpot in pairs(Config.LightSpots) do
                local distanceToLight = #(playerCoords - lightSpot.pos)

                if distanceToLight < lightSpot.rangeTorRender or IsTutorialCameraDisplaying() then
                    waitTime = 0
                    DrawLightWithRangeAndShadow(
                        lightSpot.pos.x, lightSpot.pos.y, lightSpot.pos.z,
                        255, 255, 255,
                        lightSpot.lightRange, lightSpot.intensity, lightSpot.shadow
                    )
                else
                    waitTime = 1000
                end
            end
        end
    end, "render light")
end

if Config.UseHelpMarkers then
    CreateThread(function()
        local waitTime = 1000

        while true do
            Wait(waitTime)

            if IsPlayerInMission() then
                local playerCoords = GetEntityCoords(PlayerPedId())

                for _, helpMarker in pairs(Config.MissionHelpMarkers) do
                    if helpMarker.render then
                        local distanceToMarker = #(playerCoords - helpMarker.pos)

                        if distanceToMarker < helpMarker.rangeTorRender
                            or (IsTutorialCameraDisplaying() and IsPlayerCorrectlyDressedForJob())
                            or (IsPlayerInMission() and not helpMarker.workingClothes)
                        then
                            waitTime = 0
                            DrawMarker(
                                helpMarker.type,
                                helpMarker.pos.x, helpMarker.pos.y, helpMarker.pos.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                helpMarker.size.x, helpMarker.size.y, helpMarker.size.z,
                                helpMarker.color.r, helpMarker.color.g, helpMarker.color.b, helpMarker.color.a,
                                helpMarker.bobUpAndDown, helpMarker.faceCamera, 0, helpMarker.rotate
                            )
                        end
                    else
                        waitTime = 1000
                    end
                end
            end
        end
    end, "render light")
end

if Config.TargetZoneType ~= 0 then
    CreateThread(function()
        for _, processingLocation in pairs(Config.ProcessingLocationForBarrel) do
            CreateTargetZone(processingLocation.pos + vector3(0, 0, 1), 1.7, 1.0, processingLocation.heading, {
                {
                    distance = 1.1,
                    num = 1,
                    type = "client",
                    event = "rcore_fuel:process_barrel",
                    icon = _U("target_process_icon"),
                    label = _U("target_process_label"),
                    targeticon = _U("target_process_targeticon"),
                    canInteract = function()
                        return true
                    end,
                    drawColor = { 255, 255, 255, 255 },
                    successDrawColor = { 30, 144, 255, 255 },
                    eventAction = "process_barrel",
                },
            })
        end
    end, "creating target zone main.lua 66")
end

CreateThread(function()
    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, processingLocation in pairs(Config.ProcessingLocationForBarrel) do
            local distanceToLocation = #(playerCoords - processingLocation.pos)

            if distanceToLocation < 50 or IsTutorialCameraDisplaying() then
                if not processingLocation.entity then
                    local processingEntity = CreateLocalObject(processingLocation.model, processingLocation.pos)
                    FreezeEntityPosition(processingEntity, true)
                    SetEntityHeading(processingEntity, processingLocation.heading)
                    processingLocation.entity = processingEntity
                end
            elseif processingLocation.entity then
                DeleteEntity(processingLocation.entity)
                processingLocation.entity = nil
            end
        end
    end
end, "creating location for processing barrels")

CreateThread(function()
    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local missionFuelPipe = Config.MissionFuelPipe
        local distanceToPipe = #(missionFuelPipe.pos - playerCoords)

        if distanceToPipe < missionFuelPipe.renderDistance then
            if not missionFuelPipe.entity then
                local pipeEntity = CreateLocalObject(missionFuelPipe.model, missionFuelPipe.pos)
                FreezeEntityPosition(pipeEntity, true)
                SetEntityHeading(pipeEntity, missionFuelPipe.heading)
                SetEntityCollision(pipeEntity, false, false)
                missionFuelPipe.entity = pipeEntity
            end
        elseif missionFuelPipe.entity then
            DeleteEntity(missionFuelPipe.entity)
            missionFuelPipe.entity = nil
        end
    end
end, "local object for mission pipe 113 main.lua")

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    if Config.MissionFuelPipe and DoesEntityExist(Config.MissionFuelPipe.entity) then
        DeleteEntity(Config.MissionFuelPipe.entity)
    end

    for _, processingLocation in pairs(Config.ProcessingLocationForBarrel) do
        if DoesEntityExist(processingLocation.entity) then
            DeleteEntity(processingLocation.entity)
        end
    end
end)

PendingMissionFuelData = nil

RegisterNetEvent("rcore_fuel:prepareMissionData", function(missionId, fuelData)
    PendingMissionFuelData = fuelData
end)
