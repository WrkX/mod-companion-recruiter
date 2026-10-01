# Standalone checks

These scripts compile small harnesses around the production C++ functions or run the addon against a
mock Vanilla UI. Each script covers a separate behavior; they are not duplicates of one another. They
do not start a server or access a database. The C++ harnesses require Python 3 and a C++17 compiler;
on Windows they locate Visual Studio automatically. Some checks also read the sibling TortoiseWoW
server checkout, which is expected at the module's normal `modules/mod-companion-recruiter` location.

Run an individual check from the module root:

| Command | Coverage | Additional requirement |
| --- | --- | --- |
| `python tests/test_gear_generation.py` | Gear targets, candidate ranges, fallback choices, and restrictions | Sibling server checkout |
| `python tests/test_contract_grace.py` | Contract grace countdown, protection pauses, expiry, offline time, and restart restoration | None |
| `python tests/test_group_leadership.py` | Party/raid membership and preservation of explicit leadership | None |
| `python tests/test_gossip_transport.py` | C++ gossip menu construction and Vanilla packet limits | Lua 5.2 is optional; pass `--lua <path>` to also exercise the addon |
| `python tests/test_auto_revive.py` | Delayed recovery, rezzer detection, instance handling, and AI reset | Sibling server checkout |
| `python tests/test_dungeon_travel.py` | Safe dungeon entry, re-entry, bindings, and teleport failures | None |

The gossip check with Lua also verifies addon navigation, permanent class/spec/race purchases,
roster paging, and suppression of the stock gossip frame. Without Lua it still validates generated
menus, action indexes, packet decoding, and the legacy overflow boundary.

The checks are intentionally runnable as scripts rather than requiring pytest or another test runner.
