-- =====================================================
--  rcore_police · modules/base/server/init/sv-init.lua
--  Engineered by Eazy Fxap
--  Original: 1111 lines → Cleaned: 241 lines
-- =====================================================

db = {}
spawnVehicleSessions = {}
DutyService = {}
SocietyService = {}
ImageService = {}
GarageService = {}
InventoryService = {}
GroupsService = {}
UseableItemsCooldowns = {}
UsedItemsCache = {}
EmergencyCalls = {}
RegisteredItems = {}
ServerItems = {}
AssetDeployer = createDeployer()
GlobalCache = {}

local scanAllowed = false

RegisterCommand("police_check_allow_command", function(source, args)
    if source ~= 0 then
        dbg.critical("[\n[Scanner] Access denied!\nOnly the ^1server console^7 can allow the conflict scan.\n]")
        return
    end
    scanAllowed = true
    dbg.info("[Scanner] Scan command ENABLED for this session.\n→ Run ^3police_check_conflicts^7 next to start the scan.\n\n---------------- WARNING ----------------\nThis command is ^1HEAVY^7 on the server!\nDO NOT run this on a live server or with players online!\n-----------------------------------------\n")
end, false)

RegisterCommand("police_check_conflicts", function(source, args)
    if source ~= 0 then
        dbg.critical("[\n[Scanner] Access denied!\nOnly the ^1server console^7 can start the scan.\n]")
        return
    end
    if not scanAllowed then
        dbg.critical("[\n[Scanner] Access denied!\nYou must run ^3police_check_allow_command^7 first!\nThis is a ^1heavy^7 operation.\nDO NOT use on a live server!\n]")
        return
    end
    scanAllowed = false
    dbg.info("[\n[Scanner] Starting police event scan...\n]")
    TriggerEvent("rcore_police:server:internal:startScanner", source)
end, false)

CreateThread(function()
    Wait(0)
    if AssetDeployer then
        AssetDeployer:registerDefaultCommand("policesetup")
        AssetDeployer:registerResetDeployCommand()
        AssetDeployer:setSaveDeployInCache(true)
        AssetDeployer:suggestDeploys(true)
    end
    
    if isResourcePresentProvideless(PoliceResources.ESX) then
        dbg.info("Detected %s on your server, remove it!", PoliceResources.ESX)
    end
    if isResourcePresentProvideless(PoliceResources.QB) then
        dbg.info("Detected %s on your server, remove it!", PoliceResources.QB)
    end
    if isResourcePresentProvideless(PoliceResources.QBOX) then
        dbg.info("Detected %s on your server, remove it!", PoliceResources.QBOX)
    end
    
    if Config.Inventory == Inventory.OX and Config.Framework == Framework.QBCore then
        local oxVersion = GetResourceMetadata(Inventory.OX, "version", 0)
        if oxVersion and IsVersionEqual(oxVersion, "2.41.0") then
            print("^3============================================================^7\n^3[ox_inventory | QBCore Bridge Warning]^7\n------------------------------------------------------------\n - You are running ^5ox_inventory v2.41.0^7 with QBCore.\n - The official QBCore bridge was discontinued by Ox.\n - This version has known ^3invBusy bugs^7:\n     • 17.8.2024 - server/qbx: invalid statebag access (Linden)\n     • 15.9.2024 - client: replicate invBusy state (Linden)\n     •  6.2.2025 - client/inventory: invalid statebag index (#1881, Scully)\n\n ⚠️  Because of these issues,\n     ^3Cuffing.DisableInventoryWhileCuffed^7 has been auto-disabled.\n\n ✅ Recommended solution:\n     Use the maintained community fork with QBCore support:\n     ^5https://github.com/TheOrderFivem/ox_inventory/releases/download/2.44.6/ox_inventory.zip\n------------------------------------------------------------\n^3============================================================^7\n")
        end
    end
    
    if Config.Image.AllowCameraItem then
        -- Seoul Base already ships and uses screenshot-basic (Creative MDT/EMS).
        -- Reuse the same confirmed resource instead of requiring rcore's optional screencapture dependency.
        if not isResourcePresentProvideless("screenshot-basic") then
            Config.Image.AllowCameraItem = false
            print("^3[rcore_police/Seoul]^7 Camera item disabled: resource ^5screenshot-basic^7 is not running.")
        end
    end
end)

RegisterCommand("departments", function(source, args, rawCommand)
    local groups = GroupsService.GetGroups()
    if groups and next(groups) then
        tprint(groups)
    end
end, false)

RegisterCommand("rcore_police_debug_enviroment", function(source, args, rawCommand)
    if source == 0 then
        local targetRes = args[1] or "police"
        local garageStorage = Object.getStorage(STORAGE_GARAGE)
        
        local identity = FindTargetResource and FindTargetResource("identity") or "NOT_FOUND"
        local multichar = FindTargetResource and FindTargetResource("multichar") or "NOT_FOUND"
        local fuel = FindTargetResource and FindTargetResource("fuel") or "NOT_FOUND"
        local banking = FindTargetResource and FindTargetResource("banking") or "NOT_FOUND"
        local society = FindTargetResource and FindTargetResource("society") or "NOT_FOUND"
        local target = FindTargetResource and FindTargetResource("target") or "NOT_FOUND"
        
        if ValidMapData and next(ValidMapData) then
            print("Listing active supported map presets:")
            tprint(ValidMapData)
        end
        
        local debugInfo = {}
        debugInfo.police_version = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
        
        debugInfo.third_party_search = {
            note = "Third party search has nothing with integration functionality!",
            list = {
                identity = identity,
                multichar = multichar,
                fuel = fuel,
                society = society,
                banking = banking,
                target = target
            }
        }
        
        debugInfo.garage_stock_system = {
            vehicles_in_garage = garageStorage and garageStorage.getVehicleCount(targetRes) or 0
        }
        
        local socVersion = "Undefined"
        if Config.Society and Config.Society ~= Society.NONE then
            socVersion = GetResourceMetadata(Config.Society, "version", 0) or "Undefined"
        end
        
        debugInfo.society = {
            name = Config.Society,
            version = socVersion,
            account = {
                balance = SocietyService.GetMoney(targetRes)
            }
        }
        
        debugInfo.other = {
            AutoDuty = Config.AutoDuty and "Enabled" or "Disabled",
            DutySystemState = Config.DutySystemState and "Enabled" or "Disabled"
        }
        
        debugInfo.zones = {
            [ZONE_TYPE.WEAPON_SHOP] = { state = Config.ItemShop.Enable and "Rendering zone" or "Zone disabled", variable = "Config.ItemShop.Enable" },
            [ZONE_TYPE.GARAGE_VEHICLE] = { state = Config.Garage.Enable and "Rendering zone" or "Zone disabled", variable = "Config.Garage.Enable" },
            [ZONE_TYPE.DUTY] = { state = Config.DutySystemState and "Rendering zone" or "Zone disabled", variable = "Config.DutySystemState" },
            [ZONE_TYPE.BOSS_MENU] = { state = Config.BossMenu.Enable and "Rendering zone" or "Zone disabled", variable = "Config.BossMenu.Enable" },
            [ZONE_TYPE.CLOTHING_ROOM] = { state = Config.Outfits.Enable and "Rendering zone" or "Zone disabled", variable = "Config.Outfits.Enable" },
            [ZONE_TYPE.GARAGE_AIR] = { state = Config.Garage.Enable and "Rendering zone" or "Zone disabled", variable = "Config.Garage.Enable" }
        }
        
        debugInfo.config = {
            tackle_enabled = Config.Tackle.Enable,
            job_menu_enabled = Config.JobMenu.Enable,
            radial_menu_enabled = Config.RadialMenu.Enable
        }
        
        local function getVer(val, noneVal)
            if val ~= noneVal then
                return GetResourceMetadata(val, "version", 0) or "Undefined"
            end
            return "Undefined"
        end
        
        debugInfo.integration = {
            framework = { name = Config.Framework, version = getVer(Config.Framework, Framework.NONE) },
            target = { name = Config.InteractionsTarget, version = getVer(Config.InteractionsTarget, InteractionsTarget.NONE) },
            inventory = { name = Config.Inventory, version = getVer(Config.Inventory, Inventory.NONE) },
            society = { name = Config.Society or "Undefined society", version = Config.Society and getVer(Config.Society, Society.NONE) or "Undefined" },
            keys = { name = Config.Keys, version = getVer(Config.Keys, Keys.NONE) },
            garage = { name = Config.Garages, version = getVer(Config.Garages, Garages.NONE) },
            invoices = { name = Config.Invoices, version = getVer(Config.Invoices, Invoices.NONE) },
            prison = { name = Config.Prison, version = getVer(Config.Prison, Prison.NONE) },
            pg = { name = Config.PG, version = getVer(Config.PG, Garages.NONE) },
            fuel = { name = Config.Fuel, version = getVer(Config.Fuel, Fuel.NONE) },
            licence = { name = Config.Licence, version = getVer(Config.Licence, Licence.NONE) },
            menu = { name = Config.Menu, version = getVer(Config.Menu, Menu.NONE) },
            notify = { name = Config.Notify, version = getVer(Config.Notify, Notify.NONE) },
            mdt = { name = Config.MDT, version = getVer(Config.MDT, MDT.NONE) },
            textui = { name = Config.TextUI, version = getVer(Config.TextUI, TextUI.NONE) },
            dispatch = { name = Config.Dispatch, version = getVer(Config.Dispatch, Dispatch.NONE) },
            duty = { name = Config.Duty, version = getVer(Config.Duty, Duty.NONE) }
        }
        
        if type(debugInfo) == "table" and next(debugInfo) then
            print("Showing police enviroment data:")
            tprint(debugInfo)
        end
    end
end, false)

RegisterCommand("rcore_police_inventory_test_search_self", function(source, args, rawCommand)
    if Framework.isAdmin(source) then
        StartClient(source, "InventoryTestSearch", tonumber(args[1]))
    end
end, false)

RegisterCommand("rcore_police_inventory_test_stash_self", function(source, args, rawCommand)
    if Framework.isAdmin(source) then
        if InventoryService.RunTestStash then
            InventoryService.RunTestStash(source)
        else
            dbg.critical("Stash test doesnt exist for inventory named: %s", Config.Inventory)
        end
    end
end, false)

RegisterCommand("rcore_police_test_admin", function(source, args, rawCommand)
    if source == 0 then return end
    
    local isStandalone = (Config.Framework == Framework.NONE)
    local aceLib = false
    
    if isStandalone then
        if Ace.Can(source, Permissions.HAS_SERVER_GROUP) then
            aceLib = true
        end
    end
    
    local info = {
        isAdmin = Framework.isAdmin(source),
        playerGroup = isStandalone and Framework.getPlayerGroup and Framework.getPlayerGroup(source) or "This is only for standalone servers",
        playerAceNative = IsPlayerAceAllowed(source, "command") and true or false,
        playerAceLib = aceLib,
        notes = not isStandalone and "playerAceLib server-group check only runs on standalone (Framework.NONE)." or nil
    }
    
    if type(info) == "table" and next(info) then
        dbg.info("Showing informations about your admin permissions")
        tprint(info)
    end
end, false)
