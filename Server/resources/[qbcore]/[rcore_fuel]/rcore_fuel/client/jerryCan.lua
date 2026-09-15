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

isJerryCanRefuelingActive = false
local jerryRefuelingGeneration = 0

local function StopJerryCanRefueling()
    if isJerryCanRefuelingActive and IsPlayerWalkingToCoordinates() then
        CancelWalkToCoordinates()
        ClearPedTasks(PlayerPedId())
    end
    jerryRefuelingGeneration = jerryRefuelingGeneration + 1
    isJerryCanRefuelingActive = false
    Animation.ResetAll()
end
jerryCanMaxAmmo = 4500
coreInventoryWeaponId = nil
coreInventoryWeaponData = {}
activeJerryCanSlotId = -1
jerryCanVehicleSearchRadius = 2.0

local function GetSafeJerryCanLitersSize()
    local size = tonumber(Config.JerryCanLitersSize) or 20
    if size <= 0 or size ~= size or size == math.huge or size == -math.huge then
        return 20
    end
    return size
end

local function IsPetrolCanWeaponName(name)
    name = tostring(name or "")
    return string.upper(name) == "WEAPON_PETROLCAN" or string.lower(name) == "weapon_petrolcan"
end

function IsPlayerHoldingJerryCan()
    local _, weaponHash = GetCurrentPedWeapon(PlayerPedId())
    return weaponHash == GetHashKey("weapon_petrolcan")
end

-- OX/CORE expose stable server-verifiable item identifiers. Passing them with
-- jerry-can operations lets the server bind each paid liter to one real can.
function GetJerryCanServerItemIdentifiers()
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.OX then
        local ok, currentWeapon = pcall(function() return exports.ox_inventory:getCurrentWeapon() end)
        if ok and currentWeapon and currentWeapon.slot
            and IsPetrolCanWeaponName(currentWeapon.name) then
            return currentWeapon.slot, currentWeapon.slot
        end

        -- Fallback if getCurrentWeapon is delayed or weapon is held via native
        if IsPlayerHoldingJerryCan() then
            local searchOk, slots = pcall(function() return exports.ox_inventory:Search('slots', 'WEAPON_PETROLCAN') end)
            if searchOk and type(slots) == "table" and #slots > 0 and slots[1] and slots[1].slot then
                return slots[1].slot, slots[1].slot
            end
        end
    elseif invSystem == Inventory.CORE then
        local itemId = coreInventoryWeaponData and coreInventoryWeaponData.id or nil
        return coreInventoryWeaponId, itemId
    end

    return nil, nil
end

function GetCurrentJerryCanPercentage()
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.TGIANN then
        for slotId, itemData in pairs(exports[InventoryResourceNames[Inventory.TGIANN]]:GetPlayerItems()) do
            if tonumber(slotId) == activeJerryCanSlotId then
                return itemData.info.ammo
            end
        end
        return 100
    end

    if invSystem == Inventory.CODEM then
        for slotId, itemData in pairs(exports[InventoryResourceNames[Inventory.CODEM]]:GetClientPlayerInventory()) do
            if tonumber(slotId) == activeJerryCanSlotId then
                return itemData.info.ammo
            end
        end
        return 100
    end

    if invSystem == Inventory.OX then
        local ok, currentWeapon = pcall(function() return exports.ox_inventory:getCurrentWeapon() end)
        if (not ok or not currentWeapon or not IsPetrolCanWeaponName(currentWeapon.name)) and IsPlayerHoldingJerryCan() then
            local searchOk, slots = pcall(function() return exports.ox_inventory:Search('slots', 'WEAPON_PETROLCAN') end)
            if searchOk and type(slots) == "table" and #slots > 0 and slots[1] then
                currentWeapon = slots[1]
                ok = true
            end
        end

        if ok and currentWeapon and IsPetrolCanWeaponName(currentWeapon.name) then
            local ammo = currentWeapon.metadata and tonumber(currentWeapon.metadata.ammo)
            local durability = currentWeapon.metadata and tonumber(currentWeapon.metadata.durability)

            -- In ox_inventory, petrol cans store fuel as a percentage (0..100) in
            -- metadata.ammo and metadata.durability. If an older script wrote GTA native
            -- ammo units (> 100 up to 4500), normalize down to 0..100.
            if ammo ~= nil and ammo > 100 then
                ammo = math.max(0, math.min(100, math.floor((ammo / jerryCanMaxAmmo) * 100)))
            end
            if durability ~= nil and durability > 100 then
                durability = math.max(0, math.min(100, math.floor(durability)))
            end

            -- If neither field exists on a freshly acquired can, initialize to 100% full
            if ammo == nil and durability == nil then
                return (Config.JerryCanStartsFull ~= false) and 100 or 0
            end

            -- When both fields exist: if one is 0 and the other is > 0 (e.g. ammo = 0, durability = 100),
            -- ox_inventory weapons without clip ammo often have ammo defaulted to 0 on give while
            -- durability represents the true condition/fuel level. Respect the positive value.
            if ammo ~= nil and durability ~= nil then
                if ammo > 0 and durability > 0 then
                    return math.max(0, math.min(100, math.floor(math.min(ammo, durability))))
                else
                    return math.max(0, math.min(100, math.floor(math.max(ammo, durability))))
                end
            end

            if ammo ~= nil then
                return math.max(0, math.min(100, math.floor(ammo)))
            end

            if durability ~= nil then
                return math.max(0, math.min(100, math.floor(durability)))
            end
        end

        -- If holding can but metadata is entirely empty, treat as fresh full can
        if IsPlayerHoldingJerryCan() then
            return (Config.JerryCanStartsFull ~= false) and 100 or 0
        end

        return 0
    end

    if Config.InventorySystem == Inventory.CORE then
        if coreInventoryWeaponData and coreInventoryWeaponData.metadata and coreInventoryWeaponData.metadata.durability then
            local ammo = coreInventoryWeaponData.metadata.ammo or 0
            return math.floor((ammo / jerryCanMaxAmmo) * 100)
        end
        return 0
    end

    if Config.InventorySystem == Inventory.QS then
        local inventory = exports[InventoryResourceNames[Inventory.QS]]:getUserInventory()
        local slotItem = inventory[activeJerryCanSlotId]
        if slotItem then
            return slotItem.info.quality
        end
        return 100
    end

    if Config.InventorySystem == Inventory.ORIGEN then
        if SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData then
            local playerData = SharedObject.Functions.GetPlayerData()
            local playerItems = playerData and playerData.items
            local slotItem = playerItems and playerItems[activeJerryCanSlotId]
            if slotItem and slotItem.metadata then
                return slotItem.metadata.quality or 0
            end
        end
        return 100
    end

    if Config.InventorySystem == Inventory.JAKSAM then
        local inventory = exports[InventoryResourceNames[Inventory.JAKSAM]]:getInventory()
        if inventory then
            local items = inventory.items or {}
            local slotKey = "SLOT-" .. activeJerryCanSlotId
            local slotItem = items[slotKey]
            if slotItem then
                if slotItem.metadata and slotItem.metadata.ammo then
                    return slotItem.metadata.ammo
                end
                return 100
            end
        end
        return 100
    end

    local qbStyleInventories = {}
    qbStyleInventories[Inventory.QB] = true
    qbStyleInventories[Inventory.LJ] = true
    qbStyleInventories[Inventory.PS] = true

    if qbStyleInventories[Config.InventorySystem] then
        if SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData then
            local playerData = SharedObject.Functions.GetPlayerData()
            local playerItems = playerData and playerData.items
            local slotItem = playerItems and playerItems[activeJerryCanSlotId]
            if slotItem and slotItem.info then
                return slotItem.info.quality or 100
            end
        end
        return 100
    end

    local playerPed = PlayerPedId()
    local petrolCanHash = GetHashKey("weapon_petrolcan")
    local _, maxAmmo = GetMaxAmmo(playerPed, petrolCanHash)
    -- FIX 7: guard division by zero when maxAmmo is 0 (weapon not equipped/registered)
    if not maxAmmo or maxAmmo == 0 then return 0 end
    local currentAmmo = GetAmmoInPedWeapon(playerPed, petrolCanHash)
    return (currentAmmo / maxAmmo) * 100
end

function IsJerryCanEmpty()
    return GetCurrentJerryCanPercentage() <= 0
end

function IsJerryCanFull()
    return GetCurrentJerryCanPercentage() >= 100
end

function AddLiterToJerryCan()
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.CORE then
        if not (coreInventoryWeaponData and coreInventoryWeaponData.metadata and coreInventoryWeaponData.metadata.ammo) then
            return
        end

        local ammoPerLiter = jerryCanMaxAmmo / GetSafeJerryCanLitersSize()
        local newAmmo = math.floor(coreInventoryWeaponData.metadata.ammo + ammoPerLiter)

        if newAmmo > jerryCanMaxAmmo then
            coreInventoryWeaponData.metadata.ammo = jerryCanMaxAmmo
        else
            coreInventoryWeaponData.metadata.ammo = newAmmo
        end

        TriggerServerEvent("rcore_fuel:updateMetaData", coreInventoryWeaponId, coreInventoryWeaponData.id, coreInventoryWeaponData.metadata)
        return
    end

    if invSystem == Inventory.JAKSAM then
        return
    end

    if invSystem == Inventory.TGIANN then
        return
    end

    if invSystem == Inventory.CODEM then
        return
    end

    if invSystem == Inventory.OX then
        local ok, currentWeapon = pcall(function() return exports.ox_inventory:getCurrentWeapon() end)
        if (not ok or not currentWeapon or not IsPetrolCanWeaponName(currentWeapon.name)) and IsPlayerHoldingJerryCan() then
            local searchOk, slots = pcall(function() return exports.ox_inventory:Search('slots', 'WEAPON_PETROLCAN') end)
            if searchOk and type(slots) == "table" and #slots > 0 and slots[1] then
                currentWeapon = slots[1]
                ok = true
            end
        end

        if ok and currentWeapon and IsPetrolCanWeaponName(currentWeapon.name) then
            local percentPerLiter = 100 / GetSafeJerryCanLitersSize()
            local currentPercent = GetCurrentJerryCanPercentage()
            local newPercent = math.min(100, math.floor(currentPercent + percentPerLiter))
            local weaponSlot = currentWeapon.slot

            -- Update GTA native ped ammo to match percentage (0..4500) for visual weapon HUD
            SetPedAmmo(PlayerPedId(), GetHashKey("weapon_petrolcan"), math.floor((newPercent / 100) * 4500))

            if weaponSlot then
                TriggerServerEvent("rcore_fuel:updateMetaData", weaponSlot, weaponSlot, {
                    ammo = newPercent,
                    durability = newPercent,
                })
            end
            return
        end
    end

    if invSystem == Inventory.QB or invSystem == Inventory.QS then
        return
    end

    local playerPed = PlayerPedId()
    local petrolCanHash = GetHashKey("weapon_petrolcan")
    local _, maxAmmo = GetMaxAmmo(playerPed, petrolCanHash)
    -- FIX 7: guard against zero maxAmmo
    if not maxAmmo or maxAmmo == 0 then return end
    local ammoPerLiter = maxAmmo / GetSafeJerryCanLitersSize()
    SetPedAmmo(playerPed, petrolCanHash, math.floor(GetAmmoInPedWeapon(playerPed, petrolCanHash) + ammoPerLiter))
end

function RemoveLiterFromJerryCan()
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.CORE then
        if not (coreInventoryWeaponData and coreInventoryWeaponData.metadata and coreInventoryWeaponData.metadata.ammo) then
            return
        end

        local ammoPerLiter = jerryCanMaxAmmo / GetSafeJerryCanLitersSize()
        local newAmmo = math.floor(coreInventoryWeaponData.metadata.ammo - ammoPerLiter)

        if newAmmo < 0 then
            coreInventoryWeaponData.metadata.ammo = 0
        else
            coreInventoryWeaponData.metadata.ammo = newAmmo
        end

        TriggerServerEvent("rcore_fuel:updateMetaData", coreInventoryWeaponId, coreInventoryWeaponData.id, coreInventoryWeaponData.metadata)
        return
    end

    if invSystem == Inventory.OX then
        local ok, currentWeapon = pcall(function() return exports.ox_inventory:getCurrentWeapon() end)
        if (not ok or not currentWeapon or not IsPetrolCanWeaponName(currentWeapon.name)) and IsPlayerHoldingJerryCan() then
            local searchOk, slots = pcall(function() return exports.ox_inventory:Search('slots', 'WEAPON_PETROLCAN') end)
            if searchOk and type(slots) == "table" and #slots > 0 and slots[1] then
                currentWeapon = slots[1]
                ok = true
            end
        end

        if ok and currentWeapon and IsPetrolCanWeaponName(currentWeapon.name) then
            local percentPerLiter = 100 / GetSafeJerryCanLitersSize()
            local currentPercent = GetCurrentJerryCanPercentage()
            local newPercent = math.max(0, math.floor(currentPercent - percentPerLiter))
            local weaponSlot = currentWeapon.slot

            -- Update GTA native ped ammo to match percentage (0..4500) for visual weapon HUD
            SetPedAmmo(PlayerPedId(), GetHashKey("weapon_petrolcan"), math.floor((newPercent / 100) * 4500))

            if weaponSlot then
                TriggerServerEvent("rcore_fuel:updateMetaData", weaponSlot, weaponSlot, {
                    ammo = newPercent,
                    durability = newPercent,
                })
            end
            return
        end
    end

    if invSystem == Inventory.JAKSAM then
        return
    end

    if invSystem == Inventory.CODEM then
        return
    end

    if invSystem == Inventory.QB or invSystem == Inventory.QS then
        return
    end

    local playerPed = PlayerPedId()
    local petrolCanHash = GetHashKey("weapon_petrolcan")
    local _, maxAmmo = GetMaxAmmo(playerPed, petrolCanHash)
    -- FIX 7: guard against zero maxAmmo
    if not maxAmmo or maxAmmo == 0 then return end
    local ammoPerLiter = maxAmmo / GetSafeJerryCanLitersSize()
    SetPedAmmo(playerPed, petrolCanHash, math.floor(GetAmmoInPedWeapon(playerPed, petrolCanHash) - ammoPerLiter))
end

local function IsJerryCanRefuelingAllowed(fuelType)
    if not Config.JerrycanRefuelingAllowedForSpecificTypes then return true end
    for k, v in pairs(Config.JerrycanRefuelingAllowedForSpecificTypes) do
        if v == fuelType or k == fuelType then
            return true
        end
    end
    return false
end

function PlaySingleOurEffect()
    local soundHandler = CreateSoundHandler()
    if not soundHandler then return end
    soundHandler.LoadSound(SoundEffect.SINGLE_POUR)
    soundHandler.SetPlayingPosition(GetEntityCoords(PlayerPedId()))
    soundHandler.SetPlayingDistance(3.0)
    soundHandler.SetLoop(false)
    soundHandler.SetVolume(Config.LiquidVolume or 1.0)
    soundHandler.SetAutoPlay(true)
    soundHandler.CreateMedia()
end

CreateThread(function()
    local outlinedVehicle = nil
    local jerryCanGuideShown = false

    while true do
        Wait(1000)

        if IsPlayerHoldingJerryCan() then
            if not jerryCanGuideShown then
                ShowHelpNotification(_U("jerrycan_guide"), false, true, 10000)
                jerryCanGuideShown = true
            end
        else
            jerryCanGuideShown = false
        end

        if outlinedVehicle ~= nil then
            if DoesEntityExist(outlinedVehicle) then
                SetEntityDrawOutline(outlinedVehicle, false)
            end
            outlinedVehicle = nil
        end

        if not IsPlayerInVehicle() and IsPlayerHoldingJerryCan() and not isJerryCanRefuelingActive then
            local playerPed = PlayerPedId()
            local nearbyVehicle = GetClosestVehicleInArea(GetEntityCoords(playerPed), jerryCanVehicleSearchRadius)
            local canRefuelType = false
            if nearbyVehicle and nearbyVehicle ~= 0 and DoesEntityExist(nearbyVehicle) then
                local vehicleFuelType = GetVehicleFuelType(GetEntityModel(nearbyVehicle))
                canRefuelType = IsJerryCanRefuelingAllowed(vehicleFuelType)
            end

            if nearbyVehicle and nearbyVehicle ~= 0 and DoesEntityExist(nearbyVehicle)
                and canRefuelType and IsVehicleModelEnabledForFueling(nearbyVehicle) then
                SetEntityDrawOutline(nearbyVehicle, true)
                local outlineColor = Config.ColorTarget or { r = 255, g = 255, b = 255, a = 255 }
                SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
                SetEntityDrawOutlineShader(1)
                outlinedVehicle = nearbyVehicle
            end
        end
    end
end, "make vehicle glow")

RegisterKey(function()
    if isJerryCanRefuelingActive then
        StopJerryCanRefueling()
        return
    end

    if IsPlayerInVehicle() or IsPlayerHoldingDispenserGun() or IsPlayerWalkingToCoordinates() then
        return
    end

    local playerPed = PlayerPedId()
    local nearbyVehicle = GetClosestVehicleInArea(GetEntityCoords(playerPed), jerryCanVehicleSearchRadius)

    if IsPlayerHoldingJerryCan() and nearbyVehicle then
        local vehicleFuelType = GetVehicleFuelType(GetEntityModel(nearbyVehicle))
        local canRefuelType = IsJerryCanRefuelingAllowed(vehicleFuelType)

        if not (canRefuelType and IsVehicleModelEnabledForFueling(nearbyVehicle)) then
            ShowNotification(_U("cannot_refuel_from_jerrycan"))
            return
        end

        if IsJerryCanEmpty() then
            ShowNotification(_U("jerry_can_empty") or "Your jerry can is empty.")
            return
        end

        if IsVehicleFull(nearbyVehicle) then
            ShowNotification(_U("vehicle_is_full") or "The vehicle is already full.")
            return
        end

        isJerryCanRefuelingActive = true
        jerryRefuelingGeneration = jerryRefuelingGeneration + 1
        local generation = jerryRefuelingGeneration

        local fuelPosition, targetHeading = GetVehicleFuelingPosition(nearbyVehicle)
        local vehicleStart = GetEntityCoords(nearbyVehicle)
        local function canContinue()
            return isJerryCanRefuelingActive and generation == jerryRefuelingGeneration
                and PlayerPedId() == playerPed and DoesEntityExist(nearbyVehicle)
                and not IsEntityDead(playerPed) and not IsPedRagdoll(playerPed)
                and not IsPedInAnyVehicle(playerPed, false) and IsPlayerHoldingJerryCan()
                and #(GetEntityCoords(nearbyVehicle) - vehicleStart) < 0.75
        end
        if not GoToCoordsWithHeadingInTime(playerPed, fuelPosition, targetHeading, 1500, canContinue)
            or not canContinue() then
            if generation == jerryRefuelingGeneration then StopJerryCanRefueling() end
            return
        end

        if not Animation.Play("jerrycan") or generation ~= jerryRefuelingGeneration then
            if generation == jerryRefuelingGeneration then StopJerryCanRefueling() end
            return
        end
        ShowHelpNotification("Press ~INPUT_CONTEXT~ or ~INPUT_VEH_DUCK~ to stop refueling.", false, true, 10000)

        -- Active cancel control monitor: allows immediate cancellation with E, X, Backspace, or Esc
        CreateThread(function()
            while isJerryCanRefuelingActive and generation == jerryRefuelingGeneration do
                Wait(0)
                if not isJerryCanRefuelingActive or generation ~= jerryRefuelingGeneration then return end
                DisableJerryCanFuelingControls()
                -- 38 = E (INPUT_PICKUP / INPUT_CONTEXT)
                -- 73 = X (INPUT_VEH_DUCK)
                -- 177 = Backspace (INPUT_CELLPHONE_CANCEL)
                -- 200 = Esc / Pause (INPUT_FRONTEND_PAUSE_ALTERNATE)
                -- The registered refuel key handles toggling. Processing E here
                -- as well can stop a newly started session on the same keypress.
                if IsControlJustPressed(0, 73) or IsControlJustPressed(0, 177) or IsControlJustPressed(0, 200) then
                    StopJerryCanRefueling()
                    break
                end
            end
        end, "jerry can cancel monitor")

        CreateThread(function()
            while isJerryCanRefuelingActive and generation == jerryRefuelingGeneration do
                Wait(1500)
                if not isJerryCanRefuelingActive or generation ~= jerryRefuelingGeneration then return end

                local ped = PlayerPedId()
                local targetValid = canContinue()
                    and #(GetEntityCoords(ped) - fuelPosition) < 1.5
                    and not IsPlayerInVehicle()
                    and not IsPedRagdoll(ped)
                    and not IsEntityDead(ped)
                    and #(GetEntityCoords(ped) - GetEntityCoords(nearbyVehicle)) <= (jerryCanVehicleSearchRadius + 2.0)

                if targetValid and not IsJerryCanEmpty() and IsPlayerHoldingJerryCan() and not IsVehicleFull(nearbyVehicle) then
                    -- Consumption now happens only after the server validates the
                    -- vehicle/proximity/rate limit and sends addFuelFromJerry back.
                    local jerryWeaponId, jerryItemId = GetJerryCanServerItemIdentifiers()
                    TriggerServerEvent("rcore_fuel:addFuelFromJerry", VehToNet(nearbyVehicle), jerryWeaponId, jerryItemId)
                else
                    StopJerryCanRefueling()
                    return
                end
            end
        end, "fueling with jerry can")
    end
end, "fuelvehiclejerry",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.JERRYCAN] and Config.KeyMaps[KeyAction.JERRYCAN].label) or "Jerry Can Refuel",
    (Config.KeyMaps and Config.KeyMaps[KeyAction.JERRYCAN] and Config.KeyMaps[KeyAction.JERRYCAN].action) or "e"
)

RegisterNetEvent("rcore_fuel:stopJerryRefueling", function(reason)
    StopJerryCanRefueling()
    if reason then
        ShowNotification(reason)
    end
end)

RegisterNetEvent("rcore_fuel:consumeJerryLiter", function()
    -- OX/CORE transactional path: consume the can first. The server grants the
    -- vehicle liter only after the authoritative metadata write acknowledges.
    if source ~= 65535 then return end
    if IsPlayerHoldingJerryCan() and not IsJerryCanEmpty() then
        RemoveLiterFromJerryCan()
    else
        isJerryCanRefuelingActive = false
        Animation.ResetAll()
    end
end)

RegisterNetEvent("rcore_fuel:addFuelFromJerry", function(vehicleNetId, litersToGrant)
    -- Server-authoritative delivery only; reject local TriggerEvent spoofing.
    if source ~= 65535 then return end

    -- OX/CORE can end with less than one whole liter remaining. The authoritative
    -- server transaction debits exactly that remainder, so grant only the matching
    -- fraction instead of turning a tiny metadata remainder into a full vehicle liter.
    local liters = tonumber(litersToGrant) or 1.0
    if liters ~= liters or liters == math.huge or liters == -math.huge then return end
    liters = math.max(0.0, math.min(1.0, liters))
    if liters <= 0.0 then return end

    local vehicleEntity = NetToVeh(vehicleNetId)
    if vehicleEntity and vehicleEntity ~= 0 and DoesEntityExist(vehicleEntity)
        and IsPlayerHoldingJerryCan() then
        PlaySingleOurEffect()
        if Config.InventorySystem ~= Inventory.OX and Config.InventorySystem ~= Inventory.CORE then
            RemoveLiterFromJerryCan()
        end
        AddVehicleFuelLiter(vehicleEntity, liters)
        if IsVehicleFull(vehicleEntity) or IsJerryCanEmpty() then
            isJerryCanRefuelingActive = false
            Animation.ResetAll()
        end
    end
end)

local inventoryWeaponSlotSystems = {}
inventoryWeaponSlotSystems[Inventory.QB] = true
inventoryWeaponSlotSystems[Inventory.QS] = true
inventoryWeaponSlotSystems[Inventory.LJ] = true
inventoryWeaponSlotSystems[Inventory.PS] = true
inventoryWeaponSlotSystems[Inventory.TGIANN] = true
inventoryWeaponSlotSystems[Inventory.ORIGEN] = true

if inventoryWeaponSlotSystems[Config.InventorySystem] then
    function SetActiveWeaponSlot(weaponItem)
        if weaponItem and weaponItem.info and weaponItem.name == "weapon_petrolcan" then
            activeJerryCanSlotId = tonumber(weaponItem.slot)

            if Config.InventorySystem == Inventory.TGIANN then
                TriggerServerEvent("rcore_fuel:setActiveSlotId", activeJerryCanSlotId)
            end
        end
    end

    RegisterNetEvent("inventory:client:UseWeapon", function(weaponItem, ammo)
        SetActiveWeaponSlot(weaponItem)
    end)

    RegisterNetEvent("ps-inventory:client:UseWeapon", function(weaponItem, ammo)
        SetActiveWeaponSlot(weaponItem)
    end)
end

RegisterNetEvent("codem-inventory:client:UseWeapon", function(weaponItem, ammo, slot)
    if weaponItem and type(weaponItem) == "table" and weaponItem.name then
        if string.lower(weaponItem.name) == "weapon_petrolcan" then
            activeJerryCanSlotId = tonumber(weaponItem.slot)
            TriggerServerEvent("rcore_fuel:setActiveSlotId", activeJerryCanSlotId)
        end
    end
end)

RegisterNetEvent("core_inventory:client:handleWeapon", function(weaponName, weaponData, weaponId)
    if weaponName and string.lower(weaponName) == "weapon_petrolcan" then
        coreInventoryWeaponId = weaponId
        coreInventoryWeaponData = weaponData
    end
end)

RegisterNetEvent("jaksam_inventory:currentWeaponChanged", function(weaponName, weaponData, slotId)
    activeJerryCanSlotId = slotId
    TriggerServerEvent("rcore_fuel:setActiveSlotId", slotId)
end)

RegisterNetEvent("rcore_fuel:setPlayerActiveSlotNumber", function(slotId)
    activeJerryCanSlotId = slotId
end)

local origenInventorySystems = {}
origenInventorySystems[Inventory.ORIGEN] = true

if origenInventorySystems[Config.InventorySystem] or Config.EnableInventoryKeyBinds then
    local inventoryHotkeyBindings = {
        { key = "1", keyIndex = 1 },
        { key = "2", keyIndex = 2 },
        { key = "3", keyIndex = 3 },
        { key = "4", keyIndex = 4 },
        { key = "5", keyIndex = 5 },
        { key = "6", keyIndex = 6 },
        { key = "7", keyIndex = 7 },
        { key = "8", keyIndex = 8 },
        { key = "9", keyIndex = 9 },
        { key = "0", keyIndex = 0 },
    }

    for _, hotkeyBinding in pairs(inventoryHotkeyBindings) do
        RegisterCommand("@rcore_fuel_custom_" .. hotkeyBinding.key, function()
            activeJerryCanSlotId = hotkeyBinding.keyIndex
            TriggerServerEvent("rcore_fuel:setActiveSlotId", hotkeyBinding.keyIndex)
        end, false)

        RegisterKeyMapping(
            "@rcore_fuel_custom_" .. hotkeyBinding.key,
            "rcore_fuel inventory keybind do not change",
            "keyboard",
            hotkeyBinding.key
        )
    end
end

-- Keep GTA V's native ped ammo pool (0..4500) synchronized with jerry can fuel percentage
-- so the GTA V weapon HUD never shows "0 ammo" on a newly acquired or non-empty can.
AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    if currentWeapon and IsPetrolCanWeaponName(currentWeapon.name) then
        local ped = PlayerPedId()
        local petrolCanHash = GetHashKey("weapon_petrolcan")
        local percent = GetCurrentJerryCanPercentage()
        local targetAmmo = math.max(0, math.min(4500, math.floor((percent / 100) * 4500)))
        SetPedAmmo(ped, petrolCanHash, targetAmmo)
    end
end)

CreateThread(function()
    local petrolCanHash = GetHashKey("weapon_petrolcan")
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local _, curWeapon = GetCurrentPedWeapon(ped)
        if curWeapon == petrolCanHash then
            local percent = GetCurrentJerryCanPercentage()
            local targetAmmo = math.max(0, math.min(4500, math.floor((percent / 100) * 4500)))
            local currentPedAmmo = GetAmmoInPedWeapon(ped, petrolCanHash)
            if math.abs(currentPedAmmo - targetAmmo) > 25 then
                SetPedAmmo(ped, petrolCanHash, targetAmmo)
            end
        end
    end
end)
