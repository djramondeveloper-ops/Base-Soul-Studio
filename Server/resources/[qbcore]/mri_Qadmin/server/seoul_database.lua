-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL DATABASE COMPAT
-- Mapeia o MRI QAdmin para as tabelas reais da Seoul Base.
-- NÃO cria tabela players/player_vehicles/bans; usa characters, vehicles e accounts.
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulQAdminDB = SeoulQAdminDB or {}

local function toNumber(value, default)
    local n = tonumber(value)
    if n == nil then return default or 0 end
    return n
end

local function trim(value)
    if value == nil then return '' end
    return (tostring(value):gsub('^%s*(.-)%s*$', '%1'))
end

local function normalizeLicense(license)
    if not license or license == '' then return nil end
    license = trim(license)
    license = license:gsub('^identifier%.', '')
    license = license:gsub('^license:license2:', 'license2:')
    license = license:gsub('^license:license:', 'license:')
    return license
end

function SeoulQAdminDB.NormalizeLicense(license)
    return normalizeLicense(license)
end

function SeoulQAdminDB.PassportFromCitizenId(citizenid)
    return toNumber(citizenid, nil)
end

function SeoulQAdminDB.GetCharacter(passport)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    if not passport then return nil end
    return MySQL.single.await([[SELECT id, Name, Lastname, License, Bank, age, Sex, Created, Login, Deleted FROM characters WHERE id = ? LIMIT 1]], { passport })
end

function SeoulQAdminDB.GetLicenseByPassport(passport)
    local row = SeoulQAdminDB.GetCharacter(passport)
    return row and row.License or nil
end

function SeoulQAdminDB.GetPhone(passport)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    if not passport then return nil end
    return MySQL.scalar.await([[SELECT phone_number FROM phone_phones WHERE owner_id = ? ORDER BY assigned DESC LIMIT 1]], { 'vrp:' .. passport })
end

function SeoulQAdminDB.GetCharacterName(row)
    if not row then return 'N/A' end
    return trim((row.Name or row.name or 'Individuo') .. ' ' .. (row.Lastname or row.lastname or 'Indigente'))
end

function SeoulQAdminDB.MakeCharInfo(row, phone)
    row = row or {}
    return {
        firstname = row.Name or row.name or 'Individuo',
        lastname = row.Lastname or row.lastname or 'Indigente',
        birthdate = row.age and ('Idade: ' .. tostring(row.age)) or 'Desconhecido',
        gender = (row.Sex == 'F' or row.sex == 'F') and 1 or 0,
        phone = phone or 'Desconhecido',
        account = tostring(row.id or '')
    }
end

function SeoulQAdminDB.GetAccountByLicense(license)
    license = normalizeLicense(license)
    if not license then return nil end
    return MySQL.single.await([[SELECT id, License, Banned, Reason FROM accounts WHERE License = ? LIMIT 1]], { license })
end

function SeoulQAdminDB.IsLicenseBanned(license)
    local account = SeoulQAdminDB.GetAccountByLicense(license)
    if not account then return nil end
    local banned = toNumber(account.Banned, 0)
    if banned == -1 or banned > os.time() then
        return { id = account.id, license = account.License, reason = account.Reason or 'Banimento administrativo', expire = banned, bannedby = 'Seoul Admin' }
    end
    return nil
end

function SeoulQAdminDB.BanLicense(license, reason, expire)
    license = normalizeLicense(license)
    if not license then return false end
    reason = tostring(reason or 'Banimento administrativo')
    expire = toNumber(expire, -1)
    if expire >= 2147483647 then expire = -1 end
    local affected = MySQL.update.await([[UPDATE accounts SET Banned = ?, Reason = ? WHERE License = ?]], { expire, reason, license })
    return affected and affected > 0
end

function SeoulQAdminDB.UnbanLicense(license)
    license = normalizeLicense(license)
    if not license then return 0 end
    return MySQL.update.await([[UPDATE accounts SET Banned = 0, Reason = NULL WHERE License = ?]], { license }) or 0
end

function SeoulQAdminDB.UnbanPassport(passport)
    local license = SeoulQAdminDB.GetLicenseByPassport(passport)
    if not license then return 0 end
    return SeoulQAdminDB.UnbanLicense(license)
end

function SeoulQAdminDB.ListBans(search, limit, offset)
    search = trim(search)
    limit = math.max(1, math.min(tonumber(limit) or 50, 200))
    offset = math.max(0, tonumber(offset) or 0)
    local now = os.time()
    local where = [[ WHERE a.Banned <> 0 AND (a.Banned = -1 OR a.Banned > ?) ]]
    local params = { now }
    if search ~= '' then
        local pattern = '%' .. search .. '%'
        where = where .. [[ AND (a.License LIKE ? OR a.Reason LIKE ? OR CONCAT(c.Name, ' ', c.Lastname) LIKE ? OR CAST(c.id AS CHAR) LIKE ?) ]]
        params[#params+1] = pattern; params[#params+1] = pattern; params[#params+1] = pattern; params[#params+1] = pattern
    end
    local total = MySQL.scalar.await([[SELECT COUNT(1) FROM accounts a LEFT JOIN characters c ON c.License = a.License ]] .. where, params) or 0
    local q = [[
        SELECT a.id, a.License as license, a.Reason as reason, a.Banned as expire,
               COALESCE(CONCAT(c.Name, ' ', c.Lastname), a.License) as name,
               'Seoul Admin' as bannedby
        FROM accounts a
        LEFT JOIN characters c ON c.License = a.License
    ]] .. where .. [[ ORDER BY a.Banned DESC LIMIT ? OFFSET ? ]]
    local qparams = { table.unpack(params) }
    qparams[#qparams+1] = limit
    qparams[#qparams+1] = offset
    local rows = MySQL.query.await(q, qparams) or {}
    return rows, total
end

function SeoulQAdminDB.DeleteCharacter(passport)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    if not passport then return false end
    MySQL.query.await([[DELETE FROM vehicles WHERE Passport = ?]], { passport })
    MySQL.query.await([[DELETE FROM mri_qadmin_character_groups WHERE citizenid = ?]], { tostring(passport) })
    MySQL.query.await([[DELETE FROM player_warns WHERE targetIdentifier = ?]], { tostring(passport) })
    local affected = MySQL.update.await([[UPDATE characters SET Deleted = 1 WHERE id = ?]], { passport })
    return affected and affected > 0
end

function SeoulQAdminDB.ClearOfflineInventory(passport)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    if not passport then return false end
    local row = SeoulQAdminDB.GetCharacter(passport)
    if not row then return false end
    MySQL.update.await([[UPDATE ox_inventory SET data = '[]' WHERE owner = ? AND name = 'player']], { 'vrp:' .. passport })
    return true
end

function SeoulQAdminDB.GetPermissionMembers(permission)
    permission = trim(permission)
    if permission == '' then return {} end
    local row = MySQL.single.await([[SELECT Information FROM entitydata WHERE Name = ? LIMIT 1]], { 'Permissions:' .. permission })
    local data = row and row.Information and json.decode(row.Information) or {}
    if type(data) ~= 'table' then return {} end
    local ids = {}
    local levels = {}
    for passport, level in pairs(data) do
        local p = tonumber(passport)
        if p then
            ids[#ids + 1] = p
            levels[tostring(p)] = tonumber(level) or 1
        end
    end
    if #ids == 0 then return {} end
    local chars = MySQL.query.await([[SELECT id, Name, Lastname, License, age, Sex FROM characters WHERE id IN (?) AND Deleted = 0]], { ids }) or {}
    local members = {}
    for _, char in ipairs(chars) do
        members[#members + 1] = {
            id = tostring(char.id),
            name = SeoulQAdminDB.GetCharacterName(char),
            cid = tostring(char.id),
            grade = { name = tostring(levels[tostring(char.id)] or 1), level = levels[tostring(char.id)] or 1 },
            online = false
        }
    end
    return members
end

function SeoulQAdminDB.HasVehiclePlate(plate)
    plate = trim(plate):upper()
    if plate == '' then return false end
    local result = MySQL.single.await([[SELECT Plate FROM vehicles WHERE Plate = ? LIMIT 1]], { plate })
    return result and result.Plate ~= nil
end

function SeoulQAdminDB.InsertVehicle(passport, model, plate, props)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    model = trim(model)
    plate = trim(plate):upper()
    if not passport or model == '' or plate == '' then return false end
    props = type(props) == 'table' and props or {}
    local engine = tonumber(props.engineHealth or props.engine or 1000) or 1000
    local body = tonumber(props.bodyHealth or props.body or 1000) or 1000
    local fuel = tonumber(props.fuelLevel or props.fuel or 100) or 100
    MySQL.insert.await([[INSERT INTO vehicles (Passport, Vehicle, Plate, Engine, Body, Fuel, Save) VALUES (?, ?, ?, ?, ?, ?, ?)]], {
        passport, model, plate, engine, body, fuel, '1'
    })
    return true
end

print('^2[Seoul Admin]^7 Database compat ativo: usando characters/vehicles/accounts da Seoul.')

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS / GROUPS SEOUL HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function decodeJsonMap(value)
    if type(value) ~= 'string' or value == '' then return {} end
    local ok, data = pcall(json.decode, value)
    if ok and type(data) == 'table' then return data end
    return {}
end

function SeoulQAdminDB.GetPermissionMap(permission)
    permission = trim(permission)
    if permission == '' then return {} end
    local row = MySQL.single.await([[SELECT Information FROM entitydata WHERE Name = ? LIMIT 1]], { 'Permissions:' .. permission })
    return decodeJsonMap(row and row.Information)
end

function SeoulQAdminDB.SavePermissionMap(permission, data)
    permission = trim(permission)
    if permission == '' then return false end
    data = type(data) == 'table' and data or {}
    MySQL.insert.await([[INSERT IGNORE INTO permissions (Permission) VALUES (?)]], { permission })
    MySQL.update.await([[INSERT INTO entitydata (Name, Information) VALUES (?, ?) ON DUPLICATE KEY UPDATE Information = VALUES(Information)]], {
        'Permissions:' .. permission,
        json.encode(data)
    })
    return true
end

function SeoulQAdminDB.SetPermission(passport, permission, level)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    permission = trim(permission)
    if not passport or permission == '' then return false end
    level = math.max(1, tonumber(level) or 1)
    local data = SeoulQAdminDB.GetPermissionMap(permission)
    data[tostring(passport)] = level
    return SeoulQAdminDB.SavePermissionMap(permission, data)
end

function SeoulQAdminDB.RemovePermission(passport, permission)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    permission = trim(permission)
    if not passport or permission == '' then return false end
    local data = SeoulQAdminDB.GetPermissionMap(permission)
    data[tostring(passport)] = nil
    return SeoulQAdminDB.SavePermissionMap(permission, data)
end

function SeoulQAdminDB.GetCharacterPermissionNames(passport)
    passport = SeoulQAdminDB.PassportFromCitizenId(passport)
    if not passport then return {} end
    local rows = MySQL.query.await([[SELECT Name, Information FROM entitydata WHERE Name LIKE 'Permissions:%']]) or {}
    local result = {}
    for _, row in ipairs(rows) do
        local name = tostring(row.Name or ''):gsub('^Permissions:', '')
        local data = decodeJsonMap(row.Information)
        local level = tonumber(data[tostring(passport)])
        if name ~= '' and level then result[name] = level end
    end
    return result
end

function SeoulQAdminDB.GetAllPermissionNames()
    local names = {}
    local set = {}
    local rows = MySQL.query.await([[SELECT Permission FROM permissions WHERE Permission <> '' ORDER BY Permission ASC]]) or {}
    for _, row in ipairs(rows) do
        local name = trim(row.Permission)
        if name ~= '' and not set[name] then set[name] = true; names[#names + 1] = name end
    end
    local erows = MySQL.query.await([[SELECT Name FROM entitydata WHERE Name LIKE 'Permissions:%' ORDER BY Name ASC]]) or {}
    for _, row in ipairs(erows) do
        local name = tostring(row.Name or ''):gsub('^Permissions:', '')
        if name ~= '' and not set[name] then set[name] = true; names[#names + 1] = name end
    end
    if not set.Admin then names[#names + 1] = 'Admin' end
    table.sort(names)
    return names
end

function SeoulQAdminDB.GetPermissionMaxLevel(permission)
    local data = SeoulQAdminDB.GetPermissionMap(permission)
    local max = 1
    for _, level in pairs(data) do
        local n = tonumber(level)
        if n and n > max then max = n end
    end
    return max
end
