extends Control
class_name ItemDropArea

@export var item_display_container : ItemDisplayContainer

func _can_drop_data(_position, data):
	if not data.has_method("get_item"):
		return false
	var item = data.get_item()
	if not item:
		return false
	return true

func _drop_data(_position, data):
	if not data.has_method("get_item"):
		push_error("Tried to drop something without an item on item drop area")
		return
	var item = data.get_item()
	if not item:
		push_error("Dropping invalid item")
		return
	print("Dropped item " + item.item_name)
	var source = data.get_parent()
	if source.get_parent():
		source.remove_child(data)
		data.queue_free()
	item_display_container.add_item(item)
