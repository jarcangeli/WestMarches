extends Control

var drag_enabled : bool = true

func get_item():
	return get_parent().item

func get_drag_data(_position):
	if not drag_enabled:
		return null
	var item = get_item()
	set_drag_preview(Item.make_item_preview(item))
	print("Picked up " + item.item_name)
	return item
