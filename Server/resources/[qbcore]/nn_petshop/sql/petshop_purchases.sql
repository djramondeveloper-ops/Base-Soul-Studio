-- Pet Shop: stores which pets and clothing each player has purchased (persists across sessions)
-- pet_type: 'dog' | 'cat' | 'clothing'
-- pet_id: for dogs e.g. retriever, pug; for cats e.g. cat_grey; for clothing e.g. white_cap, safety_glasses
CREATE TABLE IF NOT EXISTS `petshop_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `pet_type` varchar(20) NOT NULL COMMENT 'dog, cat, or clothing',
  `pet_id` varchar(50) NOT NULL COMMENT 'e.g. retriever, cat_grey, white_cap',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_purchase` (`citizenid`, `pet_type`, `pet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
