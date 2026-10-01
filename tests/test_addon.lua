-- Exercise the real addon with a small mock of the Vanilla frame/gossip API.
table.getn = function(t) return #t end
math.mod = math.fmod
unpack = table.unpack
local methods = {}
local frames = {}
local function noop() end
local function frame(name, parent)
    local f = setmetatable({ name = name, parent = parent, visible = true, scripts = {}, enabled = true }, { __index = methods })
    table.insert(frames, f)
    if name then _G[name] = f end
    return f
end
for _, name in ipairs({"SetPoint", "ClearAllPoints", "SetAllPoints", "SetBackdrop", "SetBackdropColor",
    "SetBackdropBorderColor", "SetTexCoord", "SetTexture", "SetVertexColor", "SetTextColor",
    "SetJustifyH", "SetJustifyV", "RegisterEvent", "RegisterForDrag", "SetFrameStrata",
    "SetMovable", "SetHighlightTexture", "StartMoving", "StopMovingOrSizing", "SetOwner",
    "SetVerticalScroll", "AddMessage", "SetShadowOffset", "SetShadowColor", "SetFont"}) do methods[name] = noop end
function methods:GetFont() return "Fonts\\FRIZQT__.TTF", 12, "" end
function methods:CreateTexture(name) return frame(name, self) end
function methods:CreateFontString(name) return frame(name, self) end
function methods:SetWidth(value) self.width = value end
function methods:SetHeight(value) self.height = value end
function methods:SetText(value) self.text = value end
function methods:GetStringWidth() return #(self.text or "") * 6 end
function methods:SetAlpha(value) self.alpha = value end
function methods:EnableMouse(value) self.mouse = value end
function methods:SetFrameLevel(value) self.level = value end
function methods:GetFrameLevel() return self.level or 0 end
function methods:GetName() return self.name end
function methods:SetScript(name, callback) self.scripts[name] = callback end
function methods:GetScript(name) return self.scripts[name] end
function methods:SetScrollChild(child) self.scrollChild = child end
function methods:SetNormalTexture() self.normalTexture = frame(nil, self) end
function methods:GetNormalTexture() return self.normalTexture end
function methods:Enable() self.enabled = true end
function methods:Disable() self.enabled = false end
function methods:Show() self.visible = true end
function methods:Hide()
    local wasVisible = self.visible
    self.visible = false
    if wasVisible and self.scripts.OnHide then self.scripts.OnHide() end
end
function methods:IsShown() return self.visible end
CreateFrame = function(_, name, parent) return frame(name, parent) end
getglobal = function(name) return _G[name] or frame(name) end
UIParent, GossipFrame, GameTooltip, UIErrorsFrame = frame("UIParent"), frame("GossipFrame"), frame("GameTooltip"), frame("UIErrorsFrame")
GossipFrame:Hide()
GossipFrame:SetScript("OnEvent", function()
    if event == "GOSSIP_SHOW" then
        GossipFrame:Show()
        GossipFrame:SetAlpha(1)
        GossipFrame:EnableMouse(true)
    elseif event == "GOSSIP_CLOSED" then
        GossipFrame:Hide()
    end
end)
StaticPopupDialogs, UISpecialFrames, SlashCmdList = {}, {}, {}
CANCEL = "Cancel"
UnitFactionGroup = function() return "Alliance" end
GetNumRaidMembers = function() return 0 end
UnitName = function() return "Owner" end
UnitClass = function() return "Druid", "DRUID" end
UnitRace = function() return "Night Elf", "NightElf" end
local gossip, selected, popup = {}, nil, nil
GetGossipOptions = function()
    local result = {}
    for _, text in ipairs(gossip) do table.insert(result, text); table.insert(result, "gossip") end
    return unpack(result)
end
SelectGossipOption = function(index) selected = gossip[index] end
CloseGossip = function()
    event = "GOSSIP_CLOSED"
    CompanionRecruiterAddon.scripts.OnEvent()
    GossipFrame.scripts.OnEvent()
end
StaticPopup_Show = function(name) popup = name end
assert(loadfile(arg[1]))()
local function upvalue(fn, key)
    for index = 1, 200 do
        local name, value = debug.getupvalue(fn, index)
        if not name then break end
        if name == key then return value end
    end
    error("Missing upvalue: " .. key)
end
local sync = upvalue(CompanionRecruiterAddon.scripts.OnEvent, "SyncMenu")
local showPage = upvalue(sync, "ShowPage")
local pages = upvalue(showPage, "pages")
local refreshRoster = upvalue(showPage, "RefreshManageRows")
local rows = upvalue(refreshRoster, "manageRows")
local tabs = upvalue(showPage, "tabs")
local updatePicker = upvalue(sync, "UpdatePicker")
local classButtons = upvalue(updatePicker, "pickerClassButtons")
local specButtons = upvalue(updatePicker, "pickerSpecButtons")
local raceButtons = upvalue(updatePicker, "pickerRaceButtons")
local mainMenu = {"Recruit a tank companion (1g 0s 0c)", "Choose a companion's class and specialization (1g 0s 0c)",
    "Fill my party with temporary companions (4g 0s 0c)", "Permanent Recruitment", "Manage Companions (20)"}
local function menu(options, stockFirst)
    assert(#options <= 15, "Fixture exceeds the Vanilla gossip packet limit")
    gossip = options
    event = "GOSSIP_SHOW"
    -- Exercise both possible orders of the two frames' event handlers.
    if stockFirst then GossipFrame.scripts.OnEvent() end
    CompanionRecruiterAddon.scripts.OnEvent()
    if not stockFirst then GossipFrame.scripts.OnEvent() end
end
local function click(f) assert(f.scripts.OnClick, "Not clickable"); selected = nil; f.scripts.OnClick() end
local function clickTab(name)
    -- Navigation tabs store their clickable button in their panel.
    for _, f in ipairs(frames) do
        if f.parent == tabs[name].panel and f.scripts.OnClick then click(f); return end
    end
    if tabs[name].panel.scripts.OnClick then click(tabs[name].panel); return end
    error("Tab button missing: " .. name)
end
local function rosterRow(name) return name .. " - Druid / Feral (Damage) / dps / Night Elf / Female [Stored]" end
menu(mainMenu)
assert(CompanionRecruiterWindow:IsShown(), "Main menu did not open")
assert(not GossipFrame:IsShown(), "Native gossip opened for the recruiter")
clickTab("manage")
assert(selected == "Manage Companions (20)")
-- Also support a roster menu sent by the earlier server without a Back option.
menu({rosterRow("Cat"), "Remove companion: Cat", "More companions", "Buy another companion"})
assert(CompanionRecruiterWindow:IsShown() and pages.manage:IsShown(), "Roster closed the addon")
assert(GossipFrame.alpha == 0, "Roster fell back to ordinary gossip")
assert(#rows == 1 and rows[1].companionName == "Cat", "Navigation appeared as companions")
click(rows[1].button)
assert(selected == rosterRow("Cat"), "Invite selected the wrong gossip index")
click(upvalue(refreshRoster, "manageNext"))
assert(selected == "More companions", "Next page did not select the server action")
menu({rosterRow("Bear"), "Remove companion: Bear", "Previous companions", "Buy another companion", "Back to recruiter"})
assert(rows[1].companionName == "Bear")
click(upvalue(refreshRoster, "managePrevious"))
assert(selected == "Previous companions")
menu({"You do not own any companions yet.", "Buy another companion", "Back to recruiter"})
assert(not rows[1]:IsShown() and upvalue(refreshRoster, "manageEmptyText"):IsShown(), "Empty roster is not empty")
clickTab("permanent")
assert(selected == "Back to recruiter", "Cannot leave the roster through the tabs")
menu(mainMenu)
assert(selected == "Permanent Recruitment", "Pending tab navigation failed")
menu({"Warrior", "Druid", "Arms (75g 0s 0c)", "Race: Human (75g 0s 0c)", "Recruit permanent companion", "Back to recruiter"})
click(classButtons.Druid.button)
assert(selected == "Druid")
menu({"Warrior", "Druid", "Balance (75g 0s 0c)", "Feral (Tank) (75g 0s 0c)", "Feral (Damage) (75g 0s 0c)",
    "Restoration (75g 0s 0c)", "Race: Night Elf (75g 0s 0c)", "Recruit permanent companion", "Back to recruiter"})
assert(specButtons[3].button.mouse, "Feral damage is disabled")
click(specButtons[3].button)
assert(selected == "Feral (Damage) (75g 0s 0c)", "Feral damage selects the wrong spec")
menu(gossip)
click(raceButtons["Night Elf"].button)
menu(gossip)
local recruit = upvalue(updatePicker, "pickerRecruit")
assert(recruit.enabled, "Valid permanent selection cannot be purchased")
click(recruit)
assert(selected == "Recruit permanent companion")
CloseGossip()
menu(mainMenu)
menu({"Warrior", "Druid", "Arms", "Back to recruiter"})
click(classButtons.Druid.button)
menu({"Balance", "Feral (Tank)", "Feral (Damage)", "Restoration", "Choose another class", "Back to recruiter"})
assert(specButtons[3].button.mouse, "Temporary Feral damage is disabled")
click(specButtons[3].button)
click(recruit)
assert(selected == "Feral (Damage)", "Temporary Feral damage did not recruit")
CloseGossip()
-- A permanent menu must identify itself even if the client closed the old gossip.
menu({"Warrior", "Druid", "Arms (75g 0s 0c)", "Race: Human (75g 0s 0c)",
    "Recruit permanent companion", "Back to recruiter"})
assert(CompanionRecruiterWindow:IsShown() and pages.picker:IsShown(), "Permanent menu fell back to gossip after closing")
assert(GossipFrame.alpha == 0 and not GossipFrame.mouse, "Permanent gossip is still visible or clickable")
assert(not GossipFrame:IsShown(), "Native permanent gossip opened behind the addon")
assert(upvalue(sync, "mode") == "permanent", "Permanent menu retained the temporary mode")
CloseGossip()
menu({"Warrior", "Arms (75g 0s 0c)", "Race: Human (75g 0s 0c)",
    "Recruit permanent companion", "Back to recruiter"}, true)
assert(pages.picker:IsShown() and not GossipFrame:IsShown(), "Stock-first permanent menu opened native gossip")
CloseGossip()
menu({"Innkeeper services", "Make this inn your home"})
assert(not CompanionRecruiterWindow:IsShown(), "Unrelated gossip opened the addon")
assert(GossipFrame:IsShown() and GossipFrame.alpha == 1 and GossipFrame.mouse, "Unrelated gossip was suppressed")
local costDisplay = upvalue(updatePicker, "pickerCost")
for _, sample in ipairs({
    {"Cost: 75g 0s 0c", "Cost: ", {"75", false, false}},
    {"Total: 7388g 95s 30c", "Total: ", {"7388", "95", "30"}},
    {"0g 30s 0c", "", {false, "30", false}},
    {"0g 0s 5c", "", {false, false, "5"}},
    {"Cost: 0g 0s 0c", "Cost: ", {false, false, "0"}},
    {"Total: full", "Total: full", {false, false, false}},
    {"", "", {false, false, false}}
}) do
    costDisplay:SetText(sample[1])
    assert(costDisplay.label.text == sample[2], "Money prefix or non-price message changed")
    for i = 1, 3 do
        local coin = costDisplay.coins[i]
        local expected = sample[3][i]
        assert(coin.icon:IsShown() == (expected ~= false), "Wrong coin denomination is visible")
        assert(coin.amount:IsShown() == (expected ~= false), "Stale money amount remained visible")
        if expected then assert(coin.amount.text == expected, "Displayed money amount changed") end
    end
end
print("PASS: coin amounts, gold/silver/copper textures, omitted zero denominations, free/empty/full prices")
if arg[2] then
    local serverMenus = assert(loadfile(arg[2]))()
    local function pickerOnly()
        assert(CompanionRecruiterWindow:IsShown() and pages.picker:IsShown(), "Recruitment left the addon picker")
        assert(not pages.main:IsShown() and not pages.manage:IsShown(), "Another addon page remained visible")
        assert(not GossipFrame:IsShown(), "A C++ recruiter response opened native gossip")
    end
    for _, faction in ipairs({"Alliance", "Horde"}) do
        UnitFactionGroup = function() return faction end
        for _, stockFirst in ipairs({false, true}) do
            CloseGossip()
            menu(mainMenu, stockFirst)
            clickTab("permanent")
            assert(selected == "Permanent Recruitment")
            menu(serverMenus[faction .. "_classes"], stockFirst)
            assert(selected == "Warrior", "Class catalogue did not automatically request default details")
            pickerOnly()
            menu(serverMenus[faction .. "_1"], stockFirst)
            pickerOnly()
            assert(raceButtons[faction == "Horde" and "Orc" or "Human"].canSelect,
                   "Default class did not receive selectable races")
            assert(classButtons.Druid.button.mouse, "Class catalogue was lost when loading details")
            -- Change class through two server responses while staying on the same page.
            click(classButtons.Druid.button)
            assert(selected == "Choose another class", "Class change did not request the catalogue")
            assert(classButtons.Druid.iconBorder:IsShown() and not classButtons.Warrior.iconBorder:IsShown(),
                   "Class selection flashed back to Warrior while awaiting the catalogue")
            menu(serverMenus[faction .. "_classes"], stockFirst)
            assert(selected == "Druid", "Pending class change reverted to the default class")
            assert(classButtons.Druid.iconBorder:IsShown() and not classButtons.Warrior.iconBorder:IsShown(),
                   "Class selection changed while awaiting the requested class details")
            pickerOnly()
            local details = serverMenus[faction .. "_11"]
            menu(details, stockFirst)
            pickerOnly()
            assert(not recruit.enabled, "Changing class retained a stale purchase selection")
            assert(specButtons[3].button.mouse, "Server's Feral Damage choice is unavailable")
            click(specButtons[3].button)
            assert(selected == "Feral (Damage) (75g 0s 0c)")
            menu(details, stockFirst)
            pickerOnly()
            local race = faction == "Horde" and "Tauren" or "Night Elf"
            click(raceButtons[race].button)
            assert(selected == "Race: " .. race .. " (75g 0s 0c)")
            menu(details, stockFirst)
            pickerOnly()
            assert(recruit.enabled, "Complete permanent selection cannot be purchased")
            click(recruit)
            assert(selected == "Recruit permanent companion", "Purchase selected the wrong server action")
        end
    end
    CloseGossip()
    print("PASS: actual C++ class/detail responses, Alliance/Horde, automatic default, class switching, spec/race selection and purchase, addon-only UI in both event orders")
end
print("PASS: roster, empty roster, pagination, tab navigation, permanent/temporary Feral damage, permanent menu after close, both event orders, native frame suppression, unrelated gossip")
