"""Compile recruiter travel and check dungeon re-entry and dead-bot safety."""
from pathlib import Path

from test_auto_revive import compile_and_run
from test_gear_generation import extract


PREFIX = r'''
#include <cstdint>
#include <chrono>
#include <cmath>
#include <iostream>
#include <map>
#include <stdexcept>
using uint32 = uint32_t;
struct Clock {
    using time_point = std::chrono::steady_clock::time_point;
    static time_point current;
    static time_point now() { return current; }
};
Clock::time_point Clock::current{std::chrono::seconds(1000)};
float TeleportDistance() { return 100; }
uint32 StuckSeconds() { return 8; }
constexpr uint32 TELE_TO_NOT_LEAVE_COMBAT = 1, TELE_TO_NOT_UNSUMMON_PET = 2, TELE_TO_FORCE_MAP_CHANGE = 4;
constexpr uint32 PLAYER_FLAGS = 0, PLAYER_FLAGS_GHOST = 1;
struct DungeonPersistentState {};
struct InstanceGroupBind { DungeonPersistentState* state; };
struct InstancePlayerBind { DungeonPersistentState* state; bool perm; };
struct Map {
    bool dungeon = false; uint32 id = 33;
    bool IsDungeon() const { return dungeon; }
    uint32 GetId() const { return id; }
};
struct DungeonMap : Map {
    DungeonPersistentState* state = nullptr;
    DungeonPersistentState* GetPersistanceState() const { return state; }
};
struct Group {
    InstanceGroupBind* bind = nullptr; InstanceGroupBind created{};
    InstanceGroupBind* GetBoundInstance(uint32) { return bind; }
    InstanceGroupBind* BindToInstance(DungeonPersistentState* state, bool) {
        created.state = state; bind = &created; return bind;
    }
};
struct Player {
    bool alive = true, world = true, teleport = false, ghost = false, taxi = false, flying = false;
    bool reject = false; uint32 mapId = 33, instance = 7, teleports = 0, flags = 0;
    bool combat = false;
    float x = 1, y = 2;
    float distance = 200;
    Map* map = nullptr; Group* group = nullptr; InstancePlayerBind* bind = nullptr;
    bool IsAlive() const { return alive; }
    bool IsInCombat() const { return combat; }
    uint32 GetGUIDLow() const { return 2; }
    bool IsInWorld() const { return world; }
    bool IsBeingTeleported() const { return teleport; }
    bool IsTaxiFlying() const { return taxi; }
    bool IsFlying() const { return flying; }
    bool HasFlag(uint32, uint32) const { return ghost; }
    bool IsInGroup(Player* other, bool) const { return group && group == other->group; }
    uint32 GetMapId() const { return mapId; }
    uint32 GetInstanceId() const { return instance; }
    float GetDistance(Player*) const { return distance; }
    Group* GetGroup() const { return group; }
    Map* GetMap() const { return map; }
    InstancePlayerBind* GetBoundInstance(uint32) const { return bind; }
    float GetPositionX() const { return x; }
    float GetPositionY() const { return y; }
    float GetPositionZ() const { return 3; }
    float GetOrientation() const { return 4; }
    bool TeleportTo(uint32, float, float, float, float, uint32 options) {
        ++teleports; flags = options; return !reject;
    }
};
uint32 blocked = 0;
bool noPath = false;
bool HasNoPathToOwner(Player*, Player*) { return noPath; }
void LogCompanionTravelBlocked(Player*, Player*, char const*) { ++blocked; }
void check(bool ok, char const* message) { if (!ok) throw std::runtime_error(message); }
'''

CHECKS = r'''
int main() {
    try {
        DungeonPersistentState current, other;
        DungeonMap map; map.dungeon = true; map.state = &current;
        Group group;
        Player owner, bot; owner.group = bot.group = &group; owner.map = &map;
        bot.alive = false; bot.ghost = true; bot.mapId = 0;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 0 && !group.bind, "Dead bot followed through a resurrecting dungeon portal");
        bot.alive = true; bot.ghost = false;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 1 && group.bind->state == &current, "Living bot did not enter owner's bound dungeon");
        bot.mapId = 33; bot.instance = 8;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 2 && (bot.flags & TELE_TO_FORCE_MAP_CHANGE), "Same-map wrong instance used near teleport");
        bot.instance = 7; bot.distance = 10;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 2, "Nearby bot was needlessly teleported");
        bot.mapId = 0; bot.instance = 0;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 3 && group.bind->state == &current, "Exit/re-entry lost the original dungeon binding");
        InstanceGroupBind conflict{&other}; group.bind = &conflict;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 3 && blocked == 1 && conflict.state == &other, "Conflicting group binding overwritten or silently ignored");
        group.bind = &group.created;
        InstancePlayerBind permanent{&other, true}; bot.bind = &permanent;
        BringCompanionToOwner(&owner, &bot);
        check(bot.teleports == 3 && blocked == 2, "Permanent raid binding bypassed");
        bot.bind = nullptr; bot.reject = true;
        BringCompanionToOwner(&owner, &bot);
        check(blocked == 3, "Core teleport rejection was silent");
        bot.reject = false; bot.mapId = owner.mapId; bot.instance = owner.instance;
        bot.distance = 50; noPath = true;
        check(!CompanionIsWithOwner(&owner, &bot), "Unwalkable path was ignored");
        noPath = false;
        check(CompanionIsWithOwner(&owner, &bot), "Stuck timer did not start");
        Clock::current += std::chrono::seconds(7);
        check(CompanionIsWithOwner(&owner, &bot), "Stuck timer fired early");
        Clock::current += std::chrono::seconds(1);
        check(!CompanionIsWithOwner(&owner, &bot), "Stuck companion did not recover");
        bot.combat = true; noPath = true;
        check(CompanionIsWithOwner(&owner, &bot), "Path recovery interrupted combat");
        bot.combat = false; noPath = false;
        check(CompanionIsWithOwner(&owner, &bot), "Progress tracking did not restart");
        bot.x += 11; Clock::current += std::chrono::seconds(8);
        check(CompanionIsWithOwner(&owner, &bot), "Moving companion was classified as stuck");
        std::cout << "PASS: dead-bot guard, dungeon binding, forced instance change, exit/re-entry, rejection diagnostics\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


if __name__ == "__main__":
    cpp = (Path(__file__).resolve().parents[1] / "src/CompanionRecruiter.cpp").read_text(encoding="utf-8")
    source = PREFIX + extract(cpp, "struct FollowProgress", ";")
    source += "std::map<uint32, FollowProgress> gFollowProgress;\n"
    for signature in ("bool IsSafeTeleportTarget(", "bool CompanionIsWithOwner(", "void BringCompanionToOwner("):
        source += extract(cpp, signature)
    compile_and_run(source + CHECKS)
