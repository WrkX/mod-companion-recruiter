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
- Paces expensive preparation work so filling a raid does not initialize every bot in one world tick.
- Reserves pending group slots and refunds contracts that cannot log in and join in time.
- Deletes temporary characters after the configurable contract lifetime.
- Protects expired contracts while the owner is dead or inside an instance, followed by a grace period.
- Cleans up when the owner logs out, leaves the group, dismisses the companions, or the server restarts.
- Sells permanent companions that are stored in a character-owned roster and can be invited again for free.
- Keeps permanent companion ownership private to the purchasing character, with a configurable roster limit.
- Catches permanent companions up to their owner's level when invited or when the owner levels up.
- Regenerates permanent companions' class-appropriate gear at first initialization and after level catch-up;
  at level 55 and above, equipment selection follows the owner's equipped gear score when available.

Contracts are intentionally process-local: restarting the world server invalidates and deletes every active
recruiter contract instead of attempting to restore its remaining duration.

Temporary contracts last three hours by default. Their gold price increases at every player level,
interpolating from 1 silver at level 10 through 30 silver at level 40 to 1 gold at level 60.
Permanent companions cost a flat 75 gold at every level. The temporary multiplier, permanent gold
price, and contract duration can be adjusted in `mod_companion_recruiter.conf`.

The recruiter uses PlayerBots' configured talent paths where they cover a specialization. For any missing
tree it creates a valid progression path from that class's available talents, so every Vanilla tree can be
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

The world migrations create twelve level-60 recruiter variants (`919001` through `919012`) with the
same `npc_companion_recruiter` gossip script. The original fixed Stormwind and Orgrimmar spawns are
removed so the final locations can be placed by a GM. See [SPAWN_COMMANDS.md](SPAWN_COMMANDS.md)
for the entry and display ID mapping and the in-game spawn commands.
The character migrations create `companion_recruiter_owned`, which stores each permanent companion's
owner, purchase metadata, role, and specialization. Existing role-only companions receive a matching
default specialization when the new migration runs.

## Client addon

Copy `addon/CompanionRecruiter` into the Vanilla 1.12 client's `Interface/AddOns` directory.
Enable **Companion Recruiter** on the character selection AddOns screen, then speak to a
Companion Recruiter in Stormwind or Orgrimmar. The addon replaces only that NPC's gossip
window. If the addon is disabled, the regular gossip menu still works.
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
global random-level and auto-learn settings. Its optional master gear sync uses PlayerBots' existing
item-level cap when preparing a permanent companion.

This module is written for the TortoiseWoW APIs and is not a drop-in AzerothCore module.
