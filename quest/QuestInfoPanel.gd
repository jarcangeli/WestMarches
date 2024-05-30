extends Panel

export var name_label_path : NodePath
onready var name_label = get_node(name_label_path)
export var description_text_ui_path : NodePath
onready var description_text_ui = get_node(description_text_ui_path)

func set_quest(quest : Quest):
	name_label.text = quest.quest_name
	description_text_ui.text = quest.quest_description
