extends Panel

@export var quest_name_label_path : NodePath
@onready var quest_name_label = get_node(quest_name_label_path)
@export var quest_description_text_ui_path : NodePath
@onready var quest_description_text_ui = get_node(quest_description_text_ui_path)

@export var quest_rewards_display_path : NodePath
@onready var quest_rewards_display = get_node(quest_rewards_display_path)

@export var party_summary_path : NodePath
@onready var party_summary = get_node(party_summary_path)

@export var quest_difficulty_display_path : NodePath
@onready var quest_difficulty_display : TextureProgressBar = get_node(quest_difficulty_display_path)

func set_quest(quest : Quest):
	quest_name_label.text = "Quest: " + quest.quest_name
	quest_description_text_ui.text = quest.quest_description
	quest_rewards_display.set_quest(quest)
	quest_difficulty_display.value = quest.get_difficulty()

func set_party(party : AdventuringParty):
	if not is_instance_valid(party):
		party_summary.clear_party()
	else:
		party_summary.set_party(party)
