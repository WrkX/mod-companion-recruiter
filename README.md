# Windrunner Companion Recruiter

Hire PlayerBot companions from a Companion Guild recruiter: a tank, healer, or damage dealer for a few hours, a full party or raid fill, or a permanent companion that stays on your character’s roster.

The repository name is `windrunne-companion-Recruiter`. Keep the checkout at `modules/mod-companion-recruiter` in the TortoiseWoW source tree so CMake and SQL updates find it.

## What you can do

Talk to a **Companion Recruiter** NPC (title **Companion Guild**) with the client addon enabled.

- Recruit a single companion at your level, with class and talent tree. Role comes from that tree (tank, healer, or damage). Temporary companions get a random race from your faction.
- Fill a 5-player party toward one tank, one healer, and three damage dealers, counting roles already in the group.
- Fill a 10-, 20-, or 40-player Vanilla raid, keeping faction-legal classes and filling missing coverage in 10- and 20-player raids.
- Buy a permanent companion (flat gold cost). Invite it later from **Manage Roster** at no extra charge. Ownership is per character, with a configurable roster cap.
- Temporary contracts last three hours by default. Price scales with level (1 silver at 10, 30 silver at 40, 1 gold at 60). You are charged only after the bot character is created.

Companions stay at the level they were hired or summoned. They do not gain XP or follow later level-ups. Permanent companions catch up to the owner’s level each time you invite them, then refresh talents, spells, gear, supplies, and pets.

Paid temporary contracts live in the character database. Logging out or restarting the world server logs the companion out; it reconnects when you return if the original deadline (or an active expiry-grace period) has not passed. Expired contracts keep a short grace while you are dead or in an instance: the timer runs in the open world and pauses while protected, without resetting when you go back inside.

Companions are cleaned up when you leave the group, dismiss them, delete the owning character, or the contract ends. They keep the group’s chosen leader when they join or reconnect. Dungeon portals keep invitations and the group through loading screens; after they land, leftover movement from the previous map is cleared.

## Requirements

- TortoiseWoW with the native `modules/` framework
- Vendored cmangos PlayerBots (`BUILD_PLAYERBOTS=ON`) and `AiPlayerbot.Enabled = 1`
- **Static** module linkage (PlayerBots is not safe to duplicate in a dynamic module)

This TortoiseWoW fork also provides `PlayerbotFactory::InitializeAtCurrentLevel()`, which sets up an externally managed bot without changing its requested level or depending on global random-level / auto-learn settings.

## Install

1. Clone or copy this repo to `modules/mod-companion-recruiter` in the TortoiseWoW source tree.
2. Configure and build with PlayerBots and static modules:

```sh
cmake -S . -B build \
  -DBUILD_PLAYERBOTS=ON \
  -DMODULES=static \
  -DMODULE_MOD_COMPANION_RECRUITER=static
```

3. Allow module SQL (`Database.AutoUpdate.AllowedModules = "all"`, or add this module to the allowlist). Character SQL creates `companion_recruiter_owned` and `companion_recruiter_contract`. World SQL installs recruiter NPCs, gossip, and companion banter.
4. Copy `conf/mod_companion_recruiter.conf.dist` to `mod_companion_recruiter.conf` in the installed module config directory.

## Client addon

Copy `addon/CompanionRecruiter` into the Vanilla 1.12 client’s `Interface/AddOns` folder. Enable **Companion Recruiter** on the character-select AddOns screen.

Recruitment uses the addon window. The stock gossip frame is suppressed for this NPC’s recruitment replies. Keep the addon and server module in sync; copying only the Lua file will not fix an older server that still sends oversized responses.

`/crdebug` opens a visual preview anywhere (tabs, class/spec, party and raid flow). Purchases, invitations, and dismissals stay disabled until you speak to a recruiter. The sample roster exists only in preview.

## Companion Mode

`AiPlayerbot.WindrunnerCompanionMode` defaults to `1` in PlayerBots config. With it on, this recruiter is the only source of bot creation and login. Existing random-bot accounts stay in the database but remain offline. Recruited companions still follow, fight, answer their owner, and show up in `/who`.

Changing Companion Mode needs a **server restart**. Set it to `0` to restore normal PlayerBots behavior. The DungeonClear `.dc test` harness creates bots directly, so run that harness with Companion Mode off and restart first.

World SQL installs about 1,000 occasional party conversations. Missing or invalid conversation data disables only that banter. Full scripts (level, faction, speakers) are in [docs/COMPANION_BANTER.md](docs/COMPANION_BANTER.md).

## Recruiter NPCs

World data defines twelve level-60 variants (`919001`–`919012`) on script `npc_companion_recruiter`, plus placed spawns. All use the **Companion Guild** title and greeting.

| Faction | Race | Entry | `.npc add` |
| --- | --- | --- | --- |
| Alliance | Human | 919001 | `.npc add 919001` |
| Alliance | Dwarf | 919002 | `.npc add 919002` |
| Alliance | Gnome | 919003 | `.npc add 919003` |
| Alliance | High Elf | 919004 | `.npc add 919004` |
| Alliance | Night Elf | 919005 | `.npc add 919005` |
| Horde | Orc | 919006 | `.npc add 919006` |
| Horde | Troll | 919007 | `.npc add 919007` |
| Horde | Goblin | 919008 | `.npc add 919008` |
| Horde | Tauren | 919009 | `.npc add 919009` |
| Horde | Undead | 919010 | `.npc add 919010` |
| Neutral | — | 919011 | `.npc add 919011` |
| Neutral | — | 919012 | `.npc add 919012` |

Stand where you want the NPC, face the right way, then run `.npc add` as a GM. If templates are already loaded, `.reload creature_template` or a world restart is enough.

## Configuration

See `conf/mod_companion_recruiter.conf.dist`. Defaults include:

| Setting | Default | Purpose |
| --- | --- | --- |
| `CompanionRecruiter.Enabled` | `1` | Master switch |
| `CompanionRecruiter.MinimumLevel` | `10` | Lowest player level that can recruit |
| `CompanionRecruiter.CostMultiplier` | `1.0` | Scales temporary prices (`0` = free) |
| `CompanionRecruiter.PermanentCostGold` | `75` | One-time permanent purchase |
| `CompanionRecruiter.MaxOwnedCompanions` | `40` | Permanent roster cap per character |
| `CompanionRecruiter.LifetimeMinutes` | `180` | Temporary contract length |
| `CompanionRecruiter.LoginTimeoutSeconds` | `120` | Refund if the bot cannot log in / join |
| `CompanionRecruiter.PreparationsPerUpdate` | `2` | Spell/gear setup budget per world tick |
| `CompanionRecruiter.ProtectInInstances` | `1` | Keep expired contracts while dead or instanced |
| `CompanionRecruiter.ExpiryGraceMinutes` | `10` | Grace after expiry outside protection |
| `CompanionRecruiter.MaxCompanionsPerPlayer` | `39` | Cap vs. 40-player raid size |
| `CompanionRecruiter.TeleportDistance` | `100` | Snap companion to owner across maps / distance |
| `CompanionRecruiter.StuckSeconds` | `8` | Snap if follow is stuck out of combat |

Preparation is rate-limited so a raid fill does not initialize every bot in one tick. Failed logins refund the contract.

## Gear and talents

Temporary companions are geared at the level they were purchased. Permanent companions use their level after catching up to the owner level captured at invite. Target and item-level ranges are captured at that moment; swapping the owner’s gear while a bot waits in the queue does not change that run.

- Below 55: target **bot level + 5**.
- 55 and up: target **max(55, owner’s average equipped item level)** (empty slots, shirts, and tabards excluded).
- Prefer items within `GearItemLevelRange` (default ±5). If a slot has nothing usable, widen to `GearItemLevelFallbackRange` (default ±15), then the closest suitable lower item. Caps still apply (`RandomGearMaxLevel` and the fallback upper bound). Scarce slots can land below the target; the outfit average is not guaranteed.

Enchants apply only when item level is **strictly greater** than `EnchantItemLevelThreshold` (default 65). Set it to `0` to use PlayerBots’ normal level-based enchanting.

Talent trees use PlayerBots paths when they exist. Missing Vanilla trees get a generated progression that keeps the requested tree as the main spec. Those paths are functional defaults, not hand-tuned raid builds.

## Tests

Standalone checks (no live server or database) live under `tests/`. See [tests/README.md](tests/README.md) for commands and coverage.

## Out of scope

Gurubashi arena automation from the AzerothCore recruiter is not part of this port.

## License

GNU Affero General Public License v3. See [LICENSE](LICENSE).
