CreateThread(function()
    Wait(500)
    ensureSchema()
    print('^2[nn_petshop]^0 Server ready (Seoul vRP/Creative + oxmysql).')
end)

local function getIdentifier(src)
    return PetshopFramework and PetshopFramework.GetIdentifier(src)
end

local function getCash(src)
    return PetshopFramework and PetshopFramework.GetCash(src) or 0
end

local function removeCash(src, amount)
    return PetshopFramework and PetshopFramework.RemoveCash(src, amount)
end

local function notifyClient(src, success, message)
    TriggerClientEvent('nn_petshop:client:notify', src, success == true, message)
end

local function hasItem(src, itemName, amount)
    return PetshopFramework and PetshopFramework.HasItem(src, itemName, amount)
end

local function removeItem(src, itemName, amount)
    return PetshopFramework and PetshopFramework.RemoveItem(src, itemName, amount)
end

local function addItem(src, itemName, amount)
    return PetshopFramework and PetshopFramework.AddItem(src, itemName, amount)
end

local function columnExists(tableName, columnName)
    local rows = MySQL.query.await([[
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = ?
            AND COLUMN_NAME = ?
        LIMIT 1
    ]], { tableName, columnName })

    return rows and rows[1] ~= nil
end

local function ensureColumn(tableName, columnName, definition)
    if columnExists(tableName, columnName) then
        return
    end

    MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `%s` %s'):format(tableName, columnName, definition))
    print(('^2[nn_petshop]^0 DB column added: %s.%s'):format(tableName, columnName))
end

function ensureSchema()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `nn_petshop_pets` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(64) NOT NULL,
            `pet_type` VARCHAR(16) NOT NULL,
            `pet_id` VARCHAR(64) NOT NULL,
            `custom_name` VARCHAR(64) DEFAULT NULL,
            `obedience` INT NOT NULL DEFAULT 100,
            `hunger` INT NOT NULL DEFAULT 100,
            `thirst` INT NOT NULL DEFAULT 100,
            `equipped_clothing` VARCHAR(64) DEFAULT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `owner_pet` (`identifier`, `pet_type`, `pet_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `nn_petshop_clothing` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(64) NOT NULL,
            `clothing_id` VARCHAR(64) NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `owner_clothing` (`identifier`, `clothing_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    ensureColumn('nn_petshop_pets', 'custom_name', 'VARCHAR(64) DEFAULT NULL')
    ensureColumn('nn_petshop_pets', 'obedience', 'INT NOT NULL DEFAULT 100')
    ensureColumn('nn_petshop_pets', 'hunger', 'INT NOT NULL DEFAULT 100')
    ensureColumn('nn_petshop_pets', 'thirst', 'INT NOT NULL DEFAULT 100')
    ensureColumn('nn_petshop_pets', 'equipped_clothing', 'VARCHAR(64) DEFAULT NULL')
end

local function defaultObedience()
    local cfg = Config.Obedience
    return tonumber(cfg and cfg.startValue) or 100
end

local function defaultHunger()
    local cfg = Config.Hunger
    return tonumber(cfg and cfg.startValue) or 100
end

local function defaultThirst()
    local cfg = Config.Thirst
    return tonumber(cfg and cfg.startValue) or 100
end

local function findPet(petType, petId)
    petType = tostring(petType or ''):lower()
    petId = tostring(petId or '')

    local list
    if petType == 'cat' or petType == 'cats' then
        list = Config.Cats
    else
        list = Config.Dogs
        petType = 'dog'
    end

    for _, entry in ipairs(list or {}) do
        if entry.id == petId then
            return entry, petType == 'cat' and 'cat' or 'dog'
        end
    end

    return nil, petType == 'cat' and 'cat' or 'dog'
end

local function findClothing(clothingId)
    clothingId = tostring(clothingId or ''):lower()
    if clothingId == '' or clothingId == 'none' then
        return nil
    end

    for _, entry in ipairs(Config.Clothing or {}) do
        if entry.id == clothingId then
            return entry
        end
    end

    return nil
end

local function findTreat(treatType)
    treatType = tostring(treatType or ''):lower()
    if treatType == '' then
        return nil
    end
    return Config.Treats and Config.Treats[treatType] or nil
end

local function fetchOwned(identifier)
    local dogs = {}
    local cats = {}
    local clothing = {}
    local dogStats = {}

    local petRows = MySQL.query.await(
        'SELECT pet_type, pet_id, obedience, hunger, thirst FROM nn_petshop_pets WHERE identifier = ?',
        { identifier }
    ) or {}

    for _, row in ipairs(petRows) do
        if row.pet_type == 'dog' then
            dogs[#dogs + 1] = row.pet_id
            dogStats[row.pet_id] = {
                obedience = tonumber(row.obedience) or defaultObedience(),
                hunger = tonumber(row.hunger) or defaultHunger(),
                thirst = tonumber(row.thirst) or defaultThirst(),
            }
        elseif row.pet_type == 'cat' then
            cats[#cats + 1] = row.pet_id
        end
    end

    local clothRows = MySQL.query.await(
        'SELECT clothing_id FROM nn_petshop_clothing WHERE identifier = ?',
        { identifier }
    ) or {}

    for _, row in ipairs(clothRows) do
        clothing[#clothing + 1] = row.clothing_id
    end

    return {
        dogs = dogs,
        cats = cats,
        clothing = clothing,
        dogStats = dogStats,
    }
end

local function ownsPet(identifier, petType, petId)
    local row = MySQL.single.await(
        'SELECT id FROM nn_petshop_pets WHERE identifier = ? AND pet_type = ? AND pet_id = ? LIMIT 1',
        { identifier, petType, petId }
    )
    return row ~= nil
end

local function ownsClothing(identifier, clothingId)
    local row = MySQL.single.await(
        'SELECT id FROM nn_petshop_clothing WHERE identifier = ? AND clothing_id = ? LIMIT 1',
        { identifier, clothingId }
    )
    return row ~= nil
end

local function sendOwned(src, eventName)
    local identifier = getIdentifier(src)
    if not identifier then
        TriggerClientEvent(eventName, src, { dogs = {}, cats = {}, clothing = {} })
        return
    end

    TriggerClientEvent(eventName, src, fetchOwned(identifier))
end

RegisterNetEvent('nn_petshop:server:requestPurchased', function()
    local src = source
    sendOwned(src, 'nn_petshop:client:receivedPurchased')
end)

RegisterNetEvent('nn_petshop:server:requestPurchasedSpawn', function()
    local src = source
    sendOwned(src, 'nn_petshop:client:receivedPurchasedForSpawn')
end)

RegisterNetEvent('nn_petshop:server:purchase', function(petType, petId, clothingId, customName)
    local src = source
    local identifier = getIdentifier(src)
    if not identifier then
        notifyClient(src, false, 'Passaporte nao encontrado.')
        return
    end

    local pet, normalizedType = findPet(petType, petId)
    if not pet then
        notifyClient(src, false, 'Pet invalido no config.')
        return
    end

    if ownsPet(identifier, normalizedType, pet.id) then
        notifyClient(src, false, 'Voce ja possui esse pet.')
        return
    end

    local total = tonumber(pet.price) or 0
    local clothingEntry

    if clothingId and clothingId ~= '' and clothingId ~= 'none' then
        clothingEntry = findClothing(clothingId)
        if clothingEntry and not ownsClothing(identifier, clothingEntry.id) then
            total = total + (tonumber(clothingEntry.price) or 0)
        end
    end

    if getCash(src) < total then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    if not removeCash(src, total) then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    local custom = customName
    if type(custom) == 'string' and custom:match('^%s*$') then
        custom = nil
    end

    local ok, insertErr = pcall(function()
        MySQL.insert.await(
        'INSERT INTO nn_petshop_pets (identifier, pet_type, pet_id, custom_name, obedience, hunger, thirst) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            identifier,
            normalizedType,
            pet.id,
            custom,
            defaultObedience(),
            defaultHunger(),
            defaultThirst(),
        }
        )
    end)

    if not ok then
        print(('^1[nn_petshop]^0 Failed to save pet purchase: %s'):format(tostring(insertErr)))
        if PetshopFramework and PetshopFramework.RefundCash then
            PetshopFramework.RefundCash(src, total)
        end
        notifyClient(src, false, 'Erro ao salvar pet no banco.')
        return
    end

    if clothingEntry and not ownsClothing(identifier, clothingEntry.id) then
        local clothOk, clothErr = pcall(function()
            MySQL.insert.await(
            'INSERT INTO nn_petshop_clothing (identifier, clothing_id) VALUES (?, ?)',
            { identifier, clothingEntry.id }
            )
        end)

        if not clothOk then
            print(('^1[nn_petshop]^0 Failed to save clothing purchase: %s'):format(tostring(clothErr)))
            if PetshopFramework and PetshopFramework.RefundCash then
                PetshopFramework.RefundCash(src, tonumber(clothingEntry.price) or 0)
            end
            notifyClient(src, false, 'Pet comprado, mas o acessorio nao salvou no banco.')
        end
    end

    notifyClient(src, true, Config.Messages and Config.Messages.purchased)
    TriggerClientEvent('nn_petshop:client:closeUi', src)

    if pet.model then
        TriggerClientEvent('nn_petshop:client:spawnPet', src, pet.model)
    end
end)

RegisterNetEvent('nn_petshop:server:buyClothingEvent', function(clothingId)
    local src = source
    local identifier = getIdentifier(src)
    if not identifier then
        notifyClient(src, false, 'Passaporte nao encontrado.')
        return
    end

    local entry = findClothing(clothingId)
    if not entry then
        notifyClient(src, false, 'Acessorio invalido no config.')
        return
    end

    if ownsClothing(identifier, entry.id) then
        notifyClient(src, false, 'Voce ja possui esse acessorio.')
        return
    end

    local price = tonumber(entry.price) or 0
    if getCash(src) < price then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    if not removeCash(src, price) then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    local ok, insertErr = pcall(function()
        MySQL.insert.await(
        'INSERT INTO nn_petshop_clothing (identifier, clothing_id) VALUES (?, ?)',
        { identifier, entry.id }
        )
    end)

    if not ok then
        print(('^1[nn_petshop]^0 Failed to save clothing purchase: %s'):format(tostring(insertErr)))
        if PetshopFramework and PetshopFramework.RefundCash then
            PetshopFramework.RefundCash(src, price)
        end
        notifyClient(src, false, 'Erro ao salvar acessorio no banco.')
        return
    end

    notifyClient(src, true, Config.Messages and Config.Messages.purchased)
    TriggerClientEvent('nn_petshop:client:receivedPurchasedClothing', src, entry.id)
end)

RegisterNetEvent('nn_petshop:server:buyTreat', function(treatType)
    local src = source
    local identifier = getIdentifier(src)
    if not identifier then
        notifyClient(src, false, 'Passaporte nao encontrado.')
        return
    end

    local treat = findTreat(treatType)
    if not treat or not treat.item then
        notifyClient(src, false, 'Petisco invalido no config.')
        return
    end

    local price = tonumber(treat.price) or 0
    if getCash(src) < price then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    if PetshopFramework and PetshopFramework.CanCarryItem then
        if not PetshopFramework.CanCarryItem(src, treat.item, 1) then
            notifyClient(src, false, 'Sem espaco no inventario.')
            return
        end
    end

    if not removeCash(src, price) then
        notifyClient(src, false, Config.Messages and Config.Messages.notEnoughMoney)
        return
    end

    if not addItem(src, treat.item, 1) then
        if PetshopFramework and PetshopFramework.RefundCash then
            PetshopFramework.RefundCash(src, price)
        end
        notifyClient(src, false, Config.Messages and Config.Messages.error)
        return
    end

    notifyClient(src, true, ('Voce comprou %s.'):format(treat.name or treatType))
end)

RegisterNetEvent('nn_petshop:server:giveTreatToDog', function(payload)
    local src = source
    local identifier = getIdentifier(src)
    if not identifier then
        return
    end

    local treatType
    if type(payload) == 'table' then
        treatType = payload.treatType or payload.treat_type
    else
        treatType = payload
    end

    local treat = findTreat(treatType)
    if not treat then
        local legacyItem = Config.Obedience and Config.Obedience.treatItem
        if legacyItem and hasItem(src, legacyItem, 1) then
            removeItem(src, legacyItem, 1)
            local boost = tonumber(Config.Obedience.treatBoost) or 25
            TriggerClientEvent('nn_petshop:client:applyTreatBoost', src, boost)
            return
        end
        notifyClient(src, false, 'Petisco invalido.')
        return
    end

    if not hasItem(src, treat.item, 1) then
        notifyClient(src, false, ('Voce precisa de %s.'):format(treat.name or treat.item))
        return
    end

    if not removeItem(src, treat.item, 1) then
        notifyClient(src, false, Config.Messages and Config.Messages.error)
        return
    end

    TriggerClientEvent('nn_petshop:client:applyTreatEffects', src, {
        obedienceBoost = tonumber(treat.obedienceBoost) or 0,
        hunger = tonumber(treat.hunger) or 0,
        thirst = tonumber(treat.thirst) or 0,
    })
end)

RegisterNetEvent('nn_petshop:server:equipClothing', function(clothingId)
    local src = source
    local identifier = getIdentifier(src)
    if not identifier then
        return
    end

    clothingId = tostring(clothingId or ''):lower()
    if clothingId == '' or clothingId == 'none' then
        TriggerClientEvent('nn_petshop:client:doEquipClothing', src, 'none')
        return
    end

    if not ownsClothing(identifier, clothingId) then
        notifyClient(src, false, 'Voce nao possui esse acessorio.')
        return
    end

    if not findClothing(clothingId) then
        notifyClient(src, false, Config.Messages and Config.Messages.error)
        return
    end

    TriggerClientEvent('nn_petshop:client:doEquipClothing', src, clothingId)
end)
