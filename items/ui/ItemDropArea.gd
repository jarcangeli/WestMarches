extends Control
class_name ItemDropArea

@export var drop_enabled := true
@export var item_display_container : ItemDisplayContainer

func _can_drop_data(_position, data):
	if not drop_enabled:
		return false
	if not data.has_method("get_item"):
		return false
	var item = data.get_item()
	if not item:
		return false
	if self == item.get_parent():
		return false
	return true

func _drop_data(_position, data):
	if not drop_enabled:
		push_warning("Tried to drop item on disabled drop area")
		return false
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
	
	if not item_display_container:
		push_error("Tried to drop item on area with no associated container")
		return
	item_display_container.add_item(item)
