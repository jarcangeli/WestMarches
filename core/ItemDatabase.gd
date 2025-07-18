extends Database

const items_path = "res://core/databases/items"
const icons_path = "res://assets/icons/items/"

var icons_by_name = {}

var item_data_by_index = {}
var item_data_by_name = {}

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
	preload_icons(icons_path, icons_by_name)
	get_database_from_path(items_path)

func load_header(_header):
	pass

func load_line(csv):
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
	if item_data.valid():
		item_data_by_index[item_data.id] = item_data
		item_data_by_name[item_data.item_name] = item_data #TODO: Sanitize for mods, or remove
