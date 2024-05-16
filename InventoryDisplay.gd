extends VBoxContainer

export var item_display_scene_path : Resource 

func _ready():
	clear_items()
	load_items(ItemDatabase.items)

func clear_items():
	for node in get_children():
		if node is ItemInventoryDisplay:
			remove_child(node)
			node.queue_free()

func load_items(items):
	for item_name in items:
		var item = items[item_name]
		var display = item_display_scene_path.instance()
		add_child(display)
		display.item = item
