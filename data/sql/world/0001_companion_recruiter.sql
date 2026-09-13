-- TortoiseWoW / MaNGOS schema. Creates one neutral recruiter and two capital spawns.
SET @RECRUITER_ENTRY := 919001;
SET @SOURCE_ENTRY := 20102;
SET @STORMWIND_GUID := 9190001;
SET @ORGRIMMAR_GUID := 9190002;
SET @GOSSIP_TEXT := 919100;

DELETE FROM `creature` WHERE `guid` IN (@STORMWIND_GUID, @ORGRIMMAR_GUID);
DELETE FROM `creature_template` WHERE `entry` = @RECRUITER_ENTRY;
DELETE FROM `npc_text` WHERE `ID` = @GOSSIP_TEXT;
DELETE FROM `broadcast_text` WHERE `entry` = @GOSSIP_TEXT;

DROP TEMPORARY TABLE IF EXISTS `_companion_recruiter_template`;
CREATE TEMPORARY TABLE `_companion_recruiter_template` LIKE `creature_template`;
INSERT INTO `_companion_recruiter_template` SELECT * FROM `creature_template` WHERE `entry` = @SOURCE_ENTRY;
UPDATE `_companion_recruiter_template`
SET `entry` = @RECRUITER_ENTRY,
    `display_id1` = 2027,
    `display_id2` = 0,
    `display_id3` = 0,
    `display_id4` = 0,
    `name` = 'Companion Recruiter',
    `subname` = 'Adventure Guild',
    `gossip_menu_id` = 0,
    `level_min` = 60,
    `level_max` = 60,
    `faction` = 35,
    `npc_flags` = `npc_flags` | 1,
    `unit_flags` = 0,
    `dynamic_flags` = 0,
    `ai_name` = '',
    `movement_type` = 0,
    `script_name` = 'npc_companion_recruiter'
WHERE `entry` = @SOURCE_ENTRY;
INSERT INTO `creature_template` SELECT * FROM `_companion_recruiter_template`;
DROP TEMPORARY TABLE `_companion_recruiter_template`;

INSERT INTO `broadcast_text`
    (`entry`, `male_text`, `female_text`, `chat_type`, `sound_id`, `language_id`,
     `emote_id1`, `emote_id2`, `emote_id3`, `emote_delay1`, `emote_delay2`, `emote_delay3`)
VALUES
    (@GOSSIP_TEXT,
     'The roads are dangerous, $N. The Adventure Guild keeps blades, prayers, and spells ready for those with coin and cause.',
     '', 0, 0, 0, 0, 0, 0, 0, 0, 0);

INSERT INTO `npc_text`
    (`ID`, `BroadcastTextID0`, `Probability0`, `BroadcastTextID1`, `Probability1`,
     `BroadcastTextID2`, `Probability2`, `BroadcastTextID3`, `Probability3`,
     `BroadcastTextID4`, `Probability4`, `BroadcastTextID5`, `Probability5`,
     `BroadcastTextID6`, `Probability6`, `BroadcastTextID7`, `Probability7`)
VALUES
    (@GOSSIP_TEXT, @GOSSIP_TEXT, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

INSERT INTO `creature`
    (`guid`, `id`, `id2`, `id3`, `id4`, `map`, `position_x`, `position_y`, `position_z`,
     `orientation`, `spawntimesecsmin`, `spawntimesecsmax`, `wander_distance`,
     `health_percent`, `mana_percent`, `movement_type`, `spawn_flags`, `visibility_mod`)
VALUES
    (@STORMWIND_GUID, @RECRUITER_ENTRY, 0, 0, 0, 0, -8913.23, 554.633, 93.7944,
     0.6591, 300, 300, 0, 100, 100, 0, 0, 0),
    (@ORGRIMMAR_GUID, @RECRUITER_ENTRY, 0, 0, 0, 1, 1503.89, -4415.43, 22.6348,
     0.1890, 300, 300, 0, 100, 100, 0, 0, 0);
