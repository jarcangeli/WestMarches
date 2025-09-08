extends Container
class_name QuestSelectPanel

@onready var quest_name_label: Label = %QuestNameLabel
@onready var quest_description_text: Label = %QuestDescriptionText
@onready var difficulty_bar: TextureProgressBar = %DifficultyBar
@onready var deaths_bar: TextureProgressBar = %DeathsBar
@onready var rewards_container: ItemDisplayContainer = %RewardsContainer
@onready var choose_quest_button: Button = %ChooseQuestButton

var party : AdventuringParty = null
var quest : Quest = null

func set_party(new_party : AdventuringParty):
	party = new_party
	if quest:
		quest.party = new_party
		update_win_percentage()

func set_quest(new_quest : Quest):
	quest = new_quest
	rewards_container.clear_item_views()
	if not quest:
		quest_name_label.text = "Quest: -"
		quest_description_text.text = "..."
		return
	
	quest.party = party
	quest_name_label.text = quest.quest_name
	quest_description_text.text = quest.quest_description
	rewards_container.add_items(quest.get_party_rewards())
	
	update_win_percentage()

func update_win_percentage():
	if not quest or not party:
		difficulty_bar.value = 0
		difficulty_bar.tooltip_text = ""
		deaths_bar.value = 0
		deaths_bar.tooltip_text = ""
		return
	var results := quest.simulate_results() #TODO: Another thread?
	var win_percent = results.get_win_percentage()
	difficulty_bar.value = 100.0 - win_percent
	difficulty_bar.tooltip_text =  "%.1f%% victory" % win_percent
	var deaths = results.get_average_character_deaths()
	var scaled_deaths = deaths * 3 / party.get_characters().size()
	deaths_bar.value = scaled_deaths
	deaths_bar.tooltip_text = "%.1f deaths" % deaths
