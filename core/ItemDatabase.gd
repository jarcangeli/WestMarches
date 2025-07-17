extends Node

const items_path = "res://core/databases/items"
const icons_path = "res://assets/icons/items/"

var icons_by_name = {}

var items_by_index = {}
var items_by_name = {}

enum ITEM_TABLE_HEADER
{
	ID,
	ITEM_NAME,
	DESCRIPTION,
	ICON,
	PRIMARY_SLOT_TYPE,
	CONSUMED_ON_ACQUIRE,
	CONSTITUTION_BONUS,
	STRENGTH_BONUS,
	DEXTERITY_BONUS,
	CURRENCY_GENERATED
}

func _ready():
	
	preload_icons(icons_path)
	
	get_items_from_path(items_path)

func preload_icons(path):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load items path: " + path)
		return
	
	dir.list_dir_begin()
	var item_file_name = "gogogo"
	while item_file_name != "":
		item_file_name = dir.get_next()
		if item_file_name.ends_with(".import"):
			continue
		var file_path = icons_path + '/' + item_file_name
		var icon : Texture2D = load(file_path)
		if icon:
			icons_by_name[item_file_name] = icon

func get_items_from_path(path):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load items path: " + path)
		return
	
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var item_file_name = "gogogo"
	while item_file_name != "":
		item_file_name = dir.get_next()
		var file_path = items_path + '/' + item_file_name
		if not dir.current_is_dir() and item_file_name.ends_with(".csv"):
			# File
			var file = FileAccess.open(file_path, FileAccess.READ)
			if not file:
				continue
			
			var header = file.get_csv_line()
			while !file.eof_reached():
				var csv = file.get_csv_line()
				if len(csv) < len(header):
					continue
				var item_data = ItemData.new()
				item_data.id = int(csv[ITEM_TABLE_HEADER.ID])
				item_data.item_name = csv[ITEM_TABLE_HEADER.ITEM_NAME]
				item_data.description = csv[ITEM_TABLE_HEADER.DESCRIPTION]
				item_data.icon = icons_by_name[csv[ITEM_TABLE_HEADER.ICON]] #TODO: Test if wrong
				item_data.primary_slot_type = Item.shortname_to_slot(csv[ITEM_TABLE_HEADER.PRIMARY_SLOT_TYPE])
				item_data.consumed_on_acquire = bool(int(csv[ITEM_TABLE_HEADER.CONSUMED_ON_ACQUIRE]))
				item_data.constitution_bonus = int(csv[ITEM_TABLE_HEADER.CONSTITUTION_BONUS])
				item_data.strength_bonus = int(csv[ITEM_TABLE_HEADER.STRENGTH_BONUS])
				item_data.dexterity_bonus = int(csv[ITEM_TABLE_HEADER.DEXTERITY_BONUS])
				item_data.currency_generated = int(csv[ITEM_TABLE_HEADER.CURRENCY_GENERATED])
				if not item_data.valid():
					continue
				
				var item = Item.new(item_data)
				if not item:
					continue
				items_by_index[item.id] = item
				items_by_name[item.item_name] = item #TODO: Sanitize for mods, or remove
