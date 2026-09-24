#include "ScriptObjects.h"
#include "ScriptedGossip.h"

#include "AiFactory.h"
#include "ChatHelper.h"
#include "Config/Config.h"
#include "Database/DBCStructure.h"
#include "GossipDef.h"
#include "Group/Group.h"
#include "Maps/Map.h"
#include "ObjectAccessor.h"
#include "Objects/Creature.h"
#include "Objects/Player.h"
#include "PlayerbotAI.h"
#include "PlayerbotAIConfig.h"
#include "PlayerbotFactory.h"
#include "PlayerbotMgr.h"
#include "RandomPlayerbotFactory.h"
#include "RandomPlayerbotMgr.h"
#include "World.h"
#include "strategy/Event.h"

#include <algorithm>
#include <array>
#include <cctype>
#include <chrono>
#include <climits>
#include <cstdint>
#include <list>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

namespace
{
using Clock = std::chrono::steady_clock;

constexpr uint32 RECRUITER_GOSSIP_TEXT = 919100;
constexpr uint8 INVALID_SPEC_TAB = 255;
constexpr uint32 MANAGE_PAGE_SIZE = 13;
constexpr uint32 FILL_ASSIGNMENT_PAGE_SIZE = 25;

struct RecruiterSpec
{
    uint8 cls;
    uint8 tab;
    char const* name;
};

constexpr std::array<RecruiterSpec, 27> RECRUITER_SPECS = {{
    {CLASS_WARRIOR, 0, "Arms"}, {CLASS_WARRIOR, 1, "Fury"}, {CLASS_WARRIOR, 2, "Protection"},
    {CLASS_PALADIN, 0, "Holy"}, {CLASS_PALADIN, 1, "Protection"}, {CLASS_PALADIN, 2, "Retribution"},
    {CLASS_HUNTER, 0, "Beast Mastery"}, {CLASS_HUNTER, 1, "Marksmanship"}, {CLASS_HUNTER, 2, "Survival"},
    {CLASS_ROGUE, 0, "Assassination"}, {CLASS_ROGUE, 1, "Combat"}, {CLASS_ROGUE, 2, "Subtlety"},
    {CLASS_PRIEST, 0, "Discipline"}, {CLASS_PRIEST, 1, "Holy"}, {CLASS_PRIEST, 2, "Shadow"},
    {CLASS_SHAMAN, 0, "Elemental"}, {CLASS_SHAMAN, 1, "Enhancement"}, {CLASS_SHAMAN, 2, "Restoration"},
    {CLASS_MAGE, 0, "Arcane"}, {CLASS_MAGE, 1, "Fire"}, {CLASS_MAGE, 2, "Frost"},
    {CLASS_WARLOCK, 0, "Affliction"}, {CLASS_WARLOCK, 1, "Demonology"}, {CLASS_WARLOCK, 2, "Destruction"},
    {CLASS_DRUID, 0, "Balance"}, {CLASS_DRUID, 1, "Feral"}, {CLASS_DRUID, 2, "Restoration"}
}};

enum GossipAction : uint32
{
    ACTION_RECRUIT_TANK = GOSSIP_ACTION_INFO_DEF + 1,
    ACTION_RECRUIT_HEALER,
    ACTION_RECRUIT_DPS,
    ACTION_FILL_PARTY_MENU,
    ACTION_FILL_PARTY_AS_TANK,
    ACTION_FILL_PARTY_AS_HEALER,
    ACTION_FILL_PARTY_AS_DPS,
    ACTION_FILL_RAID_MENU,
    ACTION_FILL_RAID_10,
    ACTION_FILL_RAID_20,
    ACTION_FILL_RAID_40,
    ACTION_FILL_RAID_10_AS_TANK,
    ACTION_FILL_RAID_10_AS_HEALER,
    ACTION_FILL_RAID_10_AS_DPS,
    ACTION_FILL_RAID_20_AS_TANK,
    ACTION_FILL_RAID_20_AS_HEALER,
    ACTION_FILL_RAID_20_AS_DPS,
    ACTION_FILL_RAID_40_AS_TANK,
    ACTION_FILL_RAID_40_AS_HEALER,
    ACTION_FILL_RAID_40_AS_DPS,
    ACTION_DISMISS_ALL,
    ACTION_RECRUIT_CLASS_MENU,
    ACTION_RETURN_MAIN,
    ACTION_SELECT_CLASS_BASE = GOSSIP_ACTION_INFO_DEF + 100,
    ACTION_SELECT_CLASS_SPEC_BASE = GOSSIP_ACTION_INFO_DEF + 200,
    ACTION_PERMANENT_MENU = GOSSIP_ACTION_INFO_DEF + 50,
    ACTION_MANAGE_MENU,
    ACTION_PERMANENT_SELECT_CLASS_BASE = GOSSIP_ACTION_INFO_DEF + 300,
    ACTION_PERMANENT_SELECT_SPEC_BASE = GOSSIP_ACTION_INFO_DEF + 400,
    ACTION_OWNED_TOGGLE_BASE = GOSSIP_ACTION_INFO_DEF + 500,
    ACTION_OWNED_REMOVE_BASE = GOSSIP_ACTION_INFO_DEF + 550,
    ACTION_MANAGE_PREVIOUS = GOSSIP_ACTION_INFO_DEF + 600,
    ACTION_MANAGE_NEXT = GOSSIP_ACTION_INFO_DEF + 601,
    ACTION_FILL_PREVIOUS = GOSSIP_ACTION_INFO_DEF + 602,
    ACTION_FILL_NEXT = GOSSIP_ACTION_INFO_DEF + 603,
    ACTION_FILL_MEMBER_BASE = GOSSIP_ACTION_INFO_DEF + 700,
    ACTION_FILL_SET_TANK = GOSSIP_ACTION_INFO_DEF + 800,
    ACTION_FILL_SET_HEALER,
    ACTION_FILL_SET_DAMAGE,
    ACTION_FILL_CONFIRM,
    ACTION_FILL_BACK_TO_ASSIGNMENTS,
    ACTION_FILL_CANCEL,
    ACTION_PERMANENT_SELECT_RACE_BASE = GOSSIP_ACTION_INFO_DEF + 900,
    ACTION_PERMANENT_RECRUIT = GOSSIP_ACTION_INFO_DEF + 920
};

enum class PlayerRole : uint8
{
    Auto,
    Tank,
    Healer,
    Damage
};

struct FillRoleSession
{
    uint32 targetSize = 5;
    uint32 page = 0;
    uint32 selectedMemberGuid = 0;
    std::vector<uint32> memberGuids;
    std::map<uint32, PlayerRole> roles;
};

struct PermanentRecruitmentSession
{
    uint8 cls = 0;
    uint8 specTab = INVALID_SPEC_TAB;
    uint8 variant = 0;
    uint8 race = 0;
};

struct RoleCounts
{
    uint32 tanks = 0;
    uint32 healers = 0;
    uint32 damage = 0;
};

struct CompanionContract
{
    uint32 botGuid = 0;
    uint32 ownerGuid = 0;
    uint32 paidCost = 0;
    uint8 cls = 0;
    uint8 specTab = INVALID_SPEC_TAB;
    BotRoles role = BOT_ROLE_DPS;
    Clock::time_point createdAt;
    Clock::time_point preparedAt{};
    Clock::time_point expiresAt;
    Clock::time_point graceExpiresAt{};
    bool prepared = false;
    bool initialized = false;
    bool joinedOnce = false;
    uint8 warningMask = 0;
};

struct OwnedCompanion
{
    uint32 botGuid = 0;
    uint32 ownerGuid = 0;
    uint32 purchaseCost = 0;
    uint8 cls = 0;
    uint8 specTab = INVALID_SPEC_TAB;
    BotRoles role = BOT_ROLE_DPS;
    uint8 level = 1;
    uint8 race = 0;
    uint8 gender = GENDER_NONE;
    std::string name;
    bool invited = false;
};

// Gossip, player, group, and world update hooks all execute on the world thread.
std::map<uint32, CompanionContract> gContracts;
std::map<uint32, OwnedCompanion> gOwnedCompanions;
uint32 gUpdateTimer = 0;
bool gRecruiterSpecPathsInitialized = false;
std::map<uint32, uint32> gManagePages;
std::map<uint32, FillRoleSession> gFillRoleSessions;
std::map<uint32, PermanentRecruitmentSession> gPermanentRecruitmentSessions;

uint32 CountOwnedCompanions(uint32 ownerGuid);
char const* RecruiterClassName(uint8 cls);
std::string RecruiterSpecName(uint8 cls, uint8 tab);
void SendMainMenu(Player* player, Creature* creature);

uint32 EncodeRecruiterSpec(uint8 cls, uint8 tab, uint8 variant = 0)
{
    return uint32(cls) * 6 + uint32(tab) * 2 + variant;
}

PlayerRole PlayerRoleForBotRole(BotRoles role)
{
    if (role & BOT_ROLE_TANK)
        return PlayerRole::Tank;
    if (role & BOT_ROLE_HEALER)
        return PlayerRole::Healer;
    return PlayerRole::Damage;
}

BotRoles BotRoleForRecruiterSpec(uint8 cls, uint8 tab, uint8 variant = 0)
{
    if (cls == CLASS_DRUID && tab == 1 && variant == 1)
        return BOT_ROLE_DPS;
    return AiFactory::GetPlayerRoles(cls, tab);
}

std::string RecruiterSpecDisplayName(uint8 cls, uint8 tab, BotRoles role)
{
    if (cls == CLASS_DRUID && tab == 1)
        return role == BOT_ROLE_TANK ? "Feral (Tank)" : "Feral (Damage)";
    return RecruiterSpecName(cls, tab);
}

RecruiterSpec const* FindRecruiterSpec(uint8 cls, uint8 tab)
{
    auto itr = std::find_if(RECRUITER_SPECS.begin(), RECRUITER_SPECS.end(), [cls, tab](RecruiterSpec const& spec)
    {
        return spec.cls == cls && spec.tab == tab;
    });
    return itr == RECRUITER_SPECS.end() ? nullptr : &*itr;
}

TalentPath* FindRecruiterTalentPath(uint8 cls, uint8 tab)
{
    if (cls >= MAX_CLASSES)
        return nullptr;

    for (TalentPath& path : sPlayerbotAIConfig.classSpecs[cls].talentPath)
        if (!path.talentSpec.empty() && path.talentSpec.back().highestTree() == tab)
            return &path;
    return nullptr;
}

TalentSpec BuildRecruiterTreeSpec(uint8 cls, uint8 tab, uint32 points)
{
    TalentSpec spec = sPlayerbotAIConfig.classSpecs[cls].baseSpec;
    spec.points = 0;
    for (TalentSpec::TalentListEntry& talent : spec.talents)
        talent.rank = 0;

    while (spec.points < points)
    {
        bool addedPoint = false;
        for (TalentSpec::TalentListEntry& talent : spec.talents)
        {
            if (talent.tabPage() != tab || talent.rank >= talent.maxRank)
                continue;
            if (int(talent.talentInfo->Row * 5) > spec.GetTalentPoints(tab))
                continue;

            if (talent.talentInfo->DependsOn)
            {
                auto prerequisite = std::find_if(spec.talents.begin(), spec.talents.end(), [&talent](TalentSpec::TalentListEntry const& entry)
                {
                    return entry.talentInfo->TalentID == talent.talentInfo->DependsOn;
                });
                if (prerequisite == spec.talents.end() || prerequisite->rank < int(talent.talentInfo->DependsOnRank))
                    continue;
            }

            ++talent.rank;
            ++spec.points;
            addedPoint = true;
            break;
        }

        if (!addedPoint)
            return TalentSpec();
    }

    return spec;
}

void EnsureRecruiterSpecPaths()
{
    if (gRecruiterSpecPathsInitialized)
        return;
    gRecruiterSpecPathsInitialized = true;

    uint32 const maxLevel = std::min<uint32>(sWorld.getConfig(CONFIG_UINT32_MAX_PLAYER_LEVEL), 100);
    for (RecruiterSpec const& definition : RECRUITER_SPECS)
    {
        if (FindRecruiterTalentPath(definition.cls, definition.tab))
            continue;

        ClassSpecs& classSpecs = sPlayerbotAIConfig.classSpecs[definition.cls];
        int pathId = 0;
        while (std::any_of(classSpecs.talentPath.begin(), classSpecs.talentPath.end(), [pathId](TalentPath const& path)
            { return path.id == pathId; }))
            ++pathId;

        std::string pathName = definition.name;
        std::transform(pathName.begin(), pathName.end(), pathName.begin(), [](unsigned char ch) { return char(std::tolower(ch)); });
        std::replace(pathName.begin(), pathName.end(), ' ', '_');
        TalentPath path(pathId, pathName, 0);
        bool complete = true;
        for (uint32 level = 10; level <= maxLevel; ++level)
        {
            uint32 const points = TalentSpec::LeveltoPoints(level);
            TalentSpec levelSpec = BuildRecruiterTreeSpec(definition.cls, definition.tab, points);
            std::ostringstream validation;
            if (levelSpec.points != points || levelSpec.highestTree() != definition.tab ||
                !levelSpec.CheckTalents(points, &validation))
            {
                complete = false;
                break;
            }
            path.talentSpec.push_back(levelSpec);
        }

        if (complete && !path.talentSpec.empty())
            classSpecs.talentPath.push_back(std::move(path));
        else
            sLog.outError("Companion recruiter could not build a talent path for class %u tree %u",
                uint32(definition.cls), uint32(definition.tab));
    }
}

uint32 RecruiterSpecNo(uint8 cls, uint8 tab)
{
    TalentPath* path = FindRecruiterTalentPath(cls, tab);
    return path ? uint32(path->id + 1) : 0;
}

std::string RecruiterSpecName(uint8 cls, uint8 tab)
{
    RecruiterSpec const* spec = FindRecruiterSpec(cls, tab);
    return spec ? spec->name : "Unknown";
}

bool IsEnabled()
{
    return sConfig.GetBoolDefault("CompanionRecruiter.Enabled", true);
}

uint32 MinimumLevel()
{
    return std::max<int32>(1, sConfig.GetIntDefault("CompanionRecruiter.MinimumLevel", 10));
}

uint32 LifetimeSeconds()
{
    return uint32(std::max<int32>(1, sConfig.GetIntDefault("CompanionRecruiter.LifetimeMinutes", 180))) * 60u;
}

uint32 GraceSeconds()
{
    return uint32(std::max<int32>(0, sConfig.GetIntDefault("CompanionRecruiter.ExpiryGraceMinutes", 10))) * 60u;
}

uint32 LoginTimeoutSeconds()
{
    return uint32(std::clamp<int32>(sConfig.GetIntDefault("CompanionRecruiter.LoginTimeoutSeconds", 120), 30, 600));
}

uint32 PreparationsPerUpdate()
{
    return uint32(std::clamp<int32>(sConfig.GetIntDefault("CompanionRecruiter.PreparationsPerUpdate", 2), 1, 5));
}

uint32 MaxCompanions()
{
    return uint32(std::clamp<int32>(sConfig.GetIntDefault("CompanionRecruiter.MaxCompanionsPerPlayer", 39), 1, 39));
}

float CostMultiplier()
{
    return std::max(0.0f, sConfig.GetFloatDefault("CompanionRecruiter.CostMultiplier", 1.0f));
}

uint32 GetPermanentCompanionCost()
{
    int32 const gold = std::clamp<int32>(sConfig.GetIntDefault("CompanionRecruiter.PermanentCostGold", 75),
        0, int32(MAX_MONEY_AMOUNT / GOLD));
    return uint32(gold) * GOLD;
}

uint32 MaxOwnedCompanions()
{
    return uint32(std::clamp<int32>(sConfig.GetIntDefault("CompanionRecruiter.MaxOwnedCompanions", 20), 1, 39));
}

uint32 GetCompanionCost(Player const* player)
{
    struct CostPoint
    {
        uint32 level;
        uint32 copper;
    };

    static constexpr std::array<CostPoint, 5> curve = {{
        {10, 1 * SILVER},
        {20, 4 * SILVER},
        {30, 8 * SILVER},
        {40, 30 * SILVER},
        {60, 1 * GOLD}
    }};

    if (!player)
        return 0;

    uint32 const level = std::max<uint32>(1, player->GetLevel());
    uint32 base = curve.front().copper;
    if (level >= curve.back().level)
        base = curve.back().copper;
    else
    {
        for (size_t i = 1; i < curve.size(); ++i)
        {
            if (level > curve[i].level)
                continue;

            CostPoint const& lower = curve[i - 1];
            CostPoint const& upper = curve[i];
            if (level <= lower.level)
                base = lower.copper;
            else
                base = lower.copper + (upper.copper - lower.copper) * (level - lower.level) /
                    (upper.level - lower.level);
            break;
        }
    }

    double const scaled = double(base) * CostMultiplier();
    if (!(scaled > 0.0))
        return 0;
    return uint32(std::min<double>(scaled, MAX_MONEY_AMOUNT));
}

std::string FormatMoney(uint32 copper)
{
    std::ostringstream out;
    out << copper / GOLD << "g " << (copper % GOLD) / SILVER << "s " << copper % SILVER << "c";
    return out.str();
}

void SendMessage(Player* player, std::string const& message)
{
    if (player && player->GetSession())
        ChatHandler(player->GetSession()).SendSysMessage(message.c_str());
}

void AddMenuItem(Player* player, uint8 icon, std::string const& text, uint32 action)
{
    player->PlayerTalkClass->GetGossipMenu().AddMenuItem(icon, text.c_str(), GOSSIP_SENDER_MAIN, action);
}

void SendMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->SendGossipMenu(RECRUITER_GOSSIP_TEXT, creature->GetObjectGuid());
}

uint32 CountOwnerContracts(uint32 ownerGuid)
{
    return uint32(std::count_if(gContracts.begin(), gContracts.end(), [ownerGuid](auto const& pair)
    {
        return pair.second.ownerGuid == ownerGuid;
    }));
}

void TrackCompanion(uint32 botGuid, uint32 ownerGuid, BotRoles role, uint8 cls, uint8 specTab, uint32 paidCost)
{
    CompanionContract contract;
    contract.botGuid = botGuid;
    contract.ownerGuid = ownerGuid;
    contract.paidCost = paidCost;
    contract.cls = cls;
    contract.specTab = specTab;
    contract.role = role;
    contract.createdAt = Clock::now();
    contract.expiresAt = contract.createdAt + std::chrono::seconds(LifetimeSeconds());

    gContracts[botGuid] = contract;
}

void RequestDismiss(uint32 botGuid)
{
    if (!botGuid)
        return;

    auto itr = gContracts.find(botGuid);
    if (itr != gContracts.end())
        itr->second.expiresAt = Clock::time_point::min();
}

void RequestDismissOwner(uint32 ownerGuid)
{
    if (!ownerGuid)
        return;

    for (auto& pair : gContracts)
        if (pair.second.ownerGuid == ownerGuid)
            pair.second.expiresAt = Clock::time_point::min();
}

void DeleteCompanion(uint32 botGuid)
{
    if (!botGuid)
        return;

    sRandomPlayerbotMgr.SetValue(botGuid, "create levelup", 0);
    sRandomPlayerbotMgr.SetValue(botGuid, "create gear", 0);
    sRandomPlayerbotMgr.SetValue(botGuid, "create group", 0);
    sRandomPlayerbotMgr.SetValue(botGuid, "companion_recruiter", 0);
    sRandomPlayerbotMgr.SetExternallyManaged(botGuid, false);
    sRandomPlayerbotMgr.DeleteBot(ObjectGuid(HIGHGUID_PLAYER, botGuid));
    CharacterDatabase.PExecute(
        "DELETE FROM ai_playerbot_random_bots WHERE owner = 0 AND bot = '%u'",
        botGuid);
}

bool ContractTargetsRecruitingGroup(CompanionContract const& contract, Player* recruiter)
{
    if (!recruiter)
        return false;

    Group* group = recruiter->GetGroup();
    if (!group)
        return contract.ownerGuid == recruiter->GetGUIDLow();

    Player* contractOwner = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, contract.ownerGuid));
    return contractOwner && contractOwner->GetGroup() == group;
}

bool IsPendingForRecruitingGroup(CompanionContract const& contract, Player* recruiter)
{
    if (!ContractTargetsRecruitingGroup(contract, recruiter))
        return false;

    Player* bot = sRandomPlayerbotMgr.GetPlayerBot(contract.botGuid);
    Group* group = recruiter->GetGroup();
    return !bot || bot->GetGroup() != group;
}

uint32 CountPendingGroupContracts(Player* recruiter)
{
    if (!recruiter)
        return 0;

    uint32 pending = 0;
    for (auto const& pair : gContracts)
        if (IsPendingForRecruitingGroup(pair.second, recruiter))
            ++pending;
    return pending;
}

bool OwnedCompanionTargetsRecruitingGroup(OwnedCompanion const& companion, Player* recruiter)
{
    if (!recruiter)
        return false;

    Group* group = recruiter->GetGroup();
    if (!group)
        return companion.ownerGuid == recruiter->GetGUIDLow();

    Player* companionOwner = ObjectAccessor::FindConnectedPlayer(
        ObjectGuid(HIGHGUID_PLAYER, companion.ownerGuid));
    return companionOwner && companionOwner->GetGroup() == group;
}

bool IsPendingOwnedInvite(OwnedCompanion const& companion, Player* recruiter)
{
    if (!companion.invited || !OwnedCompanionTargetsRecruitingGroup(companion, recruiter))
        return false;

    Player* bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid);
    if (!bot)
        return true;

    Group* group = recruiter->GetGroup();
    return group ? bot->GetGroup() != group : !recruiter->IsInGroup(bot, true);
}

uint32 CountPendingOwnedInvites(Player* recruiter)
{
    if (!recruiter)
        return 0;

    uint32 pending = 0;
    for (auto const& pair : gOwnedCompanions)
        if (IsPendingOwnedInvite(pair.second, recruiter))
            ++pending;
    return pending;
}

bool CanInviteCompanion(Player* owner)
{
    Group* group = owner ? owner->GetGroup() : nullptr;
    if (!group)
    {
        if (1u + CountPendingGroupContracts(owner) + CountPendingOwnedInvites(owner) >= MAX_GROUP_SIZE)
        {
            SendMessage(owner, "Your pending companions already fill a five-player party.");
            return false;
        }
        return true;
    }

    ObjectGuid const ownerGuid = owner->GetObjectGuid();
    if (!group->IsLeader(ownerGuid) && !group->IsAssistant(ownerGuid))
    {
        SendMessage(owner, "Only the group leader or a raid assistant can recruit companions into this group.");
        return false;
    }
    uint32 const capacity = group->isRaidGroup() ? MAX_RAID_SIZE : MAX_GROUP_SIZE;
    if (group->GetMembersCount() + CountPendingGroupContracts(owner) + CountPendingOwnedInvites(owner) >= capacity)
    {
        SendMessage(owner, "Your group has no room for another companion.");
        return false;
    }
    return true;
}

PlayerRole RoleForPlayer(Player const* player)
{
    if (!player)
        return PlayerRole::Damage;

    uint32 const guid = player->GetGUIDLow();
    auto contract = gContracts.find(guid);
    if (contract != gContracts.end())
        return PlayerRoleForBotRole(contract->second.role);
    auto owned = gOwnedCompanions.find(guid);
    if (owned != gOwnedCompanions.end())
        return PlayerRoleForBotRole(owned->second.role);

    if (PlayerbotAI* ai = GetBotAI(const_cast<Player*>(player)))
    {
        BotRoles const forcedRole = BotRoles(ai->GetForcedRole());
        if (forcedRole != BOT_ROLE_NONE)
            return PlayerRoleForBotRole(forcedRole);
    }

    return PlayerRoleForBotRole(AiFactory::GetPlayerRoles(player));
}

bool IsRecruiterCompanion(Player const* player)
{
    return player && (gContracts.count(player->GetGUIDLow()) || gOwnedCompanions.count(player->GetGUIDLow()));
}

char const* RoleName(PlayerRole role)
{
    switch (role)
    {
        case PlayerRole::Tank: return "Tank";
        case PlayerRole::Healer: return "Healer";
        default: return "Damage";
    }
}

std::vector<Player*> GetRecruitingHumanMembers(Player* owner)
{
    std::vector<Player*> members;
    if (!owner)
        return members;

    if (Group* group = owner->GetGroup())
    {
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            if (Player* member = ref->getSource(); member && !GetBotAI(member) && !IsRecruiterCompanion(member))
                members.push_back(member);
    }
    else if (!GetBotAI(owner))
        members.push_back(owner);

    return members;
}

void SyncFillRoleSession(Player* owner, FillRoleSession& session)
{
    std::vector<Player*> const members = GetRecruitingHumanMembers(owner);
    std::set<uint32> currentMembers;
    session.memberGuids.clear();
    for (Player* member : members)
    {
        uint32 const guid = member->GetGUIDLow();
        currentMembers.insert(guid);
        session.memberGuids.push_back(guid);
        if (!session.roles.count(guid))
            session.roles[guid] = RoleForPlayer(member);
    }

    for (auto itr = session.roles.begin(); itr != session.roles.end();)
        if (!currentMembers.count(itr->first))
            itr = session.roles.erase(itr);
        else
            ++itr;

    uint32 const pageCount = uint32((session.memberGuids.size() + FILL_ASSIGNMENT_PAGE_SIZE - 1) /
        FILL_ASSIGNMENT_PAGE_SIZE);
    if (pageCount && session.page >= pageCount)
        session.page = pageCount - 1;
    else if (!pageCount)
        session.page = 0;

    if (session.selectedMemberGuid && !currentMembers.count(session.selectedMemberGuid))
        session.selectedMemberGuid = 0;
}

bool IsClassAvailableToOwner(Player const* owner, uint8 cls)
{
    if (!owner)
        return false;
    if (cls == CLASS_PALADIN)
        return owner->GetTeam() == ALLIANCE;
    if (cls == CLASS_SHAMAN)
        return owner->GetTeam() == HORDE;
    return true;
}

bool IsRaceInOwnerFaction(Player const* owner, uint8 race)
{
    if (!owner || !race || race >= MAX_RACES || !sChrRacesStore.LookupEntry(race))
        return false;

    uint32 const raceMask = 1u << (race - 1);
    if (owner->GetTeam() == ALLIANCE)
        return (RACEMASK_ALLIANCE & raceMask) != 0;
    if (owner->GetTeam() == HORDE)
        return (RACEMASK_HORDE & raceMask) != 0;
    return false;
}

bool IsRaceAvailableToOwner(Player const* owner, uint8 cls, uint8 race)
{
    static RandomPlayerbotFactory raceFactory(0);
    return IsRaceInOwnerFaction(owner, race) && RandomPlayerbotFactory::isAvailableRace(cls, race);
}

uint8 RandomRaceForOwner(Player const* owner, uint8 cls)
{
    std::vector<uint8> races;
    for (uint32 race = 1; race < MAX_RACES; ++race)
        if (IsRaceAvailableToOwner(owner, cls, uint8(race)))
            races.push_back(uint8(race));

    return races.empty() ? 0 : races[urand(0, uint32(races.size() - 1))];
}

std::vector<uint8> GetRoleClassPool(Player const* owner, BotRoles role)
{
    std::vector<uint8> pool;
    for (uint8 cls : {uint8(CLASS_WARRIOR), uint8(CLASS_PALADIN), uint8(CLASS_HUNTER), uint8(CLASS_ROGUE),
             uint8(CLASS_PRIEST), uint8(CLASS_SHAMAN), uint8(CLASS_MAGE), uint8(CLASS_WARLOCK), uint8(CLASS_DRUID)})
        if (IsClassAvailableToOwner(owner, cls) && RandomPlayerbotFactory::isAvailableRole(cls, role))
            pool.push_back(cls);
    return pool;
}

void CountRole(RoleCounts& counts, PlayerRole role)
{
    switch (role)
    {
        case PlayerRole::Tank: ++counts.tanks; break;
        case PlayerRole::Healer: ++counts.healers; break;
        default: ++counts.damage; break;
    }
}

void CountBotRole(RoleCounts& counts, BotRoles role);

RoleCounts GetCurrentRoles(Player* owner, std::map<uint32, PlayerRole> const& assignedRoles)
{
    RoleCounts counts;
    if (!owner)
        return counts;

    auto countMember = [&counts, &assignedRoles](Player* member)
    {
        if (!member)
            return;
        auto assigned = assignedRoles.find(member->GetGUIDLow());
        CountRole(counts, !GetBotAI(member) && !IsRecruiterCompanion(member) && assigned != assignedRoles.end() ?
            assigned->second : RoleForPlayer(member));
    };

    Group* group = owner->GetGroup();
    if (!group)
    {
        countMember(owner);
        for (auto const& pair : gContracts)
            if (IsPendingForRecruitingGroup(pair.second, owner))
                CountBotRole(counts, pair.second.role);
        for (auto const& pair : gOwnedCompanions)
            if (IsPendingOwnedInvite(pair.second, owner))
                CountBotRole(counts, pair.second.role);
        return counts;
    }

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
        countMember(ref->getSource());

    for (auto const& pair : gContracts)
        if (IsPendingForRecruitingGroup(pair.second, owner))
            CountBotRole(counts, pair.second.role);
    for (auto const& pair : gOwnedCompanions)
        if (IsPendingOwnedInvite(pair.second, owner))
            CountBotRole(counts, pair.second.role);
    return counts;
}

std::set<uint8> GetCurrentClasses(Player* owner)
{
    std::set<uint8> classes;
    if (!owner)
        return classes;

    if (Group* group = owner->GetGroup())
    {
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            if (Player* member = ref->getSource())
                classes.insert(member->getClass());
    }
    else
        classes.insert(owner->getClass());

    for (auto const& pair : gContracts)
        if (ContractTargetsRecruitingGroup(pair.second, owner) && pair.second.cls)
            classes.insert(pair.second.cls);
    for (auto const& pair : gOwnedCompanions)
        if (IsPendingOwnedInvite(pair.second, owner) && pair.second.cls)
            classes.insert(pair.second.cls);
    return classes;
}

std::vector<uint8> GetRequiredRaidClasses(Player const* owner, uint32 targetSize)
{
    if (targetSize == 10)
        return {uint8(CLASS_DRUID), uint8(CLASS_PRIEST), uint8(CLASS_MAGE),
            uint8(owner->GetTeam() == ALLIANCE ? CLASS_PALADIN : CLASS_SHAMAN)};
    if (targetSize == 20)
        return {uint8(CLASS_WARRIOR), uint8(owner->GetTeam() == ALLIANCE ? CLASS_PALADIN : CLASS_SHAMAN),
            uint8(CLASS_HUNTER), uint8(CLASS_ROGUE), uint8(CLASS_PRIEST), uint8(CLASS_MAGE),
            uint8(CLASS_WARLOCK), uint8(CLASS_DRUID)};
    return {};
}

BotRoles PreferredRoleForClass(uint8 cls, RoleCounts const& counts, uint32 desiredTanks, uint32 desiredHealers)
{
    if (counts.tanks < desiredTanks && RandomPlayerbotFactory::isAvailableRole(cls, BOT_ROLE_TANK))
        return BOT_ROLE_TANK;
    if (counts.healers < desiredHealers && RandomPlayerbotFactory::isAvailableRole(cls, BOT_ROLE_HEALER))
        return BOT_ROLE_HEALER;
    if (RandomPlayerbotFactory::isAvailableRole(cls, BOT_ROLE_DPS))
        return BOT_ROLE_DPS;
    if (RandomPlayerbotFactory::isAvailableRole(cls, BOT_ROLE_HEALER))
        return BOT_ROLE_HEALER;
    return BOT_ROLE_TANK;
}

void CountBotRole(RoleCounts& counts, BotRoles role)
{
    if (role == BOT_ROLE_TANK)
        ++counts.tanks;
    else if (role == BOT_ROLE_HEALER)
        ++counts.healers;
    else
        ++counts.damage;
}

bool CreateCompanion(Player* owner, BotRoles role, uint8 forcedClass = 0, bool permanent = false,
    uint8 specTab = INVALID_SPEC_TAB, uint8 race = 0, uint8 gender = GENDER_NONE)
{
    if (!owner || !owner->GetSession())
        return false;
    if (!IsEnabled() || owner->GetLevel() < MinimumLevel())
    {
        SendMessage(owner, "You are not eligible to recruit a companion.");
        return false;
    }
    if (!sPlayerbotAIConfig.enabled)
    {
        SendMessage(owner, "The PlayerBots system is currently disabled.");
        return false;
    }
    if (!permanent && !CanInviteCompanion(owner))
        return false;

    uint32 const ownerGuid = owner->GetGUIDLow();
    if (!permanent && CountOwnerContracts(ownerGuid) >= MaxCompanions())
    {
        SendMessage(owner, "You already command the maximum number of temporary companions.");
        return false;
    }
    if (permanent && CountOwnedCompanions(ownerGuid) >= MaxOwnedCompanions())
    {
        SendMessage(owner, "You already own the maximum number of companions.");
        return false;
    }

    uint32 const cost = permanent ? GetPermanentCompanionCost() : GetCompanionCost(owner);
    if (owner->GetMoney() < cost)
    {
        SendMessage(owner, "You need " + FormatMoney(cost) + " to recruit a companion.");
        return false;
    }

    if (specTab != INVALID_SPEC_TAB)
    {
        EnsureRecruiterSpecPaths();
        if (!FindRecruiterSpec(forcedClass, specTab) || !RecruiterSpecNo(forcedClass, specTab))
        {
            SendMessage(owner, "That specialization is not available.");
            return false;
        }
    }

    std::vector<uint8> const classPool = GetRoleClassPool(owner, role);
    uint8 cls = forcedClass;
    if (cls && (!IsClassAvailableToOwner(owner, cls) || !RandomPlayerbotFactory::isAvailableRole(cls, role) ||
        (specTab != INVALID_SPEC_TAB && !FindRecruiterSpec(cls, specTab))))
        cls = 0;
    if (!forcedClass && !classPool.empty())
        cls = classPool[urand(0, uint32(classPool.size() - 1))];
    if (!cls)
    {
        SendMessage(owner, "No class is available for that role.");
        return false;
    }
    if (permanent && !IsRaceAvailableToOwner(owner, cls, race))
    {
        SendMessage(owner, "That race is not available for this companion.");
        return false;
    }
    if (!permanent)
    {
        race = RandomRaceForOwner(owner, cls);
        if (!race)
        {
            SendMessage(owner, "No race in your faction is available for that class.");
            return false;
        }
    }

    std::ostringstream parameters;
    parameters << "level=" << uint32(owner->GetLevel())
               << " class=" << ChatHelper::formatClass(cls)
               << " role=" << ChatHelper::formatRole(role)
               << " race=" << uint32(race);
    if (permanent && (gender == GENDER_MALE || gender == GENDER_FEMALE))
        parameters << " gender=" << uint32(gender);
    if (!permanent)
        parameters << " group=" << owner->GetName();
    parameters << " login=false";

    std::list<std::string> messages;
    ObjectGuid botGuid;
    sRandomPlayerbotMgr.CreateBot(owner, parameters.str(), messages, botGuid,
        permanent ? "companion_recruiter_owned" : "companion_recruiter");
    if (!botGuid)
    {
        SendMessage(owner, messages.empty() ? "Companion creation failed." : messages.back());
        return false;
    }

    uint32 const botGuidLow = botGuid.GetCounter();
    std::string permanentName;
    sRandomPlayerbotMgr.SetExternallyManaged(botGuidLow, true);
    if (permanent)
    {
        sRandomPlayerbotMgr.SetValue(botGuidLow, "companion_recruiter_owned", ownerGuid, "", INT32_MAX);
        QueryResult* nameResult = CharacterDatabase.PQuery(
            "SELECT name, level, race, gender FROM characters WHERE guid = '%u'", botGuidLow);
        std::string botName = "Companion";
        uint8 botLevel = uint8(owner->GetLevel());
        uint8 botRace = race;
        uint8 botGender = gender;
        if (nameResult)
        {
            Field* fields = nameResult->Fetch();
            botName = fields[0].GetCppString();
            botLevel = uint8(fields[1].GetUInt32());
            botRace = uint8(fields[2].GetUInt32());
            botGender = uint8(fields[3].GetUInt32());
            delete nameResult;
        }
        else
        {
            for (std::string const& message : messages)
                if (message.compare(0, 13, "Bot created: ") == 0)
                {
                    botName = message.substr(13);
                    break;
                }
        }
        CharacterDatabase.PExecute(
            "INSERT INTO companion_recruiter_owned (owner_guid, bot_guid, class_id, role, spec_tab, purchase_cost) "
            "VALUES ('%u', '%u', '%u', '%u', '%u', '%u')",
            ownerGuid, botGuidLow, uint32(cls), uint32(role), uint32(specTab), cost);
        OwnedCompanion companion;
        companion.botGuid = botGuidLow;
        companion.ownerGuid = ownerGuid;
        companion.purchaseCost = cost;
        companion.cls = cls;
        companion.specTab = specTab;
        companion.role = role;
        companion.level = botLevel;
        companion.race = botRace;
        companion.gender = botGender;
        companion.name = botName;
        gOwnedCompanions[botGuidLow] = companion;
        permanentName = botName;
    }
    else
    {
        sRandomPlayerbotMgr.SetValue(botGuidLow, "companion_recruiter", ownerGuid, "", int32(LifetimeSeconds()));
        TrackCompanion(botGuidLow, ownerGuid, role, cls, specTab, cost);
    }
    if (specTab != INVALID_SPEC_TAB)
        sRandomPlayerbotMgr.SetValue(botGuidLow, "specNo", RecruiterSpecNo(cls, specTab));
    owner->LogModifyMoney(-int32(cost), "CompanionRecruiter");
    if (!permanent)
        sRandomPlayerbotMgr.AddPlayerBot(botGuidLow, 0);

    std::string const specDescription = specTab == INVALID_SPEC_TAB ? std::string() :
        RecruiterClassName(cls) + std::string(" ") + RecruiterSpecDisplayName(cls, specTab, role) +
            ", " + ChatHelper::formatRole(role);
    SendMessage(owner, permanent ? "You now own " + permanentName +
        (specDescription.empty() ? std::string() : " (" + specDescription + ")") +
        ". It can be invited for free from Companion Management."
        : "A " + (specTab == INVALID_SPEC_TAB ? ChatHelper::formatRole(role) :
            RecruiterSpecDisplayName(cls, specTab, role) + " " + ChatHelper::formatRole(role)) +
            " companion is on the way. Contract price: " + FormatMoney(cost) + ".");
    return true;
}

uint32 CurrentGroupSize(Player* owner)
{
    uint32 const actual = owner && owner->GetGroup() ? owner->GetGroup()->GetMembersCount() : 1u;
    return actual + CountPendingGroupContracts(owner) + CountPendingOwnedInvites(owner);
}

bool FillGroup(Player* owner, uint32 targetSize, std::map<uint32, PlayerRole> const& assignedRoles)
{
    if (!owner)
        return false;

    Group* group = owner->GetGroup();
    if (targetSize > MAX_GROUP_SIZE && (!group || !group->isRaidGroup()))
    {
        SendMessage(owner, "Convert your group to a raid before requesting raid companions.");
        return false;
    }

    uint32 const currentSize = CurrentGroupSize(owner);
    if (currentSize >= targetSize)
    {
        SendMessage(owner, "Your group already has that many members.");
        return false;
    }

    uint32 const missing = targetSize - currentSize;
    uint32 const availableContracts = MaxCompanions() - std::min(MaxCompanions(), CountOwnerContracts(owner->GetGUIDLow()));
    uint32 const toCreate = std::min(missing, availableContracts);
    if (!toCreate)
    {
        SendMessage(owner, "You already command the maximum number of temporary companions.");
        return false;
    }

    RoleCounts counts = GetCurrentRoles(owner, assignedRoles);
    if (targetSize == 5 && (counts.tanks > 1 || counts.healers > 1 || counts.damage > 3))
    {
        SendMessage(owner, "Your selected roles already exceed the party target of 1 tank, 1 healer, and 3 damage. Adjust the roles before filling.");
        return false;
    }

    uint64 const totalCost = uint64(GetCompanionCost(owner)) * toCreate;
    if (owner->GetMoney() < totalCost)
    {
        SendMessage(owner, "You need " + FormatMoney(uint32(totalCost)) + " to fill those slots.");
        return false;
    }

    uint32 const desiredTanks = targetSize <= 5 ? 1u : (targetSize <= 20 ? 2u : 4u);
    uint32 const desiredHealers = targetSize <= 5 ? 1u : (targetSize <= 10 ? 2u : (targetSize <= 20 ? 4u : 8u));
    uint32 created = 0;

    if (targetSize > MAX_GROUP_SIZE)
    {
        std::set<uint8> classes = GetCurrentClasses(owner);
        for (uint8 cls : GetRequiredRaidClasses(owner, targetSize))
        {
            if (created >= toCreate)
                break;
            if (classes.count(cls))
                continue;

            BotRoles const role = PreferredRoleForClass(cls, counts, desiredTanks, desiredHealers);
            if (!CreateCompanion(owner, role, cls))
                break;
            classes.insert(cls);
            CountBotRole(counts, role);
            ++created;
        }
    }

    while (created < toCreate)
    {
        BotRoles role = BOT_ROLE_DPS;
        if (counts.tanks < desiredTanks)
            role = BOT_ROLE_TANK;
        else if (counts.healers < desiredHealers)
            role = BOT_ROLE_HEALER;

        if (!CreateCompanion(owner, role))
            break;

        CountBotRole(counts, role);
        ++created;
    }

    if (created)
        SendMessage(owner, "Queued " + std::to_string(created) + " temporary companion(s) for your group.");
    return created != 0;
}

std::string FillCost(Player* owner, uint32 targetSize)
{
    uint32 const size = CurrentGroupSize(owner);
    if (size >= targetSize)
        return "full";
    uint64 const total = uint64(targetSize - size) * GetCompanionCost(owner);
    return FormatMoney(uint32(std::min<uint64>(total, UINT32_MAX)));
}

void SendFillAssignmentsMenu(Player* player, Creature* creature)
{
    if (!player)
        return;

    auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
    if (sessionItr == gFillRoleSessions.end())
    {
        SendMainMenu(player, creature);
        return;
    }

    FillRoleSession& session = sessionItr->second;
    SyncFillRoleSession(player, session);
    player->PlayerTalkClass->ClearMenus();
    if (session.memberGuids.empty())
    {
        AddMenuItem(player, GOSSIP_ICON_CHAT, "No human group members are available to assign.", ACTION_FILL_CANCEL);
    }
    else
    {
        uint32 const start = session.page * FILL_ASSIGNMENT_PAGE_SIZE;
        uint32 const end = std::min<uint32>(uint32(session.memberGuids.size()), start + FILL_ASSIGNMENT_PAGE_SIZE);
        for (uint32 index = start; index < end; ++index)
        {
            uint32 const memberGuid = session.memberGuids[index];
            Player* member = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, memberGuid));
            if (!member)
                continue;
            auto roleItr = session.roles.find(memberGuid);
            PlayerRole const role = roleItr == session.roles.end() ? RoleForPlayer(member) : roleItr->second;
            AddMenuItem(player, GOSSIP_ICON_CHAT,
                std::string(member->GetName()) + " - " + RecruiterClassName(member->getClass()) + " [" + RoleName(role) + "]",
                ACTION_FILL_MEMBER_BASE + index);
        }

        if (session.page > 0)
            AddMenuItem(player, GOSSIP_ICON_CHAT, "Previous members", ACTION_FILL_PREVIOUS);
        if (end < session.memberGuids.size())
            AddMenuItem(player, GOSSIP_ICON_CHAT, "More members", ACTION_FILL_NEXT);
    }

    AddMenuItem(player, GOSSIP_ICON_CHAT,
        "Confirm Roles (" + FillCost(player, session.targetSize) + ")", ACTION_FILL_CONFIRM);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_FILL_CANCEL);
    SendMenu(player, creature);
}

void SendFillMemberRoleMenu(Player* player, Creature* creature)
{
    if (!player)
        return;

    auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
    if (sessionItr == gFillRoleSessions.end() || !sessionItr->second.selectedMemberGuid)
    {
        SendFillAssignmentsMenu(player, creature);
        return;
    }

    FillRoleSession& session = sessionItr->second;
    uint32 const memberGuid = session.selectedMemberGuid;
    Player* member = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, memberGuid));
    if (!member)
    {
        session.selectedMemberGuid = 0;
        SendFillAssignmentsMenu(player, creature);
        return;
    }

    PlayerRole const currentRole = session.roles[memberGuid];
    player->PlayerTalkClass->ClearMenus();
    AddMenuItem(player, GOSSIP_ICON_CHAT,
        std::string("Role for ") + member->GetName() + " (" + RoleName(currentRole) + ")", ACTION_FILL_BACK_TO_ASSIGNMENTS);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Set role to Tank", ACTION_FILL_SET_TANK);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Set role to Healer", ACTION_FILL_SET_HEALER);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Set role to Damage", ACTION_FILL_SET_DAMAGE);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to role assignments", ACTION_FILL_BACK_TO_ASSIGNMENTS);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_FILL_CANCEL);
    SendMenu(player, creature);
}

void BeginFillRoleAssignments(Player* player, Creature* creature, uint32 targetSize)
{
    if (!player)
        return;

    Group* group = player->GetGroup();
    if (targetSize > MAX_GROUP_SIZE && (!group || !group->isRaidGroup()))
    {
        SendMessage(player, "Convert your group to a raid before requesting raid companions.");
        SendMainMenu(player, creature);
        return;
    }
    if (group && !group->IsLeader(player->GetObjectGuid()) && !group->IsAssistant(player->GetObjectGuid()))
    {
        SendMessage(player, "Only the group leader or a raid assistant can recruit companions into this group.");
        SendMainMenu(player, creature);
        return;
    }
    if (CurrentGroupSize(player) >= targetSize)
    {
        SendMessage(player, "Your group already has that many members.");
        SendMainMenu(player, creature);
        return;
    }
    if (!CanInviteCompanion(player))
    {
        SendMainMenu(player, creature);
        return;
    }

    FillRoleSession& session = gFillRoleSessions[player->GetGUIDLow()];
    session = FillRoleSession();
    session.targetSize = targetSize;
    SyncFillRoleSession(player, session);
    SendFillAssignmentsMenu(player, creature);
}

void SendMainMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->ClearMenus();
    std::string const price = FormatMoney(GetCompanionCost(player));
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a tank companion (" + price + ")", ACTION_RECRUIT_TANK);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a healer companion (" + price + ")", ACTION_RECRUIT_HEALER);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a damage companion (" + price + ")", ACTION_RECRUIT_DPS);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Choose a companion's class and specialization (" + price + ")", ACTION_RECRUIT_CLASS_MENU);
    if (player->GetGroup() && player->GetGroup()->isRaidGroup())
        AddMenuItem(player, GOSSIP_ICON_MONEY_BAG,
            "Fill my raid with temporary companions", ACTION_FILL_RAID_MENU);
    else
        AddMenuItem(player, GOSSIP_ICON_MONEY_BAG,
            "Fill my party with temporary companions (" + FillCost(player, 5) + ")", ACTION_FILL_PARTY_MENU);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Permanent Recruitment", ACTION_PERMANENT_MENU);
    AddMenuItem(player, GOSSIP_ICON_CHAT,
        "Manage Companions (" + std::to_string(CountOwnedCompanions(player->GetGUIDLow())) + ")", ACTION_MANAGE_MENU);
    if (CountOwnerContracts(player->GetGUIDLow()))
        AddMenuItem(player, GOSSIP_ICON_CHAT, "Dismiss all my temporary companions", ACTION_DISMISS_ALL);
    SendMenu(player, creature);
}

uint32 CountOwnedCompanions(uint32 ownerGuid)
{
    return uint32(std::count_if(gOwnedCompanions.begin(), gOwnedCompanions.end(), [ownerGuid](auto const& pair)
    {
        return pair.second.ownerGuid == ownerGuid;
    }));
}

std::vector<OwnedCompanion> GetOwnedCompanions(uint32 ownerGuid)
{
    std::vector<OwnedCompanion> companions;
    for (auto const& pair : gOwnedCompanions)
        if (pair.second.ownerGuid == ownerGuid)
            companions.push_back(pair.second);
    return companions;
}

void LoadOwnedCompanions()
{
    gOwnedCompanions.clear();
    QueryResult* result = CharacterDatabase.Query(
        "SELECT o.bot_guid, o.owner_guid, o.purchase_cost, o.class_id, o.role, o.spec_tab, c.level, c.name, c.race, c.gender "
        "FROM companion_recruiter_owned o JOIN characters c ON c.guid = o.bot_guid");
    if (!result)
        return;

    do
    {
        Field* fields = result->Fetch();
        OwnedCompanion companion;
        companion.botGuid = fields[0].GetUInt32();
        companion.ownerGuid = fields[1].GetUInt32();
        companion.purchaseCost = fields[2].GetUInt32();
        companion.cls = uint8(fields[3].GetUInt32());
        companion.role = BotRoles(fields[4].GetUInt32());
        companion.specTab = uint8(fields[5].GetUInt32());
        companion.level = uint8(fields[6].GetUInt32());
        companion.name = fields[7].GetCppString();
        companion.race = uint8(fields[8].GetUInt32());
        companion.gender = uint8(fields[9].GetUInt32());
        gOwnedCompanions[companion.botGuid] = companion;
    } while (result->NextRow());
    delete result;
}

char const* RecruiterClassName(uint8 cls)
{
    switch (cls)
    {
        case CLASS_WARRIOR: return "Warrior";
        case CLASS_PALADIN: return "Paladin";
        case CLASS_HUNTER: return "Hunter";
        case CLASS_ROGUE: return "Rogue";
        case CLASS_PRIEST: return "Priest";
        case CLASS_SHAMAN: return "Shaman";
        case CLASS_MAGE: return "Mage";
        case CLASS_WARLOCK: return "Warlock";
        case CLASS_DRUID: return "Druid";
        default: return "Unknown";
    }
}

void AddSpecOptions(Player* player, uint8 cls, bool permanent)
{
    EnsureRecruiterSpecPaths();
    std::string const cost = permanent ? " (" + FormatMoney(GetPermanentCompanionCost()) + ")" : std::string();
    for (RecruiterSpec const& spec : RECRUITER_SPECS)
    {
        if (spec.cls != cls || !RecruiterSpecNo(cls, spec.tab))
            continue;

        if (cls == CLASS_DRUID && spec.tab == 1)
        {
            AddMenuItem(player, permanent ? GOSSIP_ICON_MONEY_BAG : GOSSIP_ICON_CHAT,
                "Feral (Tank)" + cost,
                (permanent ? ACTION_PERMANENT_SELECT_SPEC_BASE : ACTION_SELECT_CLASS_SPEC_BASE) +
                    EncodeRecruiterSpec(cls, spec.tab));
            AddMenuItem(player, permanent ? GOSSIP_ICON_MONEY_BAG : GOSSIP_ICON_CHAT,
                "Feral (Damage)" + cost,
                (permanent ? ACTION_PERMANENT_SELECT_SPEC_BASE : ACTION_SELECT_CLASS_SPEC_BASE) +
                    EncodeRecruiterSpec(cls, spec.tab, 1));
            continue;
        }

        BotRoles const role = AiFactory::GetPlayerRoles(cls, spec.tab);
        if (!RandomPlayerbotFactory::isAvailableRole(cls, role))
            continue;
        AddMenuItem(player, permanent ? GOSSIP_ICON_MONEY_BAG : GOSSIP_ICON_CHAT,
            std::string(spec.name) + cost,
            (permanent ? ACTION_PERMANENT_SELECT_SPEC_BASE : ACTION_SELECT_CLASS_SPEC_BASE) +
                EncodeRecruiterSpec(cls, spec.tab));
    }
}

void SendClassMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->ClearMenus();
    for (uint8 cls : {uint8(CLASS_WARRIOR), uint8(CLASS_PALADIN), uint8(CLASS_HUNTER), uint8(CLASS_ROGUE),
             uint8(CLASS_PRIEST), uint8(CLASS_SHAMAN), uint8(CLASS_MAGE), uint8(CLASS_WARLOCK), uint8(CLASS_DRUID)})
        if (IsClassAvailableToOwner(player, cls))
            AddMenuItem(player, GOSSIP_ICON_CHAT, RecruiterClassName(cls), ACTION_SELECT_CLASS_BASE + cls);
    AddSpecOptions(player, CLASS_WARRIOR, false);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_RETURN_MAIN);
    SendMenu(player, creature);
}

void SendClassSpecMenu(Player* player, Creature* creature, uint8 cls)
{
    player->PlayerTalkClass->ClearMenus();
    AddSpecOptions(player, cls, false);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Choose another class", ACTION_RECRUIT_CLASS_MENU);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_RETURN_MAIN);
    SendMenu(player, creature);
}

void AddPermanentClassOptions(Player* player)
{
    for (uint8 cls : {uint8(CLASS_WARRIOR), uint8(CLASS_PALADIN), uint8(CLASS_HUNTER), uint8(CLASS_ROGUE),
             uint8(CLASS_PRIEST), uint8(CLASS_SHAMAN), uint8(CLASS_MAGE), uint8(CLASS_WARLOCK), uint8(CLASS_DRUID)})
        if (IsClassAvailableToOwner(player, cls))
            AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, RecruiterClassName(cls), ACTION_PERMANENT_SELECT_CLASS_BASE + cls);
}

void AddPermanentRaceOptions(Player* player, uint8 cls)
{
    std::string const cost = FormatMoney(GetPermanentCompanionCost());
    for (uint8 race = 1; race < MAX_RACES; ++race)
        if (IsRaceInOwnerFaction(player, race))
        {
            bool const available = IsRaceAvailableToOwner(player, cls, race);
            std::string const raceName = ChatHelper::formatRace(race);
            AddMenuItem(player, GOSSIP_ICON_MONEY_BAG,
                (available ? "Race: " + raceName + " (" + cost + ")" : "Race unavailable: " + raceName),
                ACTION_PERMANENT_SELECT_RACE_BASE + uint32(race - 1));
        }
}

void SendPermanentClassMenu(Player* player, Creature* creature)
{
    uint8 const defaultClass = CLASS_WARRIOR;
    PermanentRecruitmentSession& session = gPermanentRecruitmentSessions[player->GetGUIDLow()];
    session.cls = defaultClass;
    session.specTab = INVALID_SPEC_TAB;
    session.variant = 0;
    session.race = 0;
    player->PlayerTalkClass->ClearMenus();
    AddPermanentClassOptions(player);
    AddSpecOptions(player, defaultClass, true);
    AddPermanentRaceOptions(player, defaultClass);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit permanent companion", ACTION_PERMANENT_RECRUIT);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_RETURN_MAIN);
    SendMenu(player, creature);
}

void SendPermanentSpecMenu(Player* player, Creature* creature, uint8 cls)
{
    PermanentRecruitmentSession& session = gPermanentRecruitmentSessions[player->GetGUIDLow()];
    if (session.cls != cls)
    {
        session.cls = cls;
        session.specTab = INVALID_SPEC_TAB;
        session.variant = 0;
        session.race = 0;
    }
    player->PlayerTalkClass->ClearMenus();
    AddPermanentClassOptions(player);
    AddSpecOptions(player, cls, true);
    AddPermanentRaceOptions(player, cls);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit permanent companion", ACTION_PERMANENT_RECRUIT);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Choose another class", ACTION_PERMANENT_MENU);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_RETURN_MAIN);
    SendMenu(player, creature);
}

void SendManageMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->ClearMenus();
    uint32 const ownerGuid = player->GetGUIDLow();
    std::vector<OwnedCompanion> companions = GetOwnedCompanions(ownerGuid);
    uint32 const pageCount = uint32((companions.size() + MANAGE_PAGE_SIZE - 1) / MANAGE_PAGE_SIZE);
    uint32& page = gManagePages[ownerGuid];
    if (pageCount && page >= pageCount)
        page = pageCount - 1;
    else if (!pageCount)
        page = 0;

    if (companions.empty())
    {
        AddMenuItem(player, GOSSIP_ICON_CHAT, "You do not own any companions yet.", ACTION_PERMANENT_MENU);
    }
    else
    {
        uint32 const start = page * MANAGE_PAGE_SIZE;
        uint32 const end = std::min<uint32>(uint32(companions.size()), start + MANAGE_PAGE_SIZE);
        for (uint32 index = start; index < end; ++index)
        {
            OwnedCompanion const& companion = companions[index];
            Player* bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid);
            bool const following = bot && player->IsInGroup(bot, true);
            std::string const status = following ? "Following" :
                (companion.invited ? "Inviting" : (bot ? "Idle" : "Stored"));
            AddMenuItem(player, following ? GOSSIP_ICON_TALK : GOSSIP_ICON_CHAT,
                companion.name + " - " + RecruiterClassName(companion.cls) +
                    " / " + (companion.specTab < 3 ? RecruiterSpecDisplayName(companion.cls, companion.specTab, companion.role) : "Unknown") +
                    " / " + ChatHelper::formatRole(companion.role) + " / " + ChatHelper::formatRace(companion.race) +
                    " / " + (companion.gender == GENDER_FEMALE ? "Female" : "Male") + " [" + status + "]",
                ACTION_OWNED_TOGGLE_BASE + index);
            AddMenuItem(player, GOSSIP_ICON_CHAT, "Remove companion: " + companion.name,
                ACTION_OWNED_REMOVE_BASE + index);
        }

        if (page > 0)
            AddMenuItem(player, GOSSIP_ICON_CHAT, "Previous companions", ACTION_MANAGE_PREVIOUS);
        if (page + 1 < pageCount)
            AddMenuItem(player, GOSSIP_ICON_CHAT, "More companions", ACTION_MANAGE_NEXT);
    }
    AddMenuItem(player, GOSSIP_ICON_CHAT, "Buy another companion", ACTION_PERMANENT_MENU);
    SendMenu(player, creature);
}

bool IsProtected(Player* owner)
{
    if (!owner)
        return false;
    if (!owner->IsAlive())
        return true;
    return sConfig.GetBoolDefault("CompanionRecruiter.ProtectInInstances", true) &&
        owner->GetMap() && owner->GetMap()->IsDungeon();
}

Player* GetCommandMaster(Player* owner)
{
    Group* group = owner ? owner->GetGroup() : nullptr;
    if (!group)
        return owner;

    Player* leader = ObjectAccessor::FindConnectedPlayer(group->GetLeaderGuid());
    if (!leader || leader->GetGroup() != group || GetBotAI(leader))
        return owner;
    return leader;
}

bool IsSafeTeleportTarget(Player const* player)
{
    return player && player->IsInWorld() && !player->IsBeingTeleported() && !player->IsTaxiFlying() &&
        !player->IsFlying() && !player->HasFlag(PLAYER_FLAGS, PLAYER_FLAGS_GHOST);
}

bool ApplyRecruiterSpec(uint32 botGuid, Player* bot, PlayerbotAI* ai, uint8 cls, uint8 specTab,
    BotRoles role, PlayerbotFactory& factory)
{
    uint32 const specNo = RecruiterSpecNo(cls, specTab);
    if (!specNo)
        return false;

    sRandomPlayerbotMgr.SetValue(botGuid, "specNo", specNo);
    if (bot->GetLevel() < 10)
        return false;

    ai->SetForcedRole(uint8(role));
    ai->DoSpecificAction("auto talents");
    factory.EquipGear();
    if (bot->GetLevel() >= sPlayerbotAIConfig.minEnchantingBotLevel)
        factory.EnchantEquipment();
    factory.InitAmmo();
    ai->ResetStrategies();
    TalentSpec appliedSpec(bot);
    return appliedSpec.GetTalentPoints() > 0 && appliedSpec.highestTree() == specTab;
}

bool PrepareOnlineCompanion(CompanionContract& contract, Player* bot, PlayerbotAI* ai)
{
    ai->SetForcedRole(uint8(contract.role));
    if (contract.specTab == INVALID_SPEC_TAB && bot->GetLevel() >= 10 &&
        !(AiFactory::GetPlayerRoles(bot) & contract.role))
        return false;

    PlayerbotFactory factory(bot, bot->GetLevel());
    factory.InitializeAtCurrentLevel();
    if (contract.specTab != INVALID_SPEC_TAB)
    {
        if (!ApplyRecruiterSpec(contract.botGuid, bot, ai, contract.cls, contract.specTab, contract.role, factory))
            return false;
    }

    sRandomPlayerbotMgr.SetValue(contract.botGuid, "create levelup", 0);
    sRandomPlayerbotMgr.SetValue(contract.botGuid, "create gear", 0);
    sRandomPlayerbotMgr.SetValue(contract.botGuid, "create group", 0);
    contract.preparedAt = Clock::now();
    contract.prepared = true;
    return true;
}

bool InitializeOnlineCompanion(CompanionContract& contract, Player* owner, Player* bot)
{
    PlayerbotAI* ai = GetBotAI(bot);
    if (!ai || !owner)
        return true;

    if (!contract.prepared)
    {
        if (!PrepareOnlineCompanion(contract, bot, ai))
            return false;
        ai->ResetStrategies();
    }

    Player* commandMaster = GetCommandMaster(owner);
    if (ai->GetMaster() != commandMaster)
    {
        ai->SetMaster(commandMaster);
        ai->ChangeStrategy("+follow", BotState::BOT_STATE_NON_COMBAT);
    }

    if (!owner->IsInGroup(bot, true))
        ai->DoSpecificAction("join", ai::Event("companion recruiter", "", owner), true);

    if (IsSafeTeleportTarget(commandMaster) && !bot->IsBeingTeleported() && !bot->IsTaxiFlying() && !bot->IsFlying() &&
        (bot->GetMapId() != commandMaster->GetMapId() || bot->GetDistance(commandMaster) > 160.0f))
        bot->TeleportTo(commandMaster->GetMapId(), commandMaster->GetPositionX(), commandMaster->GetPositionY(),
            commandMaster->GetPositionZ(), commandMaster->GetOrientation(),
            TELE_TO_NOT_LEAVE_COMBAT | TELE_TO_NOT_UNSUMMON_PET);

    contract.initialized = owner->IsInGroup(bot, true);
    contract.joinedOnce = contract.joinedOnce || contract.initialized;
    return true;
}

bool InitializeOwnedCompanion(OwnedCompanion& companion, Player* owner, Player* bot)
{
    PlayerbotAI* ai = GetBotAI(bot);
    if (!ai || !owner)
        return false;

    ai->SetForcedRole(uint8(companion.role));
    if (ai->GetMaster() != owner)
    {
        ai->SetMaster(owner);
        ai->ChangeStrategy("+follow", BotState::BOT_STATE_NON_COMBAT);
    }

    bool const levelCatchup = bot->GetLevel() < owner->GetLevel();
    if (levelCatchup)
    {
        bot->GiveLevel(owner->GetLevel());
        companion.level = uint8(bot->GetLevel());
    }

    bool const needsInitialization = levelCatchup || sRandomPlayerbotMgr.GetValue(companion.botGuid, "create levelup") ||
        sRandomPlayerbotMgr.GetValue(companion.botGuid, "create gear");
    if (needsInitialization)
    {
        // PlayerBots' master-sync equipment path caps item levels near the
        // owner's equipped gear score. At low levels, its normal level-based selection
        // is more reliable when the owner's equipment is sparse.
        uint32 const ownerGearScore = ai->GetEquipGearScore(owner, false, false);
        // GetEquipGearScore averages empty equipment slots as zero. Do not use
        // a sparse owner's low nonzero score as the item-level cap: InitEquipment
        // clears the bot's gear before selecting replacements, and a cap below
        // the bot's level can leave it with no usable replacements.
        bool const syncGearWithMaster = owner->GetLevel() >= 55 && ownerGearScore != 0 &&
            ownerGearScore + sPlayerbotAIConfig.randomGearMaxDiff >= owner->GetLevel();
        PlayerbotFactory factory(bot, bot->GetLevel());
        factory.InitializeAtCurrentLevel(syncGearWithMaster);
        sRandomPlayerbotMgr.SetValue(companion.botGuid, "create levelup", 0);
        sRandomPlayerbotMgr.SetValue(companion.botGuid, "create gear", 0);
        sRandomPlayerbotMgr.SetValue(companion.botGuid, "create group", 0);
        ai->ResetStrategies();
    }

    if (companion.specTab != INVALID_SPEC_TAB)
    {
        uint32 const specNo = RecruiterSpecNo(companion.cls, companion.specTab);
        if (specNo)
        {
            uint32 const savedSpecNo = sRandomPlayerbotMgr.GetValue(companion.botGuid, "specNo");
            TalentSpec currentSpec(bot);
            bool const hasUnspentPoints = currentSpec.GetTalentPoints() < bot->CalculateTalentsPoints();
            if (needsInitialization || savedSpecNo != specNo || (bot->GetLevel() >= 10 &&
                (AiFactory::GetPlayerSpecTab(bot) != companion.specTab || hasUnspentPoints)))
            {
                PlayerbotFactory factory(bot, bot->GetLevel());
                ApplyRecruiterSpec(companion.botGuid, bot, ai, companion.cls, companion.specTab, companion.role, factory);
            }
            else
                sRandomPlayerbotMgr.SetValue(companion.botGuid, "specNo", specNo);
        }
    }

    if (!companion.invited)
        return true;

    Player* commandMaster = owner;
    if (ai->GetMaster() != commandMaster)
    {
        ai->SetMaster(commandMaster);
        ai->ChangeStrategy("+follow", BotState::BOT_STATE_NON_COMBAT);
    }

    if (!owner->IsInGroup(bot, true))
        ai->DoSpecificAction("join", ai::Event("companion recruiter owned", "", owner), true);

    if (IsSafeTeleportTarget(commandMaster) && !bot->IsBeingTeleported() && !bot->IsTaxiFlying() && !bot->IsFlying() &&
        (bot->GetMapId() != commandMaster->GetMapId() || bot->GetDistance(commandMaster) > 160.0f))
        bot->TeleportTo(commandMaster->GetMapId(), commandMaster->GetPositionX(), commandMaster->GetPositionY(),
            commandMaster->GetPositionZ(), commandMaster->GetOrientation(),
            TELE_TO_NOT_LEAVE_COMBAT | TELE_TO_NOT_UNSUMMON_PET);
    return true;
}

void EnsureOwnedCompanionOnline(OwnedCompanion& companion)
{
    sRandomPlayerbotMgr.SetExternallyManaged(companion.botGuid, true);
    if (!sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid))
        sRandomPlayerbotMgr.AddPlayerBot(companion.botGuid, 0);
}

void DismissOwnedCompanion(OwnedCompanion& companion)
{
    companion.invited = false;
    if (Player* bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid))
    {
        if (bot->GetGroup())
            bot->GetGroup()->RemoveMember(bot->GetObjectGuid(), GROUP_LEAVE);
        sRandomPlayerbotMgr.LogoutPlayerBot(companion.botGuid, true);
    }
}

void UpdateOwnedCompanions()
{
    for (auto& pair : gOwnedCompanions)
    {
        OwnedCompanion& companion = pair.second;
        Player* owner = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, companion.ownerGuid));
        Player* bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid);
        if (!owner)
        {
            if (bot)
                DismissOwnedCompanion(companion);
            continue;
        }
        if (companion.invited)
        {
            Group* group = owner->GetGroup();
            if (group && (!bot || bot->GetGroup() != group))
            {
                uint32 const capacity = group->isRaidGroup() ? MAX_RAID_SIZE : MAX_GROUP_SIZE;
                if (group->GetMembersCount() >= capacity)
                {
                    companion.invited = false;
                    if (bot)
                        DismissOwnedCompanion(companion);
                    SendMessage(owner, companion.name + " could not join because the group is full; the invitation was cancelled.");
                    continue;
                }
            }

            EnsureOwnedCompanionOnline(companion);
            bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid);
            if (bot)
                InitializeOwnedCompanion(companion, owner, bot);
        }
        else if (bot)
            DismissOwnedCompanion(companion);
    }
}

bool ToggleOwnedCompanion(Player* owner, uint32 index)
{
    if (!owner)
        return false;
    std::vector<OwnedCompanion> companions = GetOwnedCompanions(owner->GetGUIDLow());
    if (index >= companions.size())
        return false;
    OwnedCompanion& companion = gOwnedCompanions[companions[index].botGuid];
    Player* bot = sRandomPlayerbotMgr.GetPlayerBot(companion.botGuid);
    if (companion.invited || (bot && owner->IsInGroup(bot, true)))
    {
        DismissOwnedCompanion(companion);
        SendMessage(owner, companion.name + " was dismissed and remains yours.");
        return true;
    }
    if (!CanInviteCompanion(owner))
        return false;
    companion.invited = true;
    EnsureOwnedCompanionOnline(companion);
    SendMessage(owner, companion.name + " is being invited to your group.");
    return true;
}

bool RemoveOwnedCompanion(Player* owner, uint32 index)
{
    if (!owner)
        return false;

    std::vector<OwnedCompanion> const companions = GetOwnedCompanions(owner->GetGUIDLow());
    if (index >= companions.size())
        return false;

    uint32 const botGuid = companions[index].botGuid;
    auto itr = gOwnedCompanions.find(botGuid);
    if (itr == gOwnedCompanions.end() || itr->second.ownerGuid != owner->GetGUIDLow())
        return false;

    std::string const name = itr->second.name;
    DismissOwnedCompanion(itr->second);
    CharacterDatabase.PExecute("DELETE FROM companion_recruiter_owned WHERE bot_guid = '%u'", botGuid);
    sRandomPlayerbotMgr.SetValue(botGuid, "companion_recruiter_owned", 0);
    DeleteCompanion(botGuid);
    gOwnedCompanions.erase(itr);
    SendMessage(owner, name + " was removed from your available companions.");
    return true;
}

void UpdateContracts()
{
    Clock::time_point const now = Clock::now();
    std::vector<uint32> deletes;
    std::vector<std::pair<Player*, std::string>> messages;
    uint32 preparationBudget = PreparationsPerUpdate();

    for (auto& pair : gContracts)
    {
        CompanionContract& contract = pair.second;
            Player* owner = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, contract.ownerGuid));
            if (!owner)
            {
                deletes.push_back(contract.botGuid);
                continue;
            }

            if (contract.expiresAt == Clock::time_point::min())
            {
                deletes.push_back(contract.botGuid);
                continue;
            }

            Player* bot = sRandomPlayerbotMgr.GetPlayerBot(contract.botGuid);
            bool const mayInitialize = contract.prepared || preparationBudget != 0;
            bool const wasPrepared = contract.prepared;
            if (bot && mayInitialize && !InitializeOnlineCompanion(contract, owner, bot))
            {
                if (contract.paidCost)
                    owner->LogModifyMoney(int32(contract.paidCost), "CompanionRecruiterRefund");
                messages.emplace_back(owner, "A companion could not apply its requested specialization and role; its contract price was refunded.");
                deletes.push_back(contract.botGuid);
                continue;
            }
            if (!wasPrepared && contract.prepared)
                --preparationBudget;

            bool const loginTimedOut = !bot &&
                now >= contract.createdAt + std::chrono::seconds(LoginTimeoutSeconds());
            bool const preparationTimedOut = bot && !contract.prepared && !GetBotAI(bot) &&
                now >= contract.createdAt + std::chrono::seconds(LoginTimeoutSeconds());
            bool const joinTimedOut = contract.prepared && !contract.joinedOnce &&
                now >= contract.preparedAt + std::chrono::seconds(LoginTimeoutSeconds());
            if (loginTimedOut || preparationTimedOut || joinTimedOut)
            {
                if (contract.paidCost)
                    owner->LogModifyMoney(int32(contract.paidCost), "CompanionRecruiterRefund");
                messages.emplace_back(owner, "A companion could not join your group; its contract price was refunded.");
                deletes.push_back(contract.botGuid);
                continue;
            }

            auto const remaining = std::chrono::duration_cast<std::chrono::seconds>(contract.expiresAt - now).count();
            if (remaining > 0)
            {
                uint32 warningMinutes = 0;
                if (remaining <= 60 && !(contract.warningMask & 4))
                {
                    contract.warningMask |= 7;
                    warningMinutes = 1;
                }
                else if (remaining <= 300 && !(contract.warningMask & 2))
                {
                    contract.warningMask |= 3;
                    warningMinutes = 5;
                }
                else if (remaining <= 600 && !(contract.warningMask & 1))
                {
                    contract.warningMask |= 1;
                    warningMinutes = 10;
                }

                if (warningMinutes)
                    messages.emplace_back(owner, "Your temporary companion contract expires in " +
                        std::to_string(warningMinutes) + (warningMinutes == 1 ? " minute." : " minutes."));
            }

            if (now < contract.expiresAt)
                continue;

            if (IsProtected(owner))
            {
                contract.graceExpiresAt = now + std::chrono::seconds(GraceSeconds());
                continue;
            }

            if (contract.graceExpiresAt == Clock::time_point{})
                contract.graceExpiresAt = now + std::chrono::seconds(GraceSeconds());
            if (now >= contract.graceExpiresAt)
                deletes.push_back(contract.botGuid);
    }

    for (uint32 guid : deletes)
        gContracts.erase(guid);

    for (auto const& message : messages)
        SendMessage(message.first, message.second);
    for (uint32 guid : deletes)
        DeleteCompanion(guid);
}

class CompanionRecruiterNpc : public CreatureScript
{
public:
    CompanionRecruiterNpc() : CreatureScript("npc_companion_recruiter") {}

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        if (!IsEnabled())
        {
            SendMessage(player, "The companion recruiter is currently unavailable.");
            return true;
        }
        if (!sPlayerbotAIConfig.enabled)
        {
            SendMessage(player, "The PlayerBots system is currently disabled.");
            return true;
        }
        if (player->GetLevel() < MinimumLevel())
        {
            SendMessage(player, "Return when you have reached level " + std::to_string(MinimumLevel()) + ".");
            return true;
        }
        SendMainMenu(player, creature);
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        if (sender != GOSSIP_SENDER_MAIN)
            return true;
        if (!IsEnabled() || player->GetLevel() < MinimumLevel())
        {
            player->PlayerTalkClass->CloseGossip();
            SendMessage(player, "You are not eligible to recruit a companion.");
            return true;
        }

        player->PlayerTalkClass->ClearMenus();
        if (action == ACTION_PERMANENT_RECRUIT)
        {
            auto sessionItr = gPermanentRecruitmentSessions.find(player->GetGUIDLow());
            if (sessionItr != gPermanentRecruitmentSessions.end())
            {
                PermanentRecruitmentSession const session = sessionItr->second;
                bool validSelection = session.specTab != INVALID_SPEC_TAB && session.race &&
                    IsClassAvailableToOwner(player, session.cls) &&
                    IsRaceAvailableToOwner(player, session.cls, session.race) &&
                    (session.variant == 0 || (session.cls == CLASS_DRUID && session.specTab == 1)) &&
                    FindRecruiterSpec(session.cls, session.specTab);
                BotRoles role = BOT_ROLE_NONE;
                if (validSelection)
                {
                    role = BotRoleForRecruiterSpec(session.cls, session.specTab, session.variant);
                    validSelection = RandomPlayerbotFactory::isAvailableRole(session.cls, role);
                }
                if (validSelection)
                {
                    gPermanentRecruitmentSessions.erase(sessionItr);
                    player->CLOSE_GOSSIP_MENU();
                    CreateCompanion(player, role, session.cls, true, session.specTab, session.race);
                }
                else
                {
                    SendMessage(player, "Select a class, specialization, and race before recruiting.");
                    SendPermanentSpecMenu(player, creature, session.cls);
                }
            }
            else
                SendPermanentClassMenu(player, creature);
            return true;
        }
        if (action >= ACTION_PERMANENT_SELECT_RACE_BASE &&
            action < ACTION_PERMANENT_SELECT_RACE_BASE + uint32(MAX_RACES - 1))
        {
            uint8 const race = uint8(action - ACTION_PERMANENT_SELECT_RACE_BASE + 1);
            auto sessionItr = gPermanentRecruitmentSessions.find(player->GetGUIDLow());
            if (sessionItr != gPermanentRecruitmentSessions.end())
            {
                if (IsClassAvailableToOwner(player, sessionItr->second.cls) &&
                    IsRaceAvailableToOwner(player, sessionItr->second.cls, race))
                {
                    sessionItr->second.race = race;
                    SendPermanentSpecMenu(player, creature, sessionItr->second.cls);
                }
                else
                {
                    SendMessage(player, "That race is not available for the selected class.");
                    SendPermanentSpecMenu(player, creature, sessionItr->second.cls);
                }
            }
            else
                SendPermanentClassMenu(player, creature);
            return true;
        }
        if (action > ACTION_PERMANENT_SELECT_CLASS_BASE && action < ACTION_PERMANENT_SELECT_CLASS_BASE + 12)
        {
            uint8 const cls = uint8(action - ACTION_PERMANENT_SELECT_CLASS_BASE);
            if (IsClassAvailableToOwner(player, cls) &&
                std::string(RecruiterClassName(cls)) != "Unknown")
            {
                PermanentRecruitmentSession& session = gPermanentRecruitmentSessions[player->GetGUIDLow()];
                session.cls = cls;
                session.specTab = INVALID_SPEC_TAB;
                session.variant = 0;
                session.race = 0;
                SendPermanentSpecMenu(player, creature, cls);
            }
            else
                SendPermanentClassMenu(player, creature);
            return true;
        }
        if (action >= ACTION_PERMANENT_SELECT_SPEC_BASE && action < ACTION_PERMANENT_SELECT_SPEC_BASE + 72)
        {
            uint32 const encoded = action - ACTION_PERMANENT_SELECT_SPEC_BASE;
            uint8 const cls = uint8(encoded / 6);
            uint8 const specTab = uint8((encoded % 6) / 2);
            uint8 const variant = uint8(encoded % 2);
            BotRoles const role = BotRoleForRecruiterSpec(cls, specTab, variant);
            if (IsClassAvailableToOwner(player, cls) &&
                std::string(RecruiterClassName(cls)) != "Unknown" &&
                (variant == 0 || (cls == CLASS_DRUID && specTab == 1)) &&
                FindRecruiterSpec(cls, specTab) && RandomPlayerbotFactory::isAvailableRole(cls, role))
            {
                PermanentRecruitmentSession& session = gPermanentRecruitmentSessions[player->GetGUIDLow()];
                if (session.cls != cls)
                {
                    session.cls = cls;
                    session.race = 0;
                }
                session.cls = cls;
                session.specTab = specTab;
                session.variant = variant;
                SendPermanentSpecMenu(player, creature, cls);
            }
            else
                SendPermanentClassMenu(player, creature);
            return true;
        }
        if (action > ACTION_SELECT_CLASS_BASE && action < ACTION_SELECT_CLASS_BASE + 12)
        {
            uint8 const cls = uint8(action - ACTION_SELECT_CLASS_BASE);
            if (IsClassAvailableToOwner(player, cls) &&
                std::string(RecruiterClassName(cls)) != "Unknown")
                SendClassSpecMenu(player, creature, cls);
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action == ACTION_MANAGE_PREVIOUS)
        {
            uint32& page = gManagePages[player->GetGUIDLow()];
            if (page > 0)
                --page;
            SendManageMenu(player, creature);
            return true;
        }
        if (action == ACTION_MANAGE_NEXT)
        {
            ++gManagePages[player->GetGUIDLow()];
            SendManageMenu(player, creature);
            return true;
        }
        if (action == ACTION_FILL_PREVIOUS || action == ACTION_FILL_NEXT)
        {
            auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
            if (sessionItr != gFillRoleSessions.end())
            {
                if (action == ACTION_FILL_PREVIOUS && sessionItr->second.page > 0)
                    --sessionItr->second.page;
                else if (action == ACTION_FILL_NEXT)
                    ++sessionItr->second.page;
                SendFillAssignmentsMenu(player, creature);
            }
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action >= ACTION_FILL_MEMBER_BASE && action < ACTION_FILL_MEMBER_BASE + MAX_RAID_SIZE)
        {
            auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
            if (sessionItr != gFillRoleSessions.end())
            {
                FillRoleSession& session = sessionItr->second;
                SyncFillRoleSession(player, session);
                uint32 const index = action - ACTION_FILL_MEMBER_BASE;
                if (index < session.memberGuids.size())
                {
                    session.selectedMemberGuid = session.memberGuids[index];
                    SendFillMemberRoleMenu(player, creature);
                }
                else
                    SendFillAssignmentsMenu(player, creature);
            }
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action == ACTION_FILL_SET_TANK || action == ACTION_FILL_SET_HEALER || action == ACTION_FILL_SET_DAMAGE)
        {
            auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
            if (sessionItr != gFillRoleSessions.end())
            {
                FillRoleSession& session = sessionItr->second;
                uint32 const memberGuid = session.selectedMemberGuid;
                Player* member = memberGuid ? ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, memberGuid)) : nullptr;
                BotRoles const requestedRole = action == ACTION_FILL_SET_TANK ? BOT_ROLE_TANK :
                    (action == ACTION_FILL_SET_HEALER ? BOT_ROLE_HEALER : BOT_ROLE_DPS);
                if (member && session.roles.count(memberGuid) &&
                    RandomPlayerbotFactory::isAvailableRole(member->getClass(), requestedRole))
                    session.roles[memberGuid] = action == ACTION_FILL_SET_TANK ? PlayerRole::Tank :
                        (action == ACTION_FILL_SET_HEALER ? PlayerRole::Healer : PlayerRole::Damage);
                else if (member && session.roles.count(memberGuid))
                    SendMessage(player, "That role is not available for this class.");
                session.selectedMemberGuid = 0;
                SendFillAssignmentsMenu(player, creature);
            }
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action == ACTION_FILL_BACK_TO_ASSIGNMENTS)
        {
            auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
            if (sessionItr != gFillRoleSessions.end())
            {
                sessionItr->second.selectedMemberGuid = 0;
                SendFillAssignmentsMenu(player, creature);
            }
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action == ACTION_FILL_CONFIRM)
        {
            auto sessionItr = gFillRoleSessions.find(player->GetGUIDLow());
            if (sessionItr != gFillRoleSessions.end())
            {
                SyncFillRoleSession(player, sessionItr->second);
                uint32 const targetSize = sessionItr->second.targetSize;
                std::map<uint32, PlayerRole> assignedRoles = sessionItr->second.roles;
                gFillRoleSessions.erase(sessionItr);
                player->CLOSE_GOSSIP_MENU();
                FillGroup(player, targetSize, assignedRoles);
            }
            else
                SendMainMenu(player, creature);
            return true;
        }
        if (action == ACTION_FILL_CANCEL)
        {
            gFillRoleSessions.erase(player->GetGUIDLow());
            SendMainMenu(player, creature);
            return true;
        }
        if (action >= ACTION_OWNED_TOGGLE_BASE && action < ACTION_OWNED_TOGGLE_BASE + MaxOwnedCompanions())
        {
            ToggleOwnedCompanion(player, action - ACTION_OWNED_TOGGLE_BASE);
            SendManageMenu(player, creature);
            return true;
        }
        if (action >= ACTION_OWNED_REMOVE_BASE && action < ACTION_OWNED_REMOVE_BASE + MaxOwnedCompanions())
        {
            RemoveOwnedCompanion(player, action - ACTION_OWNED_REMOVE_BASE);
            SendManageMenu(player, creature);
            return true;
        }
        if (action >= ACTION_SELECT_CLASS_SPEC_BASE && action < ACTION_SELECT_CLASS_SPEC_BASE + 72)
        {
            uint32 const encoded = action - ACTION_SELECT_CLASS_SPEC_BASE;
            uint8 const cls = uint8(encoded / 6);
            uint8 const specTab = uint8((encoded % 6) / 2);
            uint8 const variant = uint8(encoded % 2);
            BotRoles const role = BotRoleForRecruiterSpec(cls, specTab, variant);
            player->CLOSE_GOSSIP_MENU();
            if (IsClassAvailableToOwner(player, cls) &&
                std::string(RecruiterClassName(cls)) != "Unknown" &&
                (variant == 0 || (cls == CLASS_DRUID && specTab == 1)) &&
                FindRecruiterSpec(cls, specTab) && RandomPlayerbotFactory::isAvailableRole(cls, role))
                CreateCompanion(player, role, cls, false, specTab);
            return true;
        }
        switch (action)
        {
            case ACTION_RECRUIT_TANK: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_TANK); break;
            case ACTION_RECRUIT_HEALER: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_HEALER); break;
            case ACTION_RECRUIT_DPS: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_DPS); break;
            case ACTION_RECRUIT_CLASS_MENU: SendClassMenu(player, creature); break;
            case ACTION_PERMANENT_MENU: SendPermanentClassMenu(player, creature); break;
            case ACTION_MANAGE_MENU:
                gManagePages[player->GetGUIDLow()] = 0;
                SendManageMenu(player, creature);
                break;
            case ACTION_RETURN_MAIN:
                gPermanentRecruitmentSessions.erase(player->GetGUIDLow());
                SendMainMenu(player, creature);
                break;
            case ACTION_FILL_PARTY_MENU:
                BeginFillRoleAssignments(player, creature, 5);
                break;
            case ACTION_FILL_RAID_MENU:
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 10-player raid (" + FillCost(player, 10) + ")", ACTION_FILL_RAID_10);
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 20-player raid (" + FillCost(player, 20) + ")", ACTION_FILL_RAID_20);
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 40-player raid (" + FillCost(player, 40) + ")", ACTION_FILL_RAID_40);
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Back to recruiter", ACTION_RETURN_MAIN);
                SendMenu(player, creature);
                break;
            case ACTION_FILL_RAID_10: BeginFillRoleAssignments(player, creature, 10); break;
            case ACTION_FILL_RAID_20: BeginFillRoleAssignments(player, creature, 20); break;
            case ACTION_FILL_RAID_40: BeginFillRoleAssignments(player, creature, 40); break;
            case ACTION_FILL_PARTY_AS_TANK:
            case ACTION_FILL_PARTY_AS_HEALER:
            case ACTION_FILL_PARTY_AS_DPS: BeginFillRoleAssignments(player, creature, 5); break;
            case ACTION_FILL_RAID_10_AS_TANK:
            case ACTION_FILL_RAID_10_AS_HEALER:
            case ACTION_FILL_RAID_10_AS_DPS: BeginFillRoleAssignments(player, creature, 10); break;
            case ACTION_FILL_RAID_20_AS_TANK:
            case ACTION_FILL_RAID_20_AS_HEALER:
            case ACTION_FILL_RAID_20_AS_DPS: BeginFillRoleAssignments(player, creature, 20); break;
            case ACTION_FILL_RAID_40_AS_TANK:
            case ACTION_FILL_RAID_40_AS_HEALER:
            case ACTION_FILL_RAID_40_AS_DPS: BeginFillRoleAssignments(player, creature, 40); break;
            case ACTION_DISMISS_ALL:
                player->CLOSE_GOSSIP_MENU();
                RequestDismissOwner(player->GetGUIDLow());
                SendMessage(player, "Your temporary companions are being dismissed.");
                break;
            default:
                player->CLOSE_GOSSIP_MENU();
                break;
        }
        return true;
    }
};

class CompanionRecruiterWorld : public WorldScript
{
public:
    CompanionRecruiterWorld() : WorldScript("companion_recruiter_world", {WORLDHOOK_ON_UPDATE, WORLDHOOK_ON_STARTUP}) {}

    void OnStartup() override
    {
        EnsureRecruiterSpecPaths();
        LoadOwnedCompanions();
        QueryResult* result = CharacterDatabase.PQuery(
            "SELECT DISTINCT bot FROM ai_playerbot_random_bots WHERE owner = 0 AND event = 'companion_recruiter'");
        std::vector<uint32> staleBots;
        if (result)
        {
            do
            {
                staleBots.push_back(result->Fetch()[0].GetUInt32());
            } while (result->NextRow());
            delete result;
        }

        for (uint32 botGuid : staleBots)
            DeleteCompanion(botGuid);
        UpdateOwnedCompanions();
    }

    void OnUpdate(uint32 diff) override
    {
        gUpdateTimer += diff;
        if (gUpdateTimer < 1000)
            return;
        gUpdateTimer = 0;
        UpdateContracts();
        UpdateOwnedCompanions();
    }
};

class CompanionRecruiterPlayer : public PlayerScript
{
public:
    CompanionRecruiterPlayer() : PlayerScript("companion_recruiter_player",
        {PLAYERHOOK_ON_BEFORE_LOGOUT, PLAYERHOOK_ON_DELETE}) {}

    void OnBeforeLogout(Player* player) override
    {
        if (player)
            gFillRoleSessions.erase(player->GetGUIDLow());
        if (player && !GetBotAI(player))
        {
            RequestDismissOwner(player->GetGUIDLow());
            for (auto& pair : gOwnedCompanions)
                if (pair.second.ownerGuid == player->GetGUIDLow())
                    DismissOwnedCompanion(pair.second);
        }
    }

    void OnDelete(ObjectGuid guid, uint32 /*accountId*/) override
    {
        uint32 const ownerGuid = guid.GetCounter();
        gFillRoleSessions.erase(ownerGuid);
        std::vector<uint32> owned;
        for (auto const& pair : gOwnedCompanions)
            if (pair.second.ownerGuid == ownerGuid)
                owned.push_back(pair.first);
        for (uint32 botGuid : owned)
        {
            auto itr = gOwnedCompanions.find(botGuid);
            if (itr == gOwnedCompanions.end())
                continue;
            DismissOwnedCompanion(itr->second);
            CharacterDatabase.PExecute("DELETE FROM companion_recruiter_owned WHERE bot_guid = '%u'", botGuid);
            sRandomPlayerbotMgr.SetValue(botGuid, "companion_recruiter_owned", 0);
            DeleteCompanion(botGuid);
            gOwnedCompanions.erase(itr);
        }
    }
};

class CompanionRecruiterGroup : public GroupScript
{
public:
    CompanionRecruiterGroup() : GroupScript("companion_recruiter_group") {}

    bool CanMemberAccept(Group* group, Player* player) override
    {
        if (!group || !player)
            return true;
        auto owned = gOwnedCompanions.find(player->GetGUIDLow());
        if (owned == gOwnedCompanions.end())
            return true;

        Player* owner = ObjectAccessor::FindConnectedPlayer(
            ObjectGuid(HIGHGUID_PLAYER, owned->second.ownerGuid));
        if (!owner || (owner->GetGroup() != group &&
            (group->IsCreated() || group->GetLeaderGuid() != owner->GetObjectGuid())))
            return false;
        return group->IsLeader(owner->GetObjectGuid()) ||
            (group->isRaidGroup() && group->IsAssistant(owner->GetObjectGuid()));
    }

    void OnRemoveMember(Group* group, ObjectGuid guid, uint8 /*method*/) override
    {
        uint32 const removedGuid = guid.GetCounter();
        RequestDismiss(removedGuid);

        auto owned = gOwnedCompanions.find(removedGuid);
        if (owned != gOwnedCompanions.end())
            owned->second.invited = false;

        Player* removedPlayer = ObjectAccessor::FindConnectedPlayer(guid);
        if (removedPlayer && !GetBotAI(removedPlayer))
        {
            RequestDismissOwner(removedGuid);
            for (auto& pair : gOwnedCompanions)
                if (pair.second.ownerGuid == removedGuid)
                    pair.second.invited = false;
        }
    }

    void OnDisband(Group* group) override
    {
        if (!group)
            return;
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            if (Player* player = ref->getSource(); player && !GetBotAI(player))
            {
                RequestDismissOwner(player->GetGUIDLow());
                for (auto& pair : gOwnedCompanions)
                    if (pair.second.ownerGuid == player->GetGUIDLow())
                        pair.second.invited = false;
            }
    }
};
} // namespace

void Addmod_companion_recruiterScripts()
{
    new CompanionRecruiterNpc();
    new CompanionRecruiterWorld();
    new CompanionRecruiterPlayer();
    new CompanionRecruiterGroup();
}
