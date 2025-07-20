extends Database

const items_table_name = "items"
const icons_path = "res://assets/icons/items/"

var icons_by_name = {}

var item_data_by_index = {}
var item_data_by_name = {}

func _ready():
	preload_icons(icons_path, icons_by_name)
	load_table(items_table_name)

func load_row(row : Dictionary):
	var item_data = ItemData.new()
	item_data.id = int(row["id"])
	item_data.item_name = row["name"]
	item_data.description = row["description"]
	item_data.icon = icons_by_name[row["icon"]] #TODO: Test if wrong
	item_data.primary_slot_type = Item.shortname_to_slot(row["slot"])
	item_data.consumed_on_acquire = bool(int(row["consumed"]))
	item_data.constitution_bonus = int(row["con"])
	item_data.strength_bonus = int(row["str"])
	item_data.dexterity_bonus = int(row["dex"])
	item_data.currency_generated =int(row["currency_generated"])
	if item_data.valid():
		item_data_by_index[item_data.id] = item_data
		item_data_by_name[item_data.item_name] = item_data #TODO: Sanitize for mods, or remove

func generate_random_item() -> Item:
	var keys = item_data_by_index.keys()
	var item_data = item_data_by_index[keys[randi() % len(keys)]]
	var item = Item.new(item_data)
	return item
