-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local SENT_BATCH_DATA_BY_ACTION = {
    [MENU_ACTIONS.SHOW_VEHICLE_INFORMATION] = true,
    [MENU_ACTIONS.IMPOUND_VEHICLE] = true,
}
local lastMenuInteractTime = nil
local lastInteractTime = nil
local cooldownTime = 500
NetworkService.RegisterNetEvent('StartInteractionByItem', function(validRequest, action, playerId)
    if validRequest then
        TriggerEvent("rcore_police:client:routeMenuInteractToServer", {
            action,
            playerId,
        })
    end
end)
function passesCondition(flags, isCuffed, isHandsUp, target)
    local isDead = DeadUtils.IsTargetPlayerDead(target)
    if target and isDead then
        return isDead
    end
    if flags.RequireCuffed and flags.RequireHandsup then
        return isCuffed or isHandsUp
    elseif flags.RequireCuffed then
        return isCuffed
    elseif flags.RequireHandsup then
        return isHandsUp
    else
        return true
    end
end
AddEventHandler('rcore_police:client:menuInteract', function(session, invokingResource)
    if not session then return end
    local currentResource = GetCurrentResourceName()
    local currentTime = GetGameTimer()
    local isFromAnotherResource = invokingResource ~= currentResource
    local canInteract = Utils.CanPlayerInteract({
        FLAG_SKIP_NUI_CHECK = isFromAnotherResource,
        FLAG_SKIP_DEATH = Config.Flags.SkipDeathCheck or false,
    })
    if not canInteract then return end
    if lastMenuInteractTime and (currentTime - lastMenuInteractTime) < cooldownTime then return end
    lastMenuInteractTime = currentTime
    local action = session.action
    local value = session.value or nil
    local actionType = session.type or nil
    local data = session.data or nil
    local mePed = PlayerPedId()
    local meCoords = GetEntityCoords(mePed)
    local entity = Utils.GetClosestVehicleToPlayer(meCoords, Config.CheckVehicleDistance)
    if action == MENU_ACTIONS.ESCORT_CITIZEN and not Config.Escort.Enable then
        return dbg.debug('Escort action blocked by config: Escort.Enable = false')
    end
    if actionType == ACTION_TYPES.VEHICLE then
        if entity == 0 then
            return Framework.sendNotification(_U('MENU_INTERACT.NOT_CLOSE_TO_ANY_VEHICLE'), 'error')
        end
        value = entity
        if SENT_BATCH_DATA_BY_ACTION[action] and entity then
            data = {
                plate = GetVehicleNumberPlateText(entity),
                netId = VehToNet(entity)
            }
        end
    end
    if actionType == ACTION_TYPES.CITIZEN then
        local closestPlayer, _, closestPlayers = Utils.getClosestPlayers(Config.CheckDistance, false)
        local count = 0
        if closestPlayers then
            for _ in pairs(closestPlayers) do count = count + 1 end
        end
        if count > 1 and Config.Menu == Menu.RCORE then
            local playersNearby = {
                { header = _U("SELECT_PLAYER_MENU_TITLE"), isMenuHeader = true },
            }
            for k, v in pairs(closestPlayers) do
                local playerId = v.playerId
                startHoverFunction(playerId, k)
                table.insert(playersNearby, {
                    type = 'button',
                    header = getPlayerLabelByShowMode(playerId),
                    description = '',
                    onHoverId = k,
                    icon = v.icon or '',
                    params = {
                        isClient = true,
                        event = 'rcore_police:client:routeMenuInteractToServer',
                        args = { action, playerId, actionType, data },
                    },
                })
            end
            return UI:CreateMenu(MENU_ID_LIST.SELECT_PLAYERS, _U('SELECT_PLAYER_MENU_TITLE'), playersNearby, true)
        else
            if closestPlayer and closestPlayer ~= -1 then
                value = closestPlayer
            else
                return Framework.sendNotification(_U('NO_CITIZEN_NEARBY'), 'error')
            end
        end
    end
    local targetPed = UtilsService.GetPlayerPedFromServerId(value)
    local isCuffed = targetPed and IsPedCuffed(targetPed)
    local isHandsUp = GetHandsUPState(value)
    if action == MENU_ACTIONS.ESCORT_CITIZEN and not passesCondition(Config.Escort.Flags, isCuffed, isHandsUp, value) then
        if Config.Escort.Flags.RequireCuffed and Config.Escort.Flags.RequireHandsup then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_HANDSUP"))
        elseif Config.Escort.Flags.RequireCuffed then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED"))
        elseif Config.Escort.Flags.RequireHandsup then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_HANDSUP"))
        end
    end
    if action == MENU_ACTIONS.SEARCH_PLAYER and not passesCondition(Config.PlayerSearch.Flags, isCuffed, isHandsUp, value) then
        if Config.PlayerSearch.Flags.RequireCuffed and Config.PlayerSearch.Flags.RequireHandsup then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_HANDSUP"))
        elseif Config.PlayerSearch.Flags.RequireCuffed then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED"))
        elseif Config.PlayerSearch.Flags.RequireHandsup then
            return Framework.sendNotification(_U("ACTIONS_REQUIRE_HANDSUP"))
        end
    end
    if not value then 
        return
    end
    TriggerServerEvent('rcore_police:server:requestMenuInteract', action, value, actionType, data)
end)
AddEventHandler('rcore_police:client:routeMenuInteractToServer', function(data)
    if not data then
        return
    end
    local plyPed = PlayerPedId()
    local action = data[1]
    local target = tonumber(data[2])
    local targetPed = UtilsService.GetPlayerPedFromServerId(target)
    local targetCoords = GetEntityCoords(targetPed)
    local plyInVehicle = GetVehiclePedIsIn(plyPed, false)
    local escortFlags = Config.Escort.Flags
    local searchFlags = Config.PlayerSearch.Flags
    local isCuffed = IsPedCuffed(targetPed)
    local isHandsUp = GetHandsUPState(target)
    if not UtilsService.IsTargetInFrontOfPed(plyPed, targetCoords) and not DoesEntityExist(plyInVehicle) then
        return Framework.sendNotification(_U("CITIZEN_NOT_IN_FRONT"), "error")
    end
    if action == MENU_ACTIONS.ESCORT_CITIZEN then
        if not passesCondition(escortFlags, isCuffed, isHandsUp, target) then
            if escortFlags.RequireCuffed and escortFlags.RequireHandsup then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_HANDSUP"))
            elseif escortFlags.RequireCuffed then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED"))
            elseif escortFlags.RequireHandsup then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_HANDSUP"))
            end
        end
    end
    if action == MENU_ACTIONS.SEARCH_PLAYER then
        if not passesCondition(searchFlags, isCuffed, isHandsUp, target) then
            if searchFlags.RequireCuffed and searchFlags.RequireHandsup then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED_OR_HANDSUP"))
            elseif searchFlags.RequireCuffed then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_CUFFED"))
            elseif searchFlags.RequireHandsup then
                return Framework.sendNotification(_U("ACTIONS_REQUIRE_HANDSUP"))
            end
        end
    end
    TriggerServerEvent("rcore_police:server:requestMenuInteract", table.unpack(data))
end)
OpenMainMenu = function()
    local currentTime = GetGameTimer()
    if lastInteractTime and (currentTime - lastInteractTime) < cooldownTime then
        return
    end
    lastInteractTime = GetGameTimer()
    if not Utils.CanPlayerInteract() then
        return
    end
    if not Utils.HasAccessToJobMenu() then
        return
    end
    if not Config.JobMenu.Enable then
        return dbg.debug('Job menu - is disabled.')
    end
    local array = {
        {
            header = _U('JOB_MENU.MENU_TITLE'),
            isMenuHeader = true,
        },
    }
    local propSubMenu = Menu.AddPropsSubMenu()
    local vehicleSubMenu = Menu.AddVehicleSubMenu()
    local citizenSubMenu = Menu.AddCitizenSubMenu()
    if next(propSubMenu) then
        array[#array + 1] = {
            type = 'button',
            header = _U('MENUS.MAIN_MENU_PROPS_TITLE'),
            description = '',
            params = {
                icon = 'fa-solid fa-cube',
            },
            submenu = propSubMenu
        }
    end
    if next(vehicleSubMenu) then
        array[#array + 1] = {
            type = 'button',
            header = _U('MENUS.MAIN_MENU_VEHICLE_INTERACTIONS_TITLE'),
            description = '',
            params = {
                icon = 'fas fa-car'
            },
            submenu = vehicleSubMenu
        }
    end
    if next(citizenSubMenu) then
        array[#array + 1] = {
            type = 'button',
            header = _U('MENUS.MAIN_MENU_CITIZEN_TITLE'),
            description = '',
            params = {
                icon = 'fa-solid fa-user'
            },
            submenu = citizenSubMenu
        }
    end
    UI:CreateMenu(MENU_ID_LIST.MAIN_MENU, _U('JOB_MENU.MENU_TITLE'), array, true)
end
RegisterKey(OpenMainMenu, 'RCORE_POLICE_JOB_MENU', _U("KEY_MAPPING.JOB_MENU"), Config.JobMenuKey)
RegisterCommand('policemenu', function()
    OpenMainMenu()
end, false)

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 167) then -- F6
            OpenMainMenu()
        end
    end
end)

AddEventHandler('rcore_police:client:openJobMenu', function()
    OpenMainMenu()
end)
