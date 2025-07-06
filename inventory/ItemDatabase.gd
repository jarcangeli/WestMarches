extends Node

const items_path = "res://items/"

var items = {}

func _ready():
	get_items_from_path(items_path)

func get_items_from_path(path):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load items path: " + path)
		return
	
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var item_file_name = dir.get_next()
	while item_file_name != "":
		var item_path = items_path + item_file_name
		if not dir.current_is_dir():
			# File
			var item = ResourceLoader.load(item_path).instantiate()
			if not item:
				push_error("Failed to load item at " + item_path)
			elif item.item_name in items:
				push_warning("Duplicate item found at " + item_path)
			else:
				add_child(item)
				items[item.item_name] = item
		
		item_file_name = dir.get_next()
