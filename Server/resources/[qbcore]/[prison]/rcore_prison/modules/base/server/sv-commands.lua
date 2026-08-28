local stateCommands = Config.StateCommands
local enforceAllCommands = false

if not stateCommands or (type(stateCommands) == "table" and not next(stateCommands)) then
    enforceAllCommands = true
    dbg.critical("Failed to load Config.StateCommands, seems not defined enforcing all commands be useable!")
end

local function isCommandEnabled(commandName)
    return enforceAllCommands or (stateCommands and next(stateCommands) and stateCommands[commandName])
end

local function notifyNoPermission(playerId, reason)
    Framework.sendNotification(playerId, _U("PERMISSION.GENERAL_MESSAGE", reason), "error")
    dbg.info("Cannot perform this command - you are not job member!", playerId)
end

local function ensureJobCommandAccess(playerId, commandName)
    local state, reason = Framework.canPerformJobCommand(playerId, commandName)
    if state then
        return true
    end

    notifyNoPermission(playerId, reason)
    return false
end

local function ensureAdminAccess(playerId)
    if Framework.isAdmin(playerId) then
        return true
    end

    Framework.sendNotification(playerId, _U("GENERAL.YOU_NEED_TO_BE_ADMIN"), "error")
    dbg.info("Cannot perform this command - you are not admin!", playerId)
    return false
end

local function ensureDatabaseReady(playerId)
    if IS_DATABASE_READY then
        return true
    end

    Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.RESOURCE_LOADING"), "error")
    return false
end

local function getTargetPlayerOrNotify(playerId, value)
    local targetPlayerId = GetPlayerByIdOrName(value)
    if targetPlayerId then
        return targetPlayerId
    end

    dbg.info("Cannot find player from value %s", value)
    Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.INVALID_PLAYER_ID"), "error")
    return nil
end

local function ensurePositiveTime(playerId, rawValue)
    local amount = tonumber(rawValue)

    if not amount then
        dbg.info("Cannot parse jail time %s", rawValue)
        Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.INVALID_JAIL_TIME"), "error")
        return nil
    end

    if amount <= 0 then
        Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.INVALID_JAIL_TIME_VALUE"), "error")
        return nil
    end

    return amount
end

local function ensureCommandDistance(playerId, targetPlayerId)
    if not Config.RestrictCommandsForDistance then
        return true
    end

    local myPed = GetPlayerPed(playerId)
    local targetPed = GetPlayerPed(targetPlayerId)
    local myCoords = GetEntityCoords(myPed)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(myCoords - targetCoords)

    if distance <= Config.RestrictDistance then
        return true
    end

    Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.TOO_FAR_AWAY"), "error")
    return false
end

if isCommandEnabled(Config.Commands.JailCP) then
    RegisterCommand(Config.Commands.JailCP, function(source)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.JailCP) then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        if CheckRestrictionZone(playerId, Config.Commands.JailCP) then
            StartClient(playerId, "openMDW", true)
        end
    end, false)
end

if isCommandEnabled(Config.Commands.StopAlarm) then
    RegisterCommand(Config.Commands.StopAlarm, function(source)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.StopAlarm) then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        HandleAlarm(false)
    end, false)
end

if isCommandEnabled(Config.Commands.Startcs) then
    RegisterCommand(Config.Commands.Startcs, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.Startcs) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        local perollAmount = ensurePositiveTime(playerId, args[2])
        if not perollAmount then
            return
        end

        local reason = args[3] and tostring(args[3]) or "none"

        if PrisonService.CheckForAnySentence(targetPlayerId) then
            Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.PLAYER_ALREADY_HAS_SENTENCE"), "error")
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        if not ensureCommandDistance(playerId, targetPlayerId) then
            return
        end

        COMSService.StartPerollForCitizen(playerId, targetPlayerId, perollAmount, reason)
    end, false)
end

if isCommandEnabled(Config.Commands.Jail) then
    RegisterCommand(Config.Commands.Jail, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.Jail) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        local jailTime = ensurePositiveTime(playerId, args[2])
        if not jailTime then
            return
        end

        local reason = args[3] and tostring(args[3]) or "none"

        if COMSService.CheckForAnySentence(targetPlayerId) then
            Framework.sendNotification(playerId, _U("COMMANDS_MESSAGES.PLAYER_ALREADY_HAS_SENTENCE"), "error")
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        if not ensureCommandDistance(playerId, targetPlayerId) then
            return
        end

        if CheckRestrictionZone(playerId, Config.Commands.Jail) then
            PrisonService.JailCitizen(playerId, targetPlayerId, jailTime, reason)
        end
    end, false)
end

if isCommandEnabled(Config.Commands.Unjail) then
    RegisterCommand(Config.Commands.Unjail, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.Unjail) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        if not ensureCommandDistance(playerId, targetPlayerId) then
            return
        end

        if CheckRestrictionZone(playerId, Config.Commands.Unjail) then
            PrisonService.UnjailCitizen(targetPlayerId, true)
        end
    end, false)
end

if isCommandEnabled(Config.Commands.Solitary) then
    RegisterCommand(Config.Commands.Solitary, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.Solitary) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        local jailTime = ensurePositiveTime(playerId, args[2])
        if not jailTime then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        SolitaryService.SetPrisonerSentence(targetPlayerId, jailTime, "-", playerId)
    end, false)
end

if isCommandEnabled(Config.Commands.RemoveSolitary) then
    RegisterCommand(Config.Commands.RemoveSolitary, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.RemoveSolitary) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        SolitaryService.ReleasePrisoner(targetPlayerId)
    end, false)
end

if isCommandEnabled(Config.Commands.Removecs) then
    RegisterCommand(Config.Commands.Removecs, function(source, args)
        local playerId = source

        if not ensureJobCommandAccess(playerId, Config.Commands.Removecs) then
            return
        end

        local targetPlayerId = getTargetPlayerOrNotify(playerId, args[1])
        if not targetPlayerId then
            return
        end

        if not ensureDatabaseReady(playerId) then
            return
        end

        if not ensureCommandDistance(playerId, targetPlayerId) then
            return
        end

        COMSService.ReleaseUser(targetPlayerId, playerId)
    end, false)
end

if isCommandEnabled(Config.Commands.ResetPrisonBreak) then
    RegisterCommand(Config.Commands.ResetPrisonBreak, function(source)
        local playerId = source

        if not ensureAdminAccess(playerId) then
            return
        end

        PrisonBreakReset(playerId, false)
    end, false)
end

RegisterCommand("rcore_prison_gather_inventory_data", function(source, args)
    if source ~= 0 then
        return
    end

    local targetPlayer = tonumber(args[1])
    if not targetPlayer then
        return dbg.debug("Gather inventory data: Failed to get any data since %s is undefined", targetPlayer)
    end

    local ped = GetPlayerPed(targetPlayer)
    if not DoesEntityExist(ped) then
        dbg.debug("Gather invetory data: Failed since target player with playerId %s is offline!", targetPlayer)
        return
    end

    local playerInventory = Inventory.GatherInventoryData(targetPlayer)
    if playerInventory and next(playerInventory) then
        tprint(playerInventory)
    else
        dbg.debug("Gather inventory data: Failed to gather inventory data, its empty, using inventory named: %s", Config.Inventories)
    end
end, false)

RegisterCommand("rcore_prison_test_permissions", function(source, args)
    if source ~= 0 then
        return
    end

    local targetPlayer = tonumber(args[1])
    if not targetPlayer then
        return dbg.debug("Permissions: Failed to get any data since %s is undefined player", targetPlayer)
    end

    local ped = GetPlayerPed(targetPlayer)
    if not DoesEntityExist(ped) then
        return
    end

    local job = Framework.getJob(targetPlayer)
    if not job then
        return
    end

    local jobName = job.name
    local validJob = Config.Jobs[jobName] ~= nil
    local list = {
        player_job = jobName,
        valid_job = validJob,
        is_admin = Framework.isAdmin(targetPlayer),
        jobs = {},
    }

    if not validJob then
        list.jobs = Config.Jobs
    end

    if next(list) then
        tprint(list)
    end
end, false)

RegisterCommand("rcore_prison_test_inventory_functions", function(source, args)
    if source ~= 0 then
        return
    end

    local targetPlayer = tonumber(args[1])
    if not targetPlayer then
        return dbg.debug("Gather inventory data: Failed to get any data since %s is undefined", targetPlayer)
    end

    local targetItem = args[2] or "water"
    local ped = GetPlayerPed(targetPlayer)

    if not DoesEntityExist(ped) then
        dbg.debug("Test inventory functions: Failed since target player with playerId %s is offline!", targetPlayer)
        return
    end

    local inventory = Inventory.GatherInventoryData(targetPlayer)
    local inventoryFunctions = {
        test_against_item = targetItem,
        inventoryName = Config.Inventories,
        player = {
            playerId = targetPlayer,
            playerName = GetPlayerName(targetPlayer),
            identifier = Framework.getIdentifier(targetPlayer),
        },
        hasItem = {
            state = Inventory.hasItem(targetPlayer, targetItem, 1),
            amount = 1,
        },
        doesItemExist = {
            state = Inventory.DoesItemExist(targetPlayer, targetItem),
        },
        playerInventory = {
            data = inventory,
        },
    }

    if next(inventoryFunctions) then
        tprint(inventoryFunctions)
    end
end, false)

function GetPlayerByIdOrName(targetPlayer)
    if isNumber(targetPlayer) and GetPlayerPed(targetPlayer) > 0 then
        return tonumber(targetPlayer)
    end

    if type(targetPlayer) == "string" then
        for _, playerId in pairs(GetPlayers()) do
            local playerName = Framework.getCharacterName(playerId)
            if playerName == targetPlayer then
                return playerId
            end
        end
    end
end

function GetPlayerByCharacterId(targetCharId)
    if not targetCharId then
        return
    end

    for _, playerId in pairs(GetPlayers()) do
        playerId = tonumber(playerId)

        local charId = Framework.getIdentifier(playerId)
        if charId == targetCharId then
            return playerId
        end
    end
end
