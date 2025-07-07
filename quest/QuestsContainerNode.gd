extends Node

@export var quest_signal : String

func _ready():
	SignalBus.connect(quest_signal, self.on_quest_changed)

func on_quest_changed(quest):
	if not is_instance_valid(quest):
		return
	if quest.get_parent():
		quest.get_parent().remove_child(quest)
	add_child(quest)
