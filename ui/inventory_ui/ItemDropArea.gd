extends Control
class_name ItemDropArea

@export var item_container : ItemDisplayContainer

func _can_drop_data(_position, data):
	if not (data is Item):
		return false
	if data.get_parent() == item_container:
		return false
	return true

func _drop_data(_position, data):
	if not (data is Item):
		push_error("Tried to drop non-item on equipment container")
		return
	print("Dropped item " + data.item_name)
	var source = data.get_parent()
	if source.has_method("remove_item"): #TODO: Source is the rewards node in QuestKill
		source.remove_item(data)
	item_container.add_item(data)
