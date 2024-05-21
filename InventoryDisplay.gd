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
		var item : Item = items[item_name]
		var display = item_display_scene_path.instance()
		add_child(display)
		display.item = item
		
		var err = item.connect("item_changed", display, "on_item_changed")
		if err:
			push_error("Could not connect item change to display: " + err)
