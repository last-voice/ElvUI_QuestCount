local TLVaddonName, TLVaddon = ...

local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local L = TLVaddon.L
local TLV = TLVaddon.TLV

local ElvUIColor

local TLVDataText

function TLVaddon:qdbg (cnt, questInfo)

    if (cnt == 1) then
        TLV:Debug("--- --- --- --- --- --- --- --- --- ---")
    end

    append = ""

    if (questInfo.frequency ~= nil) then
        if (questInfo.frequency > 0) then
            append = " ....f:" .. questInfo.frequency
        end
    end

    if (questInfo.isTask) then
        append = " ....tast"
    end

    if (questInfo.isBounty) then
        append = " ....bounty"
    end

    if (questInfo.isStory) then
        append = " ....story"
    end

    if (not questInfo.isScaling) then
        append = " ....!scaling"
    end

    if (questInfo.isAutoComplete) then
        append = " ....autocomplete"
    end

    if (C_QuestLog.IsWorldQuest(questInfo.questID)) then
        append = " ....worldq"
    end

    if (C_QuestLog.QuestHasWarModeBonus(questInfo.questID)) then
        append = " ....warmodebonus"
    end

    if (C_QuestLog.IsThreatQuest(questInfo.questID)) then
        append = " ....threat"
    end

    if (C_QuestLog.IsRepeatableQuest(questInfo.questID)) then
        append = " ....repeatable"
    end

    if (C_QuestLog.IsQuestTrivial(questInfo.questID)) then
        append = " ....trivial"
    end

    if (C_QuestLog.IsQuestTask(questInfo.questID)) then
        append = " ....task"
    end

    if (C_QuestLog.IsQuestReplayable(questInfo.questID)) then
        append = " ....replayable"
    end

    if (C_QuestLog.IsQuestInvasion(questInfo.questID)) then
        append = " ....invasion"
    end

    if (C_QuestLog.IsQuestCalling(questInfo.questID)) then
        append = " ....calling"
    end

    if (not C_QuestLog.IsOnQuest(questInfo.questID)) then
        append = " ....!ison"
    end

    if (C_QuestLog.IsLegendaryQuest(questInfo.questID)) then
        append = " ....legendary"
    end

    if (C_QuestLog.IsAccountQuest(questInfo.questID)) then
        append = " ....account"
    end

    TLV:Debug(cnt .. " " .. questInfo.questID .. " " .. questInfo.title .. append)


end

function TLVaddon:StandardQuests ()

    local quests, _ = C_QuestLog.GetNumQuestLogEntries()

    local cnt = 0

    for i = 1, quests do

        questInfo = C_QuestLog.GetInfo(i)

        if (questInfo.questID > 0) then

            -- this is a real quest, no header or else

            if (questInfo.campaignID == nil) then

                -- no campaign quest

                if (not questInfo.isHidden) then

                    -- the quest ist not hidden

                    local questType = C_QuestLog.GetQuestType(questInfo.questID)

                    if (not C_QuestLog.IsComplete(questInfo.questID)) then

                        -- quest is not complete

                        if (not C_QuestLog.IsQuestTrivial(questInfo.questID)) then

                            -- the quest is not trivial

                            -- so this is a standard quest!

                            cnt = cnt + 1

                            -- TLVaddon:qdbg(cnt, questInfo)

                        end

                    end

                end

            end

        end

    end

    return cnt

end

function TLVaddon:OnEvent (event, arg1)

    if event == "ADDON_LOADED" and arg1 == TLVaddonName then

        TLVaddon.AddOnTitle = GetAddOnMetadata(TLVaddonName, "Title")
        TLVaddon.AddOnVersion = GetAddOnMetadata(TLVaddonName, "Version")

        QuestCountFrame:UnregisterEvent("ADDON_LOADED")

        return

    end

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
        append = " (+" .. (numQuests - numStandardQuests) .. ")"

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

QuestCountFrame = CreateFrame("Frame")

QuestCountFrame:RegisterEvent("ADDON_LOADED")
QuestCountFrame:SetScript("OnEvent", TLVaddon.OnEvent)

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Quest Count', nil, { 'PLAYER_ENTERING_WORLD', 'QUEST_LOG_UPDATE' }, TLVaddon.OnEvent, nil, TLVaddon.OnClick, nil, nil, "Quest Count")

-- DT:RegisterDatatext('Quest Count', nil, { 'PLAYER_ENTERING_WORLD', 'QUEST_ACCEPTED', 'QUEST_AUTOCOMPLETE', 'QUEST_COMPLETE', 'QUEST_DATA_LOAD_RESULT', 'QUEST_DETAIL', 'QUEST_LOG_CRITERIA_UPDATE', 'QUEST_LOG_UPDATE', 'QUEST_POI_UPDATE', 'QUEST_REMOVED', 'QUEST_TURNED_IN', 'QUEST_WATCH_LIST_CHANGED', 'QUEST_WATCH_UPDATE', 'QUESTLINE_UPDATE', 'TASK_PROGRESS_UPDATE', 'TREASURE_PICKER_CACHE_FLUSH', 'WAYPOINT_UPDATE', 'WORLD_QUEST_COMPLETED_BY_SPELL' }, TLVaddon.OnEvent, nil, TLVaddon.OnClick, nil, nil, "Quest Count")
