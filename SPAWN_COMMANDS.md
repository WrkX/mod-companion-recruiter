# Place the companion recruiters

Apply `data/sql/world/0002_companion_recruiter_variants.sql` before placing these NPCs. If the world server is already running, enter `.reload creature_template` as an administrator; a restart also loads the new templates. Stand at each intended location, face the desired direction, and run its command in GM chat. `.npc add` saves the spawn to the world database.

| Side | Appearance | Display ID | Entry | GM command |
| --- | --- | ---: | ---: | --- |
| Alliance | Human | 12954 | 919001 | `.npc add 919001` |
| Alliance | Dwarf | 12549 | 919002 | `.npc add 919002` |
| Alliance | Gnome | 15453 | 919003 | `.npc add 919003` |
| Alliance | High Elf | 18226 | 919004 | `.npc add 919004` |
| Alliance | Night Elf | 15459 | 919005 | `.npc add 919005` |
| Horde | Orc | 12165 | 919006 | `.npc add 919006` |
| Horde | Troll | 11083 | 919007 | `.npc add 919007` |
| Horde | Goblin | 10468 | 919008 | `.npc add 919008` |
| Horde | Tauren | 2096 | 919009 | `.npc add 919009` |
| Horde | Undead | 8672 | 919010 | `.npc add 919010` |
| Neutral | Neutral 1 | 7102 | 919011 | `.npc add 919011` |
| Neutral | Neutral 2 | 7102* | 919012 | `.npc add 919012` |

*Neutral 2 uses display 7102 until a second display ID is supplied.*

All twelve templates have gossip flag `1` and script name `npc_companion_recruiter`. Select their gossip to open the existing recruiter menu and addon.

After you have placed the NPCs, tell me they are ready. I will query the saved `creature` rows by these entry IDs and create a follow-up world migration with the exact GUIDs, maps, coordinates, orientations, and spawn settings. This keeps the already applied template migration unchanged.
