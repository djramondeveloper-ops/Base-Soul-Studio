-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-actions.lua
--  Engineered by Eazy Fxap
--  Original: 459 lines → Cleaned: 129 lines
-- =====================================================

local Actions = {}

Actions.SEARCH_PLAYER = function(source, target)
    ActionService.SearchPlayer(source, target)
end

Actions.FROM_VEHICLE = function(source, target)
    ActionService.TakePlayerFromVehicle(source, target)
end

Actions.IN_VEHICLE = function(source, target)
    ActionService.PutPlayerInVehicle(source, target)
end

Actions.ESCORT_CITIZEN = function(source, target)
    ActionService.Escort(source, target)
end

Actions.SENT_TO_JAIL = function(source, target)
    ActionService.JailPlayer(source, target)
end

Actions.SENT_TO_COMS = function(source, target)
    ActionService.SentPlayerToCOMS(source, target)
end

Actions.SENT_FINE = function(source, target, dummy, data)
    safeCallFunction(CreateInvoice, MENU_ACTIONS.SENT_FINE, source, target, data.cost, data)
end

Actions.SHOW_PLAYER_LICENSES = function(source, target)
    safeCallFunction(ShowPlayerLicense, MENU_ACTIONS.SHOW_PLAYER_LICENSES, target, source)
end

Actions.INVOICE_CITIZEN = function(source, target)
    ActionService.RenderFine(source, target)
end

Actions.REQUEST_SPAWN_MODEL = function(source, target, propType)
    local propData = Config.Props.ModelDataByPropType[propType]
    if propData then
        local itemName = propData.itemName
        local label = propData.label
        if Config.Props.CheckHasItem and itemName then
            if not InventoryService.hasItem(source, itemName) then
                return Framework.sendNotification(source, _U("PROPS.YOU_DONT_HAVE_ITEM_IN_INVENTORY", label), "error")
            end
        end
    else
        if Config.Props.CheckHasItem then
            dbg.debug("Prop with type %s is not defined in Config.Props.ModelDataByPropType - disabling inventory check", propType)
        end
    end
    
    if UsedItemsCache[source] then return end
    UsedItemsCache[source] = true
    StartClient(source, "spawnProp", target, propType)
end

Actions.SHOW_VEHICLE_INFORMATION = function(source, target, dummy, data)
    local vehicleInfo = GarageService.GetVehicleInfo(data.plate, target)
    if vehicleInfo and next(vehicleInfo) then
        StartClient(source, "handleVehicleTask", MENU_ACTIONS.SHOW_VEHICLE_INFORMATION, target, vehicleInfo)
    end
end

Actions.IMPOUND_VEHICLE = function(source, target, dummy, data)
    if not data then return end
    data.owned = GarageService.IsVehiclePlayerOwned(data.plate, target)
    StartClient(source, "handleVehicleTask", MENU_ACTIONS.IMPOUND_VEHICLE, target, data)
end

Actions.HIRE_PLAYER = function(source, target)
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(source)
    if not isMember then return end
    
    local job = Framework.getJob(source)
    if job and not job.isBoss then return end
    
    local hireSuccess = Framework.SetPlayerJob(target, groupData and groupData.group or nil, 0)
    local targetName = Framework.getCharacterShortName(target)
    
    if hireSuccess then
        Framework.sendNotification(target, _U("BOSS_MENU.YOU_HIRED_BY_INITIATOR", groupData and groupData.group or nil, groupData and groupData.name or nil), "success")
        Framework.sendNotification(source, _U("BOSS_MENU.YOU_HIRED_PLAYER", targetName), "success")
    end
end

Actions.UNLOCK_VEHICLE = function(source, target)
    StartClient(source, "handleVehicleTask", MENU_ACTIONS.UNLOCK_VEHICLE, target)
end

Actions.CUFF_SOFT = function(source, target)
    ActionService.Handcuff(source, target)
end

Actions.EMERGENCY = function(source, target, dummy, data)
    EmergencyCall(data)
end

function performAction(actionName, ...)
    local actionFn = Actions[actionName]
    local args = {...}
    local source = args[1]
    
    if actionFn then
        dbg.debug("Loading action named: %s by player %s named %s", actionName, source, GetPlayerName(source))
        actionFn(...)
    else
        dbg.critical("Interaction: Failed to perform action %s, since is not defined by player %s named %s", actionName, source, GetPlayerName(source))
    end
end

RegisterNetEvent("rcore_police:server:requestMenuInteract", function(actionName, target, actionType, data)
    local src = source
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember or not groupData then
        return
    end
    
    if actionType and actionType == ACTION_TYPES.CITIZEN then
        if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.CheckDistance) then
            return Framework.sendNotification(src, _U("NO_CITIZEN_NEARBY"), "error")
        end
    end
    
    if actionName == "EMERGENCY" then
        data = groupData
    end
    
    performAction(actionName, src, target, actionType, data)
end)

RegisterNetEvent("rcore_police:server:requestSearchInventory", function(target)
    local src = source
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then return end
    ActionService.SearchPlayer(src, target)
end)

RegisterNetEvent("rcore_police:server:requestStopEscort", function()
    local src = source
    ClearPedTasksImmediately(GetPlayerPed(src))
    ActionService.Escort(src)
end)

RegisterNetEvent("rcore_police:server:requestCuffDuringEscort", function(target)
    local src = source
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember or not groupData then return end
    
    if not Utils.IsPlayerNearAnotherPlayer(src, target, Config.Cuffing.CheckDistance) then
        return Framework.sendNotification(src, _U("NO_CITIZEN_NEARBY"), "error")
    end
    
    if src == target then return end
    
    ActionService.Escort(src, target, true)
    Wait(100)
    ActionService.Handcuff(src, target)
    Wait(500)
    ActionService.Escort(src, target)
end)
