"""Compile real PlayerBots resurrection code with a controlled clock and party."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from test_gear_generation import extract


PREFIX = r'''
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>
using uint32 = uint32_t;
using time_t = int64_t;
time_t mockNow = 1000;
#define time(...) mockNow
constexpr uint32 PLAYER_FLAGS = 0, PLAYER_FLAGS_GHOST = 1, PLAYER_SELF_RES_SPELL = 2;
constexpr uint32 TELE_TO_FORCE_MAP_CHANGE = 16;
enum class BotState { BOT_STATE_DEAD, BOT_STATE_COMBAT, BOT_STATE_NON_COMBAT };
struct Corpse {
    uint32 map = 33, instance = 7;
    uint32 GetMapId() const { return map; }
    uint32 GetInstanceId() const { return instance; }
};
struct PlayerbotAI;
struct Group;
struct Player {
    bool alive = true, world = true, combat = false, teleport = false, ghost = false;
    bool bg = false, hardcore = false;
    uint32 map = 33, instance = 7, selfRez = 0, bones = 0, teleports = 0, options = 0;
    Group* group = nullptr; PlayerbotAI* ai = nullptr; Corpse* corpse = nullptr;
    std::set<uint32> spells;
    bool IsAlive() const { return alive; }
    bool IsInWorld() const { return world; }
    bool IsInCombat() const { return combat; }
    bool IsBeingTeleported() const { return teleport; }
    bool InBattleGround() const { return bg; }
    uint32 GetMapId() const { return map; }
    uint32 GetInstanceId() const { return instance; }
    Corpse* GetCorpse() const { return corpse; }
    Group* GetGroup() const { return group; }
    bool IsInGroup(Player* other) const { return group && group == other->group; }
    bool HasSpell(uint32 spell) const { return spells.count(spell); }
    bool HasFlag(uint32, uint32) const { return ghost; }
    uint32 GetUInt32Value(uint32) const { return selfRez; }
    float GetPositionX() const { return 1; }
    float GetPositionY() const { return 2; }
    float GetPositionZ() const { return 3; }
    float GetOrientation() const { return 4; }
    char const* GetName() const { return "fixture"; }
    void ResurrectPlayer(float) { if (!hardcore) { alive = true; ghost = false; } }
    void SpawnCorpseBones() { ++bones; }
    bool TeleportTo(uint32, float, float, float, float, uint32 flags) {
        ++teleports; options = flags; return true;
    }
};
struct GroupReference {
    Player* player; GroupReference* following = nullptr;
    Player* getSource() const { return player; }
    GroupReference* next() const { return following; }
};
struct Group {
    GroupReference* first;
    GroupReference* GetFirstMember() const { return first; }
};
struct PlayerbotAI {
    Player* master; Player* bot; BotState state = BotState::BOT_STATE_DEAD;
    uint32 resets = 0; bool staleMovement = true;
    bool HasRealPlayerMaster() const { return master != nullptr; }
    Player* GetMaster() const { return master; }
    bool IsStateActive(BotState value) const { return state == value; }
    bool HasStrategy(char const*, BotState) const { return true; }
    void StopMoving() {}
    void ChangeEngine(BotState value) { state = value; }
    void Reset(bool full) { if (full) { ++resets; staleMovement = false; } }
    void OnResurrected();
    void TellPlayerNoFacing(Player*, char const*) {}
};
PlayerbotAI* GetBotAI(Player* player) { return player->ai; }
struct Config { bool autoReviveWithoutRezzer = true, windrunnerCompanionMode = true; uint32 autoReviveDelay = 5; }
    sPlayerbotAIConfig;
struct Facade {
    bool UnitIsDead(Player* player) const { return !player->alive; }
    bool IsAlive(Player* player) const { return player->alive; }
} sServerFacade;
struct Logger { template<class... Args> void outDetail(Args...) {} } sLog;
struct Event {};
struct AutoReviveAction {
    PlayerbotAI* ai; Player* bot; time_t quietSince = 0;
    Player* GetMaster() const { return ai->master; }
    static bool CanResurrectOthers(Player*);
    static bool WillAutoRevive(Player*);
    bool isUseful();
    bool Execute(Event&);
};
void check(bool ok, char const* message) { if (!ok) throw std::runtime_error(message); }
'''

CHECKS = r'''
int main() {
    try {
        Player owner, bot, other;
        bot.alive = false;
        PlayerbotAI ai{&owner, &bot}; bot.ai = &ai;
        GroupReference r3{&other}, r2{&bot, &r3}, r1{&owner, &r2}; Group group{&r1};
        owner.group = bot.group = other.group = &group;
        AutoReviveAction action{&ai, &bot}; Event event;
        check(!action.isUseful(), "Timer must begin before resurrection");
        mockNow = 1005; check(!action.isUseful(), "Old five-second setting bypassed minimum");
        mockNow = 1029; check(!action.isUseful(), "Revived before thirty seconds");
        mockNow = 1030; check(action.isUseful(), "Thirty-second boundary excluded");
        other.map = 0; other.instance = 0; other.alive = false; other.combat = true;
        check(!action.Execute(event) && !bot.alive, "Queued revive ignored distant/dead member in combat");
        other.combat = false; mockNow = 1040; check(!action.isUseful(), "Quiet period was not restarted");
        mockNow = 1069; check(!action.isUseful(), "Re-entering combat did not reset timer");
        mockNow = 1070; check(action.Execute(event), "Revive failed after full quiet period");
        check(bot.alive && bot.bones == 1 && ai.state == BotState::BOT_STATE_NON_COMBAT &&
              ai.resets == 1 && !ai.staleMovement, "Resurrection left stale dead AI/movement state");
        check(!action.Execute(event) && bot.bones == 1, "Living bot resurrected twice");

        Corpse corpse; bot.alive = false; bot.ghost = true; bot.corpse = &corpse;
        bot.map = 0; bot.instance = 2; ai.state = BotState::BOT_STATE_DEAD;
        mockNow = 2000; check(!action.isUseful(), "Released ghost skipped delay");
        mockNow = 2030; check(action.Execute(event), "Outdoor ghost could not recover to dungeon owner");
        check(bot.teleports == 1, "Outdoor ghost did not rejoin owner");
        bot.alive = false; bot.ghost = true; bot.map = 33; bot.instance = 8;
        ai.state = BotState::BOT_STATE_DEAD;
        mockNow = 3000; action.isUseful(); mockNow = 3030;
        check(action.Execute(event) && bot.options == TELE_TO_FORCE_MAP_CHANGE,
              "Same-map recovery stayed in wrong instance");

        bot.alive = false; bot.ghost = true; corpse.instance = 9;
        check(!AutoReviveAction::WillAutoRevive(&bot), "Unrelated dungeon corpse admitted");
        corpse.instance = 7; bot.map = 33; bot.instance = 7; bot.ghost = false;
        other.alive = true; other.map = 33; other.instance = 8; other.spells.insert(2006);
        check(AutoReviveAction::WillAutoRevive(&bot), "Rezzer in another instance blocked recovery");
        other.instance = 7;
        check(!AutoReviveAction::WillAutoRevive(&bot), "Available rezzer was ignored");
        other.spells.clear(); bot.selfRez = 1;
        check(!action.isUseful(), "Soulstone priority was lost");
        bot.selfRez = 0; bot.hardcore = true;
        mockNow = 4000; action.isUseful(); mockNow = 4030;
        uint32 bones = bot.bones;
        check(!action.Execute(event) && bot.bones == bones, "Hardcore corpse was destroyed after refused resurrection");
        std::cout << "PASS: thirty-second quiet period, all group members, execution recheck, AI reset, ghost/instance recovery\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


def run(server):
    bots = server / "src/modules/PlayerBots/playerbot"
    cpp = (bots / "strategy/actions/AutoReviveAction.cpp").read_text(encoding="utf-8")
    ai = (bots / "PlayerbotAI.cpp").read_text(encoding="utf-8")
    source = PREFIX + extract(cpp, "const uint32 REZ_SPELLS[] =", ";")
    source += extract(ai, "void PlayerbotAI::OnResurrected()")
    for signature in ("bool AutoReviveAction::CanResurrectOthers(", "bool AutoReviveAction::WillAutoRevive(",
                      "bool AutoReviveAction::isUseful()", "bool AutoReviveAction::Execute("):
        source += extract(cpp, signature)
    source += CHECKS
    compile_and_run(source)


def compile_and_run(source):
    with tempfile.TemporaryDirectory(prefix="companion-revive-test-") as directory:
        work = Path(directory)
        (work / "checks.cpp").write_text(source, encoding="utf-8")
        if os.name == "nt":
            vswhere = Path(os.environ["ProgramFiles(x86)"]) / "Microsoft Visual Studio/Installer/vswhere.exe"
            install = subprocess.check_output([str(vswhere), "-latest", "-products", "*", "-requires",
                "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath"], text=True).strip()
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
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--server", type=Path, default=Path(__file__).resolve().parents[3])
    run(parser.parse_args().server)
