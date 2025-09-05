extends GraphNode
class_name QuestEncounterNode

@onready var name_edit: LineEdit = %NameEdit
@onready var repeatable_check_box: CheckBox = %RepeatableCheckBox
@onready var description_edit: TextEdit = %DescriptionEdit
@onready var monsters_edit: LineEdit = %MonstersEdit
@onready var items_edit: LineEdit = %ItemsEdit
@onready var status_panel: Panel = %StatusPanel

const OK_COLOUR = Color.WEB_GREEN
const BAD_COLOUR = Color.DARK_RED

func get_encounter_data() -> EncounterData:
	var encounter_data := EncounterData.new()
	encounter_data.encounter_name = name_edit.text
	encounter_data.description = description_edit.text
	encounter_data.monster_names = Array(Array(monsters_edit.text.split(',')), TYPE_STRING, "", null)
	encounter_data.item_names = Array(Array(items_edit.text.split(',')), TYPE_STRING, "", null)
	encounter_data.repeatable = repeatable_check_box.button_pressed
	return encounter_data

func set_encounter_data(encounter_data : EncounterData):
	if encounter_data == null:
		push_warning("Trying to set encounter data using null")
		return
	name_edit.text = encounter_data.encounter_name
	description_edit.text = encounter_data.description
	monsters_edit.text = ','.join(encounter_data.monster_names)
	items_edit.text = ','.join(encounter_data.item_names)
	repeatable_check_box.set_pressed_no_signal(encounter_data.repeatable)
	
	update_status()

func update_status():
	var missing = name_edit.text.is_empty() or description_edit.text.is_empty() or monsters_edit.text.is_empty() or items_edit.text.is_empty()
	status_panel.modulate = BAD_COLOUR if missing else OK_COLOUR

#@export var on_start_message : String
#@export var on_combat_start_message : String
#@export var on_win_message : String
#@export var on_lose_message : String
