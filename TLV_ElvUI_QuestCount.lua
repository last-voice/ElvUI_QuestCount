local _, TLVaddon = ...

local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local L = TLVaddon.L

local ElvUIColor

local TLVDataText

function TLVaddon:StandardQuests ()

    local quests, _ = C_QuestLog.GetNumQuestLogEntries()

    local cnt = 0

    for i = 1, quests do

        questInfo = C_QuestLog.GetInfo(i)

        if (questInfo.questID > 0) then

            -- this is a real quest, no header or else

            if (not questInfo.isHidden) then

                -- the quest ist not hidden

                local questType = C_QuestLog.GetQuestType(questInfo.questID)

                if (questType == 0 and questInfo.campaignID == nil) then

                    -- a normal quest and no campaign quest

                    if (not C_QuestLog.IsQuestTrivial(questInfo.questID)) then

                        -- the quest is not trivial

                        -- so this is a standard quest!

                        cnt = cnt + 1

                    end

                end

            end

        end

    end

    return cnt

end

function TLVaddon:OnEvent (event, unit)

    if (self.text == nil) then
        return
    end

    local maxQuests = C_QuestLog.GetMaxNumQuestsCanAccept()

    local _, numQuests = C_QuestLog.GetNumQuestLogEntries()

    local numStandardQuests = TLVaddon:StandardQuests()

    local color

    if (maxQuests - numStandardQuests < 1) then
        color = "|cfff01000"
    elseif (maxQuests - numStandardQuests < 6) then
        color = "|cfff0f010"
    elseif (ElvUIColor) then
        color = ElvUIColor
    end

    local append = ""

    if (numQuests > numStandardQuests) then
        append =  " (+" .. (numQuests - numStandardQuests) .. ")"

    end

    if (color) then
        self.text:SetFormattedText(L["Quests"] .. ": %s%s|r / %s%s|r%s", color, numStandardQuests, color, maxQuests, append)
    else
        self.text:SetFormattedText(L["Quests"] .. ": %s / %s%s", numStandardQuests, maxQuests, append)
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

DT:RegisterDatatext('Quest Count', nil, { 'QUEST_LOG_UPDATE' }, TLVaddon.OnEvent, nil, TLVaddon.OnClick, nil, nil, "Quest Count")

-- DT:RegisterDatatext('Quest Count', nil, { 'PLAYER_ENTERING_WORLD', 'QUEST_ACCEPTED', 'QUEST_AUTOCOMPLETE', 'QUEST_COMPLETE', 'QUEST_DATA_LOAD_RESULT', 'QUEST_DETAIL', 'QUEST_LOG_CRITERIA_UPDATE', 'QUEST_LOG_UPDATE', 'QUEST_POI_UPDATE', 'QUEST_REMOVED', 'QUEST_TURNED_IN', 'QUEST_WATCH_LIST_CHANGED', 'QUEST_WATCH_UPDATE', 'QUESTLINE_UPDATE', 'TASK_PROGRESS_UPDATE', 'TREASURE_PICKER_CACHE_FLUSH', 'WAYPOINT_UPDATE', 'WORLD_QUEST_COMPLETED_BY_SPELL' }, TLVaddon.OnEvent, nil, TLVaddon.OnClick, nil, nil, "Quest Count")
