-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



db.CachedQueries = {}
local QUERIES = {
    QB_PHONE_INVOICES =
    'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
    INSERT_REPORT = 'INSERT INTO rcore_police_reports (status, message, player, phone) VALUES (?, ?, ?, ?)',
    DELETE_REPORT = 'DELETE FROM rcore_police_reports WHERE id = ?',
    UPDATE_STATUS = 'UPDATE rcore_police_reports SET status = ? WHERE id = ?',
    UPDATE_NOTE = 'UPDATE rcore_police_reports SET note = ? WHERE id = ?',
    FETCH_ALL_REPORTS = "SELECT * FROM rcore_police_reports",
    FETCH_SERVER_ITEMS = 'SELECT * FROM items',
    DAETH_PLAYERS_UPDATE_PLAYER_STATE = [[
        INSERT INTO rcore_police_death_players (identifier, state)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE state = VALUES(state);
    ]],
    DEATH_PLAYERS_CREATE_TABLE = [[
        CREATE TABLE IF NOT EXISTS rcore_police_death_players (
            id SERIAL PRIMARY KEY,
            identifier VARCHAR(50) NOT NULL,
            state TINYINT DEFAULT 0 CHECK (state IN (0, 1)),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY `uq_rcore_police_death_identifier` (`identifier`)
        );
    ]],
    REPORTS_CREATE_TABLE = [[
        CREATE TABLE IF NOT EXISTS rcore_police_reports (
            id SERIAL PRIMARY KEY,
            status VARCHAR(50) NOT NULL,
            message TEXT NOT NULL,
            player VARCHAR(50) NOT NULL,
            phone VARCHAR(15),
            note LONGTEXT DEFAULT '',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    ]],
    GARAGE = {
        IS_VEHICLE_OWNED_BY_PLATE       =
        'SELECT plate FROM `{player_vehicle_table}` WHERE `{player_vehicle_table_column}` = ? LIMIT 1',
        GET_VEHICLE_OWNER_INFO_BY_PLATE = {
            ESX = [[
                SELECT
                    CONCAT(users.firstname, ' ', users.lastname) AS vehicle_owner,
                    COALESCE(NULLIF(users.phone_number, ''), 'Unknown') AS phone_number,
                    users.identifier AS identifier
                FROM `{player_vehicle_table}`
                INNER JOIN users ON `{player_vehicle_table}`.owner = users.identifier
                WHERE LOWER(REPLACE(`{player_vehicle_table}`.`{player_vehicle_table_column}`, " ", "")) = LOWER(?)
            ]],
            QBCORE = [[
                SELECT
                    CONCAT(characters.Name, ' ', characters.Lastname) AS vehicle_owner,
                    COALESCE(NULLIF(characters.Phone, ''), 'Unknown') AS phone_number,
                    CAST(characters.id AS CHAR) AS identifier
                FROM `{player_vehicle_table}`
                INNER JOIN characters ON `{player_vehicle_table}`.Passport = characters.id
                WHERE LOWER(REPLACE(`{player_vehicle_table}`.`{player_vehicle_table_column}`, " ", "")) = LOWER(REPLACE(?, " ", ""))
                LIMIT 1
            ]],
            QBOX = [[
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.firstname')) AS firstname,
                    JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.lastname')) AS lastname,
                    CONCAT(
                        JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.firstname')),
                        ' ',
                        JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.lastname'))
                    ) AS vehicle_owner,
                    COALESCE(NULLIF(players.phone_number, ''), 'Unknown') AS phone_number,
                    players.citizenid AS identifier
                FROM `{player_vehicle_table}`
                INNER JOIN players ON `{player_vehicle_table}`.citizenid = players.citizenid
                WHERE LOWER(CONVERT(REPLACE(`{player_vehicle_table}`.`{player_vehicle_table_column}`, " ", "") USING utf8mb4) COLLATE utf8mb4_general_ci)
                    = LOWER(CONVERT(? USING utf8mb4) COLLATE utf8mb4_general_ci)
            ]]
        }
    }
}
CreateThread(function()
    local replacements = {
        player_vehicle_table = "owned_vehicles",
        player_vehicle_table_column = "plate",
        user_table = "users",
        user_column = "identifier"
    }
    if Config.Framework == Framework.ESX then
        replacements.player_vehicle_table = ServerConfig.Database.ESX or "owned_vehicles"
        replacements.user_column = 'identifier'
        replacements.user_table = "users"
    end
    if IS_QB[Config.Framework] then
        replacements.player_vehicle_table = ServerConfig.Database.QBCORE or "vehicles"
        replacements.player_vehicle_table_column = 'Plate'
        replacements.user_column = 'id'
        replacements.user_table = "characters"
    end
    if Config.Framework == Framework.NONE then
        return dbg.debug('Database: No supported framework detected running standalone for garages!')
    end
    db.FormatQueriesOnce(QUERIES.GARAGE, replacements)
end)
db.FormatQueriesOnce = function(queryTable, replacements)
    if next(db.CachedQueries) then return db.CachedQueries end
    for key, query in pairs(queryTable) do
        if type(query) == "string" then
            for placeholder, value in pairs(replacements) do
                query = query:gsub("{" .. placeholder .. "}", value)
            end
            db.CachedQueries[key] = query
        elseif type(query) == "table" then
            local framework = FRAMEWORK_TO_SHORT_NAME[Config.Framework]
            if not framework then
                return
            end
            local frameworkQuery = query[framework]
            if frameworkQuery then
                for placeholder, value in pairs(replacements) do
                    frameworkQuery = frameworkQuery:gsub("{" .. placeholder .. "}", value)
                end
                db.CachedQueries[key] = frameworkQuery
            else
                print("[WARNING] No query defined for framework:", Config.Framework, "in key:", key)
            end
        end
    end
    return db.CachedQueries
end
db.GetCachedQuery = function(key, opts)
    opts = opts or {}
    local query = db.CachedQueries[key]
    if not query then
        return nil
    end
    if opts.withPhoneNumber == false then
        query = query:gsub(",%s*COALESCE%b()%s+AS%s+phone_number", "")
        query = query:gsub(",%s*JSON_UNQUOTE%b()%s+AS%s+phone_number", "")
        query = query:gsub(",%s*players%.phone_number%s+AS%s+phone_number", "")
        query = query:gsub("%s+AND%s+users%.phone_number%s+IS%s+NOT%s+NULL", "")
        query = query:gsub("%s+AND%s+users%.phone_number%s*!=%s*''", "")
    end
    return query
end
db.IsVehicleOwnedByPlateGarage = function(plate)
    if Config.Framework == Framework.NONE then
        return false, nil
    end
    local query = db.GetCachedQuery('IS_VEHICLE_OWNED_BY_PLATE')
    if not query then
        return false
    end
    local result = MySQL.single.await(query, { plate })
    return result ~= nil
end
db.GetVehicleOwnerInfoByPlate = function(plate)
    if Config.Framework == Framework.NONE then
        return false, nil
    end
    if not plate then
        return false, nil
    end
    local baseQuery = db.GetCachedQuery('GET_VEHICLE_OWNER_INFO_BY_PLATE', { withPhoneNumber = true })
    if not baseQuery then
        return false, nil
    end
    local result = MySQL.single.await(baseQuery, { plate })
    return result ~= nil, result
end
db.UpdateReportNote = function(id, note)
    return MySQL.query(
        QUERIES.UPDATE_NOTE,
        { note, id }
    )
end
db.UpdateReportStatus = function(id, state)
    return MySQL.query(
        QUERIES.UPDATE_STATUS,
        { state, id }
    )
end
db.InsertReport = function(state, message, player, phone)
    return MySQL.insert(
        QUERIES.INSERT_REPORT,
        { state, message, player, phone }
    )
end
db.DeleteReport = function(id)
    return MySQL.insert(
        QUERIES.DELETE_REPORT,
        { id }
    )
end
db.GetAllReports = function()
    return MySQL.query.await(
        QUERIES.FETCH_ALL_REPORTS,
        {}
    )
end
db.GetServerItems = function()
    return MySQL.Sync.fetchAll(QUERIES.FETCH_SERVER_ITEMS, {})
end
db.InitDatabase = function()
    local existingTables = {}
    if TABLES and next(TABLES) then
        for _, v in pairs(TABLES) do
            existingTables[v.TABLE_NAME] = true
        end
        local created = false
        if not existingTables.rcore_police_reports then
            MySQL.query.await(QUERIES.REPORTS_CREATE_TABLE, {})
            dbg.debug('Database: Creating reports table in your database.')
            created = true
        end
        if not existingTables.rcore_police_death_players then
            MySQL.query.await(QUERIES.DEATH_PLAYERS_CREATE_TABLE, {})
            dbg.debug('Database: Creating death-state table in your database.')
            created = true
        end
        return created
    end
    return false
end
db.SetPlayerDeathState = function(identifier, state)
    return MySQL.insert(QUERIES.DAETH_PLAYERS_UPDATE_PLAYER_STATE,
        { identifier, state }
    )
end
db.InsertQBPhoneInvoice = function(citizenId, amount, job, officerName, officerCharId)
    return MySQL.insert(
        QUERIES.QB_PHONE_INVOICES,
        { citizenId, amount, job, officerName, officerCharId }
    )
end
