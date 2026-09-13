# Tortoise Companion Recruiter

A TortoiseWoW module that hires fresh cmangos PlayerBots as temporary party or raid companions.
It is a native port of the recruiter concept from
[`WoWGreymane/mod-companionRecruiter`](https://github.com/WoWGreymane/mod-companionRecruiter), informed by
the older persistent companion implementation in [`WrkX/core`](https://github.com/WrkX/core).

## Features

- Recruit a tank, healer, or damage companion at the player's level.
- Fill a five-player party or a 10-, 20-, or 40-player Vanilla raid.
- Preserve faction-correct class choices and fill missing class coverage in 10- and 20-player raids.
- Uses the PlayerBots random-account allocator instead of creating ad-hoc accounts.
- Charges only after character creation succeeds.
- Initializes level-appropriate spells, skills, equipment, supplies, and pets explicitly for externally managed bots.
- Paces expensive preparation work so filling a raid does not initialize every bot in one world tick.
- Reserves pending group slots and refunds contracts that cannot log in and join in time.
- Deletes temporary characters after the configurable contract lifetime.
- Protects expired contracts while the owner is dead or inside an instance, followed by a grace period.
- Cleans up when the owner logs out, leaves the group, dismisses the companions, or the server restarts.

Contracts are intentionally process-local: restarting the world server invalidates and deletes every active
recruiter contract instead of attempting to restore its remaining duration.

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

The world migration creates recruiter entry `919001` in Stormwind and Orgrimmar.

## Requirements

- TortoiseWoW's native `modules/` framework.
- The vendored cmangos PlayerBots subsystem (`BUILD_PLAYERBOTS=ON`).
- `AiPlayerbot.Enabled = 1` at runtime.
- Static module linkage; the vendored PlayerBots library is not safe to duplicate inside a dynamic module.

The integration also adds `PlayerbotFactory::InitializeAtCurrentLevel()` to this TortoiseWoW fork. That
hook initializes a new externally managed bot without changing its requested level or depending on the
global random-level and auto-learn settings.

This module is written for the TortoiseWoW APIs and is not a drop-in AzerothCore module.
