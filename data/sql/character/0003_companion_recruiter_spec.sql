ALTER TABLE `companion_recruiter_owned`
  ADD COLUMN `spec_tab` TINYINT UNSIGNED NOT NULL DEFAULT 255 AFTER `role`;

-- Give legacy role-only companions a sensible tree while preserving their role.
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
END;
