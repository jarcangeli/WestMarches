extends Node


func _ready():
	SignalBus.hconnect("quest_completed", self, "on_quest_completed")

func on_quest_completed(quest):
	if not is_instance_valid(quest):
		return
	if quest.get_parent():
		quest.get_parent().remove_child(quest)
	add_child(quest)
