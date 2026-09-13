#include "ScriptObjects.h"
#include "ScriptedGossip.h"

#include "AiFactory.h"
#include "ChatHelper.h"
#include "Config/Config.h"
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
#include "strategy/Event.h"

#include <algorithm>
#include <array>
#include <chrono>
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
    ACTION_DISMISS_ALL
};

enum class PlayerRole : uint8
{
    Auto,
    Tank,
    Healer,
    Damage
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

// Gossip, player, group, and world update hooks all execute on the world thread.
std::map<uint32, CompanionContract> gContracts;
uint32 gUpdateTimer = 0;

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
    return uint32(std::max<int32>(1, sConfig.GetIntDefault("CompanionRecruiter.LifetimeMinutes", 60))) * 60u;
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

uint32 GetCompanionCost(Player const* player)
{
    struct CostPoint
    {
        uint32 level;
        uint32 copper;
    };

    static constexpr std::array<CostPoint, 6> curve = {{
        {10, 1 * SILVER},
        {20, 4 * SILVER},
        {30, 8 * SILVER},
        {40, 30 * SILVER},
        {50, 40 * SILVER},
        {60, 50 * SILVER}
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

void TrackCompanion(uint32 botGuid, uint32 ownerGuid, BotRoles role, uint8 cls, uint32 paidCost)
{
    CompanionContract contract;
    contract.botGuid = botGuid;
    contract.ownerGuid = ownerGuid;
    contract.paidCost = paidCost;
    contract.cls = cls;
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

bool CanInviteCompanion(Player* owner)
{
    Group* group = owner ? owner->GetGroup() : nullptr;
    if (!group)
    {
        if (1u + CountPendingGroupContracts(owner) >= MAX_GROUP_SIZE)
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
    if (group->GetMembersCount() + CountPendingGroupContracts(owner) >= capacity)
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

    BotRoles roles = AiFactory::GetPlayerRoles(player);
    if (roles & BOT_ROLE_TANK)
        return PlayerRole::Tank;
    if (roles & BOT_ROLE_HEALER)
        return PlayerRole::Healer;
    return PlayerRole::Damage;
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

RoleCounts GetCurrentRoles(Player* owner, PlayerRole ownerRole)
{
    RoleCounts counts;
    if (!owner)
        return counts;

    Group* group = owner->GetGroup();
    if (!group)
    {
        CountRole(counts, ownerRole == PlayerRole::Auto ? RoleForPlayer(owner) : ownerRole);
        for (auto const& pair : gContracts)
            if (IsPendingForRecruitingGroup(pair.second, owner))
                CountBotRole(counts, pair.second.role);
        return counts;
    }

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->getSource();
        if (!member)
            continue;
        if (member == owner && ownerRole != PlayerRole::Auto)
            CountRole(counts, ownerRole);
        else
            CountRole(counts, RoleForPlayer(member));
    }

    for (auto const& pair : gContracts)
        if (IsPendingForRecruitingGroup(pair.second, owner))
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

bool CreateCompanion(Player* owner, BotRoles role, uint8 forcedClass = 0)
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
    if (!CanInviteCompanion(owner))
        return false;

    uint32 const ownerGuid = owner->GetGUIDLow();
    if (CountOwnerContracts(ownerGuid) >= MaxCompanions())
    {
        SendMessage(owner, "You already command the maximum number of temporary companions.");
        return false;
    }

    uint32 const cost = GetCompanionCost(owner);
    if (owner->GetMoney() < cost)
    {
        SendMessage(owner, "You need " + FormatMoney(cost) + " to recruit a companion.");
        return false;
    }

    std::vector<uint8> const classPool = GetRoleClassPool(owner, role);
    uint8 cls = forcedClass;
    if (cls && (!IsClassAvailableToOwner(owner, cls) || !RandomPlayerbotFactory::isAvailableRole(cls, role)))
        cls = 0;
    if (!forcedClass && !classPool.empty())
        cls = classPool[urand(0, uint32(classPool.size() - 1))];
    if (!cls)
    {
        SendMessage(owner, "No class is available for that role.");
        return false;
    }

    std::ostringstream parameters;
    parameters << "level=" << uint32(owner->GetLevel())
               << " class=" << ChatHelper::formatClass(cls)
               << " role=" << ChatHelper::formatRole(role)
               << " group=" << owner->GetName()
               << " login=false";

    std::list<std::string> messages;
    ObjectGuid botGuid;
    sRandomPlayerbotMgr.CreateBot(owner, parameters.str(), messages, botGuid, "companion_recruiter");
    if (!botGuid)
    {
        SendMessage(owner, messages.empty() ? "Companion creation failed." : messages.back());
        return false;
    }

    uint32 const botGuidLow = botGuid.GetCounter();
    sRandomPlayerbotMgr.SetExternallyManaged(botGuidLow, true);
    sRandomPlayerbotMgr.SetValue(botGuidLow, "companion_recruiter", ownerGuid, "", int32(LifetimeSeconds()));
    TrackCompanion(botGuidLow, ownerGuid, role, cls, cost);
    owner->LogModifyMoney(-int32(cost), "CompanionRecruiter");
    sRandomPlayerbotMgr.AddPlayerBot(botGuidLow, 0);

    SendMessage(owner, "A " + ChatHelper::formatRole(role) + " companion is on the way. Contract price: " +
        FormatMoney(cost) + ".");
    return true;
}

uint32 CurrentGroupSize(Player* owner)
{
    uint32 const actual = owner && owner->GetGroup() ? owner->GetGroup()->GetMembersCount() : 1u;
    return actual + CountPendingGroupContracts(owner);
}

bool FillGroup(Player* owner, PlayerRole ownerRole, uint32 targetSize)
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
    uint64 const totalCost = uint64(GetCompanionCost(owner)) * toCreate;
    if (owner->GetMoney() < totalCost)
    {
        SendMessage(owner, "You need " + FormatMoney(uint32(totalCost)) + " to fill those slots.");
        return false;
    }

    RoleCounts counts = GetCurrentRoles(owner, ownerRole);
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

void SendMainMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->ClearMenus();
    std::string const price = FormatMoney(GetCompanionCost(player));
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a tank companion (" + price + ")", ACTION_RECRUIT_TANK);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a healer companion (" + price + ")", ACTION_RECRUIT_HEALER);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Recruit a damage companion (" + price + ")", ACTION_RECRUIT_DPS);
    AddMenuItem(player, GOSSIP_ICON_MONEY_BAG,
        "Fill my party with temporary companions (" + FillCost(player, 5) + ")", ACTION_FILL_PARTY_MENU);
    if (player->GetGroup() && player->GetGroup()->isRaidGroup())
        AddMenuItem(player, GOSSIP_ICON_MONEY_BAG, "Fill my raid with temporary companions", ACTION_FILL_RAID_MENU);
    if (CountOwnerContracts(player->GetGUIDLow()))
        AddMenuItem(player, GOSSIP_ICON_CHAT, "Dismiss all my temporary companions", ACTION_DISMISS_ALL);
    SendMenu(player, creature);
}

void SendRoleMenu(Player* player, Creature* creature, uint32 targetSize, uint32 firstAction)
{
    player->PlayerTalkClass->ClearMenus();
    std::string const suffix = " Fill to " + std::to_string(targetSize) + " members (" + FillCost(player, targetSize) + ").";
    AddMenuItem(player, GOSSIP_ICON_CHAT, "I am the tank." + suffix, firstAction);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "I am the healer." + suffix, firstAction + 1);
    AddMenuItem(player, GOSSIP_ICON_CHAT, "I am damage." + suffix, firstAction + 2);
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

bool PrepareOnlineCompanion(CompanionContract& contract, Player* bot, PlayerbotAI* ai)
{
    ai->SetForcedRole(uint8(contract.role));
    if (bot->GetLevel() >= 10 && !(AiFactory::GetPlayerRoles(bot) & contract.role))
        return false;

    PlayerbotFactory factory(bot, bot->GetLevel());
    factory.InitializeAtCurrentLevel();

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
                messages.emplace_back(owner, "A companion could not fulfill its requested role; its contract price was refunded.");
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
        switch (action)
        {
            case ACTION_RECRUIT_TANK: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_TANK); break;
            case ACTION_RECRUIT_HEALER: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_HEALER); break;
            case ACTION_RECRUIT_DPS: player->CLOSE_GOSSIP_MENU(); CreateCompanion(player, BOT_ROLE_DPS); break;
            case ACTION_FILL_PARTY_MENU:
                SendRoleMenu(player, creature, 5, ACTION_FILL_PARTY_AS_TANK);
                break;
            case ACTION_FILL_RAID_MENU:
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 10-player raid (" + FillCost(player, 10) + ")", ACTION_FILL_RAID_10);
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 20-player raid (" + FillCost(player, 20) + ")", ACTION_FILL_RAID_20);
                AddMenuItem(player, GOSSIP_ICON_CHAT, "Fill a 40-player raid (" + FillCost(player, 40) + ")", ACTION_FILL_RAID_40);
                SendMenu(player, creature);
                break;
            case ACTION_FILL_RAID_10: SendRoleMenu(player, creature, 10, ACTION_FILL_RAID_10_AS_TANK); break;
            case ACTION_FILL_RAID_20: SendRoleMenu(player, creature, 20, ACTION_FILL_RAID_20_AS_TANK); break;
            case ACTION_FILL_RAID_40: SendRoleMenu(player, creature, 40, ACTION_FILL_RAID_40_AS_TANK); break;
            case ACTION_FILL_PARTY_AS_TANK: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Tank, 5); break;
            case ACTION_FILL_PARTY_AS_HEALER: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Healer, 5); break;
            case ACTION_FILL_PARTY_AS_DPS: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Damage, 5); break;
            case ACTION_FILL_RAID_10_AS_TANK: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Tank, 10); break;
            case ACTION_FILL_RAID_10_AS_HEALER: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Healer, 10); break;
            case ACTION_FILL_RAID_10_AS_DPS: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Damage, 10); break;
            case ACTION_FILL_RAID_20_AS_TANK: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Tank, 20); break;
            case ACTION_FILL_RAID_20_AS_HEALER: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Healer, 20); break;
            case ACTION_FILL_RAID_20_AS_DPS: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Damage, 20); break;
            case ACTION_FILL_RAID_40_AS_TANK: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Tank, 40); break;
            case ACTION_FILL_RAID_40_AS_HEALER: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Healer, 40); break;
            case ACTION_FILL_RAID_40_AS_DPS: player->CLOSE_GOSSIP_MENU(); FillGroup(player, PlayerRole::Damage, 40); break;
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
    }

    void OnUpdate(uint32 diff) override
    {
        gUpdateTimer += diff;
        if (gUpdateTimer < 1000)
            return;
        gUpdateTimer = 0;
        UpdateContracts();
    }
};

class CompanionRecruiterPlayer : public PlayerScript
{
public:
    CompanionRecruiterPlayer() : PlayerScript("companion_recruiter_player", {PLAYERHOOK_ON_BEFORE_LOGOUT}) {}

    void OnBeforeLogout(Player* player) override
    {
        if (player && !GetBotAI(player))
            RequestDismissOwner(player->GetGUIDLow());
    }
};

class CompanionRecruiterGroup : public GroupScript
{
public:
    CompanionRecruiterGroup() : GroupScript("companion_recruiter_group") {}

    void OnRemoveMember(Group* group, ObjectGuid guid, uint8 /*method*/) override
    {
        uint32 const removedGuid = guid.GetCounter();
        RequestDismiss(removedGuid);

        Player* removedPlayer = ObjectAccessor::FindConnectedPlayer(guid);
        if (removedPlayer && !GetBotAI(removedPlayer))
            RequestDismissOwner(removedGuid);
    }

    void OnDisband(Group* group) override
    {
        if (!group)
            return;
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            if (Player* player = ref->getSource(); player && !GetBotAI(player))
                RequestDismissOwner(player->GetGUIDLow());
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
