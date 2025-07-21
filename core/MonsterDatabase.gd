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
	monster_data.stats.set_value(AbilityStats.Type.ATTACK, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.AVOIDANCE, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.INTIATIVE, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.CRIT_RATE, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.REGENERATION, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.THORNS, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.AOE_ATTACK, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.POISON_CHANCE, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.POISON_DAMAGE, (row["constitution"]))
	monster_data.stats.set_value(AbilityStats.Type.SNIPE_ATTACK, (row["constitution"]))
	if monster_data.valid():
		monster_data_by_index[monster_data.id] = monster_data
		monster_data_by_name[monster_data.character_name] = monster_data #TODO: Sanitize for mods, or remove
