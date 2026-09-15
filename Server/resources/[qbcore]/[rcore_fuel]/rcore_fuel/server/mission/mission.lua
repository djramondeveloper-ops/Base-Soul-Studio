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

PendingFuelMissions = PendingFuelMissions or {}

local recentlyResetVehicles = {}
local activePumpOutOperations = {}
local missionFuelPipeOwner = nil
local barrelLocationOwners = {}

local function RequiredProcessedBarrels()
    local count = 0
    for _ in pairs(Config.AttachableBonesTipTruck or {}) do count = count + 1 end
    return math.max(1, count)
end

local function PlayerNearMissionPosition(src, position, distance)
    if not position then return false end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - position) <= (distance or 15.0)
end

local function MissionWorkerMatchesSource(mission, src)
    if not mission or tonumber(mission.workerSource) ~= tonumber(src) then return false end
    if not mission.workerIdentifier then return true end
    return Framework.GetPlayerIdentifier(src) == mission.workerIdentifier
end

local function MissionOwnerMatchesSource(mission, src)
    if not mission or tonumber(mission.ownerSource) ~= tonumber(src) then return false end
    if not mission.ownerIdentifier then return true end
    return Framework.GetPlayerIdentifier(src) == mission.ownerIdentifier
end

local function ReleaseMissionInteractionLocks(src)
    local _, mission = FindPendingFuelMissionByWorker(src)

    if tonumber(missionFuelPipeOwner) == tonumber(src) then
        missionFuelPipeOwner = nil
        TriggerClientEvent("rcore_fuel:missionFuelpipe:setStatus", -1, false)
    end
    for locationIndex, owner in pairs(barrelLocationOwners) do
        if tonumber(owner) == tonumber(src) then
            barrelLocationOwners[locationIndex] = nil
            if mission and mission.barrelProcessingStartedAt then
                mission.barrelProcessingStartedAt[locationIndex] = nil
            end
            TriggerClientEvent("rcore_fuel:processBarrelLocation:setStatus", -1, locationIndex, false)
        end
    end

    if mission then
        mission.activeBarrelLocation = nil
    end
end

local function ClearMissionForWorker(src, explicitMissionId)
    local missionId = explicitMissionId
    local activeDriver = GetActiveDriver(src)
    if not missionId and activeDriver then
        missionId = activeDriver.missionId
    end
    if not missionId then
        missionId = select(1, FindPendingFuelMissionByWorker(src))
    end

    local mission = missionId and GetPendingFuelMission(missionId) or nil
    local sameWorker = not mission or MissionWorkerMatchesSource(mission, src)
    if sameWorker then
        ReleaseMissionInteractionLocks(src)
        UnregisterDriver(src)
    end
    if missionId then
        return ClearPendingFuelMission(missionId)
    end
    return nil
end

local function NotifyMissionOwner(mission, message)
    if not mission or not mission.ownerSource then return end
    local ownerSource = tonumber(mission.ownerSource)
    if ownerSource and GetPlayerName(ownerSource) and MissionOwnerMatchesSource(mission, ownerSource) then
        Framework.ShowNotification(ownerSource, message)
    end
end

RegisterNetEvent("rcore_fuel:acceptedRefuelMission", function(missionId)
    local src = source
    local mission = GetPendingFuelMission(missionId)

    -- Only a player who was actually invited by an owner can start a mission.
    -- Previously any client could invent a mission id and immediately farm the payout.
    if not mission or not MissionWorkerMatchesSource(mission, src) or mission.accepted then
        return
    end
    -- Enforce invitation expiry at acceptance time, not only in the 30-second sweeper.
    -- Otherwise a stale invitation can still be accepted after its nominal 5-minute TTL
    -- during the window before the next cleanup tick.
    if mission.createdAt and os.time() - mission.createdAt >= 300 then
        NotifyMissionOwner(mission, "The fuel-delivery invitation expired without a response.")
        ClearPendingFuelMission(missionId)
        return
    end

    if RegisterDriver(src, missionId, mission.shopId) ~= true then return end
    mission.accepted = true
    TriggerClientEvent("rcore_fuel:startFuelMission", src, missionId)
    NotifyMissionOwner(mission, string.format("%s accepted the fuel delivery mission.", GetPlayerName(src) or "The worker"))
end)

RegisterNetEvent("rcore_fuel:playerRefusedMission", function(missionId)
    local src = source
    local mission = GetPendingFuelMission(missionId)
    if not mission or not MissionWorkerMatchesSource(mission, src) then return end

    NotifyMissionOwner(mission, string.format("%s refused the fuel delivery mission.", GetPlayerName(src) or "The worker"))
    ClearMissionForWorker(src, missionId)
end)

RegisterNetEvent("rcore_fuel:playerCancelMission", function()
    local src = source
    local mission = ClearMissionForWorker(src)
    if mission then
        NotifyMissionOwner(mission, string.format("%s cancelled the fuel delivery mission.", GetPlayerName(src) or "The worker"))
    end
end)

RegisterNetEvent("rcore_fuel:finishTheMission", function()
    local src = source
    local activeDriver = GetActiveDriver(src)
    if not activeDriver or not activeDriver.missionId then return end

    local mission = GetPendingFuelMission(activeDriver.missionId)
    if not mission or not mission.accepted or not MissionWorkerMatchesSource(mission, src) then
        UnregisterDriver(src)
        return
    end

    local shopData = Config.ShopList and Config.ShopList[mission.shopId]
    if not shopData then
        ClearMissionForWorker(src, activeDriver.missionId)
        return
    end

    -- Completion is set only when the server sees a full final fueling cycle
    -- (start -> configured duration -> stop). Merely starting the sound and waiting,
    -- or calling this event directly, is not enough.
    if mission.finalFuelCompleted ~= true then
        return
    end

    local tankerPos = shopData.tankerTapPosition and shopData.tankerTapPosition.pos
    local playerPed = GetPlayerPed(src)
    if tankerPos and (not playerPed or playerPed == 0 or #(GetEntityCoords(playerPed) - tankerPos) > 20.0) then
        return
    end

    -- A station can be sold while a delivery is in progress. Never charge the
    -- original owner to refill the buyer's station (or finish under a changed job).
    if mission.cashType ~= "society" and shopData.owner_identifier ~= mission.ownerIdentifier then
        Framework.ShowNotification(src, "The station owner changed; this delivery was cancelled.")
        ClearMissionForWorker(src, activeDriver.missionId)
        return
    end

    local fuelType = mission.fuelType
    local currentCapacity = (shopData.capacity and tonumber(shopData.capacity[fuelType])) or 0
    local litersToAdd = math.max(0, math.floor(tonumber(mission.liters) or 0))
    local maxCapacity = shopData.maxCapacity and tonumber(shopData.maxCapacity[fuelType])
    if maxCapacity then
        litersToAdd = math.min(litersToAdd, math.max(0, math.floor(maxCapacity - currentCapacity)))
    end

    if litersToAdd <= 0 then
        Framework.ShowNotification(src, "The station tank is already full; no fuel was delivered.")
        ClearMissionForWorker(src, activeDriver.missionId)
        return
    end

    local unitPrice = tonumber(mission.pricePerLiter) or GetCompanyFuelPrice(fuelType) or 0
    local totalCost = math.max(1, math.floor(unitPrice * litersToAdd + 0.5))

    -- ESX society access is callback-based and can yield. Lock completion before any
    -- payment call so duplicate finish events cannot charge/pay/add stock twice while
    -- the first handler is waiting for the society account callback.
    if mission.completionInProgress == true then return end
    mission.completionInProgress = true

    local paid = false

    if mission.cashType == "society" then
        if shopData.EnableSociety then
            paid = Society.Withdraw(shopData.Job, totalCost) == true
        end
    elseif mission.cashType == "cash" or mission.cashType == "bank" then
        local ownerSource = tonumber(mission.ownerSource)
        if ownerSource and GetPlayerName(ownerSource)
            and MissionOwnerMatchesSource(mission, ownerSource)
            and Framework.GetMoney(ownerSource, mission.cashType) >= totalCost then
            paid = Framework.RemoveMoney(ownerSource, mission.cashType, totalCost) == true
        end
    end

    -- Society access can yield. The original worker may have disconnected while the
    -- callback was in flight and the numeric source may already belong to somebody else.
    local workerStillSame = MissionWorkerMatchesSource(mission, src)

    if not paid then
        if workerStillSame then
            Framework.ShowNotification(src, "The station could not pay for the delivered fuel.")
        end
        NotifyMissionOwner(mission, "Fuel delivery payment failed; the station stock was not changed.")
        if workerStillSame then
            ClearMissionForWorker(src, activeDriver.missionId)
        else
            ClearPendingFuelMission(activeDriver.missionId)
        end
        return
    end

    if not shopData.capacity then shopData.capacity = {} end
    shopData.capacity[fuelType] = currentCapacity + litersToAdd
    PersistCapacityNow(mission.shopId)

    local changes = {}
    changes[mission.shopId] = { capacity = shopData.capacity }
    TriggerClientEvent("rcore_fuel:updateConfig", -1, changes)

    local configuredPayout = math.max(0, math.floor(tonumber(Config.MissionPayout) or 1500))
    -- Never create more driver reward than the delivered fuel actually cost. This
    -- closes the 1-liter mission money-mint while preserving the configured payout
    -- for normal-sized deliveries.
    local payoutRatio = math.max(0, tonumber(Config.MissionPayoutMaxCostRatio) or 1.0)
    local payout = math.min(configuredPayout, math.floor(totalCost * payoutRatio))
    local payoutSucceeded = payout <= 0
    if workerStillSame and payout > 0 then
        payoutSucceeded = Framework.AddMoney(src, "cash", payout) == true
        if not payoutSucceeded then
            payoutSucceeded = Framework.AddMoney(src, "bank", payout) == true
        end
    elseif not workerStillSame then
        payoutSucceeded = false
    end

    if workerStillSame then
        if payoutSucceeded then
            Framework.ShowNotification(src, string.format(
                "You delivered %d liters and earned $%d!", litersToAdd, payout))
        else
            Framework.ShowNotification(src, string.format(
                "You delivered %d liters, but the $%d payout could not be credited. Check your framework/inventory integration.", litersToAdd, payout), "error")
        end
    else
        print(string.format(
            "[rcore_fuel] Mission %s completed after worker %s disconnected; payout was not sent to reused source %s.",
            tostring(activeDriver.missionId), tostring(mission.workerIdentifier), tostring(src)))
    end

    NotifyMissionOwner(mission, string.format(
        "Fuel delivery completed: %d liters added for $%d.", litersToAdd, totalCost))
    if workerStillSame then
        ClearMissionForWorker(src, activeDriver.missionId)
    else
        ClearPendingFuelMission(activeDriver.missionId)
    end
end)

RegisterNetEvent("rcore_fuel:missionFuelpipe:setStatus", function(isBusy)
    local src = source
    local activeDriver = GetActiveDriver(src)
    if not activeDriver or not activeDriver.missionId then return end

    local mission = GetPendingFuelMission(activeDriver.missionId)
    if not mission or not mission.accepted or not MissionWorkerMatchesSource(mission, src) then return end
    if not PlayerNearMissionPosition(src, Config.MissionFuelPipe and Config.MissionFuelPipe.pos, 15.0) then return end

    if isBusy == true then
        -- This stage comes after processing/loading the oil barrels. Tracking the
        -- completed processing cycles server-side stops a modified client from
        -- jumping straight to the tanker stages.
        if (tonumber(mission.processedBarrels) or 0) < RequiredProcessedBarrels() then
            Framework.ShowNotification(src, "Finish processing the oil barrels first.", "error")
            return
        end
        if missionFuelPipeOwner and tonumber(missionFuelPipeOwner) ~= tonumber(src) then return end
        missionFuelPipeOwner = src
        mission.initialFuelStartedAt = GetGameTimer()
        mission.initialFuelCompleted = false
        TriggerClientEvent("rcore_fuel:missionFuelpipe:setStatus", -1, true)
    elseif tonumber(missionFuelPipeOwner) == tonumber(src) then
        local requiredTime = math.max(1000, tonumber(Config.FuelingTankerTime) or 120000)
        local elapsed = mission.initialFuelStartedAt and (GetGameTimer() - mission.initialFuelStartedAt) or 0
        mission.initialFuelCompleted = elapsed >= math.max(0, requiredTime - 1500)
        mission.initialFuelStartedAt = nil
        missionFuelPipeOwner = nil
        TriggerClientEvent("rcore_fuel:missionFuelpipe:setStatus", -1, false)
    end
end)

RegisterNetEvent("rcore_fuel:startFinalTankerSound", function(shouldPlay, shopId, fuelData)
    local src = source
    local activeDriver = GetActiveDriver(src)
    if not activeDriver then return end

    local mission = GetPendingFuelMission(activeDriver.missionId)
    if not mission or not mission.accepted or mission.shopId ~= shopId
        or not MissionWorkerMatchesSource(mission, src) then
        return
    end

    local shopData = Config.ShopList and Config.ShopList[shopId]
    local tankerPos = shopData and shopData.tankerTapPosition and shopData.tankerTapPosition.pos
    local playerPed = GetPlayerPed(src)
    if tankerPos and (not playerPed or playerPed == 0 or #(GetEntityCoords(playerPed) - tankerPos) > 20.0) then
        return
    end

    local requiredTime = math.max(1000, tonumber(Config.FuelingTankerTime) or 120000)
    if shouldPlay == true then
        if mission.initialFuelCompleted ~= true then
            Framework.ShowNotification(src, "Complete the tanker loading step first.", "error")
            return
        end
        if mission.finalFuelActive == true then return end
        mission.finalFuelActive = true
        mission.finalFuelCompleted = false
        mission.finalFuelStartedAt = GetGameTimer()
    else
        if mission.finalFuelActive ~= true or not mission.finalFuelStartedAt then return end
        local elapsed = GetGameTimer() - mission.finalFuelStartedAt
        mission.finalFuelCompleted = elapsed >= math.max(0, requiredTime - 1500)
        mission.finalFuelActive = false
        mission.finalFuelStartedAt = nil
    end

    -- Use the server's mission data rather than trusting arbitrary client payloads.
    local safeFuelData = {
        fuelType = mission.fuelType,
        fuelToTank = mission.liters,
        cashType = mission.cashType,
        shopId = mission.shopId,
    }
    TriggerClientEvent("rcore_fuel:startFinalTankerSound", -1, shouldPlay == true, shopId, safeFuelData)
end)

RegisterNetEvent("rcore_fuel:processBarrelLocation:setStatus", function(locationIndex, isBusy)
    local src = source
    local activeDriver = GetActiveDriver(src)
    if not activeDriver or not activeDriver.missionId then return end

    local mission = GetPendingFuelMission(activeDriver.missionId)
    if not mission or not mission.accepted or not MissionWorkerMatchesSource(mission, src) then return end

    locationIndex = tonumber(locationIndex)
    local processingLocation = locationIndex and Config.ProcessingLocationForBarrel and Config.ProcessingLocationForBarrel[locationIndex]
    if not processingLocation or not PlayerNearMissionPosition(src, processingLocation.pos, 15.0) then return end

    local owner = barrelLocationOwners[locationIndex]
    mission.barrelProcessingStartedAt = mission.barrelProcessingStartedAt or {}

    if isBusy == true then
        if owner and tonumber(owner) ~= tonumber(src) then return end

        local activeLocation = tonumber(mission.activeBarrelLocation)
        if activeLocation and activeLocation ~= locationIndex then
            -- One worker may only process one barrel location at a time. Without this,
            -- a modified client can start every location in parallel and complete the
            -- whole processing stage after a single timer window.
            return
        end

        -- A duplicate "busy=true" for the already-active location must not restart the
        -- server timer. This also makes retransmitted UI/network events idempotent.
        if tonumber(owner) == tonumber(src) and mission.barrelProcessingStartedAt[locationIndex] then
            return
        end

        barrelLocationOwners[locationIndex] = src
        mission.activeBarrelLocation = locationIndex
        mission.barrelProcessingStartedAt[locationIndex] = GetGameTimer()
        TriggerClientEvent("rcore_fuel:processBarrelLocation:setStatus", -1, locationIndex, true)
    elseif tonumber(owner) == tonumber(src) then
        local activeLocation = tonumber(mission.activeBarrelLocation)
        if activeLocation and activeLocation ~= locationIndex then return end

        local startedAt = mission.barrelProcessingStartedAt[locationIndex]
        local requiredTime = math.max(1000, tonumber(Config.TimeToProcessBarrel) or 60000)
        local elapsed = startedAt and (GetGameTimer() - startedAt) or 0

        mission.barrelProcessingStartedAt[locationIndex] = nil
        mission.activeBarrelLocation = nil
        barrelLocationOwners[locationIndex] = nil

        if elapsed >= math.max(0, requiredTime - 1500) then
            local requiredBarrels = RequiredProcessedBarrels()
            mission.processedBarrels = math.min(requiredBarrels, (tonumber(mission.processedBarrels) or 0) + 1)
        end

        TriggerClientEvent("rcore_fuel:processBarrelLocation:setStatus", -1, locationIndex, false)
    end
end)

RegisterNetEvent("rcore_fuel:missionEndedForPlayer", function()
    local src = source
    ClearMissionForWorker(src)
end)

RegisterNetEvent("rcore_fuel:resetFuel", function(vehicleNetId, amountToInsert)
    local src = source
    vehicleNetId = tonumber(vehicleNetId)
    if not vehicleNetId or vehicleNetId ~= vehicleNetId or vehicleNetId == math.huge or vehicleNetId == -math.huge then return end
    vehicleNetId = math.floor(vehicleNetId)
    if vehicleNetId <= 0 then return end

    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local playerPed = GetPlayerPed(src)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or not playerPed or playerPed == 0 then
        return
    end

    if #(GetEntityCoords(playerPed) - GetEntityCoords(vehicle)) > 8.0 then return end

    local wrongFuelEvidence = WrongFuelVehicleEvidence and WrongFuelVehicleEvidence[vehicleNetId]
    if not wrongFuelEvidence or wrongFuelEvidence.model ~= GetEntityModel(vehicle)
        or wrongFuelEvidence.entity ~= vehicle
        or (tonumber(wrongFuelEvidence.wrongLiters) or 0) < 1 then
        Framework.ShowNotification(src, "The server has no record of wrong fuel in this vehicle.", "error")
        return
    end

    if InventoryBridge and not InventoryBridge.HasItem(src, "fuel_pump", 1) then
        Framework.ShowNotification(src, "You need a fuel pumper to do that.")
        return
    end

    local now = GetGameTimer()
    local operationTime = math.max(10000, tonumber(Config.FuelPumperInterval) or 60000)
    if activePumpOutOperations[vehicleNetId] then return end
    if recentlyResetVehicles[vehicleNetId] and now - recentlyResetVehicles[vehicleNetId] < operationTime then return end

    local vehicleCoords = GetEntityCoords(vehicle)
    local safePos = vehicleCoords
    local safeHeading = GetEntityHeading(vehicle)
    if type(amountToInsert) == "table" then
        local requestedPos = amountToInsert.pos
        if requestedPos then
            local ok, distance = pcall(function() return #(requestedPos - vehicleCoords) end)
            if ok and distance <= 10.0 then safePos = requestedPos end
        end
        local requestedHeading = tonumber(amountToInsert.heading)
        if requestedHeading and requestedHeading == requestedHeading
            and requestedHeading ~= math.huge and requestedHeading ~= -math.huge then
            -- GTA headings wrap naturally, but normalize untrusted values before they
            -- are broadcast to every client and used to spawn the temporary prop.
            safeHeading = requestedHeading % 360.0
        end
    end

    local identifier = string.format("%s_%s_%s", src, vehicleNetId, now)
    local operation = {
        source = src,
        vehicleNetId = vehicleNetId,
        identifier = identifier,
        startedAt = now,
        expiresAt = now + operationTime,
        vehicleEntity = vehicle,
        vehicleModel = GetEntityModel(vehicle),
        evidence = wrongFuelEvidence,
        startedByIdentifier = Framework.GetPlayerIdentifier(src) or ("source:" .. tostring(src)),
    }
    activePumpOutOperations[vehicleNetId] = operation
    recentlyResetVehicles[vehicleNetId] = now

    TriggerClientEvent("rcore_fuel:insertPump", -1, {
        identifier = identifier,
        pos = safePos,
        model = "ch_prop_ch_generator_01a",
        heading = safeHeading,
        timeElapsed = 0,
    })

    CreateThread(function()
        Wait(operationTime)
        if activePumpOutOperations[vehicleNetId] ~= operation then return end
        activePumpOutOperations[vehicleNetId] = nil

        local currentVehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        local currentPed = GetPlayerPed(src)
        local currentEvidence = WrongFuelVehicleEvidence and WrongFuelVehicleEvidence[vehicleNetId]
        local samePlayer = Framework.GetPlayerIdentifier(src) == operation.startedByIdentifier
        local completed = samePlayer
            and currentVehicle and currentVehicle ~= 0 and DoesEntityExist(currentVehicle)
            and currentPed and currentPed ~= 0
            and currentVehicle == operation.vehicleEntity
            and GetEntityModel(currentVehicle) == operation.vehicleModel
            and currentEvidence == operation.evidence
            and currentEvidence.entity == currentVehicle
            and (tonumber(currentEvidence.wrongLiters) or 0) >= 1
            and Entity(currentVehicle).state[DecorEnum.WRONG_FUEL] == true
            and #(GetEntityCoords(currentPed) - GetEntityCoords(currentVehicle)) <= 12.0

        if completed and InventoryBridge then
            completed = InventoryBridge.HasItem(src, "fuel_pump", 1)
        end

        if completed then
            local contaminators = currentEvidence.contaminators or {}
            local selfContaminated = operation.startedByIdentifier and contaminators[operation.startedByIdentifier] == true
            local wrongLiters = math.max(0, math.floor(tonumber(currentEvidence.wrongLiters) or 0))
            local configuredReward = math.max(0, math.floor(tonumber(Config.MissionRewardForWrongFuel) or 250))
            local minRewardLiters = math.max(1, math.floor(tonumber(Config.MinWrongFuelLitersForReward) or 10))
            local rewardPerLiter = math.max(0, tonumber(Config.WrongFuelRewardPerLiter) or 10)
            -- A second player can otherwise contaminate 1L and let a partner claim the
            -- full fixed reward. Scale by evidence and require a meaningful cleanup.
            local reward = 0
            if wrongLiters >= minRewardLiters then
                reward = math.min(configuredReward, math.floor(wrongLiters * rewardPerLiter))
            end
            if selfContaminated then reward = 0 end

            local rewardSucceeded = reward <= 0
            if reward > 0 then
                rewardSucceeded = Framework.AddMoney(src, "cash", reward) == true
                if not rewardSucceeded then
                    rewardSucceeded = Framework.AddMoney(src, "bank", reward) == true
                end
            end
            if selfContaminated then
                Framework.ShowNotification(src, "Fuel was pumped out. No service reward is paid for contamination you caused yourself.")
            elseif reward <= 0 then
                Framework.ShowNotification(src, "Fuel was pumped out. The contamination amount was too small for a service reward.")
            elseif rewardSucceeded then
                Framework.ShowNotification(src, string.format("You pumped out the fuel and earned $%d for the service.", reward))
            else
                Framework.ShowNotification(src, "Fuel was pumped out, but the service reward could not be credited.", "error")
            end
            if WrongFuelVehicleEvidence then WrongFuelVehicleEvidence[vehicleNetId] = nil end

            -- Clear the authoritative replicated marker before telling clients to
            -- remove their local decorator/fuel state.
            Entity(currentVehicle).state:set(DecorEnum.WRONG_FUEL, nil, true)
            Entity(currentVehicle).state:set(DecorEnum.MILEAGE, nil, true)
            TriggerClientEvent("rcore_fuel:resetFuel", -1, vehicleNetId)
        elseif samePlayer then
            Framework.ShowNotification(src, "Fuel pump-out cancelled because you moved away.", "error")
        end

        TriggerClientEvent("rcore_fuel:removeFromCache", -1, identifier)
    end)
end)

RegisterNetEvent("rcore_fuel:removeFromCache", function(identifier)
    local src = source
    if type(identifier) ~= "string" then return end

    local now = GetGameTimer()
    for _, operation in pairs(activePumpOutOperations) do
        if operation.identifier == identifier then
            -- Only the player who started the server-created operation may request
            -- its visual cleanup, and only when its real timer has essentially ended.
            if tonumber(operation.source) ~= tonumber(src) or now < (operation.expiresAt - 1500) then return end
            TriggerClientEvent("rcore_fuel:removeFromCache", -1, identifier)
            return
        end
    end
end)

RegisterNetEvent("rcore_fuel:forceCancelMission", function(shopId)
    local src = source
    local shopData = shopId and Config.ShopList[shopId]
    if not shopData then return end

    local identifier = Framework.GetPlayerIdentifier(src)
    local authorised = shopData.owner_identifier == identifier
        or (shopData.EnableSociety and Framework.IsBoss(src, shopData.Job))
    if not authorised then return end
    -- Match the rest of the company-management surface: cancellation is a station
    -- management action, not a remote server-wide control event.
    local marker = shopData.companyMenuMarkerPos
    if marker and not PlayerNearMissionPosition(src, marker, 12.0) then return end

    local missionId = shopData.isMissionRunning
    local mission = missionId and GetPendingFuelMission(missionId) or nil
    if mission then
        if mission.completionInProgress == true then
            Framework.ShowNotification(src, "This delivery is already being finalized and can no longer be cancelled.")
            return
        end

        local workerSource = tonumber(mission.workerSource)
        if workerSource and GetPlayerName(workerSource) and MissionWorkerMatchesSource(mission, workerSource) then
            TriggerClientEvent("rcore_fuel:forceMissionCancelled", workerSource)
            ReleaseMissionInteractionLocks(workerSource)
            UnregisterDriver(workerSource)
        end
        ClearPendingFuelMission(missionId)
    else
        shopData.isMissionRunning = nil
        TriggerClientEvent("rcore_fuel:updateConfig", -1, {
            [shopId] = { isMissionRunning = false }
        })
    end

end)


-- Clean stale vehicle-service bookkeeping so recycled network IDs do not inherit
-- old cooldown/evidence state on long-running servers.
CreateThread(function()
    while true do
        Wait(60000)
        local now = GetGameTimer()
        local operationTime = math.max(10000, tonumber(Config.FuelPumperInterval) or 60000)
        for netId, timestamp in pairs(recentlyResetVehicles) do
            if now - (tonumber(timestamp) or 0) > operationTime * 2 then
                recentlyResetVehicles[netId] = nil
            end
        end
        if WrongFuelVehicleEvidence then
            for netId, evidence in pairs(WrongFuelVehicleEvidence) do
                local entity = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
                if not entity or entity == 0 or not DoesEntityExist(entity)
                    or (evidence.entity and entity ~= evidence.entity)
                    or (evidence.model and GetEntityModel(entity) ~= evidence.model) then
                    WrongFuelVehicleEvidence[netId] = nil
                end
            end
        end
    end
end)

-- Release interaction locks if a client disappears from a mission stage without
-- sending its normal "not busy" event. This prevents one stale mission from
-- blocking every later delivery until a resource restart.
CreateThread(function()
    while true do
        Wait(15000)
        local now = GetGameTimer()

        if missionFuelPipeOwner then
            local missionId, mission = FindPendingFuelMissionByWorker(missionFuelPipeOwner)
            local maxAge = math.max(1000, tonumber(Config.FuelingTankerTime) or 120000) + 120000
            if not mission or not mission.initialFuelStartedAt or now - mission.initialFuelStartedAt > maxAge then
                missionFuelPipeOwner = nil
                if mission then mission.initialFuelStartedAt = nil end
                TriggerClientEvent("rcore_fuel:missionFuelpipe:setStatus", -1, false)
            end
        end

        for locationIndex, owner in pairs(barrelLocationOwners) do
            local _, mission = FindPendingFuelMissionByWorker(owner)
            local startedAt = mission and mission.barrelProcessingStartedAt and mission.barrelProcessingStartedAt[locationIndex]
            local maxAge = math.max(1000, tonumber(Config.TimeToProcessBarrel) or 60000) + 120000
            if not mission or not startedAt or now - startedAt > maxAge then
                barrelLocationOwners[locationIndex] = nil
                if mission and mission.barrelProcessingStartedAt then
                    mission.barrelProcessingStartedAt[locationIndex] = nil
                    if tonumber(mission.activeBarrelLocation) == tonumber(locationIndex) then
                        mission.activeBarrelLocation = nil
                    end
                end
                TriggerClientEvent("rcore_fuel:processBarrelLocation:setStatus", -1, locationIndex, false)
            end
        end
    end
end)

-- An ignored mission invitation used to leave the station permanently stuck in
-- "mission running" until a restart or manual cancellation. Expire only unaccepted
-- invitations; accepted missions remain under player/owner lifecycle handling.
CreateThread(function()
    while true do
        Wait(30000)
        local now = os.time()
        local expired = {}
        for missionId, mission in pairs(PendingFuelMissions) do
            if not mission.accepted and mission.createdAt and now - mission.createdAt >= 300 then
                expired[#expired + 1] = missionId
            end
        end

        for _, missionId in ipairs(expired) do
            local mission = GetPendingFuelMission(missionId)
            if mission and not mission.accepted then
                NotifyMissionOwner(mission, "The fuel-delivery invitation expired without a response.")
                local workerSource = tonumber(mission.workerSource)
                if workerSource and GetPlayerName(workerSource) and MissionWorkerMatchesSource(mission, workerSource) then
                    Framework.ShowNotification(workerSource, "The fuel-delivery invitation expired.")
                end
                ClearPendingFuelMission(missionId)
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source

    -- Cancel long-running pump-out jobs owned by this exact source before FiveM can
    -- recycle the number. The waiter thread compares the operation object and exits.
    for vehicleNetId, operation in pairs(activePumpOutOperations) do
        if tonumber(operation.source) == tonumber(src) then
            activePumpOutOperations[vehicleNetId] = nil
            TriggerClientEvent("rcore_fuel:removeFromCache", -1, operation.identifier)
        end
    end

    ReleaseMissionInteractionLocks(src)
    local workerMissionId = select(1, FindPendingFuelMissionByWorker(src))
    if workerMissionId then
        local mission = GetPendingFuelMission(workerMissionId)
        if mission and mission.completionInProgress == true then
            -- The final transaction may currently be waiting on an async society callback.
            -- Let that transaction finish instead of deleting its mission state mid-charge.
            NotifyMissionOwner(mission, "The delivery worker disconnected while the completed delivery was being finalized.")
        else
            NotifyMissionOwner(mission, "The assigned fuel-delivery worker disconnected; the mission was cancelled.")
            ClearPendingFuelMission(workerMissionId)
        end
    end

    local ownerMissionIds = {}
    for missionId, mission in pairs(PendingFuelMissions) do
        if tonumber(mission.ownerSource) == tonumber(src) then
            ownerMissionIds[#ownerMissionIds + 1] = missionId
        end
    end

    for _, missionId in ipairs(ownerMissionIds) do
        local mission = GetPendingFuelMission(missionId)
        if mission then
            if mission.completionInProgress == true then
                -- Society-funded completion no longer depends on the owner's player object.
                -- Do not invalidate an in-flight payment after it has begun.
                local workerSource = tonumber(mission.workerSource)
                if workerSource and GetPlayerName(workerSource) and MissionWorkerMatchesSource(mission, workerSource) then
                    Framework.ShowNotification(workerSource, "The station owner disconnected while your completed delivery was being finalized.")
                end
            else
                local workerSource = tonumber(mission.workerSource)
                if workerSource and GetPlayerName(workerSource) and MissionWorkerMatchesSource(mission, workerSource) then
                    TriggerClientEvent("rcore_fuel:forceMissionCancelled", workerSource)
                    Framework.ShowNotification(workerSource, "The station owner disconnected; the delivery mission was cancelled.")
                    UnregisterDriver(workerSource)
                end
                ClearPendingFuelMission(missionId)
            end
        end
    end

    UnregisterDriver(src)
end)
