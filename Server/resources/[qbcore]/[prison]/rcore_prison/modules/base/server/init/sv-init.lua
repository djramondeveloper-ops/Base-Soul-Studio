PrisonService = nil
ChatService = nil

Inventory = Inventory or {}
Dispatch = Dispatch or {}
PlayerLoadedPool = PlayerLoadedPool or {}
ServerItems = ServerItems or {}
RestrictZone = RestrictZone or {}

if type(Inventory.HandleOpenState) ~= 'function' then
    Inventory.HandleOpenState = function(playerId, state)
        if not playerId then
            return false
        end

        local ok, ply = pcall(Player, playerId)
        if not ok or not ply then
            return false
        end

        if isResourcePresentProvideless and Inventories and isResourcePresentProvideless(Inventories.OX) then
            ply.state:set('invBusy', state, true)
        elseif Config and Framework and Config.Framework == Framework.QBCore then
            ply.state:set('inv_busy', state, true)
        end

        return true
    end
end

local MISSING_ASSET_WARNING = [[^3============================================================^7
^3[rcore_prison_assets - Missing Dependency]^7
------------------------------------------------------------
- Resource: ^5rcore_prison_assets^7 is ^1missing^7.
- This is a required ^2support asset^7 for the Prison Break module to work properly (^1not an MLO^7).
- The asset is already included inside ^5[prison]/rcore_prison_assets^7.
➝ If missing, you may have accidentally removed it from the package — please re-download it from your Portal to restore it.

⚠️ Without this asset, the Prison Break feature and other functionality will not work correctly.
------------------------------------------------------------
^3============================================================^7
]]

local WASABI_NO_JAIL_WARNING = [[^3============================================================^7
^3[Wasabi Police - Configuration Warning]^7
------------------------------------------------------------
- File: wasabi_police/game/configuration/config.lua
- No jail system has been defined in your configuration.

⚠️  To use Wasabi Police with ^5rcore jail^7:
   • Set ^5Config.Jail.jail = "rcore"^7
   • Set ^5Config.Jail.BuiltInPrison.enabled = false^7
------------------------------------------------------------
^3============================================================^7
]]

local WASABI_BUILTIN_WARNING = [[^3============================================================^7
^3[Wasabi Police - Configuration Warning]^7
------------------------------------------------------------
- File: wasabi_police/game/configuration/config.lua
- You have enabled ^5rcore jail integration^7.
- But ^5Config.Jail.BuiltInPrison.enabled^7 is ^1true^7.
   - This causes conflicts with rcore jail.
   ➝ Change it to ^2false^7 in your config.

⚠️  This would cause that jailing will go through wasabi builtin prison system.
------------------------------------------------------------
^3============================================================^7
]]

CreateThread(function()
    local timeoutAt = GetGameTimer() + 10000

    while GetGameTimer() < timeoutAt do
        if Object and Object.getService and Object.getService(SERVICE_PRISONER) and Object.getService(SERVICE_CHAT) then
            break
        end

        Wait(50)
    end

    PrisonService = Object and Object.getService and Object.getService(SERVICE_PRISONER) or nil
    if not PrisonService then
        if dbg and dbg.critical then
            dbg.critical('Cannot find prison service - sv-init.lua')
        end
        return
    end

    ChatService = Object.getService(SERVICE_CHAT)
    if not ChatService then
        if dbg and dbg.critical then
            dbg.critical('Cannot find chat service - sv-init.lua')
        end
        return
    end

    if not isResourcePresentProvideless('rcore_prison_assets') then
        print(MISSING_ASSET_WARNING)
    end

    if isResourceLoaded('wasabi_police') then
        local jailConfig = LoadScriptData('game/configuration/config', 'wasabi_police', 'Config.Jail')
        if jailConfig then
            local jailType = jailConfig.jail
            local builtInEnabled = jailConfig.BuiltInPrison and jailConfig.BuiltInPrison.enabled or false

            if (not jailType or jailType == '') and builtInEnabled then
                print(WASABI_NO_JAIL_WARNING)
            end

            if jailType == 'rcore' and builtInEnabled then
                print(WASABI_BUILTIN_WARNING)
            end
        end
    end
end, 'sv-init code name: Phoenix')

function LoadScriptData(scriptPath, resourceName, keyPath)
    if not isResourcePresentProvideless(resourceName) then
        return nil
    end

    local fileName = ('%s.lua'):format(scriptPath)
    local fileContent = LoadResourceFile(resourceName, fileName)
    if not fileContent then
        return nil
    end

    local environment = setmetatable({}, { __index = _G })

    local ok, chunkOrError = pcall(load, fileContent, fileName, 't', environment)
    if not ok then
        if dbg and dbg.critical then
            dbg.critical('Cannot load datafile %s with error %s', fileName, tostring(chunkOrError))
        end
        return nil
    end

    local chunk = chunkOrError
    local executed, resultOrError = pcall(chunk)
    if not executed then
        if dbg and dbg.critical then
            dbg.critical('Error loading datafile %s: %s', fileName, tostring(resultOrError))
        end
        return nil
    end

    if not keyPath then
        return environment
    end

    local current = environment
    for key in string.gmatch(keyPath, '[^%.]+') do
        if type(current) ~= 'table' or current[key] == nil then
            if dbg and dbg.critical then
                dbg.critical('Cannot find key %s in datafile %s', keyPath, fileName)
            end
            return nil
        end

        current = current[key]
    end

    return current
end

function IsAtZone(zoneId, source)
    if not zoneId then
        return false
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local interactionData = SH.data.interaction[zoneId]

    if not interactionData then
        return false
    end

    local distance = #(playerCoords - interactionData.coords)
    local checkDistance = Config.Zone.CheckDist
    local usingCustomZoneDistance = false

    if interactionData.zone and interactionData.zone.distance then
        checkDistance = interactionData.zone.distance
        usingCustomZoneDistance = true
    end

    if dbg and dbg.debug then
        dbg.debug(
            'Checking zone distance for user %s: distance %s with check distance is <= %s | Config.Zone.CheckDist = %s',
            GetPlayerName(source),
            distance,
            checkDistance,
            not usingCustomZoneDistance
        )
    end

    return distance <= checkDistance
end
