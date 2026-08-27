DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `Characters` int(10) NOT NULL DEFAULT 1,
  `Gemstone` bigint(20) NOT NULL DEFAULT 0,
  `Discord` varchar(50) NOT NULL DEFAULT '0',
  `License` varchar(50) NOT NULL DEFAULT '0',
  `Login` bigint(20) NOT NULL DEFAULT current_timestamp(),
  `Token` varchar(10) DEFAULT '0',
  `Banned` bigint(20) NOT NULL DEFAULT 0,
  `Reason` varchar(255) DEFAULT NULL,
  `Referral` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `Discord` (`Discord`),
  KEY `License` (`License`),
  KEY `Token` (`Token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `avatars`;
CREATE TABLE IF NOT EXISTS `avatars` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Image` text DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `characters`;
CREATE TABLE IF NOT EXISTS `characters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT 'Individuo',
  `Lastname` varchar(50) DEFAULT 'Indigente',
  `License` varchar(50) DEFAULT NULL,
  `Bank` bigint(20) NOT NULL DEFAULT 5000,
  `Blood` int(1) NOT NULL DEFAULT 1,
  `Prison` int(10) NOT NULL DEFAULT 0,
  `Killed` int(10) NOT NULL DEFAULT 0,
  `Death` int(10) NOT NULL DEFAULT 0,
  `Daily` varchar(20) NOT NULL DEFAULT '09-01-1990-0',
  `Created` bigint(20) NOT NULL DEFAULT current_timestamp(),
  `Login` bigint(20) NOT NULL DEFAULT current_timestamp(),
  `Skin` varchar(50) NOT NULL DEFAULT 'mp_m_freemode_01',
  `SkinMontly` bigint(20) NOT NULL DEFAULT 0,
  `Deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Discord` (`License`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `characters`
    ADD COLUMN IF NOT EXISTS `age` INT(11) NOT NULL DEFAULT 20 AFTER `Lastname`,
    ADD COLUMN IF NOT EXISTS `Sex` VARCHAR(1) NOT NULL DEFAULT 'M' AFTER `age`;

DROP TABLE IF EXISTS `chests`;
CREATE TABLE IF NOT EXISTS `chests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Weight` bigint(20) NOT NULL DEFAULT 500,
  `Slots` int(10) NOT NULL DEFAULT 50,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `dependents`;
CREATE TABLE IF NOT EXISTS `dependents` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Dependent` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `ems_creative_consultations`;
CREATE TABLE IF NOT EXISTS `ems_creative_consultations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Reason` varchar(255) NOT NULL DEFAULT '',
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Doctor` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Status` varchar(255) NOT NULL DEFAULT 'appointment',
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `ems_creative_exams`;
CREATE TABLE IF NOT EXISTS `ems_creative_exams` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL DEFAULT '',
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Doctor` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Status` varchar(255) NOT NULL DEFAULT 'appointment',
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `ems_creative_specialties`;
CREATE TABLE IF NOT EXISTS `ems_creative_specialties` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(150) NOT NULL DEFAULT 'Médico',
  `Members` longtext NOT NULL DEFAULT '[]',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `entitydata`;
CREATE TABLE IF NOT EXISTS `entitydata` (
  `Name` varchar(100) NOT NULL,
  `Information` longtext DEFAULT NULL,
  PRIMARY KEY (`Name`),
  KEY `Information` (`Name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `fuelstations_creative`;
CREATE TABLE IF NOT EXISTS `fuelstations_creative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Name` varchar(100) NOT NULL DEFAULT 'Posto de Combustível',
  `Color` int(3) NOT NULL DEFAULT 47,
  `Blip` int(3) NOT NULL DEFAULT 361,
  `Stock` int(9) NOT NULL DEFAULT 0,
  `FuelPrice` decimal(5,1) NOT NULL DEFAULT 5.0,
  `MoneyEarned` bigint(20) NOT NULL DEFAULT 0,
  `MoneySpent` bigint(20) NOT NULL DEFAULT 0,
  `FuelImported` bigint(20) NOT NULL DEFAULT 0,
  `Visits` bigint(20) NOT NULL DEFAULT 0,
  `Empty` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `hwid`;
CREATE TABLE IF NOT EXISTS `hwid` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Account` bigint(20) NOT NULL DEFAULT 1,
  `Token` varchar(250) NOT NULL DEFAULT '0',
  `Banned` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `invoices`;
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Received` bigint(19) NOT NULL DEFAULT 0,
  `Reason` longtext NOT NULL,
  `Price` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `illness`;
CREATE TABLE IF NOT EXISTS `illness` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Illness` VARCHAR(50) NOT NULL,
  PRIMARY KEY (Passport),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_arrest`;
CREATE TABLE IF NOT EXISTS `mdt_creative_arrest` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Officers` longtext DEFAULT NULL,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Infractions` longtext DEFAULT NULL,
  `Arrest` bigint(20) NOT NULL DEFAULT 0,
  `Fine` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_board`;
CREATE TABLE IF NOT EXISTS `mdt_creative_board` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_fines`;
CREATE TABLE IF NOT EXISTS `mdt_creative_fines` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Infractions` longtext DEFAULT NULL,
  `Fine` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Paid` tinyint(1) NOT NULL DEFAULT 0,
  `Arrest` bigint(20) DEFAULT NULL,
  `Date` varchar(10) NOT NULL DEFAULT '',
  `Hour` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `MDT_Arrest` (`Arrest`),
  CONSTRAINT `MDT_Arrest` FOREIGN KEY (`Arrest`) REFERENCES `mdt_creative_arrest` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_internalaffairs`;
CREATE TABLE IF NOT EXISTS `mdt_creative_internalaffairs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Title` text DEFAULT NULL,
  `Suspect` bigint(20) NOT NULL DEFAULT 0,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Archive` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_medals`;
CREATE TABLE IF NOT EXISTS `mdt_creative_medals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'Honra ao Mérito',
  `Officers` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_penalcode_sections`;
CREATE TABLE IF NOT EXISTS `mdt_creative_penalcode_sections` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Type` varchar(10) NOT NULL,
  `Title` varchar(100) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `Order` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_penalcode_articles`;
CREATE TABLE IF NOT EXISTS `mdt_creative_penalcode_articles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Section` bigint(20) NOT NULL DEFAULT 0,
  `Article` varchar(250) NOT NULL,
  `Contravention` varchar(250) NOT NULL,
  `Fine` bigint(20) NOT NULL DEFAULT 0,
  `Arrest` bigint(20) NOT NULL DEFAULT 0,
  `Bail` bigint(20) NOT NULL DEFAULT 0,
  `Order` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `MDT_Section` (`Section`),
  CONSTRAINT `MDT_Section` FOREIGN KEY (`Section`) REFERENCES `mdt_creative_penalcode_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_reports`;
CREATE TABLE IF NOT EXISTS `mdt_creative_reports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Title` text DEFAULT NULL,
  `Suspects` longtext NOT NULL DEFAULT '[]',
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Archive` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_units`;
CREATE TABLE IF NOT EXISTS `mdt_creative_units` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'PRPD',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Officers` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_vehicles`;
CREATE TABLE IF NOT EXISTS `mdt_creative_vehicles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Image` text NOT NULL DEFAULT '',
  `Vehicle` varchar(100) DEFAULT NULL,
  `Plate` varchar(10) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_wanted`;
CREATE TABLE IF NOT EXISTS `mdt_creative_wanted` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Image` text DEFAULT NULL,
  `Accusations` longtext DEFAULT NULL,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `HowLong` int(5) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `mdt_creative_warning`;
CREATE TABLE IF NOT EXISTS `mdt_creative_warning` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Officer` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `painel_creative_announcements`;
CREATE TABLE IF NOT EXISTS `painel_creative_announcements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Title` text DEFAULT NULL,
  `Description` longtext DEFAULT NULL,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Updated` bigint(20) DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `painel_creative_paramedic`;
CREATE TABLE IF NOT EXISTS `painel_creative_paramedic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Doctor` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `painel_creative_tags`;
CREATE TABLE IF NOT EXISTS `painel_creative_tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'Recruta',
  `Members` longtext NOT NULL DEFAULT '[]',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `painel_creative_transactions`;
CREATE TABLE IF NOT EXISTS `painel_creative_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Type` varchar(50) NOT NULL DEFAULT 'Deposit',
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Value` bigint(20) NOT NULL DEFAULT 0,
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  `Transfer` bigint(20) DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Members` int(10) NOT NULL DEFAULT 10,
  `Tags` int(10) NOT NULL DEFAULT 3,
  `Announces` int(10) NOT NULL DEFAULT 3,
  `Experience` bigint(20) NOT NULL DEFAULT 0,
  `Points` bigint(20) NOT NULL DEFAULT 0,
  `Bank` bigint(20) NOT NULL DEFAULT 0,
  `Premium` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `playerdata`;
CREATE TABLE IF NOT EXISTS `playerdata` (
  `Passport` bigint(20) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Information` longtext DEFAULT NULL,
  PRIMARY KEY (`Passport`,`Name`),
  KEY `Passport` (`Passport`),
  KEY `Information` (`Name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `propertys`;
CREATE TABLE IF NOT EXISTS `propertys` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT 'Homes0001',
  `Interior` varchar(20) NOT NULL DEFAULT 'Middle',
  `Item` bigint(20) NOT NULL DEFAULT 3,
  `Tax` bigint(20) NOT NULL DEFAULT 0,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Serial` varchar(10) NOT NULL,
  `Vault` bigint(20) NOT NULL DEFAULT 1,
  `Fridge` bigint(20) NOT NULL DEFAULT 1,
  `Garage` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `races`;
CREATE TABLE IF NOT EXISTS `races` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL DEFAULT 'Indivíduo Indigente',
  `Mode` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Race` smallint(5) unsigned NOT NULL DEFAULT 0,
  `Passport` int(10) unsigned NOT NULL DEFAULT 0,
  `Vehicle` varchar(50) NOT NULL DEFAULT 'Sultan RS',
  `Points` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_race_player` (`Mode`,`Race`,`Passport`),
  KEY `Points` (`Points`),
  KEY `Name` (`Name`),
  KEY `Vehicle` (`Vehicle`),
  KEY `Passport` (`Passport`),
  KEY `Race` (`Race`),
  KEY `Mode` (`Mode`),
  KEY `idx_races_race_points` (`Race`,`Points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `taxes`;
CREATE TABLE IF NOT EXISTS `taxes` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Price` bigint(19) NOT NULL,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Price` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `Vehicle` varchar(100) DEFAULT NULL,
  `Tax` bigint(20) NOT NULL DEFAULT 0,
  `Plate` varchar(10) DEFAULT NULL,
  `Weight` bigint(20) NOT NULL DEFAULT 0,
  `Save` varchar(50) NOT NULL DEFAULT '1',
  `Rental` bigint(20) NOT NULL DEFAULT 0,
  `Arrest` tinyint(1) NOT NULL DEFAULT 0,
  `Block` tinyint(1) NOT NULL DEFAULT 0,
  `Engine` int(4) NOT NULL DEFAULT 1000,
  `Body` int(4) NOT NULL DEFAULT 1000,
  `Health` int(4) NOT NULL DEFAULT 1000,
  `Fuel` int(3) NOT NULL DEFAULT 100,
  `Nitro` int(5) NOT NULL DEFAULT 0,
  `Work` tinyint(1) NOT NULL DEFAULT 0,
  `Doors` longtext DEFAULT NULL,
  `Windows` longtext DEFAULT NULL,
  `Tyres` longtext DEFAULT NULL,
  `Brakes` longtext DEFAULT NULL,
  `Dirt` int(5) NOT NULL DEFAULT 0.0,
  `Seatbelt` tinyint(1) NOT NULL DEFAULT 0,
  `Drift` tinyint(1) NOT NULL DEFAULT 0,
  `Keys` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Vehicle` (`Vehicle`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `tickets_creative`;
CREATE TABLE IF NOT EXISTS `tickets_creative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Subject` varchar(255) NOT NULL DEFAULT '',
  `Category` varchar(100) NOT NULL DEFAULT '',
  `Assumed` bigint(20) DEFAULT NULL,
  `Status` tinyint(1) NOT NULL DEFAULT 1,
  `CreatedAt` bigint(20) DEFAULT NULL,
  `ClosedAt` bigint(20) DEFAULT NULL,
  `Author` bigint(20) NOT NULL DEFAULT 0,
  `Members` longtext DEFAULT NULL,
  `MessageAdmin` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `tickets_creative_messages`;
CREATE TABLE IF NOT EXISTS `tickets_creative_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Ticket` bigint(20) NOT NULL DEFAULT 0,
  `Type` varchar(100) NOT NULL DEFAULT 'User',
  `Author` bigint(20) DEFAULT NULL,
  `Staff` tinyint(1) NOT NULL DEFAULT 0,
  `Message` longtext DEFAULT NULL,
  `CreatedAt` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_tickets_creative_messages_tickets_creative` (`Ticket`),
  CONSTRAINT `FK_tickets_creative_messages_tickets_creative` FOREIGN KEY (`Ticket`) REFERENCES `tickets_creative` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `codes_creative`;
CREATE TABLE IF NOT EXISTS `codes_creative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Code` varchar(50) NOT NULL DEFAULT '',
  `Rewards` longtext DEFAULT NULL,
  `Max` int(9) NOT NULL DEFAULT 1,
  `Used` int(9) NOT NULL DEFAULT 0,
  `CreatedAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `codes_creative_redeemd`;
CREATE TABLE IF NOT EXISTS `codes_creative_redeemd` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Code` varchar(50) NOT NULL DEFAULT '',
  `Passport` bigint(20) NOT NULL DEFAULT 0,
  `RedeemdAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `deaths_creative`;
CREATE TABLE IF NOT EXISTS `deaths_creative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Attacker` bigint(20) NOT NULL DEFAULT 0,
  `Victim` bigint(20) NOT NULL DEFAULT 0,
  `Weapon` varchar(50) NOT NULL DEFAULT 'WEAPON_PISTOL',
  `Timestamp` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `entitydata` (`Name`, `Information`) VALUES ('Permissions:Admin', '{\"1\":1}');

-- -----------------------------------------------------------------------------
-- OX INVENTORY - Seoul/vRP
-- OX salva inventário do player em owner='vrp:<Passport>', name='player'.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `trunk` LONGTEXT NULL;
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `glovebox` LONGTEXT NULL;

-- phone_number is the identifier used for phones in twitter etc
CREATE TABLE IF NOT EXISTS `phone_phones` (
    `id` VARCHAR(100) NOT NULL, -- if metadata - unique id for the phone; if not - player identifier
    `owner_id` VARCHAR(100) NOT NULL, -- the player identifier of the first person who used the phone, used for lookup app etc
    `phone_number` VARCHAR(15) NOT NULL,
    `name` VARCHAR(50),

    `pin` VARCHAR(4) DEFAULT NULL,
    `face_id` VARCHAR(100) DEFAULT NULL, -- the identifier of the face that is used for the phone

    `settings` LONGTEXT, -- json encoded settings
    `is_setup` BOOLEAN DEFAULT FALSE,
    `assigned` BOOLEAN DEFAULT FALSE, -- if the phone is assigned to a phone item (metadata)
    `battery` INT NOT NULL DEFAULT 100, -- battery percentage

    `last_seen` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY (`phone_number`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_last_phone` (
    `id` VARCHAR(100) NOT NULL, -- the player's identifier (not named identifier since esx_multicharacter breaks it)
    `phone_number` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_photo_albums` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `title` VARCHAR(100) NOT NULL,
    `shared` BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_photo_album_members` (
    `album_id` INT NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,

    PRIMARY KEY (`album_id`, `phone_number`),
    FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_photos` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `link` VARCHAR(500) NOT NULL,
    `is_video` BOOLEAN DEFAULT FALSE,
    `size` FLOAT NOT NULL DEFAULT 0,
    `metadata` VARCHAR(20) DEFAULT NULL,

    `is_favourite` BOOLEAN DEFAULT FALSE,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_photo_album_photos` (
    `album_id` INT NOT NULL,
    `photo_id` INT NOT NULL,

    PRIMARY KEY (`album_id`, `photo_id`),
    FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`photo_id`) REFERENCES `phone_photos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_notes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `content` LONGTEXT, -- limit maybe?
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_notifications` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `app` VARCHAR(50) NOT NULL,

    `title` VARCHAR(50) DEFAULT NULL,
    `content` VARCHAR(500) DEFAULT NULL,
    `thumbnail` VARCHAR(500) DEFAULT NULL,
    `avatar` VARCHAR(500) DEFAULT NULL,
    `show_avatar` BOOLEAN DEFAULT FALSE,
    `custom_data` TEXT DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- TWITTER
CREATE TABLE IF NOT EXISTS `phone_twitter_hashtags` (
    `hashtag` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL DEFAULT 0,
    `last_used` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`hashtag`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_accounts` (
    `display_name` VARCHAR(30) NOT NULL,

    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,

    `phone_number` VARCHAR(15) NOT NULL,
    `bio` VARCHAR(100) DEFAULT NULL,
    `profile_image` VARCHAR(500) DEFAULT NULL,
    `profile_header` VARCHAR(500) DEFAULT NULL,

    `pinned_tweet` VARCHAR(50) DEFAULT NULL,

    `verified` TINYINT(1) DEFAULT 0,
    `follower_count` INT(11) NOT NULL DEFAULT 0,
    `following_count` INT(11) NOT NULL DEFAULT 0,

    `private` BOOLEAN DEFAULT FALSE,

    `date_joined` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`username`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_follows` (
    `followed` VARCHAR(20) NOT NULL,
    `follower` VARCHAR(20) NOT NULL,
    `notifications` BOOLEAN NOT NULL DEFAULT FALSE, -- if the follower gets notifications from the followed

    PRIMARY KEY (`followed`, `follower`),
    FOREIGN KEY (`followed`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`follower`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_follow_requests` (
    `requester` VARCHAR(20) NOT NULL,
    `requestee` VARCHAR(20) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`requester`, `requestee`),
    FOREIGN KEY (`requester`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`requestee`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_tweets` (
    `id` VARCHAR(10) NOT NULL,
    `username` VARCHAR(20) NOT NULL, -- the person who tweeted, matches to `username` in phone_twitter_accounts

    `content` VARCHAR(280),
    `attachments` TEXT, -- json array of attachments

    `reply_to` VARCHAR(50) DEFAULT NULL, -- the tweet / reply this tweet / reply was a reply to

    `like_count` INT(11) DEFAULT 0,
    `reply_count` INT(11) DEFAULT 0,
    `retweet_count` INT(11) DEFAULT 0,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_likes` (
    `tweet_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL, -- the person who liked the tweet / reply, matches to `username` in phone_twitter_accounts

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`tweet_id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
    -- no foreign key on tweet_id as it should still show in the feed, even if the tweet is deleted
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_retweets` (
    `tweet_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL, -- the person who retweeted the tweet / reply, matches to `username` in phone_twitter_accounts

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`tweet_id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
    -- no foreign key on tweet_id as it should still show in the feed, even if the tweet is deleted
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_promoted` (
    `tweet_id` VARCHAR(50) NOT NULL,
    `promotions` INT(11) NOT NULL DEFAULT 0, -- how how many times this tweet should be promoted
    `views` INT(11) NOT NULL DEFAULT 0, -- how many times this tweet has been promoted

    PRIMARY KEY (`tweet_id`),
    FOREIGN KEY (`tweet_id`) REFERENCES `phone_twitter_tweets`(`id`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_messages` (
    `id` VARCHAR(10) NOT NULL,

    `sender` VARCHAR(20) NOT NULL, -- the person who sent the message, matches to `username` in phone_twitter_accounts
    `recipient` VARCHAR(20) NOT NULL, -- the person who received the message, matches to `username` in phone_twitter_accounts

    `content` VARCHAR(1000),
    `attachments` TEXT, -- json array of attachments

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`sender`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`recipient`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_twitter_notifications` (
    `id` VARCHAR(10) NOT NULL,
    `username` VARCHAR(20) NOT NULL, -- the person who received the notification, matches to `username` in phone_twitter_accounts
    `from` VARCHAR(20) NOT NULL, -- the person who sent the notification, matches to `username` in phone_twitter_accounts

    `type` VARCHAR(20) NOT NULL, -- like, retweet, reply, follow
    `tweet_id` VARCHAR(50) DEFAULT NULL, -- the tweet / reply this notification is about

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`from`) REFERENCES `phone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- PHONE
CREATE TABLE IF NOT EXISTS `phone_phone_contacts` (
    `contact_phone_number` VARCHAR(15) NOT NULL, -- the phone number of the contact
    `firstname` VARCHAR(50) NOT NULL DEFAULT "",
    `lastname` VARCHAR(50) NOT NULL DEFAULT "",
    `profile_image` VARCHAR(500) DEFAULT NULL,
    `email` VARCHAR(50) DEFAULT NULL,
    `address` VARCHAR(50) DEFAULT NULL,
    `favourite` BOOLEAN DEFAULT FALSE,
    `phone_number` VARCHAR(15) NOT NULL, -- the phone number of the person who added the contact

    PRIMARY KEY (`contact_phone_number`, `phone_number`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_phone_calls` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,

    `caller` VARCHAR(15) NOT NULL, -- the phone number of the person who called
    `callee` VARCHAR(15) NOT NULL, -- the phone number of the person who was called

    `duration` INT(11) NOT NULL DEFAULT 0,
    `answered` BOOLEAN DEFAULT FALSE, -- whether the call was answered or not

    `hide_caller_id` BOOLEAN DEFAULT FALSE, -- whether the caller's phone number was hidden or not

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE INDEX IF NOT EXISTS idx_calls_missed ON phone_phone_calls (`callee`, `answered`);
CREATE INDEX IF NOT EXISTS idx_calls_callee_id ON phone_phone_calls (`callee`);
CREATE INDEX IF NOT EXISTS idx_calls_caller_id ON phone_phone_calls (`caller`);

CREATE TABLE IF NOT EXISTS `phone_phone_blocked_numbers` (
    `phone_number` VARCHAR(15) NOT NULL, -- the phone number of the person who blocked the number
    `blocked_number` VARCHAR(15) NOT NULL, -- the phone number that was blocked

    PRIMARY KEY (`phone_number`, `blocked_number`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_phone_voicemail` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,

    `caller` VARCHAR(15) NOT NULL,
    `callee` VARCHAR(15) NOT NULL,

    `url` VARCHAR(500) NOT NULL,
    `duration` INT NOT NULL,
    `hide_caller_id` BOOLEAN DEFAULT FALSE,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- INSTAGRAM
CREATE TABLE IF NOT EXISTS `phone_instagram_accounts` (
    `display_name` VARCHAR(30) NOT NULL,

    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,

    `profile_image` VARCHAR(500) DEFAULT NULL,
    `bio` VARCHAR(100) DEFAULT NULL,

    `post_count` INT(11) NOT NULL DEFAULT 0,
    `story_count` INT(11) NOT NULL DEFAULT 0,
    `follower_count` INT(11) NOT NULL DEFAULT 0,
    `following_count` INT(11) NOT NULL DEFAULT 0,

    `phone_number` VARCHAR(15) NOT NULL,

    `private` BOOLEAN DEFAULT FALSE,

    `verified` BOOLEAN DEFAULT FALSE,
    `date_joined` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`username`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_follows` (
    `followed` VARCHAR(20) NOT NULL, -- the person followed, matches to `username` in phone_instagram_accounts
    `follower` VARCHAR(20) NOT NULL, -- the person following, matches to `username` in phone_instagram_accounts

    PRIMARY KEY (`followed`, `follower`),
    FOREIGN KEY (`followed`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`follower`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_posts` (
    `id` VARCHAR(10) NOT NULL,

    `media` TEXT, -- json array of attached media
    `caption` VARCHAR(500) NOT NULL DEFAULT "",
    `location` VARCHAR(50) DEFAULT NULL,

    `like_count` INT(11) NOT NULL DEFAULT 0,
    `comment_count` INT(11) NOT NULL DEFAULT 0,

    `username` VARCHAR(20) NOT NULL, -- the person who posted, matches to `username` in phone_instagram_accounts

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_comments` (
    `id` VARCHAR(10) NOT NULL,
    `post_id` VARCHAR(50) NOT NULL, -- the post this comment was made on, matches to `id` in phone_instagram_posts

    `username` VARCHAR(20) NOT NULL, -- the person who commented, matches to `username` in phone_instagram_accounts
    `comment` VARCHAR(500) NOT NULL DEFAULT "",
    `like_count` INT(11) NOT NULL DEFAULT 0,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`post_id`) REFERENCES `phone_instagram_posts`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_likes` (
    `id` VARCHAR(10) NOT NULL, -- the post / comment this like was on, matches to `id` in phone_instagram_posts / phone_instagram_comments
    `username` VARCHAR(20) NOT NULL, -- the person who liked, matches to `username` in phone_instagram_accounts
    `is_comment` BOOLEAN NOT NULL DEFAULT FALSE, -- whether this like was on a comment or a post

    PRIMARY KEY (`id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_messages` (
    `id` VARCHAR(10) NOT NULL,

    `sender` VARCHAR(20) NOT NULL, -- the person who sent the message, matches to `username` in phone_instagram_accounts
    `recipient` VARCHAR(20) NOT NULL, -- the person who received the message, matches to `username` in phone_instagram_accounts

    `content` VARCHAR(1000),
    `attachments` TEXT, -- json array of attachments

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`sender`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`recipient`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_notifications` (
    `id` VARCHAR(10) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `from` VARCHAR(20) NOT NULL,

    `type` VARCHAR(20) NOT NULL, -- like, comment, follow
    `post_id` VARCHAR(50) DEFAULT NULL, -- the post / comment this notification is about

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`from`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_stories` (
    `id` VARCHAR(10) NOT NULL,

    `username` VARCHAR(20) NOT NULL,
    `image` VARCHAR(500) NOT NULL,
    `metadata` LONGTEXT DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_stories_views` (
    `story_id` VARCHAR(50) NOT NULL,
    `viewer` VARCHAR(20) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`story_id`, `viewer`),
    FOREIGN KEY (`story_id`) REFERENCES `phone_instagram_stories`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`viewer`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_instagram_follow_requests` (
    `requester` VARCHAR(20) NOT NULL,
    `requestee` VARCHAR(20) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`requester`, `requestee`),
    FOREIGN KEY (`requester`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`requestee`) REFERENCES `phone_instagram_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CLOCK
CREATE TABLE IF NOT EXISTS `phone_clock_alarms` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `hours` INT(2) NOT NULL DEFAULT 0,
    `minutes` INT(2) NOT NULL DEFAULT 0,

    `label` VARCHAR(50) DEFAULT NULL,
    `enabled` BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (`id`, `phone_number`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- TINDER
CREATE TABLE IF NOT EXISTS `phone_tinder_accounts` (
    `name` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,

    `photos` TEXT, -- json array of photos
    `bio` VARCHAR(500) DEFAULT NULL,
    `dob` DATE NOT NULL,

    `is_male` BOOLEAN NOT NULL,
    `interested_men` BOOLEAN NOT NULL,
    `interested_women` BOOLEAN NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT TRUE,

    `last_seen` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`phone_number`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tinder_swipes` (
    `swiper` VARCHAR(15) NOT NULL, -- the phone number of the person who swiped
    `swipee` VARCHAR(15) NOT NULL, -- the phone number of the person who was swiped on

    `liked` BOOLEAN NOT NULL DEFAULT FALSE, -- whether the swiper liked the swipee or not

    PRIMARY KEY (`swiper`, `swipee`),
    FOREIGN KEY (`swiper`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`swipee`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tinder_matches` (
    `phone_number_1` VARCHAR(15) NOT NULL,
    `phone_number_2` VARCHAR(15) NOT NULL,

    `latest_message` VARCHAR(1000) DEFAULT NULL, -- the latest message sent between the two people
    `latest_message_timestamp` TIMESTAMP, -- the timestamp of the latest message sent between the two people

    PRIMARY KEY (`phone_number_1`, `phone_number_2`),
    FOREIGN KEY (`phone_number_1`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`phone_number_2`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tinder_messages` (
    `id` INT NOT NULL AUTO_INCREMENT, -- the message id

    `sender` VARCHAR(15) NOT NULL, -- the phone number of the person who sent the message
    `recipient` VARCHAR(15) NOT NULL, -- the phone number of the person who received the message

    `content` VARCHAR(1000),
    `attachments` TEXT, -- json array of attachments

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`sender`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`recipient`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- MESSAGES
CREATE TABLE IF NOT EXISTS `phone_message_channels` (
    `id` INT NOT NULL AUTO_INCREMENT,

    `is_group` BOOLEAN NOT NULL DEFAULT FALSE,
    `name` VARCHAR(50) DEFAULT NULL,
    `last_message` VARCHAR(50) NOT NULL DEFAULT "",
    `last_message_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_message_members` (
    `channel_id` INT NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,

    `is_owner` BOOLEAN NOT NULL DEFAULT FALSE,
    `deleted` BOOLEAN NOT NULL DEFAULT FALSE, -- if the member has deleted the channel
    `unread` INT NOT NULL DEFAULT 0,

    PRIMARY KEY (`channel_id`, `phone_number`),
    FOREIGN KEY (`channel_id`) REFERENCES `phone_message_channels`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE INDEX IF NOT EXISTS idx_members_phone_number ON phone_message_members (`phone_number`);

CREATE TABLE IF NOT EXISTS `phone_message_messages` (
    `id` INT NOT NULL AUTO_INCREMENT,

    `channel_id` INT NOT NULL,

    `sender` VARCHAR(15) NOT NULL,
    `content` VARCHAR(1000),
    `attachments` TEXT, -- json array of attachments
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES `phone_message_channels`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- DARKCHAT
CREATE TABLE IF NOT EXISTS `phone_darkchat_accounts` (
    `phone_number` VARCHAR(15) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,

    PRIMARY KEY (`username`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_darkchat_channels` (
    `name` VARCHAR(50) NOT NULL,

    PRIMARY KEY (`name`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_darkchat_members` (
    `channel_name` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL,

    PRIMARY KEY (`channel_name`, `username`),
    FOREIGN KEY (`channel_name`) REFERENCES `phone_darkchat_channels`(`name`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `phone_darkchat_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_darkchat_messages` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `channel` VARCHAR(50) NOT NULL,
    `sender` VARCHAR(20) NOT NULL,
    `content` VARCHAR(1000),
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`channel`) REFERENCES `phone_darkchat_channels`(`name`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`sender`) REFERENCES `phone_darkchat_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- WALLET
CREATE TABLE IF NOT EXISTS `phone_wallet_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `amount` INT(11) NOT NULL,
    `company` VARCHAR(50) NOT NULL,
    `logo` VARCHAR(200) DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- YELLOW PAGES
CREATE TABLE IF NOT EXISTS `phone_yellow_pages_posts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `description` VARCHAR(1000) NOT NULL,

    `attachment` VARCHAR(500) DEFAULT NULL,
    `price` INT(11) DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- BACKUPS
CREATE TABLE IF NOT EXISTS `phone_backups` (
    `id` VARCHAR(100) NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- MARKETPLACE
CREATE TABLE IF NOT EXISTS `phone_marketplace_posts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `title` VARCHAR(50) NOT NULL,
    `description` VARCHAR(1000) NOT NULL,
    `attachments` TEXT, -- json array of attachments
    `price` INT(11) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- MUSIC
CREATE TABLE IF NOT EXISTS `phone_music_playlists` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `name` VARCHAR(50) NOT NULL,
    `cover` VARCHAR(500) DEFAULT NULL,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_music_saved_playlists` (
    `playlist_id` INT UNSIGNED NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,

    PRIMARY KEY (`playlist_id`, `phone_number`),
    FOREIGN KEY (`playlist_id`) REFERENCES `phone_music_playlists`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_music_songs` (
    `song_id` VARCHAR(100) NOT NULL,
    `playlist_id` INT UNSIGNED NOT NULL,

    PRIMARY KEY (`song_id`, `playlist_id`),
    FOREIGN KEY (`playlist_id`) REFERENCES `phone_music_playlists`(`id`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- MAIL
CREATE TABLE IF NOT EXISTS `phone_mail_accounts` (
    `address` VARCHAR(100) NOT NULL,
    `password` VARCHAR(100) NOT NULL,

    PRIMARY KEY (`address`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_mail_messages` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,

    `recipient` VARCHAR(100) NOT NULL,
    `sender` VARCHAR(100) NOT NULL,

    `subject` VARCHAR(100) NOT NULL,
    `content` TEXT NOT NULL,
    `attachments` LONGTEXT, -- json array of attachments
    `actions` LONGTEXT, -- json array of actions

    `read` BOOLEAN NOT NULL DEFAULT FALSE,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE INDEX IF NOT EXISTS idx_recipient ON phone_mail_messages (`recipient`);
CREATE INDEX IF NOT EXISTS idx_sender ON phone_mail_messages (`sender`);

CREATE TABLE IF NOT EXISTS `phone_mail_deleted` (
    `message_id` INT UNSIGNED NOT NULL,
    `address` VARCHAR(100) NOT NULL,

    PRIMARY KEY (`message_id`, `address`),
    FOREIGN KEY (`message_id`) REFERENCES `phone_mail_messages`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`address`) REFERENCES `phone_mail_accounts`(`address`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- COMPANIES APP
CREATE TABLE IF NOT EXISTS `phone_services_channels` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,
    `company` VARCHAR(50) NOT NULL,

    `last_message` VARCHAR(100) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_services_messages` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `channel_id` INT UNSIGNED NOT NULL,

    `sender` VARCHAR(15) NOT NULL,
    `message` VARCHAR(1000) NOT NULL,

    `x_pos` INT(11) DEFAULT NULL,
    `y_pos` INT(11) DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES `phone_services_channels`(`id`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- MAPS
CREATE TABLE IF NOT EXISTS `phone_maps_locations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `name` VARCHAR(50) NOT NULL,

    `x_pos` FLOAT NOT NULL,
    `y_pos` FLOAT NOT NULL,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CRYPTO
CREATE TABLE IF NOT EXISTS `phone_crypto` (
    `id` VARCHAR(100) NOT NULL, -- player identifier
    `coin` VARCHAR(15) NOT NULL, -- coin, for example "bitcoin"
    `amount` DOUBLE NOT NULL DEFAULT 0, -- amount of coins
    `invested` INT(11) NOT NULL DEFAULT 0, -- amount of $$$ invested

    PRIMARY KEY (`id`, `coin`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ACCOUNT SWITCHER
CREATE TABLE IF NOT EXISTS `phone_logged_in_accounts` (
    `phone_number` VARCHAR(15) NOT NULL,
    `app` VARCHAR(50) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (`phone_number`, `app`, `username`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- TIKTOK
CREATE TABLE IF NOT EXISTS `phone_tiktok_accounts` (
    `name` VARCHAR(30) NOT NULL,
    `bio` VARCHAR(100) DEFAULT NULL,
    `avatar` VARCHAR(500) DEFAULT NULL,

    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,

    `verified` BOOLEAN DEFAULT FALSE,

    `follower_count` INT(11) NOT NULL DEFAULT 0,
    `following_count` INT(11) NOT NULL DEFAULT 0,
    `like_count` INT(11) NOT NULL DEFAULT 0,
    `video_count` INT(11) NOT NULL DEFAULT 0,

    `twitter` VARCHAR(20) DEFAULT NULL,
    `instagram` VARCHAR(20) DEFAULT NULL,

    `show_likes` BOOLEAN DEFAULT TRUE,

    `phone_number` VARCHAR(15) NOT NULL,
    `date_joined` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`username`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_follows` (
    `followed` VARCHAR(20) NOT NULL,
    `follower` VARCHAR(20) NOT NULL,

    PRIMARY KEY (`followed`, `follower`),
    FOREIGN KEY (`followed`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`follower`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_videos` (
    `id` VARCHAR(10) NOT NULL,

    `username` VARCHAR(20) NOT NULL,

    `src` VARCHAR(500) NOT NULL,
    `caption` VARCHAR(100) DEFAULT NULL,
    `metadata` LONGTEXT, -- json array of metadata
    `music` TEXT DEFAULT NULL,

    `likes` INT(11) NOT NULL DEFAULT 0,
    `comments` INT(11) NOT NULL DEFAULT 0,
    `views` INT(11) NOT NULL DEFAULT 0,
    `saves` INT(11) NOT NULL DEFAULT 0,

    `pinned_comment` VARCHAR(10) DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_likes` (
    `username` VARCHAR(20) NOT NULL,
    `video_id` VARCHAR(10) NOT NULL,

    PRIMARY KEY (`username`, `video_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_views` (
    `username` VARCHAR(20) NOT NULL,
    `video_id` VARCHAR(10) NOT NULL,

    PRIMARY KEY (`username`, `video_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_saves` (
    `username` VARCHAR(20) NOT NULL,
    `video_id` VARCHAR(10) NOT NULL,

    PRIMARY KEY (`username`, `video_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_comments` (
    `id` VARCHAR(10) NOT NULL,
    `reply_to` VARCHAR(10) DEFAULT NULL,
    `video_id` VARCHAR(10) NOT NULL,

    `username` VARCHAR(20) NOT NULL,
    `comment` VARCHAR(550) NOT NULL,

    `likes` INT(11) NOT NULL DEFAULT 0,
    `replies` INT(11) NOT NULL DEFAULT 0,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`reply_to`) REFERENCES `phone_tiktok_comments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_comments_likes` (
    `username` VARCHAR(20) NOT NULL,
    `comment_id` VARCHAR(10) NOT NULL,

    PRIMARY KEY (`username`, `comment_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`comment_id`) REFERENCES `phone_tiktok_comments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_channels` (
    `id` VARCHAR(10) NOT NULL,

    `last_message` VARCHAR(50) NOT NULL,

    `member_1` VARCHAR(20) NOT NULL,
    `member_2` VARCHAR(20) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY (`member_1`, `member_2`),
    FOREIGN KEY (`member_1`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`member_2`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_messages` (
    `id` VARCHAR(10) NOT NULL,
    `channel_id` VARCHAR(10) NOT NULL,
    `sender` VARCHAR(20) NOT NULL,

    `content` VARCHAR(500) NOT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES `phone_tiktok_channels`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`sender`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_pinned_videos` (
    `username` VARCHAR(20) NOT NULL,
    `video_id` VARCHAR(10) NOT NULL,

    PRIMARY KEY (`username`, `video_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_notifications` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(20) NOT NULL,

    `from` VARCHAR(20) NOT NULL,
    `type` VARCHAR(20) NOT NULL, -- like, comment, follow, save, reply or like_comment
    `video_id` VARCHAR(10) DEFAULT NULL,
    `comment_id` VARCHAR(10) DEFAULT NULL,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`from`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`comment_id`) REFERENCES `phone_tiktok_comments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `phone_tiktok_unread_messages` (
    `username` VARCHAR(20) NOT NULL,
    `channel_id` VARCHAR(10) NOT NULL,
    `amount` INT(11) NOT NULL DEFAULT 0,

    PRIMARY KEY (`username`, `channel_id`),
    FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`channel_id`) REFERENCES `phone_tiktok_channels`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- VOICE MEMOS
CREATE TABLE IF NOT EXISTS `phone_voice_memos_recordings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(15) NOT NULL,

    `file_name` VARCHAR(50) NOT NULL,
    `file_url` VARCHAR(500) NOT NULL,
    `file_length` INT(11) NOT NULL,

    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_number`) REFERENCES `phone_phones`(`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //

-- Instagram triggers
-- Triggers for post counts
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_post_count
AFTER INSERT ON phone_instagram_posts
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET post_count = post_count + 1
    WHERE username = NEW.username;
END;

CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_post_count
AFTER DELETE ON phone_instagram_posts
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET post_count = post_count - 1
    WHERE username = OLD.username;
END;

-- Trigger for story counts
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_story_count
AFTER INSERT ON phone_instagram_stories
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET story_count = story_count + 1
    WHERE username = NEW.username;
END;

CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_story_count
AFTER DELETE ON phone_instagram_stories
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET story_count = story_count - 1
    WHERE username = OLD.username;
END;

-- Trigger for comment counts
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_comment_count
AFTER INSERT ON phone_instagram_comments
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_posts
    SET comment_count = comment_count + 1
    WHERE id = NEW.post_id;
END;

CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_comment_count
AFTER DELETE ON phone_instagram_comments
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_posts
    SET comment_count = comment_count - 1
    WHERE id = OLD.post_id;
END;

-- Trigger for like counts
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_like_count
AFTER INSERT ON phone_instagram_likes
FOR EACH ROW
BEGIN
    IF NEW.is_comment = 0 THEN
        UPDATE phone_instagram_posts
        SET like_count = like_count + 1
        WHERE id = NEW.id;
    ELSE
        UPDATE phone_instagram_comments
        SET like_count = like_count + 1
        WHERE id = NEW.id;
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_like_count
AFTER DELETE ON phone_instagram_likes
FOR EACH ROW
BEGIN
    IF OLD.is_comment = 0 THEN
        UPDATE phone_instagram_posts
        SET like_count = like_count - 1
        WHERE id = OLD.id;
    ELSE
        UPDATE phone_instagram_comments
        SET like_count = like_count - 1
        WHERE id = OLD.id;
    END IF;
END;

-- Triggers for follower counts
CREATE TRIGGER IF NOT EXISTS phone_instagram_update_counts_after_follow
AFTER INSERT ON phone_instagram_follows
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    UPDATE phone_instagram_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END;

CREATE TRIGGER IF NOT EXISTS phone_instagram_update_counts_after_unfollow
AFTER DELETE ON phone_instagram_follows
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    UPDATE phone_instagram_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END;

-- Triggers for phone_twitter_follows
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_counts_after_follow
AFTER INSERT ON phone_twitter_follows
FOR EACH ROW
BEGIN
    -- Increment the follower_count for the followed user
    UPDATE phone_twitter_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    -- Increment the following_count for the follower user
    UPDATE phone_twitter_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END;

CREATE TRIGGER IF NOT EXISTS phone_twitter_update_counts_after_unfollow
AFTER DELETE ON phone_twitter_follows
FOR EACH ROW
BEGIN
    -- Decrement the follower_count for the followed user
    UPDATE phone_twitter_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    -- Decrement the following_count for the follower user
    UPDATE phone_twitter_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END;

CREATE TRIGGER IF NOT EXISTS phone_twitter_update_like_count_after_like
AFTER INSERT ON phone_twitter_likes
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET like_count = like_count + 1
    WHERE id = NEW.tweet_id;
END;

CREATE TRIGGER IF NOT EXISTS phone_twitter_update_like_count_after_unlike
AFTER DELETE ON phone_twitter_likes
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET like_count = like_count - 1
    WHERE id = OLD.tweet_id;
END;

CREATE TRIGGER IF NOT EXISTS phone_twitter_update_retweet_count_after_retweet
AFTER INSERT ON phone_twitter_retweets
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET retweet_count = retweet_count + 1
    WHERE id = NEW.tweet_id;
END;

CREATE TRIGGER IF NOT EXISTS phone_twitter_update_retweet_count_after_unretweet
AFTER DELETE ON phone_twitter_retweets
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET retweet_count = retweet_count - 1
    WHERE id = OLD.tweet_id;
END;

-- Triggers for phone_tiktok_follows
-- Increment phone_tiktok_accounts.follower_count and phone_tiktok_accounts.following_count after inserting a new row into phone_tiktok_follows
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_counts_after_follow
AFTER INSERT ON phone_tiktok_follows
FOR EACH ROW
BEGIN
    -- Increment the follower_count for the followed user
    UPDATE phone_tiktok_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    -- Increment the following_count for the follower user
    UPDATE phone_tiktok_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END;

-- Decrement phone_tiktok_accounts.follower_count and phone_tiktok_accounts.following_count after deleting a row from phone_tiktok_follows
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_counts_after_unfollow
AFTER DELETE ON phone_tiktok_follows
FOR EACH ROW
BEGIN
    -- Decrement the follower_count for the followed user
    UPDATE phone_tiktok_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    -- Decrement the following_count for the follower user
    UPDATE phone_tiktok_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END;

-- Trigger for phone_tiktok_videos
-- Trigger to increment phone_tiktok_accounts.video_count after inserting a new row into phone_tiktok_videos
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_count
AFTER INSERT ON phone_tiktok_videos
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    SET video_count = video_count + 1
    WHERE username = NEW.username;
END;

-- Trigger for phone_tiktok_likes
-- Trigger to increment phone_tiktok_videos.likes after inserting a new row into phone_tiktok_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_likes
AFTER INSERT ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET likes = likes + 1
    WHERE id = NEW.video_id;
END;

-- Trigger to decrement phone_tiktok_videos.likes after deleting a row from phone_tiktok_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_likes
AFTER DELETE ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET likes = likes - 1
    WHERE id = OLD.video_id;
END;

-- Trigger to increment phone_tiktok_accounts.like_count for the user after a new like is inserted into phone_tiktok_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_account_likes
AFTER INSERT ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    JOIN phone_tiktok_videos ON phone_tiktok_videos.username = phone_tiktok_accounts.username
    SET phone_tiktok_accounts.like_count = phone_tiktok_accounts.like_count + 1
    WHERE phone_tiktok_videos.id = NEW.video_id;
END;

-- Trigger to decrement phone_tiktok_accounts.like_count for the user after a like is removed from phone_tiktok_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_account_likes
AFTER DELETE ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    JOIN phone_tiktok_videos ON phone_tiktok_videos.username = phone_tiktok_accounts.username
    SET phone_tiktok_accounts.like_count = phone_tiktok_accounts.like_count - 1
    WHERE phone_tiktok_videos.id = OLD.video_id;
END;

-- Triggers for phone_tiktok_views
-- Trigger to increment phone_tiktok_videos.views when a new view is inserted into phone_tiktok_views
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_views
AFTER INSERT ON phone_tiktok_views
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET views = views + 1
    WHERE id = NEW.video_id;
END;

-- Triggers for phone_tiktok_saves
-- Increment saves after inserting a new row into phone_tiktok_saves
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_saves
AFTER INSERT ON phone_tiktok_saves
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET saves = saves + 1
    WHERE id = NEW.video_id;
END;

-- Decrement saves after deleting a row from phone_tiktok_saves
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_saves
AFTER DELETE ON phone_tiktok_saves
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET saves = saves - 1
    WHERE id = OLD.video_id;
END;

-- Triggers for phone_tiktok_comments
-- Increment phone_tiktok_videos.comments after inserting a new row into phone_tiktok_comments
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_comments
AFTER INSERT ON phone_tiktok_comments
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET comments = comments + 1
    WHERE id = NEW.video_id;
END;

-- Decrement phone_tiktok_videos.comments after deleting a row from phone_tiktok_comments
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_comments
BEFORE DELETE ON phone_tiktok_comments
FOR EACH ROW
BEGIN
    DECLARE v_replies_count INT;

    -- Count the replies for the comment
    SELECT COUNT(*) INTO v_replies_count
    FROM phone_tiktok_comments
    WHERE reply_to = OLD.id;

    -- Update the video's comments count
    UPDATE phone_tiktok_videos
    SET comments = comments - (1 + v_replies_count)
    WHERE id = OLD.video_id;
END;

-- Triggers for phone_tiktok_comments_likes
-- Increment phone_tiktok_comments.likes after inserting a new row into phone_tiktok_comments_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_comment_likes
AFTER INSERT ON phone_tiktok_comments_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_comments
    SET likes = likes + 1
    WHERE id = NEW.comment_id;
END;

-- Decrement phone_tiktok_comments.likes after deleting a row from phone_tiktok_comments_likes
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_comment_likes
AFTER DELETE ON phone_tiktok_comments_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_comments
    SET likes = likes - 1
    WHERE id = OLD.comment_id;
END;

-- Triggers for phone_tiktok_messages
-- Trigger to update phone_tiktok_channels.last_message after a new message is inserted into phone_tiktok_messages
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_last_message
AFTER INSERT ON phone_tiktok_messages
FOR EACH ROW
BEGIN
    DECLARE modified_content TEXT CHARACTER SET utf8mb4;

    IF NEW.content LIKE '<!SHARED-VIDEO-URL%' THEN
        SET modified_content = 'Shared a video';
    ELSEIF LENGTH(NEW.content) > 50 THEN
        SET modified_content = CONCAT(SUBSTR(NEW.content, 1, 17), '...');
    ELSE
        SET modified_content = NEW.content;
    END IF;

    UPDATE phone_tiktok_channels
    SET last_message = modified_content
    WHERE id = NEW.channel_id;
END;

//
DELIMITER ;

-- Execute somente se utilizou a adaptação antiga 'pandora:'
UPDATE phone_phones SET owner_id = REPLACE(owner_id, 'pandora:', 'vrp:') WHERE owner_id LIKE 'pandora:%';

