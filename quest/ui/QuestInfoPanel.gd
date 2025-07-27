extends Panel

@export var quest_name_label : Label
@export var quest_description_text_ui : Label
@export var quest_rewards_display : QuestRewardsDisplay
@export var party_summary : PartySummaryUI
@export var quest_difficulty_display : TextureProgressBar
@onready var deaths_bar: TextureProgressBar = %DeathsBar

func set_quest(quest : Quest):
	if not quest.party:
		return #TODO: Handle?
	set_party(quest.party)
	quest_name_label.text = "Quest: " + quest.quest_name
	quest_description_text_ui.text = quest.quest_description
	quest_rewards_display.set_quest(quest)
	quest_difficulty_display.value = quest.get_difficulty()
	
	var results := quest.simulate_results() #TODO: Another thread?
	var win_percent = results.get_win_percentage()
	quest_difficulty_display.value = 100.0 - win_percent
	quest_difficulty_display.tooltip_text = str(win_percent) + "%"
	var deaths = results.get_average_character_deaths()
	deaths_bar.value = deaths

func set_party(party : AdventuringParty):
	if not is_instance_valid(party):
		party_summary.clear_party()
	else:
		party_summary.set_party(party)
