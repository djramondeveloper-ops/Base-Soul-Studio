CREATE TABLE IF NOT EXISTS `seoul_brothels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `owner_passport` int DEFAULT NULL,
  `balance` bigint NOT NULL DEFAULT 0,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `entrance` longtext NULL,
  `management` longtext NULL,
  `cashier` longtext NULL,
  `prices` longtext NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `seoul_brothel_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `brothel_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `coords` longtext NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_brothel_rooms_brothel` (`brothel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `seoul_brothel_workers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `brothel_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `model` varchar(80) NOT NULL,
  `coords` longtext NOT NULL,
  `heading` float NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_brothel_workers_brothel` (`brothel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `seoul_brothel_members` (
  `brothel_id` int NOT NULL,
  `passport` int NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'manager',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`brothel_id`,`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `seoul_brothel_transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `brothel_id` int NOT NULL,
  `passport` int DEFAULT NULL,
  `type` varchar(30) NOT NULL,
  `amount` bigint NOT NULL DEFAULT 0,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_brothel_transactions_brothel` (`brothel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
