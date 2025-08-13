extends Database

const items_table_name = "items"
const icons_path = "res://assets/icons/items/"

var icons_by_name = {}
var indexes_by_rarity = {
	Globals.Rarity.COMMON: 		[],
	Globals.Rarity.UNCOMMON: 	[],
	Globals.Rarity.RARE: 		[],
	Globals.Rarity.EPIC: 		[]
}

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
	item_data.currency_generated =int(row["currency_generated"])
	item_data.stat_values.resize(AbilityStats.Type.SIZE)
	item_data.stat_values.fill(0)
	item_data.stat_values[AbilityStats.Type.CONSTITUTION] 	= int(row["constitution"])
	item_data.stat_values[AbilityStats.Type.ATTACK] 		= int(row["attack"])
	item_data.stat_values[AbilityStats.Type.DAMAGE_DIE] 	= int(row["damage_die"])
	item_data.stat_values[AbilityStats.Type.DAMAGE_BONUS] 	= int(row["damage_bonus"])
	item_data.stat_values[AbilityStats.Type.AVOIDANCE] 		= int(row["avoidance"])
	item_data.stat_values[AbilityStats.Type.INTIATIVE] 		= int(row["initiative"])
	item_data.stat_values[AbilityStats.Type.CRIT_RATE] 		= int(row["crit_rate"])
	item_data.stat_values[AbilityStats.Type.REGENERATION] 	= int(row["regeneration"])
	item_data.stat_values[AbilityStats.Type.THORNS] 		= int(row["thorns"])
	item_data.stat_values[AbilityStats.Type.AOE_DAMAGE] 	= int(row["aoe_attack"])
	item_data.stat_values[AbilityStats.Type.POISON_CHANCE] 	= int(row["poison_chance"])
	item_data.stat_values[AbilityStats.Type.POISON_DAMAGE] 	= int(row["poison_damage"])
	item_data.stat_values[AbilityStats.Type.SNIPE_DAMAGE] 	= int(row["snipe_damage"])
	item_data.value = get_weighted_value(item_data.stat_values)
	item_data.rarity = get_rarity_from_value(item_data.value)
	if item_data.valid():
		data_by_index[item_data.id] = item_data
		data_by_name[item_data.item_name] = item_data #TODO: Sanitize for mods, or remove
		if indexes_by_rarity.has(item_data.rarity):
			indexes_by_rarity[item_data.rarity].append(item_data.id)
		else:
			indexes_by_rarity.insert(item_data.rarity, [item_data.id])

func generate_random_item() -> Item:
	var rarity := Globals.Rarity.COMMON
	var roll = randf()
	if roll > 1.0 - TK.EPIC_CHANCE:
		rarity = Globals.Rarity.EPIC
	elif roll > (1.0 - TK.EPIC_CHANCE - TK.RARE_CHANCE):
		rarity = Globals.Rarity.RARE
	elif roll > (1.0 - TK.EPIC_CHANCE - TK.RARE_CHANCE - TK.UNCOMMON_CHANCE):
		rarity = Globals.Rarity.UNCOMMON
	
	var keys = indexes_by_rarity[rarity]
	var item_data = get_data_by_index(keys[randi() % len(keys)])
	var item = Item.new(item_data)
	return item

static func get_weighted_value(values : Array[int]):
	var sum := 0
	for i in range(len(values)):
		sum += values[i] *  AbilityStats.weights[i]
	return sum

static func get_rarity_from_value(value : int):
	if value > TK.EPIC_VALUE:
		return Globals.Rarity.EPIC
	elif value > TK.RARE_VALUE: 
		return Globals.Rarity.RARE
	elif value > TK.UNCOMMON_VALUE:
		return Globals.Rarity.UNCOMMON
	return Globals.Rarity.COMMON
