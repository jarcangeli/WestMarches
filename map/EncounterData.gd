extends Resource
class_name EncounterData

@export var encounter_name : String

@export var description : String
@export var victory_text : String = ""

#TODO: Should these be PackedStringArrays
@export var monster_names : Array[String] = []
@export var item_names : Array[String] = []

@export var repeatable := false
@export var dependency : String = ""

@export var on_start_message : String
@export var on_combat_start_message : String
@export var on_win_message : String
@export var on_lose_message : String

func valid() -> bool:
	if encounter_name.is_empty() or monster_names.is_empty():
		return false
	for monster_name in monster_names:
		if monster_name.is_empty():
			return false
	for item_name in item_names:
		if item_name.is_empty():
			return false
	return true
