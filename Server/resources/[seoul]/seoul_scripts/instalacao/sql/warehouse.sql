CREATE TABLE IF NOT EXISTS `seoul_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT NULL,
  `identifier` varchar(64) DEFAULT NULL,
  `owner` varchar(80) DEFAULT NULL,
  `name` varchar(40) NOT NULL,
  `code` varchar(8) NOT NULL,
  `location_index` int(11) NOT NULL,
  `max_slots` int(11) NOT NULL DEFAULT 50,
  `max_weight` int(11) NOT NULL DEFAULT 50000,
  `original_price` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
