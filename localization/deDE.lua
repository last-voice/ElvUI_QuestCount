if (GetLocale() ~= "deDE") then
    return
end

local L = {}

L["Quests"] = "Quests"

local _, ElvUI_QuestCount = ...
ElvUI_QuestCount.L = setmetatable(L, { __index = ElvUI_QuestCount.L })
