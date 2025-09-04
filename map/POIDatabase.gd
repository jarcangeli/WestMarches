extends Node
class_name POIDatabaseClass

const pois_path := "res://map/pois/"

var pois_by_name := {}

func _ready():
	load_pois_from_configs(pois_path)

func load_pois_from_configs(path):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not load POI path: " + path)
		return
	
	dir.list_dir_begin()
	var config_file_name = "gogogo"
	while config_file_name != "":
		config_file_name = dir.get_next()
		if not config_file_name.ends_with(".cfg") or config_file_name.is_empty():
			continue
		var config = ConfigFile.new()
		# Load data from a file.
		var err = config.load(path + '/' + config_file_name)
		# If the file didn't load, ignore it.
		if err != OK:
			push_error("Could not load POI config: " + config_file_name)
			continue
			
		var sections = config.get_sections()
		var poi_data := POIData.new()
		poi_data.poi_name = config.get_value(sections[0], "name")
		poi_data.description = config.get_value(sections[0], "description")
		sections.remove_at(0)
		var encounters : Array[EncounterData] = []
		for section in sections:
			var encounter_data = get_encounter_data_from_cfg_section(config, section)
			encounters.append(encounter_data)
		poi_data.encounters = encounters
		if poi_data.poi_name != "Template":
			pois_by_name[poi_data.poi_name] = poi_data

static func get_encounter_data_from_cfg_section(config, section) -> EncounterData:
	var encounter_keys = config.get_section_keys(section)
	var encounter_data := EncounterData.new()
	encounter_data.encounter_name = config.get_value(section, "name")
	encounter_data.description = config.get_value(section, "description")
	if config.has_section_key(section, "repeatable"):
		encounter_data.repeatable = bool(config.get_value(section, "repeatable"))
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
