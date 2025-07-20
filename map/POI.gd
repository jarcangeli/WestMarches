extends Node2D
class_name POI
# Point Of Interest

var poi_name : String
var description : String

func _ready():
	update_display.call_deferred()

func load_data(data : POIData):
	if not data:
		return
	poi_name = data.poi_name
	description = data.description
	name = poi_name
	for encounter_data : EncounterData in data.encounters:
		var encounter := Encounter.new(encounter_data)
		add_child.call_deferred(encounter)

func update_display():
	var label = $Display/Label
	if label:
		label.text = name
	else:
		push_warning("No label for POI")
