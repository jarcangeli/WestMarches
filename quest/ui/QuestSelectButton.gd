extends AudioButton
class_name QuestButton

signal quest_selected(selected_quest)

var quest : Quest = null

func _ready():
	super._ready()
	var err = connect("pressed", Callable(self, "on_pressed"))
	if err:
		push_warning(err)
	
	if is_instance_valid(quest):
		text = quest.quest_name
	else:
		push_error("Quest button created with no quest associated")

func on_pressed():
	quest_selected.emit(quest)
