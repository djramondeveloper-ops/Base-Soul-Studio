CREATE TABLE IF NOT EXISTS `nn_petshop_pets` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `pet_type` VARCHAR(16) NOT NULL,
    `pet_id` VARCHAR(64) NOT NULL,
    `custom_name` VARCHAR(64) DEFAULT NULL,
    `obedience` INT NOT NULL DEFAULT 100,
    `hunger` INT NOT NULL DEFAULT 100,
    `thirst` INT NOT NULL DEFAULT 100,
    `equipped_clothing` VARCHAR(64) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `owner_pet` (`identifier`, `pet_type`, `pet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `nn_petshop_clothing` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `clothing_id` VARCHAR(64) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `owner_clothing` (`identifier`, `clothing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
