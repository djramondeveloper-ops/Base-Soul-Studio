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

local cleaningPlayerFrozen = false
local cleaningActive = false

local function FinishCleaningSession()
    cleaningActive = false
end

RegisterNetEvent("rcore_fuel:selectVehicleForCleaning", function()
    if cleaningActive then
        ShowNotification("You are already cleaning a vehicle.")
        return
    end

    cleaningActive = true
    ShowHelpNotification(_U("select_vehicle"), false, true, 10000)

    local ped = PlayerPedId()
    local veh = LetUserSelectVehicle()
    if not veh or not DoesEntityExist(veh) then
        FinishCleaningSession()
        return
    end

    ShowNotification("Walk to each window marker and press ~INPUT_PICKUP~ to clean it.", 6000)

    -- GetModelDimensions returns min/max corners. Use the bounding-box diagonal so
    -- marker placement scales sensibly across different vehicle sizes.
    local modelMin, modelMax = GetModelDimensions(GetEntityModel(veh))
    local size = #(modelMax - modelMin)

    local prepPose = {
        vector3(1.1, -0.9, 0.5),
        vector3(1.1, 0.9, 0.5),
        vector3(-1.1, -0.9, 0.5),
        vector3(-1.1, 0.9, 0.5),
    }

    local doorPos = {}
    for _, v in ipairs(prepPose) do
        local x = (size / 2.647) * v.x
        local y = (size / 2.647) * v.y
        table.insert(doorPos, vector3(x, y, v.z))
    end

    local breakLoop = false
    local freezeCommand = false
    local remainingDoors = #doorPos

    while true do
        Wait(0)

        if breakLoop then
            FinishCleaningSession()
            return
        end

        ped = PlayerPedId()
        if not DoesEntityExist(veh) or IsEntityDead(ped) or #(GetEntityCoords(veh) - GetEntityCoords(ped)) >= 35 then
            FinishCleaningSession()
            return
        end

        local pedCoords = GetEntityCoords(ped)
        local cleanKey = Config.KeyMaps and Config.KeyMaps[KeyAction.CLEAN_VEHICLE]
        local cleanGroup = (cleanKey and cleanKey.group) or 0
        local cleanControl = (cleanKey and cleanKey.control) or 38

        for k, v in pairs(doorPos) do
            local pos = GetOffsetFromEntityInWorldCoords(veh, v)
            local distance = #(pos - pedCoords)

            -- The old code had invisible interaction points, which made the item
            -- appear to do nothing after selecting a vehicle.
            DrawMarker(
                20,
                pos.x, pos.y, pos.z + 0.15,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.22, 0.22, 0.22,
                255, 255, 255, 180,
                false, true, 2, false, nil, nil, false
            )

            if distance <= 1.25 and not freezeCommand then
                ShowHelpNotification("Press ~INPUT_PICKUP~ to clean this window", true, false)

                if IsControlJustReleased(cleanGroup, cleanControl) or IsDisabledControlJustReleased(cleanGroup, cleanControl) then
                    freezeCommand = true

                    CreateThread(function()
                        local arrived = GoToCoordsWithHeadingInTime(
                            ped,
                            pos - vector3(0, 0, 1),
                            GetPotentitalHeadingForCoords(GetEntityCoords(veh)),
                            1000
                        )
                        if not arrived or not cleaningActive or not DoesEntityExist(veh) then
                            freezeCommand = false
                            return
                        end
                        Animation.Play("clean2")
                        FreezeEntityPosition(ped, true)
                        cleaningPlayerFrozen = true

                        Wait(10000)

                        FreezeEntityPosition(ped, false)
                        cleaningPlayerFrozen = false
                        doorPos[k] = nil
                        remainingDoors = remainingDoors - 1
                        freezeCommand = false
                        Animation.ResetAll()

                        if remainingDoors <= 0 then
                            SetVehicleDirtLevel(veh, 0.0)

                            -- The cleaner is reusable while the job is in progress and is
                            -- consumed only after all four windows have been cleaned.
                            -- Inventory mutation stays server-side through InventoryBridge.
                            TriggerServerEvent("rcore_fuel:consumeWindowCleaner")

                            ShowNotification("Vehicle windows cleaned.", 5000)
                            breakLoop = true
                        else
                            ShowNotification(string.format("Window cleaned. %d remaining.", remainingDoors), 2500)
                        end
                    end, "animation for cleaning vehicle")
                end
            end
        end
    end
end)

-- Cleanup cleaning freeze/state if the resource is restarted mid-animation.
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    cleaningActive = false
    if cleaningPlayerFrozen then
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(PlayerPedId())
        cleaningPlayerFrozen = false
    end
end)
