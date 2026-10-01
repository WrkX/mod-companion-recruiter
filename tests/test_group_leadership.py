"""Compile actual group maintenance and verify ordinary group authority."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from test_gear_generation import extract


PREFIX = r'''
#include <cstdint>
#include <iostream>
#include <map>
#include <set>
#include <stdexcept>
#include <string>
using uint32 = uint32_t;
struct ObjectGuid {
    uint32 value = 0;
    ObjectGuid(uint32 v = 0) : value(v) {}
    uint32 GetCounter() const { return value; }
    bool IsEmpty() const { return value == 0; }
    bool operator==(ObjectGuid other) const { return value == other.value; }
};
struct Player;
struct Group {
    uint32 leader = 0, changes = 0;
    bool bg = false, raid = false;
    std::set<uint32> members, assistants;
    bool isBGGroup() const { return bg; }
    bool isRaidGroup() const { return raid; }
    bool IsMember(ObjectGuid guid) const { return members.count(guid.value); }
    bool IsLeader(ObjectGuid guid) const { return leader == guid.value; }
    bool IsAssistant(ObjectGuid guid) const { return assistants.count(guid.value); }
    ObjectGuid GetLeaderGuid() const { return leader; }
    uint32 GetMembersCount() const { return uint32(members.size()); }
    uint32 GetId() const { return 7; }
    bool HandleHardcoreInteraction(Player*) const { return true; }
    void RemoveInvite(Player*) {}
    bool Create(ObjectGuid guid, char const*) { leader = guid.value; members.insert(guid.value); return true; }
    bool AddMember(ObjectGuid guid, char const*);
    void ChangeLeader(ObjectGuid guid) {
        if (!IsMember(guid)) return;
        leader = guid.value; ++changes;
    }
};
struct Player {
    uint32 id; bool bot = false;
    Group* group = nullptr; Group* original = nullptr;
    bool world = true, teleport = false;
    enum class HardcoreInteractionResult { Allowed };
    ObjectGuid GetObjectGuid() const { return id; }
    Group* GetGroup() const { return group; }
    Group* GetOriginalGroup() const { return original; }
    Group* GetGroupInvite() const { return nullptr; }
    bool IsInWorld() const { return world; }
    bool IsBeingTeleported() const { return teleport; }
    char const* GetName() const { return "fixture"; }
    bool IsInGroup(Player* other, bool) const { return group && group == other->group; }
    HardcoreInteractionResult HandleHardcoreInteraction(Player*, bool) const {
        return HardcoreInteractionResult::Allowed;
    }
    void RemoveFromGroup() { if (group) group->members.erase(id); group = nullptr; }
};
struct ObjectMgr {
    std::map<uint32, Player*> players;
    Player* GetPlayer(ObjectGuid guid) const {
        auto it = players.find(guid.value); return it == players.end() ? nullptr : it->second;
    }
    void AddGroup(Group*) {}
} sObjectMgr;
bool Group::AddMember(ObjectGuid guid, char const*) {
    members.insert(guid.value);
    if (Player* player = sObjectMgr.GetPlayer(guid)) player->group = this;
    return true;
}
bool GetBotAI(Player* player) { return player && player->bot; }
std::map<uint32, int> gContracts, gOwnedCompanions;
constexpr uint32 MAX_GROUP_SIZE = 5, MAX_RAID_SIZE = 40;
uint32 warnings = 0;
void NotifyOwnerCannotLeadGroup(Player*, Group*, Player*) { ++warnings; }
struct Logger { template<class... Args> void outError(Args...) {} } sLog;
void check(bool ok, char const* message) { if (!ok) throw std::runtime_error(message); }
'''

CHECKS = r'''
int main() {
    try {
        Player owner{1}, bot{2, true}, human{3};
        sObjectMgr.players = {{1, &owner}, {2, &bot}, {3, &human}};
        gContracts[2] = 1;
        Group group;
        group.members = {1, 2, 3}; group.leader = 2;
        owner.group = bot.group = human.group = &group;
        check(EnsureCompanionInGroup(&owner, &bot), "Existing member rejected");
        check(group.leader == 2 && group.changes == 0, "Maintenance changed the chosen leader");
        EnsureCompanionInGroup(&owner, &bot);
        check(group.changes == 0, "Maintenance changed leadership repeatedly");

        group.leader = 2; group.raid = true; group.assistants.insert(1);
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 2, "Raid assistant stole leadership");

        sObjectMgr.players.erase(2); group.leader = 2;
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 2, "Offline temporary leader was replaced");
        gContracts.clear(); gOwnedCompanions[2] = 1; group.leader = 2;
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 2, "Offline permanent leader was replaced");
        sObjectMgr.players[2] = &bot;

        group.leader = 3;
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 3, "Human leader was replaced");
        bot.group = nullptr; group.members.erase(2);
        check(EnsureCompanionInGroup(&owner, &bot), "Raid assistant could not add companion");
        check(group.leader == 3 && bot.group == &group, "Joining changed human leadership");
        bot.group = nullptr; group.members.erase(2); group.assistants.clear();
        check(!EnsureCompanionInGroup(&owner, &bot) && warnings == 1,
              "Nonleader recruited into another human's group");

        group.members.insert(2); bot.group = &group; group.leader = 1;
        group.ChangeLeader(2);
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 2, "Explicit leader selection was overwritten");
        group.ChangeLeader(3);
        check(group.leader == 3, "Human transfer failed");

        group.bg = true; group.leader = 2;
        EnsureCompanionInGroup(&owner, &bot);
        check(group.leader == 2, "Battleground leadership was changed");
        group.bg = false; group.members.erase(1);
        bot.group = nullptr; group.members.erase(2); group.leader = 1;
        owner.world = false; owner.teleport = true;
        check(!EnsureCompanionInGroup(&owner, &bot) && !bot.group && warnings == 1,
              "Owner zoning changed membership or reported a leader error");
        owner.world = true; owner.teleport = false; bot.teleport = true;
        check(!EnsureCompanionInGroup(&owner, &bot) && !bot.group && warnings == 1,
              "Bot zoning changed membership or reported a leader error");
        bot.teleport = false;
        check(!EnsureCompanionInGroup(nullptr, &bot), "Missing owner accepted");
        check(!EnsureCompanionInGroup(&owner, nullptr), "Missing bot accepted");
        std::cout << "PASS: existing groups, raids, offline leaders, human authority, explicit leadership\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


def run():
    module = Path(__file__).resolve().parents[1]
    cpp = (module / "src/CompanionRecruiter.cpp").read_text(encoding="utf-8")
    source = PREFIX
    for signature in ("bool EnsureCompanionInGroup(",):
        source += extract(cpp, signature).replace(" override", "")
    source += CHECKS
    with tempfile.TemporaryDirectory(prefix="companion-group-test-") as directory:
        work = Path(directory)
        (work / "checks.cpp").write_text(source, encoding="utf-8")
        if os.name == "nt":
            vswhere = Path(os.environ["ProgramFiles(x86)"]) / "Microsoft Visual Studio/Installer/vswhere.exe"
            install = subprocess.check_output([str(vswhere), "-latest", "-products", "*", "-requires",
                "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath"], text=True).strip()
            if not install:
                raise RuntimeError("No MSVC compiler found")
            vcvars = Path(install) / "VC/Auxiliary/Build/vcvars64.bat"
            script = work / "build.cmd"
            script.write_text(f'@echo off\ncall "{vcvars}" >nul\nif errorlevel 1 exit /b 1\n'
                              'cl /nologo /EHsc /std:c++17 /W3 checks.cpp /Fe:checks.exe\n')
            command = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/c", str(script)]
        else:
            command = [shutil.which("c++") or "c++", "-std=c++17", "checks.cpp", "-o", "checks.exe"]
        subprocess.run(command, cwd=work, check=True)
        subprocess.run([str(work / "checks.exe")], cwd=work, check=True)


if __name__ == "__main__":
    run()
