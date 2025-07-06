extends VBoxContainer

signal item_selected(item)

@export var item_display_scene_path : Resource 

func clear_items():
	for node in get_children():
		if node is ItemButtonDisplay:
			remove_child(node)
			node.queue_free()

func on_item_selected(item):
	item_selected.emit(item)

func load_items(items):
	for item in items:
		if not item is Item:
			continue
		var display = item_display_scene_path.instantiate()
		add_child(display)
		display.item = item
		
		display.connect("item_selected", Callable(self, "on_item_selected").bind(item)) #ignore errs
		
		var err = connect("item_selected", Callable(display, "on_other_item_selected"))
		if err:
			push_error("Could not hook up item ui deselection: " + err)
		
		err = item.connect("item_changed", Callable(display, "on_item_changed"))
		if err:
			push_error("Could not connect item change to display: " + err)
