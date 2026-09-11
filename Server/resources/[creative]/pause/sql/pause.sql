CREATE TABLE IF NOT EXISTS `deaths_creative` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Attacker` INT NULL DEFAULT NULL,
	`Victim` INT NULL DEFAULT NULL,
	`Weapon` VARCHAR(64) NULL DEFAULT NULL,
	`Timestamp` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	INDEX `idx_deaths_creative_attacker` (`Attacker`),
	INDEX `idx_deaths_creative_victim` (`Victim`),
	INDEX `idx_deaths_creative_timestamp` (`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `codes_creative` (
	`Code` VARCHAR(64) NOT NULL,
	`Rewards` LONGTEXT NOT NULL,
	`Max` INT NOT NULL DEFAULT 0,
	`Used` INT NOT NULL DEFAULT 0,
	`CreatedAt` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `codes_creative_redeemd` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Code` VARCHAR(64) NOT NULL,
	`Passport` INT NOT NULL,
	`RedeemdAt` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY `idx_codes_creative_redeemd_code_passport` (`Code`,`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
