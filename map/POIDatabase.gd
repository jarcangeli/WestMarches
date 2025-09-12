extends Node
class_name POIDatabaseClass

const pois_file := "res://test/quest_graph/graph_data/quests.cfg"

var pois_by_name := {}
var all_encounters : Array[Encounter] = []
var available_encounters : Array[Encounter] = []
var encounters_by_name := {}

func _ready():
	load_pois_from_file(pois_file)
	for encounter in all_encounters:
		if encounter.dependency.is_empty():
			available_encounters.append(encounter)
	
	if TK.DEBUG:
		print("%d pois loaded with %d encounters. %d encounters immediately available." % [len(pois_by_name), len(all_encounters), len(available_encounters)])

func load_pois_from_file(config_file_name):
	if not config_file_name.ends_with(".cfg") or config_file_name.is_empty():
		return
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(config_file_name)
	# If the file didn't load, ignore it.
	if err != OK:
		push_error("Could not load POI config: " + config_file_name)
		return
	
	var sections = config.get_sections()
	var poi_data : POIData = null
	for section in sections:
		if section_is_poi(config, section):
			if poi_data:
				pois_by_name[poi_data.poi_name] = poi_data
			poi_data = get_poi_data_from_cfg_section(config, section)
		else:
			var encounter_data = get_encounter_data_from_cfg_section(config, section)
			encounter_data.poi_data = poi_data
			if not encounter_data.valid():
				continue
			var encounter = Encounter.new(encounter_data)
			add_child(encounter, true)
			all_encounters.append(encounter)
			encounters_by_name[encounter.encounter_name] = encounter
			if poi_data:
				poi_data.encounters.append(encounter)

func section_is_poi(config : ConfigFile, section : String) -> bool:
	var keys = config.get_section_keys(section)
	if "name" in keys and "description" in keys and keys.size() == 2:
		return true
	return false

static func get_poi_data_from_cfg_section(config, section) -> POIData:
	var poi_data := POIData.new()
	poi_data.poi_name = config.get_value(section, "name")
	poi_data.description = config.get_value(section, "description")
	return poi_data

static func get_encounter_data_from_cfg_section(config, section) -> EncounterData:
	var encounter_keys = config.get_section_keys(section)
	var encounter_data := EncounterData.new()
	encounter_data.encounter_name = config.get_value(section, "name")
	encounter_data.description = config.get_value(section, "description")
	encounter_data.victory_text = config.get_value(section, "victory_text", "")
	encounter_data.dependency = config.get_value(section, "dependency", "")
	encounter_data.repeatable = bool(config.get_value(section, "repeatable", false))
	for key : String in encounter_keys:
		if key.begins_with("monster"):
			encounter_data.monster_names.append(config.get_value(section, key))
		if key.begins_with("item"):
			encounter_data.item_names.append(config.get_value(section, key))
	encounter_data.on_start_message = config.get_value(section, "start_message", "")
	encounter_data.on_combat_start_message = \
		config.get_value(section, "combat_start_message", default_combat_start_message(encounter_data))
	encounter_data.on_win_message = config.get_value(section, "win_message", "The monsters were defeated!")
	encounter_data.on_lose_message = config.get_value(section, "lose_message", "The party was defeated...")
	return encounter_data

static func default_combat_start_message(data : EncounterData):
	if data.monster_names.is_empty():
		return "The party find no creatures to slay"
	elif len(data.monster_names) == 1:
		return "The party come across %s" % data.monster_names[0]
	else:
		return "The party come across %s" % ', '.join(data.monster_names)

func get_random_encounter() -> Encounter:
	var encounter = available_encounters[randi() % len(available_encounters)]
	return encounter

func update_available_encounters(completed_encounters):
	available_encounters.clear()
	for encounter in all_encounters:
		if encounter.encounter_name in completed_encounters and not encounter.repeatable:
			continue
		
		if encounter.dependency.is_empty() or encounter.dependency in completed_encounters:
			available_encounters.append(encounter)
