extends Database

const monsters_table_name = "monsters"

var monster_data_by_index = {}
var monster_data_by_name = {}

func _ready():
	load_table(monsters_table_name)

func load_row(row : Dictionary):
	var monster_data = CharacterData.new()
	monster_data.id = int(row["id"])
	monster_data.character_name = row["name"]
	monster_data.stats.set_value(AbilityStats.Type.CONSTITUTION, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.ATTACK, (row["attack"]))
	monster_data.stats.set_value(AbilityStats.Type.AVOIDANCE, (row["avoidance"]))
	monster_data.stats.set_value(AbilityStats.Type.INTIATIVE, (row["initiative"]))
	monster_data.stats.set_value(AbilityStats.Type.CRIT_RATE, (row["crit_rate"]))
	monster_data.stats.set_value(AbilityStats.Type.REGENERATION, (row["regeneration"]))
	monster_data.stats.set_value(AbilityStats.Type.THORNS, (row["thorns"]))
	monster_data.stats.set_value(AbilityStats.Type.AOE_ATTACK, (row["aoe_attack"]))
	monster_data.stats.set_value(AbilityStats.Type.POISON_CHANCE, (row["poison_chance"]))
	monster_data.stats.set_value(AbilityStats.Type.POISON_DAMAGE, (row["poison_damage"]))
	monster_data.stats.set_value(AbilityStats.Type.SNIPE_DAMAGE, (row["snipe_damage"]))
	if monster_data.valid():
		monster_data_by_index[monster_data.id] = monster_data
		monster_data_by_name[monster_data.character_name] = monster_data #TODO: Sanitize for mods, or remove
