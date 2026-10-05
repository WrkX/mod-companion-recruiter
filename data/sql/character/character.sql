-- BEGIN SOURCE: data/sql/character/0002_companion_recruiter_owned.sql
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
-- END SOURCE: data/sql/character/0002_companion_recruiter_owned.sql

-- BEGIN SOURCE: data/sql/character/0003_companion_recruiter_spec.sql
ALTER TABLE `companion_recruiter_owned`
  ADD COLUMN IF NOT EXISTS `spec_tab` TINYINT UNSIGNED NOT NULL DEFAULT 255 AFTER `role`;

-- Give legacy role-only companions a sensible tree while preserving their role.
-- 255 is the unset sentinel, so a replay leaves a chosen spec alone.
UPDATE `companion_recruiter_owned`
SET `spec_tab` = CASE
  WHEN `class_id` = 1 AND `role` = 1 THEN 2 -- Warrior tank: Protection
  WHEN `class_id` = 1 THEN 1 -- Warrior damage: Fury
  WHEN `class_id` = 2 AND `role` = 1 THEN 1 -- Paladin tank: Protection
  WHEN `class_id` = 2 AND `role` = 2 THEN 0 -- Paladin healer: Holy
  WHEN `class_id` = 2 THEN 2 -- Paladin damage: Retribution
  WHEN `class_id` = 3 THEN 0 -- Hunter: Beast Mastery
  WHEN `class_id` = 4 THEN 1 -- Rogue: Combat
  WHEN `class_id` = 5 AND `role` = 2 THEN 1 -- Priest healer: Holy
  WHEN `class_id` = 5 THEN 2 -- Priest damage: Shadow
  WHEN `class_id` = 7 AND `role` = 2 THEN 2 -- Shaman healer: Restoration
  WHEN `class_id` = 7 THEN 1 -- Shaman damage: Enhancement
  WHEN `class_id` = 8 THEN 0 -- Mage: Arcane
  WHEN `class_id` = 9 THEN 0 -- Warlock: Affliction
  WHEN `class_id` = 11 AND `role` = 1 THEN 1 -- Druid tank: Feral
  WHEN `class_id` = 11 AND `role` = 2 THEN 2 -- Druid healer: Restoration
  WHEN `class_id` = 11 THEN 0 -- Druid damage: Balance
  ELSE 255
END
WHERE `spec_tab` = 255;
-- END SOURCE: data/sql/character/0003_companion_recruiter_spec.sql

-- BEGIN SOURCE: data/sql/character/0004_companion_recruiter_contract.sql
-- Temporary paid contracts survive owner logout and world-server restarts.
-- Absolute Unix deadlines keep elapsed offline/server-down time part of the
-- purchased lifetime; runtime login state is reconstructed when the owner
-- reconnects.
CREATE TABLE IF NOT EXISTS `companion_recruiter_contract` (
  `bot_guid` INT UNSIGNED NOT NULL,
  `owner_guid` INT UNSIGNED NOT NULL,
  `paid_cost` INT UNSIGNED NOT NULL DEFAULT 0,
  `class_id` TINYINT UNSIGNED NOT NULL,
  `role` TINYINT UNSIGNED NOT NULL,
  `spec_tab` TINYINT UNSIGNED NOT NULL DEFAULT 255,
  `gear_average` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `gear_range` SMALLINT UNSIGNED NOT NULL DEFAULT 5,
  `gear_fallback_range` SMALLINT UNSIGNED NOT NULL DEFAULT 15,
  `expires_at` BIGINT UNSIGNED NOT NULL,
  `grace_expires_at` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `prepared` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `joined_once` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `warning_mask` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bot_guid`),
  KEY `idx_companion_recruiter_contract_owner` (`owner_guid`),
  KEY `idx_companion_recruiter_contract_expiry` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- END SOURCE: data/sql/character/0004_companion_recruiter_contract.sql

