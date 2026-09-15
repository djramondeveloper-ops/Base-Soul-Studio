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

if Config.TargetZoneType ~= 0 then
    CreateThread(function()
        local targetConfig = Config.BarrelSpawnLocationsTarget

        CreateTargetZone(targetConfig.pos, targetConfig.length, targetConfig.width, targetConfig.heading, {
            {
                distance = 0.7,
                num = 1,
                type = "client",
                event = "rcore_fuel:pickup_barrel",
                icon = _U("target_pickup_barrel_icon"),
                label = _U("target_pickup_barrel_label"),
                targeticon = _U("target_pickup_barrel_targeticon"),
                canInteract = function()
                    return true
                end,
                drawColor = { 255, 255, 255, 255 },
                successDrawColor = { 30, 144, 255, 255 },
                eventAction = "pickup_barrel",
            },
        })
    end, "creating target zone propSpawner.lua 23")
end

CreateThread(function()
    local nextHelpNotificationTime = 0

    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, barrelLocation in pairs(Config.BarrelSpawnLocations) do
            if IsPlayerCorrectlyDressedForJob() then
                local distanceToBarrel = #(playerCoords - barrelLocation.pos)

                if distanceToBarrel < 1 then
                    if not barrelLocation.entered then
                        if Config.TargetZoneType == 0 then
                            local gameTimer = GetGameTimer()
                            if nextHelpNotificationTime < gameTimer then
                                nextHelpNotificationTime = gameTimer + 6000
                                ShowHelpNotification(_U("pick_barrel"), true, true, 5000)
                            end
                        end

                        barrelLocation.entered = true
                    end
                else
                    barrelLocation.entered = nil
                end
            end

            local shouldShowBarrel = #(playerCoords - barrelLocation.pos) < 30 or IsTutorialCameraDisplaying()

            if shouldShowBarrel then
                if not barrelLocation.entity then
                    local barrelEntity = CreateLocalObject("prop_barrel_01a", barrelLocation.pos)
                    FreezeEntityPosition(barrelEntity, true)

                    if barrelLocation.heading then
                        SetEntityHeading(barrelEntity, barrelLocation.heading)
                    else
                        SetEntityHeading(barrelEntity, math.random(360.0) + 0.0)
                    end

                    if barrelLocation.rotation then
                        SetEntityRotation(barrelEntity, barrelLocation.rotation)
                    end

                    barrelLocation.entity = barrelEntity
                end
            elseif barrelLocation.entity then
                DeleteEntity(barrelLocation.entity)
                barrelLocation.entity = nil
            end
        end
    end
end, "pick up barrel notification")

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for _, barrelLocation in pairs(Config.BarrelSpawnLocations) do
        if DoesEntityExist(barrelLocation.entity) then
            DeleteEntity(barrelLocation.entity)
        end
    end
end)
