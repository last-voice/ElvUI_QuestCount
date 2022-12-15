local _, TLVaddon = ...

local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local L = TLVaddon.L

local FormatedString = "%s / %s"

local ElvUIColor

local TLVDataText

function TLVaddon:OnEvent (event, unit)

    local _, numQuests = C_QuestLog.GetNumQuestLogEntries()

    local maxQuests = C_QuestLog.GetMaxNumQuestsCanAccept()

    local color

    if (numQuests + 2 >= maxQuests) then
        color = "|cfff01000"
    elseif (ElvUIColor) then
        color = ElvUIColor
    end

    if (color) then
        self.text:SetFormattedText(L["Quests"] .. ": %s%s|r / %s%s|r", color, numQuests, color, C_QuestLog.GetMaxNumQuestsCanAccept())
    else
        self.text:SetFormattedText(L["Quests"] .. ": %s / %s", numQuests, C_QuestLog.GetMaxNumQuestsCanAccept())
    end

    TLVDataText = self

end

function TLVaddon:OnClick ()

    ToggleQuestLog()

end

local function ValueColorUpdate (hex)

    ElvUIColor = hex

    if TLVDataText then
        TLVaddon:OnEvent(TLVDataText)
    end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Quest Count', nil, { 'PLAYER_ENTERING_WORLD', 'QUEST_ACCEPTED', 'QUEST_AUTOCOMPLETE', 'QUEST_COMPLETE', 'QUEST_DATA_LOAD_RESULT', 'QUEST_DETAIL', 'QUEST_LOG_CRITERIA_UPDATE', 'QUEST_LOG_UPDATE', 'QUEST_POI_UPDATE', 'QUEST_REMOVED', 'QUEST_TURNED_IN', 'QUEST_WATCH_LIST_CHANGED', 'QUEST_WATCH_UPDATE', 'QUESTLINE_UPDATE', 'TASK_PROGRESS_UPDATE', 'TREASURE_PICKER_CACHE_FLUSH', 'WAYPOINT_UPDATE', 'WORLD_QUEST_COMPLETED_BY_SPELL' }, TLVaddon.OnEvent, nil, TLVaddon.OnClick, nil, nil, "Quest Count")
