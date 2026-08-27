-- ============================================================
-- nn_petshop | main.lua | CLIENT SCRIPT
-- FiveM Pet Shop resource — client-side logic.
--
-- Handles: map blip, notifications, shop/spawn/treat-shop NUI,
-- pet spawning, accessories, stat decay (obedience/thirst/hunger),
-- control panel, attack/follow/move commands, sit/bark animations,
-- and a developer accessory-positioning tool.
--
-- Framework:   Seoul vRP/Creative adapter on server side
-- Target sys:  interact first, ox_target fallback
-- Notification: ox_lib (falls back to print)
-- ============================================================


-- ===================== MAP BLIP ===========================
-- Spawns the Pet Shop map blip once when the resource starts.
CreateThread(function()
    local blip = AddBlipForCoord(Config.ShopCoords.x, Config.ShopCoords.y, Config.ShopCoords.z)
    SetBlipSprite(blip, 141)          -- Shopping bag icon
    SetBlipDisplay(blip, 4)           -- Show on minimap
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)            -- Green
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Petshop")
    EndTextCommandSetBlipName(blip)
end)


-- ===================== NOTIFICATION =======================
--- Shows a notification via ox_lib, or falls back to print().
--- @param message  string  Text to display.
--- @param notifType  string|nil  "success"|"error"|"info"|"primary". Defaults to "info".
local function notify(message, notifType)
    if Config.NotificationsEnabled == false then return end

    notifType = notifType or "primary"
    if notifType == "primary" then notifType = "info" end

    if GetResourceState("ox_lib") == "started" then
        pcall(function()
            exports.ox_lib:notify({
                title       = "Pet Shop",
                description = message,
                type        = notifType,
                duration    = 4000,
            })
        end)
        return
    end

    -- Fallback when ox_lib is not available
    print("[nn_petshop] " .. message)
end


-- ===================== CATALOG ============================
--- Builds and returns the pet catalog table from Config.
--- Consumed by the NUI frontend to render the shop grid.
--- @return table  { cats, dogs, clothing }
local function getCatalog()
    return {
        cats     = Config.Cats or {},
        dogs     = Config.Dogs,
        clothing = Config.Clothing,
    }
end


-- =================== INPUT CONTROL =======================
--- Blocks the ESC / menu-open controls for a fixed number of frames.
--- Called after closing a NUI panel so the ESC keypress that closed it
--- cannot immediately trigger an in-game menu.
--- @param frameCount  number|nil  Frames to block (default 22).
local function blockMenuControlsFor(frameCount)
    if not frameCount then frameCount = 22 end
    CreateThread(function()
        for _ = 1, frameCount do
            Wait(0)
            DisableControlAction(0, 199, true)  -- F3 / Open interaction menu
            DisableControlAction(0, 200, true)  -- Back
            DisableControlAction(0, 322, true)  -- ESC
        end
    end)
end


-- ===================== MENU STATE =========================
-- Tracks whether the main shop / spawn NUI panel is currently open
-- and whether a close-listener thread is already running.
local isMenuClosing          = false  -- Used as a cross-thread signal to stop aiming loops
local isMenuOpen             = false  -- True while the shop/spawn NUI is focused
local menuCloseThreadRunning = false  -- Prevents spawning duplicate ESC-listener threads

--- Signals any aiming/control loops to stop (used as a shared abort flag).
local function signalMenuClosing()
    isMenuClosing = true
end

--- Releases the NUI keyboard/cursor capture without touching NUI visibility.
local function releaseMenuInputFocus()
    isMenuOpen = false
end

--- Ensures exactly one ESC-listener thread runs while the NUI is open.
--- When ESC is pressed: signals closing, removes NUI focus, re-blocks controls briefly.
local function startMenuCloseListener()
    releaseMenuInputFocus()
    isMenuOpen = true
    if menuCloseThreadRunning then return end
    menuCloseThreadRunning = true

    CreateThread(function()
        while true do
            if not isMenuOpen then break end
            Wait(0)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 322) then
                isMenuOpen = false
                signalMenuClosing()
                SetNuiFocus(false, false)
                blockMenuControlsFor()
                break
            end
        end
        menuCloseThreadRunning = false
    end)
end


-- =================== SPAWN UI STATE ======================
local isSpawnUiOpen             = false
local spawnUiCloseThreadRunning = false
local dogFollowActive           = false

local function setSpawnUiClosed()
    isSpawnUiOpen = false
end

--- Fully closes the shop/spawn NUI and resets all focus state.
local function closeAllUi()
    isSpawnUiOpen = false
    releaseMenuInputFocus()
    signalMenuClosing()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "setVisible", data = false })
    blockMenuControlsFor()
end

--- Like startMenuCloseListener but for the spawn/shop UI.
--- When ESC is pressed it calls closeAllUi() instead.
local function startSpawnUiCloseListener()
    isSpawnUiOpen = true
    if spawnUiCloseThreadRunning then return end
    spawnUiCloseThreadRunning = true

    CreateThread(function()
        while true do
            if not isSpawnUiOpen then break end
            Wait(0)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 322) then
                closeAllUi()
                break
            end
        end
        spawnUiCloseThreadRunning = false
    end)
end


-- =================== SHOP UI OPEN ========================
--- Opens the main Pet Shop (buy pets / clothing) NUI.
--- @param purchasedData  table|nil  { dogs, cats, clothing } already owned.
local function openShopUi(purchasedData)
    local playerMoney = {}   -- Placeholder: money data comes from server event in production
    local playerLevel = 1

    local purchasedDogs     = (purchasedData and purchasedData.dogs)     or {}
    local purchasedCats     = (purchasedData and purchasedData.cats)     or {}
    local purchasedClothing = (purchasedData and purchasedData.clothing) or {}

    releaseMenuInputFocus()
    SetNuiFocus(true, true)

    -- Tell the NUI to show itself in "shop" mode
    SendNUIMessage({
        action = "setVisible",
        data   = {
            visible           = true,
            uiMode            = "shop",
            purchasedDogs     = purchasedDogs,
            purchasedCats     = purchasedCats,
            purchasedClothing = purchasedClothing,
        },
    })

    -- Sync the dog-follow toggle state
    SendNUIMessage({ action = "setFollowState", data = dogFollowActive })

    -- Send the full catalog and player info
    SendNUIMessage({
        action = "openCatalog",
        data   = {
            catalog           = getCatalog(),
            uiMode            = "shop",
            player            = {
                level = playerLevel,
                bank  = playerMoney.bank or 0,
                cash  = playerMoney.cash or 0,
            },
            purchasedDogs     = purchasedDogs,
            purchasedCats     = purchasedCats,
            purchasedClothing = purchasedClothing,
        },
    })

    startSpawnUiCloseListener()
end

--- Opens the Pet Spawn UI (spawn / despawn already-purchased pets).
--- @param purchasedData  table|nil  { dogs, cats, clothing } already owned.
local function openSpawnUi(purchasedData)
    local playerMoney = {}
    local playerLevel = 1

    local purchasedDogs     = (purchasedData and purchasedData.dogs)     or {}
    local purchasedCats     = (purchasedData and purchasedData.cats)     or {}
    local purchasedClothing = (purchasedData and purchasedData.clothing) or {}

    releaseMenuInputFocus()
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = "setVisible",
        data   = {
            visible           = true,
            uiMode            = "spawnDogs",
            purchasedDogs     = purchasedDogs,
            purchasedCats     = purchasedCats,
            purchasedClothing = purchasedClothing,
        },
    })

    SendNUIMessage({ action = "setFollowState", data = dogFollowActive })

    SendNUIMessage({
        action = "openCatalog",
        data   = {
            catalog           = getCatalog(),
            uiMode            = "spawnDogs",
            player            = {
                level = playerLevel,
                bank  = playerMoney.bank or 0,
                cash  = playerMoney.cash or 0,
            },
            purchasedDogs     = purchasedDogs,
            purchasedCats     = purchasedCats,
            purchasedClothing = purchasedClothing,
        },
    })

    startSpawnUiCloseListener()
end


-- ==================== SHOP TRIGGER ========================
--- Asks the server to reply with this player's purchased pets,
--- which triggers the "receivedPurchased" event and opens the shop UI.
local function requestShopOpen()
    TriggerServerEvent("nn_petshop:server:requestPurchased")
end

-- Server sends purchased data back → open the shop
RegisterNetEvent("nn_petshop:client:receivedPurchased", function(purchasedData)
    openShopUi(purchasedData)
end)

-- Server sends purchased data back → open the spawn UI
RegisterNetEvent("nn_petshop:client:receivedPurchasedForSpawn", function(purchasedData)
    openSpawnUi(purchasedData)
end)


-- ====================== SHORTCUTS =========================
-- Each shortcut flag is false when explicitly disabled in Config.Shortcuts,
-- true (or truthy) otherwise — using ~= false rather than == true so that
-- nil (key absent) is treated as enabled.
local Shortcuts = Config.Shortcuts or {}
local shortcutPetshopCommand      = Shortcuts.petshopCommand      ~= false
local shortcutSpawnCommand        = Shortcuts.spawnCommand        ~= false
local shortcutSpawnKeybind        = Shortcuts.spawnKeybind        ~= false
local shortcutSpawnAliasDogspawn  = Shortcuts.spawnAliasDogspawn  ~= false
local shortcutTreatshopCommand    = Shortcuts.treatshopCommand    ~= false
local shortcutControlCommand      = Shortcuts.controlCommand      ~= false
local shortcutControlKeybind      = Shortcuts.controlKeybind      ~= false
local shortcutControlAliasDefault = Shortcuts.controlAliasDefault ~= false

-- /petshop — opens the buy UI
if shortcutPetshopCommand then
    RegisterCommand("petshop", function() requestShopOpen() end, false)
end

--- Triggers the server to send purchased data for the spawn UI.
local function requestSpawnUiOpen()
    TriggerServerEvent("nn_petshop:server:requestPurchasedSpawn")
end

-- Resolve configurable spawn command name and default keybind
local spawnCommandName = (Config.SpawnUiCommand  and tostring(Config.SpawnUiCommand):lower())  or "dogspawn"
local spawnDefaultKey  = (Config.SpawnUiDefaultKey and tostring(Config.SpawnUiDefaultKey):lower()) or "o"

if shortcutSpawnCommand then
    RegisterCommand(spawnCommandName, function() requestSpawnUiOpen() end, false)
end

-- Always register "dogspawn" as an alias when the custom name differs
if shortcutSpawnCommand and shortcutSpawnAliasDogspawn and "dogspawn" ~= spawnCommandName then
    RegisterCommand("dogspawn", function() requestSpawnUiOpen() end, false)
end

if shortcutSpawnCommand and shortcutSpawnKeybind then
    RegisterKeyMapping(spawnCommandName, "Open Pet Spawn UI", "keyboard", spawnDefaultKey)
end


-- ===================== TREAT SHOP =========================
local treatShopOpen = false  -- True while the treat shop NUI is focused

--- Opens the treat shop NUI and blocks ESC until it is closed.
local function openTreatShop()
    treatShopOpen = true
    releaseMenuInputFocus()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openTreatShop", data = true })

    CreateThread(function()
        while true do
            if not treatShopOpen then break end
            Wait(0)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 322) then
                treatShopOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "closeTreatShopFromClient", data = true })
                blockMenuControlsFor()
                break
            end
        end
    end)
end

if shortcutTreatshopCommand then
    RegisterCommand("treatshop", function() openTreatShop() end, false)
end


-- ===================== PET STATE ==========================
-- These upvalues hold the complete runtime state of the player's active pet.

local spawnedPetCardIndex = 0      -- 0-based card index shown highlighted in the spawn UI
local spawnedPetEntity    = nil    -- GTA ped entity handle for the active pet
local accessoryEntity     = nil    -- Prop entity handle for the equipped accessory
local currentAccessoryId  = nil    -- Config key of the currently equipped accessory
dogFollowActive           = false  -- Whether TaskFollowToOffsetOfEntity is active
local spawnedDogId        = nil    -- Purchased dog ID (key in player's saved dogs, dogs only)
local petSpawnInProgress  = false  -- Prevents concurrent spawn requests from creating duplicate pets
local petCooldowns        = {}     -- { [petId] = GetGameTimer() expiry } post-death cooldowns
local savedPetStats       = {}     -- { [petId] = {obedience,thirst,hunger} } persisted per-session


-- ===================== PET STATS ==========================
local obedienceLevel = (Config.Obedience and Config.Obedience.startValue) or 100
local thirstLevel    = 100
local hungerLevel    = 100
local statDecayThread = nil  -- Thread coroutine handle; nil when no pet is active
local onPetDeath      = nil  -- Forward-declared callback; assigned after handlePetDeath is defined
local isCatModel      = nil  -- Forward-declared; assigned after checkIsCatModel is defined

-- NUI sync helpers -----------------------------------------

--- Pushes the current obedience value to the HUD.
local function syncObedienceToUi()
    SendNUIMessage({ action = "setObedience", data = math.floor(obedienceLevel) })
end

--- Pushes the current thirst value to the HUD.
local function syncThirstToUi()
    SendNUIMessage({ action = "setThirst", data = math.floor(thirstLevel) })
end

--- Pushes the current hunger value to the HUD.
local function syncHungerToUi()
    SendNUIMessage({ action = "setHunger", data = math.floor(hungerLevel) })
end

-- Decay thread ---------------------------------------------

--- Starts the per-second stat decay thread if one is not already running.
--- Decays obedience, thirst, and hunger every second while a pet exists.
--- For dogs: triggers handlePetDeath() when thirst or hunger hits zero.
local function startStatDecayThread()
    if statDecayThread then return end

    local thread = CreateThread(function()
        local obedienceDecay = (Config.Obedience and Config.Obedience.decayPerSecond) or 0.5
        local thirstDecay    = (Config.Thirst    and Config.Thirst.decayPerSecond)    or 0.15
        local hungerDecay    = (Config.Hunger    and Config.Hunger.decayPerSecond)    or 0.1

        while true do
            -- Exit if the pet entity has gone away
            if not spawnedPetEntity              then break end
            if not DoesEntityExist(spawnedPetEntity) then break end

            Wait(1000)

            if obedienceLevel > 0 then
                obedienceLevel = math.max(0, obedienceLevel - obedienceDecay)
                syncObedienceToUi()
            end

            if thirstLevel > 0 then
                thirstLevel = math.max(0, thirstLevel - thirstDecay)
                syncThirstToUi()
            end

            if hungerLevel > 0 then
                hungerLevel = math.max(0, hungerLevel - hungerDecay)
                syncHungerToUi()
            end

            -- Dogs die from starvation/dehydration; cats do not
            if spawnedDogId then
                if thirstLevel <= 0 or hungerLevel <= 0 then
                    onPetDeath()
                end
            end
        end

        statDecayThread = nil
    end)

    statDecayThread = thread
end

--- Clears the thread handle so it can be restarted on next spawn.
local function clearStatDecayThread()
    statDecayThread = nil
end

--- Resets obedience to the configured starting value and syncs to HUD.
local function resetObedience()
    obedienceLevel = (Config.Obedience and Config.Obedience.startValue) or 100
    syncObedienceToUi()
end

--- Resets thirst and hunger to their configured starting values and syncs to HUD.
local function resetThirstAndHunger()
    thirstLevel = (Config.Thirst  and Config.Thirst.startValue)  or 100
    hungerLevel = (Config.Hunger  and Config.Hunger.startValue) or 100
    syncThirstToUi()
    syncHungerToUi()
end

--- Returns true if the pet's obedience is high enough to follow commands.
--- Uses Config.Obedience.minToObey (default 20) as the threshold.
--- @return boolean
local function isPetObedient()
    if obedienceLevel <= 0 then return false end
    local minObedience = (Config.Obedience and Config.Obedience.minToObey) or 20
    return minObedience <= obedienceLevel
end

--- Locally gives the pet a treat (boosts obedience without server involvement).
--- The server route (nn_petshop:server:giveTreatToDog) validates item ownership first;
--- this function is used for the simple "give treat" button that bypasses item cost.
--- @return boolean  true on success, false if no pet is spawned.
local function giveTreat()
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return false
    end
    local boost = (Config.Obedience and Config.Obedience.treatBoost) or 25
    obedienceLevel = math.min(100, obedienceLevel + boost)
    syncObedienceToUi()
    notify("Seu pet adorou o petisco!", "success")
    return true
end

--- Applies a numeric obedience boost (from a server event).
--- @param amount  number
local function applyObedienceBoost(amount)
    if not amount or type(amount) ~= "number" then return end
    obedienceLevel = math.min(100, obedienceLevel + amount)
    syncObedienceToUi()
end

-- Treat boost from server (item-cost path)
RegisterNetEvent("nn_petshop:client:applyTreatBoost", function(amount)
    applyObedienceBoost(amount)
end)

--- Applies treat effects delivered by the server after validating the item.
--- Adjusts obedience, hunger, and thirst all at once.
--- @param effectData  table  { obedienceBoost, hunger, thirst }
RegisterNetEvent("nn_petshop:client:applyTreatEffects", function(effectData)
    if type(effectData) ~= "table" then return end

    local obedienceBoost = tonumber(effectData.obedienceBoost) or 0
    local hungerBoost    = tonumber(effectData.hunger)         or 0
    local thirstBoost    = tonumber(effectData.thirst)         or 0

    if obedienceBoost ~= 0 then
        obedienceLevel = math.max(0, math.min(100, obedienceLevel + obedienceBoost))
        syncObedienceToUi()
    end
    if hungerBoost ~= 0 then
        hungerLevel = math.max(0, math.min(100, hungerLevel + hungerBoost))
        syncHungerToUi()
    end
    if thirstBoost ~= 0 then
        thirstLevel = math.max(0, math.min(100, thirstLevel + thirstBoost))
        syncThirstToUi()
    end
end)


-- ====================== TARGET MODULE =====================
-- Target adapter exposes the module selected for this base.
-- We load it 1 second after resource start to allow cb to initialise.
local targetModule = nil

CreateThread(function()
    Wait(1000)
    if GetNnPetshopTargetModule then
        targetModule = GetNnPetshopTargetModule()
    end
end)


-- =================== TARGET HELPERS =======================
--- Normalises a raw options config table into the format expected by the bridge target module.
--- @param optionsConfig  table  { options = {...}, distance = number }
--- @param defaultZoneName  string  Used as prefix for auto-generated option names.
--- @return table  Normalised list of option entries.
local function buildTargetOptions(optionsConfig, defaultZoneName)
    if not defaultZoneName then defaultZoneName = "nn_petshop" end
    local defaultDistance = tonumber(optionsConfig.distance) or 2.5
    local result = {}

    for i, option in ipairs(optionsConfig.options or {}) do
        if option.label and option.action then
            local entry = {
                name        = option.name or (defaultZoneName .. "_opt_" .. tostring(i)),
                icon        = option.icon or "fas fa-circle",
                label       = option.label,
                action      = option.action,
                canInteract = option.canInteract,
                distance    = tonumber(option.distance) or defaultDistance,
            }
            result[#result + 1] = entry
        end
    end

    return result
end

--- Resolves a plain entity number or a table-wrapped { entity = N } into a bare entity handle.
--- Some target systems pass the entity wrapped in a table.
--- @param entityOrTable  number|table
--- @return number  Entity handle.
local function resolveEntity(entityOrTable)
    if type(entityOrTable) == "table" and entityOrTable.entity ~= nil then
        return entityOrTable.entity
    end
    return entityOrTable
end

--- Registers a local-entity target interaction on the given entity using the bridge module.
--- @param entity  number
--- @param optionsConfig  table  { options, distance }
local function addEntityTarget(entity, optionsConfig)
    if not targetModule or not entity or entity == 0 then return end
    if not DoesEntityExist(entity)          then return end
    if not targetModule.AddLocalEntity     then return end
    targetModule.AddLocalEntity(entity, buildTargetOptions(optionsConfig, "nn_petshop_pet"))
end

--- Removes local-entity target interactions from the given entity.
--- Tries all supported target systems via pcall so only the active one fires.
--- @param entity  number
local function removeEntityTarget(entity)
    if not entity or entity == 0            then return end
    if not DoesEntityExist(entity)          then return end

    -- Target module (PascalCase variant)
    pcall(function()
        if targetModule and targetModule.RemoveLocalEntity then
            targetModule.RemoveLocalEntity(entity)
        end
    end)

    -- Target module (camelCase variant, seen in some versions)
    pcall(function()
        if targetModule and type(targetModule.removeLocalEntity) == "function" then
            targetModule.removeLocalEntity(entity)
        end
    end)

    -- qb-target v1
    pcall(function() exports["qb-target"]:RemoveTargetEntity(entity) end)

    -- qb-target v2
    pcall(function() exports["qb-target"]:RemoveEntity(entity) end)

    -- ox_target
    pcall(function() exports.ox_target:removeLocalEntity(entity) end)
end

--- Adds a box zone via the bridge module.
--- @param zoneName  string
--- @param coords  vector3
--- @param width  number
--- @param depth  number
--- @param zoneOptions  table  { heading, minZ, maxZ }
--- @param targetOptions  table  { options, distance }
local function addBoxZone(zoneName, coords, width, depth, zoneOptions, targetOptions)
    if not targetModule or not targetModule.AddBoxZone then return end

    local minZ    = zoneOptions.minZ or (coords.z - 1)
    local maxZ    = zoneOptions.maxZ or (coords.z + 1)
    local zHeight = maxZ - minZ
    local heading = zoneOptions.heading or 0

    targetModule.AddBoxZone(
        zoneName,
        coords,
        vector3(width, depth, zHeight),
        heading,
        buildTargetOptions(targetOptions, zoneName)
    )
end


-- =================== TREAT TARGETS ========================
--- Registers "Give <treat>" target interactions on the spawned pet entity.
--- One option is created for each entry in Config.Treats.
local function registerPetTreatTargets()
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then return end

    local interactionDistance = 2.5
    local options = {}

    for treatKey, treatData in pairs(Config.Treats or {}) do
        if treatData and treatData.item and treatData.name then
            local option = {
                name  = "nn_petshop_treat_" .. tostring(treatKey),
                icon  = "fas fa-cookie-bite",
                label = "Dar " .. (treatData.name or treatKey),
            }

            -- action: validates entity is the active pet before firing the server event
            option.action = function(entityOrTable)
                local entity = resolveEntity(entityOrTable)
                if type(entity) ~= "number" or entity == 0 then return end
                if not DoesEntityExist(entity)              then return end
                if entity ~= spawnedPetEntity               then return end
                TriggerServerEvent("nn_petshop:server:giveTreatToDog", { treatType = treatKey })
            end

            -- canInteract: only shows the option when target is the active pet
            option.canInteract = function(entity)
                if type(entity) ~= "number" or entity == 0 then return false end
                if not DoesEntityExist(entity)              then return false end
                return entity == spawnedPetEntity
            end

            option.distance    = interactionDistance
            options[#options + 1] = option
        end
    end

    if #options == 0 then return end

    local capturedEntity = spawnedPetEntity

    CreateThread(function()
        -- Wait for the target module to be ready
        while not targetModule do Wait(100) end

        -- Abort if the pet changed while we were waiting
        if not capturedEntity then return end
        if capturedEntity ~= spawnedPetEntity then return end
        if not DoesEntityExist(capturedEntity) then return end

        pcall(function()
            addEntityTarget(capturedEntity, { options = options, distance = interactionDistance })
        end)
    end)
end

--- Removes all treat target interactions from the active pet entity.
local function removePetTreatTargets()
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then return end
    removeEntityTarget(spawnedPetEntity)
end

local function deleteEntitySafely(entity)
    if not entity or not DoesEntityExist(entity) then
        return true
    end

    if NetworkGetEntityIsNetworked(entity) and not NetworkHasControlOfEntity(entity) then
        local timeout = GetGameTimer() + 1200

        repeat
            NetworkRequestControlOfEntity(entity)
            Wait(0)
        until NetworkHasControlOfEntity(entity) or GetGameTimer() >= timeout
    end

    SetEntityAsMissionEntity(entity, true, true)

    if IsEntityAPed(entity) then
        DeletePed(entity)
    else
        DeleteEntity(entity)
    end

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        Wait(0)
    end

    return not DoesEntityExist(entity)
end

local function clearActivePetState(options)
    options = options or {}

    local petId     = spawnedDogId
    local petEntity = spawnedPetEntity
    local prop      = accessoryEntity

    if options.saveStats and petId then
        savedPetStats[petId] = { obedience = obedienceLevel, thirst = thirstLevel, hunger = hungerLevel }
    end

    if petEntity and DoesEntityExist(petEntity) then
        removeEntityTarget(petEntity)

        if options.deletePet ~= false and not deleteEntitySafely(petEntity) then
            return petId, false
        end
    end

    if prop and DoesEntityExist(prop) then
        deleteEntitySafely(prop)
    end

    spawnedPetEntity    = nil
    accessoryEntity     = nil
    currentAccessoryId  = nil
    spawnedDogId        = nil
    dogFollowActive     = false
    spawnedPetCardIndex = 0
    clearStatDecayThread()

    return petId, true
end


-- =================== CONTROL PANEL UI ====================
local isControlUiOpen             = false  -- Whether the pet control panel is visible
local controlUiCloseThreadRunning = false

--- Shows or hides the pet control panel.
--- When hiding, optionally keeps NUI focus active (used after despawning a pet
--- so the spawn-list UI remains interactive).
--- @param visible  boolean
--- @param options  table|nil  { keepNuiFocus = bool }
local function setControlUiVisible(visible, options)
    if not options then options = {} end
    SendNUIMessage({ action = "setControlVisible", data = visible })

    if visible then
        releaseMenuInputFocus()
        isControlUiOpen = true
        if controlUiCloseThreadRunning then return end
        controlUiCloseThreadRunning = true

        CreateThread(function()
            while true do
                if not isControlUiOpen then break end
                Wait(0)
                DisableControlAction(0, 199, true)
                DisableControlAction(0, 200, true)
                DisableControlAction(0, 322, true)
                if IsDisabledControlJustPressed(0, 322) then
                    setControlUiVisible(false)
                    break
                end
            end
            controlUiCloseThreadRunning = false
        end)
    else
        isControlUiOpen = false
        signalMenuClosing()

        if options.keepNuiFocus then
            -- Keep the NUI open but hand control back to the spawn-list listener
            startMenuCloseListener()
        else
            releaseMenuInputFocus()
            SetNuiFocus(false, false)
            blockMenuControlsFor()
        end
    end
end


-- =================== PET DEATH ===========================
--- Called when a dog dies (health → 0, or starvation/dehydration).
--- Sets a respawn cooldown, cleans up the entity, and notifies the player.
local function handlePetDeath()
    local deadPetId = spawnedDogId
    if not deadPetId then return end

    -- Record the cooldown expiry timestamp
    local cooldownMs = (Config.SpawnCooldownAfterDeathSeconds or 180) * 1000
    petCooldowns[deadPetId]  = GetGameTimer() + cooldownMs
    savedPetStats[deadPetId] = nil  -- Discard saved stats on death

    -- Clear active-dog tracking
    spawnedDogId    = nil
    dogFollowActive = false
    clearStatDecayThread()
    currentAccessoryId = nil

    -- Tell the NUI about the death and push updated cooldown list
    SendNUIMessage({ action = "despawned",         data = deadPetId })
    setControlUiVisible(false)
    SendNUIMessage({ action = "setSpawnedDogName", data = nil })

    local cooldownsForUi = {}
    for petId, expiryTimer in pairs(petCooldowns) do
        local remaining = math.ceil((expiryTimer - GetGameTimer()) / 1000)
        if remaining > 0 then cooldownsForUi[petId] = remaining end
    end
    SendNUIMessage({ action = "setPetCooldowns", data = cooldownsForUi })

    local cooldownMinutes = math.floor((Config.SpawnCooldownAfterDeathSeconds or 180) / 60)
    notify("Seu cachorro morreu. Voce pode spawnar novamente em " .. cooldownMinutes .. " minutos.", "error")

    -- Snapshot handles and clear globals before the async deletion
    local deadEntity    = spawnedPetEntity
    local deadAccessory = accessoryEntity
    spawnedPetEntity    = nil
    accessoryEntity     = nil

    if deadEntity and DoesEntityExist(deadEntity) then
        CreateThread(function()
            -- Force death state in case it was triggered by starvation
            if not IsEntityDead(deadEntity) then
                SetEntityHealth(deadEntity, 0)
            end

            -- Wait for the death animation to finish before deleting
            Wait((Config.DeathAnimationDurationSeconds or 4) * 1000)

            if deadAccessory and DoesEntityExist(deadAccessory) then
                DeleteEntity(deadAccessory)
            end

            if DoesEntityExist(deadEntity) then
                removeEntityTarget(deadEntity)
                DeleteEntity(deadEntity)
            end
        end)
    elseif deadAccessory and DoesEntityExist(deadAccessory) then
        DeleteEntity(deadAccessory)
    end
end

onPetDeath = handlePetDeath  -- Wire up the forward-declared callback


-- =================== NEARBY PET FINDER ===================
--- Scans all CPed game-pool entities near the player looking for a pet ped
--- whose model hash matches any dog or cat in the config.
--- Used to reconnect to an existing pet after a resource restart.
--- @param filter  string|nil  "cats" = only cats, "dogs" = only dogs, nil = either.
--- @return number|nil  Entity handle of the closest matching pet, or nil.
local function findNearbyPet(filter)
    local playerPed = PlayerPedId()
    if not playerPed or not DoesEntityExist(playerPed) then return nil end

    local playerCoords  = GetEntityCoords(playerPed)
    local searchRadius  = 25.0
    local validModels   = {}

    if filter ~= "cats" then
        for _, dogConfig in ipairs(Config.Dogs or {}) do
            if dogConfig.model then validModels[GetHashKey(dogConfig.model)] = true end
        end
    end

    if filter ~= "dogs" then
        for _, catConfig in ipairs(Config.Cats or {}) do
            if catConfig.model then validModels[GetHashKey(catConfig.model)] = true end
        end
    end

    local closestEntity   = nil
    local closestDistance = searchRadius + 1.0

    for _, ped in ipairs(GetGamePool("CPed")) do
        if ped and ped ~= playerPed and DoesEntityExist(ped) then
            if IsPedHuman(ped) == false and IsEntityAMissionEntity(ped) then
                local modelHash = GetEntityModel(ped)
                if validModels[modelHash] then
                    local dist = #(playerCoords - GetEntityCoords(ped))
                    if closestDistance > dist then
                        closestDistance = dist
                        closestEntity   = ped
                    end
                end
            end
        end
    end

    return closestEntity
end


-- ================== OPEN CONTROL UI ======================
--- Opens the pet control panel for the active pet.
--- If the entity reference is stale, scans nearby peds first.
local function openControlUi()
    -- Try to reconnect to an already-spawned pet
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        local nearby = findNearbyPet(nil)
        if nearby and DoesEntityExist(nearby) then
            spawnedPetEntity = nearby
        end
    end

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Spawne um pet primeiro.", "error")
        return
    end

    -- Determine pet type so the UI shows the correct panel
    local modelHash = GetEntityModel(spawnedPetEntity)
    local isPetACat = false

    for _, catConfig in ipairs(Config.Cats or {}) do
        if catConfig.model and GetHashKey(catConfig.model) == modelHash then
            isPetACat = true
            break
        end
    end

    SendNUIMessage({ action = "setSpawnedPetType",      data = isPetACat and "cats" or "dogs" })
    SetNuiFocus(true, true)
    setControlUiVisible(true)
    SendNUIMessage({ action = "setFollowState",          data = dogFollowActive })
    SendNUIMessage({ action = "setSpawnedDogCardIndex",  data = spawnedPetCardIndex })
    syncObedienceToUi()
    syncThirstToUi()
    syncHungerToUi()
end


-- ================== CONTROL COMMANDS =====================
local controlCommandName = (Config.ControlUiCommand    and tostring(Config.ControlUiCommand):lower())    or "controlldog"
local controlDefaultKey  = (Config.ControlUiDefaultKey and tostring(Config.ControlUiDefaultKey):lower()) or "n"
local controlKeymapCmd   = "+" .. controlCommandName   -- Required press-command for RegisterKeyMapping

if shortcutControlCommand then
    RegisterCommand(controlCommandName, function() openControlUi() end, false)
end

if shortcutControlCommand and shortcutControlKeybind then
    -- Both + and - commands are required by FiveM's key-mapping system
    RegisterCommand(controlKeymapCmd,             function() openControlUi() end, false)
    RegisterCommand("-" .. controlCommandName,    function() end,               false)
end

if shortcutControlCommand and shortcutControlAliasDefault and "controlldog" ~= controlCommandName then
    RegisterCommand("controlldog", function() openControlUi() end, false)
end

if shortcutControlCommand and shortcutControlKeybind then
    RegisterKeyMapping(controlKeymapCmd, "Open Pet Control UI", "keyboard", controlDefaultKey)
end


-- =================== PET SHOP BOX ZONE ===================
-- Waits for the target module, then places a clickable box zone at the
-- pet shop coordinates so players can open the shop without a command.
CreateThread(function()
    while not targetModule do Wait(100) end

    local cfg = Config.PetShopTarget or {}
    if cfg.enabled == false then return end

    local coords   = cfg.coords or Config.ShopCoords
    local center   = vector3(coords.x, coords.y, coords.z)
    local zoneName = cfg.zoneName or "petshop_main"
    local radius   = cfg.radius   or Config.ShopRadius or 2.0
    local distance = cfg.distance or 2.5
    local label    = cfg.label    or "Abrir Petshop"
    local icon     = cfg.icon     or "fas fa-paw"
    local size     = radius * 2.0
    local heading  = tonumber(coords.w) or 0

    if not targetModule.AddBoxZone then
        print("^1[nn_petshop]^0 Target module missing AddBoxZone. Start interact or ox_target.")
        return
    end

    local ok = pcall(function()
        addBoxZone(zoneName, center, size, size, {
            heading = heading,
            minZ    = center.z - 1.0,
            maxZ    = center.z + 1.0,
        }, {
            options  = {{
                name   = "nn_petshop_open_shop",
                icon   = icon,
                label  = label,
                action = function() requestShopOpen() end,
            }},
            distance = tonumber(distance) or 2.5,
        })
    end)

    if not ok then
        print("^1[nn_petshop]^0 Failed to register pet shop target box zone.")
    end
end)


-- =================== TREAT SHOP BOX ZONE =================
-- Same pattern as the pet shop zone, but for the treat shop.
CreateThread(function()
    while not targetModule do Wait(100) end

    local cfg = Config.TreatShopTarget or {}
    if cfg.enabled == false then return end

    local coords = cfg.coords
    if not coords then return end  -- Treat shop has no implicit fallback position

    local center   = vector3(coords.x, coords.y, coords.z)
    local zoneName = cfg.zoneName or "petshop_treats"
    local radius   = cfg.radius   or 1.8
    local distance = cfg.distance or 2.5
    local label    = cfg.label    or "Abrir Loja de Petiscos"
    local icon     = cfg.icon     or "fas fa-cookie-bite"
    local size     = radius * 2.0

    if not targetModule.AddBoxZone then
        print("^1[nn_petshop]^0 Target module missing AddBoxZone for TreatShopTarget. Start interact or ox_target.")
        return
    end

    local ok = pcall(function()
        addBoxZone(zoneName, center, size, size, {
            heading = 0,
            minZ    = center.z - 1.0,
            maxZ    = center.z + 1.0,
        }, {
            options  = {{
                name   = "nn_petshop_open_treatshop",
                icon   = icon,
                label  = label,
                action = function() openTreatShop() end,
            }},
            distance = tonumber(distance) or 2.5,
        })
    end)

    if not ok then
        print("^1[nn_petshop]^0 Failed to register treat shop target box zone.")
    end
end)


-- ===================== NUI CALLBACKS ======================

-- Close the main shop/spawn UI from the NUI "X" button
RegisterNUICallback("hideFrame", function(_, cb)
    closeAllUi()
    cb("ok")
end)

-- Close the control panel from the NUI "X" button
RegisterNUICallback("hideControl", function(_, cb)
    setControlUiVisible(false)
    cb("ok")
end)

-- Return catalog data (used when the NUI initialises and needs the item grid)
RegisterNUICallback("getCatalog", function(_, cb)
    local playerMoney = {}
    cb({
        catalog           = getCatalog(),
        player            = { level = 1, bank = playerMoney.bank or 0, cash = playerMoney.cash or 0 },
        purchasedDogs     = {},
        purchasedCats     = {},
        purchasedClothing = {},
    })
end)

-- Handle a pet purchase initiated from the NUI
RegisterNUICallback("purchase", function(data, cb)
    local petType    = data and data.petType
    local petId      = data and data.petId
    local clothingId = data and data.clothingId
    local customName = data and data.customName

    if not petType or not petId then
        cb({ success = false })
        return
    end

    -- Normalise plural type names to singular for the server event
    if petType == "dogs" then petType = "dog"
    elseif petType == "cats" then petType = "cat"
    end

    TriggerServerEvent("nn_petshop:server:purchase", petType, petId, clothingId, customName)
    cb({ success = true })
end)

-- Handle a clothing-only purchase from the NUI
RegisterNUICallback("purchaseClothing", function(data, cb)
    -- Accept { clothingId } or { data = { clothingId } }
    local inner      = (type(data) == "table" and data.data) or data
    local clothingId = inner and (inner.clothingId or inner.ClothingId)

    -- Validate: must be a non-empty, non-"none" string
    if not clothingId
        or type(clothingId) ~= "string"
        or clothingId == "none"
        or clothingId:match("^%s*$")
    then
        cb({ success = false })
        return
    end

    clothingId = clothingId:match("^%s*(.+)%s*$") or clothingId
    TriggerServerEvent("nn_petshop:server:buyClothingEvent", clothingId)
    cb({ ok = true })
end)

-- Server confirms a clothing purchase; update the NUI inventory
RegisterNetEvent("nn_petshop:client:receivedPurchasedClothing", function(clothingData)
    if clothingData then
        SendNUIMessage({ action = "addPurchasedClothing", data = clothingData })
    end
end)

-- Generic notification event from server
RegisterNetEvent("nn_petshop:client:notify", function(success, messageOverride)
    local message = messageOverride
    if not messageOverride then
        message = success and Config.Messages.purchased or Config.Messages.error
    end
    notify(message, success and "success" or "error")
end)

-- Server can force-close the UI (e.g. after a transaction completes)
RegisterNetEvent("nn_petshop:client:closeUi", function()
    closeAllUi()
end)


-- =================== MODEL UTILITIES ======================
--- Returns the string model name for an entity by comparing its hash
--- against all entries in Config.Dogs and Config.Cats.
--- @param entity  number
--- @return string|nil  Model name, or nil if not found.
local function getModelNameFromEntity(entity)
    if not entity or not DoesEntityExist(entity) then return nil end
    local modelHash = GetEntityModel(entity)

    for _, dogConfig in ipairs(Config.Dogs or {}) do
        if dogConfig.model and GetHashKey(dogConfig.model) == modelHash then
            return dogConfig.model
        end
    end
    for _, catConfig in ipairs(Config.Cats or {}) do
        if catConfig.model and GetHashKey(catConfig.model) == modelHash then
            return catConfig.model
        end
    end
    return nil
end

--- Resolves the attach offset and rotation for a clothing prop.
--- If the config has a "byModel" override table and the pet model is in it,
--- the per-model values take precedence over the defaults.
--- @param clothingConfig  table  Entry from Config.ClothingProps
--- @param petEntity  number  Entity handle of the dog
--- @return vector3 offset, vector3 rotation
local function getAccessoryOffsetAndRotation(clothingConfig, petEntity)
    local offset   = clothingConfig.offset   or vector3(0.0, 0.0, 0.0)
    local rotation = clothingConfig.rotation or vector3(0.0, 0.0, 0.0)

    if clothingConfig.byModel and petEntity then
        local modelName = getModelNameFromEntity(petEntity)
        if modelName then
            local override = clothingConfig.byModel[modelName]
            if override then
                offset   = override.offset   or offset
                rotation = override.rotation or rotation
            end
        end
    end

    return offset, rotation
end


-- =================== PED SPAWNING ========================
--- Spawns a pet ped directly in front of the player.
--- The ped is marked as a mission entity and configured as a non-fleeing, non-combative animal.
--- @param modelNameOrHash  string|number  Model name or pre-resolved hash.
--- @param clothingData  table|nil  { texture = number } for component colour variation (cats).
local function spawnPetPed(modelNameOrHash, clothingData)
    local modelHash = (type(modelNameOrHash) == "string" and GetHashKey(modelNameOrHash)) or modelNameOrHash
    if not modelHash or modelHash == 0 then return end

    RequestModel(modelHash)
    local attempts = 0
    while not HasModelLoaded(modelHash) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    if not HasModelLoaded(modelHash) then return end

    local playerPed = PlayerPedId()
    if not playerPed or playerPed == 0 then return end

    local coords     = GetEntityCoords(playerPed)
    local heading    = GetEntityHeading(playerPed)
    local headingRad = math.rad(heading)
    local dist       = Config.SpawnDistanceInFront or 2.5

    -- Position directly in front of the player facing toward them
    local ped = CreatePed(
        28,   -- PedType 28 = animal
        modelHash,
        coords.x - math.sin(headingRad) * dist,
        coords.y + math.cos(headingRad) * dist,
        coords.z - 1.0,   -- Slightly below; PlaceObjectOnGroundProperly will snap it up
        heading + 180.0,  -- Facing toward the player
        true, true        -- isNetwork = true, bScriptHostPed = true (so other players can see it)
    )

    NetworkRegisterEntityAsNetworked(ped)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ped), true)

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)    -- Ignore ambient stimuli
    SetPedFleeAttributes(ped, 0, false)           -- Never flee
    SetPedCombatAttributes(ped, 46, true)         -- CanFightArmedPedsWhenNotArmed
    PlaceObjectOnGroundProperly(ped)
    SetModelAsNoLongerNeeded(modelHash)

    spawnedPetEntity = ped
    dogFollowActive  = false

    -- Apply coat texture variation (used for cat colour variants)
    if clothingData and type(clothingData) == "table" then
        local texture = clothingData.texture or clothingData.variation or clothingData.tex
        if type(texture) == "number" then
            SetPedComponentVariation(ped, 0, 0, texture, 0)
        end
    end

    return ped
end

-- Server can trigger a spawn directly (alternative to the NUI flow)
RegisterNetEvent("nn_petshop:client:spawnPet", function(spawnData)
    if not spawnData or petSpawnInProgress then return end

    petSpawnInProgress = true

    CreateThread(function()
        if spawnedPetEntity and DoesEntityExist(spawnedPetEntity) then
            local _, removed = clearActivePetState({ saveStats = true, deletePet = true })
            if removed == false then
                notify("Nao foi possivel recolher o pet atual. Tente novamente.", "error")
                petSpawnInProgress = false
                return
            end
        elseif spawnedPetEntity then
            clearActivePetState({ saveStats = true, deletePet = false })
        end

        local newPet = spawnPetPed(spawnData)
        if not newPet then
            notify("Falha ao spawnar o pet.", "error")
        end

        petSpawnInProgress = false
    end)
end)

-- =================== DEATH MONITOR =======================
-- Polls every second to detect when a spawned dog dies so we can trigger
-- the death handler (cooldown, entity cleanup, notification).
CreateThread(function()
    while true do
        Wait(1000)
        if spawnedPetEntity and spawnedDogId then
            if DoesEntityExist(spawnedPetEntity) then
                if IsEntityDead(spawnedPetEntity) then
                    onPetDeath()
                end
            else
                onPetDeath()
            end
        end
    end
end)


-- ================== SPAWN PET (NUI) =======================
RegisterNUICallback("spawnPet", function(data, cb)
    local petType    = data and data.petType
    local petId      = data and data.petId
    local customName = data and data.customName

    if not petType or not petId then
        cb({ success = false })
        return
    end

    if petSpawnInProgress then
        cb({ success = false, busy = true })
        return
    end

    if petType == "dogs" then
        local expiry = petCooldowns[petId]
        if expiry and expiry > GetGameTimer() then
            local remaining = math.ceil((expiry - GetGameTimer()) / 1000)
            cb({ success = false, cooldownRemaining = remaining })
            return
        end
    end

    local petList = (petType == "dogs" and Config.Dogs)
                 or (petType == "cats" and Config.Cats)

    if not petList then
        cb({ success = false })
        return
    end

    petSpawnInProgress = true

    CreateThread(function()
        local callbackSent = false

        local function finish(result)
            petSpawnInProgress = false
            if not callbackSent then
                callbackSent = true
                cb(result)
            end
        end

        local ok, err = pcall(function()
            for index, petConfig in ipairs(petList) do
                if petConfig.id == petId and petConfig.model then
                    if spawnedPetEntity and DoesEntityExist(spawnedPetEntity) then
                        local _, removed = clearActivePetState({ saveStats = true, deletePet = true })
                        if removed == false then
                            notify("Nao foi possivel recolher o pet atual. Tente novamente.", "error")
                            finish({ success = false, cleanupFailed = true })
                            return
                        end
                    elseif spawnedPetEntity then
                        clearActivePetState({ saveStats = true, deletePet = false })
                    end

                    spawnedPetCardIndex = math.min(index - 1, 5)

                    if petType == "dogs" then
                        spawnedDogId = petId
                    end

                    local clothingData = nil
                    if petType == "cats" and type(petConfig.texture) == "number" then
                        clothingData = { texture = petConfig.texture }
                    end

                    local newPet = spawnPetPed(petConfig.model, clothingData)
                    if not newPet then
                        clearActivePetState({ saveStats = false, deletePet = false })
                        finish({ success = false })
                        return
                    end

                    if petType == "dogs" then
                        local saved = savedPetStats[petId]
                        if saved then
                            obedienceLevel = math.max(0, math.min(100, tonumber(saved.obedience) or (Config.Obedience and Config.Obedience.startValue) or 100))
                            thirstLevel    = math.max(0, math.min(100, tonumber(saved.thirst)    or (Config.Thirst   and Config.Thirst.startValue)    or 100))
                            hungerLevel    = math.max(0, math.min(100, tonumber(saved.hunger)    or (Config.Hunger   and Config.Hunger.startValue)    or 100))
                            syncObedienceToUi()
                            syncThirstToUi()
                            syncHungerToUi()
                        else
                            resetObedience()
                            resetThirstAndHunger()
                        end
                    else
                        resetObedience()
                        resetThirstAndHunger()
                    end

                    startStatDecayThread()

                    if petType == "dogs" then
                        SendNUIMessage({ action = "setSpawnedPetType", data = "dogs" })
                        setControlUiVisible(true)
                        syncObedienceToUi()
                        syncThirstToUi()
                        syncHungerToUi()
                        SendNUIMessage({ action = "setSpawnedDogCardIndex", data = spawnedPetCardIndex })

                        local displayName = (type(customName) == "string" and #customName > 0) and customName or nil
                        SendNUIMessage({ action = "setSpawnedDogName", data = displayName })
                        registerPetTreatTargets()
                        setSpawnUiClosed()
                        SendNUIMessage({ action = "setVisible", data = false })
                    else
                        SendNUIMessage({ action = "setSpawnedPetType", data = "cats" })
                        spawnedDogId = nil
                        registerPetTreatTargets()
                        setControlUiVisible(true)
                        syncObedienceToUi()
                        syncThirstToUi()
                        syncHungerToUi()
                        SendNUIMessage({ action = "setSpawnedDogCardIndex", data = spawnedPetCardIndex })
                        SendNUIMessage({ action = "setSpawnedDogName", data = petConfig.name or "Cat" })
                        closeAllUi()
                    end

                    finish({ success = true })
                    return
                end
            end

            finish({ success = false })
        end)

        if not ok then
            print(("[nn_petshop] spawnPet failed: %s"):format(tostring(err)))
            finish({ success = false })
        end
    end)
end)

-- ================== DESPAWN PET (NUI) =====================
RegisterNUICallback("despawnPet", function(data, cb)
    cb("ok")

    local petId = (data and data.petId) or spawnedDogId

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        clearActivePetState({ saveStats = true, deletePet = false })
        SendNUIMessage({ action = "despawned",         data = petId })
        setControlUiVisible(false, { keepNuiFocus = true })
        SendNUIMessage({ action = "setSpawnedPetType", data = "dogs" })
        SendNUIMessage({ action = "setSpawnedDogName", data = nil })
        return
    end

    clearActivePetState({ saveStats = true, deletePet = true })

    SendNUIMessage({ action = "despawned",         data = petId })
    setControlUiVisible(false, { keepNuiFocus = true })
    SendNUIMessage({ action = "setSpawnedPetType", data = "dogs" })
    SendNUIMessage({ action = "setSpawnedDogName", data = nil })
end)


-- ================ GET COOLDOWNS (NUI) =====================
RegisterNUICallback("getPetCooldowns", function(_, cb)
    local result = {}
    local now    = GetGameTimer()

    for petId, expiry in pairs(petCooldowns) do
        local remaining = math.ceil((expiry - now) / 1000)
        if remaining > 0 then
            result[petId] = remaining
        else
            petCooldowns[petId] = nil  -- Prune expired entries
        end
    end

    cb(result)
end)


-- =================== EQUIP ACCESSORY =====================
--- Loads a prop model, creates the object, and attaches it to the dog's skeleton.
--- Replaces any currently equipped accessory.
--- @param clothingId  string  Key from Config.ClothingProps.
local function equipAccessory(clothingId)
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return
    end

    if isCatModel(GetEntityModel(spawnedPetEntity)) then
        notify("Acessorios so podem ser equipados em cachorros.", "error")
        return
    end

    -- Remove existing accessory
    if accessoryEntity and DoesEntityExist(accessoryEntity) then
        DeleteEntity(accessoryEntity)
        accessoryEntity = nil
    end
    currentAccessoryId = nil

    if clothingId == "none" then
        notify("Acessorios removidos.", "success")
        return
    end

    local clothingConfig = Config.ClothingProps and Config.ClothingProps[clothingId]
    if not clothingConfig or not clothingConfig.model or clothingConfig.model == "" then
        notify("Esse acessorio nao tem prop visual configurado.", "error")
        return
    end

    local modelHash = (type(clothingConfig.model) == "string" and GetHashKey(clothingConfig.model)) or clothingConfig.model
    if not modelHash or modelHash == 0 then
        notify("Modelo de acessorio invalido.", "error")
        return
    end

    RequestModel(modelHash)
    local attempts = 0
    while not HasModelLoaded(modelHash) do
        if not (attempts < 200) then break end
        Wait(10)
        attempts = attempts + 1
    end

    if not HasModelLoaded(modelHash) then
        notify("Falha ao carregar modelo do acessorio.", "error")
        return
    end

    local petCoords = GetEntityCoords(spawnedPetEntity)
    local prop = CreateObject(modelHash, petCoords.x, petCoords.y, petCoords.z, true, false, false)
    SetModelAsNoLongerNeeded(modelHash)

    if not DoesEntityExist(prop) then
        notify("Nao foi possivel criar o acessorio.", "error")
        return
    end

    local bone             = clothingConfig.bone or 31086  -- Fallback: SKEL_ROOT bone
    local offset, rotation = getAccessoryOffsetAndRotation(clothingConfig, spawnedPetEntity)

    AttachEntityToEntity(
        prop, spawnedPetEntity,
        GetPedBoneIndex(spawnedPetEntity, bone),
        offset.x, offset.y, offset.z,
        rotation.x, rotation.y, rotation.z,
        true, true, false, true, 2, true
    )

    accessoryEntity    = prop
    currentAccessoryId = clothingId
    notify("Acessorio equipado.", "success")
end

-- Server can trigger accessory equip directly (after validating ownership)
RegisterNetEvent("nn_petshop:client:doEquipClothing", function(clothingId)
    equipAccessory(clothingId)
end)

-- NUI button: validate, then ask server to confirm and echo back via doEquipClothing
RegisterNUICallback("equipClothing", function(data, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return
    end

    if isCatModel(GetEntityModel(spawnedPetEntity)) then
        notify("Acessorios so podem ser equipados em cachorros.", "error")
        return
    end

    local clothingId = data and data.clothingId
    if not clothingId then return end

    TriggerServerEvent("nn_petshop:server:equipClothing", clothingId)
end)


-- ============= ACCESSORY POSITION TOOL ==================
-- Developer utility (/adjustaccessory) for positioning a prop attachment on a dog.
-- Controls: W/S = ±value, A/D = cycle axis, ENTER = print config snippet, ESC = exit.

local POSITION_STEP = 0.01  -- Metres per keypress for offset adjustments
local ROTATION_STEP = 5.0   -- Degrees per keypress for rotation adjustments

local AXIS_NAMES = { "offset X", "offset Y", "offset Z", "rot X", "rot Y", "rot Z" }

local COLOR_SELECTED = "~g~"
local COLOR_NORMAL   = "~w~"

-- GTA control IDs used by the tool
local KEY_W = 32  -- Forward / W
local KEY_S = 33  -- Back    / S
local KEY_A = 34  -- Left    / A
local KEY_D = 35  -- Right   / D

--- Renders a text string at the given screen-space position using centred small white font.
local function drawScreenText(text, x, y)
    SetTextFont(4)
    SetTextScale(0.32, 0.32)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

--- Draws the accessory positioning HUD overlay showing offset, rotation, active axis, and controls.
local function drawAccessoryPositionHud(offset, rotation, activeAxis)
    local function fmtOff(axis)
        local v = (axis == 1 and offset.x) or (axis == 2 and offset.y) or offset.z
        return string.format("%.3f", v)
    end
    local function fmtRot(axis)
        local v = (axis == 1 and rotation.x) or (axis == 2 and rotation.y) or rotation.z
        return string.format("%.1f", v)
    end
    local function col(axis)
        return (activeAxis == axis) and COLOR_SELECTED or COLOR_NORMAL
    end

    local baseY = 0.18
    local lineH = 0.032

    drawScreenText("~b~--- ACCESSORY POSITION TOOL ---~w~",
        0.5, baseY)
    drawScreenText("~o~Offset~w~ (pos) "
        .. col(1).."X="..fmtOff(1).."~w~  "
        .. col(2).."Y="..fmtOff(2).."~w~  "
        .. col(3).."Z="..fmtOff(3).."~w~",
        0.5, baseY + lineH)
    drawScreenText("~o~Rotation~w~ (deg) "
        .. col(4).."X="..fmtRot(1).."~w~  "
        .. col(5).."Y="..fmtRot(2).."~w~  "
        .. col(6).."Z="..fmtRot(3).."~w~",
        0.5, baseY + lineH * 2)
    drawScreenText("~y~Editing: " .. (AXIS_NAMES[activeAxis] or "?") .. " (axis " .. tostring(activeAxis) .. "/6)~w~",
        0.5, baseY + lineH * 3)
    drawScreenText("~g~W~w~=+ ~g~S~w~=- ~g~A~w~/~g~D~w~=axis ~g~ENTER~w~=print ~r~ESC~w~=exit",
        0.5, baseY + lineH * 4)
end

RegisterCommand("adjustaccessory", function(_, args)
    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Spawne um pet primeiro.", "error")
        return
    end

    local firstArg = args and args[1] and args[1]:lower() or nil

    if firstArg == "help" or firstArg == "-help" or firstArg == "?" then
        print("^2[nn_petshop] /adjustaccessory:^0 Equip an accessory on your pet, then run /adjustaccessory (no args) to position it. W/S=value A/D=axis ENTER=print ESC=exit")
        return
    end

    local targetClothingId  = nil
    local propEntity        = nil
    local usingEquippedProp = false

    if not firstArg or firstArg == "" then
        -- Use the currently equipped accessory
        targetClothingId = currentAccessoryId
        propEntity       = accessoryEntity

        if not targetClothingId or not (Config.ClothingProps and Config.ClothingProps[targetClothingId]) then
            notify("Equipe um acessorio no pet primeiro.", "error")
            return
        end
        if not propEntity or not DoesEntityExist(propEntity) then
            notify("Equipe um acessorio no pet primeiro.", "error")
            return
        end

        usingEquippedProp = true
    else
        -- Spawn a temporary preview prop for the named clothing ID
        targetClothingId = firstArg

        if not (Config.ClothingProps and Config.ClothingProps[targetClothingId]) then
            notify("ID de acessorio desconhecido: " .. tostring(targetClothingId), "error")
            return
        end

        local clothingCfg = Config.ClothingProps[targetClothingId]
        local modelHash   = (type(clothingCfg.model) == "string" and GetHashKey(clothingCfg.model)) or clothingCfg.model

        if not modelHash or modelHash == 0 then
            notify("Modelo invalido para " .. targetClothingId, "error")
            return
        end

        if accessoryEntity and DoesEntityExist(accessoryEntity) then
            DeleteEntity(accessoryEntity)
            accessoryEntity    = nil
            currentAccessoryId = nil
        end

        RequestModel(modelHash)
        local a = 0
        while not HasModelLoaded(modelHash) do
            if not (a < 200) then break end
            Wait(10)
            a = a + 1
        end

        if not HasModelLoaded(modelHash) then
            notify("Falha ao carregar modelo.", "error")
            return
        end

        local pc = GetEntityCoords(spawnedPetEntity)
        propEntity = CreateObject(modelHash, pc.x, pc.y, pc.z, true, false, false)
        SetModelAsNoLongerNeeded(modelHash)

        if not DoesEntityExist(propEntity) then
            notify("Falha ao criar prop.", "error")
            return
        end
    end

    local clothingConfig    = Config.ClothingProps[targetClothingId]
    local petEntity         = spawnedPetEntity
    local bone              = clothingConfig.bone or 31086
    local offset, rotation  = getAccessoryOffsetAndRotation(clothingConfig, petEntity)
    local activeAxis        = 1

    notify("Posicionando: " .. targetClothingId .. " | W/S: valor, A/D: eixo, ENTER: imprimir, ESC: sair", "primary")

    CreateThread(function()
        while true do
            if not DoesEntityExist(propEntity) then break end
            if not DoesEntityExist(petEntity)  then break end

            -- Block all movement / combat inputs during positioning
            for _, ctrl in ipairs({200, 322, 191, 32, 33, 34, 35, 21, 22, 36, 24, 257, 25, 23, 75}) do
                DisableControlAction(0, ctrl, true)
            end

            -- Reattach each frame so adjustment is immediate
            AttachEntityToEntity(
                propEntity, petEntity,
                GetPedBoneIndex(petEntity, bone),
                offset.x, offset.y, offset.z,
                rotation.x, rotation.y, rotation.z,
                true, true, false, true, 2, true
            )

            drawAccessoryPositionHud(offset, rotation, activeAxis)

            -- W / dpad-up: increase value
            if IsDisabledControlJustPressed(0, KEY_W) or IsControlJustPressed(0, 172) then
                if activeAxis <= 3 then
                    if     activeAxis == 1 then offset   = vector3(offset.x + POSITION_STEP, offset.y, offset.z)
                    elseif activeAxis == 2 then offset   = vector3(offset.x, offset.y + POSITION_STEP, offset.z)
                    else                        offset   = vector3(offset.x, offset.y, offset.z + POSITION_STEP) end
                else
                    local r = activeAxis - 3
                    if     r == 1 then rotation = vector3(rotation.x + ROTATION_STEP, rotation.y, rotation.z)
                    elseif r == 2 then rotation = vector3(rotation.x, rotation.y + ROTATION_STEP, rotation.z)
                    else               rotation = vector3(rotation.x, rotation.y, rotation.z + ROTATION_STEP) end
                end

            -- S / dpad-down: decrease value
            elseif IsDisabledControlJustPressed(0, KEY_S) or IsControlJustPressed(0, 173) then
                if activeAxis <= 3 then
                    if     activeAxis == 1 then offset   = vector3(offset.x - POSITION_STEP, offset.y, offset.z)
                    elseif activeAxis == 2 then offset   = vector3(offset.x, offset.y - POSITION_STEP, offset.z)
                    else                        offset   = vector3(offset.x, offset.y, offset.z - POSITION_STEP) end
                else
                    local r = activeAxis - 3
                    if     r == 1 then rotation = vector3(rotation.x - ROTATION_STEP, rotation.y, rotation.z)
                    elseif r == 2 then rotation = vector3(rotation.x, rotation.y - ROTATION_STEP, rotation.z)
                    else               rotation = vector3(rotation.x, rotation.y, rotation.z - ROTATION_STEP) end
                end

            -- A / dpad-left: previous axis (wraps 1→6)
            elseif IsDisabledControlJustPressed(0, KEY_A) or IsControlJustPressed(0, 174) then
                activeAxis = activeAxis - 1
                if activeAxis < 1 then activeAxis = 6 end

            -- D / dpad-right: next axis (wraps 6→1)
            elseif IsDisabledControlJustPressed(0, KEY_D) or IsControlJustPressed(0, 175) then
                activeAxis = activeAxis + 1
                if activeAxis > 6 then activeAxis = 1 end

            -- ENTER: print config snippet to F8 console
            elseif IsDisabledControlJustPressed(0, 191) then
                local modelStr = (type(clothingConfig.model) == "number")
                    and tostring(clothingConfig.model)
                    or  ('"' .. tostring(clothingConfig.model) .. '"')

                print("^2[nn_petshop] Config for " .. targetClothingId .. " (copy into Config.ClothingProps):^0")
                print(string.format([[
    %s = {
        model = %s,
        bone = %s,
        offset = vector3(%.3f, %.3f, %.3f),
        rotation = vector3(%.1f, %.1f, %.1f),
    },
]],
                    targetClothingId, modelStr, tostring(bone),
                    offset.x, offset.y, offset.z,
                    rotation.x, rotation.y, rotation.z
                ))

                -- Also print per-model byModel entry if we can identify the dog breed
                local modelName = getModelNameFromEntity(petEntity)
                if modelName then
                    print("^3[nn_petshop] For byModel (small dogs), add to " .. tostring(targetClothingId) .. ".byModel in config.lua:^0")
                    print(string.format(
                        "  %s = { offset = vector3(%.3f, %.3f, %.3f), rotation = vector3(%.1f, %.1f, %.1f) },",
                        modelName,
                        offset.x, offset.y, offset.z,
                        rotation.x, rotation.y, rotation.z
                    ))
                end

                notify("Config impressa no console F8.", "success")
                if not usingEquippedProp then DeleteEntity(propEntity) end
                return

            -- ESC / Back: cancel and clean up temporary prop
            elseif IsControlJustPressed(0, 200) or IsControlJustPressed(0, 322) then
                if not usingEquippedProp then DeleteEntity(propEntity) end
                notify("Cancelado.", "primary")
                return
            end

            Wait(0)
        end
    end)
end, false)


-- ================ EULER → DIRECTION VECTOR ===============
--- Converts a GTA rotation vector (Euler angles in degrees) into a normalised
--- forward direction vector.  Used to build camera-forward raycasts.
--- @param rot  vector3  Rotation in degrees (x = pitch, y = roll, z = yaw).
--- @return vector3  Unit direction vector.
local function eulerToDirectionVector(rot)
    local rx = math.rad(rot.x)
    local rz = math.rad(rot.z)
    return vector3(
        -math.sin(rz) * math.abs(math.cos(rx)),
         math.cos(rz) * math.abs(math.cos(rx)),
         math.sin(rx)
    )
end


-- =================== TREAT CALLBACKS ======================

-- Simple give-treat button (no item cost, just obedience boost)
RegisterNUICallback("giveTreat", function(_, cb)
    cb("ok")
    giveTreat()
end)

-- Buy a treat from the treat shop (validates item and money server-side)
RegisterNUICallback("buyTreat", function(data, cb)
    cb("ok")
    local treatType = data and (data.treatType or data.treat_type)
    if treatType and type(treatType) == "string" then
        TriggerServerEvent("nn_petshop:server:buyTreat", treatType)
    end
end)

-- Return treat metadata so the NUI can render the treat list and prices
RegisterNUICallback("getTreatPrices", function(_, cb)
    local result = {}
    for treatKey, treatData in pairs(Config.Treats or {}) do
        if treatData and (treatData.name or treatData.price) then
            result[treatKey] = {
                name           = treatData.name            or treatKey,
                price          = tonumber(treatData.price) or 0,
                obedienceBoost = tonumber(treatData.obedienceBoost) or 0,
                hunger         = tonumber(treatData.hunger) or 0,
                thirst         = tonumber(treatData.thirst) or 0,
            }
        end
    end
    cb(result)
end)

-- Close the treat shop (invoked by the NUI "X" button)
RegisterNUICallback("closeTreatShop", function(_, cb)
    cb("ok")
    if treatShopOpen then
        treatShopOpen = false
        releaseMenuInputFocus()
        SetNuiFocus(false, false)
    end
end)


-- ================== ATTACK TARGET =========================
--- Enters an aim mode where the player uses their crosshair to designate a ped
--- for the dog to attack.  Requires obedience ≥ minToObey.
--- Controls: Left click = designate target, ESC/Back = exit.
RegisterNUICallback("attackTarget", function(_, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return
    end

    if isCatModel(GetEntityModel(spawnedPetEntity)) then
        notify("Gatos nao podem atacar.", "error")
        return
    end

    if not isPetObedient() then
        notify("Seu cachorro nao esta obediente o suficiente. De um petisco.", "error")
        return
    end

    SetNuiFocus(false, false)

    CreateThread(function()
        isMenuClosing = false
        local active  = true

        while active do
            if isMenuClosing then isMenuClosing = false ; break end

            -- Disable the player's own weapons during aiming mode
            local disableControls = {199,200,322,24,257,25,140,141,142}
            for _, ctrl in ipairs(disableControls) do DisableControlAction(0, ctrl, true) end
            DisablePlayerFiring(PlayerId(), true)

            -- Raycast from camera forward
            local camCoords = GetGameplayCamCoord()
            local camDir    = eulerToDirectionVector(GetGameplayCamRot(2))
            local rayEnd    = camCoords + camDir * 500.0
            local rayHandle = StartShapeTestRay(
                camCoords.x, camCoords.y, camCoords.z,
                rayEnd.x, rayEnd.y, rayEnd.z,
                -1, PlayerPedId(), 0
            )

            Wait(0)

            -- Re-disable after Wait (controls reset each frame)
            for _, ctrl in ipairs(disableControls) do DisableControlAction(0, ctrl, true) end
            DisablePlayerFiring(PlayerId(), true)

            local _, hit, hitCoords, _, hitEntity = GetShapeTestResult(rayHandle)

            -- Draw red targeting marker where the ray hits
            if hit and hitCoords then
                DrawMarker(28,
                    hitCoords.x, hitCoords.y, hitCoords.z + 0.5,
                    0,0,0, 0,0,0, 0.5,0.5,0.5,
                    255,80,80,180, false,false,2,false,nil,nil,false)
            end

            -- Check for any "fire" input variant across all input methods
            local fired = IsDisabledControlJustPressed(0,24) or IsDisabledControlJustPressed(0,257)
                       or IsDisabledControlJustReleased(0,24) or IsDisabledControlJustReleased(0,257)
                       or IsControlJustPressed(0,24) or IsControlJustPressed(0,257)
                       or IsControlJustReleased(0,24) or IsControlJustReleased(0,257)
                       or IsControlJustPressed(0,44)

            if fired then
                if hitEntity and hitEntity ~= 0 and DoesEntityExist(hitEntity) and IsEntityAPed(hitEntity) then
                    if hitEntity ~= spawnedPetEntity and hitEntity ~= PlayerPedId() then
                        TaskCombatPed(spawnedPetEntity, hitEntity, 0, 16)
                        notify("Cachorro atacando o alvo.", "success")
                    end
                else
                    notify("Mire em um alvo valido (ped).", "error")
                end
            end

            if IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 200) then
                active = false
            end
        end

        DisablePlayerFiring(PlayerId(), false)
    end)
end)


-- ================== MOVE TO TARGET ========================
--- Enters an aim mode where the player clicks a ground position to send the dog there.
--- Uses TaskFollowNavMeshToCoord.  Requires obedience ≥ minToObey.
RegisterNUICallback("moveToTarget", function(_, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum cachorro spawnado.", "error")
        return
    end

    if not isPetObedient() then
        notify("Seu cachorro nao esta obediente o suficiente. De um petisco.", "error")
        return
    end

    SetNuiFocus(false, false)

    CreateThread(function()
        isMenuClosing = false
        local active              = true
        local clickInputExpiry    = 0    -- GetGameTimer() value; non-zero means a click was just made
        local lastHitCoords       = nil  -- World position last aimed at

        while active do
            if isMenuClosing then isMenuClosing = false ; break end

            local disableControls = {199,200,322,24,257,25,140,141,142}
            for _, ctrl in ipairs(disableControls) do DisableControlAction(0, ctrl, true) end
            DisablePlayerFiring(PlayerId(), true)

            local camCoords = GetGameplayCamCoord()
            local camDir    = eulerToDirectionVector(GetGameplayCamRot(2))
            local rayEnd    = camCoords + camDir * 500.0
            local rayHandle = StartShapeTestRay(
                camCoords.x, camCoords.y, camCoords.z,
                rayEnd.x, rayEnd.y, rayEnd.z,
                -1, PlayerPedId(), 0
            )

            Wait(0)

            for _, ctrl in ipairs(disableControls) do DisableControlAction(0, ctrl, true) end
            DisablePlayerFiring(PlayerId(), true)

            local _, hit, hitCoords = GetShapeTestResult(rayHandle)

            if hit and hitCoords then
                lastHitCoords = hitCoords
                -- Green marker for move-to target
                DrawMarker(28,
                    hitCoords.x, hitCoords.y, hitCoords.z + 0.5,
                    0,0,0, 0,0,0, 0.5,0.5,0.5,
                    80,200,80,180, false,false,2,false,nil,nil,false)
            end

            -- Detect click to set destination (opens a 180ms window)
            local clicked = IsDisabledControlJustPressed(0,24) or IsDisabledControlJustPressed(0,257)
                         or IsDisabledControlJustReleased(0,24) or IsDisabledControlJustReleased(0,257)
                         or IsControlJustPressed(0,24) or IsControlJustPressed(0,257)
                         or IsControlJustReleased(0,24) or IsControlJustReleased(0,257)
                         or IsControlJustPressed(0,44)

            if clicked then
                clickInputExpiry = GetGameTimer() + 180
            end

            if clickInputExpiry > 0 then
                local now = GetGameTimer()
                if clickInputExpiry >= now and lastHitCoords then
                    TaskFollowNavMeshToCoord(spawnedPetEntity,
                        lastHitCoords.x, lastHitCoords.y, lastHitCoords.z,
                        1.0, -1, 0.5, false, 0)
                    notify("Cachorro indo ate o local.", "success")
                    active = false
                elseif clickInputExpiry < now then
                    notify("Mire em um local valido.", "error")
                    active = false
                end
            end

            if active and (IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 200)) then
                active = false
            end
        end

        DisablePlayerFiring(PlayerId(), false)
    end)
end)


-- ================== TOGGLE FOLLOW =========================
RegisterNUICallback("toggleFollow", function(_, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum cachorro spawnado.", "error")
        SendNUIMessage({ action = "setFollowState", data = false })
        return
    end

    local playerPed = PlayerPedId()
    if not playerPed or playerPed == 0 then return end

    if dogFollowActive then
        -- Stop following the player
        ClearPedTasks(spawnedPetEntity)
        dogFollowActive = false
        SendNUIMessage({ action = "setFollowState", data = false })
        notify("Cachorro parou de seguir.", "primary")
    else
        -- Start following; must be obedient enough
        if not isPetObedient() then
            notify("Seu cachorro nao esta obediente o suficiente. De um petisco.", "error")
            return
        end

        dogFollowActive = true
        SendNUIMessage({ action = "setFollowState", data = true })
        notify("Cachorro esta seguindo voce.", "success")

        -- Follow thread.
        -- Handles both on-foot following and automatic vehicle boarding.
        CreateThread(function()
            local stuckMs       = 0
            local lastMoveSpeed = -1
            local enteringVeh   = false  -- true while TaskEnterVehicle is pending

            local initPed = PlayerPedId()
            TaskFollowToOffsetOfEntity(spawnedPetEntity, initPed, -1.5, 0.0, 0.0, 8.0, -1, 1.0, true)

            while dogFollowActive do
                Wait(200)
                if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then break end

                local ped         = PlayerPedId()
                local playerInVeh = IsPedInAnyVehicle(ped, false)
                local petInVeh    = IsPedInAnyVehicle(spawnedPetEntity, false)

                -- ── VEHICLE MODE ────────────────────────────────────────────
                if playerInVeh then
                    local vehicle = GetVehiclePedIsIn(ped, false)

                    if DoesEntityExist(vehicle) and not petInVeh and not enteringVeh then
                        -- Find the first free passenger seat (skip driver seat -1)
                        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                        for seat = 0, maxSeats - 1 do
                            if IsVehicleSeatFree(vehicle, seat, true) then
                                TaskEnterVehicle(spawnedPetEntity, vehicle, -1, seat, 2.0, 1, 0)
                                enteringVeh = true
                                stuckMs     = 0
                                lastMoveSpeed = -1
                                break
                            end
                        end
                    end
                    -- While the player is in a vehicle skip foot-follow logic entirely

                -- ── ON-FOOT MODE ────────────────────────────────────────────
                else
                    if petInVeh then
                        -- Player left the vehicle — tell the dog to exit too
                        local vehicle = GetVehiclePedIsIn(spawnedPetEntity, false)
                        TaskLeaveVehicle(spawnedPetEntity, vehicle, 0)
                        enteringVeh   = false
                        stuckMs       = 0
                        lastMoveSpeed = -1
                        Wait(1000)  -- give the exit animation time to play

                    elseif enteringVeh then
                        -- Player left before the dog finished boarding — cancel
                        ClearPedTasksImmediately(spawnedPetEntity)
                        enteringVeh   = false
                        lastMoveSpeed = -1

                    else
                        -- Normal on-foot follow ──────────────────────────────
                        local petCoords = GetEntityCoords(spawnedPetEntity)
                        local pedCoords = GetEntityCoords(ped)
                        local dist      = #(petCoords - pedCoords)
                        local pSpeed    = GetEntitySpeed(ped)
                        local petSpeed  = GetEntitySpeed(spawnedPetEntity)

                        -- Speed tier (re-issue only on change)
                        local moveSpeed
                        if dist > 10.0 or pSpeed > 5.0 then
                            moveSpeed = 20.0
                        elseif dist > 6.0 or pSpeed > 3.5 then
                            moveSpeed = 12.0
                        elseif pSpeed > 1.5 or dist > 3.0 then
                            moveSpeed = 4.0
                        else
                            moveSpeed = 1.5
                        end

                        local needReissue = (moveSpeed ~= lastMoveSpeed)
                        lastMoveSpeed = moveSpeed

                        -- Stuck detection (3 s grace — animals pause between path segments)
                        if dist > 5.0 and petSpeed < 0.1 then
                            stuckMs = stuckMs + 200
                            if stuckMs >= 3000 then
                                stuckMs     = 0
                                needReissue = true
                                ClearPedTasksImmediately(spawnedPetEntity)
                            end
                        else
                            stuckMs = 0
                        end

                        -- Safety teleport when navmesh gives up entirely
                        if dist > 50.0 then
                            local headingRad = math.rad(GetEntityHeading(ped))
                            SetEntityCoords(
                                spawnedPetEntity,
                                pedCoords.x - math.sin(headingRad) * 2.0,
                                pedCoords.y + math.cos(headingRad) * 2.0,
                                pedCoords.z,
                                false, false, false, false
                            )
                            PlaceObjectOnGroundProperly(spawnedPetEntity)
                            needReissue = true
                            stuckMs     = 0
                        end

                        if needReissue then
                            TaskFollowToOffsetOfEntity(spawnedPetEntity, ped, -1.5, 0.0, 0.0, moveSpeed, -1, 1.0, true)
                        end
                    end
                end
            end
        end)
    end
end)


-- =================== PET ANIMATIONS =======================
local CAT_SIT_SCENARIO = "WORLD_CAT_SLEEPING_GROUND"

-- Sitting scenarios keyed by dog breed substring
local DOG_SIT_SCENARIOS = {
    rottweiler = "WORLD_DOG_SITTING_ROTTWEILER",
    retriever  = "WORLD_DOG_SITTING_RETRIEVER",
    shepherd   = "WORLD_DOG_SITTING_SHEPHERD",
    small      = "WORLD_DOG_SITTING_SMALL",       -- Default for small/unknown breeds
}

-- Barking scenarios keyed by dog breed substring
local DOG_BARK_SCENARIOS = {
    rottweiler = "WORLD_DOG_BARKING_ROTTWEILER",
    retriever  = "WORLD_DOG_BARKING_RETRIEVER",
    shepherd   = "WORLD_DOG_BARKING_SHEPHERD",
    small      = "WORLD_DOG_BARKING_SMALL",
}

--- Selects the correct animation scenario for a dog by inspecting its model name.
--- Falls back to "small" for unrecognised breeds.
--- @param modelHash  number  From GetEntityModel.
--- @param scenarioTable  table  DOG_SIT_SCENARIOS or DOG_BARK_SCENARIOS.
--- @return string  Scenario name.
local function getDogScenarioByModel(modelHash, scenarioTable)
    for _, dogConfig in ipairs(Config.Dogs or {}) do
        if dogConfig.model and GetHashKey(dogConfig.model) == modelHash then
            local m = dogConfig.model:lower()
            if m:find("rottweiler") then return scenarioTable.rottweiler end
            if m:find("retriever")  then return scenarioTable.retriever  end
            if m:find("shepherd")   then return scenarioTable.shepherd   end
            return scenarioTable.small
        end
    end
    return scenarioTable.small
end

local function getDogSitScenario(modelHash)
    return getDogScenarioByModel(modelHash, DOG_SIT_SCENARIOS)
end

local function getDogBarkScenario(modelHash)
    return getDogScenarioByModel(modelHash, DOG_BARK_SCENARIOS)
end

--- Returns true when the given model hash matches any cat in Config.Cats.
--- Assigned to the forward-declared 'isCatModel' upvalue after definition.
--- @param modelHash  number
--- @return boolean
local function checkIsCatModel(modelHash)
    for _, catConfig in ipairs(Config.Cats or {}) do
        if catConfig.model and GetHashKey(catConfig.model) == modelHash then
            return true
        end
    end
    return false
end

isCatModel = checkIsCatModel  -- Wire up the forward-declared reference used throughout the file


-- =================== PET SIT =============================
RegisterNUICallback("petSit", function(_, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return
    end

    if not isPetObedient() then
        notify("Seu cachorro nao esta obediente o suficiente. De um petisco.", "error")
        return
    end

    local modelHash = GetEntityModel(spawnedPetEntity)

    if isCatModel(modelHash) then
        ClearPedTasks(spawnedPetEntity)
        SetPedKeepTask(spawnedPetEntity, true)
        PlaceObjectOnGroundProperly(spawnedPetEntity)
        TaskStartScenarioInPlace(spawnedPetEntity, CAT_SIT_SCENARIO, 0, true)
        notify("Gato sentou.", "success")
    else
        local scenario = getDogSitScenario(modelHash)
        ClearPedTasks(spawnedPetEntity)
        SetPedKeepTask(spawnedPetEntity, true)
        PlaceObjectOnGroundProperly(spawnedPetEntity)
        TaskStartScenarioInPlace(spawnedPetEntity, scenario, 0, true)
        notify("Cachorro sentou.", "success")
    end
end)


-- =================== PET BARK ============================
-- NUI callback is named "petGivePaw" but plays a bark / vocalistion scenario.
RegisterNUICallback("petGivePaw", function(_, cb)
    cb("ok")

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Nenhum pet spawnado.", "error")
        return
    end

    if not isPetObedient() then
        notify("Seu cachorro nao esta obediente o suficiente. De um petisco.", "error")
        return
    end

    local modelHash = GetEntityModel(spawnedPetEntity)

    if isCatModel(modelHash) then
        notify("Truque de latir esta desativado para gatos.", "error")
        return
    end

    local scenario = getDogBarkScenario(modelHash)
    ClearPedTasks(spawnedPetEntity)
    SetPedKeepTask(spawnedPetEntity, true)
    PlaceObjectOnGroundProperly(spawnedPetEntity)
    TaskStartScenarioInPlace(spawnedPetEntity, scenario, 0, true)
    notify("Cachorro latiu.", "success")
end)


-- ================== DEV: TEST SIT =========================
--- Developer command: spawns the first configured dog and makes it sit.
--- Useful for verifying model→scenario mapping without going through the shop UI.
RegisterCommand("testdogsit", function()
    local modelName = "a_c_rottweiler"
    if Config.Dogs and Config.Dogs[1] and Config.Dogs[1].model then
        modelName = Config.Dogs[1].model or modelName
    end

    spawnPetPed(modelName)

    if not spawnedPetEntity or not DoesEntityExist(spawnedPetEntity) then
        notify("Falha ao spawnar cachorro.", "error")
        print("[nn_petshop testdogsit] Failed to spawn dog.")
        return
    end

    Wait(300)
    if not DoesEntityExist(spawnedPetEntity) then return end

    local modelHash = GetEntityModel(spawnedPetEntity)
    local scenario  = getDogSitScenario(modelHash)

    print(string.format("[nn_petshop testdogsit] Model: %s -> Scenario: %s", modelName, scenario))

    ClearPedTasks(spawnedPetEntity)
    SetPedKeepTask(spawnedPetEntity, true)
    PlaceObjectOnGroundProperly(spawnedPetEntity)
    TaskStartScenarioInPlace(spawnedPetEntity, scenario, 0, true)
    notify("Cachorro sentou: " .. scenario, "success")
end, false)
