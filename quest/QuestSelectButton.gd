extends Button
class_name QuestButton

signal quest_selected(selected_quest)

var quest : Quest = null

func _ready():
	var err = connect("pressed", self, "on_pressed")
	if err:
		push_warning(err)
	
	if is_instance_valid(quest):
		text = quest.quest_name
	else:
		push_error("Quest button created with no quest associated")

func on_pressed():
	emit_signal("quest_selected", quest)
