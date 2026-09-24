-- Persistent companions are owned by one character GUID. Their bot character
-- remains in the PlayerBots random account pool, but this table is the authority
-- that decides which player may invite it.
CREATE TABLE IF NOT EXISTS `companion_recruiter_owned` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_guid` INT UNSIGNED NOT NULL,
  `bot_guid` INT UNSIGNED NOT NULL,
  `class_id` TINYINT UNSIGNED NOT NULL,
  `role` TINYINT UNSIGNED NOT NULL,
  `purchase_cost` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_companion_recruiter_owned_bot` (`bot_guid`),
  KEY `idx_companion_recruiter_owned_owner` (`owner_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
