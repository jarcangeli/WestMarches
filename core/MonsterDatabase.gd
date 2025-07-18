extends Database

const monsters_path = "res://core/databases/monsters"

var monster_data_by_index = {}
var monster_data_by_name = {}

enum MONSTER_TABLE_HEADER
{
	ID,
	NAME,
	CONSTITUTION,
	STRENGTH,
	DEXTERITY
}

func _ready():
	get_database_from_path(monsters_path)

func load_header(_header):
	pass

func load_line(csv):
	var monster_data = CharacterData.new()
	monster_data.id = int(csv[MONSTER_TABLE_HEADER.ID])
	monster_data.character_name = csv[MONSTER_TABLE_HEADER.NAME]
	monster_data.constitution_bonus = int(csv[MONSTER_TABLE_HEADER.CONSTITUTION])
	monster_data.strength_bonus = int(csv[MONSTER_TABLE_HEADER.STRENGTH])
	monster_data.dexterity_bonus = int(csv[MONSTER_TABLE_HEADER.DEXTERITY])
	if monster_data.valid():
		monster_data_by_index[monster_data.id] = monster_data
		monster_data_by_name[monster_data.item_name] = monster_data #TODO: Sanitize for mods, or remove
