
---- CONSTANTS

local THORXP_COLOR_NAME = "|cffffff78"
local THORXP_COLOR_NR = "|cffff7831"
local THORXP_COLOR_RESUME = "|r"

---- HELPER FUNCTRIONS

-- Format the given message and extra parameters (effectively using string.format) in the given color.
local function FormatColor(color, message, ...)
    return color .. string.format(message, ...) .. THORXP_COLOR_RESUME
end

-- Format the given number using the given number format (effectively using string.format) using the corresponding color. If format is not given, "%d" is used.
local function FormatNr(nr, format)
    local format = format or "%d"
    return FormatColor(THORXP_COLOR_NR, format, nr)
end

-- Formats the given message and extra parameters and logs it to the default frame.
local function Log(message, ...)
    print(string.format(message, ...))
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

---- CLASS: ThorXP 

ThorXP = {}
ThorXP.__index = ThorXP

function ThorXP:Create()
    local object = {}
    setmetatable(object, ThorXP)
    object.xp_ = GetXP()
    return object
end

function ThorXP:HandleXpUpdate()
	local xp_cur = GetXP()
    local xp_max = GetMaxXP()
    local level = GetLevel()

    local delta = xp_cur - self.xp_
    local goal = xp_max - xp_cur
    local reps = math.ceil(goal / delta)

    Log("%s %s (level %d %s/%s), level %d @ %s (%sx)",
        FormatColor(THORXP_COLOR_NAME, "Experience"),
        FormatNr(delta, "%+d"),
        level,
        FormatNr(xp_cur),
        FormatNr(xp_max),
        level + 1,
        FormatNr(goal),
        FormatNr(reps))

    self.xp_ = xp_cur
end

---- VARIABLES

local ThorXP_Addon = ThorXP:Create()
local ThorXP_Frame = CreateFrame("FRAME", nil, UIParent)

---- SETUP

local function HandleEvent(self, event, ...)
    if (event == "PLAYER_XP_UPDATE") then
        ThorXP_Addon:HandleXpUpdate()
    end
end

ThorXP_Frame:RegisterEvent("PLAYER_XP_UPDATE")
ThorXP_Frame:SetScript("OnEvent", HandleEvent)


---- TODO

-- class colored name
-- color ThorXP
-- color levels
-- level up xp gained is probably incorrect
-- first report is incorrect
-- disable at max level