-- CONSTANTS

local ADDON_NAME = "ThorExperience"
local ADDON_VERSION = "1.0.0"
local ADDON_AUTHOR = "Thorinsøn"

local COLOR_NAME = "|cffffff78"
local COLOR_NR = "|cffff7831"
local COLOR_LOG = "|cffff7f00"
local COLOR_RESUME = "|r"


-- FUNCTIONS

local function FormatColor(color, message, ...)
    return color .. string.format(message, ...) .. COLOR_RESUME
end

local function FormatColorClass(class, message, ...)
    local _, _, _, color = GetClassColor(class)
    return FormatColor("|c" .. color, message, ...)
end

local function FormatNr(nr, format)
    local format = format or "%d"
    return FormatColor(COLOR_NR, format, nr)
end

local function LogPlain(message, ...)
    print(string.format(message, ...))
end

local function Log(message, ...)
    print(FormatColor(COLOR_LOG, "[" .. ADDON_NAME .. "] " .. message, ...))
end

local function LogDebug(message, ...)
    Log("[DBG] " .. message, ...)
end

local function GetXP()
    return UnitXP("player")
end

local function GetMaxXP()
    return UnitXPMax("player")
end

local function GetLevel()
    return UnitLevel("player")
end


----- CLASS - ThorExperience

local ThorExperience = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0")

function ThorExperience:OnPlayerXpUpdate()
    LogDebug("OnPlayerXpUpdate")

    LogDebug("state - xp: %d xp_max: %d level: %d", self.xp, self.xp_max, self.level)

    local xp = GetXP()
    local xp_max = GetMaxXP()
    local level = GetLevel()

    local delta = xp - self.xp
    if level ~= self.level then
        delta = delta + self.xp_max
    end
    local goal = xp_max - xp
    local reps = math.ceil(goal / delta)

    LogDebug("new - xp: %d xp_max: %d level: %d - delta: %+d", xp, xp_max, level, delta)

    if delta ~= 0 then
        LogPlain("%s %s | level %d %s/%s | level %d at %s (%sx)",
            FormatColor(COLOR_NAME, "Experience"),
            FormatNr(delta, "%+d"),
            level,
            FormatNr(xp),
            FormatNr(xp_max),
            level + 1,
            FormatNr(goal),
            FormatNr(reps))
    end

    self.xp = xp
    self.xp_max = xp_max
    self.level = level
end

function ThorExperience:OnEnable()
    LogDebug("OnEnable")

    self.xp = GetXP()
    self.xp_max = GetMaxXP()
    self.level = GetLevel()

    LogDebug("state - xp: %d xp_max: %d level: %d", self.xp, self.xp_max, self.level)

    self:RegisterEvent("PLAYER_XP_UPDATE", "OnPlayerXpUpdate")

    Log("version " .. ADDON_VERSION .. " by " .. FormatColorClass("HUNTER", ADDON_AUTHOR) ..  " initialized")
end
