## ElvUI_QuestCount #TLV changelog

Full changelog: https://github.com/last-voice/ElvUI_QuestCount/blob/main/CHANGELOG.md

v1.4.2.2
- Peeps, I'm working on another. So i changed the file structure of this addon too. This caused quite some chaos. Finally, this version should be stable again. Sorry!

v1.4.2.1
- stupid me :-/

v1.4.2
- Changed the too generic name of saved variable.

v1.4.1
- TLVlib in separate repo

v1.4
- I was all wrong, next try
- Blizzard increased to 35 max, but API C QuestLog.GetMaxNumQuestsCanAccept still returns 25, so I use a constant 35 yet
- Also new calcualtion: All quests but neither hidden nor account quests seem to count against the 35
- Hopefully that'll be true ^^

v1.3
- Never give up - the completed quests seem to count no more

v1.2
- README

v1.1
- Found out how to calculate the real counting standard quests, because certain type of quests don't count against the 25

v1.0
- Here we go
- removed empty esES.lua