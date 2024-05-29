extends Node


func _ready():
	SignalBus.hconnect("quest_finished", self, "on_quest_finished")

func on_quest_finished(quest):
	if not is_instance_valid(quest):
		return
	if quest.get_parent():
		quest.get_parent().remove_child(quest)
	add_child(quest)
