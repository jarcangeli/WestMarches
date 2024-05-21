extends Control

func get_item():
	return get_parent().item

func get_drag_data(_position):
	var item = get_item()
	set_drag_preview(Item.make_item_preview(item))
	print("Picked up " + item.item_name)
	return item
