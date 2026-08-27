-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local InteractionsMap = {
    {
        icon = "fa-solid fa-handcuffs",
        label = _U("TARGET.HANDCUFF"),
        action = MENU_ACTIONS.CUFF_SOFT,
        type = ACTION_TYPES.CITIZEN
    },
    {
        icon = "fa-solid fa-eye",
        label = _U("TARGET.SEARCH_PLAYER"),
        action = MENU_ACTIONS.SEARCH_PLAYER,
        type = ACTION_TYPES.CITIZEN
    },
    {
        icon = "fa-solid fa-user",
        label = _U("TARGET.ESCORT"),
        action = MENU_ACTIONS.ESCORT_CITIZEN,
        type = ACTION_TYPES.CITIZEN
    },
    {
        icon = "fa-solid fa-car",
        label = _U("TARGET.PUT_IN_VEHICLE"),
        action = MENU_ACTIONS.IN_VEHICLE,
        type = ACTION_TYPES.CITIZEN
    },
    {
        icon = "fa-solid fa-user",
        label = _U("TARGET.FROM_VEHICLE"),
        action = MENU_ACTIONS.FROM_VEHICLE,
        type = ACTION_TYPES.CITIZEN
    }
}
local function createCanInteractFunction(interact)
    return function(entity)
        if Config.RequireDutyForTargetInteractions and not Framework.job.duty then
            return false
        end
        if interact.action == MENU_ACTIONS.FROM_VEHICLE then
            local plyPed = PlayerPedId()
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
            if DoesEntityExist(plyVehicle) then
                return false
            end
            local vehicle = entity
            if not DoesEntityExist(vehicle) then
                return false
            end
            local isAnySeatOccupied = false
            for seatIndex = 0, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                local ped = GetPedInVehicleSeat(vehicle, seatIndex)
                if ped ~= 0 then
                    isAnySeatOccupied = true
                end
            end
            return isAnySeatOccupied and Utils.CanPlayerInteract({ FLAG_SKIP_NUI_CHECK = true })
        else
            if not IsPedAPlayer(entity) then return false end
            return Utils.CanPlayerInteract({ FLAG_SKIP_NUI_CHECK = true })
        end
    end
end
local function FindPlayerSeatPed(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then
        return nil, nil
    end
    for seatIndex = 0, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        local ped = GetPedInVehicleSeat(vehicle, seatIndex)
        if ped ~= 0 then
            local playerIndex = NetworkGetPlayerIndexFromPed(ped)
            if playerIndex and playerIndex ~= -1 then
                return seatIndex, ped
            end
        end
    end
    return nil, nil
end
local function createActionFunction(interact, isVehicleAction)
    return function(data)
        local targetEntity = nil
        if type(data) == "number" then
            targetEntity = data
        elseif type(data) == "table" then
            targetEntity = data.entity
        end
        if not targetEntity then
            return dbg.critical('Failed to do interaction named: %s failed to get entity to being invoked on: %s',
                interact.action, type(targetEntity))
        end
        if Config.DebugInteract then
            local key = ("Routing: action %s via %s with type: %s"):format(interact.action, GetCurrentResourceName(),
                interact.type)
            if key then
                Framework.sendNotification(key)
            end
        end
        if isVehicleAction then
            local vehicle = targetEntity
            local plyPed = PlayerPedId()
            local seatIndex, targetPed = FindPlayerSeatPed(vehicle)
            if targetPed and DoesEntityExist(targetPed) then
                local playerId = UtilsService.GetServerIdFromPed(targetPed)
                if playerId and playerId ~= 0 then
                    TriggerEvent("rcore_police:client:routeMenuInteractToServer", {
                        interact.action,
                        playerId,
                        interact.type
                    })
                end
            end
        else
            local playerId = UtilsService.GetServerIdFromPed(targetEntity)
            if playerId then
                TriggerEvent("rcore_police:client:routeMenuInteractToServer", {
                    interact.action,
                    playerId,
                    interact.type
                })
            end
        end
    end
end
CreateThread(function()
    if not Config.InteractionEnableTarget then return end
    for _, interact in pairs(InteractionsMap) do
        local isVehicleAction = (interact.action == MENU_ACTIONS.FROM_VEHICLE)
        if Config.DebugInteract then
            interact.label = ("%s : %s"):format(interact.label, GetCurrentResourceName())
        end
        local interactKey = ("%s:%s"):format(interact.label, GetCurrentResourceName())
        local interactLabel = ("%s: %s"):format(_U("INTERACT_TARGET_PREFIX_JOB"), interact.label)
        if isResourcePresentProvideless('crm-target') or Config.InteractionsTarget == InteractionsTarget.OX then
            if isVehicleAction then
                exports.ox_target:addGlobalVehicle({
                    {
                        name = interactKey,
                        icon = interact.icon,
                        groups = PoliceJobs,
                        label = interactLabel,
                        distance = Config.CheckDistance,
                        canInteract = createCanInteractFunction(interact),
                        onSelect = createActionFunction(interact, true)
                    }
                })
            else
                exports.ox_target:addGlobalPlayer({
                    {
                        name = interactKey,
                        icon = interact.icon,
                        groups = PoliceJobs,
                        label = interactLabel,
                        distance = Config.CheckDistance,
                        canInteract = createCanInteractFunction(interact),
                        onSelect = createActionFunction(interact, false)
                    }
                })
            end
        elseif Config.InteractionsTarget == InteractionsTarget.QB then
            local targeting = exports['qb-target']
            if isVehicleAction then
                targeting:AddGlobalVehicle({
                    options = {
                        {
                            type = "client",
                            icon = interact.icon,
                            label = interactLabel,
                            job = PoliceJobs,
                            canInteract = createCanInteractFunction(interact),
                            action = createActionFunction(interact, true)
                        }
                    },
                    distance = 0.5
                })
            else
                targeting:AddGlobalPed({
                    options = {
                        {
                            type = "client",
                            icon = interact.icon,
                            label = interactLabel,
                            job = PoliceJobs,
                            canInteract = createCanInteractFunction(interact),
                            action = createActionFunction(interact, false)
                        }
                    },
                    distance = Config.CheckDistance
                })
            end
        end
    end
end)
