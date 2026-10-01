"""Compile the real recruiter menu builders and check their Vanilla wire format.

Optionally run the addon against the generated C++ menus with --lua PATH.
No live server, database, client files, or MPQs are modified.
"""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile

from test_gear_generation import extract


PREFIX = r'''
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>
using uint8 = uint8_t; using uint32 = uint32_t;
enum { CLASS_WARRIOR=1, CLASS_PALADIN, CLASS_HUNTER, CLASS_ROGUE, CLASS_PRIEST,
       CLASS_SHAMAN=7, CLASS_MAGE, CLASS_WARLOCK, CLASS_DRUID=11 };
enum { GOSSIP_ACTION_INFO_DEF=1000, GOSSIP_SENDER_MAIN=1, GOSSIP_ICON_CHAT=0,
       GOSSIP_ICON_TALK=1, GOSSIP_ICON_MONEY_BAG=6, HIGHGUID_PLAYER=0,
       GENDER_FEMALE=1, MAX_RACES=11 };
using BotRoles = int;
struct Option { uint8 icon; std::string text; uint32 action; };
struct Menu {
    std::vector<Option> items;
    void AddMenuItem(uint8 icon, char const* text, uint32, uint32 action) {
        items.push_back({icon, text, action});
    }
    uint32 MenuItemCount() const { return uint32(items.size()); }
};
struct Talk {
    Menu menu; bool sent=false, closed=false;
    Menu& GetGossipMenu() { return menu; }
    void ClearMenus() { menu.items.clear(); sent=false; closed=false; }
    void CloseGossip() { closed=true; }
    void SendGossipMenu(uint32, uint32) { sent=true; }
};
struct Player {
    Talk talk; Talk* PlayerTalkClass=&talk; bool horde=false;
    uint32 id=1; std::string name="Owner";
    uint32 GetGUIDLow() const { return id; }
    char const* GetName() const { return name.c_str(); }
    uint8 getClass() const { return CLASS_WARRIOR; }
    bool IsInGroup(Player*, bool) const { return false; }
};
struct Creature { uint32 GetObjectGuid() const { return 919001; } };
struct Logger { void outError(char const*) {} } sLog;
void SendMessage(Player*, char const*) {}
void EnsureRecruiterSpecPaths() {}
uint32 RecruiterSpecNo(uint8, uint8) { return 1; }
uint32 GetPermanentCompanionCost() { return 750000; }
std::string FormatMoney(uint32) { return "75g 0s 0c"; }
namespace AiFactory { BotRoles GetPlayerRoles(uint8, uint8) { return 4; } }
namespace RandomPlayerbotFactory { bool isAvailableRole(uint8, BotRoles) { return true; } }
bool IsClassAvailableToOwner(Player* p, uint8 cls) {
    return cls != (p->horde ? CLASS_PALADIN : CLASS_SHAMAN);
}
bool IsRaceInOwnerFaction(Player* p, uint8 race) {
    bool horde = race==2 || race==5 || race==6 || race==8 || race==9;
    return p->horde == horde;
}
bool IsRaceAvailableToOwner(Player*, uint8 cls, uint8 race) {
    return cls != CLASS_DRUID || race==4 || race==6;
}
namespace ChatHelper {
    std::string formatRace(uint8 race) {
        static char const* names[]={"", "Human", "Orc", "Dwarf", "Night Elf", "Undead",
                                   "Tauren", "Gnome", "Troll", "Goblin", "High Elf"};
        return names[race];
    }
    std::string formatRole(BotRoles) { return "dps"; }
}
struct OwnedCompanion {
    uint32 botGuid=0; std::string name;
    uint8 cls=CLASS_WARRIOR, specTab=0, race=1, gender=0;
    BotRoles role=4; bool invited=false;
};
std::vector<OwnedCompanion> owned;
std::vector<OwnedCompanion> GetOwnedCompanions(uint32) { return owned; }
std::string RecruiterSpecDisplayName(uint8, uint8, BotRoles) { return "Arms"; }
struct Bots { Player* GetPlayerBot(uint32) { return nullptr; } } sRandomPlayerbotMgr;
struct ObjectGuid { uint32 id; ObjectGuid(int, uint32 value): id(value) {} };
std::map<uint32, Player> members;
namespace ObjectAccessor {
    Player* FindConnectedPlayer(ObjectGuid guid) { return &members.at(guid.id); }
}
'''

SUPPORT = r'''
std::map<uint32, uint32> gManagePages;
std::map<uint32, FillRoleSession> gFillRoleSessions;
std::map<uint32, PermanentRecruitmentSession> gPermanentRecruitmentSessions;
void SyncFillRoleSession(Player*, FillRoleSession&) {}
PlayerRole RoleForPlayer(Player*) { return PlayerRole::Damage; }
char const* RoleName(PlayerRole) { return "Damage"; }
std::string FillCost(Player*, uint32) { return "4g 0s 0c"; }
void SendMainMenu(Player*, Creature*) { throw std::runtime_error("Unexpected main menu"); }
'''

CHECKS = r'''
void check(bool result, char const* reason) { if (!result) throw std::runtime_error(reason); }
void emit(Player& p, std::string const& name) {
    check(p.talk.sent && !p.talk.closed, "Valid menu was rejected");
    check(p.talk.menu.items.size() <= 15, "Menu exceeds the native packet reader's limit");
    std::cout << "MENU\t" << name;
    for (auto const& item : p.talk.menu.items) std::cout << '\t' << item.text;
    std::cout << '\n';
}
int main() {
    try {
        Player p; Creature npc;
        for (bool horde : {false, true}) {
            p.horde = horde;
            std::string faction = horde ? "Horde" : "Alliance";
            SendPermanentClassMenu(&p, &npc);
            emit(p, faction + "_classes");
            check(p.talk.menu.items[0].action == ACTION_PERMANENT_SELECT_CLASS_BASE + CLASS_WARRIOR,
                  "Default class action changed");
            for (uint8 cls : {1,2,3,4,5,7,8,9,11}) {
                if (!IsClassAvailableToOwner(&p, cls)) continue;
                SendPermanentSpecMenu(&p, &npc, cls);
                emit(p, faction + "_" + std::to_string(cls));
                auto& session = gPermanentRecruitmentSessions[p.id];
                session.specTab=1; session.variant=0; session.race=horde ? 6 : 4;
                SendPermanentSpecMenu(&p, &npc, cls);
                check(session.specTab==1 && session.race==(horde ? 6 : 4), "Selection lost on refresh");
                check(p.talk.menu.items[p.talk.menu.items.size()-3].action==ACTION_PERMANENT_RECRUIT,
                      "Purchase action changed");
                SendClassSpecMenu(&p, &npc, cls);
                emit(p, faction + "_temporary_" + std::to_string(cls));
            }
            SendClassMenu(&p, &npc);
            emit(p, faction + "_temporary_classes");
        }
        for (uint32 count=0; count<=40; ++count) {
            owned.clear();
            for (uint32 i=0; i<count; ++i) {
                OwnedCompanion bot; bot.botGuid=i; bot.name="Bot"+std::to_string(i); owned.push_back(bot);
            }
            for (uint32 page=0; page<std::max(1u, (count+MANAGE_PAGE_SIZE-1)/MANAGE_PAGE_SIZE); ++page) {
                gManagePages[p.id]=page;
                SendManageMenu(&p, &npc);
                emit(p, "roster_"+std::to_string(count)+"_"+std::to_string(page));
                if (count) check(p.talk.menu.items[0].action==ACTION_OWNED_TOGGLE_BASE+page*MANAGE_PAGE_SIZE,
                                 "Roster page action index changed");
            }
            auto& fill=gFillRoleSessions[p.id]; fill.memberGuids.clear();
            for (uint32 i=0; i<count; ++i) {
                members[i].name="Player"+std::to_string(i); fill.memberGuids.push_back(i);
            }
            for (uint32 page=0; page<std::max(1u, (count+FILL_ASSIGNMENT_PAGE_SIZE-1)/FILL_ASSIGNMENT_PAGE_SIZE); ++page) {
                fill.page=page;
                SendFillAssignmentsMenu(&p, &npc);
                emit(p, "fill_"+std::to_string(count)+"_"+std::to_string(page));
                if (count) check(p.talk.menu.items[0].action==ACTION_FILL_MEMBER_BASE+page*FILL_ASSIGNMENT_PAGE_SIZE,
                                 "Fill page action index changed");
            }
        }
        p.talk.ClearMenus();
        for (int i=0; i<16; ++i) AddMenuItem(&p, 0, "overflow", ACTION_RETURN_MAIN);
        SendMenu(&p, &npc);
        check(p.talk.closed && !p.talk.sent, "Oversized packet was sent instead of rejected");
    } catch (std::exception const& e) { std::cerr << e.what() << '\n'; return 1; }
}
'''


def packet(options):
    data = struct.pack("<QII", 919001, 919100, len(options))
    for i, text in enumerate(options):
        data += struct.pack("<IBB", i, 6, 0) + text.encode() + b"\0"
    return data + struct.pack("<I", 0)


def read_native(data):
    count = struct.unpack_from("<I", data, 12)[0]
    offset, options = 16, []
    for _ in range(min(count, 15)):
        offset += 6
        end = data.index(b"\0", offset)
        options.append(data[offset:end].decode())
        offset = end + 1
    quest_count = struct.unpack_from("<I", data, offset)[0]
    return options, quest_count, offset + 4


def run(lua=None):
    module = Path(__file__).resolve().parents[1]
    cpp = (module / "src/CompanionRecruiter.cpp").read_text(encoding="utf-8")
    source = PREFIX + "\n".join(re.findall(r"^constexpr uint(?:8|32) (?:RECRUITER_GOSSIP_TEXT|INVALID_SPEC_TAB|RECRUITER_MAX_OPTIONS|MANAGE_PAGE_SIZE|FILL_ASSIGNMENT_PAGE_SIZE) = .*;", cpp, re.M))
    for signature in ("struct RecruiterSpec", "constexpr std::array<RecruiterSpec, 27> RECRUITER_SPECS =",
                      "enum GossipAction", "enum class PlayerRole", "struct FillRoleSession", "struct PermanentRecruitmentSession"):
        source += extract(cpp, signature, ";")
    source += SUPPORT
    for signature in ("uint32 EncodeRecruiterSpec(", "char const* RecruiterClassName(uint8 cls)\n{",
                      "void AddMenuItem(", "void SendMenu(", "void AddSpecOptions(", "void SendClassMenu(",
                      "void SendClassSpecMenu(", "void AddPermanentClassOptions(", "void AddPermanentRaceOptions(",
                      "void SendPermanentClassMenu(", "void SendPermanentSpecMenu(", "void SendManageMenu(",
                      "void SendFillAssignmentsMenu("):
        source += extract(cpp, signature)
    source += CHECKS
    with tempfile.TemporaryDirectory(prefix="companion-menu-test-") as directory:
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
        output = subprocess.check_output([str(work / "checks.exe")], cwd=work, text=True)
        menus = {parts[1]: parts[2:] for parts in (line.split("\t") for line in output.splitlines())}
        for name, options in menus.items():
            wire = packet(options)
            decoded, quests, offset = read_native(wire)
            assert decoded == options and quests == 0 and offset == len(wire), name
        # Reproduce the exact three damaged quest labels from the user's screenshot.
        legacy = menus["Horde_classes"][:-2] + menus["Horde_1"][:-2] + ["Back to recruiter"]
        _, quests, offset = read_native(packet(legacy))
        assert quests == 15, "Legacy overflow fixture no longer reproduces the client boundary"
        wire = packet(legacy)
        damaged = []
        for _ in range(3):
            offset += 12  # native quest id, icon, level
            end = wire.index(b"\0", offset)
            damaged.append(wire[offset:end].decode())
            offset = end + 1
        assert damaged == ["in (75g 0s 0c)", "t permanent companion", "o recruiter"], damaged
        print(f"PASS: {len(menus)} real C++ menus, Vanilla packet decoding, action indices, overflow guard, exact screenshot reproduction")
        if lua:
            fixtures = work / "menus.lua"
            fixtures.write_text("return {\n" + "\n".join(
                f"[{json.dumps(name)}] = {{{', '.join(json.dumps(s) for s in options)}}},"
                for name, options in menus.items()) + "\n}\n", encoding="utf-8")
            subprocess.run([lua, str(module / "tests/test_addon.lua"),
                str(module / "addon/CompanionRecruiter/CompanionRecruiter.lua"), str(fixtures)], check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lua", help="Lua 5.2 executable to run the addon integration checks")
    run(parser.parse_args().lua)
