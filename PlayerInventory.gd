extends Node
class_name PlayerInventory

func _ready():
	Globals.player_inventory = self

func add_item(item):
	if not is_instance_valid(item):
		return
	
	if is_instance_valid(item.get_parent()):
		item.get_parent().remove_child(item)
	add_child(item)

func add_rewards(quest : Quest):
	if not is_instance_valid(quest):
		return
	
	for item in quest.get_rewards():
		if item is Item:
			add_item(item)
	
	SignalBus.emit_signal("player_inventory_changed")
