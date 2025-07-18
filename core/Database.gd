extends Node
class_name Database

func preload_icons(path, container):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load items path: " + path)
		return
	
	dir.list_dir_begin()
	var item_file_name = "gogogo"
	while item_file_name != "":
		item_file_name = dir.get_next()
		if item_file_name.ends_with(".import") or item_file_name.is_empty():
			continue
		var file_path = path + item_file_name
		var icon : Texture2D = load(file_path)
		if icon:
			container[item_file_name] = icon

func load_header(_header):
	pass

func load_line(_csv):
	pass

func get_database_from_path(path):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load database path: " + path)
		return
	
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = "gogogo"
	while file_name != "":
		file_name = dir.get_next()
		var file_path = path + "/" + file_name
		if not dir.current_is_dir() and file_name.ends_with(".csv"):
			# File
			var file = FileAccess.open(file_path, FileAccess.READ)
			if not file:
				continue
			
			var header = file.get_csv_line()
			load_header(header)
			while !file.eof_reached():
				var csv = file.get_csv_line()
				if len(csv) < len(header):
					continue
				load_line(csv)
