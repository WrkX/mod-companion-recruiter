# Tortoise Companion Recruiter

A TortoiseWoW module that hires fresh cmangos PlayerBots as temporary party or raid companions.
It is a native port of the recruiter concept from
[`WoWGreymane/mod-companionRecruiter`](https://github.com/WoWGreymane/mod-companionRecruiter), informed by
the older persistent companion implementation in [`WrkX/core`](https://github.com/WrkX/core).

## Features

- Recruit a tank, healer, or damage companion at the player's level.
- Select a class specialization for temporary and permanent companions; the companion's role is derived from its selected talent tree. Temporary companions receive a random valid race from the owner's faction.
- Fill a five-player party toward one tank, one healer, and three damage dealers using the selected human roles and the roles of bots already in the group, or fill a 10-, 20-, or 40-player Vanilla raid.
- Preserve faction-correct class choices and fill missing class coverage in 10- and 20-player raids.
- Uses the PlayerBots random-account allocator instead of creating ad-hoc accounts.
- Charges only after character creation succeeds.
- Initializes level-appropriate spells, skills, equipment, supplies, and pets explicitly for externally managed bots.
- Shares one preparation budget between temporary recruitment and permanent summons, so a raid does not initialize every bot in one world tick.
- Reserves pending group slots and refunds contracts that cannot log in and join in time.
- Companions preserve the group's chosen leadership when joining or reconnecting.
- Dungeon portals preserve active companion invitations and the existing group through loading screens. Once companions land, they clear movement paths from the previous map or instance.
- Persists paid temporary contracts across owner logout and world-server restarts, reconnecting their companions until the original absolute contract deadline.
- Deletes temporary characters after the configurable contract lifetime.
- Protects expired contracts while the owner is dead or inside an instance. The grace period counts down outside protection and pauses while protected, without resetting on re-entry.
- Suspends companions while their owner is offline and cleans them up when the owner leaves the group, dismisses them, deletes the owning character, or their contract expires.
- Sells permanent companions that are stored in a character-owned roster and can be invited again for free.
- Keeps permanent companion ownership private to the purchasing character, with a configurable roster limit.
- Sets temporary companions up at the level they were purchased at; active companions do not gain XP or follow their owner's later level-ups.
- Prepares permanent companions once per summon, catching them up to the owner's level captured at the invitation and refreshing their talents, spells, gear, supplies, and pets.
- Targets bot level + 5 below level 55, and the owner's average equipped item level (at least 55) from level 55 onward, with configurable preferred and fallback ranges. Summoned companions keep their setup until dismissed; summon them again to refresh it.

Paid temporary contracts are stored in the character database. Logging out or restarting the world server
logs the companion out without cancelling the purchase; it reconnects when the owner returns, provided the
original absolute contract deadline (or an active expiry-protection grace period) has not elapsed.

Temporary contracts last three hours by default. Their gold price increases at every player level,
interpolating from 1 silver at level 10 through 30 silver at level 40 to 1 gold at level 60.
Permanent companions cost a flat 75 gold at every level. The temporary multiplier, permanent gold
price, and contract duration can be adjusted in `mod_companion_recruiter.conf`.

Equipment generation targets **bot level + 5** for bots below level 55. At level 55 and above,
it targets **max(55, owner's average equipped item level)**. The average excludes empty slots,
shirts, and tabards, and rounds to the nearest item level. Each slot first tries suitable items within
`CompanionRecruiter.GearItemLevelRange` (default **±5**). If none can be equipped, it tries
`CompanionRecruiter.GearItemLevelFallbackRange` (default **±15**), then the closest suitable lower item.
The fallback's upper limit and `AiPlayerbot.RandomGearMaxLevel` remain hard caps. Within each range,
items closest to the target are preferred, with specialization stat weights breaking ties. Class,
level, faction, uniqueness, and blacklist restrictions still apply. Scarce slots may consequently
fall below the target; the finished outfit's average is not an exact guarantee.

For example, a level **40** bot targets **45**, preferring item levels **40–50** and widening a missing
slot to **30–60** before considering older gear. A level **55** bot targets **55** if the owner's
average is lower or no items are equipped, or **70** if the owner's average is 70. This minimum
applies to the target, not to each generated item. Both range settings are clamped to 0–100, and the
fallback cannot be narrower than the preferred range. The target and ranges are captured when
buying/summoning, so changing equipment while a bot waits for preparation does not change that
generation. Permanent companions use their level after catching up to the captured owner level.

Generated equipment is enchanted only when its item level is strictly greater than
`CompanionRecruiter.EnchantItemLevelThreshold` (default **65**). This applies equally to role-only,
specialization-selected, party-fill, raid-fill, temporary, and permanent companions. Set the threshold to
`0` to use PlayerBots' normal level-based enchanting behavior.

The recruiter uses PlayerBots' configured talent paths where they cover a specialization. For any missing
tree it creates a valid progression path from that class's available talents, spilling into other trees
when the requested tree is full while keeping it the main specialization, so every Vanilla tree can be
selected; those generated paths are functional defaults rather than hand-tuned raid builds.

The separate Gurubashi arena automation from the AzerothCore repository is intentionally outside the
scope of this first port.

## Install

Place this repository at `modules/mod-companion-recruiter` in the TortoiseWoW source tree, then configure
with PlayerBots and modules enabled:

```sh
cmake -S . -B build \
  -DBUILD_PLAYERBOTS=ON \
  -DMODULES=static \
  -DMODULE_MOD_COMPANION_RECRUITER=static
```

Allow module SQL updates (`Database.AutoUpdate.AllowedModules = "all"` or add this module to the
allowlist), and copy `mod_companion_recruiter.conf.dist` to `mod_companion_recruiter.conf` in the installed
module config directory.

`AiPlayerbot.WindrunnerCompanionMode` defaults to `1` in the PlayerBots configuration. With it
enabled, the recruiter is the only source of bot creation and login. Existing random bot accounts
and characters stay in the database but remain offline. Recruited companions still follow and
fight, answer their owner, and appear in `/who`. The world SQL update installs 1,000 occasional
party conversations; missing or invalid conversation data disables only that banter. Changing
Companion Mode requires a server restart. Set it to `0` to restore normal PlayerBots behavior.
Read the complete dialogue with level, faction, and speaker details in
[COMPANION_BANTER.md](docs/COMPANION_BANTER.md).
The DungeonClear `.dc test` harness creates bots directly, so run that harness with Companion Mode
set to `0` and restart first.

The world migrations create twelve level-60 recruiter variants (`919001` through `919012`) with the
same `npc_companion_recruiter` gossip script. The original fixed Stormwind and Orgrimmar spawns are
removed so the final locations can be placed by a GM. See [SPAWN_COMMANDS.md](SPAWN_COMMANDS.md)
for the entry and display ID mapping and the in-game spawn commands.
The template SQL removes the inherited invisible trigger flag from all recruiter variants and uses
the title and greeting **Companion Guild**. For an existing world, apply the two `creature_template`
and `broadcast_text` UPDATE statements in the section marked `0002_companion_recruiter_variants.sql`
in `data/sql/world.sql`, then restart the world server to make existing recruiters visible outside GM mode.
The consolidated world SQL updates existing Goblin and neutral recruiter
models to their current display IDs.
The consolidated character SQL creates `companion_recruiter_owned`, which stores each permanent companion's
owner, purchase metadata, role, and specialization, and `companion_recruiter_contract`, which stores active
paid temporary contracts and their absolute deadlines. Existing role-only permanent companions receive a
matching default specialization when the new migration runs.

## Client addon

Copy `addon/CompanionRecruiter` into the Vanilla 1.12 client's `Interface/AddOns` directory.
Enable **Companion Recruiter** on the character selection AddOns screen, then speak to a
Companion Recruiter in Stormwind or Orgrimmar. Recruitment uses the addon's own window;
the stock gossip frame is suppressed for this NPC's recruitment responses.
Keep the addon and server module updated together. In particular, the permanent-recruitment
transport fix requires rebuilding and restarting the server as well as updating the addon.
Copying only the Lua file cannot repair an oversized response from an older server build.
Use `/crdebug` to open or close a visual preview anywhere. Browse the tabs, class and specialization choices, and party or raid flow in preview mode. Purchases,
invitations, and dismissals remain disabled until you speak to the NPC. The sample roster is
only shown in preview mode.

The window supports temporary party filling, class and specialization recruitment, raid filling, permanent
companion purchases, and a roster tab for inviting or dismissing owned companions. Raid groups get a
`Fill Raid` action in place of the party fill action.
Use the **Permanent Recruitment** tab to buy a companion once; use **Manage Roster** to invite it
again later without another charge.

## Requirements

- TortoiseWoW's native `modules/` framework.
- The vendored cmangos PlayerBots subsystem (`BUILD_PLAYERBOTS=ON`).
- `AiPlayerbot.Enabled = 1` at runtime.
- Static module linkage; the vendored PlayerBots library is not safe to duplicate inside a dynamic module.

The integration also adds `PlayerbotFactory::InitializeAtCurrentLevel()` to this TortoiseWoW fork. That
hook initializes an externally managed bot without changing its requested level or depending on the
global random-level and auto-learn settings. Its optional `EquipmentItemLevelTarget` carries the
captured equipment average and ranges into PlayerBots' equipment selection without changing normal
random-bot generation.

This module is written for the TortoiseWoW APIs and is not a drop-in AzerothCore module.

See [tests/README.md](tests/README.md) for the standalone checks, their coverage, and prerequisites.
