-- Vanilla 1.12 / Lua 5.0. The server gossip menu is the source of truth.
local CR = CreateFrame("Frame", "CompanionRecruiterAddon", UIParent)
CR:RegisterEvent("GOSSIP_SHOW")
CR:RegisterEvent("GOSSIP_CLOSED")

local classNames = { "Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid" }
local availableRolesByClass = {
    Warrior = { Tank = true, Damage = true },
    Paladin = { Tank = true, Healer = true, Damage = true },
    Hunter = { Damage = true },
    Rogue = { Damage = true },
    Priest = { Healer = true, Damage = true },
    Shaman = { Healer = true, Damage = true },
    Mage = { Damage = true },
    Warlock = { Damage = true },
    Druid = { Tank = true, Healer = true, Damage = true }
}
local function IsRoleAvailableForClass(className, roleName)
    return availableRolesByClass[className] and availableRolesByClass[className][roleName] or false
end
local classIconTexture = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
local classIconCoords = {
    WARRIOR = { 0, 0.25, 0, 0.25 },
    MAGE = { 0.25, 0.49609375, 0, 0.25 },
    ROGUE = { 0.49609375, 0.7421875, 0, 0.25 },
    DRUID = { 0.7421875, 0.98828125, 0, 0.25 },
    HUNTER = { 0, 0.25, 0.25, 0.5 },
    SHAMAN = { 0.25, 0.49609375, 0.25, 0.5 },
    PRIEST = { 0.49609375, 0.7421875, 0.25, 0.5 },
    WARLOCK = { 0.7421875, 0.98828125, 0.25, 0.5 },
    PALADIN = { 0, 0.25, 0.5, 0.75 }
}
local function SetClassIcon(texture, className)
    local coords = className and classIconCoords[string.upper(className)]
    if not coords then
        texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        texture:SetTexCoord(0, 1, 0, 1)
        return
    end
    texture:SetTexture(classIconTexture)
    texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
end
local raceIconTexture = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-RACES"
local raceIconCoords = {
    HUMAN = { male = { 0, 0.125, 0, 0.25 }, female = { 0, 0.125, 0.5, 0.75 } },
    DWARF = { male = { 0.125, 0.25, 0, 0.25 }, female = { 0.125, 0.25, 0.5, 0.75 } },
    GNOME = { male = { 0.25, 0.375, 0, 0.25 }, female = { 0.25, 0.375, 0.5, 0.75 } },
    NIGHTELF = { male = { 0.375, 0.5, 0, 0.25 }, female = { 0.375, 0.5, 0.5, 0.75 } },
    HIGH_ELF = { male = { 0.5, 0.625, 0.25, 0.5 }, female = { 0.5, 0.625, 0.75, 1 } },
    TAUREN = { male = { 0, 0.125, 0.25, 0.5 }, female = { 0, 0.125, 0.75, 1 } },
    SCOURGE = { male = { 0.125, 0.25, 0.25, 0.5 }, female = { 0.125, 0.25, 0.75, 1 } },
    TROLL = { male = { 0.25, 0.375, 0.25, 0.5 }, female = { 0.25, 0.375, 0.75, 1 } },
    ORC = { male = { 0.375, 0.5, 0.25, 0.5 }, female = { 0.375, 0.5, 0.75, 1 } },
    GOBLIN = { male = { 0.5, 0.625, 0, 0.25 }, female = { 0.5, 0.625, 0.5, 0.75 } }
}
local raceIconNames = { ["Night Elf"] = "NIGHTELF", ["High Elf"] = "HIGH_ELF", Undead = "SCOURGE" }
local raceNames = { "Human", "Dwarf", "Gnome", "Night Elf", "High Elf", "Orc", "Undead", "Tauren", "Troll", "Goblin" }
local factionRaceNames = {
    Alliance = { ["Human"] = true, ["Dwarf"] = true, ["Gnome"] = true, ["Night Elf"] = true, ["High Elf"] = true },
    Horde = { ["Orc"] = true, ["Undead"] = true, ["Tauren"] = true, ["Troll"] = true, ["Goblin"] = true }
}
local classRaceNames = {
    Warrior = { Human = true, Dwarf = true, Gnome = true, ["Night Elf"] = true, ["High Elf"] = true,
        Orc = true, Undead = true, Tauren = true, Troll = true, Goblin = true },
    Paladin = { Human = true, Dwarf = true, ["High Elf"] = true },
    Hunter = { Human = true, Dwarf = true, ["Night Elf"] = true, ["High Elf"] = true,
        Orc = true, Tauren = true, Troll = true, Goblin = true },
    Rogue = { Human = true, Dwarf = true, Gnome = true, ["Night Elf"] = true, ["High Elf"] = true,
        Orc = true, Undead = true, Troll = true, Goblin = true },
    Priest = { Human = true, Dwarf = true, ["Night Elf"] = true, ["High Elf"] = true,
        Undead = true, Troll = true },
    Shaman = { Orc = true, Tauren = true, Troll = true },
    Mage = { Human = true, Gnome = true, ["High Elf"] = true, Undead = true, Troll = true, Goblin = true },
    Warlock = { Human = true, Gnome = true, Orc = true, Undead = true, Goblin = true },
    Druid = { ["Night Elf"] = true, Tauren = true }
}
local allianceRaceTokens = { HUMAN = true, DWARF = true, GNOME = true, NIGHTELF = true, HIGHELF = true }
local hordeRaceTokens = { ORC = true, SCOURGE = true, UNDEAD = true, TAUREN = true, TROLL = true, GOBLIN = true }
local function CurrentFactionGroup()
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    if factionRaceNames[faction] then return faction end

    if UnitRace then
        local localizedRace, raceToken = UnitRace("player")
        local token = string.upper(string.gsub(raceToken or localizedRace or "", "[^%a]", ""))
        if allianceRaceTokens[token] then return "Alliance" end
        if hordeRaceTokens[token] then return "Horde" end
    end
    return nil
end
local function IsRaceInCurrentFaction(raceName)
    local faction = CurrentFactionGroup()
    return factionRaceNames[faction] and factionRaceNames[faction][raceName] or false
end
local function IsRaceAvailableForClass(className, raceName)
    return classRaceNames[className] and classRaceNames[className][raceName] or false
end
local function SetRaceGenderIcon(texture, raceName, genderName)
    local key = raceIconNames[raceName] or string.upper(raceName or "")
    local gender = string.lower(genderName or "male")
    local coords = raceIconCoords[key] and raceIconCoords[key][gender]
    if not coords then
        texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        texture:SetTexCoord(0, 1, 0, 1)
        return
    end
    texture:SetTexture(raceIconTexture)
    texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
end
local roleIcons = {
    Tank = "Interface\\Icons\\INV_Shield_06",
    Healer = "Interface\\Icons\\Spell_Holy_HolyBolt",
    Damage = "Interface\\Icons\\INV_Sword_04"
}
local specializationOptions = {
    Warrior = {
        { name = "Arms", icon = "Interface\\Icons\\Ability_Warrior_Charge" },
        { name = "Fury", icon = "Interface\\Icons\\Ability_Warrior_InnerRage" },
        { name = "Protection", icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance" }
    },
    Paladin = {
        { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_HolyBolt" },
        { name = "Protection", icon = "Interface\\Icons\\Spell_Holy_DevotionAura" },
        { name = "Retribution", icon = "Interface\\Icons\\Spell_Holy_AuraOfLight" }
    },
    Hunter = {
        { name = "Beast Mastery", icon = "Interface\\Icons\\Ability_Hunter_BeastTaming" },
        { name = "Marksmanship", icon = "Interface\\Icons\\Ability_Hunter_AimedShot" },
        { name = "Survival", icon = "Interface\\Icons\\Ability_Hunter_SwiftStrike" }
    },
    Rogue = {
        { name = "Assassination", icon = "Interface\\Icons\\Ability_Rogue_Eviscerate" },
        { name = "Combat", icon = "Interface\\Icons\\Ability_Backstab" },
        { name = "Subtlety", icon = "Interface\\Icons\\Ability_Stealth" }
    },
    Priest = {
        { name = "Discipline", icon = "Interface\\Icons\\Spell_Holy_PowerWordShield" },
        { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_HolyBolt" },
        { name = "Shadow", icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain" }
    },
    Shaman = {
        { name = "Elemental", icon = "Interface\\Icons\\Spell_Nature_Lightning" },
        { name = "Enhancement", icon = "Interface\\Icons\\Spell_Nature_LightningShield" },
        { name = "Restoration", icon = "Interface\\Icons\\Spell_Nature_HealingWaveGreater" }
    },
    Mage = {
        { name = "Arcane", icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
        { name = "Fire", icon = "Interface\\Icons\\Spell_Fire_FlameBolt" },
        { name = "Frost", icon = "Interface\\Icons\\Spell_Frost_FrostBolt" }
    },
    Warlock = {
        { name = "Affliction", icon = "Interface\\Icons\\Spell_Shadow_DeathCoil" },
        { name = "Demonology", icon = "Interface\\Icons\\Spell_Shadow_Metamorphosis" },
        { name = "Destruction", icon = "Interface\\Icons\\Spell_Fire_FireBolt02" }
    },
    Druid = {
        { name = "Balance", icon = "Interface\\Icons\\Spell_Nature_StarFall" },
        { name = "Feral (Tank)", icon = "Interface\\Icons\\Ability_Racial_BearForm" },
        { name = "Feral (Damage)", icon = "Interface\\Icons\\Ability_Druid_CatForm" },
        { name = "Restoration", icon = "Interface\\Icons\\Spell_Nature_HealingTouch" }
    }
}
local options = {}
local page = nil
local selectedClass = "Warrior"
local selectedRole = nil
local selectedSpec = nil
local raidSize = nil
local fillRoleMemberName = nil
local pendingAssignmentRole = nil
local previewRoleOverride = nil
local active = false
local preview = false
local recruitCost = nil
local mode = "temporary"
local temporaryDescription = "Recruit a companion for a limited\ntime. Companions will leave when\nthe group is disbanded."
local picker
local ShowPage
local UpdatePicker
local pendingTab = nil
local pendingClass = nil
local pickerClassAvailability = {}
local selectedRace = nil

local function ParchmentTextColor(font, r, g, b)
    font:SetTextColor(r, g, b)
    -- GameFont templates carry a drop shadow intended for light text on dark
    -- panels. On parchment it produces a second dark edge around every glyph.
    font:SetShadowOffset(0, 0)
    font:SetShadowColor(0, 0, 0, 0)
    local face, height = font:GetFont()
    if face then font:SetFont(face, height, "") end
end

local function Text(parent, content, size, x, y, width, height, color)
    local font = parent:CreateFontString(nil, "OVERLAY", size or "GameFontNormal")
    font:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    font:SetWidth(width)
    font:SetHeight(height)
    font:SetJustifyH("LEFT")
    font:SetJustifyV("TOP")
    if color[1] < 0.5 and color[2] < 0.5 and color[3] < 0.5 then
        ParchmentTextColor(font, color[1], color[2], color[3])
    else
        font:SetTextColor(color[1], color[2], color[3])
    end
    font:SetText(content)
    return font
end

local function MoneyText(parent, content, size, x, y, width, height, color)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    frame:SetWidth(width)
    frame:SetHeight(height)
    local line = CreateFrame("Frame", nil, frame)
    line:SetHeight(height)
    frame.align = "LEFT"
    frame.label = Text(line, "", size, 0, 0, 0, height, color)
    frame.coins = {}
    local i
    for i = 1, 3 do
        local amount = Text(line, "", size, 0, 0, 0, height, color)
        local icon = line:CreateTexture(nil, "ARTWORK")
        -- Same atlas and 13px denominations as SmallMoneyFrameTemplate.
        icon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
        icon:SetTexCoord((i - 1) * 0.25, i * 0.25, 0, 1)
        icon:SetWidth(13)
        icon:SetHeight(13)
        frame.coins[i] = { amount = amount, icon = icon }
    end
    function frame:SetJustifyH(align)
        self.align = align
        local point = align == "CENTER" and "TOP" or ("TOP" .. align)
        line:ClearAllPoints()
        line:SetPoint(point, self, point, 0, 0)
    end
    function frame:SetText(value)
        value = value or ""
        local _, _, prefix, gold, silver, copper = string.find(value, "^(.-)(%d+)g (%d+)s (%d+)c$")
        self.label:SetText(prefix or value)
        self.label:SetWidth(0)
        local offset = self.label:GetStringWidth()
        local values = { tonumber(gold) or 0, tonumber(silver) or 0, tonumber(copper) or 0 }
        local empty = values[1] == 0 and values[2] == 0 and values[3] == 0
        local j
        for j = 1, 3 do
            local entry = self.coins[j]
            if gold and (values[j] > 0 or (empty and j == 3)) then
                entry.amount:SetText(tostring(values[j]))
                entry.amount:SetWidth(0)
                entry.amount:ClearAllPoints()
                entry.amount:SetPoint("TOPLEFT", line, "TOPLEFT", offset, 0)
                offset = offset + entry.amount:GetStringWidth() + 1
                entry.icon:ClearAllPoints()
                entry.icon:SetPoint("TOPLEFT", line, "TOPLEFT", offset, 1)
                offset = offset + 13 + 4
                entry.amount:Show()
                entry.icon:Show()
            else
                entry.amount:Hide()
                entry.icon:Hide()
            end
        end
        line:SetWidth(math.max(1, offset - (gold and 4 or 0)))
        self:SetJustifyH(self.align)
    end
    frame:SetText(content)
    return frame
end

local function Box(parent, x, y, width, height, r, g, b, name)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    frame:SetWidth(width)
    frame:SetHeight(height)
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    frame:SetBackdropColor(r or 0.08, g or 0.08, b or 0.08, 1)
    frame:SetBackdropBorderColor(0.58, 0.45, 0.27, 1)
    return frame
end

local function IconSelectionBorder(parent, icon)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("TOPLEFT", icon, "TOPLEFT", -3, 3)
    frame:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3)
    frame:SetFrameLevel(parent:GetFrameLevel() + 3)
    frame:EnableMouse(false)

    -- Match the navigation tabs' border artwork, size, and selected color.
    frame:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    frame:SetBackdropBorderColor(1, 0.74, 0.2, 1)
    function frame:SetSelected(selected)
        if selected then self:Show() else self:Hide() end
    end
    frame:Hide()
    return frame
end

local function Button(parent, label, x, y, width, height, onClick)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    button:SetWidth(width)
    button:SetHeight(height or 26)
    button:SetText(label)
    button:SetScript("OnClick", onClick)
    return button
end

local function FindOption(prefix)
    local i
    for i = 1, table.getn(options) do
        if string.sub(options[i], 1, string.len(prefix)) == prefix then
            return i
        end
    end
    return nil
end

local function HasOption(prefix)
    return FindOption(prefix) ~= nil
end

local function CostFor(prefix)
    local index = FindOption(prefix)
    if not index then return nil end
    local _, _, suffix = string.find(options[index], "%(([^()]*)%)$")
    if suffix == "full" or (suffix and string.find(suffix, "^%d+g %d+s %d+c$")) then
        return suffix
    end
    return nil
end

local function SelectOption(prefix)
    local index = FindOption(prefix)
    if index then
        SelectGossipOption(index)
        return true
    end
    UIErrorsFrame:AddMessage("That recruitment choice is no longer available.", 1, 0.25, 0.25)
    return false
end

local function NavigateTab(target)
    if target == "permanent" then
        selectedClass = "Warrior"
        selectedSpec = nil
        selectedRace = nil
        recruitCost = nil
        pickerClassAvailability = {}
    end
    if preview then
        mode = target
        if target == "permanent" then
            ShowPage("picker")
            UpdatePicker()
        else
            ShowPage(target == "temporary" and "main" or "manage")
        end
        return
    end
    if target == "temporary" and HasOption("Recruit a tank companion") then
        mode = target
        ShowPage("main")
        return
    end
    local choice = target == "permanent" and "Permanent Recruitment" or "Manage Companions"
    if target ~= "temporary" and HasOption(choice) then
        mode = target
        SelectOption(choice)
        return
    end
    if HasOption("Back to recruiter") then
        pendingTab = target
        SelectOption("Back to recruiter")
    end
end

local window = Box(UIParent, 0, 0, 600, 410, 0.04, 0.04, 0.04, "CompanionRecruiterWindow")
window:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    tile = true, tileSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
window:SetBackdropColor(0.025, 0.027, 0.032, 1)
local windowBackground = window:CreateTexture(nil, "BACKGROUND")
windowBackground:SetPoint("TOPLEFT", window, "TOPLEFT", 12, -13)
windowBackground:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -13, 12)
windowBackground:SetTexture("Interface\\CompanionRecruiter\\companion-recruiter-background")
-- Use the large lower-left panel from the Auction House texture atlas, excluding its trim.
windowBackground:SetTexCoord(0.1816, 0.4697, 0.3945, 0.7930)
window:ClearAllPoints()
window:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
window:SetFrameStrata("DIALOG")
window:EnableMouse(true)
window:SetMovable(true)
window:RegisterForDrag("LeftButton")
window:SetScript("OnDragStart", function() window:StartMoving() end)
window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
window:Hide()
CR.window = window

local header = Box(window, 10, -13, 580, 34, 0.10, 0.10, 0.10)
header:SetBackdropBorderColor(0.76, 0.76, 0.78, 1)
local windowTitle = Text(header, "Companion Recruitment", "GameFontNormalLarge", 70, -8, 450, 25, { 1, 0.82, 0.25 })
windowTitle:SetJustifyH("CENTER")
local headerRule = header:CreateTexture(nil, "ARTWORK")
headerRule:SetTexture("Interface\\QuestFrame\\UI-HorizontalBreak")
headerRule:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 7, -1)
headerRule:SetWidth(566)
headerRule:SetHeight(6)
headerRule:SetVertexColor(0.82, 0.63, 0.30, 0.65)
local close = CreateFrame("Button", nil, header, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", header, "TOPRIGHT", 1, -1)
close:SetScript("OnClick", function()
    if preview then window:Hide() else CloseGossip() end
end)

local tabGap = 4
local tabHeight = 62
local railPad = 5 + tabGap
local rail = Box(window, 15, -49, 142, railPad * 2 + tabHeight * 3 + tabGap * 2, 0.035, 0.035, 0.035)
rail:SetBackdropBorderColor(0.31, 0.30, 0.28, 1)
local function StyleNavigationTab(tab, selected, hovered)
    if selected then
        tab.panel:SetBackdropColor(0.11, 0.13, 0.17, 1)
        tab.panel:SetBackdropBorderColor(1, 0.74, 0.2, 1)
        tab.label:SetTextColor(1, 0.84, 0.38)
    elseif hovered then
        tab.panel:SetBackdropColor(0.10, 0.09, 0.07, 1)
        tab.panel:SetBackdropBorderColor(0.60, 0.48, 0.29, 1)
        tab.label:SetTextColor(0.95, 0.87, 0.68)
    else
        tab.panel:SetBackdropColor(0.045, 0.045, 0.045, 1)
        tab.panel:SetBackdropBorderColor(0.30, 0.28, 0.24, 1)
        tab.label:SetTextColor(0.76, 0.75, 0.70)
    end
end
local function NavigationTab(label, iconPath, y, target)
    local panel = Box(rail, 5, y, 132, tabHeight, 0.06, 0.06, 0.06)
    local button = CreateFrame("Button", nil, panel)
    button:SetAllPoints(panel)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(iconPath)
    icon:SetWidth(28)
    icon:SetHeight(28)
    icon:SetPoint("LEFT", button, "LEFT", 8, 0)
    local text = Text(button, label, "GameFontHighlightSmall", 42, -17, 85, 32, { 0.8, 0.8, 0.76 })
    local tab = { panel = panel, label = text, target = target }
    button:SetScript("OnClick", function() NavigateTab(target) end)
    button:SetScript("OnEnter", function()
        tab.hovered = true
        StyleNavigationTab(tab, tab.target == mode, true)
    end)
    button:SetScript("OnLeave", function()
        tab.hovered = false
        StyleNavigationTab(tab, tab.target == mode, false)
    end)
    StyleNavigationTab(tab, target == mode, false)
    return tab
end
local temporaryTab = NavigationTab("Temporary\nRecruitment", "Interface\\Icons\\INV_Helmet_06", -railPad, "temporary")
local permanentTab = NavigationTab("Permanent\nRecruitment", "Interface\\Icons\\INV_BannerPVP_02", -(railPad + tabHeight + tabGap), "permanent")
local manageTab = NavigationTab("Companion\nManagement", "Interface\\Icons\\Trade_Engineering", -(railPad + (tabHeight + tabGap) * 2), "manage")
local tabs = { temporary = temporaryTab, permanent = permanentTab, manage = manageTab }

local content = CreateFrame("Frame", nil, window)
content:SetPoint("TOPLEFT", window, "TOPLEFT", 166, -57)
content:SetWidth(422)
content:SetHeight(337)

local pages = {}
local function NewPage(name)
    local frame = CreateFrame("Frame", nil, content)
    frame:SetAllPoints(content)
    frame:Hide()
    pages[name] = frame
    return frame
end

local main = NewPage("main")
local mainBackground = main:CreateTexture(nil, "BACKGROUND")
mainBackground:SetAllPoints(main)
mainBackground:SetTexCoord(0, 1, 0, 0.798828125)
local function UpdateMainBackground()
    local faction = CurrentFactionGroup()
    local texture = faction == "Horde" and "recruiter-background-horde" or "recruiter-background-alliance"
    mainBackground:SetTexture("Interface\\CompanionRecruiter\\" .. texture)
end
UpdateMainBackground()
local contentBorder = CreateFrame("Frame", nil, content)
contentBorder:SetFrameLevel(content:GetFrameLevel() + 10)
contentBorder:SetPoint("TOPLEFT", content, "TOPLEFT", -4, 6)
contentBorder:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 7, -10)
contentBorder:SetBackdrop({
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 14,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
contentBorder:SetBackdropBorderColor(0.76, 0.76, 0.78, 0.95)
local contentParchment = content:CreateTexture(nil, "BACKGROUND")
contentParchment:SetPoint("TOPLEFT", content, "TOPLEFT")
contentParchment:SetPoint("BOTTOMRIGHT", contentBorder, "BOTTOMRIGHT", -7, 0)
contentParchment:SetTexture("Interface\\CompanionRecruiter\\parchment")
contentParchment:SetTexCoord(0, 1, 0, 0.798828125)
contentParchment:SetVertexColor(1, 1, 1, 1)
contentParchment:Hide()
mainBackground:ClearAllPoints()
mainBackground:SetPoint("TOPLEFT", main, "TOPLEFT", 0, 0)
mainBackground:SetPoint("BOTTOMRIGHT", contentBorder, "BOTTOMRIGHT", -7, 0)
-- The shared content border sits above page backgrounds; redraw the outer trim above it.
local windowBorderOverlay = CreateFrame("Frame", nil, window)
windowBorderOverlay:SetAllPoints(window)
windowBorderOverlay:SetBackdrop({
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
windowBorderOverlay:SetBackdropBorderColor(0.84, 0.84, 0.86, 1)
windowBorderOverlay:SetFrameLevel(contentBorder:GetFrameLevel() + 10)
close:SetFrameLevel(windowBorderOverlay:GetFrameLevel() + 1)
local mainTitle = Text(main, "Temporary Recruitment", "GameFontNormalLarge", 12, -6, 394, 25,
    { 1, 0.78, 0.27 })
local mainDescription = Text(main, temporaryDescription,
    "GameFontHighlight", 12, -38, 394, 43, { 0.84, 0.82, 0.78 })

local fillCard = Box(main, 10, -145, 193, 187, 0.08, 0.08, 0.08)
fillCard:SetBackdropColor(0.035, 0.035, 0.04, 1)
local fillIconSlot = fillCard:CreateTexture(nil, "ARTWORK")
fillIconSlot:SetTexture("Interface\\Buttons\\UI-EmptySlot")
fillIconSlot:SetPoint("TOP", fillCard, "TOP", 0, -7)
fillIconSlot:SetWidth(54)
fillIconSlot:SetHeight(54)
local fillIcon = fillCard:CreateTexture(nil, "OVERLAY")
fillIcon:SetTexture("Interface\\Icons\\Spell_Holy_PrayerOfHealing")
fillIcon:SetPoint("CENTER", fillIconSlot, "CENTER", 0, 0)
fillIcon:SetWidth(40)
fillIcon:SetHeight(40)
local fillTitle = Text(fillCard, "Fill Group", "GameFontNormalLarge", 10, -63, 173, 25, { 1, 0.78, 0.27 })
local fillDescription = Text(fillCard, "Recruit the missing tank, healer,\nand damage roles for your\nparty.",
    "GameFontHighlightSmall", 14, -90, 166, 39, { 0.85, 0.82, 0.77 })
local fillCost = MoneyText(fillCard, "", "GameFontNormalSmall", 14, -131, 166, 18, { 1, 0.78, 0.27 })
local fillButton = Button(fillCard, "Fill Group", 22, -151, 150, 25, function()
    if preview then
        raidSize = nil
        ShowPage(GetNumRaidMembers() > 0 and "raids" or "fillAssignments")
    else SelectOption(HasOption("Fill my raid") and "Fill my raid" or "Fill my party") end
end)

local chooseCard = Box(main, 216, -145, 193, 187, 0.08, 0.08, 0.08)
chooseCard:SetBackdropColor(0.035, 0.035, 0.04, 1)
local chooseIconSlot = chooseCard:CreateTexture(nil, "ARTWORK")
chooseIconSlot:SetTexture("Interface\\Buttons\\UI-EmptySlot")
chooseIconSlot:SetPoint("TOP", chooseCard, "TOP", 0, -7)
chooseIconSlot:SetWidth(54)
chooseIconSlot:SetHeight(54)
local chooseIcon = chooseCard:CreateTexture(nil, "OVERLAY")
chooseIcon:SetTexture(roleIcons.Damage)
chooseIcon:SetTexCoord(0, 1, 0, 1)
chooseIcon:SetPoint("CENTER", chooseIconSlot, "CENTER", 0, 0)
chooseIcon:SetWidth(40)
chooseIcon:SetHeight(40)
main:SetScript("OnShow", function()
    fillIcon:SetTexture("Interface\\Icons\\Spell_Holy_PrayerOfHealing")
    fillIcon:SetTexCoord(0, 1, 0, 1)
    fillIcon:SetVertexColor(1, 1, 1, 1)
    fillIcon:Show()
    chooseIcon:SetTexture(roleIcons.Damage)
    chooseIcon:SetTexCoord(0, 1, 0, 1)
    chooseIcon:SetVertexColor(1, 1, 1, 1)
    chooseIcon:Show()
end)
local chooseTitle = Text(chooseCard, "Class & Spec", "GameFontNormalLarge", 10, -63, 173, 25, { 1, 0.78, 0.27 })
local chooseDescription = Text(chooseCard, "Choose a class and\nspecialization for one\nnew companion.",
    "GameFontHighlightSmall", 14, -90, 166, 39, { 0.85, 0.82, 0.77 })
fillTitle:SetJustifyH("CENTER")
chooseTitle:SetJustifyH("CENTER")
fillDescription:SetJustifyH("CENTER")
chooseDescription:SetJustifyH("CENTER")
local chooseCost = MoneyText(chooseCard, "", "GameFontNormalSmall", 14, -131, 166, 18, { 1, 0.78, 0.27 })
local chooseButton = Button(chooseCard, "Choose Class & Spec", 22, -151, 150, 25, function()
    selectedClass = "Warrior"
    selectedSpec = nil
    pendingClass = nil
    pickerClassAvailability = {}
    if preview then
        ShowPage("picker")
        UpdatePicker()
    else
        SelectOption("Choose a companion's class and specialization")
        ShowPage("picker")
        UpdatePicker()
    end
end)

picker = NewPage("picker")
local pickerTitle = Text(picker, "Select Class & Specialization", "GameFontNormalLarge", 12, -6, 394, 25, { 1, 0.78, 0.27 })
local pickerClassTitle = Text(picker, "Select Class", "GameFontHighlight", 12, -36, 390, 20, { 0.9, 0.86, 0.75 })
local pickerClassButtons = {}
local pickerSpecButtons = {}
local pickerSpecTitle = Text(picker, "Select Specialization", "GameFontHighlight", 12, -179, 390, 20, { 0.9, 0.86, 0.75 })
local pickerSpecHint = Text(picker, "Select a class above to see its specializations.",
    "GameFontHighlightSmall", 12, -199, 390, 18, { 0.72, 0.69, 0.61 })
local pickerCost = MoneyText(picker, "", "GameFontNormalSmall", 108, -310, 150, 20, { 0.35, 0.19, 0.045 })
pickerCost:SetJustifyH("CENTER")

local function SelectPickerClass(name)
    if preview then
        selectedClass = name
        selectedSpec = nil
        selectedRace = nil
        UpdatePicker()
    elseif HasOption(name) then
        selectedClass = name
        selectedSpec = nil
        selectedRace = nil
        UpdatePicker()
        SelectOption(name)
    elseif HasOption("Choose another class") then
        selectedClass = name
        selectedSpec = nil
        selectedRace = nil
        pendingClass = name
        UpdatePicker()
        SelectOption("Choose another class")
    end
end

for i = 1, table.getn(classNames) do
    local name = classNames[i]
    local col = math.mod(i - 1, 5)
    local row = math.floor((i - 1) / 5)
    local tile = CreateFrame("Frame", nil, picker)
    tile:SetPoint("TOPLEFT", picker, "TOPLEFT", 15 + col * 82, -58 - row * 57)
    tile:SetWidth(72)
    tile:SetHeight(54)
    local button = CreateFrame("Button", nil, tile)
    button:SetAllPoints(tile)
    local icon = button:CreateTexture(nil, "ARTWORK")
    SetClassIcon(icon, name)
    icon:SetWidth(31)
    icon:SetHeight(31)
    icon:SetPoint("TOP", button, "TOP", 0, -2)
    local iconBorder = IconSelectionBorder(tile, icon)
    iconBorder:SetFrameLevel(button:GetFrameLevel() + 1)
    local label = Text(tile, name, "GameFontNormalSmall", 2, -36, 68, 15, { 1, 0.78, 0.27 })
    label:SetJustifyH("CENTER")
    button:SetScript("OnClick", function() SelectPickerClass(name) end)
    pickerClassButtons[name] = { tile = tile, button = button, iconBorder = iconBorder, label = label }
end

local pickerDivider = picker:CreateTexture(nil, "BACKGROUND")
pickerDivider:SetTexture("Interface\\QuestFrame\\UI-HorizontalBreak")
pickerDivider:SetVertexColor(0.78, 0.59, 0.29, 0.82)
pickerDivider:SetPoint("TOPLEFT", picker, "TOPLEFT", 12, -173)
pickerDivider:SetWidth(398)
pickerDivider:SetHeight(7)
local pickerColumnDivider = picker:CreateTexture(nil, "BACKGROUND")
pickerColumnDivider:SetTexture("Interface\\Buttons\\WHITE8X8")
pickerColumnDivider:SetVertexColor(0.33, 0.29, 0.21, 1)
pickerColumnDivider:SetPoint("TOPLEFT", picker, "TOPLEFT", 285, -36)
pickerColumnDivider:SetWidth(1)
pickerColumnDivider:SetHeight(264)
pickerColumnDivider:Hide()
for i = 1, 4 do
    local index = i
    local tile = CreateFrame("Frame", nil, picker)
    tile:SetPoint("TOPLEFT", picker, "TOPLEFT", 7 + (i - 1) * 104, -219)
    tile:SetWidth(96)
    tile:SetHeight(76)
    local button = CreateFrame("Button", nil, tile)
    button:SetAllPoints(tile)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\Ability_Warrior_Charge")
    icon:SetWidth(38)
    icon:SetHeight(38)
    icon:SetPoint("TOP", button, "TOP", 0, -5)
    local iconBorder = IconSelectionBorder(tile, icon)
    iconBorder:SetFrameLevel(button:GetFrameLevel() + 1)
    local label = Text(tile, "", "GameFontNormalSmall", 5, -49, 86, 25, { 1, 0.78, 0.27 })
    label:SetJustifyH("CENTER")
    button:SetScript("OnClick", function()
        local entry = pickerSpecButtons[index]
        if entry.option then
            selectedSpec = entry.option.name
            UpdatePicker()
            if mode == "permanent" and not preview then SelectOption(selectedSpec) end
        end
    end)
    pickerSpecButtons[i] = { tile = tile, button = button, icon = icon, label = label, iconBorder = iconBorder }
end

local pickerRaceTitle = Text(picker, "Select Race", "GameFontHighlight", 12, -179, 120, 20,
    { 0.9, 0.86, 0.75 })
local pickerRaceButtons = {}
for i = 1, table.getn(raceNames) do
    local raceName = raceNames[i]
    local tile = CreateFrame("Frame", nil, picker)
    tile:SetWidth(120)
    tile:SetHeight(26)
    local button = CreateFrame("Button", nil, tile)
    button:SetAllPoints(tile)
    local icon = button:CreateTexture(nil, "ARTWORK")
    SetRaceGenderIcon(icon, raceName, "Male")
    icon:SetWidth(22)
    icon:SetHeight(22)
    icon:SetPoint("LEFT", button, "LEFT", 2, 0)
    local iconBorder = IconSelectionBorder(tile, icon)
    local label = Text(tile, raceName, "GameFontNormal", 28, -5, 90, 18, { 1, 0.78, 0.27 })
    label:SetJustifyH("LEFT")
    button:SetScript("OnClick", function()
        if not pickerRaceButtons[raceName].canSelect then return end
        selectedRace = raceName
        UpdatePicker()
        if not preview then SelectOption("Race: " .. raceName) end
    end)
    pickerRaceButtons[raceName] = { tile = tile, button = button, icon = icon, iconBorder = iconBorder, label = label }
end

local pickerBack = Button(picker, "Back", 6, -306, 96, 27, function()
    if preview then ShowPage("main") else SelectOption("Back to recruiter") end
end)
local pickerRecruit = Button(picker, "Recruit Companion", 266, -306, 150, 27, function()
    if mode == "permanent" then
        if not selectedSpec or not selectedRace then return end
        if preview then UIErrorsFrame:AddMessage("Preview only.", 1, 0.78, 0.25)
        else SelectOption("Recruit permanent companion") end
    elseif not preview then
        if selectedSpec then SelectOption(selectedSpec) end
    end
end)

UpdatePicker = function()
    local j
    local permanent = mode == "permanent"
    ParchmentTextColor(pickerTitle, 0.23, 0.12, 0.035)
    ParchmentTextColor(pickerClassTitle, 0.27, 0.17, 0.075)
    ParchmentTextColor(pickerRaceTitle, 0.27, 0.17, 0.075)
    ParchmentTextColor(pickerSpecTitle, 0.27, 0.17, 0.075)
    ParchmentTextColor(pickerSpecHint, 0.39, 0.28, 0.16)
    pickerDivider:SetVertexColor(0.43, 0.27, 0.10, 0.72)
    pickerColumnDivider:SetVertexColor(0.43, 0.27, 0.10, 0.75)
    for j = 1, table.getn(classNames) do
        local name = classNames[j]
        if HasOption(name) then pickerClassAvailability[name] = true end
        local available = preview or pickerClassAvailability[name]
        local entry = pickerClassButtons[name]
        entry.button:EnableMouse(available and not pendingClass)
        entry.tile:SetAlpha(available and 1 or 0.3)
        local selected = selectedClass == name
        entry.iconBorder:SetSelected(selected and available)
    end

    if permanent then
        pickerBack:Hide()
        pickerClassTitle:SetWidth(265)
        pickerDivider:SetWidth(273)
        pickerColumnDivider:Show()
        pickerRaceTitle:Show()
        pickerRaceTitle:ClearAllPoints()
        pickerRaceTitle:SetPoint("TOPLEFT", picker, "TOPLEFT", 295, -36)
        pickerRaceTitle:SetWidth(120)
        pickerSpecTitle:ClearAllPoints()
        pickerSpecTitle:SetPoint("TOPLEFT", picker, "TOPLEFT", 12, -179)
        pickerSpecTitle:SetWidth(277)
        pickerSpecTitle:SetText("Select Specialization")
        pickerSpecHint:ClearAllPoints()
        pickerSpecHint:SetPoint("TOPLEFT", picker, "TOPLEFT", 12, -199)
        pickerSpecHint:SetWidth(277)
    else
        pickerBack:Show()
        pickerClassTitle:SetWidth(390)
        pickerDivider:SetWidth(398)
        pickerColumnDivider:Hide()
        pickerRaceTitle:Hide()
        pickerSpecTitle:ClearAllPoints()
        pickerSpecTitle:SetPoint("TOPLEFT", picker, "TOPLEFT", 12, -179)
        pickerSpecTitle:SetWidth(390)
        pickerSpecHint:ClearAllPoints()
        pickerSpecHint:SetPoint("TOPLEFT", picker, "TOPLEFT", 12, -199)
        pickerSpecHint:SetWidth(390)
    end

    local visibleRaceCount = 0
    for j = 1, table.getn(raceNames) do
        local raceName = raceNames[j]
        local hasRaceOption = HasOption("Race: " .. raceName)
        local hasUnavailableOption = HasOption("Race unavailable: " .. raceName)
        local visible = permanent and (preview and IsRaceInCurrentFaction(raceName) or
            (not preview and (hasRaceOption or hasUnavailableOption)))
        local canSelect = permanent and (preview and IsRaceInCurrentFaction(raceName) and
            IsRaceAvailableForClass(selectedClass, raceName) or
            (not preview and hasRaceOption))
        local entry = pickerRaceButtons[raceName]
        entry.canSelect = canSelect
        if visible then
            entry.tile:ClearAllPoints()
            entry.tile:SetPoint("TOPLEFT", picker, "TOPLEFT", 295,
                (permanent and -56 or -204) - visibleRaceCount * 28)
            entry.tile:SetAlpha(canSelect and 1 or 0.3)
            entry.tile:Show()
            entry.button:EnableMouse(canSelect and not pendingClass)
            visibleRaceCount = visibleRaceCount + 1
        else
            entry.tile:Hide()
            entry.button:EnableMouse(false)
        end
        local selected = selectedRace == raceName and canSelect
        entry.iconBorder:SetSelected(selected)
        ParchmentTextColor(entry.label, 0.25, 0.14, 0.045)
    end
    if selectedRace and not (preview and IsRaceInCurrentFaction(selectedRace) and
        IsRaceAvailableForClass(selectedClass, selectedRace) or
        (not preview and HasOption("Race: " .. selectedRace))) then
        selectedRace = nil
    end

    local specs = selectedClass and specializationOptions[selectedClass] or nil
    if selectedSpec and not preview and not HasOption(selectedSpec) then selectedSpec = nil end
    if selectedClass then
        pickerSpecHint:SetText("Specializations for " .. selectedClass .. ".")
    else
        pickerSpecHint:SetText("Select a class above to see its specializations.")
    end
    local specCount = specs and table.getn(specs) or 0
    local tileWidth = permanent and (specCount > 3 and 54 or 82) or (specCount > 3 and 96 or 122)
    local tileGap = permanent and (specCount > 3 and 4 or 6) or (specCount > 3 and 8 or 14)
    local totalWidth = specCount * tileWidth + math.max(0, specCount - 1) * tileGap
    local specPanelLeft = permanent and 12 or 0
    local specPanelWidth = permanent and 265 or 422
    local startX = specPanelLeft + math.floor((specPanelWidth - totalWidth) / 2)
    for j = 1, 4 do
        local spec = specs and specs[j] or nil
        local available = spec and (preview or HasOption(spec.name))
        local entry = pickerSpecButtons[j]
        entry.option = spec
        if spec then
            entry.tile:ClearAllPoints()
            entry.tile:SetPoint("TOPLEFT", picker, "TOPLEFT", startX + (j - 1) * (tileWidth + tileGap), -219)
            entry.tile:SetWidth(tileWidth)
            entry.tile:SetHeight(76)
            entry.label:ClearAllPoints()
            entry.label:SetPoint("TOPLEFT", entry.tile, "TOPLEFT", 5, -49)
            entry.label:SetWidth(tileWidth - 10)
            entry.label:SetText(spec.name)
            entry.icon:SetTexture(spec.icon)
            local iconSize = permanent and (specCount > 3 and 28 or 34) or (specCount > 3 and 34 or 38)
            entry.icon:SetWidth(iconSize)
            entry.icon:SetHeight(iconSize)
            entry.icon:ClearAllPoints()
            entry.icon:SetPoint("TOP", entry.button, "TOP", 0, permanent and -4 or -5)
            entry.label:SetPoint("TOPLEFT", entry.tile, "TOPLEFT", 5,
                permanent and (specCount > 3 and -38 or -45) or -49)
            entry.label:SetHeight(permanent and 30 or 25)
            ParchmentTextColor(entry.label, 0.25, 0.14, 0.045)
            entry.tile:Show()
        else
            entry.tile:Hide()
        end
        entry.button:EnableMouse(available and not pendingClass)
        entry.tile:SetAlpha(available and 1 or 0.3)
        local selected = selectedSpec == (spec and spec.name)
        entry.iconBorder:SetSelected(selected and available)
    end

    for j = 1, table.getn(classNames) do
        local name = classNames[j]
        local col = math.mod(j - 1, 5)
        local row = math.floor((j - 1) / 5)
        local entry = pickerClassButtons[name]
        local tileWidth = permanent and 52 or 72
        entry.tile:ClearAllPoints()
        entry.tile:SetPoint("TOPLEFT", picker, "TOPLEFT",
            permanent and (12 + col * 52) or (15 + col * 82), -58 - row * 57)
        entry.tile:SetWidth(tileWidth)
        entry.label:ClearAllPoints()
        entry.label:SetPoint("TOPLEFT", entry.tile, "TOPLEFT", permanent and 0 or 2, -36)
        entry.label:SetWidth(permanent and 52 or 68)
        ParchmentTextColor(entry.label, 0.25, 0.14, 0.045)
    end
    local price = selectedSpec and CostFor(selectedSpec) or
        (specs and specs[1] and CostFor(specs[1].name)) or recruitCost
    pickerCost:SetText(price and ("Cost: " .. price) or "")
    pickerRecruit:SetText(mode == "permanent" and "Buy Companion" or "Recruit Companion")
    local canRecruit = selectedSpec and (preview or HasOption(selectedSpec))
    if permanent then
        canRecruit = canRecruit and selectedRace and
            (preview and IsRaceInCurrentFaction(selectedRace) and
                IsRaceAvailableForClass(selectedClass, selectedRace) or
                (not preview and HasOption("Race: " .. selectedRace)))
    end
    if canRecruit then pickerRecruit:Enable() else pickerRecruit:Disable() end
end

local raidButton = Button(main, "Fill Group", 11, -293, 124, 27, function()
    if preview then
        raidSize = nil
        ShowPage(GetNumRaidMembers() > 0 and "raids" or "fillAssignments")
    else SelectOption(HasOption("Fill my raid") and "Fill my raid" or "Fill my party") end
end)
local classes = NewPage("classes")
local classesTitle = Text(classes, "Select Class & Specialization", "GameFontNormalLarge", 12, -6, 390, 26, { 1, 0.78, 0.27 })
local classesDescription = Text(classes, "Select Class",
    "GameFontHighlight", 12, -39, 390, 30, { 0.84, 0.82, 0.78 })
local classGrid = CreateFrame("Frame", nil, content)
classGrid:SetAllPoints(content)
classGrid:Hide()
local classButtons = {}
local i
for i = 1, table.getn(classNames) do
    local name = classNames[i]
    local col = math.mod(i - 1, 5)
    local row = math.floor((i - 1) / 5)
    local tile = CreateFrame("Frame", nil, classGrid)
    tile:SetPoint("TOPLEFT", classGrid, "TOPLEFT", 12 + col * 81, -65 - row * 67)
    tile:SetWidth(72)
    tile:SetHeight(63)
    local icon = CreateFrame("Button", nil, tile)
    icon:SetPoint("TOP", tile, "TOP", 0, -7)
    icon:SetWidth(36)
    icon:SetHeight(36)
    icon:SetNormalTexture(classIconTexture)
    SetClassIcon(icon:GetNormalTexture(), name)
    icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    local iconBorder = IconSelectionBorder(tile, icon)
    iconBorder:SetFrameLevel(icon:GetFrameLevel() + 1)
    icon:SetScript("OnClick", function()
        selectedClass = name
        selectedSpec = nil
        if preview then
            ShowPage("picker")
            UpdatePicker()
        else
            SelectOption(name)
        end
    end)
    local label = Text(tile, name, "GameFontNormalSmall", 3, -44, 66, 16, { 1, 0.78, 0.27 })
    label:SetJustifyH("CENTER")
    classButtons[name] = { tile = tile, icon = icon, iconBorder = iconBorder, label = label }
end
local classHint = Text(classes, "Select a class above to see its specializations.", "GameFontHighlightSmall", 12, -221, 390, 32, { 0.72, 0.69, 0.61 })
Button(classes, "Back", 11, -293, 122, 27, function()
    if preview then NavigateTab("temporary") else SelectOption("Back to recruiter") end
end)

local roles = NewPage("roles")
local rolesTitle = Text(roles, "Select Role", "GameFontNormalLarge", 12, -6, 390, 26, { 0.23, 0.12, 0.035 })
local rolesDescription = Text(roles, "Only roles supported by the chosen class are available.",
    "GameFontHighlight", 12, -39, 390, 30, { 0.27, 0.17, 0.075 })
local roleButtons = {}
local roleNames = { "Tank", "Healer", "Damage" }
for i = 1, 3 do
    local name = roleNames[i]
    local tile = Box(roles, 12 + (i - 1) * 137, -91, 126, 148, 0.08, 0.08, 0.08)
    local icon = CreateFrame("Button", nil, tile)
    icon:SetPoint("TOP", tile, "TOP", 0, -15)
    icon:SetWidth(62)
    icon:SetHeight(62)
    icon:SetNormalTexture(roleIcons[name])
    icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    icon:SetScript("OnClick", function()
        if page == "fillRolePicker" then
            if preview then
                selectedRole = name
                ShowPage("fillAssignments")
            else
                SelectOption("Set role to " .. name)
            end
        else
            selectedRole = name
            CR:UpdateRoleSelection()
        end
    end)
    local label = Text(tile, name, "GameFontNormal", 8, -94, 110, 30, { 1, 0.78, 0.27 })
    label:SetJustifyH("CENTER")
    roleButtons[name] = { tile = tile, icon = icon, label = label }
end
local roleBack = Button(roles, "Back", 11, -293, 122, 27, function()
    if preview then ShowPage(page == "fillRolePicker" and "fillAssignments" or
        (page == "classRole" and "classes" or (raidSize and "raids" or "main")))
    elseif page == "classRole" then SelectOption(mode == "permanent" and "Choose another class" or "Choose another class")
    elseif page == "fillRolePicker" then SelectOption("Back to role assignments")
    else SelectOption("Back to recruiter") end
end)
local roleCost = MoneyText(roles, "", "GameFontNormalSmall", 14, -274, 390, 23, { 0.35, 0.19, 0.045 })
local recruitButton = Button(roles, "Recruit Companion", 246, -293, 163, 27, function()
    if preview then return end
    if selectedRole then
        if page == "classRole" then SelectOption(selectedRole)
        else SelectOption("I am " .. (selectedRole == "Damage" and "damage" or "the " .. string.lower(selectedRole))) end
    end
end)

local raids = NewPage("raids")
Text(raids, "Raid Recruitment", "GameFontNormalLarge", 12, -6, 390, 26, { 0.23, 0.12, 0.035 })
Text(raids, "Select a raid size. Your group must already be a raid.",
    "GameFontHighlight", 12, -39, 390, 34, { 0.27, 0.17, 0.075 })
local raidCosts = {}
for i = 1, 3 do
    local size = i == 1 and 10 or (i == 2 and 20 or 40)
    local tile = Box(raids, 12, -79 - (i - 1) * 69, 397, 59, 0.08, 0.08, 0.08)
    Text(tile, size .. " Players", "GameFontNormalLarge", 15, -15, 158, 27, { 1, 0.78, 0.27 })
    raidCosts[size] = MoneyText(tile, "", "GameFontNormalSmall", 136, -21, 113, 20, { 1, 0.78, 0.27 })
    Button(tile, "Select", 252, -15, 131, 27, function()
        raidSize = size
        selectedRole = nil
        if preview then ShowPage("fillAssignments") else SelectOption("Fill a " .. size .. "-player raid") end
    end)
end
Button(raids, "Back", 11, -293, 122, 27, function()
    if preview then ShowPage("main") else SelectOption("Back to recruiter") end
end)

local manage = NewPage("manage")
Text(manage, "Companion Management", "GameFontNormalLarge", 12, -6, 390, 26, { 0.23, 0.12, 0.035 })
local manageTableBg = Box(manage, 12, -47, 397, 244, 0.07, 0.065, 0.055)
manageTableBg:SetBackdropColor(0.07, 0.065, 0.055, 0.95)
local manageListWidth = 367
local rosterHeader = CreateFrame("Frame", nil, manage)
rosterHeader:SetPoint("TOPLEFT", manageTableBg, "TOPLEFT", 5, -5)
rosterHeader:SetPoint("TOPRIGHT", manageTableBg, "TOPRIGHT", -5, -5)
rosterHeader:SetHeight(22)
local rosterHeaderBg = rosterHeader:CreateTexture(nil, "BACKGROUND")
rosterHeaderBg:SetAllPoints(rosterHeader)
rosterHeaderBg:SetTexture("Interface\\Buttons\\WHITE8X8")
rosterHeaderBg:SetVertexColor(0.14, 0.13, 0.11, 1)
Text(rosterHeader, "Name", "GameFontHighlightSmall", 36, -4, 96, 16, { 0.7, 0.7, 0.65 })
Text(rosterHeader, "Class / Spec", "GameFontHighlightSmall", 135, -4, 90, 16, { 0.7, 0.7, 0.65 })
local manageScrollBarBg = CreateFrame("Frame", nil, manage)
manageScrollBarBg:SetPoint("TOPRIGHT", manageTableBg, "TOPRIGHT", -5, -27)
manageScrollBarBg:SetPoint("BOTTOMRIGHT", manageTableBg, "BOTTOMRIGHT", -5, 5)
manageScrollBarBg:SetWidth(20)
manageScrollBarBg:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
manageScrollBarBg:SetBackdropColor(0.035, 0.032, 0.028, 1)
local manageScroll = CreateFrame("ScrollFrame", "CompanionRecruiterRosterScroll", manage, "UIPanelScrollFrameTemplate")
manageScroll:SetPoint("TOPLEFT", manageTableBg, "TOPLEFT", 5, -27)
manageScroll:SetWidth(manageListWidth)
manageScroll:SetHeight(212)
local manageScrollBar = getglobal(manageScroll:GetName() .. "ScrollBar")
manageScrollBar:ClearAllPoints()
manageScrollBar:SetPoint("TOP", manageScrollBarBg, "TOP", 0, -16)
manageScrollBar:SetPoint("BOTTOM", manageScrollBarBg, "BOTTOM", 0, 16)
local manageContent = CreateFrame("Frame", nil, manageScroll)
manageContent:SetWidth(manageListWidth)
manageContent:SetHeight(1)
manageScroll:SetScrollChild(manageContent)
local manageRows = {}
local manageEmptyText
local managePrevious = Button(manage, "Previous", 12, -297, 122, 27, function()
    if not preview then SelectOption("Previous companions") end
end)
local manageNext = Button(manage, "Next", 286, -297, 122, 27, function()
    if not preview then SelectOption("More companions") end
end)
local pendingOwnedRemovalName
StaticPopupDialogs["COMPANION_RECRUITER_REMOVE_OWNED"] = {
    text = "Do you really want to remove %s from your available companions? This permanently deletes it.",
    button1 = "Remove",
    button2 = CANCEL,
    OnAccept = function()
        local name = pendingOwnedRemovalName
        pendingOwnedRemovalName = nil
        if name then SelectOption("Remove companion: " .. name) end
    end,
    OnCancel = function() pendingOwnedRemovalName = nil end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
}

local function RefreshManageRows()
    if not preview and HasOption("Previous companions") then managePrevious:Show() else managePrevious:Hide() end
    if not preview and HasOption("More companions") then manageNext:Show() else manageNext:Hide() end
    local j
    for j = 1, table.getn(manageRows) do manageRows[j]:Hide() end
    manageScroll:SetVerticalScroll(0)
    local rowTexts = {}
    if preview then
        table.insert(rowTexts, "Thorin - Warrior / Protection / tank / Human / Male [Stored]")
        table.insert(rowTexts, "Lyriassa - Mage / Frost / dps / High Elf / Female [Following]")
        table.insert(rowTexts, "Shadra - Warlock / Affliction / dps / Orc / Female [Stored]")
        table.insert(rowTexts, "Merin - Priest / Holy / healer / Night Elf / Female [Idle]")
        table.insert(rowTexts, "Brom - Paladin / Protection / tank / Dwarf / Male [Stored]")
        table.insert(rowTexts, "Thornic - Druid / Restoration / healer / Tauren / Male [Following]")
    else
        for j = 1, table.getn(options) do
            local text = options[j]
            if string.find(text, "^.- %- .- / .- %[(.-)%]$") then
                table.insert(rowTexts, text)
            end
        end
    end
    manageContent:SetHeight(math.max(174, table.getn(rowTexts) * 35))
    if manageEmptyText then manageEmptyText:Hide() end
    for j = 1, table.getn(rowTexts) do
        local row = manageRows[j]
        if not row then
            row = Box(manageContent, 0, -1 - (j - 1) * 35, manageListWidth, 34, 0.055, 0.055, 0.05)
            row:SetBackdropBorderColor(0.22, 0.22, 0.2, 1)
            row.raceIcon = row:CreateTexture(nil, "ARTWORK")
            row.raceIcon:SetWidth(28)
            row.raceIcon:SetHeight(28)
            row.raceIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -3)
            row.label = Text(row, "", "GameFontNormalSmall", 36, -11, 96, 16, { 0.95, 0.83, 0.43 })
            row.classIcon = row:CreateTexture(nil, "ARTWORK")
            row.classIcon:SetWidth(24)
            row.classIcon:SetHeight(24)
            row.classIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 139, -5)
            row.roleIcon = row:CreateTexture(nil, "ARTWORK")
            row.roleIcon:SetWidth(24)
            row.roleIcon:SetHeight(24)
            row.roleIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 177, -5)
            local rowFrame = row
            row.button = Button(row, "Invite", 258, -5, 76, 24, function()
                if not preview then SelectOption(rowFrame.option) end
            end)
            row.removeButton = CreateFrame("Button", nil, row, "UIPanelCloseButton")
            row.removeButton:ClearAllPoints()
            row.removeButton:SetPoint("TOPLEFT", row, "TOPLEFT", 341, -2)
            row.removeButton:SetWidth(24)
            row.removeButton:SetHeight(24)
            row.removeButton:SetScript("OnClick", function()
                if not preview and rowFrame.companionName then
                    pendingOwnedRemovalName = rowFrame.companionName
                    StaticPopup_Show("COMPANION_RECRUITER_REMOVE_OWNED", rowFrame.companionName)
                end
            end)
            row.removeButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(rowFrame.removeButton, "ANCHOR_RIGHT")
                GameTooltip:SetText("Remove from available companions")
                GameTooltip:Show()
            end)
            row.removeButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
            manageRows[j] = row
        end
        row.option = rowTexts[j]
        local _, _, botName, botClass, botSpec, botRole, botRace, botGender, status =
            string.find(row.option, "^(.-) %- (.-) / (.-) / (.-) / (.-) / (.-) %[(.-)%]$")
        if not botName then
            _, _, botName, botClass, botSpec, botRole, status =
                string.find(row.option, "^(.-) %- (.-) / (.-) / (.-) %[(.-)%]$")
        end
        row.companionName = botName
        local roleMap = { tank = "Tank", healer = "Healer", dps = "Damage", damage = "Damage" }
        local role = botRole and roleMap[string.lower(botRole)]
        local specList = botClass and specializationOptions[botClass]
        local specIcon
        if specList then
            local specIndex
            for specIndex = 1, table.getn(specList) do
                if specList[specIndex].name == botSpec then
                    specIcon = specList[specIndex].icon
                    break
                end
            end
        end
        row.label:SetText(botName or row.option)
        SetRaceGenderIcon(row.raceIcon, botRace, botGender)
        SetClassIcon(row.classIcon, botClass)
        row.roleIcon:SetTexture(specIcon or roleIcons[role] or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.button:SetText(status == "Following" and "Dismiss" or (status == "Inviting" and "Cancel" or "Invite"))
        if preview then
            row.button:Disable()
            row.removeButton:Disable()
        else
            row.button:Enable()
            row.removeButton:Enable()
        end
        row:Show()
    end
    if table.getn(rowTexts) == 0 then
        if not manageEmptyText then
            manageEmptyText = Text(manageContent, "No permanent companions yet. Buy one from Permanent Recruitment.",
                "GameFontHighlight", 16, -48, 335, 45, { 1, 1, 1 })
        end
        manageEmptyText:Show()
    end
end

local fillAssignments = NewPage("fillAssignments")
Text(fillAssignments, "Assign Roles", "GameFontNormalLarge", 12, -6, 390, 26, { 0.23, 0.12, 0.035 })
Text(fillAssignments, "Choose a role for yourself and each group member.",
    "GameFontHighlight", 12, -39, 390, 30, { 0.27, 0.17, 0.075 })
local fillTableBg = Box(fillAssignments, 12, -76, 397, 200, 0.07, 0.065, 0.055)
fillTableBg:SetBackdropColor(0.07, 0.065, 0.055, 0.95)
local fillListWidth = 367
local fillRosterHeader = CreateFrame("Frame", nil, fillAssignments)
fillRosterHeader:SetPoint("TOPLEFT", fillTableBg, "TOPLEFT", 5, -5)
fillRosterHeader:SetPoint("TOPRIGHT", fillTableBg, "TOPRIGHT", -5, -5)
fillRosterHeader:SetHeight(22)
local fillRosterHeaderBg = fillRosterHeader:CreateTexture(nil, "BACKGROUND")
fillRosterHeaderBg:SetAllPoints(fillRosterHeader)
fillRosterHeaderBg:SetTexture("Interface\\Buttons\\WHITE8X8")
fillRosterHeaderBg:SetVertexColor(0.14, 0.13, 0.11, 1)
Text(fillRosterHeader, "Name", "GameFontHighlightSmall", 36, -4, 100, 16, { 0.7, 0.7, 0.65 })
Text(fillRosterHeader, "Class", "GameFontHighlightSmall", 151, -4, 80, 16, { 0.7, 0.7, 0.65 })
Text(fillRosterHeader, "Role", "GameFontHighlightSmall", 244, -4, 100, 16, { 0.7, 0.7, 0.65 })
local fillScrollBarBg = CreateFrame("Frame", nil, fillAssignments)
fillScrollBarBg:SetPoint("TOPRIGHT", fillTableBg, "TOPRIGHT", -5, -27)
fillScrollBarBg:SetPoint("BOTTOMRIGHT", fillTableBg, "BOTTOMRIGHT", -5, 5)
fillScrollBarBg:SetWidth(20)
fillScrollBarBg:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
fillScrollBarBg:SetBackdropColor(0.035, 0.032, 0.028, 1)
local fillScroll = CreateFrame("ScrollFrame", "CompanionRecruiterFillRosterScroll", fillAssignments, "UIPanelScrollFrameTemplate")
fillScroll:SetPoint("TOPLEFT", fillTableBg, "TOPLEFT", 5, -27)
fillScroll:SetWidth(fillListWidth)
fillScroll:SetHeight(168)
local fillScrollBar = getglobal(fillScroll:GetName() .. "ScrollBar")
fillScrollBar:ClearAllPoints()
fillScrollBar:SetPoint("TOP", fillScrollBarBg, "TOP", 0, -16)
fillScrollBar:SetPoint("BOTTOM", fillScrollBarBg, "BOTTOM", 0, 16)
local fillContent = CreateFrame("Frame", nil, fillScroll)
fillContent:SetWidth(fillListWidth)
fillContent:SetHeight(1)
fillScroll:SetScrollChild(fillContent)
local fillRows = {}
local fillPreviousButton, fillNextButton, fillCostText, fillConfirmButton
local previewPlayerRole = function()
    local name = UnitName("player") or "You"
    local localizedClass, classToken = UnitClass("player")
    classToken = classToken or localizedClass
    local className = "Warrior"
    local classIndex
    for classIndex = 1, table.getn(classNames) do
        if string.upper(classNames[classIndex]) == string.upper(classToken or "") then
            className = classNames[classIndex]
            break
        end
    end

    local defaultTabs = { Mage = 2, Paladin = 3, Priest = 2, Warrior = 3, Shaman = 2 }
    local selectedTab = defaultTabs[className] or 1
    local highestPoints = 0
    if GetTalentTabInfo then
        local tab
        for tab = 1, 3 do
            local _, _, points = GetTalentTabInfo(tab)
            if points and points > highestPoints then
                highestPoints = points
                selectedTab = tab
            end
        end
    end

    local role = "Damage"
    if className == "Warrior" and selectedTab == 3 then
        role = "Tank"
    elseif className == "Paladin" then
        if selectedTab == 1 then role = "Healer"
        elseif selectedTab == 2 then role = "Tank" end
    elseif className == "Priest" then
        if selectedTab ~= 3 then role = "Healer" end
    elseif className == "Shaman" then
        if selectedTab == 3 then role = "Healer" end
    elseif className == "Druid" then
        if selectedTab == 2 then role = "Tank"
        elseif selectedTab == 3 then role = "Healer" end
    end

    return name, className, role
end

local function FillMemberOption(text)
    local _, _, memberName, className, role = string.find(text,
        "^(.-) %- (.-) %[(.-)%]$")
    if memberName and className and role then
        return memberName, className, role
    end
    return nil
end
local function RefreshFillAssignmentRows()
    local rowTexts = {}
    if preview then
        local name, className, role = previewPlayerRole()
        table.insert(rowTexts, name .. " - " .. className .. " [" .. (previewRoleOverride or role) .. "]")
    else
        local j
        for j = 1, table.getn(options) do
            if FillMemberOption(options[j]) then
                table.insert(rowTexts, options[j])
            end
        end
    end

    local j
    for j = 1, table.getn(fillRows) do fillRows[j]:Hide() end
    fillScroll:SetVerticalScroll(0)
    fillContent:SetHeight(math.max(174, table.getn(rowTexts) * 34))
    for j = 1, table.getn(rowTexts) do
        local row = fillRows[j]
        if not row then
            row = Box(fillContent, 0, -1 - (j - 1) * 34, fillListWidth, 33, 0.055, 0.055, 0.05)
            row:SetBackdropBorderColor(0.22, 0.22, 0.2, 1)
            row.classIcon = row:CreateTexture(nil, "ARTWORK")
            row.classIcon:SetWidth(22)
            row.classIcon:SetHeight(22)
            row.classIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 7, -5)
            row.name = Text(row, "", "GameFontHighlightSmall", 35, -10, 108, 16, { 0.95, 0.83, 0.43 })
            row.class = Text(row, "", "GameFontHighlightSmall", 151, -10, 82, 16, { 0.8, 0.8, 0.76 })
            local rowFrame = row
            row.roleTiles = {}
            local roleIndex
            for roleIndex = 1, table.getn(roleNames) do
                local roleName = roleNames[roleIndex]
                local roleTile = Box(row, 245 + (roleIndex - 1) * 34, -3, 29, 29, 0.08, 0.08, 0.08)
                roleTile:SetBackdropBorderColor(0.42, 0.36, 0.28, 1)
                local roleButton = CreateFrame("Button", nil, roleTile)
                roleButton:SetAllPoints(roleTile)
                roleButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                local roleIcon = roleButton:CreateTexture(nil, "ARTWORK")
                roleIcon:SetTexture(roleIcons[roleName])
                roleIcon:SetWidth(21)
                roleIcon:SetHeight(21)
                roleIcon:SetPoint("CENTER", roleButton, "CENTER", 0, 0)
                local selectedRoleName = roleName
                local roleTileFrame = roleTile
                roleTile.button = roleButton
                roleTile.icon = roleIcon
                roleButton:SetScript("OnClick", function()
                    if not roleTileFrame.available then return end
                    if preview then
                        previewRoleOverride = selectedRoleName
                        rowFrame.roleValue = selectedRoleName
                        local roleIndex
                        for roleIndex = 1, table.getn(roleNames) do
                            local name = roleNames[roleIndex]
                            local tile = rowFrame.roleTiles[name]
                            local selected = name == rowFrame.roleValue and tile.available
                            tile:SetBackdropBorderColor(selected and 1 or (tile.available and 0.42 or 0.22),
                                selected and 0.74 or (tile.available and 0.36 or 0.22),
                                selected and 0.24 or (tile.available and 0.28 or 0.22), 1)
                        end
                    else
                        pendingAssignmentRole = selectedRoleName
                        SelectOption(rowFrame.option)
                    end
                end)
                roleButton:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(roleButton, "ANCHOR_RIGHT")
                    GameTooltip:SetText(roleTileFrame.available and selectedRoleName or
                        (selectedRoleName .. " unavailable for " .. (rowFrame.classValue or "this class")))
                    GameTooltip:Show()
                end)
                roleButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
                row.roleTiles[roleName] = roleTile
            end
            fillRows[j] = row
        end
        local option = rowTexts[j]
        local memberName, className, role = FillMemberOption(option)
        row.option = option
        row.classValue = className
        row.roleValue = role or "Damage"
        row.name:SetText(memberName or option)
        row.class:SetText(className or "")
        SetClassIcon(row.classIcon, className)
        local selectedRoleName = row.roleValue
        local roleIndex
        for roleIndex = 1, table.getn(roleNames) do
            local name = roleNames[roleIndex]
            local tile = row.roleTiles[name]
            local available = IsRoleAvailableForClass(className, name)
            tile.available = available
            tile.button:EnableMouse(available)
            tile:SetAlpha(available and 1 or 0.3)
            tile.icon:SetAlpha(available and 1 or 0.3)
            local selected = name == selectedRoleName and available
            tile:SetBackdropBorderColor(selected and 1 or (available and 0.42 or 0.22),
                selected and 0.74 or (available and 0.36 or 0.22),
                selected and 0.24 or (available and 0.28 or 0.22), 1)
        end
        row:Show()
    end

    if preview then
        fillPreviousButton:Hide()
        fillNextButton:Hide()
        fillConfirmButton:Enable()
    else
        local previous = FindOption("Previous members")
        local nextPage = FindOption("More members")
        if previous then fillPreviousButton:Show() else fillPreviousButton:Hide() end
        if nextPage then fillNextButton:Show() else fillNextButton:Hide() end
        fillCostText:SetText(CostFor("Confirm Roles") or "")
        if HasOption("Confirm Roles") then fillConfirmButton:Enable() else fillConfirmButton:Disable() end
    end
end
fillPreviousButton = Button(fillAssignments, "Previous", 11, -280, 88, 25, function()
    if preview then return end
    SelectOption("Previous members")
end)
fillNextButton = Button(fillAssignments, "More", 105, -280, 88, 25, function()
    if preview then return end
    SelectOption("More members")
end)
fillCostText = MoneyText(fillAssignments, "", "GameFontNormalSmall", 202, -283, 207, 18, { 0.35, 0.19, 0.045 })
fillCostText:SetJustifyH("RIGHT")
local fillCancelButton = Button(fillAssignments, "Cancel", 11, -307, 122, 27, function()
    if preview then ShowPage("main") else SelectOption("Back to recruiter") end
end)
fillConfirmButton = Button(fillAssignments, "Confirm Roles", 246, -307, 163, 27, function()
    if preview then return end
    SelectOption("Confirm Roles")
end)

function CR:UpdateRoleSelection()
    local j
    for j = 1, 3 do
        local name = roleNames[j]
        local previewRole = page ~= "classRole" or name == "Damage" or
            (name == "Tank" and (selectedClass == "Warrior" or selectedClass == "Paladin" or selectedClass == "Druid")) or
            (name == "Healer" and (selectedClass == "Paladin" or selectedClass == "Priest" or selectedClass == "Shaman" or selectedClass == "Druid"))
        local available
        if page == "fillRolePicker" then
            available = preview or HasOption("Set role to " .. name)
        else
            available = (preview and previewRole) or (not preview and (page == "classRole" and HasOption(name) or
                (mode ~= "permanent" and HasOption("I am " .. (name == "Damage" and "damage" or "the " .. string.lower(name))))))
        end
        roleButtons[name].icon:EnableMouse(available)
        roleButtons[name].icon:SetAlpha(available and 1 or 0.3)
        roleButtons[name].tile:SetBackdropBorderColor(selectedRole == name and 1 or 0.42,
            selectedRole == name and 0.72 or 0.36, 0.20, 1)
    end
    recruitButton:SetText(page == "fillRolePicker" and "Choose a Role" or
        (mode == "permanent" and "Buy Companion" or (page == "classRole" and "Recruit Companion" or (raidSize and "Fill Raid" or "Fill Group"))))
    local price = mode == "permanent" and recruitCost or (page == "classRole" and recruitCost or CostFor("I am the tank."))
    roleCost:SetText(price and ("Total cost: " .. price) or "")
    if page ~= "fillRolePicker" and selectedRole and not preview then recruitButton:Enable()
    else recruitButton:Disable() end
end

local function ReadOptions()
    options = {}
    local raw = { GetGossipOptions() }
    local j
    for j = 1, table.getn(raw), 2 do
        table.insert(options, raw[j])
    end
end

local function IsRecruiterMenu()
    -- Permanent recruitment can arrive after the previous gossip was closed.
    -- Identify its own action instead of depending on the previous page's state.
    return HasOption("Recruit a tank companion") or HasOption("Recruit permanent companion") or
        (active and (HasOption("Back to recruiter") or HasOption("Confirm Roles") or
            HasOption("Set role to Tank") or HasOption("Buy another companion")))
end

local function HasClassOption()
    local j
    for j = 1, table.getn(classNames) do
        if HasOption(classNames[j]) then return true end
    end
    return false
end

ShowPage = function(name)
    local key
    for key in pairs(pages) do pages[key]:Hide() end
    classGrid:Hide()
    page = name
    if name == "main" then contentParchment:Hide() else contentParchment:Show() end
    if name == "main" then UpdateMainBackground() end
    if name == "classRole" or name == "fillRole" or name == "fillRolePicker" then
        local choosingClass = name == "classRole"
        rolesTitle:SetText(choosingClass and "Select Class & Specialization" or
            (raidSize and "Your Role - " .. raidSize .. " Player Raid" or "Your Role - Party"))
        if name == "fillRolePicker" then
            rolesTitle:SetText("Assign Role")
            rolesDescription:SetText("Choose a role for " .. (fillRoleMemberName or "this group member") .. ".")
        else
            rolesTitle:SetText(choosingClass and "Select Class & Specialization" or
                (raidSize and "Your Role - " .. raidSize .. " Player Raid" or "Your Role - Party"))
            rolesDescription:SetText(choosingClass and ((selectedClass or "Companion") .. " - Select Specialization") or
                "Select your role. The recruiter fills the remaining positions.")
        end
        if choosingClass then classGrid:Show() end
        local j
        for j = 1, table.getn(classNames) do
            local entry = classButtons[classNames[j]]
            local selected = classNames[j] == selectedClass
            entry.icon:EnableMouse(false)
            entry.tile:SetAlpha(selected and 1 or 0.35)
            ParchmentTextColor(entry.label, 0.25, 0.14, 0.045)
            entry.iconBorder:SetSelected(selected)
        end
        for j = 1, 3 do
            local entry = roleButtons[roleNames[j]]
            entry.tile:ClearAllPoints()
            entry.tile:SetPoint("TOPLEFT", roles, "TOPLEFT", 12 + (j - 1) * 137, choosingClass and -202 or -91)
            entry.tile:SetHeight(choosingClass and 70 or 148)
            entry.icon:SetWidth(choosingClass and 32 or 62)
            entry.icon:SetHeight(choosingClass and 32 or 62)
            entry.icon:ClearAllPoints()
            entry.icon:SetPoint("TOP", entry.tile, "TOP", 0, choosingClass and -6 or -15)
            entry.label:SetHeight(choosingClass and 18 or 30)
            entry.label:ClearAllPoints()
            entry.label:SetPoint("TOPLEFT", entry.tile, "TOPLEFT", 8, choosingClass and -44 or -94)
        end
        CR:UpdateRoleSelection()
        pages.roles:Show()
    elseif name == "raids" then
        local size
        for _, size in ipairs({ 10, 20, 40 }) do
            local price = CostFor("Fill a " .. size .. "-player raid")
            raidCosts[size]:SetText(price or "")
        end
        pages.raids:Show()
    elseif name == "classes" then
        classGrid:Show()
        ParchmentTextColor(classesTitle, 0.18, 0.10, 0.03)
        ParchmentTextColor(classesDescription, 0.22, 0.14, 0.06)
        ParchmentTextColor(classHint, 0.22, 0.14, 0.06)
        if mode == "permanent" then
            classesDescription:SetText("Purchase a companion. Future invitations are free.")
        else
            classesDescription:SetText("Select Class")
        end
        classesTitle:SetText(mode == "permanent" and "Permanent Recruitment" or "Select Class & Specialization")
        local j
        for j = 1, table.getn(classNames) do
            local className = classNames[j]
            local available = preview or HasOption(className)
            local entry = classButtons[className]
            local selected = selectedClass == className
            entry.tile:SetAlpha(available and 1 or 0.3)
            entry.iconBorder:SetSelected(selected and available)
            ParchmentTextColor(entry.label, 0.25, 0.14, 0.045)
            entry.icon:EnableMouse(available)
        end
        pages.classes:Show()
    elseif name == "manage" then
        RefreshManageRows()
        pages.manage:Show()
    elseif name == "fillAssignments" then
        RefreshFillAssignmentRows()
        pages.fillAssignments:Show()
    else
        pages[name]:Show()
    end
    local tabMode, tab
    for tabMode, tab in pairs(tabs) do
        local selected = tabMode == mode
        tab.panel:SetBackdropColor(selected and 0.12 or 0.04, selected and 0.15 or 0.04, selected and 0.18 or 0.04, 1)
        tab.panel:SetBackdropBorderColor(selected and 1 or 0.3, selected and 0.74 or 0.29, selected and 0.2 or 0.26, 1)
        tab.label:SetTextColor(selected and 1 or 0.78, selected and 0.82 or 0.78, selected and 0.3 or 0.74)
    end
    windowTitle:SetText(mode == "manage" and "Companions" or (mode == "permanent" and "Permanent Recruitment" or "Companion Recruitment"))

end

local view = {
    window = window,
    chooseCost = chooseCost,
    fillCost = fillCost,
    fillTitle = fillTitle,
    fillDescription = fillDescription,
    fillButton = fillButton,
    raidButton = raidButton,
    mainDescription = mainDescription,
    chooseButton = chooseButton
}

local function SyncMenu()
    ReadOptions()
    if not IsRecruiterMenu() then
        if preview then view.window:Hide() end
        if active then
            active = false
            view.window:Hide()
            GossipFrame:SetAlpha(1)
            GossipFrame:EnableMouse(true)
        end
        return
    end
    if pendingTab and HasOption("Recruit a tank companion") then
        local target = pendingTab
        pendingTab = nil
        if target ~= "temporary" then
            NavigateTab(target)
            return
        end
    end
    preview = false
    active = true
    GossipFrame:SetAlpha(0)
    GossipFrame:EnableMouse(false)
    if HasOption("Confirm Roles") then
        pendingAssignmentRole = nil
        mode = "temporary"
        ShowPage("fillAssignments")
        view.window:Show()
        return
    elseif HasOption("Set role to Tank") then
        local requestedRole = pendingAssignmentRole
        if requestedRole and HasOption("Set role to " .. requestedRole) then
            pendingAssignmentRole = nil
            SelectOption("Set role to " .. requestedRole)
            return
        end
        pendingAssignmentRole = nil
        mode = "temporary"
        local roleOption = FindOption("Role for ")
        if roleOption then
            local _, _, memberName, currentRole = string.find(options[roleOption],
                "^Role for (.-) %((.-)%)$")
            fillRoleMemberName = memberName
            selectedRole = currentRole
        end
        ShowPage("fillRolePicker")
        view.window:Show()
        return
    end
    if pendingClass and HasOption(pendingClass) then
        local target = pendingClass
        pendingClass = nil
        selectedClass = target
        selectedSpec = nil
        selectedRace = nil
        UpdatePicker()
        SelectOption(target)
        return
    end
    if HasOption("Recruit a tank companion") then
        pendingAssignmentRole = nil
        mode = "temporary"
        selectedClass = nil
        selectedRole = nil
        selectedSpec = nil
        pendingClass = nil
        pickerClassAvailability = {}
        raidSize = nil
        recruitCost = CostFor("Choose a companion's class and specialization") or CostFor("Recruit a tank companion")
        view.chooseCost:SetText(recruitCost and ("Cost: " .. recruitCost) or "")
        local partyCost = CostFor("Fill my party")
        local raid = HasOption("Fill my raid")
        view.fillCost:SetText((raid and CostFor("Fill my raid") or partyCost) and ("Total: " .. (raid and CostFor("Fill my raid") or partyCost)) or "")
        view.fillTitle:SetText(raid and "Fill Raid" or "Fill Group")
        view.fillDescription:SetText(raid and "Recruit the missing tank, healer,\nand damage roles for your raid." or
            "Recruit the missing tank, healer,\nand damage roles for your\nparty.")
        view.fillButton:SetText(raid and "Fill Raid" or "Fill Group")
        view.raidButton:SetText(raid and "Fill Raid" or "Fill Group")
        view.mainDescription:SetText(temporaryDescription)
        view.fillButton:Enable()
        view.raidButton:Enable()
        view.raidButton:Hide()
        if HasOption("Choose a companion's class and specialization") then view.chooseButton:Enable() else view.chooseButton:Disable() end
        ShowPage("main")
    elseif HasOption("Recruit permanent companion") then
        mode = "permanent"
        if HasClassOption() and not HasOption("Race:") and not HasOption("Race unavailable:") then
            -- The class catalogue and details travel in separate, bounded
            -- server responses. Keep a single picker visible throughout.
            if not selectedClass or not HasOption(selectedClass) then selectedClass = "Warrior" end
            selectedSpec = nil
            selectedRace = nil
            ShowPage("picker")
            UpdatePicker()
            view.window:Show()
            SelectOption(selectedClass)
            return
        end
        ShowPage("picker")
        UpdatePicker()
    elseif mode == "manage" then
        ShowPage("manage")
    elseif mode == "permanent" and HasOption("Race:") then
        ShowPage("picker")
        UpdatePicker()
    elseif HasOption("Permanent Recruitment") then
        mode = "permanent"
        ShowPage("picker")
        UpdatePicker()
    elseif mode == "permanent" and selectedClass and HasOption("Choose another class") then
        ShowPage("picker")
        UpdatePicker()
    elseif mode == "permanent" and (HasClassOption() or HasOption("Buy another companion")) then
        selectedClass = "Warrior"
        selectedSpec = nil
        selectedRace = nil
        if HasClassOption() then
            ShowPage("picker")
            UpdatePicker()
        else
            ShowPage("classes")
        end
    elseif mode == "temporary" and selectedClass and HasOption("Choose another class") then
        ShowPage("picker")
        UpdatePicker()
    elseif mode == "temporary" and HasClassOption() then
        ShowPage("picker")
        UpdatePicker()
    elseif mode == "temporary" and HasOption("Choose another class") then
        ShowPage("picker")
        UpdatePicker()
    elseif HasOption("Choose another class") then
        ShowPage("picker")
        UpdatePicker()
    elseif HasClassOption() then
        ShowPage("picker")
        UpdatePicker()
    elseif HasOption("Fill a 10-player raid") then
        ShowPage("raids")
    elseif HasOption("I am the tank.") then
        selectedRole = nil
        ShowPage("fillRole")
    end
    view.window:Show()
end

-- Keep the native gossip frame from opening for recruiter menus. Making it
-- transparent in our own event handler is not sufficient: the stock handler
-- can run afterwards, and its children still belong to the native panel.
-- Do not Hide() the panel here; its OnHide can close the NPC conversation.
local stockGossipOnEvent = GossipFrame:GetScript("OnEvent")
GossipFrame:SetScript("OnEvent", function()
    if event == "GOSSIP_SHOW" then
        ReadOptions()
        if IsRecruiterMenu() then return end
    end
    if stockGossipOnEvent then stockGossipOnEvent() end
end)

CR:SetScript("OnEvent", function()
    if event == "GOSSIP_SHOW" then
        SyncMenu()
    elseif event == "GOSSIP_CLOSED" and active then
        active = false
        pendingTab = nil
        pendingAssignmentRole = nil
        window:Hide()
        GossipFrame:SetAlpha(1)
        GossipFrame:EnableMouse(true)
        page = nil
    end
end)

window:SetScript("OnHide", function()
    if active then CloseGossip() end
    preview = false
end)
table.insert(UISpecialFrames, "CompanionRecruiterWindow")

SLASH_COMPANIONRECRUITERDEBUG1 = "/crdebug"
SlashCmdList["COMPANIONRECRUITERDEBUG"] = function()
    if active then
        window:Show()
        return
    end
    if preview and window:IsShown() then
        window:Hide()
        return
    end
    preview = true
    options = {}
    selectedClass = "Warrior"
    selectedRole = nil
    selectedSpec = nil
    pendingAssignmentRole = nil
    previewRoleOverride = nil
    pendingClass = nil
    pickerClassAvailability = {}
    picker:Hide()
    raidSize = nil
    mode = "temporary"
    recruitCost = nil
    mainDescription:SetText(temporaryDescription)
    fillCost:SetText("")
    chooseCost:SetText("")
    fillButton:Enable()
    chooseButton:Enable()
    raidButton:Disable()
    raidButton:Hide()
    local raid = GetNumRaidMembers() > 0
    fillTitle:SetText(raid and "Fill Raid" or "Fill Group")
    fillButton:SetText(raid and "Fill Raid" or "Fill Group")
    fillDescription:SetText(raid and "Recruit the missing tank, healer,\nand damage roles for your raid." or
        "Recruit the missing tank, healer,\nand damage roles for your\nparty.")
    ShowPage("main")
    window:Show()
end
