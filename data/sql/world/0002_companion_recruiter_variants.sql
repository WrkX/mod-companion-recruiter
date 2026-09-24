-- Twelve level-60 recruiter variants. The shared script supplies the gossip
-- options used by the Companion Recruiter addon. Spawns are placed by GMs and
-- recorded in a later migration after their positions have been approved.
-- 919001-919005: Alliance; 919006-919010: Horde; 919011-919012: neutral.
-- Neutral 2 temporarily shares display 7102 until a second model is chosen.

-- Retire the two fixed spawns created by 0001; the new placement set is manual.
DELETE FROM `creature` WHERE `guid` IN (9190001, 9190002) AND `id` = 919001;

-- Keep the original recruiter as the Human variant so its existing gossip
-- text and level-60 template remain the source for every new variant.
UPDATE `creature_template`
SET `display_id1` = 12954,
    `display_id2` = 0,
    `display_id3` = 0,
    `display_id4` = 0,
    `level_min` = 60,
    `level_max` = 60,
    `faction` = 12,
    `npc_flags` = `npc_flags` | 1,
    `script_name` = 'npc_companion_recruiter'
WHERE `entry` = 919001;

DELETE FROM `creature_template` WHERE `entry` BETWEEN 919002 AND 919012;
DROP TEMPORARY TABLE IF EXISTS `_companion_recruiter_variants`;
CREATE TEMPORARY TABLE `_companion_recruiter_variants` LIKE `creature_template`;
INSERT INTO `_companion_recruiter_variants` SELECT * FROM `creature_template` WHERE `entry` = 919001;

-- Alliance: Dwarf, Gnome, High Elf, Night Elf.
UPDATE `_companion_recruiter_variants` SET `entry` = 919002, `display_id1` = 12549;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919003, `display_id1` = 15453;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919004, `display_id1` = 18226;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919005, `display_id1` = 15459;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;

-- Horde: Orc, Troll, Goblin, Tauren, Undead.
UPDATE `_companion_recruiter_variants` SET `entry` = 919006, `display_id1` = 12165, `faction` = 29;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919007, `display_id1` = 11083;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919008, `display_id1` = 10468;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919009, `display_id1` = 2096;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919010, `display_id1` = 8672;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;

-- Neutral variants.
UPDATE `_companion_recruiter_variants` SET `entry` = 919011, `display_id1` = 7102, `faction` = 35;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;
UPDATE `_companion_recruiter_variants` SET `entry` = 919012, `display_id1` = 7102;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_variants`;

DROP TEMPORARY TABLE `_companion_recruiter_variants`;
