# Tortoise Companion Recruiter

A TortoiseWoW module that hires fresh cmangos PlayerBots as temporary party or raid companions.
It is a native port of the recruiter concept from `WoWGreymane/mod-companionRecruiter`, informed by
the older persistent companion implementation in `WrkX/core`.

## Features

- Recruit a tank, healer, or damage companion at the player's level.
- Fill a five-player party or a 10-, 20-, or 40-player Vanilla raid.
- Uses the PlayerBots random-account allocator instead of creating ad-hoc accounts.
- Charges only after character creation succeeds.
- Deletes temporary characters after the configurable contract lifetime.
- Protects expired contracts while the owner is dead or inside an instance, followed by a grace period.
- Cleans up when the owner logs out, leaves the group, dismisses the companions, or the server restarts.

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

The world migration creates recruiter entry `900001` in Stormwind and Orgrimmar.

## Requirements

- TortoiseWoW's native `modules/` framework.
- The vendored cmangos PlayerBots subsystem (`BUILD_PLAYERBOTS=ON`).

This module is written for the TortoiseWoW APIs and is not a drop-in AzerothCore module.
