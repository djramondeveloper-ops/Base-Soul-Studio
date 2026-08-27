-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



RegisterCommand(Config.Commands.GRANT_LICENCE and Config.Commands.GRANT_LICENCE or 'grant_licence', function(source, args, rawCommand)
    local playerId = source
    local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
    if not state then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_ACCESS"), "error")
    end
    local target = tonumber(args[1])
    if not target then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_NIL"), "error")
    end
    local targetPed = GetPlayerPed(target)
    if not DoesEntityExist(targetPed) then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_OFFLINE"), "error")
    end
    if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance) then
        return Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
    end
    local license = args[2]
    AddPlayerLicense(playerId, target, license)
end, false)
RegisterCommand(Config.Commands.REVOKE_LICENCE and Config.Commands.REVOKE_LICENCE or 'revoke_licence', function(source, args, rawCommand)
    local playerId = source
    local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
    if not state then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_ACCESS"), "error")
    end
    local target = tonumber(args[1])
    if not target then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_NIL"), "error")
    end
    local targetPed = GetPlayerPed(target)
    if not DoesEntityExist(targetPed) then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_OFFLINE"), "error")
    end
    if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance) then
        return Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
    end
    local license = args[2]
    RemovePlayerLicense(playerId, target, license)
end, false)
RegisterCommand(Config.Commands.PRESET_CREATOR and Config.Commands.PRESET_CREATOR or 'preset_creator', function(source, args, rawCommand)
    local playerId = source
    if not Framework.isAdmin(playerId) then
        return Framework.sendNotification(playerId, _U('PRESET_CREATOR.NOT_ENOUGH_PERMISSION'))
    end
    StartClient(source, 'PresetCreator')
end, false)
RegisterCommand(Config.Commands.PANIC_BUTTON or 'panic_button', function(source, args, rawCommand)
    local playerId = source
    local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
    if not playerData then
        return
    end
    if not Config.PanicButton.EnableCommand then
        return
    end
    if Config.PanicButton.NeedItem then
        if not InventoryService.hasItem(playerData, Config.PanicButton.NeedItemName) then
            Framework.sendNotification(playerId, _U("YOU_DONT_HAVE_ITEM_IN_YOUR_INVENTORY", Config.PanicButton.NeedItemName), "error")
            return
        end
    end
    EmergencyCall(playerData)
end, false)
RegisterCommand(Config.Commands.FREE_PLAYER or 'freePlayer', function(source, args, rawCommand)
    local playerId = source
    if not Config.ChatCommands["freePlayer"] then
        return
    end
    if not Framework.isAdmin(playerId) then
        return Framework.sendNotification(playerId, _U("ACTION_REQUIRE_ADMIN_RIGHTS"), "error")
    end
    local target = tonumber(args[1])
    if not target then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_NIL"), "error")
    end
    local targetPed = GetPlayerPed(target)
    if not DoesEntityExist(targetPed) then
        return Framework.sendNotification(playerId, _U("HELP_MESSAGES.NO_TARGET_OFFLINE"), "error")
    end
    if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance) then
        return Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
    end
    ActionService.ForceUncuff(target)
end, false)
if Config.EnableInteractCommandsForAll and Config.EnableInteractCommandsForAll then
	RegisterCommand(Config.Commands.SEARCH_PLAYER and Config.Commands.SEARCH_PLAYER or 'search', function(source, args, rawCommand)
		local playerId = source
		if not playerId then
			return
		end
        if isResourcePresentProvideless(Society.JOBS_CREATOR) then
            dbg.critical("Conflict detected: 'job_creator' has a built-in '/search' command that overlaps with ours./ To avoid unexpected behavior, please use 'target' or 'radial_menu' instead, or integrate its search via our API.")
            return 
        end
		ActionService.SearchPlayer(playerId)
	end, false)
    RegisterCommand(Config.Commands.SEARCH_PLAYER_QB and Config.Commands.SEARCH_PLAYER_QB or 'rob', function(source, args, rawCommand)
		local playerId = source
		if not playerId then
			return
		end
        if isResourcePresentProvideless(Society.JOBS_CREATOR) then
            dbg.critical("Conflict detected: 'job_creator' has a built-in '/rob' command that overlaps with ours./ To avoid unexpected behavior, please use 'target' or 'radial_menu' instead, or integrate its search via our API.")
            return 
        end
		ActionService.SearchPlayer(playerId)
	end, false)
	RegisterCommand(Config.Commands.ESCORT_PLAYER and Config.Commands.ESCORT_PLAYER or 'escort', function(source, args, rawCommand)
		local playerId = source
		if not playerId then
			return
		end
		ActionService.Escort(playerId)
	end, false)
	RegisterCommand(Config.Commands.PUT_PLAYER_IN_VEH and Config.Commands.PUT_PLAYER_IN_VEH or 'put_in_veh', function(source, args, rawCommand)
		local playerId = source
		if not playerId then
			return
		end
		ActionService.PutPlayerInVehicle(playerId)
	end, false)
	RegisterCommand(Config.Commands.GET_PLAYER_FROM_VEH and Config.Commands.GET_PLAYER_FROM_VEH or 'get_from_veh', function(source, args, rawCommand)
		local playerId = source
		if not playerId then
			return
		end
		ActionService.TakePlayerFromVehicle(playerId)
	end, false)
end
