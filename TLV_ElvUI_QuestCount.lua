local QuestCount_Name, QuestCount = ...

local L = QuestCount.L
local TLVlib = QuestCount.TLVlib

QuestCount.E = unpack(ElvUI) -- EvlUI needed
QuestCount.DT = QuestCount.E:GetModule("DataTexts") -- DataTexts needed

function QuestCount:qdbg (cnt, questInfo)

    if (cnt == 1) then
        TLVlib:Debug("--- --- --- --- --- --- --- --- --- ---")
    end

    local questType = C_QuestLog.GetQuestType(questInfo.questID)

    local append = ""

    -- IntelliJ-IDEA-Lua-IDE-WoW-API/APIs/QuestLog.lua:339
    --QuestTag.Group = 1
    --QuestTag.PvP = 41
    --QuestTag.Raid = 62
    --QuestTag.Dungeon = 81
    --QuestTag.Legendary = 83
    --QuestTag.Heroic = 85
    --QuestTag.Raid10 = 88
    --QuestTag.Raid25 = 89
    --QuestTag.Scenario = 98
    --QuestTag.Account = 102
    --QuestTag.CombatAlly = 266

    if (questType == 1) then
        append = append .. " ....t:group"
    elseif (questType == 41) then
        append = append .. " ....t:pvp"
    elseif (questType == 62) then
        append = append .. " ....t:raid"
    elseif (questType == 81) then
        append = append .. " ....t:dungeon"
    elseif (questType == 83) then
        append = append .. " ....t:legendary"
    elseif (questType == 85) then
        append = append .. " ....t:heroic"
    elseif (questType == 88) then
        append = append .. " ....t:raid10"
    elseif (questType == 89) then
        append = append .. " ....t:raid25"
    elseif (questType == 98) then
        append = append .. " ....t:scenario"
    elseif (questType == 102) then
        append = append .. " ....t:account"
    elseif (questType == 266) then
        append = append .. " ....t:combatally"
    elseif (questType > 0) then
        append = append .. " ....t:" .. questType
    end

    if (questInfo.campaignID) then
        append = append .. " ....c:" .. questInfo.campaignID
    end

    if (questInfo.frequency ~= nil) then
        if (questInfo.frequency > 0) then
            append = append .. " ....f:" .. questInfo.frequency
        end
    end

    if (questInfo.isHidden) then
        append = append .. " ....hidden"
    end

    if (questInfo.isTask) then
        append = append .. " ....tast"
    end

    if (questInfo.isBounty) then
        append = append .. " ....bounty"
    end

    if (questInfo.isStory) then
        append = append .. " ....story"
    end

    if (not questInfo.isScaling) then
        append = append .. " ....!scaling"
    end

    if (questInfo.isAutoComplete) then
        append = append .. " ....autocomplete"
    end

    if (C_QuestLog.IsWorldQuest(questInfo.questID)) then
        append = append .. " ....worldq"
    end

    if (C_QuestLog.QuestHasWarModeBonus(questInfo.questID)) then
        append = append .. " ....warmodebonus"
    end

    if (C_QuestLog.IsThreatQuest(questInfo.questID)) then
        append = append .. " ....threat"
    end

    if (C_QuestLog.IsRepeatableQuest(questInfo.questID)) then
        append = append .. " ....repeatable"
    end

    if (C_QuestLog.IsQuestTrivial(questInfo.questID)) then
        append = append .. " ....trivial"
    end

    if (C_QuestLog.IsQuestTask(questInfo.questID)) then
        append = append .. " ....task"
    end

    if (C_QuestLog.IsQuestReplayable(questInfo.questID)) then
        append = append .. " ....replayable"
    end

    if (C_QuestLog.IsQuestInvasion(questInfo.questID)) then
        append = append .. " ....invasion"
    end

    if (C_QuestLog.IsQuestCalling(questInfo.questID)) then
        append = append .. " ....calling"
    end

    if (not C_QuestLog.IsOnQuest(questInfo.questID)) then
        append = append .. " ....!ison"
    end

    if (C_QuestLog.IsLegendaryQuest(questInfo.questID)) then
        append = append .. " ....legendary"
    end

    if (C_QuestLog.IsAccountQuest(questInfo.questID)) then
        append = append .. " ....account"
    end

    if (C_QuestLog.IsComplete(questInfo.questID)) then
        append = append .. " ....complete"
    end

    TLVlib:Debug(cnt .. " " .. questInfo.questID .. " " .. questInfo.title .. append)


end

function QuestCount:CountingQuests ()

    local quests, _ = C_QuestLog.GetNumQuestLogEntries()

    local cnt = 0

    for i = 1, quests do

        questInfo = C_QuestLog.GetInfo(i)

        if (questInfo.questID > 0) then

            if (not C_QuestLog.IsAccountQuest(questInfo.questID)) then
                -- no account quest

                if (not questInfo.isHidden) then
                    -- no hidden quests
                    cnt = cnt + 1

                    QuestCount:qdbg(cnt, questType, questInfo)


                end

            end

        end

        return cnt

    end

end

function QuestCount:OnEvent (event, arg1)

    if (self.text == nil) then
        return
    end

    local maxQuests = 35 -- C_QuestLog.GetMaxNumQuestsCanAccept()

    local _, numQuests = C_QuestLog.GetNumQuestLogEntries()

    local numStandardQuests = QuestCount:CountingQuests()

    numStandardQuests = numQuests

    local color

    if (maxQuests - numStandardQuests < 1) then
        color = "|cfff01000"
    elseif (maxQuests - numStandardQuests < 6) then
        color = "|cfff0f010"
    elseif (QuestCount.ElvUIColor) then
        color = QuestCount.ElvUIColor
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

    QuestCount.DataText = self

end

function QuestCount:OnClick ()

    ToggleQuestLog()

end

local function ValueColorUpdate (hex)

    QuestCount.ElvUIColor = hex

    if QuestCount.DataText then
        QuestCount:OnEvent(QuestCount.DataText)
    end
end

QuestCount.E.valueColorUpdateFuncs[ValueColorUpdate] = true

QuestCount.DT:RegisterDatatext('Quest Count', nil, { 'QUEST_LOG_UPDATE' }, QuestCount.OnEvent, nil, QuestCount.OnClick, nil, nil, "Quest Count")

-- QuestCount.DT:RegisterDatatext('Quest Count', nil, { 'PLAYER_ENTERING_WORLD', 'QUEST_ACCEPTED', 'QUEST_AUTOCOMPLETE', 'QUEST_COMPLETE', 'QUEST_DATA_LOAD_RESULT', 'QUEST_DETAIL', 'QUEST_LOG_CRITERIA_UPDATE', 'QUEST_LOG_UPDATE', 'QUEST_POI_UPDATE', 'QUEST_REMOVED', 'QUEST_TURNED_IN', 'QUEST_WATCH_LIST_CHANGED', 'QUEST_WATCH_UPDATE', 'QUESTLINE_UPDATE', 'TASK_PROGRESS_UPDATE', 'TREASURE_PICKER_CACHE_FLUSH', 'WAYPOINT_UPDATE', 'WORLD_QUEST_COMPLETED_BY_SPELL' }, QuestCount.OnEvent, nil, QuestCount.OnClick, nil, nil, "Quest Count")

function QuestCount:Init (event, arg1)

    if event == "ADDON_LOADED" and arg1 == QuestCount_Name then

        TLVlib:Init()

        self:UnregisterEvent("ADDON_LOADED")

    end

end

local TLV_Event_Frame = CreateFrame("Frame")
TLV_Event_Frame:RegisterEvent("ADDON_LOADED")
TLV_Event_Frame:SetScript("OnEvent", QuestCount.Init)
