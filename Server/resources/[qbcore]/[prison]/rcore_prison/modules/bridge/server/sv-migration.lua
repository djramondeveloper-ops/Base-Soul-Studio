local requiredTables = {
  rcore_prison = true,
  rcore_prison_accounts = true,
  rcore_prison_accounts_log = true,
  rcore_prison_coms = true,
  rcore_prison_coms_sessions = true,
  rcore_prison_stash = true,
  rcore_prison_logs = true
}

local legacyMigrationTables = {
  rcore_prison_coms = true,
  rcore_prison_coms_sessions = true
}

local migrationTableCount = table.size(legacyMigrationTables)
local totalTableCount = table.size(requiredTables)

local createTableStatements = {
  rcore_prison = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison` (
            `prisoner_id` INT(11) NOT NULL AUTO_INCREMENT,
            `owner` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `solitary_time` DATETIME NULL DEFAULT NULL,
            `jail_time` DATETIME NULL DEFAULT NULL,
            `data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `createdAt` TIMESTAMP NULL DEFAULT current_timestamp(),
            `updatedAt` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
            PRIMARY KEY (`prisoner_id`) USING BTREE,
            INDEX `owner` (`owner`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_accounts = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison_accounts` (
            `account_id` INT(11) NOT NULL AUTO_INCREMENT,
            `owner` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `balance` BIGINT(20) NULL DEFAULT '0',
            `giftstate` TINYINT(4) NULL DEFAULT '0',
            `createdAt` TIMESTAMP NULL DEFAULT current_timestamp(),
            `updatedAt` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
            PRIMARY KEY (`account_id`) USING BTREE,
            INDEX `owner` (`owner`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_coms_sessions = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison_coms_sessions` (
            `zoneId` BIGINT(10) NOT NULL,
            `verticesTarget` BIGINT(10) NOT NULL,
            `verticesDone` BIGINT(10) NOT NULL DEFAULT '0',
            PRIMARY KEY (`zoneId`),
            INDEX `zoneId_index` (`zoneId`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_coms = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison_coms` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `owner` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `zoneId` BIGINT(10) NULL DEFAULT NULL,
            `state` ENUM('IDLE','SWEEPING','RETURN') NOT NULL COLLATE 'utf8mb4_unicode_ci',
            `perollAmount` INT(10) NULL DEFAULT '0',
            `perollTarget` INT(10) NULL DEFAULT '0',
            `createdAt` TIMESTAMP NULL DEFAULT current_timestamp(),
            `name` VARCHAR(60) NOT NULL COLLATE 'utf8mb4_unicode_ci',
            PRIMARY KEY (`id`) USING BTREE,
            INDEX `owner` (`owner`) USING BTREE,
            INDEX `zoneId` (`zoneId`) USING BTREE,
            CONSTRAINT `FK_Q27L` FOREIGN KEY (`zoneId`) REFERENCES `rcore_prison_coms_sessions` (`zoneId`) ON UPDATE RESTRICT ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_stash = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison_stash` (
            `owner` VARCHAR(255) NOT NULL,
            `stash` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
            PRIMARY KEY (`owner`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_logs = [[
        CREATE TABLE IF NOT EXISTS `rcore_prison_logs` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `action` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `desc` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `charId` VARCHAR(70) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `officer_name` VARCHAR(70) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `citizen_name` VARCHAR(70) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `created_at` DATETIME NOT NULL DEFAULT current_timestamp(),
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
  rcore_prison_accounts_log = [[
        CREATE TABLE `rcore_prison_accounts_log` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `action` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `desc` VARCHAR(300) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `charId` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
            `amount` INT(11) NULL DEFAULT NULL,
            `created_at` DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (`id`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
}

IS_DATABASE_READY = false

local function ensureSolitaryTimeColumn()
  local prisonTableInfo = MySQL.Sync.fetchSingle([[
        SELECT COUNT(*)
        AS table_count
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_NAME = 'rcore_prison'
        AND TABLE_SCHEMA = DATABASE()
    ]])

  if not prisonTableInfo or prisonTableInfo.table_count <= 0 then
    return
  end

  local columnInfo = MySQL.Sync.fetchSingle([[
        SELECT COUNT(*)
        AS column_count
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'rcore_prison'
        AND COLUMN_NAME = 'solitary_time'
        AND TABLE_SCHEMA = DATABASE()
    ]])

  if columnInfo and columnInfo.column_count == 0 then
    dbg.debug("Adding column `solitary_time` to `rcore_prison` table.")
    MySQL.Sync.execute([[
                ALTER TABLE `rcore_prison`
                ADD COLUMN `solitary_time` DATETIME NULL DEFAULT current_timestamp() AFTER `owner`;
            ]])
  end
end

function IsDatabaseReady()
  local checkedTables = 0
  local databaseReady = false
  local existingTableCount = 0
  local missingTableCount = 0
  local missingLegacyTables = 0
  local legacyMigrationDetected = false

  if not isResourcePresentProvideless(Config.Database) then
    dbg.critical("Database connection required - Please ensure oxmysql or mysql-async is installed and running")
    dbg.critical("Download oxmysql: https://github.com/CommunityOx/oxmysql/releases/download/v2.12.3/oxmysql.zip")
    dbg.critical("More info: https://store.rcore.cz/package/5341769")
    return false
  end

  if type(MySQL.Sync.fetchSingle) == "nil" then
    dbg.critical("You are running mysql-async, which is missing MySQL.Sync.fetchSingle !!!")
    dbg.critical("Please use oxmysql, instead mysql-async: https://github.com/CommunityOx/oxmysql/releases/download/v2.12.3/oxmysql.zip")
    return false
  end

  for tableName in pairs(requiredTables) do
    local exists = db.DoesTableExist(tableName)

    if requiredTables[tableName] and exists then
      existingTableCount = existingTableCount + 1
    elseif not exists then
      missingTableCount = missingTableCount + 1
    end

    if legacyMigrationTables[tableName] and not exists then
      missingLegacyTables = missingLegacyTables + 1

      if missingLegacyTables >= migrationTableCount then
        legacyMigrationDetected = true
      end
    end

    checkedTables = checkedTables + 1
  end

  ensureSolitaryTimeColumn()

  if missingTableCount ~= 0 then
    dbg.bridge("Database tables are not defined, creating tables! %s %s", missingTableCount, totalTableCount)

    for tableName, createSql in pairs(createTableStatements) do
      if not db.DoesTableExist(tableName) then
        local created = MySQL.Sync.execute(createSql, {})

        if created then
          dbg.debug("Table with ID %s created!", tableName)
        end
      end
    end

    databaseReady = true
  elseif legacyMigrationDetected then
    dbg.bridge("You are running older version of rcore_prison, perfoming automatic migration and adding new columns to db!")
    tprint(legacyMigrationTables)

    local oldTransactions = MySQL.Sync.fetchAll("SELECT * FROM rcore_prison_transactions", {})

    if oldTransactions and next(oldTransactions) then
      for _, transaction in pairs(oldTransactions) do
        local accountData = MySQL.Sync.fetchSingle(
          "SELECT owner FROM rcore_prison_accounts WHERE account_id = @account_id",
          {
            ["@account_id"] = transaction.account_id
          }
        )

        if accountData then
          local logged = LogService.RegisterTransaction(
            transaction.transaction_name,
            transaction.message,
            accountData.owner,
            "-",
            "-"
          )

          if logged then
            MySQL.Sync.execute(
              "DELETE FROM rcore_prison_transactions WHERE transaction_id = @transaction_id",
              {
                ["@transaction_id"] = transaction.transaction_id
              }
            )
          end
        end
      end
    end

    local oldPerollRows = MySQL.Sync.fetchAll([[
            SELECT
                JSON_EXTRACT(data, '$.prisonerName') AS prisonerName,
                JSON_EXTRACT(data, '$.jail_time') AS jail_time,
                OWNER AS owner
            FROM
                rcore_prison
            WHERE
                JSON_EXTRACT(data, '$.state') != 'jailed';
        ]], {})

    if oldPerollRows and next(oldPerollRows) then
      for _, prisonRow in pairs(oldPerollRows) do
        local created = db.CreateCitizenPeroll(
          prisonRow.owner,
          "IDLE",
          prisonRow.jail_time,
          prisonRow.prisonerName
        )

        if created then
          db.RemovePerollByOwner(prisonRow.owner)
        end
      end
    end

    local columnInfo = MySQL.Sync.fetchSingle([[
            SELECT COUNT(*)
            AS column_count
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'rcore_prison'
            AND COLUMN_NAME = 'solitary_time'
            AND TABLE_SCHEMA = DATABASE()
        ]])

    if columnInfo and columnInfo.column_count == 0 then
      dbg.bridge("Adding column `solitary_time` to `rcore_prison` table.")
      MySQL.Sync.execute([[
                ALTER TABLE `rcore_prison`
                ADD COLUMN `solitary_time` DATETIME NULL DEFAULT current_timestamp() AFTER `owner`;
            ]])
    end

    databaseReady = true
  elseif existingTableCount >= totalTableCount then
    dbg.bridge("Database tables are defined, loading data into cache.")
    databaseReady = true
  end

  return databaseReady
end

CreateThread(function()
  local isReady = IsDatabaseReady()

  if isReady then
    IS_DATABASE_READY = true
    BridgeLoadedHeartbeat()
  end
end, "sv-migration code name: Phoenix")