extends Panel

@export var quest_name_label : Label
@export var quest_description_text_ui : Label
@export var quest_rewards_display : QuestRewardsDisplay
@export var party_summary : PartySummaryUI
@export var quest_difficulty_display : TextureProgressBar

func set_quest(quest : Quest):
	quest_name_label.text = "Quest: " + quest.quest_name
	quest_description_text_ui.text = quest.quest_description
	quest_rewards_display.set_quest(quest)
	quest_difficulty_display.value = quest.get_difficulty()
	
	var win_percent = quest.simulate_win_percentage() #TODO: Another thread?
	quest_difficulty_display.value = 100.0 - win_percent
	quest_difficulty_display.tooltip_text = str(win_percent) + "%"

func set_party(party : AdventuringParty):
	if not is_instance_valid(party):
		party_summary.clear_party()
	else:
		party_summary.set_party(party)
