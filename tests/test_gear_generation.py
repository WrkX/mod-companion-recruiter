"""Run the real gear-selection functions with a small deterministic item cache.

Requires Python 3 and a C++17 compiler. On Windows, Visual Studio's compiler is
located automatically when it is not already on PATH. No live server/DB needed.
"""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def extract(source, signature, suffix=""):
    start = source.index(signature)
    depth = 0
    for end in range(source.index("{", start), len(source)):
        depth += (source[end] == "{") - (source[end] == "}")
        if not depth:
            return source[start:end + 1] + suffix + "\n"
    raise ValueError(signature)


PREFIX = r'''
#define MANGOSBOT_ZERO
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <tuple>
#include <unordered_set>
#include <vector>
using uint8 = uint8_t; using uint16 = uint16_t; using uint32 = uint32_t;
using uint64 = uint64_t; using int32 = int32_t;
enum { EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_HEAD = 0, EQUIPMENT_SLOT_NECK,
    EQUIPMENT_SLOT_SHOULDERS, EQUIPMENT_SLOT_BODY, EQUIPMENT_SLOT_CHEST,
    EQUIPMENT_SLOT_WAIST, EQUIPMENT_SLOT_LEGS, EQUIPMENT_SLOT_FEET,
    EQUIPMENT_SLOT_WRISTS, EQUIPMENT_SLOT_HANDS, EQUIPMENT_SLOT_FINGER1,
    EQUIPMENT_SLOT_FINGER2, EQUIPMENT_SLOT_TRINKET1, EQUIPMENT_SLOT_TRINKET2,
    EQUIPMENT_SLOT_BACK, EQUIPMENT_SLOT_MAINHAND, EQUIPMENT_SLOT_OFFHAND,
    EQUIPMENT_SLOT_RANGED, EQUIPMENT_SLOT_TABARD, EQUIPMENT_SLOT_END };
enum { ITEM_QUALITY_POOR, ITEM_QUALITY_NORMAL, ITEM_QUALITY_UNCOMMON,
    ITEM_QUALITY_RARE, ITEM_QUALITY_EPIC, ITEM_QUALITY_LEGENDARY, ITEM_QUALITY_ARTIFACT };
enum { CLASS_WARRIOR = 1, CLASS_PALADIN, CLASS_HUNTER, CLASS_ROGUE,
    CLASS_PRIEST, CLASS_SHAMAN = 7, CLASS_MAGE, CLASS_WARLOCK, CLASS_DRUID = 11 };
enum { ITEM_CLASS_ARMOR, ITEM_CLASS_WEAPON, ITEM_SUBCLASS_ARMOR_SHIELD = 6 };
enum { INVTYPE_WEAPON, INVTYPE_2HWEAPON, INVTYPE_HOLDABLE };
constexpr uint32 ITEM_FLAG_UNIQUE_EQUIPPABLE = 1;
constexpr int INVENTORY_SLOT_BAG_0 = 0, EQUIP_ERR_OK = 0, ALLIANCE = 0, MAX_ITEM_PROTO_DAMAGES = 2;
struct DamageInfo { float DamageMin = 0, DamageMax = 0; };
struct ItemPrototype {
    uint32 ItemId = 0, ItemLevel = 0, RequiredLevel = 1, Quality = ITEM_QUALITY_UNCOMMON;
    uint32 Flags = 0, MaxCount = 0, Class = ITEM_CLASS_ARMOR, SubClass = 0;
    uint32 InventoryType = INVTYPE_WEAPON, Delay = 2500, RandomProperty = 0;
    uint8 slot = EQUIPMENT_SLOT_CHEST;
    uint32 weight = 10; bool usable = true, questConflict = false;
    char const* Name1 = "fixture";
    DamageInfo Damage[MAX_ITEM_PROTO_DAMAGES];
    bool IsWeapon() const { return Class == ITEM_CLASS_WEAPON; }
};
struct ObjectMgr {
    std::map<uint32, ItemPrototype> items;
    ItemPrototype const* GetItemPrototype(uint32 id) {
        auto it = items.find(id); return it == items.end() ? nullptr : &it->second;
    }
} sObjectMgr;
struct Item {
    uint32 id; uint8 slot;
    ItemPrototype const* GetProto() const { return sObjectMgr.GetItemPrototype(id); }
    uint8 GetBagSlot() const { return 0; }
    uint8 GetSlot() const { return slot; }
    void SetItemRandomProperties(uint32) {}
    void SetOwnerGuid(uint32) {}
};
struct PlayerbotAI;
struct Player {
    uint32 level = 60, spec = 1; uint8 cls = CLASS_HUNTER;
    std::map<uint8, Item> equipment; PlayerbotAI* ai = nullptr;
    uint32 GetLevel() const { return level; }
    uint8 getClass() const { return cls; }
    uint32 GetGUIDLow() const { return 1; }
    uint32 GetObjectGuid() const { return 1; }
    uint32 GetTeam() const { return ALLIANCE; }
    uint32 GetGuildId() const { return 0; }
    char const* GetName() const { return "test"; }
    Item* GetItemByPos(int, uint8 slot) const {
        auto it = equipment.find(slot);
        return it == equipment.end() ? nullptr : const_cast<Item*>(&it->second);
    }
    bool HasItemCount(uint32 id, uint32 count) const {
        uint32 total = 0; for (auto const& pair : equipment) if (pair.second.id == id) ++total;
        return total >= count;
    }
    void DestroyItem(int, uint8 slot, bool) { equipment.erase(slot); }
    Item* EquipNewItem(uint16 slot, uint32 id, bool) {
        equipment[uint8(slot)] = {id, uint8(slot)}; return &equipment[uint8(slot)];
    }
    void SetVisibleItemSlot(uint8, Item*) {}
    void InitStatsForLevel(bool) {}
    void UpdateAllStats() {}
};
struct DestroyItemsVisitor { explicit DestroyItemsVisitor(Player*) {} };
enum class IterateItemsMask { ITERATE_ITEMS_IN_EQUIP };
struct PlayerbotAI {
    Player* bot; Player* master = nullptr;
    explicit PlayerbotAI(Player* p) : bot(p) { p->ai = this; }
    bool HasRealPlayerMaster() const { return true; }
    bool IsInRealGuild() const { return false; }
    Player* GetMaster() const { return master; }
    uint32 GetEquipGearScore(Player*, bool, bool) { return 0; }
    void InventoryIterateItems(DestroyItemsVisitor*, IterateItemsMask) { bot->equipment.clear(); }
    void TellPlayerNoFacing(Player*, std::string const&) {}
};
PlayerbotAI* GetBotAI(Player* p) { return p->ai; }
struct Config {
    std::map<std::string, int32> values;
    int32 GetIntDefault(std::string const& key, int32 fallback) {
        auto it = values.find(key); return it == values.end() ? fallback : it->second;
    }
} sConfig;
struct BotConfig {
    bool randomGearProgression = true, randomGearTabards = false, randomGearTabardsReplaceGuild = false;
    float randomGearTabardsChance = 0, randomGearLoweringChance = 0;
    uint32 randomGearMaxDiff = 10, randomGearMaxLevel = 1000;
    std::vector<uint32> randomGearBlacklist;
} sPlayerbotAIConfig;
struct RandomItemMgr {
    using Key = std::tuple<uint32, uint8, uint8, uint8, uint32>;
    std::map<Key, std::vector<uint32>> cache;
    uint32 GetPlayerSpecId(Player* p) { return p->spec; }
    std::vector<uint32> Query(uint32 level, uint8 cls, uint8 spec, uint8 slot, uint32 quality) {
        auto it = cache.find({level, cls, spec, slot, quality});
        return it == cache.end() ? std::vector<uint32>{} : it->second;
    }
    uint32 GetStatWeight(uint32 id, uint32) { return sObjectMgr.items.at(id).weight; }
    uint32 GetBestRandomEnchantStatWeight(uint32, uint32) { return 0; }
    uint32 GetLiveStatWeight(Player* p, uint32 id, uint32) {
        auto const& item = sObjectMgr.items.at(id);
        return item.usable && item.RequiredLevel <= p->GetLevel() ? item.weight : 0;
    }
    uint32 GetMinLevelFromCache(uint32 id) { return sObjectMgr.items.at(id).RequiredLevel; }
    bool HasSameQuestRewards(Player*, uint32 id) { return sObjectMgr.items.at(id).questConflict; }
    uint32 CalculateBestRandomEnchantId(uint8, uint32, uint32) { return 0; }
    uint32 CalculateEnchantWeight(uint8, uint32, uint32) { return 0; }
} sRandomItemMgr;
struct RandomPlayerbotMgr {
    bool IsRandomBot(Player*) { return false; }
    uint32 GetValue(Player*, char const*) { return 0; }
    void SetValue(Player*, char const*, uint32) {}
    static int CanEquipUnseenItem(Player* bot, uint8 slot, uint16& dest, uint32 id) {
        auto const& p = sObjectMgr.items.at(id); dest = slot;
        bool matchingSlot = p.slot == slot || (slot == EQUIPMENT_SLOT_MAINHAND && p.IsWeapon());
        return matchingSlot && p.usable && p.RequiredLevel <= bot->level ? EQUIP_ERR_OK : 1;
    }
} sRandomPlayerbotMgr;
struct Log { template<class... T> void outDetail(char const*, T...) {} } sLog;
uint32 urand(uint32 low, uint32) { return low; }
'''

FACTORY = r'''
class PlayerbotFactory {
public:
    Player* bot; PlayerbotAI* ai; uint32 level, itemQuality = 0;
    explicit PlayerbotFactory(Player* p) : bot(p), ai(p->ai), level(p->level) {}
    void Shuffle(std::vector<uint32>&) {}
    void EnchantItem(Item*) {}
    std::vector<uint32> GetEquipmentCandidates(uint32 specId, uint8 slot, uint32 maxItemLevel,
        EquipmentItemLevelTarget const& gearTarget);
    void InitEquipment(bool incremental, bool syncWithMaster, bool progressive, bool partialUpgrade,
        EquipmentItemLevelTarget const& gearTarget);
};
'''

TESTS = r'''
void check(bool okay, char const* message) { if (!okay) throw std::runtime_error(message); }
void reset() {
    sObjectMgr.items.clear(); sRandomItemMgr.cache.clear(); sConfig.values.clear();
    sPlayerbotAIConfig = BotConfig{};
}
void item(uint32 id, uint32 ilvl, uint8 slot = EQUIPMENT_SLOT_CHEST, uint32 cacheLevel = 60,
          uint32 weight = 10, uint32 quality = ITEM_QUALITY_UNCOMMON) {
    ItemPrototype p; p.ItemId = id; p.ItemLevel = ilvl; p.slot = slot; p.weight = weight; p.Quality = quality;
    sObjectMgr.items[id] = p;
    sRandomItemMgr.cache[{cacheLevel, CLASS_HUNTER, 1, slot, quality}].push_back(id);
}
void generate(Player& bot, EquipmentItemLevelTarget target) {
    PlayerbotFactory factory(&bot); factory.InitEquipment(false, false, true, false, target);
}
uint32 equipped(Player const& bot, uint8 slot = EQUIPMENT_SLOT_CHEST) {
    Item* i = bot.GetItemByPos(0, slot); return i ? i->id : 0;
}
void testAverage() {
    reset(); Player owner;
    item(900001, 60, EQUIPMENT_SLOT_MAINHAND); item(900002, 80, EQUIPMENT_SLOT_CHEST);
    item(900003, 1000, EQUIPMENT_SLOT_BODY); item(900004, 1000, EQUIPMENT_SLOT_TABARD);
    owner.EquipNewItem(EQUIPMENT_SLOT_MAINHAND, 900001, true);
    owner.EquipNewItem(EQUIPMENT_SLOT_CHEST, 900002, true);
    owner.EquipNewItem(EQUIPMENT_SLOT_BODY, 900003, true);
    owner.EquipNewItem(EQUIPMENT_SLOT_TABARD, 900004, true);
    auto target = CompanionGearTarget(&owner, 60);
    check(target.average == 70 && target.range == 5 && target.fallbackRange == 15,
          "Equipped average included empty/cosmetic slots or used wrong defaults");
    // A two-hander has an empty off-hand; each actual equipped ring counts once.
    sObjectMgr.items.at(900001).InventoryType = INVTYPE_2HWEAPON;
    item(900005, 50, EQUIPMENT_SLOT_FINGER1); item(900006, 90, EQUIPMENT_SLOT_FINGER2);
    owner.EquipNewItem(EQUIPMENT_SLOT_FINGER1, 900005, true);
    owner.EquipNewItem(EQUIPMENT_SLOT_FINGER2, 900006, true);
    check(CompanionGearTarget(&owner, 60).average == 70, "Two-handed weapon or rings changed the average incorrectly");
    sObjectMgr.items.at(900002).ItemLevel = 82;
    check(CompanionGearTarget(&owner, 60).average == 71, "Average did not round to nearest item level");
    check(target.average == 70, "Captured target changed with later owner equipment");
    sConfig.values["CompanionRecruiter.GearItemLevelRange"] = 9;
    sConfig.values["CompanionRecruiter.GearItemLevelFallbackRange"] = 2;
    check(CompanionGearTarget(&owner, 60).fallbackRange == 9, "Fallback was narrower than preferred range");
    sConfig.values["CompanionRecruiter.GearItemLevelRange"] = -5;
    sConfig.values["CompanionRecruiter.GearItemLevelFallbackRange"] = 10000;
    target = CompanionGearTarget(&owner, 60);
    check(target.range == 0 && target.fallbackRange == 100, "Configuration bounds were not enforced");
    owner.equipment.clear();
    check(CompanionGearTarget(&owner, 60).average == 55 && CompanionGearTarget(nullptr, 60).average == 55,
          "Empty owner did not use the minimum target");
}
void testTargetLevelFormula() {
    reset(); Player owner; owner.level = 60;
    item(900001, 90); owner.EquipNewItem(EQUIPMENT_SLOT_CHEST, 900001, true);
    check(CompanionGearTarget(&owner, 10).average == 15, "Low-level target followed master gear or level");
    check(CompanionGearTarget(&owner, 54).average == 59, "Level 54 did not target bot level plus five");
    check(CompanionGearTarget(&owner, 55).average == 90, "Level 55 did not follow higher master gear");
    sObjectMgr.items.at(900001).ItemLevel = 40;
    check(CompanionGearTarget(&owner, 54).average == 59, "Low-level target followed lower master gear");
    check(CompanionGearTarget(&owner, 55).average == 55, "Level 55 did not enforce minimum target");
    check(CompanionGearTarget(&owner, 60).average == 55, "High-level target added five to bot level");
    sObjectMgr.items.at(900001).ItemLevel = 55;
    check(CompanionGearTarget(&owner, 55).average == 55, "Exact minimum master average changed target");
    check(CompanionGearTarget(nullptr, 54).average == 59, "Low-level target required master gear");
}
void testPreferredAndFallback() {
    reset(); Player bot; PlayerbotAI ai(&bot); EquipmentItemLevelTarget target{50, 5, 15};
    item(900001, 50, EQUIPMENT_SLOT_CHEST, 60, 1000); // Closest, but not usable.
    sObjectMgr.items.at(900001).usable = false;
    item(900002, 53, EQUIPMENT_SLOT_CHEST, 60, 100);
    item(900003, 47, EQUIPMENT_SLOT_CHEST, 60, 200); // Same distance, better stats.
    item(900004, 60, EQUIPMENT_SLOT_CHEST, 60, 10000); // Better stats cannot outrank primary band.
    item(900005, 70, EQUIPMENT_SLOT_CHEST, 60, 100000); // Above fallback cap.
    generate(bot, target);
    check(equipped(bot) == 900003, "Closest usable primary item/stat tie-break failed");
    sPlayerbotAIConfig.randomGearBlacklist.push_back(900003);
    sObjectMgr.items.at(900002).questConflict = true;
    generate(bot, target);
    check(equipped(bot) == 900004, "Rejected primary items prevented the wider fallback");
    sObjectMgr.items.at(900004).RequiredLevel = 61;
    item(900006, 25, EQUIPMENT_SLOT_CHEST, 10, 100); // Older than the normal required-level window.
    generate(bot, target);
    check(equipped(bot) == 900006, "No safe older fallback after both ranges failed");
    sObjectMgr.items.at(900006).usable = false;
    generate(bot, target);
    check(!equipped(bot), "Fallback exceeded its cap or equipped an unusable item");
}
void testBoundariesAndCache() {
    reset(); Player bot; PlayerbotAI ai(&bot); EquipmentItemLevelTarget target{50, 5, 15};
    item(900001, 55); item(900002, 65); item(900003, 66);
    generate(bot, target); check(equipped(bot) == 900001, "Preferred upper boundary was excluded");
    sObjectMgr.items.at(900001).usable = false;
    generate(bot, target); check(equipped(bot) == 900002, "Fallback upper boundary was excluded");
    target.fallbackRange = 5; generate(bot, target);
    check(!equipped(bot), "Configurable fallback range was ignored");
    item(900004, 45); item(900005, 35);
    generate(bot, target); check(equipped(bot) == 900004, "Preferred lower boundary was excluded");
    sObjectMgr.items.at(900004).usable = false; target.fallbackRange = 15;
    sObjectMgr.items.at(900002).usable = false;
    generate(bot, target); check(equipped(bot) == 900005, "Fallback lower boundary was excluded");
    sPlayerbotAIConfig.randomGearMaxLevel = 34;
    generate(bot, target); check(!equipped(bot), "Global maximum item level was exceeded");
    reset(); item(900010, 20, EQUIPMENT_SLOT_CHEST, 10);
    sRandomItemMgr.cache[{20, CLASS_HUNTER, 1, EQUIPMENT_SLOT_CHEST, ITEM_QUALITY_UNCOMMON}] = {900010, 900010};
    item(900011, 20, EQUIPMENT_SLOT_CHEST, 61); // Cache above the bot's level must not be searched.
    PlayerbotFactory factory(&bot);
    auto candidates = factory.GetEquipmentCandidates(1, EQUIPMENT_SLOT_CHEST, 25, {20, 5, 15});
    check(candidates == std::vector<uint32>{900010}, "Earlier level search, deduplication, or level ceiling failed");
    target = {20, 0, 0}; generate(bot, target);
    check(equipped(bot) == 900010, "Exact item-level target could not use older gear");
}
void testUniqueAndWeapons() {
    reset(); Player bot; PlayerbotAI ai(&bot);
    item(900001, 50, EQUIPMENT_SLOT_FINGER1); sObjectMgr.items.at(900001).Flags = ITEM_FLAG_UNIQUE_EQUIPPABLE;
    sRandomItemMgr.cache[{60, CLASS_HUNTER, 1, EQUIPMENT_SLOT_FINGER2, ITEM_QUALITY_UNCOMMON}] = {900001};
    item(900002, 60, EQUIPMENT_SLOT_FINGER2);
    generate(bot, {50,5,15});
    check(equipped(bot, EQUIPMENT_SLOT_FINGER1) == 900001 && equipped(bot, EQUIPMENT_SLOT_FINGER2) == 900002,
          "Unique-equipped rejection did not fall back for the second ring");
    reset(); item(900003, 50, EQUIPMENT_SLOT_OFFHAND, 10);
    sObjectMgr.items.at(900003).Class = ITEM_CLASS_WEAPON;
    generate(bot, {50,5,15});
    check(equipped(bot, EQUIPMENT_SLOT_MAINHAND) == 900003, "Main hand missed an older generic one-handed weapon");
}
void testLowLevelAndNoTarget() {
    reset(); Player bot; bot.level = 10; PlayerbotAI ai(&bot);
    item(900001, 15, EQUIPMENT_SLOT_CHEST, 10);
    generate(bot, {10,5,15});
    check(equipped(bot) == 900001, "Owner matching was incorrectly limited to high-level bots");
    generate(bot, {});
    check(equipped(bot) == 900001, "Empty owner target broke normal level-based generation");
    bot.level = 1; auto original = equipped(bot); generate(bot, {10,5,15});
    check(equipped(bot) == original, "Below-level-5 starting outfit was destroyed");
}
int main() {
    try {
        testTargetLevelFormula(); std::cout << "PASS: bot-level target formula and level 54/55 boundary\n";
        testAverage(); std::cout << "PASS: equipped averages, snapshots, and configuration bounds\n";
        testPreferredAndFallback(); std::cout << "PASS: primary, wider, and older fallback with all eligibility checks\n";
        testBoundariesAndCache(); std::cout << "PASS: inclusive ranges, global cap, older cache entries, and deduplication\n";
        testUniqueAndWeapons(); std::cout << "PASS: unique rings and generic one-handed weapons\n";
        testLowLevelAndNoTarget(); std::cout << "PASS: low-level matching and normal generation without a target\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


def run(cxx=None):
    module = Path(__file__).resolve().parents[1]
    server = module.parents[1]
    factory_dir = server / "src/modules/PlayerBots/playerbot"
    factory = (factory_dir / "PlayerbotFactory.cpp").read_text(encoding="utf-8")
    header = (factory_dir / "PlayerbotFactory.h").read_text(encoding="utf-8")
    recruiter = (module / "src/CompanionRecruiter.cpp").read_text(encoding="utf-8")
    source = PREFIX + extract(header, "struct EquipmentItemLevelTarget", ";") + FACTORY
    source += extract(recruiter, "EquipmentItemLevelTarget CompanionGearTarget(")
    source += extract(factory, "std::vector<uint32> PlayerbotFactory::GetEquipmentCandidates(")
    source += extract(factory, "void PlayerbotFactory::InitEquipment(") + TESTS
    with tempfile.TemporaryDirectory(prefix="companion-gear-test-") as directory:
        work = Path(directory)
        (work / "checks.cpp").write_text(source, encoding="utf-8")
        compiler = cxx or shutil.which("cl" if os.name == "nt" else "c++")
        if os.name == "nt" and not compiler:
            vswhere = Path(os.environ["ProgramFiles(x86)"]) / "Microsoft Visual Studio/Installer/vswhere.exe"
            installation = subprocess.check_output([
                str(vswhere), "-latest", "-products", "*", "-requires",
                "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath",
            ], text=True).strip()
            if not installation:
                raise RuntimeError("No C++ compiler found; specify --cxx or install MSVC.")
            vcvars = Path(installation) / "VC/Auxiliary/Build/vcvars64.bat"
            script = work / "build.cmd"
            script.write_text(f'@echo off\ncall "{vcvars}" >nul\nif errorlevel 1 exit /b 1\n'
                              'cl /nologo /EHsc /std:c++17 /W3 checks.cpp /Fe:checks.exe\n')
            command = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/c", str(script)]
        elif compiler and Path(compiler).stem.lower() == "cl":
            command = [compiler, "/nologo", "/EHsc", "/std:c++17", "/W3", "checks.cpp", "/Fe:checks.exe"]
        elif compiler:
            command = [compiler, "-std=c++17", "checks.cpp", "-o", "checks.exe" if os.name == "nt" else "checks"]
        else:
            raise RuntimeError("No C++ compiler found; specify --cxx.")
        subprocess.run(command, cwd=work, check=True)
        subprocess.run([str(work / ("checks.exe" if os.name == "nt" else "checks"))], cwd=work, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cxx", help="C++17 compiler executable")
    run(parser.parse_args().cxx)
