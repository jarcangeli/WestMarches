extends Container
class_name QuestSelectPanel

signal quest_chosen(quest)

@onready var quest_name_label: Label = %QuestNameLabel
@onready var quest_description_text: Label = %QuestDescriptionText
@onready var difficulty_bar: TextureProgressBar = %DifficultyBar
@onready var deaths_bar: TextureProgressBar = %DeathsBar
@onready var rewards_container: ItemDisplayContainer = %RewardsContainer
@onready var choose_quest_button: Button = %ChooseQuestButton
@onready var guide_label: Label = %GuideLabel

var party : AdventuringParty = null
var quest : Quest = null

func _ready():
	choose_quest_button.pressed.connect(on_choose_quest)

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
	var scaled_deaths = round(deaths * 3.0 / party.get_characters().size())
	#print("Deaths ", deaths, ". scaled: ", scaled_deaths)
	deaths_bar.value = round(scaled_deaths)
	deaths_bar.tooltip_text = "%.1f deaths" % deaths

func on_choose_quest():
	quest_chosen.emit(quest)
	AudioBus.play.emit(AudioBus.quest_select) 

func toggle_running_quest(is_running_quest):
	choose_quest_button.visible = not is_running_quest
	guide_label.text = "Current Quest. Advance time to progress." if is_running_quest else "Choose a quest for the party to embark on"
