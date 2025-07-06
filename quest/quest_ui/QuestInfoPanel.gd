extends Panel

@export var quest_name_label_path : NodePath
@onready var quest_name_label = get_node(quest_name_label_path)
@export var quest_description_text_ui_path : NodePath
@onready var quest_description_text_ui = get_node(quest_description_text_ui_path)

@export var quest_rewards_display_path : NodePath
@onready var quest_rewards_display = get_node(quest_rewards_display_path)

@export var party_name_label_path : NodePath
@onready var party_name_label = get_node(party_name_label_path)

@export var party_info_label_path : NodePath
@onready var party_info_label = get_node(party_info_label_path)

@export var quest_difficulty_display_path : NodePath
@onready var quest_difficulty_display : TextureProgressBar = get_node(quest_difficulty_display_path)

func set_quest(quest : Quest):
	quest_name_label.text = "Quest: " + quest.quest_name
	quest_description_text_ui.text = quest.quest_description
	quest_rewards_display.set_quest(quest)
	quest_difficulty_display.value = quest.get_difficulty()

func set_party(party : AdventuringParty):
	if not is_instance_valid(party):
		party_name_label.text = "Party: No party"
		party_info_label.text = ""
	else:
		party_name_label.text = "Party: " + party.name
		party_info_label.text = ""
		for character in party.get_characters():
			party_info_label.text += character.name + "\n"
