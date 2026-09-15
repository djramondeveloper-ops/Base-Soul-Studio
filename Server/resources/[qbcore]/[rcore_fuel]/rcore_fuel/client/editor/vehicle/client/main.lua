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

local isEditorEnabled = false
local offsetX = -4
local offsetY = -4
local offsetZ = 0.0
local editSpeed = 0.01
local playerHeading = 0.0
local currentVehicleModelHash = 0
local editorVehicleEntity = 0
local fuelNozzleEntity = 0
local savedPlayerCoords = vector3(0, 0, 0)
local vehicleModelList = {}
local currentVehicleIndex = 1

local editorSpawnPosition = vector3(-1352.15, -2800.38, 13.94)
local editorSpawnHeading = 60.0

function SpawnVehicleForEditorByIndex(vehicleIndex)
    DeleteEntity(editorVehicleEntity)

    editorVehicleEntity = CreateLocalVehicle(
        vehicleModelList[vehicleIndex],
        editorSpawnPosition,
        editorSpawnHeading
    )

    currentVehicleModelHash = GetEntityModel(editorVehicleEntity)
    FreezeEntityPosition(editorVehicleEntity, true)

    offsetX = -4
    offsetY = -4
    offsetZ = 0.0
    playerHeading = 0.0

    local offset, heading = GetVehicleOffsetFuelingAnimation(currentVehicleModelHash)
    offsetX, offsetY, offsetZ = offset.x, offset.y, offset.z
    playerHeading = heading
end

RegisterCommand("offsetfueling", function(_source, args)
    if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
        TriggerEvent("chat:addMessage", {
            args = {
                "^1SYSTEM",
                "Warning you do not have permission to open this command. You did not added the 'add_ace' or you dont have on your character 'add_principal'",
            },
        })
        TriggerEvent("chat:addMessage", {
            args = {
                "^1SYSTEM",
                "Second option is: Go to your 'Live Console' and type command /fuelgrantpermission [ID]",
            },
        })
        return
    end

    isEditorEnabled = not isEditorEnabled

    if isEditorEnabled then
        disableFire = true
        SetPlayerCanUseCover(PlayerId(), false)
        ShowNotification("Editor enabled")

        vehicleModelList = GetAllVehicleModels()

        if args[1] and IsModelInCdimage(args[1]) then
            for index, modelName in pairs(vehicleModelList) do
                if modelName == args[1] then
                    currentVehicleIndex = index
                    break
                end
            end
        end

        if IsPlayerInVehicle() then
            local currentVehicleModel = GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))

            for index, modelName in pairs(vehicleModelList) do
                if GetHashKey(modelName) == currentVehicleModel then
                    currentVehicleIndex = index
                    break
                end
            end
        end

        savedPlayerCoords = GetEntityCoords(PlayerPedId())
        SetEntityCoordsNoOffset(PlayerPedId(), editorSpawnPosition.x, editorSpawnPosition.y, editorSpawnPosition.z, false, false, true)
        Wait(2000)

        ShowHelpNotification(
            "~INPUT_SKIP_CUTSCENE~ to save changes\n\n"
                .. "~INPUT_SPRINT~ + ~INPUT_COVER~ / ~INPUT_PICKUP~ for vehicle change\n\n"
                .. "~INPUT_COVER~ / ~INPUT_PICKUP~ for rotation player\n\n"
                .. "~INPUT_PHONE~ ~INPUT_CELLPHONE_DOWN~ up/down speed change\n"
                .. "~INPUT_VEH_SUB_PITCH_UD~ backwards/forward\n"
                .. "~INPUT_VEH_SUB_TURN_LEFT_ONLY~ ~INPUT_VEH_SUB_TURN_RIGHT_ONLY~ left/right\n",
            false,
            false,
            9000000
        )

        SpawnVehicleForEditorByIndex(currentVehicleIndex)
        Animation.Play("fueling")
    else
        SetPlayerCanUseCover(PlayerId(), true)
        disableFire = false
        DeleteEntity(editorVehicleEntity)
        DeleteEntity(fuelNozzleEntity)
        Animation.ResetAll()
        SetEntityCoordsNoOffset(PlayerPedId(), savedPlayerCoords.x, savedPlayerCoords.y, savedPlayerCoords.z, false, false, true)
        ShowHelpNotification("...", false, false, 100)
        ShowNotification("You exited editor")
    end

    print("Editor status: ", isEditorEnabled)
end)

CreateThread(function()
    while true do
        if not isEditorEnabled then
            Wait(1000)
            goto continue
        end

        Wait(0)

        ShowNativeSubtitles(string.format(
            [[
offset: vector3(%.2f,%.2f,%.2f)
Heading: %.2f
Exists: %s
Append value: %s
Index %s/%s]],
            offsetX,
            offsetY,
            offsetZ,
            playerHeading,
            ExistingFuelingOffsetVehicles[currentVehicleModelHash] ~= nil,
            editSpeed,
            currentVehicleIndex,
            #vehicleModelList
        ))

        if DoesEntityExist(editorVehicleEntity) then
            local playerPed = PlayerPedId()
            local targetPosition = GetOffsetFromEntityInWorldCoords(
                editorVehicleEntity,
                vector3(offsetX, offsetY, offsetZ)
            )
            local groundPosition = vector3(
                targetPosition.x,
                targetPosition.y,
                GetGroundLevelZ(targetPosition)
            )
            local targetHeading = GetEntityHeading(editorVehicleEntity) - playerHeading
            SetEntityCoordsNoOffset(
                playerPed,
                groundPosition.x,
                groundPosition.y,
                groundPosition.z,
                true,
                true,
                false
            )
            SetEntityHeading(playerPed, targetHeading)

            if not DoesEntityExist(fuelNozzleEntity) then
                fuelNozzleEntity = CreateLocalObject(
                    "prop_cs_fuel_nozle",
                    GetEntityCoords(playerPed)
                )
                AttachFuelNozzleToPed(fuelNozzleEntity, playerPed)
            end
        end

        if IsControlJustReleased(1, 18) then
            print("Saved new data for model:", vehicleModelList[currentVehicleIndex])
            ShowNotification("Vehicle new offset saved!")
            TriggerServerEvent(
                "rcore_fuel:editor:saveOffset",
                currentVehicleModelHash,
                vector3(offsetX, offsetY, offsetZ),
                playerHeading
            )
        end

        if IsControlPressed(1, 21) then
            if IsControlJustReleased(1, 38) then
                currentVehicleIndex = currentVehicleIndex + 1

                if currentVehicleIndex > #vehicleModelList then
                    currentVehicleIndex = 1
                end

                SpawnVehicleForEditorByIndex(currentVehicleIndex)
            elseif IsControlJustReleased(1, 44) then
                currentVehicleIndex = currentVehicleIndex - 1

                if currentVehicleIndex < 1 then
                    currentVehicleIndex = #vehicleModelList
                end

                SpawnVehicleForEditorByIndex(currentVehicleIndex)
            end
        elseif IsControlPressed(1, 38) then
            playerHeading = playerHeading + 0.33

            if playerHeading > 360.0 then
                playerHeading = 0.0
            end
        elseif IsControlPressed(1, 44) then
            playerHeading = playerHeading - 0.33

            if playerHeading < 0.0 then
                playerHeading = 360.0
            end
        end

        if IsControlPressed(1, 27) then
            editSpeed = editSpeed + 0.000005
        end

        if IsControlPressed(1, 173) then
            editSpeed = editSpeed - 0.000005

            if editSpeed <= 0.0 then
                editSpeed = 0.000005
            end
        end

        if IsControlPressed(1, 127) then
            offsetX = offsetX + editSpeed
        end

        if IsControlPressed(1, 126) then
            offsetX = offsetX - editSpeed
        end

        if IsControlPressed(1, 124) then
            offsetY = offsetY + editSpeed
        end

        if IsControlPressed(1, 125) then
            offsetY = offsetY - editSpeed
        end

        ::continue::
    end
end, "editor for fuel offset")

RegisterNetEvent("rcore_fuel:editorSetNewOffset", function(modelHash, offsetData)
    ExistingFuelingOffsetVehicles[tonumber(modelHash)] = offsetData

    for _, customOffset in pairs(Config.CustomOffsetForFuelingVehicle) do
        ExistingFuelingOffsetVehicles[GetHashKey(customOffset.model)] = {
            offset = customOffset.offset,
            heading = customOffset.heading,
        }
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    if not DoesEntityExist(editorVehicleEntity) and not DoesEntityExist(fuelNozzleEntity) then
        return
    end

    DeleteEntity(editorVehicleEntity)
    DeleteEntity(fuelNozzleEntity)
    Animation.ResetAll()
    SetEntityCoordsNoOffset(PlayerPedId(), savedPlayerCoords.x, savedPlayerCoords.y, savedPlayerCoords.z, false, false, true)
    ShowHelpNotification("...", false, false, 100)
end)
