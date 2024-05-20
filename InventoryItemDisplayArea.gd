extends Control

func get_item():
	return get_parent().item

func get_drag_data(_position):
	set_drag_preview(make_item_preview())
	var item = get_item()
	print("Picked up " + item.item_name)
	return item

func make_item_preview():
	var item = get_item()
	if not is_instance_valid(item):
		return null
	var sprite = TextureRect.new()
	sprite.texture = item.icon
	return sprite
