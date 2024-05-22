extends Panel

signal quest_chosen(quest)

export var name_label_path : NodePath
onready var name_label = get_node(name_label_path)
export var description_text_ui_path : NodePath
onready var description_text_ui = get_node(description_text_ui_path)

var quest : Quest = null

func set_quest(new_quest : Quest):
	quest = new_quest
	name_label.text = new_quest.quest_name
	description_text_ui.text = new_quest.quest_description

func on_choose_quest_button_pressed():
	emit_signal("quest_chosen", quest)
