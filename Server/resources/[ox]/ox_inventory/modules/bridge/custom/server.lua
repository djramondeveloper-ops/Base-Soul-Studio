local function seoulOxDebug()
    local value = tostring(GetConvar("seoul:debug", "false")):lower()
    return value == "true" or value == "1" or value == "yes" or value == "sim"
end

local Inventory = require 'modules.inventory.server'

local function ensureVrpProxy()
    if _G.__seoul_ox_vrp_proxy then
        return _G.__seoul_ox_vrp_proxy
    end

    if not module or not async then
        local utils = LoadResourceFile('vrp', 'lib/Utils.lua')
        if utils then
            local chunk, err = load(utils, '@vrp/lib/Utils.lua')
            if chunk then
                local ok, result = pcall(chunk)
                if not ok then
                    print(('^3[Seoul][OX]^7 Falha ao carregar vrp/lib/Utils.lua: %s'):format(result))
                end
            else
                print(('^3[Seoul][OX]^7 Falha no load de vrp/lib/Utils.lua: %s'):format(err))
            end
        end
    end

    if not module then
        print('^1[Seoul][OX]^7 module() da vRP não está disponível para o bridge.')
        return nil
    end

    local ok, Proxy = pcall(module, 'vrp', 'lib/Proxy')
    if not ok or not Proxy or not Proxy.getInterface then
        print(('^1[Seoul][OX]^7 Falha ao carregar Proxy da vRP: %s'):format(Proxy or 'Proxy inválido'))
        return nil
    end

    _G.__seoul_ox_vrp_proxy = Proxy.getInterface('vRP')
    return _G.__seoul_ox_vrp_proxy
end

local vRP = ensureVrpProxy()

local function vRPCall(name, ...)
    vRP = vRP or ensureVrpProxy()
    if not vRP then return nil end

    local fn = vRP[name]
    if type(fn) ~= 'function' then return nil end

    local ok, result = pcall(fn, ...)
    if not ok then
        print(('^3[Seoul][OX]^7 vRP.%s falhou: %s'):format(name, result))
        return nil
    end

    return result
end

local function passportFromSource(source)
    return tonumber(vRPCall('Passport', tonumber(source)) or 0)
end

local function normalizeGroups(Passport)
    local groups = {}
    local userGroups = vRPCall('UserGroups', Passport) or {}

    for name, level in pairs(userGroups) do
        groups[tostring(name)] = tonumber(level) or 0
    end

    return groups
end

local function identityName(identity)
    identity = identity or {}
    local first = identity.Name or identity.name or 'Individuo'
    local last = identity.Lastname or identity.name2 or 'Indigente'
    return ('%s %s'):format(first, last)
end

local function convertVrpInventory(data)
    local converted = {}
    local slot = 0

    if type(data) ~= 'table' then
        return converted
    end

    for key, value in pairs(data) do
        if type(value) == 'table' then
            local name = value.name or value.item
            local count = value.count or value.amount
            local itemSlot = tonumber(value.slot or key)

            if name and tonumber(count) and tonumber(count) > 0 then
                slot = slot + 1
                converted[slot] = {
                    name = tostring(name),
                    count = tonumber(count),
                    slot = itemSlot or slot,
                    metadata = value.metadata or value.info
                }
            end
        end
    end

    return converted
end

local function getVrpLegacyInventory(Passport)
    local datatable = vRPCall('Datatable', Passport) or {}
    return convertVrpInventory(datatable.Inventory or {})
end

local function makePlayer(Passport, source)
    local identity = vRPCall('Identity', Passport) or {}

    return {
        source = tonumber(source),
        identifier = ('vrp:%s'):format(Passport),
        name = identityName(identity),
        groups = normalizeGroups(Passport),
        sex = identity.Sex or identity.sex,
        dateofbirth = identity.Birthdate or identity.Birth or identity.birthdate
    }
end

local function loadPlayerInventory(Passport, source)
    Passport = tonumber(Passport)
    source = tonumber(source)

    if not Passport or not source or not server.setPlayerInventory then
        return
    end

    -- Evita carregar o mesmo inventário duas vezes.
    -- O ox_inventory derruba erro quando setPlayerInventory roda novamente para o mesmo owner/source.
    local activeInv = Inventory(source)
    if activeInv and activeInv.player then
        return
    end

    local owner = ('vrp:%s'):format(Passport)
    local existing = MySQL.scalar.await("SELECT data FROM ox_inventory WHERE owner = ? AND name = 'player' LIMIT 1", { owner })
    local initialData

    if not existing then
        initialData = getVrpLegacyInventory(Passport)
    end

    server.setPlayerInventory(makePlayer(Passport, source), initialData)
end

AddEventHandler('Connect', function(Passport, source)
    SetTimeout(750, function()
        loadPlayerInventory(Passport, source)
    end)
end)

AddEventHandler('playerDropped', function()
    server.playerDropped(source)
end)

SetTimeout(3000, function()
    for _, src in ipairs(GetPlayers()) do
        src = tonumber(src)
        local Passport = passportFromSource(src)
        if Passport and Passport > 0 then
            loadPlayerInventory(Passport, src)
        end
    end
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    return {
        source = player.source,
        name = player.name,
        groups = player.groups or {},
        sex = player.sex,
        dateofbirth = player.dateofbirth
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.UseItem(source, itemName, data)
    local Passport = passportFromSource(source)
    if not Passport or Passport <= 0 then return false end

    local slot = data and tonumber(data.slot)
    if not slot then return false end

    local amount = 1
    if itemName == 'gemstone' and data and tonumber(data.count) and tonumber(data.count) > 0 then
        amount = tonumber(data.count)
    end

    if GetResourceState('inventory') == 'started' then
        local ok, result = pcall(function()
            return exports.inventory:UseItemFromOx(source, slot, amount)
        end)

        if ok then
            if result == false then
                if seoulOxDebug() then print(('^3[Seoul][OX]^7 inventory recusou uso do item %s slot %s Passport %s.'):format(tostring(itemName), tostring(slot), tostring(Passport))) end
            end
            return result ~= false
        end

        print(('^1[Seoul][OX]^7 Falha no export inventory:UseItemFromOx para %s slot %s: %s'):format(tostring(itemName), tostring(slot), tostring(result)))
    end

    return false
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, name)
    return false
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
    return false, 'not_supported'
end

---@diagnostic disable-next-line: duplicate-set-field
function server.getOwnedVehicleId(entityId)
    local plate = GetVehicleNumberPlateText(entityId)
    return plate and plate:gsub('%s+', '') or nil
end

if seoulOxDebug() then print('^2[Seoul]^7 ox_inventory bridge vRP ativo.') end
