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
	monster_data.base_constitution = int(row["con"])
	monster_data.base_strength = int(row["str"])
	monster_data.base_dexterity = int(row["dex"])
	if monster_data.valid():
		monster_data_by_index[monster_data.id] = monster_data
		monster_data_by_name[monster_data.character_name] = monster_data #TODO: Sanitize for mods, or remove
