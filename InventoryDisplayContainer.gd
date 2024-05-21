extends VBoxContainer

signal item_selected(item)

export var item_display_scene_path : Resource 

func _ready():
	clear_items()
	load_items(ItemDatabase.items)

func clear_items():
	for node in get_children():
		if node is ItemInventoryDisplay:
			remove_child(node)
			node.queue_free()

func on_item_selected(item):
	emit_signal("item_selected", item)

func load_items(items):
	for item_name in items:
		var item : Item = items[item_name]
		var display = item_display_scene_path.instance()
		add_child(display)
		display.item = item
		
		display.connect("item_selected", self, "on_item_selected", [item]) #ignore errs
		
		var err = connect("item_selected", display, "on_other_item_selected")
		if err:
			push_error("Could not hook up item ui deselection: " + err)
		
		err = item.connect("item_changed", display, "on_item_changed")
		if err:
			push_error("Could not connect item change to display: " + err)
