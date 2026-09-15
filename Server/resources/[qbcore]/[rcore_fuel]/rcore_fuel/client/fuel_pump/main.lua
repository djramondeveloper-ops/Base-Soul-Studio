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

local isRefuelingStarted = false
local selectedVehicleEntity = nil
local isJerryCanFueling = false
local highlightedVehicleEntity = nil
local currentPumpSide = nil
local nearPumpShopId = nil
local currentDispenserConfig = nil
local currentDispenserSlotIndex = nil
local currentPumpShopId = nil
local currentDispenserValues = nil
local currentDispenserId = nil
local isSelectVehicleBusy = false
local selectVehicleDebounce = false
local fuelingGeneration = 0

IsPumping = false
IsEntityDetach = false

function GetSelectedVehicleForFueling()
    if not selectedVehicleEntity then
        return highlightedVehicleEntity
    end

    return selectedVehicleEntity
end

function GetCurrentPumpSideEntered()
    return currentPumpSide
end

function GetCurrentPumpIdentifier()
    return currentPumpShopId
end

function GetCurrentDispenserIdentifier()
    return currentDispenserId
end

function GetCurrentDispenserValues()
    return currentDispenserValues
end

function GetCurrentFuelPumpTypeFuel()
    local dispenserValues = GetCurrentDispenserValues()
    return dispenserValues and dispenserValues.fuelType or nil
end

function GetPumpDuiIdentifier()
    return "pump_" .. GetCurrentPumpIdentifier() .. "_" .. GetCurrentDispenserIdentifier()
end

function GetLerpAmountForFuelType(fuelType)
    local flowRate = (GetGunFlowRatePerMinute(fuelType) or 60) * 0.8
    if flowRate <= 0 then flowRate = 48.0 end
    return (60000 / flowRate) / 1000
end

function StopFueling(fromServer)
    -- A delayed server acknowledgement must not cancel the nozzle-return gesture.
    if fromServer and not IsPumping and not isRefuelingStarted then return end
    if IsPumping then TriggerEvent("rcore_fuel:refuelSummary", { status = "Stopped — return the nozzle to pay" }) end
    fuelingGeneration = fuelingGeneration + 1
    if IsPlayerWalkingToCoordinates() then
        CancelWalkToCoordinates()
        ClearPedTasks(PlayerPedId())
    end
    local vehicleNetId = nil

    if selectedVehicleEntity and selectedVehicleEntity ~= 0 and DoesEntityExist(selectedVehicleEntity) then
        vehicleNetId = VehToNet(selectedVehicleEntity)
    end

    local dispenserValues = GetCurrentDispenserValues()
    local fuelType = dispenserValues and dispenserValues.fuelType or nil
    if not fromServer then
        TriggerServerEvent("rcore_fuel:stopFueling", GetCurrentPumpIdentifier(), fuelType, vehicleNetId)
        TriggerEvent("rcore_fuel:stopFueling", vehicleNetId)
    end
    Animation.ResetAll()
    -- FIX 15: was missing the sideId argument entirely (and liquidPosition, for
    -- the isPlaying=true call sites below) -- the receiving handler uses sideId
    -- as a table key (pumpPosition.soundPlayerPump[sideId]), so a nil there
    -- crashed with "table index is nil". This fires on every return-the-nozzle
    -- action, matching the reported crash exactly.
    TriggerServerEvent("rcore_fuel:syncSoundPump", false, currentPumpShopId, currentDispenserId, currentPumpSide)

    IsPlayerReadyToPump = true
    IsPumping = false
    isJerryCanFueling = false
    isRefuelingStarted = false
    freezeSelectVehicle = false
    StopFuelFXOnEntity()
end

function ResetFuelingVariables()
    fuelingGeneration = fuelingGeneration + 1
    if IsPlayerWalkingToCoordinates() then
        CancelWalkToCoordinates()
        ClearPedTasks(PlayerPedId())
    end
    -- Clear visual state before dropping entity handles. Otherwise an outline can
    -- remain on a vehicle after the nozzle/session is reset.
    if highlightedVehicleEntity and DoesEntityExist(highlightedVehicleEntity) then
        SetEntityDrawOutline(highlightedVehicleEntity, false)
    end
    if selectedVehicleEntity and DoesEntityExist(selectedVehicleEntity) then
        SetEntityDrawOutline(selectedVehicleEntity, false)
    end

    currentPumpShopId = nil
    currentDispenserValues = nil
    currentDispenserId = nil
    selectedVehicleEntity = nil
    isRefuelingStarted = false
    IsPlayerReadyToPump = false
    isJerryCanFueling = false
    highlightedVehicleEntity = nil
    IsPumping = false
    nearPumpShopId = nil
    currentDispenserConfig = nil
    currentDispenserSlotIndex = nil
    currentPumpSide = nil
    DisableMouseForSelectVehicle = false
    isSelectVehicleBusy = false
end

function ClearHighlightedVehicle()
    if highlightedVehicleEntity then
        if DoesEntityExist(highlightedVehicleEntity) then
            SetEntityDrawOutline(highlightedVehicleEntity, false)
        end
        highlightedVehicleEntity = nil
    end
end

function SetHighlightedVehicle(vehicleEntity)
    if not vehicleEntity or vehicleEntity == 0 or not DoesEntityExist(vehicleEntity) then
        ClearHighlightedVehicle()
        return
    end

    if highlightedVehicleEntity ~= vehicleEntity then
        if highlightedVehicleEntity and DoesEntityExist(highlightedVehicleEntity) then
            SetEntityDrawOutline(highlightedVehicleEntity, false)
        end
        highlightedVehicleEntity = vehicleEntity
    end

    SetEntityDrawOutline(vehicleEntity, true)

    local outlineColor = Config.ColorTarget or { r = 255, g = 255, b = 255, a = 255 }
    SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    SetEntityDrawOutlineShader(1)
end

function IsTargetSystemKeyPressed()
    return IsControlPressed(1, Config.KeyForTargetSystem) or IsDisabledControlPressed(1, Config.KeyForTargetSystem)
end

function DisableJerryCanFuelingControls()
    DisablePlayerFiring(PlayerId(), true)
    DisableControlAction(0, 21, true) -- sprint
    DisableControlAction(0, 22, true) -- jump
    DisableControlAction(0, 23, true) -- enter vehicle
    DisableControlAction(0, 30, true) -- movement
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 29, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(1, 37, true)
    DisableControlAction(0, 140, true)
end

function ValidateVehicleFuelType(pumpFuelType, vehicleFuelType)
    local denyRules = Config.DenyFuelingFromTypeFuelForTypeFuel[pumpFuelType]

    -- Physical incompatibilities (for example an EV connector on a combustion car)
    -- are always denied, independently from the optional wrong-fuel gameplay setting.
    if denyRules and denyRules[vehicleFuelType] then
        ShowHelpNotification(_U("wrong_fuel_type_engine", _U(vehicleFuelType), _U(pumpFuelType)), false, true, 10000)
        return false
    end

    -- When strict type checking is enabled, also reject otherwise-compatible but
    -- incorrect fuel (for example gasoline in a diesel). When disabled, that mistake
    -- is intentionally allowed so the wrong-fuel / pump-out mechanics can run.
    if Config.CheckForFuelType and pumpFuelType ~= vehicleFuelType then
        ShowHelpNotification(_U("wrong_fuel_type_car", _U(vehicleFuelType), _U(pumpFuelType)), false, true, 10000)
        return false
    end

    return true
end

function StartJerryCanFuelingThread(generation)
    CreateThread(function()
        while IsPumping and generation == fuelingGeneration do
            Wait(0)
            DisableJerryCanFuelingControls()
        end
    end, "disable entering vehicle and so on")
end

function BeginVehicleFueling(playerPed)
    local vehicle = selectedVehicleEntity
    if not vehicle or not DoesEntityExist(vehicle) then return end
    fuelingGeneration = fuelingGeneration + 1
    local generation = fuelingGeneration
    isRefuelingStarted = true
    isJerryCanFueling = false
    SetEntityDrawOutline(selectedVehicleEntity, false)

    if not IsPlayerHoldingJerryCan() then
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
    end

    IsPumping = true

    local fuelPosition, targetHeading = GetVehicleFuelingPosition(vehicle)
    local vehicleStart = GetEntityCoords(vehicle)
    local vehicleHeading = GetEntityHeading(vehicle)
    local function canContinue()
        return generation == fuelingGeneration and IsPumping and IsPlayerHoldingDispenserGun()
            and PlayerPedId() == playerPed and DoesEntityExist(vehicle)
            and not IsEntityDead(playerPed) and not IsPedRagdoll(playerPed)
            and not IsPedInAnyVehicle(playerPed, false)
            and #(GetEntityCoords(vehicle) - vehicleStart) < 0.75
            and math.abs(GetShortestAngleDistance(vehicleHeading, GetEntityHeading(vehicle))) < 10
    end
    StartJerryCanFuelingThread(generation)
    if not GoToCoordsWithHeadingInTime(playerPed, fuelPosition, targetHeading, 1500, canContinue)
        or not canContinue() then
        if generation == fuelingGeneration then
            StopFueling()
            ShowNotification("Could not reach the fueling position. Move closer with a clear path and try again.")
        end
        return
    end
    Animation.ResetAll()
    if not Animation.Play("fueling") or not canContinue() then
        if generation == fuelingGeneration then StopFueling() end
        return
    end

    TriggerServerEvent("rcore_fuel:syncSoundPump", true, currentPumpShopId, currentDispenserId, currentPumpSide, fuelPosition)

    local dispenserValues = GetCurrentDispenserValues()
    local fuelType = dispenserValues and dispenserValues.fuelType or nil

    SendDUIDataByIdentifier(GetPumpDuiIdentifier(), {
        type = "lerpAmount",
        amount = GetLerpAmountForFuelType(fuelType),
    })

    TriggerEvent("rcore_fuel:startFueling", VehToNet(vehicle))
    CreateThread(function()
        while generation == fuelingGeneration and IsPumping do
            Wait(100)
            if generation ~= fuelingGeneration then return end
            if not canContinue() or #(GetEntityCoords(playerPed) - fuelPosition) > 1.5 then
                StopFueling()
                return
            end
        end
    end, "monitor fueling position")
end

function BeginJerryCanFueling()
    fuelingGeneration = fuelingGeneration + 1
    local generation = fuelingGeneration
    isRefuelingStarted = true
    isJerryCanFueling = true
    IsPumping = true
    if not Animation.Play("type") or generation ~= fuelingGeneration then
        if generation == fuelingGeneration then StopFueling() end
        return
    end
    TriggerServerEvent("rcore_fuel:syncSoundPump", true, currentPumpShopId, currentDispenserId, currentPumpSide, GetEntityCoords(PlayerPedId()))
    TriggerEvent("rcore_fuel:startFueling")
    StartJerryCanFuelingThread(generation)
end

function SelectedVehicleAndStartFueling()
    -- Stop must work during the approach and even when the target becomes full.
    if IsPumping then
        StopFueling()
        return
    end
    if isSelectVehicleBusy then
        return
    end

    if selectVehicleDebounce then
        return
    end

    isSelectVehicleBusy = true

    if highlightedVehicleEntity and highlightedVehicleEntity ~= 0
        and DoesEntityExist(highlightedVehicleEntity) and IsVehicleFull(highlightedVehicleEntity) then
        ShowHelpNotification(_U("vehicle_is_full"), false, true, 10000)
        isSelectVehicleBusy = false
        return
    end

    if IsPlayerReadyToPump and not IsPumping then
        selectedVehicleEntity = highlightedVehicleEntity
    end

    selectVehicleDebounce = true
    SetTimeout(1000, function()
        selectVehicleDebounce = false
    end)

    local playerPed = PlayerPedId()

    if DisableMouseForSelectVehicle then
        isSelectVehicleBusy = false
        return
    end

    if IsPlayerReadyToPump then
        if IsPumping then
            StopFueling()
            IsPlayerReadyToPump = true
            IsPumping = false
            isJerryCanFueling = false
            isRefuelingStarted = false
            isSelectVehicleBusy = false
            return
        end

        if IsPlayerHoldingJerryCan() and not isJerryCanFueling then
            local pumpFuelType = GetCurrentFuelPumpTypeFuel()

            local isAllowed = false
            if pumpFuelType then
                if Config.JerrycanRefuelingAllowedForSpecificTypes then
                    isAllowed = Config.JerrycanRefuelingAllowedForSpecificTypes[pumpFuelType] == true
                        or Config.JerrycanRefuelingAllowedForSpecificTypes[tostring(pumpFuelType)] == true
                    if not isAllowed then
                        for _, v in pairs(Config.JerrycanRefuelingAllowedForSpecificTypes) do
                            if v == pumpFuelType then isAllowed = true break end
                        end
                    end
                else
                    isAllowed = true
                end
            end

            if isAllowed and not IsTargetSystemKeyPressed() then
                BeginJerryCanFueling()
                isSelectVehicleBusy = false
                return
            end
        end

        if selectedVehicleEntity and DoesEntityExist(selectedVehicleEntity) and not isJerryCanFueling then
            local pumpFuelType = GetCurrentFuelPumpTypeFuel()
            local vehicleFuelType = GetVehicleFuelType(GetEntityModel(selectedVehicleEntity))

            if ValidateVehicleFuelType(pumpFuelType, vehicleFuelType) then
                BeginVehicleFueling(playerPed)
            else
                isSelectVehicleBusy = false
                return
            end
        end
    end

    isSelectVehicleBusy = false
end

CreateThread(function()
    local waitTime = 1000

    while true do
        Wait(waitTime)

        if IsPlayerReadyToPump and not IsPumping and not isRefuelingStarted then
            waitTime = 300

            local _, hit, _, _, entityHit = CastRayCastFromPlayer(PlayerPedId(), 4294967295, 10.0)

            if hit == 1 and GetEntityType(entityHit) == 2 and IsVehicleModelEnabledForFueling(entityHit) then
                SetHighlightedVehicle(entityHit)
            else
                ClearHighlightedVehicle()
            end
        else
            waitTime = 1000
            -- FIX 13: was just nil-ing the tracking variable without clearing the
            -- actual outline effect, leaving a stale glow on the vehicle -- use the
            -- helper that does both, same as the "no valid vehicle" branch above
            ClearHighlightedVehicle()
        end
    end
end, "raycast for highlight vehicle")

CreateThread(function()
    while true do
        Wait(0)

        if nearPumpShopId then
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 76, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 18, true)
        else
            Wait(1000)
        end
    end
end, "disabling entering vehicle")

-- Selection must exist before the asynchronous pump display has been created.
-- Keep the fuel and its one-based list index consistent across display reloads.
function ResolvePumpFuelSelection(dispenserValues)
    local fuelTypes = dispenserValues and dispenserValues.fuelTypeList
    if type(fuelTypes) ~= "table" or #fuelTypes == 0 then return nil end

    local index = tonumber(dispenserValues.activeType)
    if not index or index % 1 ~= 0 or index < 1 or index > #fuelTypes
        or fuelTypes[index] ~= dispenserValues.fuelType then
        index = nil
        for candidate, fuelType in ipairs(fuelTypes) do
            if fuelType == dispenserValues.fuelType then index = candidate break end
        end
        index = index or 1
    end

    dispenserValues.activeType = index
    dispenserValues.fuelType = fuelTypes[index]
    return index
end

function SwitchFuelType(skipCycle)
    Wait(1)

    -- The server captures the selected fuel type when a dispensing session starts.
    -- Changing the client selection mid-session makes UI/sound/wrong-fuel state disagree.
    if IsPumping or isRefuelingStarted then
        return
    end

    if not nearPumpShopId then
        return
    end

    local dispenserValues = GetCurrentDispenserValues()
    local shopId, dispenserId = GetCurrentPumpIdentifier(), GetCurrentDispenserIdentifier()
    local shop = Config.ShopList and Config.ShopList[shopId]
    if not shop or not dispenserId then return end

    local index = ResolvePumpFuelSelection(dispenserValues)
    if not index then return end
    local fuelTypes = dispenserValues.fuelTypeList
    if not skipCycle then index = index % #fuelTypes + 1 end

    -- Inspect each grade once without yielding into a different pump session.
    for _ = 1, #fuelTypes do
        local fuelType = fuelTypes[index]
        local capacity = shop.capacity and shop.capacity[fuelType]
        if capacity == nil or capacity >= 1 then
            dispenserValues.activeType = index
            dispenserValues.fuelType = fuelType
            local duiIdentifier = GetPumpDuiIdentifier()
            SendDUIDataByIdentifier(duiIdentifier, { type = "activeFuel", index = index - 1 })
            SendDUIDataByIdentifier(duiIdentifier, {
                type = "lerpAmount", amount = GetLerpAmountForFuelType(fuelType),
            })
            return
        end
        index = index % #fuelTypes + 1
    end
    ShowNotification(_U("pump_doesnt_have_any_fuel"))
end

RegisterKey(function()
    SwitchFuelType()
end, "switchFuelTypeInPump",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.SWITCH_FUEL_TYPE] and Config.KeyMaps[KeyAction.SWITCH_FUEL_TYPE].label) or "Switch fuel type",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.SWITCH_FUEL_TYPE] and Config.KeyMaps[KeyAction.SWITCH_FUEL_TYPE].action) or "q"
)

function pickupdispendergun()
    if IsPumping or isJerryCanRefuelingActive then
        return
    end

    if nearPumpShopId then
        local _, pumpSide = GetWalkOffsetForPump(currentDispenserConfig.entity)

        if pumpSide ~= GetCurrentPumpSideEntered() then
            return
        end
    end

    local playerCoords = GetEntityCoords(PlayerPedId())

    for shopId, shopData in pairs(Config.ShopList) do
        if #(shopData.blipPosition - playerCoords) <= 100 then
            for dispenserIndex, dispenserData in pairs(shopData.pumpPosition) do
                local resolvedPumpEntity = FindSupportedDispenserEntity(dispenserData.pos, dispenserData.hash, 3.0)
                if resolvedPumpEntity ~= 0 and DoesEntityExist(resolvedPumpEntity) and #(dispenserData.pos - playerCoords) < 2 then
                    dispenserData.entity = resolvedPumpEntity
                    if nearPumpShopId ~= nil then
                        if nearPumpShopId ~= shopId or currentDispenserSlotIndex ~= dispenserIndex then
                            goto continue_dispenser
                        end
                    end

                    local canUsePump = true

                    if shopData.fuel_only_employee then
                        -- FIX 14: comparing IsAtJob()'s boolean return to the job
                        -- name string can never be true (type mismatch), and the
                        -- "or canUsePump" self-reference made this always evaluate
                        -- to the pre-existing true regardless -- the employees-only
                        -- restriction never actually restricted anything.
                        canUsePump = IsAtJob(shopData.Job)
                    end

                    if shopData.open == false then
                        canUsePump = false
                    end

                    if not canUsePump then
                        local message = _U("must_find_employee")

                        if shopData.open == false then
                            message = _U("closed")
                        end

                        ShowHelpNotification(message, false, true, 10000)
                        return
                    end

                    local pumpEntity = resolvedPumpEntity

                    if not DoesEntityExist(pumpEntity) or pumpEntity == 0 then
                        break
                    end

                    currentPumpShopId = shopId
                    currentDispenserValues = dispenserData
                    currentDispenserId = dispenserIndex
                    nearPumpShopId = shopId
                    currentDispenserConfig = dispenserData
                    currentDispenserSlotIndex = dispenserIndex

                    local allowedFuelTypes = {}

                    for _, fuelType in pairs(currentDispenserConfig.fuelTypeList) do
                        allowedFuelTypes[fuelType] = true
                    end

                    local hasAvailableFuel = false
                    local shopCapacity = Config.ShopList[currentPumpShopId] and Config.ShopList[currentPumpShopId].capacity

                    if not shopCapacity then
                        hasAvailableFuel = true
                    else
                        -- A nil capacity entry means that fuel type is not stock-tracked
                        -- (unlimited), matching the server's ShopHasCapacity behavior.
                        for _, fuelType in pairs(currentDispenserConfig.fuelTypeList or {}) do
                            local fuelAmount = shopCapacity[fuelType]
                            if fuelAmount == nil or (tonumber(fuelAmount) or 0) >= 1 then
                                hasAvailableFuel = true
                                break
                            end
                        end
                    end

                    if not hasAvailableFuel and not IsPlayerReadyToPump then
                        ShowNotification(_U("pump_doesnt_have_any_fuel"))
                        ResetFuelingVariables()
                        break
                    end

                    local _, pumpSide = GetWalkOffsetForPump(pumpEntity)
                    if not pumpSide then
                        ShowNotification("This pump model has no usable nozzle side configured.")
                        ResetFuelingVariables()
                        return
                    end
                    local isSideOccupied = dispenserData.occupied and dispenserData.occupied[pumpSide]
                    local sideOwner = dispenserData.source and dispenserData.source[pumpSide]
                    local playerServerId = GetPlayerServerID()

                    if sideOwner ~= playerServerId and isSideOccupied then
                        ResetFuelingVariables()
                        return
                    end

                    currentPumpSide = pumpSide
                    TriggerServerEvent("rcore_fuel:pumpIsFree", pumpSide, shopId, dispenserIndex, dispenserData)
                    break

                    ::continue_dispenser::
                end
            end
        end
    end
end

if Config.TargetZoneType == 0 then
    RegisterKey(pickupdispendergun, "pickupdispendergun",
        (Config.KeyMaps and Config.KeyMaps[KeyAction.PICKUP_NOZZLE] and Config.KeyMaps[KeyAction.PICKUP_NOZZLE].label) or "Pickup nozzle",
        (Config.KeyMaps and Config.KeyMaps[KeyAction.PICKUP_NOZZLE] and Config.KeyMaps[KeyAction.PICKUP_NOZZLE].action) or "e"
    )
else
    CreateThread(function()
        for modelHash, _ in pairs(GetAllWorkingDispenserModels()) do
            CreateTargetModel(modelHash, {
                {
                    distance = 1.5,
                    num = 1,
                    type = "client",
                    event = "rcore_fuel:pickUpDispenserGun",
                    icon = _U("target_pump_icon"),
                    label = _U("target_pump_label"),
                    targeticon = _U("target_pump_targeticon"),
                    canInteract = function()
                        return true
                    end,
                    drawColor = { 255, 255, 255, 255 },
                    successDrawColor = { 30, 144, 255, 255 },
                    eventAction = "open_pump",
                },
            })
        end

        AddEventHandler("rcore_fuel:pickUpDispenserGun", function()
            pickupdispendergun()
        end)
    end, "creating target system models")
end

RegisterKey(SelectedVehicleAndStartFueling, "selectvehicletotankrcorefuel",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.REFUEL_VEHICLE] and Config.KeyMaps[KeyAction.REFUEL_VEHICLE].label) or "Refuel vehicle",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.REFUEL_VEHICLE] and Config.KeyMaps[KeyAction.REFUEL_VEHICLE].action) or "MOUSE_LEFT",
    "MOUSE_BUTTON"
)

RegisterNetEvent("baseevents:enteringVehicle", function()
    if DoesEntityExist(GetEntityDispenserGun()) then
        ClearPedTasksImmediately(PlayerPedId())
    end
end)

RegisterNetEvent("rcore_fuel:playerIsTryingToEnterVehicle", function()
    if DoesEntityExist(GetEntityDispenserGun()) then
        ClearPedTasksImmediately(PlayerPedId())
    end
end)

local function DestroyPumpSound(sound)
    if not sound then return end
    pcall(function() sound.FadeOut(250) end)
    pcall(function() sound.Destroy() end)
end

function StartPumpElectricSound(pumpPosition, sideId)
    local soundEntry = pumpPosition.soundPlayerPump[sideId]
    if soundEntry.eleSound then
        DestroyPumpSound(soundEntry.eleSound)
        soundEntry.eleSound = nil
    end
    soundEntry.eleSound = CreateSoundHandler("ele_" .. sideId)
    soundEntry.eleSound.LoadSound(SoundEffect.FUEL_PUMP_SOUND_ELE_LOOP)
    soundEntry.eleSound.SetPlayingPosition(pumpPosition.pos)
    soundEntry.eleSound.SetVolume(Config.ElectricHummingVolume or 0.75)
    soundEntry.eleSound.SetLoop(true)
    soundEntry.eleSound.SetAutoPlay(true)
    soundEntry.eleSound.CreateMedia()
end

function StartPumpLiquidSound(pumpPosition, sideId, liquidPosition)
    local soundEntry = pumpPosition.soundPlayerPump[sideId]
    if soundEntry.liquidSound then
        DestroyPumpSound(soundEntry.liquidSound)
        soundEntry.liquidSound = nil
    end
    soundEntry.liquidSound = CreateSoundHandler("liquid_" .. sideId)
    soundEntry.liquidSound.LoadSound(SoundEffect.LIQUID_POURING_LOOP)
    soundEntry.liquidSound.SetPlayingPosition(liquidPosition)
    soundEntry.liquidSound.SetPlayingDistance(3.0)
    soundEntry.liquidSound.SetVolume(Config.LiquidVolume or 1.0)
    soundEntry.liquidSound.SetLoop(true)
    soundEntry.liquidSound.SetAutoPlay(true)
    soundEntry.liquidSound.CreateMedia()
end

function StopPumpSoundEntry(soundEntry, pumpFuelType)
    -- Stop whatever is actually attached to the entry instead of deciding from the
    -- *current* fuel type. This also cleans up correctly after state/type changes.
    if soundEntry.eleSound then
        local sound = soundEntry.eleSound
        soundEntry.eleSound = nil
        CreateThread(function()
            DestroyPumpSound(sound)
        end, "killing elesound 2")
    end

    if soundEntry.liquidSound then
        local sound = soundEntry.liquidSound
        soundEntry.liquidSound = nil
        CreateThread(function()
            DestroyPumpSound(sound)
        end, "killing liquid sound 2")
    end
end

RegisterNetEvent("rcore_fuel:syncSoundPump", function(isPlaying, shopId, dispenserIndex, sideId, liquidPosition)
    local shop = Config.ShopList and Config.ShopList[shopId]
    if not shop or not shop.pumpPosition or not shop.pumpPosition[dispenserIndex] or not sideId then
        return
    end
    local pumpPosition = shop.pumpPosition[dispenserIndex]

    if isPlaying then
        if not pumpPosition.soundPlayerPump then
            pumpPosition.soundPlayerPump = {}
        end

        if not pumpPosition.soundPlayerPump[sideId] then
            pumpPosition.soundPlayerPump[sideId] = {}
        end

        StartPumpElectricSound(pumpPosition, sideId)

        if not Config.NonLiquidFueLTypes[pumpPosition.fuelType] then
            StartPumpLiquidSound(pumpPosition, sideId, liquidPosition)
        end
    else
        if not pumpPosition.soundPlayerPump then
            pumpPosition.soundPlayerPump = {}
        end

        local soundEntry = pumpPosition.soundPlayerPump[sideId]

        if soundEntry then
            StopPumpSoundEntry(soundEntry, pumpPosition.fuelType)
            pumpPosition.soundPlayerPump[sideId] = nil
        end
    end
end)

RegisterNetEvent("rcore_fuel:stopPlayerFuelingAnim", function()
    StopFueling()
end)

RegisterNetEvent("rcore_fuel:resetFuelPumpVariables", function()
    ResetFuelingVariables()
end)
