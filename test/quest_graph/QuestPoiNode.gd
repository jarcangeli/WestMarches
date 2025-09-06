extends GraphNode
class_name QuestPOINode

@onready var name_edit: LineEdit = %NameEdit
@onready var status_panel: Panel = %StatusPanel
@onready var description_edit: TextEdit = %DescriptionEdit

const OK_COLOUR = Color.WEB_GREEN
const BAD_COLOUR = Color.DARK_RED

func _ready():
	name_edit.text_changed.connect(any_text_changed)
	description_edit.text_changed.connect(update_status)

func get_poi_data() -> POIData:
	var poi_data := POIData.new()
	poi_data.poi_name = name_edit.text
	poi_data.description = description_edit.text
	return poi_data

func set_poi_data(poi_data : POIData):
	if poi_data == null:
		push_warning("Trying to set poi data using null")
		return
	name_edit.text = poi_data.poi_name
	description_edit.text = poi_data.description
	
	update_status()

func any_text_changed(_text):
	update_status()

func update_status():
	var missing = name_edit.text.is_empty() or description_edit.text.is_empty()
	status_panel.modulate = BAD_COLOUR if missing else OK_COLOUR
