-- Seoul Base / rcore_police
-- Tabelas realmente usadas pela adaptação.
-- A tabela `invoices` NÃO é criada aqui: ela já existe e é usada pelo Bank/LB Tablet da Seoul.

CREATE TABLE IF NOT EXISTS `rcore_police_reports` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `status` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `player` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(15) NULL,
    `note` LONGTEXT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rcore_police_death_players` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(50) NOT NULL,
    `state` TINYINT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_rcore_police_death_identifier` (`identifier`),
    CONSTRAINT `chk_rcore_police_death_state` CHECK (`state` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rcore_police_society` (
    `department` VARCHAR(64) NOT NULL,
    `balance` BIGINT NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Compatibilidade com instalação anterior do rcore: garante o índice exigido pelo
-- ON DUPLICATE KEY UPDATE do estado de morte sem falhar quando o índice já existe.
SET @rcore_has_death_index := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'rcore_police_death_players'
      AND index_name = 'uq_rcore_police_death_identifier'
);
SET @rcore_index_sql := IF(
    @rcore_has_death_index = 0,
    'ALTER TABLE `rcore_police_death_players` ADD UNIQUE KEY `uq_rcore_police_death_identifier` (`identifier`)',
    'SELECT 1'
);
PREPARE rcore_stmt FROM @rcore_index_sql;
EXECUTE rcore_stmt;
DEALLOCATE PREPARE rcore_stmt;
