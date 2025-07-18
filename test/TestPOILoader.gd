extends Node

const pois_path := "res://map/pois/"

func _ready():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("res://map/pois/SwampHut.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		push_error("Could not load test POI config")
		return

	var sections = config.get_sections()
	
	var poi_data := POIData.new()
	poi_data.poi_name = config.get_value(sections[0], "name")
	poi_data.description = config.get_value(sections[0], "description")
	sections.remove_at(0)
	var encounters : Array[EncounterData] = []
	for section in sections:
		var encounter_keys = config.get_section_keys(section)
		var encounter_data := EncounterData.new()
		encounter_data.encounter_name = config.get_value(section, "name")
		encounter_data.description = config.get_value(section, "description")
		for key : String in encounter_keys:
			if key.begins_with("monster"):
				encounter_data.monster_names.append(config.get_value(section, key))
			if key.begins_with("item"):
				encounter_data.item_names.append(config.get_value(section, key))
		encounters.append(encounter_data)
	poi_data.encounters = encounters
