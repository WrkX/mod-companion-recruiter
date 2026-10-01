"""Exercise real companion maintenance across loading screens and preparation.

The ObjectAccessor fixture reproduces TortoiseWoW's in-world-only
FindConnectedPlayer alias. No server or database is started.
"""
import argparse
from pathlib import Path

from test_auto_revive import compile_and_run
from test_gear_generation import extract


PREFIX = r'''
#include <chrono>
#include <cstdint>
#include <functional>
#include <iostream>
#include <map>
#include <set>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>
using uint8 = uint8_t; using uint32 = uint32_t;
using uint64 = uint64_t; using int32 = int32_t;
using BotRoles = int;
constexpr BotRoles BOT_ROLE_DPS = 4;
constexpr uint8 INVALID_SPEC_TAB = 255;
constexpr uint8 GENDER_NONE = 2;
constexpr uint32 HIGHGUID_PLAYER = 0, MAX_GROUP_SIZE = 5, MAX_RAID_SIZE = 40;
struct EquipmentItemLevelTarget {};
struct Clock {
    using time_point = std::chrono::steady_clock::time_point;
    static time_point current;
    static time_point now() { return current; }
};
Clock::time_point Clock::current{std::chrono::seconds(1000)};
uint64 UnixNow() { return uint64(std::chrono::duration_cast<std::chrono::seconds>(Clock::now().time_since_epoch()).count()); }
uint32 LoginTimeoutSeconds() { return 120; }
uint32 GraceSeconds() { return 600; }
uint32 EnchantItemLevelThreshold() { return 65; }
Clock::time_point RestoreDeadline(uint64 value) { return Clock::time_point(std::chrono::seconds(value)); }
struct ObjectGuid {
    uint32 value = 0;
    ObjectGuid(uint32 id = 0) : value(id) {}
    ObjectGuid(uint32, uint32 id) : value(id) {}
    uint32 GetCounter() const { return value; }
    bool IsEmpty() const { return !value; }
    bool operator==(ObjectGuid other) const { return value == other.value; }
};
struct Session {
    bool logout = false;
    bool PlayerLogout() const { return logout; }
};
struct Player;
struct Group {
    uint32 leader = 1, changes = 0;
    std::set<uint32> members;
    bool raid = false;
    bool isBGGroup() const { return false; }
    bool isRaidGroup() const { return raid; }
    bool IsMember(ObjectGuid guid) const { return members.count(guid.value); }
    bool IsLeader(ObjectGuid guid) const { return leader == guid.value; }
    bool IsAssistant(ObjectGuid) const { return false; }
    ObjectGuid GetLeaderGuid() const { return leader; }
    uint32 GetId() const { return 7; }
    uint32 GetMembersCount() const { return uint32(members.size()); }
    bool HandleHardcoreInteraction(Player*) const { return true; }
    void RemoveInvite(Player*) {}
    void ChangeLeader(ObjectGuid guid) { leader = guid.value; ++changes; }
    bool Create(ObjectGuid guid, char const*) { leader = guid.value; members.insert(guid.value); return true; }
    bool AddMember(ObjectGuid guid, char const*);
};
struct PlayerbotAI;
struct Player {
    uint32 id = 1, mapId = 0, instanceId = 0, level = 40, removals = 0, refunds = 0;
    bool world = true, teleport = false, alive = true, xp = true, hasSession = true;
    Group* group = nullptr;
    PlayerbotAI* ai = nullptr;
    Session session;
    enum class HardcoreInteractionResult { Allowed };
    ObjectGuid GetObjectGuid() const { return id; }
    uint32 GetGUIDLow() const { return id; }
    uint32 GetMapId() const { return mapId; }
    uint32 GetInstanceId() const { return instanceId; }
    uint32 GetLevel() const { return level; }
    void GiveLevel(uint32 requested) { level = requested; }
    bool IsInWorld() const { return world; }
    bool IsBeingTeleported() const { return teleport; }
    bool IsAlive() const { return alive; }
    Group* GetGroup() const { return group; }
    Group* GetOriginalGroup() const { return nullptr; }
    Group* GetGroupInvite() const { return nullptr; }
    char const* GetName() const { return "fixture"; }
    Session* GetSession() { return hasSession ? &session : nullptr; }
    bool IsInGroup(Player* other, bool) const { return group && group == other->group; }
    HardcoreInteractionResult HandleHardcoreInteraction(Player*, bool) const { return HardcoreInteractionResult::Allowed; }
    void RemoveFromGroup() { ++removals; if (group) group->members.erase(id); group = nullptr; }
    void SetXPGain(bool enable) { xp = enable; }
    void LogModifyMoney(int32, char const*) { ++refunds; }
};
namespace ObjectAccessor {
    std::map<uint32, Player*> players;
    Player* FindPlayerNotInWorld(ObjectGuid guid) {
        auto it = players.find(guid.value); return it == players.end() ? nullptr : it->second;
    }
    Player* FindConnectedPlayer(ObjectGuid guid) {
        Player* player = FindPlayerNotInWorld(guid); return player && player->world ? player : nullptr;
    }
}
bool Group::AddMember(ObjectGuid guid, char const*) {
    members.insert(guid.value);
    if (Player* player = ObjectAccessor::FindConnectedPlayer(guid)) player->group = this;
    return true;
}
struct ObjectMgr { uint32 creates = 0; void AddGroup(Group*) { ++creates; } } sObjectMgr;
struct Logger { template<class... Args> void outError(Args...) {} } sLog;
void NotifyOwnerCannotLeadGroup(Player*, Group*, Player*) {}
enum class BotState { BOT_STATE_NON_COMBAT };
struct PlayerbotAI {
    Player* master = nullptr;
    bool follow = false, staleMovement = true;
    uint32 strategyResets = 0, movementResets = 0, role = 0;
    Player* GetMaster() const { return master; }
    void SetMaster(Player* owner) { master = owner; }
    void SetForcedRole(uint8 value) { role = value; }
    void DoSpecificAction(char const*) {}
    void ResetStrategies() { ++strategyResets; follow = false; }
    void ChangeStrategy(char const*, BotState) { follow = true; }
    void Reset(bool full) { if (full) { ++movementResets; staleMovement = false; } }
};
PlayerbotAI* GetBotAI(Player* bot) { return bot ? bot->ai : nullptr; }
struct BotManager {
    std::map<uint32, Player*> bots;
    std::set<uint32> pending;
    std::map<std::pair<uint32, std::string>, uint32> values;
    uint32 logouts = 0, logins = 0, cancels = 0;
    Player* GetPlayerBot(uint32 id) { auto it = bots.find(id); return it == bots.end() ? nullptr : it->second; }
    bool HasPendingBotLogin(uint32 id) const { return pending.count(id); }
    void AddPlayerBot(uint32 id, uint32) { ++logins; pending.insert(id); }
    void CancelPendingBotLogin(uint32 id) { ++cancels; pending.erase(id); }
    void LogoutPlayerBot(uint32 id, bool) { ++logouts; bots.erase(id); }
    void SetExternallyManaged(uint32, bool) {}
    uint32 GetValue(uint32 id, char const* key) { return values[{id, key}]; }
    void SetValue(uint32 id, char const* key, uint32 value) { values[{id, key}] = value; }
} sRandomPlayerbotMgr;
uint32 gearPreparations = 0;
struct PlayerbotFactory {
    PlayerbotFactory(Player*, uint32) {}
    void InitializeAtCurrentLevel(EquipmentItemLevelTarget, uint32) { ++gearPreparations; }
    void EnchantEquipment() {}
};
uint32 RecruiterSpecNo(uint8, uint8) { return 1; }
namespace AiFactory { uint32 GetPlayerRoles(Player*) { return BOT_ROLE_DPS; } }
struct TalentSpec {
    TalentSpec(Player*) {}
    uint32 GetTalentPoints() const { return 31; }
    uint8 highestTree() const { return 0; }
};
uint32 messages = 0, persists = 0, deletes = 0;
void SendMessage(Player*, std::string const&) { ++messages; }
void DeleteCompanion(uint32 id) { ++deletes; sRandomPlayerbotMgr.bots.erase(id); }
Player* GetCommandMaster(Player* owner) { return owner; }
void BringCompanionToOwner(Player*, Player*) {} // Travel/bindings have their own production harness.
bool IsProtected(Player* owner) { return !owner->alive || owner->mapId == 33; }
void check(bool ok, char const* message) { if (!ok) throw std::runtime_error(message); }
'''

SUPPORT = r'''
std::map<uint32, CompanionContract> gContracts;
std::map<uint32, OwnedCompanion> gOwnedCompanions;
std::map<uint32, std::pair<uint32, uint32>> gCompanionLocations;
void PersistTemporaryContract(CompanionContract const&) { ++persists; }
void RefreshTemporaryMarker(CompanionContract const&) {}
struct Config {
    bool companionRecruiterRegistered = false;
    std::function<void()> companionRecruiterOnTalentSpecsLoaded;
    std::function<bool(uint32)> companionRecruiterAllowsLogin;
} sPlayerbotAIConfig;
void ReloadRecruiterSpecPaths() {}
bool IsEnabled() { return true; }
struct CompanionRecruiterNpc {};
struct CompanionRecruiterWorld {};
struct CompanionRecruiterPlayer {};
struct CompanionRecruiterGroup {};
'''

CHECKS = r'''
void Addmod_companion_recruiterScripts();
int main(int argc, char** argv) {
    try {
        std::string scenario = argc > 1 ? argv[1] : "all";
        Player owner, temporary, permanent;
        temporary.id = 2; permanent.id = 3;
        PlayerbotAI tempAi, ownedAi; temporary.ai = &tempAi; permanent.ai = &ownedAi;
        tempAi.master = ownedAi.master = &owner;
        tempAi.follow = ownedAi.follow = true;
        Group group; group.members = {1, 2, 3};
        owner.group = temporary.group = permanent.group = &group;
        ObjectAccessor::players = {{1, &owner}, {2, &temporary}, {3, &permanent}};
        sRandomPlayerbotMgr.bots = {{2, &temporary}, {3, &permanent}};
        CompanionContract contract;
        contract.botGuid = 2; contract.ownerGuid = 1; contract.prepared = true;
        contract.joinedOnce = contract.initialized = true;
        contract.expiresAtUnix = 10000; contract.expiresAt = RestoreDeadline(10000);
        OwnedCompanion owned;
        owned.botGuid = 3; owned.ownerGuid = 1; owned.invited = owned.prepared = true;
        owned.name = "Owned"; owned.level = 40;
        gContracts[2] = contract; gOwnedCompanions[3] = owned;
        sRandomPlayerbotMgr.values[{2, "companion_recruiter"}] = 1;
        sRandomPlayerbotMgr.values[{3, "companion_recruiter_owned"}] = 1;
        uint32 budget = 4;
        Addmod_companion_recruiterScripts();

        if (scenario == "all" || scenario == "zoning") {
            owner.world = false; owner.teleport = true;
            check(!ObjectAccessor::FindConnectedPlayer(owner.GetObjectGuid()), "Fixture does not reproduce the core lookup");
            for (uint32 tick = 0; tick < 130; ++tick) {
                Clock::current += std::chrono::seconds(1);
                UpdateContracts(budget); UpdateOwnedCompanions(budget);
            }
            check(!gContracts.at(2).suspended && gOwnedCompanions.at(3).invited,
                  "Loading screen suspended temporary or dismissed permanent companion");
            check(sPlayerbotAIConfig.companionRecruiterAllowsLogin(2) &&
                  sPlayerbotAIConfig.companionRecruiterAllowsLogin(3), "Portal owner blocked queued companion login");
            check(group.members.size() == 3 && temporary.group == &group && permanent.group == &group &&
                  !sRandomPlayerbotMgr.logouts && !sRandomPlayerbotMgr.logins && !sObjectMgr.creates,
                  "Loading screen removed companions or rebuilt the group");
            check(budget == 4 && !gearPreparations && !messages, "Zoning prepared bots or emitted cancellation messages");
            owner.world = true; owner.teleport = false; owner.mapId = 33; owner.instanceId = 7;
            temporary.world = permanent.world = false;
            temporary.teleport = permanent.teleport = true;
            Clock::current += std::chrono::seconds(130);
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(!sRandomPlayerbotMgr.logouts && gOwnedCompanions.at(3).invited,
                  "Companion transfer was treated as a failed invitation");
            temporary.world = permanent.world = true;
            temporary.teleport = permanent.teleport = false;
            temporary.mapId = permanent.mapId = 33;
            temporary.instanceId = permanent.instanceId = 7;
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(owner.group == &group && temporary.group == &group && permanent.group == &group &&
                  group.members.size() == 3 && !group.changes && !sObjectMgr.creates,
                  "Dungeon landing changed group identity, membership, or leader");
            check(tempAi.follow && ownedAi.follow, "Dungeon landing lost active follow strategies");
            check(gContracts.at(2).expiresAtUnix == 10000, "Portal extended the paid contract lifetime");

            // Pending invites also survive a slow owner/bot loading screen.
            gOwnedCompanions.at(3).prepared = false;
            gOwnedCompanions.at(3).inviteStartedAt = Clock::now();
            permanent.group = nullptr; group.members.erase(3);
            permanent.world = false; permanent.teleport = true;
            for (uint32 tick = 0; tick < 130; ++tick) {
                Clock::current += std::chrono::seconds(1);
                UpdateOwnedCompanions(budget);
            }
            check(gOwnedCompanions.at(3).invited && !gOwnedCompanions.at(3).prepared &&
                  !sRandomPlayerbotMgr.logouts && !gearPreparations,
                  "Pending invite timed out or prepared during bot loading");
            permanent.world = true; permanent.teleport = false;
            UpdateOwnedCompanions(budget);
            check(permanent.group == &group && gOwnedCompanions.at(3).invited,
                  "Pending companion failed to join after loading");
        }

        if (scenario == "all" || scenario == "preparation") {
            gOwnedCompanions.at(3).prepared = false; gOwnedCompanions.at(3).specTab = 0;
            gOwnedCompanions.at(3).summonLevel = 40; budget = 4;
            ownedAi.follow = false;
            UpdateOwnedCompanions(budget);
            check(ownedAi.strategyResets >= 2 && ownedAi.follow && !permanent.xp,
                  "Permanent companion lost follow while rebuilding talents/gear/strategies");
            gContracts.at(2).prepared = false; gContracts.at(2).specTab = 0; tempAi.follow = false;
            UpdateContracts(budget);
            check(tempAi.follow && !temporary.xp, "Preassigned temporary master prevented follow after preparation");
            uint32 const preparations = gearPreparations;
            ownedAi.follow = tempAi.follow = false; // Explicit owner stay command.
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(!ownedAi.follow && !tempAi.follow && gearPreparations == preparations,
                  "Routine maintenance overrode stay or regenerated equipment");
        }

        if (scenario == "all" || scenario == "movement") {
            InitializeOnlineCompanion(gContracts.at(2), &owner, &temporary);
            InitializeOwnedCompanion(gOwnedCompanions.at(3), &owner, &permanent);
            uint32 const tempResets = tempAi.movementResets, ownedResets = ownedAi.movementResets;
            bool const tempFollow = tempAi.follow, ownedFollow = ownedAi.follow;
            temporary.mapId = permanent.mapId = 34; temporary.instanceId = permanent.instanceId = 8;
            tempAi.staleMovement = ownedAi.staleMovement = true;
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(!tempAi.staleMovement && !ownedAi.staleMovement &&
                  tempAi.movementResets == tempResets + 1 && ownedAi.movementResets == ownedResets + 1,
                  "Map change retained old movement paths");
            check(tempAi.follow == tempFollow && ownedAi.follow == ownedFollow,
                  "Map change replaced explicit movement strategies");
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(tempAi.movementResets == tempResets + 1 && ownedAi.movementResets == ownedResets + 1,
                  "Routine maintenance repeatedly reset movement");
            temporary.instanceId = permanent.instanceId = 9;
            UpdateContracts(budget); UpdateOwnedCompanions(budget);
            check(tempAi.movementResets == tempResets + 2 && ownedAi.movementResets == ownedResets + 2,
                  "Same-map instance change retained old movement paths");
        }

        // A real logout must still stop companion activity, including the
        // interval before the Player disappears from ObjectAccessor.
        owner.session.logout = true;
        check(!sPlayerbotAIConfig.companionRecruiterAllowsLogin(2) &&
              !sPlayerbotAIConfig.companionRecruiterAllowsLogin(3), "Logging-out owner allowed bot login");
        UpdateContracts(budget); UpdateOwnedCompanions(budget);
        check(gContracts.at(2).suspended && !gOwnedCompanions.at(3).invited &&
              sRandomPlayerbotMgr.logouts == 2 && !gCompanionLocations.count(2) && !gCompanionLocations.count(3),
              "Real logout failed to suspend/dismiss companions and clear movement tracking");
        owner.session.logout = false; ObjectAccessor::players.erase(1);
        check(!sPlayerbotAIConfig.companionRecruiterAllowsLogin(2) &&
              !sPlayerbotAIConfig.companionRecruiterAllowsLogin(3), "Absent owner allowed bot login");
        std::cout << "PASS: " << scenario << ", owner logout and login policy\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


def run(source_path, scenario):
    cpp = source_path.read_text(encoding="utf-8")
    source = PREFIX
    for signature in ("struct CompanionContract", "struct OwnedCompanion"):
        source += extract(cpp, signature, ";")
    source += SUPPORT
    for signature in ("Player* FindCompanionOwner(", "void MaintainCompanionFollow("):
        if signature in cpp:
            source += extract(cpp, signature)
    for signature in ("bool EnsureCompanionInGroup(", "bool ApplyRecruiterSpec(",
                      "bool PrepareOnlineCompanion(", "bool InitializeOnlineCompanion(",
                      "bool InitializeOwnedCompanion(", "void EnsureOwnedCompanionOnline(",
                      "void DismissOwnedCompanion(", "void UpdateOwnedCompanions(",
                      "void SuspendTemporaryCompanion(", "bool UpdateContractGrace(",
                      "void UpdateContracts(", "void Addmod_companion_recruiterScripts("):
        source += extract(cpp, signature)
    # The compiled main supports individual historical regression cases.
    source += CHECKS.replace('argc > 1 ? argv[1] : "all"', f'"{scenario}"')
    compile_and_run(source)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=Path(__file__).resolve().parents[1] / "src/CompanionRecruiter.cpp")
    parser.add_argument("--case", choices=("all", "zoning", "preparation", "movement"), default="all")
    args = parser.parse_args()
    run(args.source, args.case)
