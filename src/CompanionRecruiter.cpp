#include "ScriptObjects.h"

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
#include <mutex>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

namespace
{
using Clock = std::chrono::steady_clock;

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
    BotRoles role = BOT_ROLE_DPS;
    Clock::time_point expiresAt;
    Clock::time_point graceExpiresAt{};
    bool initialized = false;
    uint8 warningMask = 0;
};

std::mutex gContractsLock;
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

    return uint32(float(base) * CostMultiplier());
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
    player->PlayerTalkClass->GetGossipMenu().AddMenuItem(icon, text, GOSSIP_SENDER_MAIN, action);
}

void SendMenu(Player* player, Creature* creature)
{
    player->PlayerTalkClass->SendGossipMenu(900100, creature->GetObjectGuid());
}

uint32 CountOwnerContracts(uint32 ownerGuid)
{
    std::lock_guard<std::mutex> guard(gContractsLock);
    return uint32(std::count_if(gContracts.begin(), gContracts.end(), [ownerGuid](auto const& pair)
    {
        return pair.second.ownerGuid == ownerGuid;
    }));
}

void TrackCompanion(uint32 botGuid, uint32 ownerGuid, BotRoles role)
{
    CompanionContract contract;
    contract.botGuid = botGuid;
    contract.ownerGuid = ownerGuid;
    contract.role = role;
    contract.expiresAt = Clock::now() + std::chrono::seconds(LifetimeSeconds());

    std::lock_guard<std::mutex> guard(gContractsLock);
    gContracts[botGuid] = contract;
}

void RequestDismiss(uint32 botGuid)
{
    if (!botGuid)
        return;

    std::lock_guard<std::mutex> guard(gContractsLock);
    auto itr = gContracts.find(botGuid);
    if (itr != gContracts.end())
        itr->second.expiresAt = Clock::time_point::min();
}

void RequestDismissOwner(uint32 ownerGuid)
{
    if (!ownerGuid)
        return;

    std::lock_guard<std::mutex> guard(gContractsLock);
    for (auto& pair : gContracts)
        if (pair.second.ownerGuid == ownerGuid)
            pair.second.expiresAt = Clock::time_point::min();
}

void DeleteCompanion(uint32 botGuid)
{
    if (!botGuid)
        return;

    sRandomPlayerbotMgr.SetExternallyManaged(botGuid, false);
    sRandomPlayerbotMgr.DeleteBot(ObjectGuid(HIGHGUID_PLAYER, botGuid));
    CharacterDatabase.PExecute(
        "DELETE FROM ai_playerbot_random_bots WHERE owner = 0 AND bot = '%u' AND event IN ('companion_recruiter','temporary')",
        botGuid);
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

void CountRole(RoleCounts& counts, PlayerRole role)
{
    switch (role)
    {
        case PlayerRole::Tank: ++counts.tanks; break;
        case PlayerRole::Healer: ++counts.healers; break;
        default: ++counts.damage; break;
    }
}

RoleCounts GetCurrentRoles(Player* owner, PlayerRole ownerRole)
{
    RoleCounts counts;
    if (!owner)
        return counts;

    Group* group = owner->GetGroup();
    if (!group)
    {
        CountRole(counts, ownerRole == PlayerRole::Auto ? RoleForPlayer(owner) : ownerRole);
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
    return counts;
}

bool CreateCompanion(Player* owner, BotRoles role)
{
    if (!owner || !owner->GetSession())
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

    RandomPlayerbotFactory classPicker(0);
    uint8 const cls = classPicker.GetRandomClass(0, role);
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
    sRandomPlayerbotMgr.CreateBot(owner, parameters.str(), messages, botGuid);
    if (!botGuid)
    {
        SendMessage(owner, messages.empty() ? "Companion creation failed." : messages.back());
        return false;
    }

    uint32 const botGuidLow = botGuid.GetCounter();
    owner->ModifyMoney(-int32(cost));
    sRandomPlayerbotMgr.SetExternallyManaged(botGuidLow, true);
    sRandomPlayerbotMgr.SetValue(botGuidLow, "companion_recruiter", ownerGuid, "", int32(LifetimeSeconds()));
    TrackCompanion(botGuidLow, ownerGuid, role);
    sRandomPlayerbotMgr.AddPlayerBot(botGuidLow, 0);

    SendMessage(owner, "A " + ChatHelper::formatRole(role) + " companion is on the way. Contract price: " +
        FormatMoney(cost) + ".");
    return true;
}

uint32 CurrentGroupSize(Player* owner)
{
    return owner && owner->GetGroup() ? owner->GetGroup()->GetMembersCount() : 1u;
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

    while (created < toCreate)
    {
        BotRoles role = BOT_ROLE_DPS;
        if (counts.tanks < desiredTanks)
            role = BOT_ROLE_TANK;
        else if (counts.healers < desiredHealers)
            role = BOT_ROLE_HEALER;

        if (!CreateCompanion(owner, role))
            break;

        if (role == BOT_ROLE_TANK)
            ++counts.tanks;
        else if (role == BOT_ROLE_HEALER)
            ++counts.healers;
        else
            ++counts.damage;
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

void InitializeOnlineCompanion(CompanionContract& contract, Player* owner, Player* bot)
{
    PlayerbotAI* ai = GetBotAI(bot);
    if (!ai || !owner)
        return;

    ai->SetMaster(owner);
    ai->SetForcedRole(uint8(contract.role));
    ai->ResetStrategies();

    if (!owner->IsInGroup(bot, true))
        ai->DoSpecificAction("join", ai::Event("companion recruiter", "", owner), true);

    if (bot->GetMapId() != owner->GetMapId() || bot->GetDistance(owner) > 160.0f)
        bot->TeleportTo(owner->GetMapId(), owner->GetPositionX(), owner->GetPositionY(), owner->GetPositionZ(),
            owner->GetOrientation());

    contract.initialized = true;
}

void UpdateContracts()
{
    Clock::time_point const now = Clock::now();
    std::vector<uint32> deletes;
    std::vector<std::pair<Player*, std::string>> messages;

    {
        std::lock_guard<std::mutex> guard(gContractsLock);
        for (auto& pair : gContracts)
        {
            CompanionContract& contract = pair.second;
            Player* owner = ObjectAccessor::FindConnectedPlayer(ObjectGuid(HIGHGUID_PLAYER, contract.ownerGuid));
            if (!owner)
            {
                deletes.push_back(contract.botGuid);
                continue;
            }

            Player* bot = sRandomPlayerbotMgr.GetPlayerBot(contract.botGuid);
            if (bot && !contract.initialized)
                InitializeOnlineCompanion(contract, owner, bot);

            if (contract.expiresAt == Clock::time_point::min())
            {
                deletes.push_back(contract.botGuid);
                continue;
            }

            auto const remaining = std::chrono::duration_cast<std::chrono::seconds>(contract.expiresAt - now).count();
            struct Warning { int64 seconds; uint8 bit; uint32 minutes; };
            static constexpr Warning warnings[] = {{600, 1, 10}, {300, 2, 5}, {60, 4, 1}};
            for (Warning const& warning : warnings)
            {
                if (remaining <= warning.seconds && remaining > 0 && !(contract.warningMask & warning.bit))
                {
                    contract.warningMask |= warning.bit;
                    messages.emplace_back(owner, "Your temporary companion contract expires in " +
                        std::to_string(warning.minutes) + (warning.minutes == 1 ? " minute." : " minutes."));
                }
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
    }

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
        if (sender != GOSSIP_SENDER_MAIN || !IsEnabled())
            return true;

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
