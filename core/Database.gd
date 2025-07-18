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

func load_row(_row):
	pass #Override

func load_table(table_name):
	var table = DB.get_table(table_name)
	if not table:
		push_error("Could not load table from db: " + table_name)
		return
	for row in table:
		load_row(row)
