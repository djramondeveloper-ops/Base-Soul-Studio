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

local enumeratorMetatable = {}

function enumeratorMetatable.__gc(enumerator)
    if enumerator.destructor and enumerator.handle then
        enumerator.destructor(enumerator.handle)
    end

    enumerator.destructor = nil
    enumerator.handle = nil
end

function CreateEntityEnumerator(findFirst, findNext, findEnd)
    return coroutine.wrap(function()
        local handle, entity = findFirst()

        if not entity or entity == 0 then
            findEnd(handle)
            return
        end

        local enumerator = {
            handle = handle,
            destructor = findEnd,
        }

        setmetatable(enumerator, enumeratorMetatable)

        local hasNext = true
        repeat
            coroutine.yield(entity)
            hasNext, entity = findNext(handle)
        until not hasNext

        enumerator.handle = nil
        enumerator.destructor = nil
        findEnd(handle)
    end)
end

function EnumerateVehicles()
    return CreateEntityEnumerator(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function IsSpawnPointClear(coords, radius)
    return #GetVehiclesInArea(coords, radius) == 0
end

function GetVehiclesInArea(coords, radius)
    local nearbyVehicles = {}

    for _, vehicle in ipairs(GetVehicles()) do
        if #(GetEntityCoords(vehicle) - coords) <= radius then
            table.insert(nearbyVehicles, vehicle)
        end
    end

    return nearbyVehicles
end

function GetAnyVehicleInArea(coords, radius)
    for _, vehicle in ipairs(GetVehicles()) do
        if #(GetEntityCoords(vehicle) - coords) <= radius then
            return vehicle
        end
    end
end

function GetClosestVehicleInArea(coords, radius)
    local closestVehicle = nil
    local closestDistance = nil

    for _, vehicle in ipairs(GetVehicles()) do
        if DoesEntityExist(vehicle) then
            local distance = #(GetEntityCoords(vehicle) - coords)
            if distance <= radius and (not closestDistance or distance < closestDistance) then
                closestVehicle = vehicle
                closestDistance = distance
            end
        end
    end

    return closestVehicle
end

function GetVehicles()
    if GetGamePool then
        local poolVehicles = GetGamePool('CVehicle')
        if poolVehicles and type(poolVehicles) == "table" then
            return poolVehicles
        end
    end

    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        if NetworkGetEntityIsNetworked(vehicle) ~= false then
            table.insert(vehicles, vehicle)
        end
    end

    return vehicles
end

function GetVehiclesByModel(coords, radius, modelHash)
    for _, vehicle in pairs(GetVehicles()) do
        if #(GetEntityCoords(vehicle) - coords) <= radius and GetEntityModel(vehicle) == modelHash then
            return vehicle
        end
    end

    return false
end

function ResolveVehicleModelHash(model)
    if type(model) ~= "number" or not model then
        model = GetHashKey(model)
    end

    return model
end

function LoadVehicleModel(model)
    model = ResolveVehicleModelHash(model)

    if not IsModelInCdimage(model) or not IsModelValid(model) then
        print(
            string.format("[rcore_fuel] [ERROR] Model: %s does not exist in game! Please configure a valid vehicle spawn model!", tostring(model))
        )
        return model
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        local timeout = 0
        while not HasModelLoaded(model) and timeout < 300 do
            Wait(33)
            timeout = timeout + 1
        end
        if not HasModelLoaded(model) then
            print(string.format("[rcore_fuel] [ERROR] Timed out loading vehicle model: %s", tostring(model)))
        end
    end

    return model
end

function CreateLocalVehicle(model, coords, heading)
    model = LoadVehicleModel(model)

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
    SetVehRadioStation(vehicle, "OFF")
    SetModelAsNoLongerNeeded(model)

    return vehicle
end

function CreateNetworkVehicle(model, coords, heading)
    model = LoadVehicleModel(model)

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetVehRadioStation(vehicle, "OFF")
    SetModelAsNoLongerNeeded(model)

    return vehicle
end

function LetUserSelectVehicle()
    local selectedVehicle = nil
    local selectionFinished = false
    local playerPed = PlayerPedId()
    local startCoords = GetEntityCoords(playerPed)

    CreateThread(function()
        while true do
            Wait(300)

            if selectionFinished then
                return
            end

            if #(startCoords - GetEntityCoords(playerPed)) > 15 then
                if selectedVehicle and DoesEntityExist(selectedVehicle) then
                    SetEntityDrawOutline(selectedVehicle, false)
                end
                selectedVehicle = nil
                selectionFinished = true
                return
            end

            local _, hit, _, _, entityHit = CastRayCastFromPlayer(PlayerPedId(), 4294967295, 10.0)

            if hit == 1 and GetEntityType(entityHit) == 2 then
                if selectedVehicle ~= entityHit then
                    if selectedVehicle and DoesEntityExist(selectedVehicle) then
                        SetEntityDrawOutline(selectedVehicle, false)
                    end
                    selectedVehicle = entityHit
                    SetEntityDrawOutline(entityHit, true)

                    local outlineColor = Config.ColorTarget or { r = 255, g = 255, b = 255, a = 255 }
                    SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
                    SetEntityDrawOutlineShader(1)
                end
            elseif selectedVehicle then
                if DoesEntityExist(selectedVehicle) then
                    SetEntityDrawOutline(selectedVehicle, false)
                end
                selectedVehicle = nil
            end
        end
    end, "LetUserSelectVehicle")

    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        if IsEntityDead(playerPed) then
            selectionFinished = true
            ClearPedTasksImmediately(playerPed)
            if selectedVehicle and DoesEntityExist(selectedVehicle) then
                SetEntityDrawOutline(selectedVehicle, false)
            end
            return nil
        end

        -- SELECT confirms the selection and returns the vehicle; CANCEL abandons it.
        -- The default SELECT control is INPUT_ATTACK (left mouse / control 24).
        -- Without disabling it, GTA also processes the same click as a melee/attack,
        -- which is why the ped punches/kicks when choosing a vehicle.
        local selectKey = Config.KeyMaps and Config.KeyMaps[KeyAction.SELECT_VEHICLE]
        local selectGroup = (selectKey and selectKey.group) or 0
        local selectControl = (selectKey and selectKey.control) or 38 -- E

        -- Consume the selection input and common combat inputs while this selector is open.
        -- IsDisabledControlJustReleased below still lets us use the disabled key for selection.
        DisableControlAction(selectGroup, selectControl, true)
        DisableControlAction(0, 24, true)  -- INPUT_ATTACK
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
        DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
        DisablePlayerFiring(PlayerId(), true)

        if IsDisabledControlJustReleased(selectGroup, selectControl) then
            if selectedVehicle and DoesEntityExist(selectedVehicle) and GetEntityType(selectedVehicle) == 2 then
                selectionFinished = true
                SetEntityDrawOutline(selectedVehicle, false)
                return selectedVehicle
            end
        end

        local cancelKey = Config.KeyMaps and Config.KeyMaps[KeyAction.CANCEL_SELECTION_VEHICLE]
        local cancelGroup = (cancelKey and cancelKey.group) or 0
        local cancelControl = (cancelKey and cancelKey.control) or 73 -- X
        if IsControlJustReleased(cancelGroup, cancelControl) then
            ClearPedTasksImmediately(PlayerPedId())
            selectionFinished = true
            if selectedVehicle and DoesEntityExist(selectedVehicle) then
                SetEntityDrawOutline(selectedVehicle, false)
            end
            return nil
        end

        if selectionFinished then
            break
        end
    end
end

function ResolveVehicleModelName(vehicle, modelHash)
    local modelName = ""

    for _, spawnName in pairs(GetAllVehicleModels()) do
        if modelHash == GetHashKey(spawnName) then
            modelName = spawnName
        end
    end

    return modelName
end

function GiveVehicleKeys(vehicle)
    local modelHash = GetEntityModel(vehicle)
    local modelName = ResolveVehicleModelName(vehicle, modelHash)
    Config.GiveVehicleKeys(vehicle, modelHash, modelName, GetVehicleNumberPlateText(vehicle))
end

function RemoveVehicleKeys(vehicle)
    local modelHash = GetEntityModel(vehicle)
    local modelName = ResolveVehicleModelName(vehicle, modelHash)
    Config.RemoveVehicleKeys(vehicle, modelHash, modelName, GetVehicleNumberPlateText(vehicle))
end
