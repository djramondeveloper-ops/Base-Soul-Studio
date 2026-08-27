-- ================================================================
-- LB Phone - Server Main Handler
-- Core server functions for phone system management
-- Handles string generation, phone numbers, settings, and user management
-- ================================================================

-- Global variables for phone system
local phoneToSource = {}        -- Maps phone numbers to player sources
local phoneSettings = {}        -- Cached phone settings
local settingsChanged = {}      -- Tracks which settings have changed
local latestVersion = "seoul-dev-latest" -- Seoul local version label
local phoneObjects = {}         -- Server-side phone objects

-- Generate a random string with letters and numbers
-- Used for creating unique IDs and identifiers
local function GenerateString(length)
    local result = ""
    local startIndex = 1
    local stringLength = length or 15  -- Default length is 15 characters
    local step = 1
    
    -- Generate each character of the string
    for i = startIndex, stringLength, step do
        local charType = math.random(1, 2)  -- 1 for letter, 2 for number
        
        if charType == 1 then
            -- Generate a random letter (a-z)
            local randomChar = string.char(math.random(97, 122))
            
            -- 50% chance to make it uppercase
            local caseChoice = math.random(1, 2)
            if caseChoice == 1 then
                randomChar = randomChar:upper()
            end
            
            result = result .. randomChar
        else
            -- Generate a random number (1-9)
            local randomNumber = math.random(1, 9)
            result = result .. randomNumber
        end
    end
    
    return result
end
-- Generate a unique ID for a database table
-- Ensures the generated ID doesn't already exist in the specified table
function GenerateId(tableName, columnName)
    local isUnique = false
    local generatedId = nil
    
    -- Keep generating until we find a unique ID
    while not isUnique do
        -- Generate a 5-character string
        generatedId = GenerateString(5)
        
        -- Build query to check if ID already exists
        local query = "SELECT `" .. columnName .. "` FROM `" .. tableName .. "` WHERE `" .. columnName .. "` = @id"
        local parameters = {
            ["@id"] = generatedId
        }
        
        -- Check if ID already exists in database
        local existingId = MySQL.Sync.fetchScalar(query, parameters)
        isUnique = (existingId == nil)
        
        -- If not unique, wait a bit before trying again
        if not isUnique then
            Wait(50)
        end
    end
    
    return generatedId
end
-- Generate a unique phone number with optional prefix
-- Respects Config.PhoneNumber settings for length and prefixes
function GeneratePhoneNumber()
    local prefixes = Config.PhoneNumber.Prefixes
    local isUnique = false
    local finalNumber = nil
    
    -- Keep generating until we find a unique phone number
    while not isUnique do
        local numberString = ""
        local startIndex = 1
        local numberLength = Config.PhoneNumber.Length
        local step = 1
        
        -- Generate the base number (digits only)
        for i = startIndex, numberLength, step do
            local randomDigit = math.random(0, 9)
            numberString = numberString .. randomDigit
        end
        
        -- Add prefix if configured
        local prefixCount = #prefixes
        if prefixCount == 0 then
            -- No prefixes configured, use number as is
            finalNumber = numberString
        else
            -- Select random prefix and combine with number
            local randomPrefixIndex = math.random(1, prefixCount)
            local selectedPrefix = prefixes[randomPrefixIndex]
            finalNumber = selectedPrefix .. numberString
        end
        
        -- Check if this number already exists in database
        local existingNumber = MySQL.Sync.fetchScalar(
            "SELECT phone_number FROM phone_phones WHERE phone_number = @number",
            {["@number"] = finalNumber}
        )
        
        isUnique = (existingNumber == nil)
        
        -- If not unique, wait briefly before trying again
        if not isUnique then
            Wait(0)  -- Yield to prevent blocking
        end
    end
    
    return finalNumber
end
-- Get phone settings for a specific phone number
-- Returns cached settings or nil if not found
function GetSettings(phoneNumber)
    return phoneSettings[phoneNumber]
end

-- Export the GetSettings function for external use
exports("GetSettings", GetSettings)
-- Set phone settings for a specific phone number
-- Handles caching and database updates based on configuration
function SetSettings(phoneNumber, settings)
    -- If settings is nil, handle cleanup and database update
    if not settings then
        if settingsChanged[phoneNumber] then
            -- Remove from changed settings tracker
            settingsChanged[phoneNumber] = nil
            
            -- Update database if caching is enabled
            if Config.CacheSettings ~= false then
                debugprint("Updating settings in database for", phoneNumber)
                MySQL.update(
                    "UPDATE phone_phones SET settings = ? WHERE phone_number = ?",
                    {json.encode(phoneSettings[phoneNumber]), phoneNumber}
                )
            end
        end
    end
    
    -- Update cached settings
    phoneSettings[phoneNumber] = settings
end
-- Save all cached settings to database
-- Only saves settings that have been modified
function SaveAllSettings()
    -- Skip if caching is disabled
    if Config.CacheSettings == false then
        return
    end
    
    infoprint("info", "Saving all settings")
    
    -- Iterate through all cached settings
    for phoneNumber, settings in pairs(phoneSettings) do
        -- Only save if settings have been changed
        if settingsChanged[phoneNumber] then
            MySQL.update(
                "UPDATE phone_phones SET settings = ? WHERE phone_number = ?",
                {json.encode(settings), phoneNumber}
            )
        else
            debugprint("Not saving settings for", phoneNumber, "because no changes were made")
        end
    end
end
-- Callback: Handle player loaded event
-- Manages phone assignment and unique phone system
RegisterLegacyCallback("playerLoaded", function(source, callback)
    local playerIdentifier = GetIdentifier(source)
    
    debugprint(GetPlayerName(source), source, playerIdentifier, "triggered phone:playerLoaded")
    
    -- Handle non-unique phone system
    if not Config.Item.Unique then
        -- Get existing phone number for player
        local phoneNumber = MySQL.scalar.await(
            "SELECT phone_number FROM phone_phones WHERE id = ?",
            {playerIdentifier}
        )
        
        if phoneNumber then
            -- Check if player has the phone item
            if HasPhoneItem(source, phoneNumber) then
                -- Map phone number to player source
                phoneToSource[phoneNumber] = source
                
                -- Update last seen timestamp
                MySQL.update(
                    "UPDATE phone_phones SET last_seen = CURRENT_TIMESTAMP WHERE phone_number = ?",
                    {phoneNumber}
                )
            end
        end
        
        return callback(phoneNumber)
    end
    -- Handle unique phone system
    -- Get last used phone number for this player
    local lastPhoneNumber = MySQL.scalar.await(
        "SELECT phone_number FROM phone_last_phone WHERE id = ?",
        {playerIdentifier}
    )
    
    debugprint("result from phone_last_phone: ", lastPhoneNumber)
    
    if lastPhoneNumber then
        debugprint("checking if " .. source .. " has phone with metadata for last phone number equipped")
        
        -- Check if player has the phone item with this number
        if HasPhoneItem(source, lastPhoneNumber) then
            debugprint(source .. "has phone with metadata")
            
            -- Map phone number to player source
            phoneToSource[lastPhoneNumber] = source
            
            -- Update last seen timestamp
            MySQL.update(
                "UPDATE phone_phones SET last_seen = CURRENT_TIMESTAMP WHERE phone_number = ?",
                {lastPhoneNumber}
            )
            
            return callback(lastPhoneNumber)
        end
        
        debugprint(source .. " doesn't have phone with metadata for last phone number equipped")
        return callback()
    end
    -- Check if player has an empty phone (no number assigned)
    debugprint("checking if " .. source .. " has an empty phone")
    
    if not HasPhoneItem(source) then
        debugprint(source .. " does not have an empty phone")
        return callback()
    end
    
    debugprint(source .. " does have an empty phone, checking if they have an existing phone from pre-unique phone")
    
    -- Check for existing unassigned phone from before unique phone system
    local existingPhoneNumber = MySQL.scalar.await(
        "SELECT phone_number FROM phone_phones WHERE id = ? AND assigned = FALSE",
        {playerIdentifier}
    )
    
    if existingPhoneNumber then
        -- Try to set the phone number to the item metadata
        if SetPhoneNumber(source, existingPhoneNumber) then
            debugprint(source .. " does have an existing phone from pre-unique phone")
            
            -- Mark phone as assigned and update last seen
            MySQL.update(
                "UPDATE phone_phones SET assigned = TRUE, last_seen = CURRENT_TIMESTAMP WHERE phone_number = ?",
                {existingPhoneNumber}
            )
            
            -- Set as last used phone
            MySQL.update(
                "INSERT INTO phone_last_phone (id, phone_number) VALUES (?, ?)",
                {playerIdentifier, existingPhoneNumber}
            )
            
            -- Map phone number to player source
            phoneToSource[existingPhoneNumber] = source
            
            return callback(existingPhoneNumber)
        end
    end
    
    debugprint(source .. " does not have an existing phone from pre-unique phone, or failed to set number to item metadata")
    return callback()
end)
-- Callback: Set last used phone for a player
-- Handles phone switching and cleanup when phone is unequipped
RegisterLegacyCallback("setLastPhone", function(source, callback, phoneNumber)
    local playerIdentifier = GetIdentifier(source)
    local currentPhoneNumber = GetEquippedPhoneNumber(source)
    
    -- Save battery for current phone
    SaveBattery(source)
    
    -- Handle phone unequipping (phoneNumber is nil)
    if not phoneNumber then
        -- Remove last phone record
        MySQL.update(
            "DELETE FROM phone_last_phone WHERE id = ?",
            {playerIdentifier}
        )
        
        if currentPhoneNumber then
            -- Remove phone mapping
            phoneToSource[currentPhoneNumber] = nil
            
            -- Clear player state
            local playerState = Player(source).state
            playerState.phoneOpen = false
            playerState.phoneName = nil
            playerState.phoneNumber = nil
            
            -- Clear settings cache if exists
            if GetSettings(currentPhoneNumber) then
                SetSettings(currentPhoneNumber, nil)
            end
        end
        
        return callback()
    end
    -- Check if phone is already being used by another player
    if phoneToSource[phoneNumber] then
        if phoneToSource[phoneNumber] ~= source then
            -- Phone is being used by someone else
            return callback()
        end
    end
    
    -- Verify phone exists in database
    local phoneExists = MySQL.scalar.await(
        "SELECT 1 FROM phone_phones WHERE phone_number = ?",
        {phoneNumber}
    )
    
    if not phoneExists then
        infoprint("warning", 
            GetPlayerName(source) .. " | " .. source .. 
            " tried to use a phone with a number that doesn't exist. " ..
            "This usually happens when you delete the phone from phone_phones, " ..
            "without deleting the phone item from the player's inventory. " ..
            "Phone number: " .. phoneNumber
        )
        return callback()
    end
    -- Update last phone record in database
    MySQL.update.await(
        "INSERT INTO phone_last_phone (id, phone_number) VALUES (?, ?) ON DUPLICATE KEY UPDATE phone_number = ?",
        {playerIdentifier, phoneNumber, phoneNumber}
    )
    
    -- Clean up previous phone mapping if switching phones
    if currentPhoneNumber then
        phoneToSource[currentPhoneNumber] = nil
        
        -- Clear previous phone settings if exists
        if GetSettings(currentPhoneNumber) then
            SetSettings(currentPhoneNumber, nil)
        end
    end
    
    -- Set new phone mapping
    phoneToSource[phoneNumber] = source
    
    callback()
end)
-- Callback: Generate a new phone number for a player
-- Handles both unique and non-unique phone systems
RegisterLegacyCallback("generatePhoneNumber", function(source, callback)
    local playerIdentifier = GetIdentifier(source)
    local phoneId = playerIdentifier
    
    debugprint(GetPlayerName(source), source, playerIdentifier, "wants to generate a phone number")
    
    -- Handle unique phone system
    if Config.Item.Unique then
        debugprint("unique phones enabled, checking if " .. GetPlayerName(source) .. " has a phone item without a number assigned")
        
        -- Check if player has an empty phone item
        if not HasPhoneItem(source) then
            debugprint(GetPlayerName(source) .. " does not have a phone item without a number assigned")
            return callback()
        end
        
        -- Generate unique phone ID
        phoneId = GenerateId("phone_phones", "id")
    else
        -- Check if player already has a phone number (non-unique system)
        local existingNumber = MySQL.scalar.await(
            "SELECT phone_number FROM phone_phones WHERE id = ?",
            {playerIdentifier}
        )
        
        if existingNumber then
            infoprint("warning", 
                GetPlayerName(source) .. " wants to generate a phone number, but they already have one. " ..
                "Please set Config.Debug to true, and send the full log in customer-support if this happens again."
            )
            
            -- Map existing phone to player
            phoneToSource[existingNumber] = source
            return callback(existingNumber)
        end
    end
    -- Generate new phone number
    local newPhoneNumber = GeneratePhoneNumber()
    
    -- Insert phone record into database
    MySQL.update.await(
        "INSERT INTO phone_phones (id, owner_id, phone_number) VALUES (?, ?, ?)",
        {phoneId, playerIdentifier, newPhoneNumber}
    )
    
    -- Trigger phone number generated event
    TriggerEvent("lb-phone:phoneNumberGenerated", source, newPhoneNumber)
    
    -- Handle unique phone system setup
    if Config.Item.Unique then
        -- Set phone number to item metadata
        SetPhoneNumber(source, newPhoneNumber)
        
        -- Mark phone as assigned
        MySQL.update.await(
            "UPDATE phone_phones SET assigned = TRUE WHERE phone_number = ?",
            {newPhoneNumber}
        )
        
        -- Set as last used phone
        MySQL.update.await(
            "INSERT INTO phone_last_phone (id, phone_number) VALUES (?, ?) ON DUPLICATE KEY UPDATE phone_number = ?",
            {GetIdentifier(source), newPhoneNumber, newPhoneNumber}
        )
    end
    
    -- Map phone number to player source
    phoneToSource[newPhoneNumber] = source
    
    callback(newPhoneNumber)
end)
-- Callback: Get phone data for a player
-- Retrieves phone information from database and handles settings cache
RegisterLegacyCallback("getPhone", function(source, callback, phoneNumber)
    debugprint(GetPlayerName(source), "triggered phone:getPhone. checking if they have an item")
    
    -- Check if player has the phone item
    if not HasPhoneItem(source, phoneNumber) then
        debugprint(GetPlayerName(source), "does not have an item")
        return callback()
    end
    
    debugprint(GetPlayerName(source), "has an item, getting phone data")
    
    -- Get phone data from database
    local phoneData = MySQL.single.await(
        "SELECT owner_id, is_setup, settings, `name`, battery FROM phone_phones WHERE phone_number = ?",
        {phoneNumber}
    )
    
    if not phoneData then
        debugprint(GetPlayerName(source), "does not have any phone data")
        return callback()
    end
    -- Handle phone settings (cache or decode from database)
    if phoneData.settings then
        local cachedSettings = GetSettings(phoneNumber)
        
        if not cachedSettings then
            -- Decode settings from database and cache them
            phoneData.settings = json.decode(phoneData.settings)
            SetSettings(phoneNumber, phoneData.settings)
        else
            -- Use cached settings
            phoneData.settings = cachedSettings
        end
    end
    
    debugprint(GetPlayerName(source), "has phone data")
    
    -- Set owner if not already set (legacy support)
    if not phoneData.owner_id then
        debugprint(GetPlayerName(source) .. "'s phone does not have an owner, setting owner to " .. GetIdentifier(source))
        
        MySQL.update(
            "UPDATE phone_phones SET owner_id = ? WHERE phone_number = ?",
            {GetIdentifier(source), phoneNumber}
        )
    end
    
    return callback(phoneData)
end)
-- Get the phone number currently equipped by a player
-- Returns phone number if found, nil otherwise
function GetEquippedPhoneNumber(source, callback)
    -- Iterate through phone mappings to find this player's phone
    for phoneNumber, playerSource in pairs(phoneToSource) do
        if playerSource == source then
            -- Execute callback if provided
            if callback then
                callback(phoneNumber)
            end
            return phoneNumber
        end
    end
    
    -- No phone found for this player
    return nil
end

-- Get the player source for a given phone number
-- Returns source if phone is active, false otherwise
function GetSourceFromNumber(phoneNumber)
    if not phoneNumber then
        return false
    end
    
    local source = phoneToSource[phoneNumber]
    return source or false
end

-- Export GetSourceFromNumber for external use
exports("GetSourceFromNumber", GetSourceFromNumber)
-- Callback: Check if player is admin
-- Returns admin status from framework
RegisterLegacyCallback("isAdmin", function(source, callback)
    local isAdmin, adminLevel = IsAdmin(source)
    callback(isAdmin, adminLevel)
end)

-- Callback: Get player's character name
-- Returns firstname and lastname from framework
RegisterLegacyCallback("getCharacterName", function(source, callback)
    local firstname, lastname = GetCharacterName(source)
    callback({
        firstname = firstname,
        lastname = lastname
    })
end)
-- Seoul: version checker remoto desativado para evitar spam/changelog externo no console.
-- Mantém a versão local sincronizada com o fxmanifest.
CreateThread(function()
    latestVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or latestVersion
end)

-- Callback: Get latest version information
-- Returns cached version data from API
RegisterCallback("getLatestVersion", function(source)
    return latestVersion
end)
-- Event: Handle phone setup completion
-- Saves initial settings and creates email account if configured
RegisterNetEvent("phone:finishedSetup", function(settings)
    local playerSource = source
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    
    if not phoneNumber then
        return
    end
    
    -- Cache settings and update database
    SetSettings(phoneNumber, settings)
    MySQL.update(
        "UPDATE phone_phones SET is_setup = true, settings = ? WHERE phone_number = ?",
        {json.encode(settings), phoneNumber}
    )
    
    -- Auto-create email account if enabled
    if Config.AutoCreateEmail then
        GenerateEmailAccount(playerSource, phoneNumber)
    end
end)
-- Event: Set phone name
-- Updates phone name with validation and filtering
RegisterNetEvent("phone:setName", function(phoneName)
    local playerSource = source
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    
    if not phoneNumber then
        return
    end
    
    -- Apply name filter if configured
    if Config.NameFilter then
        if not phoneName:match(Config.NameFilter) then
            infoprint("warning", 
                "Player " .. GetPlayerName(playerSource) .. 
                " tried to set an invalid phone name: " .. phoneName
            )
            
            -- Fallback to character name format
            local firstname, lastname = GetCharacterName(playerSource)
            phoneName = L("BACKEND.MISC.X_PHONE", {
                name = firstname,
                lastname = lastname
            })
        end
    end
    
    -- Update phone name in database
    MySQL.Async.execute(
        "UPDATE phone_phones SET `name`=@name WHERE phone_number=@phoneNumber",
        {
            ["@phoneNumber"] = phoneNumber,
            ["@name"] = phoneName
        }
    )
    
    -- Update item name for unique phones
    if Config.Item.Unique then
        if SetItemName then
            SetItemName(playerSource, phoneNumber, phoneName)
        end
    end
    
    -- Update cached settings
    local settings = GetSettings(phoneNumber)
    if settings then
        settings.name = phoneName
    end
    
    -- Update player state
    Player(playerSource).state.phoneName = phoneName
end)
-- Base Callback: Save phone settings
-- Handles settings caching and immediate database updates
BaseCallback("setSettings", function(source, phoneNumber, settings)
    debugprint(source, "saving settings for phone number", phoneNumber)
    
    -- Mark settings as changed for this phone
    settingsChanged[phoneNumber] = true
    
    -- Update cached settings
    SetSettings(phoneNumber, settings)
    
    -- Immediate database update if caching is disabled
    if Config.CacheSettings == false then
        MySQL.update(
            "UPDATE phone_phones SET settings = ? WHERE phone_number = ?",
            {json.encode(settings), phoneNumber}
        )
    end
end)
-- Event: Toggle phone open/closed state
-- Updates player state for phone status
RegisterNetEvent("phone:togglePhone", function(isOpen, phoneName)
    local playerSource = source
    local playerState = Player(playerSource).state
    
    -- Set phone open status
    playerState.phoneOpen = isOpen
    
    -- Get equipped phone number
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    if not phoneNumber then
        return
    end
    
    -- Update phone information in player state.
    -- Some client paths in this build call phone:togglePhone without passing
    -- phoneName. Do not erase a valid name; recover it from the cached settings
    -- or phone row so AirShare/contact sharing keeps working.
    if type(phoneName) ~= "string" or phoneName == "" then
        phoneName = playerState.phoneName
    end

    if (type(phoneName) ~= "string" or phoneName == "") then
        local settings = GetSettings(phoneNumber)
        if settings and type(settings.name) == "string" and settings.name ~= "" then
            phoneName = settings.name
        end
    end

    if (type(phoneName) ~= "string" or phoneName == "") then
        phoneName = MySQL.scalar.await(
            "SELECT `name` FROM phone_phones WHERE phone_number = ? LIMIT 1",
            { phoneNumber }
        )
    end

    if type(phoneName) ~= "string" or phoneName == "" then
        local firstname, lastname = GetCharacterName(playerSource)
        if firstname then
            phoneName = L("BACKEND.MISC.X_PHONE", {
                name = firstname,
                lastname = lastname or ""
            })
        else
            phoneName = phoneNumber
        end
    end

    playerState.phoneName = phoneName
    playerState.phoneNumber = phoneNumber
end)

-- Event: Toggle phone flashlight
-- Updates player state for flashlight status
RegisterNetEvent("phone:toggleFlashlight", function(isFlashlightOn)
    local playerState = Player(source).state
    playerState.flashlight = isFlashlightOn
end)
-- Event: Set phone object for server-side spawning
-- Manages phone prop entities for players
RegisterNetEvent("phone:setPhoneObject", function(networkId)
    local playerSource = source
    
    -- Handle phone object deletion if server-side spawning is enabled
    if Config.ServerSideSpawn and not networkId then
        local existingObjectId = phoneObjects[playerSource]
        if existingObjectId then
            debugprint("Deleting phone object for player " .. playerSource)
            DeleteEntity(NetworkGetEntityFromNetworkId(existingObjectId))
        end
    end
    
    -- Update phone object mapping
    phoneObjects[playerSource] = networkId
end)
-- Event: Handle player disconnection
-- Cleanup phone objects, settings, and mappings
AddEventHandler("playerDropped", function()
    local playerSource = source
    local phoneObjectId = phoneObjects[playerSource]
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    
    -- Clean up phone object if exists
    if phoneObjectId then
        local phoneEntity = NetworkGetEntityFromNetworkId(phoneObjectId)
        if phoneEntity then
            DeleteEntity(phoneEntity)
        end
        phoneObjects[playerSource] = nil
    end
    
    -- Clean up phone mappings and settings
    if phoneNumber then
        -- Wait a bit before cleanup to ensure proper disconnection
        Wait(1000)
        
        -- Clear settings cache
        SetSettings(phoneNumber, nil)
        
        -- Remove phone to source mapping
        phoneToSource[phoneNumber] = nil
    end
end)
-- Event: Handle resource stop
-- Clean up all phone objects and save settings
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    
    -- Delete all phone objects
    for playerSource, phoneObjectId in pairs(phoneObjects) do
        local phoneEntity = NetworkGetEntityFromNetworkId(phoneObjectId)
        if phoneEntity then
            DeleteEntity(phoneEntity)
        end
    end
    
    -- Save all cached settings to database
    SaveAllSettings()
end)

-- Event: Handle server shutdown
-- Ensure all settings are saved before shutdown
AddEventHandler("txAdmin:events:serverShuttingDown", function()
    SaveAllSettings()
end)
-- Perform factory reset on a phone
-- Clears all data and logged in accounts
function FactoryReset(phoneNumber)
    -- Delete all logged in accounts for this phone
    MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE phone_number = ?",
        {phoneNumber}
    )
    
    -- Reset phone to factory defaults
    local resetSuccess = MySQL.update.await(
        "UPDATE phone_phones SET is_setup = false, settings = NULL, pin = NULL, face_id = NULL WHERE phone_number = ?",
        {phoneNumber}
    ) > 0
    
    if resetSuccess then
        -- Get player source for this phone
        local playerSource = phoneToSource[phoneNumber]
        if playerSource then
            -- Trigger client-side factory reset
            TriggerClientEvent("phone:factoryReset", playerSource)
            
            -- Clear cached settings
            SetSettings(phoneNumber, nil)
            
            -- Remove phone mapping
            phoneToSource[phoneNumber] = nil
        end
    end
end

-- Event: Handle factory reset request
-- Resets the phone for the requesting player
RegisterNetEvent("phone:factoryReset", function()
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return
    end
    
    FactoryReset(phoneNumber)
end)

-- Export factory reset function for external use
exports("FactoryReset", FactoryReset)
